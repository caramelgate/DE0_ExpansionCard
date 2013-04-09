//------------------------------------------------------------------------------
//
//  de0_nios2.v : de1_nios2 top module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2009/jun/22 release 0.0  
//
//------------------------------------------------------------------------------

module de0_nios2 (
//	inout	[31:0]	GPIO0_D,		// inout [TOP] gpio[31:0]
//	input	[1:0]	GPIO0_CLKIN,	// inout [TOP] clkin[1:0]
//	inout	[1:0]	GPIO0_CLKOUT,	// inout [TOP] clkout[1:0]
//	inout	[31:0]	GPIO1_D,		// inout [TOP] gpio[31:0]
//	input	[1:0]	GPIO1_CLKIN,	// inout [TOP] clkin[1:0]
//	inout	[1:0]	GPIO1_CLKOUT,	// inout [TOP] clkout[1:0]

	input			GPIO0_ETH_RXCLK,	// in    [GPIO0] eth rxclk
	input			GPIO0_ETH_TXCLK,	// in    [GPIO0] eth txclk
	output			GPIO0_ETH_CLK,		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
	input			GPIO0_ETH_CLKFB,	// in    [GPIO0] eth clkfb (RMII=50MHz)
	output			GPIO0_ETH_RST_N,	// out   [GPIO0] eth #rst
	output			GPIO0_ETH_MDC,		// out   [GPIO0] eth mdc
	inout			GPIO0_ETH_MDIO,		// inout [GPIO0] eth mdio
	input			GPIO0_ETH_RXDV,		// in    [GPIO0] eth rxdv (MII/RMII mode)
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
	input			GPIO1_HPD,		// in    [GPIO1] hpd in
	inout			GPIO1_SCL,		// inout [GPIO1] ddc scl
	inout			GPIO1_SDA,		// inout [GPIO1] ddc sda
	input			GPIO1_PLL,		// in    [GPIO1] pllfb -> pll
	input			GPIO1_CLK,		// in    [GPIO1] option (27MHz or 24.576MHz)

	// global signals
	input			CLOCK_50,		// in    [TOP] 50MHz
	input			CLOCK_50_2,		// in    [TOP] 50MHz

	// the_ps2_0
	inout			PS2_KBCLK,		// inout [TOP] kbd clk
	inout			PS2_KBDAT,		// inout [TOP] kbd data
	inout			PS2_MSCLK,		// inout [TOP] mouse clk
	inout			PS2_MSDAT,		// inout [TOP] mouse data

	// the_vga_controller_0
	output	[3:0]	VGA_B,			// out   [TOP] blue[3:0]
	output	[3:0]	VGA_G,			// out   [TOP] green[3:0]
	output	[3:0]	VGA_R,			// out   [TOP] red[3:0]
	output			VGA_HS,			// out   [TOP] hsync
	output			VGA_VS,			// out   [TOP] vsync

	// the_SEG7_Display
	output	[6:0]	HEX0_D,			// out   [TOP] hex data
	output			HEX0_DP,		// out   [TOP] hex point
	output	[6:0]	HEX1_D,			// out   [TOP] hex data
	output			HEX1_DP,		// out   [TOP] hex point
	output	[6:0]	HEX2_D,			// out   [TOP] hex data
	output			HEX2_DP,		// out   [TOP] hex point
	output	[6:0]	HEX3_D,			// out   [TOP] hex data
	output			HEX3_DP,		// out   [TOP] hex point

	// the_button_pio
	input	[2:0]	BUTTON,			// in    [TOP] button[2:0]

	// the_led_green
	output	[9:0]	LEDG,			// out   [TOP] led green[9:0]

	// the_sdram_0
	output	[11:0]	DRAM_ADDR,		// out   [TOP] sdram addr[11:0]
	output			DRAM_BA_0,		// out   [TOP] sdram ba[0]
	output			DRAM_BA_1,		// out   [TOP] sdram ba[1]
	output			DRAM_CAS_N,		// out   [TOP] sdram #cas
	output			DRAM_CKE,		// out   [TOP] sdram cke
	output			DRAM_CLK,		// out   [TOP] sdram clk
	output			DRAM_CS_N,		// out   [TOP] sdram #cs
	inout	[15:0]	DRAM_DQ,		// inout [TOP] sdram data[15:0]
	output			DRAM_LDQM,		// out   [TOP] sdram dqm[0]
	output			DRAM_UDQM,		// out   [TOP] sdram dqm[1]
	output			DRAM_RAS_N,		// out   [TOP] sdram #ras
	output			DRAM_WE_N,		// out   [TOP] sdram #we

	// the_spi_0
	input			SD_DAT,			// in    [TOP] sd dat
	output			SD_CMD,			// out   [TOP] sd cmd
	output			SD_CLK,			// out   [TOP] sd clk
	output			SD_DAT3,		// out   [TOP] sd dat3
	input			SD_WP_N,		// in    [TOP] sd #wp

	// the_lcd_0
	inout	[7:0]	LCD_DATA,		// inout [TOP] lcd data[7:0]
	output			LCD_RW,			// out   [TOP] lcd rw
	output			LCD_RS,			// out   [TOP] lcd rs
	output			LCD_EN,			// out   [TOP] lcd en
	output			LCD_BLON,		// out   [TOP] lcd backlight on
	// the_switch_pio
	input	[9:0]	SW,				// in    [TOP] sw[9:0]

	// the_tri_state_bridge_0_avalon_slave
	output			FL_CE_N,			// out   [TOP] flash #ce
	output	[21:0]	FL_ADDR,			// out   [TOP] flash addr[21:0]
	inout	[15:0]	FL_DQ,				// out   [TOP] flash data[15:0]
	output			FL_OE_N,			// out   [TOP] flash #oe
	output			FL_WE_N,			// out   [TOP] flash #we
	output			FL_RST_N,			// out   [TOP] flash #rst
	output			FL_BYTE_N,			// out   [TOP] flash #byte
	input			FL_RY,				// in    [TOP] flash ready/#busy
	output			FL_WP_N,			// out   [TOP] flash #wp

	// the_uart_0
	input			UART_RXD,			// in    [TOP] rxd
	output			UART_TXD,			// out   [TOP] txd
	input			UART_RTS,			// in    [TOP] rts
	output			UART_CTS			// out   [TOP] cts
);

//--------------------------------------------------------------
//  override parameter

//--------------------------------------------------------------
//  local parameter

//--------------------------------------------------------------
//  signal

	wire	RESET_N;
	wire	RST_N;

	wire	CLK25;
	wire	CLK100;
	wire	CLK100d;

//	wire	UART_CTS;
//	wire	UART_RTS;

//--------------------------------------------------------------
//  design

	wire	MMC_CD_N;
	wire	MMC_CS_N;
	wire	MMC_DOUT;

	reg		MMC_CS_n_r;
	reg		MMC_cd_in_r;
	reg		MMC_cd_led_r;
	reg		[3:0] MMC_cd_r;
	wire	MMC_CS_n_w;
	wire	MMC_cd_in_w;
	wire	MMC_cd_led_w;
	wire	[3:0] MMC_cd_w;

	assign MMC_CS_N=GPIO0_SD_CS;
	assign MMC_DOUT=GPIO0_SD_DO;
	assign MMC_CD_N=MMC_cd_r[3];	// in    0=ins / 1=eject

	always @(posedge CLK25 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				MMC_CS_n_r <= 1'b1;
				MMC_cd_in_r <= 1'b0;
				MMC_cd_led_r <= 1'b0;
				MMC_cd_r[3:0] <= 4'b1000;
			end
		else
			begin
				MMC_CS_n_r <= MMC_CS_n_w;
				MMC_cd_in_r <= MMC_cd_in_w;
				MMC_cd_led_r <= MMC_cd_led_w;
				MMC_cd_r[3:0] <= MMC_cd_w[3:0];
			end
	end

	assign MMC_CS_n_w=MMC_CS_N;
	assign MMC_cd_in_w=MMC_DOUT;
	assign MMC_cd_led_w=(MMC_cd_r[3]==1'b0) & (MMC_CS_N==1'b1) ? 1'b1 : 1'b0;

	assign MMC_cd_w[3]=
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b0) & (MMC_cd_r[2:0]==3'b111) ? 1'b1 :	// card eject
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b0) & (MMC_cd_r[2:0]!=3'b111) ? 1'b0 :	// card insert
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b1) ? 1'b0 :
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b0) ? 1'b0 :
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b1) & (MMC_cd_r[2:0]==3'b111) ? 1'b0 :	// card insert
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b1) & (MMC_cd_r[2:0]!=3'b111) ? 1'b1 :	// card eject
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b0) ? 1'b1 :
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b0) ? 1'b1 :
			1'b0;
	assign MMC_cd_w[2:0]=
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b0) ? 3'b0 :
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b0) ? MMC_cd_r[2:0]+3'b01 :
			(MMC_cd_r[3]==1'b0) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b1) ? 3'b0 :
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b0) ? 3'b0 :
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b1) ? MMC_cd_r[2:0]+3'b01 :
			(MMC_cd_r[3]==1'b1) & (MMC_CS_n_r==1'b1) & (MMC_cd_in_r==1'b0) ? 3'b0 :
			3'b0;


	// ---- board connect ----

	assign LCD_DATA[7:0]=8'hzz;
	assign LCD_RW=1'bz;
	assign LCD_RS=1'bz;
	assign LCD_EN=1'bz;
	assign LCD_BLON=1'bz;

	assign PS2_KBCLK=1'bz;
	assign PS2_KBDAT=1'bz;
	assign PS2_MSCLK=1'bz;
	assign PS2_MSDAT=1'bz;

	assign VGA_B=4'hz;
	assign VGA_G=4'hz;
	assign VGA_R=4'hz;
	assign VGA_HS=1'bz;
	assign VGA_VS=1'bz;

	assign {HEX0_D[6:0],HEX0_DP}=8'hzz;
	assign {HEX1_D[6:0],HEX1_DP}=8'hzz;
	assign {HEX2_D[6:0],HEX2_DP}=8'hzz;
	assign {HEX3_D[6:0],HEX3_DP}=8'hzz;
//	assign LEDG[9:0]=10'hzzz;
//	assign LEDG[9:0]=SW[9:0];

	assign LEDG[9:0]={10'b0,MMC_CD_N,RST_N,RESET_N,BUTTON[2:0]};

//	assign GPIO0_D[31:0]=32'hzzzzzzzz;
//	assign GPIO0_CLKIN[1:0]=2'bzz;
//	assign GPIO0_CLKOUT[1:0]=2'bzz;
//	assign GPIO1_D[31:0]=32'hzzzzzzzzz;
//	assign GPIO1_CLKIN[1:0]=2'bzz;
//	assign GPIO1_CLKOUT[1:0]=2'bzz;

/*
//	input			GPIO0_ETH_RXCLK
//	input			GPIO0_ETH_TXCLK
	assign GPIO0_ETH_CLK=1'bz;
//	input			GPIO0_ETH_CLKFB
	assign GPIO0_ETH_RST_N=1'bz;
	assign GPIO0_ETH_MDC=1'bz;
	assign GPIO0_ETH_MDIO=1'bz;
	assign GPIO0_ETH_RXDV=1'bz;
//	input			GPIO0_ETH_CRS
//	input			GPIO0_ETH_RXER
//	input			GPIO0_ETH_COL
//	input	[3:0]	GPIO0_ETH_RXD
	assign GPIO0_ETH_TXEN=1'bz;
	assign GPIO0_ETH_TXD[3:0]=4'hz;
*/
	assign GPIO0_SPD_TX=1'bz;
//	input			GPIO0_SPD_RX
	assign GPIO0_DA0=1'bz;
	assign GPIO0_DA1=1'bz;
//	input			GPIO0_SD_DO
//	assign GPIO0_SD_SCK=1'bz;
//	assign GPIO0_SD_DI=1'bz;
//	assign GPIO0_SD_CS=1'bz;
	assign GPIO0_USB0=1'bz;
	assign GPIO0_USB1=1'bz;
	assign GPIO0_USB2=1'bz;
	assign GPIO0_USB3=1'bz;
	assign GPIO0_USB4=1'bz;
//	input			GPIO0_USB5
	assign GPIO0_UTX=1'bz;
//	input			GPIO0_URX

	assign GPIO1_PC[7:0]=8'hzz;
	assign GPIO1_PB[7:0]=8'hzz;
	assign GPIO1_PA[7:0]=8'hzz;
	assign GPIO1_PF[1:0]=2'bzz;
	assign GPIO1_TX[3:0]=4'hz;
	assign GPIO1_PLLFB=1'bz;
//	assign GPIO1_HPD
	assign GPIO1_SCL=1'bz;
	assign GPIO1_SDA=1'bz;

	// ---- user interface ----

	// ---- clock ----

	wire	pll_locked;

	assign RESET_N=BUTTON[0];

alt_pll_50x100x100d pll_50x100x100d(
	.areset(!RESET_N),
	.inclk0(CLOCK_50),
	.c0(CLK100),
	.c1(CLK100d),
	.locked(pll_locked)
);

	assign DRAM_CLK=CLK100d;
//	assign DRAM_CLK=CLK100;

	reg		CLK50_DIV_r;
	reg		[7:0] CLK50_DLY_r;
	reg		CLK50_DLY_OUT_r;
	reg		pll_locked_r;

	wire	CLK25_RST_N;
	wire	CLK25_RST_OUT_N;

	assign CLK25=CLK50_DIV_r;
	assign CLK25_RST_N=CLK50_DLY_r[7];
	assign CLK25_RST_OUT_N=CLK50_DLY_OUT_r;

	assign RST_N=CLK25_RST_OUT_N;

	always @(posedge CLOCK_50 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				pll_locked_r <= 1'b0;
				CLK50_DIV_r <= 1'b0;
				CLK50_DLY_r[7:0] <= 8'b0;
				CLK50_DLY_OUT_r <= 1'b0;
			end
		else
			begin
				pll_locked_r <= pll_locked;
				CLK50_DIV_r <= !CLK50_DIV_r;
				CLK50_DLY_r[7] <=
					(pll_locked_r==1'b0) ? 1'b0 :
					(pll_locked_r==1'b1) & (CLK50_DLY_r[6:0]==7'h7f) ? 1'b1 :
					(pll_locked_r==1'b1) & (CLK50_DLY_r[6:0]!=7'h7f) ? CLK50_DLY_r[7] :
					1'b0;
				CLK50_DLY_r[6:0]=
					(pll_locked_r==1'b0) ? 7'b0 :
					(pll_locked_r==1'b1) & (CLK50_DLY_r[7]==1'b1) ? 7'b0 :
					(pll_locked_r==1'b1) & (CLK50_DLY_r[7]==1'b0) ? CLK50_DLY_r[6:0]+7'b01 :
					7'b0;
				CLK50_DLY_OUT_r <= CLK50_DLY_r[7];
			end
	end

	// ---- nios2 ----

	assign FL_RST_N=RESET_N;
//	assign UART_CTS=UART_RTS;
	assign FL_BYTE_N=1'b0;
	assign FL_WP_N=1'b1;
	assign FL_DQ[15:8]=8'hzz;

  wire             mcoll_pad_i_to_the_igor_mac;
  wire             mcrs_pad_i_to_the_igor_mac;
  wire             md_pad_i_to_the_igor_mac;
  wire             md_pad_o_from_the_igor_mac;
  wire             md_padoe_o_from_the_igor_mac;
  wire             mdc_pad_o_from_the_igor_mac;
  wire             mrx_clk_pad_i_to_the_igor_mac;
  wire    [  3: 0] mrxd_pad_i_to_the_igor_mac;
  wire             mrxdv_pad_i_to_the_igor_mac;
  wire             mrxerr_pad_i_to_the_igor_mac;
  wire             mtx_clk_pad_i_to_the_igor_mac;
  wire    [  3: 0] mtxd_pad_o_from_the_igor_mac;
  wire             mtxen_pad_o_from_the_igor_mac;
  wire             mtxerr_pad_o_from_the_igor_mac;

//	input			GPIO0_ETH_RXCLK,	// in    [GPIO0] eth rxclk
//	input			GPIO0_ETH_TXCLK,	// in    [GPIO0] eth txclk
//	output			GPIO0_ETH_CLK,		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
//	input			GPIO0_ETH_CLKFB,	// in    [GPIO0] eth clkfb (RMII=50MHz)
//	output			GPIO0_ETH_RST_N,	// out   [GPIO0] eth #rst
//	output			GPIO0_ETH_MDC,		// out   [GPIO0] eth mdc
//	inout			GPIO0_ETH_MDIO,		// inout [GPIO0] eth mdio
//	inout			GPIO0_ETH_RXDV,		// inout [GPIO0] eth rxdv (MII/RMII mode)
//	input			GPIO0_ETH_CRS,		// in    [GPIO0] eth crs
//	input			GPIO0_ETH_RXER,		// in    [GPIO0] eth rxer
//	input			GPIO0_ETH_COL,		// in    [GPIO0] eth col
//	input	[3:0]	GPIO0_ETH_RXD,		// in    [GPIO0] eth rxd
//	output			GPIO0_ETH_TXEN,		// out   [GPIO0] eth txen
//	output	[3:0]	GPIO0_ETH_TXD,		// out   [GPIO0] eth txd

/*
	assign GPIO0_ETH_RXDV=1'bz;

	assign GPIO0_ETH_RST_N=CLK25_RST_OUT_N;
	assign GPIO0_ETH_CLK=CLK25;
	assign mcoll_pad_i_to_the_igor_mac=GPIO0_ETH_COL;
	assign mcrs_pad_i_to_the_igor_mac=GPIO0_ETH_CRS;
	assign md_pad_i_to_the_igor_mac=GPIO0_ETH_MDIO;
	assign GPIO0_ETH_MDIO=(md_padoe_o_from_the_igor_mac==1'b1) ? md_pad_o_from_the_igor_mac : 1'bz;
	assign GPIO0_ETH_MDC=mdc_pad_o_from_the_igor_mac;
	assign mrx_clk_pad_i_to_the_igor_mac=GPIO0_ETH_RXCLK;
	assign mrxd_pad_i_to_the_igor_mac[3:0]=GPIO0_ETH_RXD[3:0];
	assign mrxdv_pad_i_to_the_igor_mac=GPIO0_ETH_RXDV;
	assign mrxerr_pad_i_to_the_igor_mac=GPIO0_ETH_RXER;
	assign mtx_clk_pad_i_to_the_igor_mac=GPIO0_ETH_TXCLK;
	assign GPIO0_ETH_TXD[3:0]=mtxd_pad_o_from_the_igor_mac[3:0];
	assign GPIO0_ETH_TXEN=mtxen_pad_o_from_the_igor_mac;
*/

	assign GPIO0_ETH_RST_N=CLK25_RST_OUT_N;
	assign GPIO0_ETH_CLK=CLK25;
	assign mrx_clk_pad_i_to_the_igor_mac=GPIO0_ETH_RXCLK;
	assign mtx_clk_pad_i_to_the_igor_mac=GPIO0_ETH_TXCLK;
	assign GPIO0_ETH_MDIO=(md_padoe_o_from_the_igor_mac==1'b1) ? md_pad_o_from_the_igor_mac : 1'bz;
	assign GPIO0_ETH_MDC=mdc_pad_o_from_the_igor_mac;
	assign GPIO0_ETH_TXD[0]=mtxd_pad_o_from_the_igor_mac[0];
	assign GPIO0_ETH_TXD[1]=mtxd_pad_o_from_the_igor_mac[1];
	assign GPIO0_ETH_TXD[2]=mtxd_pad_o_from_the_igor_mac[2];
	assign GPIO0_ETH_TXD[3]=mtxd_pad_o_from_the_igor_mac[3];
	assign GPIO0_ETH_TXEN=mtxen_pad_o_from_the_igor_mac;
	assign mcoll_pad_i_to_the_igor_mac=GPIO0_ETH_COL;
	assign mcrs_pad_i_to_the_igor_mac=GPIO0_ETH_CRS;
	assign md_pad_i_to_the_igor_mac=GPIO0_ETH_MDIO;
	assign mrxd_pad_i_to_the_igor_mac[3:0]=GPIO0_ETH_RXD[3:0];
	assign mrxdv_pad_i_to_the_igor_mac=GPIO0_ETH_RXDV;
	assign mrxerr_pad_i_to_the_igor_mac=GPIO0_ETH_RXER;

/*
	assign GPIO1_D[1]=1'bz;
	assign GPIO1_D[2]=1'bz;
	assign GPIO1_D[3]=1'bz;
	assign GPIO1_D[6]=1'b0;
	assign GPIO1_D[18]=1'bz;
	assign GPIO1_D[31:20]=12'hzzz;

//	assign GPIO1_D[5]=CLK25_RST_OUT_N;
//	assign GPIO1_D[0]=CLK25;
//	assign mcoll_pad_i_to_the_igor_mac=GPIO1_D[10];
//	assign mcrs_pad_i_to_the_igor_mac=GPIO1_D[8];
//	assign md_pad_i_to_the_igor_mac=GPIO1_D[4];
//	assign GPIO1_D[4]=(md_padoe_o_from_the_igor_mac==1'b1) ? md_pad_o_from_the_igor_mac : 1'bz;
//	assign GPIO1_D[7]=mdc_pad_o_from_the_igor_mac;
//	assign mrx_clk_pad_i_to_the_igor_mac=GPIO1_CLKIN[0];
//	assign mrxd_pad_i_to_the_igor_mac[3:0]={GPIO1_CLKOUT[0],GPIO1_D[14],GPIO1_D[12],GPIO1_D[13]};
//	assign mrxdv_pad_i_to_the_igor_mac=GPIO1_D[9];
//	assign mrxerr_pad_i_to_the_igor_mac=GPIO1_D[11];
//	assign mtx_clk_pad_i_to_the_igor_mac=GPIO1_CLKIN[1];
//	assign GPIO1_D[19]=mtxd_pad_o_from_the_igor_mac[3];
//	assign GPIO1_D[16]=mtxd_pad_o_from_the_igor_mac[2];
//	assign GPIO1_D[17]=mtxd_pad_o_from_the_igor_mac[1];
//	assign GPIO1_CLKOUT[1]=mtxd_pad_o_from_the_igor_mac[0];
//	assign GPIO1_D[15]=mtxen_pad_o_from_the_igor_mac;

	assign GPIO1_D[5]=1'bz;
	assign GPIO1_D[0]=1'bz;
	assign GPIO1_D[4]=1'bz;
	assign GPIO1_D[7]=1'bz;
	assign {GPIO1_D[19],GPIO1_D[16],GPIO1_D[17],GPIO1_CLKOUT[1]}=4'bzzzz;
	assign GPIO1_D[15]=1'bz;

//	assign GPIO1_CLKIN[0]=1'bz;
//	assign GPIO1_CLKIN[1]=1'bz;

	assign GPIO1_D[8]=1'bz;
	assign GPIO1_D[9]=1'bz;
	assign GPIO1_D[10]=1'bz;
	assign GPIO1_D[11]=1'bz;
	assign GPIO1_D[12]=1'bz;
	assign GPIO1_D[13]=1'bz;
	assign GPIO1_CLKOUT[0]=1'bz;
	assign GPIO1_D[14]=1'bz;
*/

	assign SD_CMD=1'bz;
	assign SD_CLK=1'bz;
	assign SD_DAT3=1'bz;

  nios2 DUT
    (
      .MISO_to_the_spi_0                       (GPIO0_SD_DO), //SD_DAT),
      .MOSI_from_the_spi_0                     (GPIO0_SD_DI), //SD_CMD),
      .SCLK_from_the_spi_0                     (GPIO0_SD_SCK), //SD_CLK),
      .SS_n_from_the_spi_0                     (GPIO0_SD_CS), //SD_DAT3),
      .clk                                     (CLK100),
      .cts_n_to_the_uart_0                     (UART_CTS),
      .mcoll_pad_i_to_the_igor_mac    (mcoll_pad_i_to_the_igor_mac),
      .mcrs_pad_i_to_the_igor_mac     (mcrs_pad_i_to_the_igor_mac),
      .md_pad_i_to_the_igor_mac       (md_pad_i_to_the_igor_mac),
      .md_pad_o_from_the_igor_mac     (md_pad_o_from_the_igor_mac),
      .md_padoe_o_from_the_igor_mac   (md_padoe_o_from_the_igor_mac),
      .mdc_pad_o_from_the_igor_mac    (mdc_pad_o_from_the_igor_mac),
      .mrx_clk_pad_i_to_the_igor_mac  (mrx_clk_pad_i_to_the_igor_mac),
      .mrxd_pad_i_to_the_igor_mac     (mrxd_pad_i_to_the_igor_mac),
      .mrxdv_pad_i_to_the_igor_mac    (mrxdv_pad_i_to_the_igor_mac),
      .mrxerr_pad_i_to_the_igor_mac   (mrxerr_pad_i_to_the_igor_mac),
      .mtx_clk_pad_i_to_the_igor_mac  (mtx_clk_pad_i_to_the_igor_mac),
      .mtxd_pad_o_from_the_igor_mac   (mtxd_pad_o_from_the_igor_mac),
      .mtxen_pad_o_from_the_igor_mac  (mtxen_pad_o_from_the_igor_mac),
      .mtxerr_pad_o_from_the_igor_mac (mtxerr_pad_o_from_the_igor_mac),
      .reset_n                                 (CLK25_RST_N),
      .rts_n_from_the_uart_0                   (UART_RTS),
      .rxd_to_the_uart_0                       (UART_RXD),
      .select_n_to_the_cfi_flash_0             (FL_CE_N),
      .tri_state_bridge_0_address              (FL_ADDR[21:0]),
      .tri_state_bridge_0_data                 (FL_DQ[7:0]),
      .tri_state_bridge_0_readn                (FL_OE_N),
      .txd_from_the_uart_0                     (UART_TXD),
      .write_n_to_the_cfi_flash_0              (FL_WE_N),
      .zs_addr_from_the_sdram_0                (DRAM_ADDR[11:0]),
      .zs_ba_from_the_sdram_0                  ({DRAM_BA_1,DRAM_BA_0}),
      .zs_cas_n_from_the_sdram_0               (DRAM_CAS_N),
      .zs_cke_from_the_sdram_0                 (DRAM_CKE),
      .zs_cs_n_from_the_sdram_0                (DRAM_CS_N),
      .zs_dq_to_and_from_the_sdram_0           (DRAM_DQ[15:0]),
      .zs_dqm_from_the_sdram_0                 ({DRAM_UDQM,DRAM_LDQM}),
      .zs_ras_n_from_the_sdram_0               (DRAM_RAS_N),
      .zs_we_n_from_the_sdram_0                (DRAM_WE_N)
    );

endmodule
