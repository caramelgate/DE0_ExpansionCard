//-----------------------------------------------------------------------------
//
//  de0ec8.v : de0ec8 pfl module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/18 release 0.0  connection test
//
//------------------------------------------------------------------------------

module de0ec8 #(
	parameter	DEVICE=1,		// 1=altera
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
	assign UART_TXD=1'bz;
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

	assign DRAM_ADDR[12:0]=13'h0000;
	assign DRAM_BA[1:0]=2'b0;
	assign DRAM_CAS_N=1'b1;
	assign DRAM_CKE=1'b0;
	assign DRAM_CLK=1'b0;
	assign DRAM_CS_N=1'b1;
	assign DRAM_DQ[15:0]=16'hzzzz;
	assign DRAM_DQM[1:0]=1'b1;
	assign DRAM_RAS_N=1'b1;
	assign DRAM_WE_N=1'b1;

	assign SD_CMD=1'bz;
	assign SD_CLK=1'bz;
	assign SD_DAT3=1'bz;

//	assign FL_CE_N=1'b1;
//	assign FL_ADDR[21:0]=22'hzzzzzz;
//	assign FL_DQ[15:0]=16'hzzzz;
//	assign FL_OE_N=1'b1;
//	assign FL_WE_N=1'b1;
//	assign FL_RST_N=1'b0;
//	assign FL_BYTE_N=1'b1;
//	assign FL_WP_N=1'b0;

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

//	assign FL_CE_N=1'b1;
//	assign FL_ADDR[21:0]=22'hzzzzzz;
//	assign FL_DQ[15:0]=16'hzzzz;
//	assign FL_OE_N=1'b1;
//	assign FL_WE_N=1'b1;
	assign FL_RST_N=RST_IN_N;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b1;

	assign FL_ADDR[21]=1'h0;

alt_de0_PFL de0_PFL (
	.pfl_flash_access_granted(1'b1),
	.pfl_nreset(RST_IN_N),
	.flash_addr(FL_ADDR[20:0]),
	.flash_data(FL_DQ[15:0]),
	.flash_nce(FL_CE_N),
	.flash_noe(FL_OE_N),
	.flash_nwe(FL_WE_N),
	.pfl_flash_access_request()
);

endmodule

