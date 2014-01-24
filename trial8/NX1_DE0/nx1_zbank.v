//------------------------------------------------------------------------------
//
//	nx1_zbank.v : ese x1 memory interface module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/dec/04 release 0.0  modifyed and downgrade for de1(altera cyclone2)
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

module nx1_zbank #(
	parameter	def_MBASE=32'h00000000,	// main memory base address
	parameter	def_BBASE=32'h00100000,	// bank memory base address
	parameter	def_VBASE=32'h00180000	// video base address
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
	input			mem_clk,			// in    [MEM] clk
	input			mem_rst_n,			// in    [MEM] #reset

	output			z_wait_n,			// out   [CPU] 
	input	[5:0]	z_czbank,			// in    [CPU] CPU BANK REG
	input	[15:0]	z_addr,				// in    [CPU] CPU address
	input	[7:0]	z_wdata,			// in    [CPU] CPU write data
	output	[7:0]	z_rdata,			// in    [CPU] CPU read data
	input			z_rd,				// in    [CPU] rd
	input			z_wr,				// in    [CPU] wr
	input			z_mreq,				// in    [CPU] main select
	input			z_ioreq,			// in    [CPU] vram select
	input	[3:0]	z_vplane,			// in    [CPU] vram plane select
	input			z_multiplane		// in    [CPU] vram multiplane write
//	input			z_debug,			// in    [CPU] debug select
//	input	[3:0]	z_dbank,			// in    [CPU] debug select
//	input			z_vbank,			// in    [CPU] vram offset
//	input			v_req,				// in    [VIDEO] req
//	output			v_ack,				// out   [VIDEO] ack
//	input	[31:0]	v_addr,				// in    [VIDEO] addr
//	output			v_rdata,			// out   [VIDEO] read data
);


/*

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
        | ROM 512K (8KR)                            |
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

	reg		[3:0] mem_cs_r;
	reg		[1:0] mem_req_r;
	reg		wait_n_r;

	wire	[3:0] mem_cs_w;
	wire	[1:0] mem_req_w;
	wire	wait_n_w;

	reg		[1:0] mem_cmd_state_r;
	reg		mem_cmd_req_r;
	reg		mem_wr_req_r;
	reg		mem_rd_req_r;
	reg		mem_cmd_rd_r;
	reg		[31:0] mem_cmd_addr_r;
	reg		[3:0] mem_wr_mask_r;
	reg		[31:0] mem_wr_data_r;
	reg		[31:0] mem_rd_data_r;

	wire	[1:0] mem_cmd_state_w;
	wire	mem_cmd_req_w;
	wire	mem_wr_req_w;
	wire	mem_rd_req_w;
	wire	mem_cmd_rd_w;
	wire	[31:0] mem_cmd_addr_w;
	wire	[3:0] mem_wr_mask_w;
	wire	[31:0] mem_wr_data_w;
	wire	[31:0] mem_rd_data_w;

	wire	mem_ack;
	wire	mem_rd_ack;
	wire	mem_wr_ack;

	assign z_wait_n=
			(z_mreq==1'b1) ? wait_n_r :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_wr==1'b1) & (z_multiplane==1'b1) ? wait_n_r :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_wr==1'b1) & (z_multiplane==1'b0) & (z_addr[15:14]!=2'b00) ? wait_n_r :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_rd==1'b1) & (z_addr[15:14]!=2'b00) ? wait_n_r :
			1'b1;

	assign mem_wr_ack=(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 1'b1 : 1'b0;

	assign mem_rd_ack=(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) ? 1'b1 : 1'b0;

	assign mem_ack=(mem_wr_ack==1'b1) | (mem_rd_ack==1'b1) ? 1'b1 : 1'b0;

	assign mem_cmd_en=mem_cmd_req_r;
	assign mem_cmd_instr[2:0]={2'b00,mem_cmd_rd_r};
	assign mem_cmd_bl[5:0]=6'b0;
	assign mem_cmd_byte_addr[29:0]=mem_cmd_addr_r[29:0];

	assign mem_wr_en=mem_wr_req_r;
	assign mem_wr_mask[3:0]=mem_wr_mask_r[3:0];
	assign mem_wr_data[31:0]=mem_wr_data_r[31:0];
	assign mem_rd_en=(mem_rd_empty==1'b0) ? 1'b1 : 1'b0;

	assign z_rdata[7:0]=//mem_rd_data_r[7:0];
			(z_mreq==1'b1) & (z_addr[1:0]==2'b11) ? mem_rd_data_r[31:24] :
			(z_mreq==1'b1) & (z_addr[1:0]==2'b10) ? mem_rd_data_r[23:16] :
			(z_mreq==1'b1) & (z_addr[1:0]==2'b01) ? mem_rd_data_r[15:8] :
			(z_mreq==1'b1) & (z_addr[1:0]==2'b00) ? mem_rd_data_r[7:0] :
			(z_mreq==1'b0) & (z_addr[15:14]==2'b11) ? mem_rd_data_r[31:24] :
			(z_mreq==1'b0) & (z_addr[15:14]==2'b10) ? mem_rd_data_r[23:16] :
			(z_mreq==1'b0) & (z_addr[15:14]==2'b01) ? mem_rd_data_r[15:8] :
			(z_mreq==1'b0) & (z_addr[15:14]==2'b00) ? mem_rd_data_r[7:0] :
			8'b0;

	wire	mem_cs_req;

	assign mem_cs_req=mem_cs_r[3];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem_cs_r[3:0] <= 4'b0;
				mem_req_r[1:0] <= 2'b0;
				wait_n_r <= 1'b1;

				mem_cmd_state_r[1:0] <= 2'b0;
				mem_cmd_req_r <= 1'b0;
				mem_wr_req_r <= 1'b0;
				mem_rd_req_r <= 1'b0;
				mem_cmd_rd_r <= 1'b0;
				mem_cmd_addr_r[31:0] <= 32'b0;
				mem_wr_mask_r[3:0] <= 4'b0;
				mem_wr_data_r[31:0] <= 32'b0;
				mem_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				mem_cs_r[3:0] <= mem_cs_w[3:0];
				mem_req_r[1:0] <= mem_req_w[1:0];
				wait_n_r <= wait_n_w;

				mem_cmd_state_r[1:0] <= mem_cmd_state_w[1:0];
				mem_cmd_req_r <= mem_cmd_req_w;
				mem_wr_req_r <= mem_wr_req_w;
				mem_rd_req_r <= mem_rd_req_w;
				mem_cmd_rd_r <= mem_cmd_rd_w;
				mem_cmd_addr_r[31:0] <= mem_cmd_addr_w[31:0];
				mem_wr_mask_r[3:0] <= mem_wr_mask_w[3:0];
				mem_wr_data_r[31:0] <= mem_wr_data_w[31:0];
				mem_rd_data_r[31:0] <= mem_rd_data_w[31:0];
			end
	end

	assign mem_cs_w[0]=
			(z_mreq==1'b1) & (z_wr==1'b1) ? 1'b1 :
			(z_mreq==1'b1) & (z_rd==1'b1) ? 1'b1 :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_wr==1'b1) & (z_multiplane==1'b1) ? 1'b1 :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_wr==1'b1) & (z_multiplane==1'b0) & (z_addr[15:14]!=2'b00) ? 1'b1 :
			(z_mreq==1'b0) & (z_ioreq==1'b1) & (z_rd==1'b1) & (z_addr[15:14]!=2'b00) ? 1'b1 :
			1'b0;

	assign mem_cs_w[1]=(mem_init_done==1'b0) ? 1'b0 : mem_cs_r[0];
	assign mem_cs_w[2]=mem_cs_r[1];
	assign mem_cs_w[3]=(mem_cs_r[2:1]==2'b01) ? 1'b1 : 1'b0;

	assign mem_req_w[0]=(mem_cs_r[3]==1'b1) ? 1'b1 : 1'b0;

	assign mem_req_w[1]=
			(mem_cs_r[3]==1'b1) ? 1'b1 :
			(mem_cs_r[3]==1'b0) & (mem_req_r[1]==1'b1) & (mem_cmd_state_r[1:0]==2'b00) ? 1'b0 :
			(mem_cs_r[3]==1'b0) & (mem_req_r[1]==1'b1) & (mem_cmd_state_r[1:0]!=2'b00) ? 1'b1 :
			1'b0;

	assign wait_n_w=
			(mem_init_done==1'b0) ? 1'b0 :
			(mem_init_done==1'b1) & (mem_cs_r[2]==1'b0) ? 1'b0 :
			(mem_init_done==1'b1) & (mem_cs_r[2]==1'b1) & (mem_ack==1'b0) ? wait_n_r :
			(mem_init_done==1'b1) & (mem_cs_r[2]==1'b1) & (mem_ack==1'b1) ? 1'b1 :
			1'b0;

	assign mem_cmd_state_w[1:0]=
			(mem_init_done==1'b0) ? 2'b0 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (mem_req_r[1]==1'b0)  ? 2'b00 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (mem_req_r[1]==1'b1) & (mem_cmd_rd_r==1'b0) ? 2'b01 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b00) & (mem_req_r[1]==1'b1) & (mem_cmd_rd_r==1'b1) ? 2'b11 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b0) ? 2'b01 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b01) & (mem_cmd_empty==1'b1) ? 2'b00 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b1) ? 2'b11 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b11) & (mem_rd_empty==1'b0) ? 2'b00 :
			(mem_init_done==1'b1) & (mem_cmd_state_r[1:0]==2'b10) ? 2'b00 :
			2'b00;

	assign mem_cmd_req_w=(mem_req_r[0]==1'b1) ? 1'b1 : 1'b0;

	assign mem_wr_req_w=(mem_req_r[0]==1'b1) & (mem_cmd_rd_r==1'b0) ? 1'b1 : 1'b0;

	assign mem_cmd_rd_w=(z_wr==1'b1) ? 1'b0 : 1'b1;

	assign mem_cmd_addr_w[31:0]=
			(z_mreq==1'b1) & (z_addr[15]==1'b1) ? {def_MBASE[31:20],4'h0,1'b1,z_addr[14:2],2'b0} :
			(z_mreq==1'b1) & (z_addr[15]==1'b0) & (z_czbank[4]==1'b1) ? {def_MBASE[31:20],4'h0,1'b0,z_addr[14:2],2'b0} :
			(z_mreq==1'b1) & (z_addr[15]==1'b0) & (z_czbank[4]==1'b0) ? {def_BBASE[31:20],1'b1,z_czbank[3:0],z_addr[14:2],2'b0} :
			(z_mreq==1'b0) ? {def_VBASE[31:18],2'b00,1'b0,z_addr[13:0],2'b0} :
			32'b0;

//assign O_GRB_CS  = iorq_r&((I_A[15:14]==2'b01)^I_DAM); // 4000-7FFF B-- / -RG
//assign O_GRR_CS  = iorq_r&((I_A[15:14]==2'b10)^I_DAM); // 8000-BFFF -R- / B-G
//assign O_GRG_CS  = iorq_r&((I_A[15:14]==2'b11)^I_DAM); // C000-FFFF --G / BR-

	assign mem_wr_mask_w[3]=
			(z_mreq==1'b1) & (z_addr[1:0]==2'b11) ? 1'b0 :
		//	(z_mreq==1'b0) ? !z_vplane[3] :
			(z_mreq==1'b0) & (z_multiplane==1'b0) & (z_addr[15:14]==2'b11) ? 1'b0 :
			(z_mreq==1'b0) & (z_multiplane==1'b1) & (z_addr[15:14]!=2'b11) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[2]=
			(z_mreq==1'b1) & (z_addr[1:0]==2'b10) ? 1'b0 :
		//	(z_mreq==1'b0) ? !z_vplane[2] :
			(z_mreq==1'b0) & (z_multiplane==1'b0) & (z_addr[15:14]==2'b10) ? 1'b0 :
			(z_mreq==1'b0) & (z_multiplane==1'b1) & (z_addr[15:14]!=2'b10) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[1]=
			(z_mreq==1'b1) & (z_addr[1:0]==2'b01) ? 1'b0 :
		//	(z_mreq==1'b0) ? !z_vplane[1] :
			(z_mreq==1'b0) & (z_multiplane==1'b0) & (z_addr[15:14]==2'b01) ? 1'b0 :
			(z_mreq==1'b0) & (z_multiplane==1'b1) & (z_addr[15:14]!=2'b01) ? 1'b0 :
			1'b1;
	assign mem_wr_mask_w[0]=
			(z_mreq==1'b1) & (z_addr[1:0]==2'b00) ? 1'b0 :
		//	(z_mreq==1'b0) ? !z_vplane[0] :
		//	(z_mreq==1'b0) & (z_multiplane==1'b0) & (z_addr[15:14]==2'b00) ? 1'b0 :
		//	(z_mreq==1'b0) & (z_multiplane==1'b1) & (z_addr[15:14]!=2'b00) ? 1'b0 :
			1'b1;

	assign mem_wr_data_w[31:0]={z_wdata[7:0],z_wdata[7:0],z_wdata[7:0],z_wdata[7:0]};

	assign mem_rd_data_w[31:0]=(mem_rd_ack==1'b1) ? mem_rd_data[31:0] : mem_rd_data_r[31:0];

/*
	wire	zmem_sel;
	wire	[31:0] zmem_addr;
	wire	[3:0] zmem_be;
	wire	[31:0] zmem_wdata;
	wire	[7:0] zmem_rdata;
	wire	[31:0] vmem_addr;
	wire	[3:0] vmem_be;
	wire	[31:0] vmem_wdata;
	wire	[7:0] vmem_rdata;

	assign zmem_addr[31:0]=
			(z_addr[15]==1'b1) ? {def_MBASE[31:16],1'b0,z_addr[14:2],2'b0} :
			(z_addr[15]==1'b0) & (z_czbank[4]==1'b1) ? {def_MBASE[31:16],1'b0,z_addr[14:2],2'b0} :
			(z_addr[15]==1'b0) & (z_czbank[4]==1'b0) ? {def_BBASE[31:19],z_czbank[3:0],z_addr[14:2],2'b0} :
			32'b0;

	assign zmem_be[3]=(z_addr[1:0]==2'b11) ? 1'b1 : 1'b0;
	assign zmem_be[2]=(z_addr[1:0]==2'b10) ? 1'b1 : 1'b0;
	assign zmem_be[1]=(z_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign zmem_be[0]=(z_addr[1:0]==2'b00) ? 1'b1 : 1'b0;

	assign zmem_wdata[31:0]={z_wdata[7:0],z_wdata[7:0],z_wdata[7:0],z_wdata[7:0]};

	assign zmem_rdata[7:0]=
			(z_addr[1:0]==2'b11) ? mem_rd_data_r[31:24] :
			(z_addr[1:0]==2'b10) ? mem_rd_data_r[23:16] :
			(z_addr[1:0]==2'b01) ? mem_rd_data_r[15:8] :
			(z_addr[1:0]==2'b00) ? mem_rd_data_r[7:0] :
			8'b0;

	assign vmem_addr[31:0]=
			{def_VBASE[31:18],2'b00,1'b0,z_addr[13:0],2'b0} :
			32'b0;

	assign vmem_be[3]=z_vplane[3];
	assign vmem_be[2]=z_vplane[2];
	assign vmem_be[1]=z_vplane[1];
	assign vmem_be[0]=z_vplane[0];

	assign vmem_wdata[31:0]={z_wdata[7:0],z_wdata[7:0],z_wdata[7:0],z_wdata[7:0]};

	assign vmem_rdata[7:0]=
			(z_addr[15:14]==2'b11) ? mem_rd_data_r[31:24] :
			(z_addr[15:14]==2'b10) ? mem_rd_data_r[23:16] :
			(z_addr[15:14]==2'b01) ? mem_rd_data_r[15:8] :
			(z_addr[15:14]==2'b00) ? mem_rd_data_r[7:0] :
			8'b0;
*/

endmodule
