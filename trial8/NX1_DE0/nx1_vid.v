//------------------------------------------------------------------------------
//
//	nx1_vid.v : ese x1 video module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/nov/28 release 0.0  modifyed and downgrade for de1(altera cyclone2)
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
//
//	original copyright 
//
//--------------------------------------------------------------------------------------
/****************************************************************************
	X1 VIDEO CIRCUIT

	Version 050414

	Copyright(C) 2004,2005 Tatsuyuki Satoh

	This software is provided "AS IS", with NO WARRANTY.
	NON-COMMERCIAL USE ONLY

	Histry:
		2008. 4.28 bugfix,can't PCG(X1mode) in WIDTH40 with X1turbo select
		2005. 4.14 X1turbo mode PCG access address generator
		           non left sque mode (coded only)
		2005. 1.11 1st release

	Note:

	Distributing all and a part is prohibited. 
	Because this version is developer-alpha version.

    VIDEO / GRAPHIC RAM read is not supported

****************************************************************************/

//`define FAST_SQUE  /* 8dot left sque,save some circuit */

module nx1_vid #(
	parameter	busfree=8'h0,
	parameter	def_DEVICE=0,			// 0=Xilinx , 1=Altera
	parameter	def_X1TURBO=0,
	parameter	def_VBASE=32'h00180000,	// video base address
	parameter	SIM_FAST=0,				// fast simulation
	parameter	DEBUG=0					// 
) (
	input			EX_HDISP,			// out   [CRT] horizontal disp
	input			EX_VDISP,			// out   [CRT] vertical disp
	input			EX_HBP,				// in    [SYNC] horizontal backporch
	input			EX_HWSAV,			// in    [SYNC] horizontal window sav
	input			EX_HSAV,			// out   [CRT] horizontal sav
	input			EX_HEAV,			// out   [CRT] horizontal eav
	input			EX_HC,				// out   [CRT] horizontal countup
	input			EX_VWSAV,			// in    [SYNC] vertical window sav
	input			EX_VSAV,			// out   [CRT] vertical sav
	input			EX_VEAV,			// out   [CRT] vertical eav
	input			EX_VC,				// out   [CRT] vertical countup

	input			vram_clk,			// in    [VRAM] clk
	input			vram_init_done,		// in    [VRAM] init done
	output			vram_cmd_en,		// out   [VRAM] cmd en
	output	[2:0]	vram_cmd_instr,		// out   [VRAM] cmd inst[2:0]
	output	[5:0]	vram_cmd_bl,		// out   [VRAM] cmd blen[5:0]
	output	[29:0]	vram_cmd_byte_addr,	// out   [VRAM] cmd addr[29:0]
	input			vram_cmd_empty,		// in    [VRAM] cmd empt
	input			vram_cmd_full,		// in    [VRAM] cmd full
	output			vram_rd_en,			// out   [VRAM] rd en
	input	[31:0]	vram_rd_data,		// in    [VRAM] rd rdata[31:0]
	input			vram_rd_full,		// in    [VRAM] rd full
	input			vram_rd_empty,		// in    [VRAM] rd empt
	input	[6:0]	vram_rd_count,		// in    [VRAM] rd count[6:0]
	input			vram_rd_overflow,	// in    [VRAM] rd over
	input			vram_rd_error,		// in    [VRAM] rd err

	input			I_RESET,
	input			I_CCLK,
	input			I_CCKE,
	input	[15:0]	I_A,
	input	[7:0]	I_D,
	output	[7:0]	O_D,
	output			O_DE,
	input			I_WR,
	input			I_RD,
	output			O_VWAIT,

	input			defchr_enable,
	input			I_CRTC_CS,
	input			I_CG_CS,
	input			I_PAL_CS,
	input			I_TXT_CS,
	input			I_ATT_CS,
	input			I_KAN_CS,

	input			I_GRB_CS,
	input			I_GRR_CS,
	input			I_GRG_CS,

	input			I_VCLK,
	input			I_CLK1,
	input			I_W40,

	input			I_HIRESO,
	input			I_LINE400,
	input			I_TEXT12,
	input			I_PCG_TURBO,
	input			I_CG16,
	input			I_UDLINE,
	input	[2:0]	I_BLACK_COL,
	input			I_TXT_BLACK,
	input			I_GR0_BLACK,
	input			I_GR1_BLACK,
	input			I_BLK_BLACK,

	output			O_YM,

	output	[10:0]	O_CGA,

	output	[7:0]	text_rdata,
	output	[7:0]	attr_rdata,
	output	[7:0]	ktext_rdata,

	output	[7:0]	cg_rdata,

	output	[7:0]	O_R,
	output	[7:0]	O_G,
	output	[7:0]	O_B,
	output			O_HSYNC,
	output			O_VSYNC,
	output			O_VDISP
);


	wire	[13:0] O_VA;

	wire	[7:0] I_CG_D;
	wire	[7:0] I_PCGB_D;
	wire	[7:0] I_PCGR_D;
	wire	[7:0] I_PCGG_D;

	wire	[7:0] I_TXT_D;
	wire	[7:0] I_ATT_D;
	wire	[7:0] I_KAN_D;
	wire	[7:0] I_GRA_D;
	wire	[7:0] I_GRB_D;
	wire	[7:0] I_GRR_D;
	wire	[7:0] I_GRG_D;

	wire	cg_wr;
	wire	pcgb_wr;
	wire	pcgr_wr;
	wire	pcgg_wr;

//	wire	[7:0] text_rdata;
//	wire	[7:0] attr_rdata;
//	wire	[7:0] ktext_rdata;
//	wire	[7:0] cg_rdata;

	wire	[7:0] text_vdata;
	wire	[7:0] attr_vdata;
	wire	[7:0] ktext_vdata;

	wire	[7:0] cg_vdata;
	wire	[7:0] pcgb_vdata;
	wire	[7:0] pcgr_vdata;
	wire	[7:0] pcgg_vdata;

	assign I_CG_D=cg_vdata;
	assign I_PCGB_D=pcgb_vdata;
	assign I_PCGR_D=pcgr_vdata;
	assign I_PCGG_D=pcgg_vdata;

	assign I_TXT_D=text_vdata;
	assign I_ATT_D=(DEBUG==0) ? attr_vdata : 8'h07;
	assign I_KAN_D=ktext_vdata;

	assign cg_wr=I_CG_CS & I_WR & defchr_enable;
	assign pcgb_wr=cg_wr & (I_A[9:8]==2'b01); // 15xx
	assign pcgr_wr=cg_wr & (I_A[9:8]==2'b10); // 16xx
	assign pcgg_wr=cg_wr & (I_A[9:8]==2'b11); // 17xx

	assign cg_rdata[7:0]=
			(I_A[9:8]==2'b00) ? cg_vdata   :
			(I_A[9:8]==2'b01) ? pcgb_vdata :
			(I_A[9:8]==2'b10) ? pcgr_vdata :
			(I_A[9:8]==2'b10) ? pcgg_vdata :
			busfree[7:0];

nx1_cg8 #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) x1_cg8 (
	.CLK1(I_VCLK),
	.ADDR1(O_CGA[10:0]),
	.DATA1(cg_vdata[7:0]),
	.CLK2(I_VCLK),
	.ADDR2(O_CGA[10:0]),
	.DATA2()
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) pcg_b_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(O_CGA[10:0]),
  .CDI(I_D[7:0]),
  .CDO(),
  .CCS(1'b1),
  .CWE(pcgb_wr & I_CCKE),
  .CRD(1'b1),
  .VCLK(I_VCLK),
  .VA(O_CGA[10:0]),
  .VDO(pcgb_vdata[7:0])
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) pcg_r_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(O_CGA[10:0]),
  .CDI(I_D[7:0]),
  .CDO(),
  .CCS(1'b1),
  .CWE(pcgr_wr & I_CCKE),
  .CRD(1'b1),
  .VCLK(I_VCLK),
  .VA(O_CGA[10:0]),
  .VDO(pcgr_vdata[7:0])
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) pcg_g_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(O_CGA[10:0]),
  .CDI(I_D[7:0]),
  .CDO(),
  .CCS(1'b1),
  .CWE(pcgg_wr & I_CCKE),
  .CRD(1'b1),
  .VCLK(I_VCLK),
  .VA(O_CGA[10:0]),
  .VDO(pcgg_vdata[7:0])
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) text_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(I_A[10:0]),
  .CDI(I_D[7:0]),
  .CDO(text_rdata[7:0]),
  .CCS(I_TXT_CS),
  .CWE(I_WR & I_CCKE),
  .CRD(I_RD),
  .VCLK(I_VCLK),
  .VA(O_VA[10:0]),
  .VDO(text_vdata[7:0])
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) att_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(I_A[10:0]),
  .CDI(I_D[7:0]),
  .CDO(attr_rdata[7:0]),
  .CCS(I_ATT_CS),
  .CWE(I_WR & I_CCKE),
  .CRD(I_RD),
  .VCLK(I_VCLK),
  .VA(O_VA[10:0]),
  .VDO(attr_vdata[7:0])
);

nx1_dpram2k #(
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) kanji_ram (
  .CCLK(I_CCLK),//ZCLK),
  .CA(I_A[10:0]),
  .CDI(I_D[7:0]),
  .CDO(ktext_rdata[7:0]),
  .CCS(I_KAN_CS),
  .CWE(I_WR & I_CCKE),
  .CRD(I_RD),
  .VCLK(I_VCLK),
  .VA(O_VA[10:0]),
  .VDO(ktext_vdata[7:0])
);

/****************************************************************************
  CRTC
****************************************************************************/
wire [4:0]  crtc_ra;
wire [13:0] crtc_ma;
wire crtc_hsync;
wire crtc_vsync;
wire crtc_disptmg;

	wire	vclk_cyc0;
	wire	vclk_cyc1;
	wire	vclk_cyc2;
	wire	vclk_cyc3;
	wire	vclk_cyc4;
	wire	vclk_cyc5;
	wire	vclk_cyc6;
	wire	vclk_cyc7;

crtc45e #(
	.init_reg1(8'h14),		// horizontal displayed 80chr or 40chr
	.init_reg6(7'h19),		// vetical displayed 25chr
	.init_reg9(5'h07)		// caracter scan line 8 -1
) crtc6845 (
	.EX_HDISP(EX_HDISP),		// in    [CRT] horizontal disp
	.EX_VDISP(EX_VDISP),		// in    [CRT] vertical disp
	.EX_HSAV(EX_HWSAV),			// in    [CRT] horizontal sav
	.EX_HEAV(EX_HEAV),			// in    [CRT] horizontal eav
	.EX_HC(EX_HC),				// in    [CRT] horizontal countup
	.EX_VSAV(EX_VWSAV),			// in    [CRT] vertical sav
	.EX_VEAV(EX_VEAV),			// in    [CRT] vertical eav
	.EX_VC(EX_VC),				// in    [CRT] vertical countup

	.I_CLK(I_CCLK),
	.I_E(I_CCKE),
	.I_DI(I_D),
	.I_RS(I_A[0]),
	.I_RWn(~I_WR),
	.I_CSn(~(I_CRTC_CS & defchr_enable)),

	.I_VCLK(I_VCLK),
	.I_RSTn(~I_RESET),
	.I_W40(I_W40),

	.QA(QA),
	.QB(QB),
	.QC(QC),
	.QD(QD),
	.QP(QP),

	.vclk_cyc0(vclk_cyc0),	// ma,ra load
	.vclk_cyc1(vclk_cyc1),	// attr latch
	.vclk_cyc2(vclk_cyc2),	// cg-addr load
	.vclk_cyc3(vclk_cyc3),	// chr latch
	.vclk_cyc4(vclk_cyc4),
	.vclk_cyc5(vclk_cyc5),
	.vclk_cyc6(vclk_cyc6),
	.vclk_cyc7(vclk_cyc7),	// 

	.O_RA(crtc_ra[4:0]),
	.O_MA(crtc_ma[13:0]),
	.O_H_SYNC(crtc_hsync),
	.O_V_SYNC(crtc_vsync),
	.O_DISPTMG(crtc_disptmg)
);


	reg		EX_HBP_REQ_r;
	reg		EX_HSAV_REQ_r;
	reg		EX_HEAV_REQ_r;
	wire	EX_HBP_REQ_w;
	wire	EX_HSAV_REQ_w;
	wire	EX_HEAV_REQ_w;

	wire	linebuff_wen;
	wire	[7:0] linebuff_waddr;
	wire	[35:0] linebuff_wdata;
	wire	[7:0] linebuff_raddr;
	wire	[35:0] linebuff_rdata;

	localparam	vcst00=4'b0000;
	localparam	vcst01=4'b0001;
	localparam	vcst02=4'b0011;
	localparam	vcst03=4'b0010;
	localparam	vcst04=4'b0100;
	localparam	vcst05=4'b0101;
	localparam	vcst06=4'b0111;
	localparam	vcst07=4'b0110;
	localparam	vcst10=4'b1100;
	localparam	vcst11=4'b1101;
	localparam	vcst12=4'b1111;
	localparam	vcst13=4'b1110;
	localparam	vcst14=4'b1000;
	localparam	vcst15=4'b1001;
	localparam	vcst16=4'b1011;
	localparam	vcst17=4'b1010;

	reg		[3:0] vram_cmd_state_r;
	reg		vram_cmd_en_r;
	reg		[16:0] vram_cmd_byte_addr_r;
	reg		[7:0] vram_rbuff_addr_r;
	reg		[7:0] vram_rd_count_r;

	wire	[3:0] vram_cmd_state_w;
	wire	vram_cmd_en_w;
	wire	[16:0] vram_cmd_byte_addr_w;
	wire	[7:0] vram_rbuff_addr_w;
	wire	[7:0] vram_rd_count_w;

	reg		linebuff_wen_r;
	reg		[7:0] linebuff_waddr_r;
	reg		[35:0] linebuff_wdata_r;

	wire	linebuff_wen_w;
	wire	[7:0] linebuff_waddr_w;
	wire	[35:0] linebuff_wdata_w;

	assign vram_cmd_en=vram_cmd_en_r;
	assign vram_cmd_instr[2:0]=3'b001;	// read
	assign vram_cmd_bl[5:0]=6'h03;		// burst 4cycle
	assign vram_cmd_byte_addr[29:0]={def_VBASE[29:19],vram_cmd_byte_addr_r[16:2],4'b0};

	assign vram_rd_en=!vram_rd_empty;

//         a[15:14]=0 a[15:14]=1 a[15:14]=2 a[15:14]=3
//         D[7:0]     D[7:0]     D[7:0]     D[7:0]
//18.0000 +----------+----------+----------+----------+
//        | A0       | B0       | R0       | G0       |
//19.0000 +----------+----------+----------+----------+
//        | A1       | B1       | R1       | G1       |
//1a.0000 +----------+----------+----------+----------+

	assign I_GRA_D[7:0]=linebuff_rdata[7:0];	// rsv (alpha)
	assign I_GRB_D[7:0]=linebuff_rdata[15:8];	// blu
	assign I_GRR_D[7:0]=linebuff_rdata[23:16];	// red
	assign I_GRG_D[7:0]=linebuff_rdata[31:24];	// grn

generate
	if (def_DEVICE==0)
begin

xil_blk_mem_gen_v7_2_dp36x256 linebuf0(
	.clka(vram_clk),
	.ena(1'b1),
	.wea({linebuff_wen,linebuff_wen,linebuff_wen,linebuff_wen}),
	.addra(linebuff_waddr[7:0]),
	.dina(linebuff_wdata[35:0]),
	.clkb(I_VCLK),
	.enb(1'b1),
	.addrb(linebuff_raddr[7:0]),
	.doutb(linebuff_rdata[35:0])
);

end
endgenerate

generate
	if (def_DEVICE==1)
begin

alt_altsyncram_c3dp36x256 linebuf0(
	.byteena_a(4'b1111),
	.data(linebuff_wdata[35:0]),
	.rdaddress(linebuff_raddr[7:0]),
	.rdclock(I_VCLK),
	.wraddress(linebuff_waddr[7:0]),
	.wrclock(vram_clk),
	.wren(linebuff_wen),
	.q(linebuff_rdata[35:0])
);

end
endgenerate

	assign linebuff_waddr[7:0]=linebuff_waddr_r[7:0];
	assign linebuff_wdata[35:0]=linebuff_wdata_r[35:0];
	assign linebuff_wen=linebuff_wen_r;

	assign linebuff_raddr[7:0]=crtc_ma[7:0];

	always @(posedge I_VCLK or posedge I_RESET)
	begin
		if (I_RESET==1'b1)
			begin
				EX_HBP_REQ_r <= 1'b0;
				EX_HSAV_REQ_r <= 1'b0;
				EX_HEAV_REQ_r <= 1'b0;
			end
		else
			begin
				EX_HBP_REQ_r <= EX_HBP_REQ_w;
				EX_HSAV_REQ_r <= EX_HSAV_REQ_w;
				EX_HEAV_REQ_r <= EX_HEAV_REQ_w;
			end
	end

	assign EX_HBP_REQ_w=(EX_HBP==1'b1) ? !EX_HBP_REQ_r  : EX_HBP_REQ_r;
	assign EX_HSAV_REQ_w=(EX_HSAV==1'b1) ? !EX_HSAV_REQ_r  : EX_HSAV_REQ_r;
	assign EX_HEAV_REQ_w=(EX_HEAV==1'b1) ? !EX_HEAV_REQ_r  : EX_HEAV_REQ_r;

	reg		[3:0] vram_hbp_req_r;
	reg		[3:0] vram_hsav_req_r;
	reg		[3:0] vram_heav_req_r;
	reg		[3:0] vram_hdisp_r;
	wire	[3:0] vram_hbp_req_w;
	wire	[3:0] vram_hsav_req_w;
	wire	[3:0] vram_heav_req_w;
	wire	[3:0] vram_hdisp_w;

	always @(posedge vram_clk or posedge I_RESET)
	begin
		if (I_RESET==1'b1)
			begin
				vram_hbp_req_r[3:0] <= 4'b0;
				vram_hsav_req_r[3:0] <= 4'b0;
				vram_heav_req_r[3:0] <= 4'b0;
				vram_hdisp_r[3:0] <= 4'b0;
				vram_cmd_state_r <= vcst00;
				vram_cmd_en_r <= 1'b0;
				vram_cmd_byte_addr_r[16:0] <= 17'b0;
				vram_rbuff_addr_r[7:0] <= 8'b0;
				vram_rd_count_r[7:0] <= 8'b0;
				linebuff_wen_r <= 1'b0;
				linebuff_waddr_r[7:0] <= 8'b0;
				linebuff_wdata_r[35:0] <= 36'b0;
			end
		else
			begin
				vram_hbp_req_r[3:0] <= vram_hbp_req_w[3:0];
				vram_hsav_req_r[3:0] <= vram_hsav_req_w[3:0];
				vram_heav_req_r[3:0] <= vram_heav_req_w[3:0];
				vram_hdisp_r[3:0] <= vram_hdisp_w[3:0];
				vram_cmd_state_r <= vram_cmd_state_w;
				vram_cmd_en_r <= vram_cmd_en_w;
				vram_cmd_byte_addr_r[16:0] <= vram_cmd_byte_addr_r[16:0];
				vram_rbuff_addr_r[7:0] <= vram_rbuff_addr_w[7:0];
				vram_rd_count_r[7:0] <= vram_rd_count_w[7:0];
				linebuff_wen_r <= linebuff_wen_w;
				linebuff_waddr_r[7:0] <= linebuff_waddr_w[7:0];
				linebuff_wdata_r[35:0] <= linebuff_wdata_w[35:0];
			end
	end

	assign vram_hbp_req_w[0]=EX_HBP_REQ_r;
	assign vram_hbp_req_w[1]=vram_hbp_req_r[0];
	assign vram_hbp_req_w[2]=vram_hbp_req_r[1];
	assign vram_hbp_req_w[3]=(vram_hbp_req_r[2:1]==2'b01) | (vram_hbp_req_r[2:1]==2'b10) ? 1'b1 : 1'b0;

	assign vram_hsav_req_w[0]=EX_HSAV_REQ_r;
	assign vram_hsav_req_w[1]=vram_hsav_req_r[0];
	assign vram_hsav_req_w[2]=vram_hsav_req_r[1];
	assign vram_hsav_req_w[3]=(vram_hsav_req_r[2:1]==2'b01) | (vram_hsav_req_r[2:1]==2'b10) ? 1'b1 : 1'b0;

	assign vram_heav_req_w[0]=EX_HEAV_REQ_r;
	assign vram_heav_req_w[1]=vram_heav_req_r[0];
	assign vram_heav_req_w[2]=vram_heav_req_r[1];
	assign vram_heav_req_w[3]=
			(vram_hbp_req_r[3]==1'b1) ? 1'b0 :
			(vram_hbp_req_r[3]==1'b0) &  ((vram_heav_req_r[2:1]==2'b01) | (vram_heav_req_r[2:1]==2'b10)) ? 1'b1 :
			(vram_hbp_req_r[3]==1'b0) & !((vram_heav_req_r[2:1]==2'b01) | (vram_heav_req_r[2:1]==2'b10)) &  (vram_cmd_state_r==vcst10) ? 1'b0 :
			(vram_hbp_req_r[3]==1'b0) & !((vram_heav_req_r[2:1]==2'b01) | (vram_heav_req_r[2:1]==2'b10)) & !(vram_cmd_state_r==vcst10) ? vram_heav_req_r[3] :
			1'b0;

	assign vram_hdisp_w[0]=(EX_HDISP==1) & (EX_VDISP==1) ? 1'b1 : 1'b0;
	assign vram_hdisp_w[1]=vram_hdisp_r[0];
	assign vram_hdisp_w[2]=vram_hdisp_r[1];
	assign vram_hdisp_w[3]=vram_hdisp_r[2];

	assign vram_cmd_state_w=
			(vram_cmd_state_r==vcst00) & (vram_init_done==1'b0) ? vcst00 :
			(vram_cmd_state_r==vcst00) & (vram_init_done==1'b1) ? vcst01 :	// init done
			(vram_cmd_state_r==vcst01) & (vram_hbp_req_r[3]==1'b0) ? vcst01 :
			(vram_cmd_state_r==vcst01) & (vram_hbp_req_r[3]==1'b1) ? vcst02 :	// display prefetch
			(vram_cmd_state_r==vcst02) & (vram_cmd_empty==1'b0) ? vcst02 :
			(vram_cmd_state_r==vcst02) & (vram_cmd_empty==1'b1) ? vcst03 :	// cmd read
			(vram_cmd_state_r==vcst03) ? vcst04 :	// cmd read
			(vram_cmd_state_r==vcst04) ? vcst05 :	// cmd read
			(vram_cmd_state_r==vcst05) ? vcst06 :	// cmd read
			(vram_cmd_state_r==vcst06) & (vram_rd_empty==1'b0) ? vcst06 :
			(vram_cmd_state_r==vcst06) & (vram_rd_empty==1'b1) ? vcst07 :	// read data ready
			(vram_cmd_state_r==vcst07) & (vram_rd_count_r[3:0]!=4'b0) ? vcst07 :
			(vram_cmd_state_r==vcst07) & (vram_rd_count_r[3:0]==4'b0) ? vcst10 :	// 4x4burst done

			(vram_cmd_state_r==vcst10) & (vram_heav_req_r[3]==1'b1) ? vcst01 :	// abort
			(vram_cmd_state_r==vcst10) & (vram_heav_req_r[3]==1'b0) & (vram_hdisp_r[3]==1'b0) ? vcst10 :
			(vram_cmd_state_r==vcst10) & (vram_heav_req_r[3]==1'b0) & (vram_hdisp_r[3]==1'b1) ? vcst11 :	// display request

			(vram_cmd_state_r==vcst11) & (vram_rd_count_r[6:4]!=3'b110) ? vcst02 :	// read next
			(vram_cmd_state_r==vcst11) & (vram_rd_count_r[6:4]==3'b110) ? vcst12 :	// 6x4burst(80+16) done

			(vram_cmd_state_r==vcst12) & (vram_hdisp_r[3]==1'b1) ? vcst01 :	// idle
			(vram_cmd_state_r==vcst12) & (vram_hdisp_r[3]==1'b0) ? vcst12 :
			vcst00;

	assign vram_cmd_en_w=
			(vram_cmd_state_r==vcst02) & (vram_cmd_empty==1'b1) ? 1'b1 :
			(vram_cmd_state_r==vcst03) ? 1'b1 :
			(vram_cmd_state_r==vcst04) ? 1'b1 :
			(vram_cmd_state_r==vcst05) ? 1'b1 :
			1'b0;

	assign vram_cmd_byte_addr_w[16:0]=
			(vram_cmd_state_r==vcst00) ? 17'b0 :
			(vram_cmd_state_r==vcst01) ? {2'b00,1'b0,crtc_ra[2:0],crtc_ma[10:4],4'b0} :	// 16bytes allignment
			(vram_cmd_state_r==vcst02) & (vram_cmd_empty==1'b0) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst02) & (vram_cmd_empty==1'b1) ? vram_cmd_byte_addr_r[16:0]+17'h010 :
			(vram_cmd_state_r==vcst03) ? vram_cmd_byte_addr_r[16:0]+17'h010 :
			(vram_cmd_state_r==vcst04) ? vram_cmd_byte_addr_r[16:0]+17'h010 :
			(vram_cmd_state_r==vcst05) ? vram_cmd_byte_addr_r[16:0]+17'h010 :
			(vram_cmd_state_r==vcst06) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst07) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst10) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst11) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst12) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst13) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst14) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst15) ? vram_cmd_byte_addr_r[16:0] :
			(vram_cmd_state_r==vcst16) ? vram_cmd_byte_addr_r[16:0] :
			17'b0;

	assign vram_rbuff_addr_w[7:0]=
			(vram_cmd_state_r==vcst01) ? {crtc_ma[9:4],2'b0} :
			(vram_cmd_state_r!=vcst01) & (vram_rd_en==1'b0) ? vram_rbuff_addr_r[7:0] :
			(vram_cmd_state_r!=vcst01) & (vram_rd_en==1'b1) ? vram_rbuff_addr_r[7:0]+1'b1 :
			8'b0;

	assign vram_rd_count_w[7:0]=
			(vram_cmd_state_r==vcst01) ? 8'b0 :
			(vram_cmd_state_r!=vcst01) & (vram_rd_en==1'b0) ? vram_rd_count_r[7:0] :
			(vram_cmd_state_r!=vcst01) & (vram_rd_en==1'b1) ? vram_rd_count_r[7:0]+1'b1 :
			8'b0;

	assign linebuff_wen_w=vram_rd_en;
	assign linebuff_waddr_w[7:0]=vram_rbuff_addr_r[7:0];
	assign linebuff_wdata_w[35:0]={4'b0,vram_rd_data[31:0]};

/****************************************************************************
  VDISP signal
****************************************************************************/
//
// 3xLS14 & RC delay(220ohm,1200pF)
// about 300ns = 35ns(28.6Mhz) * 8.5
//
reg vdisp;
reg vdisp_dly;

	always @(posedge I_VCLK or posedge I_RESET)
	begin
		if (I_RESET==1'b1)
			begin
				vdisp <= 1'b0;
				vdisp_dly <= 1'b0;
			end
		else
			begin
				if(crtc_ra[0])
					vdisp_dly <= 1;
				else 
					begin
						// latch VDISP
						if(~QP & QA & ~QD & ~QC & ~QB)
							begin
								if(vdisp_dly)
									vdisp <= crtc_disptmg;
								vdisp_dly <= 1'b0;
							end
					end
			end
	end

/****************************************************************************
  VRAM/GRAM access address
****************************************************************************/

//`ifdef X1TURBO
// CRTC / turbo PCG address mux
wire [10:0] vram_a = (I_PCG_TURBO && ~crtc_disptmg) ? 11'b11111111111 : crtc_ma;
//`else
//wire [10:0] vram_a = crtc_ma;
//`endif

// CPU / VRAM address mux
//assign O_VA = QD ? I_A[13:0] : {crtc_ra[2:0],vram_a};
assign O_VA  = {crtc_ra[2:0],vram_a};

/****************************************************************************
  VRAM & CG LATCH
****************************************************************************/
reg [7:0] txt_d;
reg [7:0] cgb_d , cgr_d , cgg_d;
reg [7:0] grb_d , grr_d , grg_d;
//`ifdef FAST_SQUE
wire [7:0] att_d = I_ATT_D; // attr bypass
//`else
//reg [7:0] att_d;
//reg [7:0] grb_r , grr_r , grg_r;
//`endif

// attribute bit assign
reg att_h2x;
//reg att_v2x;
reg att_pcg;
reg att_blink;
reg att_rev;
reg att_g;
reg att_r;
reg att_b;

reg hsync_d , vsync_d , disp_d;

// V2X
reg [2:0] cg_line;
reg old_ra0;

always @(posedge I_VCLK)
begin
  if(~QP & QA) // 1pixel clock
  begin

    // CG pixel shift
    if(~att_h2x || ~QB)
    begin
      // pixel hift register
      cgb_d[7:1] <= cgb_d[6:0];
      cgr_d[7:1] <= cgr_d[6:0];
      cgg_d[7:1] <= cgg_d[6:0];
    end

    // GRAM pixel shift
    grb_d[7:1] <= grb_d[6:0];
    grr_d[7:1] <= grr_d[6:0];
    grg_d[7:1] <= grg_d[6:0];

    if(~QD)
    begin
//`ifdef FAST_SQUE
      if( QC & ~QB) // delay 2 ealy latch
      begin
        txt_d <= I_TXT_D;

        // CG V pos
        old_ra0 <= crtc_ra[0];
        if( (att_d[6] | ~crtc_disptmg) & vdisp )
        begin
          // V2X
          if(old_ra0 & ~crtc_ra[0])
            cg_line <= cg_line + 1;    // x2 increment CRTC 2V
        end else begin
          cg_line <= crtc_ra[2:0];     // x1 CRTC through
        end
      end
//`endif
      if(~QC & ~QB) // delay 4
      begin
//`ifndef FAST_SQUE
//        // 1 char delayed latch
//        txt_d <= I_TXT_D;
//        att_d <= I_ATT_D;
//        // CG V pos
//        old_ra0 <= crtc_ra[0];
//        if( (att_d[6] | ~crtc_disptmg) & vdisp )
//        begin
//          // V2X
//          if(old_ra0 & ~crtc_ra[0])
//            cg_line <= cg_line + 1;        // x2 increment CRTC 2V
//        end else begin
//          cg_line <= crtc_ra[2:0];     // x1 CRTC through
//        end
//`endif
        // CG load
        if(~att_h2x || ~crtc_ma[0])
        begin
          cgb_d  <= I_PCGB_D; // blue
          cgr_d  <= I_PCGR_D; // reg
          cgg_d  <= att_d[5] ? I_PCGG_D : I_CG_D; // green or ROM
        end
        // ATT load
        att_h2x   <=  att_d[7];
//`ifdef FAST_SQUE
//        att_v2x   <=  att_d[6];
//`else
//        att_v2x   <= (att_d[6] | ~crtc_disptmg) & vdisp;
//`endif
        att_pcg   <=  att_d[5];
        att_blink <=  att_d[4];
        att_rev   <=  att_d[3];
        att_g     <=  att_d[2];
        att_r     <=  att_d[1];
        att_b     <=  att_d[0];

        // GRAM load
//`ifdef FAST_SQUE
        grb_d <= I_GRB_D;
        grr_d <= I_GRR_D;
        grg_d <= I_GRG_D;
        // syncs
        hsync_d  <= crtc_hsync;
        vsync_d  <= crtc_vsync;
//`else
//        grb_r <= I_GRB_D;
//        grr_r <= I_GRR_D;
//        grg_r <= I_GRG_D;
//        grb_d <= grb_r;
//        grr_d <= grr_r;
//        grg_d <= grg_r;
//        // syncs
//        hsync_d  <= crtc_hsync;
//        vsync_d  <= crtc_vsync;
//`endif
        disp_d   <= crtc_disptmg;
      end
    end
  end
end

/****************************************************************************
  CG/PCG address
****************************************************************************/

/*
  kanji

wire kan_sel = kan_d[7]; // CG / KANJI
wire kan_rt  = kan_d[7]; // LEFT / RIGHT
wire kan_ul  = kan_d[7]; // under line
wire kan_d2  = kan_d[7]; // DAI1 / DAI2,GAIJI
wire [3:0] kan_ah = kan_d[3:0]; // upper address
*/

//`ifdef X1TURBO
wire x1t_cg_sel = I_PCG_TURBO & (crtc_hsync | hsync_d);
assign O_CGA = { txt_d, x1t_cg_sel ? I_A[3:1] : cg_line };
//`else
//assign O_CGA = { txt_d, cg_line };
//`endif

/****************************************************************************
  CG attribute effect
****************************************************************************/
wire col_rev = att_rev^(att_blink & I_CLK1);

wire cg_b = (att_pcg ? cgb_d[7] : cgg_d[7]) & att_b;
wire cg_r = (att_pcg ? cgr_d[7] : cgg_d[7]) & att_r;
wire cg_g = cgg_d[7] & att_g;

wire [2:0] cg_col = {cg_g,cg_r,cg_b} ^ {col_rev,col_rev,col_rev};
wire cg_trans = cg_col==3'b000;

/****************************************************************************
  GRAM palette / priority
****************************************************************************/
reg [7:0] PAL_B , PAL_R , PAL_G , PRIO_R;

always @(posedge I_CCLK or posedge I_RESET)
begin
  if(I_RESET)
  begin
    PAL_B  <= (DEBUG==1) ? 8'haa : 8'b0;
    PAL_R  <= (DEBUG==1) ? 8'hcc : 8'b0;
    PAL_G  <= (DEBUG==1) ? 8'hf0 : 8'b0;
    PRIO_R <= 8'h00;
  end else begin
    if(I_PAL_CS & I_WR)
    begin
      case(I_A[9:8])
      2'b00: PAL_B  <= (DEBUG==0) ? I_D : PAL_B;
      2'b01: PAL_R  <= (DEBUG==0) ? I_D : PAL_R;
      2'b10: PAL_G  <= (DEBUG==0) ? I_D : PAL_G;
      2'b11: PRIO_R <= I_D;
      endcase
    end
  end
end

// palette table
wire [2:0] gr_col = disp_d ? {grg_d[7],grr_d[7],grb_d[7]} : 3'b000;

//`ifdef BORDER_BLACK
//wire [2:0] gr_pal = disp_d ? {PAL_G[gr_col],PAL_R[gr_col],PAL_B[gr_col]} : 3'b000;
//`else
wire [2:0] gr_pal = {PAL_G[gr_col],PAL_R[gr_col],PAL_B[gr_col]};
//`endif
wire gr_sel = PRIO_R[gr_col] | cg_trans | ~disp_d;

// BLACK controll
//`ifdef X1TURBO
wire gr_black = (gr_col[2:1]==2'b00) & ((I_GR0_BLACK & ~gr_col[0]) | (I_GR1_BLACK & gr_col[0]));
wire cg_black = I_TXT_BLACK & (cg_col==I_BLACK_COL);
wire mx_black = ~disp_d ? I_BLK_BLACK : gr_sel ? gr_black : cg_black;
//`endif

/****************************************************************************
  video output mixer
****************************************************************************/
// VGA output mixer
//                   RIGHT SIDE: text 
//                   COLOR VER : area

//`ifdef X1TURBO
reg ym_r;
//`endif

reg [2:0] out_col;
always @(posedge I_VCLK)
begin
//`ifdef X1TURBO
  ym_r    <= mx_black;
  out_col <= mx_black ? 3'b000 : gr_sel ? gr_pal : cg_col;
//`else
//  out_col <= gr_sel ? gr_pal : cg_col;
//`endif
end

	assign O_B[7:0]=
			(DEBUG==0) & (disp_d==1'b1) & (out_col[0]==1'b1) ? 8'hff :
			(DEBUG==0) & (disp_d==1'b1) & (out_col[0]==1'b0) ? 8'h00 :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[0]==1'b1) ? 8'hff :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[0]==1'b0) ? 8'h3f :
			(DEBUG==1) & (disp_d==1'b0) ? 8'h1f :
			8'h0;
	assign O_R[7:0]=
			(DEBUG==0) & (disp_d==1'b1) & (out_col[1]==1'b1) ? 8'hff :
			(DEBUG==0) & (disp_d==1'b1) & (out_col[1]==1'b0) ? 8'h00 :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[1]==1'b1) ? 8'hff :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[1]==1'b0) ? 8'h3f :
			(DEBUG==1) & (disp_d==1'b0) ? 8'h1f :
			8'h0;
	assign O_G[7:0]=
			(DEBUG==0) & (disp_d==1'b1) & (out_col[2]==1'b1) ? 8'hff :
			(DEBUG==0) & (disp_d==1'b1) & (out_col[2]==1'b0) ? 8'h00 :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[2]==1'b1) ? 8'hff :
			(DEBUG==1) & (disp_d==1'b1) & (out_col[2]==1'b0) ? 8'h3f :
			(DEBUG==1) & (disp_d==1'b0) ? 8'h1f :
			8'h0;

//`ifdef X1TURBO
assign O_YM = ym_r;
//`endif

//`ifdef FAST_SQUE
assign O_HSYNC = crtc_hsync;
assign O_VSYNC = crtc_vsync;
//`else
//assign O_HSYNC = hsync_d;
//assign O_VSYNC = vsync_d;
//`endif
assign O_VDISP = vdisp;

/****************************************************************************
  CPU read data
****************************************************************************/
assign O_D  = 8'h00;
assign O_DE = 1'b0;
assign O_VWAIT = 1'b0; //!!!!!

endmodule
