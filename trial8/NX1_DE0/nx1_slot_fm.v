//------------------------------------------------------------------------------
//
//	nx1_slot_fm.v : ese x1 fm board top module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/dec/28 release 0.0  
//
//------------------------------------------------------------------------------

module nx1_slot_fm #(
	parameter	def_DEVICE=0			// 0=Xilinx sp3, 1=Altera c3
) (
	output	[15:0]	pcm_lch,			// out   [OPTION] pcm left
	output	[15:0]	pcm_rch,			// out   [OPTION] pcm right
	output			pcm_load,			// out   [OPTION] pcm load

	input	[15:0]	slot_addr,			// in    [SLOT1] address
	input	[7:0]	slot_wdata,			// in    [SLOT1] wr dara
	output	[7:0]	slot_rdata,			// out   [SLOT1] rd data
	input			slot_mreq_n,		// in    [SLOT1] #mreq
	input			slot_ioreq_n,		// in    [SLOT1] #ioreq
	input			slot_rd_n,			// in    [SLOT1] #rd
	input			slot_wr_n,			// in    [SLOT1] #wr
	input			slot_m1_n,			// in    [SLOT1] #m1
	input			slot_halt_n,		// in    [SLOT1] #halt
	input			slot_clk,			// in    [SLOT1] clk
	input			slot_exio,			// in    [SLOT1] cycle active
	output			slot_exint_n,		// out   [SLOT1] #exint
	output			slot_exwait_n,		// out   [SLOT1] #exwait
	output			slot_nmi_n,			// out   [SLOT1] #nmi
	output			slot_iei,			// out   [SLOT1] iei
	input			slot_ieo,			// in    [SLOT1] ieo
	output			slot_valid,			// out   [SLOT1] rd data valid
	output			slot_fastcycle,		// out   [SLOT1] fast cycle active
	input			slot_cyc_reti,		// in    [SLOT1] z80 reti cycle
	input			slot_cyc_vect,		// in    [SLOT1] z80 m1-vect cycle
	input			slot_sysclk,		// in    [SLOT1] sysclk (=32MHz)
	input			slot_syscke,		// in    [SLOT1] syscke (=zcke)
	input			slot_reset_n		// in    [SLOT1] #reset
);

	wire	ctc_cs;
	wire	[7:0] ctc_rdata;
	wire	ctc_doe;
	wire	fm_cs;
	wire	[7:0] fm_rdata;
	wire	fm_doe;

	assign fm_cs=(slot_exio==1'b1) & (slot_ioreq_n==1'b0) & (slot_addr[12:8]==5'h07) & (slot_addr[2]==1'b0) ? 1'b1 : 1'b0;	// 0700-0703
	assign ctc_cs=(slot_exio==1'b1) & (slot_ioreq_n==1'b0) & (slot_addr[12:8]==5'h07) & (slot_addr[2]==1'b1) ? 1'b1 : 1'b0;	// 0704-0707

	assign fm_doe=(fm_cs==1'b1) & (slot_rd_n==1'b0) ? 1'b1 : 1'b0;

	assign slot_rdata[7:0]=
			(fm_cs==1'b1) ? fm_rdata[7:0] :
			(ctc_cs==1'b1) ? ctc_rdata[7:0] :
			8'b0;
	assign slot_exwait_n=1'b1;
	assign slot_nmi_n=1'b1;
	assgin slot_valid=({fm_doe,ctc_doe}==2'b00) ? 1'b0 : 1'b1;

/****************************************************************************
  Z80 CTC (turbo / FM board)
****************************************************************************/

	wire	[3:0] ctc_to;
	wire	[3:0] ctc_ti;

	assign ctc_ti[0]=1'b1;
	assign ctc_ti[1]=clk2M;
	assign ctc_ti[2]=clk2M;
	assign ctc_ti[3]=ctc_to[0]; // Ch0 -> CH3 chain

z80ctc zctc(
	.I_RESET(!slot_reset_n),
	.I_CLK(slot_clk),	//slot_sysclk),
	.I_CLKEN(1'b1),	//slot_syscke),
	.I_A(slot_addr[1:0]),
	.I_D(slot_wdata[7:0]),
	.O_D(ctc_rdata[7:0]),
	.O_DOE(ctc_doe),
	.I_CS_n(!ctc_cs),
	.I_WR_n(slot_wr_n),
	.I_RD_n(slot_rd_n),
	.I_M1_n(slot_m1_n),
// irq handling
	.I_SPM1(slot_cyc_vect),
	.I_RETI(slot_cyc_reti),
	.I_IEI(slot_iei),
	.O_IEO(slot_ieo),
	.O_INT_n(slot_exint_n),
//
	.I_TI(ctc_ti[3:0]),
	.O_TO(ctc_to[3:0])
);

/****************************************************************************
  FM sound board (YM2151)
****************************************************************************/

	assign fm_rdata[7:0]=(fm_doe==1'b1) ? 8'h03 : 8'b0; // YM2151 , DUMMY STATUS

	assign pcm_lch[15:0]=16'b0;
	assign pcm_rch[15:0]=16'b0;
	assign pcm_load=1'b0;

endmodule
