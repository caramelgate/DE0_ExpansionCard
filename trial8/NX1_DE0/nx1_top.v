//------------------------------------------------------------------------------
//
//	nx1_top.v : ese x1 top module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/nov/28 release 0.0  modifyed and downgrade for de1(altera cyclone2)
//  2014/jan/10 release 0.1  preview
//       jan/17 release 0.1a +FDC
//       jan/27 release 0.1b replace VID
//       feb/03 release 0.1c replace mode(+memory interface)
//
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
//
//	original copyright 
//
//--------------------------------------------------------------------------------------
/****************************************************************************
  nise X1 TOP

  Version 0804xx

  Copyright(C) 2004,2005,2008 Tatsuyuki Satoh

  This software is provided "AS IS", with NO WARRANTY.
  NON-COMMERCIAL USE ONLY

  Histry:
    2008. 4.xx separated by sp3sk model
    2005. 4.12 
    2005. 4.12 .d88 support
    2005. 1.20 added NTSC S2 encoder
    2005. 1.14 Cleanup
           LED all off when eco-mode
    2005. 1.12 1st release

  Note:

  Distributing all and a part is prohibited. 
  Because this version is developer-alpha version.

****************************************************************************/

module nx1_top #(
	parameter	def_DEVICE=0,			// 0=Xilinx , 1=Altera
	parameter	def_work_sram=0,		// main memory sdr / syncram
	parameter	def_X1TURBO=0,			// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
	parameter	def_FM_BOARD=0,			// YM2151 FM sound board (not supported yet)
//	parameter	def_EXTEND_BIOS=0,		// extend BIOS MENU & NoICE-Z80 resource-free monitor
	parameter	def_use_ipl=1,			// fast simulation : ipl skip
	parameter	SIM_FAST=0,				// fast simulation
	parameter	DEBUG=0,				// fast simulation
	parameter	def_MBASE=32'h00000000,	// main memory base address
	parameter	def_BBASE=32'h00100000,	// bank memory base address
	parameter	def_VBASE=32'h00180000	// video base address
) (
	input			EX_HS,				// in    [SYNC] horizontal sync
	input			EX_VS,				// in    [SYNC] vertical sync
	input			EX_DE,				// in    [SYNC] disp/#blank
	input			EX_HDISP,			// in    [SYNC] horizontal disp
	input			EX_VDISP,			// in    [SYNC] vertical disp
	input			EX_HBP,				// in    [SYNC] horizontal backporch
	input			EX_HWSAV,			// in    [SYNC] horizontal window sav
	input			EX_HSAV,			// in    [SYNC] horizontal sav
	input			EX_HEAV,			// in    [SYNC] horizontal eav
	input			EX_HC,				// in    [SYNC] horizontal countup
	input			EX_VWSAV,			// in    [SYNC] vertical window sav
	input			EX_VSAV,			// in    [SYNC] vertical sav
	input			EX_VEAV,			// in    [SYNC] vertical eav
	input			EX_VC,				// in    [SYNC] vertical countup
	input			EX_CLK,				// in    [SYNC] video clock

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

	output	[15:0]	ipl_addr,			// out   [CPU] ipl rom address
	input	[7:0]	ipl_rdata,			// in    [CPU] ipl read data
	output	[7:0]	ipl_wdata,			// out   [CPU] dbg : ipl write data
	output			ipl_wr,				// out   [CPU] dbg : ipl write 
	output			ipl_req,			// out   [CPU] ipl req
	input			ipl_ack,			// in    [CPU] ipl ack

	output	[15:0]	z_dbg_addr,			// out   [dbg] addr
	output	[7:0]	z_dbg_rdata,		// out   [dbg] debug : read data
	output	[7:0]	z_dbg_wdata,		// out   [dbg] debug : read data
	output			z_mreq,				// out   [dbg] #mreq
	output			z_ioreq,			// out   [dbg] #ioreq
	output			z_wr,				// out   [dbg] #wr
	output			z_rd,				// out   [dbg] #rd

	output	[19:0]	faddr,				// out   [FDD] flash addr
	output			frd,				// out   [FDD] flash oe
	input	[15:0]	frdata,				// in    [FDD] flash read data

//	output	[15:0]	slot1_addr,			// out   [SLOT1] address
//	output	[7:0]	slot1_wdata,		// out   [SLOT1] wr dara out
//	input	[7:0]	slot1_rdata,		// in    [SLOT1] rd data in
//	output			slot1_mreq_n,		// out   [SLOT1] NA : #mreq=High
//	output			slot1_iorq_n,		// out   [SLOT1] #ioreq
//	output			slot1_rd_n,			// out   [SLOT1] #rd
//	output			slot1_wr_n,			// out   [SLOT1] #wr
//	output			slot1_m1_n,			// out   [SLOT1] #m1
//	output			slot1_halt_n,		// out   [SLOT1] NA : #halt=High
//	output			slot1_clk,			// out   [SLOT1] clk (=4MHz)
//	output			slot1_cke,			// out   [SLOT1] cke (=4MHz)
//	output			slot1_exio,			// out   [SLOT1] cycle active
//	input			slot1_exint_n,		// in    [SLOT1] #exint
//	input			slot1_exwait_n,		// in    [SLOT1] #exwait
//	input			slot1_nmi_n,		// in    [SLOT1] #nmi
//	input			slot1_iei,			// in    [SLOT1] iei
//	output			slot1_ieo,			// out   [SLOT1] ieo
//	input			slot1_valid,		// in    [SLOT1] rd data valid
//	output			slot1_reti,			// out   [SLOT1] z80 reti cycle
//	output			slot1_vect,			// out   [SLOT1] z80 m1-vect cycle
//	output			slot1_clk2,			// out   [SLOT1] clk2 (=2MHz)
//	output			slot1_cke2,			// out   [SLOT1] cke2 (=4MHz)
//	output			slot1_sysclk,		// out   [SLOT1] sysclk (=32MHz)
//	output			slot1_sysckp,		// out   [SLOT1] sysckp (=32MHz)
//	output			slot1_sysckn,		// out   [SLOT1] sysckn (=32MHz)
//	output			slot1_reset_n		// out   [SLOT1] #reset

	input			I_RESET,			// in    [sys] reset
	input			I_CLK32M,			// in    [sys] clk 32MHz(33MHz)

	input	 		I_PS2_CLK,			// in    [sub] ps2 kbd-clk
	input	 		I_PS2_DAT,			// in    [sub] ps2 kbd-dat
	output			O_PS2_CLK_T,		// out   [sub] ps2 kbd-clk oe
	output			O_PS2_DAT_T,		// out   [sub] ps2 kbd-dat oe

	output			O_MMC_CLK,			// out   [mmc] clk / sd-clk
	output			O_MMC_CS,			// out   [mmc] cs / sd-dat3
	output			O_MMC_DOUT,			// out   [mmc] do / sd-cmd
	input			I_MMC_DIN,			// out   [mmc] di / sd-dat
	input			I_MMC_INS,			// out   [mmc] #ins / #sd-ins

	output	[15:0]	PCM_L,				// out   [psg]
	output	[15:0]	PCM_R,				// out   [psg]

	output	[3:0]	O_LED_FDD_RED,		// out   [led]
	output	[3:0]	O_LED_FDD_GREEN,	// out   [led]

	input			I_NMI_n,			// in    [cpu]
	input			I_IPL_n,			// in    [cpu]
	input			I_DEFCHR_SW,		// in    [cpu]

	output			O_LED_POWER,		// out   [led]
	output			O_LED_TIMER,		// out   [led]
	output			O_LED_HIRESO,		// out   [led] turbo
	input	[3:0]	I_DSW,				// in    [sw] turbo
	output			O_LED_ANALOG,		// out   [led] turboz
	input	[1:0]	I_ZDSW,				// in    [sw] turboz

	input	[7:0]	I_JOYA,				// in    [psg]
	input	[7:0]	I_JOYB,				// in    [psg]
	output	[7:0]	O_JOYA,				// out   [psg]
	output	[7:0]	O_JOYB,				// out   [psg]
	output	T_JOYA,						// out   [psg]
	output	T_JOYB,						// out   [psg]

	output	[7:0]	O_VGA_R,			// out   [video] video out red[7:0]
	output	[7:0]	O_VGA_G,			// out   [video] video out grn[7:0]
	output	[7:0]	O_VGA_B,			// out   [video] video out blu[7:0]
	output			O_VGA_HS,			// out   [video] video out hsync
	output			O_VGA_VS,			// out   [video] video out vsync
	output			O_VGA_DE,			// out   [video] video out de/#blank
	output			O_VGA_CLK,			// out   [video] video out clk

	output			O_XCF_CCLK,			// na : xilinx config rom
	output			O_XCF_RESET,		// na : xilinx config rom
	input	 		I_XCF_DIN,			// na : xilinx config rom

//	input			I_FIRMWARE_EN,		// debug

	output	[15:0]	O_DBG_NUM4,			// debug
	output	[3:0]	O_DBG_DOT4,			// debug
	output	[7:0]	O_DBG_LED8,			// debug

	input	I_USART_CLK,				// uart base clock
	input	I_USART_CLKEN16,			// uart x16 clock enable
	input	I_USART_RX,					// uart in
	output	O_USART_TX					// uart out
);

	assign O_LED_POWER=1'b0;
	assign O_LED_TIMER=1'b0;
	assign O_LED_HIRESO=1'b0;
	assign O_LED_ANALOG=1'b0;

/****************************************************************************
  button / switch function
****************************************************************************/

//wire ext_ipl_kill  = 1'b0;
wire ext_trap_en   = 1'b0; // NMI break & boot No-ICE Monitor
wire defchr_enable = (def_X1TURBO==0) ? 1'b1 : ~I_DEFCHR_SW;

/****************************************************************************
  clock generator
****************************************************************************/

/****************************************************************************
  basic clock divider
****************************************************************************/

/****************************************************************************
  system reset signal
****************************************************************************/

/****************************************************************************
  Z80
****************************************************************************/

	wire	sys_clk;
	wire	sys_reset;

	wire	[7:0] fz_data_in;
	wire	[15:0] fz_adr;
	wire	fz_intreq;
	wire	fz_nmireq;
	wire	fz_start;
	wire	fz_mreq;
	wire	fz_iorq;
	wire	fz_rd;
	wire	fz_wr;
	wire	[7:0] fz_data_out;
	wire	fz_m1;
	wire	[15:0] fz_radr;
	wire	fz_intack;
	wire	fz_nmiack;
	wire	fz_waitreq;
	wire	fz_reset_req;

fz80 fz80(
	.data_in(fz_data_in[7:0]),
	.reset_in(fz_reset_req),
	.clk(sys_clk),
	.adr(fz_adr[15:0]),
	.intreq(fz_intreq),
	.nmireq(fz_nmireq),
	.busreq(1'b0),
	.start(fz_start),
	.mreq(fz_mreq),
	.iorq(fz_iorq),
	.rd(fz_rd),
	.wr(fz_wr),
	.data_out(fz_data_out[7:0]),
	.busack_out(),
	.intack_out(fz_intack),
	.mr(),
	.m1(fz_m1),
//	.halt(fz_halt),
	.radr(fz_radr[15:0]),
	.nmiack_out(fz_nmiack),
	.waitreq(fz_waitreq)
);

	wire	z_int_n;
	wire	z_nmi_n;
	wire	z_clk;
	wire	z_cke;
	wire	z_clk2;
	wire	z_cke2;
	wire	z_ckp;
	wire	z_ckn;
	wire	[15:0] z_addr;
	wire	[7:0] z_wdata;
	wire	[7:0] z_rdata;
	wire	z_wait_n;
	wire	z_iorq_n;
	wire	z_rd_n;
	wire	z_wr_n;
	wire	z_m1_n;
	wire	z_vect;
	wire	z_reti;
	wire	z_reset_n;

	assign sys_clk=I_CLK32M;
	assign sys_reset=I_RESET;
	assign z_reset_n=!fz_reset_req;

nx1_mode #(
	.def_work_sram(def_work_sram),		// main memory sdr / syncram
	.def_MBASE(def_MBASE),	// main memory base address
	.def_BBASE(def_BBASE),	// bank memory base address
	.def_VBASE(def_VBASE)	// video base address
) mode (
	.mem_cmd_en(mem_cmd_en),						// out   [MEM] cmd en
	.mem_cmd_instr(mem_cmd_instr[2:0]),				// out   [MEM] cmd inst[2:0]
	.mem_cmd_bl(mem_cmd_bl[5:0]),					// out   [MEM] cmd blen[5:0]
	.mem_cmd_byte_addr(mem_cmd_byte_addr[29:0]),	// out   [MEM] cmd addr[29:0]
	.mem_cmd_empty(mem_cmd_empty),					// in    [MEM] cmd empt
	.mem_cmd_full(mem_cmd_full),					// in    [MEM] cmd full
	.mem_wr_en(mem_wr_en),							// out   [MEM] wr en
	.mem_wr_mask(mem_wr_mask[3:0]),					// out   [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// out   [MEM] wr wdata[31:0]
	.mem_wr_full(mem_wr_full),						// in    [MEM] wr full
	.mem_wr_empty(mem_wr_empty),					// in    [MEM] wr empt
	.mem_wr_count(mem_wr_count[6:0]),				// in    [MEM] wr count[6:0]
	.mem_wr_underrun(mem_wr_underrun),				// in    [MEM] wr over
	.mem_wr_error(mem_wr_error),					// in    [MEM] wr err
	.mem_rd_en(mem_rd_en),							// out   [MEM] rd en
	.mem_rd_data(mem_rd_data[31:0]),				// in    [MEM] rd rdata[31:0]
	.mem_rd_full(mem_rd_full),						// in    [MEM] rd full
	.mem_rd_empty(mem_rd_empty),					// in    [MEM] rd empt
	.mem_rd_count(mem_rd_count[6:0]),				// in    [MEM] rd count[6:0]
	.mem_rd_overflow(mem_rd_overflow),				// in    [MEM] rd over
	.mem_rd_error(mem_rd_error),					// in    [MEM] rd err

	.mem_init_done(vram_init_done),					// in    [MEM] init_done

	.ipl_addr(ipl_addr[15:0]),						// out   [CPU] ipl rom address
	.ipl_rdata(ipl_rdata[7:0]),						// in    [CPU] ipl read data
	.ipl_wdata(ipl_wdata[7:0]),						// out   [CPU] dbg : ipl writre data
	.ipl_wr(ipl_wr),								// out   [CPU] dbg : ipl writre
	.ipl_req(ipl_req),								// out   [CPU] 
	.ipl_ack(ipl_ack),								// in    [CPU] 

	.fz_clk(sys_clk),								// in    [MEM] clk
	.fz_rst_n(!sys_reset),							// in    [MEM] #reset

	.fz_int_req(fz_intreq),							// out   [CPU] 
	.fz_nmi_req(fz_nmireq),							// out   [CPU] 
	.fz_int_ack(fz_intack),							// in    [CPU] 
	.fz_nmi_ack(fz_nmiack),							// in    [CPU] 
	.fz_reset_req(fz_reset_req),					// out   [CPU] 
	.fz_wait(fz_waitreq),
	.fz_start(fz_start),							// in    [FZ] start in
	.fz_addr(fz_adr[15:0]),
	.fz_wdata(fz_data_out[7:0]),
	.fz_rdata(fz_data_in[7:0]),
	.fz_m1(fz_m1),
	.fz_rd(fz_rd),
	.fz_wr(fz_wr),
	.fz_mreq(fz_mreq),
	.fz_ioreq(fz_iorq),

	.cz_bank(6'b100000),
	.cz_ipl(),
	.cz_multiplane(),

	.z_int_n(z_int_n),								// in    [Z80]
	.z_nmi_n(z_nmi_n),								// in    [Z80]
	.z_clk(z_clk),									// out   [Z80] 
	.z_cke(z_cke),									// out   [Z80] 
	.z_clk2(z_clk2),								// out   [Z80] 
	.z_cke2(z_cke2),								// out   [Z80] 
	.z_ckp(z_ckp),									// out   [Z80] 
	.z_ckn(z_ckn),									// out   [Z80] 
	.z_addr(z_addr[15:0]),							// out   [Z80] 
	.z_wdata(z_wdata[7:0]),							// out   [Z80] 
	.z_rdata(z_addr[7:0]),							// in    [Z80] 
	.z_wait_n(z_wait_n),							// in    [Z80] 
	.z_iorq_n(z_iorq_n),							// out   [Z80] 
	.z_rd_n(z_rd_n),								// out   [Z80] 
	.z_wr_n(z_wr_n),								// out   [Z80] 
	.z_m1_n(z_m1_n),								// out   [Z80] 
	.z_vect(z_vect),								// out   [Z80] 
	.z_reti(z_reti)									// out   [Z80] 
);

	wire	cg_wait_n;

	assign z_nmi_n = I_NMI_n;

/****************************************************************************
  Z80 daisychain INT
****************************************************************************/

//`ifdef X1TURBO
wire slot1_int_n , slot1_iei , slot1_ieo;
wire slot2_int_n , slot2_iei , slot2_ieo;
wire sio_int_n   , sio_iei   , sio_ieo;
wire dma_int_n   , dma_iei   , dma_ieo;
wire ctc_int_n   , ctc_iei   , ctc_ieo;
wire sub_int_n   , sub_iei;

// DUMMY
assign slot1_int_n = 1'b1;
assign slot1_ieo   = 1'b1;
assign slot2_int_n = 1'b1;
assign slot2_ieo   = 1'b1;
assign sio_int_n   = 1'b1;
assign sio_ieo     = 1'b1;

// daisychain
assign slot2_iei = slot1_ieo;
assign sio_iei = slot2_ieo;
assign dma_iei = sio_ieo;
assign ctc_iei = dma_ieo;
assign sub_iei = (def_X1TURBO==1'b0) ? 1'b1 : ctc_ieo;

// wired or

	assign z_int_n  = (def_X1TURBO==1'b0) ? sub_int_n : slot1_int_n & slot2_int_n & sio_int_n & dma_int_n & ctc_int_n & sub_int_n;

//`else // X1
//assign sub_iei = 1'b1;
//assign ZINT_n  = sub_int_n;
//`endif

/****************************************************************************
  system bus MUX
  master
  Z80DMA  (with RFSH hack access for FDD data)
  Z80 CPU (with Z80 DEBUGGER)
****************************************************************************/

/****************************************************************************
  Z80 interruput support signal
****************************************************************************/

/****************************************************************************
  Address Decoder
****************************************************************************/

wire [3:0]  dma_bank;
wire [15:0] dma_a;
wire [7:0] dma_do,dma_di;
wire dma_mreq_n,dma_iorq_n,dma_rd_n,dma_wr_n;
wire dma_sel;

//wire ipl_enable;
//wire dam_enable;

wire ipl_sel;
wire dam;

// chip selects
wire emm_cs;
wire exrom_cs;
wire kanrom_cs;
wire fd5_cs;
wire pal_cs;
wire cg_cs;
wire crtc_cs;
wire sub_cs;
wire pia_cs;
wire psg_cs;
wire attr_cs;
wire text_cs;
//`ifdef FM_BOARD
wire fm_cs;
wire fm_ctc_cs;
//`endif
//`ifdef X1TURBO
wire ktext_cs;
wire bmem_cs;
wire dma_cs;
wire sio_cs;
wire ctc_cs;
wire p1fd0_cs;
wire black_cs;
wire dipsw_cs;
//`endif

//assign ipl_enable = ~debug_mode & ~ext_ipl_kill & ZRFSH_n;
//assign dam_enable = ~debug_mode;

nx1_adec #(
	.def_X1TURBO(def_X1TURBO),		// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
	.def_FDC(1),					// onboard fdc
	.def_FM_BOARD(def_FM_BOARD)		// YM2151 FM sound board (not supported yet)
) nx1_adec (
  .I_RESET(!z_reset_n),
  .I_CLK(sys_clk),
  .I_A(z_addr[15:0]),
  .I_MREQ_n(1'b1),.I_IORQ_n(z_iorq_n),.I_RD_n(z_rd_n),.I_WR_n(z_wr_n),
// mode / switch
  .I_IPL_SEL(1'b0),// & ipl_enable),
  .I_DAM(1'b0),// & dam_enable),
  .I_DEFCHR(defchr_enable),
// memory
  .O_IPL_CS(),.O_RAM_CS(),
// chip select
  .O_EMM_CS(emm_cs),
  .O_EXTROM_CS(exrom_cs),
  .O_KANROM_CS(kanrom_cs),
  .O_FD5_CS(fd5_cs),
  .O_PAL_CS(pal_cs),
  .O_CG_CS(cg_cs),
  .O_CRTC_CS(crtc_cs),
  .O_SUB_CS(sub_cs),
  .O_PIA_CS(pia_cs),
  .O_PSG_CS(psg_cs),
  .O_IPL_SET_CS(),
  .O_IPL_RES_CS(),
// VRAM
  .O_ATTR_CS(attr_cs),.O_TEXT_CS(text_cs),
  .O_GRB_CS(),.O_GRR_CS(),.O_GRG_CS(),
// option board
//`ifdef FM_BOARD
  .O_FM_CS(fm_cs),.O_FMCTC_CS(fm_ctc_cs),
//`endif
// X1turbo adittional
//`ifdef X1TURBO
  .O_HDD_CS(),
  .O_FD8_CS(),
  .O_BMEM_CS(bmem_cs),
  .O_DMA_CS(dma_cs),
  .O_SIO_CS(sio_cs),
  .O_CTC_CS(ctc_cs),
  .O_P1FDX_CS(p1fd0_cs),
  .O_BLACK_CS(black_cs),
  .O_DIPSW_CS(dipsw_cs),
  .O_KANJI_CS(ktext_cs),
//`endif
// DOUJI access mode clear
  .O_DAM_CLR()
);

// subcpu debug download mode
//wire firm_en = 1'b0;//I_FIRMWARE_EN;
//wire firm_cs = firm_en & ~ZMREQ_n;

// data input
wire [7:0] exrom_dr;  // external ROM
wire [7:0] sub_rd;    // subcpu RD / 5'FDD
wire [7:0] text_rd;   // text VRAM
wire [7:0] attr_rd;   // attribute VRAM
wire [7:0] cg_mux_dr; // CG / PSG
wire [7:0] pia_dr;    // PIA8255
wire [7:0] psg_dr;    // PSG (JOYSTICK)

wire [7:0] ctc_rd;    // Z80 CTC
wire ctc_doe;
wire [7:0] fm_rd;   // YM2151
wire [7:0] dma_rd;    // Z80 DMAC
wire [7:0] sio_rd;    // Z80 SIO
wire [7:0] ktext_rd;  // KANJI VRAM

	wire	fd5_wait_n;
	wire	[7:0] fd5_rdata;

wire dma_doe = 1'b0;
wire sio_doe = 1'b0;

// address decoder
wire sub_doe;
wire sram_doe = 1'b0;

//	localparam busfree=8'h00;	// or tie
	localparam busfree=8'hff;	// and tie

assign z_wait_n  = cg_wait_n & fd5_wait_n;

assign z_rdata    =
	fd5_cs ? fd5_rdata :
  ctc_doe   ? ctc_rd  :
  dma_doe   ? dma_rd  :
  sio_doe   ? sio_rd  :
  sub_doe   ? sub_rd  :
  cg_cs     ? cg_mux_dr :
  pia_cs    ? pia_dr  :
  psg_cs    ? psg_dr  :
  exrom_cs    ? exrom_dr :
  text_cs   ? text_rd :
  attr_cs   ? attr_rd :
  ktext_cs    ? ktext_rd :
  fm_cs     ? fm_rd :
  8'hff;


n8877 #(
	.def_wp(4'b1111),
	.busfree(busfree)
) fdc8877 (
	.faddr(faddr[19:0]),			// out   [MEM] addr
	.frd(frd),						// out   [MEM] rd req
	.frdata(frdata[15:0]),			// in    [MEM] read data

	.addr(z_addr[2:0]),
	.wdata(z_wdata[7:0]),
	.rdata(fd5_rdata[7:0]),
	.wr(!z_wr_n),
//	input			req,
//	output			ack,

	.cs(({fd5_cs,z_wr_n}==2'b10) | ({fd5_cs,z_rd_n}==2'b10)),
	.wait_n(fd5_wait_n),

	.rst_n(z_reset_n),
	.clk(sys_clk)
);


/****************************************************************************
  SUB CPU
****************************************************************************/
wire sub_tx_bsy;
wire sub_rx_bsy;
wire key_brk_n;

wire [15:0] num_7seg;
wire [3:0]  dot_7seg;

// JOYSTICK EMULATION
wire [7:0] joy_ea,joy_eb;

// FDC emulation
wire fd5_drq;
// FD physical emulation
wire [3:0] fd5_lamp;
wire [7:0] pcm_out; // SEEK SOUND

// TimerTimming port;
wire clk1;   // for text Blink

// firmware download
wire sub_reset = !z_reset_n;// | firm_en;

// DMA / fdd emu
assign dma_sel = 1'b0;//(~ZRFSH_n | ~ZBUSAK_n) & ~firm_en;

nx1_sub #(
	.RAM_DEPTH(11),
	.JOY_EMU(0),
	.def_DEVICE(def_DEVICE)				// 0=Xilinx , 1=Altera
) x1_sub (
  .I_reset(sub_reset),
// SUBCPU (DMAC) basic clock
  .I_clk(sys_clk),
// Z80 system bus
  .I_cs(sub_cs),
  .I_rd(~z_rd_n),
  .I_wr(~z_wr_n),
  .I_M1_n(1'b1),
  .I_D(z_wdata[7:0]),
  .O_D(sub_rd[7:0]),
  .O_DOE(sub_doe),
// handshake
  .O_TX_BSY(sub_tx_bsy),
  .O_RX_BSY(sub_rx_bsy),
  .O_KEY_BRK_n(key_brk_n),
// subcpu int controll
  .I_SPM1(z_vect),
  .I_RETI(z_reti),
  .I_IEI(sub_iei),
  .O_INT_n(sub_int_n),
// SUBCPU Firmware Access Port
  .I_fa(z_addr[12:0]),
  .I_fcs(1'b0),//firm_cs),
// FD emulation
  .O_FDC_DRQ_n(fd5_drq),
  .I_FDCS(1'b0),//fd5_cs),
  .I_RFSH_n(1'b1),//ZRFSH_n),
  .I_RFSH_STB_n(1'b1),//H_MREQ_n),
//
  .I_DMA_CS(1'b0),//dma_cs),
  .O_DMA_BANK(dma_bank),
  .O_DMA_A(dma_a),
  .I_DMA_D(7'b0),//dma_di),
  .O_DMA_D(dma_do),
  .O_DMA_MREQ_n(dma_mreq_n),
  .O_DMA_IORQ_n(dma_iorq_n),
  .O_DMA_RD_n(dma_rd_n),
  .O_DMA_WR_n(dma_wr_n),
  .O_DMA_BUSRQ_n(),//ZBUSRQ_n),
  .I_DMA_BUSAK_n(1'b1),//ZBUSAK_n),
  .I_DMA_RDY(1'b0),//fd5_drq),
  .I_DMA_WAIT_n(1'b0),//ZWAIT_n),
  .I_DMA_IEI(dma_iei),
  .O_DMA_INT_n(dma_int_n),
  .O_DMA_IEO(dma_ieo),
//
  .O_FD_LAMP(fd5_lamp),
// PCM SOUND
  .O_PCM(pcm_out),
// debug monitor
  .num_7seg(O_DBG_NUM4),
  .dot_7seg(O_DBG_DOT4),
// PS2 KeyPort
  .I_PS2C(I_PS2_CLK),
  .I_PS2D(I_PS2_DAT),
  .O_PS2CT(O_PS2_CLK_T),
  .O_PS2DT(O_PS2_DAT_T),
// TEXT Blick clock
  .O_clk1(clk1),
// JOY EMU
  .O_JOY_A(joy_ea),
  .O_JOY_B(joy_eb)
);

// Front Panel
assign O_LED_FDD_RED = fd5_lamp;
assign O_LED_FDD_GREEN = 4'b0000;

/****************************************************************************
  8255 PIA
****************************************************************************/
wire [7:0] lpt_data;
wire vblank_n; // with latch ~RA0
wire vsync , hsync;
wire lpt_rdy = 1'b0;
wire cmt_read = 1'b0;

	wire	[7:0] pia_a; // printer output data;
	wire	[7:0] pia_b;
	wire	[7:0] pia_c;

	assign pia_b[7:0]=(def_X1TURBO==0) ? {vblank_n,sub_tx_bsy,sub_rx_bsy,1'b1,lpt_rdy,vsync,cmt_read,key_brk_n} : {vblank_n,sub_tx_bsy,sub_rx_bsy,ipl_sel,lpt_rdy,vsync,cmt_read,key_brk_n};

wire lpt_stb   = pia_c[7];
wire width40   = pia_c[6];
wire dam_en_n  = pia_c[5]; // DOUJI ACCESS fall trigger
wire sm_scrl_n = pia_c[4]; // smooth scroll (L)

/*
//PIA8255 pia(
nx1_8255 pia(
  .I_RESET(!z_reset_n),
  .I_A(z_addr[1:0]),
  .I_CS(pia_cs),
  .I_RD(~z_rd_n),
  .I_WR(~z_wr_n),
  .I_D(z_wdata),
  .O_D(pia_dr),
//
  .I_PA(8'h00), .O_PA(pia_a),
//
  .I_PB(pia_b), .O_PB(),
//
  .I_PC(8'h00), .O_PC(pia_c)
);
*/

n8255 #(
	.busfree(busfree)
) pia (
	.CLK(z_clk),			// in    [CPU] clk
	.CKE(z_cke),			// in    [CPU] cke
	.RESET(!z_reset_n),		// in    [CPU] reset
	.ADDR(z_addr[1:0]),		// in    [CPU] addr[1:0]
	.WR(!z_wr_n),			// in    [CPU] wr
	.WDATA(z_wdata[7:0]),	// in    [CPU] write data
	.RDATA(pia_dr[7:0]),	// out   [CPU] read data
	.CS(pia_cs),			// in    [CPU] cs

	.PA_IN(8'b0),			// in    [PPI] na
	.PB_IN(pia_b[7:0]),		// in    [PPI] -- 
	.PC_IN(8'b0),			// in    [PPI] na
	.PA_OUT(pia_a[7:0]),	// out   [PPI] -- printer data --
	.PB_OUT(),				// out   [PPI] na
	.PC_OUT(pia_c[7:0])		// out   [PPI] -- 
);

/****************************************************************************
  JOY STICK MUX
****************************************************************************/
wire [7:0] joy_mux_a , joy_mux_b;

assign joy_mux_a = I_JOYA;//joy_ea & I_JOYA;
assign joy_mux_b = I_JOYB;//joy_eb & I_JOYB;

assign O_JOYA = 8'hff;
assign O_JOYB = 8'hff;
assign T_JOYA = 1'b1;
assign T_JOYB = 1'b1;

/****************************************************************************
  AY-3-8910
****************************************************************************/

wire [7:0] PSG_OUT;

wire [9:0] PSG_OUT_A,PSG_OUT_B,PSG_OUT_C;

ay8910 PSG(
  .rst_n(z_reset_n),
  .clk(z_clk2),
  .clken(1'b1),
  .asel(~z_addr[8]),
  .cs_n(~psg_cs),
  .direct_sel(0),
  .wr_n(z_wr_n),
  .rd_n(z_rd_n),
  .di(z_wdata[7:0]),
  .do(psg_dr),
  .A(PSG_OUT_A) ,
  .B(PSG_OUT_B) ,
  .C(PSG_OUT_C) ,
  .pa_i(joy_mux_a) ,
  .pb_i(joy_mux_b) ,
  .pa_o() ,
  .pa_t() ,
  .pb_o() ,
  .pb_t()
);

wire [11:0] PSG_MIX = PSG_OUT_A + PSG_OUT_B + PSG_OUT_C + {pcm_out,2'b00};
assign PCM_L = {PSG_MIX,4'b0000};
assign PCM_R = {PSG_MIX,4'b0000};

/****************************************************************************
  mode swithes
****************************************************************************/

/****************************************************************************
  X1turbo mode swithes
****************************************************************************/
wire hireso;
wire line400;
wire text12;
wire gram_rp;
wire gram_wp;
wire pcg_mode;
wire cg16;
wire udline;
wire [2:0] black_col;
wire txt_black;
wire gr0_black;
wire gr1_black;
wire blk_black;

wire [7:0] x1tm_rd;
wire x1tm_doe;

nx1_tmode #(
	.def_X1TURBO(def_X1TURBO)		// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
) x1t_mode (
  .I_RESET(!z_reset_n),
  .CLK(z_clk),
  .I_D(z_wdata),
  .O_D(x1tm_rd),
  .O_DOE(x1tm_doe),
  .I_WR(~z_wr_n),
  .I_RD(~z_rd_n),
  .I_P1FD0_CS(p1fd0_cs),
  .I_P1FE0_CS(black_cs),
  .O_HIRESO(hireso),
  .O_LINE400(line400),
  .O_TEXT12(text12),
  .O_GRAM_RP(gram_rp),
  .O_GRAM_WP(gram_wp),
  .O_PCG_TURBO(pcg_mode),
  .O_CG16(cg16),
  .O_UDLINE(udline),
  .O_BLACK_COL(black_col),
  .O_TXT_BLACK(txt_black),
  .O_GR0_BLACK(gr0_black),
  .O_GR1_BLACK(gr1_black),
  .O_BLK_BLACK(blk_black)
);

/****************************************************************************
  VIDEO circuit
****************************************************************************/

wire vid_re;
wire [7:0] vid_dr;

wire vwait;

	wire	dbg_text_cs;
	wire	[15:0] dbg_addr;

	wire	[7:0] red;
	wire	[7:0] green;
	wire	[7:0] blue;

	assign z_dbg_addr[15:0]=z_addr[15:0];
	assign z_dbg_rdata[7:0]=z_rdata[7:0];
	assign z_dbg_wdata[7:0]=z_wdata[7:0];
	assign z_mreq=1'b0;
	assign z_ioreq=!z_iorq_n;
	assign z_wr=!z_wr_n;
	assign z_rd=!z_rd_n;

	assign dbg_addr[15:0]=z_addr[15:0];
		//	(DEBUG==0) ? z_addr[15:0] :
		//	(DEBUG==1) & (text_cs==1'b1) ? z_addr[15:0] :
		//	(DEBUG==1) & (text_cs==1'b0) ? {8'b0,z_addr[7:0]} :
		//	16'b0;

	assign dbg_text_cs=text_cs;
		//	(DEBUG==0) & (text_cs==1'b1) ? 1'b1 :
		//	(DEBUG==1) & (text_cs==1'b1) ? 1'b1 :
		//	(DEBUG==1) & (text_cs==1'b0) & (z_mreq==1'b1) & (z_wr==1'b1) & (z_addr[15:8]==8'hfe) ? 1'b1 :
		//	1'b0;

nx1_vid #(
	.busfree(busfree),				// idle busdata
	.def_DEVICE(def_DEVICE),		// 0=Xilinx , 1=Altera
	.def_X1TURBO(def_X1TURBO),		// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
	.def_VBASE(def_VBASE),			// video base address
	.SIM_FAST(SIM_FAST),			// fast simulation
	.DEBUG(DEBUG)					// 
) nx1_vid (

	.EX_HS(EX_HS),				// in    [SYNC] horizontal sync
	.EX_VS(EX_VS),				// in    [SYNC] vertical sync
	.EX_DE(EX_DE),				// in    [SYNC] disp/#blank
	.EX_HDISP(EX_HDISP),		// in    [SYNC] horizontal disp
	.EX_VDISP(EX_VDISP),		// in    [SYNC] vertical disp
	.EX_HBP(EX_HBP),			// in    [SYNC] horizontal backporch
	.EX_HWSAV(EX_HWSAV),		// in    [SYNC] horizontal window sav
	.EX_HSAV(EX_HSAV),			// in    [SYNC] horizontal sav
	.EX_HEAV(EX_HEAV),			// in    [SYNC] horizontal eav
	.EX_HC(EX_HC),				// in    [SYNC] horizontal countup
	.EX_VWSAV(EX_VWSAV),		// in    [SYNC] vertical window sav
	.EX_VSAV(EX_VSAV),			// in    [SYNC] vertical sav
	.EX_VEAV(EX_VEAV),			// in    [SYNC] vertical eav
	.EX_VC(EX_VC),				// in    [SYNC] vertical countup

	.vram_clk(vram_clk),							// in    [VRAM] clk
	.vram_init_done(vram_init_done),				// in    [VRAM] init done
	.vram_cmd_en(vram_cmd_en),						// out   [VRAM] cmd en
	.vram_cmd_instr(vram_cmd_instr[2:0]),			// out   [VRAM] cmd inst[2:0]
	.vram_cmd_bl(vram_cmd_bl[5:0]),					// out   [VRAM] cmd blen[5:0]
	.vram_cmd_byte_addr(vram_cmd_byte_addr[29:0]),	// out   [VRAM] cmd addr[29:0]
	.vram_cmd_empty(vram_cmd_empty),				// in    [VRAM] cmd empt
	.vram_cmd_full(vram_cmd_full),					// in    [VRAM] cmd full
	.vram_rd_en(vram_rd_en),						// out   [VRAM] rd en
	.vram_rd_data(vram_rd_data[31:0]),				// in    [VRAM] rd rdata[31:0]
	.vram_rd_full(vram_rd_full),					// in    [VRAM] rd full
	.vram_rd_empty(vram_rd_empty),					// in    [VRAM] rd empt
	.vram_rd_count(vram_rd_count[6:0]),				// in    [VRAM] rd count[6:0]
	.vram_rd_overflow(vram_rd_overflow),			// in    [VRAM] rd over
	.vram_rd_error(vram_rd_error),					// in    [VRAM] rd err

	.I_RESET(!z_reset_n),
	.I_CCLK(sys_clk),//z_clk),
	.I_CCKE(z_cke & z_ckp),//z_clk),
  .I_A(dbg_addr),
  .I_D(z_wdata),
  .O_D(vid_dr),
  .O_DE(vid_re),
  .I_WR(~z_wr_n),
  .I_RD(~z_rd_n),
  .O_VWAIT(vwait),
  .defchr_enable(defchr_enable),
  .I_CRTC_CS(crtc_cs),
  .I_CG_CS(cg_cs),
  .I_PAL_CS(pal_cs),
  .I_TXT_CS(dbg_text_cs), .I_ATT_CS(attr_cs), .I_KAN_CS(ktext_cs),
  .I_VCLK(EX_CLK),  .I_CLK1(clk1),
  .I_W40(width40),
  .I_HIRESO(hireso),
  .I_LINE400(line400),
  .I_TEXT12(text12),
  .I_PCG_TURBO(pcg_mode),
  .I_CG16(cg16),
  .I_UDLINE(udline),
  .I_BLACK_COL(black_col),
  .I_TXT_BLACK(txt_black),
  .I_GR0_BLACK(gr0_black),
  .I_GR1_BLACK(gr1_black),
  .I_BLK_BLACK(blk_black),
	.text_rdata(text_rd),
	.attr_rdata(attr_rd),
	.ktext_rdata(ktext_rd),

	.cg_rdata(cg_mux_dr),

	.v_red(O_VGA_R),
	.v_grn(O_VGA_G),
	.v_blu(O_VGA_B),
	.v_hs(O_VGA_HS),
	.v_vs(O_VGA_VS),
	.v_de(O_VGA_DE),
	.v_whs(),
	.v_wvs(),
	.v_wde(),

	.O_R()  ,
	.O_G()   ,
	.O_B(),
	.O_HSYNC() ,
	.O_VSYNC(),
	.O_VDISP(vblank_n)
);

//`ifdef X1TURBO
/****************************************************************************
  X1turbo hard sync PCG set wait controll
****************************************************************************/
//assign pcg_wait_n = ~(~hsync & pcg_mode & cg_cs);
//`else
//assign pcg_wait_n = 1'b1;//1'b0;
//`endif

	assign pcg_wait_n=(def_X1TURBO==0) ? 1'b1 : ~(~hsync & pcg_mode & cg_cs);

/****************************************************************************
  X1 soft sync PCG wait TRAP
****************************************************************************/

assign cg_wait_n = pcg_wait_n;

//`ifdef Z80_CTC
/****************************************************************************
  Z80 CTC (turbo / FM board)
****************************************************************************/

//`ifdef X1TURBO
//wire z80ctc_cs = ctc_cs;    // HIGH priority
//`else
//wire z80ctc_cs = fm_ctc_cs;   // LOW priority
//`endif

	wire	z80ctc_cs;

	assign z80ctc_cs=ctc_cs;

wire [3:0] ctc_to;
wire [3:0] ctc_ti;

assign ctc_ti[0] = 1'b1;
assign ctc_ti[1] = z_clk2;
assign ctc_ti[2] = z_clk2;
assign ctc_ti[3]   = ctc_to[0]; // Ch0 -> CH3 chain

z80ctc z80ctc(
  .I_RESET(!z_reset_n),
  .I_CLK(z_clk),
  .I_CLKEN(1'b1),
  .I_A(z_addr[1:0]),
  .I_D(z_wdata),
  .O_D(ctc_rd),
  .O_DOE(ctc_doe),
  .I_CS_n(~z80ctc_cs),
  .I_WR_n(z_wr_n),
  .I_RD_n(z_rd_n),
  .I_M1_n(z_m1_n),
// irq handling
  .I_SPM1(z_vect),
  .I_RETI(z_reti),
  .I_IEI(ctc_iei),
  .O_IEO(ctc_ieo),
  .O_INT_n(ctc_int_n),
//
  .I_TI(ctc_ti),
  .O_TO(ctc_to)
);
//`endif

/****************************************************************************
  FM sound board (YM2151)
****************************************************************************/
//`ifdef FM_BOARD
assign fm_rd = (def_FM_BOARD==0) ? 8'b0 : 8'h03; // YM2151 , DUMMY STATUS
//`endif

/****************************************************************************
  Z80SIO
****************************************************************************/
//`ifdef X1TURBO
assign sio_rd = (def_X1TURBO==0) ? 8'b0 : 8'h00;
//`endif

/****************************************************************************
  Z80DMA
****************************************************************************/
//`ifdef X1TURBO
assign dma_rd = 8'h00;
//`endif

/****************************************************************************
  SPI I/F
****************************************************************************/

// I_MMC_DIN
	reg		spi_clk;
	reg		[1:0] spi_cs;
	reg		[3:0] spi_cnt;
	reg		[7:0] spi_sreg;
	reg		spi_do;
	wire	spi_din;
	wire	[2:0] spi_in;

//wire spi_din = (spi_cs[1] & I_MMC_DIN) | (I_XCF_DIN & spi_cs[0]);	// na

	assign spi_din=(spi_cs[1]==1'b1) ? I_MMC_DIN : 1'b0;

always @(posedge sys_clk or negedge z_reset_n)
begin
  if(~z_reset_n)
  begin
  spi_clk  <= 1'b0;
  spi_cs   <= 2'b00;
  spi_cnt  <= 4'b0000;
  spi_sreg <= 8'h00;
  spi_do   <= 1'b0;
  end else begin
   if(~spi_clk)
     spi_do <= z_wdata[0];

  // cs access
  if(exrom_cs & ~z_wr_n)
  begin
    spi_cnt  <= z_addr[3:0];
    spi_cs   <= z_addr[5:4];
    if(~z_addr[6])
    begin
    spi_sreg <= z_wdata[7:0];
    end
  end else begin
    if(spi_cnt != 0)
    begin
    // flip clock
    spi_clk <= ~spi_clk;
    // shift in
    if(~spi_clk)
      spi_sreg <= {spi_din,spi_sreg[7:1]}; // LSB first in
    // bit count ,output change
    if(spi_clk)
      spi_cnt <= spi_cnt - 1;
    end
  end
  end
end

//// XCF Config-ROM
//assign O_XCF_RESET =  spi_cs[0];
//assign O_XCF_CCLK  =  spi_clk;

	assign O_XCF_RESET=1'b0;	// na
	assign O_XCF_CCLK=1'b0;		// na

// MMC
assign O_MMC_CS   = ~spi_cs[1];
assign O_MMC_CLK  =  spi_clk;
assign O_MMC_DOUT =  spi_do;

// Read Shift Register
assign exrom_dr    = spi_sreg;

endmodule
