//-----------------------------------------------------------------------------
//
//  nexys3_25drv.v : megadrive 25th anniversary top module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/20 release 0.0  
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

//`define debug_disp
//`define use_lcd
//`define debug
`define dac_amp1_out	// pmod-amp1
//`define dac_i2s_out	// pmod-i2s

module nexys3_25drv #(
	parameter	DEVICE=0,		// 0=xilinx
	parameter	SIM_ISIM=0,		// ISE ISIM simulation
	parameter	SIM_WO_TG68=0,	// reduced simulation : without TG68
	parameter	SIM_WO_SDR=0,	// redused simulation : without sdr-sdram
	parameter	SIM_FAST=0,		// fast simulation
	parameter	SIM_WO_VDP=0,	//
	parameter	SIM_WO_OS=0,	//
	parameter	opn2=1,			// 0=rtl / 1=connect YM2612
	parameter	vdp_sca=1,		// 0=kill
	parameter	vdp_scb=1,		// 0=kill
	parameter	vdp_spr=1,		// 0=kill
	parameter	pad_1p=1,		// 0=kill
	parameter	pad_2p=1,		// 0=kill
	parameter	DEBUG=0			// 
) (
/*
	inout			EppAstb,			// inout [USB] U-FLAGA
	inout			EppDstb,			// inout [USB] U-FLAGB
	inout			EppWait,			// inout [USB] U-SLRD
	inout	[7:0]	EppDB,				// inout [USB] U-FD0 .. U-FD7
	inout			UsbClk,				// inout [USB] U-IFCLK
	inout			UsbDir,				// inout [USB] U-SLCS
	inout			UsbWR,				// inout [USB] U-SLWR
	inout			UsbOE,				// inout [USB] U-SLOE
	inout	[1:0]	UsbAdr,				// inout [USB] U-FIFOAD1 .. U-FIFOAD0
	inout			UsbPktend,			// inout [USB] U-PKTEND
	inout			UsbFlag,			// inout [USB] U-FLAGC
	inout			UsbMode,			// inout [USB] U-INT0#
*/
	output			MemOE,				// out   [MEM] P30-OE
	output			MemWR,				// out   [MEM] P30-WE
	output			MemAdv,				// out   [MEM] P30-ADV
	input			MemWait,			// in    [MEM] P30-WAIT
	output			MemClk,				// out   [MEM] P30-CLK
	output			RamCS,				// out   [MEM] MT-CE
	output			RamCRE,				// out   [MEM] MT-CRE
	output			RamUB,				// out   [MEM] MT-UB
	output			RamLB,				// out   [MEM] MT-LB
	output	[26:1]	MemAdr,				// out   [MEM] P30-A0 .. P30-A25
	output			FlashCS,			// out   [MEM] P30-CE
	output			FlashRp,			// out   [MEM] P30-RST
	inout	[15:0]	MemDB,				// inout [MEM] P30-DQ0 .. P30-DQ15

	output			QuadSpiFlashCS,		// out   [MEM] CS
	output			QuadSpiFlashSck,	// out   [MEM] SCK
	inout			QuadSpiFlashDB,		// out   [MEM] SDI
//	inout	[2:0]	QuadSpiFlashDQ,		// inout [MEM] P30-DQ0 .. P30-DQ2

	output			PhyRstn,			// out   [ETH] ETH-RST
	input			PhyCrs,				// in    [ETH] ETH-CRS
	input			PhyCol,				// in    [ETH] ETH-COL
	input			PhyClk25Mhz,		// in    [ETH] ETH-CLK25MHZ
	output	[3:0]	PhyTxd,				// out   [ETH] ETH-TXD3 .. ETH-TXD0
	output			PhyTxEn,			// out   [ETH] ETH-TX_EN
	input			PhyTxClk,			// in    [ETH] ETH-TX_CLK
	inout			PhyTxEr,			// inout [ETH] ETH-TXD4
	input	[3:0]	PhyRxd,				// in    [ETH] ETH-RXD3 .. ETH-RXD0
	input			PhyRxDv,			// in    [ETH] ETH-RX_DV
	input			PhyRxEr,			// in    [ETH] ETH-RXD4
	input			PhyRxClk,			// in    [ETH] ETH-RX_CLK
	output			PhyMdc,				// out   [ETH] ETH-MDC
	inout			PhyMdio,			// inout [ETH] ETH-MDIO

	inout			PS2KData,			// inout [HID] PIC-SDI1
	inout			PS2KClk,			// inout [HID] PIC-SCK1
	inout			PS2MData,			// inout [HID] PIC-SDO1
	inout			PS2MClk,			// inout [HID] PIC-SS1
	inout	[1:0]	PicGpio,			// inout [HID] PIC-GPIO0 .. PIC-GPIO1

	input			RxD,				// in    [UART] MCU-RX
	output			TxD,				// out   [UART] MCU-TX

	output	[7:0]	SegC,				// out   [7SEG] DP,CG .. CA
	output	[3:0]	SegAn,				// out   [7SEG] AN0 .. AN3
	output	[7:0]	Led,				// out   [LED] LD0 .. LD7
	input	[7:0]	Sw,					// in    [SW] SW0 .. SW7
	input			BtnS,				// in    [SW] BTNS
	input			BtnU,				// in    [SW] BTNU
	input			BtnL,				// in    [SW] BTNL
	input			BtnD,				// in    [SW] BTND
	input			BtnR,				// in    [SW] BTNR

	output	[2:0]	VideoRed,			// out   [VIDEO] RED0 .. RED2
	output	[2:0]	VideoGrn,			// out   [VIDEO] GRN0 .. GRN2
	output	[2:1]	VideoBlu,			// out   [VIDEO] BLU1 .. BLU2
	output			VideoHsync,			// out   [VIDEO] HSYNC
	output			VideoVsync,			// out   [VIDEO] VSYNC

	inout	[7:0]	PMOD_A,				// inout [PMOD] JA10 .. JA7,JA4 .. JA1
	inout	[7:0]	PMOD_B,				// inout [PMOD] JB10 .. JB7,JB4 .. JB1
	inout	[7:0]	PMOD_C,				// inout [PMOD] JC10 .. JA7,JC4 .. JC1
	inout	[7:0]	PMOD_D,				// inout [PMOD] JD10 .. JB7,JD4 .. JD1

	inout	[19:0]	VHDC_P,				// inout [VHDC] EXP_IO1_P .. EXP_I20_P
	inout	[19:0]	VHDC_N,				// inout [VHDC] EXP_IO1_N .. EXP_I20_N

	input			Clk					// in    [SYS] 100MHz
);

//	assign MemOE=1'b1;
//	assign MemWR=1'b1;
//	assign MemAdv=1'b1;
//	assign MemClk=1'b0;
//	assign RamCS=1'b1;
//	assign RamCRE=1'b0;
//	assign RamUB=1'b1;
//	assign RamLB=1'b1;
//	assign MemAdr[26:1]=26'h0;
//	assign FlashCS=1'b1;
//	assign FlashRp=1'b0;
//	assign MemDB[15:0]=16'hzzzz;

//	assign QuadSpiFlashCS=1'b1;
//	assign QuadSpiFlashSck=1'b1;
//	assign QuadSpiFlashDB=1'bz;

	assign PhyRstn=1'b0;
	assign PhyTxd[3:0]=4'bzzzz;
	assign PhyTxEn=1'bz;
	assign PhyTxEr=1'bz;
	assign PhyMdc=1'bz;
	assign PhyMdio=1'bz;

	assign PS2KData=1'bz;
	assign PS2KClk=1'bz;
	assign PS2MData=1'bz;
	assign PS2MClk=1'bz;
	assign PicGpio[1:0]=2'bzz;

	assign TxD=1'bz;

	assign SegC[7:0]=8'b11111111;
	assign SegAn[3:0]=4'b1111;
//	assign Led[7:0]=8'b00000000;
//	assign VideoRed[2:0]=3'b000;
//	assign VideoGrn[2:0]=3'b000;
//	assign VideoBlu[2:1]=2'b00;
//	assign VideoHsync=1'b0;
//	assign VideoVsync=1'b0;

//	assign PMOD_A[7:0]=8'hzz;
//	assign PMOD_B[7:0]=8'hzz;
//	assign PMOD_C[7:0]=8'hzz;
	assign PMOD_D[7:0]=8'hzz;

	assign VHDC_P[19:0]=20'hzzzzz;
	assign VHDC_N[19:0]=20'hzzzzz;

	wire	RESET;

	assign RESET=BtnS;

	wire	GCLK100;
	wire	CLK25;
	wire	CLK27;
	wire	CLK50;
	wire	CLK54;
	wire	CLK135;
	wire	RST_N;

	wire	TX_CLK;
	wire	TX_CLKx5;

	wire	[7:0] TX_RED;
	wire	[7:0] TX_GRN;
	wire	[7:0] TX_BLU;
	wire	TX_HS;
	wire	TX_VS;
	wire	TX_DE;

	wire	[7:0] PSG_OUT;
	wire	[15:0] FM_OUT_L;
	wire	[15:0] FM_OUT_R;

	wire	mem_clk;
	wire	mem_init_done;
	wire	mem_cmd_req;
	wire	[3:0] mem_cmd_instr;
	wire	[5:0] mem_cmd_bl;
	wire	[29:0] mem_cmd_byte_addr;
	wire	mem_cmd_ack;
	wire	[3:0] mem_wr_mask;
	wire	[31:0] mem_wr_data;
	wire	mem_wr_ack;
	wire	[31:0] mem_rd_data;
	wire	mem_rd_ack;

	assign mem_clk=CLK54;
//	assign mem_clk=CLK25;

FDDRRSE DDR_mt_clk(.Q(MemClk),.C0(mem_clk),.C1(~mem_clk),.CE(1'b1),.D0(1'b0),.D1(mem_init_done),.R(1'b0),.S(1'b0));

	wire	[15:0] mt_rdata;
	wire	[15:0] mt_wdata;
	wire	mt_wdata_oe;

	wire	quad_spi_d_in;
	wire	quad_spi_d_out;
	wire	quad_spi_d_oe;

	assign mt_rdata[15:0]=MemDB[15:0];
	assign MemDB[15:0]=(mt_wdata_oe==1'b1) ? mt_wdata[15:0] : 16'hzzzz;

	assign quad_spi_d_in=QuadSpiFlashDB;
	assign QuadSpiFlashDB=(quad_spi_d_oe==1'b1) ? quad_spi_d_out : 1'bz;

mg_cram #(
	.count150us(12000)		// 80MHz 150us=12000clk
) cram (
	.mt_oe_n(MemOE),								// out   [MEM] #mem_oe (P30-OE)
	.mt_wr_n(MemWR),								// out   [MEM] #mem_wr (P30-WE)
	.mt_adv_n(MemAdv),								// out   [MEM] #mem_adv (P30-ADV)
	.mt_wait_n(MemWait),							// in    [MEM] #mem_wait/ready (P30-WAIT)
	.mt_clk(),										// out   [MEM] mem_clk (P30-CLK)
	.ram_cs_n(RamCS),								// out   [MEM] #ram_cs (MT-CE)
	.ram_cre(RamCRE),								// out   [MEM] ram_cre (MT-CRE)
	.ram_ub_n(RamUB),								// out   [MEM] #ram_ub (MT-UB)
	.ram_lb_n(RamLB),								// out   [MEM] #ram_lb (MT-LB )
	.mt_addr(MemAdr[26:1]),							// out   [MEM] mem_addr[26:1] (P30-A0..A25)
	.flash_cs_n(FlashCS),							// out   [MEM] #falsh_cs (P30-CE)
	.flash_rst_n(FlashRp),							// out   [MEM] #flash_rst (P30-RST)
	.mt_rdata(mt_rdata[15:0]),						// in    [MEM] mem_data[15:0] in (P30-DQ0..DQ15)
	.mt_wdata(mt_wdata[15:0]),						// out   [MEM] mem_data[15:0] out (P30-DQ0..DQ15)
	.mt_wdata_oe(mt_wdata_oe),						// out   [MEM] mem_data_oe

	.quad_spi_cs_n(QuadSpiFlashCS),					// out   [MEM] #spi_cs (CS)
	.quad_spi_sck(QuadSpiFlashSck),					// out   [MEM] spi_sck (SCK)
	.quad_spi_d_in(quad_spi_d_in),					// in    [MEM] spi_d in (SDI)
	.quad_spi_d_out(quad_spi_d_out),				// out   [MEM] spi_d out (SDI)
	.quad_spi_d_oe(quad_spi_d_oe),					// out   [MEM] spi_d oe (SDI)
//	.quad_spi_dq(quad_spi_dq[3:1]),					// inout [MEM] spi_dq (P30-DQ0..DQ2)

	.init_done(mem_init_done),						// out   [MEM] #init/done

	.mem_cmd_req(mem_cmd_req),						// in    [MEM] cmd req
	.mem_cmd_instr(mem_cmd_instr[3:0]),				// in    [MEM] cmd device(flash=1),inst[2:0]
	.mem_cmd_bl(mem_cmd_bl[5:0]),					// in    [MEM] cmd blen[5:0](flash=0)
	.mem_cmd_byte_addr(mem_cmd_byte_addr[29:0]),	// in    [MEM] cmd addr[29:0]
	.mem_cmd_ack(mem_cmd_ack),						// out   [MEM] cmd ack
	.mem_wr_mask(mem_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// in    [MEM] wr wdata[31:0]
	.mem_wr_ack(mem_wr_ack),						// out   [MEM] wr ack
	.mem_rd_data(mem_rd_data[31:0]),				// out   [MEM] rd rdata[31:0]
	.mem_rd_ack(mem_rd_ack),						// out   [MEM] rd ack

	.mem_rst_n(RST_N),								// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	wire	p0_cmd_req;
	wire	[3:0] p0_cmd_instr;
	wire	[5:0] p0_cmd_bl;
	wire	[29:0] p0_cmd_byte_addr;
	wire	p0_cmd_ack;
	wire	[3:0] p0_wr_mask;
	wire	[31:0] p0_wr_data;
	wire	[31:0] p0_rd_data;

	wire	p1_cmd_req;
	wire	[3:0] p1_cmd_instr;
	wire	[5:0] p1_cmd_bl;
	wire	[29:0] p1_cmd_byte_addr;
	wire	p1_cmd_ack;
	wire	[3:0] p1_wr_mask;
	wire	[31:0] p1_wr_data;
	wire	[31:0] p1_rd_data;

	wire	p2_cmd_req;
	wire	[3:0] p2_cmd_instr;
	wire	[5:0] p2_cmd_bl;
	wire	[29:0] p2_cmd_byte_addr;
	wire	p2_cmd_ack;
	wire	[3:0] p2_wr_mask;
	wire	[31:0] p2_wr_data;
	wire	[31:0] p2_rd_data;

	wire	p3_cmd_req;
	wire	[3:0] p3_cmd_instr;
	wire	[5:0] p3_cmd_bl;
	wire	[29:0] p3_cmd_byte_addr;
	wire	p3_cmd_ack;
	wire	[3:0] p3_wr_mask;
	wire	[31:0] p3_wr_data;
	wire	[31:0] p3_rd_data;

	wire	p4_cmd_req;
	wire	[3:0] p4_cmd_instr;
	wire	[5:0] p4_cmd_bl;
	wire	[29:0] p4_cmd_byte_addr;
	wire	p4_cmd_ack;
	wire	[3:0] p4_wr_mask;
	wire	[31:0] p4_wr_data;
	wire	[31:0] p4_rd_data;

	wire	p5_cmd_req;
	wire	[3:0] p5_cmd_instr;
	wire	[5:0] p5_cmd_bl;
	wire	[29:0] p5_cmd_byte_addr;
	wire	p5_cmd_ack;
	wire	[3:0] p5_wr_mask;
	wire	[31:0] p5_wr_data;
	wire	[31:0] p5_rd_data;

	wire	p6_cmd_req;
	wire	[3:0] p6_cmd_instr;
	wire	[5:0] p6_cmd_bl;
	wire	[29:0] p6_cmd_byte_addr;
	wire	p6_cmd_ack;
	wire	[3:0] p6_wr_mask;
	wire	[31:0] p6_wr_data;
	wire	[31:0] p6_rd_data;

	wire	p7_cmd_req;
	wire	[3:0] p7_cmd_instr;
	wire	[5:0] p7_cmd_bl;
	wire	[29:0] p7_cmd_byte_addr;
	wire	p7_cmd_ack;
	wire	[3:0] p7_wr_mask;
	wire	[31:0] p7_wr_data;
	wire	[31:0] p7_rd_data;

mg_arb8 mg_arb(
	.init_done(mem_init_done),						// in    [MEM] #init/done

	.mem_cmd_req(mem_cmd_req),						// out   [MEM] cmd req
	.mem_cmd_instr(mem_cmd_instr[3:0]),				// out   [MEM] cmd device(flash=1),inst[2:0]
	.mem_cmd_bl(mem_cmd_bl[5:0]),					// out   [MEM] cmd blen[5:0](flash=0)
	.mem_cmd_byte_addr(mem_cmd_byte_addr[29:0]),	// out   [MEM] cmd addr[29:0]
	.mem_cmd_ack(mem_cmd_ack),						// in    [MEM] cmd ack
	.mem_wr_mask(mem_wr_mask[3:0]),					// out   [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// out   [MEM] wr wdata[31:0]
	.mem_wr_ack(mem_wr_ack),						// in    [MEM] wr ack
	.mem_rd_data(mem_rd_data[31:0]),				// in    [MEM] rd rdata[31:0]
	.mem_rd_ack(mem_rd_ack),						// in    [MEM] rd ack

	.p0_cmd_req(p0_cmd_req),						// in    [MEM] cmd req
	.p0_cmd_instr(p0_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p0_cmd_bl(p0_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p0_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p0_cmd_ack(p0_cmd_ack),						// out   [MEM] cmd ack
	.p0_wr_mask(p0_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p0_wr_data(p0_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p0_rd_data(p0_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p1_cmd_req(p1_cmd_req),						// in    [MEM] cmd req
	.p1_cmd_instr(p1_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p1_cmd_bl(p1_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p1_cmd_byte_addr(p1_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p1_cmd_ack(p1_cmd_ack),						// out   [MEM] cmd ack
	.p1_wr_mask(p1_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p1_wr_data(p1_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p1_rd_data(p1_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p2_cmd_req(p2_cmd_req),						// in    [MEM] cmd req
	.p2_cmd_instr(p2_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p2_cmd_bl(p2_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p2_cmd_byte_addr(p2_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p2_cmd_ack(p2_cmd_ack),						// out   [MEM] cmd ack
	.p2_wr_mask(p2_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p2_wr_data(p2_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p2_rd_data(p2_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p3_cmd_req(p3_cmd_req),						// in    [MEM] cmd req
	.p3_cmd_instr(p3_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p3_cmd_bl(p3_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p3_cmd_byte_addr(p3_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p3_cmd_ack(p3_cmd_ack),						// out   [MEM] cmd ack
	.p3_wr_mask(p3_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p3_wr_data(p3_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p3_rd_data(p3_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p4_cmd_req(p4_cmd_req),						// in    [MEM] cmd req
	.p4_cmd_instr(p4_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p4_cmd_bl(p4_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p4_cmd_byte_addr(p4_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p4_cmd_ack(p4_cmd_ack),						// out   [MEM] cmd ack
	.p4_wr_mask(p4_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p4_wr_data(p4_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p4_rd_data(p4_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p5_cmd_req(p5_cmd_req),						// in    [MEM] cmd req
	.p5_cmd_instr(p5_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p5_cmd_bl(p5_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p5_cmd_byte_addr(p5_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p5_cmd_ack(p5_cmd_ack),						// out   [MEM] cmd ack
	.p5_wr_mask(p5_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p5_wr_data(p5_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p5_rd_data(p5_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p6_cmd_req(p6_cmd_req),						// in    [MEM] cmd req
	.p6_cmd_instr(p6_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p6_cmd_bl(p6_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p6_cmd_byte_addr(p6_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p6_cmd_ack(p6_cmd_ack),						// out   [MEM] cmd ack
	.p6_wr_mask(p6_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p6_wr_data(p6_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p6_rd_data(p6_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.p7_cmd_req(p7_cmd_req),						// in    [MEM] cmd req
	.p7_cmd_instr(p7_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p7_cmd_bl(p7_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
	.p7_cmd_byte_addr(p7_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p7_cmd_ack(p7_cmd_ack),						// out   [MEM] cmd ack
	.p7_wr_mask(p7_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p7_wr_data(p7_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p7_rd_data(p7_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

	.mem_rst_n(RST_N),								// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	wire	[7:0] KEY1;
	wire	[7:0] KEY2;

	reg		[7:0] key1_in_r;
	reg		[7:0] key2_in_r;

	assign PMOD_A[7:0]=8'hzz;
	assign PMOD_B[7:0]=8'hzz;

//	assign KEY1[7:0]=PMOD_A[7:0];
//	assign KEY2[7:0]=PMOD_B[7:0];

	assign KEY1[7:0]=key1_in_r[7:0];
	assign KEY2[7:0]=key2_in_r[7:0];

	always @(posedge CLK54 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				key1_in_r[7:0] <= 8'hff;
				key2_in_r[7:0] <= 8'hff;
			end
		else
			begin
				key1_in_r[7:0] <= PMOD_A[7:0];
				key2_in_r[7:0] <= PMOD_B[7:0];
			end
	end

IBUFG IBUFG_GCLK100(.I(Clk),.O(GCLK100));

	reg		[1:0] CLK100_div_r;

	wire	RESET_REQ;
	reg		[7:0] RESET_REQ_r;

//	assign CLK50=CLK100_div_r[0];
//	assign CLK25=CLK100_div_r[1];
BUFG BUFG_CLK50(.I(CLK100_div_r[0]),.O(CLK50));
BUFG BUFG_CLK25(.I(CLK100_div_r[1]),.O(CLK25));

	assign RESET_REQ=RESET_REQ_r[7];

	always @(posedge GCLK100 or posedge RESET)
	begin
		if (RESET==1'b1)
			begin
				CLK100_div_r[1:0] <= 2'b00;
				RESET_REQ_r[7] <= 1'b1;
				RESET_REQ_r[6:0] <= 7'b0;
			end
		else
			begin
				CLK100_div_r[1:0] <= CLK100_div_r[1:0]+2'b01;
				RESET_REQ_r[7] <= (RESET_REQ_r[6:0]==7'h7f) ? 1'b0 : RESET_REQ_r[7];
				RESET_REQ_r[6:0] <= (RESET_REQ_r[7]==1'b0) ? 7'b0 : RESET_REQ_r[6:0]+7'h01;
			end
	end

xil_clk_wiz_v3_6_100x54 clkgen_100x54(
	.CLK_IN1(GCLK100),
	.CLK_OUT1(CLK54),
	.RESET(RESET_REQ),
	.LOCKED(RST_N)
);

	wire	[31:0] CART_ADDR;
	wire	[31:0] CART_WDATA;
	wire	[31:0] CART_RDATA;
	wire	[3:0] CART_BE;
	wire	CART_REQ;
	wire	CART_WE;
	wire	CART_ACK;

	wire	[31:0] VRAM32_ADDR;
	wire	VRAM32_REQ;
	wire	[3:0] VRAM32_BE;
	wire	[31:0] VRAM32_RDATA;
	wire	[31:0] VRAM32_WDATA;
	wire	VRAM32_WR;
	wire	VRAM32_ACK;

	wire	[31:0] WORK_ADDR;
	wire	[31:0] WORK_WDATA;
	wire	[31:0] WORK_RDATA;
	wire	[3:0] WORK_BE;
	wire	WORK_WR;
	wire	WORK_REQ;
	wire	WORK_ACK;

	wire	[31:0]	VD_ADDR;
	wire			VD_REQ;
	wire	[3:0]	VD_BE;
	wire	[31:0]	VD_RDATA;
	wire	[31:0]	VD_WDATA;
	wire			VD_WR;
	wire			VD_ACK;

	wire	[31:0]	V0_ADDR;
	wire			V0_REQ;
	wire	[3:0]	V0_BE;
	wire	[31:0]	V0_RDATA;
	wire	[31:0]	V0_WDATA;
	wire			V0_WR;
	wire			V0_ACK;

	wire	[31:0]	V1_ADDR;
	wire			V1_REQ;
	wire	[3:0]	V1_BE;
	wire	[31:0]	V1_RDATA;
	wire	[31:0]	V1_WDATA;
	wire			V1_WR;
	wire			V1_ACK;

	wire	[31:0]	V2_ADDR;
	wire			V2_REQ;
	wire	[3:0]	V2_BE;
	wire	[31:0]	V2_RDATA;
	wire	[31:0]	V2_WDATA;
	wire			V2_WR;
	wire			V2_ACK;

	wire	[31:0]	V3_ADDR;
	wire			V3_REQ;
	wire	[3:0]	V3_BE;
	wire	[31:0]	V3_RDATA;
	wire	[31:0]	V3_WDATA;
	wire			V3_WR;
	wire			V3_ACK;

	assign p0_cmd_req=CART_REQ;
	assign p0_cmd_instr[3:0]=4'b1001;
	assign p0_cmd_bl[5:0]=6'b0;
	assign p0_cmd_byte_addr[29:0]={8'b0,CART_ADDR[21:1],1'b0};
	assign CART_ACK=p0_cmd_ack;
	assign p0_wr_mask[3:0]=4'b0;	// ~CART_BE[3:0];
	assign p0_wr_data[31:0]=CART_WDATA[31:0];
	assign CART_RDATA[31:0]=p0_rd_data[31:0];

	assign p1_cmd_req=WORK_REQ;
	assign p1_cmd_instr[3:0]={3'b000,!WORK_WR};
	assign p1_cmd_bl[5:0]=6'b0;
	assign p1_cmd_byte_addr[29:0]={6'h00,8'h1,WORK_ADDR[15:2],2'b0};
	assign WORK_ACK=p1_cmd_ack;
	assign p1_wr_mask[3:0]=~WORK_BE[3:0];
	assign p1_wr_data[31:0]=WORK_WDATA[31:0];
	assign WORK_RDATA[31:0]=p1_rd_data[31:0];

	assign p2_cmd_req=V0_REQ;
	assign p2_cmd_instr[3:0]={3'b000,!V0_WR};
	assign p2_cmd_bl[5:0]=6'b0;
	assign p2_cmd_byte_addr[29:0]={6'h00,8'h0,V0_ADDR[15:2],2'b0};
	assign V0_ACK=p2_cmd_ack;
	assign p2_wr_mask[3:0]=~V0_BE[3:0];
	assign p2_wr_data[31:0]=V0_WDATA[31:0];
	assign V0_RDATA[31:0]=p2_rd_data[31:0];

	assign p3_cmd_req=V1_REQ;
	assign p3_cmd_instr[3:0]={3'b000,!V1_WR};
	assign p3_cmd_bl[5:0]=6'b0;
	assign p3_cmd_byte_addr[29:0]={6'h00,8'h0,V1_ADDR[15:2],2'b0};
	assign V1_ACK=p3_cmd_ack;
	assign p3_wr_mask[3:0]=~V1_BE[3:0];
	assign p3_wr_data[31:0]=V1_WDATA[31:0];
	assign V1_RDATA[31:0]=p3_rd_data[31:0];

	assign p4_cmd_req=V2_REQ;
	assign p4_cmd_instr[3:0]={3'b000,!V2_WR};
	assign p4_cmd_bl[5:0]=6'b0;
	assign p4_cmd_byte_addr[29:0]={6'h00,8'h0,V2_ADDR[15:2],2'b0};
	assign V2_ACK=p4_cmd_ack;
	assign p4_wr_mask[3:0]=~V2_BE[3:0];
	assign p4_wr_data[31:0]=V2_WDATA[31:0];
	assign V2_RDATA[31:0]=p4_rd_data[31:0];

	assign p5_cmd_req=V3_REQ;
	assign p5_cmd_instr[3:0]={3'b000,!V3_WR};
	assign p5_cmd_bl[5:0]=6'b0;
	assign p5_cmd_byte_addr[29:0]={6'h00,8'h0,V3_ADDR[15:2],2'b0};
	assign V3_ACK=p5_cmd_ack;
	assign p5_wr_mask[3:0]=~V3_BE[3:0];
	assign p5_wr_data[31:0]=V3_WDATA[31:0];
	assign V3_RDATA[31:0]=p5_rd_data[31:0];

	assign p6_cmd_req=VD_REQ;
	assign p6_cmd_instr[3:0]={3'b000,!VD_WR};
	assign p6_cmd_bl[5:0]=6'b0;
	assign p6_cmd_byte_addr[29:0]={6'h00,8'h0,VD_ADDR[15:2],2'b0};
	assign VD_ACK=p6_cmd_ack;
	assign p6_wr_mask[3:0]=~VD_BE[3:0];
	assign p6_wr_data[31:0]=VD_WDATA[31:0];
	assign VD_RDATA[31:0]=p6_rd_data[31:0];

	assign p7_cmd_req=VRAM32_REQ;
	assign p7_cmd_instr[3:0]={3'b000,!VRAM32_WR};
	assign p7_cmd_bl[5:0]=6'b0;
	assign p7_cmd_byte_addr[29:0]={6'h00,8'h0,VRAM32_ADDR[15:2],2'b0};
	assign VRAM32_ACK=p7_cmd_ack;
	assign p7_wr_mask[3:0]=~VRAM32_BE[3:0];
	assign p7_wr_data[31:0]=VRAM32_WDATA[31:0];
	assign VRAM32_RDATA[31:0]=p7_rd_data[31:0];


//	assign TX_CLK=CLK27;
//	assign TX_CLKx5=CLK135;

	wire	TG_RESET;
	wire	TG_BUSERR;
	wire	TG_ADDRERR;
	wire	TG_ILLERR;

	wire	[15:0] DEBUG_OUT;
	wire	[15:0] DEBUG_VDP;
	wire	[15:0] DEBUG_FM;
	wire	[15:0] DEBUG_Z;

	reg		[15:0] DEBUG_VDP_r;
	reg		[15:0] DEBUG_OUT_r;
	reg		[3:0] DEBUG_SEL_r;

	reg		[2:0] TX_DEBUG_sel_r;

	reg		[7:0] TX_RED_r;
	reg		[7:0] TX_GRN_r;
	reg		[7:0] TX_BLU_r;
	reg		TX_HS_r;
	reg		TX_VS_r;
	reg		TX_DE_r;
	reg		[3:0] TX_CLK_r;

	assign VideoRed[2:0]=TX_RED_r[7:5];
	assign VideoGrn[2:0]=TX_GRN_r[7:5];
	assign VideoBlu[2:1]=TX_BLU_r[7:6];
	assign VideoHsync=TX_HS_r;
	assign VideoVsync=TX_VS_r;

	always @(posedge CLK54 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				DEBUG_VDP_r[15:0] <= 16'b0;
				DEBUG_OUT_r[15:0] <= 16'b0;
				DEBUG_SEL_r[3:0] <= 4'b0;
			end
		else
			begin
				DEBUG_VDP_r[15:0] <= DEBUG_VDP[15:0];
				DEBUG_OUT_r[15:0] <= DEBUG_OUT[15:0];
				DEBUG_SEL_r[0] <= DEBUG_OUT_r[1];	// z-fm
				DEBUG_SEL_r[1] <= DEBUG_OUT_r[2];	// z-psg
				DEBUG_SEL_r[2] <= DEBUG_OUT_r[8];	// m-fm
				DEBUG_SEL_r[3] <= DEBUG_OUT_r[9];	// m-psg
			end
	end

	always @(posedge CLK54 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				TX_DEBUG_sel_r[2:0] <= 3'b0;
				TX_RED_r[7:0] <= 8'b0;
				TX_GRN_r[7:0] <= 8'b0;
				TX_BLU_r[7:0] <= 8'b0;
				TX_HS_r <= 1'b0;
				TX_VS_r <= 1'b0;
				TX_DE_r <= 1'b0;
				TX_CLK_r[3:0] <= 4'b0;
			end
		else
			begin
				TX_DEBUG_sel_r[2:0] <= ({TX_CLK_r[0],TX_CLK}==2'b01) ? DEBUG_SEL_r[2:0] : TX_DEBUG_sel_r[2:0];
`ifdef debug_disp
				TX_RED_r[7:0] <= // (TX_DE==1'b1) ? TX_RED[7:0] : 8'b0;
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_RED_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[0]!=1'b1) ? TX_RED[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[0]==1'b1) ? 8'hff :
					8'b0;
				TX_GRN_r[7:0] <= // (TX_DE==1'b1) ? TX_GRN[7:0] : 8'b0;
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_GRN_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[1]!=1'b1) ? TX_GRN[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[1]==1'b1) ? 8'hff :
					8'b0;
				TX_BLU_r[7:0] <= // (TX_DE==1'b1) ? TX_BLU[7:0] : 8'b0;
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_BLU_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[2]!=1'b1) ? TX_BLU[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) & (TX_DEBUG_r[2]==1'b1) ? 8'hff :
					8'b0;
`else
				TX_RED_r[7:0] <= 
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_RED_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) ? TX_RED[7:0] :
					8'b0;
				TX_GRN_r[7:0] <= 
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_GRN_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) ? TX_GRN[7:0] :
					8'b0;
				TX_BLU_r[7:0] <= 
					({TX_CLK_r[0],TX_CLK}!=2'b01) ? TX_BLU_r[7:0] :
					({TX_CLK_r[0],TX_CLK}==2'b01) & (TX_DE==1'b1) ? TX_BLU[7:0] :
					8'b0;
`endif
				TX_HS_r <= ({TX_CLK_r[0],TX_CLK}==2'b01) ? TX_HS : TX_HS_r;
				TX_VS_r <= ({TX_CLK_r[0],TX_CLK}==2'b01) ? TX_VS : TX_VS_r;
				TX_DE_r <= ({TX_CLK_r[0],TX_CLK}==2'b01) ? TX_DE : TX_DE_r;
				TX_CLK_r[3:0] <= {TX_CLK_r[2:0],TX_CLK};
			end
	end

	wire	dac_l_out;	// pmod-amp1 lch / pmod-i2s sdin
	wire	dac_s_out;	// pmod-amp1 nc  / pmod-i2s sclk
	wire	dac_r_out;	// pmod-amp1 rch / pmod-i2s lrck
	wire	dac_m_out;	// pmod-amp1 nc  / pmod-i2s mclk

	assign PMOD_C[0]=dac_l_out;
	assign PMOD_C[1]=dac_s_out;
	assign PMOD_C[2]=dac_r_out;
	assign PMOD_C[3]=dac_m_out;
	assign PMOD_C[4]=1'bz;
	assign PMOD_C[5]=1'bz;
	assign PMOD_C[6]=1'bz;
	assign PMOD_C[7]=1'bz;

`ifdef dac_amp1_out

	// ---- dac out ----

	wire	DAC_CLK;

	wire	[23:0] dac_lch;
	wire	[23:0] dac_rch;
	wire	dac_ch_req;

	assign DAC_CLK=CLK54;

	assign dac_ch_req=1'b1;
	assign dac_lch[23:0]={FM_OUT_L[15:0],8'b0};
	assign dac_rch[23:0]={FM_OUT_R[15:0],8'b0};

	wire	dac_lch_out,dac_rch_out;
	wire	dac_lch_out_w,dac_rch_out_w;
	reg		dac_lch_out_r,dac_rch_out_r;

	assign dac_l_out=dac_lch_out_r;
	assign dac_r_out=dac_rch_out_r;
	assign dac_s_out=1'bz;
	assign dac_m_out=1'bz;

	always @(posedge DAC_CLK or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				dac_lch_out_r <= 1'b0;
				dac_rch_out_r <= 1'b0;
			end
		else
			begin
				dac_lch_out_r <= dac_lch_out_w;
				dac_rch_out_r <= dac_rch_out_w;
			end
	end

	assign dac_lch_out_w=dac_lch_out;
	assign dac_rch_out_w=dac_rch_out;

dac9f pwm_dac(
	.dac_lch_out(dac_lch_out),			// out   [DAC] dac left out
	.dac_rch_out(dac_rch_out),			// out   [DAC] dac right out

	.dac_lch(dac_lch[23:4]),			// in    [DAC] [19:0] dac left data
	.dac_rch(dac_rch[23:4]),			// in    [DAC] [19:0] dac right data
	.dac_req(dac_ch_req),				// in    [DAC] dac req

	.dac_rst_n(RST_N),					// in    [DAC] #reset
	.dac_clk(DAC_CLK)					// in    [DAC] clock (48KHz*512)
);

`else

	assign dac_l_out=1'bz;
	assign dac_s_out=1'bz;
	assign dac_r_out=1'bz;
	assign dac_m_out=1'bz;

`endif

	reg		[7:0] led_level_r;
	reg		[7:0] led_debug_r;
	reg		[7:0] led_level_out_r;
	wire	[7:0] led_level_w;
	wire	[7:0] led_debug_w;
	wire	[7:0] led_level_out_w;

	always @(posedge CLK54 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				led_level_r[7:0] <= 8'b0;
				led_debug_r[7:0] <= 8'b0;
				led_level_out_r[7:0] <= 8'b0;
			end
		else
			begin
`ifdef dac_amp1_out
				led_level_r[7:0] <= FM_OUT_L[15:8];
`else
				led_level_r[7:0] <= 8'b0;//FM_OUT_L[15:8];
`endif
				led_debug_r[7:0] <= DEBUG_OUT[15:8];
				led_level_out_r[7:0] <= led_level_out_w[7:0];
			end
	end

	wire	[7:0] led_level;

	assign led_level[7:0]=(led_level_r[7]==1'b0) ? {led_level_r[6:0],1'b0} : {!led_level_r[6:0],1'b0};

	assign led_level_out_w[0]=(led_level[7:5]>3'h0) ? 1'b1 : 1'b0;
	assign led_level_out_w[1]=(led_level[7:5]>3'h1) ? 1'b1 : 1'b0;
	assign led_level_out_w[2]=(led_level[7:5]>3'h2) ? 1'b1 : 1'b0;
	assign led_level_out_w[3]=(led_level[7:5]>3'h3) ? 1'b1 : 1'b0;
	assign led_level_out_w[4]=(led_level[7:5]>3'h4) ? 1'b1 : 1'b0;
	assign led_level_out_w[5]=(led_level[7:5]>3'h5) ? 1'b1 : 1'b0;
	assign led_level_out_w[6]=(led_level[7:5]>3'h6) ? 1'b1 : 1'b0;
	assign led_level_out_w[7]=1'b0;

//	assign LEDG[9]=SYSRST_N;
//	assign LEDG[8]=MEM_INIT_DONE;

	assign Led[7:0]=(Sw[2]==1'b0) ? led_debug_r[7:0] : led_level_out_r[7:0];

	wire	[1:0] YM_ADDR;
	wire	[7:0] YM_WDATA;
	wire	[7:0] YM_RDATA;
	wire	YM_DOE;
	wire	YM_WR_N;
	wire	YM_RD_N;
	wire	YM_CS_N;
	wire	YM_CLK;

	assign YM_RDATA[7:0]=8'b0;

gen_top8 #(
	.DEVICE(DEVICE),
	.SIM_WO_VDP(SIM_WO_VDP),
	.SIM_WO_OS(SIM_WO_OS),
	.opn2(opn2),
	.vdp_sca(vdp_sca),
	.vdp_scb(vdp_scb),
	.vdp_spr(vdp_spr),
	.pad_1p(pad_1p),
	.pad_2p(pad_2p)
) gen (
	.DEBUG_OUT(DEBUG_OUT),
	.DEBUG_VDP(DEBUG_VDP),
	.DEBUG_FM(DEBUG_FM),
	.DEBUG_Z(DEBUG_Z),

	.debug_sca(Sw[7]),
	.debug_scw(Sw[6]),
	.debug_scb(Sw[5]),
	.debug_spr(Sw[4]),
	.debug_dma(Sw[3]),

//	.RESET(!RST_N),			// in 
	.RESET(!mem_init_done),			// in 

	.PSG_OUT(PSG_OUT),		// out
	.FM_OUT_L(FM_OUT_L),	// 
	.FM_OUT_R(FM_OUT_R),	// 

//	.YM_ADDR(YM_ADDR[1:0]),
//	.YM_WDATA(YM_WDATA[7:0]),
//	.YM_RDATA(YM_RDATA[7:0]),
//	.YM_DOE(YM_DOE),
//	.YM_WR_N(YM_WR_N),
//	.YM_RD_N(YM_RD_N),
//	.YM_CS_N(YM_CS_N),
//	.YM_CLK(YM_CLK),

	.VERSION({Sw[1:0],6'b100000}),	// JPN,NTSC,no_CD,1'b0,4'b0000
//	.VERSION({2'b00,6'b100000}),	// JPN,NTSC,no_CD,1'b0,4'b0000

	.KEY1(KEY1),			// in 
	.KEY2(KEY2),			// in 

	.CLOCK_54(CLK54),		// in 

	.WORK_ADDR(WORK_ADDR),		// out 
	.WORK_REQ(WORK_REQ),		// out 
	.WORK_WDATA(WORK_WDATA),	// out 
	.WORK_RDATA(WORK_RDATA),	// in 
	.WORK_BE(WORK_BE),			// out 
	.WORK_WR(WORK_WR),			// out 
	.WORK_ACK(WORK_ACK),		// 

	.CART_ADDR(CART_ADDR),		// out
	.CART_WDATA(CART_WDATA),	
	.CART_RDATA(CART_RDATA),	
	.CART_REQ(CART_REQ),		// out 
	.CART_WE(CART_WE),			// out 
	.CART_ACK(CART_ACK),		// 

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

	.VGA_R(TX_RED),		// out 
	.VGA_G(TX_GRN),		// out 
	.VGA_B(TX_BLU),		// out 
	.VGA_VS(TX_VS),		// out 
	.VGA_HS(TX_HS),		// out 
	.VGA_DE(TX_DE),		// out 
	.VGA_CLK(TX_CLK)	// out 
);

endmodule

