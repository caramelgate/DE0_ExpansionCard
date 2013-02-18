//-----------------------------------------------------------------------------
//
//  de0_tg68.v : de0 tg68 test module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/jan/25 release 0.0  de1 cyclone2
//      /feb/01 release 0.0a de0 cyclone3
//      /feb/18 release 0.1  mecb(mc68000 educational computer board)
//
//------------------------------------------------------------------------------

module de0_tg68 #(
	parameter	DEVICE=1,		// 1=altera
	parameter	SIM_WO_TG68=0,	// 
	parameter	SIM_FAST=0,		// 
	parameter	DEBUG=0			// 
) (
	input			CLOCK_50,		// in    [SYS] 50MHz
	input			CLOCK_50_2,		// in    [SYS] 50MHz

//	inout	[31:0]	GPIO0_D,		// inout [GPIO] gpio[31:0]
//	input	[1:0]	GPIO0_CLKIN,	// inout [GPIO] clkin[1:0]
//	inout	[1:0]	GPIO0_CLKOUT,	// inout [GPIO] clkout[1:0]
//	inout	[31:0]	GPIO1_D,		// inout [GPIO] gpio[31:0]
//	input	[1:0]	GPIO1_CLKIN,	// inout [GPIO] clkin[1:0]
//	inout	[1:0]	GPIO1_CLKOUT,	// inout [GPIO] clkout[1:0]

	input			GPIO0_ETH_RXCLK,	// in    [GPIO0] eth rxclk
	input			GPIO0_ETH_TXCLK,	// in    [GPIO0] eth txclk
	output			GPIO0_ETH_CLK,		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
	input			GPIO0_ETH_CLKFB,	// in    [GPIO0] eth clkfb (RMII=50MHz)
	output			GPIO0_ETH_RST_N,	// out   [GPIO0] eth #rst
	output			GPIO0_ETH_MDC,		// out   [GPIO0] eth mdc
	inout			GPIO0_ETH_MDIO,		// inout [GPIO0] eth mdio
	inout			GPIO0_ETH_RXDV,		// inout [GPIO0] eth rxdv (MII/RMII mode)
	input			GPIO0_ETH_CRS,		// in    [GPIO0] eth crs
	input			GPIO0_ETH_RXER,		// in    [GPIO0] eth rxer
	input			GPIO0_ETH_COL,		// in    [GPIO0] eth col
	input	[3:0]	GPIO0_ETH_RXD,		// in    [GPIO0] eth rxd
	output			GPIO0_ETH_TXEN,		// out   [GPIO0] eth txen
	output	[3:0]	GPIO0_ETH_TXD,		// out   [GPIO0] eth txd
	output			GPIO0_SPD_TX,		// out   [GPIO0] optical tx
	input			GPIO0_SPD_RX,		// in    [GPIO0] optical rx
	output			GPIO0_DA0,			// out   [GPIO0] DA0(L) out
	output			GPIO0_DA1,			// out   [GPIO0] DA1(R) out
	input			GPIO0_SD_DO,		// in    [GPIO0] sd dout (<- card out)
	output			GPIO0_SD_SCK,		// out   [GPIO0] sd sck  (-> card in)
	output			GPIO0_SD_DI,		// out   [GPIO0] sd din  (-> card in)
	output			GPIO0_SD_CS,		// out   [GPIO0] sd cs   (-> card in)
	inout			GPIO0_USB0,			// inout [GPIO0] usb DM
	inout			GPIO0_USB1,			// inout [GPIO0] usb DP
	output			GPIO0_USB2,			// out   [GPIO0] usb host pd
	output			GPIO0_USB3,			// out   [GPIO0] usb dev DM pu
	output			GPIO0_USB4,			// out   [GPIO0] usb dev DP pu
	input			GPIO0_USB5,			// in    [GPIO0] usb dev power sense
	output			GPIO0_UTX,			// out   [GPIO0] uart tx out
	input			GPIO0_URX,			// in    [GPIO0] uart rx in

	inout	[7:0]	GPIO1_PC,		// inout [GPIO1] sv1
	inout	[7:0]	GPIO1_PB,		// inout [GPIO1] sv2
	inout	[7:0]	GPIO1_PA,		// inout [GPIO1] sv3
	inout	[1:0]	GPIO1_PF,		// inout [GPIO1] sv4
	inout	[3:0]	GPIO1_TX,		// out   [GPIO1] video out
	inout			GPIO1_PLLFB,	// out   [GPIO1] pllfb -> pll
	inout			GPIO1_HPD,		// in    [GPIO1] hpd in
	inout			GPIO1_SCL,		// inout [GPIO1] ddc scl
	inout			GPIO1_SDA,		// inout [GPIO1] ddc sda
	input			GPIO1_PLL,		// in    [GPIO1] pllfb -> pll
	input			GPIO1_CLK,		// in    [GPIO1] option (27MHz or 24.576MHz)

	input	[2:0]	BUTTON,			// in    [SW] button[2:0]

	input	[9:0]	SW,				// in    [SW] sw[9:0]

	output	[9:0]	LEDG,			// out   [LED] led green[9:0]
	output	[6:0]	HEX0_D,			// out   [LED] led hex0[6:0]
	output			HEX0_DP,		// out   [LED] led hex0 point
	output	[6:0]	HEX1_D,			// out   [LED] led hex1[6:0]
	output			HEX1_DP,		// out   [LED] led hex1 point
	output	[6:0]	HEX2_D,			// out   [LED] led hex2[6:0]
	output			HEX2_DP,		// out   [LED] led hex2 point
	output	[6:0]	HEX3_D,			// out   [LED] led hex3[6:0]
	output			HEX3_DP,		// out   [LED] led hex3 point

	inout			PS2_KBCLK,		// out   [KBD] clock
	inout			PS2_KBDAT,		// out   [KBD] data
	inout			PS2_MSCLK,		// out   [MS] clock
	inout			PS2_MSDAT,		// out   [MS] data
	input			UART_RXD,		// in    [UART] rxd
	output			UART_TXD,		// out   [UART] txd
	input			UART_RTS,		// in    [UART] rts
	output			UART_CTS,		// out   [UART] cts

	output	[3:0]	VGA_R,			// out   [VIDEO] red[3:0]
	output	[3:0]	VGA_G,			// out   [VIDEO] green[3:0]
	output	[3:0]	VGA_B,			// out   [VIDEO] blue[3:0]
	output			VGA_HS,			// out   [VIDEO] hsync
	output			VGA_VS,			// out   [VIDEO] vsync

	inout	[7:0]	LCD_DATA,		// inout [LCD] lcd data[7:0]
	output			LCD_RW,			// out   [LCD] lcd rw
	output			LCD_RS,			// out   [LCD] lcd rs
	output			LCD_EN,			// out   [LCD] lcd en
	output			LCD_BLON,		// out   [LCD] lcd backlight on

	output	[12:0]	DRAM_ADDR,		// out   [SDR] addr[12:0]
	output	[1:0]	DRAM_BA,		// out   [SDR] bank[1:0]
	output			DRAM_CAS_N,		// out   [SDR] #cas
	output			DRAM_CKE,		// out   [SDR] cke
	output			DRAM_CLK,		// out   [SDR] clk
	output			DRAM_CS_N,		// out   [SDR] #cs
	inout	[15:0]	DRAM_DQ,		// inout [SDR] data[15:0]
	output	[1:0]	DRAM_DQM,		// out   [SDR] dqm[1:0]
	output			DRAM_RAS_N,		// out   [SDR] #ras
	output			DRAM_WE_N,		// out   [SDR] #we

	output	[21:0]	FL_ADDR,		// out   [FLASH]
	inout	[15:0]	FL_DQ,			// inout [FLASH]
	output			FL_CE_N,		// out   [FLASH]
	output			FL_OE_N,		// out   [FLASH]
	output			FL_WE_N,		// out   [FLASH]
	output			FL_RST_N,		// out   [FLASH]
	output			FL_BYTE_N,		// out   [FLASH] flash #byte
	input			FL_RY,			// in    [FLASH] flash ready/#busy
	output			FL_WP_N,		// out   [FLASH] flash #wp

	input			SD_DAT,			// in    [SD] spi dat_i(sd -> host)
	output			SD_CMD,			// out   [SD] spi dat_o(host -> sd)
	output			SD_CLK,			// out   [SD] spi clk
	output			SD_DAT3,		// out   [SD] spi cs
	input			SD_WP_N			// in    [SD] sd #wp
);


//	assign GPIO0_D[31:0]=32'hzzzzzzzz;
//	assign GPIO0_CLKOUT[1:0]=2'bzz;
//	assign GPIO1_D[31:0]=32'hzzzzzzzz;
//	assign GPIO1_CLKOUT[1:0]=2'bzz;

	assign GPIO0_ETH_CLK=1'bz;
	assign GPIO0_ETH_RST_N=1'bz;
	assign GPIO0_ETH_MDC=1'bz;
	assign GPIO0_ETH_MDIO=1'bz;
	assign GPIO0_ETH_RXDV=1'bz;
	assign GPIO0_ETH_TXEN=1'bz;
	assign GPIO0_ETH_TXD[3:0]=4'hz;
	assign GPIO0_SPD_TX=1'bz;
	assign GPIO0_DA0=1'bz;
	assign GPIO0_DA1=1'bz;
	assign GPIO0_SD_SCK=1'bz;
	assign GPIO0_SD_DI=1'bz;
	assign GPIO0_SD_CS=1'bz;
	assign GPIO0_USB0=1'bz;
	assign GPIO0_USB1=1'bz;
	assign GPIO0_USB2=1'bz;
	assign GPIO0_USB3=1'bz;
	assign GPIO0_USB4=1'bz;
	assign GPIO0_UTX=1'bz;

	wire	UART_TXD1;
	wire	UART_RXD1;

//	assign GPIO1_PA[0]=1'bz;	// cts
//	assign GPIO1_PA[1]=UART_TXD1;	// txd
//	assign UART_RXD1=GPIO1_PA[2];	// rxd
//	assign GPIO1_PA[3]=1'bz;	// rts
//	assign GPIO1_PA[4]=1'bz;
//	assign GPIO1_PA[5]=1'bz;
//	assign GPIO1_PA[6]=1'bz;
//	assign GPIO1_PA[7]=1'bz;

	assign GPIO1_PC[7:0]=8'hzz;
	assign GPIO1_PB[7:0]=8'hzz;
	assign GPIO1_PA[7:0]=8'hzz;
	assign GPIO1_PF[1:0]=2'bzz;
	assign GPIO1_TX[3:0]=4'hz;
	assign GPIO1_PLLFB=1'bz;
	assign GPIO1_HPD=1'bz;
	assign GPIO1_SCL=1'bz;
	assign GPIO1_SDA=1'bz;

	assign PS2_KBCLK=1'bz;
	assign PS2_KBDAT=1'bz;
	assign PS2_MSCLK=1'bz;
	assign PS2_MSDAT=1'bz;
//	assign UART_TXD=1'bz;
	assign UART_CTS=1'bz;

	assign LEDG[9:0]=10'b0;
	assign HEX0_D[6:0]=7'hzz;
	assign HEX0_DP=1'bz;
	assign HEX1_D[6:0]=7'hzz;
	assign HEX1_DP=1'bz;
	assign HEX2_D[6:0]=7'hzz;
	assign HEX2_DP=1'bz;
	assign HEX3_D[6:0]=7'hzz;
	assign HEX3_DP=1'bz;

//	assign DRAM_ADDR[12:0]=13'h0000;
//	assign DRAM_BA[1:0]=2'b0;
//	assign DRAM_CAS_N=1'b1;
//	assign DRAM_CKE=1'b0;
//	assign DRAM_CLK=1'b0;
//	assign DRAM_CS_N=1'b1;
//	assign DRAM_DQ[15:0]=16'hzzzz;
//	assign DRAM_DQM[1:0]=1'b1;
//	assign DRAM_RAS_N=1'b1;
//	assign DRAM_WE_N=1'b1;

	assign SD_CMD=1'bz;
	assign SD_CLK=1'bz;
	assign SD_DAT3=1'bz;

	assign FL_CE_N=1'b1;
	assign FL_ADDR[21:0]=22'hzzzzzz;
	assign FL_DQ[15:0]=16'hzzzz;
	assign FL_OE_N=1'b1;
	assign FL_WE_N=1'b1;
	assign FL_RST_N=1'b0;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b0;

	assign VGA_R[3:0]=4'hz;
	assign VGA_G[3:0]=4'hz;
	assign VGA_B[3:0]=4'hz;
	assign VGA_HS=1'bz;
	assign VGA_VS=1'bz;

	assign LCD_DATA[7:0]=8'hzz;
	assign LCD_RW=1'bz;
	assign LCD_RS=1'bz;
	assign LCD_EN=1'bz;
	assign LCD_BLON=1'bz;

	wire	RST_IN_N;

	assign RST_IN_N=BUTTON[0];

	wire	SYSRST_N;
	wire	RESET_N;
	wire	pll0_rst_n;
	wire	pll1_rst_n;
	wire	pll0_locked;
	wire	pll1_locked;
	wire	CLK7;
	wire	CLK54;
	wire	CLK135;
	wire	CLK7_T0;
	wire	CLK7_T6;
	wire	MEM_INIT_DONE;

	reg		[4:0] rst0_r;
	reg		[8:0] rst_r;
	wire	[4:0] rst0_w;
	wire	[8:0] rst_w;
	reg		[3:0] clk54_div_r;
	reg		[1:0] clk54_cyc_r;
	wire	[3:0] clk54_div_w;
	wire	[1:0] clk54_cyc_w;

	assign SYSRST_N=pll0_locked;
	assign RESET_N=rst_r[8];
	assign pll0_rst_n=rst0_r[4];
	assign CLK7=clk54_div_r[3];
	assign CLK7_T0=clk54_cyc_r[0];
	assign CLK7_T6=clk54_cyc_r[1];

	always @(posedge CLOCK_50 or negedge RST_IN_N)
	begin
		if (RST_IN_N==1'b0)
			begin
				rst0_r[4:0] <= 5'b0;
			end
		else
			begin
				rst0_r[4:0] <= rst0_w[4:0];
			end
	end

	assign rst0_w[4]=(rst0_r[3:0]==4'hf) ? 1'b1 : rst0_r[4];
	assign rst0_w[3:0]=(rst0_r[4]==1'b1) ? 4'h0 : rst0_r[3:0]+4'h1;

	always @(posedge CLK54 or negedge pll0_locked)
	begin
		if (pll0_locked==1'b0)
			begin
				rst_r[8:0] <= 9'b0;
				clk54_div_r[3:0] <= 4'b0;
				clk54_cyc_r[1:0] <= 2'b0;
			end
		else
			begin
				rst_r[8:0] <= rst_w[8:0];
				clk54_div_r[3:0] <= clk54_div_w[3:0];
				clk54_cyc_r[1:0] <= clk54_cyc_w[1:0];
			end
	end

	assign rst_w[8]=
			(rst_r[3]==1'b0) ? 1'b0 :
			(rst_r[3]==1'b1) & (rst_r[7:4]==4'hf) ? 1'b1 :
			(rst_r[3]==1'b1) & (rst_r[7:4]!=4'hf) ? rst_r[8] :
			1'b0;
	assign rst_w[7:4]=(rst_r[3]==1'b0) & (rst_r[8]==1'b1) ? 8'h0 : rst_r[7:4]+4'h1;
	assign rst_w[3:0]={rst_r[2:0],MEM_INIT_DONE};

	assign clk54_div_w[3]=!clk54_div_w[2];
	assign clk54_div_w[2:0]=
			(clk54_div_r[2:0]==3'b000) ? 3'b001 :
			(clk54_div_r[2:0]==3'b001) ? 3'b010 :
			(clk54_div_r[2:0]==3'b010) ? 3'b011 :
			(clk54_div_r[2:0]==3'b011) ? 3'b100 :
			(clk54_div_r[2:0]==3'b100) ? 3'b101 :
			(clk54_div_r[2:0]==3'b101) ? 3'b110 :
			(clk54_div_r[2:0]==3'b110) ? 3'b000 :
			(clk54_div_r[2:0]==3'b111) ? 3'b000 :
			3'b000;

	assign clk54_cyc_w[1]=(clk54_div_r[2:0]==3'b101) ? 1'b1 : 1'b0;
	assign clk54_cyc_w[0]=clk54_cyc_r[1];

generate
	if (SIM_FAST==0)
begin

alt_altpll_50x54x135 pll_50x54x135(
	.areset(!pll0_rst_n),
	.inclk0(CLOCK_50),
	.c0(CLK54),
	.c1(CLK135),
	.locked(pll0_locked)
);

end
	else
begin

	assign CLK54=CLOCK_50;
	assign CLK135=CLOCK_50;
	assign pll0_locked=pll0_rst_n;

end
endgenerate

// 50/2=25 25*3*7/2/11=23.863 23.863*9/4=53.693
// 27*5*7/3/11=28.636 28.636*15/8=53.693
// 3.57(NTSC)*8=28.636 28.636*15/8=53.693
// 27*2=54

// 53.693/15=3.57
// 53.693/7=7.67

	// ---- TG68 ----

	wire	tg_clk;
	wire	tg_rst_n;
	wire	[15:0] tg_rdata;
	wire	[2:0] tg_ipl;
	wire	tg_dtak;
	wire	[31:0] tg_addr;
	wire	[15:0] tg_wdata;
	wire	tg_as;
	wire	tg_uds;
	wire	tg_lds;
	wire	tg_rw;
	wire	tg_doe;
	wire	[1:0] tg_be;

	assign tg_clk=CLK7;
	assign tg_rst_n=RESET_N;
	assign tg_ipl[2:0]=3'b111;
	assign tg_be[1:0]={tg_uds,tg_lds};

generate
	if (SIM_WO_TG68==0)
begin

TG68 TG68(
	.clk(tg_clk),				// in    [TG68] clk
	.reset(tg_rst_n),			// in    [TG68] #rst
	.clkena_in(1'b1),			// in    [TG68] 
	.data_in(tg_rdata[15:0]),	// in    [TG68] rd data[15:0]
	.IPL(tg_ipl[2:0]),			// in    [TG68] interrupt[2:0]
	.dtack(tg_dtak | tg_as),	// in    [TG68] data ack
	.addr(tg_addr[31:0]),		// out   [TG68] addr[31:0]
	.data_out(tg_wdata[15:0]),	// out   [TG68] wr data[15:0]
	.as(tg_as),					// out   [TG68] as
	.uds(tg_uds),				// out   [TG68] #uds
	.lds(tg_lds),				// out   [TG68] #lds
	.rw(tg_rw),					// out   [TG68] rd/wr
	.drive_data(tg_doe)			// out   [TG68] data oe
);

end
	else
begin

	assign tg_addr[31:0]=0;
	assign tg_wdata[15:0]=0;
	assign tg_as=1;
	assign tg_uds=1;
	assign tg_lds=1;
	assign tg_rw=1;
	assign tg_doe=1'b0;

end
endgenerate

	wire	[31:0] mem32_addr;
	wire	[31:0] mem32_wdata;
	wire	[31:0] mem32_rdata;
	wire	[3:0] mem32_be;
	wire	mem32_req;
	wire	mem32_ack;
	wire	mem32_rd;
	wire	mem32_t1;

tg68_mecb #(
	.DEVICE(DEVICE),				// 0=xilinx , 1=altera
	.baud(12'd24)					// uart_19200 : 7.71MHz - 19200x16
) tg68_mecb (
	.tg_clk(tg_clk),				// in    [TG68] clock
	.tg_rst_n(tg_rst_n),			// in    [TG68] #reset

	.tg_as(tg_as),					// in    [TG68] #as
	.tg_addr(tg_addr[31:0]),		// in    [TG68] addr[31:0]
	.tg_wdata(tg_wdata[15:0]),		// in    [TG68] wdata[15:0]
	.tg_rdata(tg_rdata[15:0]),		// out   [TG68] rdata[15:0]
	.tg_be(tg_be[1:0]),				// in    [TG68] #be[1:0]
	.tg_rw(tg_rw),					// in    [TG68] rd/#wr
	.tg_dtak(tg_dtak),				// out   [TG68] #ack

	.mem32_addr(mem32_addr[31:0]),		// out   [MEM] addr[31:0]
	.mem32_wdata(mem32_wdata[31:0]),	// out   [MEM] write data[31:0]
	.mem32_rdata(mem32_rdata[31:0]),	// in    [MEM] read data[31:0]
	.mem32_be(mem32_be[3:0]),			// out   [MEM] be[3:0]
	.mem32_req(mem32_req),				// out   [MEM] req
	.mem32_ack(mem32_ack),				// in    [MEM] ack
	.mem32_rd(mem32_rd),				// out   [MEM] rd/#we
	.mem32_t1(mem32_t1),				// out   [MEM] t1 cycle

	.TXD(UART_TXD),						// out   [TG68] uart tx 19200-8N1-NONE
	.RXD(UART_RXD),						// in    [TG68] uart rx 19200-8N1-NONE
	.TXD2(),							// out   [TG68] uart2 tx 19200-8N1-NONE
	.RXD2(1'b0)							// in    [TG68] uart2 rx 19200-8N1-NONE
);

	// ---- sdr-sdram ----

	wire	[15:0] DRAM_WDATA;
	wire	[15:0] DRAM_RDATA;
	wire	DRAM_OE;

	wire	mem0_req;
	wire	mem0_ack;
	wire	[31:0] mem0_addr;
	wire	[31:0] mem0_wdata;
	wire	[31:0] mem0_rdata;
	wire	[3:0] mem0_be;
	wire	mem0_rd;

	wire	mem0_t1;

	assign DRAM_DQ[15:0]=(DRAM_OE==1'b1) ? DRAM_WDATA[15:0] : 16'hzzzz;
	assign DRAM_RDATA[15:0]=DRAM_DQ[15:0];

	wire	mem1_req;
	wire	mem1_ack;
	wire	[31:0] mem1_addr;
	wire	[31:0] mem1_wdata;
	wire	[31:0] mem1_rdata;
	wire	[3:0] mem1_be;
	wire	mem1_rd;

	wire	mem2_req;
	wire	mem2_ack;
	wire	[31:0] mem2_addr;
	wire	[31:0] mem2_wdata;
	wire	[31:0] mem2_rdata;
	wire	[3:0] mem2_be;
	wire	mem2_rd;

	assign mem0_req=mem32_req;
	assign mem0_t1=mem32_t1;
	assign mem0_addr=mem32_addr[31:0];
	assign mem0_wdata=mem32_wdata[31:0];
	assign mem0_be=mem32_be[3:0];
	assign mem0_rd=mem32_rd;
	assign mem32_rdata[31:0]=mem0_rdata[31:0];
	assign mem32_ack=mem0_ack;

	assign mem1_req=1'b0;
	assign mem1_addr=32'b0;
	assign mem1_wdata=32'b0;
	assign mem1_be=4'b0;
	assign mem1_rd=1'b0;

	assign mem2_req=1'b0;
	assign mem2_addr=32'b0;
	assign mem2_wdata=32'b0;
	assign mem2_be=4'b0;
	assign mem2_rd=1'b0;

tg_sdr #(
	.DEVICE(DEVICE),			// 0=xilinx , 1=altera
	.SIM_FAST(SIM_FAST)	//
) sdrc (
	.sdr_addr(DRAM_ADDR[12:0]),		// out   [SDR] addr[12:0]
	.sdr_ba(DRAM_BA[1:0]),			// out   [SDR] bank[1:0]
	.sdr_cas_n(DRAM_CAS_N),			// out   [SDR] #cas
	.sdr_cke(DRAM_CKE),				// out   [SDR] cke
	.sdr_clk(DRAM_CLK),				// out   [SDR] clk
	.sdr_cs_n(DRAM_CS_N),			// out   [SDR] #cs
	.sdr_wdata(DRAM_WDATA[15:0]),	// out   [SDR] write data[15:0]
	.sdr_rdata(DRAM_RDATA[15:0]),	// in    [SDR] read data[15:0]
	.sdr_oe(DRAM_OE),				// out   [SDR] data oe
	.sdr_dqm(DRAM_DQM[1:0]),		// out   [SDR] dqm[1:0]
	.sdr_ras_n(DRAM_RAS_N),			// out   [SDR] #ras
	.sdr_we_n(DRAM_WE_N),			// out   [SDR] #we

	.mem0_req(mem0_req),			// in    [TG68] req
	.mem0_t1(mem0_t1),				// in    [TG68] t1
	.mem0_ack(mem0_ack),			// out   [TG68] ack
	.mem0_addr(mem0_addr[31:0]),	// in    [TG68] addr[31:0]
	.mem0_wdata(mem0_wdata[31:0]),	// in    [TG68] wdata[31:0]
	.mem0_rdata(mem0_rdata[31:0]),	// out   [TG68] rdata[31:0]
	.mem0_be(mem0_be[3:0]),			// in    [TG68] be[3:0]
	.mem0_rd(mem0_rd),				// in    [TG68] rd/#wr

	.mem1_req(mem1_req),			// in    [SYS] req
	.mem1_ack(mem1_ack),			// out   [SYS] ack
	.mem1_addr(mem1_addr[31:0]),	// in    [SYS] addr[31:0]
	.mem1_wdata(mem1_wdata[31:0]),	// in    [SYS] wdata[31:0]
	.mem1_rdata(mem1_rdata[31:0]),	// out   [SYS] rdata[31:0]
	.mem1_be(mem1_be[3:0]),			// in    [SYS] be[3:0]
	.mem1_rd(mem1_rd),				// in    [SYS] rd/#wr

	.mem2_req(mem2_req),			// in    [SYS] req
	.mem2_ack(mem2_ack),			// out   [SYS] ack
	.mem2_addr(mem2_addr[31:0]),	// in    [SYS] addr[31:0]
	.mem2_wdata(mem2_wdata[31:0]),	// in    [SYS] wdata[31:0]
	.mem2_rdata(mem2_rdata[31:0]),	// out   [SYS] rdata[31:0]
	.mem2_be(mem2_be[3:0]),			// in    [SYS] be[3:0]
	.mem2_rd(mem2_rd),				// in    [SYS] rd/#wr

	.mem_init_done(MEM_INIT_DONE),	// out   [SYS] init_done
	.mem_t0(CLK7_T0),				// in    [SYS] state T0
	.mem_clk(CLK54),				// in    [SYS] clk 54MHz
	.mem_rst_n(SYSRST_N)			// in    [SYS] #reset
);

endmodule

