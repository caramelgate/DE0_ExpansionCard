//------------------------------------------------------------------------------
//
//	crtc45e.v : 6845 fake module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/nov/28 release 0.0  
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
//	original copyright 
//
//--------------------------------------------------------------------------------------
// CRTC6845(HD46505) CORE 
//
// Version : beta 4
//
// Copyright(c) 2004 Katsumi Degawa , All rights reserved.
// Copyright(c) 2004 Tatsuyuki Satoh , All rights reserved.
//
// Important !
//
// This program is freeware for non-commercial use. 
// An author does no guarantee about this program.
// You can use this under your own risk. 
//
// VerilogHDL model of MC6845(HD46505) compatible CRTC.
// This was made for FPGA-GAME(ROCK-OLA). 
// Therefore. There is a limitation in the function. 
// 1. This doesn't implement interlace mode.
// 2. This doesn't implement light pen detection founction.
// 3. This doesn't implement cursor control founction.
//
// 4. This doesn't implement display sque (HD46505SP)
// 5. This doesn't support case Nht==0
//
// File History
//  2005. 4. 5  by T.satoh
//                bugfix port size mismatch
//  2005. 1.13  by T.satoh
//                bugfix VSYNC pulse width (line to raster)
//                bugfix NEXT_R_RA bit size mismatch.
//  2004.12. 9  by T.satoh
//                rewrite source with minimize code. (178 -> 119 slice to Spartan3 with Area optimize)
//                bugfix , bypass wite register 10H-1FH ( R_ADR width change 5bit from 4bit).
//                fix register mismatch width W_Nr,O_Nr,Nvt,Nvd and Nvsp.
//                change R_V_CNT width 9bit to 7bit.
//
//  2004.10.23  First release  
//--------------------------------------------------------------------------------------


//module crtc6845s #(

module crtc45e #(
	parameter	init_reg0=8'h00,		// 
	parameter	init_reg1=8'h28,		// horizontal displayed 80chr or 40chr
	parameter	init_reg2=8'h00,		// 
	parameter	init_reg3=8'h00,		// 
	parameter	init_reg5=8'h00,		// 
	parameter	init_reg6=7'h19,		// vetical displayed 25chr
	parameter	init_reg7=7'h00,		// 
	parameter	init_reg9=5'h07,		// caracter scan line 8 -1
	parameter	init_reg12=14'h0000		// memory address
) (
	input			EX_HDISP,			// in    [CRT] horizontal disp
	input			EX_VDISP,			// in    [CRT] vertical disp
	input			EX_HSAV,			// in    [CRT] horizontal sav
	input			EX_HEAV,			// in    [CRT] horizontal eav
	input			EX_HC,				// in    [CRT] horizontal countup
	input			EX_VSAV,			// in    [CRT] vertical sav
	input			EX_VEAV,			// in    [CRT] vertical eav
	input			EX_VC,				// in    [CRT] vertical countup

	input			I_CLK,				// in    [crtc] clk
	input			I_E,				// in    [crtc] cycle-e
	input	[7:0]	I_DI,				// in    [crtc] data in
	input			I_RS,				// in    [crtc] reg/addr
	input			I_RWn,				// in    [crtc] rd/#wr
	input			I_CSn,				// in    [crtc] #cs

	input			I_VCLK,				// in    [crtc] vclk
//	input			I_CKE,				// in    [crtc] cke
	input			I_RSTn,				// in    [crtc] #rst

//	output	[13:0]	cg_ma,				// out   [crtc] cg mem-addr

//	output			tp_hsav,
//	output			tp_heav,
//	output			tp_vsav,
//	output			tp_veav,
//	output			tp_exhs,
//	output			tp_exvs,
//	output			tp_ras,

	input			I_W40,				// in

	output			QA,
	output			QB,
	output			QC,
	output			QD,
	output			QP,

	output			vclk_cyc0,	// ma,ra load
	output			vclk_cyc1,	// attr latch
	output			vclk_cyc2,	// cg-addr load
	output			vclk_cyc3,	// chr latch
	output			vclk_cyc4,
	output			vclk_cyc5,
	output			vclk_cyc6,
	output			vclk_cyc7,	// 

	output	[4:0]	O_RA,				// out   [crtc] ras-addr
	output	[13:0]	O_MA,				// out   [crtc] mem-addr
	output			O_H_SYNC,			// out   [crtc] hdisp/#blank
	output			O_V_SYNC,			// out   [crtc] vdisp/#blank
	output			O_DISPTMG			// out   [crtc] disp/#blank
);

	wire	cpu_clk;
	wire	cpu_cyc_e;
	wire	[7:0] cpu_wdata;
	wire	cpu_a0;
	wire	cpu_wr_n;
	wire	cpu_cs_n;

	wire	v_clk;
	wire	v_cke;
	wire	v_rst_n;

	wire	[13:0] cg_mem_addr;
	wire	[4:0] ras_addr;
	wire	[13:0] mem_addr;
	wire	hsync_out;
	wire	vsync_out;
	wire	disp_out;

	assign cpu_clk=I_CLK;
	assign cpu_cyc_e=I_E;
	assign cpu_wdata[7:0]=I_DI[7:0];
	assign cpu_a0=I_RS;
	assign cpu_wr_n=I_RWn;
	assign cpu_cs_n=(I_CSn==1'b0) & (I_E==1'b1) ? 1'b0 : 1'b1 ;

	assign v_clk=I_VCLK;
	assign v_cke=vclk_cyc7;//I_CKE;
	assign v_rst_n=I_RSTn;

	reg		vclk_div_under_r;
	reg		[2:0] vclk_div_r;
	reg		[7:0] vclk_div_out_r;
	wire	vclk_div_under_w;
	wire	[2:0] vclk_div_w;
	wire	[7:0] vclk_div_out_w;

	always @(posedge v_clk or negedge v_rst_n)
	begin
		if (v_rst_n==1'b0)
			begin
				vclk_div_under_r <= 1'b0;
				vclk_div_r[2:0] <= 3'b0;
				vclk_div_out_r[7:0] <= 8'b0;
			end
		else
			begin
				vclk_div_under_r <= vclk_div_under_w;
				vclk_div_r[2:0] <= vclk_div_w[2:0];
				vclk_div_out_r[7:0] <= vclk_div_out_w[7:0];
			end
	end

	assign vclk_div_under_w=
			(EX_HSAV==1'b1) ? 1'b0 :
			(EX_HSAV==1'b0) & (I_W40==1'b0) ? 1'b1 :
			(EX_HSAV==1'b0) & (I_W40==1'b1) & (EX_HC==1'b1) ? !vclk_div_under_r :
			(EX_HSAV==1'b0) & (I_W40==1'b1) & (EX_HC==1'b0) ? vclk_div_under_r :
			1'b0;

	assign vclk_div_w[2:0]=
			(EX_HSAV==1'b1) ? 3'b0 :
			(EX_HSAV==1'b0) & (EX_HC==1'b1) & (vclk_div_under_r==1'b1) ? vclk_div_r[2:0]+3'b01 :
			(EX_HSAV==1'b0) & (EX_HC==1'b1) & (vclk_div_under_r==1'b0) ? vclk_div_r[2:0] :
			(EX_HSAV==1'b0) & (EX_HC==1'b0) ? vclk_div_r[2:0] :
			3'b0;

	assign vclk_div_out_w[7:0]=
			(EX_HDISP==1'b0) ? 8'b00000001 :
			(EX_HDISP==1'b1) &  ((EX_HC==1'b1) & (vclk_div_under_r==1'b1) & (vclk_div_r[2:0]==3'b111)) ? 8'b00000001 :
			(EX_HDISP==1'b1) & !((EX_HC==1'b1) & (vclk_div_under_r==1'b1) & (vclk_div_r[2:0]==3'b111)) ? {vclk_div_out_r[6:0],1'b0} :
			8'b00000001;

	assign QP = 1'b0;
	assign QA = 1'b1;
	assign QB = ~vclk_div_r[0];
	assign QC = ~vclk_div_r[1];
	assign QD = ~vclk_div_r[2];

	assign vclk_cyc0=vclk_div_out_r[0];
	assign vclk_cyc1=vclk_div_out_r[1];
	assign vclk_cyc2=vclk_div_out_r[2];
	assign vclk_cyc3=vclk_div_out_r[3];
	assign vclk_cyc4=vclk_div_out_r[4];
	assign vclk_cyc5=vclk_div_out_r[5];
	assign vclk_cyc6=vclk_div_out_r[6];
	assign vclk_cyc7=(vclk_div_r[2:0]==3'b111) & (EX_HC==1'b1) & (vclk_div_under_r==1'b1) ? 1'b1 : 1'b0;


//	assign cg_ma[13:0]=cg_mem_addr[13:0];
//	assign O_RA[4:0]=ras_addr[4:0];
//	assign O_MA[13:0]=mem_addr[13:0];
//	assign O_H_SYNC=hsync_out;
//	assign O_V_SYNC=vsync_out;
//	assign O_DISPTMG=disp_out;



	wire	W_Vmode;
	wire	W_IntSync;
	wire	[1:0] W_DScue;
	wire	[1:0] W_CScue;

	reg		[4:0] R_ADR;
	reg		[7:0] R_Nht;
	reg		[7:0] R_Nhd;
	reg		[7:0] R_Nhsp;
	reg		[7:0] R_Nsw;
	reg		[6:0] R_Nvt;
	reg		[4:0] R_Nadj;
	reg		[6:0] R_Nvd;
	reg		[6:0] R_Nvsp;
	reg		[7:0] R_Intr;
	reg		[4:0] R_Nr;
	reg		[13:0] R_Msa;

	assign W_VMode   =  R_Intr[1];
	assign W_IntSync =  R_Intr[0];
	assign W_DScue   = R_Intr[5:4]; // disp   scue 0,1,2 or OFF
	assign W_CScue   = R_Intr[7:6]; // cursor scue 0,1,2 or OFF

	always@(posedge cpu_clk or negedge v_rst_n)
	begin
		if (v_rst_n==1'b0)
			begin
				R_ADR <= 5'b0;
				R_Nht <= 8'b0;
				R_Nhd  <= init_reg1[7:0];
				R_Nhsp <= 8'b0;
				R_Nsw  <= 8'b0;
				R_Nvt  <= 7'b0;
				R_Nadj <= 5'b0;
				R_Nvd  <= init_reg6[6:0];
				R_Nvsp <= 7'b0;
				R_Intr <= 8'b0;
				R_Nr   <= init_reg9[4:0];
				R_Msa <= init_reg12[13:0];
			end
		else
			begin
				R_ADR <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b000) ? cpu_wdata[4:0] : R_ADR;
				R_Nht <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h00) ? cpu_wdata : R_Nht;
				R_Nhd  <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h01) ? cpu_wdata : R_Nhd;
				R_Nhsp <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h02) ? cpu_wdata : R_Nhsp;
				R_Nsw  <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h03) ? cpu_wdata : R_Nsw;
				R_Nvt  <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h04) ? cpu_wdata[6:0] : R_Nvt;
				R_Nadj <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h05) ? cpu_wdata[4:0] : R_Nadj;
				R_Nvd  <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h06) ? cpu_wdata[6:0] : R_Nvd;
				R_Nvsp <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h07) ? cpu_wdata[6:0] : R_Nvsp;
				R_Intr <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h08) ? cpu_wdata[7:0] : R_Intr;
				R_Nr   <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h09) ? cpu_wdata[4:0] : R_Nr;
				R_Msa[13:8] <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h0c) ? cpu_wdata[5:0] : R_Msa[13:8];
				R_Msa[7:0] <= ({cpu_cs_n,cpu_wr_n,cpu_a0}==3'b001) & (R_ADR==5'h0d) ? cpu_wdata : R_Msa[7:0];
			end
	end

	reg		[7:0] R_H_CNT;
	reg		[6:0] R_V_CNT;
	reg		[4:0] R_RA;
	reg		[13:0] R_MA;
	reg		R_DISPTMG;
	wire	[7:0] NEXT_R_H_CNT;
	wire	[6:0] NEXT_R_V_CNT;
	wire	[4:0] NEXT_R_RA;

	wire	W_RA_C;

	assign NEXT_R_H_CNT[7:0]=R_H_CNT[7:0]+8'h01;
	assign NEXT_R_V_CNT[6:0]=R_V_CNT[6:0]+7'h01;
	assign NEXT_R_RA[4:0]=R_RA[4:0]+5'b01;
	assign W_RA_C=(R_RA==R_Nr) ? 1'b1 : 1'b0;

	assign O_RA=R_RA;
	assign O_MA=R_MA;

	reg		[13:0] R_MA_C;

	wire	hsav;
	wire	heav;
	wire	hdisp;
	wire	hblank;
	wire	vsav;
	wire	veav;
	wire	vdisp;
	wire	vblank;

	reg		R_H_DISP;
	reg		R_V_DISP;
	wire	W_HDISP_clr;
	wire	W_VDISP_clr;

	assign W_HDISP_clr=(NEXT_R_H_CNT[7:0]==R_Nhd[7:0]) ? 1'b1 : 1'b0;
	assign W_VDISP_clr=(NEXT_R_V_CNT[6:0]==R_Nvd[6:0]) & (W_RA_C==1'b1) ? 1'b1 : 1'b0;

	assign hsav=EX_HSAV;
	assign heav=EX_HEAV;
	assign hdisp=EX_HDISP;
	assign hblank=!EX_HDISP;
	assign vsav=EX_VSAV;
	assign veav=EX_VEAV;
	assign vdisp=EX_VDISP;
	assign vblank=!EX_VDISP;

	wire	[13:0] R_MA_w;
	wire	[13:0] R_MA_C_w;
	wire	[7:0] R_H_CNT_w;
	wire	R_H_SYNC_w;
	wire	[4:0] R_RA_w;
	wire	R_V_SYNC_w;
	wire	[6:0] R_V_CNT_w;
	wire	R_DISPTMG_w;


//	assign tp_hsav=hsav;
//	assign tp_heav=heav;
//	assign tp_vsav=vsav;
//	assign tp_veav=veav;
//	assign tp_exhs=1'b0;//ex_hsync_req;
//	assign tp_exvs=1'b0;//ex_vsync_req;
//	assign tp_ras=W_RA_C;

	assign O_H_SYNC=!R_H_DISP;
	assign O_V_SYNC=!R_V_DISP;
	assign O_DISPTMG=R_DISPTMG;

	always@(posedge v_clk or negedge v_rst_n)
	begin
		if(v_rst_n==1'b0)
			begin
				R_MA   <= 14'h0000;
				R_MA_C <= 14'h0000;
				R_H_CNT <= 8'h00; 
				R_RA <= 5'h00; 
				R_V_CNT <= 7'h00; 
				R_H_DISP <= 1'b0;
				R_V_DISP <= 1'b0;
				R_DISPTMG   <= 1'b0;
			end
		else
			begin
				R_MA <= R_MA_w;
				R_MA_C <= R_MA_C_w;
				R_H_CNT <= R_H_CNT_w;
				R_H_DISP <= R_H_DISP_w;
				R_V_DISP <= R_V_DISP_w;
				R_RA <= R_RA_w;
				R_V_CNT <= R_V_CNT_w;
				R_DISPTMG <= R_DISPTMG_w;
			end
	end

	assign R_MA_w=
			(vsav==1'b1) ? R_Msa :
			(vsav==1'b0) & (hsav==1'b1) ? R_MA_C :
			(vsav==1'b0) & (hsav==1'b0) & (hdisp==1'b0) ? R_MA :
			(vsav==1'b0) & (hsav==1'b0) & (hdisp==1'b1) & (v_cke==1'b0) ? R_MA :
			(vsav==1'b0) & (hsav==1'b0) & (hdisp==1'b1) & (v_cke==1'b1) ? R_MA+14'b01 :
			R_MA;

	assign R_MA_C_w=
			(vsav==1'b1) ? R_Msa :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b1) & (W_RA_C==1'b1) ? R_MA_C+{5'b0,R_Nhd[7:0]} :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b1) & (W_RA_C==1'b0) ? R_MA_C :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b0) ? R_MA_C :
			(vsav==1'b0) & (EX_VC==1'b0) ? R_MA_C :
			R_MA_C;

	assign R_H_CNT_w=
			(hsav==1'b1) ? 8'b0 :
			(hsav==1'b0) & (hdisp==1'b0) ? R_H_CNT :
			(hsav==1'b0) & (hdisp==1'b1) & (v_cke==1'b0) ? R_H_CNT :
			(hsav==1'b0) & (hdisp==1'b1) & (v_cke==1'b1) ? NEXT_R_H_CNT :
			R_H_CNT;

	assign R_RA_w=
			(vsav==1'b1) ? 5'b0 :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b1) & (W_RA_C==1'b1) ? 5'b0 :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b1) & (W_RA_C==1'b0) ? NEXT_R_RA :
			(vsav==1'b0) & (EX_VC==1'b1) & (heav==1'b0) ? R_RA :
			(vsav==1'b0) & (EX_VC==1'b0) ? R_RA :
			R_RA;

	assign R_V_CNT_w=
			(vsav==1'b1) ? 7'b0 :
			(vsav==1'b0) & (EX_VC==1'b1) &  ((heav==1'b1) & (W_RA_C==1'b1)) ? NEXT_R_V_CNT :
			(vsav==1'b0) & (EX_VC==1'b1) & !((heav==1'b1) & (W_RA_C==1'b1)) ? R_V_CNT :
			(vsav==1'b0) & (EX_VC==1'b0) ? R_V_CNT :
			R_V_CNT;

	assign R_H_DISP_w=
			(hsav==1'b1) ? 1'b1 :
			(hsav==1'b0) & (heav==1'b1) ? 1'b0 :
			(hsav==1'b0) & (heav==1'b0) & (W_HDISP_clr==1'b1) & (v_cke==1'b0) ? R_H_DISP :
			(hsav==1'b0) & (heav==1'b0) & (W_HDISP_clr==1'b1) & (v_cke==1'b1) ? 1'b0 :
			(hsav==1'b0) & (heav==1'b0) & (W_HDISP_clr==1'b0) ? R_H_DISP :
			R_H_DISP;

	assign R_V_DISP_w=
			(vsav==1'b1) ? 1'b1 :
			(vsav==1'b0) & (veav==1'b1) ? 1'b0 :
			(vsav==1'b0) & (veav==1'b0) & (EX_VC==1'b1) & ({W_VDISP_clr,W_HDISP_clr}==2'b11) & (v_cke==1'b0) ? R_V_DISP :
			(vsav==1'b0) & (veav==1'b0) & (EX_VC==1'b1) & ({W_VDISP_clr,W_HDISP_clr}==2'b11) & (v_cke==1'b1) ? 1'b0 :
			(vsav==1'b0) & (veav==1'b0) & (EX_VC==1'b1) & ({W_VDISP_clr,W_HDISP_clr}!=2'b11) ? R_V_DISP :
			(vsav==1'b0) & (veav==1'b0) & (EX_VC==1'b0) ? R_V_DISP :
			R_V_DISP;

	assign R_DISPTMG_w=({R_V_DISP_w,R_H_DISP_w}==2'b11) ? 1'b1 : 1'b0;

endmodule
