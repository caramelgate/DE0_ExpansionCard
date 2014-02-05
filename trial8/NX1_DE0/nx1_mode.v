//------------------------------------------------------------------------------
//
//	nx1_mode.v : ese x1 mode control and memory interface module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/dec/28 release 0.0  modifyed and downgrade for de1(altera cyclone2)
//  2014/jan/10 release 0.1  preview
//      /jan/24 release 0.2  integrate memory control(zbank.v)
//
//------------------------------------------------------------------------------

module nx1_mode #(
//	parameter	def_MMU180=16'h0038,	// 180 mmu reg
	parameter	def_work_sram=1,
	parameter	def_MBASE=32'h00000000,	// main memory base address
	parameter	def_BBASE=32'h00100000,	// bank memory base address
	parameter	def_VBASE=32'h00180000,	// video base address
	parameter	def_EBASE=32'h00200000,	// EMM base address
	parameter	def_RBASE=32'h00300000	// ROM base address
) (
	output			mem_cmd_en,			// out   [MEM] cmd en
	output	[2:0]	mem_cmd_instr,		// out   [MEM] cmd inst[2:0]
	output	[5:0]	mem_cmd_bl,			// out   [MEM] cmd blen[5:0]
	output	[29:0]	mem_cmd_byte_addr,	// out   [MEM] cmd addr[29:0]
	input			mem_cmd_empty,		// in    [MEM] cmd empt
	input			mem_cmd_full,		// in    [MEM] cmd full
	output			mem_wr_en,			// out   [MEM] wr en
	output	[3:0]	mem_wr_mask,		// out   [MEM] wr mask[3:0]
	output	[31:0]	mem_wr_data,		// out   [MEM] wr wdata[31:0]
	input			mem_wr_full,		// in    [MEM] wr full
	input			mem_wr_empty,		// in    [MEM] wr empt
	input	[6:0]	mem_wr_count,		// in    [MEM] wr count[6:0]
	input			mem_wr_underrun,	// in    [MEM] wr over
	input			mem_wr_error,		// in    [MEM] wr err
	output			mem_rd_en,			// out   [MEM] rd en
	input	[31:0]	mem_rd_data,		// in    [MEM] rd rdata[31:0]
	input			mem_rd_full,		// in    [MEM] rd full
	input			mem_rd_empty,		// in    [MEM] rd empt
	input	[6:0]	mem_rd_count,		// in    [MEM] rd count[6:0]
	input			mem_rd_overflow,	// in    [MEM] rd over
	input			mem_rd_error,		// in    [MEM] rd err

	input			mem_init_done,		// in    [MEM] init_done

	output	[15:0]	ipl_addr,			// out   [CPU] ipl rom address
	input	[7:0]	ipl_rdata,			// in    [CPU] ipl read data
	output	[7:0]	ipl_wdata,			// out   [CPU] dbg : ipl write data
	output			ipl_wr,				// out   [CPU] dbg : ipl write
	output			ipl_req,			// out   [CPU] ipl req
	input			ipl_ack,			// in    [CPU] ipl ack

	input			fz_clk,				// in    [CPU] clk (32MHz)
	input			fz_rst_n,			// in    [CPU] #reset

	output			fz_int_req,			// out   [CPU] interrupt req
	output			fz_nmi_req,			// out   [CPU] nmi req
	input			fz_int_ack,			// in    [CPU] interrupt ack
	input			fz_nmi_ack,			// in    [CPU] nmi ack
	output			fz_reset_req,		// out   [CPU] reset req
	output			fz_wait,			// out   [CPU] wait
	input			fz_start,			// in    [CPU] start
	input	[15:0]	fz_addr,			// in    [CPU] address
	input	[7:0]	fz_wdata,			// in    [CPU] write data
	output	[7:0]	fz_rdata,			// out   [CPU] read data
	input			fz_m1,				// in    [CPU] m1
	input			fz_rd,				// in    [CPU] rd
	input			fz_wr,				// in    [CPU] wr
	input			fz_mreq,			// in    [CPU] mem select
	input			fz_ioreq,			// in    [CPU] io select

	input	[5:0]	cz_bank,			// in    [CPU] CPU BANK REG
	output			cz_ipl,				// out   [CPU] ipl / ram select
	output			cz_multiplane,		// out   [CPU] vram multiplane write

	input			z_int_n,			// in    [Z80] #interrupt
	input			z_nmi_n,			// in    [Z80] #nmi
	output			z_clk,				// out   [Z80] clk (4MHz) z80 bus clock
	output			z_cke,				// out   [Z80] cke (z_clk) z80 bus cycle active
	output			z_clk2,				// out   [Z80] clk (2MHz psg)
	output			z_cke2,				// out   [Z80] cke (z_clk rise)
	output			z_ckp,				// out   [Z80] ckp (fz_clk rise)
	output			z_ckn,				// out   [Z80] ckn (fz_clk fall)
	output	[15:0]	z_addr,				// out   [Z80] addr
	output	[7:0]	z_wdata,			// out   [Z80] write data out
	input	[7:0]	z_rdata,			// in    [Z80] read data in
	input			z_wait_n,			// in    [Z80] #wait
	output			z_iorq_n,			// out   [Z80] #iorq
	output			z_rd_n,				// out   [Z80] #rd
	output			z_wr_n,				// out   [Z80] #wr
	output			z_m1_n,				// out   [Z80] #m1
	output			z_vect,				// out   [Z80] interrupt vect read
	output			z_reti				// out   [Z80] inst reti
);

/*

//	0038 : CBR common base address
//	0039 : BBR bank base address
//	003a : CBA common/bank area
//
//	c_act=(za[15:12]>=CBA[7:4]) ? 1'b1 : 1'b0;
//	b_act=(za[15:12]>=CBA[3:0]) ? 1'b1 : 1'b0;
//
//	mmua[19:12]=
//		(mreq==1'b1) & (c_act==1'b1) ? {4'b0,za[15:12]}+CBA[7:0] :
//		(mreq==1'b1) & (c_act==1'b0) & (b_act==1'b1) ? {4'b0,za[15:12]}+BBA[7:0] :
//		{4'b0,za[15:12]};
//	mmua[11:0]=za[11:0];

	reg		[7:0] mmu180_cbr_r;
	reg		[7:0] mmu180_bbr_r;
	reg		[7:0] mmu180_cba_r;
	wire	[7:0] mmu180_cbr_w;
	wire	[7:0] mmu180_bbr_w;
	wire	[7:0] mmu180_cba_w;

	wire	[19:0] mmu180_addr;
	wire	mmu180_cbr_hit;
	wire	mmu180_bbr_hit;

	assign mmu180_cbr_hit=(z_addr[15:12]>mmu180_cba_r[7:4]) | (z_addr[15:12]=mmu180_cba_r[7:4]) ? 1'b1 : 1'b0;
	assign mmu180_bbr_hit=(z_addr[15:12]>mmu180_cba_r[3:0]) | (z_addr[15:12]=mmu180_cba_r[3:0]) ? 1'b1 : 1'b0;

	assign mmu180_addr[19:12]=
			(mmu180_cbr_hit==1'b1) ? {4'b0,z_addr[15:12]}+mmu180_cbr_r[7:0] :
			(mmu180_cbr_hit==1'b0) & (mmu180_cbr_hit==1'b1) ? {4'b0,z_addr[15:12]}+mmu180_bbr_r[7:0] :
			(mmu180_cbr_hit==1'b0) & (mmu180_cbr_hit==1'b0) ? {4'b0,z_addr[15:12]} :
			{4'b0,z_addr[15:12]};

	alwaus @(posedge fz_clk or negedge fz_rst_n)
	begin
		if (fz_rst_n==1'b0)
			begin
				mmu180_cbr_r[7:0] <= 8'b0;
				mmu180_bbr_r[7:0] <= 8'b0;
				mmu180_cba_r[7:0] <= 8'b0;
			end
		else
			begin
				mmu180_cbr_r[7:0] <= mmu180_cbr_w[7:0];
				mmu180_bbr_r[7:0] <= mmu180_bbr_w[7:0];
				mmu180_cba_r[7:0] <= mmu180_cba_w[7:0];
			end
	end

	assign mmu180_cbr_w[7:0]=({cz_multiplane,z_ckp,z_cke,z_iorq_n,z_wr_n}==5'b01100) & (z_addr[15:0]=={def_MMU[15:2],2'b00) ? z_wdata[7:0] : mmu180_cbr_r[7:0];
	assign mmu180_bbr_w[7:0]=({cz_multiplane,z_ckp,z_cke,z_iorq_n,z_wr_n}==5'b01100) & (z_addr[15:0]=={def_MMU[15:2],2'b01) ? z_wdata[7:0] : mmu180_bbr_r[7:0];
	assign mmu180_cba_w[7:0]=({cz_multiplane,z_ckp,z_cke,z_iorq_n,z_wr_n}==5'b01100) & (z_addr[15:0]=={def_MMU[15:2],2'b10) ? z_wdata[7:0] : mmu180_cba_r[7:0];

        memory 00.0000h-0f.ffffh

         a[1:0]=0   a[1:0]=1   a[1:0]=2   a[1:0]=3
         D[7:0]     D[15:8]    D[23:16]   D[31:24]
00.0000 +----------+----------+----------+----------+
        | MAIN RAM 00000H                           | 00b00=5'h1x
00.8000 +----------+----------+----------+----------+
        | MAIN RAM 08000H                           |
01.0000 +----------+----------+----------+----------+
        | MAIN RAM 10000H                           |
02.0000 +----------+----------+----------+----------+
        | MAIN RAM 20000H                           |
03.0000 +----------+----------+----------+----------+
        |                                           |
        | MAIN RAM                                  |
        |                                           |
0e.0000 +----------+----------+----------+----------+
        | MAIN RAM e0000H                           |
0f.0000 +----------+----------+----------+----------+
        | MAIN RAM f0000H                           |
10.0000 +----------+----------+----------+----------+

        memory 10.0000-1f.ffff : z80 bank memory / vram

         a[1:0]=0   a[1:0]=1   a[1:0]=2   a[1:0]=3
         D[7:0]     D[15:8]    D[23:16]   D[31:24]
10.0000 +----------+----------+----------+----------+
        | BANK RAM SEL0                             | 0b00=5'h00
10.8000 +----------+----------+----------+----------+
        | BANK RAM SEL1                             | 0b00=5'h01
11.0000 +----------+----------+----------+----------+
        | BANK RAM SEL2                             |
11.8000 +----------+----------+----------+----------+
        | BANK RAM SEL3                             |
12.0000 +----------+----------+----------+----------+
        |                                           |
        | BANK RAM                                  |
        |                                           |
17.0000 +----------+----------+----------+----------+
        | BANK RAM SEL14                            | 0b00=5'h0e
17.8000 +----------+----------+----------+----------+
        | BANK RAM SEL15                            | 0b00=5'h0f
18.0000 +----------+----------+----------+----------+
        | VRAM ABRG 0                               |
19.0000 +----------+----------+----------+----------+
        | VRAM ABRG 1                               |
1a.0000 +----------+----------+----------+----------+
        |                                           |
        | FREE                                      |
        |                                           |
20.0000 +----------+----------+----------+----------+

        memory 20.0000-2f.ffff : emm-0 / emm-1

20.0000 +----------+----------+----------+----------+
        | EMM 0 512K (8EM-0)                        | 0d00
28.0000 +----------+----------+----------+----------+
        | EMM 1 512K (8EM-1)                        | 0d04
30.0000 +----------+----------+----------+----------+

        memory 30.0000-3f.ffff : rom

30.0000 +----------+----------+----------+----------+
        | ROM 512K (8BR)                            | 0e00
38.0000 +----------+----------+----------+----------+
        | ROM 512K (8KR)                            | 0e80
40.0000 +----------+----------+----------+----------+

        Z80 memory image

         a[1:0]=0   a[1:0]=1   a[1:0]=2   a[1:0]=3
         D[7:0]     D[15:8]    D[23:16]   D[31:24]
00.0000 +----------+----------+----------+----------+
        | MAIN RAM SEL / BANK RAM SEL               |
00.8000 +----------+----------+----------+----------+
        | MAIN RAM SEL                              |
01.0000 +----------+----------+----------+----------+

        Z80 vram image

         a[15:14]=0 a[15:14]=1 a[15:14]=2 a[15:14]=3
         D[7:0]     D[7:0]     D[7:0]     D[7:0]
18.0000 +----------+----------+----------+----------+
        | A0       | B0       | R0       | G0       |
19.0000 +----------+----------+----------+----------+
        | A1       | B1       | R1       | G1       |
1a.0000 +----------+----------+----------+----------+

*/

	// ---- ----

//	wire	cz_ipl;
//	wire	cz_multiplane;

	reg		[4:0] fz_reset_req_r;
	reg		fz_intreq_r;
	reg		[7:0] fz_nmireq_r;

	wire	[4:0] fz_reset_req_w;
	wire	fz_intreq_w;
	wire	[7:0] fz_nmireq_w;

	assign fz_reset_req=fz_reset_req_r[4];

	assign fz_int_req=fz_intreq_r;
	assign fz_nmi_req=fz_nmireq_r[7];

	always @(posedge fz_clk or negedge fz_rst_n)
	begin
		if (fz_rst_n==1'b0)
			begin
				fz_reset_req_r[4:0] <= 5'b11000;
				fz_intreq_r <= 1'b0;
				fz_nmireq_r[7:0] <= 8'b0;
			end
		else
			begin
				fz_reset_req_r[4:0] <= fz_reset_req_w[4:0];
				fz_intreq_r <= fz_intreq_w;
				fz_nmireq_r[7:0] <= fz_nmireq_w[7:0];
			end
	end

	assign fz_reset_req_w[4]=fz_reset_req_r[3];

	assign fz_reset_req_w[3]=
			(fz_reset_req_r[3]==1'b0) ? 1'b0 :
			(fz_reset_req_r[3]==1'b1) & (fz_reset_req_r[2:0]==3'b111) ? 1'b0 :
			(fz_reset_req_r[3]==1'b1) & (fz_reset_req_r[2:0]!=3'b111) ? 1'b1 :
			1'b1;

	assign fz_reset_req_w[2:0]=
			(fz_reset_req_r[3]==1'b0) ? 3'b000 :
			(fz_reset_req_r[3]==1'b1) ? fz_reset_req_r[2:0]+3'b01 :
			3'b0;

	assign fz_intreq_w=!z_int_n;
	assign fz_nmireq_w[7]=
			(fz_nmi_ack==1'b1) ? 1'b0 :
			(fz_nmi_ack==1'b0) & (fz_nmireq_r[7]==1'b1) ? 1'b1 :
			(fz_nmi_ack==1'b0) & (fz_nmireq_r[7]==1'b0) & (fz_nmireq_r[6:0]==7'h3f) ? 1'b1 :
			(fz_nmi_ack==1'b0) & (fz_nmireq_r[7]==1'b0) & (fz_nmireq_r[6:0]!=7'h3f) ? fz_nmireq_r[7] :
			1'b0;

	assign fz_nmireq_w[6:0]=
			(fz_nmireq_r[6]==1'b0) & (z_nmi_n==1'b1) ? 7'b0 :
			(fz_nmireq_r[6]==1'b0) & (z_nmi_n==1'b0) ? fz_nmireq_r[6:0]+7'b01 :
			(fz_nmireq_r[6]==1'b1) & (z_nmi_n==1'b0) ? 7'b0 :
			(fz_nmireq_r[6]==1'b1) & (z_nmi_n==1'b1) ? fz_nmireq_r[6:0]+7'b01 :
			7'b0;



	localparam	fzst00=4'b0000;	// main
	localparam	fzst01=4'b0001;
	localparam	fzst02=4'b0011;
	localparam	fzst03=4'b0010;

	localparam	fzst04=4'b0100;	// ipl
	localparam	fzst05=4'b0101;

	localparam	fzst06=4'b0111;	// i/o
	localparam	fzst07=4'b0110;

	localparam	fzst10=4'b1000;	// irq ack
	localparam	fzst11=4'b1001;
	localparam	fzst12=4'b1011;
	localparam	fzst13=4'b1010;
	localparam	fzst14=4'b1100;
	localparam	fzst15=4'b1101;
	localparam	fzst16=4'b1111;
	localparam	fzst17=4'b1110;

	reg		[3:0] fz_state_r;
	reg		fz_mem_req_r;
	reg		fz_io_req_r;
	reg		fz_wait_r;
	reg		[15:0] fz_addr_r;
	reg		[7:0] fz_wdata_r;
	reg		[7:0] fz_rdata_r;
	reg		fz_mreq_r;
	reg		fz_iorq_r;
	reg		fz_rd_r;
	reg		fz_wr_r;
	reg		fz_m1_r;
	reg		[9:0] fz_inst_data0_r;
	reg		[9:0] fz_inst_data1_r;
	reg		inst_reti_r;
	reg		ipl_req_r;

	wire	[3:0] fz_state_w;
	wire	fz_mem_req_w;
	wire	fz_io_req_w;
	wire	fz_wait_w;
	wire	[15:0] fz_addr_w;
	wire	[7:0] fz_wdata_w;
	wire	[7:0] fz_rdata_w;
	wire	fz_mreq_w;
	wire	fz_iorq_w;
	wire	fz_rd_w;
	wire	fz_wr_w;
	wire	fz_m1_w;
	wire	[9:0] fz_inst_data0_w;
	wire	[9:0] fz_inst_data1_w;
	wire	inst_reti_w;
	wire	ipl_req_w;

	wire	inst_reti;

	wire	mem_rd_addr_hit;
	wire	mem_req;
	wire	mem_ack;
	wire	[7:0] mem_rdata;

	wire	io_req;
	wire	io_ack;
	wire	[7:0] io_rdata;

	assign mem_req=fz_mem_req_r;

	assign io_req=fz_io_req_r;

	assign ipl_addr[15:0]=fz_addr_r[15:0];
	assign ipl_wdata[7:0]=fz_wdata_r[7:0];
	assign ipl_wr=fz_wr_r;

	assign ipl_req=ipl_req_r;

	assign fz_rdata[7:0]=fz_rdata_r[7:0];
	assign fz_wait=fz_wait_r;

	assign inst_reti=(fz_inst_data0_r[9:0]==10'h3ed) & ({fz_m1_r,fz_mreq_r,fz_rdata_w[7:0]}==10'h34d) ? 1'b1 : 1'b0;

	always @(posedge fz_clk or negedge fz_rst_n)
	begin
		if (fz_rst_n==1'b0)
			begin
				fz_state_r <= fzst00;
				fz_mem_req_r <= 1'b0;
				fz_io_req_r <= 1'b0;
				fz_wait_r <= 1'b1;
				fz_addr_r[15:0] <= 16'b0;
				fz_wdata_r[7:0] <= 8'b0;
				fz_rdata_r[7:0] <= 8'b0;
				fz_mreq_r <= 1'b0;
				fz_iorq_r <= 1'b0;
				fz_rd_r <= 1'b0;
				fz_wr_r <= 1'b0;
				fz_m1_r <= 1'b0;

				fz_inst_data0_r[9:0] <= 10'b0;
				fz_inst_data1_r[9:0] <= 10'b0;
				inst_reti_r <= 1'b0;
				ipl_req_r <= 1'b0;
			end
		else
			begin
				fz_state_r <= fz_state_w;
				fz_mem_req_r <= fz_mem_req_w;
				fz_io_req_r <= fz_io_req_w;
				fz_wait_r <= fz_wait_w;
				fz_addr_r[15:0] <= fz_addr_w[15:0];
				fz_wdata_r[7:0] <= fz_wdata_w[7:0];
				fz_rdata_r[7:0] <= fz_rdata_w[7:0];
				fz_mreq_r <= fz_mreq_w;
				fz_iorq_r <= fz_iorq_w;
				fz_rd_r <= fz_rd_w;
				fz_wr_r <= fz_wr_w;
				fz_m1_r <= fz_m1_w;

				fz_inst_data0_r[9:0] <= fz_inst_data0_w[9:0];
				fz_inst_data1_r[9:0] <= fz_inst_data1_w[9:0];
				inst_reti_r <= inst_reti_w;
				ipl_req_r <= ipl_req_w;
			end
	end

	assign fz_state_w=
			(fz_reset_req_r[3]==1'b1) ? fzst00 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst00) ? fzst01 :

			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b0) ? fzst01 :	// idle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b0) & (def_work_sram==0) ? fzst02 :	// fast cycle : mem write
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b0) & (def_work_sram==1) & (fz_addr[15:14]!=2'b11) ? fzst02 :	// fast cycle : mem write
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b0) & (def_work_sram==1) & (fz_addr[15:14]==2'b11) ? fzst04 :	// ipl
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b0) ? fzst02 :	// fast cycle : mem read
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b1) & (def_work_sram==0) & (fz_addr[15]==1'b0) ? fzst04 :	// ipl
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b1) & (def_work_sram==0) & (fz_addr[15]==1'b1) ? fzst02 :	// fast cycle : mem read
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b1) & (def_work_sram==1) & (fz_addr[15]==1'b0) ? fzst04 :	// ipl
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b1) & (def_work_sram==1) & (fz_addr[15:14]==2'b10) ? fzst02 :	// fast cycle : mem read
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b1) & (def_work_sram==1) & (fz_addr[15:14]==2'b11) ? fzst04 :	// ipl
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b1) ? fzst06 :	// io cycle : irq ack
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b00) & (cz_multiplane==1'b1) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b00) & (cz_multiplane==1'b0) ? fzst06 :	// io cycle : i/o
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b01) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b10) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b11) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b00) ? fzst06 :	// z cycle : i/o
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b01) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b10) ? fzst02 :	// fast cycle
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b11) ? fzst02 :	// fast cycle

			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) & (inst_reti==1'b0) ? fzst01 :	// buff hit
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) & (inst_reti==1'b1) ? fzst10 :	// buff hit
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b0) ? fzst03 :	// 
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst02) & (fz_rd_r==1'b0) & (mem_ack==1'b1) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst02) & (fz_rd_r==1'b0) & (mem_ack==1'b0) ? fzst03 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst03) & (fz_rd_r==1'b1) & (mem_ack==1'b1) & (inst_reti==1'b0) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst03) & (fz_rd_r==1'b1) & (mem_ack==1'b1) & (inst_reti==1'b1) ? fzst10 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst03) & (fz_rd_r==1'b0) & (mem_ack==1'b1) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst03) & (mem_ack==1'b0) ? fzst03 :

			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst04) ? fzst05 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (fz_rd_r==1'b1) & (ipl_ack==1'b1) & (inst_reti==1'b0) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (fz_rd_r==1'b1) & (ipl_ack==1'b1) & (inst_reti==1'b1) ? fzst10 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (fz_rd_r==1'b0) & (ipl_ack==1'b1) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (ipl_ack==1'b0) ? fzst05 :

			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst06) ? fzst07 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst07) & (io_ack==1'b1) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst07) & (io_ack==1'b0) ? fzst07 :

			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst10) ? fzst11 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst11) & (io_ack==1'b1) ? fzst01 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst11) & (io_ack==1'b0) ? fzst11 :

			fzst00;

	assign fz_mem_req_w=
			(fz_state_r==fzst00) ? 1'b0 :
			(fz_state_r==fzst01) & (fz_start==1'b0) ? 1'b0 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b0) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b1) & (fz_rd==1'b1) & (cz_ipl==1'b0) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b00) & (cz_multiplane==1'b1) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b01) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b10) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b0) & (fz_addr[15:14]==2'b11) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b01) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b10) ? 1'b1 :
			(fz_state_r==fzst01) & (fz_start==1'b1) & (fz_mreq==1'b0) & (fz_m1==1'b0) & (fz_rd==1'b1) & (fz_addr[15:14]==2'b11) ? 1'b1 :
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) ? 1'b0 :
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b0) ? 1'b1 :
			(fz_state_r==fzst02) & (fz_rd_r==1'b0) & (mem_ack==1'b1) ? 1'b0 :
			(fz_state_r==fzst02) & (fz_rd_r==1'b0) & (mem_ack==1'b0) ? 1'b1 :
			(fz_state_r==fzst03) & (mem_ack==1'b1) ? 1'b0 :
			(fz_state_r==fzst03) & (mem_ack==1'b0) ? 1'b1 :
			1'b0;

	assign fz_io_req_w=
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) & (inst_reti==1'b1) ? 1'b1 :
			(fz_state_r==fzst03) & (fz_rd_r==1'b1) & (mem_ack==1'b1) & (inst_reti==1'b1) ? 1'b1 :
			(fz_state_r==fzst05) & (fz_rd_r==1'b1) & (ipl_ack==1'b1) & (inst_reti==1'b1) ? 1'b1 :

			(fz_state_r==fzst06) ? 1'b1 :
			(fz_state_r==fzst07) & (io_ack==1'b1) ? 1'b0 :
			(fz_state_r==fzst07) & (io_ack==1'b0) ? 1'b1 :
			(fz_state_r==fzst10) ? 1'b1 :
			(fz_state_r==fzst11) & (io_ack==1'b1) ? 1'b0 :
			(fz_state_r==fzst11) & (io_ack==1'b0) ? 1'b1 :
			1'b0;

	assign fz_wait_w=
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) & (inst_reti==1'b0) ? 1'b0 :
			(fz_state_r==fzst03) & (mem_ack==1'b1) & (inst_reti==1'b0) ? 1'b0 :
			(fz_state_r==fzst05) & (ipl_ack==1'b1) & (inst_reti==1'b0) ? 1'b0 :
			(fz_state_r==fzst07) & (io_ack==1'b1) ? 1'b0 :
			(fz_state_r==fzst11) & (io_ack==1'b1) ? 1'b0 :
			1'b1;

	assign fz_addr_w[15:0]=(fz_start==1'b1) ? fz_addr[15:0] : fz_addr_r[15:0];
	assign fz_wdata_w[7:0]=(fz_start==1'b1) ? fz_wdata[7:0] : fz_wdata_r[7:0];

	assign fz_rdata_w[7:0]=
			(fz_state_r==fzst00) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst01) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst02) & (fz_rd_r==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) ? mem_rdata[7:0] :
			(fz_state_r==fzst02) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst03) & (fz_rd_r==1'b1) & (mem_ack==1'b1) ? mem_rdata[7:0] :
			(fz_state_r==fzst03) & (fz_rd_r==1'b1) & (mem_ack==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst03) & (fz_rd_r==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst04) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst05) & (fz_rd_r==1'b1) & (ipl_ack==1'b1) ? ipl_rdata[7:0] :
			(fz_state_r==fzst05) & (fz_rd_r==1'b1) & (ipl_ack==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst05) & (fz_rd_r==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst06) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst07) & (fz_rd_r==1'b1) & (ipl_ack==1'b1) ? io_rdata[7:0] :
			(fz_state_r==fzst07) & (fz_rd_r==1'b1) & (ipl_ack==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst07) & (fz_rd_r==1'b0) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst10) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst11) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst12) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst13) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst14) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst15) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst16) ? fz_rdata_r[7:0] :
			(fz_state_r==fzst17) ? fz_rdata_r[7:0] :
			8'b0;

	assign fz_mreq_w=(fz_start==1'b1) ? fz_mreq : fz_mreq_r;
	assign fz_iorq_w=(fz_start==1'b1) ? fz_ioreq : fz_iorq_r;
	assign fz_rd_w=(fz_start==1'b1) ? fz_rd : fz_rd_r;
	assign fz_wr_w=(fz_start==1'b1) ? fz_wr : fz_wr_r;
	assign fz_m1_w=(fz_start==1'b1) ? fz_m1 : fz_m1_r;

	assign fz_inst_data0_w[9:0]=(fz_wait_r==1'b0) ? {fz_m1_r,fz_mreq_r,fz_rdata_r[7:0]} : fz_inst_data0_r[9:0];
	assign fz_inst_data1_w[9:0]=(fz_wait_r==1'b0) ? fz_inst_data0_r[9:0] : fz_inst_data1_r[9:0];

	assign inst_reti_w=
			(inst_reti==1'b1) ? 1'b1 :
			(inst_reti==1'b0) & (io_ack==1'b1) ? 1'b0 :
			(inst_reti==1'b0) & (io_ack==1'b0) ? inst_reti_r :
			1'b0;

	assign ipl_req_w=
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst04) ? 1'b1 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (ipl_ack==1'b1) ? 1'b0 :
			(fz_reset_req_r[3]==1'b0) & (fz_state_r==fzst05) & (ipl_ack==1'b0) ? 1'b1 :
			1'b0;

	// ---- ----

	reg		[3:0] io_clk_div_r;
	reg		[1:0] io_ckp_r;
	reg		[1:0] io_ckn_r;
	reg		io_cke2_r;
	reg		[3:0] io_state_r;
	reg		io_ack_r;
	reg		io_cke_r;
	reg		[15:0] io_addr_r;
	reg		[7:0] io_wdata_r;
	reg		[7:0] io_rdata_r;
	reg		[1:0] io_wait_n_r;
	reg		io_req_n_r;
	reg		io_rd_n_r;
	reg		io_wr_n_r;
	reg		io_m1_n_r;
	reg		io_vect_r;
	reg		io_reti_r;

	wire	[3:0] io_clk_div_w;
	wire	[1:0] io_ckp_w;
	wire	[1:0] io_ckn_w;
	wire	io_cke2_w;
	wire	[3:0] io_state_w;
	wire	io_ack_w;
	wire	io_cke_w;
	wire	[15:0] io_addr_w;
	wire	[7:0] io_wdata_w;
	wire	[7:0] io_rdata_w;
	wire	[1:0] io_wait_n_w;
	wire	io_req_n_w;
	wire	io_rd_n_w;
	wire	io_wr_n_w;
	wire	io_m1_n_w;
	wire	io_vect_w;
	wire	io_reti_w;


	reg		[7:0] io_1a02_r;
	reg		[7:0] io_1a02_d_r;
	reg		cz_ipl_r;
	reg		cz_multiplane_r;

	wire	[7:0] io_1a02_w;
	wire	[7:0] io_1a02_d_w;
	wire	cz_ipl_w;
	wire	cz_multiplane_w;


	localparam	iost00=4'b0000;
	localparam	iost01=4'b0001;
	localparam	iost02=4'b0011;
	localparam	iost03=4'b0010;
	localparam	iost04=4'b0100;
	localparam	iost05=4'b0101;
	localparam	iost06=4'b0111;
	localparam	iost07=4'b0110;
	localparam	iost10=4'b1000;
	localparam	iost11=4'b1001;
	localparam	iost12=4'b1011;
	localparam	iost13=4'b1010;
	localparam	iost14=4'b1100;
	localparam	iost15=4'b1101;
	localparam	iost16=4'b1111;
	localparam	iost17=4'b1110;

	assign z_clk=io_clk_div_r[2];
	assign z_clk2=io_clk_div_r[3];
	assign z_cke2=io_cke2_r;
	assign z_ckp=io_ckp_r[0];
	assign z_ckn=io_ckn_r[0];
	assign z_cke=io_cke_r;
	assign z_addr[15:0]=io_addr_r[15:0];
	assign z_wdata[7:0]=io_wdata_r[7:0];
	assign z_iorq_n=io_req_n_r;
	assign z_rd_n=io_rd_n_r;
	assign z_wr_n=io_wr_n_r;
	assign z_m1_n=io_m1_n_r;
	assign z_vect=io_vect_r;
	assign z_reti=io_reti_r;

	assign io_ack=io_ack_r;
	assign io_rdata[7:0]=io_rdata_r[7:0];

	assign cz_ipl=cz_ipl_r;
	assign cz_multiplane=cz_multiplane_r;

	always @(posedge fz_clk or negedge fz_rst_n)
	begin
		if (fz_rst_n==1'b0)
			begin
				io_clk_div_r[3:0] <= 4'b0;
				io_cke2_r <= 1'b0;
				io_ckp_r[1:0] <= 2'b0;
				io_ckn_r[1:0] <= 2'b0;
				io_state_r <= iost00;
				io_ack_r <= 1'b0;
				io_cke_r <= 1'b0;
				io_addr_r[15:0] <= 16'b0;
				io_wdata_r[7:0] <= 8'b0;
				io_rdata_r[7:0] <= 8'b0;
				io_wait_n_r[1:0] <= 2'b0;
				io_req_n_r <= 1'b1;
				io_rd_n_r <= 1'b1;
				io_wr_n_r <= 1'b1;
				io_m1_n_r <= 1'b1;
				io_vect_r <= 1'b0;
				io_reti_r <= 1'b0;

				io_1a02_r[7:0] <= 8'hff;
				io_1a02_d_r[7:0] <= 8'hff;
				cz_ipl_r <= 1'b1;
				cz_multiplane_r <= 1'b0;
			end
		else
			begin
				io_clk_div_r[3:0] <= io_clk_div_w[3:0];
				io_cke2_r <= io_cke2_w;
				io_ckp_r[1:0] <= io_ckp_w[1:0];
				io_ckn_r[1:0] <= io_ckn_w[1:0];
				io_state_r <= io_state_w;
				io_ack_r <= io_ack_w;
				io_cke_r <= io_cke_w;
				io_addr_r[15:0] <= io_addr_w[15:0];
				io_wdata_r[7:0] <= io_wdata_w[7:0];
				io_rdata_r[7:0] <= io_rdata_w[7:0];
				io_wait_n_r[1:0] <= io_wait_n_w[1:0];
				io_req_n_r <= io_req_n_w;
				io_rd_n_r <= io_rd_n_w;
				io_wr_n_r <= io_wr_n_w;
				io_m1_n_r <= io_m1_n_w;
				io_vect_r <= io_vect_w;
				io_reti_r <= io_reti_w;

				io_1a02_r[7:0] <= io_1a02_w[7:0];
				io_1a02_d_r[7:0] <= io_1a02_d_w[7:0];
				cz_ipl_r <= cz_ipl_w;
				cz_multiplane_r <= cz_multiplane_w;
			end
	end

	assign io_clk_div_w[2:0]=io_clk_div_r[2:0]+3'b01;

	assign io_clk_div_w[3]=(io_ckp_r[0]==1'b1) ? !io_clk_div_r[3] : io_clk_div_r[3];

	assign io_cke2_w=(io_clk_div_r[3]==2'b0) & ((io_ckp_w[0]==1'b1) | (io_ckp_w[1]==1'b1)) ? 1'b1 : 1'b0;

	assign io_ckp_w[0]=(io_clk_div_r[2:0]==3'b010) ? 1'b1 : 1'b0;
	assign io_ckp_w[1]=io_ckp_r[0];
	assign io_ckn_w[0]=(io_clk_div_r[2:0]==3'b110) ? 1'b1 : 1'b0;
	assign io_ckn_w[1]=io_ckn_r[0];

	assign io_state_w=
			(io_state_r==iost00) & (io_req==1'b0) ? iost00 :	// idle
			(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b0) ? iost00 :	// T0
			(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b1) & (inst_reti_r==1'b1) ? iost04 :	// -> T1
			(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b1) & (inst_reti_r==1'b0) & (fz_m1_r==1'b0) ? iost01 :	// -> T1
			(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b1) & (inst_reti_r==1'b0) & (fz_m1_r==1'b1) ? iost10 :	// -> T1(interrupt ack)
			(io_state_r==iost01) & (io_ckp_r[1]==1'b0) ? iost01 :	// T1
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) ? iost02 :	// -> T2
			(io_state_r==iost02) & (io_ckp_r[1]==1'b0) ? iost02 :	// T2
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b0) ? iost02 :	// -> T2
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) ? iost03 :	// -> T3
			(io_state_r==iost03) & (io_ckn_r[1]==1'b0) ? iost03 :	// T3
			(io_state_r==iost03) & (io_ckn_r[1]==1'b1) ? iost00 :	// -> T4

			(io_state_r==iost04) & (io_ckp_r[1]==1'b0) ? iost04 :
			(io_state_r==iost04) & (io_ckp_r[1]==1'b1) ? iost05 :
			(io_state_r==iost05) & (io_ckp_r[1]==1'b0) ? iost05 :
			(io_state_r==iost05) & (io_ckp_r[1]==1'b1) ? iost06 :
			(io_state_r==iost06) & (io_ckn_r[1]==1'b0) ? iost06 :
			(io_state_r==iost06) & (io_ckn_r[1]==1'b1) ? iost00 :
			(io_state_r==iost07) ? iost00 :

			(io_state_r==iost10) ? iost11 :	// T0
			(io_state_r==iost11) & (io_ckp_r[1]==1'b0) ? iost11 :	// T1
			(io_state_r==iost11) & (io_ckp_r[1]==1'b1) ? iost12 :	// -> T2
			(io_state_r==iost12) & (io_ckp_r[1]==1'b0) ? iost12 :	// T2
			(io_state_r==iost12) & (io_ckp_r[1]==1'b1) ? iost13 :	// -> T3
			(io_state_r==iost13) & (io_ckp_r[1]==1'b0) ? iost13 :	// T3
			(io_state_r==iost13) & (io_ckp_r[1]==1'b1) ? iost14 :	// -> T4
			(io_state_r==iost14) & (io_ckp_r[1]==1'b0) ? iost14 :	// T4
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b0) ? iost14 :	// -> T4
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) ? iost15 :	// -> T5
			(io_state_r==iost15) & (io_ckn_r[1]==1'b0) ? iost15 :	// T5
			(io_state_r==iost15) & (io_ckn_r[1]==1'b1) ? iost00 :	// -> T0
			(io_state_r==iost16) ? iost00 :
			(io_state_r==iost17) ? iost00 :
			iost00;

	assign io_ack_w=
		//	(io_state_r==iost03) & (io_ckn_r[1]==1'b1) ? 1'b1 :
		//	(io_state_r==iost15) & (io_ckn_r[1]==1'b1) ? 1'b1 :
			(io_state_r==iost03) & (io_ckn_r[0]==1'b1) ? 1'b1 :
			(io_state_r==iost05) & (io_ckn_r[0]==1'b1) ? 1'b1 :
			(io_state_r==iost14) & (io_ckp_r[0]==1'b1) ? 1'b1 :
			1'b0;

	assign io_cke_w=
			(io_state_r==iost02) & (io_ckp_w[0]==1'b1) ? 1'b1 :
			(io_state_r==iost02) & (io_ckp_w[1]==1'b1) ? 1'b1 :
			(io_state_r==iost05) & (io_ckp_w[0]==1'b1) ? 1'b1 :
			(io_state_r==iost05) & (io_ckp_w[1]==1'b1) ? 1'b1 :
			(io_state_r==iost13) & (io_ckp_w[0]==1'b1) ? 1'b1 :
			(io_state_r==iost13) & (io_ckp_w[1]==1'b1) ? 1'b1 :
			1'b0;

	assign io_addr_w[15:0]=(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b1) ? fz_addr_r[15:0] : io_addr_r[15:0];
	assign io_wdata_w[7:0]=(io_state_r==iost00) & (io_req==1'b1) & (io_ckp_r[1]==1'b1) ? fz_wdata_r[7:0] : io_wdata_r[7:0];

	assign io_rdata_w[7:0]=
			(io_state_r==iost03) & (io_ckn_r[0]==1'b1) ? z_rdata[7:0] :
			(io_state_r==iost14) & (io_ckp_r[0]==1'b1) ? z_rdata[7:0] :
			io_rdata_r[7:0];

	assign io_wait_n_w[1:0]=(io_ckn_r[0]==1'b1) ? {io_wait_n_r[0],z_wait_n} : io_wait_n_r[1:0];
	
	assign io_req_n_w=
			(io_state_r==iost00) ? 1'b1 :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b0) ? io_req_n_r :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) ? 1'b0 :
			(io_state_r==iost02) ? 1'b0 :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b1) ? io_req_n_r :

			(io_state_r==iost10) ? 1'b1 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b1) ? 1'b1 :
			(io_state_r==iost12) & (io_ckp_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost12) & (io_ckp_r[1]==1'b1) ? 1'b1 :
			(io_state_r==iost13) & (io_ckn_r[1]==1'b0) ? io_req_n_r :
			(io_state_r==iost13) & (io_ckn_r[1]==1'b1) ? 1'b0 :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b0) ? io_req_n_r :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b0) ? io_req_n_r :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) ? 1'b1 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b1) ? 1'b1 :
			1'b1;

	assign io_rd_n_w=
			(io_state_r==iost00) ? 1'b1 :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b0) ? io_rd_n_r :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) & (fz_rd_r==1'b1) ? 1'b0 :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) & (fz_rd_r==1'b0) ? 1'b1 :
			(io_state_r==iost02) ? io_rd_n_r :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b1) ? io_rd_n_r :
			1'b1;

	assign io_wr_n_w=
			(io_state_r==iost00) ? 1'b1 :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b0) ? io_wr_n_r :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) & (fz_rd_r==1'b1) ? 1'b1 :
			(io_state_r==iost01) & (io_ckp_r[1]==1'b1) & (fz_rd_r==1'b0) ? 1'b0 :
			(io_state_r==iost02) ? io_wr_n_r :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost03) & (io_ckn_r[1]==1'b1) ? io_wr_n_r :
			1'b1;

	assign io_m1_n_w=
			(io_state_r==iost10) ? 1'b1 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b1) ? 1'b0 :
			(io_state_r==iost12) ? 1'b0 :
			(io_state_r==iost13) ? 1'b0 :
			(io_state_r==iost14) ? 1'b0 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b0) ? 1'b0 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b1) ? 1'b1 :
			1'b1;

	assign io_vect_w=
			(io_state_r==iost10) ? 1'b0 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b0) ? 1'b0 :
			(io_state_r==iost11) & (io_ckp_r[1]==1'b1) ? 1'b0 :
			(io_state_r==iost12) & (io_ckp_r[1]==1'b0) ? 1'b0 :
			(io_state_r==iost12) & (io_ckp_r[1]==1'b1) ? 1'b0 :
			(io_state_r==iost13) & (io_ckn_r[1]==1'b0) ? io_vect_r :
			(io_state_r==iost13) & (io_ckn_r[1]==1'b1) ? 1'b1 :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b0) ? io_vect_r :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b0) ? io_vect_r :
			(io_state_r==iost14) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) ? 1'b0 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b0) ? 1'b0 :
			(io_state_r==iost15) & (io_ckn_r[1]==1'b1) ? 1'b0 :
			1'b0;

	assign io_reti_w=
			(io_state_r==iost04) & (io_ckp_r[1]==1'b0) ? 1'b0 :
			(io_state_r==iost04) & (io_ckp_r[1]==1'b1) ? 1'b1 :
			(io_state_r==iost05) ? 1'b1 :
			(io_state_r==iost06) & (io_ckn_r[1]==1'b0) ? 1'b1 :
			(io_state_r==iost06) & (io_ckn_r[1]==1'b1) ? 1'b0 :
			1'b0;

	assign io_1a02_w[7:0]=
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a02) ? io_wdata_r[7:0] :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b000) ? {io_1a02_r[7:1],io_wdata_r[0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b001) ? {io_1a02_r[7:2],io_wdata_r[0],io_1a02_r[0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b010) ? {io_1a02_r[7:3],io_wdata_r[0],io_1a02_r[1:0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b011) ? {io_1a02_r[7:4],io_wdata_r[0],io_1a02_r[2:0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b100) ? {io_1a02_r[7:5],io_wdata_r[0],io_1a02_r[3:0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b101) ? {io_1a02_r[7:6],io_wdata_r[0],io_1a02_r[4:0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b110) ? {io_1a02_r[7],io_wdata_r[0],io_1a02_r[5:0]} :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:0]==16'h1a03) & (io_wdata_r[7]==1'b0) & (io_wdata_r[3:1]==3'b111) ? {io_wdata_r[0],io_1a02_r[6:0]} :
			io_1a02_r[7:0];

	assign io_1a02_d_w[7:0]=io_1a02_r[7:0];

	assign cz_ipl_w=
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:8]==8'h1d) ? 1'b1 :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b1) & (io_addr_r[15:8]==8'h1e) ? 1'b0 :
			(io_state_r==iost02) & (io_ckp_r[1]==1'b1) & (io_wait_n_r[0]==1'b1) & (io_rd_n_r==1'b0) & (io_addr_r[15:8]==8'h1e) ? 1'b0 :
			cz_ipl_r;

	assign cz_multiplane_w=
			({fz_iorq_r,fz_rd_r}==2'b11) ? 1'b0 :
			({fz_iorq_r,fz_rd_r}!=2'b11) & ({io_1a02_d_r[5],io_1a02_r[5]}==2'b10) ? 1'b1 :
			({fz_iorq_r,fz_rd_r}!=2'b11) & ({io_1a02_d_r[5],io_1a02_r[5]}!=2'b10) ? cz_multiplane_r :
			1'b0;

	// ---- ----

	reg		mem_wait_r;
	reg		mem_init_done_r;
	reg		[1:0] mem_cmd_state_r;
	reg		mem_cmd_req_r;
	reg		mem_wr_req_r;
	reg		mem_rd_req_r;
	reg		[31:0] mem_cmd_addr_r;
	reg		[3:0] mem_wr_mask_r;
	reg		[31:0] mem_wr_data_r;
	reg		[31:0] mem_rd_addr0_r;
	reg		[31:0] mem_rd_addr1_r;
	reg		[1:0] mem_rd_count_r;
	reg		[31:0] mem_rd_data00_r;
	reg		[31:0] mem_rd_data01_r;
	reg		[31:0] mem_rd_data02_r;
	reg		[31:0] mem_rd_data03_r;
	reg		[31:0] mem_rd_data10_r;
	reg		[31:0] mem_rd_data11_r;
	reg		[31:0] mem_rd_data12_r;
	reg		[31:0] mem_rd_data13_r;

	wire	mem_wait_w;
	wire	mem_init_done_w;
	wire	[1:0] mem_cmd_state_w;
	wire	mem_cmd_req_w;
	wire	mem_wr_req_w;
	wire	mem_rd_req_w;
	wire	[31:0] mem_cmd_addr_w;
	wire	[3:0] mem_wr_mask_w;
	wire	[31:0] mem_wr_data_w;
	wire	[1:0] mem_rd_count_w;
	wire	[31:0] mem_rd_addr0_w;
	wire	[31:0] mem_rd_addr1_w;
	wire	[31:0] mem_rd_data_w;
	wire	[31:0] mem_rd_data00_w;
	wire	[31:0] mem_rd_data01_w;
	wire	[31:0] mem_rd_data02_w;
	wire	[31:0] mem_rd_data03_w;
	wire	[31:0] mem_rd_data10_w;
	wire	[31:0] mem_rd_data11_w;
	wire	[31:0] mem_rd_data12_w;
	wire	[31:0] mem_rd_data13_w;

	wire	mem_rd_ack;
	wire	mem_wr_ack;

	wire	[31:0] mem_cmd_addr_tmp;

	assign mem_cmd_addr_tmp[31:0]=
			(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b1) ? {def_MBASE[31:20],4'h0,1'b1,fz_addr_r[14:2],2'b0} :
			(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b0) & (cz_bank[4]==1'b1) ? {def_MBASE[31:20],4'h0,1'b0,fz_addr_r[14:2],2'b0} :
			(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b0) & (cz_bank[4]==1'b0) ? {def_BBASE[31:20],1'b1,cz_bank[3:0],fz_addr_r[14:2],2'b0} :
			(fz_mreq_r==1'b0) ? {def_VBASE[31:18],2'b00,1'b0,fz_addr_r[13:0],2'b0} :
			32'b0;

	assign mem_rd_addr_hit=
		//	(mem_rd_addr0_r[31:4]==mem_cmd_addr_tmp[31:4]) & (mem_rd_addr0_r[0]==1'b1) ? 1'b1 :
		//	(mem_rd_addr1_r[31:4]==mem_cmd_addr_tmp[31:4]) & (mem_rd_addr1_r[0]==1'b1) ? 1'b1 :
			1'b0;

	assign mem_wr_ack=(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 1'b1 : 1'b0;

	assign mem_rd_ack=(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) ? 1'b1 : 1'b0;

	assign mem_ack=
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 1'b1 :
		//	(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b11) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign mem_cmd_en=mem_cmd_req_r;
	assign mem_cmd_instr[2:0]={2'b00,fz_rd_r};
	assign mem_cmd_bl[5:0]=(fz_rd_r==1'b0) ? 6'h00 : 6'h03;
	assign mem_cmd_byte_addr[29:0]=(fz_rd_r==1'b0) ? {mem_cmd_addr_r[29:2],2'b0} : {mem_cmd_addr_r[29:3],4'b0};

	assign mem_wr_en=mem_wr_req_r;
	assign mem_wr_mask[3:0]=mem_wr_mask_r[3:0];
	assign mem_wr_data[31:0]=mem_wr_data_r[31:0];
	assign mem_rd_en=(mem_rd_empty==1'b0) ? 1'b1 : 1'b0;

	assign mem_rdata[7:0]=//mem_rd_data_r[7:0];
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h0) ? mem_rd_data00_r[7:0] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h1) ? mem_rd_data00_r[15:8] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h2) ? mem_rd_data00_r[23:16] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h3) ? mem_rd_data00_r[31:24] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h4) ? mem_rd_data01_r[7:0] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h5) ? mem_rd_data01_r[15:8] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h6) ? mem_rd_data01_r[23:16] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h7) ? mem_rd_data01_r[31:24] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h8) ? mem_rd_data02_r[7:0] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'h9) ? mem_rd_data02_r[15:8] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'ha) ? mem_rd_data02_r[23:16] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'hb) ? mem_rd_data02_r[31:24] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'hc) ? mem_rd_data03_r[7:0] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'hd) ? mem_rd_data03_r[15:8] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'he) ? mem_rd_data03_r[23:16] :
			(fz_mreq_r==1'b1) & (fz_addr_r[3:0]==4'hf) ? mem_rd_data03_r[31:24] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h0) ? mem_rd_data10_r[7:0] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h1) ? mem_rd_data10_r[15:8] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h2) ? mem_rd_data10_r[23:16] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h3) ? mem_rd_data10_r[31:24] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h4) ? mem_rd_data11_r[7:0] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h5) ? mem_rd_data11_r[15:8] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h6) ? mem_rd_data11_r[23:16] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h7) ? mem_rd_data11_r[31:24] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h8) ? mem_rd_data12_r[7:0] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'h9) ? mem_rd_data12_r[15:8] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'ha) ? mem_rd_data12_r[23:16] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'hb) ? mem_rd_data12_r[31:24] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'hc) ? mem_rd_data13_r[7:0] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'hd) ? mem_rd_data13_r[15:8] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'he) ? mem_rd_data13_r[23:16] :
			(fz_mreq_r==1'b0) & ({fz_addr_r[1:0],fz_addr_r[15:14]}==4'hf) ? mem_rd_data13_r[31:24] :
			8'b0;


	always @(posedge fz_clk or negedge fz_rst_n)
	begin
		if (fz_rst_n==1'b0)
			begin
				mem_init_done_r <= 1'b0;
				mem_wait_r <= 1'b1;
				mem_cmd_state_r[1:0] <= 2'b0;
				mem_cmd_req_r <= 1'b0;
				mem_wr_req_r <= 1'b0;
				mem_rd_req_r <= 1'b0;
				mem_cmd_addr_r[31:0] <= 32'b0;
				mem_wr_mask_r[3:0] <= 4'b0;
				mem_wr_data_r[31:0] <= 32'b0;
				mem_rd_addr0_r[31:0] <= 32'b0;
				mem_rd_addr1_r[31:0] <= 32'b0;
				mem_rd_count_r[1:0] <= 2'b0;
				mem_rd_data00_r[31:0] <= 32'b0;
				mem_rd_data01_r[31:0] <= 32'b0;
				mem_rd_data02_r[31:0] <= 32'b0;
				mem_rd_data03_r[31:0] <= 32'b0;
				mem_rd_data10_r[31:0] <= 32'b0;
				mem_rd_data11_r[31:0] <= 32'b0;
				mem_rd_data12_r[31:0] <= 32'b0;
				mem_rd_data13_r[31:0] <= 32'b0;
			end
		else
			begin
				mem_init_done_r <= mem_init_done_w;
				mem_wait_r <= mem_wait_w;
				mem_cmd_state_r[1:0] <= mem_cmd_state_w[1:0];
				mem_cmd_req_r <= mem_cmd_req_w;
				mem_wr_req_r <= mem_wr_req_w;
				mem_rd_req_r <= mem_rd_req_w;
				mem_cmd_addr_r[31:0] <= mem_cmd_addr_w[31:0];
				mem_wr_mask_r[3:0] <= mem_wr_mask_w[3:0];
				mem_wr_data_r[31:0] <= mem_wr_data_w[31:0];
				mem_rd_addr0_r[31:0] <= mem_rd_addr0_w[31:0];
				mem_rd_addr1_r[31:0] <= mem_rd_addr1_w[31:0];
				mem_rd_count_r[1:0] <= mem_rd_count_w[1:0];
				mem_rd_data00_r[31:0] <= mem_rd_data00_w[31:0];
				mem_rd_data01_r[31:0] <= mem_rd_data01_w[31:0];
				mem_rd_data02_r[31:0] <= mem_rd_data02_w[31:0];
				mem_rd_data03_r[31:0] <= mem_rd_data03_w[31:0];
				mem_rd_data10_r[31:0] <= mem_rd_data10_w[31:0];
				mem_rd_data11_r[31:0] <= mem_rd_data11_w[31:0];
				mem_rd_data12_r[31:0] <= mem_rd_data12_w[31:0];
				mem_rd_data13_r[31:0] <= mem_rd_data13_w[31:0];
			end
	end

	assign mem_init_done_w=mem_init_done;

	assign mem_wait_w=
			(mem_init_done_r==1'b0) ? 1'b1 :
			(mem_init_done_r==1'b1) & (fz_mem_req_r==1'b1) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b0) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 1'b0 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b1) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) ? 1'b0 :
			1'b1;

	assign mem_cmd_state_w[1:0]=
			(mem_init_done_r==1'b0) ? 2'b0 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b0) ? 2'b00 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b0) ? 2'b01 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b0) ? 2'b11 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b1) ? 2'b00 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b0) ? 2'b01 :	// wait empty
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 2'b00 :	// posted end
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b1) ? 2'b11 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]!=2'b11) ? 2'b11 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b11) ? 2'b10 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b10) ? 2'b00 :
			2'b00;

	assign mem_cmd_req_w=
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b0) ? 1'b1 :
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b1) & (mem_rd_addr_hit==1'b0) ? 1'b1 :
			1'b0;

	assign mem_wr_req_w=
			(mem_init_done_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b0) ? 1'b1 :
			1'b0;

	assign mem_cmd_addr_w[31:0]=mem_cmd_addr_tmp[31:0];
		//	(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b1) ? {def_MBASE[31:20],4'h0,1'b1,fz_addr_r[14:2],2'b0} :
		//	(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b0) & (cz_bank[4]==1'b1) ? {def_MBASE[31:20],4'h0,1'b0,fz_addr_r[14:2],2'b0} :
		//	(fz_mreq_r==1'b1) & (fz_addr_r[15]==1'b0) & (cz_bank[4]==1'b0) ? {def_BBASE[31:20],1'b1,cz_bank[3:0],fz_addr_r[14:2],2'b0} :
		//	(fz_mreq_r==1'b0) ? {def_VBASE[31:18],2'b00,1'b0,fz_addr_r[13:0],2'b0} :
		//	32'b0;

	assign mem_wr_mask_w[3]=
			(fz_mreq_r==1'b1) & (fz_addr_r[1:0]==2'b11) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b0) & (fz_addr_r[15:14]==2'b11) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b1) & (fz_addr_r[15:14]!=2'b11) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[2]=
			(fz_mreq_r==1'b1) & (fz_addr_r[1:0]==2'b10) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b0) & (fz_addr_r[15:14]==2'b10) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b1) & (fz_addr_r[15:14]!=2'b10) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[1]=
			(fz_mreq_r==1'b1) & (fz_addr_r[1:0]==2'b01) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b0) & (fz_addr_r[15:14]==2'b01) ? 1'b0 :
			(fz_mreq_r==1'b0) & (cz_multiplane==1'b1) & (fz_addr_r[15:14]!=2'b01) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[0]=
			(fz_mreq_r==1'b1) & (fz_addr_r[1:0]==2'b00) ? 1'b0 :
		//	(fz_mreq_r==1'b0) & (cz_multiplane==1'b0) & (fz_addr_r[15:14]==2'b00) ? 1'b0 :
		//	(fz_mreq_r==1'b0) & (cz_multiplane==1'b1) & (fz_addr_r[15:14]!=2'b00) ? 1'b0 :
			1'b1;

	assign mem_wr_data_w[31:0]={fz_wdata[7:0],fz_wdata[7:0],fz_wdata[7:0],fz_wdata[7:0]};

	assign mem_rd_addr0_w[31:0]=
			(fz_mreq_r==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b0) ? {mem_rd_addr0_r[31:4],4'b0000} :
			(fz_mreq_r==1'b1) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b00) ? {mem_cmd_addr_r[31:4],4'b0001} :
			mem_rd_addr0_r[31:0];

	assign mem_rd_addr1_w[31:0]=
			(fz_mreq_r==1'b0) & (mem_cmd_state_r[1:0]==2'b00) & (fz_mem_req_r==1'b1) & (fz_rd_r==1'b0) ? {mem_rd_addr1_r[31:4],4'b0000} :
			(fz_mreq_r==1'b0) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b00) ? {mem_cmd_addr_r[31:4],4'b0001} :
			mem_rd_addr1_r[31:0];

	assign mem_rd_count_w[1:0]=(mem_rd_empty==1'b0) ? mem_rd_count_r[1:0]+2'b01 : mem_rd_count_r[1:0];

	assign mem_rd_data00_w[31:0]=(fz_mreq_r==1'b1) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b00) ? mem_rd_data[31:0] : mem_rd_data00_r[31:0];
	assign mem_rd_data01_w[31:0]=(fz_mreq_r==1'b1) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b01) ? mem_rd_data[31:0] : mem_rd_data01_r[31:0];
	assign mem_rd_data02_w[31:0]=(fz_mreq_r==1'b1) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b10) ? mem_rd_data[31:0] : mem_rd_data02_r[31:0];
	assign mem_rd_data03_w[31:0]=(fz_mreq_r==1'b1) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b11) ? mem_rd_data[31:0] : mem_rd_data03_r[31:0];

	assign mem_rd_data10_w[31:0]=(fz_mreq_r==1'b0) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b00) ? mem_rd_data[31:0] : mem_rd_data10_r[31:0];
	assign mem_rd_data11_w[31:0]=(fz_mreq_r==1'b0) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b01) ? mem_rd_data[31:0] : mem_rd_data11_r[31:0];
	assign mem_rd_data12_w[31:0]=(fz_mreq_r==1'b0) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b10) ? mem_rd_data[31:0] : mem_rd_data12_r[31:0];
	assign mem_rd_data13_w[31:0]=(fz_mreq_r==1'b0) & (mem_rd_empty==1'b0) & (mem_rd_count_r[1:0]==2'b11) ? mem_rd_data[31:0] : mem_rd_data13_r[31:0];

endmodule
