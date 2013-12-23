//-----------------------------------------------------------------------------
//
//  gen_top8.v : 25drv top module
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
//  TG68 : TG68 (opencores) license LGPL
//  T80 : T80 (opencores) license as-is
//  sn76489 : fpga_colecovison (fpga arcade) license GPL2
//
//------------------------------------------------------------------------------

`define m68_buffered
`define z80_buffered
//`define z80_interrupt

`define debug_tg68_iinterrput

`define sync_z80_busreq
`define sync_io_fm
//`define sync_io_psg

//`define m68_fast	// fast simulation : 54/7(7.7MHz) -> 54/6(9MHz)

// Converted from gen_top.vhd
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



module gen_top8 #(
	parameter	DEVICE=0,		// 0=xilinx , 1=altera
	parameter	SIM_WO_VDP=0,
	parameter	SIM_WO_OS=0,
	parameter	opn2=0,		// 0=rtl / 1=connect YM2612
	parameter	vdp_sca=1,
	parameter	vdp_scb=1,
	parameter	vdp_spr=1,
	parameter	pad_1p=1,
	parameter	pad_2p=0
) (
	output	[15:0]	DEBUG_OUT,
	output	[15:0]	DEBUG_VDP,
	output	[15:0]	DEBUG_FM,
	output	[15:0]	DEBUG_Z,

	input			debug_sca,
	input			debug_scw,
	input			debug_scb,
	input			debug_spr,
	input			debug_dma,

	input			RESET,

	output	[7:0]	PSG_OUT,
	output	[15:0]	FM_OUT_L,
	output	[15:0]	FM_OUT_R,

	output	[1:0]	YM_ADDR,
	output	[7:0]	YM_WDATA,
	input	[7:0]	YM_RDATA,
	output			YM_DOE,
	output			YM_WR_N,
	output			YM_RD_N,
	output			YM_CS_N,
	output			YM_RESET_N,
	output			YM_CLK,

	input	[7:0]	VERSION,

	input	[7:0]	KEY1,
	input	[7:0]	KEY2,

	input			CLOCK_54,

	output	[31:0]	VRAM32_ADDR,
	output	[3:0]	VRAM32_BE,
	input	[31:0]	VRAM32_RDATA,
	output	[31:0]	VRAM32_WDATA,
	output			VRAM32_WR,
	output			VRAM32_REQ,
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

	output	[31:0]	CART_ADDR,
	output	[31:0]	CART_WDATA,
	output	[3:0]	CART_BE,
	input	[31:0]	CART_RDATA,
	output			CART_WE,
	output			CART_REQ,
	input			CART_ACK,

	output	[31:0]	WORK_ADDR,
	output	[31:0]	WORK_WDATA,
	input	[31:0]	WORK_RDATA,
	output	[3:0]	WORK_BE,
	output			WORK_WR,
	output			WORK_REQ,
	input			WORK_ACK,

	output	[7:0]	VGA_R,
	output	[7:0]	VGA_G,
	output	[7:0]	VGA_B,
	output			VGA_VS,
	output			VGA_HS,
	output			VGA_DE,
	output			VGA_CLK
);

	wire	vdma_busreq;
	wire	vdma_busack_n;
	wire	[23:0] vdma_addr;
	wire	[1:0] vdma_be;
	wire	[15:0] vdma_rdata;
	wire	vdma_req;
	wire	vdma_ack;

//	wire	m68_cart_sel;
	wire	m68_cart_req;
	wire	m68_cart_wr;
	wire	[31:0] m68_cart_addr;
	wire	[31:0] m68_cart_wdata;
	wire	[3:0] m68_cart_be;
	wire	[31:0] m68_cart_rdata;
	wire	m68_cart_ack;

//	wire	z80_cart_sel;
	wire	z80_cart_req;
	wire	z80_cart_wr;
	wire	[31:0] z80_cart_addr;
	wire	[31:0] z80_cart_wdata;
	wire	[3:0] z80_cart_be;
	wire	[31:0] z80_cart_rdata;
	wire	z80_cart_ack;

//	wire	dma_cart_sel;
	wire	dma_cart_req;
	wire	dma_cart_wr;
	wire	[31:0] dma_cart_addr;
	wire	[31:0] dma_cart_wdata;
	wire	[3:0] dma_cart_be;
	wire	[31:0] dma_cart_rdata;
	wire	dma_cart_ack;
	wire	dma_cart_busreq;
	wire	dma_cart_busack;

//	wire	m68_zmem_sel;
	wire	m68_zmem_req;
	wire	m68_zmem_wr;
	wire	[31:0] m68_zmem_addr;
	wire	[31:0] m68_zmem_wdata;
	wire	[3:0] m68_zmem_be;
	wire	[31:0] m68_zmem_rdata;
	wire	m68_zmem_ack;

//	wire	z80_zmem_sel;
	wire	z80_zmem_req;
	wire	z80_zmem_wr;
	wire	[31:0] z80_zmem_addr;
	wire	[31:0] z80_zmem_wdata;
	wire	[3:0] z80_zmem_be;
	wire	[31:0] z80_zmem_rdata;
	wire	z80_zmem_ack;

//	wire	m68_work_sel;
	wire	m68_work_req;
	wire	m68_work_wr;
	wire	[31:0] m68_work_addr;
	wire	[31:0] m68_work_wdata;
	wire	[3:0] m68_work_be;
	wire	[31:0] m68_work_rdata;
	wire	m68_work_ack;

//	wire	z80_work_sel;
	wire	z80_work_req;
	wire	z80_work_wr;
	wire	[31:0] z80_work_addr;
	wire	[31:0] z80_work_wdata;
	wire	[3:0] z80_work_be;
	wire	[31:0] z80_work_rdata;
	wire	z80_work_ack;

//	wire	dma_work_sel;
	wire	dma_work_req;
	wire	dma_work_wr;
	wire	[31:0] dma_work_addr;
	wire	[31:0] dma_work_wdata;
	wire	[3:0] dma_work_be;
	wire	[31:0] dma_work_rdata;
	wire	dma_work_ack;
	wire	dma_work_busreq;
	wire	dma_wokrk_busack;

//	wire	m68_ctrl_sel;
	wire	m68_ctrl_req;
	wire	m68_ctrl_wr;
	wire	[31:0] m68_ctrl_addr;
	wire	[31:0] m68_ctrl_wdata;
	wire	[3:0] m68_ctrl_be;
	wire	[31:0] m68_ctrl_rdata;
	wire	m68_ctrl_ack;

//	wire	z80_ctrl_sel;
	wire	z80_ctrl_req;
	wire	z80_ctrl_wr;
	wire	[31:0] z80_ctrl_addr;
	wire	[31:0] z80_ctrl_wdata;
	wire	[3:0] z80_ctrl_be;
	wire	[31:0] z80_ctrl_rdata;
	wire	z80_ctrl_ack;

//	wire	m68_os_sel;
	wire	m68_os_req;
	wire	m68_os_wr;
	wire	[31:0] m68_os_addr;
	wire	[31:0] m68_os_wdata;
	wire	[3:0] m68_os_be;
	wire	[31:0] m68_os_rdata;
	wire	m68_os_ack;

//	wire	m68_pad_sel;
	wire	m68_pad_req;
	wire	m68_pad_wr;
	wire	[31:0] m68_pad_addr;
	wire	[31:0] m68_pad_wdata;
	wire	[3:0] m68_pad_be;
	wire	[31:0] m68_pad_rdata;
	wire	m68_pad_ack;

//	wire	z80_pad_sel;
	wire	z80_pad_req;
	wire	z80_pad_wr;
	wire	[31:0] z80_pad_addr;
	wire	[31:0] z80_pad_wdata;
	wire	[3:0] z80_pad_be;
	wire	[31:0] z80_pad_rdata;
	wire	z80_pad_ack;

//	wire	m68_bar_sel;
	wire	m68_bar_req;
	wire	m68_bar_wr;
	wire	[31:0] m68_bar_addr;
	wire	[31:0] m68_bar_wdata;
	wire	[3:0] m68_bar_be;
	wire	[31:0] m68_bar_rdata;
	wire	m68_bar_ack;

//	wire	z80_bar_sel;
	wire	z80_bar_req;
	wire	z80_bar_wr;
	wire	[31:0] z80_bar_addr;
	wire	[31:0] z80_bar_wdata;
	wire	[3:0] z80_bar_be;
	wire	[31:0] z80_bar_rdata;
	wire	z80_bar_ack;

//	wire	m68_vdp_sel;
	wire	m68_vdp_req;
	wire	m68_vdp_wr;
	wire	[31:0] m68_vdp_addr;
	wire	[31:0] m68_vdp_wdata;
	wire	[3:0] m68_vdp_be;
	wire	[31:0] m68_vdp_rdata;
	wire	m68_vdp_ack;

//	wire	z80_vdp_sel;
	wire	z80_vdp_req;
	wire	z80_vdp_wr;
	wire	[31:0] z80_vdp_addr;
	wire	[31:0] z80_vdp_wdata;
	wire	[3:0] z80_vdp_be;
	wire	[31:0] z80_vdp_rdata;
	wire	z80_vdp_ack;

//	wire	m68_psg_sel;
	wire	m68_psg_req;
	wire	m68_psg_wr;
	wire	[31:0] m68_psg_addr;
	wire	[31:0] m68_psg_wdata;
	wire	[3:0] m68_psg_be;
	wire	[31:0] m68_psg_rdata;
	wire	m68_psg_ack;

//	wire	z80_psg_sel;
	wire	z80_psg_req;
	wire	z80_psg_wr;
	wire	[31:0] z80_psg_addr;
	wire	[31:0] z80_psg_wdata;
	wire	[3:0] z80_psg_be;
	wire	[31:0] z80_psg_rdata;
	wire	z80_psg_ack;

//	wire	m68_fm_sel;
	wire	m68_fm_req;
	wire	m68_fm_wr;
	wire	[31:0] m68_fm_addr;
	wire	[31:0] m68_fm_wdata;
	wire	[3:0] m68_fm_be;
	wire	[31:0] m68_fm_rdata;
	wire	m68_fm_ack;

//	wire	z80_fm_sel;
	wire	z80_fm_req;
	wire	z80_fm_wr;
	wire	[31:0] z80_fm_addr;
	wire	[31:0] z80_fm_wdata;
	wire	[3:0] z80_fm_be;
	wire	[31:0] z80_fm_rdata;
	wire	z80_fm_ack;

	wire			MCLK;

//	wire			TG68_CLK;
	wire			TG68_RES_N;
//	wire			TG68_CLKE;
	wire	[15:0]	TG68_DI;
	reg 	[2:0]	TG68_IPL_N;
	wire			TG68_DTACK_N;
	wire	[31:0]	TG68_A;
	wire	[15:0]	TG68_DO;
	wire			TG68_AS_N;
	wire			TG68_UDS_N;
	wire			TG68_LDS_N;
	wire			TG68_RNW;
	wire	[2:0]	TG68_IACK;
	wire			TG68_INTACK;

	wire 			TG68_ENARDREG;
	wire 			TG68_ENAWRREG;
	wire 			TGCLK_RISE;
	wire 			TGCLK_FALL;

	wire 			T80_RESET_N;
	wire			T80_CLK_N;
	wire 			T80_CLKEN;
	wire			T80_WAIT_N;
	wire 			T80_INT_N;
	wire			T80_NMI_N;
	wire			T80_BUSRQ_N;
	wire			T80_M1_N;
	wire			T80_MREQ_N;
	wire			T80_IORQ_N;
	wire			T80_RD_N;
	wire			T80_WR_N;
	wire			T80_RFSH_N;
	wire			T80_HALT_N;
	wire			T80_BUSAK_N;
	wire	[15:0]	T80_A;
	wire	[7:0]	T80_DI;
	wire	[7:0]	T80_DO;

//	reg 			MRST_N;
//	reg 	[8:0]	RSTCNT;
//	reg 			VCLK;
//	reg 			VCLK_RISE;
//	reg 			VCLK_FALL;
//	reg 	[2:0]	VCLKCNT;
//	reg 			ZCLK;
//	reg 			ZCLK_RISE;
//	reg 	[3:0]	ZCLKCNT;

	wire 			MRST_N;
	wire 			VCLK;
	wire 			FCLK;
	wire 			FCLK_RISE;
	wire 			ZCLK;
	wire 			ZCLK_RISE;

	wire 			ZBUSREQ;
	wire 			ZRESET_N;
	wire 			ZBUSACK_N;
	wire 			CART_EN;

	wire 			T80_FLASH_SEL;
	wire 			T80_SRAM_SEL;
	wire 			T80_ZRAM_SEL;
	wire 			T80_CTRL_SEL;
	wire 			T80_IO_SEL;
	wire 			T80_VDP_SEL;
	wire 			T80_PSG_SEL;
	wire 			T80_FM_SEL;
	wire 			T80_BAR_SEL;

	wire 	[23:15]	BAR;

	wire			HINT;
	reg 			HINT_ACK;
	wire			VINT_TG68;
	wire			VINT_T80;
	reg 			VINT_TG68_ACK;
	wire 			VINT_T80_ACK;

	wire			VBUS_DMA_REQ;
	wire			VBUS_DMA_ACK;
	wire	[23:0]	VBUS_ADDR;
	wire			VBUS_UDS_N;
	wire			VBUS_LDS_N;
	wire	[15:0]	VBUS_DATA;
	wire			VBUS_SEL;
	wire			VBUS_DTACK_N;

	// ---- reset , clock ----

	assign MCLK=CLOCK_54;

	reg		mrst_out_r;
	reg		[8:0] mrst_count_r;
	wire	mrst_out_w;
	wire	[8:0] mrst_count_w;

	assign MRST_N=mrst_out_r;

	always @(posedge RESET or posedge MCLK)
	begin
		if (RESET==1'b1)
			begin
				mrst_out_r <= 1'b0;
				mrst_count_r[8:0] <= 9'b0;
			end
		else
			begin
				mrst_out_r <= mrst_out_w;
				mrst_count_r[8:0] <= mrst_count_w[8:0];
			end
	end

	assign mrst_out_w=mrst_count_r[8];
	assign mrst_count_w[8]=(mrst_count_r[7:0]==8'hff) ? 1'b1 : mrst_count_r[8];
	assign mrst_count_w[7:0]=(mrst_count_r[8]==1'b1) ? 8'b0 : mrst_count_r[7:0]+8'b01;

	reg		[2:0] VCLK_count_r;
	reg		VCLK_out_r;
	reg		[2:0] FCLK_count_r;
	reg		FCLK_out_r;
	reg		FCLK_RISE_r;
	reg		[3:0] ZCLK_count_r;
	reg		ZCLK_out_r;
	reg		ZCLK_RISE_r;

	reg		TGCLK_RISE_r;
	reg		TGCLK_FALL_r;
	reg		TG68_ENARDREG_r;
	reg		TG68_ENAWRREG_r;

	wire	[2:0] VCLK_count_w;
	wire	VCLK_out_w;
	wire	[2:0] FCLK_count_w;
	wire	FCLK_out_w;
	wire	FCLK_RISE_w;
	wire	[3:0] ZCLK_count_w;
	wire	ZCLK_out_w;
	wire	ZCLK_RISE_w;

	wire	TGCLK_RISE_w;
	wire	TGCLK_FALL_w;
	wire	TG68_ENARDREG_w;
	wire	TG68_ENAWRREG_w;

	assign VCLK=VCLK_out_r;
	assign FCLK=FCLK_out_r;
	assign FCLK_RISE=FCLK_RISE_r;
	assign ZCLK=ZCLK_out_r;
	assign ZCLK_RISE=ZCLK_RISE_r;

	assign TGCLK_RISE=TGCLK_RISE_r;
	assign TGCLK_FALL=TGCLK_FALL_r;
	assign TG68_ENARDREG=TG68_ENARDREG_r;
	assign TG68_ENAWRREG=TG68_ENAWRREG_r;

	always @(posedge RESET or posedge MCLK)
	begin
		if (RESET==1'b1)
			begin
				VCLK_count_r[2:0] <= 3'b0;
				VCLK_out_r <= 1'b0;
				FCLK_count_r[2:0] <= 3'b0;
				FCLK_out_r <= 1'b0;
				FCLK_RISE_r <= 1'b0;
				ZCLK_count_r[3:0] <= 4'b0;
				ZCLK_out_r <= 1'b0;
				ZCLK_RISE_r <= 1'b0;
				TGCLK_RISE_r <= 1'b0;
				TGCLK_FALL_r <= 1'b0;
				TG68_ENARDREG_r <= 1'b0;
				TG68_ENAWRREG_r <= 1'b0;
			end
		else
			begin
				VCLK_count_r[2:0] <= VCLK_count_w[2:0];
				VCLK_out_r <= VCLK_out_w;
				FCLK_count_r[2:0] <= FCLK_count_w[2:0];
				FCLK_out_r <= FCLK_out_w;
				FCLK_RISE_r <= FCLK_RISE_w;
				ZCLK_count_r[3:0] <= ZCLK_count_w[3:0];
				ZCLK_out_r <= ZCLK_out_w;
				ZCLK_RISE_r <= ZCLK_RISE_w;
				TGCLK_RISE_r <= TGCLK_RISE_w;
				TGCLK_FALL_r <= TGCLK_FALL_w;
				TG68_ENARDREG_r <= TG68_ENARDREG_w;
				TG68_ENAWRREG_r <= TG68_ENAWRREG_w;
			end
	end

	assign FCLK_count_w[2:0]=(FCLK_count_r[2:1]==2'b11) ? 3'b000 : FCLK_count_r[2:0]+3'b01;
	assign FCLK_out_w=!FCLK_count_r[2];
	assign FCLK_RISE_w=(FCLK_count_r[2:0]==3'b0) ? 1'b1 : 1'b0;
	assign ZCLK_count_w[3:0]=(ZCLK_count_r[3:1]==3'b111) ? 4'b0 : ZCLK_count_r[3:0]+4'b01;
	assign ZCLK_out_w=!ZCLK_count_r[3];
	assign ZCLK_RISE_w=(ZCLK_count_r[3:0]==4'b0) ? 1'b1 : 1'b0;

`ifdef m68_fast

	assign VCLK_count_w[2]=(VCLK_count_r[1]==1'b1) ? !VCLK_count_r[2] : VCLK_count_r[2];
	assign VCLK_count_w[1:0]=(VCLK_count_r[1]==1'b1) ? 2'b00 : VCLK_count_r[1:0]+2'b01;
	assign VCLK_out_w=!VCLK_count_r[2];
	assign TGCLK_RISE_w=(VCLK_count_r[2:0]==3'b101) ? 1'b1 : 1'b0;
	assign TGCLK_FALL_w=(VCLK_count_r[2:0]==3'b001) ? 1'b1 : 1'b0;

`else

	assign VCLK_count_w[2:0]=(VCLK_count_r[2:1]==2'b11) ? 3'b000 : VCLK_count_r[2:0]+3'b01;
	assign VCLK_out_w=!VCLK_count_r[2];
	assign TGCLK_RISE_w=(VCLK_count_r[2:0]==3'b101) ? 1'b1 : 1'b0;
	assign TGCLK_FALL_w=(VCLK_count_r[2:0]==3'b010) ? 1'b1 : 1'b0;

`endif

	assign TG68_ENARDREG_w=TGCLK_RISE_r;
	assign TG68_ENAWRREG_w=TGCLK_FALL_r;

//	assign VCLK_count_w[2:0]=(VCLK_count_r[2:1]==2'b11) ? 3'b000 : VCLK_count_r[2:0]+3'b01;
//	assign VCLK_out_w=!VCLK_count_r[2];
//	assign ZCLK_count_w[3:0]=(ZCLK_count_r[3:1]==3'b111) ? 4'b0 : ZCLK_count_r[3:0]+4'b01;
//	assign ZCLK_out_w=!ZCLK_count_r[3];
//	assign ZCLK_RISE_w=(ZCLK_count_r[3:0]==4'b0) ? 1'b1 : 1'b0;
//	assign TGCLK_RISE_w=(VCLK_count_r[2:0]==3'b101) ? 1'b1 : 1'b0;
//	assign TGCLK_FALL_w=(VCLK_count_r[2:0]==3'b010) ? 1'b1 : 1'b0;
//	assign TG68_ENARDREG_w=TGCLK_RISE_r;
//	assign TG68_ENAWRREG_w=TGCLK_FALL_r;

//	always @(posedge RESET or posedge MCLK)
//	begin
//		if (RESET==1'b1)
//			begin
//				MRST_N <= 1'b0;
//				RSTCNT[8:0] <= 9'b0;
//			end
//		else
//			begin
//				MRST_N <= RSTCNT[8];
//				RSTCNT[8] <= (RSTCNT[7:0]==8'hff) ? 1'b1 : RSTCNT[8];
//				RSTCNT[7:0] <= (RSTCNT[8]==1'b0) ? RSTCNT[7:0]+8'b01 : 8'b0;
//			end
//	end
//	always @(posedge RESET or posedge MCLK)
//	begin
//		if (RESET==1'b1)
//			begin
//				VCLK	<= 1'b1;
//				ZCLK	<= 1'b0;
//				ZCLK_RISE	<= 1'b0;
//				VCLKCNT	<= 3'b001;	// important for SRAM controller (EDIT: not needed anymore)
//				VCLK_RISE <= 1'b0;
//				VCLK_FALL <= 1'b0;
//				TG68_ENARDREG	<= 1'b0;
//				TG68_ENAWRREG	<= 1'b0;
//			end
//		else
//			begin
//			//	VCLKCNT	<= VCLKCNT + 1;
//			//	if (VCLKCNT==3'b000) begin
//			//		ZCLK	<=  ~ZCLK;
//			//	end
//			//	if (VCLKCNT==3'b110) begin
//			//		VCLKCNT	<= 3'b000;
//			//	end
//			//	if (VCLKCNT <= 3'b011) begin
//			//		VCLK	<= 1'b1;
//			//	end else begin
//			//		VCLK	<= 1'b0;
//			//	end
//			//	if (VCLKCNT==3'b110) begin
//			//		TG68_ENAWRREG	<= 1'b1;
//			//	end else begin
//			//		TG68_ENAWRREG	<= 1'b0;
//			//	end
//			//	if (VCLKCNT==3'b011) begin
//			//		TG68_ENARDREG	<= 1'b1;
//			//	end else begin
//			//		TG68_ENARDREG	<= 1'b0;
//			//	end	
//				ZCLK	<=  (VCLKCNT==3'b000) ? ~ZCLK : ZCLK;
//				ZCLK_RISE	<=  (VCLKCNT==3'b000) & (ZCLK==1'b0) ? 1'b1 : 1'b0;
//				VCLKCNT	<= (VCLKCNT==3'b110) ? 3'b000 : VCLKCNT + 1;
//			//	VCLK	<= (VCLKCNT <= 3'b011) ? 1'b1 : 1'b0;
//				VCLK	<= (VCLKCNT[2]==1'b0) ? 1'b1 : 1'b0;
//				VCLK_RISE <= (VCLKCNT==3'b101) ? 1'b1 : 1'b0;
//				VCLK_FALL <= (VCLKCNT==3'b010) ? 1'b1 : 1'b0;
//				TG68_ENAWRREG	<= (VCLKCNT==3'b110) ? 1'b1 : 1'b0;
//				TG68_ENARDREG	<= (VCLKCNT==3'b011) ? 1'b1 : 1'b0;
//			end
//	end

	// ---- 68K : TG68(modified) ----

`ifdef debug_tg68_iinterrput

TG68I tg68 (
//	.clk(TG68_CLK),
	.clk(MCLK),
	.reset(TG68_RES_N),
//	.clkena_in(TG68_CLKE),
	.clkena_in(1'b1),
	.data_in(TG68_DI),
	.IPL(TG68_IPL_N),
	.dtack(TG68_DTACK_N),
	.addr(TG68_A),
	.data_out(TG68_DO),
	.as(TG68_AS_N),
	.uds(TG68_UDS_N),
	.lds(TG68_LDS_N),
	.rw(TG68_RNW),
	.enaRDreg(TG68_ENARDREG),
	.enaWRreg(TG68_ENAWRREG),
	.intack_vect(TG68_IACK[2:0]),
	.intack(TG68_INTACK)
);

`else

	assign TG68_IACK[2:0]=3'b0;

TG68 tg68 (
//	.clk(TG68_CLK),
	.clk(MCLK),
	.reset(TG68_RES_N),
//	.clkena_in(TG68_CLKE),
	.clkena_in(1'b1),
	.data_in(TG68_DI),
	.IPL(TG68_IPL_N),
	.dtack(TG68_DTACK_N),
	.addr(TG68_A),
	.data_out(TG68_DO),
	.as(TG68_AS_N),
	.uds(TG68_UDS_N),
	.lds(TG68_LDS_N),
	.rw(TG68_RNW),
	.enaRDreg(TG68_ENARDREG),
	.enaWRreg(TG68_ENAWRREG),
	.intack(TG68_INTACK)
);

`endif

	// ---- Z80 : T80 ----

t80se t80 (
	.RESET_n(T80_RESET_N),
	.CLK_n(T80_CLK_N),
//	.CLKEN(1'b1),
	.CLKEN(T80_CLKEN),
	.WAIT_n(T80_WAIT_N),
	.INT_n(T80_INT_N),
	.NMI_n(T80_NMI_N),
	.BUSRQ_n(T80_BUSRQ_N),
	.M1_n(T80_M1_N),
	.MREQ_n(T80_MREQ_N),
	.IORQ_n(T80_IORQ_N),
	.RD_n(T80_RD_N),
	.WR_n(T80_WR_N),
	.RFSH_n(T80_RFSH_N),
	.HALT_n(T80_HALT_N),
	.BUSAK_n(T80_BUSAK_N),
	.A(T80_A),
	.DI(T80_DI),
	.DO(T80_DO)
);

//	assign T80_CLK_N=ZCLK;
//	assign T80_CLKEN=1'b1;
	assign T80_CLK_N=MCLK;
	assign T80_CLKEN=ZCLK_RISE;
	assign T80_NMI_N=1'b1;

//	assign VBUS_DMA_ACK=1'b0;
//	assign VRAM_DTACK_N=1'b0;


	//--------------------------------------------------------------
	// INTERRUPTS CONTROL
	//--------------------------------------------------------------

	wire	[2:0] TG_IPL;
	wire	TG_IPL_6;
	wire	TG_IPL_4;
	wire	TG_IPL_2;

	assign TG_IPL_6=(VINT_TG68==1'b1 && VINT_TG68_ACK==1'b0) ? 1'b1 : 1'b0;
	assign TG_IPL_4=(HINT==1'b1 && HINT_ACK==1'b0) ? 1'b1 : 1'b0;
	assign TG_IPL_2=1'b0;

	assign TG_IPL[2:0]=
			({TG_IPL_6}                  ==1'b1)   ? 3'b001 :
			({TG_IPL_6,TG_IPL_4}         ==2'b01)  ? 3'b011 :
			({TG_IPL_6,TG_IPL_4,TG_IPL_2}==3'b001) ? 3'b101 :
			3'b111;

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				TG68_IPL_N	<= 3'b111;
				HINT_ACK	<= 1'b0;
				VINT_TG68_ACK	<= 1'b0;
			end
		else
			begin
`ifdef debug_tg68_iinterrput
				TG68_IPL_N <= (TGCLK_RISE==1'b1) ? TG_IPL : TG68_IPL_N;
				HINT_ACK <=
					(HINT==1'b0) ? 1'b0 :
					(HINT==1'b1) & (TG68_INTACK==1'b1) & (TG68_IACK[2:0]==3'b100) ? 1'b1 :
					HINT_ACK;
				VINT_TG68_ACK <=
					(VINT_TG68==1'b0) ? 1'b0 :
					(VINT_TG68==1'b1) & (TG68_INTACK==1'b1) & (TG68_IACK[2:0]==3'b110) ? 1'b1 :
					VINT_TG68_ACK;
`else
				TG68_IPL_N <= (TGCLK_RISE==1'b1) ? TG_IPL : TG68_IPL_N;
				HINT_ACK <=
					(HINT==1'b0) ? 1'b0 :
					(HINT==1'b1) & (TG68_INTACK==1'b1) ? 1'b1 :
					HINT_ACK;
				VINT_TG68_ACK <=
					(VINT_TG68==1'b0) ? 1'b0 :
					(VINT_TG68==1'b1) & (TG68_INTACK==1'b1) ? 1'b1 :
					VINT_TG68_ACK;
`endif
			end
	end

`ifdef z80_interrupt

	reg		[3:0] INT_T80_ACK_r;
	reg		[3:0] T80_INT_REQ_r;
	wire	[3:0] INT_T80_ACK_w;
	wire	[3:0] T80_INT_REQ_w;

	assign T80_INT_N=!T80_INT_REQ_r[3];
	assign VINT_T80_ACK=INT_T80_ACK_r[1];

	always @(negedge MRST_N or negedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				T80_INT_REQ_r[3:0] <= 4'b0;
				INT_T80_ACK_r[3:0] <= 4'b0;
			end
		else
			begin
				T80_INT_REQ_r[3:0] <= T80_INT_REQ_w[3:0];
				INT_T80_ACK_r[3:0] <= INT_T80_ACK_w[3:0];
			end
	end

	assign T80_INT_REQ_w[1:0]=(VINT_T80==1'b0) ? 2'b00 : {T80_INT_REQ_r[0],1'b1};
	assign T80_INT_REQ_w[2]=(T80_INT_REQ_r[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign T80_INT_REQ_w[3]=
			(T80_INT_REQ_r[3]==1'b0) & (T80_INT_REQ_r[2]==1'b0) ? 1'b0 :
			(T80_INT_REQ_r[3]==1'b0) & (T80_INT_REQ_r[2]==1'b1) ? 1'b1 :
			(T80_INT_REQ_r[3]==1'b1) & (INT_T80_ACK_r[0]==1'b0) ? 1'b1 :
			(T80_INT_REQ_r[3]==1'b1) & (INT_T80_ACK_r[0]==1'b1) ? 1'b0 :
			1'b0;

	assign INT_T80_ACK_w[0]=(ZCLK_RISE==1'b1) & ({T80_M1_N,T80_IORQ_N}==2'b00) ? 1'b1 : 1'b0;
	assign INT_T80_ACK_w[1]=
			(VINT_T80==1'b1) & (INT_T80_ACK_r[0]==1'b0) ? 1'b0 :
			(VINT_T80==1'b1) & (INT_T80_ACK_r[0]==1'b1) ? 1'b1 :
			1'b0;
	assign INT_T80_ACK_w[3:2]=2'b00;

`else

	reg		INT_T80_ACK;
	reg		T80_INT_REQ;
	reg		VINT_T80_ACK_r;

	assign T80_INT_N=T80_INT_REQ;
	assign VINT_T80_ACK=VINT_T80_ACK_r;

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				VINT_T80_ACK_r <= 1'b0;
			end
		else
			begin
				VINT_T80_ACK_r <= 
					(VINT_T80==1'b0) ? 1'b0 :
					(VINT_T80==1'b1) &  ((INT_T80_ACK==1'b1) & (ZCLK_RISE==1'b1))  ? 1'b1 :
					(VINT_T80==1'b1) & !((INT_T80_ACK==1'b1) & (ZCLK_RISE==1'b1))  ? 1'b0 :
					1'b0;
			end
	end

//	always @(negedge MRST_N or negedge ZCLK)
	always @(negedge MRST_N or negedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				T80_INT_REQ <= 1'b1;
				INT_T80_ACK <= 1'b0;
			end
		else
			begin
				T80_INT_REQ <= 
					(ZCLK_RISE==1'b0) ? T80_INT_REQ :
					(ZCLK_RISE==1'b1) & (VINT_T80==1'b0) ? 1'b1 :
					(ZCLK_RISE==1'b1) & (VINT_T80==1'b1) ? 1'b0 :
					1'b1;
				INT_T80_ACK <= 
					(ZCLK_RISE==1'b1) & (T80_M1_N==1'b0 && T80_IORQ_N==1'b0) ? 1'b1 :
					1'b0;
			end
	end

`endif

	// --- vdma data bus ----

	assign VBUS_DTACK_N=
			(VBUS_ADDR[23]==1'b0) ? (!dma_cart_ack) :
			(VBUS_ADDR[23]==1'b1) ? (!dma_work_ack) :
			1'b0;
	assign VBUS_DATA=
			(VBUS_ADDR[23]==1'b0) ? (dma_cart_rdata[15:0]) :
			(VBUS_ADDR[23]==1'b1) ? (dma_work_rdata[15:0]) :
			16'h0;

	assign vdma_addr[23:0]=VBUS_ADDR[23:0];
	assign vdma_be[1:0]=2'b11;
	assign vdma_rdata[15:0]=VBUS_DATA[15:0];
	assign vdma_req=VBUS_SEL;
	assign vdma_ack=!VBUS_DTACK_N;

	assign dma_cart_req=(vdma_addr[23:22]==2'b00) & (vdma_req==1'b1) ? 1'b1 : 1'b0;
	assign dma_cart_addr[31:0]={8'b0,vdma_addr[23:0]};
	assign dma_work_req=(vdma_addr[23:21]==3'b111) & (vdma_req==1'b1) ? 1'b1 : 1'b0;
	assign dma_work_addr[31:0]={8'b0,vdma_addr[23:0]};

	assign dma_cart_busreq=VBUS_DMA_REQ;
	assign dma_work_busreq=VBUS_DMA_REQ;
//	assign VBUS_DMA_ACK=(dma_cart_busack==1'b1) & (dma_cart_busack==1'b1) ? 1'b1 : 1'b0;
	assign VBUS_DMA_ACK=1'b0;

	assign dma_cart_wr=1'b0;
	assign dma_work_wr=1'b0;
	assign dma_cart_wdata[31:0]=32'b0;
	assign dma_work_wdata[31:0]=32'b0;
	assign dma_cart_be[3:0]=4'b1111;
	assign dma_work_be[3:0]=4'b1111;

	// --- 68k data bus ----

	wire	m68_ack;

	reg		[1:0] m68_req_r;
	reg		m68_sel_r;
	reg		m68_dtak_n_r;
	reg		[15:0] m68_rdata_r;
	reg		m68_cart_sel_r;
	reg		m68_work_sel_r;
	reg		m68_zmem_sel_r;
	reg		m68_ctrl_sel_r;
	reg		m68_os_sel_r;
	reg		m68_pad_sel_r;
	reg		m68_bar_sel_r;
	reg		m68_vdp_sel_r;
	reg		m68_psg_sel_r;
	reg		m68_fm_sel_r;

	wire	[1:0] m68_req_w;
	wire	m68_sel_w;
	wire	m68_dtak_n_w;
	wire	[15:0] m68_rdata_w;
	wire	m68_cart_sel_w;
	wire	m68_work_sel_w;
	wire	m68_zmem_sel_w;
	wire	m68_ctrl_sel_w;
	wire	m68_os_sel_w;
	wire	m68_pad_sel_w;
	wire	m68_bar_sel_w;
	wire	m68_vdp_sel_w;
	wire	m68_psg_sel_w;
	wire	m68_fm_sel_w;

//`ifdef m68_buffered

	assign TG68_RES_N=MRST_N;
	assign TG68_DTACK_N=m68_dtak_n_r;
	assign TG68_DI[15:0]=m68_rdata_r[15:0];

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				m68_req_r[1:0] <= 2'b0;
				m68_sel_r <= 1'b0;
				m68_dtak_n_r <= 1'b1;
				m68_rdata_r[15:0] <= 16'b0;

				m68_cart_sel_r <= 1'b0;
				m68_work_sel_r <= 1'b0;
				m68_zmem_sel_r <= 1'b0;
				m68_ctrl_sel_r <= 1'b0;
				m68_os_sel_r <= 1'b0;
				m68_pad_sel_r <= 1'b0;
				m68_bar_sel_r <= 1'b0;
				m68_vdp_sel_r <= 1'b0;
				m68_psg_sel_r <= 1'b0;
				m68_fm_sel_r <= 1'b0;
			end
		else
			begin
				m68_req_r[1:0] <= m68_req_w[1:0];
				m68_sel_r <= m68_sel_w;
				m68_dtak_n_r <= m68_dtak_n_w;
				m68_rdata_r[15:0] <= m68_rdata_w[15:0];

				m68_cart_sel_r <= m68_cart_sel_w;
				m68_work_sel_r <= m68_work_sel_w;
				m68_zmem_sel_r <= m68_zmem_sel_w;
				m68_ctrl_sel_r <= m68_ctrl_sel_w;
				m68_os_sel_r <= m68_os_sel_w;
				m68_pad_sel_r <= m68_pad_sel_w;
				m68_bar_sel_r <= m68_bar_sel_w;
				m68_vdp_sel_r <= m68_vdp_sel_w;
				m68_psg_sel_r <= m68_psg_sel_w;
				m68_fm_sel_r <= m68_fm_sel_w;
			end
	end

	assign m68_ack=
			(m68_cart_sel_r==1'b1) ? m68_cart_ack :
			(m68_work_sel_r==1'b1) ? m68_work_ack :
			(m68_zmem_sel_r==1'b1) ? m68_zmem_ack :
			(m68_ctrl_sel_r==1'b1) ? m68_ctrl_ack :
			(m68_os_sel_r==1'b1) ? m68_os_ack :
			(m68_pad_sel_r==1'b1) ? m68_pad_ack :
			(m68_bar_sel_r==1'b1) ? m68_bar_ack :
			(m68_vdp_sel_r==1'b1) ? m68_vdp_ack :
			(m68_psg_sel_r==1'b1) ? m68_psg_ack :
			(m68_fm_sel_r==1'b1) ? m68_fm_ack :
		//	({m68_cart_sel_r,m68_work_sel_r,m68_zmem_sel_r,m68_ctrl_sel_r,m68_os_sel_r,m68_pad_sel_r,m68_bar_sel_r,m68_vdp_sel_r,m68_psg_sel_r,m68_fm_sel_r}==0) ? 1'b1 :
			({m68_cart_sel_r,m68_work_sel_r,m68_zmem_sel_r,m68_ctrl_sel_r,m68_os_sel_r,m68_pad_sel_r,m68_bar_sel_r,m68_vdp_sel_r,m68_psg_sel_r,m68_fm_sel_r}==0) ? !TG68_AS_N :
			1'b0;

	assign m68_req_w[1:0]=
			(m68_req_r[1:0]==2'b00) & (TG68_AS_N==1'b1) ? 2'b00 :
			(m68_req_r[1:0]==2'b00) & (TG68_AS_N==1'b0) & ({TG68_UDS_N,TG68_LDS_N}==2'b11) ? 2'b00 :
			(m68_req_r[1:0]==2'b00) & (TG68_AS_N==1'b0) & ({TG68_UDS_N,TG68_LDS_N}!=2'b11) ? 2'b01 :
			(m68_req_r[1:0]==2'b01) ? 2'b11 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b0) ? 2'b11 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b1) ? 2'b10 :
			(m68_req_r[1:0]==2'b10) & (TG68_AS_N==1'b0) ? 2'b10 :
			(m68_req_r[1:0]==2'b10) & (TG68_AS_N==1'b1) ? 2'b00 :
			2'b00;

	assign m68_sel_w=
			(m68_req_r[1:0]==2'b00) ? 1'b0 :
			(m68_req_r[1:0]==2'b01) ? 1'b1 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b0) ? 1'b1 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b1) ? 1'b0 :
			(m68_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign m68_dtak_n_w=
			(m68_req_r[1:0]==2'b00) ? 1'b0 :
		//	(m68_req_r[1:0]==2'b00) & (TG68_INTACK==1'b1) ? 1'b0 :
		//	(m68_req_r[1:0]==2'b00) & (TG68_INTACK==1'b0) ? 1'b1 :
			(m68_req_r[1:0]==2'b01) ? 1'b1 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b0) ? 1'b1 :
			(m68_req_r[1:0]==2'b11) & (m68_ack==1'b1) ? 1'b0 :
			(m68_req_r[1:0]==2'b10) & (TG68_AS_N==1'b0) ? 1'b0 :
			(m68_req_r[1:0]==2'b10) & (TG68_AS_N==1'b1) ? 1'b1 :
			1'b1;

	assign m68_rdata_w[15:0]=
			(m68_cart_sel_r==1'b1) & (m68_cart_ack==1'b1) ? (m68_cart_rdata[15:0]) :
			(m68_work_sel_r==1'b1) & (m68_work_ack==1'b1) ? (m68_work_rdata[15:0]) :
			(m68_zmem_sel_r==1'b1) & (m68_zmem_ack==1'b1) ? (m68_zmem_rdata[15:0]) :
			(m68_ctrl_sel_r==1'b1) & (m68_ctrl_ack==1'b1) ? (m68_ctrl_rdata[15:0]) :
			(m68_os_sel_r==1'b1) & (m68_os_ack==1'b1) ? (m68_os_rdata[15:0]) :
			(m68_pad_sel_r==1'b1) & (m68_pad_ack==1'b1) ? (m68_pad_rdata[15:0]) :
			(m68_bar_sel_r==1'b1) & (m68_bar_ack==1'b1) ? (m68_bar_rdata[15:0]) :
			(m68_vdp_sel_r==1'b1) & (m68_vdp_ack==1'b1) ? (m68_vdp_rdata[15:0]) :
			(m68_psg_sel_r==1'b1) & (m68_psg_ack==1'b1) ? (m68_psg_rdata[15:0]) :
			(m68_fm_sel_r==1'b1) & (m68_fm_ack==1'b1) ? (m68_fm_rdata[15:0]) :
			m68_rdata_r[15:0];
		//	16'hffff;

	assign m68_cart_sel_w=(TG68_A[23:22]==2'b00) & (CART_EN==1'b1) ? 1'b1 : 1'b0;
	assign m68_work_sel_w=(TG68_A[23:21]==3'b111) ? 1'b1 : 1'b0;
	assign m68_zmem_sel_w=(TG68_A[23:16]==8'hA0) & (TG68_A[15:14]==2'b00) ? 1'b1 : 1'b0;
	assign m68_ctrl_sel_w=(TG68_A[23:12]==12'hA11) | (TG68_A[23:12]==12'hA14) ? 1'b1 : 1'b0;
	assign m68_os_sel_w=(TG68_A[23:22]==2'b00) & (CART_EN==1'b0) ? 1'b1 : 1'b0;
	assign m68_pad_sel_w=(TG68_A[23:12]==12'hA10) ? 1'b1 : 1'b0;
	assign m68_bar_sel_w=(TG68_A[23:12]==12'hA06) ? 1'b1 : 1'b0;
	assign m68_vdp_sel_w=
			(TG68_A[23:21]==3'b110) & (TG68_A[4]==1'b0) ? 1'b1 :
			(TG68_A[23:12]==12'hA07) & (TG68_A[4]==1'b0) ? 1'b1 :
			1'b0;
	assign m68_psg_sel_w=
			(TG68_A[23:21]==3'b110) & (TG68_A[4]==1'b1) ? 1'b1 :
			(TG68_A[23:12]==12'hA07) & (TG68_A[4]==1'b1) ? 1'b1 :
			1'b0;
	assign m68_fm_sel_w=(TG68_A[23:12]==12'hA04) ? 1'b1 : 1'b0;

	assign m68_cart_req=(m68_cart_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_work_req=(m68_work_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_zmem_req=(m68_zmem_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_ctrl_req=(m68_ctrl_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_os_req=(m68_os_sel_r==1'b1) &  (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_pad_req=(m68_pad_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_bar_req=(m68_bar_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_vdp_req=(m68_vdp_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_psg_req=(m68_psg_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;
	assign m68_fm_req=(m68_fm_sel_r==1'b1) & (m68_sel_r==1'b1) ? 1'b1 : 1'b0;

//`else
//	assign TG68_RES_N	= MRST_N;
//	assign TG68_DTACK_N=
//			(m68_cart_req==1'b1) ? (!m68_cart_ack) :
//			(m68_work_req==1'b1) ? (!m68_work_ack) :
//			(m68_zmem_req==1'b1) ? (!m68_zmem_ack) :
//			(m68_ctrl_req==1'b1) ? (!m68_ctrl_ack) :
//			(m68_os_req==1'b1) ? (!m68_os_ack) :
//			(m68_pad_req==1'b1) ? (!m68_pad_ack) :
//			(m68_bar_req==1'b1) ? (!m68_bar_ack) :
//			(m68_vdp_req==1'b1) ? (!m68_vdp_ack) :
//			(m68_psg_req==1'b1) ? (!m68_psg_ack) :
//			(m68_fm_req==1'b1) ? (!m68_fm_ack) :
//			TG68_AS_N;
//		//	1'b0;
//	assign TG68_DI[15:0]=
//			(m68_cart_req==1'b1) ? (m68_cart_rdata[15:0]) :
//			(m68_work_req==1'b1) ? (m68_work_rdata[15:0]) :
//			(m68_zmem_req==1'b1) ? (m68_zmem_rdata[15:0]) :
//			(m68_ctrl_req==1'b1) ? (m68_ctrl_rdata[15:0]) :
//			(m68_os_req==1'b1) ? (m68_os_rdata[15:0]) :
//			(m68_pad_req==1'b1) ? (m68_pad_rdata[15:0]) :
//			(m68_bar_req==1'b1) ? (m68_bar_rdata[15:0]) :
//			(m68_vdp_req==1'b1) ? (m68_vdp_rdata[15:0]) :
//			(m68_psg_req==1'b1) ? (m68_psg_rdata[15:0]) :
//			(m68_fm_req==1'b1) ? (m68_fm_rdata[15:0]) :
//			16'hffff;
//	assign m68_cart_req=(TG68_A[23:22]==2'b00 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0) && TG68_RNW==1'b1 && CART_EN==1'b1) ? 1'b1 : 1'b0;
//	assign m68_work_req=(TG68_A[23:21]==3'b111 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//	assign m68_zmem_req=(TG68_A[23:16]==8'hA0 && TG68_A[14]==1'b0 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//	assign m68_ctrl_req=((TG68_A[23:12]==12'hA11 || TG68_A[23:12]==12'hA14) && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//	assign m68_os_req=(TG68_A[23:22]==2'b00 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0) && TG68_RNW==1'b1 && CART_EN==1'b0) ? 1'b1 : 1'b0;
//	assign m68_pad_req=(TG68_A[23:5]=={16'hA100, 3'b000} && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//	assign m68_bar_req=((TG68_A[23:16]==8'hA0 && TG68_A[14:13]==2'b11 && TG68_A[12:8] != 5'b11111) && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//	assign m68_vdp_req=
//			(TG68_A[23:21]==3'b110 && TG68_A[18:16]==3'b000 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) & (TG68_A[4]==1'b0) ? 1'b1 :
//			(TG68_A[23:16]==8'hA0 && TG68_A[14:5]=={7'b1111111, 3'b000} && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) & (TG68_A[4]==1'b0) ? 1'b1 :
//			1'b0;
//	assign m68_psg_req=
//			(TG68_A[23:21]==3'b110 && TG68_A[18:16]==3'b000 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) & (TG68_A[4]==1'b1) ? 1'b1 :
//			(TG68_A[23:16]==8'hA0 && TG68_A[14:5]=={7'b1111111, 3'b000} && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) & (TG68_A[4]==1'b1) ? 1'b1 :
//			1'b0;
//	assign m68_fm_req=(TG68_A[23:16]==8'hA0 && TG68_A[14:13]==2'b10 && TG68_AS_N==1'b0 && (TG68_UDS_N==1'b0 || TG68_LDS_N==1'b0)) ? 1'b1 : 1'b0;
//`endif

	wire	[31:0] m68_32_wdata;
	wire	[3:0] m68_32_be;

	wire	[31:0] m68_16_wdata;
	wire	[3:0] m68_16_be;

	wire	[31:0] m68_8_wdata;
	wire	[3:0] m68_8_be;

	assign m68_32_wdata[31:0]={TG68_DO[15:0],TG68_DO[15:0]};
	assign m68_32_be[3]=(TG68_UDS_N==1'b0) & (TG68_A[1]==1'b0) ? 1'b1 : 1'b0;
	assign m68_32_be[2]=(TG68_LDS_N==1'b0) & (TG68_A[1]==1'b0) ? 1'b1 : 1'b0;
	assign m68_32_be[1]=(TG68_UDS_N==1'b0) & (TG68_A[1]==1'b1) ? 1'b1 : 1'b0;
	assign m68_32_be[0]=(TG68_LDS_N==1'b0) & (TG68_A[1]==1'b1) ? 1'b1 : 1'b0;

	assign m68_16_wdata[31:0]={16'b0,TG68_DO[15:0]};
	assign m68_16_be[3]=1'b0;
	assign m68_16_be[2]=1'b0;
	assign m68_16_be[1]=(TG68_UDS_N==1'b0) ? 1'b1 : 1'b0;
	assign m68_16_be[0]=(TG68_LDS_N==1'b0) ? 1'b1 : 1'b0;

	assign m68_8_wdata[31:0]=(TG68_UDS_N==1'b0) ? {24'b0,TG68_DO[15:8]} : {24'b0,TG68_DO[7:0]};
	assign m68_8_be[3]=1'b0;
	assign m68_8_be[2]=1'b0;
	assign m68_8_be[1]=1'b0;
	assign m68_8_be[0]=1'b1;

	assign m68_cart_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_cart_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_cart_wdata[31:0]=m68_32_wdata[31:0];
	assign m68_cart_be[3:0]=m68_32_be[3:0];

	assign m68_work_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_work_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_work_wdata[31:0]=m68_32_wdata[31:0];
	assign m68_work_be[3:0]=m68_32_be[3:0];

	assign m68_zmem_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_zmem_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_zmem_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_zmem_be[3:0]=m68_16_be[3:0];

	assign m68_ctrl_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_ctrl_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_ctrl_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_ctrl_be[3:0]=m68_16_be[3:0];

	assign m68_os_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_os_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_os_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_os_be[3:0]=m68_16_be[3:0];

	assign m68_pad_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_pad_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_pad_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_pad_be[3:0]=m68_16_be[3:0];

	assign m68_bar_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_bar_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_bar_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_bar_be[3:0]=m68_16_be[3:0];

	assign m68_vdp_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_vdp_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_vdp_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_vdp_be[3:0]=m68_16_be[3:0];

	assign m68_psg_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_psg_addr[31:0]={8'b0,TG68_A[23:0]};
	assign m68_psg_wdata[31:0]=m68_16_wdata[31:0];
	assign m68_psg_be[3:0]=m68_16_be[3:0];

	assign m68_fm_wr=(TG68_RNW==1'b0) ? 1'b1 : 1'b0;
	assign m68_fm_addr[31:0]={8'b0,TG68_A[23:1],TG68_UDS_N};
	assign m68_fm_wdata[31:0]=m68_8_wdata[31:0];
	assign m68_fm_be[3:0]=m68_8_be[3:0];

	// ---- z80 data bus ----

	wire	z80_ack;

	reg		[1:0] z80_req_r;
	reg		z80_sel_r;
	reg		z80_wait_n_r;
	reg		[7:0] z80_rdata_r;

	reg		z80_work_sel_r;
	reg		z80_zmem_sel_r;
	reg		z80_cart_sel_r;
	reg		z80_ctrl_sel_r;
	reg		z80_pad_sel_r;
	reg		z80_bar_sel_r;
	reg		z80_vdp_sel_r;
	reg		z80_psg_sel_r;
	reg		z80_fm_sel_r;

	wire	[1:0] z80_req_w;
	wire	z80_sel_w;
	wire	z80_wait_n_w;
	wire	[7:0] z80_rdata_w;

	wire	z80_work_sel_w;
	wire	z80_zmem_sel_w;
	wire	z80_cart_sel_w;
	wire	z80_ctrl_sel_w;
	wire	z80_pad_sel_w;
	wire	z80_bar_sel_w;
	wire	z80_vdp_sel_w;
	wire	z80_psg_sel_w;
	wire	z80_fm_sel_w;

//`ifdef z80_buffered

	assign T80_WAIT_N=z80_wait_n_r;
	assign T80_DI[7:0]=z80_rdata_r[7:0];

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				z80_req_r[1:0] <= 2'b0;
				z80_sel_r <= 1'b0;
				z80_wait_n_r <= 1'b1;
				z80_rdata_r[7:0] <= 8'b0;

				z80_work_sel_r <= 1'b0;
				z80_zmem_sel_r <= 1'b0;
				z80_cart_sel_r <= 1'b0;
				z80_ctrl_sel_r <= 1'b0;
				z80_pad_sel_r <= 1'b0;
				z80_bar_sel_r <= 1'b0;
				z80_vdp_sel_r <= 1'b0;
				z80_psg_sel_r <= 1'b0;
				z80_fm_sel_r <= 1'b0;
			end
		else
			begin
				z80_req_r[1:0] <= z80_req_w[1:0];
				z80_sel_r <= z80_sel_w;
				z80_wait_n_r <= z80_wait_n_w;
				z80_rdata_r[7:0] <= z80_rdata_w[7:0];

				z80_work_sel_r <= z80_work_sel_w;
				z80_zmem_sel_r <= z80_zmem_sel_w;
				z80_cart_sel_r <= z80_cart_sel_w;
				z80_ctrl_sel_r <= z80_ctrl_sel_w;
				z80_pad_sel_r <= z80_pad_sel_w;
				z80_bar_sel_r <= z80_bar_sel_w;
				z80_vdp_sel_r <= z80_vdp_sel_w;
				z80_psg_sel_r <= z80_psg_sel_w;
				z80_fm_sel_r <= z80_fm_sel_w;
			end
	end

	assign z80_ack=
			(z80_work_sel_r==1'b1) ? z80_work_ack :
			(z80_zmem_sel_r==1'b1) ? z80_zmem_ack :
			(z80_cart_sel_r==1'b1) ? z80_cart_ack :
			(z80_ctrl_sel_r==1'b1) ? z80_ctrl_ack :
			(z80_pad_sel_r==1'b1) ? z80_pad_ack :
			(z80_bar_sel_r==1'b1) ? z80_bar_ack :
			(z80_vdp_sel_r==1'b1) ? z80_vdp_ack :
			(z80_psg_sel_r==1'b1) ? z80_psg_ack :
			(z80_fm_sel_r==1'b1) ? z80_fm_ack :
			({z80_work_sel_r,z80_zmem_sel_r,z80_cart_sel_r,z80_ctrl_sel_r,z80_pad_sel_r,z80_bar_sel_r,z80_vdp_sel_r,z80_psg_sel_r,z80_fm_sel_r}==0) ? 1'b1 :
			1'b0;

	assign z80_req_w[1:0]=
			(T80_RESET_N==1'b0) ? 2'b00 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b00) & (T80_BUSAK_N==1'b0) ? 2'b00 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b00) & ({T80_BUSAK_N,T80_MREQ_N}==2'b11) ? 2'b00 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b00) & ({T80_BUSAK_N,T80_MREQ_N}==2'b10) & ({T80_RD_N,T80_WR_N}==2'b11) ? 2'b00 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b00) & ({T80_BUSAK_N,T80_MREQ_N}==2'b10) & ({T80_RD_N,T80_WR_N}!=2'b11) ? 2'b01 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b01) ? 2'b11 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b11) & (z80_ack==1'b0) ? 2'b11 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b11) & (z80_ack==1'b1) ? 2'b10 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b10) & (T80_MREQ_N==1'b0) ? 2'b10 :
			(T80_RESET_N==1'b1) & (z80_req_r[1:0]==2'b10) & (T80_MREQ_N==1'b1) ? 2'b00 :
			2'b00;

	assign z80_sel_w=
			(z80_req_r[1:0]==2'b00) ? 1'b0 :
			(z80_req_r[1:0]==2'b01) ? 1'b1 :
			(z80_req_r[1:0]==2'b11) & (z80_ack==1'b0) ? 1'b1 :
			(z80_req_r[1:0]==2'b11) & (z80_ack==1'b1) ? 1'b0 :
			(z80_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign z80_wait_n_w=
			(z80_req_r[1:0]==2'b00) & (T80_MREQ_N==1'b1) ? 1'b1 :
			(z80_req_r[1:0]==2'b00) & (T80_MREQ_N==1'b0) ? 1'b0 :
			(z80_req_r[1:0]==2'b01) ? 1'b0 :
			(z80_req_r[1:0]==2'b11) & (z80_ack==1'b0) ? 1'b0 :
			(z80_req_r[1:0]==2'b11) & (z80_ack==1'b1) ? 1'b1 :
			(z80_req_r[1:0]==2'b10) ? 1'b1 :
			1'b1;

	assign z80_rdata_w[7:0]=
			(z80_work_sel_r==1'b1) & (z80_work_ack==1'b1) ? (z80_work_rdata[7:0]) :
			(z80_zmem_sel_r==1'b1) & (z80_zmem_ack==1'b1) ? (z80_zmem_rdata[7:0]) :
			(z80_cart_sel_r==1'b1) & (z80_cart_ack==1'b1) ? (z80_cart_rdata[7:0]) :
			(z80_ctrl_sel_r==1'b1) & (z80_ctrl_ack==1'b1) ? (z80_ctrl_rdata[7:0]) :
			(z80_pad_sel_r==1'b1) & (z80_pad_ack==1'b1) ? (z80_pad_rdata[7:0]) :
			(z80_bar_sel_r==1'b1) & (z80_bar_ack==1'b1) ? (z80_bar_rdata[7:0]) :
			(z80_vdp_sel_r==1'b1) & (z80_vdp_ack==1'b1) ? (z80_vdp_rdata[7:0]) :
			(z80_psg_sel_r==1'b1) & (z80_psg_ack==1'b1) ? (z80_psg_rdata[7:0]) :
			(z80_fm_sel_r==1'b1) & (z80_fm_ack==1'b1) ? (z80_fm_rdata[7:0]) :
			z80_rdata_r[7:0];
		//	8'hFF;

	assign z80_cart_sel_w=(T80_A[15]==1'b1) & (BAR[23:22]==2'b00) ? 1'b1 : 1'b0;
	assign z80_zmem_sel_w=(T80_A[15:14]==2'b00) ? 1'b1 : 1'b0;
	assign z80_work_sel_w=(T80_A[15]==1'b1) & (BAR[23:21]==3'b111) ? 1'b1 : 1'b0;
//	assign z80_ctrl_sel_w=(T80_A[15]==1'b1) & (({BAR[23:15], T80_A[14:12]}==12'hA11 || {BAR[23:15], T80_A[14:12]}==12'hA14)) ? 1'b1 : 1'b0;
	assign z80_ctrl_sel_w=1'b0;
	assign z80_pad_sel_w=(T80_A[15]==1'b1) & ({BAR, T80_A[14:12]}==12'hA10) ? 1'b1 : 1'b0;
	assign z80_bar_sel_w=(T80_A[15:12]==4'h6) ? 1'b1 : 1'b0;
	assign z80_vdp_sel_w=
			(T80_A[15:12]==4'h7) & (T80_A[4]==1'b0) ? 1'b1 :
			(T80_A[15]==1'b1) & (BAR[23:21]==3'b110) & (T80_A[4]==1'b0) ? 1'b1 :
			1'b0;
	assign z80_psg_sel_w=
			(T80_A[15:12]==4'h7) & (T80_A[4]==1'b1) ? 1'b1 :
			(T80_A[15]==1'b1) & (BAR[23:21]==3'b110) & (T80_A[4]==1'b1) ? 1'b1 :
			1'b0;
	assign z80_fm_sel_w=(T80_A[15:12]==4'h4) ? 1'b1 : 1'b0;

	assign z80_cart_req=(z80_cart_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_zmem_req=(z80_zmem_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_work_req=(z80_work_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
//	assign z80_ctrl_req=(z80_ctrl_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_ctrl_req=1'b0;
	assign z80_pad_req=(z80_pad_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_bar_req=(z80_bar_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_vdp_req=(z80_vdp_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_psg_req=(z80_psg_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;
	assign z80_fm_req=(z80_fm_sel_r==1'b1) & (z80_sel_r===1'b1) ? 1'b1 : 1'b0;

//`else
//	assign T80_WAIT_N=
//			(z80_work_req==1'b1) ? ( z80_work_ack) :
//			(z80_zmem_req==1'b1) ? ( z80_zmem_ack) :
//			(z80_cart_req==1'b1) ? ( z80_cart_ack) :
//			(z80_ctrl_req==1'b1) ? ( z80_ctrl_ack) :
//			(z80_pad_req==1'b1) ? ( z80_pad_ack) :
//			(z80_bar_req==1'b1) ? ( z80_bar_ack) :
//			(z80_vdp_req==1'b1) ? ( z80_vdp_ack) :
//			(z80_psg_req==1'b1) ? ( z80_psg_ack) :
//			(z80_fm_req==1'b1) ? ( z80_fm_ack) :
//			1'b1;
//	assign T80_DI[7:0]=
//			(z80_work_req==1'b1) ? (z80_work_rdata[7:0]) :
//			(z80_zmem_req==1'b1) ? (z80_zmem_rdata[7:0]) :
//			(z80_cart_req==1'b1) ? (z80_cart_rdata[7:0]) :
//			(z80_ctrl_req==1'b1) ? (z80_ctrl_rdata[7:0]) :
//			(z80_pad_req==1'b1) ? (z80_pad_rdata[7:0]) :
//			(z80_bar_req==1'b1) ? (z80_bar_rdata[7:0]) :
//			(z80_vdp_req==1'b1) ? (z80_vdp_rdata[7:0]) :
//			(z80_psg_req==1'b1) ? (z80_psg_rdata[7:0]) :
//			(z80_fm_req==1'b1) ? (z80_fm_rdata[7:0]) :
//			8'hFF;
//	assign z80_cart_req=(T80_A[15]==1'b1 && BAR[23:22]==2'b00 && T80_MREQ_N==1'b0 && T80_RD_N==1'b0) ? 1'b1 : 1'b0;
//	assign z80_zmem_req=(T80_A[15:14]==2'b00 && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
//	assign z80_work_req=(T80_A[15]==1'b1 && BAR[23:21]==3'b111 && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
///	assign z80_ctrl_req=(T80_A[15]==1'b1 && ({BAR[23:15], T80_A[14:12]}==12'hA11 || {BAR[23:15], T80_A[14:12]}==12'hA14) && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
//	assign z80_ctrl_req=1'b0;
//	assign z80_pad_req=(T80_A[15]==1'b1 && {BAR, T80_A[14:5]}=={16'hA100, 3'b000} && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
//	assign z80_bar_req=((T80_A[15:13]==3'b011 && T80_A[12:8] != 5'b11111) && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
//	assign z80_vdp_req=
//			(T80_A[15:5]=={8'h7F, 3'b000} && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) & (T80_A[4]==1'b0) ? 1'b1 :
//			(T80_A[15]==1'b1 && BAR[23:21]==3'b110 && BAR[18:16]==3'b000 && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) & (T80_A[4]==1'b0) ? 1'b1 :
//			1'b0;
//	assign z80_psg_req=
//			(T80_A[15:5]=={8'h7F, 3'b000} && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) & (T80_A[4]==1'b1) ? 1'b1 :
//			(T80_A[15]==1'b1 && BAR[23:21]==3'b110 && BAR[18:16]==3'b000 && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) & (T80_A[4]==1'b1) ? 1'b1 :
//			1'b0;
//	assign z80_fm_req=(T80_A[15:13]==3'b010 && T80_MREQ_N==1'b0 && (T80_RD_N==1'b0 || T80_WR_N==1'b0)) ? 1'b1 : 1'b0;
//`endif

	wire	[31:0] z80_32_wdata;
	wire	[3:0] z80_32_be;

	wire	[31:0] z80_16_wdata;
	wire	[3:0] z80_16_be;

	wire	[31:0] z80_8_wdata;
	wire	[3:0] z80_8_be;

	assign z80_32_wdata[31:0]={T80_DO[7:0],T80_DO[7:0],T80_DO[7:0],T80_DO[7:0]};
	assign z80_32_be[3]=(T80_A[1:0]==2'b00) ? 1'b1 : 1'b0;
	assign z80_32_be[2]=(T80_A[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign z80_32_be[1]=(T80_A[1:0]==2'b10) ? 1'b1 : 1'b0;
	assign z80_32_be[0]=(T80_A[1:0]==2'b11) ? 1'b1 : 1'b0;

	assign z80_16_wdata[31:0]={16'b0,T80_DO[7:0],T80_DO[7:0]};
	assign z80_16_be[3]=1'b0;
	assign z80_16_be[2]=1'b0;
	assign z80_16_be[1]=(T80_A[0]==1'b0) ? 1'b1 : 1'b0;
	assign z80_16_be[0]=(T80_A[0]==1'b1) ? 1'b1 : 1'b0;

	assign z80_8_wdata[31:0]={24'b0,T80_DO[7:0]};
	assign z80_8_be[3]=1'b0;
	assign z80_8_be[2]=1'b0;
	assign z80_8_be[1]=1'b0;
	assign z80_8_be[0]=1'b1;

	assign T80_FLASH_SEL=z80_cart_req;
	assign T80_SRAM_SEL=z80_work_req;
	assign T80_ZRAM_SEL=z80_zmem_req;
	assign T80_CTRL_SEL=z80_ctrl_req;
	assign T80_IO_SEL=z80_pad_req;
	assign T80_BAR_SEL=z80_bar_req;
	assign T80_VDP_SEL=z80_vdp_req;
	assign T80_PSG_SEL=z80_psg_req;
	assign T80_FM_SEL=z80_fm_req;

	assign z80_cart_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_cart_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_cart_wdata[31:0]=z80_32_wdata[31:0];
	assign z80_cart_be[3:0]=z80_32_be[3:0];

	assign z80_work_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_work_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_work_wdata[31:0]=z80_32_wdata[31:0];
	assign z80_work_be[3:0]=z80_32_be[3:0];

	assign z80_zmem_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_zmem_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_zmem_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_zmem_be[3:0]=z80_16_be[3:0];

	assign z80_ctrl_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_ctrl_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_ctrl_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_ctrl_be[3:0]=z80_16_be[3:0];

	assign z80_pad_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_pad_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_pad_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_pad_be[3:0]=z80_16_be[3:0];

	assign z80_bar_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_bar_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_bar_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_bar_be[3:0]=z80_16_be[3:0];

	assign z80_vdp_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_vdp_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_vdp_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_vdp_be[3:0]=z80_16_be[3:0];

	assign z80_psg_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_psg_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_psg_wdata[31:0]=z80_16_wdata[31:0];
	assign z80_psg_be[3:0]=z80_16_be[3:0];

	assign z80_fm_wr=(T80_WR_N==1'b0) ? 1'b1 : 1'b0;
	assign z80_fm_addr[31:0]=(T80_A[15]==1'b1) ? {8'b0,2'b00,BAR[21:15],T80_A[14:0]} : {16'b0,1'b0,T80_A[14:0]};
	assign z80_fm_wdata[31:0]=z80_8_wdata[31:0];
	assign z80_fm_be[3:0]=z80_8_be[3:0];

	// ---- debug ---

//	assign DEBUG_OUT[15:0]=16'b0;

	reg		[15:0] DEBUG_OUT_r;
	wire	[15:0] DEBUG_OUT_w;

	assign DEBUG_OUT[15:0]=DEBUG_OUT_r[15:0];

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				DEBUG_OUT_r[15:0] <= 16'b0;
			end
		else
			begin
				DEBUG_OUT_r[15:0] <= DEBUG_OUT_w[15:0];
			end
	end

	assign DEBUG_OUT_w[15]=m68_cart_req;
	assign DEBUG_OUT_w[14]=m68_work_req;
	assign DEBUG_OUT_w[13]=m68_zmem_req;
	assign DEBUG_OUT_w[12]=m68_ctrl_req;
	assign DEBUG_OUT_w[11]=m68_pad_req;
	assign DEBUG_OUT_w[10]=m68_vdp_req;
	assign DEBUG_OUT_w[9]=m68_psg_req;
	assign DEBUG_OUT_w[8]=m68_fm_req;
	assign DEBUG_OUT_w[7]=m68_bar_req;
	assign DEBUG_OUT_w[6]=CART_EN;
	assign DEBUG_OUT_w[5]=z80_cart_req;
	assign DEBUG_OUT_w[4]=z80_work_req;
	assign DEBUG_OUT_w[3]=z80_zmem_req;	// z80_pad_req;
	assign DEBUG_OUT_w[2]=z80_psg_req;	// z80_vdp_req;
	assign DEBUG_OUT_w[1]=z80_fm_req;
	assign DEBUG_OUT_w[0]=z80_bar_req;

	reg		[15:0] T80_FLASH_SEL_r;
	reg		[15:0] T80_CTRL_SEL_r;
	reg		[15:0] T80_IO_SEL_r;
	reg		[15:0] T80_BAR_SEL_r;
	reg		[15:0] T80_VDP_SEL_r;
	reg		[15:0] T80_FM_SEL_r;

	reg		T80_FLASH_SEL_out_r;
	reg		T80_CTRL_SEL_out_r;
	reg		T80_IO_SEL_out_r;
	reg		T80_BAR_SEL_out_r;
	reg		T80_VDP_SEL_out_r;
	reg		T80_FM_SEL_out_r;

	assign DEBUG_Z[15:0]={BAR[23:15],T80_RESET_N,ZBUSREQ,T80_FLASH_SEL_out_r,T80_IO_SEL_out_r,T80_BAR_SEL_out_r,T80_VDP_SEL_out_r,T80_FM_SEL_out_r};

	always @(posedge MCLK or posedge RESET)
	begin
		if (RESET==1'b1)
			begin
				T80_FLASH_SEL_r[15:0] <= 16'b0;
				T80_CTRL_SEL_r[15:0] <= 16'b0;
				T80_IO_SEL_r[15:0] <= 16'b0;
				T80_BAR_SEL_r[15:0] <= 16'b0;
				T80_VDP_SEL_r[15:0] <= 16'b0;
				T80_FM_SEL_r[15:0] <= 16'b0;

				T80_FLASH_SEL_out_r <= 1'b0;
				T80_CTRL_SEL_out_r <= 1'b0;
				T80_IO_SEL_out_r <= 1'b0;
				T80_BAR_SEL_out_r <= 1'b0;
				T80_VDP_SEL_out_r <= 1'b0;
				T80_FM_SEL_out_r <= 1'b0;
			end
		else
			begin
				T80_FLASH_SEL_r[15:0] <=
					(T80_FLASH_SEL==1'b1) ? 16'hffff :
					(T80_FLASH_SEL==1'b0) & (T80_FLASH_SEL_r[15:0]!=16'b0) ? T80_FLASH_SEL_r[15:0]-16'b01 :
					(T80_FLASH_SEL==1'b0) & (T80_FLASH_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				T80_CTRL_SEL_r[15:0] <=
					(T80_CTRL_SEL==1'b1) ? 16'hffff :
					(T80_CTRL_SEL==1'b0) & (T80_CTRL_SEL_r[15:0]!=16'b0) ? T80_CTRL_SEL_r[15:0]-16'b01 :
					(T80_CTRL_SEL==1'b0) & (T80_CTRL_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				T80_IO_SEL_r[15:0] <=
					(T80_IO_SEL==1'b1) ? 16'hffff :
					(T80_IO_SEL==1'b0) & (T80_IO_SEL_r[15:0]!=16'b0) ? T80_IO_SEL_r[15:0]-16'b01 :
					(T80_IO_SEL==1'b0) & (T80_IO_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				T80_BAR_SEL_r[15:0] <=
					(T80_BAR_SEL==1'b1) ? 16'hffff :
					(T80_BAR_SEL==1'b0) & (T80_BAR_SEL_r[15:0]!=16'b0) ? T80_BAR_SEL_r[15:0]-16'b01 :
					(T80_BAR_SEL==1'b0) & (T80_BAR_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				T80_VDP_SEL_r[15:0] <=
					(T80_PSG_SEL==1'b1) ? 16'hffff :
					(T80_PSG_SEL==1'b0) & (T80_VDP_SEL_r[15:0]!=16'b0) ? T80_VDP_SEL_r[15:0]-16'b01 :
					(T80_PSG_SEL==1'b0) & (T80_VDP_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				T80_FM_SEL_r[15:0] <=
					(T80_FM_SEL==1'b1) ? 16'hffff :
					(T80_FM_SEL==1'b0) & (T80_FM_SEL_r[15:0]!=16'b0) ? T80_FM_SEL_r[15:0]-16'b01 :
					(T80_FM_SEL==1'b0) & (T80_FM_SEL_r[15:0]==16'b0) ? 16'b0 :
					16'b0;

				T80_FLASH_SEL_out_r <= (T80_FLASH_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				T80_CTRL_SEL_out_r <= (T80_CTRL_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				T80_IO_SEL_out_r <= (T80_IO_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				T80_BAR_SEL_out_r <= (T80_BAR_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				T80_VDP_SEL_out_r <= (T80_VDP_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				T80_FM_SEL_out_r <= (T80_FM_SEL_r[15:0]==16'b0) ? 1'b0 : 1'b1;
			end
	end

	// ---- cartrdge ----

	wire	[31:0] mem_cart_addr;
	wire	[31:0] mem_cart_wdata;
	wire	[3:0] mem_cart_be;
	wire	[31:0] mem_cart_rdata;
	wire	mem_cart_wr;
	wire	mem_cart_req;
	wire	mem_cart_ack;

	assign CART_WE=1'b0;
	assign CART_WDATA[31:0]=32'b0;
	assign CART_BE[3:0]=4'b0;
	assign CART_REQ=mem_cart_req;
	assign CART_ADDR[31:0]=mem_cart_addr[31:0];
	assign mem_cart_rdata[31:0]=CART_RDATA[31:0];
	assign mem_cart_ack=CART_ACK;

gen_arb32 #(
	.p0_size(2),		// size=1(8),2(16),4(32)
	.p1_size(1),
	.p2_size(2)
) mem_cart_arb (
	.dev_addr(mem_cart_addr),			// out
	.dev_wdata(mem_cart_wdata),			// out
	.dev_be(mem_cart_be),				// out
	.dev_rdata(mem_cart_rdata),			// in
	.dev_wr(mem_cart_wr),				// out
	.dev_req(mem_cart_req),				// out
	.dev_ack(mem_cart_ack),				// in

	.p0_addr(dma_cart_addr),			// in
	.p0_wdata(dma_cart_wdata),			// in
	.p0_be(dma_cart_be),				// in
	.p0_rdata(dma_cart_rdata),			// out
	.p0_wr(dma_cart_wr),				// in
	.p0_req(dma_cart_req),				// in
	.p0_ack(dma_cart_ack),				// out
	.p0_busreq(dma_cart_busreq),		// in
	.p0_busack(dma_cart_busack),		// out

	.p1_addr(z80_cart_addr),			// in
	.p1_wdata(z80_cart_wdata),			// in
	.p1_be(z80_cart_be),				// in
	.p1_rdata(z80_cart_rdata),			// out
	.p1_wr(z80_cart_wr),				// in
	.p1_req(z80_cart_req),				// in
	.p1_ack(z80_cart_ack),				// out

	.p2_addr(m68_cart_addr),			// in
	.p2_wdata(m68_cart_wdata),			// in
	.p2_be(m68_cart_be),				// in
	.p2_rdata(m68_cart_rdata),			// out
	.p2_wr(m68_cart_wr),				// in
	.p2_req(m68_cart_req),				// in
	.p2_ack(m68_cart_ack),				// out

	.p3_addr(32'b0),			// in
	.p3_wdata(32'b0),			// in
	.p3_be(4'b0),				// in
	.p3_rdata(),				// out
	.p3_wr(1'b0),				// in
	.p3_req(1'b0),				// in
	.p3_ack(),					// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	// ---- m68 ram 64k ----

	wire	[31:0] mem_work_addr;
	wire	[31:0] mem_work_wdata;
	wire	[3:0] mem_work_be;
	wire	[31:0] mem_work_rdata;
	wire	mem_work_wr;
	wire	mem_work_req;
	wire	mem_work_ack;

	assign WORK_ADDR[31:0]=mem_work_addr[31:0];
	assign WORK_WDATA[31:0]=mem_work_wdata;
	assign WORK_BE[3:0]=mem_work_be;
	assign WORK_WR=mem_work_wr;
	assign WORK_REQ=mem_work_req;
	assign mem_work_rdata[31:0]=WORK_RDATA[31:0];
	assign mem_work_ack=WORK_ACK;

gen_arb32 #(
	.p0_size(2),		// size=1(8),2(16),4(32)
	.p1_size(1),
	.p2_size(2)
) mem_work_arb (
	.dev_addr(mem_work_addr),			// out
	.dev_wdata(mem_work_wdata),			// out
	.dev_be(mem_work_be),				// out
	.dev_rdata(mem_work_rdata),			// in
	.dev_wr(mem_work_wr),				// out
	.dev_req(mem_work_req),				// out
	.dev_ack(mem_work_ack),				// in

	.p0_addr(dma_work_addr),			// in
	.p0_wdata(dma_work_wdata),			// in
	.p0_be(dma_work_be),				// in
	.p0_rdata(dma_work_rdata),			// out
	.p0_wr(dma_work_wr),				// in
	.p0_req(dma_work_req),				// in
	.p0_ack(dma_work_ack),				// out
	.p0_busreq(dma_work_busreq),		// in
	.p0_busack(dma_work_busack),		// out

	.p1_addr(z80_work_addr),			// in
	.p1_wdata(z80_work_wdata),			// in
	.p1_be(z80_work_be),				// in
	.p1_rdata(z80_work_rdata),			// out
	.p1_wr(z80_work_wr),				// in
	.p1_req(z80_work_req),				// in
	.p1_ack(z80_work_ack),				// out

	.p2_addr(m68_work_addr),			// in
	.p2_wdata(m68_work_wdata),			// in
	.p2_be(m68_work_be),				// in
	.p2_rdata(m68_work_rdata),			// out
	.p2_wr(m68_work_wr),				// in
	.p2_req(m68_work_req),				// in
	.p2_ack(m68_work_ack),				// out

	.p3_addr(32'b0),			// in
	.p3_wdata(32'b0),			// in
	.p3_be(4'b0),				// in
	.p3_rdata(),				// out
	.p3_wr(1'b0),				// in
	.p3_req(1'b0),				// in
	.p3_ack(),					// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	// ---- z80 ram 8k ----

	wire	[31:0] mem_zmem_addr;
	wire	[31:0] mem_zmem_wdata;
	wire	[3:0] mem_zmem_be;
	wire	[31:0] mem_zmem_rdata;
	wire	mem_zmem_wr;
	wire	mem_zmem_req;
	wire	mem_zmem_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) mem_zmem_arb (
	.dev_addr(mem_zmem_addr),			// out
	.dev_wdata(mem_zmem_wdata),			// out
	.dev_be(mem_zmem_be),				// out
	.dev_rdata(mem_zmem_rdata),			// in
	.dev_wr(mem_zmem_wr),				// out
	.dev_req(mem_zmem_req),				// out
	.dev_ack(mem_zmem_ack),				// in

	.p0_addr(z80_zmem_addr),			// in
	.p0_wdata(z80_zmem_wdata),			// in
	.p0_be(z80_zmem_be),				// in
	.p0_rdata(z80_zmem_rdata),			// out
	.p0_wr(z80_zmem_wr),				// in
	.p0_req(z80_zmem_req),				// in
	.p0_ack(z80_zmem_ack),				// out

	.p1_addr(m68_zmem_addr),			// in
	.p1_wdata(m68_zmem_wdata),			// in
	.p1_be(m68_zmem_be),				// in
	.p1_rdata(m68_zmem_rdata),			// out
	.p1_wr(m68_zmem_wr),				// in
	.p1_req(m68_zmem_req),				// in
	.p1_ack(m68_zmem_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	reg		[3:0] mem_zmem_req_r;
	reg		mem_zmem_we_r;
	reg		[1:0] mem_zmem_wr_r;

	assign mem_zmem_ack=mem_zmem_req_r[1];
//	assign mem_zmem_ack=(mem_zmem_req==1'b1) ? mem_zmem_req_r[1] : 1'b0;

	always @(posedge MCLK or negedge MRST_N)
	begin
		if (MRST_N==1'b0)
			begin
				mem_zmem_req_r[3:0] <= 4'b0;
				mem_zmem_we_r <= 1'b0;
				mem_zmem_wr_r[1:0] <= 2'b0;
			end
		else
			begin
				mem_zmem_req_r[3:0] <= (mem_zmem_req==1'b0) ? 4'b0 : {mem_zmem_req_r[2:0],1'b1};
				mem_zmem_we_r <= ({mem_zmem_req,mem_zmem_req_r[0]}==2'b10) & (mem_zmem_wr==1'b1) ? 1'b1 : 1'b0;
				mem_zmem_wr_r[0] <= ({mem_zmem_req,mem_zmem_req_r[0]}==2'b10) & (mem_zmem_be[0]==1'b1) & (mem_zmem_wr==1'b1) ? 1'b1 : 1'b0;
				mem_zmem_wr_r[1] <= ({mem_zmem_req,mem_zmem_req_r[0]}==2'b10) & (mem_zmem_be[1]==1'b1) & (mem_zmem_wr==1'b1) ? 1'b1 : 1'b0;
			end
	end

	assign mem_zmem_rdata[31:16]=16'h0;

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_16x4k mem_16x4k(
	.clka(MCLK),
	.ena(mem_zmem_req),
	.wea(mem_zmem_wr_r[1:0]),
	.addra(mem_zmem_addr[12:1]),
	.dina(mem_zmem_wdata[15:0]),
	.clkb(MCLK),
	.enb(mem_zmem_req),
	.addrb(mem_zmem_addr[12:1]),
	.doutb(mem_zmem_rdata[15:0])
);

end
	else
begin
end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_16x4k mem_16x4k(
	.byteena_a(mem_zmem_be[1:0]),
	.clock(MCLK),
	.data(mem_zmem_wdata[15:0]),
	.rdaddress(mem_zmem_addr[12:1]),
	.wraddress(mem_zmem_addr[12:1]),
	.wren(mem_zmem_we_r),
	.q(mem_zmem_rdata[15:0])
);

end
	else
begin
end
endgenerate

	// ---- z80 busreq/busack , os-rom ----

	wire	[31:0] io_ctrl_addr;
	wire	[31:0] io_ctrl_wdata;
	wire	[3:0] io_ctrl_be;
	wire	[31:0] io_ctrl_rdata;
	wire	io_ctrl_wr;
	wire	io_ctrl_req;
	wire	io_ctrl_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_ctrl_arb (
	.dev_addr(io_ctrl_addr),			// out
	.dev_wdata(io_ctrl_wdata),			// out
	.dev_be(io_ctrl_be),				// out
	.dev_rdata(io_ctrl_rdata),			// in
	.dev_wr(io_ctrl_wr),				// out
	.dev_req(io_ctrl_req),				// out
	.dev_ack(!io_ctrl_ack),				// in

	.p0_addr(z80_ctrl_addr),			// in
	.p0_wdata(z80_ctrl_wdata),			// in
	.p0_be(z80_ctrl_be),				// in
	.p0_rdata(z80_ctrl_rdata),			// out
	.p0_wr(z80_ctrl_wr),				// in
	.p0_req(z80_ctrl_req),				// in
	.p0_ack(z80_ctrl_ack),				// out

	.p1_addr(m68_ctrl_addr),			// in
	.p1_wdata(m68_ctrl_wdata),			// in
	.p1_be(m68_ctrl_be),				// in
	.p1_rdata(m68_ctrl_rdata),			// out
	.p1_wr(m68_ctrl_wr),				// in
	.p1_req(m68_ctrl_req),				// in
	.p1_ack(m68_ctrl_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

//`ifdef sync_z80_busreq

	reg		ctrl_ack_r;

	reg		ctrl_cart_en_r;
	reg		ctrl_z80_busreq_r;
	reg		ctrl_z80_reset_n_r;
	wire	ctrl_cart_en_w;
	wire	ctrl_z80_busreq_w;
	wire	ctrl_z80_reset_n_w;

	reg		ctrl_z80_busack_n_r;
	reg		z80_reset_n_r;
	reg		z80_busreq_n_r;
	wire	ctrl_z80_busack_n_w;
	wire	z80_reset_n_w;
	wire	z80_busreq_n_w;

	assign io_ctrl_ack=ctrl_ack_r;
//	assign io_ctrl_ack=(io_ctrl_req==1'b1) ? ctrl_ack_r : 1'b0;
	assign io_ctrl_rdata[31:16]=16'h0000;
	assign io_ctrl_rdata[15:0]={7'h7f,ZBUSACK_N,7'h7f,ZBUSACK_N};

	assign CART_EN=ctrl_cart_en_r;
	assign ZBUSREQ=ctrl_z80_busreq_r;
	assign ZRESET_N=ctrl_z80_reset_n_r;

	assign ZBUSACK_N=ctrl_z80_busack_n_r;

	assign T80_RESET_N=z80_reset_n_r;
	assign T80_BUSRQ_N=z80_busreq_n_r;

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				ctrl_ack_r <= 1'b0;
				ctrl_z80_busreq_r <= 1'b0;
				ctrl_z80_reset_n_r <= 1'b0;
				ctrl_cart_en_r <= (SIM_WO_OS==1'b1) ? 1'b1 : 1'b0;
				ctrl_z80_busack_n_r <= 1'b0;
			end
		else
			begin
				ctrl_ack_r <= (io_ctrl_req==1'b1) ? 1'b1 : 1'b0;
				ctrl_z80_busreq_r <= ctrl_z80_busreq_w;
				ctrl_z80_reset_n_r <= ctrl_z80_reset_n_w;
				ctrl_cart_en_r <= ctrl_cart_en_w;
				ctrl_z80_busack_n_r <= (z80_reset_n_r==1'b0) ? z80_busreq_n_r : T80_BUSAK_N;
			end
	end

	assign ctrl_z80_busreq_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h11) & (io_ctrl_wr==1'b1) & (io_ctrl_be[1]==1'b1) ? io_ctrl_wdata[8] : ctrl_z80_busreq_r;
	assign ctrl_z80_reset_n_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h12) & (io_ctrl_wr==1'b1) & (io_ctrl_be[1]==1'b1) ? io_ctrl_wdata[8] : ctrl_z80_reset_n_r;
	assign ctrl_cart_en_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h41) & (io_ctrl_wr==1'b1) & (io_ctrl_be[0]==1'b1) ? io_ctrl_wdata[0] : ctrl_cart_en_r;

//	always @(negedge MRST_N or negedge ZCLK)
	always @(negedge MRST_N or negedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				z80_reset_n_r <= 1'b0;
				z80_busreq_n_r <= 1'b0;
			end
		else
			begin
				z80_reset_n_r <= z80_reset_n_w;
				z80_busreq_n_r <= z80_busreq_n_w;
			end
	end

	assign z80_reset_n_w=
			(z80_reset_n_r==1'b1) & (ctrl_z80_reset_n_r==1'b1) ? 1'b1 :
			(z80_reset_n_r==1'b1) & (ctrl_z80_reset_n_r==1'b0) ? 1'b0 :
			(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b0) ? z80_reset_n_r :
			(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b1) & (ctrl_z80_reset_n_r==1'b0) ? 1'b0 :
		//	(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b1) & (ctrl_z80_reset_n_r==1'b1) & (ctrl_z80_busreq_r==1'b1) ? 1'b0 :
		//	(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b1) & (ctrl_z80_reset_n_r==1'b1) & (ctrl_z80_busreq_r==1'b0) ? 1'b1 :
			(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b1) & (ctrl_z80_reset_n_r==1'b1) & (z80_busreq_n_r==1'b0) ? 1'b0 :
			(z80_reset_n_r==1'b0) & (ZCLK_RISE==1'b1) & (ctrl_z80_reset_n_r==1'b1) & (z80_busreq_n_r==1'b1) ? 1'b1 :
			1'b0;
	assign z80_busreq_n_w=(ZCLK_RISE==1'b1) ? !ctrl_z80_busreq_r : z80_busreq_n_r;

//`else
/*
	reg		ctrl_ack_r;

	reg		ctrl_cart_en_r;
	reg		ctrl_z80_busreq_r;
	reg		ctrl_z80_reset_n_r;
	wire	ctrl_cart_en_w;
	wire	ctrl_z80_busreq_w;
	wire	ctrl_z80_reset_n_w;

	reg		ctrl_z80_busack_n_r;
	reg		z80_reset_n;
	reg		z80_busreq_n;

	assign io_ctrl_ack=ctrl_ack_r;
//	assign io_ctrl_ack=(io_ctrl_req==1'b1) ? ctrl_ack_r : 1'b0;
	assign io_ctrl_rdata[31:16]=16'h0;
	assign io_ctrl_rdata[15:0]={7'h7f,ZBUSACK_N,7'h7f,ZBUSACK_N};

	assign CART_EN=ctrl_cart_en_r;
	assign ZBUSREQ=ctrl_z80_busreq_r;
	assign ZRESET_N=ctrl_z80_reset_n_r;

	assign ZBUSACK_N=ctrl_z80_busack_n_r;

	assign T80_RESET_N=z80_reset_n;
	assign T80_BUSRQ_N=z80_busreq_n;

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				ctrl_ack_r <= 1'b0;
				ctrl_z80_busreq_r <= 1'b0;
				ctrl_z80_reset_n_r <= 1'b0;
				ctrl_cart_en_r <= (SIM_WO_OS==1'b1) ? 1'b1 : 1'b0;
				ctrl_z80_busack_n_r <= 1'b0;
			end
		else
			begin
				ctrl_ack_r <= (io_ctrl_req==1'b1) ? 1'b1 : 1'b0;
				ctrl_z80_busreq_r <= ctrl_z80_busreq_w;
				ctrl_z80_reset_n_r <= ctrl_z80_reset_n_w;
				ctrl_cart_en_r <= ctrl_cart_en_w;
				ctrl_z80_busack_n_r <= (T80_RESET_N==1'b0) ? ~ZBUSREQ : T80_BUSAK_N;
			end
	end

//	always @(negedge MRST_N or negedge ZCLK)
	always @(negedge MRST_N or negedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				z80_reset_n <= 1'b0;
				z80_busreq_n <= 1'b0;
			end
		else
			begin
				z80_reset_n <= (ZCLK_RISE==1'b1) ? ZRESET_N : z80_reset_n;
				z80_busreq_n <= (ZCLK_RISE==1'b1) ? ~ZBUSREQ : z80_busreq_n;
			end
	end

	assign ctrl_z80_busreq_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h11) & (io_ctrl_wr==1'b1) & (io_ctrl_be[1]==1'b1) ? io_ctrl_wdata[8] : ctrl_z80_busreq_r;
	assign ctrl_z80_reset_n_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h12) & (io_ctrl_wr==1'b1) & (io_ctrl_be[1]==1'b1) ? io_ctrl_wdata[8] : ctrl_z80_reset_n_r;
	assign ctrl_cart_en_w=({io_ctrl_req,ctrl_ack_r}==2'b10) & (io_ctrl_addr[15:8]==8'h41) & (io_ctrl_wr==1'b1) & (io_ctrl_be[0]==1'b1) ? io_ctrl_wdata[0] : ctrl_cart_en_r;
*/
//`endif

	// ---- bios (boot and initiallize) ----

//	assign m68_os_ack=m68_os_req;
//	assign m68_os_rdata[31:16]=16'h0;

	reg		[1:0] m68_os_ack_r;

	assign m68_os_ack=m68_os_req;
//	assign m68_os_ack=m68_os_ack_r[1];
	assign m68_os_rdata[31:16]=16'h0;

	always @(negedge MRST_N or negedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				m68_os_ack_r[1:0] <= 2'b0;
			end
		else
			begin
				m68_os_ack_r[1:0] <= (m68_os_req==1'b1) ? {m68_os_ack_r[0],1'b0} : 2'b01;
			end
	end

//	// OS ROM
//	os_rom	os (
//		.A(TG68_A[8:1]),
//		.OEn(OS_OEn),
//		.D(TG68_OS_D)
//	);

generate
	if (SIM_WO_OS==1)
begin

	assign m68_os_rdata[15:0]=16'h0;

end
	else
begin

os_rom #(
	.DEVICE(DEVICE)
) rom (
	.clk(MCLK),
	.addr(m68_os_addr[11:0]),
	.data(m68_os_rdata[15:0])
);

end
endgenerate


	// ---- control pad ----

	wire	[31:0] io_pad_addr;
	wire	[31:0] io_pad_wdata;
	wire	[3:0] io_pad_be;
	wire	[31:0] io_pad_rdata;
	wire	io_pad_wr;
	wire	io_pad_req;
	wire	io_pad_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_pad_arb (
	.dev_addr(io_pad_addr),			// out
	.dev_wdata(io_pad_wdata),			// out
	.dev_be(io_pad_be),				// out
	.dev_rdata(io_pad_rdata),			// in
	.dev_wr(io_pad_wr),				// out
	.dev_req(io_pad_req),				// out
	.dev_ack(io_pad_ack),				// in

	.p0_addr(z80_pad_addr),			// in
	.p0_wdata(z80_pad_wdata),			// in
	.p0_be(z80_pad_be),				// in
	.p0_rdata(z80_pad_rdata),			// out
	.p0_wr(z80_pad_wr),				// in
	.p0_req(z80_pad_req),				// in
	.p0_ack(z80_pad_ack),				// out

	.p1_addr(m68_pad_addr),			// in
	.p1_wdata(m68_pad_wdata),			// in
	.p1_be(m68_pad_be),				// in
	.p1_rdata(m68_pad_rdata),			// out
	.p1_wr(m68_pad_wr),				// in
	.p1_req(m68_pad_req),				// in
	.p1_ack(m68_pad_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	wire	P1_UP;
	wire	P1_DOWN;
	wire	P1_LEFT;
	wire	P1_RIGHT;
	wire	P1_A;
	wire	P1_B;
	wire	P1_C;
	wire	P1_START;

	wire	P2_UP;
	wire	P2_DOWN;
	wire	P2_LEFT;
	wire	P2_RIGHT;
	wire	P2_A;
	wire	P2_B;
	wire	P2_C;
	wire	P2_START;

	assign {P1_START,P1_C,P1_B,P1_A,P1_RIGHT,P1_LEFT,P1_DOWN,P1_UP}=KEY1[7:0];
	assign {P2_START,P2_C,P2_B,P2_A,P2_RIGHT,P2_LEFT,P2_DOWN,P2_UP}=KEY2[7:0];

	assign io_pad_rdata[31:16]=16'h0;

gen_io gen_io (
	.RST_N(MRST_N),
	.MCLK(MCLK),
	.CLK(VCLK),

	.VERSION(VERSION),

	.P1_UP(P1_UP),
	.P1_DOWN(P1_DOWN),
	.P1_LEFT(P1_LEFT),
	.P1_RIGHT(P1_RIGHT),
	.P1_A(P1_A),
	.P1_B(P1_B),
	.P1_C(P1_C),
	.P1_START(P1_START),

	.P2_UP(P2_UP),
	.P2_DOWN(P2_DOWN),
	.P2_LEFT(P2_LEFT),
	.P2_RIGHT(P2_RIGHT),
	.P2_A(P2_A),
	.P2_B(P2_B),
	.P2_C(P2_C),
	.P2_START(P2_START),

	.io_req(io_pad_req),
	.io_addr(io_pad_addr[4:0]),
	.io_wr(io_pad_wr),
	.io_be(io_pad_be[1:0]),
	.io_wdata(io_pad_wdata[15:0]),
	.io_rdata(io_pad_rdata[15:0]),
	.io_ack(io_pad_ack)
);

	// ---- z80 bank ----

	wire	[31:0] io_bar_addr;
	wire	[31:0] io_bar_wdata;
	wire	[3:0] io_bar_be;
	wire	[31:0] io_bar_rdata;
	wire	io_bar_wr;
	wire	io_bar_req;
	wire	io_bar_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_bar_arb (
	.dev_addr(io_bar_addr),			// out
	.dev_wdata(io_bar_wdata),			// out
	.dev_be(io_bar_be),				// out
	.dev_rdata(io_bar_rdata),			// in
	.dev_wr(io_bar_wr),				// out
	.dev_req(io_bar_req),				// out
	.dev_ack(io_bar_ack),				// in

	.p0_addr(z80_bar_addr),			// in
	.p0_wdata(z80_bar_wdata),			// in
	.p0_be(z80_bar_be),				// in
	.p0_rdata(z80_bar_rdata),			// out
	.p0_wr(z80_bar_wr),				// in
	.p0_req(z80_bar_req),				// in
	.p0_ack(z80_bar_ack),				// out

	.p1_addr(m68_bar_addr),			// in
	.p1_wdata(m68_bar_wdata),			// in
	.p1_be(m68_bar_be),				// in
	.p1_rdata(m68_bar_rdata),			// out
	.p1_wr(m68_bar_wr),				// in
	.p1_req(m68_bar_req),				// in
	.p1_ack(m68_bar_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	reg		io_bar_ack_r;
	reg		[23:15] z80_bar_r;

	assign io_bar_rdata=32'h0;
	assign io_bar_ack=io_bar_ack_r;
//	assign io_bar_ack=(io_bar_req==1'b1) ? io_bar_ack_r : 1'b0;

	assign BAR[23:15]=z80_bar_r[23:15];

	always @(negedge MRST_N or posedge MCLK)
	begin
		if (MRST_N==1'b0)
			begin
				io_bar_ack_r <= 1'b0;
				z80_bar_r <= 9'b0;
			end
		else
			begin
				io_bar_ack_r <= (io_bar_req==1'b1) ? 1'b1 : 1'b0;
				z80_bar_r <= (io_bar_be[1]==1'b1) & (io_bar_wr==1'b1) & ({io_bar_req,io_bar_ack_r}==2'b10) ? {io_bar_wdata[8], z80_bar_r[23:16]} : z80_bar_r[23:15];
			end
	end

	// ---- video vdp ----

	wire	[31:0] io_vdp_addr;
	wire	[31:0] io_vdp_wdata;
	wire	[3:0] io_vdp_be;
	wire	[31:0] io_vdp_rdata;
	wire	io_vdp_wr;
	wire	io_vdp_req;
	wire	io_vdp_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_vdp_arb (
	.dev_addr(io_vdp_addr),			// out
	.dev_wdata(io_vdp_wdata),			// out
	.dev_be(io_vdp_be),				// out
	.dev_rdata(io_vdp_rdata),			// in
	.dev_wr(io_vdp_wr),				// out
	.dev_req(io_vdp_req),				// out
	.dev_ack(!io_vdp_ack),				// in

	.p0_addr(z80_vdp_addr),			// in
	.p0_wdata(z80_vdp_wdata),			// in
	.p0_be(z80_vdp_be),				// in
	.p0_rdata(z80_vdp_rdata),			// out
	.p0_wr(z80_vdp_wr),				// in
	.p0_req(z80_vdp_req),				// in
	.p0_ack(z80_vdp_ack),				// out

	.p1_addr(m68_vdp_addr),			// in
	.p1_wdata(m68_vdp_wdata),			// in
	.p1_be(m68_vdp_be),				// in
	.p1_rdata(m68_vdp_rdata),			// out
	.p1_wr(m68_vdp_wr),				// in
	.p1_req(m68_vdp_req),				// in
	.p1_ack(m68_vdp_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	assign io_vdp_rdata[31:16]=16'h0;
	assign vdma_busack_n=1'b0;

gen_vdp #(
	.DEVICE(DEVICE),
	.disp_bga(vdp_sca),
	.disp_bgb(vdp_scb),
	.disp_spr(vdp_spr)
) gen_vdp (
	.DEBUG_OUT(DEBUG_VDP),

	.debug_sca(debug_sca),
	.debug_scw(debug_scw),
	.debug_scb(debug_scb),
	.debug_spr(debug_spr),
	.debug_dma(debug_dma),

	.RST_N(MRST_N),
	.CLK(MCLK),

	.SEL(io_vdp_req),
	.A(io_vdp_addr[4:0]),
	.RNW(!io_vdp_wr),
	.UDS_N(!io_vdp_be[1]),
	.LDS_N(!io_vdp_be[0]),
	.DI(io_vdp_wdata[15:0]),
	.DO(io_vdp_rdata[15:0]),
	.DTACK_N(io_vdp_ack),

	.VRAM32_ADDR(VRAM32_ADDR[31:0]),
	.VRAM32_REQ(VRAM32_REQ),
	.VRAM32_BE(VRAM32_BE[3:0]),
	.VRAM32_RDATA(VRAM32_RDATA[31:0]),
	.VRAM32_WDATA(VRAM32_WDATA[31:0]),
	.VRAM32_WR(VRAM32_WR),
	.VRAM32_ACK(VRAM32_ACK),

	.VD_ADDR(VD_ADDR[31:0]),
	.VD_REQ(VD_REQ),
	.VD_BE(VD_BE[3:0]),
	.VD_RDATA(VD_RDATA[31:0]),
	.VD_WDATA(VD_WDATA[31:0]),
	.VD_WR(VD_WR),
	.VD_ACK(VD_ACK),

	.V0_ADDR(V0_ADDR[31:0]),
	.V0_REQ(V0_REQ),
	.V0_BE(V0_BE[3:0]),
	.V0_RDATA(V0_RDATA[31:0]),
	.V0_WDATA(V0_WDATA[31:0]),
	.V0_WR(V0_WR),
	.V0_ACK(V0_ACK),

	.V1_ADDR(V1_ADDR[31:0]),
	.V1_REQ(V1_REQ),
	.V1_BE(V1_BE[3:0]),
	.V1_RDATA(V1_RDATA[31:0]),
	.V1_WDATA(V1_WDATA[31:0]),
	.V1_WR(V1_WR),
	.V1_ACK(V1_ACK),

	.V2_ADDR(V2_ADDR[31:0]),
	.V2_REQ(V2_REQ),
	.V2_BE(V2_BE[3:0]),
	.V2_RDATA(V2_RDATA[31:0]),
	.V2_WDATA(V2_WDATA[31:0]),
	.V2_WR(V2_WR),
	.V2_ACK(V2_ACK),

	.V3_ADDR(V3_ADDR[31:0]),
	.V3_REQ(V3_REQ),
	.V3_BE(V3_BE[3:0]),
	.V3_RDATA(V3_RDATA[31:0]),
	.V3_WDATA(V3_WDATA[31:0]),
	.V3_WR(V3_WR),
	.V3_ACK(V3_ACK),

	.HINT(HINT),
	.HINT_ACK(HINT_ACK),

	.VINT_TG68(VINT_TG68),
	.VINT_T80(VINT_T80),
	.VINT_TG68_ACK(VINT_TG68_ACK),
	.VINT_T80_ACK(VINT_T80_ACK),

	.VBUS_DMA_REQ(VBUS_DMA_REQ),
	.VBUS_DMA_ACK(VBUS_DMA_ACK),

	.VBUS_ADDR(VBUS_ADDR),
	.VBUS_UDS_N(VBUS_UDS_N),
	.VBUS_LDS_N(VBUS_LDS_N),
	.VBUS_DATA(VBUS_DATA),
	.VBUS_SEL(VBUS_SEL),
	.VBUS_DTACK_N(VBUS_DTACK_N),

	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_DE(VGA_DE),
	.VGA_CLK(VGA_CLK)
);

	// ---- sound psg ----

	wire	[31:0] io_psg_addr;
	wire	[31:0] io_psg_wdata;
	wire	[3:0] io_psg_be;
	wire	[31:0] io_psg_rdata;
	wire	io_psg_wr;
	wire	io_psg_req;
	wire	io_psg_ack;

gen_arb16 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_psg_arb (
	.dev_addr(io_psg_addr),			// out
	.dev_wdata(io_psg_wdata),			// out
	.dev_be(io_psg_be),				// out
	.dev_rdata(io_psg_rdata),			// in
	.dev_wr(io_psg_wr),				// out
	.dev_req(io_psg_req),				// out
	.dev_ack(io_psg_ack),				// in

	.p0_addr(z80_psg_addr),			// in
	.p0_wdata(z80_psg_wdata),			// in
	.p0_be(z80_psg_be),				// in
	.p0_rdata(z80_psg_rdata),			// out
	.p0_wr(z80_psg_wr),				// in
	.p0_req(z80_psg_req),				// in
	.p0_ack(z80_psg_ack),				// out

	.p1_addr(m68_psg_addr),			// in
	.p1_wdata(m68_psg_wdata),			// in
	.p1_be(m68_psg_be),				// in
	.p1_rdata(m68_psg_rdata),			// out
	.p1_wr(m68_psg_wr),				// in
	.p1_req(m68_psg_req),				// in
	.p1_ack(m68_psg_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

//`ifdef sync_io_psg
//	wire	[31:0] psg_iy_wdata;
//	wire	psg_iy_req;
//	wire	psg_iy_ack;
//	wire	[31:0] psg_ix_wdata;
//	wire	psg_ix_req;
//	wire	psg_ix_ack;
//	assign psg_ix_req=(io_psg_req==1'b1) & (io_psg_wr==1'b1) ? 1'b1 : 1'b0;
//	assign io_psg_ack=
//			(io_psg_req==1'b1) & (io_psg_wr==1'b0) ? 1'b1 :
//			(io_psg_req==1'b1) & (io_psg_wr==1'b1) ? psg_ix_ack :
//			1'b0;
//sp3a_xy32 xy32_psg(
//	.iy_addr(),								// out   [I-Y] [31:0] addr output
//	.iy_rdata(32'b0),						// in    [I-Y] [31:0] data input
//	.iy_wdata(psg_iy_wdata[31:0]),			// out   [I-Y] [31:0] data output
//	.iy_be(),								// out   [I-Y] [3:0] be
//	.iy_rd(),								// out   [I-Y] read/#write
//	.iy_busy(1'b0),							// in    [I-Y] busy/#ready
//	.iy_req(psg_iy_req),					// out   [I-Y] req
//	.iy_ack(psg_iy_ack),					// in    [I-Y] ack
//	.iy_err(1'b0),							// in    [I-Y] exception error
//	.iy_clk(ZCLK),							// in    [I-Y] y-clk
//	.ix_addr(32'b0),						// in    [I-X] [31:0] addr input
//	.ix_rdata(),							// out   [I-X] [31:0] data output
//	.ix_wdata({24'b0,io_psg_wdata[7:0]}),	// in    [I-X] [31:0] data input
//	.ix_be(4'b0001),						// in    [I-X] [3:0] be
//	.ix_rd(1'b0),							// in    [I-X] read/#write
//	.ix_busy(),								// out   [I-X] busy/#ready
//	.ix_req(psg_ix_req),					// in    [I-X] req
//	.ix_ack(psg_ix_ack),					// out   [I-X] ack
//	.ix_err(),								// out   [I-X] exception error
//	.ix_rst_n(MRST_N),						// in    [I-X] #reset
//	.ix_clk(MCLK)							// in    [I-X] x-clk
//);
//sn76489_top #(
//	.clock_div_16_g(1)
//) psg (
//sn76489_top psg(
//	.clock_i(ZCLK),				// in  std_logic;
//	.clock_en_i(1'b1),			// in  std_logic;
//	.res_n_i(MRST_N),			// in  std_logic;
//	.ce_n_i(!psg_iy_req),		// in  std_logic;
//	.we_n_i(1'b0),				// in  std_logic;
//	.ready_o(psg_iy_ack),		// out std_logic;
//	.d_i(psg_iy_wdata[7:0]),	// in  std_logic_vector(0 to 7);
//	.aout_o(PSG_OUT)			// out signed(0 to 7)
//);
//`else

	wire	PSG_CE;
	wire	PSG_RDY;
	reg		[1:0] PSG_RDY_r;
	wire	[1:0] PSG_RDY_w;

	assign io_psg_rdata[31:0]=32'h0;
//	assign io_psg_ack=(PSG_RDY==1'b1) & (ZCLK_RISE==1'b1) ? 1'b1 : 1'b0;
	assign io_psg_ack=
			(io_psg_wr==1'b0) ? 1'b1 :
			(io_psg_wr==1'b1) & (io_psg_be[0]==1'b0) ? 1'b1 :
			(io_psg_wr==1'b1) & (io_psg_be[0]==1'b1) & ({PSG_RDY,PSG_RDY_r[1]}==2'b11) ? 1'b1 :
			1'b0;
	assign PSG_CE=(io_psg_req==1'b1) & (io_psg_wr==1'b1) & (io_psg_be[0]==1'b1) ? 1'b1 : 1'b0;

	always @(posedge MCLK or negedge MRST_N)
	begin
		if (MRST_N==1'b0)
			begin
				PSG_RDY_r[1:0] <= 2'b0;
			end
		else
			begin
				PSG_RDY_r[1:0] <= PSG_RDY_w[1:0];
			end
	end

	assign PSG_RDY_w[1:0]=(PSG_CE==1'b1) ? {PSG_RDY_r[0],1'b1} : 2'b00;

//sn76489_top #(
//	.clock_div_16_g(1)
//) psg (
sn76489_top psg(
	.clock_i(MCLK),				// in  std_logic;
	.clock_en_i(ZCLK_RISE),			// in  std_logic;
	.res_n_i(MRST_N),			// in  std_logic;
	.ce_n_i(!PSG_CE),			// in  std_logic;
	.we_n_i(1'b0),				// in  std_logic;
	.ready_o(PSG_RDY),			// out std_logic;
	.d_i(io_psg_wdata[7:0]),	// in  std_logic_vector(0 to 7);
	.aout_o(PSG_OUT)			// out signed(0 to 7)
);

//`endif

	// ---- sound fm ----

	wire	[31:0] io_fm_addr;
	wire	[31:0] io_fm_wdata;
	wire	[3:0] io_fm_be;
	wire	[31:0] io_fm_rdata;
	wire	io_fm_wr;
	wire	io_fm_req;
	wire	io_fm_ack;

`ifdef sync_io_fm

gen_arb8 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_fm_arb (
	.dev_addr(io_fm_addr),			// out
	.dev_wdata(io_fm_wdata),			// out
	.dev_be(io_fm_be),				// out
	.dev_rdata(io_fm_rdata),			// in
	.dev_wr(io_fm_wr),				// out
	.dev_req(io_fm_req),				// out
	.dev_ack(io_fm_ack),				// in

	.p0_addr(z80_fm_addr),			// in
	.p0_wdata(z80_fm_wdata),			// in
	.p0_be(z80_fm_be),				// in
	.p0_rdata(z80_fm_rdata),			// out
	.p0_wr(z80_fm_wr),				// in
	.p0_req(z80_fm_req),				// in
	.p0_ack(z80_fm_ack),				// out

	.p1_addr(m68_fm_addr),			// in
	.p1_wdata(m68_fm_wdata),			// in
	.p1_be(m68_fm_be),				// in
	.p1_rdata(m68_fm_rdata),			// out
	.p1_wr(m68_fm_wr),				// in
	.p1_req(m68_fm_req),				// in
	.p1_ack(m68_fm_ack),				// out

	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);

	wire	[31:0] fm_iy_addr;
	wire	[31:0] fm_iy_rdata;
	wire	[31:0] fm_iy_wdata;
	wire	fm_iy_req;
	wire	fm_iy_ack;

	wire	[31:0] fm_ix_addr;
	wire	[31:0] fm_ix_rdata;
	wire	[31:0] fm_ix_wdata;
	wire	fm_ix_req;
	wire	fm_ix_ack;

sp3a_xy32 xy32_fm(
	.iy_addr(fm_iy_addr[31:0]),				// out   [I-Y] [31:0] addr output
	.iy_rdata({24'b0,fm_iy_rdata[7:0]}),	// in    [I-Y] [31:0] data input
	.iy_wdata(fm_iy_wdata[31:0]),			// out   [I-Y] [31:0] data output
	.iy_be(),								// out   [I-Y] [3:0] be
	.iy_rd(fm_iy_rd),						// out   [I-Y] read/#write
	.iy_busy(1'b0),							// in    [I-Y] busy/#ready
	.iy_req(fm_iy_req),						// out   [I-Y] req
	.iy_ack(fm_iy_ack),						// in    [I-Y] ack
	.iy_err(1'b0),							// in    [I-Y] exception error
	.iy_clk(FCLK),							// in    [I-Y] y-clk

	.ix_addr(io_fm_addr[31:0]),				// in    [I-X] [31:0] addr input
	.ix_rdata(io_fm_rdata[31:0]),			// out   [I-X] [31:0] data output
	.ix_wdata({24'b0,io_fm_wdata[7:0]}),	// in    [I-X] [31:0] data input
	.ix_be(4'b0001),						// in    [I-X] [3:0] be
	.ix_rd(!io_fm_wr),						// in    [I-X] read/#write
	.ix_busy(),								// out   [I-X] busy/#ready
	.ix_req(io_fm_req),						// in    [I-X] req
	.ix_ack(io_fm_ack),						// out   [I-X] ack
	.ix_err(),								// out   [I-X] exception error
	.ix_rst_n(MRST_N),						// in    [I-X] #reset
	.ix_clk(MCLK)							// in    [I-X] x-clk
);

	assign fm_iy_rdata[31:8]=24'b0;

gen_fm8 #(
	.opn2(opn2)
) fm (
	.debug_out(DEBUG_FM),
	
	.FM_OUT_L(FM_OUT_L),
	.FM_OUT_R(FM_OUT_R),
	.MIX_PSG(PSG_OUT),

	.YM_ADDR(YM_ADDR),
	.YM_WDATA(YM_WDATA),
	.YM_RDATA(YM_RDATA),
	.YM_DOE(YM_DOE),
	.YM_WR_N(YM_WR_N),
	.YM_RD_N(YM_RD_N),
	.YM_CS_N(YM_CS_N),
	.YM_RESET_N(YM_RESET_N),
	.YM_CLK(YM_CLK),

	.RST_N(ZRESET_N),
	.MCLK(FCLK),
	.SEL(fm_iy_req),
	.ADDR(fm_iy_addr[1:0]),
	.RNW(fm_iy_rd),
	.WDATA(fm_iy_wdata[7:0]),
	.RDATA(fm_iy_rdata[7:0]),
	.ACK(fm_iy_ack)
);

`else

gen_arb8 #(
	.p0_size(1),		// size=1(8),2(16)
	.p1_size(2)
) io_fm_arb (
	.dev_addr(io_fm_addr),			// out
	.dev_wdata(io_fm_wdata),			// out
	.dev_be(io_fm_be),				// out
	.dev_rdata(io_fm_rdata),			// in
	.dev_wr(io_fm_wr),				// out
	.dev_req(io_fm_req),				// out
	.dev_ack(!io_fm_ack),				// in
	.p0_addr(z80_fm_addr),			// in
	.p0_wdata(z80_fm_wdata),			// in
	.p0_be(z80_fm_be),				// in
	.p0_rdata(z80_fm_rdata),			// out
	.p0_wr(z80_fm_wr),				// in
	.p0_req(z80_fm_req),				// in
	.p0_ack(z80_fm_ack),				// out
	.p1_addr(m68_fm_addr),			// in
	.p1_wdata(m68_fm_wdata),			// in
	.p1_be(m68_fm_be),				// in
	.p1_rdata(m68_fm_rdata),			// out
	.p1_wr(m68_fm_wr),				// in
	.p1_req(m68_fm_req),				// in
	.p1_ack(m68_fm_ack),				// out
	.dev_clk(MCLK),						// in
	.dev_rst_n(MRST_N)					// in
);
	assign io_fm_rdata[31:8]=24'h0;

gen_fm8s #(
	.opn2(opn2)
) fm (
	.debug_out(DEBUG_FM),
	
	.FM_OUT_L(FM_OUT_L),
	.FM_OUT_R(FM_OUT_R),
	.MIX_PSG(PSG_OUT),
	
	.RST_N(ZRESET_N),	// gen-hw.txt line 328
	.MCLK(MCLK),
	.CKE(FCLK_RISE),
	.SEL(io_fm_req),
	.ADDR(io_fm_addr[1:0]),
	.RNW(!io_fm_wr),
	.WDATA(io_fm_wdata[7:0]),
	.RDATA(io_fm_rdata[7:0]),
	.DTACK_N(io_fm_ack)
);

`endif

endmodule
