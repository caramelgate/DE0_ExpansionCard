//------------------------------------------------------------------------------
//
// MECB : MC6800 EDUCATIONAL COMPUTER BOARD
//
// original design 1982 by Motorola Inc.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
//  tg68_mecb.v : tg68000 educational computer board system top module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2012/mar/15 release 0.0  tg68 mecb
//  2013/feb/18 release 0.1  de0
//
//------------------------------------------------------------------------------
//
//  RESET -> rom_bank=1 , all bootrom
//  accress $xxxx_8xxx -> rom_bank=0 , normal mode
// 
//  memory address
//  $0000_0000 - $0000_7fff : mem 32Kbytes
//  $0000_8000 - $0000_ffff : rom 32Kbytes
//  $0001_0040 - $0001_0042 : uart0
//  $0001_0041 - $0001_0043 : uart1
//  $0002_0000 - $07ff_ffff : mem
//
//  interrupt
//  irq7/nmi reserved
//  irq6     
//  irq5     
//  irq4     
//  irq3     
//  irq2     
//  irq1     
//  irq0     sprious/invalid
//

module tg68_mecb #(
	parameter	DEVICE=1,			// xilinx=0 / altera=1
	parameter	baud=12'd80			// uart_19200 : 25MHz - 19200x16
) (
	input			tg_clk,					// in    [TG68] clock
	input			tg_rst_n,				// in    [TG68] #reset

	input			tg_as,					// in    [TG68] #as
	input	[31:0]	tg_addr,				// in    [TG68] addr[31:0]
	input	[15:0]	tg_wdata,				// in    [TG68] wdata[15:0]
	output	[15:0]	tg_rdata,				// out   [TG68] rdata[15:0]
	input	[1:0]	tg_be,					// in    [TG68] #be[1:0]
	input			tg_rw,					// in    [TG68] rd/#wr
	output			tg_dtak,				// out   [TG68] #ack
	output	[2:0]	tg_ipl,					// out   [TG68] ipl[2:0]

	output	[31:0]	mem32_addr,				// out   [MEM] addr[31:0]
	output	[31:0]	mem32_wdata,			// out   [MEM] write data[31:0]
	input	[31:0]	mem32_rdata,			// in    [MEM] read data[31:0]
	output	[3:0]	mem32_be,				// out   [MEM] be[3:0]
	output			mem32_req,				// out   [MEM] req
	input			mem32_ack,				// in    [MEM] ack
	output			mem32_rd,				// out   [MEM] rd/#we
	output			mem32_t1,				// out   [MEM] t1 cycle

	output			TXD,					// out   [TG68] uart tx 19200-8N1-NONE
	input			RXD,					// in    [TG68] uart rx 19200-8N1-NONE
	output			TXD2,					// out   [TG68] uart2 tx 19200-8N1-NONE
	input			RXD2					// in    [TG68] uart2 rx 19200-8N1-NONE
);

	wire	[3:0] tg_be32;
	wire	[31:0] tg_wdata32;

	wire	rom_bank;

	wire	rom_bank_w;
	reg		rom_bank_r;

	wire	tg_irq0;
	wire	tg_irq1;
	wire	tg_irq2;
	wire	tg_irq3;
	wire	tg_irq4;
	wire	tg_irq5;
	wire	tg_irq6;
	wire	tg_irq7;

	wire	[31:0] tg_irq0_stat;
	wire	[31:0] tg_irq1_stat;
	wire	[31:0] tg_irq2_stat;
	wire	[31:0] tg_irq3_stat;
	wire	[31:0] tg_irq4_stat;
	wire	[31:0] tg_irq5_stat;
	wire	[31:0] tg_irq6_stat;
	wire	[31:0] tg_irq7_stat;

	wire	[2:0] tg_ipl_w;
	reg		[2:0] tg_ipl_r;

	wire	[3:0] tg_dtak_w;
	reg		[3:0] tg_dtak_r;

	assign rom_bank=rom_bank_r;
	assign tg_ipl[2:0]=tg_ipl_r[2:0];

	assign tg_be32[0]=(tg_be[0]==1'b0) & (tg_addr[1]==1'b1) ? 1'b0 : 1'b1;
	assign tg_be32[1]=(tg_be[1]==1'b0) & (tg_addr[1]==1'b1) ? 1'b0 : 1'b1;
	assign tg_be32[2]=(tg_be[0]==1'b0) & (tg_addr[1]==1'b0) ? 1'b0 : 1'b1;
	assign tg_be32[3]=(tg_be[1]==1'b0) & (tg_addr[1]==1'b0) ? 1'b0 : 1'b1;

	assign tg_wdata32[31:0]={tg_wdata[15:0],tg_wdata[15:0]};

	assign tg_irq7=1'b0;			// (nmi)
	assign tg_irq6=1'b0;			// MECB acia1 ?
	assign tg_irq5=1'b0;			// MECB acia2 ?
	assign tg_irq4=1'b0;			// MECB pit ?
	assign tg_irq3=1'b0;			// MECB pit ?
	assign tg_irq2=1'b0;
	assign tg_irq1=1'b0;
	assign tg_irq0=1'b0;			// sprious / invalid

	assign tg_irq7_stat[31:0]=32'h0;
	assign tg_irq6_stat[31:0]=32'h0;
	assign tg_irq5_stat[31:0]=32'h0;
	assign tg_irq4_stat[31:0]=32'h0;
	assign tg_irq3_stat[31:0]=32'h0;
	assign tg_irq2_stat[31:0]=32'h0;
	assign tg_irq1_stat[31:0]=32'h0;
	assign tg_irq0_stat[31:0]=32'h0;

	always @(posedge tg_clk or negedge tg_rst_n)
	begin
		if (tg_rst_n==1'b0)
			begin
				rom_bank_r <= 1'b1;
				tg_dtak_r[3:0] <= 4'b1111;
				tg_ipl_r[2:0] <= 3'b111;
			end
		else
			begin
				rom_bank_r <= rom_bank_w;
				tg_dtak_r[3:0] <= tg_dtak_w[3:0];
				tg_ipl_r[2:0] <= tg_ipl_w[2:0];
			end
	end

	assign rom_bank_w=
			(rom_bank_r==1'b0) ? 1'b0 :
			(rom_bank_r==1'b1) &  ((tg_addr[15]==1'b1) & (tg_as==1'b0)) ? 1'b0 :		// MECB rom aread $xxxx_8000 - $xxxx_bfff
			(rom_bank_r==1'b1) & !((tg_addr[15]==1'b1) & (tg_as==1'b0)) ? rom_bank_r :
			rom_bank_r;

//	assign rom_bank_w=
//			(rom_bank_r==1'b0) ? 1'b0 :
//			(rom_bank_r==1'b1) &  ((tg_addr[23]==1'b1) & (tg_as==1'b0)) ? 1'b0 :		// roma area $xxff_0000 - $xxff_ffff
//			(rom_bank_r==1'b1) & !((tg_addr[23]==1'b1) & (tg_as==1'b0)) ? rom_bank_r :
//			rom_bank_r;

	assign tg_dtak_w[3:0]=(tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? {tg_dtak_r[2:0],1'b0} : 4'b1111;

	assign tg_ipl_w[2:0]=
			({tg_irq7}==1'b1) ? 3'b000 :
			({tg_irq7,tg_irq6}==2'b01) ? 3'b001 :
			({tg_irq7,tg_irq6,tg_irq5}==3'b001) ? 3'b010 :
			({tg_irq7,tg_irq6,tg_irq5,tg_irq4}==4'b0001) ? 3'b011 :
			({tg_irq7,tg_irq6,tg_irq5,tg_irq4,tg_irq3}==5'b00001) ? 3'b100 :
			({tg_irq7,tg_irq6,tg_irq5,tg_irq4,tg_irq3,tg_irq2}==6'b000001) ? 3'b101 :
			({tg_irq7,tg_irq6,tg_irq5,tg_irq4,tg_irq3,tg_irq2,tg_irq1}==7'b0000001) ? 3'b110 :
			3'b111;

	// 

	wire	[31:0] rom_rdata;
	wire	rom_ce;

	wire	[31:0] ram_rdata;
	wire	ram_ce;

	wire	[31:0] uart_rdata;
	wire	uart_ce;

	wire	[31:0] mem_rdata;
	wire	mem_ce;
	wire	mem_ack;

	reg		[31:0] tg_rdata_sel_r;
	wire	[31:0] tg_rdata_sel_w;
	wire	[31:0] tg_rdata_sel;

	assign tg_rdata[15:0]=(tg_addr[1]==1'b0) ? tg_rdata_sel[31:16] : tg_rdata_sel[15:0];

	assign tg_rdata_sel[31:0]=tg_rdata_sel_r[31:0];

	always @(posedge tg_clk or negedge tg_rst_n)
	begin
		if (tg_rst_n==1'b0)
			begin
				tg_rdata_sel_r[31:0] <= 32'b0;
			end
		else
			begin
				tg_rdata_sel_r[31:0] <= tg_rdata_sel_w[31:0];
			end
	end

	assign {tg_rdata_sel_w[31:0],tg_dtak}=
			(rom_bank==1'b1) ? {rom_rdata[31:0],tg_dtak_r[2]} :
			(rom_bank==1'b0) & (tg_addr[31:16]==16'h0000) & (tg_addr[15]==1'b0) ? {mem_rdata,mem_ack} :	// 
			(rom_bank==1'b0) & (tg_addr[31:16]==16'h0000) & (tg_addr[15]==1'b1) ? {rom_rdata,tg_dtak_r[2]} :	// 
			(rom_bank==1'b0) & (tg_addr[31:16]==16'h0001) & ({tg_addr[15:2],2'b0}==16'h0040) ? {uart_rdata,tg_dtak_r[1]} :	// 
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h001) ? {mem_rdata,mem_ack} :	// $0010_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h002) ? {mem_rdata,mem_ack} :	// $0020_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h003) ? {mem_rdata,mem_ack} :	// $0030_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h004) ? {mem_rdata,mem_ack} :	// $0040_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h005) ? {mem_rdata,mem_ack} :	// $0050_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h006) ? {mem_rdata,mem_ack} :	// $0060_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h007) ? {mem_rdata,mem_ack} :	// $0070_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h008) ? {mem_rdata,mem_ack} :	// $0080_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h009) ? {mem_rdata,mem_ack} :	// $0090_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00a) ? {mem_rdata,mem_ack} :	// $00a0_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00b) ? {mem_rdata,mem_ack} :	// $00b0_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00c) ? {mem_rdata,mem_ack} :	// $00c0_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00d) ? {mem_rdata,mem_ack} :	// $00d0_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00e) ? {mem_rdata,mem_ack} :	// $00e0_0000 mem
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00f) ? {mem_rdata,mem_ack} :	// $00f0_0000 mem
			{32'b0,tg_dtak_r[0]};

/*
	// 68k vector : simulation testpoint

	wire	vect_reset;
	wire	vect_buserr;
	wire	vect_addrerr;
	wire	vect_illerr;
	wire	vect_divzerr;
	wire	vect_chkerr;

	assign vect_reset=({tg_addr[23:2],2'b0}==24'h000000) & (tg_as==1'b0) ? 1'b1 : 1'b0;
	assign vect_buserr=({tg_addr[23:2],2'b0}==24'h000008) & (tg_as==1'b0) ? 1'b1 : 1'b0;
	assign vect_addrerr=({tg_addr[23:2],2'b0}==24'h00000c) & (tg_as==1'b0) ? 1'b1 : 1'b0;
	assign vect_illerr=({tg_addr[23:2],2'b0}==24'h000010) & (tg_as==1'b0) ? 1'b1 : 1'b0;
	assign vect_divzerr=({tg_addr[23:2],2'b0}==24'h000014) & (tg_as==1'b0) ? 1'b1 : 1'b0;
	assign vect_chkerr=({tg_addr[23:2],2'b0}==24'h000018) & (tg_as==1'b0) ? 1'b1 : 1'b0;
*/

	assign ram_ce=1'b0;

	assign rom_ce=
			(rom_bank==1'b1) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:16]==16'h0000) & (tg_addr[15]==1'b1) & (tg_as==1'b0) ? 1'b1 :
			1'b0;

	assign uart_ce=
			(tg_dtak_r[1:0]==2'b10) & (rom_bank==1'b0) & (tg_addr[31:16]==16'h0001) & ({tg_addr[15:2],2'b0}==16'h0040) & (tg_as==1'b0) ? 1'b1 :
			1'b0;

	assign mem_ce=
			(rom_bank==1'b0) & (tg_addr[31:16]==16'h0000) & (tg_addr[15]==1'b0) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h001) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h002) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h003) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h004) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h005) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h006) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h007) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h008) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h009) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00a) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00b) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00c) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00d) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00e) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			(rom_bank==1'b0) & (tg_addr[31:20]==12'h00f) & (tg_as==1'b0) & (tg_be[1:0]!=2'b11) ? 1'b1 :
			1'b0;

	// ---- rom ----

	wire	[31:0] rom_rdatao;

	assign rom_rdata[31:0]=rom_rdatao[31:0];

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v4_2_rom32x8k bootrom(
	.clka(tg_clk),
	.ena(1'b1),
	.addra(tg_addr[14:2]),
	.douta(rom_rdatao[31:0])
);

end
	else
begin

alt_altsyncram_rom32x4k bootrom(
	.address(tg_addr[13:2]),
	.clock(tg_clk),
	.q(rom_rdatao[31:0])
);

end
endgenerate

	// ---- uart ----

	wire	uart_wr;

	wire	uart1_req;

	wire	uart1_txfull;
	wire	uart1_rxready;
	wire	[7:0] uart1_rdatao;

	wire	uart2_req;

	wire	uart2_txfull;
	wire	uart2_rxready;
	wire	[7:0] uart2_rdatao;

	assign uart_rdata[31:24]={6'b0,!uart1_txfull,uart1_rxready};
	assign uart_rdata[23:16]={6'b0,!uart2_txfull,uart2_rxready};
	assign uart_rdata[15:8]=uart1_rdatao[7:0];
	assign uart_rdata[7:0]=uart2_rdatao[7:0];

	assign uart1_req=(uart_ce==1'b1) & (tg_be32[1]==1'b0) ? 1'b1 : 1'b0;
	assign uart2_req=(uart_ce==1'b1) & (tg_be32[0]==1'b0) ? 1'b1 : 1'b0;
	assign uart_wr=(tg_rw==1'b0) ? 1'b1 : 1'b0;

tg_uart #(
	.baud38400(baud)		// 25Mhz : 38400x16=40
) uart1 (
	.uart_tx(TXD),					// out   [UART] send
	.uart_tx_busy(uart1_txfull),	// out   [UART] send busy

	.uart_rx(RXD),					// in    [UART] recieve
	.uart_rx_ready(uart1_rxready),	// out   [UART] recieve data ready

	.io_wdata(tg_wdata[15:8]),		// in    [UART] [7:0] io write data input
	.io_rdata(uart1_rdatao[7:0]),	// out   [UART] [7:0] io read data output
	.io_req(uart1_req),				// in    [UART] io req
	.io_wr(uart_wr),				// in    [UART] io #read/write
	.io_ack(),						// out   [UART] io ack/#busy
	.io_clk(tg_clk),				// in    [UART] clk
	.io_rst_n(tg_rst_n)				// in    [UART] #rst
);

tg_uart #(
	.baud38400(baud)		// 25Mhz : 38400x16=40
) uart2 (
	.uart_tx(TXD2),					// out   [UART] send
	.uart_tx_busy(uart2_txfull),	// out   [UART] send busy

	.uart_rx(RXD2),					// in    [UART] recieve
	.uart_rx_ready(uart2_rxready),	// out   [UART] recieve data ready

	.io_wdata(tg_wdata[7:0]),		// in    [UART] [7:0] io write data input
	.io_rdata(uart2_rdatao[7:0]),	// out   [UART] [7:0] io read data output
	.io_req(uart2_req),				// in    [UART] io req
	.io_wr(uart_wr),				// in    [UART] io #read/write
	.io_ack(),						// out   [UART] io ack/#busy
	.io_clk(tg_clk),				// in    [UART] clk
	.io_rst_n(tg_rst_n)				// in    [UART] #rst
);

	// ---- mem ----

	assign mem32_addr[31:0]=tg_addr[31:0];
	assign mem32_wdata[31:0]=tg_wdata32[31:0];
	assign mem_rdata[31:0]=mem32_rdata[31:0];
	assign mem32_be[3:0]=(tg_rw==1'b1) ? 4'b1111 : {!tg_be32[3],!tg_be32[2],!tg_be32[1],!tg_be32[0]};
	assign mem32_req=mem_ce;
	assign mem32_rd=tg_rw;

	reg		mem32_req_r;
	wire	mem32_req_w;

	assign mem32_t1=(mem_ce==1'b1) & (mem32_req_r==1'b0) ? 1'b1 : 1'b0;
	assign mem_ack=(mem_ce==1'b1) & (mem32_ack==1'b1) ? 1'b0 : 1'b1;

	always @(posedge tg_clk or negedge tg_rst_n)
	begin
		if (tg_rst_n==1'b0)
			begin
				mem32_req_r <= 1'b0;
			end
		else
			begin
				mem32_req_r <= mem32_req_w;
			end
	end

	assign mem32_req_w=mem_ce;

/*

	wire	[3:0] mem_mask;
	wire	[31:0] mem_wdata;

//	assign mem_mask[0]=(tg_be[0]==1'b0) & (tg_addr[1]==1'b1) ? 1'b0 : 1'b1;
//	assign mem_mask[1]=(tg_be[1]==1'b0) & (tg_addr[1]==1'b1) ? 1'b0 : 1'b1;
//	assign mem_mask[2]=(tg_be[0]==1'b0) & (tg_addr[1]==1'b0) ? 1'b0 : 1'b1;
//	assign mem_mask[3]=(tg_be[1]==1'b0) & (tg_addr[1]==1'b0) ? 1'b0 : 1'b1;
//	assign mem_wdata[31:0]={tg_wdata[15:0],tg_wdata[15:0]};

	assign mem_mask[3:0]=tg_be32[3:0];
	assign mem_wdata[31:0]=tg_wdata32[31:0];

	localparam	mst00=4'b0000;
	localparam	mst01=4'b0001;
	localparam	mst10=4'b0010;
	localparam	mst11=4'b0011;

	reg		[3:0] mem_state_r;
	reg		mem_ack_r;
	reg		mem_cmd_en_r;
	reg		mem_wr_en_r;
	reg		mem_rd_en_r;
	wire	[3:0] mem_state_w;
	wire	mem_ack_w;
	wire	mem_cmd_en_w;
	wire	mem_wr_en_w;
	wire	mem_rd_en_w;

	assign mig_cmd_en=mem_cmd_en_r;
	assign mig_cmd_instr[2:0]={1'b0,1'b1,tg_rw};
	assign mig_cmd_bl[5:0]=6'h00;
	assign mig_cmd_byte_addr[29:0]={tg_addr[29:2],2'b00};
	assign mig_wr_en=mem_wr_en_r;
	assign mig_wr_mask[3:0]=mem_mask[3:0];
	assign mig_wr_data[31:0]=mem_wdata[31:0];
	assign mig_rd_en=mem_rd_en_r;
	assign mem_rdata[31:0]=mig_rd_data[31:0];

	assign mem_ack=mem_ack_r;

	always @(posedge tg_clk or negedge tg_rst_n)
	begin
		if (tg_rst_n==1'b0)
			begin
				mem_state_r <= mst00;
				mem_ack_r <= 1'b1;
				mem_cmd_en_r <= 1'b0;
				mem_wr_en_r <= 1'b0;
				mem_rd_en_r <= 1'b0;
			end
		else
			begin
				mem_state_r <= mem_state_w;
				mem_ack_r <= mem_ack_w;
				mem_cmd_en_r <= mem_cmd_en_w;
				mem_wr_en_r <= mem_wr_en_w;
				mem_rd_en_r <= mem_rd_en_w;
			end
	end

	assign mem_state_w=
			(mem_state_r==mst00) & (mem_ce==1'b0) ? mst00 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b0) ? mst00 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) & (tg_rw==1'b0) ? mst01 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) & (tg_rw==1'b1) ? mst10 :
			(mem_state_r==mst01) & (mem_ce==1'b1) ? mst01 :
			(mem_state_r==mst01) & (mem_ce==1'b0) ? mst00 :
			(mem_state_r==mst10) & (mig_rd_empty==1'b1) ? mst10 :
			(mem_state_r==mst10) & (mig_rd_empty==1'b0) ? mst11 :
			(mem_state_r==mst11) & (mem_ce==1'b1) ? mst11 :
			(mem_state_r==mst11) & (mem_ce==1'b0) ? mst00 :
			mst00;

	assign mem_ack_w=
			(mem_state_r==mst00) & (mem_ce==1'b0) ? 1'b1 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b0) ? 1'b1 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) & (tg_rw==1'b0) ? 1'b0 :
			(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) & (tg_rw==1'b1) ? 1'b1 :
			(mem_state_r==mst01) & (mem_ce==1'b1) ? 1'b0 :
			(mem_state_r==mst01) & (mem_ce==1'b0) ? 1'b1 :
			(mem_state_r==mst10) & (mig_rd_empty==1'b1) ? 1'b1 :
			(mem_state_r==mst10) & (mig_rd_empty==1'b0) ? 1'b0 :
			(mem_state_r==mst11) & (mem_ce==1'b1) ? 1'b0 :
			(mem_state_r==mst11) & (mem_ce==1'b0) ? 1'b1 :
			1'b1;

	assign mem_cmd_en_w=(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) ? 1'b1 : 1'b0;

	assign mem_wr_en_w=(mem_state_r==mst00) & (mem_ce==1'b1) & (mig_cmd_empty==1'b1) & (tg_rw==1'b0) ? 1'b1 : 1'b0;

	assign mem_rd_en_w=(mem_state_r==mst11) & (mem_ce==1'b1) ? 1'b1 : 1'b0;
*/

endmodule

