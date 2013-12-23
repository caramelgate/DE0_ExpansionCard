//-----------------------------------------------------------------------------
//
//  gen_vdp.v : 25drv vdp module
//
//  LICENSE : as-is (same as fpgagen)
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/16 release 0.0  rewrite fpgagen module and connection test
//       dec/23 release 0.1  preview
//
//------------------------------------------------------------------------------
//
//  original and related project
//
//  fpgagen : fpgagen (googlecode) license new-bsd
//
//------------------------------------------------------------------------------

//`define debug_bgb_scroll
//`define debug_bgb_access
//`define debug_bgb_width

//`define debug_display

`define disp_scale

`define replace_dmastate
`define replace_cpuif
`define replace_hvtiming
`define replace_composite
//`define debug_composite_priority

`define replace_timing_virq
`define replace_timing_hirq
`define replace_timing_hvstat

`define replace_spr_search
`define replace_spr_render
`define spr_render_limit
`define spr_search_reload
//`define debug_spr_render_readback

`define replace_bgb_render
`define replace_bga_render

`define direct_bgb_render
`define direct_bga_render
`define direct_spr_render
`define direct_spr_search
`define direct_dma_access

// Converted from vdp.vhd
// by VHDL2Verilog ver1.00(2004/05/06)  Copyright(c) S.Morioka (http://www02.so-net.ne.jp/~morioka/v2v.htm)

// Copyright (c) 2010 Gregory Estrade (greg@torlus.com)
//
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// Redistributions in synthesized form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// Neither the name of the author nor the names of other contributors may
// be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Please report bugs to the author, but before you do so, please
// make sure that this is not a derivative work and that
// you have the latest version of this file.


module gen_vdp #(
	parameter	DEVICE=0,		// 0=xilinz , 1=altera
	parameter	disp_bga=1,
	parameter	disp_bgb=1,
	parameter	disp_spr=1
) (
	output	[15:0]	DEBUG_OUT,

	input			debug_sca,
	input			debug_scw,
	input			debug_scb,
	input			debug_spr,
	input			debug_dma,

	output	[2:0]	debug_lsm,

	input			RST_N,
	input			CLK,
	input			SEL,
	input	[4:0]	A,
	input			RNW,
	input			UDS_N,
	input			LDS_N,
	input	[15:0]	DI,
	output	[15:0]	DO,
	output			DTACK_N,

	output	[31:0]	VRAM32_ADDR,
	output			VRAM32_REQ,
	output	[3:0]	VRAM32_BE,
	input	[31:0]	VRAM32_RDATA,
	output	[31:0]	VRAM32_WDATA,
	output			VRAM32_WR,
	input			VRAM32_ACK,

	output	[31:0]	VD_ADDR,
	output			VD_REQ,
	output	[3:0]	VD_BE,
	input	[31:0]	VD_RDATA,
	output	[31:0]	VD_WDATA,
	output			VD_WR,
	input			VD_ACK,

	output	[31:0]	V0_ADDR,
	output			V0_REQ,
	output	[3:0]	V0_BE,
	input	[31:0]	V0_RDATA,
	output	[31:0]	V0_WDATA,
	output			V0_WR,
	input			V0_ACK,

	output	[31:0]	V1_ADDR,
	output			V1_REQ,
	output	[3:0]	V1_BE,
	input	[31:0]	V1_RDATA,
	output	[31:0]	V1_WDATA,
	output			V1_WR,
	input			V1_ACK,

	output	[31:0]	V2_ADDR,
	output			V2_REQ,
	output	[3:0]	V2_BE,
	input	[31:0]	V2_RDATA,
	output	[31:0]	V2_WDATA,
	output			V2_WR,
	input			V2_ACK,

	output	[31:0]	V3_ADDR,
	output			V3_REQ,
	output	[3:0]	V3_BE,
	input	[31:0]	V3_RDATA,
	output	[31:0]	V3_WDATA,
	output			V3_WR,
	input			V3_ACK,

	output			HINT,
	input			HINT_ACK,
	output			VINT_TG68,
	output			VINT_T80,
	input			VINT_TG68_ACK,
	input			VINT_T80_ACK,

	output			VBUS_DMA_REQ,
	input			VBUS_DMA_ACK,
	output	[23:0]	VBUS_ADDR,
	output			VBUS_UDS_N,
	output			VBUS_LDS_N,
	input	[15:0]	VBUS_DATA,
	output			VBUS_SEL,
	input			VBUS_DTACK_N,

	output	[7:0]	VGA_R,
	output	[7:0]	VGA_G,
	output	[7:0]	VGA_B,
	output			VGA_HS,
	output			VGA_VS,
	output			VGA_DE,
	output			VGA_CLK
);

//	720x480p clk=27MHz
//	720 736 798 858 480 489 495 525 -h -v
//	0- 0-720- 0-16-62-60
//	640 776 838 858 480 489 495 525 -h -v
//	0-40-640-40-16-62-60
//       640-   56-62-100

	localparam VGA_PER_LINE= 858*2;
	localparam VGA_HS_CLOCKS= 62*2;
	localparam VGA_DE_DISP= 640*2;
	localparam VGA_DE_START= 178*2;
	localparam VGA_VS_LINES= 6;
	localparam VGA_LINES= 525;			// 525  up,54MHz
	localparam VGA_V_DISP_START= 36;
	localparam NTSC_CLOCKS_PER_LINE= 3432;
	localparam NTSC_H_DISP_CLOCKS= 2560;
	localparam NTSC_H_DISP_START= 488;
	localparam NTSC_H_REND_START= 128;
	localparam NTSC_H_REND_ABORT=NTSC_CLOCKS_PER_LINE -128;
//	localparam NTSC_H_REND_ABORT=NTSC_H_REND_START+NTSC_H_DISP_CLOCKS;
	localparam NTSC_LINES= 262;
	localparam NTSC_V_DISP_START= 18;

//	localparam NTSC_CLOCKS_PER_LINE= 3420;
//	localparam NTSC_H_DISP_CLOCKS= 2560;
//	localparam NTSC_H_DISP_START= 580;
//	localparam VGA_HS_CLOCKS= 204;	// 3.77 us
//	localparam VGA_VS_LINES= 1;		// 0.06 ms
//	localparam NTSC_LINES= 262;
//	localparam NTSC_V_DISP_START= 16;

	//--------------------------------------------------------------
	// ON-CHIP RAMS
	//--------------------------------------------------------------

	wire	CRAM_WE;
	wire	[8:0] CRAM_WADDR;
	wire	[8:0] CRAM_WDATA;
	wire	[8:0] CRAM_QDATA;
	wire	[8:0] CRAM_RADDR;
	wire	[8:0] CRAM_RDATA;

	wire	VSRAM0_WE;
	wire	[8:0] VSRAM0_WADDR;
	wire	[17:0] VSRAM0_WDATA;
	wire	[17:0] VSRAM0_QDATA;
	wire	[8:0] VSRAM0_RADDR;
	wire	[17:0] VSRAM0_RDATA;

	wire	VSRAM1_WE;
	wire	[8:0] VSRAM1_WADDR;
	wire	[17:0] VSRAM1_WDATA;
	wire	[17:0] VSRAM1_QDATA;
	wire	[8:0] VSRAM1_RADDR;
	wire	[17:0] VSRAM1_RDATA;

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v7_1_dp512x9 cram_512x9(
	.clka(!CLK),
	.ena(1'b1),
	.wea(CRAM_WE),
	.addra(CRAM_WADDR[8:0]),
	.dina(CRAM_WDATA[8:0]),
	.douta(CRAM_QDATA[8:0]),
	.clkb(!CLK),
	.enb(1'b1),
	.web(1'b0),
	.addrb(CRAM_RADDR[8:0]),
	.dinb(9'b0),
	.doutb(CRAM_RDATA[8:0])
);

xil_blk_mem_gen_v7_1_dp512x18 vsram0_512x18(
	.clka(!CLK),
	.ena(1'b1),
	.wea({VSRAM0_WE,VSRAM0_WE}),
	.addra(VSRAM0_WADDR[8:0]),
	.dina(VSRAM0_WDATA[17:0]),
	.douta(VSRAM0_QDATA[17:0]),
	.clkb(!CLK),
	.enb(1'b1),
	.web(1'b0),
	.addrb(VSRAM0_RADDR[8:0]),
	.dinb(18'b0),
	.doutb(VSRAM0_RDATA[17:0])
);

xil_blk_mem_gen_v7_1_dp512x18 vsram1_512x18(
	.clka(!CLK),
	.ena(1'b1),
	.wea({VSRAM1_WE,VSRAM1_WE}),
	.addra(VSRAM1_WADDR[8:0]),
	.dina(VSRAM1_WDATA[17:0]),
	.douta(VSRAM1_QDATA[17:0]),
	.clkb(!CLK),
	.enb(1'b1),
	.web(1'b0),
	.addrb(VSRAM1_RADDR[8:0]),
	.dinb(18'b0),
	.doutb(VSRAM1_RDATA[17:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_dp512x9 cram_512x9(
	.address_a(CRAM_WADDR[8:0]),
	.address_b(CRAM_RADDR[8:0]),
	.clock(!CLK),
	.data_a(CRAM_WDATA[8:0]),
	.data_b(9'b0),
	.wren_a(CRAM_WE),
	.wren_b(1'b0),
	.q_a(CRAM_QDATA[8:0]),
	.q_b(CRAM_RDATA[8:0])
);

alt_altsyncram_dp512x18 vsram0_512x18(
	.address_a(VSRAM0_WADDR[8:0]),
	.address_b(VSRAM0_RADDR[8:0]),
	.byteena_a(2'b11),
	.byteena_b(2'b11),
	.clock(!CLK),
	.data_a(VSRAM0_WDATA[17:0]),
	.data_b(18'b0),
	.wren_a(VSRAM0_WE),
	.wren_b(1'b0),
	.q_a(VSRAM0_QDATA[17:0]),
	.q_b(VSRAM0_RDATA[17:0])
);

alt_altsyncram_dp512x18 vsram1_512x18(
	.address_a(VSRAM1_WADDR[8:0]),
	.address_b(VSRAM1_RADDR[8:0]),
	.byteena_a(2'b11),
	.byteena_b(2'b11),
	.clock(!CLK),
	.data_a(VSRAM1_WDATA[17:0]),
	.data_b(18'b0),
	.wren_a(VSRAM1_WE),
	.wren_b(1'b0),
	.q_a(VSRAM1_QDATA[17:0]),
	.q_b(VSRAM1_RDATA[17:0])
);

end
endgenerate

	//--------------------------------------------------------------
	// CPU INTERFACE
	//--------------------------------------------------------------
	reg 			FF_DTACK_N;
	reg 	[15:0]	FF_DO;

	reg 	[7:0]	REG0;
	reg 	[7:0]	REG1;
	reg 	[7:0]	REG2;
	reg 	[7:0]	REG3;
	reg 	[7:0]	REG4;
	reg 	[7:0]	REG5;
	reg 	[7:0]	REG6;
	reg 	[7:0]	REG7;
	reg 	[7:0]	REG8;
	reg 	[7:0]	REG9;
	reg 	[7:0]	REG10;
	reg 	[7:0]	REG11;
	reg 	[7:0]	REG12;
	reg 	[7:0]	REG13;
	reg 	[7:0]	REG14;
	reg 	[7:0]	REG15;
	reg 	[7:0]	REG16;
	reg 	[7:0]	REG17;
	reg 	[7:0]	REG18;
	reg 	[7:0]	REG19;
	reg 	[7:0]	REG20;
	reg 	[7:0]	REG21;
	reg 	[7:0]	REG22;
	reg 	[7:0]	REG23;
	reg 	[7:0]	REG24;
	reg 	[7:0]	REG25;
	reg 	[7:0]	REG26;
	reg 	[7:0]	REG27;
	reg 	[7:0]	REG28;
	reg 	[7:0]	REG29;
	reg 	[7:0]	REG30;
	reg 	[7:0]	REG31;
	reg 			PENDING;
	reg 	[15:0]	ADDR_LATCH;
	reg 	[15:0]	REG_LATCH;
	reg 	[5:0]	CODE;

	reg 	[35:0]	FIFO_DATA0;
	reg 	[35:0]	FIFO_DATA1;
	reg 	[35:0]	FIFO_DATA2;
	reg 	[35:0]	FIFO_DATA3;

	reg 	[1:0]	FIFO_WR_POS;
	reg 	[1:0]	FIFO_RD_POS;
	reg 			FIFO_EMPTY;
	reg 			FIFO_FULL;

	wire			IN_DMA;
	reg 			IN_HBL;
	reg 			IN_VBL;

	reg 			SOVR;
	reg 			SOVR_SET;
	reg 			SOVR_CLR;

	reg 			SCOL;
	reg 			SCOL_SET;
	reg 			SCOL_CLR;

	//--------------------------------------------------------------
	// INTERRUPTS
	//--------------------------------------------------------------
	reg 	[7:0]	HINT_COUNT;
	reg 			HINT_PENDING;
	reg 			HINT_PENDING_SET;
	reg 			HINT_FF;

	reg 			VINT_TG68_PENDING;
	reg 			VINT_TG68_PENDING_SET;
	reg 			VINT_TG68_FF;

	reg 			VINT_T80_SET;
	reg 			VINT_T80_CLR;
	reg 			VINT_T80_FF;

	//--------------------------------------------------------------
	// REGISTERS
	//--------------------------------------------------------------
	wire	DISP;
	wire	BLANK;
	wire	LINE_DISP;

	wire			H40;
	wire			V30;

	wire			RS1;
	wire			RS0;

	wire	[7:0]	ADDR_STEP;

	wire	[1:0]	HSCR;
	wire	[1:0]	HSIZE;
	wire	[1:0]	VSIZE;
	wire			VSCR;

	wire	[4:0]	WVP;
	wire			WDOWN;
	wire	[4:0]	WHP;
	wire			WRIGT;

	wire	[5:0]	BGCOL;

	wire	[7:0]	HIT;
	wire			IE2;
	wire			IE1;
	wire			M3;
	wire			M1;
	wire			M2;
	wire			IE0;

	wire			DMA;

	wire	[1:0]	LSM;
	wire			ODD;
	wire			STEN;

	wire	[15:0]	HV;
	wire	[15:0]	STATUS;

	// Base addresses
	wire	[5:0]	HSCB;
	wire	[2:0]	NTBB;
	wire	[4:0]	NTWB;
	wire	[2:0]	NTAB;
	wire	[6:0]	SATB;

	//--------------------------------------------------------------
	// DATA TRANSFER CONTROLLER
	//--------------------------------------------------------------
	reg 			DT_ACTIVE;

	localparam DTC_IDLE				= 0;
	localparam DTC_FIFO_RD			= 1;
	localparam DTC_VRAM_WR1			= 2;
	localparam DTC_VRAM_WR2			= 3;
	localparam DTC_CRAM_WR			= 4;
	localparam DTC_VSRAM_WR			= 5;
	localparam DTC_VSRAM_WR2			= 31;
	localparam DTC_VRAM_RD1			= 6;
	localparam DTC_VRAM_RD2			= 7;
	localparam DTC_CRAM_RD			= 8;
	localparam DTC_CRAM_RD1			= 29;
	localparam DTC_VSRAM_RD			= 9;
	localparam DTC_VSRAM_RD1			= 30;
	localparam DTC_DMA_FILL_INIT		= 10;
	localparam DTC_DMA_FILL_WR		= 11;
	localparam DTC_DMA_FILL_WR2		= 12;
	localparam DTC_DMA_FILL_LOOP		= 13;
	localparam DTC_DMA_COPY_INIT		= 14;
	localparam DTC_DMA_COPY_RD		= 15;
	localparam DTC_DMA_COPY_RD2		= 16;
	localparam DTC_DMA_COPY_WR		= 17;
	localparam DTC_DMA_COPY_WR2		= 18;
	localparam DTC_DMA_COPY_LOOP		= 19;
	localparam DTC_DMA_VBUS_INIT		= 20;
	localparam DTC_DMA_VBUS_RD		= 21;
	localparam DTC_DMA_VBUS_RD2		= 22;
	localparam DTC_DMA_VBUS_SEL		= 23;
	localparam DTC_DMA_VBUS_CRAM_WR	= 24;
	localparam DTC_DMA_VBUS_VSRAM_WR	= 25;
	localparam DTC_DMA_VBUS_VRAM_WR1	= 26;
	localparam DTC_DMA_VBUS_VRAM_WR2	= 27;
	localparam DTC_DMA_VBUS_LOOP		= 28;
	reg 	[28:0]	DTC;

	wire	[31:0]	VRAM_ADDR;
	wire			VRAM_CE_N;
	wire	[1:0]	VRAM_BE_N;
	wire	[15:0]	VRAM_DO;
	wire	[31:0]	VRAM32_DO;
	wire	[15:0]	VRAM_DI;
	wire			VRAM_OE_N;
	wire			VRAM_WE_N;

	wire			VRAM_SEL;
	wire			VRAM_DTACK_N;

	reg 			DT_VRAM_SEL;
	reg 	[15:0]	DT_VRAM_ADDR;
	reg 	[15:0]	DT_VRAM_DI;
	reg 			DT_VRAM_RNW;
	reg 			DT_VRAM_UDS_N;
	reg 			DT_VRAM_LDS_N;

	reg 	[15:0]	DT_WR_ADDR;
	reg 	[15:0]	DT_WR_DATA;
	reg	 	[2:0]	DT_WR_CODE;
	reg				DT_WR_SIZE;

	reg 	[15:0]	DT_FF_DATA;
	reg 	[2:0]	DT_FF_CODE;
	reg 			DT_FF_SIZE;
	reg 			DT_FF_SEL;
	reg 			DT_FF_DTACK_N;

	reg 	[15:0]	DT_RD_DATA;
	reg 	[3:0]	DT_RD_CODE;
	reg 			DT_RD_SEL;
	reg 			DT_RD_DTACK_N;

	reg 	[15:0]	ADDR;
	reg 			ADDR_SET_REQ;
	reg 			ADDR_SET_ACK;
	reg 			REG_SET_REQ;
	reg 			REG_SET_ACK;

	reg 	[15:0]	DT_DMAF_DATA;
	reg 	[15:0]	DT_DMAV_DATA;
	reg 			DMAF_SET_REQ;
	reg 			DMAF_SET_ACK;


	reg 			FF_VBUS_DMA_REQ;
	reg 	[23:0]	FF_VBUS_ADDR;
	reg 			FF_VBUS_UDS_N;
	reg 			FF_VBUS_LDS_N;
	reg 			FF_VBUS_SEL;

	reg 			DMA_VBUS;
	reg 			DMA_FILL_PRE;
	reg 			DMA_FILL;
	reg 			DMA_COPY;

	reg 	[15:0]	DMA_LENGTH;
	reg 	[15:0]	DMA_SOURCE;

	//--------------------------------------------------------------
	// VIDEO COUNTING
	//--------------------------------------------------------------
	reg 	[11:0]	H_CNT;
	reg 	H_CNT_LOAD;
	reg 	[10:0]	H_VGA_CNT;
	reg 	[24:0]	H_DE_CNT;
	reg 	[9:0]	V_CNT;

	reg 			V_ACTIVE;
//	reg 	[7:0]	POS_Y;

	reg 			SPR_V_ACTIVE;
	reg 			PRE_V_ACTIVE;
	reg 	[9:0]	PRE_Y;
	reg 	[9:0]	PRE_V_COUNT;

	reg 			FIELD;

	reg 	[8:0]	POS_X;
	reg 	[8:0]	POS_X_WR;
	reg				POS_X_REQ;
	reg 	[7:0]	PIXDIV;

	reg 			DISP_ACTIVE;

	// HV COUNTERS
	reg 	[3:0]	HV_PIXDIV;
	reg 	[8:0]	HV_HCNT;
	reg 	[9:0]	HV_VCNT;

	//--------------------------------------------------------------
	// BACKGROUND RENDERING
	//--------------------------------------------------------------
	reg 			BGEN_ACTIVE;

	localparam BGBC_INIT			= 0;
	localparam BGBC_HS_RD		= 1;
	localparam BGBC_CALC_Y		= 2;
	localparam BGBC_CALC_BASE	= 3;
	localparam BGBC_BASE_RD		= 4;
	localparam BGBC_BASE_RD1		= 5;
	localparam BGBC_LOOP			= 6;
	localparam BGBC_TILE		= 7;
	localparam BGBC_TILE_RD		= 8;
	localparam BGBC_DONE			= 9;
	reg 	[8:0]	BGBC;

	reg 	[9:0]	BGB_X;
	reg 	[9:0]	BGB_POS;
	reg 			BGB_POS_OVER;
	reg 	[9:0]	BGB_Y;
	reg 			T_BGB_PRI;
	reg 	[1:0]	T_BGB_PAL;
	wire	[3:0]	T_BGB_COLNO;
	wire	[15:0]	BGB_BASE;
	reg 	[15:0]	BGB_TILEBASE;
	reg 			BGB_HF;

	reg 	[15:0]	BGB_VRAM_ADDR;
	reg 			BGB_SEL;

	localparam BGAC_INIT			= 0;
	localparam BGAC_HS_RD		= 1;
	localparam BGAC_CALC_Y		= 2;
	localparam BGAC_CALC_BASE	= 3;
	localparam BGAC_BASE_RD		= 4;
	localparam BGAC_BASE_RD1		= 5;
	localparam BGAC_LOOP			= 6;
	localparam BGAC_TILE		= 7;
	localparam BGAC_TILE_RD		= 8;
	localparam BGAC_DONE			= 9;
	reg 	[7:0]	BGAC;

	reg 	[9:0]	BGA_X;
	reg 	[9:0]	BGA_POS;
	reg 	BGA_POS_OVER;
	reg 	[9:0]	BGA_Y;
	reg 			T_BGA_PRI;
	reg 	[1:0]	T_BGA_PAL;
	wire	[3:0]	T_BGA_COLNO;
	wire	[15:0]	BGA_BASE;
	reg 	[15:0]	BGA_TILEBASE;
	reg 			BGA_HF;

	reg 	[15:0]	BGA_VRAM_ADDR;
	reg 			BGA_SEL;

	reg 			WIN_V;
	reg 			WIN_H;

	//--------------------------------------------------------------
	// SPRITE ENGINE
	//--------------------------------------------------------------

	reg 			SP1E_ACTIVE;

	reg 	[7:0]	SP1_X;

	reg 	[15:0]	SP1_VRAM_ADDR;
	reg 			SP1_SEL;

//	reg 	[6:0]	OBJ_CUR;

	reg 			SP2E_ACTIVE;

	localparam SP2C_INIT			= 0;
	localparam SP2C_Y_RD			= 1;
	localparam SP2C_Y_RD2		= 2;
	localparam SP2C_Y_RD3		= 3;
	localparam SP2C_Y_RD4		= 4;
	localparam SP2C_Y_TST		= 5;
	localparam SP2C_SHOW			= 6;
	localparam SP2C_X_RD			= 7;
	localparam SP2C_X_TST		= 8;
	localparam SP2C_TDEF_RD		= 9;
	localparam SP2C_CALC_XY		= 10;
	localparam SP2C_CALC_BASE	= 11;
	localparam SP2C_LOOP			= 12;
	localparam SP2C_LOOP2			= 18;
	localparam SP2C_PLOT			= 13;
	localparam SP2C_TILE_RD		= 14;
	localparam SP2C_TILE_RD2		= 17;
	localparam SP2C_NEXT			= 15;
	localparam SP2C_DONE			= 16;
	reg 	[16:0]	SP2C;

	reg 	[7:0]	SP2_Y;

	reg 	[15:0]	SP2_VRAM_ADDR;
	reg 			SP2_SEL;

	reg 	[6:0]	OBJ_TOT;
	reg 			OBJ_TOT_OVER;
//	reg 	[6:0]	OBJ_NEXT;
	reg 	[6:0]	OBJ_NB;
	reg 			OBJ_NB_OVER;
	reg 	[8:0]	OBJ_PIX;
	reg 			OBJ_PIX_OVER;

	reg 	[9:0]	OBJ_Y;
	reg 	[9:0]	OBJ_Y_OFS;
	wire	[1:0]	T_OBJ_HS;
	wire	[1:0]	T_OBJ_VS;
	reg 	[6:0]	OBJ_LINK;
	reg 			OBJ_LINK_OVER;

	reg 	[1:0]	OBJ_HS;
	reg 	[1:0]	OBJ_VS;
	reg 	[9:0]	OBJ_X;
	reg 			OBJ_X_OVER;
	reg 	[4:0]	OBJ_X_OFS;
	reg 	[4:0]	OBJ_X_OFS_COUNT;
	reg 			OBJ_PRI;
	reg 	[1:0]	OBJ_PAL;
	reg 			OBJ_VF;
	reg 			OBJ_HF;
	reg 	[10:0]	OBJ_PAT;
	reg 	[9:0]	OBJ_POS;
	reg 	[15:0]	OBJ_TILEBASE;
	reg 	[3:0]	OBJ_COLNO;
	wire	[6:0]	T_PREV_OBJ_COLINFO;

	//--------------------------------------------------------------
	// VIDEO OUTPUT
	//--------------------------------------------------------------

	reg		[7:0]	T_COLINFO;
	reg		[15:0]	T_COLOR;

	reg 	[7:0]	FF_VGA_R;
	reg 	[7:0]	FF_VGA_G;
	reg 	[7:0]	FF_VGA_B;
	reg 	[7:0]	FF_VGA_HS;
	reg 	[7:0]	FF_VGA_VS;
	reg 			FF_VGA_VDE;
	reg 	[7:0]	FF_VGA_DE;
	reg 	[7:0]	FF_VGA_CLK;

	reg 	[3:0]	FF_R;
	reg 	[3:0]	FF_G;
	reg 	[3:0]	FF_B;


	reg 	[31:0]	OBJ_Y_D;
	wire 	[8:0]	OBJ_Y_ADDR_RD;
	reg 	[8:0]	OBJ_Y_ADDR_WR;
	reg 			OBJ_Y_WE;
	wire	[15:0]	OBJ_Y_Q;

	reg 	[31:0]	OBJ_X_D;
	reg 			OBJ_X_WE;
	wire	[31:0]	OBJ_X_Q;

	reg 	[15:0]	OBJ_SZ_LINK_D;
	reg 	[8:0]	OBJ_SZ_LINK_ADDR_RD;
	reg 	[8:0]	OBJ_SZ_LINK_ADDR_WR;
	reg 			OBJ_SZ_LINK_WE;
	wire	[15:0]	OBJ_SZ_LINK_Q;

	reg 	[8:0]	BGB_COLINFO_ADDR_A;
	wire 	[8:0]	BGB_COLINFO_ADDR_B;
	reg 	[6:0]	BGB_COLINFO_D_A;
	reg 			BGB_COLINFO_WE_A;
	reg 			BGB_COLINFO_WE_A0;
	reg 			BGB_COLINFO_WE_A1;
	wire 			BGB_COLINFO_RD_B0;
//	wire	[9:0]	BGB_COLINFO_Q_B;

	reg 	[8:0]	BGA_COLINFO_ADDR_A;
	wire 	[8:0]	BGA_COLINFO_ADDR_B;
	reg 	[6:0]	BGA_COLINFO_D_A;
	reg 			BGA_COLINFO_WE_A;
	reg 			BGA_COLINFO_WE_A0;
	reg 			BGA_COLINFO_WE_A1;
	wire 			BGA_COLINFO_RD_B0;
//	wire	[9:0]	BGA_COLINFO_Q_B;

	reg 	[9:0]	OBJ_COLINFO_ADDR_A;
	wire 	[8:0]	OBJ_COLINFO_ADDR_B;
	reg 	[6:0]	OBJ_COLINFO_D_A;
	reg 			OBJ_COLINFO_WE_A;
	reg 			OBJ_COLINFO_WE_B;
	wire 			OBJ_COLINFO_RD_A0;
	wire 			OBJ_COLINFO_RD_B0;
	wire	[8:0]	OBJ_COLINFO_Q_A0;
	wire	[8:0]	OBJ_COLINFO_Q_A1;
//	wire	[9:0]	OBJ_COLINFO_Q_B;

	wire 	[8:0]	BGB_COLINFO_WDATA_A;
	wire 	[8:0]	BGB_COLINFO_RDATA_B0;
	wire 	[8:0]	BGB_COLINFO_RDATA_B1;

	assign BGB_COLINFO_WDATA_A[7]=(BGB_COLINFO_D_A[3:0]!=4'h0) ? 1'b1 : 1'b0;
	assign BGB_COLINFO_WDATA_A[8]=1'b0;
	assign BGB_COLINFO_WDATA_A[5:0]=BGB_COLINFO_D_A[5:0];
	assign BGB_COLINFO_WDATA_A[6]=(BGB_COLINFO_D_A[3:0]!=4'h0) & (BGB_COLINFO_D_A[6]==1'b1) ? 1'b1 : 1'b0;

	wire 	[8:0]	BGA_COLINFO_WDATA_A;
	wire 	[8:0]	BGA_COLINFO_RDATA_B0;
	wire 	[8:0]	BGA_COLINFO_RDATA_B1;

	assign BGA_COLINFO_WDATA_A[7]=(BGA_COLINFO_D_A[3:0]!=4'h0) ? 1'b1 : 1'b0;
	assign BGA_COLINFO_WDATA_A[8]=1'b0;
	assign BGA_COLINFO_WDATA_A[5:0]=BGA_COLINFO_D_A[5:0];
	assign BGA_COLINFO_WDATA_A[6]=(BGA_COLINFO_D_A[3:0]!=4'h0) & (BGA_COLINFO_D_A[6]==1'b1) ? 1'b1 : 1'b0;

	reg 			OBJ_COLINFO_WE_A0;
	reg 			OBJ_COLINFO_WE_B0;
	reg 			OBJ_COLINFO_WE_A1;
	reg 			OBJ_COLINFO_WE_B1;

	wire 	[8:0]	OBJ_COLINFO_WDATA_A;
	wire 	[8:0]	OBJ_COLINFO_RDATA_B0;
	wire 	[8:0]	OBJ_COLINFO_RDATA_B1;

	assign OBJ_COLINFO_WDATA_A[7]=(OBJ_COLINFO_D_A[3:0]!=4'h0) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_WDATA_A[8]=1'b0;
	assign OBJ_COLINFO_WDATA_A[6:0]=OBJ_COLINFO_D_A[6:0];

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v7_1_dp512x9 bgb_ci0(
	.clka(CLK),
	.ena(1'b1),
	.wea(BGB_COLINFO_WE_A0),
	.addra(BGB_COLINFO_ADDR_A[8:0]),
	.dina(BGB_COLINFO_WDATA_A[8:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B0),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(BGB_COLINFO_RDATA_B0[8:0])
);

xil_blk_mem_gen_v7_1_dp512x9 bgb_ci1(
	.clka(CLK),
	.ena(1'b1),
	.wea(BGB_COLINFO_WE_A1),
	.addra(BGB_COLINFO_ADDR_A[8:0]),
	.dina(BGB_COLINFO_WDATA_A[8:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B1),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(BGB_COLINFO_RDATA_B1[8:0])
);

xil_blk_mem_gen_v7_1_dp512x9 bga_ci0(
	.clka(CLK),
	.ena(1'b1),
	.wea(BGA_COLINFO_WE_A0),
	.addra(BGA_COLINFO_ADDR_A[8:0]),
	.dina(BGA_COLINFO_WDATA_A[8:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B0),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(BGA_COLINFO_RDATA_B0[8:0])
);

xil_blk_mem_gen_v7_1_dp512x9 bga_ci1(
	.clka(CLK),
	.ena(1'b1),
	.wea(BGA_COLINFO_WE_A1),
	.addra(BGA_COLINFO_ADDR_A[8:0]),
	.dina(BGA_COLINFO_WDATA_A[8:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B1),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(BGA_COLINFO_RDATA_B1[8:0])
);

xil_blk_mem_gen_v7_1_dp512x9 obj_ci0(
	.clka(CLK),
	.ena(1'b1),
	.wea(OBJ_COLINFO_WE_A0),
	.addra(OBJ_COLINFO_ADDR_A[8:0]),
	.dina(OBJ_COLINFO_WDATA_A[8:0]),
	.douta(OBJ_COLINFO_Q_A0[8:0]),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B0),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(OBJ_COLINFO_RDATA_B0[8:0])
);

xil_blk_mem_gen_v7_1_dp512x9 obj_ci1(
	.clka(CLK),
	.ena(1'b1),
	.wea(OBJ_COLINFO_WE_A1),
	.addra(OBJ_COLINFO_ADDR_A[8:0]),
	.dina(OBJ_COLINFO_WDATA_A[8:0]),
	.douta(OBJ_COLINFO_Q_A1[8:0]),
	.clkb(CLK),
	.enb(1'b1),
	.web(OBJ_COLINFO_WE_B1),
	.addrb(OBJ_COLINFO_ADDR_B[8:0]),
	.dinb(9'b0),
	.doutb(OBJ_COLINFO_RDATA_B1[8:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_dp512x9 bgb_ci0(
	.address_a(BGB_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(BGB_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(BGB_COLINFO_WE_A0),
	.wren_b(OBJ_COLINFO_WE_B0),
	.q_a(),
	.q_b(BGB_COLINFO_RDATA_B0[8:0])
);

alt_altsyncram_dp512x9 bgb_ci1(
	.address_a(BGB_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(BGB_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(BGB_COLINFO_WE_A1),
	.wren_b(OBJ_COLINFO_WE_B1),
	.q_a(),
	.q_b(BGB_COLINFO_RDATA_B1[8:0])
);

alt_altsyncram_dp512x9 bga_ci0(
	.address_a(BGA_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(BGA_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(BGA_COLINFO_WE_A0),
	.wren_b(OBJ_COLINFO_WE_B0),
	.q_a(),
	.q_b(BGA_COLINFO_RDATA_B0[8:0])
);

alt_altsyncram_dp512x9 bga_ci1(
	.address_a(BGA_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(BGA_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(BGA_COLINFO_WE_A1),
	.wren_b(OBJ_COLINFO_WE_B1),
	.q_a(),
	.q_b(BGA_COLINFO_RDATA_B1[8:0])
);

alt_altsyncram_dp512x9 obj_ci0(
	.address_a(OBJ_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(OBJ_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(OBJ_COLINFO_WE_A0),
	.wren_b(OBJ_COLINFO_WE_B0),
	.q_a(OBJ_COLINFO_Q_A0[8:0]),
	.q_b(OBJ_COLINFO_RDATA_B0[8:0])
);

alt_altsyncram_dp512x9 obj_ci1(
	.address_a(OBJ_COLINFO_ADDR_A[8:0]),
	.address_b(OBJ_COLINFO_ADDR_B[8:0]),
	.clock(CLK),
	.data_a(OBJ_COLINFO_WDATA_A[8:0]),
	.data_b(9'b0),
	.wren_a(OBJ_COLINFO_WE_A1),
	.wren_b(OBJ_COLINFO_WE_B1),
	.q_a(OBJ_COLINFO_Q_A1[8:0]),
	.q_b(OBJ_COLINFO_RDATA_B1[8:0])
);

end
endgenerate

	wire	[31:0] OBJ_Y_RDATA;
	wire	[31:0] OBJ_X_RDATA;

	assign OBJ_Y_Q[15:0]=OBJ_Y_RDATA[31:16];
	assign OBJ_SZ_LINK_Q[15:0]=OBJ_Y_RDATA[15:0];
	assign OBJ_X_Q[31:0]=OBJ_X_RDATA[31:0];

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v7_1_dp128x32 obj_oi_y(
	.clka(CLK),
	.ena(1'b1),
	.wea({OBJ_Y_WE,OBJ_Y_WE,OBJ_Y_WE,OBJ_Y_WE}),
	.addra(OBJ_Y_ADDR_WR[6:0]),
	.dina(OBJ_Y_D[31:0]),
//	.douta(),
	.clkb(CLK),
	.enb(1'b1),
//	.web(4'b0),
	.addrb(OBJ_Y_ADDR_RD[6:0]),
//	.dinb(18'b0),
	.doutb(OBJ_Y_RDATA[31:0])
);

xil_blk_mem_gen_v7_1_dp128x32 obj_oi_x(
	.clka(CLK),
	.ena(1'b1),
	.wea({OBJ_X_WE,OBJ_X_WE,OBJ_X_WE,OBJ_X_WE}),
	.addra(OBJ_Y_ADDR_WR[6:0]),
	.dina(OBJ_X_D[31:0]),
//	.douta(),
	.clkb(CLK),
	.enb(1'b1),
//	.web(4'b0),
	.addrb(OBJ_Y_ADDR_RD[6:0]),
//	.dinb(18'b0),
	.doutb(OBJ_X_RDATA[31:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_dp128x32 obj_oi_y(
	.address_a(OBJ_Y_ADDR_WR[6:0]),
	.address_b(OBJ_Y_ADDR_RD[6:0]),
	.byteena_a(4'b1111),
	.byteena_b(4'b1111),
	.clock(CLK),
	.data_a(OBJ_Y_D[31:0]),
	.data_b(32'b0),
	.wren_a(OBJ_Y_WE),
	.wren_b(1'b0),
	.q_a(),
	.q_b(OBJ_Y_RDATA[31:0])
);

alt_altsyncram_dp128x32 obj_oi_x(
	.address_a(OBJ_Y_ADDR_WR[6:0]),
	.address_b(OBJ_Y_ADDR_RD[6:0]),
	.byteena_a(4'b1111),
	.byteena_b(4'b1111),
	.clock(CLK),
	.data_a(OBJ_X_D[31:0]),
	.data_b(32'b0),
	.wren_a(OBJ_X_WE),
	.wren_b(1'b0),
	.q_a(),
	.q_b(OBJ_X_RDATA[31:0])
);

end
endgenerate

	//--------------------------------------------------------------
	// REGISTERS
	//--------------------------------------------------------------

`ifdef debug_display
	assign DISP=1'b1;
`else
	assign DISP=REG1[6];
`endif

	assign BLANK=!REG1[6];

	reg		line_disp_r;

	assign LINE_DISP=line_disp_r;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				line_disp_r <= 1'b0;
			end
		else
			begin
				line_disp_r <= (H_CNT==NTSC_H_REND_START) ? DISP : line_disp_r;
			end
	end

	assign ADDR_STEP[7:0]=REG15;
	assign H40=REG12[0];
	assign V30=REG1[3];
	assign HSCR[1:0]=REG11[1:0];
	assign HSIZE[1:0]=REG16[1:0];
	assign VSIZE[1:0]=REG16[5:4];
	assign VSCR=REG11[2];

	assign RS0=REG12[7];
	assign RS1=REG12[0];

	assign WVP[4:0]=REG18[4:0];
	assign WDOWN=REG18[7];
	assign WHP[4:0]=REG17[4:0];
	assign WRIGT=REG17[7];

	assign BGCOL[5:0]=REG7[5:0];

	assign HIT=REG10;
	assign IE1=REG0[4];
	assign IE2=REG11[3];
	assign M3=REG0[1];
	assign IE0=REG1[5];

	assign DMA=REG1[4];
	assign M1=REG1[4];
	assign M2=REG1[3];

	assign debug_lsm[2:0]={ODD,LSM[1:0]};
	assign LSM[1:0]=REG12[2:0];
	assign STEN=REG12[3];

	// Base addresses
	assign HSCB[5:0]=REG13[5:0];
	assign NTBB[2:0]=REG4[2:0];
//	assign NTWB[4:0]=(H40==1'b0) ? REG3[5:1] : {REG3[5:2],1'b0};
	assign NTWB[4:0]=REG3[5:1];
	assign NTAB[2:0]=REG2[5:3];
//	assign SATB[6:0]=(H40==1'b0) ? REG5[6:0] : {REG5[6:1],1'b0};
	assign SATB[6:0]=REG5[6:0];

	// Read-only registers
	assign ODD=(LSM[1:0]==2'b01) ? (FIELD) : (1'b0);
	assign IN_DMA=DMA_FILL | DMA_COPY | DMA_VBUS;

	assign STATUS[15]=1'b0;
	assign STATUS[14]=1'b0;
	assign STATUS[13]=1'b1;
	assign STATUS[12]=1'b1;
	assign STATUS[11]=1'b0;
	assign STATUS[10]=1'b1;
	assign STATUS[9]=FIFO_EMPTY;
	assign STATUS[8]=FIFO_FULL;
	assign STATUS[7]=VINT_TG68_PENDING;
	assign STATUS[6]=SOVR;
	assign STATUS[5]=SCOL;
	assign STATUS[4]=ODD;
	assign STATUS[3]=IN_VBL;
	assign STATUS[2]=IN_HBL;
	assign STATUS[1]=IN_DMA;
	assign STATUS[0]=V30;

	assign HV[15:0]={HV_VCNT[8:1], HV_HCNT[8:1]};

	//--------------------------------------------------------------
	// CPU INTERFACE
	//--------------------------------------------------------------

`ifdef replace_cpuif

	assign DTACK_N=FF_DTACK_N;
	assign DO=FF_DO;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				FF_DTACK_N <= 1'b1;
				FF_DO <= 16'hffff;
				DT_FF_DATA <= 0;
				DT_FF_CODE <= 0;
				DT_FF_SIZE <= 0;
				PENDING <= 1'b0;
				REG_LATCH <= 0;
				ADDR_LATCH <= 16'h0000;
				ADDR_SET_REQ <= 1'b0;
				REG_SET_REQ <= 1'b0;
				DMAF_SET_REQ <= 1'b0;
				CODE <= 6'b0;
				DT_DMAF_DATA <= 0;
				DT_RD_CODE <= 0;
				DT_RD_SEL <= 1'b0;
				DT_FF_SEL <= 1'b0;
				SOVR_CLR <= 1'b0;
				SCOL_CLR <= 1'b0;
			end
		else
			begin
				SOVR_CLR <= 1'b0;
				SCOL_CLR <= 1'b0;
				if (SEL==1'b0) 
					begin
						FF_DTACK_N <= 1'b1;
					end 
				else 
					if (SEL==1'b1 && FF_DTACK_N==1'b1) 
						begin
							if (RNW==1'b0) 
								begin	// Write
									if (A[3:2]==2'b00) 
										begin
											// Data Port
											PENDING <= 1'b0;
											if (CODE==6'b000011 || CODE==6'b000101 || CODE==6'b000001) 
												begin
													// CRAM Write // VSRAM Write // VRAM Write
													DT_FF_DATA <= DI;
													DT_FF_CODE <= CODE[2:0];
													DT_FF_SIZE <= (UDS_N==1'b0 && LDS_N==1'b0) ? 1'b1 : 1'b0;
													if (DT_FF_DTACK_N==1'b1) 
														begin
															DT_FF_SEL <= 1'b1;
														end 
													else 
														begin
															DT_FF_SEL <= 1'b0;
															FF_DTACK_N <= 1'b0;
														end
												end
											else
												begin
													DT_DMAF_DATA <= DI;
													if (DMA_FILL_PRE==1'b1) 
														begin
															if (DMAF_SET_ACK==1'b0) 
																begin
																	DMAF_SET_REQ <= 1'b1;
																end 
															else 
																begin
																	DMAF_SET_REQ <= 1'b0;
																	FF_DTACK_N <= 1'b0;
																end
														end 
													else 
														begin
															FF_DTACK_N <= 1'b0;
														end
												end
										end
									else
										if (A[3:2]==2'b01) 
											begin
												// Control Port
												if (PENDING==1'b1) 
													begin
														CODE[5:2] <= DI[7:4];
														ADDR_LATCH <= {DI[1:0], ADDR[13:0]};
														if (ADDR_SET_ACK==1'b0 || DMA_VBUS==1'b1) 
															begin
																ADDR_SET_REQ <= 1'b1;
															end 
														else 
															begin
																ADDR_SET_REQ <= 1'b0;
																FF_DTACK_N <= 1'b0;
																PENDING <= 1'b0;
															end
													end
											else
												begin
													if (DI[15:13]==3'b100) 
														begin
								// Register Set
															REG_LATCH <= DI;
															if (REG_SET_ACK==1'b0) 
																begin
																	REG_SET_REQ <= 1'b1;
																end 
															else 
																begin
																	REG_SET_REQ <= 1'b0;
																	FF_DTACK_N <= 1'b0;
																end
														end 
												else 
													begin
								// Address Set
														CODE[1:0] <= DI[15:14];
														ADDR_LATCH[13:0] <= DI[13:0];
														if (ADDR_SET_ACK==1'b0) 
															begin
																ADDR_SET_REQ <= 1'b1;
															end 
														else 
															begin
																ADDR_SET_REQ <= 1'b0;
																FF_DTACK_N <= 1'b0;
															PENDING <= 1'b1;
															end
													end
											end
									end 
								else 
									begin
										FF_DTACK_N <= 1'b0;
									end
							end 
						else 
							begin	// Read
								PENDING <= 1'b0;
								if (A[3:2]==2'b00) 
									begin
						// Data Port
										if (CODE==6'b001000 || CODE==6'b000100 || CODE==6'b000000) 
											begin	// CRAM Read // VSRAM Read // VRAM Read 
												if (DT_RD_DTACK_N==1'b1) 
													begin
														DT_RD_SEL <= 1'b1;
														DT_RD_CODE <= CODE[3:0];
													end 
												else 
													begin
														DT_RD_SEL <= 1'b0;
														FF_DO <= DT_RD_DATA;
														FF_DTACK_N <= 1'b0;
													end
											end 
										else 
											begin
												FF_DTACK_N <= 1'b0;
											end
									end 
								else 
									if (A[3:2]==2'b01) 
										begin
						// Control Port (Read Status Register)
											FF_DO <= STATUS;
											SOVR_CLR <= 1'b1;
											SCOL_CLR <= 1'b1;
											FF_DTACK_N <= 1'b0;
										end 
									else 
										if (A[3:2]==2'b10) 
											begin
							// HV Counter
												FF_DO <= HV;
												FF_DTACK_N <= 1'b0;
											end 
										else 
											begin
												FF_DTACK_N <= 1'b0;
											end
							end
					end
			end
	end

`else

	assign DTACK_N=FF_DTACK_N;
	assign DO=FF_DO;

	always @(negedge RST_N or posedge CLK) begin
		if (RST_N==1'b0) begin
			FF_DTACK_N <= 1'b1;
			FF_DO <= 16'hffff;

							DT_FF_DATA <= 0;
							DT_FF_CODE <= 0;
								DT_FF_SIZE <= 0;

			PENDING <= 1'b0;
								REG_LATCH <= 0;
			ADDR_LATCH <= 16'h0000;
			ADDR_SET_REQ <= 1'b0;
			REG_SET_REQ <= 1'b0;
			DMAF_SET_REQ <= 1'b0;
			CODE <= 6'b0;

	DT_DMAF_DATA <= 0;

	DT_RD_CODE <= 0;
			DT_RD_SEL <= 1'b0;
			DT_FF_SEL <= 1'b0;
			SOVR_CLR <= 1'b0;
			SCOL_CLR <= 1'b0;
		end
		else
		begin
			SOVR_CLR <= 1'b0;
			SCOL_CLR <= 1'b0;
			if (SEL==1'b0) begin
				FF_DTACK_N <= 1'b1;
			end else if (SEL==1'b1 && FF_DTACK_N==1'b1) begin
				if (RNW==1'b0) begin	// Write
					if (A[3:2]==2'b00) begin
						// Data Port
						PENDING <= 1'b0;

						if (CODE==6'b000011 || CODE==6'b000101 || CODE==6'b000001) begin
							// CRAM Write
							// VSRAM Write
							// VRAM Write
							DT_FF_DATA <= DI;
							DT_FF_CODE <= CODE[2:0];
						//	if (UDS_N==1'b0 && LDS_N==1'b0) begin
						//		DT_FF_SIZE <= 1'b1;
						//	end else begin
						//		DT_FF_SIZE <= 1'b0;
						//	end
								DT_FF_SIZE <= (UDS_N==1'b0 && LDS_N==1'b0) ? 1'b1 : 1'b0;


							if (DT_FF_DTACK_N==1'b1) begin
								DT_FF_SEL <= 1'b1;
							end else begin
								DT_FF_SEL <= 1'b0;
								FF_DTACK_N <= 1'b0;
							end
						end
						else
						begin
							DT_DMAF_DATA <= DI;
							if (DMA_FILL_PRE==1'b1) begin
								if (DMAF_SET_ACK==1'b0) begin
									DMAF_SET_REQ <= 1'b1;
								end else begin
									DMAF_SET_REQ <= 1'b0;
									FF_DTACK_N <= 1'b0;
								end
							end else begin
								FF_DTACK_N <= 1'b0;
							end
						end
					end
					else
					if (A[3:2]==2'b01) begin
						// Control Port
						if (PENDING==1'b1) begin
							CODE[5:2] <= DI[7:4];
							// ADDR(15 downto 14) <= DI(1 downto 0);
							// ADDR_LATCH <= DI(1 downto 0);
							ADDR_LATCH <= {DI[1:0], ADDR[13:0]};
							// In case of DMA VBUS request, hold the TG68 with DTACK_N
							// it should avoid the use of a CLKEN signal
							if (ADDR_SET_ACK==1'b0 || DMA_VBUS==1'b1) begin
								ADDR_SET_REQ <= 1'b1;
							end else begin
								ADDR_SET_REQ <= 1'b0;
								FF_DTACK_N <= 1'b0;
								PENDING <= 1'b0;
							end
						end
						else
						begin
							if (DI[15:13]==3'b100) begin
								// Register Set
								REG_LATCH <= DI;
								if (REG_SET_ACK==1'b0) begin
									REG_SET_REQ <= 1'b1;
								end else begin
									REG_SET_REQ <= 1'b0;
									FF_DTACK_N <= 1'b0;
								end
							end else begin
								// Address Set
								CODE[1:0] <= DI[15:14];
								// ADDR <= ADDR_LATCH & DI(13 downto 0);
								ADDR_LATCH[13:0] <= DI[13:0];
								if (ADDR_SET_ACK==1'b0) begin
									ADDR_SET_REQ <= 1'b1;
								end else begin
									ADDR_SET_REQ <= 1'b0;
									FF_DTACK_N <= 1'b0;
									PENDING <= 1'b1;
								end
							end
						end
					end else begin	// Note : Genesis Plus does address setting
	// even in Register Set mode. Normal ?
						// Unused (Lock-up)
						FF_DTACK_N <= 1'b0;
					end
				end else begin	// Read
					PENDING <= 1'b0;

					if (A[3:2]==2'b00) begin
						// Data Port
						if (CODE==6'b001000 || CODE==6'b000100 || CODE==6'b000000) begin	// CRAM Read
							// VSRAM Read
							// VRAM Read
							if (DT_RD_DTACK_N==1'b1) begin
								DT_RD_SEL <= 1'b1;
								DT_RD_CODE <= CODE[3:0];
							end else begin
								DT_RD_SEL <= 1'b0;
								FF_DO <= DT_RD_DATA;
								FF_DTACK_N <= 1'b0;
							end
						end else begin
							FF_DTACK_N <= 1'b0;
						end
					end else if (A[3:2]==2'b01) begin
						// Control Port (Read Status Register)
						FF_DO <= STATUS;
						SOVR_CLR <= 1'b1;
						SCOL_CLR <= 1'b1;
						FF_DTACK_N <= 1'b0;
					end else if (A[3:2]==2'b10) begin
						// HV Counter
						FF_DO <= HV;
						FF_DTACK_N <= 1'b0;
					end else begin
						FF_DTACK_N <= 1'b0;
					end
				end
			end
		end
	end

`endif

	//--------------------------------------------------------------
	// VRAM CONTROLLER
	//--------------------------------------------------------------

//	wire	[15:0] SP1_VRAM_DO;
	wire	[31:0] SP1_VRAM32_DO;
	wire	SP1_DTACK_N;

//	wire	[15:0] SP2_VRAM_DO;
	wire	[31:0] SP2_VRAM32_DO;
	wire	SP2_DTACK_N;

//	wire	[15:0] BGA_VRAM_DO;
	wire	[31:0] BGA_VRAM32_DO;
	wire	BGA_DTACK_N;

//	wire	[15:0] BGB_VRAM_DO;
	wire	[31:0] BGB_VRAM32_DO;
	wire	BGB_DTACK_N;

	wire	[15:0] DT_VRAM_DO;
	wire	[31:0] DT_VRAM32_DO;
	wire	DT_VRAM_DTACK_N;

//`ifdef direct_dma_access
//	assign x_DT_VRAM_SEL=1'b0;

	assign VD_REQ=DT_VRAM_SEL;
	assign VD_ADDR[31:0]={16'b0,DT_VRAM_ADDR[15:0]};
	assign VD_WDATA[31:0]={DT_VRAM_DI[15:0],DT_VRAM_DI[15:0]};
	assign DT_VRAM_DO[15:0]=(VD_ADDR[1]==1'b0) ? VD_RDATA[31:16] : VD_RDATA[15:0];
	assign DT_VRAM32_DO[31:0]=VD_RDATA[31:0];
	assign VD_WR=!DT_VRAM_RNW;
	assign VD_BE[3]=(VD_ADDR[1]==1'b0) & (DT_VRAM_UDS_N==1'b0) ? 1'b1 : 1'b0;
	assign VD_BE[2]=(VD_ADDR[1]==1'b0) & (DT_VRAM_LDS_N==1'b0) ? 1'b1 : 1'b0;
	assign VD_BE[1]=(VD_ADDR[1]==1'b1) & (DT_VRAM_UDS_N==1'b0) ? 1'b1 : 1'b0;
	assign VD_BE[0]=(VD_ADDR[1]==1'b1) & (DT_VRAM_LDS_N==1'b0) ? 1'b1 : 1'b0;
	assign DT_VRAM_DTACK_N=!VD_ACK;

//`else
//`endif
//`ifdef direct_spr_search
//	assign x_SP1_SEL=1'b0;

	assign V0_ADDR={16'b0,SP1_VRAM_ADDR[15:0]};
	assign V0_REQ=SP1_SEL;
	assign V0_BE=4'b1111;
	assign V0_WDATA=32'b0;
	assign V0_WR=1'b0;
//	assign SP1_VRAM_DO=(V0_ADDR[1]==1'b0) ? V0_RDATA[31:16] : V0_RDATA[15:0];
	assign SP1_VRAM32_DO=V0_RDATA[31:0];
	assign SP1_DTACK_N=!V0_ACK;

//`else
//`endif
//`ifdef direct_spr_render
//	assign x_SP2_SEL=1'b0;

	assign V1_ADDR={16'b0,SP2_VRAM_ADDR[15:0]};
	assign V1_REQ=SP2_SEL;
	assign V1_BE=4'b1111;
	assign V1_WDATA=32'b0;
	assign V1_WR=1'b0;
//	assign SP2_VRAM_DO=(V1_ADDR[1]==1'b0) ? V1_RDATA[31:16] : V1_RDATA[15:0];
	assign SP2_VRAM32_DO=V1_RDATA[31:0];
	assign SP2_DTACK_N=!V1_ACK;

//`else
//`endif
//`ifdef direct_bga_render
//	assign x_BGA_SEL=1'b0;

	assign V2_ADDR={16'b0,BGA_VRAM_ADDR[15:0]};
	assign V2_REQ=BGA_SEL;
	assign V2_BE=4'b1111;
	assign V2_WDATA=32'b0;
	assign V2_WR=1'b0;
//	assign BGA_VRAM_DO=(V2_ADDR[1]==1'b0) ? V2_RDATA[31:16] : V2_RDATA[15:0];
	assign BGA_VRAM32_DO=V2_RDATA[31:0];
	assign BGA_DTACK_N=!V2_ACK;

//`else
//`endif
//`ifdef direct_bgb_render
//	assign x_BGB_SEL=1'b0;

	assign V3_ADDR={16'b0,BGB_VRAM_ADDR[15:0]};
	assign V3_REQ=BGB_SEL;
	assign V3_BE=4'b1111;
	assign V3_WDATA=32'b0;
	assign V3_WR=1'b0;
//	assign BGB_VRAM_DO=(V3_ADDR[1]==1'b0) ? V3_RDATA[31:16] : V3_RDATA[15:0];
	assign BGB_VRAM32_DO=V3_RDATA[31:0];
	assign BGB_DTACK_N=!V3_ACK;

//`else
//`endif

	assign VRAM32_REQ=1'b0;
	assign VRAM32_ADDR[31:0]=32'b0;
	assign VRAM32_BE[3:0]=4'b0;
	assign VRAM32_WDATA[31:0]=32'b0;
	assign VRAM_DO[15:0]=16'b0;
	assign VRAM32_DO[31:0]=32'b0;
	assign VRAM32_WR=1'b0;

	//--------------------------------------------------------------
	// BACKGROUND B RENDERING
	//--------------------------------------------------------------

	wire	bga_render;
	wire	bgb_render;
	wire	spr_render;
	wire	spr_search;

	wire	bga_done;
	wire	bgb_done;
	wire	spr_done;

	wire	BGA_ACTIVE;
	wire	BGB_ACTIVE;
	wire	SPR_ACTIVE;

	reg		[1:0] scr_HSCR;
	reg		[1:0] scr_HSIZE;
	reg		[1:0] scr_VSIZE;
	reg		scr_VSCR;

//	reg		[4:0] scr_WVP;
//	reg		scr_WDOWN;
	reg		[4:0] scr_WHP;
	reg		scr_WRIGT;

	reg		scr_H40;
	reg		[5:0] scr_HSCB;
	reg		[2:0] scr_NTBB;
	reg		[4:0] scr_NTWB;
	reg		[2:0] scr_NTAB;
	reg		[6:0] scr_SATB;

	reg		debug_sca_r;
	reg		debug_scw_r;
	reg		debug_scb_r;
	reg		debug_spr_r;
	reg		debug_dma_r;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				scr_HSCR[1:0] <= 2'b0;
				scr_HSIZE[1:0] <= 2'b0;
				scr_VSIZE[1:0] <= 2'b0;
				scr_VSCR <= 1'b0;
//				scr_WVP[4:0] <= 5'b0;
//				scr_WDOWN <= 1'b0;
				scr_WHP[4:0] <= 5'b0;
				scr_WRIGT <= 1'b0;
				scr_H40 <= 1'b0;
				scr_HSCB[5:0] <= 2'b0;
				scr_NTBB[2:0] <= 2'b0;
				scr_NTWB[4:0] <= 2'b0;
				scr_NTAB[2:0] <= 2'b0;
				scr_SATB[6:0] <= 2'b0;

				debug_sca_r <= 1'b0;
				debug_scw_r <= 1'b0;
				debug_scb_r <= 1'b0;
				debug_spr_r <= 1'b0;
				debug_dma_r <= 1'b0;
			end
		else
			begin
				scr_HSCR[1:0] <= (BGEN_ACTIVE==1'b0) ? HSCR[1:0] : scr_HSCR[1:0];
				scr_HSIZE[1:0] <= (BGEN_ACTIVE==1'b0) ? HSIZE[1:0] : scr_HSIZE[1:0];
				scr_VSIZE[1:0] <= (BGEN_ACTIVE==1'b0) ? VSIZE[1:0] : scr_VSIZE[1:0];
				scr_VSCR <= (BGEN_ACTIVE==1'b0) ? VSCR : scr_VSCR;
//				scr_WVP[4:0] <= (BGEN_ACTIVE==1'b0) ? WVP[4:0] : scr_WVP[4:0];
//				scr_WDOWN <= (BGEN_ACTIVE==1'b0) ? WDOWN : scr_WDOWN;
			//	scr_WHP[4:0] <= (BGEN_ACTIVE==1'b0) ? WHP[4:0] : scr_WHP[4:0];
				scr_WHP[4:0] <= (BGEN_ACTIVE==1'b0) ? WHP[4:0]-5'b01 : scr_WHP[4:0];
				scr_WRIGT <= (BGEN_ACTIVE==1'b0) ? WRIGT : scr_WRIGT;
				scr_H40 <= (BGEN_ACTIVE==1'b0) ? H40 : scr_H40;
				scr_HSCB[5:0] <= (BGEN_ACTIVE==1'b0) ? HSCB[5:0] : scr_HSCB[5:0];
				scr_NTBB[2:0] <= (BGEN_ACTIVE==1'b0) ? NTBB[2:0] : scr_NTBB[2:0];
				scr_NTWB[4:0] <= (BGEN_ACTIVE==1'b0) ? NTWB[4:0] : scr_NTWB[4:0];
				scr_NTAB[2:0] <= (BGEN_ACTIVE==1'b0) ? NTAB[2:0] : scr_NTAB[2:0];
				scr_SATB[6:0] <= (BGEN_ACTIVE==1'b0) ? SATB[6:0] : scr_SATB[6:0];

`ifdef debug_display
				debug_sca_r <= debug_sca;
				debug_scw_r <= debug_scw;
				debug_scb_r <= debug_scb;
				debug_spr_r <= debug_spr;
				debug_dma_r <= debug_dma;
`else
				debug_sca_r <= 1'b0;
				debug_scw_r <= 1'b0;
				debug_scb_r <= 1'b0;
				debug_spr_r <= 1'b0;
				debug_dma_r <= 1'b0;
`endif
			end
	end

generate
	if (disp_bga==1)
begin
	assign BGA_ACTIVE=BGEN_ACTIVE;
end
	else
begin
	assign BGA_ACTIVE=1'b0;
end
endgenerate

generate
	if (disp_bgb==1)
begin
	assign BGB_ACTIVE=BGEN_ACTIVE;
end
	else
begin
	assign BGB_ACTIVE=1'b0;
end
endgenerate

generate
	if (disp_spr==1)
begin
	assign SPR_ACTIVE=SP2E_ACTIVE;
end
	else
begin
	assign SPR_ACTIVE=1'b0;
end
endgenerate

//`ifdef replace_bgb_render

generate
	if (disp_bgb==1)
begin

	reg		[9:0] scb_y_r;
	reg		bgb_render_r;
	reg		bgb_render_done_r;

	assign bgb_render=bgb_render_r;
	assign bgb_done=bgb_render_done_r;

	wire 	[9:0]	V_BGB_XSTART;
	wire 	[15:0]	V_BGB_BASE;
	wire 	[15:0]	V_BGB_BASE_scroll;

//	assign V_BGB_XSTART=10'b0000000000 - BGB_VRAM_DO[9:0];

`ifdef debug_bgb_scroll

//	assign V_BGB_XSTART=10'b0000000000 - {4'b0,PRE_Y[7:1]};		// scroll test
	assign V_BGB_XSTART=10'b0000000000 - {4'b0,scb_y_r[7:1]};		// scroll test

`else

	assign V_BGB_XSTART=10'b0000000000 - BGB_VRAM32_DO[9:0];

`endif

	assign V_BGB_BASE_scroll[15:0]=
			(scr_HSIZE[1:0]==2'b00) ? {3'b0,BGB_Y[9:3],BGB_X[7:3],1'b0} :
			(scr_HSIZE[1:0]==2'b01) ? {3'b0,BGB_Y[9:3],BGB_X[8:3],1'b0} :
			(scr_HSIZE[1]  ==1'b1 ) ? {3'b0,BGB_Y[9:3],BGB_X[9:3],1'b0} :
			16'b0;

	assign V_BGB_BASE[15:0]=
		//	(scr_HSIZE==2'b00) ? ({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 5'b00000}, 1'b0}) :
		//	(scr_HSIZE==2'b01) ? ({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 6'b000000}, 1'b0}) :
		//	({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 7'b0000000}, 1'b0});
			{scr_NTBB[2:0],V_BGB_BASE_scroll[12:0]};

	wire	[9:0] BGB_Y_BASE;
	wire	[9:0] BGB_Y_BASE_scroll;

	assign VSRAM1_RADDR[8:0]=
			(BGB_POS[9]==1'b1) ? 9'b0 :
			(BGB_POS[9]==1'b0) & (scr_VSCR==1'b1) ? {4'b0,BGB_POS[8:4]} :
			(BGB_POS[9]==1'b0) & (scr_VSCR==1'b0) ? 9'b0 :
			9'b0;

//	assign BGB_Y_BASE_scroll[9:0]=VSRAM1_RDATA[9:0]+{2'b0,PRE_Y[7:0]};
	assign BGB_Y_BASE_scroll[9:0]=VSRAM1_RDATA[9:0]+{2'b0,scb_y_r[7:0]};

//	assign BGB_Y_BASE[9:0]= //(VSRAM1_RDATA[9:0] + {2'b0,PRE_Y[7:0]}) & ({scr_VSIZE, 8'hff});
	assign BGB_Y_BASE[9:0]= //(VSRAM1_RDATA[9:0] + {2'b0,scb_y_r[7:0]}) & ({scr_VSIZE, 8'hff});
			(scr_VSIZE[1:0]==2'b00) ? {2'b00,BGB_Y_BASE_scroll[7:0]} :
			(scr_VSIZE[1:0]==2'b01) ? {2'b00,BGB_Y_BASE_scroll[8:0]} :
			(scr_VSIZE[1]  ==1'b1 ) ? {2'b00,BGB_Y_BASE_scroll[9:0]} :
			10'b0;

	reg		[15:0] scb_addr_latch_r;
	reg		scb_addr_hit_r;
	reg		[31:0] scb_data_latch_r;
	reg		scb_w_inside_r;
	reg		[2:0] scb_rend_x_r;
	reg		[31:0] scb_rend_data_r;
	wire	[15:0] scb_addr_latch_w;
	wire	scb_addr_hit_w;
	wire	[31:0] scb_data_latch_w;
	wire	scb_w_inside_w;
	wire	[2:0] scb_rend_x_w;
	wire	[31:0] scb_rend_data_w;

//	assign BGB_COLINFO_RD_B0=(PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
	assign BGB_COLINFO_RD_B0=(scb_y_r[0]==1'b1) ? 1'b1 : 1'b0;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				scb_y_r[9:0] <= 10'b0;
				bgb_render_r <= 1'b0;
				bgb_render_done_r <= 1'b0;
				scb_addr_latch_r[15:0] <= 16'b0;
				scb_addr_hit_r <= 1'b0;
				scb_data_latch_r[31:0] <= 32'b0;
				scb_w_inside_r <= 1'b0;
				scb_rend_x_r[2:0] <= 3'b0;
				scb_rend_data_r[31:0] <= 32'b0;
				BGB_VRAM_ADDR <= 0;
				BGB_SEL <= 1'b0;
				BGBC <= BGBC_INIT;
				BGB_COLINFO_WE_A <= 1'b0;
				BGB_COLINFO_WE_A0 <= 1'b0;
				BGB_COLINFO_WE_A1 <= 1'b0;
				BGB_COLINFO_ADDR_A[8:0] <= 9'b0;
				BGB_COLINFO_D_A[6:0] <= 7'b0;
				BGB_X[9:0] <= 10'b0;
				BGB_POS[9:0] <= 10'b0;
				BGB_POS_OVER <= 1'b0;
				BGB_Y[9:0] <= 10'b0;
				T_BGB_PRI <= 0;
				T_BGB_PAL[1:0] <= 2'b0;
				BGB_TILEBASE[15:0] <= 16'b0;
				BGB_HF <= 0;
			end
		else
			begin
				case (BGBC)
					BGBC_INIT: 
						begin
							scb_y_r[9:0] <= PRE_Y[9:0];
							bgb_render_r <= (BGB_ACTIVE==1'b1) ? 1'b1 : 1'b0;
							bgb_render_done_r <= 1'b0;
							BGB_VRAM_ADDR <= 
								(HSCR==2'b00) ? {HSCB, 10'b0000000010} :
								(HSCR==2'b01) ? {HSCB, 5'b00000, PRE_Y[2:0], 2'b10} :
								(HSCR==2'b10) ? {HSCB, PRE_Y[7:3], 5'b00010} :
								(HSCR==2'b11) ? {HSCB, PRE_Y[7:0], 2'b10} :
								16'b0;
							BGB_SEL <= (BGB_ACTIVE==1'b1) ? 1'b1 : 1'b0;
							BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_HS_RD : BGBC_INIT;
							BGB_POS_OVER <= 1'b0;
						end
					BGBC_HS_RD: 
						begin
							if (BGB_DTACK_N==1'b0) begin
								BGB_SEL <= 1'b0;
								BGB_X[9:0] <= //({V_BGB_XSTART[9:3], 3'b000}) & ({scr_HSIZE, 8'hff});
									(scr_HSIZE[1:0]==2'b00) ? {2'b00,V_BGB_XSTART[7:3],3'b000} :
									(scr_HSIZE[1:0]==2'b01) ? {2'b00,V_BGB_XSTART[8:3],3'b000} :
									(scr_HSIZE[1]  ==1'b1 ) ? {2'b00,V_BGB_XSTART[9:3],3'b000} :
									10'b0;
								BGB_POS[9:0] <= 10'b0000000000 - {7'b0000000, V_BGB_XSTART[2:0]};
								BGBC <= BGBC_CALC_Y;
							end
						end
					BGBC_CALC_Y: 
						begin
							BGB_COLINFO_WE_A <= 1'b0;
							BGB_COLINFO_WE_A0 <= 1'b0;
							BGB_COLINFO_WE_A1 <= 1'b0;
							BGB_Y <= BGB_Y_BASE[9:0];
							BGBC <= BGBC_CALC_BASE;
						end
					BGBC_CALC_BASE: 
						begin
							BGB_VRAM_ADDR <= V_BGB_BASE[15:0];
							//	(scr_HSIZE==2'b00) ? ({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 5'b00000}, 1'b0}) :
							//	(scr_HSIZE==2'b01) ? ({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 6'b000000}, 1'b0}) :
							//	({scr_NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 7'b0000000}, 1'b0});
							BGBC <= BGBC_BASE_RD;
						end
					BGBC_BASE_RD:
					begin
`ifdef debug_bgb_access
						scb_addr_hit_r <= 1'b0;
						BGB_SEL <= 1'b1;
`else
						scb_addr_hit_r <= (scb_addr_latch_r[15:2]==BGB_VRAM_ADDR[15:2]) & (scb_addr_latch_r[0]==1'b1) ? 1'b1 : 1'b0;
						BGB_SEL <= (scb_addr_latch_r[15:2]==BGB_VRAM_ADDR[15:2]) & (scb_addr_latch_r[0]==1'b1) ? 1'b0 : 1'b1;
`endif
						BGBC <= BGBC_BASE_RD1;
						end
					BGBC_BASE_RD1:
						begin
							if (scb_addr_hit_r==1'b0)
								begin
									if (BGB_DTACK_N==1'b0)
										begin
											BGB_SEL <= 1'b0;
											T_BGB_PRI <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[31] : BGB_VRAM32_DO[15];
											T_BGB_PAL[1:0] <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[30:29] : BGB_VRAM32_DO[14:13];
											BGB_HF <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[27] : BGB_VRAM32_DO[11];
											BGB_TILEBASE <=
												(BGB_VRAM_ADDR[1]==1'b0) & (BGB_VRAM32_DO[28]==1'b1) ? {BGB_VRAM32_DO[26:16], ~BGB_Y[2:0], 2'b00} :
												(BGB_VRAM_ADDR[1]==1'b0) & (BGB_VRAM32_DO[28]==1'b0) ? {BGB_VRAM32_DO[26:16], BGB_Y[2:0],  2'b00} :
												(BGB_VRAM_ADDR[1]==1'b1) & (BGB_VRAM32_DO[12]==1'b1) ? {BGB_VRAM32_DO[10:0],  ~BGB_Y[2:0], 2'b00} :
												(BGB_VRAM_ADDR[1]==1'b1) & (BGB_VRAM32_DO[12]==1'b0) ? {BGB_VRAM32_DO[10:0],  BGB_Y[2:0],  2'b00} :
												16'b0;
											BGBC <= BGBC_TILE;
											scb_data_latch_r[31:0] <= BGB_VRAM32_DO[31:0];
											scb_addr_latch_r[15:0] <= {BGB_VRAM_ADDR[15:2],2'b01};
										end
									else
										begin
											BGBC <= BGBC_BASE_RD1;
										end
								end
							else
								begin
									T_BGB_PRI <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[31] : scb_data_latch_r[15];
									T_BGB_PAL[1:0] <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[30:29] : scb_data_latch_r[14:13];
									BGB_HF <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[27] : scb_data_latch_r[11];
									BGB_TILEBASE <=
										(BGB_VRAM_ADDR[1]==1'b0) & (scb_data_latch_r[28]==1'b1) ? {scb_data_latch_r[26:16], ~BGB_Y[2:0], 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b0) & (scb_data_latch_r[28]==1'b0) ? {scb_data_latch_r[26:16], BGB_Y[2:0],  2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (scb_data_latch_r[12]==1'b1) ? {scb_data_latch_r[10:0],  ~BGB_Y[2:0], 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (scb_data_latch_r[12]==1'b0) ? {scb_data_latch_r[10:0],  BGB_Y[2:0],  2'b00} :
										16'b0;
									BGBC <= BGBC_TILE;
								end
						end
					BGBC_TILE: 
						begin
							BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 2'b00};
							BGB_SEL <= 1'b1;
							BGBC <= BGBC_TILE_RD;
						end
					BGBC_TILE_RD: 
						begin
							if (BGB_DTACK_N==1'b0) 
								begin
									BGB_SEL <= 1'b0;
									BGBC <= BGBC_LOOP;
									scb_rend_data_r[31:0] <= BGB_VRAM32_DO[31:0];
								end
						end
					BGBC_LOOP: 
						begin
							BGB_COLINFO_ADDR_A <= BGB_POS[8:0];
							BGB_COLINFO_WE_A <= (BGB_POS[9]==1'b0) ? 1'b1 : 1'b0;
						//	BGB_COLINFO_WE_A0 <= (BGB_POS[9]==1'b0) & (PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
						//	BGB_COLINFO_WE_A1 <= (BGB_POS[9]==1'b0) & (PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
							BGB_COLINFO_WE_A0 <= (BGB_POS[9]==1'b0) & (scb_y_r[0]==1'b0) ? 1'b1 : 1'b0;
							BGB_COLINFO_WE_A1 <= (BGB_POS[9]==1'b0) & (scb_y_r[0]==1'b1) ? 1'b1 : 1'b0;

							BGB_COLINFO_D_A[6:0] <=

								(debug_scb_r==1'b1) ? {{T_BGB_PRI, T_BGB_PAL[1:0]}, BGB_VRAM32_DO[31:28]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b000) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[31:28]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b001) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[27:24]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b010) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[23:20]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b011) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[19:16]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b100) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[15:12]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b101) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[11:8]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b110) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[7:4]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b111) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[3:0]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b000) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[3:0]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b001) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[7:4]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b010) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[11:8]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b011) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[15:12]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b100) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[19:16]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b101) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[23:20]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b110) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[27:24]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b111) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], BGB_VRAM32_DO[31:28]} :
/*
								(debug_scb_r==1'b1) ? {{T_BGB_PRI, T_BGB_PAL[1:0]}, scb_rend_data_r[31:28]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b000) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[31:28]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b001) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[27:24]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b010) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[23:20]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b011) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[19:16]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b100) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[15:12]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b101) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[11:8]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b110) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[7:4]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b111) & (BGB_HF==1'b0) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[3:0]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b000) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[3:0]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b001) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[7:4]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b010) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[11:8]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b011) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[15:12]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b100) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[19:16]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b101) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[23:20]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b110) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[27:24]} :
								(debug_scb_r==1'b0) & (BGB_X[2:0]==3'b111) & (BGB_HF==1'b1) ? {T_BGB_PRI, T_BGB_PAL[1:0], scb_rend_data_r[31:28]} :
*/
								7'b0;

							BGB_X[9:0] <= //(BGB_X + 1) & ({scr_HSIZE, 8'hff});
								BGB_X[9:0] + 10'b01;
							BGB_POS[9:0] <= BGB_POS[9:0] + 10'b01;
`ifdef debug_bgb_width
							BGB_POS_OVER <=
								(scr_H40==1'b0) & (BGB_POS[9:3]==7'd27) ? 1'b1 :
								(scr_H40==1'b1) & (BGB_POS[9:3]==7'd35) ? 1'b1 :
								BGB_POS_OVER;
`else
							BGB_POS_OVER <=
								(scr_H40==1'b0) & (BGB_POS[9:3]==7'd32) ? 1'b1 :
								(scr_H40==1'b1) & (BGB_POS[9:3]==7'd40) ? 1'b1 :
								BGB_POS_OVER;
`endif
							BGBC <= 
							//	(BGB_ACTIVE==1'b0) ? BGBC_DONE :
							//	(BGB_ACTIVE==1'b1) &  ((scr_H40==1'b1 && BGB_POS==319) || (scr_H40==1'b0 && BGB_POS==255)) ? BGBC_DONE :
							//	(BGB_ACTIVE==1'b1) & !((scr_H40==1'b1 && BGB_POS==319) || (scr_H40==1'b0 && BGB_POS==255)) &  (BGB_X[2:0]==3'b111) ? BGBC_CALC_Y :
							//	(BGB_ACTIVE==1'b1) & !((scr_H40==1'b1 && BGB_POS==319) || (scr_H40==1'b0 && BGB_POS==255)) & !(BGB_X[2:0]==3'b111) ? BGBC_LOOP :
								(BGB_ACTIVE==1'b0) ? BGBC_DONE :
								(BGB_ACTIVE==1'b1) & (BGB_POS_OVER==1'b0) & (BGB_X[2:0]!=3'b111) ? BGBC_LOOP :
								(BGB_ACTIVE==1'b1) & (BGB_POS_OVER==1'b0) & (BGB_X[2:0]==3'b111) ? BGBC_CALC_Y :
								(BGB_ACTIVE==1'b1) & (BGB_POS_OVER==1'b1) & (BGB_X[2:0]!=3'b111) ? BGBC_LOOP :
								(BGB_ACTIVE==1'b1) & (BGB_POS_OVER==1'b1) & (BGB_X[2:0]==3'b111) ? BGBC_DONE :
								BGBC_DONE;
						end
					BGBC_DONE: 
						begin
							bgb_render_r <= 1'b0;
							bgb_render_done_r <= 1'b1;
							BGB_SEL <= 1'b0;
							BGB_COLINFO_WE_A <= 1'b0;
							BGB_COLINFO_WE_A0 <= 1'b0;
							BGB_COLINFO_WE_A1 <= 1'b0;
							BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_DONE : BGBC_INIT;
						end
					default: 
						begin
							bgb_render_r <= 1'b0;
							bgb_render_done_r <= 1'b1;
							BGB_SEL <= 1'b0;
							BGB_COLINFO_WE_A <= 1'b0;
							BGB_COLINFO_WE_A0 <= 1'b0;
							BGB_COLINFO_WE_A1 <= 1'b0;
							BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_DONE : BGBC_INIT;
						end
					endcase
			end
	end

end
	else
begin

	assign bgb_render=1'b0;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				BGB_VRAM_ADDR <= 0;
				BGB_SEL <= 1'b0;
				BGBC <= BGBC_INIT;
				BGB_COLINFO_WE_A <= 1'b0;
				BGB_COLINFO_WE_A0 <= 1'b0;
				BGB_COLINFO_WE_A1 <= 1'b0;
				BGB_COLINFO_ADDR_A <= 9'b0;
				BGB_COLINFO_D_A <= 0;
				BGB_X <= 0;
				BGB_POS <= 0;
				BGB_Y <= 0;
				T_BGB_PRI <= 0;
				T_BGB_PAL <= 0;
				BGB_TILEBASE <= 0;
				BGB_HF <= 0;
			end
	end

end
endgenerate

//`else
/*
	reg		bgb_render_r;

	assign bgb_render=bgb_render_r;

	wire 	[9:0]	V_BGB_XSTART;
//	wire 	[15:0]	V_BGB_BASE;

//	assign V_BGB_XSTART=10'b0000000000 - BGB_VRAM_DO[9:0];
	assign V_BGB_XSTART=10'b0000000000 - BGB_VRAM32_DO[9:0];

//	assign V_BGB_BASE=
//			(HSIZE==2'b00) ? ({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 5'b00000}, 1'b0}) :
//			(HSIZE==2'b01) ? ({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 6'b000000}, 1'b0}) :
//			({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 7'b0000000}, 1'b0});

	wire	[9:0] BGB_Y_BASE;

	assign VSRAM1_RADDR[8:0]=
			(BGB_POS[9]==1'b1) ? 9'b0 :
			(BGB_POS[9]==1'b0) & (VSCR==1'b1) ? {4'b0,BGB_POS[8:4]} :
			(BGB_POS[9]==1'b0) & (VSCR==1'b0) ? 9'b0 :
			9'b0;

	assign BGB_Y_BASE[9:0]=(VSRAM1_RDATA[9:0] + {2'b0,PRE_Y[7:0]}) & ({VSIZE, 8'hff});
		//	(BGB_POS[9]==1'b1) ? (VSRAM1[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	(BGB_POS[9]==1'b0) & (VSCR==1'b1) ? (VSRAM[{BGB_POS[8:4], 1'b1}] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	(BGB_POS[9]==1'b0) & (VSCR==1'b0) ? (VSRAM1[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	10'b0;

	reg		[15:0] scb_addr_latch_r;
	reg		scb_addr_hit_r;
	reg		[31:0] scb_data_latch_r;
	wire	[15:0] scb_addr_latch_w;
	wire	scb_addr_hit_w;
	wire	[31:0] scb_data_latch_w;

	always @(negedge RST_N or posedge CLK) begin
		if (RST_N==1'b0) begin
			bgb_render_r <= 1'b0;
			scb_addr_latch_r[15:0] <= 16'b0;
			scb_addr_hit_r <= 1'b0;
			scb_data_latch_r[31:0] <= 32'b0;
						BGB_VRAM_ADDR <= 0;
			BGB_SEL <= 1'b0;
			BGBC <= BGBC_INIT;
			BGB_COLINFO_WE_A <= 1'b0;
			BGB_COLINFO_WE_A0 <= 1'b0;
			BGB_COLINFO_WE_A1 <= 1'b0;
			BGB_COLINFO_ADDR_A <= 9'b0;
							BGB_COLINFO_D_A <= 0;
	BGB_X <= 0;
	BGB_POS <= 0;
	BGB_Y <= 0;
	T_BGB_PRI <= 0;
	T_BGB_PAL <= 0;
	BGB_TILEBASE <= 0;
	BGB_HF <= 0;
		end
		else
		begin
//		//	if (BGB_ACTIVE==1'b1) begin
				case (BGBC)
				BGBC_INIT: begin
//				//	case (HSCR)	// Horizontal scroll mode
//				//	2'b00: begin
//				//		BGB_VRAM_ADDR <= {HSCB, 9'b000000001};
//				//	end
//				//	2'b01: begin
//				//		BGB_VRAM_ADDR <= {{{HSCB, 5'b00000}, Y[2:0]}, 1'b1};
//				//	end
//				//	2'b10: begin
//				//		BGB_VRAM_ADDR <= {{HSCB, Y[7:3]}, 4'b0001};
//				//	end
//				//	2'b11: begin
//				//		BGB_VRAM_ADDR <= {{HSCB, Y}, 1'b1};
//				//	end
//				//	default: begin
//				//	end
//				//	endcase
			bgb_render_r <= (BGB_ACTIVE==1'b1) ? 1'b1 : 1'b0;
						// Horizontal scroll mode
						BGB_VRAM_ADDR <= 
							(HSCR==2'b00) ? {HSCB, 10'b0000000010} :
							(HSCR==2'b01) ? {HSCB, 5'b00000, PRE_Y[2:0], 2'b10} :
							(HSCR==2'b10) ? {HSCB, PRE_Y[7:3], 5'b00010} :
							(HSCR==2'b11) ? {HSCB, PRE_Y[7:0], 2'b10} :
							16'b0;
					BGB_SEL <= (BGB_ACTIVE==1'b1) ? 1'b1 : 1'b0;
					BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_HS_RD : BGBC_INIT;
				end
				BGBC_HS_RD: begin
//				//	V_BGB_XSTART=10'b0000000000 - BGB_VRAM_DO[9:0];
					if (BGB_DTACK_N==1'b0) begin
						BGB_SEL <= 1'b0;
						BGB_X <= ({V_BGB_XSTART[9:3], 3'b000}) & ({HSIZE, 8'hff});
						BGB_POS <= 10'b0000000000 - ({7'b0000000, V_BGB_XSTART[2:0]});
						BGBC <= BGBC_CALC_Y;
					end
				end


				BGBC_CALC_Y: begin
					BGB_COLINFO_WE_A <= 1'b0;
					BGB_COLINFO_WE_A0 <= 1'b0;
					BGB_COLINFO_WE_A1 <= 1'b0;
//				//	if (BGB_POS[9]==1'b1) begin
//				//		BGB_Y <= (VSRAM1[9:0] + Y) & ({VSIZE, 8'hff});
//				//	end else begin
//				//		if (VSCR==1'b1) begin
//				//			//	BGB_Y <= (VSRAM( CONV_INTEGER(BGB_POS(8 downto 4) & "1") )(9 downto 0) + Y) and (VSIZE & "11111111");
//				//			BGB_Y <= (VSRAM[{BGB_POS[8:4], 1'b1}] + Y) & ({VSIZE, 8'hff});
//				//		end else begin
//				//			BGB_Y <= (VSRAM1[9:0] + Y[7:0]) & ({VSIZE, 8'hff});
//				//		end
//				//	end
				//	BGB_Y <= 
				//		(BGB_POS[9]==1'b1) ? (VSRAM1[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		(BGB_POS[9]==1'b0) & (VSCR==1'b1) ? (VSRAM[{BGB_POS[8:4], 1'b1}] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		(BGB_POS[9]==1'b0) & (VSCR==1'b0) ? (VSRAM1[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		10'b0;
					BGB_Y <= BGB_Y_BASE[9:0];
					BGBC <= BGBC_CALC_BASE;
				end
				BGBC_CALC_BASE: begin
//				//	case (HSIZE)
//				//	2'b00: begin
//				//		// HS 32 cells
//				//		V_BGB_BASE=({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 5'b00000}, 1'b0});
//				//	end
//				//	2'b01: begin
//				//		// HS 64 cells
//				//		V_BGB_BASE=({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 6'b000000}, 1'b0});
//				//	end
//				//	default: begin
//				//		// HS 128 cells
//				//		V_BGB_BASE=({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 7'b0000000}, 1'b0});
//				//	end
//				//	endcase
//			//		BGB_VRAM_ADDR <= {V_BGB_BASE[15:1],1'b0};
//			//		BGB_SEL <= 1'b1;
//			//		BGBC <= BGBC_BASE_RD;

					BGB_VRAM_ADDR <= //{V_BGB_BASE[15:1],1'b0};
						(HSIZE==2'b00) ? ({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 5'b00000}, 1'b0}) :
						(HSIZE==2'b01) ? ({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 6'b000000}, 1'b0}) :
						({NTBB, 13'b0000000000000}) + ({BGB_X[9:3], 1'b0}) + ({{BGB_Y[9:3], 7'b0000000}, 1'b0});
					BGBC <= BGBC_BASE_RD;
				end
				BGBC_BASE_RD:
				begin
					scb_addr_hit_r <= (scb_addr_latch_r[15:2]==BGB_VRAM_ADDR[15:2]) & (scb_addr_latch_r[0]==1'b1) ? 1'b1 : 1'b0;
					BGB_SEL <= (scb_addr_latch_r[15:2]==BGB_VRAM_ADDR[15:2]) & (scb_addr_latch_r[0]==1'b1) ? 1'b0 : 1'b1;
				//	BGB_SEL <= (scb_addr_latch_r[15:2]!=BGB_VRAM_ADDR[15:2]) | (scb_addr_latch_r[0]==1'b0) ? 1'b1 : 1'b0;
					BGBC <= BGBC_BASE_RD1;
				end
				BGBC_BASE_RD1:
				begin
//			//		if (BGB_DTACK_N==1'b0) begin
//			//			BGB_SEL <= 1'b0;
//			//			T_BGB_PRI <= BGB_VRAM_DO[15];
//			//			T_BGB_PAL <= BGB_VRAM_DO[14:13];
//			//			BGB_HF <= BGB_VRAM_DO[11];
//			//		//	if (BGB_VRAM_DO[12]==1'b1) begin	// VF
//			//		//		BGB_TILEBASE <= {{BGB_VRAM_DO[10:0],  ~(BGB_Y[2:0])}, 2'b00};
//			//		//	end else begin
//			//		//		BGB_TILEBASE <= {{BGB_VRAM_DO[10:0], BGB_Y[2:0]}, 2'b00};
//			//		//	end
//			//			// VF
//			//			BGB_TILEBASE <=
//			//				(BGB_VRAM_DO[12]==1'b1) ? {{BGB_VRAM_DO[10:0],  ~(BGB_Y[2:0])}, 2'b00} :
//			//				(BGB_VRAM_DO[12]==1'b0) ? {{BGB_VRAM_DO[10:0], BGB_Y[2:0]}, 2'b00} :
//			//				16'b0;
//			//		//	BGBC <= BGBC_LOOP;
//			//			BGBC <= BGBC_TILE;
//			//		end

					if (scb_addr_hit_r==1'b0)
						begin
							if (BGB_DTACK_N==1'b0)
								begin
									BGB_SEL <= 1'b0;
									T_BGB_PRI <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[31] : BGB_VRAM32_DO[15];
									T_BGB_PAL <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[30:29] : BGB_VRAM32_DO[14:13];
									BGB_HF <= (BGB_VRAM_ADDR[1]==1'b0) ? BGB_VRAM32_DO[27] : BGB_VRAM32_DO[11];
									BGB_TILEBASE <=
										(BGB_VRAM_ADDR[1]==1'b0) & (BGB_VRAM32_DO[28]==1'b1) ? {{BGB_VRAM32_DO[26:16],  ~(BGB_Y[2:0])}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b0) & (BGB_VRAM32_DO[28]==1'b0) ? {{BGB_VRAM32_DO[26:16], BGB_Y[2:0]}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (BGB_VRAM32_DO[12]==1'b1) ? {{BGB_VRAM32_DO[10:0],  ~(BGB_Y[2:0])}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (BGB_VRAM32_DO[12]==1'b0) ? {{BGB_VRAM32_DO[10:0], BGB_Y[2:0]}, 2'b00} :
									16'b0;
									BGBC <= BGBC_TILE;
									scb_data_latch_r[31:0] <= BGB_VRAM32_DO[31:0];
									scb_addr_latch_r[15:0] <= {BGB_VRAM_ADDR[15:2],2'b01};
								end
							else
									BGBC <= BGBC_BASE_RD1;
						end
					else
						begin
									T_BGB_PRI <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[31] : scb_data_latch_r[15];
									T_BGB_PAL <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[30:29] : scb_data_latch_r[14:13];
									BGB_HF <= (BGB_VRAM_ADDR[1]==1'b0) ? scb_data_latch_r[27] : scb_data_latch_r[11];
									BGB_TILEBASE <=
										(BGB_VRAM_ADDR[1]==1'b0) & (scb_data_latch_r[28]==1'b1) ? {{scb_data_latch_r[26:16],  ~(BGB_Y[2:0])}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b0) & (scb_data_latch_r[28]==1'b0) ? {{scb_data_latch_r[26:16], BGB_Y[2:0]}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (scb_data_latch_r[12]==1'b1) ? {{scb_data_latch_r[10:0],  ~(BGB_Y[2:0])}, 2'b00} :
										(BGB_VRAM_ADDR[1]==1'b1) & (scb_data_latch_r[12]==1'b0) ? {{scb_data_latch_r[10:0], BGB_Y[2:0]}, 2'b00} :
									16'b0;
									BGBC <= BGBC_TILE;
					end
				end
				BGBC_TILE: begin
						BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 2'b00};
//						//	(BGB_X[2]==1'b0) & (BGB_HF==1'b0) ? {BGB_TILEBASE[15:2], 2'b00} :
//						//	(BGB_X[2]==1'b1) & (BGB_HF==1'b0) ? {BGB_TILEBASE[15:2], 2'b10} :
//						//	(BGB_X[2]==1'b0) & (BGB_HF==1'b1) ? {BGB_TILEBASE[15:2], 2'b10} :
//						//	(BGB_X[2]==1'b1) & (BGB_HF==1'b1) ? {BGB_TILEBASE[15:2], 2'b00} :
//						//	16'b0;
						BGB_SEL <= 1'b1;
						BGBC <= BGBC_TILE_RD;
					end
				BGBC_TILE_RD: begin
					if (BGB_DTACK_N==1'b0) begin
						BGB_SEL <= 1'b0;
						BGBC <= BGBC_LOOP;
					end
				end
				BGBC_LOOP: begin
//				//	if (BGB_X[2:0]==3'b00 && BGB_SEL==1'b0) begin
//				//		BGB_COLINFO_WE_A <= 1'b0;
//				//		BGB_COLINFO_WE_A0 <= 1'b0;
//				//		BGB_COLINFO_WE_A1 <= 1'b0;
//				//	//	if (BGB_X[2]==1'b0) begin
//				//	//		if (BGB_HF==1'b1) begin
//				//	//			BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 1'b1};
//				//	//		end else begin
//				//	//			BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 1'b0};
//				//	//		end
//				//	//	end else begin
//				//	//		if (BGB_HF==1'b1) begin
//				//	//			BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 1'b0};
//				//	//		end else begin
//				//	//			BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 1'b1};
//				//	//		end
//				//	//	end
//				//		BGB_VRAM_ADDR <= {BGB_TILEBASE[15:2], 2'b00};
//				//		//	(BGB_X[2]==1'b0) & (BGB_HF==1'b0) ? {BGB_TILEBASE[15:2], 2'b00} :
//				//		//	(BGB_X[2]==1'b1) & (BGB_HF==1'b0) ? {BGB_TILEBASE[15:2], 2'b10} :
//				//		//	(BGB_X[2]==1'b0) & (BGB_HF==1'b1) ? {BGB_TILEBASE[15:2], 2'b10} :
//				//		//	(BGB_X[2]==1'b1) & (BGB_HF==1'b1) ? {BGB_TILEBASE[15:2], 2'b00} :
//				//		//	16'b0;
//				//		BGB_SEL <= 1'b1;
//				//		BGBC <= BGBC_TILE_RD;
//				//	end else begin
						if (BGB_POS[9]==1'b0) begin
							BGB_COLINFO_ADDR_A <= BGB_POS[8:0];
							BGB_COLINFO_WE_A <= 1'b1;
							BGB_COLINFO_WE_A0 <= (PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
							BGB_COLINFO_WE_A1 <= (PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
//						//	case (BGB_X[1:0])
//						//	2'b00: begin
//						//		if (BGB_HF==1'b1) begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[3:0]};
//						//		end else begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[15:12]};
//						//		end
//						//	end
//						//	2'b01: begin
//						//		if (BGB_HF==1'b1) begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[7:4]};
//						//		end else begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[11:8]};
//						//		end
//						//	end
//						//	2'b10: begin
//						//		if (BGB_HF==1'b1) begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[11:8]};
//						//		end else begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[7:4]};
//						//		end
//						//	end
//						//	default: begin
//						//		if (BGB_HF==1'b1) begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[15:12]};
//						//		end else begin
//						//			BGB_COLINFO_D_A <= {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM_DO[3:0]};
//						//		end
//						//	end
//						//	endcase

							BGB_COLINFO_D_A <=
								(BGB_X[2:0]==3'b000) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[31:28]} :
								(BGB_X[2:0]==3'b001) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[27:24]} :
								(BGB_X[2:0]==3'b010) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[23:20]} :
								(BGB_X[2:0]==3'b011) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[19:16]} :
								(BGB_X[2:0]==3'b100) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[15:12]} :
								(BGB_X[2:0]==3'b101) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[11:8]} :
								(BGB_X[2:0]==3'b110) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[7:4]} :
								(BGB_X[2:0]==3'b111) & (BGB_HF==1'b0) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[3:0]} :
								(BGB_X[2:0]==3'b000) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[3:0]} :
								(BGB_X[2:0]==3'b001) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[7:4]} :
								(BGB_X[2:0]==3'b010) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[11:8]} :
								(BGB_X[2:0]==3'b011) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[15:12]} :
								(BGB_X[2:0]==3'b100) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[19:16]} :
								(BGB_X[2:0]==3'b101) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[23:20]} :
								(BGB_X[2:0]==3'b110) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[27:24]} :
								(BGB_X[2:0]==3'b111) & (BGB_HF==1'b1) ? {{T_BGB_PRI, T_BGB_PAL}, BGB_VRAM32_DO[31:28]} :
								7'b0;
						end
						BGB_X <= (BGB_X + 1) & ({HSIZE, 8'hff});
						if ((scr_H40==1'b1 && BGB_POS==319) || (scr_H40==1'b0 && BGB_POS==255)) begin
							BGBC <= BGBC_DONE;
						end else begin
							BGB_POS <= BGB_POS + 1;
							if (BGB_X[2:0]==3'b111) begin
								BGBC <= BGBC_CALC_Y;
							end else begin
								BGBC <= BGBC_LOOP;
							end
						end
//				//		BGB_SEL <= 1'b0;
//				//	end
				end


				BGBC_DONE: begin
			bgb_render_r <= 1'b0;
					BGB_SEL <= 1'b0;
					BGB_COLINFO_WE_A <= 1'b0;
					BGB_COLINFO_WE_A0 <= 1'b0;
					BGB_COLINFO_WE_A1 <= 1'b0;
								BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_DONE : BGBC_INIT;
				end
				default: begin
//					// BGBC_DONE
			bgb_render_r <= 1'b0;
					BGB_SEL <= 1'b0;
					BGB_COLINFO_WE_A <= 1'b0;
					BGB_COLINFO_WE_A0 <= 1'b0;
					BGB_COLINFO_WE_A1 <= 1'b0;
								BGBC <= (BGB_ACTIVE==1'b1) ? BGBC_DONE : BGBC_INIT;
				end
				endcase
//		//	end else begin	// BGEN_ACTIVE='0'
//		//	bgb_render_r <= 1'b0;
//		//		BGB_SEL <= 1'b0;
//		//		BGBC <= BGBC_INIT;
//		//		BGB_COLINFO_WE_A <= 1'b0;
//		//		BGB_COLINFO_WE_A0 <= 1'b0;
//		//		BGB_COLINFO_WE_A1 <= 1'b0;
//		//	end
		end
	end
*/
//`endif

	//--------------------------------------------------------------
	// BACKGROUND A RENDERING
	//--------------------------------------------------------------

	wire	sca_addr_hit;
	wire	sca_w_inside;

//`ifdef replace_bga_render

generate
	if (disp_bga==1)
begin

	reg		bga_render_r;

	assign bga_render=bga_render_r;

	reg		[15:0] sca_addr_latch_r;
	reg		sca_addr_hit_r;
	reg		[31:0] sca_data_latch_r;
	reg		sca_w_inside_r;
	reg		[2:0] sca_rend_x_r;
	reg		[31:0] sca_rend_data_r;
	wire	[15:0] sca_addr_latch_w;
	wire	sca_addr_hit_w;
	wire	[31:0] sca_data_latch_w;
	wire	sca_w_inside_w;
	wire	[2:0] sca_rend_x_w;
	wire	[31:0] sca_rend_data_w;

	assign sca_addr_hit=sca_addr_hit_r;
//	assign sca_w_inside=sca_w_inside_r;
	assign sca_w_inside=
			(debug_scw_r==1'b1) ? 1'b0 : 
			(debug_scw_r==1'b0) & (WIN_H==1'b1 || WIN_V==1'b1) ? 1'b1 : 
			1'b0;

	wire 	[9:0]	V_BGA_XSTART;
	wire 	[15:0]	V_BGA_BASE;
	wire 	[15:0]	V_BGA_BASE_window;
	wire 	[15:0]	V_BGA_BASE_scroll;
	wire	[9:0] BGA_Y_BASE;
	wire	[9:0] BGA_Y_BASE_scroll;

//	assign V_BGA_XSTART=10'b0000000000 - BGA_VRAM_DO[9:0];
	assign V_BGA_XSTART=10'b0000000000 - BGA_VRAM32_DO[25:16];

	assign V_BGA_BASE_window[15:0]=
			(scr_H40==1'b0) ? {5'b0,PRE_Y[7:3],BGA_POS[7:3],1'b0} :
			(scr_H40==1'b1) ? {5'b0,PRE_Y[7:3],BGA_POS[8:3],1'b0} :
			16'b0;
	
	assign V_BGA_BASE_scroll[15:0]=
			(scr_HSIZE[1:0]==2'b00) ? {3'b0,BGA_Y_BASE[9:3],BGA_X[7:3],1'b0} :
			(scr_HSIZE[1:0]==2'b01) ? {3'b0,BGA_Y_BASE[9:3],BGA_X[8:3],1'b0} :
			(scr_HSIZE[1]  ==1'b1 ) ? {3'b0,BGA_Y_BASE[9:3],BGA_X[9:3],1'b0} :
			16'b0;

	assign V_BGA_BASE[15:0]=
		//	(sca_w_inside_r==1'b1) & (scr_H40==1'b0) ? ({scr_NTWB[4:0], 11'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
		//	(sca_w_inside_r==1'b1) & (scr_H40==1'b1) ? ({scr_NTWB[4:1], 12'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
		//	!(sca_w_inside_r==1'b1) & (scr_HSIZE==2'b00) ? ({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
		//	!(sca_w_inside_r==1'b1) & (scr_HSIZE==2'b01) ? ({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
		//	({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 7'b0000000}, 1'b0});
			(sca_w_inside_r==1'b1) & (scr_H40==1'b0) ? {scr_NTWB[4:0],V_BGA_BASE_window[10:0]} :
			(sca_w_inside_r==1'b1) & (scr_H40==1'b1) ? {scr_NTWB[4:1],V_BGA_BASE_window[11:0]} :
			(sca_w_inside_r==1'b0) ? {scr_NTAB[2:0],V_BGA_BASE_scroll[12:0]} :
			16'b0;

	assign VSRAM0_RADDR[8:0]=
			(BGA_POS[9]==1'b1) ? 9'b0 :
			(BGA_POS[9]==1'b0) & (scr_VSCR==1'b1) ? {4'b0,BGA_POS[8:4]} :
			(BGA_POS[9]==1'b0) & (scr_VSCR==1'b0) ? 9'b0 :
			9'b0;

	assign BGA_Y_BASE_scroll[9:0]=VSRAM0_RDATA[9:0]+{2'b0,PRE_Y[7:0]};

	assign BGA_Y_BASE[9:0]=
	//		(sca_w_inside_r==1'b1) ? {2'b00, PRE_Y[7:0]} :
	//	//	(sca_w_inside_r==1'b0) ? (VSRAM0_RDATA[9:0] + {2'b0,PRE_Y[7:0]}) & ({scr_VSIZE, 8'hff}) :
	//		(sca_w_inside_r==1'b0) & (scr_VSIZE[1:0]==2'b00) ? {2'b00,BGA_Y_BASE_scroll[7:0]} :
	//		(sca_w_inside_r==1'b0) & (scr_VSIZE[1:0]==2'b01) ? {2'b00,BGA_Y_BASE_scroll[8:0]} :
	//		(sca_w_inside_r==1'b0) & (scr_VSIZE[1]  ==1'b1 ) ? {2'b00,BGA_Y_BASE_scroll[9:0]} :
			(scr_VSIZE[1:0]==2'b00) ? {2'b00,BGA_Y_BASE_scroll[7:0]} :
			(scr_VSIZE[1:0]==2'b01) ? {2'b00,BGA_Y_BASE_scroll[8:0]} :
			(scr_VSIZE[1]  ==1'b1 ) ? {2'b00,BGA_Y_BASE_scroll[9:0]} :
			10'b0;

	assign BGA_COLINFO_RD_B0=(PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;

	reg		win_h_boundary_r;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				bga_render_r <= 1'b0;
				sca_addr_latch_r[15:0] <= 16'b0;
				sca_addr_hit_r <= 1'b0;
				sca_data_latch_r[31:0] <= 32'b0;
				sca_w_inside_r <= 1'b0;
				sca_rend_x_r[2:0] <= 3'b0;
				sca_rend_data_r[31:0] <= 32'b0;
				BGA_VRAM_ADDR <= 0;
				BGA_SEL <= 1'b0;
				BGAC <= BGAC_INIT;
				BGA_COLINFO_WE_A <= 1'b0;
				BGA_COLINFO_WE_A0 <= 1'b1;
				BGA_COLINFO_WE_A1 <= 1'b1;
				BGA_COLINFO_ADDR_A <= 9'b0;
				BGA_COLINFO_D_A <= 0;
				BGA_X <= 0;
				BGA_POS[9:0] <= 10'b0;
				BGA_POS_OVER <= 1'b0;
				BGA_Y <= 0;
				T_BGA_PRI <= 0;
				T_BGA_PAL <= 0;
				BGA_TILEBASE <= 0;
				BGA_HF <= 0;
				WIN_V <= 1'b0;
				WIN_H <= 1'b0;
				win_h_boundary_r <= 1'b0;
			end
		else
			begin
				sca_w_inside_r <= 
					(debug_scw_r==1'b1) ? 1'b0 : 
					(debug_scw_r==1'b0) & (WIN_H==1'b1 || WIN_V==1'b1) ? 1'b1 : 
					1'b0;
				case (BGAC)
					BGAC_INIT: 
						begin
							bga_render_r <= (BGA_ACTIVE==1'b1) ? 1'b1 : 1'b0;
							sca_addr_latch_r[15:0] <= 16'b0;
							WIN_V <=
								(PRE_Y[7:0]==8'h00) & (WVP==5'b00000) ? WDOWN :
								(PRE_Y[7:0]==8'h00) & (WVP!=5'b00000) ? ~WDOWN :
								(PRE_Y[7:0]!=8'h00) & (BGA_ACTIVE==1'b1) &  (PRE_Y[2:0]==3'b000 && PRE_Y[7:3]==WVP) ? ~WIN_V :
								(PRE_Y[7:0]!=8'h00) & (BGA_ACTIVE==1'b1) & !(PRE_Y[2:0]==3'b000 && PRE_Y[7:3]==WVP) ? WIN_V :
								(PRE_Y[7:0]!=8'h00) & (BGA_ACTIVE==1'b0) ? WIN_V :
								WIN_V;
							WIN_H <=
								(WHP==5'b00000) ? WRIGT :
								(WHP!=5'b00000) ? ~WRIGT :
								1'b0;
							BGA_VRAM_ADDR <=
								(HSCR==2'b00) ? {HSCB, 10'b0000000000} :
								(HSCR==2'b01) ? {HSCB, 5'b00000, PRE_Y[2:0], 2'b00} :
								(HSCR==2'b10) ? {HSCB, PRE_Y[7:3], 5'b00000} :
								(HSCR==2'b11) ? {HSCB, PRE_Y[7:0], 2'b00} :
								16'b0;
							BGA_SEL <= (BGA_ACTIVE==1'b1) ? 1'b1 : 1'b0;
							BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_HS_RD : BGAC_INIT;
							BGA_POS_OVER <= 1'b0;
						end
					BGAC_HS_RD: 
						begin
				//	V_BGA_XSTART=10'b0000000000 - BGA_VRAM_DO[9:0];
							if (BGA_DTACK_N==1'b0) 
								begin
									BGA_SEL <= 1'b0;
								//	BGA_X <= ({V_BGA_XSTART[9:3], 3'b000}) & ({scr_HSIZE, 8'hff});
								//	BGA_POS <= 10'b0000000000 - ({7'b0000000, V_BGA_XSTART[2:0]});
									BGA_X <= //({V_BGA_XSTART[9:3], 3'b000}) & ({scr_HSIZE, 8'hff});
										(debug_sca_r==1'b1) ? 0 :  {V_BGA_XSTART[9:3], 3'b000};
									BGA_POS[9:0] <= //(sca_w_inside_r==1'b0) ? 10'b0000000000 - ({7'b0000000, V_BGA_XSTART[2:0]}) : 10'b0;
										(debug_sca_r==1'b1) ? 0 : 
										(debug_sca_r==1'b0) & (sca_w_inside_r==1'b0) ? 10'b0000000000 - ({7'b0000000, V_BGA_XSTART[2:0]}) : 10'b0;
									BGAC <= BGAC_CALC_Y;
								end
						end
					BGAC_CALC_Y: 
						begin
							BGA_COLINFO_WE_A <= 1'b0;
							BGA_COLINFO_WE_A0 <= 1'b0;
							BGA_COLINFO_WE_A1 <= 1'b0;
						//	BGA_Y <= BGA_Y_BASE;
							//	(sca_w_inside_r==1'b1) ? {2'b00, PRE_Y[7:0]} :
							//	!(sca_w_inside_r==1'b1) ? (VSRAM0_RDATA[9:0] + {2'b0,PRE_Y[7:0]}) & ({scr_VSIZE, 8'hff}) :
							//	10'b0;
							BGAC <= BGAC_CALC_BASE;
						end
					BGAC_CALC_BASE: 
						begin
							BGA_VRAM_ADDR <= V_BGA_BASE[15:0];
							//	(sca_w_inside_r==1'b1) & (scr_H40==1'b0) ? ({scr_NTWB[4:0], 11'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
							//	(sca_w_inside_r==1'b1) & (scr_H40==1'b1) ? ({scr_NTWB[4:1], 12'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
							//	!(sca_w_inside_r==1'b1) & (scr_HSIZE==2'b00) ? ({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
							//	!(sca_w_inside_r==1'b1) & (scr_HSIZE==2'b01) ? ({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
							//	({scr_NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 7'b0000000}, 1'b0});
							BGA_Y <= (sca_w_inside_r==1'b0) ? BGA_Y_BASE : {2'b00, PRE_Y[7:0]};
							BGAC <= BGAC_BASE_RD;
						end
					BGAC_BASE_RD:
						begin
							sca_addr_hit_r <= (sca_addr_latch_r[15:2]==BGA_VRAM_ADDR[15:2]) & (sca_addr_latch_r[0]==1'b1) ? 1'b1 : 1'b0;
							BGA_SEL <= (sca_addr_latch_r[15:2]==BGA_VRAM_ADDR[15:2]) & (sca_addr_latch_r[0]==1'b1) ? 1'b0 : 1'b1;
							BGAC <= BGAC_BASE_RD1;
						end
					BGAC_BASE_RD1:
						begin
							if (sca_addr_hit_r==1'b0)
								begin
									if (BGA_DTACK_N==1'b0)
										begin
											BGA_SEL <= 1'b0;
											T_BGA_PRI <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[31] : BGA_VRAM32_DO[15];
											T_BGA_PAL <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[30:29] : BGA_VRAM32_DO[14:13];
											BGA_HF <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[27] : BGA_VRAM32_DO[11];
											BGA_TILEBASE <=
												(BGA_VRAM_ADDR[1]==1'b0) & (BGA_VRAM32_DO[28]==1'b1) ? {{BGA_VRAM32_DO[26:16],  ~(BGA_Y[2:0])}, 2'b00} :
												(BGA_VRAM_ADDR[1]==1'b0) & (BGA_VRAM32_DO[28]==1'b0) ? {{BGA_VRAM32_DO[26:16], BGA_Y[2:0]}, 2'b00} :
												(BGA_VRAM_ADDR[1]==1'b1) & (BGA_VRAM32_DO[12]==1'b1) ? {{BGA_VRAM32_DO[10:0],  ~(BGA_Y[2:0])}, 2'b00} :
												(BGA_VRAM_ADDR[1]==1'b1) & (BGA_VRAM32_DO[12]==1'b0) ? {{BGA_VRAM32_DO[10:0], BGA_Y[2:0]}, 2'b00} :
											16'b0;
											BGAC <= BGAC_TILE;
											sca_data_latch_r[31:0] <= BGA_VRAM32_DO[31:0];
											sca_addr_latch_r[15:0] <= {BGA_VRAM_ADDR[15:2],2'b01};
										end
									else
										begin
											BGAC <= BGAC_BASE_RD1;
										end
								end
							else
								begin
									T_BGA_PRI <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[31] : sca_data_latch_r[15];
									T_BGA_PAL <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[30:29] : sca_data_latch_r[14:13];
									BGA_HF <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[27] : sca_data_latch_r[11];
									BGA_TILEBASE <=
										(BGA_VRAM_ADDR[1]==1'b0) & (sca_data_latch_r[28]==1'b1) ? {{sca_data_latch_r[26:16],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b0) & (sca_data_latch_r[28]==1'b0) ? {{sca_data_latch_r[26:16], BGA_Y[2:0]}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (sca_data_latch_r[12]==1'b1) ? {{sca_data_latch_r[10:0],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (sca_data_latch_r[12]==1'b0) ? {{sca_data_latch_r[10:0], BGA_Y[2:0]}, 2'b00} :
									16'b0;
									BGAC <= BGAC_TILE;
								end
						end
					BGAC_TILE: 
						begin
							//	WIN_H <=  
							//		(BGA_POS[9]==1'b0 && WIN_H==1'b0 && scr_WRIGT==1'b1 && BGA_POS[3]==4'b1 && BGA_POS[8:4]==scr_WHP) ? ~WIN_H :
							//		(BGA_POS[9]==1'b0 && WIN_H==1'b1 && scr_WRIGT==1'b0 && BGA_POS[3]==4'b1 && BGA_POS[8:4]==scr_WHP) ? ~WIN_H :
							//		WIN_H;
									begin
										BGA_COLINFO_WE_A <= 1'b0;
										BGA_COLINFO_WE_A0 <= 1'b0;
										BGA_COLINFO_WE_A1 <= 1'b0;
										BGA_SEL <= 1'b1;
										BGAC <= BGAC_TILE_RD;
										BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],1'b0,1'b0};
									end
						end
					BGAC_TILE_RD: 
						begin
							if (BGA_DTACK_N==1'b0) 
								begin
									BGA_SEL <= 1'b0;
									BGAC <= BGAC_LOOP;
									sca_rend_x_r[2:0] <= (sca_w_inside_r==1'b1) ? BGA_POS[2:0] : BGA_X[2:0];
								//	sca_rend_x_r[2:0] <= (sca_w_inside_r==1'b1) ? 3'b0 : BGA_X[2:0];
									sca_rend_data_r[31:0] <= BGA_VRAM32_DO[31:0];
								end
						end
					BGAC_LOOP: 
						begin
									BGA_COLINFO_WE_A <= (BGA_POS[9]==1'b0) ? 1'b1 : 1'b0;
									BGA_COLINFO_WE_A0 <= (BGA_POS[9]==1'b0) & (PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
									BGA_COLINFO_WE_A1 <= (BGA_POS[9]==1'b0) & (PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
									BGA_COLINFO_ADDR_A <= BGA_POS[8:0];

									BGA_COLINFO_D_A <=
										(debug_sca_r==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :

										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b000) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b001) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b010) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b011) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b100) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b101) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b110) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b111) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b000) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b001) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b010) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b011) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b100) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b101) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b110) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
										(debug_sca_r==1'b0) & (sca_rend_x_r[2:0]==3'b111) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
										7'b0;

							sca_rend_x_r[2:0] <= sca_rend_x_r[2:0]+3'b01;
							BGA_X <= //(BGA_X + 1) & ({scr_HSIZE, 8'hff});
								BGA_X + 1;
							BGA_POS[9:0] <= BGA_POS[9:0] + 10'b01;
							BGA_POS_OVER <=
								(scr_H40==1'b1) & (BGA_POS[9:3]==7'd40) ? 1'b1 :
								(scr_H40==1'b0) & (BGA_POS[9:3]==7'd32) ? 1'b1 :
								BGA_POS_OVER;
							BGAC <= 
							//	(BGA_ACTIVE==1'b0) ? BGAC_DONE :
							//	(BGA_ACTIVE==1'b1) &  ((scr_H40==1'b1 && BGA_POS==319) || (scr_H40==1'b0 && BGA_POS==255)) ? BGAC_DONE :
							//	(BGA_ACTIVE==1'b1) & !((scr_H40==1'b1 && BGA_POS==319) || (scr_H40==1'b0 && BGA_POS==255)) &  (sca_rend_x_r[2:0]==3'b111) ? BGAC_CALC_Y :
							//	(BGA_ACTIVE==1'b1) & !((scr_H40==1'b1 && BGA_POS==319) || (scr_H40==1'b0 && BGA_POS==255)) & !(sca_rend_x_r[2:0]==3'b111) ? BGAC_LOOP :
								(BGA_ACTIVE==1'b0) ? BGAC_DONE :
								(BGA_ACTIVE==1'b1) & (sca_rend_x_r[2:0]==3'b111) & (BGA_POS_OVER==1'b1) ? BGAC_DONE :
								(BGA_ACTIVE==1'b1) & (sca_rend_x_r[2:0]==3'b111) & (BGA_POS_OVER==1'b0) ? BGAC_CALC_Y :
							//	(BGA_ACTIVE==1'b1) & (sca_rend_x_r[2:0]!=3'b111) & (BGA_POS_OVER==1'b0) ? BGAC_LOOP :
								(BGA_ACTIVE==1'b1) & (sca_rend_x_r[2:0]!=3'b111) & (BGA_POS_OVER==1'b0) & (win_h_boundary_r==1'b1) ? BGAC_CALC_Y :
								(BGA_ACTIVE==1'b1) & (sca_rend_x_r[2:0]!=3'b111) & (BGA_POS_OVER==1'b0) & (win_h_boundary_r==1'b0) ? BGAC_LOOP :
								BGAC_DONE;
							WIN_H <=  
							//	(BGA_POS[9]==1'b0 && WIN_H==1'b0 && scr_WRIGT==1'b1 && BGA_POS[3]==1'b1 && BGA_POS[8:4]==scr_WHP) & (sca_rend_x_r[2:0]==3'b111) ? ~WIN_H :
							//	(BGA_POS[9]==1'b0 && WIN_H==1'b1 && scr_WRIGT==1'b0 && BGA_POS[3]==1'b1 && BGA_POS[8:4]==scr_WHP) & (sca_rend_x_r[2:0]==3'b111) ? ~WIN_H :
							//	(BGA_POS[9]==1'b0 && WIN_H==1'b0 && scr_WRIGT==1'b1 && BGA_POS[3:0]==4'b1111 && BGA_POS[8:4]==scr_WHP) ? ~WIN_H :
							//	(BGA_POS[9]==1'b0 && WIN_H==1'b1 && scr_WRIGT==1'b0 && BGA_POS[3:0]==4'b1111 && BGA_POS[8:4]==scr_WHP) ? ~WIN_H :
								(win_h_boundary_r==1'b1) ? !WIN_H :
								WIN_H;

							win_h_boundary_r <= 
								(BGA_POS[9]==1'b0) & (WIN_H==1'b0) & (scr_WRIGT==1'b1) & (BGA_POS[3:0]==4'b1110) & (BGA_POS[8:4]==scr_WHP) ? 1'b1 :
								(BGA_POS[9]==1'b0) & (WIN_H==1'b1) & (scr_WRIGT==1'b0) & (BGA_POS[3:0]==4'b1110) & (BGA_POS[8:4]==scr_WHP) ? 1'b1 :
								1'b0;

 						end
					BGAC_DONE: 
						begin
							bga_render_r <= 1'b0;
							BGA_SEL <= 1'b0;
							BGA_COLINFO_WE_A <= 1'b0;
							BGA_COLINFO_WE_A0 <= 1'b0;
							BGA_COLINFO_WE_A1 <= 1'b0;
							BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_DONE : BGAC_INIT;
						end
					default: 
						begin
							bga_render_r <= 1'b0;
							BGA_SEL <= 1'b0;
							BGA_COLINFO_WE_A <= 1'b0;
							BGA_COLINFO_WE_A0 <= 1'b0;
							BGA_COLINFO_WE_A1 <= 1'b0;
							BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_DONE : BGAC_INIT;
						end
				endcase
			end
	end

end
	else
begin

	assign bga_render=1'b0;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				BGA_VRAM_ADDR <= 0;
				BGA_SEL <= 1'b0;
				BGAC <= BGAC_INIT;
				BGA_COLINFO_WE_A <= 1'b0;
				BGA_COLINFO_WE_A0 <= 1'b1;
				BGA_COLINFO_WE_A1 <= 1'b1;
				BGA_COLINFO_ADDR_A <= 9'b0;
				BGA_COLINFO_D_A <= 0;
				BGA_X <= 0;
				BGA_POS <= 0;
				BGA_Y <= 0;
				T_BGA_PRI <= 0;
				T_BGA_PAL <= 0;
				BGA_TILEBASE <= 0;
				BGA_HF <= 0;
	 			WIN_V <= 0;
	 			WIN_H <= 0;
			end
	end

end
endgenerate

//`else
/*
	reg		bga_render_r;

	assign bga_render=bga_render_r;

	wire 	[9:0]	V_BGA_XSTART;
//	wire 	[15:0]	V_BGA_BASE;

//	assign V_BGA_XSTART=10'b0000000000 - BGA_VRAM_DO[9:0];
	assign V_BGA_XSTART=10'b0000000000 - BGA_VRAM32_DO[25:16];

//	assign V_BGA_BASE=
//			(WIN_H==1'b1 || WIN_V==1'b1) ? ({NTWB, 11'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
//			!(WIN_H==1'b1 || WIN_V==1'b1) & (HSIZE==2'b00) ? ({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
//			!(WIN_H==1'b1 || WIN_V==1'b1) & (HSIZE==2'b01) ? ({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
//			({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 7'b0000000}, 1'b0});

	wire	[9:0] BGA_Y_BASE;

	assign VSRAM0_RADDR[8:0]=
			(BGA_POS[9]==1'b1) ? 9'b0 :
			(BGA_POS[9]==1'b0) & (VSCR==1'b1) ? {4'b0,BGA_POS[8:4]} :
			(BGA_POS[9]==1'b0) & (VSCR==1'b0) ? 9'b0 :
			9'b0;

	assign BGA_Y_BASE=
		//	(WIN_H==1'b1 || WIN_V==1'b1) ? {2'b00, PRE_Y[7:0]} :
		//	!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b1) ? (VSRAM0[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b0) & (VSCR==1'b1) ? (VSRAM[{BGA_POS[8:4], 1'b0}] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b0) & (VSCR==1'b0) ? (VSRAM0[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
		//	10'b0;
			(WIN_H==1'b1 || WIN_V==1'b1) ? {2'b00, PRE_Y[7:0]} :
			!(WIN_H==1'b1 || WIN_V==1'b1) ? (VSRAM0_RDATA[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
			10'b0;

	reg		[15:0] sca_addr_latch_r;
	reg		sca_addr_hit_r;
	reg		[31:0] sca_data_latch_r;
	wire	[15:0] sca_addr_latch_w;
	wire	sca_addr_hit_w;
	wire	[31:0] sca_data_latch_w;

	always @(negedge RST_N or posedge CLK) begin
		if (RST_N==1'b0) begin
			bga_render_r <= 1'b0;
			sca_addr_latch_r[15:0] <= 16'b0;
			sca_addr_hit_r <= 1'b0;
			sca_data_latch_r[31:0] <= 32'b0;
					BGA_VRAM_ADDR <= 0;
			BGA_SEL <= 1'b0;
			BGAC <= BGAC_INIT;
			BGA_COLINFO_WE_A <= 1'b0;
			BGA_COLINFO_WE_A0 <= 1'b1;
			BGA_COLINFO_WE_A1 <= 1'b1;
			BGA_COLINFO_ADDR_A <= 9'b0;
	BGA_COLINFO_D_A <= 0;
						BGA_X <= 0;
						BGA_POS <= 0;
						BGA_Y <= 0;
						T_BGA_PRI <= 0;
						T_BGA_PAL <= 0;
						BGA_TILEBASE <= 0;
						BGA_HF <= 0;
	 			WIN_V <= 0;
	 			WIN_H <= 0;
		end
		else
		begin
			if (BGA_ACTIVE==1'b1) begin
				case (BGAC)
				BGAC_INIT: begin
//				//	if (Y[7:0]==8'h00) begin
//				//		if (WVP==5'b00000) begin
//				//			WIN_V <= WDOWN;
//				//		end else begin
//				//			WIN_V <=  ~(WDOWN);
//				//		end
//				//	end else if (Y[2:0]==3'b000 && Y[7:3]==WVP) begin
//				//		WIN_V <=  ~WIN_V;
//				//	end

			bga_render_r <= (BGA_ACTIVE==1'b1) ? 1'b1 : 1'b0;
					WIN_V <=
						(PRE_Y[7:0]==8'h00) & (WVP==5'b00000) ? WDOWN :
						(PRE_Y[7:0]==8'h00) & (WVP!=5'b00000) ? ~(WDOWN) :
						(PRE_Y[7:0]!=8'h00) & (PRE_Y[2:0]==3'b000 && PRE_Y[7:3]==WVP) ? ~WIN_V :
						WIN_V;

//				//	if (WHP==5'b00000) begin
//				//		WIN_H <= WRIGT;
//				//	end else begin
//				//		WIN_H <=  ~(WRIGT);
//				//	end

					WIN_H <= (WHP==5'b00000) ? WRIGT : ~(WRIGT);

//				//	case (HSCR)	// Horizontal scroll mode
//				//	2'b00: begin
//				//		BGA_VRAM_ADDR <= {HSCB, 9'b000000000};
//				//	end
//				//	2'b01: begin
//				//		BGA_VRAM_ADDR <= {{{HSCB, 5'b00000}, Y[2:0]}, 1'b0};
//				//	end
//				//	2'b10: begin
//				//		BGA_VRAM_ADDR <= {{HSCB, Y[7:3]}, 4'b0000};
//				//	end
//				//	2'b11: begin
//				//		BGA_VRAM_ADDR <= {{HSCB, Y[7:0]}, 1'b0};
//				//	end
//				//	default: begin
//				//	end
//				//	endcase

					// Horizontal scroll mode
					BGA_VRAM_ADDR <=
						(scr_HSCR==2'b00) ? {scr_HSCB, 10'b0000000000} :
						(scr_HSCR==2'b01) ? {scr_HSCB, 5'b00000, PRE_Y[2:0], 2'b00} :
						(scr_HSCR==2'b10) ? {scr_HSCB, PRE_Y[7:3], 5'b00000} :
						(scr_HSCR==2'b11) ? {scr_HSCB, PRE_Y[7:0], 2'b00} :
						16'b0;
					BGA_SEL <= (BGA_ACTIVE==1'b1) ? 1'b1 : 1'b0;
					BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_HS_RD : BGAC_INIT;
				end
				BGAC_HS_RD: begin
				//	V_BGA_XSTART=10'b0000000000 - BGA_VRAM_DO[9:0];
					if (BGA_DTACK_N==1'b0) begin
						BGA_SEL <= 1'b0;
						BGA_X <= ({V_BGA_XSTART[9:3], 3'b000}) & ({HSIZE, 8'hff});
						BGA_POS <= 10'b0000000000 - ({7'b0000000, V_BGA_XSTART[2:0]});
						BGAC <= BGAC_CALC_Y;
					end
				end


				BGAC_CALC_Y: begin
					BGA_COLINFO_WE_A <= 1'b0;
					BGA_COLINFO_WE_A0 <= 1'b0;
					BGA_COLINFO_WE_A1 <= 1'b0;
//				//	if (WIN_H==1'b1 || WIN_V==1'b1) begin
//				//		BGA_Y <= {2'b00, Y[7:0]};
//				//	end else begin
//				//		if (BGA_POS[9]==1'b1) begin
//				//			BGA_Y <= (VSRAM0[9:0] + Y[7:0]) & ({VSIZE, 8'hff});
//				//		end else begin
//				//			if (VSCR==1'b1) begin
//				//				//	BGA_Y <= (VSRAM( CONV_INTEGER(BGA_POS(8 downto 4) & "0") )(9 downto 0) + Y[7:0]) and (VSIZE & "11111111");
//				//				BGA_Y <= (VSRAM[{BGA_POS[8:4], 1'b0}] + Y[7:0]) & ({VSIZE, 8'hff});
//				//			end else begin
//				//				BGA_Y <= (VSRAM0[9:0] + Y[7:0]) & ({VSIZE, 8'hff});
//				//			end
//				//		end
//				//	end

				//	BGA_Y <=
				//		(WIN_H==1'b1 || WIN_V==1'b1) ? {2'b00, PRE_Y[7:0]} :
				//		!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b1) ? (VSRAM0[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b0) & (VSCR==1'b1) ? (VSRAM[{BGA_POS[8:4], 1'b0}] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		!(WIN_H==1'b1 || WIN_V==1'b1) & (BGA_POS[9]==1'b0) & (VSCR==1'b0) ? (VSRAM0[9:0] + PRE_Y[7:0]) & ({VSIZE, 8'hff}) :
				//		10'b0;

					BGA_Y <= BGA_Y_BASE;

					BGAC <= BGAC_CALC_BASE;
				end
				BGAC_CALC_BASE: begin
//				//	if (WIN_H==1'b1 || WIN_V==1'b1) begin
//				//		V_BGA_BASE=({NTWB, 11'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0});
//				//	end else begin
//				//		case (HSIZE)
//				//		2'b00: begin
//				//			// HS 32 cells
//				//			V_BGA_BASE=({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0});
//				//		end
//				//		2'b01: begin
//				//			// HS 64 cells
//				//			V_BGA_BASE=({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0});
//				//		end
//				//		default: begin
//				//			// HS 128 cells
//				//			V_BGA_BASE=({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 7'b0000000}, 1'b0});
//				//		end
//				//		endcase
//				//	end
//			//		BGA_VRAM_ADDR <= {V_BGA_BASE[15:1],1'b0};
//			//		BGA_SEL <= 1'b1;
//			//		BGAC <= BGAC_BASE_RD;

					BGA_VRAM_ADDR <= //{V_BGA_BASE[15:1],1'b0};
						(WIN_H==1'b1 || WIN_V==1'b1) ? ({NTWB, 11'b00000000000}) + ({BGA_POS[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
						!(WIN_H==1'b1 || WIN_V==1'b1) & (HSIZE==2'b00) ? ({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 5'b00000}, 1'b0}) :
						!(WIN_H==1'b1 || WIN_V==1'b1) & (HSIZE==2'b01) ? ({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 6'b000000}, 1'b0}) :
						({NTAB, 13'b0000000000000}) + ({BGA_X[9:3], 1'b0}) + ({{BGA_Y[9:3], 7'b0000000}, 1'b0});
					BGAC <= BGAC_BASE_RD;
				end
				BGAC_BASE_RD:
				begin
					sca_addr_hit_r <= (sca_addr_latch_r[15:2]==BGA_VRAM_ADDR[15:2]) & (sca_addr_latch_r[0]==1'b1) ? 1'b1 : 1'b0;
					BGA_SEL <= (sca_addr_latch_r[15:2]==BGA_VRAM_ADDR[15:2]) & (sca_addr_latch_r[0]==1'b1) ? 1'b0 : 1'b1;
				//	BGA_SEL <= (sca_addr_latch_r[15:2]!=BGA_VRAM_ADDR[15:2]) | (sca_addr_latch_r[0]==1'b0) ? 1'b1 : 1'b0;
					BGAC <= BGAC_BASE_RD1;
				end
				BGAC_BASE_RD1:
				begin
//			//		if (BGA_DTACK_N==1'b0) begin
//			//			BGA_SEL <= 1'b0;
//			//			T_BGA_PRI <= BGA_VRAM_DO[15];
//			//			T_BGA_PAL <= BGA_VRAM_DO[14:13];
//			//			BGA_HF <= BGA_VRAM_DO[11];
//			//		//	if (BGA_VRAM_DO[12]==1'b1) begin	// VF
//			//		//		BGA_TILEBASE <= {{BGA_VRAM_DO[10:0],  ~(BGA_Y[2:0])}, 2'b00};
//			//		//	end else begin
//			//		//		BGA_TILEBASE <= {{BGA_VRAM_DO[10:0], BGA_Y[2:0]}, 2'b00};
//			//		//	end
//			//			// VF
//			//			BGA_TILEBASE <=
//			//				(BGA_VRAM_DO[12]==1'b1) ? {{BGA_VRAM_DO[10:0],  ~(BGA_Y[2:0])}, 2'b00} :
//			//				(BGA_VRAM_DO[12]==1'b0) ? {{BGA_VRAM_DO[10:0], BGA_Y[2:0]}, 2'b00} :
//			//			16'b0;
//			//			BGAC <= BGAC_TILE;
//			//		end
//			//	end

					if (sca_addr_hit_r==1'b0)
						begin
							if (BGA_DTACK_N==1'b0)
								begin
									BGA_SEL <= 1'b0;
									T_BGA_PRI <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[31] : BGA_VRAM32_DO[15];
									T_BGA_PAL <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[30:29] : BGA_VRAM32_DO[14:13];
									BGA_HF <= (BGA_VRAM_ADDR[1]==1'b0) ? BGA_VRAM32_DO[27] : BGA_VRAM32_DO[11];
									BGA_TILEBASE <=
										(BGA_VRAM_ADDR[1]==1'b0) & (BGA_VRAM32_DO[28]==1'b1) ? {{BGA_VRAM32_DO[26:16],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b0) & (BGA_VRAM32_DO[28]==1'b0) ? {{BGA_VRAM32_DO[26:16], BGA_Y[2:0]}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (BGA_VRAM32_DO[12]==1'b1) ? {{BGA_VRAM32_DO[10:0],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (BGA_VRAM32_DO[12]==1'b0) ? {{BGA_VRAM32_DO[10:0], BGA_Y[2:0]}, 2'b00} :
									16'b0;
									BGAC <= BGAC_TILE;
									sca_data_latch_r[31:0] <= BGA_VRAM32_DO[31:0];
									sca_addr_latch_r[15:0] <= {BGA_VRAM_ADDR[15:2],2'b01};
								end
							else
									BGAC <= BGAC_BASE_RD1;
						end
					else
						begin
									T_BGA_PRI <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[31] : sca_data_latch_r[15];
									T_BGA_PAL <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[30:29] : sca_data_latch_r[14:13];
									BGA_HF <= (BGA_VRAM_ADDR[1]==1'b0) ? sca_data_latch_r[27] : sca_data_latch_r[11];
									BGA_TILEBASE <=
										(BGA_VRAM_ADDR[1]==1'b0) & (sca_data_latch_r[28]==1'b1) ? {{sca_data_latch_r[26:16],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b0) & (sca_data_latch_r[28]==1'b0) ? {{sca_data_latch_r[26:16], BGA_Y[2:0]}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (sca_data_latch_r[12]==1'b1) ? {{sca_data_latch_r[10:0],  ~(BGA_Y[2:0])}, 2'b00} :
										(BGA_VRAM_ADDR[1]==1'b1) & (sca_data_latch_r[12]==1'b0) ? {{sca_data_latch_r[10:0], BGA_Y[2:0]}, 2'b00} :
									16'b0;
									BGAC <= BGAC_TILE;
					end
				end

				BGAC_TILE: begin

//				//	if (BGA_POS[9]==1'b0 && WIN_H==1'b0 && WRIGT==1'b1 && BGA_POS[3:0]==4'b0000 && BGA_POS[8:4]==WHP) begin
//				//		WIN_H <=  ~WIN_H;
//				//		BGAC <= BGAC_CALC_Y;
//				//	end else if (BGA_POS[9]==1'b0 && WIN_H==1'b1 && WRIGT==1'b0 && BGA_POS[3:0]==4'b0000 && BGA_POS[8:4]==WHP) begin
//				//		WIN_H <=  ~WIN_H;
//				//		BGAC <= BGAC_CALC_Y;
//				//	end else 
					if (WIN_H==1'b1 || WIN_V==1'b1) begin
						BGA_COLINFO_WE_A <= 1'b0;
						BGA_COLINFO_WE_A0 <= 1'b0;
						BGA_COLINFO_WE_A1 <= 1'b0;
						BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],1'b0,1'b0};
						BGA_SEL <= 1'b1;
						BGAC <= BGAC_TILE_RD;
					end 
					else
//				//	 if (WIN_H==1'b0 && WIN_V==1'b0))
					begin
						BGA_COLINFO_WE_A <= 1'b0;
						BGA_COLINFO_WE_A0 <= 1'b0;
						BGA_COLINFO_WE_A1 <= 1'b0;
						BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],1'b0,1'b0};
						BGA_SEL <= 1'b1;
						BGAC <= BGAC_TILE_RD;
					end
				end
				BGAC_TILE_RD: begin
					if (BGA_DTACK_N==1'b0) begin
						BGA_SEL <= 1'b0;
						BGAC <= BGAC_LOOP;
					end
				end

				BGAC_LOOP: begin
//				//	if (BGA_POS[9]==1'b0 && WIN_H==1'b0 && WRIGT==1'b1 && BGA_POS[3:0]==4'b0000 && BGA_POS[8:4]==WHP) begin
//				//		WIN_H <=  ~WIN_H;
//				//		BGAC <= BGAC_CALC_Y;
//				//	end else if (BGA_POS[9]==1'b0 && WIN_H==1'b1 && WRIGT==1'b0 && BGA_POS[3:0]==4'b0000 && BGA_POS[8:4]==WHP) begin
//				//		WIN_H <=  ~WIN_H;
//				//		BGAC <= BGAC_CALC_Y;
//				//	end else if (BGA_POS[2:0]==3'b00 && BGA_SEL==1'b0 && (WIN_H==1'b1 || WIN_V==1'b1)) begin
//				//		BGA_COLINFO_WE_A <= 1'b0;
//				//		BGA_COLINFO_WE_A0 <= 1'b0;
//				//		BGA_COLINFO_WE_A1 <= 1'b0;
//				//	//	if (BGA_POS[2]==1'b0) begin
//				//	//			BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],BGA_HF};
//				//	//	end else begin
//				//	//			BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],!BGA_HF};
//				//	//	end
//				//		BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],1'b0,1'b0};
//				//		//	(BGA_POS[2]==1'b0) ? {BGA_TILEBASE[15:2],BGA_HF,1'b0} :
//				//		//	(BGA_POS[2]==1'b1) ? {BGA_TILEBASE[15:2],!BGA_HF,1'b0} :
//				//		//	16'b0;
//				//		BGA_SEL <= 1'b1;
//				//		BGAC <= BGAC_TILE_RD;
//				//	end else if (BGA_X[2:0]==3'b00 && BGA_SEL==1'b0 && (WIN_H==1'b0 && WIN_V==1'b0)) begin
//				//		BGA_COLINFO_WE_A <= 1'b0;
//				//		BGA_COLINFO_WE_A0 <= 1'b0;
//				//		BGA_COLINFO_WE_A1 <= 1'b0;
//				//	//	if (BGA_X[2]==1'b0) begin
//				//	//			BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],BGA_HF};
//				//	//	end else begin
//				//	//			BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],!BGA_HF};
//				//	//	end
//				//		BGA_VRAM_ADDR <= {BGA_TILEBASE[15:2],1'b0,1'b0};
//				//		//	(BGA_X[2]==1'b0) ? {BGA_TILEBASE[15:2],BGA_HF,1'b0} :
//				//		//	(BGA_X[2]==1'b1) ? {BGA_TILEBASE[15:2],!BGA_HF,1'b0} :
//				//		//	16'b0;
//				//		BGA_SEL <= 1'b1;
//				//		BGAC <= BGAC_TILE_RD;
//				//	end else begin
						if (BGA_POS[9]==1'b0) begin
							BGA_COLINFO_WE_A <= 1'b1;
							BGA_COLINFO_WE_A0 <= (PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
							BGA_COLINFO_WE_A1 <= (PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
							BGA_COLINFO_ADDR_A <= BGA_POS[8:0];
							if (WIN_H==1'b1 || WIN_V==1'b1) begin
//							//	case (BGA_POS[1:0])
//							//	2'b00: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[3:0]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[15:12]};
//							//		end
//							//	end
//							//	2'b01: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[7:4]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[11:8]};
//							//		end
//							//	end
//							//	2'b10: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[11:8]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[7:4]};
//							//		end
//							//	end
//							//	default: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[15:12]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[3:0]};
//							//		end
//							//	end
//							//	endcase

								BGA_COLINFO_D_A <=
									(BGA_POS[2:0]==3'b000) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
									(BGA_POS[2:0]==3'b001) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
									(BGA_POS[2:0]==3'b010) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
									(BGA_POS[2:0]==3'b011) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
									(BGA_POS[2:0]==3'b100) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
									(BGA_POS[2:0]==3'b101) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
									(BGA_POS[2:0]==3'b110) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
									(BGA_POS[2:0]==3'b111) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
									(BGA_POS[2:0]==3'b000) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
									(BGA_POS[2:0]==3'b001) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
									(BGA_POS[2:0]==3'b010) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
									(BGA_POS[2:0]==3'b011) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
									(BGA_POS[2:0]==3'b100) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
									(BGA_POS[2:0]==3'b101) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
									(BGA_POS[2:0]==3'b110) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
									(BGA_POS[2:0]==3'b111) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
									7'b0;

							end else begin
//							//	case (BGA_X[1:0])
//							//	2'b00: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[3:0]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[15:12]};
//							//		end
//							//	end
//							//	2'b01: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[7:4]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[11:8]};
//							//		end
//							//	end
//							//	2'b10: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[11:8]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[7:4]};
//							//		end
//							//	end
//							//	default: begin
//							//		if (BGA_HF==1'b1) begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[15:12]};
//							//		end else begin
//							//			BGA_COLINFO_D_A <= {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM_DO[3:0]};
//							//		end
//							//	end
//							//	endcase

								BGA_COLINFO_D_A <=
									(BGA_X[2:0]==3'b000) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
									(BGA_X[2:0]==3'b001) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
									(BGA_X[2:0]==3'b010) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
									(BGA_X[2:0]==3'b011) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
									(BGA_X[2:0]==3'b100) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
									(BGA_X[2:0]==3'b101) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
									(BGA_X[2:0]==3'b110) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
									(BGA_X[2:0]==3'b111) & (BGA_HF==1'b0) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
									(BGA_X[2:0]==3'b000) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[3:0]} :
									(BGA_X[2:0]==3'b001) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[7:4]} :
									(BGA_X[2:0]==3'b010) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[11:8]} :
									(BGA_X[2:0]==3'b011) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[15:12]} :
									(BGA_X[2:0]==3'b100) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[19:16]} :
									(BGA_X[2:0]==3'b101) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[23:20]} :
									(BGA_X[2:0]==3'b110) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[27:24]} :
									(BGA_X[2:0]==3'b111) & (BGA_HF==1'b1) ? {{T_BGA_PRI, T_BGA_PAL}, BGA_VRAM32_DO[31:28]} :
									7'b0;

							end
						end
						BGA_X <= (BGA_X + 1) & ({HSIZE, 8'hff});
						if ((scr_H40==1'b1 && BGA_POS==319) || (scr_H40==1'b0 && BGA_POS==255)) begin
							BGAC <= BGAC_DONE;
						end else begin
							BGA_POS <= BGA_POS + 1;
							if (BGA_X[2:0]==3'b111 && (WIN_H==1'b0 && WIN_V==1'b0)) begin
								BGAC <= BGAC_CALC_Y;
							end else if (BGA_POS[2:0]==3'b111 && (WIN_H==1'b1 || WIN_V==1'b1)) begin
								BGAC <= BGAC_CALC_Y;
							end else begin
								BGAC <= BGAC_LOOP;
							end
						end
//				//		BGA_SEL <= 1'b0;
//				//	end
				end

				BGAC_DONE: begin
			bga_render_r <= 1'b0;
					BGA_SEL <= 1'b0;
					BGA_COLINFO_WE_A <= 1'b0;
					BGA_COLINFO_WE_A0 <= 1'b0;
					BGA_COLINFO_WE_A1 <= 1'b0;
								BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_DONE : BGAC_INIT;
				end
				default: begin
			bga_render_r <= 1'b0;
					BGA_SEL <= 1'b0;
					BGA_COLINFO_WE_A <= 1'b0;
					BGA_COLINFO_WE_A0 <= 1'b0;
					BGA_COLINFO_WE_A1 <= 1'b0;
								BGAC <= (BGA_ACTIVE==1'b1) ? BGAC_DONE : BGAC_INIT;
				end
				endcase
			end else begin	// BGEN_ACTIVE='0'
			bga_render_r <= 1'b0;
				BGA_SEL <= 1'b0;
				BGAC <= BGAC_INIT;
				BGA_COLINFO_WE_A <= 1'b0;
				BGA_COLINFO_WE_A0 <= 1'b0;
				BGA_COLINFO_WE_A1 <= 1'b0;
			end
		end
	end
*/
//`endif

//`ifdef replace_spr_search

	localparam	spr_ss00=4'd0;
	localparam	spr_ss01=4'd1;
	localparam	spr_ss02=4'd2;
	localparam	spr_ss03=4'd3;
	localparam	spr_ss04=4'd4;
	localparam	spr_ss05=4'd5;
	localparam	spr_ss06=4'd6;
	localparam	spr_ss07=4'd7;

//	[63:48]	----_--yy_yyyy_yyyy
//	[47:32]	----_hhvv_--ll_llll
//	[31:16]	pccv_hnnn_nnnn_nnnn
//	[15:0]	----_--xx_xxxx_xxxx

	reg		spr_search_r;
	wire	spr_search_w;
	reg		spr_search_done_r;
	wire	spr_search_done_w;

	assign spr_search=spr_search_r;

	reg		[3:0] spr_ss_r;
	wire	[3:0] spr_ss_w;

	wire	SP1_SEL_w;
	wire	OBJ_Y_WE_w;
	wire	OBJ_X_WE_w;
	wire	[6:0] OBJ_Y_ADDR_WR_w;
	wire	[31:0] OBJ_Y_D_w;
	wire	[31:0] OBJ_X_D_w;
	wire	[7:0] SP1_X_w;
	wire	[15:0] SP1_VRAM_ADDR_w;


	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
//				OBJ_CUR <= 7'b0;

				spr_search_r <= 1'b0;
				spr_search_done_r <= 1'b0;
				spr_ss_r <= spr_ss00;

				SP1_SEL <= 1'b0;
				OBJ_Y_WE <= 1'b0;
				OBJ_Y_ADDR_WR[8:0] <= 9'b0;
				OBJ_Y_D[31:0] <= 32'b0;
				OBJ_Y_WE <= 1'b0;
				OBJ_X_WE <= 1'b0;
				OBJ_X_D[31:0] <= 32'b0;
				SP1_X <= 8'b0;
				SP1_VRAM_ADDR[15:0] <= 16'b0;
			end
		else 
			begin
				spr_search_r <= spr_search_w;
				spr_search_done_r <= spr_search_done_w;
				spr_ss_r <= spr_ss_w;

				SP1_SEL <= SP1_SEL_w;
				OBJ_Y_WE <= OBJ_Y_WE_w;
				OBJ_Y_ADDR_WR[8:0] <= {2'b0,OBJ_Y_ADDR_WR_w[6:0]};
				OBJ_Y_D[31:0] <= OBJ_Y_D_w[31:0];
				OBJ_X_WE <= OBJ_X_WE_w;
				OBJ_X_D[31:0] <= OBJ_X_D_w[31:0];
				SP1_X[7:0] <= SP1_X_w[7:0];
				SP1_VRAM_ADDR[15:0] <= SP1_VRAM_ADDR_w[15:0];
			end
	end

	assign spr_search_done_w=
			(scr_H40==1'b1) & (SP1_X[6:0]==7'd79) ? 1'b1 :
			(scr_H40==1'b0) & (SP1_X[6:0]==7'd63) ? 1'b1 :
			1'b0;

	assign spr_search_w=
			(spr_ss_r==spr_ss00) ? 1'b0 :
			(spr_ss_r==spr_ss01) ? 1'b1 :
			(spr_ss_r==spr_ss02) ? 1'b1 :
			(spr_ss_r==spr_ss03) ? 1'b1 :
			(spr_ss_r==spr_ss04) ? 1'b1 :
			(spr_ss_r==spr_ss05) ? 1'b0 :
			1'b0;

	assign spr_ss_w=
			(spr_ss_r==spr_ss00) & (SP1E_ACTIVE==1'b0) ? spr_ss00 :
			(spr_ss_r==spr_ss00) & (SP1E_ACTIVE==1'b1) ? spr_ss01 :
			(spr_ss_r==spr_ss01) ? spr_ss02 :
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b1) ? spr_ss02 :
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) ? spr_ss03 :
			(spr_ss_r==spr_ss03) ? spr_ss04 :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b1) ? spr_ss04 :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) & (spr_search_done_r==1'b1) ? spr_ss05 :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) & (spr_search_done_r==1'b0) ? spr_ss01 :
			(spr_ss_r==spr_ss05) & (SP1E_ACTIVE==1'b0) ? spr_ss00 :
			(spr_ss_r==spr_ss05) & (SP1E_ACTIVE==1'b1) ? spr_ss05 :
			spr_ss00;

	assign SP1_VRAM_ADDR_w[15:0]=
			(spr_ss_r==spr_ss00) & (scr_H40==1'b1) ? {SATB[6:1],7'b0,3'b000} :
			(spr_ss_r==spr_ss00) & (scr_H40==1'b0) ? {SATB[6:0],6'b0,3'b000} :
			(spr_ss_r==spr_ss01) ? {SP1_VRAM_ADDR[15:3],3'b000} :
			(spr_ss_r==spr_ss02) ? {SP1_VRAM_ADDR[15:3],3'b000} :
			(spr_ss_r==spr_ss03) ? {SP1_VRAM_ADDR[15:3],3'b100} :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b1) ? {SP1_VRAM_ADDR[15:3],3'b100} :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) & (scr_H40==1'b1) ? {SP1_VRAM_ADDR[15:10],OBJ_Y_D[6:0],3'b100} :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) & (scr_H40==1'b0) ? {SP1_VRAM_ADDR[15:9],OBJ_Y_D[5:0],3'b100} :
			(spr_ss_r==spr_ss05) ? {SP1_VRAM_ADDR[15:3],3'b100} :
			16'b0;

	assign SP1_SEL_w=
			(spr_ss_r==spr_ss01) ? 1'b1 :
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b1) ? 1'b1 :
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) ? 1'b0 :
			(spr_ss_r==spr_ss03) ? 1'b1 :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b1) ? 1'b1 :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) ? 1'b0 :
			1'b0;

	assign OBJ_Y_D_w[31:16]=(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) ? SP1_VRAM32_DO[31:16] : OBJ_Y_D[31:16];
	assign OBJ_Y_D_w[15:0] =
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) & (spr_search_done_r==1'b0) ? SP1_VRAM32_DO[15:0]  :
			(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) & (spr_search_done_r==1'b1) ? {SP1_VRAM32_DO[15:8],8'b0}  :
			OBJ_Y_D[15:0];
	assign OBJ_X_D_w[31:16]=(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) ? SP1_VRAM32_DO[31:16] : OBJ_X_D[31:16];
	assign OBJ_X_D_w[15:0] =(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) ? SP1_VRAM32_DO[15:0]  : OBJ_X_D[15:0];
	assign OBJ_Y_WE_w=(spr_ss_r==spr_ss02) & (SP1_DTACK_N==1'b0) ? 1'b1 : 1'b0;
	assign OBJ_X_WE_w=(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) ? 1'b1 : 1'b0;

	assign SP1_X_w[7:0]=
			(spr_ss_r==spr_ss00) ? 8'b0 :
			(spr_ss_r==spr_ss01) ? SP1_X[7:0] :
			(spr_ss_r==spr_ss02) ? SP1_X[7:0] :
			(spr_ss_r==spr_ss03) ? SP1_X[7:0] :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b1) ? SP1_X[7:0] :
			(spr_ss_r==spr_ss04) & (SP1_DTACK_N==1'b0) ? SP1_X[7:0]+8'h01 :
			(spr_ss_r==spr_ss05) ? SP1_X[7:0] :
			8'b0;
	assign OBJ_Y_ADDR_WR_w[6:0]=
			(spr_ss_r==spr_ss00) ? SP1_X[6:0] :
			(spr_ss_r==spr_ss01) ? SP1_X[6:0] :
			(spr_ss_r==spr_ss02) ? OBJ_Y_ADDR_WR[6:0] :
			(spr_ss_r==spr_ss03) ? OBJ_Y_ADDR_WR[6:0] :
			(spr_ss_r==spr_ss04) ? OBJ_Y_ADDR_WR[6:0] :
			(spr_ss_r==spr_ss05) ? OBJ_Y_ADDR_WR[6:0] :
			7'b0;

//`else
//`endif

//`ifdef replace_spr_render

generate
	if (disp_spr==1)
begin

	// ---- sprite rendering ----

	reg		spr_render_r;
	reg		spr_render_done_r;
	reg		[8:0] OBJ_Y_ADDR_RD_r;
	wire	[8:0] OBJ_Y_ADDR_RD_w;

	wire	spr_render_w;
	wire	spr_render_done_w;
	wire	SP2_SEL_w;
	wire	[15:0] SP2_VRAM_ADDR_w;
	wire	[16:0] SP2C_w;
	wire	[9:0] OBJ_COLINFO_ADDR_A_w;
	wire	OBJ_COLINFO_WE_A_w;
	wire	OBJ_COLINFO_WE_A0_w;
	wire	OBJ_COLINFO_WE_A1_w;
	wire	[6:0] OBJ_COLINFO_D_A_w;
	wire	SCOL_SET_w;
	wire	SOVR_SET_w;
	wire	[3:0] OBJ_COLNO_w;
	wire	[6:0] OBJ_TOT_w;
	wire	OBJ_TOT_OVER_w;
	wire	[6:0] OBJ_NB_w;
	wire	OBJ_NB_OVER_w;
	wire	[9:0] OBJ_X_w;
	wire	OBJ_X_OVER_w;
	wire	[4:0] OBJ_X_OFS_w;
	wire	[4:0] OBJ_X_OFS_COUNT_w;
	wire	[9:0] OBJ_Y_w;
	wire	[9:0] OBJ_Y_OFS_w;
	wire	OBJ_PRI_w;
	wire	[1:0] OBJ_PAL_w;
	wire	OBJ_VF_w;
	wire	OBJ_HF_w;
	wire	[10:0] OBJ_PAT_w;
	wire	[1:0] OBJ_HS_w;
	wire	[1:0] OBJ_VS_w;
	wire	[6:0] OBJ_LINK_w;
	wire	OBJ_LINK_OVER_w;
	wire	[9:0] OBJ_POS_w;
	wire	[15:0] OBJ_TILEBASE_w;
	wire	[7:0] SP2_Y_w;
	wire	[8:0] OBJ_PIX_w;
	wire	OBJ_PIX_OVER_w;


	assign spr_render=spr_render_r;
	assign spr_done=spr_render_done_r;

//	assign OBJ_COLINFO_RD_A0=(PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
//	assign OBJ_COLINFO_RD_B0=(PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_RD_A0=(SP2_Y[0]==1'b0) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_RD_B0=(SP2_Y[0]==1'b1) ? 1'b1 : 1'b0;

	assign OBJ_Y_ADDR_RD[8:0]={2'b00,OBJ_TOT[6:0]};
//	assign OBJ_Y_ADDR_RD[8:0]=OBJ_Y_ADDR_RD_r[8:0];

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				SP2_Y[7:0] <= 8'b0;
				SP2C <= SP2C_INIT;
				spr_render_r <= 1'b0;
				spr_render_done_r <= 1'b0;
				SP2_SEL <= 1'b0;
				SP2_VRAM_ADDR <= 0;
				OBJ_COLINFO_ADDR_A[9:0] <= 10'b0;
				OBJ_COLINFO_WE_A <= 1'b0;
				OBJ_COLINFO_WE_A0 <= 1'b0;
				OBJ_COLINFO_WE_A1 <= 1'b0;
				OBJ_COLINFO_D_A[6:0] <= 0;
				OBJ_Y_ADDR_RD_r[8:0] <= 9'b0;
				SCOL_SET <= 1'b0;
				SOVR_SET <= 1'b0;
				OBJ_COLNO[3:0] <= 0;
				OBJ_TOT[6:0] <= 7'b0;
				OBJ_TOT_OVER <= 1'b0;
				OBJ_NB[6:0] <= 7'b0;
				OBJ_NB_OVER <= 1'b0;
				OBJ_X[9:0] <= 10'b0;
				OBJ_X_OVER <= 1'b0;
				OBJ_X_OFS[4:0] <= 5'b0;
				OBJ_X_OFS_COUNT[4:0] <= 5'b0;
				OBJ_Y_OFS[9:0] <= 10'b0;
				OBJ_Y[9:0] <= 10'b0;
				OBJ_PRI <= 1'b0;
				OBJ_PAL[1:0] <= 2'b0;
				OBJ_VF <= 1'b0;
				OBJ_HF <= 1'b0;
				OBJ_PAT[10:0] <= 11'b0;
				OBJ_HS[1:0] <= 2'b0;
				OBJ_VS[1:0] <= 2'b0;
				OBJ_LINK[6:0] <= 7'b0;
				OBJ_LINK_OVER <= 1'b0;
				OBJ_POS[9:0] <= 10'b0;
				OBJ_TILEBASE[15:0] <= 16'b0;
				OBJ_PIX[8:0] <= 9'b0;
				OBJ_PIX_OVER <= 1'b0;
			end
		else
			begin
				SP2_Y[7:0] <= SP2_Y_w[7:0];
				SP2C <= SP2C_w;
				spr_render_r <= spr_render_w;
				spr_render_done_r <= spr_render_done_w;
				SP2_SEL <= SP2_SEL_w;
				SP2_VRAM_ADDR[15:0] <= SP2_VRAM_ADDR_w[15:0];
				OBJ_COLINFO_ADDR_A[9:0] <= OBJ_COLINFO_ADDR_A_w[9:0];
				OBJ_COLINFO_WE_A <= OBJ_COLINFO_WE_A_w;
				OBJ_COLINFO_WE_A0 <= OBJ_COLINFO_WE_A0_w;
				OBJ_COLINFO_WE_A1 <= OBJ_COLINFO_WE_A1_w;
				OBJ_COLINFO_D_A[6:0] <= OBJ_COLINFO_D_A_w[6:0];
				OBJ_Y_ADDR_RD_r[8:0] <= OBJ_Y_ADDR_RD_w[8:0];
				SCOL_SET <= SCOL_SET_w;
				SOVR_SET <= SOVR_SET_w;
				OBJ_COLNO[3:0] <= OBJ_COLNO_w[3:0];
				OBJ_TOT[6:0] <= OBJ_TOT_w[6:0];
				OBJ_TOT_OVER <= OBJ_TOT_OVER_w;
				OBJ_NB[6:0] <= OBJ_NB_w[6:0];
				OBJ_NB_OVER <= OBJ_NB_OVER_w;
				OBJ_X[9:0] <= OBJ_X_w[9:0];
				OBJ_X_OVER <= OBJ_X_OVER_w;
				OBJ_X_OFS[4:0] <= OBJ_X_OFS_w[4:0];
				OBJ_X_OFS_COUNT[4:0] <= OBJ_X_OFS_COUNT_w[4:0];
				OBJ_Y_OFS[9:0] <= OBJ_Y_OFS_w[9:0];
				OBJ_Y[9:0] <= OBJ_Y_w[9:0];
				OBJ_PRI <= OBJ_PRI_w;
				OBJ_PAL[1:0] <= OBJ_PAL_w[1:0];
				OBJ_VF <= OBJ_VF_w;
				OBJ_HF <= OBJ_HF_w;
				OBJ_PAT[10:0] <= OBJ_PAT_w[10:0];
				OBJ_HS[1:0] <= OBJ_HS_w[1:0];
				OBJ_VS[1:0] <= OBJ_VS_w[1:0];
				OBJ_LINK[6:0] <= OBJ_LINK_w[6:0];
				OBJ_LINK_OVER <= OBJ_LINK_OVER_w;
				OBJ_POS[9:0] <= OBJ_POS_w[9:0];
				OBJ_TILEBASE[15:0] <= OBJ_TILEBASE_w[15:0];
				OBJ_PIX[8:0] <= OBJ_PIX_w[8:0];
				OBJ_PIX_OVER <= OBJ_PIX_OVER_w;
			end
	end

	wire	OBJ_Y_OVER;
	wire	OBJ_X_OFS_OVER;
	wire	OBJ_X_OFS_UNDER;

	assign OBJ_Y_OVER=
			(OBJ_VS==2'b00) &  (OBJ_Y[8:3]==6'b000000) ? 1'b0 :
			(OBJ_VS==2'b00) & !(OBJ_Y[8:3]==6'b000000) ? 1'b1 :
			(OBJ_VS==2'b01) &  (OBJ_Y[8:4]==5'b00000) ? 1'b0 :
			(OBJ_VS==2'b01) & !(OBJ_Y[8:4]==5'b00000) ? 1'b1  :
			(OBJ_VS==2'b10) &  (OBJ_Y[8:3]==6'b000000) ? 1'b0 :
			(OBJ_VS==2'b10) &  (OBJ_Y[8:3]==6'b000001) ? 1'b0 :
			(OBJ_VS==2'b10) &  (OBJ_Y[8:3]==6'b000010) ? 1'b0 :
			(OBJ_VS==2'b10) &  (OBJ_Y[8:3]==6'b000011) ? 1'b1 :
			(OBJ_VS==2'b10) & !(OBJ_Y[8:5]==4'b0000) ? 1'b1 :
			(OBJ_VS==2'b11) &  (OBJ_Y[8:5]==4'b0000) ? 1'b0 :
			(OBJ_VS==2'b11) & !(OBJ_Y[8:5]==4'b0000) ? 1'b1 :
			1'b1;

//	wire	spr_pos_x_under;
//	wire	spr_pos_x_over;
//	wire	spr_pos_y_outer;
//	assign spr_pos_x_under=(OBJ_X_Q[9:0]<=(10'd127-10'd32)) ? 1'b1 : 1'b0;
//	assign spr_pos_x_over =(OBJ_X_Q[9:0]>=(10'd128+10'd320)) ? 1'b1 : 1'b0;
//	assign spr_pos_y_outer=
//			(OBJ_VS==2'b00) & (OBJ_Y_OFS[9:3]==7'b0000000) ? 1'b0 :
//			(OBJ_VS==2'b01) & (OBJ_Y_OFS[9:4]==6'b000000) ? 1'b0 :
//			(OBJ_VS==2'b11) & (OBJ_Y_OFS[9:5]==5'b00000) ? 1'b0 :
//			(OBJ_VS==2'b10) & (OBJ_Y_OFS[9:5]==5'b00000 && OBJ_Y_OFS[4:3] != 2'b11) ? 1'b0 :
//			1'b1;

	assign SP2_Y_w[7:0]=
			(SP2C==SP2C_INIT) ? PRE_Y[7:0] :
			SP2_Y[7:0];

	assign SP2C_w=
			(SP2C==SP2C_INIT) & (SPR_ACTIVE==1'b0) ? SP2C_INIT :
			(SP2C==SP2C_INIT) & (SPR_ACTIVE==1'b1) & (debug_spr_r==1'b1) ? SP2C_INIT :
			(SP2C==SP2C_INIT) & (SPR_ACTIVE==1'b1) & (debug_spr_r==1'b0) ? SP2C_Y_RD :
			(SP2C==SP2C_Y_RD) ? SP2C_Y_RD4 : //SP2C_Y_RD2 :
		//	(SP2C==SP2C_Y_RD2) ? SP2C_Y_RD4 :
			(SP2C==SP2C_Y_RD4) ? SP2C_Y_TST :
			(SP2C==SP2C_Y_TST) & (OBJ_Y_OVER==1'b0) ? SP2C_CALC_XY : //SP2C_X_RD :
			(SP2C==SP2C_Y_TST) & (OBJ_Y_OVER==1'b1) ? SP2C_NEXT :
		//	(SP2C==SP2C_X_RD) ? SP2C_CALC_XY :
			(SP2C==SP2C_CALC_XY) & (OBJ_X_OVER==1'b0) ? SP2C_CALC_BASE :
			(SP2C==SP2C_CALC_XY) & (OBJ_X_OVER==1'b1) ? SP2C_DONE :
			(SP2C==SP2C_CALC_BASE) ? SP2C_TILE_RD :
			(SP2C==SP2C_TILE_RD) & (SPR_ACTIVE==1'b0) ? SP2C_DONE :
			(SP2C==SP2C_TILE_RD) & (SPR_ACTIVE==1'b1) ? SP2C_TILE_RD2 :
			(SP2C==SP2C_TILE_RD2) & (SP2_DTACK_N==1'b1) ? SP2C_TILE_RD2 :
			(SP2C==SP2C_TILE_RD2) & (SP2_DTACK_N==1'b0) ? SP2C_LOOP :
			(SP2C==SP2C_LOOP) ? SP2C_LOOP2 :
			(SP2C==SP2C_LOOP2) ? SP2C_PLOT :
			(SP2C==SP2C_PLOT) & (SPR_ACTIVE==1'b0) ? SP2C_DONE :
			(SP2C==SP2C_PLOT) & (SPR_ACTIVE==1'b1) & (OBJ_X_OFS_COUNT[2:0]!=3'b000) ? SP2C_LOOP :
			(SP2C==SP2C_PLOT) & (SPR_ACTIVE==1'b1) & (OBJ_X_OFS_COUNT[2:0]==3'b000) & (OBJ_X_OFS_COUNT[4:3]!=2'b00) ? SP2C_TILE_RD :
			(SP2C==SP2C_PLOT) & (SPR_ACTIVE==1'b1) & (OBJ_X_OFS_COUNT[2:0]==3'b000) & (OBJ_X_OFS_COUNT[4:3]==2'b00) ? SP2C_NEXT :
			(SP2C==SP2C_NEXT) &  ((SPR_ACTIVE==1'b0) | (OBJ_TOT_OVER==1'b1) | (OBJ_NB_OVER==1'b1) | (OBJ_PIX_OVER==1'b1) | (OBJ_LINK_OVER==1'b1)) ? SP2C_DONE :
			(SP2C==SP2C_NEXT) & !((SPR_ACTIVE==1'b0) | (OBJ_TOT_OVER==1'b1) | (OBJ_NB_OVER==1'b1) | (OBJ_PIX_OVER==1'b1) | (OBJ_LINK_OVER==1'b1)) ? SP2C_Y_RD :
			(SP2C==SP2C_DONE) & (SPR_ACTIVE==1'b1) ? SP2C_DONE :
			(SP2C==SP2C_DONE) & (SPR_ACTIVE==1'b0) ? SP2C_INIT :
			SP2C_DONE;

	assign spr_render_w=
			(SP2C==SP2C_INIT) & (SPR_ACTIVE==1'b0) ? 1'b0 :
			(SP2C==SP2C_INIT) & (SPR_ACTIVE==1'b1) ? 1'b1 :
			(SP2C==SP2C_DONE) ? 1'b0 :
			spr_render_r;

	assign spr_render_done_w=
			(SP2C==SP2C_DONE) ? 1'b1 :
			1'b0;

	assign SP2_SEL_w=
			(SP2C==SP2C_TILE_RD) & (SPR_ACTIVE==1'b0) ? 1'b0 :
			(SP2C==SP2C_TILE_RD) & (SPR_ACTIVE==1'b1) ? 1'b1 :
			(SP2C==SP2C_TILE_RD2) & (SP2_DTACK_N==1'b1) ? 1'b1 :
			(SP2C==SP2C_TILE_RD2) & (SP2_DTACK_N==1'b0) ? 1'b0 :
			1'b0;

	assign SP2_VRAM_ADDR_w[15:0]=
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b00) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 3'b000}, 1'b0,1'b0}) :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b01) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 4'b0000}, 1'b0,1'b0}) :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b11) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 5'b00000}, 1'b0,1'b0}) :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b00) ? OBJ_TILEBASE + {7'b0000000, 1'b0,1'b0} :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b01) ? OBJ_TILEBASE + {7'b0011000, 1'b0,1'b0} :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b10) ? OBJ_TILEBASE + {7'b0110000, 1'b0,1'b0} :
			(SP2C==SP2C_TILE_RD) &(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b11) ? OBJ_TILEBASE + {7'b1001000, 1'b0,1'b0} :
			SP2_VRAM_ADDR[15:0];

	assign OBJ_COLINFO_ADDR_A_w[9:0]=(SP2C==SP2C_LOOP) ? OBJ_POS[9:0] : OBJ_COLINFO_ADDR_A[9:0];
	assign OBJ_COLINFO_WE_A_w=(SP2C==SP2C_PLOT) & (OBJ_POS[8:0] < 9'd320) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_WE_A0_w=(SP2C==SP2C_PLOT) & (OBJ_POS[8:0] < 9'd320) & (OBJ_COLINFO_RD_A0==1'b1) & (OBJ_COLINFO_Q_A0[7]==1'b0) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_WE_A1_w=(SP2C==SP2C_PLOT) & (OBJ_POS[8:0] < 9'd320) & (OBJ_COLINFO_RD_A0==1'b0) & (OBJ_COLINFO_Q_A1[7]==1'b0) ? 1'b1 : 1'b0;
	assign OBJ_COLNO_w[3:0]=
			(OBJ_X_OFS[2:0]==3'b000) ? SP2_VRAM32_DO[31:28] :
			(OBJ_X_OFS[2:0]==3'b001) ? SP2_VRAM32_DO[27:24] :
			(OBJ_X_OFS[2:0]==3'b010) ? SP2_VRAM32_DO[23:20] :
			(OBJ_X_OFS[2:0]==3'b011) ? SP2_VRAM32_DO[19:16] :
			(OBJ_X_OFS[2:0]==3'b100) ? SP2_VRAM32_DO[15:12] :
			(OBJ_X_OFS[2:0]==3'b101) ? SP2_VRAM32_DO[11:8] :
			(OBJ_X_OFS[2:0]==3'b110) ? SP2_VRAM32_DO[7:4] :
			(OBJ_X_OFS[2:0]==3'b111) ? SP2_VRAM32_DO[3:0] :
			4'b0;
	assign OBJ_COLINFO_D_A_w[6:0]={OBJ_PRI, OBJ_PAL, OBJ_COLNO[3:0]};

	assign OBJ_Y_ADDR_RD_w[8:0]=(SP2C==SP2C_Y_RD) ? {2'b00,OBJ_TOT[6:0]} : OBJ_Y_ADDR_RD_r[8:0];
	assign SCOL_SET_w=(SP2C==SP2C_PLOT) & (OBJ_POS[9]==1'b0) & (OBJ_COLINFO_Q_A0[7]==1'b1) ? 1'b1 : 1'b0;
	assign SOVR_SET_w=(SP2C==SP2C_NEXT) & ((OBJ_NB_OVER==1'b1) | (OBJ_PIX_OVER==1'b1)) ? 1'b1 : 1'b0;

	assign OBJ_TOT_w[6:0]=
			(SP2C==SP2C_INIT) ? 7'b0 :
			(SP2C==SP2C_NEXT) ? OBJ_TOT[6:0]+7'b01 :
			OBJ_TOT[6:0];

	assign OBJ_TOT_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b1) & (OBJ_TOT==80-1) ? 1'b1 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b0) & (OBJ_TOT==64-1) ? 1'b1 :
			OBJ_TOT_OVER;

	assign OBJ_NB_w[6:0]=
			(SP2C==SP2C_INIT) ? 7'b0 :
			(SP2C==SP2C_CALC_XY) ? OBJ_NB[6:0]+7'b01 :
			OBJ_NB[6:0];

	assign OBJ_X_OVER_w=
			(SP2C==SP2C_Y_RD4) & (OBJ_X_Q[8:0]==9'b0) ? 1'b1 :
			(SP2C==SP2C_Y_RD4) & (OBJ_X_Q[8:0]!=9'b0) ? 1'b0 :
			OBJ_X_OVER;

	assign OBJ_X_w[9:0]=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[9:0] : OBJ_X[9:0];
	assign OBJ_PRI_w=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[31] : OBJ_PRI;
	assign OBJ_PAL_w[1:0]=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[30:29] : OBJ_PAL[1:0];
	assign OBJ_VF_w=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[28] : OBJ_VF;
	assign OBJ_HF_w=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[27] : OBJ_HF;
	assign OBJ_PAT_w[10:0]=(SP2C==SP2C_Y_RD4) ? OBJ_X_Q[26:16] : OBJ_PAT[10:0];

//	assign OBJ_Y_w[9:0]=(SP2C==SP2C_Y_RD4) ? 10'b00_1000_0000 + ({2'b0, PRE_Y[7:0]}) - OBJ_Y_Q[9:0] : OBJ_Y[9:0];
	assign OBJ_Y_w[9:0]=(SP2C==SP2C_Y_RD4) ? 10'b00_1000_0000 + ({2'b0, SP2_Y[7:0]}) - OBJ_Y_Q[9:0] : OBJ_Y[9:0];

	assign OBJ_HS_w[1:0]=(SP2C==SP2C_Y_RD4) ? OBJ_SZ_LINK_Q[11:10] : OBJ_HS[1:0];
	assign OBJ_VS_w[1:0]=(SP2C==SP2C_Y_RD4) ? OBJ_SZ_LINK_Q[9:8] : OBJ_VS[1:0];
	assign OBJ_LINK_w[6:0]=(SP2C==SP2C_Y_RD4) ? OBJ_SZ_LINK_Q[6:0] : OBJ_LINK[6:0];
//	assign OBJ_LINK_OVER_w=(OBJ_LINK[6:0]==7'b0) ? 1'b1 : 1'b0;

	assign OBJ_LINK_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_Y_RD4) & (OBJ_SZ_LINK_Q[6:0]==7'b0) ? 1'b1 :
			OBJ_LINK_OVER;

	assign OBJ_Y_OFS_w[9:0]=
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b00) & (OBJ_VF==1'b0) ? {OBJ_Y[9:5],OBJ_Y[4:0]} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b01) & (OBJ_VF==1'b0) ? {OBJ_Y[9:5],OBJ_Y[4:0]} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b11) & (OBJ_VF==1'b0) ? {OBJ_Y[9:5],OBJ_Y[4:0]} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b10) & (OBJ_VF==1'b0) ? {OBJ_Y[9:5],OBJ_Y[4:0]} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b00) & (OBJ_VF==1'b1) ? {OBJ_Y[9:5],2'b00,  ~(OBJ_Y[2:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b01) & (OBJ_VF==1'b1) ? {OBJ_Y[9:5],1'b0,  ~(OBJ_Y[3:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b11) & (OBJ_VF==1'b1) ? {OBJ_Y[9:5], ~(OBJ_Y[4:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y[4:3]==2'b00) ? {OBJ_Y[9:5],2'b10,~(OBJ_Y[2:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y[4:3]==2'b10) ? {OBJ_Y[9:5],2'b00,~(OBJ_Y[2:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y[4:3]==2'b11) ? {OBJ_Y[9:5],2'b01,~(OBJ_Y[2:0])} :
			(SP2C==SP2C_CALC_XY) &(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y[4:3]==2'b01) ? {OBJ_Y[9:5],2'b01,~(OBJ_Y[2:0])} :
			OBJ_Y_OFS[9:0];

	assign OBJ_X_OFS_w[4:0]=
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b00) & (OBJ_HF==1'b0) ? 5'b00000 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b01) & (OBJ_HF==1'b0) ? 5'b00000 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b10) & (OBJ_HF==1'b0) ? 5'b00000 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b11) & (OBJ_HF==1'b0) ? 5'b00000 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b00) & (OBJ_HF==1'b1) ? 5'b00111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b01) & (OBJ_HF==1'b1) ? 5'b01111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b10) & (OBJ_HF==1'b1) ? 5'b10111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b11) & (OBJ_HF==1'b1) ? 5'b11111 :
			(SP2C==SP2C_PLOT) & (OBJ_HF==1'b0) ? OBJ_X_OFS[4:0] + 5'b01 :
			(SP2C==SP2C_PLOT) & (OBJ_HF==1'b1) ? OBJ_X_OFS[4:0] - 5'b01 :
			OBJ_X_OFS[4:0];

	assign OBJ_X_OFS_COUNT_w[4:0]=
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b00) ? 5'b00111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b01) ? 5'b01111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b10) ? 5'b10111 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b11) ? 5'b11111 :
			(SP2C==SP2C_PLOT) ? OBJ_X_OFS_COUNT[4:0] - 5'b01 :
			OBJ_X_OFS_COUNT[4:0];

	assign OBJ_PIX_w[8:0]=
			(SP2C==SP2C_INIT) ? 9'b0 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b00) ? OBJ_PIX + 8 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b01) ? OBJ_PIX + 16 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b10) ? OBJ_PIX + 24 :
			(SP2C==SP2C_CALC_XY) & (OBJ_HS==2'b11) ? OBJ_PIX + 32 :
			OBJ_PIX[8:0];

	assign OBJ_POS_w[9:0]=
			(SP2C==SP2C_CALC_BASE) ? OBJ_X[9:0] - 10'b00_1000_0000 :
			(SP2C==SP2C_PLOT) ? OBJ_POS[9:0] + 10'b01 :
			OBJ_POS[9:0];

	assign OBJ_TILEBASE_w[15:0]=
			(SP2C==SP2C_CALC_BASE) ? ({OBJ_PAT[10:0], 5'b0000}) + ({OBJ_Y_OFS[8:0], 2'b00}) :
			OBJ_TILEBASE[15:0];

`ifdef spr_render_limit

	assign OBJ_NB_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b1) & (OBJ_NB==20-1) ? 1'b1 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b0) & (OBJ_NB==16-1) ? 1'b1 :
			OBJ_NB_OVER;

	assign OBJ_PIX_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b1) & (OBJ_PIX >= 320) ? 1'b1 :
			(SP2C==SP2C_CALC_BASE) & (scr_H40==1'b0) & (OBJ_PIX >= 256) ? 1'b1 :
			OBJ_PIX_OVER;

`else

	assign OBJ_NB_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_CALC_BASE) & (OBJ_NB==40-1) ? 1'b1 :
			OBJ_NB_OVER;

	assign OBJ_PIX_OVER_w=
			(SP2C==SP2C_INIT) ? 1'b0 :
			(SP2C==SP2C_CALC_BASE) & (OBJ_PIX >= 512-64) ? 1'b1 :
			OBJ_PIX_OVER;

`endif

end
	else
begin

	assign spr_render=1'b0;
	assign OBJ_Y_ADDR_RD=9'b0;
	assign OBJ_COLINFO_RD_A0=1'b0;
	assign OBJ_COLINFO_RD_B0=1'b0;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				SP2_SEL <= 1'b0;
				SP2_VRAM_ADDR <= 0;
				SP2C <= SP2C_INIT;
				OBJ_COLINFO_ADDR_A <= 9'b0;
				OBJ_COLINFO_WE_A <= 1'b0;
				OBJ_COLINFO_WE_A0 <= 1'b0;
				OBJ_COLINFO_WE_A1 <= 1'b0;
				OBJ_COLINFO_D_A <= 0;
			//	OBJ_Y_ADDR_RD <= 9'b0;
				SCOL_SET <= 1'b0;
				SOVR_SET <= 1'b0;
				OBJ_X <= 0;
				OBJ_PRI <= 0;
				OBJ_PAL <= 0;
				OBJ_VF <= 0;
				OBJ_HF <= 0;
				OBJ_PAT <= 0;
				OBJ_X_OFS <= 0;
				OBJ_Y_OFS <= 0;
				OBJ_HS <= 0;
				OBJ_VS <= 0;
				OBJ_LINK <= 0;
				OBJ_POS <= 0;
				OBJ_TILEBASE <= 0;
				OBJ_COLNO <= 0;
			end
	end

end
endgenerate

//`else
/*
generate
	if (disp_spr==1)
begin

	// ---- sprite rendering ----

	reg		spr_render_r;
	reg		[8:0] OBJ_Y_ADDR_RD_r;

	assign spr_render=spr_render_r;

	assign OBJ_Y_ADDR_RD[8:0]=OBJ_Y_ADDR_RD_r[8:0];

	assign OBJ_COLINFO_RD_A0=(PRE_Y[0]==1'b0) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_RD_B0=(PRE_Y[0]==1'b1) ? 1'b1 : 1'b0;

	reg		[511:0] obj_store_r;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				spr_render_r <= 1'b0;
				SP2_SEL <= 1'b0;
				SP2_VRAM_ADDR <= 0;
				SP2C <= SP2C_INIT;
				OBJ_COLINFO_ADDR_A <= 9'b0;
				OBJ_COLINFO_WE_A <= 1'b0;
				OBJ_COLINFO_WE_A0 <= 1'b0;
				OBJ_COLINFO_WE_A1 <= 1'b0;
				OBJ_COLINFO_D_A <= 0;
				OBJ_Y_ADDR_RD_r <= 9'b0;
				SCOL_SET <= 1'b0;
				SOVR_SET <= 1'b0;
				OBJ_X <= 0;
				OBJ_X_OVER <= 1'b0;
				OBJ_PRI <= 0;
				OBJ_PAL <= 0;
				OBJ_VF <= 0;
				OBJ_HF <= 0;
				OBJ_PAT <= 0;
				OBJ_X_OFS <= 0;
				OBJ_X_OFS_COUNT <= 0;
				OBJ_Y_OFS <= 0;
				OBJ_HS <= 0;
				OBJ_VS <= 0;
				OBJ_LINK <= 0;
				OBJ_LINK_OVER <= 1'b0;
				OBJ_POS <= 0;
				OBJ_TILEBASE <= 0;
				OBJ_COLNO <= 0;
			end
		else
			begin
				SCOL_SET <= 1'b0;
				SOVR_SET <= 1'b0;
				case (SP2C)
					SP2C_INIT: 
						begin
							SP2_Y[7:0] <= PRE_Y[7:0];
							OBJ_TOT <= 7'b0;
							OBJ_TOT_OVER <= 1'b0;
						//	OBJ_NEXT <= 7'b0;
							OBJ_NB <= 7'b0;
							OBJ_NB_OVER <= 1'b0;
							OBJ_PIX <= 9'b0;
							OBJ_PIX_OVER <= 1'b0;
							spr_render_r <= (SPR_ACTIVE==1'b1) ? 1'b1 : 1'b0;
							SP2C <= (SPR_ACTIVE==1'b1) ? SP2C_Y_RD : SP2C_INIT;
							obj_store_r[511:0] <= 512'b0;
							SP2_SEL <= 1'b0;
							OBJ_COLINFO_ADDR_A <= 9'b0;
							OBJ_COLINFO_WE_A <= 1'b0;
							OBJ_COLINFO_WE_A0 <= 1'b0;
							OBJ_COLINFO_WE_A1 <= 1'b0;
							OBJ_Y_ADDR_RD_r <= 9'b0;
						end
					SP2C_Y_RD: 
						begin
							OBJ_COLINFO_WE_A <= 1'b0;
							OBJ_COLINFO_WE_A0 <= 1'b0;
							OBJ_COLINFO_WE_A1 <= 1'b0;
							OBJ_Y_ADDR_RD_r <= {2'b00, OBJ_TOT};
							SP2C <= SP2C_Y_RD2;
						end
					SP2C_Y_RD2: 
						begin
							SP2C <= SP2C_Y_RD4;
						end
					SP2C_Y_RD4: 
						begin
							OBJ_Y_OFS <= 9'b010000000 + ({2'b0, SP2_Y}) - OBJ_Y_Q[8:0];
							OBJ_HS <= OBJ_SZ_LINK_Q[11:10];
							OBJ_VS <= OBJ_SZ_LINK_Q[9:8];
							OBJ_LINK <= OBJ_SZ_LINK_Q[6:0];
							OBJ_LINK_OVER <= (OBJ_SZ_LINK_Q[6:0]==7'b0) ? 1'b1 : 1'b0;
							SP2C <= SP2C_Y_TST;
						end
					SP2C_Y_TST:
						begin
							SP2C <= 
								(OBJ_VS==2'b00) & (OBJ_Y_OFS[8:3]==6'b000000) ? SP2C_X_RD : //SP2C_SHOW :
								(OBJ_VS==2'b01) & (OBJ_Y_OFS[8:4]==5'b00000) ? SP2C_X_RD : //SP2C_SHOW :
								(OBJ_VS==2'b11) & (OBJ_Y_OFS[8:5]==4'b0000) ? SP2C_X_RD : //SP2C_SHOW :
								(OBJ_VS==2'b10) & (OBJ_Y_OFS[8:5]==4'b0000 && OBJ_Y_OFS[4:3] != 2'b11) ? SP2C_X_RD : //SP2C_SHOW :
								SP2C_NEXT;
					end
				SP2C_SHOW: 
					begin
						SP2C <= SP2C_X_RD;
					end
				SP2C_X_RD: 
					begin
						OBJ_X <= OBJ_X_Q[8:0];
						OBJ_PRI <= OBJ_X_Q[31];
						OBJ_PAL <= OBJ_X_Q[30:29];
						OBJ_VF <= OBJ_X_Q[28];
						OBJ_HF <= OBJ_X_Q[27];
						OBJ_PAT <= OBJ_X_Q[26:16];
						SP2C <= SP2C_CALC_XY;
						OBJ_X_OVER <= (OBJ_X==9'b000000000) ? 1'b1 : 1'b0;
					end
				SP2C_CALC_XY: 
				begin

					OBJ_X_OFS <=
						(OBJ_HS==2'b00) & (OBJ_HF==1'b0) ? 5'b00000 :
						(OBJ_HS==2'b01) & (OBJ_HF==1'b0) ? 5'b00000 :
						(OBJ_HS==2'b10) & (OBJ_HF==1'b0) ? 5'b00000 :
						(OBJ_HS==2'b11) & (OBJ_HF==1'b0) ? 5'b00000 :
						(OBJ_HS==2'b00) & (OBJ_HF==1'b1) ? 5'b00111 :
						(OBJ_HS==2'b01) & (OBJ_HF==1'b1) ? 5'b01111 :
						(OBJ_HS==2'b10) & (OBJ_HF==1'b1) ? 5'b10111 :
						(OBJ_HS==2'b11) & (OBJ_HF==1'b1) ? 5'b11111 :
						5'b0;
					OBJ_X_OFS_COUNT <=
						(OBJ_HS==2'b00) ? 5'b00111 :
						(OBJ_HS==2'b01) ? 5'b01111 :
						(OBJ_HS==2'b10) ? 5'b10111 :
						(OBJ_HS==2'b11) ? 5'b11111 :
						5'b0;
					OBJ_PIX <=
						(OBJ_HS==2'b00) ? OBJ_PIX + 8 :
						(OBJ_HS==2'b01) ? OBJ_PIX + 16 :
						(OBJ_HS==2'b10) ? OBJ_PIX + 24 :
						(OBJ_HS==2'b11) ? OBJ_PIX + 32 :
						9'b0;

					OBJ_Y_OFS[4:0] <=
						(OBJ_VS==2'b00) & (OBJ_VF==1'b0) ? OBJ_Y_OFS[4:0] :
						(OBJ_VS==2'b01) & (OBJ_VF==1'b0) ? OBJ_Y_OFS[4:0] :
						(OBJ_VS==2'b11) & (OBJ_VF==1'b0) ? OBJ_Y_OFS[4:0] :
						(OBJ_VS==2'b10) & (OBJ_VF==1'b0) ? OBJ_Y_OFS[4:0] :
						(OBJ_VS==2'b00) & (OBJ_VF==1'b1) ? {2'b00,  ~(OBJ_Y_OFS[2:0])} :
						(OBJ_VS==2'b01) & (OBJ_VF==1'b1) ? {1'b0,  ~(OBJ_Y_OFS[3:0])} :
						(OBJ_VS==2'b11) & (OBJ_VF==1'b1) ?  ~(OBJ_Y_OFS[4:0]) :
						(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y_OFS[4:3]==2'b00) ? {2'b10,~(OBJ_Y_OFS[2:0])} :
						(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y_OFS[4:3]==2'b10) ? {2'b00,~(OBJ_Y_OFS[2:0])} :
						(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y_OFS[4:3]==2'b11) ? {2'b01,~(OBJ_Y_OFS[2:0])} :
						(OBJ_VS==2'b10) & (OBJ_VF==1'b1) & (OBJ_Y_OFS[4:3]==2'b01) ? {2'b01,~(OBJ_Y_OFS[2:0])} :
						5'b0;

					OBJ_NB <= OBJ_NB + 1;
					SP2C <= (OBJ_X_OVER==1'b1) ? SP2C_DONE : SP2C_CALC_BASE;
				end
				SP2C_CALC_BASE: begin
`ifdef spr_render_limit
					OBJ_NB_OVER <= 
						(scr_H40==1'b1) & (OBJ_NB==20-1) ? 1'b1 :
						(scr_H40==1'b0) & (OBJ_NB==16-1) ? 1'b1 :
						OBJ_NB_OVER;
					OBJ_PIX_OVER <=
						(scr_H40==1'b1) & (OBJ_PIX >= 320) ? 1'b1 :
						(scr_H40==1'b0) & (OBJ_PIX >= 256) ? 1'b1 :
						OBJ_PIX_OVER;
`else
					OBJ_NB_OVER <= 
						(OBJ_NB==40-1) ? 1'b1 :
						OBJ_NB_OVER;
					OBJ_PIX_OVER <= 
						(OBJ_PIX >= 512-64) ? 1'b1 :
						OBJ_PIX_OVER;
`endif
					OBJ_TOT_OVER <= 
						(scr_H40==1'b1) & (OBJ_TOT==80-1) ? 1'b1 :
						(scr_H40==1'b0) & (OBJ_TOT==64-1) ? 1'b1 :
						OBJ_TOT_OVER;
					OBJ_POS <= OBJ_X - 9'b010000000;
				//	OBJ_COLINFO_ADDR_A <= OBJ_X - 9'b010000000;
					OBJ_TILEBASE <= ({OBJ_PAT, 5'b0000}) + ({OBJ_Y_OFS, 2'b00});
					SP2C <= SP2C_TILE_RD; //SP2C_LOOP;
				end
				SP2C_TILE_RD:	// SP2C_LOOP:
					begin
						OBJ_COLINFO_WE_A <= 1'b0;
						OBJ_COLINFO_WE_A0 <= 1'b0;
						OBJ_COLINFO_WE_A1 <= 1'b0;
						OBJ_COLINFO_ADDR_A <= OBJ_POS;

						SP2_VRAM_ADDR <=
							(OBJ_VS==2'b00) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 3'b000}, 1'b0,1'b0}) :
							(OBJ_VS==2'b01) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 4'b0000}, 1'b0,1'b0}) :
							(OBJ_VS==2'b11) ? OBJ_TILEBASE + ({{OBJ_X_OFS[4:3], 5'b00000}, 1'b0,1'b0}) :
							(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b00) ? OBJ_TILEBASE + {7'b0000000, 1'b0,1'b0} :
							(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b01) ? OBJ_TILEBASE + {7'b0011000, 1'b0,1'b0} :
							(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b10) ? OBJ_TILEBASE + {7'b0110000, 1'b0,1'b0} :
							(OBJ_VS==2'b10) & (OBJ_X_OFS[4:3]==2'b11) ? OBJ_TILEBASE + {7'b1001000, 1'b0,1'b0} :
							16'b0;

						SP2_SEL <= 1'b1;
						SP2C <= SP2C_TILE_RD2;
					end
				SP2C_TILE_RD2:
					begin
						if (SP2_DTACK_N==1'b1)
							begin
								SP2C <= SP2C_TILE_RD2;
							end
						else
							begin
								SP2C <= SP2C_LOOP;
								SP2_SEL <= 1'b0;
							end
					end
				SP2C_LOOP:
					begin
`ifdef debug_spr_render_readback
						SP2C <= SP2C_LOOP2;
`else
						SP2C <= SP2C_PLOT;
`endif
						OBJ_COLINFO_WE_A <= 1'b0;
						OBJ_COLINFO_WE_A0 <= 1'b0;
						OBJ_COLINFO_WE_A1 <= 1'b0;
						OBJ_COLINFO_ADDR_A <= OBJ_POS;
						OBJ_COLNO <=
							(OBJ_X_OFS[2:0]==3'b000) ? SP2_VRAM32_DO[31:28] :
							(OBJ_X_OFS[2:0]==3'b001) ? SP2_VRAM32_DO[27:24] :
							(OBJ_X_OFS[2:0]==3'b010) ? SP2_VRAM32_DO[23:20] :
							(OBJ_X_OFS[2:0]==3'b011) ? SP2_VRAM32_DO[19:16] :
							(OBJ_X_OFS[2:0]==3'b100) ? SP2_VRAM32_DO[15:12] :
							(OBJ_X_OFS[2:0]==3'b101) ? SP2_VRAM32_DO[11:8] :
							(OBJ_X_OFS[2:0]==3'b110) ? SP2_VRAM32_DO[7:4] :
							(OBJ_X_OFS[2:0]==3'b111) ? SP2_VRAM32_DO[3:0] :
							4'b0;
					end
				SP2C_LOOP2:
					begin
						SP2C <= SP2C_PLOT;
					end
				SP2C_PLOT: 
					begin
						if (OBJ_POS < 320) 
							begin
`ifdef debug_spr_render_readback
									OBJ_COLINFO_WE_A <= (OBJ_COLINFO_Q_A0[7]==1'b0) ? 1'b0 : 1'b1;
									OBJ_COLINFO_WE_A0 <= (PRE_Y[0]==1'b0) & (OBJ_COLINFO_Q_A0[7]==1'b0) ? 1'b1 : 1'b0;
									OBJ_COLINFO_WE_A1 <= (PRE_Y[0]==1'b1) & (OBJ_COLINFO_Q_A1[7]==1'b0) ? 1'b1 : 1'b0;
									OBJ_COLINFO_D_A <= {{OBJ_PRI, OBJ_PAL}, OBJ_COLNO};
`else
								if (obj_store_r[OBJ_POS]==1'b0) begin
									OBJ_COLINFO_WE_A <= (OBJ_COLNO!=4'b0000) ? 1'b1 : 1'b0;
									OBJ_COLINFO_WE_A0 <= (PRE_Y[0]==1'b0) & (OBJ_COLNO!=4'b0000) ? 1'b1 : 1'b0;
									OBJ_COLINFO_WE_A1 <= (PRE_Y[0]==1'b1) & (OBJ_COLNO!=4'b0000) ? 1'b1 : 1'b0;
									OBJ_COLINFO_D_A <= {{OBJ_PRI, OBJ_PAL}, OBJ_COLNO};
									obj_store_r[OBJ_POS] <= (OBJ_COLNO==4'b0000) ? 1'b0 : 1'b1;
								end
`endif
						end
						OBJ_POS <= OBJ_POS + 1;
					//	OBJ_COLINFO_ADDR_A <= OBJ_COLINFO_ADDR_A +1;
						OBJ_X_OFS_COUNT <= OBJ_X_OFS_COUNT - 1;
						SP2C <= 
							(OBJ_X_OFS_COUNT[2:0]!=3'b000) ? SP2C_LOOP :
							(OBJ_X_OFS_COUNT[2:0]==3'b000) & (OBJ_X_OFS_COUNT[4:3]!=2'b00) ? SP2C_TILE_RD :
							(OBJ_X_OFS_COUNT[2:0]==3'b000) & (OBJ_X_OFS_COUNT[4:3]==2'b00) ? SP2C_NEXT :
							SP2C_NEXT;
						OBJ_X_OFS <= (OBJ_HF==1'b1) ? OBJ_X_OFS - 1 : OBJ_X_OFS + 1;
					end
				SP2C_NEXT: begin
					OBJ_COLINFO_WE_A <= 1'b0;
					OBJ_COLINFO_WE_A0 <= 1'b0;
					OBJ_COLINFO_WE_A1 <= 1'b0;
					OBJ_TOT <= OBJ_TOT + 1;
				//	OBJ_NEXT <= OBJ_LINK;

					SP2C <= (SPR_ACTIVE==1'b0) | (OBJ_TOT_OVER==1'b1) | (OBJ_NB_OVER==1'b1) | (OBJ_PIX_OVER==1'b1) | (OBJ_LINK_OVER==1'b1) ? SP2C_DONE : SP2C_Y_RD;

					if ((OBJ_TOT_OVER==1'b1) | (OBJ_NB_OVER==1'b1) | (OBJ_PIX_OVER==1'b1))
						begin
							SOVR_SET <= 1'b1;
						end
				end
				SP2C_DONE : begin
					spr_render_r <= 1'b0;
					SP2C <= (SPR_ACTIVE==1'b1) ? SP2C_DONE : SP2C_INIT;
					SP2_SEL <= 1'b0;
					OBJ_COLINFO_WE_A <= 1'b0;
					OBJ_COLINFO_WE_A0 <= 1'b0;
					OBJ_COLINFO_WE_A1 <= 1'b0;
				end
				default: begin
					spr_render_r <= 1'b0;
					SP2C <= (SPR_ACTIVE==1'b1) ? SP2C_DONE : SP2C_INIT;
					SP2_SEL <= 1'b0;
					OBJ_COLINFO_WE_A <= 1'b0;
					OBJ_COLINFO_WE_A0 <= 1'b0;
					OBJ_COLINFO_WE_A1 <= 1'b0;
				end
				endcase
		end
	end

end
	else
begin

	reg		[8:0] OBJ_Y_ADDR_RD_r;

	assign spr_render=1'b0;
	assign OBJ_Y_ADDR_RD[8:0]=OBJ_Y_ADDR_RD_r[8:0];

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				SP2_SEL <= 1'b0;
				SP2_VRAM_ADDR <= 0;
				SP2C <= SP2C_INIT;
				OBJ_COLINFO_ADDR_A <= 9'b0;
				OBJ_COLINFO_WE_A <= 1'b0;
				OBJ_COLINFO_WE_A0 <= 1'b0;
				OBJ_COLINFO_WE_A1 <= 1'b0;
				OBJ_COLINFO_D_A <= 0;
				OBJ_Y_ADDR_RD_r <= 9'b0;
				SCOL_SET <= 1'b0;
				SOVR_SET <= 1'b0;
				OBJ_X <= 0;
				OBJ_PRI <= 0;
				OBJ_PAL <= 0;
				OBJ_VF <= 0;
				OBJ_HF <= 0;
				OBJ_PAT <= 0;
				OBJ_X_OFS <= 0;
				OBJ_Y_OFS <= 0;
				OBJ_HS <= 0;
				OBJ_VS <= 0;
				OBJ_LINK <= 0;
				OBJ_POS <= 0;
				OBJ_TILEBASE <= 0;
				OBJ_COLNO <= 0;
			end
	end

end
endgenerate
*/
//`endif

	//--------------------------------------------------------------
	// VIDEO COUNTING
	//--------------------------------------------------------------
	// COUNTERS AND INTERRUPTS

	reg 	H_VGA_CNT_LOAD;

//`ifdef replace_hvtiming

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				H_VGA_CNT <= 11'b0;
				H_VGA_CNT_LOAD <= 1'b0;
				V_CNT <= 10'b0;
				FIELD <= 1'b0;
				H_CNT <= 12'b0;
				H_CNT_LOAD <= 1'b0;
				HV_PIXDIV <= 4'b0;
			end
		else
			begin
				H_VGA_CNT <= (H_VGA_CNT_LOAD==1'b1) ? 11'b0 : H_VGA_CNT + 1;
				H_VGA_CNT_LOAD <= (H_VGA_CNT==(VGA_PER_LINE) - 2) ? 1'b1 : 1'b0;
				V_CNT <= 
					(H_VGA_CNT_LOAD==1'b1) &  (V_CNT==VGA_LINES - 1) ? 10'b0 :
					(H_VGA_CNT_LOAD==1'b1) & !(V_CNT==VGA_LINES - 1) ? V_CNT + 1 :
					V_CNT;
				FIELD <=  
					(H_VGA_CNT_LOAD==1'b1) &  (V_CNT==VGA_LINES - 1) ? ~FIELD : FIELD;

				H_CNT <= 
					(H_VGA_CNT_LOAD==1'b1) & (V_CNT[0]==1'b1) ? 12'b0 : H_CNT + 1;
			//	H_CNT_LOAD <= (H_VGA_CNT_LOAD==1'b1) & (V_CNT[0]==1'b1) ? 1'b1 : 1'b0;
				H_CNT_LOAD <= (H_VGA_CNT==(VGA_PER_LINE) - 2) & (V_CNT[0]==1'b1) ? 1'b1 : 1'b0;
				HV_PIXDIV <= 
					 ((H_VGA_CNT_LOAD==1'b1) & (V_CNT[0]==1'b1)) ? 4'b0 :
					!((H_VGA_CNT_LOAD==1'b1) & (V_CNT[0]==1'b1)) & (H40==1'b1) & (HV_PIXDIV==8 - 1) ? 4'b0 :
					!((H_VGA_CNT_LOAD==1'b1) & (V_CNT[0]==1'b1)) & (H40==1'b0) & (HV_PIXDIV==10 - 1) ? 4'b0 :
					HV_PIXDIV + 1;
			end
	end

//`ifdef replace_timing_virq

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				VINT_TG68_PENDING_SET <= 1'b0;
				VINT_T80_SET <= 1'b0;
				VINT_T80_CLR <= 1'b0;
			end
		else
			begin
				VINT_TG68_PENDING_SET <=
					(H_CNT==NTSC_H_REND_START) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START + 240 -0 +2 -1) ) ? 1'b1 :
					(H_CNT==NTSC_H_REND_START) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START + 224 +8 -0 +2 -1) ) ? 1'b1 :
					1'b0;

				VINT_T80_SET <=
					(H_CNT==NTSC_H_REND_START) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START + 240 -0 +2 -1) ) ? 1'b1 :
					(H_CNT==NTSC_H_REND_START) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START + 224 +8 -0 +2 -1) ) ? 1'b1 :
					1'b0;

				VINT_T80_CLR <= 
					(H_CNT==NTSC_H_REND_START) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START + 240 -0 +2 -1)  + 1) ? 1'b1 :
					(H_CNT==NTSC_H_REND_START) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START + 224 +8 -0 +2 -1)  + 1) ? 1'b1 :
					1'b0;
			end
	end

//`else
/*
	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				VINT_TG68_PENDING_SET <= 1'b0;
				VINT_T80_SET <= 1'b0;
				VINT_T80_CLR <= 1'b0;
			end
		else
			begin
				VINT_TG68_PENDING_SET <= 1'b0;
				VINT_T80_SET <= 1'b0;
				VINT_T80_CLR <= 1'b0;
						if (H40==1'b1 && HV_PIXDIV==8 - 1) 
							begin
								if (HV_HCNT=={8'hA7, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												if (HIT==0) 
													begin
													end 
												else 
													begin
													end
											end 
										else 
											begin
												if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														if (HINT_COUNT==0) 
															begin
															end 
														else 
															begin
															end
													end
											end
									end 
								else 
									if (HV_HCNT=={8'h02, 1'b0}) 
										begin
											if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
												begin
													VINT_TG68_PENDING_SET <= 1'b1;
													VINT_T80_SET <= 1'b1;
												end 
											else 
												if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
													begin
														VINT_T80_CLR <= 1'b1;
													end
										end 
									else 
										if (HV_HCNT=={8'hB5, 1'b1}) 
											begin
												if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
													end
											end 
										else 
											if (HV_HCNT=={8'h08, 1'b1}) 
												begin
												end
							end 
						else if (H40==1'b0 && HV_PIXDIV==10 - 1) 
							begin
								if (HV_HCNT=={8'h85, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												if (HIT==0) 
													begin
													end 
												else 
													begin
													end
									end 
								else 
									begin
										if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
												if (HINT_COUNT==0) 
													begin
													end 
												else 
													begin
											end
									end
							end
					end 
				else 
					if (HV_HCNT=={8'h00, 1'b0}) 
						begin
							if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
								begin
									VINT_TG68_PENDING_SET <= 1'b1;
									VINT_T80_SET <= 1'b1;
								end 
							else 
								if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
									begin
										VINT_T80_CLR <= 1'b1;
									end
								end 
							else 
								if (HV_HCNT=={8'h93, 1'b1}) 
									begin
										if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
											end
									end 
								else 
									if (HV_HCNT=={8'h06, 1'b0}) 
										begin
										end
							end
			end
	end
*/
//`endif

//`ifdef replace_timing_hirq

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				HV_HCNT <= 9'b0;
				HV_VCNT <= 10'b0;

				HINT_COUNT <= 8'b0;
				HINT_PENDING_SET <= 1'b0;
			end
		else
			begin
				HV_HCNT <= 
					 (H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b1) ? {8'hEB, 1'b0} :
					 (H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b0) ? {8'hEF, 1'b0} :
					!(H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b1) & (HV_PIXDIV==8 - 1) &  (HV_HCNT=={8'hB5, 1'b1}) ? {8'hE4, 1'b0} :
					!(H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b1) & (HV_PIXDIV==8 - 1) & !(HV_HCNT=={8'hB5, 1'b1}) ? HV_HCNT + 1 :
					!(H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b0) & (HV_PIXDIV==10 - 1) &  (HV_HCNT=={8'h93, 1'b1}) ? {8'hE9, 1'b0} :
					!(H_CNT==NTSC_CLOCKS_PER_LINE - 1) & (H40==1'b0) & (HV_PIXDIV==10 - 1) & !(HV_HCNT=={8'h93, 1'b1}) ? HV_HCNT + 1 :
					HV_HCNT;

				HV_VCNT <= 
					(H40==1'b1) & (HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hA7, 1'b0}) & (V30==1'b0) &  (V_CNT[9:1]==NTSC_V_DISP_START + 8 - 1) ? 10'b0 :
					(H40==1'b1) & (HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hA7, 1'b0}) & (V30==1'b1) &  (V_CNT[9:1]==NTSC_V_DISP_START + 0 - 1) ? 10'b0 :
					(H40==1'b1) & (HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hA7, 1'b0}) & (V30==1'b0) & !(V_CNT[9:1]==NTSC_V_DISP_START + 8 - 1) ? HV_VCNT + 1 :
					(H40==1'b1) & (HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hA7, 1'b0}) & (V30==1'b1) & !(V_CNT[9:1]==NTSC_V_DISP_START + 0 - 1) ? HV_VCNT + 1 :
					(H40==1'b0) & (HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h85, 1'b0})  & (V30==1'b0) &  (V_CNT[9:1]==NTSC_V_DISP_START + 8 - 1) ? 10'b0 :
					(H40==1'b0) & (HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h85, 1'b0})  & (V30==1'b1) &  (V_CNT[9:1]==NTSC_V_DISP_START + 0 - 1) ? 10'b0 :
					(H40==1'b0) & (HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h85, 1'b0})  & (V30==1'b0) & !(V_CNT[9:1]==NTSC_V_DISP_START + 8 - 1) ? HV_VCNT + 1 :
					(H40==1'b0) & (HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h85, 1'b0})  & (V30==1'b1) & !(V_CNT[9:1]==NTSC_V_DISP_START + 0 - 1) ? HV_VCNT + 1 :
					HV_VCNT;

				HINT_COUNT <= 
					(H_CNT==NTSC_H_REND_START) & (PRE_V_ACTIVE==1'b0) &  (HIT==0) ? 8'b0 :
					(H_CNT==NTSC_H_REND_START) & (PRE_V_ACTIVE==1'b0) & !(HIT==0) ? HIT - 1 :
					(H_CNT==NTSC_H_REND_START) & (PRE_V_ACTIVE==1'b1) &  (HINT_COUNT==0) ? HIT :
					(H_CNT==NTSC_H_REND_START) & (PRE_V_ACTIVE==1'b1) & !(HINT_COUNT==0) ? HINT_COUNT - 1 :
					HINT_COUNT;

				HINT_PENDING_SET <=
					(H_CNT==NTSC_H_REND_START) & (PRE_V_ACTIVE==1'b1) & (HINT_COUNT==0) ? 1'b1 :
					1'b0;
			end
	end

//`else
/*
	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				HV_HCNT <= 9'b0;
				HV_VCNT <= 10'b0;

				HINT_COUNT <= 8'b0;
				HINT_PENDING_SET <= 1'b0;
			end
		else
			begin
			//	if (H_VGA_CNT==(NTSC_CLOCKS_PER_LINE / 2) - 1) 
			//		begin
			//			if (V_CNT==(NTSC_LINES * 2) - 1) 
			//				begin
			//				end
			//		end
				HINT_PENDING_SET <= 1'b0;
				if (H_CNT==NTSC_CLOCKS_PER_LINE - 1) 
					begin
						if (H40==1'b1) 
							begin
								HV_HCNT <= {8'hEB, 1'b0};
							end 
						else 
							begin
								HV_HCNT <= {8'hEF, 1'b0};
							end
					end 
				else 
					begin
						if (H40==1'b1 && HV_PIXDIV==8 - 1) 
							begin
								HV_HCNT <= HV_HCNT + 1;
								if (HV_HCNT=={8'hA7, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												HV_VCNT <= 10'b0;
												if (HIT==0) 
													begin
														HINT_PENDING_SET <= 1'b1;
														HINT_COUNT <= 8'b0;
													end 
												else 
													begin
														HINT_COUNT <= HIT - 1;
													end
											end 
										else 
											begin
												HV_VCNT <= HV_VCNT + 1;
												if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														if (HINT_COUNT==0) 
															begin
																HINT_PENDING_SET <= 1'b1;
																HINT_COUNT <= HIT;
															end 
														else 
															begin
																HINT_COUNT <= HINT_COUNT - 1;
															end
													end
											end
									end 
								else 
									if (HV_HCNT=={8'h02, 1'b0}) 
										begin
											if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
												begin
												end 
											else 
												if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
													begin
													end
										end 
									else 
										if (HV_HCNT=={8'hB5, 1'b1}) 
											begin
												HV_HCNT <= {8'hE4, 1'b0};
												if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
													end
											end 
										else 
											if (HV_HCNT=={8'h08, 1'b1}) 
												begin
												end
							end 
						else 
							if (H40==1'b0 && HV_PIXDIV==10 - 1) 
								begin
									HV_HCNT <= HV_HCNT + 1;
									if (HV_HCNT=={8'h85, 1'b0}) 
										begin
											if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
												begin
													HV_VCNT <= 10'b0;
													HINT_COUNT <= HIT;
													if (HIT==0) 
														begin
															HINT_PENDING_SET <= 1'b1;
															HINT_COUNT <= 8'b0;
														end 
													else 
														begin
															HINT_COUNT <= HIT - 1;
														end
										end 
									else 
										begin
											HV_VCNT <= HV_VCNT + 1;
											if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
												begin
													if (HINT_COUNT==0) 
														begin
															HINT_PENDING_SET <= 1'b1;
															HINT_COUNT <= HIT;
														end 
													else 
														begin
															HINT_COUNT <= HINT_COUNT - 1;
													end
												end
										end
								end 
							else 
								if (HV_HCNT=={8'h00, 1'b0}) 
									begin
										if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
											begin
											end 
										else 
											if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
												begin
												end
											end 
										else 
											if (HV_HCNT=={8'h93, 1'b1}) 
												begin
													HV_HCNT <= {8'hE9, 1'b0};
													if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
														begin
														end
												end 
											else 
												if (HV_HCNT=={8'h06, 1'b0}) 
													begin
													end
										end
					end
			end
	end
*/
//`endif

//`ifdef replace_timing_hvstat

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				IN_HBL <= 1'b0;
				IN_VBL <= 1'b1;
			end
		else
			begin
				IN_HBL <= 
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hB5, 1'b1}) & (V_CNT >= NTSC_V_DISP_START * 2 - 1) & (V30==1'b1) & (V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1) ? 1'b1 :
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hB5, 1'b1}) & (V_CNT >= NTSC_V_DISP_START * 2 - 1) & (V30==1'b0) & (V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) ? 1'b1 :
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'h08, 1'b1}) ? 1'b0 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h93, 1'b1}) & (V_CNT >= NTSC_V_DISP_START * 2 - 1) & (V30==1'b1) & (V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1) ? 1'b1 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h93, 1'b1}) & (V_CNT >= NTSC_V_DISP_START * 2 - 1) & (V30==1'b0) & (V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) ? 1'b1 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h06, 1'b0}) ? 1'b0 :
				//	IN_HBL;

					(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hB5, 1'b1}) & (PRE_V_ACTIVE==1'b1) ? 1'b1 :
					(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'h08, 1'b1}) ? 1'b0 :
					(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h93, 1'b1}) & (PRE_V_ACTIVE==1'b1) ? 1'b1 :
					(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h06, 1'b0}) ? 1'b0 :
					IN_HBL;

				IN_VBL <= 
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'hA7, 1'b0}) & (V_CNT==NTSC_V_DISP_START * 2 - 1) ? 1'b0 :
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'h02, 1'b0}) & (V30==1'b1) & (V_CNT==(NTSC_V_DISP_START + 240) * 2) ? 1'b1 :
				//	(H40==1'b1 && HV_PIXDIV==8 - 1) & (HV_HCNT=={8'h02, 1'b0}) & (V30==1'b0) & (V_CNT==(NTSC_V_DISP_START + 224) * 2) ? 1'b1 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h85, 1'b0}) & (V_CNT==NTSC_V_DISP_START * 2 - 1) ? 1'b0 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h00, 1'b0}) & (V30==1'b1) & (V_CNT==(NTSC_V_DISP_START + 240) * 2) ? 1'b1 :
				//	(H40==1'b0 && HV_PIXDIV==10 - 1) & (HV_HCNT=={8'h00, 1'b0}) & (V30==1'b0) & (V_CNT==(NTSC_V_DISP_START + 224) * 2) ? 1'b1 :
				//	IN_VBL;

					(H40==1'b1 && HV_PIXDIV==8 - 1) ? !PRE_V_ACTIVE :
					(H40==1'b0 && HV_PIXDIV==10 - 1) ? !PRE_V_ACTIVE :
					IN_VBL;
			end
	end

//`else
/*
	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				IN_HBL <= 1'b0;
				IN_VBL <= 1'b1;
			end
		else
			begin
						if (H40==1'b1 && HV_PIXDIV==8 - 1) 
							begin
								if (HV_HCNT=={8'hA7, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												if (HIT==0) 
													begin
													end 
												else 
													begin
													end
												IN_VBL <= 1'b0;
											end 
										else 
											begin
												if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														if (HINT_COUNT==0) 
															begin
															end 
														else 
															begin
															end
													end
											end
									end 
								else 
									if (HV_HCNT=={8'h02, 1'b0}) 
										begin
											if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
												begin
													IN_VBL <= 1'b1;
												end 
											else 
												if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
													begin
													end
										end 
									else 
										if (HV_HCNT=={8'hB5, 1'b1}) 
											begin
												if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														IN_HBL <= 1'b1;
													end
											end 
										else 
											if (HV_HCNT=={8'h08, 1'b1}) 
												begin
													IN_HBL <= 1'b0;
												end
							end 
						else if (H40==1'b0 && HV_PIXDIV==10 - 1) 
							begin
								if (HV_HCNT=={8'h85, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												if (HIT==0) 
													begin
													end 
												else 
													begin
													end
										IN_VBL <= 1'b0;
									end 
								else 
									begin
										if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
												if (HINT_COUNT==0) 
													begin
													end 
												else 
													begin
											end
									end
							end
					end 
				else 
					if (HV_HCNT=={8'h00, 1'b0}) 
						begin
							if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
								begin
									IN_VBL <= 1'b1;
								end 
							else 
								if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
									begin
									end
								end 
							else 
								if (HV_HCNT=={8'h93, 1'b1}) 
									begin
										if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
												IN_HBL <= 1'b1;
											end
									end 
								else 
									if (HV_HCNT=={8'h06, 1'b0}) 
										begin
											IN_HBL <= 1'b0;
										end
							end
			end
	end
*/
//`endif

//`else
/*
	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				H_CNT <= 12'b0;
				H_VGA_CNT <= 11'b0;
				V_CNT <= 10'b0;
				FIELD <= 1'b0;
				HV_PIXDIV <= 4'b0;
				HV_HCNT <= 9'b0;
				HV_VCNT <= 10'b0;

				HINT_COUNT <= 8'b0;
				HINT_PENDING_SET <= 1'b0;
				VINT_TG68_PENDING_SET <= 1'b0;
				VINT_T80_SET <= 1'b0;
				VINT_T80_CLR <= 1'b0;
				IN_HBL <= 1'b0;
				IN_VBL <= 1'b1;
			end
		else
			begin
				H_CNT <= H_CNT + 1;
				H_VGA_CNT <= H_VGA_CNT + 1;
				if (H_VGA_CNT==(NTSC_CLOCKS_PER_LINE / 2) - 1) 
					begin
						H_VGA_CNT <= 11'b0;
						V_CNT <= V_CNT + 1;
						if (V_CNT==(NTSC_LINES * 2) - 1) 
							begin
								V_CNT <= 10'b0;
								FIELD <=  ~FIELD;
							end
					end
				HINT_PENDING_SET <= 1'b0;
				VINT_TG68_PENDING_SET <= 1'b0;
				VINT_T80_SET <= 1'b0;
				VINT_T80_CLR <= 1'b0;
				if (H_CNT==NTSC_CLOCKS_PER_LINE - 1) 
					begin
						H_CNT <= 12'b0;
						HV_PIXDIV <= 4'b0;
						if (H40==1'b1) 
							begin
								HV_HCNT <= {8'hEB, 1'b0};
							end 
						else 
							begin
								HV_HCNT <= {8'hEF, 1'b0};
							end
					end 
				else 
					begin
						HV_PIXDIV <= HV_PIXDIV + 1;
						if (H40==1'b1 && HV_PIXDIV==8 - 1) 
							begin
								HV_PIXDIV <= 4'b0;
								HV_HCNT <= HV_HCNT + 1;
								if (HV_HCNT=={8'hA7, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												HV_VCNT <= 10'b0;
												if (HIT==0) 
													begin
														HINT_PENDING_SET <= 1'b1;
														HINT_COUNT <= 8'b0;
													end 
												else 
													begin
														HINT_COUNT <= HIT - 1;
													end
												IN_VBL <= 1'b0;
											end 
										else 
											begin
												HV_VCNT <= HV_VCNT + 1;
												if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														if (HINT_COUNT==0) 
															begin
																HINT_PENDING_SET <= 1'b1;
																HINT_COUNT <= HIT;
															end 
														else 
															begin
																HINT_COUNT <= HINT_COUNT - 1;
															end
													end
											end
									end 
								else 
									if (HV_HCNT=={8'h02, 1'b0}) 
										begin
											if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
												begin
													VINT_TG68_PENDING_SET <= 1'b1;
													VINT_T80_SET <= 1'b1;
													IN_VBL <= 1'b1;
												end 
											else 
												if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
													begin
														VINT_T80_CLR <= 1'b1;
													end
										end 
									else 
										if (HV_HCNT=={8'hB5, 1'b1}) 
											begin
												HV_HCNT <= {8'hE4, 1'b0};
												if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
													begin
														IN_HBL <= 1'b1;
													end
											end 
										else 
											if (HV_HCNT=={8'h08, 1'b1}) 
												begin
													IN_HBL <= 1'b0;
												end
							end 
						else if (H40==1'b0 && HV_PIXDIV==10 - 1) 
							begin
								HV_PIXDIV <= 4'b0;
								HV_HCNT <= HV_HCNT + 1;
								if (HV_HCNT=={8'h85, 1'b0}) 
									begin
										if (V_CNT==NTSC_V_DISP_START * 2 - 1) 
											begin
												HV_VCNT <= 10'b0;
												HINT_COUNT <= HIT;
												if (HIT==0) 
													begin
														HINT_PENDING_SET <= 1'b1;
														HINT_COUNT <= 8'b0;
													end 
												else 
													begin
														HINT_COUNT <= HIT - 1;
													end
										IN_VBL <= 1'b0;
									end 
								else 
									begin
										HV_VCNT <= HV_VCNT + 1;
										if ((V_CNT > NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
												if (HINT_COUNT==0) 
													begin
														HINT_PENDING_SET <= 1'b1;
														HINT_COUNT <= HIT;
													end 
												else 
													begin
														HINT_COUNT <= HINT_COUNT - 1;
											end
									end
							end
					end 
				else 
					if (HV_HCNT=={8'h00, 1'b0}) 
						begin
							if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2)) 
								begin
									VINT_TG68_PENDING_SET <= 1'b1;
									VINT_T80_SET <= 1'b1;
									IN_VBL <= 1'b1;
								end 
							else 
								if ((V30==1'b0 && V_CNT==(NTSC_V_DISP_START + 224) * 2 + 2) || (V30==1'b1 && V_CNT==(NTSC_V_DISP_START + 240) * 2 + 2)) 
									begin
										VINT_T80_CLR <= 1'b1;
									end
								end 
							else 
								if (HV_HCNT=={8'h93, 1'b1}) 
									begin
										HV_HCNT <= {8'hE9, 1'b0};
										if ((V_CNT >= NTSC_V_DISP_START * 2 - 1) && ((V30==1'b0 && V_CNT <= (NTSC_V_DISP_START + 224) * 2 - 1) || (V30==1'b1 && V_CNT <= (NTSC_V_DISP_START + 240) * 2 - 1))) 
											begin
												IN_HBL <= 1'b1;
											end
									end 
								else 
									if (HV_HCNT=={8'h06, 1'b0}) 
										begin
											IN_HBL <= 1'b0;
										end
							end
					end
			end
	end
*/
//`endif

	wire	PRE_Y_LOAD;
	reg		PRE_Y_LOAD_r;

	reg		SPR_V_load;

	assign PRE_Y_LOAD=PRE_Y_LOAD_r;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				BGEN_ACTIVE <= 1'b0;
				DISP_ACTIVE <= 1'b0;
				SP1E_ACTIVE <= 1'b0;
				SP2E_ACTIVE <= 1'b0;
				DT_ACTIVE <= 1'b0;

				V_ACTIVE <= 1'b0;
				SPR_V_load <= 1'b0;
				SPR_V_ACTIVE <= 1'b0;
				PRE_V_ACTIVE <= 1'b0;
				PRE_V_COUNT <= 10'b0;
				PRE_Y_LOAD_r <= 1'b0;
		//		PRE_Y <= 0;
			end
		else
			begin
				DISP_ACTIVE <= 
					(H_CNT==NTSC_H_REND_START) ? DISP :
				//	(H_CNT==NTSC_H_DISP_START + NTSC_H_DISP_CLOCKS) ? 1'b0 :
					(H_CNT==NTSC_H_REND_ABORT) ? 1'b0 :
					DISP_ACTIVE;
				BGEN_ACTIVE <=
					(H_CNT==NTSC_H_REND_START)  && (PRE_V_ACTIVE==1'b1) ? DISP :
				//	(H_CNT==NTSC_H_DISP_START + NTSC_H_DISP_CLOCKS) ? 1'b0 :
					(H_CNT==NTSC_H_REND_ABORT) ? 1'b0 :
					BGEN_ACTIVE;
				SP1E_ACTIVE <=
					(H_CNT==NTSC_H_REND_START) && (SPR_V_ACTIVE==1'b1) ? DISP :
				//	(H_CNT==NTSC_H_DISP_START + NTSC_H_DISP_CLOCKS) ? 1'b0 :
					(H_CNT==NTSC_H_REND_ABORT) ? 1'b0 :
					SP1E_ACTIVE;
				SP2E_ACTIVE <=
					(H_CNT==NTSC_H_REND_START) && (PRE_V_ACTIVE==1'b1) ? DISP :
				//	(H_CNT==NTSC_H_DISP_START + NTSC_H_DISP_CLOCKS) ? 1'b0 :
					(H_CNT==NTSC_H_REND_ABORT) ? 1'b0 :
					SP2E_ACTIVE;

			DT_ACTIVE <= //1'b1;
					(PRE_V_ACTIVE==1'b0) ? 1'b1 :
					(PRE_V_ACTIVE==1'b1) & (H_CNT==NTSC_H_REND_START) ? 1'b0 :
					(PRE_V_ACTIVE==1'b1) & (H_CNT==NTSC_H_REND_ABORT) ? 1'b1 :
					DT_ACTIVE;

				V_ACTIVE <=
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -1) ) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START +240 -1) ) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START +8 -1) ) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START +224 +8 -1) ) ? 1'b0 :
					V_ACTIVE;

				SPR_V_ACTIVE <=
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 -1) ) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 -1) ) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -3 -1) ) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 +8 -1) ) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 +8 -1) ) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -3 +8 -1) ) ? 1'b0 :

`ifdef spr_search_reload

					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b0) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b0) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b1) ? 1'b0:
`else
`endif
					SPR_V_ACTIVE;

				SPR_V_load <= 
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 -1) ) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 -1) ) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 +8 -1) ) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -4 +8 -1) ) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b1) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b1) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b0) & (BLANK==1'b1) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (PRE_V_ACTIVE==1'b1) & (SPR_V_load==1'b0) & (BLANK==1'b0) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +240 -1) ) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +224 +8 -1) ) ? 1'b0 :
					SPR_V_load;

				PRE_V_ACTIVE <=
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 -1) ) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +240 -1) ) ? 1'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +8 -1) ) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +224 +8 -1) ) ? 1'b0 :
					PRE_V_ACTIVE;

				PRE_V_COUNT <=
					(H_CNT_LOAD==1'b1) & (V30==1'b1) &  (V_CNT[9:1]==(NTSC_V_DISP_START -2 -1) ) ? 10'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & !(V_CNT[9:1]==(NTSC_V_DISP_START -2 -1) ) ? PRE_V_COUNT +1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) &  (V_CNT[9:1]==(NTSC_V_DISP_START -2 +8 -1) ) ? 10'b0 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & !(V_CNT[9:1]==(NTSC_V_DISP_START -2 +8 -1) ) ? PRE_V_COUNT +1 :
					(H_CNT_LOAD==1'b0) ? PRE_V_COUNT :
					PRE_V_COUNT;

				PRE_Y_LOAD_r <= 
					(H_CNT_LOAD==1'b1) & (V30==1'b1) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 -1) ) ? 1'b1 :
					(H_CNT_LOAD==1'b1) & (V30==1'b0) & (V_CNT[9:1]==(NTSC_V_DISP_START -2 +8 -1) ) ? 1'b1 :
					1'b0;
			end
	end


	wire	[7:0] CRAM_COLINFO_SEL;
	wire	[7:0] CRAM_COLINFO_SEL_COL;
	wire	[7:0] CRAM_COLINFO_SEL_PRI;

	wire	[2:0] COLINFO_PRI;
//	wire	COLINFO_E;
//	wire	COLINFO_F;

	reg		[9:0] BGA_COLINFO_Q;
	reg		[9:0] BGB_COLINFO_Q;
	reg		[9:0] OBJ_COLINFO_Q;

	assign COLINFO_PRI[2:0]={BGA_COLINFO_Q[6],BGB_COLINFO_Q[6],OBJ_COLINFO_Q[6]};

`ifdef debug_composite_priority

	assign CRAM_COLINFO_SEL[7:0]=
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,                 BGB_COLINFO_Q[7]                                    }==2'b0_1   ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_01  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_10  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b00_1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                                    }==3'b001   ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0001  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 111 SABG

			{2'b00,BGCOL};

	assign CRAM_COLINFO_SEL_PRI[7:0]={2'b00,BGA_COLINFO_Q[7:6],BGB_COLINFO_Q[7:6],OBJ_COLINFO_Q[7:6]};
	assign CRAM_COLINFO_SEL_COL[7:0]=
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,                 BGB_COLINFO_Q[7]                                    }==2'b0_1   ) ? {2'b00,2'b00,2'b11,2'b00} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_01  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_10  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,2'b11,2'b00,2'b00} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b00_1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,2'b11,2'b00,2'b00} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                                    }==3'b001   ) ? {2'b00,2'b00,2'b11,2'b00} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0001  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,2'b00,2'b00,2'b11} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,2'b11,2'b00,2'b00} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,2'b00,2'b11,2'b00} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({1'b0,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 111 SABG

			{2'b00,BGCOL};

`else

	assign CRAM_COLINFO_SEL[7:0]=
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({STEN,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7]                                    }==2'b0_1   ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_01  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==3'b0_10  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0100  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b00_1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({STEN,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7]                                                     }==2'b01    ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                                    }==3'b001   ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0001  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({STEN,                                  OBJ_COLINFO_Q[7]                   }==2'b0__1  ) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7]                   }==3'b01_0  ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0010  ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7]                   }==4'b0000  ) ? {2'b00,BGCOL[5:0]        } :	// 111 SABG

			(COLINFO_PRI[2:0]==3'b000) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__100) ? {2'b01,OBJ_COLINFO_Q[5:0]} :	// 000 SABG shadow
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_000) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101000) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b01,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 001 SABG shadow
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_000) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101000) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b01,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9:8]}==4'b1_1_00) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 010 BSAG shadow
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b1_0100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b110000) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 011 SBAG shadow
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b1_1000) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b110000) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9:8]}==4'b11__00) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 100 ASBG shadow
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b10_100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101000) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 101 SABG shadow
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_000) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101000) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9:8]}==4'b11__00) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 110 ABSG shadow
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9:8]}==5'b101_00) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__100) ? {2'b00,OBJ_COLINFO_Q[5:0]} :	// 111 SABG shadow
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_000) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101000) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100000) ? {2'b00,BGCOL[5:0]        } :	// 111 SABG

			(COLINFO_PRI[2:0]==3'b000) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==3'b1__11 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 000 SABG $F:shadow
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b11_01 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==3'b1__11 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 001 SABG $F:shadow
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b11_01 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9]  }==3'b1_1_1 ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 010 BSAG $F:shadow
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b1_011 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b11001 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==3'b1__11 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 011 SBAG $F:shadow
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b1_101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b11001 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9]  }==3'b11__1 ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 100 ASBG $F:shadow
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b10_11 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==3'b1__11 ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 101 SABG $F:shadow
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b11_01 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9]  }==3'b11__1 ) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 110 ABSG $F:shadow
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9]  }==4'b101_1 ) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10011 ) ? {2'b01,BGCOL[5:0]        } :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==3'b1__11 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 111 SABG $F:shadow
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==4'b11_01 ) ? {2'b01,BGA_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10101 ) ? {2'b01,BGB_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9]  }==5'b10001 ) ? {2'b01,BGCOL[5:0]        } :	// 111 SABG

			(COLINFO_PRI[2:0]==3'b000) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__101) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 000 SABG $E:highlight
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_001) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101001) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 000 SABG
			(COLINFO_PRI[2:0]==3'b000) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b00,BGCOL[5:0]        } :	// 000 SABG

			(COLINFO_PRI[2:0]==3'b001) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__101) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 001 SABG $E:highlight
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_001) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101001) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 001 SABG
			(COLINFO_PRI[2:0]==3'b001) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b00,BGCOL[5:0]        } :	// 001 SABG

			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9:8]}==4'b1_1_01) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 010 BSAG $E:highlight
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b1_0101) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b110001) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 010 BSAG
			(COLINFO_PRI[2:0]==3'b010) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 010 BSAG

			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__101) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 011 SBAG $E:highlight
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,                 BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b1_1001) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b110001) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 011 SBAG
			(COLINFO_PRI[2:0]==3'b011) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 011 SBAG

			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9:8]}==4'b11__01) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 100 ASBG $E:highlight
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b10_101) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101001) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 100 ASBG
			(COLINFO_PRI[2:0]==3'b100) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 100 ASBG

			(COLINFO_PRI[2:0]==3'b101) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__101) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 101 SABG $E:highlight
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_001) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101001) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 101 SABG
			(COLINFO_PRI[2:0]==3'b101) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 101 SABG

			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7]                                  ,OBJ_COLINFO_Q[9:8]}==4'b11__01) ? {2'b00,BGA_COLINFO_Q[5:0]} :	// 110 ABSG $E:highlight
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7]                 ,OBJ_COLINFO_Q[9:8]}==5'b101_01) ? {2'b00,BGB_COLINFO_Q[5:0]} :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100101) ? {2'b10,BGCOL[5:0]        } :	// 110 ABSG
			(COLINFO_PRI[2:0]==3'b110) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 110 ABSG

			(COLINFO_PRI[2:0]==3'b111) & ({STEN,                                  OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==4'b1__101) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 111 SABG $E:highlight
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],                 OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==5'b11_001) ? {2'b10,BGA_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b101001) ? {2'b10,BGB_COLINFO_Q[5:0]} :	// 111 SABG
			(COLINFO_PRI[2:0]==3'b111) & ({STEN,BGA_COLINFO_Q[7],BGB_COLINFO_Q[7],OBJ_COLINFO_Q[7],OBJ_COLINFO_Q[9:8]}==6'b100001) ? {2'b10,BGCOL[5:0]        } :	// 111 SABG

			{2'b00,BGCOL};

`endif

//`ifdef replace_composite

	reg		[7:0] CRAM_COLINFO;

	reg		[8:0] COLINFO_ADDR_B;
	reg 	[8:0] POS_X_ADDR;

//	assign BGB_COLINFO_ADDR_B=COLINFO_ADDR_B;
//	assign BGA_COLINFO_ADDR_B=COLINFO_ADDR_B;
	assign OBJ_COLINFO_ADDR_B=COLINFO_ADDR_B;

	reg		POS_X_OVER;

	wire	[15:0] CRAM_RDATA_COLINFO;

	assign CRAM_RADDR[8:0]={3'b0,CRAM_COLINFO[5:0]};
	assign CRAM_RDATA_COLINFO[15:0]={4'b0,CRAM_RDATA[8:6],1'b0,CRAM_RDATA[5:3],1'b0,CRAM_RDATA[2:0],1'b0};

	wire	[9:0] BGA_COLINFO_Q_B;
	wire	[9:0] BGB_COLINFO_Q_B;
	wire	[9:0] OBJ_COLINFO_Q_B;
	wire	[8:0] BGA_COLINFO_RDATA_B;
	wire	[8:0] BGB_COLINFO_RDATA_B;
	wire	[8:0] OBJ_COLINFO_RDATA_B;

	reg		[8:0] BGA_COLINFO_Q0;
	reg		[8:0] BGA_COLINFO_Q1;
	reg		[8:0] BGB_COLINFO_Q0;
	reg		[8:0] BGB_COLINFO_Q1;
	reg		[8:0] OBJ_COLINFO_Q0;
	reg		[8:0] OBJ_COLINFO_Q1;

	assign BGA_COLINFO_RDATA_B[8:0]=(BGA_COLINFO_RD_B0==1'b1) ? BGA_COLINFO_Q0[8:0] : BGA_COLINFO_Q1[8:0];
	assign BGB_COLINFO_RDATA_B[8:0]=(BGB_COLINFO_RD_B0==1'b1) ? BGB_COLINFO_Q0[8:0] : BGB_COLINFO_Q1[8:0];
	assign OBJ_COLINFO_RDATA_B[8:0]=(OBJ_COLINFO_RD_B0==1'b1) ? OBJ_COLINFO_Q0[8:0] : OBJ_COLINFO_Q1[8:0];

generate
	if (disp_bgb==1)
begin

	assign BGA_COLINFO_Q_B[6:0]=BGA_COLINFO_RDATA_B[6:0];
	assign BGA_COLINFO_Q_B[7]=BGA_COLINFO_RDATA_B[7];
	assign BGA_COLINFO_Q_B[8]=1'b0;
	assign BGA_COLINFO_Q_B[9]=1'b0;

end
	else
begin

	assign BGB_COLINFO_Q_B[9:0]=10'b0;

end
endgenerate

generate
	if (disp_bgb==1)
begin

	assign BGB_COLINFO_Q_B[6:0]=BGB_COLINFO_RDATA_B[6:0];
	assign BGB_COLINFO_Q_B[7]=BGB_COLINFO_RDATA_B[7];
	assign BGB_COLINFO_Q_B[8]=1'b0;
	assign BGB_COLINFO_Q_B[9]=1'b0;

end
	else
begin

	assign BGB_COLINFO_Q_B[9:0]=10'b0;

end
endgenerate

generate
	if (disp_spr==1)
begin

	assign OBJ_COLINFO_Q_B[6:0]=OBJ_COLINFO_RDATA_B[6:0];
	assign OBJ_COLINFO_Q_B[7]=OBJ_COLINFO_RDATA_B[7];
	assign OBJ_COLINFO_Q_B[8]=(OBJ_COLINFO_RDATA_B[5:0]==6'h3e) ? 1'b1 : 1'b0;
	assign OBJ_COLINFO_Q_B[9]=(OBJ_COLINFO_RDATA_B[5:0]==6'h3f) ? 1'b1 : 1'b0;

end
	else
begin

	assign OBJ_COLINFO_Q_B[9:0]=10'b0;

end
endgenerate


	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				POS_X[8:0] <= 9'b0;
				POS_X_OVER <= 1'b0;
				POS_X_WR[8:0] <= 9'b0;
				POS_X_REQ <= 1'b0;
				PIXDIV[7:0] <= 8'b0;
				COLINFO_ADDR_B[8:0] <= 9'b0;
				OBJ_COLINFO_WE_B <= 1'b0;
				OBJ_COLINFO_WE_B0 <= 1'b0;
				OBJ_COLINFO_WE_B1 <= 1'b0;

				FF_R <= 4'b0;
				FF_G <= 4'b0;
				FF_B <= 4'b0;
				POS_X_ADDR[8:0] <= 9'b0;
				CRAM_COLINFO[7:0] <= 8'b0;
				T_COLOR[15:0] <= 16'b0;
				T_COLINFO[7:0] <= 8'b0;

				BGA_COLINFO_Q[9:0] <= 10'b0;
				BGB_COLINFO_Q[9:0] <= 10'b0;
				OBJ_COLINFO_Q[9:0] <= 10'b0;

				PRE_Y[9:0] <= 10'b0;
			end
		else
			begin
				if (DISP_ACTIVE==1'b0)
					begin
						PIXDIV[7:0] <= 8'b0;
						POS_X <= 9'b0;
						POS_X_OVER <= 1'b0;
						OBJ_COLINFO_WE_B <= 1'b0;
						OBJ_COLINFO_WE_B0 <= 1'b0;
						OBJ_COLINFO_WE_B1 <= 1'b0;
					end 
				else 
					begin
						PIXDIV[7:0] <= (POS_X_OVER==1'b0) ? {PIXDIV[6:0],1'b1} : {PIXDIV[6:0],1'b0};
						POS_X <= (POS_X_OVER==1'b0) ? POS_X + 1 : POS_X;
						POS_X_OVER <= (POS_X==319) ? 1'b1 : POS_X_OVER;
						COLINFO_ADDR_B[8:0] <= POS_X;
						OBJ_COLINFO_WE_B <= (POS_X_OVER==1'b0) ? 1'b1 : 1'b0;
						OBJ_COLINFO_WE_B0 <= (PRE_Y[0]==1'b1) & (POS_X_OVER==1'b0) ? 1'b1 : 1'b0;
						OBJ_COLINFO_WE_B1 <= (PRE_Y[0]==1'b0) & (POS_X_OVER==1'b0) ? 1'b1 : 1'b0;
					end

				BGA_COLINFO_Q0[8:0] <= BGA_COLINFO_RDATA_B0[8:0];
				BGA_COLINFO_Q1[8:0] <= BGA_COLINFO_RDATA_B1[8:0];
				BGB_COLINFO_Q0[8:0] <= BGB_COLINFO_RDATA_B0[8:0];
				BGB_COLINFO_Q1[8:0] <= BGB_COLINFO_RDATA_B1[8:0];
				OBJ_COLINFO_Q0[8:0] <= OBJ_COLINFO_RDATA_B0[8:0];
				OBJ_COLINFO_Q1[8:0] <= OBJ_COLINFO_RDATA_B1[8:0];

				BGA_COLINFO_Q[9:0] <= BGA_COLINFO_Q_B[9:0];	// stage 1
				BGB_COLINFO_Q[9:0] <= BGB_COLINFO_Q_B[9:0];	// stage 1
				OBJ_COLINFO_Q[9:0] <= OBJ_COLINFO_Q_B[9:0];	// stage 1

`ifdef debug_composite_priority

			//	CRAM_COLINFO[7:0] <= CRAM_COLINFO_SEL[7:0];	// stage 2 (stage 2)		// 
				CRAM_COLINFO[7:0] <= CRAM_COLINFO_SEL_PRI[7:0];	// stage 2 (stage 2)	// priority bit
			//	CRAM_COLINFO[7:0] <= CRAM_COLINFO_SEL_COL[7:0];	// stage 2 (stage 2)	// plane

				T_COLOR[15:0] <= CRAM_RDATA_COLINFO[15:0];			// stage 3 (stage 4)
				T_COLINFO[7:0] <= CRAM_COLINFO[7:0];				// stage 3 (stage 4)
				FF_B <= {T_COLINFO[1],T_COLINFO[0],T_COLINFO[0],T_COLINFO[0]};
				FF_G <= {T_COLINFO[3],T_COLINFO[2],T_COLINFO[2],T_COLINFO[2]};
				FF_R <= {T_COLINFO[5],T_COLINFO[4],T_COLINFO[4],T_COLINFO[4]};

			//	FF_B <= 
			//		(T_COLINFO[7:6]==2'b00) ? {T_COLOR[11:9],1'b0} :
			//		(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[11:9]} :
			//		(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[11:9]} :
			//		4'b0;
			//	FF_G <= 
			//		(T_COLINFO[7:6]==2'b00) ? {T_COLOR[7:5],1'b0} :
			//		(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[7:5]} :
			//		(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[7:5]} :
			//		4'b0;
			//	FF_R <=
			//		(T_COLINFO[7:6]==2'b00) ? {T_COLOR[3:1],1'b0} :
			//		(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[3:1]} :
			//		(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[3:1]} :
			//		4'b0;

`else

				CRAM_COLINFO[7:0] <= CRAM_COLINFO_SEL[7:0];				// stage 2 (stage 2)

				T_COLOR[15:0] <= CRAM_RDATA_COLINFO[15:0];				// stage 3 (cram clk rise-edge : stage 4)
				T_COLINFO[7:0] <= CRAM_COLINFO[7:0];					// stage 3 (cram clk rise-edge : stage 4)

				FF_B <= 
					(T_COLINFO[7:6]==2'b00) ? {T_COLOR[11:9],1'b0} :	// normal
					(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[11:9]} :	// effect shadow
					(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[11:9]} :	// effect highlight-transfer
					4'b0;
				FF_G <= 
					(T_COLINFO[7:6]==2'b00) ? {T_COLOR[7:5],1'b0} :
					(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[7:5]} :
					(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[7:5]} :
					4'b0;
				FF_R <=
					(T_COLINFO[7:6]==2'b00) ? {T_COLOR[3:1],1'b0} :
					(T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[3:1]} :
					(T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[3:1]} :
					4'b0;

`endif
				POS_X_REQ <= (PIXDIV[5]==1'b1) ? 1'b1 : 1'b0;						// stage 5 (stage 6)
				POS_X_ADDR[8:0] <= POS_X_WR[8:0];									// stage 5 (stage 6)
				POS_X_WR[8:0] <= (PIXDIV[5]==1'b1) ? POS_X_WR[8:0] + 9'b01 : 9'b0;	// stage 5 (stage 6)

				PRE_Y[9:0] <=
					(PRE_Y_LOAD==1'b1) ? 10'b0 :
					(PRE_Y_LOAD==1'b0) & (H_CNT_LOAD==1'b1) ? PRE_Y[9:0] + 10'b01 :
					PRE_Y[9:0];
			end
	end

//`else
/*

//generate
//	if (disp_bgb==1)
//begin
//	assign BGB_COLINFO_Q_B[6:0]=BGB_COLINFO_RDATA_B[6:0];
//	assign BGB_COLINFO_Q_B[8:7]=BGB_COLINFO_RDATA_B[8:7];
//	assign BGB_COLINFO_Q_B[9]=1'b0;
///	assign BGB_COLINFO_Q_B[7]=(BGB_COLINFO_RDATA_B[3:0]!=4'h0) ? 1'b1 : 1'b0;
///	assign BGB_COLINFO_Q_B[8]=(BGB_COLINFO_RDATA_B[3:0]==4'he) ? 1'b1 : 1'b0;
//end
//	else
//begin
//	assign BGB_COLINFO_Q_B[9:0]=10'b0;
//end
//endgenerate
//generate
//	if (disp_bga==1)
//begin
//	assign BGA_COLINFO_Q_B[6:0]=BGA_COLINFO_RDATA_B[6:0];
//	assign BGA_COLINFO_Q_B[7]=BGA_COLINFO_RDATA_B[7];
//	assign BGA_COLINFO_Q_B[8]=1'b0;
//	assign BGA_COLINFO_Q_B[9]=1'b0;
///	assign BGA_COLINFO_Q_B[7]=(BGA_COLINFO_RDATA_B[3:0]!=4'h0) ? 1'b1 : 1'b0;
///	assign BGA_COLINFO_Q_B[8]=(BGA_COLINFO_RDATA_B[3:0]==4'he) ? 1'b1 : 1'b0;
//
//end
//	else
//begin
//	assign BGA_COLINFO_Q_B[9:0]=10'b0;
//end
//endgenerate
//generate
//	if (disp_spr==1)
//begin
//	assign OBJ_COLINFO_Q_B[6:0]=OBJ_COLINFO_RDATA_B[6:0];
//	assign OBJ_COLINFO_Q_B[7]=OBJ_COLINFO_RDATA_B[7];
//	assign OBJ_COLINFO_Q_B[8]=(OBJ_COLINFO_RDATA_B[5:0]==6'h3e) ? 1'b1 : 1'b0;
//	assign OBJ_COLINFO_Q_B[9]=(OBJ_COLINFO_RDATA_B[5:0]==6'h3f) ? 1'b1 : 1'b0;
///	assign OBJ_COLINFO_Q_B[7]=(OBJ_COLINFO_RDATA_B[3:0]!=4'h0) ? 1'b1 : 1'b0;
///	assign OBJ_COLINFO_Q_B[8]=(OBJ_COLINFO_RDATA_B[3:0]==4'he) ? 1'b1 : 1'b0;
//end
//	else
//begin
//	assign OBJ_COLINFO_Q_B[9:0]=10'b0;
//end
//endgenerate

//	wire	CRAM_WE;
//	wire	[8:0] CRAM_WADDR;
//	wire	[8:0] CRAM_WDATA;
//	wire	[8:0] CRAM_QDATA;
//	wire	[8:0] CRAM_RADDR;
//	wire	[9:0] CRAM_RDATA;
//						T_COLOR <= (PIXDIV==4'h3) ? CRAM[CRAM_COLINFO[5:0]] : T_COLOR;	//  stage 3

	reg		[7:0] CRAM_COLINFO;

	assign BGB_COLINFO_ADDR_B=POS_X;
	assign BGA_COLINFO_ADDR_B=POS_X;
	assign OBJ_COLINFO_ADDR_B=POS_X;

	reg		POS_X_OVER;

	wire	[15:0] CRAM_RDATA_COLINFO;

	assign CRAM_RADDR[8:0]={3'b0,CRAM_COLINFO[5:0]};
	assign CRAM_RDATA_COLINFO[15:0]={4'b0,CRAM_RDATA[8:6],1'b0,CRAM_RDATA[5:3],1'b0,CRAM_RDATA[2:0],1'b0};


	// PIXEL COUNTER AND OUTPUT
	// ALSO CLEARS THE SPRITE COLINFO BUFFER RIGHT AFTER RENDERING
	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				POS_X <= 9'b0;
				POS_X_OVER <= 1'b0;
				POS_X_WR <= 9'b0;
				POS_X_REQ <= 1'b0;
//				POS_Y <= 8'b0;
				PIXDIV <= 4'b0;
//				PIXOUT <= 1'b0;
//		//		BGB_COLINFO_ADDR_B <= 9'b0;
//		//		BGA_COLINFO_ADDR_B <= 9'b0;
//		//		OBJ_COLINFO_ADDR_B <= 9'b0;
//		//		OBJ_COLINFO_D_B <= 7'b0;
				OBJ_COLINFO_WE_B <= 1'b0;
				OBJ_COLINFO_WE_B0 <= 1'b0;
				OBJ_COLINFO_WE_B1 <= 1'b0;

				FF_R <= 4'b0;
				FF_G <= 4'b0;
				FF_B <= 4'b0;
				CRAM_COLINFO[7:0] <= 8'b0;
				T_COLOR[15:0] <= 16'b0;
//			//	T_BGCOLOR[15:0] <= 16'b0;
				T_COLINFO[7:0] <= 8'b0;

				BGA_COLINFO_Q[9:0] <= 10'b0;
				BGB_COLINFO_Q[9:0] <= 10'b0;
				OBJ_COLINFO_Q[9:0] <= 10'b0;
			end
		else
			begin
				BGA_COLINFO_Q[9:0] <= BGA_COLINFO_Q_B[9:0];	// stage 1
				BGB_COLINFO_Q[9:0] <= BGB_COLINFO_Q_B[9:0];
				OBJ_COLINFO_Q[9:0] <= OBJ_COLINFO_Q_B[9:0];
				if (DISP_ACTIVE==1'b0)
					begin
						POS_X <= 9'b0;
						POS_X_OVER <= 1'b0;
						POS_X_ADDR[8:0] <= 9'b0;
						POS_X_WR <= 9'b0;
						POS_X_REQ <= 1'b0;
						PIXDIV <= 4'b0;
//						PIXOUT <= 1'b0;
						FF_R <= 4'b0;
						FF_G <= 4'b0;
						FF_B <= 4'b0;

						OBJ_COLINFO_WE_B <= 1'b0;
						OBJ_COLINFO_WE_B0 <= 1'b0;
						OBJ_COLINFO_WE_B1 <= 1'b0;
						CRAM_COLINFO[7:0] <= 8'b0;
						T_COLOR[15:0] <= 16'b0;
//					//	T_BGCOLOR[15:0] <= T_BGCOLOR[15:0];
						T_COLINFO[7:0] <= 8'b0;
					end 
				else 
					begin

						CRAM_COLINFO[7:0] <= (PIXDIV==4'h2) ? CRAM_COLINFO_SEL[7:0] : {2'b00,BGCOL[5:0]};	// stage 2

						OBJ_COLINFO_WE_B <= (PIXDIV==4'h3) ? 1'b1 : 1'b0;	// stage 3
						OBJ_COLINFO_WE_B0 <= (PRE_Y[0]==1'b1) & (PIXDIV==4'h3) ? 1'b1 : 1'b0;	// stage 3
						OBJ_COLINFO_WE_B1 <= (PRE_Y[0]==1'b0) & (PIXDIV==4'h3) ? 1'b1 : 1'b0;	// stage 3

//						T_COLOR <= (PIXDIV==4'h3) ? CRAM[CRAM_COLINFO[5:0]] : T_COLOR;	//  stage 3
						T_COLOR <= (PIXDIV==4'h3) ? CRAM_RDATA_COLINFO[15:0] : T_COLOR;	//  stage 3

//					//	T_BGCOLOR <= (PIXDIV!=4'h3) ? CRAM[CRAM_COLINFO[5:0]] : T_BGCOLOR;	//  stage !3
						T_COLINFO <= (PIXDIV==4'h3) ? CRAM_COLINFO[7:0] : T_COLINFO;	// stage 3
						FF_B <= 
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b00) ? {T_COLOR[11:9],1'b0} :
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[11:9]} :
							(PIXDIV==4'h4) & (T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[11:9]} :
							FF_B;
						FF_G <= 
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b00) ? {T_COLOR[7:5],1'b0} :
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[7:5]} :
							(PIXDIV==4'h4) & (T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[7:5]} :
							FF_G;
						FF_R <=
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b00) ? {T_COLOR[3:1],1'b0} :
							(PIXDIV==4'h4) & (T_COLINFO[7:6]==2'b01) ? {1'b0,T_COLOR[3:1]} :
							(PIXDIV==4'h4) & (T_COLINFO[7]  ==1'b1 ) ? {1'b1,T_COLOR[3:1]} :
							FF_R;
						POS_X_REQ <= (PIXDIV==4'h4) & (POS_X_OVER==1'b0) ? 1'b1 : 1'b0;

						PIXDIV <= (PIXDIV==4'h5) ? 4'b0 : PIXDIV+4'b01;
						POS_X <= (PIXDIV==4'h5) ? POS_X + 1 : POS_X;
						POS_X_OVER <= (PIXDIV==4'h5) & (POS_X==319) ? 1'b1 : POS_X_OVER;
						POS_X_ADDR[8:0] <= (PIXDIV==4'h5) ? POS_X_WR + 1 : POS_X_WR;
						POS_X_WR <= (PIXDIV==4'h5) ? POS_X_WR + 1 : POS_X_WR;

					end

//				POS_Y <=
//					(V_ACTIVE==1'b0) ? 8'b0 :
//					(V_ACTIVE==1'b1) & (H_CNT==0) ? POS_Y + 1 :
//					POS_Y;
				PRE_Y <=
					(PRE_V_ACTIVE==1'b0) ? 8'b0 :
					(PRE_V_ACTIVE==1'b1) & (H_CNT_LOAD==1'b1) ? PRE_Y + 1 :
					PRE_Y;
			end
	end
*/
//`endif


	//--------------------------------------------------------------
	// VIDEO OUTPUT
	//--------------------------------------------------------------
	// SCANDOUBLER

	wire	[8:0] line0_wr_addr;
	wire	[17:0] line0_wr_data;
	wire	line0_wr_req;
	wire	[8:0] line0_rd_addr;
	wire	[17:0] line0_rd_data;

	wire	[8:0] line1_wr_addr;
	wire	[17:0] line1_wr_data;
	wire	line1_wr_req;
	wire	[8:0] line1_rd_addr;
	wire	[17:0] line1_rd_data;

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v7_1_dp512x18 line0_dp512x18(
	.clka(CLK),
	.ena(1'b1),
	.wea({line0_wr_req,line0_wr_req}),
	.addra(line0_wr_addr[8:0]),
	.dina(line0_wr_data[17:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(2'b0),
	.addrb(line0_rd_addr[8:0]),
	.dinb(18'b0),
	.doutb(line0_rd_data[17:0])
);

xil_blk_mem_gen_v7_1_dp512x18 line1_dp512x18(
	.clka(CLK),
	.ena(1'b1),
	.wea({line1_wr_req,line1_wr_req}),
	.addra(line1_wr_addr[8:0]),
	.dina(line1_wr_data[17:0]),
	.douta(),
	.clkb(CLK),
	.enb(1'b1),
	.web(2'b0),
	.addrb(line1_rd_addr[8:0]),
	.dinb(18'b0),
	.doutb(line1_rd_data[17:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_dp512x18 line0_dp512x18(
	.address_a(line0_wr_addr[8:0]),
	.address_b(line0_rd_addr[8:0]),
	.byteena_a(2'b11),
	.byteena_b(2'b11),
	.clock(CLK),
	.data_a(line0_wr_data[17:0]),
	.data_b(18'b0),
	.wren_a(line0_wr_req),
	.wren_b(1'b0),
	.q_a(),
	.q_b(line0_rd_data[17:0])
);

alt_altsyncram_dp512x18 line1_dp512x18(
	.address_a(line0_wr_addr[8:0]),
	.address_b(line0_rd_addr[8:0]),
	.byteena_a(2'b11),
	.byteena_b(2'b11),
	.clock(CLK),
	.data_a(line0_wr_data[17:0]),
	.data_b(18'b0),
	.wren_a(line1_wr_req),
	.wren_b(1'b0),
	.q_a(),
	.q_b(line1_rd_data[17:0])
);

end
endgenerate

	assign line0_wr_addr[8:0]=POS_X_WR[8:0];
	assign line0_wr_data[17:12]={FF_R[3:0],FF_R[3:2]};
	assign line0_wr_data[11:6]={FF_G[3:0],FF_G[3:2]};
	assign line0_wr_data[5:0]={FF_B[3:0],FF_B[3:2]};
	assign line0_wr_req=(PRE_Y[0]==1'b0) ? POS_X_REQ : 1'b0;

	assign line1_wr_addr[8:0]=POS_X_WR[8:0];
	assign line1_wr_data[17:12]={FF_R[3:0],FF_R[3:2]};
	assign line1_wr_data[11:6]={FF_G[3:0],FF_G[3:2]};
	assign line1_wr_data[5:0]={FF_B[3:0],FF_B[3:2]};
	assign line1_wr_req=(PRE_Y[0]==1'b1) ? POS_X_REQ : 1'b0;

	wire 	[17:0]	RGB;

	assign line0_rd_addr[8:0]=H_DE_CNT[24:16];
	assign line1_rd_addr[8:0]=H_DE_CNT[24:16];

	assign RGB[17:0]=
`ifdef disp_scale
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b0) & (H_DE_CNT[18:17]==2'b00) & (H_DE_CNT[16]==1'b0) ? {18'b000000_000000_111111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b1) & (H_DE_CNT[18:17]==2'b00) & (H_DE_CNT[16]==1'b0) ? {18'b011111_011111_011111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b0) & (H_DE_CNT[18:17]==2'b00) & (H_DE_CNT[16]==1'b1) ? {18'b011111_011111_011111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b1) & (H_DE_CNT[18:17]==2'b00) & (H_DE_CNT[16]==1'b1) ? {18'b001111_001111_001111} :

			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b0) & (H_DE_CNT[18:17]!=2'b00) & (H_DE_CNT[16]==1'b0) ? {18'b000111_000111_000111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b1) & (H_DE_CNT[18:17]!=2'b00) & (H_DE_CNT[16]==1'b0) ? {18'b011111_011111_011111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b0) & (H_DE_CNT[18:17]!=2'b00) & (H_DE_CNT[16]==1'b1) ? {18'b011111_011111_011111} :
			(V_ACTIVE==1'b0) & (V_CNT[1]==1'b1) & (H_DE_CNT[18:17]!=2'b00) & (H_DE_CNT[16]==1'b1) ? {18'b001111_001111_001111} :
`else
			(V_ACTIVE==1'b0) ? {18'b011111_011111_011111} :
`endif
			(V_ACTIVE==1'b1) & (LINE_DISP==1'b0) ? {18'b0} :
			(V_ACTIVE==1'b1) & (LINE_DISP==1'b1) & (PRE_Y[0]==1'b0) ? line1_rd_data[17:0] :
			(V_ACTIVE==1'b1) & (LINE_DISP==1'b1) & (PRE_Y[0]==1'b1) ? line0_rd_data[17:0] :

			18'b0;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				FF_VGA_R <= 8'b0;
				FF_VGA_G <= 8'b0;
				FF_VGA_B <= 8'b0;

				FF_VGA_VS[7:0] <= 8'hff;
				FF_VGA_HS[7:0] <= 8'hff;
				FF_VGA_VDE <= 1'b1;
				FF_VGA_DE[7:0] <= 8'h00;
				H_DE_CNT[24:0] <= 25'b0;
				FF_VGA_CLK[7:0] <= 8'h00;
			end
		else
			begin
`ifdef debug_display

				FF_VGA_R <= 
					(debug_dma_r==1'b0) ? {RGB[17:12],RGB[17:16]} :
					(debug_dma_r==1'b1) & (SP1E_ACTIVE==1'b0) ? {RGB[17:12],RGB[17:16]} :
					(debug_dma_r==1'b1) & (SP1E_ACTIVE==1'b1) ? 8'hff :
				//	(debug_dma_r==1'b1) & (BGB_COLINFO_WE_A0==1'b0) ? {RGB[17:12],RGB[17:16]} :
				//	(debug_dma_r==1'b1) & (BGB_COLINFO_WE_A0==1'b1) ? 8'hff :
					8'b0;
				FF_VGA_G <= 
					(debug_dma_r==1'b0) ? {RGB[11:6],RGB[11:10]} :
					(debug_dma_r==1'b1) & (HINT==1'b0) ? {RGB[11:6],RGB[11:10]} :
					(debug_dma_r==1'b1) & (HINT==1'b1) ? 8'hff :
				//	(debug_dma_r==1'b1) & (OBJ_COLINFO_WE_B0==1'b0) ? {RGB[11:6],RGB[11:10]} :
				//	(debug_dma_r==1'b1) & (OBJ_COLINFO_WE_B0==1'b1) ? 8'hff :
					8'b0;
				FF_VGA_B <= 
					(debug_dma_r==1'b0) ? {RGB[5:0],RGB[5:4]} :
					(debug_dma_r==1'b1) & (VINT_TG68==1'b0) ? {RGB[5:0],RGB[5:4]} :
					(debug_dma_r==1'b1) & (VINT_TG68==1'b1) ? 8'hff :
				//	(debug_dma_r==1'b1) & (BGB_SEL==1'b1) ? {RGB[5:0],RGB[5:4]} :
				//	(debug_dma_r==1'b1) & (BGB_SEL==1'b0) ? 8'hff :
					8'b0;

`else
				FF_VGA_R <= (FF_VGA_CLK[5:4]==2'b01) ? {RGB[17:12],RGB[17:16]} : FF_VGA_R;
				FF_VGA_G <= (FF_VGA_CLK[5:4]==2'b01) ? {RGB[11:6],RGB[11:10]} : FF_VGA_G;
				FF_VGA_B <= (FF_VGA_CLK[5:4]==2'b01) ? {RGB[5:0],RGB[5:4]} : FF_VGA_B;
`endif

				FF_VGA_VS[0] <=
					(H_VGA_CNT_LOAD==1'b1) & (V_CNT==(VGA_VS_LINES -1)) ? 1'b1 :
					(H_VGA_CNT_LOAD==1'b0) & (V_CNT==(VGA_LINES -1)) ? 1'b0 :
					FF_VGA_VS[0];
				FF_VGA_VS[7:1] <= FF_VGA_VS[6:0];

				FF_VGA_HS[0] <=
					(H_VGA_CNT_LOAD==1'b1) ? 1'b0 :
					(H_VGA_CNT_LOAD==1'b0) & (H_VGA_CNT==(VGA_HS_CLOCKS -1)) ? 1'b1 :
					FF_VGA_HS[0];
				FF_VGA_HS[7:1] <= FF_VGA_HS[6:0];

				FF_VGA_VDE <=
					(H_VGA_CNT_LOAD==1'b1) & (V_CNT==(VGA_V_DISP_START -1)) ? 1'b1 :
					(H_VGA_CNT_LOAD==1'b0) & (V_CNT==(VGA_V_DISP_START + 480 -1)) ? 1'b0 :
					FF_VGA_VDE;

				FF_VGA_DE[0] <=
					(H_VGA_CNT==VGA_DE_START-1) ? FF_VGA_VDE :
					(H_VGA_CNT==(VGA_DE_START + VGA_DE_DISP-1)) ? 1'b0 :
					FF_VGA_DE[0];
				FF_VGA_DE[7:1] <= FF_VGA_DE[6:0];

				H_DE_CNT[24:0] <= 
					(FF_VGA_DE[0]==1'b1) & (H40==1'b1) ? H_DE_CNT[24:0]+25'h0004000 :
					(FF_VGA_DE[0]==1'b1) & (H40==1'b0) & (H_DE_CNT[23:16]==8'hff) ? 25'h0ff0000 :
					(FF_VGA_DE[0]==1'b1) & (H40==1'b0) & (H_DE_CNT[23:16]!=8'hff) ? H_DE_CNT[24:0]+25'h0003334 :
					(FF_VGA_DE[0]==1'b0) ? 25'b0 :
					25'b0;

				FF_VGA_CLK[0] <= H_VGA_CNT[0];
				FF_VGA_CLK[7:1] <= FF_VGA_CLK[6:0];
			end
	end

	assign VGA_R[7:0]=FF_VGA_R[7:0];
	assign VGA_G[7:0]=FF_VGA_G[7:0];
	assign VGA_B[7:0]=FF_VGA_B[7:0];
	assign VGA_HS=FF_VGA_HS[6];
	assign VGA_VS=FF_VGA_VS[6];
	assign VGA_DE=FF_VGA_DE[6];
	assign VGA_CLK=FF_VGA_CLK[6];

	//--------------------------------------------------------------
	// VIDEO DEBUG
	//--------------------------------------------------------------

	//--------------------------------------------------------------
	// DATA TRANSFER CONTROLLER
	//--------------------------------------------------------------

`ifdef replace_dmastate

	reg		CRAM_WE_r;
	reg		[8:0] CRAM_WADDR_r;
	reg		[8:0] CRAM_WDATA_r;
	reg		VSRAM0_WE_r;
	reg		[8:0] VSRAM0_WADDR_r;
	reg		[17:0] VSRAM0_WDATA_r;
	reg		VSRAM1_WE_r;
	reg		[8:0] VSRAM1_WADDR_r;
	reg		[17:0] VSRAM1_WDATA_r;

	assign CRAM_WE=CRAM_WE_r;
	assign CRAM_WADDR=CRAM_WADDR_r;
	assign CRAM_WDATA=CRAM_WDATA_r;
	assign VSRAM0_WE=VSRAM0_WE_r;
	assign VSRAM0_WADDR=VSRAM0_WADDR_r;
	assign VSRAM0_WDATA=VSRAM0_WDATA_r;
	assign VSRAM1_WE=VSRAM1_WE_r;
	assign VSRAM1_WADDR=VSRAM1_WADDR_r;
	assign VSRAM1_WDATA=VSRAM1_WDATA_r;

	assign VBUS_DMA_REQ=DMA_VBUS;//FF_VBUS_DMA_REQ;
	assign VBUS_ADDR=FF_VBUS_ADDR;
	assign VBUS_UDS_N=1'b0;//FF_VBUS_UDS_N;
	assign VBUS_LDS_N=1'b0;//FF_VBUS_LDS_N;
	assign VBUS_SEL=FF_VBUS_SEL;

	wire 	[2:0]	DT_CODE;

	assign DT_CODE=
			(FIFO_RD_POS==2'b00) ? FIFO_DATA0[34:32] :
			(FIFO_RD_POS==2'b01) ? FIFO_DATA1[34:32] :
			(FIFO_RD_POS==2'b10) ? FIFO_DATA2[34:32] :
			(FIFO_RD_POS==2'b11) ? FIFO_DATA3[34:32] :
			0;

/*

	wire	vdpreg_wr;

	reg		vdpreg_wr_ack_r;
	wire	vdpreg_wr_ack_w;

	always @(negedge RST_N or posedge CLK) 
	begin
		if (RST_N==1'b0) 
			begin
				vdpreg_wr_ack_r[2:0] <= 3'b0;
				REG0 <= 8'h00;
				REG1 <= 8'h00;
				REG2 <= 8'h00;
				REG3 <= 8'h00;
				REG4 <= 8'h00;
				REG5 <= 8'h00;
				REG6 <= 8'h00;
				REG7 <= 8'h00;
				REG8 <= 8'h00;
				REG9 <= 8'h00;
				REG10 <= 8'h00;
				REG11 <= 8'h00;
				REG12 <= 8'h00;
				REG13 <= 8'h00;
				REG14 <= 8'h00;
				REG15 <= 8'h00;
				REG16 <= 8'h00;
				REG17 <= 8'h00;
				REG18 <= 8'h00;
				REG19 <= 8'h00;
				REG20 <= 8'h00;
				REG21 <= 8'h00;
				REG22 <= 8'h00;
				REG23 <= 8'h00;
				REG24 <= 8'h00;
				REG25 <= 8'h00;
				REG26 <= 8'h00;
				REG27 <= 8'h00;
				REG28 <= 8'h00;
				REG29 <= 8'h00;
				REG30 <= 8'h00;
				REG31 <= 8'h00;
			end
		else
			begin
				REG_SET_ACK <= vdpreg_wr_ack_w;
				vdpreg_wr_ack_r <= vdpreg_wr_ack_w;
				REG0 <= (REG_LATCH[12:8]==5'd00) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG0;
				REG1 <= (REG_LATCH[12:8]==5'd01) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG1;
				REG2 <= (REG_LATCH[12:8]==5'd02) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG2;
				REG3 <= (REG_LATCH[12:8]==5'd03) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG3;
				REG4 <= (REG_LATCH[12:8]==5'd04) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG4;
				REG5 <= (REG_LATCH[12:8]==5'd05) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG5;
				REG6 <= (REG_LATCH[12:8]==5'd06) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG6;
				REG7 <= (REG_LATCH[12:8]==5'd07) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG7;
				REG8 <= (REG_LATCH[12:8]==5'd08) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG8;
				REG9 <= (REG_LATCH[12:8]==5'd09) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG9;
				REG10 <= (REG_LATCH[12:8]==5'd10) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG10;
				REG11 <= (REG_LATCH[12:8]==5'd11) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG11;
				REG12 <= (REG_LATCH[12:8]==5'd12) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG12;
				REG13 <= (REG_LATCH[12:8]==5'd13) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG13;
				REG14 <= (REG_LATCH[12:8]==5'd14) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG14;
				REG15 <= (REG_LATCH[12:8]==5'd15) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG15;
				REG16 <= (REG_LATCH[12:8]==5'd16) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG16;
				REG17 <= (REG_LATCH[12:8]==5'd17) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG17;
				REG18 <= (REG_LATCH[12:8]==5'd18) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG18;
				REG19 <= (REG_LATCH[12:8]==5'd19) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG19;
				REG20 <= (REG_LATCH[12:8]==5'd20) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG20;
				REG21 <= (REG_LATCH[12:8]==5'd21) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG21;
				REG22 <= (REG_LATCH[12:8]==5'd22) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG22;
				REG23 <= (REG_LATCH[12:8]==5'd23) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG23;
				REG24 <= (REG_LATCH[12:8]==5'd24) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG24;
				REG25 <= (REG_LATCH[12:8]==5'd25) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG25;
				REG26 <= (REG_LATCH[12:8]==5'd26) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG26;
				REG27 <= (REG_LATCH[12:8]==5'd27) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG27;
				REG28 <= (REG_LATCH[12:8]==5'd28) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG28;
				REG29 <= (REG_LATCH[12:8]==5'd29) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG29;
				REG30 <= (REG_LATCH[12:8]==5'd30) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG30;
				REG31 <= (REG_LATCH[12:8]==5'd31) & (vdpreg_wr==1'b1) ? REG_LATCH[7:0] : REG31;
			end
	end

	assign vdpreg_wr=(REG_SET_REQ==1'b1 && REG_SET_ACK==1'b0 && IN_DMA==1'b0) begin

	assign vdpreg_wr_ack_w=(REG_SET_REQ==1'b1) & (REG_SET_ACK==1'b0) & (IN_DMA==1'b0) ? 1'b1 : 1'b0;

*/


	always @(negedge RST_N or posedge CLK) begin
		if (RST_N==1'b0) begin

			REG0 <= 8'h00;
			REG1 <= 8'h00;
			REG2 <= 8'h00;
			REG3 <= 8'h00;
			REG4 <= 8'h00;
			REG5 <= 8'h00;
			REG6 <= 8'h00;
			REG7 <= 8'h00;
			REG8 <= 8'h00;
			REG9 <= 8'h00;
			REG10 <= 8'h00;
			REG11 <= 8'h00;
			REG12 <= 8'h00;
			REG13 <= 8'h00;
			REG14 <= 8'h00;
			REG15 <= 8'h00;
			REG16 <= 8'h00;
			REG17 <= 8'h00;
			REG18 <= 8'h00;
			REG19 <= 8'h00;
			REG20 <= 8'h00;
			REG21 <= 8'h00;
			REG22 <= 8'h00;
			REG23 <= 8'h00;
			REG24 <= 8'h00;
			REG25 <= 8'h00;
			REG26 <= 8'h00;
			REG27 <= 8'h00;
			REG28 <= 8'h00;
			REG29 <= 8'h00;
			REG30 <= 8'h00;
			REG31 <= 8'h00;

					FIFO_DATA0 <= 0;
					FIFO_DATA1 <= 0;
					FIFO_DATA2 <= 0;
					FIFO_DATA3 <= 0;
				DT_WR_SIZE <= 0;
				DT_WR_CODE <= 0;
				DT_WR_ADDR <= 0;
				DT_WR_DATA <= 0;

	DT_RD_DATA <= 0;

			ADDR <= 16'h0000;
			ADDR_SET_ACK <= 1'b0;
			REG_SET_ACK <= 1'b0;
			DT_VRAM_SEL <= 1'b0;
					DT_VRAM_ADDR <= 0;
					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= 0;
			FIFO_RD_POS <= 2'b00;
			FIFO_WR_POS <= 2'b00;
			FIFO_EMPTY <= 1'b1;
			FIFO_FULL <= 1'b0;

			DT_RD_DTACK_N <= 1'b1;
			DT_FF_DTACK_N <= 1'b1;

			FF_VBUS_DMA_REQ <= 1'b0;
			FF_VBUS_ADDR <= 24'b0;
			FF_VBUS_UDS_N <= 1'b0;
			FF_VBUS_LDS_N <= 1'b0;
			FF_VBUS_SEL <= 1'b0;
			DMA_FILL_PRE <= 1'b0;
			DMA_FILL <= 1'b0;
			DMA_COPY <= 1'b0;
			DMA_VBUS <= 1'b0;
			DMA_SOURCE <= 16'h0000;
			DMA_LENGTH <= 16'h0000;
			DTC <= DTC_IDLE;

	DT_DMAV_DATA <= 0;

			DMAF_SET_ACK <= 1'b0;

			CRAM_WE_r <= 1'b0;
			CRAM_WADDR_r[8:0] <= 9'b0;
			CRAM_WDATA_r[8:0] <= 9'b0;
			VSRAM0_WE_r <= 1'b0;
			VSRAM0_WADDR_r[8:0] <= 9'b0;
			VSRAM0_WDATA_r[17:0] <= 18'b0;
			VSRAM1_WE_r <= 1'b0;
			VSRAM1_WADDR_r[8:0] <= 9'b0;
			VSRAM1_WDATA_r[17:0] <= 18'b0;

		end
		else
		begin

			FIFO_EMPTY <= (FIFO_RD_POS==FIFO_WR_POS) ? 1'b1 : 1'b0;
			FIFO_FULL <= (FIFO_WR_POS + 1==FIFO_RD_POS) ? 1'b1 : 1'b0;

			if (DT_FF_SEL==1'b0) begin DT_FF_DTACK_N <= 1'b1; end
			if (ADDR_SET_REQ==1'b0) begin ADDR_SET_ACK <= 1'b0; end
			if (REG_SET_REQ==1'b0) begin REG_SET_ACK <= 1'b0; end
			if (DMAF_SET_REQ==1'b0) begin DMAF_SET_ACK <= 1'b0; end


			if (DT_FF_SEL==1'b1 && (FIFO_WR_POS + 1 != FIFO_RD_POS) && DT_FF_DTACK_N==1'b1) begin

				if (FIFO_WR_POS==2'b00) begin FIFO_DATA0 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b01) begin FIFO_DATA1 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b10) begin FIFO_DATA2 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b11) begin FIFO_DATA3 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end

				FIFO_WR_POS <= FIFO_WR_POS + 1;
				ADDR <= ADDR + ADDR_STEP;
				DT_FF_DTACK_N <= 1'b0;
			end
		//	if (DT_ACTIVE==1'b1) begin
				case (DTC)
				DTC_IDLE: begin
					CRAM_WE_r <= 1'b0;
					VSRAM0_WE_r <= 1'b0;
					VSRAM1_WE_r <= 1'b0;
				
					if (DMA_VBUS==1'b1) begin
						DTC <= DTC_DMA_VBUS_INIT;
					end else if (DMA_FILL==1'b1) begin
						DTC <= DTC_DMA_FILL_INIT;
					end else if (DMA_COPY==1'b1) begin
						DTC <= DTC_DMA_COPY_INIT;
					end else if (FIFO_RD_POS != FIFO_WR_POS) begin
						DTC <= DTC_FIFO_RD;
					end else if (DT_RD_SEL==1'b1 && DT_RD_DTACK_N==1'b1) begin
						case (DT_RD_CODE)
						4'b1000: begin
							// CRAM Read
							DTC <= DTC_CRAM_RD;
						end
						4'b0100: begin
							// VSRAM Read
							DTC <= DTC_VSRAM_RD;
						end
						default: begin
							// VRAM Read
							DTC <= DTC_VRAM_RD1;
						end
						endcase
					end else begin
						if (ADDR_SET_REQ==1'b1 && ADDR_SET_ACK==1'b0 && IN_DMA==1'b0) begin
							ADDR <= ADDR_LATCH;

							if (CODE[5]==1'b1 && DMA==1'b1 && PENDING==1'b1)
								begin
									DMA_VBUS <= (REG23[7]==1'b0) ? 1'b1 : DMA_VBUS;
									DMA_FILL_PRE <= (REG23[7:6]==2'b10) ? 1'b1 : DMA_FILL_PRE;
									DMA_COPY <= (REG23[7:6]==2'b11) ? 1'b1 : DMA_COPY;
								end

							ADDR_SET_ACK <= 1'b1;
						end

						if (REG_SET_REQ==1'b1 && REG_SET_ACK==1'b0 && IN_DMA==1'b0) begin
							if (REG_LATCH[12:8]==5'b00000) begin REG0 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00001) begin REG1 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00010) begin REG2 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00011) begin REG3 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00100) begin REG4 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00101) begin REG5 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00110) begin REG6 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00111) begin REG7 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01000) begin REG8 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01001) begin REG9 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01010) begin REG10 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01011) begin REG11 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01100) begin REG12 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01101) begin REG13 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01110) begin REG14 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01111) begin REG15 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10000) begin REG16 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10001) begin REG17 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10010) begin REG18 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10011) begin REG19 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10100) begin REG20 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10101) begin REG21 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10110) begin REG22 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10111) begin REG23 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11000) begin REG24 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11001) begin REG25 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11010) begin REG26 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11011) begin REG27 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11100) begin REG28 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11101) begin REG29 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11110) begin REG30 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11111) begin REG31 <= REG_LATCH[7:0]; end
							REG_SET_ACK <= 1'b1;
						end

						if (DMAF_SET_REQ==1'b1 && DMAF_SET_ACK==1'b0 && IN_DMA==1'b0) begin
							DMA_FILL <= (DMA_FILL_PRE==1'b1) ? 1'b1 : DMA_FILL;
							DMAF_SET_ACK <= 1'b1;
						end
					end
				end
				DTC_FIFO_RD: begin

				if (FIFO_RD_POS==2'b00) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA0; end
				if (FIFO_RD_POS==2'b01) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA1; end
				if (FIFO_RD_POS==2'b10) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA2; end
				if (FIFO_RD_POS==2'b11) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA3; end


					FIFO_RD_POS <= FIFO_RD_POS + 1;
					case (DT_CODE)
					3'b011: begin
						// CRAM Write
						DTC <= DTC_CRAM_WR;
					end
					3'b101: begin
						// VSRAM Write
						DTC <= DTC_VSRAM_WR;
					end
					default: begin
						// VRAM Write
						DTC <= DTC_VRAM_WR1;
					end
					endcase
				end

				DTC_VRAM_WR1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {DT_WR_ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;

					DT_VRAM_DI[15:8] <= (DT_WR_ADDR[0]==1'b0) ? DT_WR_DATA[15:8] : DT_WR_DATA[7:0];
					DT_VRAM_DI[7:0]  <= (DT_WR_ADDR[0]==1'b0) ? DT_WR_DATA[7:0]  : DT_WR_DATA[15:8];

					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DTC <= DTC_VRAM_WR2;
				end
				DTC_VRAM_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end
				end


				DTC_CRAM_WR: begin
				//	CRAM[DT_WR_ADDR[6:1]] <= DT_WR_DATA;

					CRAM_WE_r <= 1'b1;
					CRAM_WADDR_r[8:0] <= {3'b0,DT_WR_ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_WR_DATA[11:9],DT_WR_DATA[7:5],DT_WR_DATA[3:1]};

					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end

				DTC_VSRAM_WR: begin

					DTC <= (DT_ACTIVE==1'b1) ? DTC_VSRAM_WR2 : DTC_VSRAM_WR;
				//	DTC <= DTC_VSRAM_WR2;
				end
				DTC_VSRAM_WR2: begin

			VSRAM0_WE_r <= (DT_WR_ADDR[1]==1'b0) ? 1'b1 : 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,DT_WR_ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};
			VSRAM1_WE_r <= (DT_WR_ADDR[1]==1'b1) ? 1'b1 : 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,DT_WR_ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};

					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end
				DTC_VRAM_RD1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b1;
					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DTC <= DTC_VRAM_RD2;
				end
				DTC_VRAM_RD2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DT_RD_DATA <= DT_VRAM_DO;
						DT_RD_DTACK_N <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end
				end
				DTC_CRAM_RD: begin
					CRAM_WE_r <= 1'b0;
					CRAM_WADDR_r[8:0] <= {3'b0,ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_WR_DATA[11:9],DT_WR_DATA[7:5],DT_WR_DATA[3:1]};

					DTC <= DTC_CRAM_RD1;
				end
				DTC_CRAM_RD1: begin
				//	DT_RD_DATA <= CRAM[ADDR[6:1]];

					DT_RD_DATA <= {4'b0,CRAM_QDATA[8:6],1'b0,CRAM_QDATA[5:3],1'b0,CRAM_QDATA[2:0],1'b0};

					DT_RD_DTACK_N <= 1'b0;
					ADDR <= ADDR + ADDR_STEP;
					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end
				DTC_VSRAM_RD: begin

			VSRAM0_WE_r <= 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};
			VSRAM1_WE_r <= 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};

					DTC <= DTC_VSRAM_RD1;

				end
				DTC_VSRAM_RD1: begin
				//	DT_RD_DATA <= {6'b0,VSRAM[ADDR[6:1]]};
					DT_RD_DATA <= (ADDR[1]==1'b0) ? VSRAM0_QDATA[15:0] : VSRAM1_QDATA[15:0];
					DT_RD_DTACK_N <= 1'b0;
					ADDR <= ADDR + ADDR_STEP;
					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--

				end
				//--------------------------------------------------------------
				// DMA FILL
				//--------------------------------------------------------------
				DTC_DMA_FILL_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DTC <= DTC_DMA_FILL_WR;
				end
				DTC_DMA_FILL_WR: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= {DT_DMAF_DATA[7:0], DT_DMAF_DATA[7:0]};
					DT_VRAM_UDS_N <= (ADDR[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (ADDR[0]==1'b0) ? 1'b0 : 1'b1;
					DTC <= DTC_DMA_FILL_WR2;
				end
				DTC_DMA_FILL_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DTC <= DTC_DMA_FILL_LOOP;
					end
				end
				DTC_DMA_FILL_LOOP: begin
					if (DMA_LENGTH==0) begin
						DMA_FILL_PRE <= 1'b0;
						DMA_FILL <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end else begin
						DTC <= DTC_DMA_FILL_WR;
					end
				end


				//--------------------------------------------------------------
				// DMA COPY
				//--------------------------------------------------------------

				DTC_DMA_COPY_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DMA_SOURCE <= {REG22, REG21};
					DTC <= DTC_DMA_COPY_RD;
				end
				DTC_DMA_COPY_RD: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {DMA_SOURCE[15:1],1'b0};
					DT_VRAM_RNW <= 1'b1;

					DT_VRAM_UDS_N <= (DMA_SOURCE[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (DMA_SOURCE[0]==1'b0) ? 1'b0 : 1'b1;

					DTC <= DTC_DMA_COPY_RD2;
				end
				DTC_DMA_COPY_RD2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DTC <= DTC_DMA_COPY_WR;
					end
				end


				DTC_DMA_COPY_WR: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= DT_VRAM_DO;

					DT_VRAM_UDS_N <= (ADDR[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (ADDR[0]==1'b0) ? 1'b0 : 1'b1;

					DTC <= DTC_DMA_COPY_WR2;

				end
				DTC_DMA_COPY_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DMA_SOURCE <= DMA_SOURCE + 1;
						DTC <= DTC_DMA_COPY_LOOP;
					end
				end
				DTC_DMA_COPY_LOOP: begin
					if (DMA_LENGTH==0) begin
						DMA_COPY <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						REG22 <= DMA_SOURCE[15:8];
						REG21 <= DMA_SOURCE[7:0];
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end else begin
						DTC <= DTC_DMA_COPY_RD;
					end
				end


				//--------------------------------------------------------------
				// DMA VBUS
				//--------------------------------------------------------------
				DTC_DMA_VBUS_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DMA_SOURCE <= {REG22, REG21};
					DTC <= (DT_ACTIVE==1'b1) ? DTC_DMA_VBUS_RD : DTC_DMA_VBUS_INIT;
				end
				DTC_DMA_VBUS_RD: begin
					FF_VBUS_SEL <= 1'b1;
					FF_VBUS_ADDR <= {{REG23[6:0], DMA_SOURCE}, 1'b0};
				//	FF_VBUS_UDS_N <= 1'b0;
				//	FF_VBUS_LDS_N <= 1'b0;
					DTC <= DTC_DMA_VBUS_RD2;

				end
				DTC_DMA_VBUS_RD2: begin
					if (VBUS_DTACK_N==1'b0) begin
						FF_VBUS_SEL <= 1'b0;
						DT_DMAV_DATA <= VBUS_DATA;
						DTC <= DTC_DMA_VBUS_SEL;
					end
				end
				DTC_DMA_VBUS_SEL: begin
					case (CODE[2:0])
					3'b011: begin
						// CRAM Write
						DTC <= DTC_DMA_VBUS_CRAM_WR;
					end
					3'b101: begin
						// VSRAM Write
						DTC <= DTC_DMA_VBUS_VSRAM_WR;
					end
					default: begin
						// VRAM Write
						DTC <= DTC_DMA_VBUS_VRAM_WR1;
					end
					endcase
				end
				DTC_DMA_VBUS_CRAM_WR: begin
				//	CRAM[ADDR[6:1]] <= DT_DMAV_DATA;

					CRAM_WE_r <= 1'b1;
					CRAM_WADDR_r[8:0] <= {3'b0,ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_DMAV_DATA[11:9],DT_DMAV_DATA[7:5],DT_DMAV_DATA[3:1]};

					ADDR <= ADDR + ADDR_STEP;
					DMA_LENGTH <= DMA_LENGTH - 1;
					DMA_SOURCE <= DMA_SOURCE + 1;
					DTC <= DTC_DMA_VBUS_LOOP;

				end
				DTC_DMA_VBUS_VSRAM_WR: begin
				//	VSRAM[ADDR[6:1]] <= DT_DMAV_DATA[9:0];
				//	if (ADDR[6:1]==6'b000000) begin
				//		VSRAM0 <= DT_DMAV_DATA;
				//	end
				//	if (ADDR[6:1]==6'b000001) begin
				//		VSRAM1 <= DT_DMAV_DATA;
				//	end

			VSRAM0_WE_r <= (ADDR[1]==1'b0) ? 1'b1 : 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_DMAV_DATA[10:0]};
			VSRAM1_WE_r <= (ADDR[1]==1'b1) ? 1'b1 : 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_DMAV_DATA[10:0]};

					ADDR <= ADDR + ADDR_STEP;
					DMA_LENGTH <= DMA_LENGTH - 1;
					DMA_SOURCE <= DMA_SOURCE + 1;
					DTC <= DTC_DMA_VBUS_LOOP;
				end
				DTC_DMA_VBUS_VRAM_WR1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;

					DT_VRAM_DI[15:8] <= (ADDR[0]==1'b0) ? DT_DMAV_DATA[15:8] : DT_DMAV_DATA[7:0];
					DT_VRAM_DI[7:0]  <= (ADDR[0]==1'b0) ? DT_DMAV_DATA[7:0]  : DT_DMAV_DATA[15:8];

					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DTC <= DTC_DMA_VBUS_VRAM_WR2;
				end
				DTC_DMA_VBUS_VRAM_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DMA_SOURCE <= DMA_SOURCE + 1;
						DTC <= DTC_DMA_VBUS_LOOP;
					end
				end
				DTC_DMA_VBUS_LOOP: begin
					CRAM_WE_r <= 1'b0;
					VSRAM0_WE_r <= 1'b0;
					VSRAM1_WE_r <= 1'b0;
				
					if (DMA_LENGTH==0) begin
						DMA_VBUS <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						REG22 <= DMA_SOURCE[15:8];
						REG21 <= DMA_SOURCE[7:0];
						DTC <= DTC_IDLE;
					//	DMA_VBUS <= 1'b0;		// <--
					end else begin
						DTC <= DTC_DMA_VBUS_RD;
					end
				end
				default: begin
				end
				endcase
		//	end else begin	// DT_ACTIVE='0'
	// Do nothing
		//	end
		end
	end

`else

	reg		CRAM_WE_r;
	reg		[8:0] CRAM_WADDR_r;
	reg		[8:0] CRAM_WDATA_r;
	reg		VSRAM0_WE_r;
	reg		[8:0] VSRAM0_WADDR_r;
	reg		[17:0] VSRAM0_WDATA_r;
	reg		VSRAM1_WE_r;
	reg		[8:0] VSRAM1_WADDR_r;
	reg		[17:0] VSRAM1_WDATA_r;

	assign CRAM_WE=CRAM_WE_r;
	assign CRAM_WADDR=CRAM_WADDR_r;
	assign CRAM_WDATA=CRAM_WDATA_r;
	assign VSRAM0_WE=VSRAM0_WE_r;
	assign VSRAM0_WADDR=VSRAM0_WADDR_r;
	assign VSRAM0_WDATA=VSRAM0_WDATA_r;
	assign VSRAM1_WE=VSRAM1_WE_r;
	assign VSRAM1_WADDR=VSRAM1_WADDR_r;
	assign VSRAM1_WDATA=VSRAM1_WDATA_r;

	assign VBUS_DMA_REQ=DMA_VBUS;//FF_VBUS_DMA_REQ;
	assign VBUS_ADDR=FF_VBUS_ADDR;
	assign VBUS_UDS_N=1'b0;//FF_VBUS_UDS_N;
	assign VBUS_LDS_N=1'b0;//FF_VBUS_LDS_N;
	assign VBUS_SEL=FF_VBUS_SEL;

	wire 	[2:0]	DT_CODE;

	assign DT_CODE=
			(FIFO_RD_POS==2'b00) ? FIFO_DATA0[34:32] :
			(FIFO_RD_POS==2'b01) ? FIFO_DATA1[34:32] :
			(FIFO_RD_POS==2'b10) ? FIFO_DATA2[34:32] :
			(FIFO_RD_POS==2'b11) ? FIFO_DATA3[34:32] :
			0;

	always @(negedge RST_N or posedge CLK) begin
		if (RST_N==1'b0) begin

			//	REG <= (others => (others => '0'));
			REG0 <= 8'h00;
			REG1 <= 8'h00;
			REG2 <= 8'h00;
			REG3 <= 8'h00;
			REG4 <= 8'h00;
			REG5 <= 8'h00;
			REG6 <= 8'h00;
			REG7 <= 8'h00;
			REG8 <= 8'h00;
			REG9 <= 8'h00;
			REG10 <= 8'h00;
			REG11 <= 8'h00;
			REG12 <= 8'h00;
			REG13 <= 8'h00;
			REG14 <= 8'h00;
			REG15 <= 8'h00;
			REG16 <= 8'h00;
			REG17 <= 8'h00;
			REG18 <= 8'h00;
			REG19 <= 8'h00;
			REG20 <= 8'h00;
			REG21 <= 8'h00;
			REG22 <= 8'h00;
			REG23 <= 8'h00;
			REG24 <= 8'h00;
			REG25 <= 8'h00;
			REG26 <= 8'h00;
			REG27 <= 8'h00;
			REG28 <= 8'h00;
			REG29 <= 8'h00;
			REG30 <= 8'h00;
			REG31 <= 8'h00;
			//	CRAM <= (others => (others => '0'));
			//	VSRAM <= (others => (others => '0'));
		//	VSRAM0 <= 16'h0000;
		//	VSRAM1 <= 16'h0000;

					FIFO_DATA0 <= 0;
					FIFO_DATA1 <= 0;
					FIFO_DATA2 <= 0;
					FIFO_DATA3 <= 0;
				DT_WR_SIZE <= 0;
				DT_WR_CODE <= 0;
				DT_WR_ADDR <= 0;
				DT_WR_DATA <= 0;

	DT_RD_DATA <= 0;

			ADDR <= 16'h0000;
			ADDR_SET_ACK <= 1'b0;
			REG_SET_ACK <= 1'b0;
			DT_VRAM_SEL <= 1'b0;
					DT_VRAM_ADDR <= 0;
					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= 0;
			FIFO_RD_POS <= 2'b00;
			FIFO_WR_POS <= 2'b00;
			FIFO_EMPTY <= 1'b1;
			FIFO_FULL <= 1'b0;

			DT_RD_DTACK_N <= 1'b1;
			DT_FF_DTACK_N <= 1'b1;

			FF_VBUS_DMA_REQ <= 1'b0;
			FF_VBUS_ADDR <= 24'b0;
			FF_VBUS_UDS_N <= 1'b0;
			FF_VBUS_LDS_N <= 1'b0;
			FF_VBUS_SEL <= 1'b0;
			DMA_FILL_PRE <= 1'b0;
			DMA_FILL <= 1'b0;
			DMA_COPY <= 1'b0;
			DMA_VBUS <= 1'b0;
			DMA_SOURCE <= 16'h0000;
			DMA_LENGTH <= 16'h0000;
			DTC <= DTC_IDLE;

	DT_DMAV_DATA <= 0;

			DMAF_SET_ACK <= 1'b0;

			CRAM_WE_r <= 1'b0;
			CRAM_WADDR_r[8:0] <= 9'b0;
			CRAM_WDATA_r[8:0] <= 9'b0;
			VSRAM0_WE_r <= 1'b0;
			VSRAM0_WADDR_r[8:0] <= 9'b0;
			VSRAM0_WDATA_r[17:0] <= 18'b0;
			VSRAM1_WE_r <= 1'b0;
			VSRAM1_WADDR_r[8:0] <= 9'b0;
			VSRAM1_WDATA_r[17:0] <= 18'b0;

		end
		else
		begin

//		//	if (FIFO_RD_POS==FIFO_WR_POS) begin
//		//		FIFO_EMPTY <= 1'b1;
//		//	end else begin
//		//		FIFO_EMPTY <= 1'b0;
//		//	end
//		//	if (FIFO_WR_POS + 1==FIFO_RD_POS) begin
//		//		FIFO_FULL <= 1'b1;
//		//	end else begin
//		//		FIFO_FULL <= 1'b0;
//		//	end
//		//	if (DT_RD_SEL==1'b0) begin
//		//		DT_RD_DTACK_N <= 1'b1;
//		//	end
//		//	if (DT_FF_SEL==1'b0) begin
//		//		DT_FF_DTACK_N <= 1'b1;
//		//	end
//		//	if (ADDR_SET_REQ==1'b0) begin
//		//		ADDR_SET_ACK <= 1'b0;
//		//	end
//		//	if (REG_SET_REQ==1'b0) begin
//		//		REG_SET_ACK <= 1'b0;
//		//	end
//		//	if (DMAF_SET_REQ==1'b0) begin
//		//		DMAF_SET_ACK <= 1'b0;
//		//	end

			FIFO_EMPTY <= (FIFO_RD_POS==FIFO_WR_POS) ? 1'b1 : 1'b0;
			FIFO_FULL <= (FIFO_WR_POS + 1==FIFO_RD_POS) ? 1'b1 : 1'b0;

			if (DT_FF_SEL==1'b0) begin DT_FF_DTACK_N <= 1'b1; end
			if (ADDR_SET_REQ==1'b0) begin ADDR_SET_ACK <= 1'b0; end
			if (REG_SET_REQ==1'b0) begin REG_SET_ACK <= 1'b0; end
			if (DMAF_SET_REQ==1'b0) begin DMAF_SET_ACK <= 1'b0; end


			if (DT_FF_SEL==1'b1 && (FIFO_WR_POS + 1 != FIFO_RD_POS) && DT_FF_DTACK_N==1'b1) begin

				if (FIFO_WR_POS==2'b00) begin FIFO_DATA0 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b01) begin FIFO_DATA1 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b10) begin FIFO_DATA2 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end
				if (FIFO_WR_POS==2'b11) begin FIFO_DATA3 <= {DT_FF_SIZE,DT_FF_CODE,ADDR,DT_FF_DATA}; end

//			//	FIFO_ADDR[FIFO_WR_POS] <= ADDR;
//			//	FIFO_DATA[FIFO_WR_POS] <= DT_FF_DATA;
//			//	FIFO_CODE[FIFO_WR_POS] <= DT_FF_CODE;
//				//	FIFO_SIZE( CONV_INTEGER( FIFO_WR_POS ) ) <= DT_FF_SIZE;
				FIFO_WR_POS <= FIFO_WR_POS + 1;
				ADDR <= ADDR + ADDR_STEP;
				DT_FF_DTACK_N <= 1'b0;
			end
			if (DT_ACTIVE==1'b1) begin
				case (DTC)
				DTC_IDLE: begin
					CRAM_WE_r <= 1'b0;
					VSRAM0_WE_r <= 1'b0;
					VSRAM1_WE_r <= 1'b0;
				
					if (DMA_VBUS==1'b1) begin
						DTC <= DTC_DMA_VBUS_INIT;
					end else if (DMA_FILL==1'b1) begin
						DTC <= DTC_DMA_FILL_INIT;
					end else if (DMA_COPY==1'b1) begin
						DTC <= DTC_DMA_COPY_INIT;
					end else if (FIFO_RD_POS != FIFO_WR_POS) begin
						DTC <= DTC_FIFO_RD;
					end else if (DT_RD_SEL==1'b1 && DT_RD_DTACK_N==1'b1) begin
						case (DT_RD_CODE)
						4'b1000: begin
							// CRAM Read
							DTC <= DTC_CRAM_RD;
						end
						4'b0100: begin
							// VSRAM Read
							DTC <= DTC_VSRAM_RD;
						end
						default: begin
							// VRAM Read
							DTC <= DTC_VRAM_RD1;
						end
						endcase
					end else begin
						if (ADDR_SET_REQ==1'b1 && ADDR_SET_ACK==1'b0 && IN_DMA==1'b0) begin
							ADDR <= ADDR_LATCH;
//						//	if (CODE[5]==1'b1 && DMA==1'b1 && PENDING==1'b1) begin
//						//		if (REG23[7]==1'b0) begin
//						//			DMA_VBUS <= 1'b1;
//						//		end else begin
//						//			if (REG23[6]==1'b0) begin
//						//				DMA_FILL_PRE <= 1'b1;
//						//			end else begin
//						//				DMA_COPY <= 1'b1;
//						//			end
//						//		end
//						//	end

							if (CODE[5]==1'b1 && DMA==1'b1 && PENDING==1'b1)
								begin
									DMA_VBUS <= (REG23[7]==1'b0) ? 1'b1 : DMA_VBUS;
									DMA_FILL_PRE <= (REG23[7:6]==2'b10) ? 1'b1 : DMA_FILL_PRE;
									DMA_COPY <= (REG23[7:6]==2'b11) ? 1'b1 : DMA_COPY;
								end

							ADDR_SET_ACK <= 1'b1;
						end


						if (REG_SET_REQ==1'b1 && REG_SET_ACK==1'b0 && IN_DMA==1'b0) begin
//							//	REG( CONV_INTEGER( REG_LATCH(12 downto 8)) ) <= REG_LATCH(7 downto 0);
							if (REG_LATCH[12:8]==5'b00000) begin REG0 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00001) begin REG1 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00010) begin REG2 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00011) begin REG3 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00100) begin REG4 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00101) begin REG5 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00110) begin REG6 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b00111) begin REG7 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01000) begin REG8 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01001) begin REG9 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01010) begin REG10 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01011) begin REG11 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01100) begin REG12 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01101) begin REG13 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01110) begin REG14 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b01111) begin REG15 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10000) begin REG16 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10001) begin REG17 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10010) begin REG18 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10011) begin REG19 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10100) begin REG20 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10101) begin REG21 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10110) begin REG22 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b10111) begin REG23 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11000) begin REG24 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11001) begin REG25 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11010) begin REG26 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11011) begin REG27 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11100) begin REG28 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11101) begin REG29 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11110) begin REG30 <= REG_LATCH[7:0]; end
							if (REG_LATCH[12:8]==5'b11111) begin REG31 <= REG_LATCH[7:0]; end
							REG_SET_ACK <= 1'b1;
						end


						if (DMAF_SET_REQ==1'b1 && DMAF_SET_ACK==1'b0 && IN_DMA==1'b0) begin
//						//	if (DMA_FILL_PRE==1'b1) begin
//						//		DMA_FILL <= 1'b1;
//						//	end
							DMA_FILL <= (DMA_FILL_PRE==1'b1) ? 1'b1 : DMA_FILL;
							DMAF_SET_ACK <= 1'b1;
						end
					end
				end
				DTC_FIFO_RD: begin

				if (FIFO_RD_POS==2'b00) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA0; end
				if (FIFO_RD_POS==2'b01) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA1; end
				if (FIFO_RD_POS==2'b10) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA2; end
				if (FIFO_RD_POS==2'b11) begin {DT_WR_SIZE,DT_WR_CODE,DT_WR_ADDR,DT_WR_DATA} <= FIFO_DATA3; end

//				//	DT_WR_ADDR <= FIFO_ADDR[FIFO_RD_POS];
//				//	DT_WR_DATA <= FIFO_DATA[FIFO_RD_POS];
//				//	DT_WR_SIZE <= FIFO_SIZE( CONV_INTEGER( FIFO_RD_POS ) );				

					FIFO_RD_POS <= FIFO_RD_POS + 1;
//				//	case (FIFO_CODE[FIFO_RD_POS])
					case (DT_CODE)
					3'b011: begin
						// CRAM Write
						DTC <= DTC_CRAM_WR;
					end
					3'b101: begin
						// VSRAM Write
						DTC <= DTC_VSRAM_WR;
					end
					default: begin
						// VRAM Write
						DTC <= DTC_VRAM_WR1;
					end
					endcase
				end
				DTC_VRAM_WR1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {DT_WR_ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
//					// if DT_WR_SIZE='1' then
//				//	if (DT_WR_ADDR[0]==1'b0) begin
//				//		DT_VRAM_DI <= DT_WR_DATA;
//				//	end else begin
//				//		DT_VRAM_DI <= {DT_WR_DATA[7:0], DT_WR_DATA[15:8]};
//				//	end

					DT_VRAM_DI[15:8] <= (DT_WR_ADDR[0]==1'b0) ? DT_WR_DATA[15:8] : DT_WR_DATA[7:0];
					DT_VRAM_DI[7:0]  <= (DT_WR_ADDR[0]==1'b0) ? DT_WR_DATA[7:0]  : DT_WR_DATA[15:8];

					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
//					// else
//					// DT_VRAM_DI <= DT_WR_DATA;
//					// if DT_WR_ADDR(0)='0' then
//					// DT_VRAM_UDS_N <= '1';
//					// DT_VRAM_LDS_N <= '0';
//					// else
//					// DT_VRAM_UDS_N <= '0';
//					// DT_VRAM_LDS_N <= '1';
//					// end if;
//					// end if;
					DTC <= DTC_VRAM_WR2;
				end
				DTC_VRAM_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end
				end


				DTC_CRAM_WR: begin
				//	CRAM[DT_WR_ADDR[6:1]] <= DT_WR_DATA;

					CRAM_WE_r <= 1'b1;
					CRAM_WADDR_r[8:0] <= {3'b0,DT_WR_ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_WR_DATA[11:9],DT_WR_DATA[7:5],DT_WR_DATA[3:1]};

					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end
				DTC_VSRAM_WR: begin
				//	VSRAM[DT_WR_ADDR[6:1]] <= DT_WR_DATA[9:0];
				//	if (DT_WR_ADDR[6:1]==6'b000000) begin
				//		VSRAM0 <= DT_WR_DATA;
				//	end
				//	if (DT_WR_ADDR[6:1]==6'b000001) begin
				//		VSRAM1 <= DT_WR_DATA;
				//	end

			VSRAM0_WE_r <= (DT_WR_ADDR[1]==1'b0) ? 1'b1 : 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,DT_WR_ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};
			VSRAM1_WE_r <= (DT_WR_ADDR[1]==1'b1) ? 1'b1 : 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,DT_WR_ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};

					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end
				DTC_VRAM_RD1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b1;
					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DTC <= DTC_VRAM_RD2;
				end
				DTC_VRAM_RD2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DT_RD_DATA <= DT_VRAM_DO;
						DT_RD_DTACK_N <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end
				end
				DTC_CRAM_RD: begin
					CRAM_WE_r <= 1'b0;
					CRAM_WADDR_r[8:0] <= {3'b0,ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_WR_DATA[11:9],DT_WR_DATA[7:5],DT_WR_DATA[3:1]};

					DTC <= DTC_CRAM_RD1;
				end
				DTC_CRAM_RD1: begin
				//	DT_RD_DATA <= CRAM[ADDR[6:1]];

					DT_RD_DATA <= {4'b0,CRAM_QDATA[8:6],1'b0,CRAM_QDATA[5:3],1'b0,CRAM_QDATA[2:0],1'b0};

					DT_RD_DTACK_N <= 1'b0;
					ADDR <= ADDR + ADDR_STEP;
					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
				end
				DTC_VSRAM_RD: begin

			VSRAM0_WE_r <= 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};
			VSRAM1_WE_r <= 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_WR_DATA[10:0]};

					DTC <= DTC_VSRAM_RD1;

				end
				DTC_VSRAM_RD1: begin
				//	DT_RD_DATA <= {6'b0,VSRAM[ADDR[6:1]]};
					DT_RD_DATA <= (ADDR[1]==1'b0) ? VSRAM0_QDATA[15:0] : VSRAM1_QDATA[15:0];
					DT_RD_DTACK_N <= 1'b0;
					ADDR <= ADDR + ADDR_STEP;
					DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--

				end
				//--------------------------------------------------------------
				// DMA FILL
				//--------------------------------------------------------------
				DTC_DMA_FILL_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DTC <= DTC_DMA_FILL_WR;
				end
				DTC_DMA_FILL_WR: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= {DT_DMAF_DATA[7:0], DT_DMAF_DATA[7:0]};
//				//	if (ADDR[0]==1'b0) begin
//				//		DT_VRAM_UDS_N <= 1'b1;
//				//		DT_VRAM_LDS_N <= 1'b0;
//				//	end else begin
//				//		DT_VRAM_UDS_N <= 1'b0;
//				//		DT_VRAM_LDS_N <= 1'b1;
//				//	end
					DT_VRAM_UDS_N <= (ADDR[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (ADDR[0]==1'b0) ? 1'b0 : 1'b1;
					DTC <= DTC_DMA_FILL_WR2;
				end
				DTC_DMA_FILL_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DTC <= DTC_DMA_FILL_LOOP;
					end
				end
				DTC_DMA_FILL_LOOP: begin
					if (DMA_LENGTH==0) begin
						DMA_FILL_PRE <= 1'b0;
						DMA_FILL <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end else begin
						DTC <= DTC_DMA_FILL_WR;
					end
				end


				//--------------------------------------------------------------
				// DMA COPY
				//--------------------------------------------------------------

				DTC_DMA_COPY_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DMA_SOURCE <= {REG22, REG21};
					DTC <= DTC_DMA_COPY_RD;
				end
				DTC_DMA_COPY_RD: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {DMA_SOURCE[15:1],1'b0};
					DT_VRAM_RNW <= 1'b1;
//				//	if (DMA_SOURCE[0]==1'b0) begin
//				//		DT_VRAM_UDS_N <= 1'b1;
//				//		DT_VRAM_LDS_N <= 1'b0;
//				//	end else begin
//				//		DT_VRAM_UDS_N <= 1'b0;
//				//		DT_VRAM_LDS_N <= 1'b1;
//				//	end

					DT_VRAM_UDS_N <= (DMA_SOURCE[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (DMA_SOURCE[0]==1'b0) ? 1'b0 : 1'b1;

					DTC <= DTC_DMA_COPY_RD2;
				end
				DTC_DMA_COPY_RD2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						DTC <= DTC_DMA_COPY_WR;
					end
				end


				DTC_DMA_COPY_WR: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
					DT_VRAM_DI <= DT_VRAM_DO;
//				//	if (ADDR[0]==1'b0) begin
//				//		DT_VRAM_UDS_N <= 1'b1;
//				//		DT_VRAM_LDS_N <= 1'b0;
//				//	end else begin
//				//		DT_VRAM_UDS_N <= 1'b0;
//				//		DT_VRAM_LDS_N <= 1'b1;
//				//	end

					DT_VRAM_UDS_N <= (ADDR[0]==1'b0) ? 1'b1 : 1'b0;
					DT_VRAM_LDS_N <= (ADDR[0]==1'b0) ? 1'b0 : 1'b1;

					DTC <= DTC_DMA_COPY_WR2;

				end
				DTC_DMA_COPY_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DMA_SOURCE <= DMA_SOURCE + 1;
						DTC <= DTC_DMA_COPY_LOOP;
					end
				end
				DTC_DMA_COPY_LOOP: begin
					if (DMA_LENGTH==0) begin
						DMA_COPY <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						REG22 <= DMA_SOURCE[15:8];
						REG21 <= DMA_SOURCE[7:0];
						DTC <= DTC_IDLE;
						DMA_VBUS <= 1'b0;	// <--
					end else begin
						DTC <= DTC_DMA_COPY_RD;
					end
				end


				//--------------------------------------------------------------
				// DMA VBUS
				//--------------------------------------------------------------
				DTC_DMA_VBUS_INIT: begin
					DMA_LENGTH <= {REG20, REG19};
					DMA_SOURCE <= {REG22, REG21};
					DTC <= DTC_DMA_VBUS_RD;
				end
				DTC_DMA_VBUS_RD: begin
					FF_VBUS_SEL <= 1'b1;
					FF_VBUS_ADDR <= {{REG23[6:0], DMA_SOURCE}, 1'b0};
				//	FF_VBUS_UDS_N <= 1'b0;
				//	FF_VBUS_LDS_N <= 1'b0;
					DTC <= DTC_DMA_VBUS_RD2;

				end
				DTC_DMA_VBUS_RD2: begin
					if (VBUS_DTACK_N==1'b0) begin
						FF_VBUS_SEL <= 1'b0;
						DT_DMAV_DATA <= VBUS_DATA;
						DTC <= DTC_DMA_VBUS_SEL;
					end
				end
				DTC_DMA_VBUS_SEL: begin
					case (CODE[2:0])
					3'b011: begin
						// CRAM Write
						DTC <= DTC_DMA_VBUS_CRAM_WR;
					end
					3'b101: begin
						// VSRAM Write
						DTC <= DTC_DMA_VBUS_VSRAM_WR;
					end
					default: begin
						// VRAM Write
						DTC <= DTC_DMA_VBUS_VRAM_WR1;
					end
					endcase
				end
				DTC_DMA_VBUS_CRAM_WR: begin
				//	CRAM[ADDR[6:1]] <= DT_DMAV_DATA;

					CRAM_WE_r <= 1'b1;
					CRAM_WADDR_r[8:0] <= {3'b0,ADDR[6:1]};
					CRAM_WDATA_r[8:0] <= {DT_DMAV_DATA[11:9],DT_DMAV_DATA[7:5],DT_DMAV_DATA[3:1]};

					ADDR <= ADDR + ADDR_STEP;
					DMA_LENGTH <= DMA_LENGTH - 1;
					DMA_SOURCE <= DMA_SOURCE + 1;
					DTC <= DTC_DMA_VBUS_LOOP;

				end
				DTC_DMA_VBUS_VSRAM_WR: begin
				//	VSRAM[ADDR[6:1]] <= DT_DMAV_DATA[9:0];
				//	if (ADDR[6:1]==6'b000000) begin
				//		VSRAM0 <= DT_DMAV_DATA;
				//	end
				//	if (ADDR[6:1]==6'b000001) begin
				//		VSRAM1 <= DT_DMAV_DATA;
				//	end

			VSRAM0_WE_r <= (ADDR[1]==1'b0) ? 1'b1 : 1'b0;
			VSRAM0_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM0_WDATA_r[17:0] <= {7'b0,DT_DMAV_DATA[10:0]};
			VSRAM1_WE_r <= (ADDR[1]==1'b1) ? 1'b1 : 1'b0;
			VSRAM1_WADDR_r[8:0] <= {4'b0,ADDR[6:2]};
			VSRAM1_WDATA_r[17:0] <= {7'b0,DT_DMAV_DATA[10:0]};

					ADDR <= ADDR + ADDR_STEP;
					DMA_LENGTH <= DMA_LENGTH - 1;
					DMA_SOURCE <= DMA_SOURCE + 1;
					DTC <= DTC_DMA_VBUS_LOOP;
				end
				DTC_DMA_VBUS_VRAM_WR1: begin
					DT_VRAM_SEL <= 1'b1;
					DT_VRAM_ADDR <= {ADDR[15:1],1'b0};
					DT_VRAM_RNW <= 1'b0;
//				//	if (ADDR[0]==1'b0) begin
//				//		DT_VRAM_DI <= DT_DMAV_DATA;
//				//	end else begin
//				//		DT_VRAM_DI <= {DT_DMAV_DATA[7:0], DT_DMAV_DATA[15:8]};
//				//	end

					DT_VRAM_DI[15:8] <= (ADDR[0]==1'b0) ? DT_DMAV_DATA[15:8] : DT_DMAV_DATA[7:0];
					DT_VRAM_DI[7:0]  <= (ADDR[0]==1'b0) ? DT_DMAV_DATA[7:0]  : DT_DMAV_DATA[15:8];

					DT_VRAM_UDS_N <= 1'b0;
					DT_VRAM_LDS_N <= 1'b0;
					DTC <= DTC_DMA_VBUS_VRAM_WR2;
				end
				DTC_DMA_VBUS_VRAM_WR2: begin
					if (DT_VRAM_DTACK_N==1'b0) begin
						DT_VRAM_SEL <= 1'b0;
						ADDR <= ADDR + ADDR_STEP;
						DMA_LENGTH <= DMA_LENGTH - 1;
						DMA_SOURCE <= DMA_SOURCE + 1;
						DTC <= DTC_DMA_VBUS_LOOP;
					end
				end
				DTC_DMA_VBUS_LOOP: begin
					CRAM_WE_r <= 1'b0;
					VSRAM0_WE_r <= 1'b0;
					VSRAM1_WE_r <= 1'b0;
				
					if (DMA_LENGTH==0) begin
						DMA_VBUS <= 1'b0;
						REG20 <= 8'h00;
						REG19 <= 8'h00;
						REG22 <= DMA_SOURCE[15:8];
						REG21 <= DMA_SOURCE[7:0];
						DTC <= DTC_IDLE;
					//	DMA_VBUS <= 1'b0;		// <--
					end else begin
						DTC <= DTC_DMA_VBUS_RD;
					end
				end
				default: begin
				end
				endcase
			end else begin	// DT_ACTIVE='0'
	// Do nothing
			end
		end
	end

`endif

	//--------------------------------------------------------------
	// INTERRUPTS AND VARIOUS LATCHES
	//--------------------------------------------------------------

	// HINT PENDING
	// HINT

	assign HINT=HINT_FF;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				HINT_PENDING <= 1'b0;
				HINT_FF <= 1'b0;
			end
		else
			begin
				HINT_PENDING <=
					(HINT_PENDING_SET==1'b1) ? 1'b1 :
					(HINT_PENDING_SET==1'b0) & (HINT_ACK==1'b1) ? 1'b0 :
					HINT_PENDING;
				HINT_FF <= (HINT_PENDING==1'b1 && IE1==1'b1) ? 1'b1 : 1'b0;
			end
	end


	// VINT - TG68 - PENDING
	// VINT - TG68

	assign VINT_TG68=VINT_TG68_FF;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				VINT_TG68_PENDING <= 1'b0;
				VINT_TG68_FF <= 1'b0;
			end
		else
			begin
				VINT_TG68_PENDING <=
					(VINT_TG68_PENDING_SET==1'b1) ? 1'b1 :
					(VINT_TG68_PENDING_SET==1'b0) & (VINT_TG68_ACK==1'b1) ? 1'b0 :
					VINT_TG68_PENDING;
				VINT_TG68_FF <= (VINT_TG68_PENDING==1'b1 && IE0==1'b1) ? 1'b1 : 1'b0;
			end
	end


	// VINT - T80

	assign VINT_T80=VINT_T80_FF;

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				VINT_T80_FF <= 1'b0;
			end
		else
			begin
				VINT_T80_FF <=
					(VINT_T80_SET==1'b1) ? 1'b1 :
					(VINT_T80_SET==1'b0) & (VINT_T80_CLR==1'b1 || VINT_T80_ACK==1'b1) ? 1'b0 :
					VINT_T80_FF;
			end
	end


	// Sprite Collision
	// Sprite Overflow

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				SCOL <= 1'b0;
				SOVR <= 1'b0;
			end
		else
			begin
				SCOL <=
					(SCOL_SET==1'b1) ? 1'b1 :
					(SCOL_SET==1'b0) & (SCOL_CLR==1'b1) ? 1'b0 :
					SCOL;
				SOVR <=
					(SOVR_SET==1'b1) ? 1'b1 :
					(SOVR_SET==1'b0) & (SOVR_CLR==1'b1) ? 1'b0 :
					SOVR;
			end
	end

	// ---- debug status ----

	reg		[15:0] DEBUG_OUT_r;
	wire	[15:0] DEBUG_OUT_w;

	assign DEBUG_OUT[15:0]=DEBUG_OUT_r[15:0];

	always @(negedge RST_N or posedge CLK)
	begin
		if (RST_N==1'b0)
			begin
				DEBUG_OUT_r[15:0] <= 16'b0;
			end
		else
			begin
				DEBUG_OUT_r[15:0] <= DEBUG_OUT_w[15:0];
			end
	end

	assign DEBUG_OUT_w[0]=spr_render;
	assign DEBUG_OUT_w[1]=spr_search;
	assign DEBUG_OUT_w[2]=bgb_render;
	assign DEBUG_OUT_w[3]=bga_render;
	assign DEBUG_OUT_w[4]=VRAM32_REQ;
	assign DEBUG_OUT_w[5]=VBUS_DMA_REQ;//VBUS_SEL;
	assign DEBUG_OUT_w[6]=HINT;
	assign DEBUG_OUT_w[7]=VINT_TG68;
	assign DEBUG_OUT_w[15:8]=0;


endmodule
