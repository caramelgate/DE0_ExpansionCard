//-----------------------------------------------------------------------------
//
//  de0ec8_25drv.v : megadrive 25th anniversary top module
//
//  LICENSE : as-is
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/16 release 0.0  rewreite fpgagen and connection test
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
`define video_out
//`define dvi_out
//`define dai_in
//`define dai_out
//`define dac_ip
`define dac_out
//`define use_hid

module de0ec8_25drv #(
	parameter	DEVICE=1,		// 1=altera
	parameter	SIM_WO_TG68=0,	// reduced simulation : without TG68
	parameter	SIM_WO_SDR=0,	// redused simulation : without sdr-sdram
	parameter	SIM_FAST=0,		// fast simulation
	parameter	SIM_WO_VDP=0,	//
	parameter	SIM_WO_OS=1,	//
	parameter	opn2=1,			// 0=rtl / 1=connect YM2612
	parameter	vdp_sca=1,		// 0=kill
	parameter	vdp_scb=1,		// 0=kill
	parameter	vdp_spr=1,		// 0=kill
	parameter	pad_1p=1,		// 0=kill
	parameter	pad_2p=0,		// 0=kill
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
	output	[3:0]	GPIO1_TX,		// out   [GPIO1] video out
	output			GPIO1_PLLFB,	// out   [GPIO1] pllfb -> pll
	input			GPIO1_HPD,		// in    [GPIO1] hpd in
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
//	assign GPIO0_ETH_RXDV=1'bz;
	assign GPIO0_ETH_TXEN=1'bz;
	assign GPIO0_ETH_TXD[3:0]=4'hz;
//	assign GPIO0_SPD_TX=1'bz;
//	assign GPIO0_DA0=1'bz;
//	assign GPIO0_DA1=1'bz;
	assign GPIO0_SD_SCK=1'bz;
	assign GPIO0_SD_DI=1'bz;
	assign GPIO0_SD_CS=1'bz;
//	assign GPIO0_USB0=1'bz;
//	assign GPIO0_USB1=1'bz;
//	assign GPIO0_USB2=1'bz;
//	assign GPIO0_USB3=1'bz;
//	assign GPIO0_USB4=1'bz;
	assign GPIO0_UTX=1'bz;

//	wire	UART_TXD1;
//	wire	UART_RXD1;
//	assign GPIO1_PA[0]=1'bz;	// cts
//	assign GPIO1_PA[1]=UART_TXD1;	// txd
//	assign UART_RXD1=GPIO1_PA[2];	// rxd
//	assign GPIO1_PA[3]=1'bz;	// rts
//	assign GPIO1_PA[4]=1'bz;
//	assign GPIO1_PA[5]=1'bz;
//	assign GPIO1_PA[6]=1'bz;
//	assign GPIO1_PA[7]=1'bz;

//	assign LEDG[9:8]=2'b0;
//	assign LEDG[7:0]=GPIO1_PB[7:0];

	assign GPIO1_PC[7:0]=8'hzz;
//	assign GPIO1_PB[7:0]=8'hzz;
//	assign GPIO1_PA[7:0]=8'hzz;
	assign GPIO1_PF[1:0]=2'bzz;
	assign GPIO1_TX[3:0]=4'hz;
	assign GPIO1_PLLFB=1'bz;
//	assign GPIO1_HPD=1'bz;
	assign GPIO1_SCL=1'bz;
	assign GPIO1_SDA=1'bz;

	assign PS2_KBCLK=1'bz;
	assign PS2_KBDAT=1'bz;
	assign PS2_MSCLK=1'bz;
	assign PS2_MSDAT=1'bz;
	assign UART_TXD=1'bz;
	assign UART_CTS=1'bz;

//	assign LEDG[9:0]=10'b0;
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

//	assign FL_CE_N=1'b1;
//	assign FL_ADDR[21:0]=22'hzzzzzz;
//	assign FL_DQ[15:0]=16'hzzzz;
//	assign FL_OE_N=1'b1;
//	assign FL_WE_N=1'b1;
//	assign FL_RST_N=1'b0;
//	assign FL_BYTE_N=1'b1;
//	assign FL_WP_N=1'b0;

//	assign VGA_R[3:0]=4'hz;
//	assign VGA_G[3:0]=4'hz;
//	assign VGA_B[3:0]=4'hz;
//	assign VGA_HS=1'bz;
//	assign VGA_VS=1'bz;

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
	wire	CLK50;
	wire	CLK25;
	wire	CLK27;
	wire	CLK54;
	wire	CLK135;
	wire	CLK7_T0;
	wire	CLK7_T6;
	wire	MEM_INIT_DONE;

	wire	CLK16;
	wire	CLK4;
	wire	CLK12;

	wire	SYSRST_N_w;
	reg		SYSRST_N_r;
	reg		[8:0] rst0_r;
	reg		[8:0] rst_r;
	wire	[8:0] rst0_w;
	wire	[8:0] rst_w;
	reg		[3:0] clk54_div_r;
	reg		[1:0] clk54_cyc_r;
	wire	[3:0] clk54_div_w;
	wire	[1:0] clk54_cyc_w;

	reg		[1:0] clk50_div_r;
	wire	[1:0] clk50_div_w;

	assign SYSRST_N=SYSRST_N_r;
	assign RESET_N=rst_r[8];
	assign pll0_rst_n=rst0_r[8];
	assign CLK7=clk54_div_r[3];
	assign CLK7_T0=clk54_cyc_r[0];
	assign CLK7_T6=clk54_cyc_r[1];
	assign CLK50=CLOCK_50;
	assign CLK25=clk50_div_r[0];

	always @(posedge CLOCK_50 or negedge RST_IN_N)
	begin
		if (RST_IN_N==1'b0)
			begin
				rst0_r[8:0] <= 9'b0;
				clk50_div_r[1:0] <= 2'b0;
			end
		else
			begin
				rst0_r[8:0] <= rst0_w[8:0];
				clk50_div_r[1:0] <= clk50_div_w[1:0];
			end
	end

	assign rst0_w[8]=(rst0_r[7:0]==8'hff) ? 1'b1 : rst0_r[8];
	assign rst0_w[7:0]=(rst0_r[8]==1'b1) ? 8'h0 : rst0_r[7:0]+8'h1;
	assign clk50_div_w[1:0]=clk50_div_r[1:0]+2'b01;

	always @(posedge CLK54 or negedge pll0_locked)
	begin
		if (pll0_locked==1'b0)
			begin
				SYSRST_N_r <= 1'b0;
				rst_r[8:0] <= 9'b0;
				clk54_div_r[3:0] <= 4'b0;
				clk54_cyc_r[1:0] <= 2'b0;
			end
		else
			begin
				SYSRST_N_r <= SYSRST_N_w;
				rst_r[8:0] <= rst_w[8:0];
				clk54_div_r[3:0] <= clk54_div_w[3:0];
				clk54_cyc_r[1:0] <= clk54_cyc_w[1:0];
			end
	end

	assign SYSRST_N_w=(pll0_locked==1'b1) & (pll0_rst_n==1'b1) ? 1'b1 : 1'b0;

//	assign rst_w[8]=
//			(rst_r[3]==1'b0) ? 1'b0 :
//			(rst_r[3]==1'b1) & (rst_r[8]==1'b1) ? 1'b1 :
//			(rst_r[3]==1'b1) & (rst_r[8]==1'b0) & (rst_r[7:4]==4'hf) ? 1'b1 :
//			(rst_r[3]==1'b1) & (rst_r[8]==1'b0) & (rst_r[7:4]!=4'hf) ? 1'b0 :
//			1'b0;
//	assign rst_w[7:4]=(rst_r[3]==1'b1) & (rst_r[8]==1'b0) ? rst_r[7:4]+4'h1 : 8'h0;
//	assign rst_w[3:0]={rst_r[2:0],MEM_INIT_DONE};

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

alt_altpll_50x16x4x12 pll_50x16x4x12(
	.areset(!pll0_rst_n),
	.inclk0(CLOCK_50),
	.c0(clk16),
	.c1(clk4),
	.c2(CLK12),
	.locked(pll1_locked)
);

end
	else
begin

	assign CLK54=CLOCK_50;
	assign CLK135=CLOCK_50;
	assign pll0_locked=pll0_rst_n;

	assign clk16=CLK50;
	assign clk4=CLK25;
	assign CLK12=CLOCK_50_2;
	assign pll1_locked=pll0_rst_n;

end
endgenerate

// 50/2=25 25*3*7/2/11=23.863 23.863*9/4=53.693
// 27*5*7/3/11=28.636 28.636*15/8=53.693
// 3.57(NTSC)*8=28.636 28.636*15/8=53.693
// 27*2=54

// 53.693/15=3.57
// 53.693/7=7.67

	// ---- display out ----

	wire	[7:0] TX_RED;
	wire	[7:0] TX_GRN;
	wire	[7:0] TX_BLU;
	wire	TX_HS;
	wire	TX_VS;
	wire	TX_DE;
	wire	TX_CLK;
	wire	TX_CLKx5;

	assign TX_CLKx5=CLK135;

`ifndef video_out

	assign VGA_R[3:0]=4'hz;
	assign VGA_G[3:0]=4'hz;
	assign VGA_B[3:0]=4'hz;
	assign VGA_HS=1'bz;
	assign VGA_VS=1'bz;

`else

	reg		[3:0] VGA_R_r;
	reg		[3:0] VGA_G_r;
	reg		[3:0] VGA_B_r;
	reg		VGA_HS_r;
	reg		VGA_VS_r;

	reg		[3:0] VGA_R_out_r;
	reg		[3:0] VGA_G_out_r;
	reg		[3:0] VGA_B_out_r;
	reg		VGA_HS_out_r;
	reg		VGA_VS_out_r;

	wire	VGA_FIELD;

	reg		[3:0] VGA_FIELD_r;
	wire	[3:0] VGA_FIELD_w;

	assign VGA_R[3:0]=VGA_R_out_r[3:0];
	assign VGA_G[3:0]=VGA_G_out_r[3:0];
	assign VGA_B[3:0]=VGA_B_out_r[3:0];
	assign VGA_HS=VGA_HS_out_r;
	assign VGA_VS=VGA_VS_out_r;

	assign VGA_FIELD=VGA_FIELD_r[2];

	reg		[15:0] DEBUG_VDP_r;
	reg		[15:0] DEBUG_OUT_r;
	reg		[3:0] DEBUG_SEL_r;
	reg		[3:0] DEBUG_DISP_r;

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				DEBUG_VDP_r[15:0] <= 16'b0;
				DEBUG_OUT_r[15:0] <= 16'b0;
				DEBUG_SEL_r[3:0] <= 4'b0;
			end
		else
			begin
				DEBUG_VDP_r[15:0] <= DEBUG_VDP[15:0];
				DEBUG_OUT_r[15:0] <= DEBUG_OUT[15:0];
				DEBUG_SEL_r[0] <= DEBUG_OUT_r[3];
				DEBUG_SEL_r[1] <= DEBUG_OUT_r[4];
				DEBUG_SEL_r[2] <= !DEBUG_OUT_r[5];
				DEBUG_SEL_r[3] <= !DEBUG_OUT_r[6];
			end
	end

//	always @(posedge TX_CLK or negedge RESET_N)
	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				DEBUG_DISP_r[3:0] <= 4'b0;
				VGA_R_r[3:0] <= 4'b0;
				VGA_G_r[3:0] <= 4'b0;
				VGA_B_r[3:0] <= 4'b0;
				VGA_HS_r <= 1'b0;
				VGA_VS_r <= 1'b0;
				VGA_R_out_r[3:0] <= 4'b0;
				VGA_G_out_r[3:0] <= 4'b0;
				VGA_B_out_r[3:0] <= 4'b0;
				VGA_HS_out_r <= 1'b0;
				VGA_VS_out_r <= 1'b0;
				VGA_FIELD_r[3:0] <= 4'b0;
			end
		else
			begin
				DEBUG_DISP_r[3:0] <= (TX_CLK==1'b1) ? DEBUG_SEL_r[3:0] : DEBUG_DISP_r[3:0];

`ifdef debug_disp
				VGA_R_r[3:0] <= //(TX_DE==1'b1) ? TX_RED[7:4] : 4'b0;
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[0]==1'b0) ? TX_RED[7:4] :
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[0]==1'b1) ? 4'hf :
					(TX_CLK==1'b0) ? VGA_R_r[3:0] :
					4'b0;
				VGA_G_r[3:0] <= //(TX_DE==1'b1) ? TX_GRN[7:4] : 4'b0;
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[1]==1'b0) ? TX_GRN[7:4] :
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[1]==1'b1) ? 4'hf :
					(TX_CLK==1'b0) ? VGA_G_r[3:0] :
					4'b0;
				VGA_B_r[3:0] <= //(TX_DE==1'b1) ? TX_BLU[7:4] : 4'b0;
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[2]==1'b0) ? TX_BLU[7:4] :
					(TX_CLK==1'b1) & (TX_DE==1'b1) & (DEBUG_DISP_r[2]==1'b1) ? 4'hf :
					(TX_CLK==1'b0) ? VGA_B_r[3:0] :
					4'b0;
`else
				VGA_R_r[3:0] <= 
					(TX_CLK==1'b1) & (TX_DE==1'b1) ? TX_RED[7:4] :
					(TX_CLK==1'b0) ? VGA_R_r[3:0] :
					4'b0;
				VGA_G_r[3:0] <= 
					(TX_CLK==1'b1) & (TX_DE==1'b1) ? TX_GRN[7:4] :
					(TX_CLK==1'b0) ? VGA_G_r[3:0] :
					4'b0;
				VGA_B_r[3:0] <= 
					(TX_CLK==1'b1) & (TX_DE==1'b1) ? TX_BLU[7:4] :
					(TX_CLK==1'b0) ? VGA_B_r[3:0] :
					4'b0;
`endif
				VGA_HS_r <= (TX_CLK==1'b1) ? TX_HS : VGA_HS_r;
				VGA_VS_r <= (TX_CLK==1'b1) ? TX_VS : VGA_VS_r;

				VGA_R_out_r[3:0] <= VGA_R_r[3:0];
				VGA_G_out_r[3:0] <= VGA_G_r[3:0];
				VGA_B_out_r[3:0] <= VGA_B_r[3:0];
				VGA_HS_out_r <= VGA_HS_r;
				VGA_VS_out_r <= VGA_VS_r;
				VGA_FIELD_r[3:0] <= VGA_FIELD_w[3:0];
			end
	end

	assign VGA_FIELD_w[3]=(VGA_FIELD_r[2:1]==2'b01) ? !VGA_FIELD_r[3] : VGA_FIELD_r[3];
	assign VGA_FIELD_w[2:0]={VGA_FIELD_r[1:0],VGA_VS_r};

`endif

`ifndef dvi_out

	assign GPIO1_PLLFB=1'bz;
	assign GPIO1_SCL=1'bz;
	assign GPIO1_SDA=1'bz;
	assign GPIO1_TX[3:0]=4'b0;

`else

	assign GPIO1_PLLFB=1'bz;
	assign GPIO1_SCL=1'bz;
	assign GPIO1_SDA=1'bz;

alt_dvi #(
	.differential(0)				// select diff=1 , single_end=0
) dvi_out (
//	.DVI_TX0_N(),					// out   [TX] TX[0]-N (CML)
	.DVI_TX0_P(GPIO1_TX[2]),		// out   [TX] TX[0]-P (CML)
//	.DVI_TX1_N(),					// out   [TX] TX[1]-N (CML)
	.DVI_TX1_P(GPIO1_TX[1]),		// out   [TX] TX[1]-P (CML)
//	.DVI_TX2_N(),					// out   [TX] TX[2]-N (CML)
	.DVI_TX2_P(GPIO1_TX[0]),		// out   [TX] TX[2]-P (CML)
//	.DVI_TXC_N(),					// out   [TX] TX_CLK-N (CML)
	.DVI_TXC_P(GPIO1_TX[3]),		// out   [TX] TX_CLK-P (CML)

	.TX_RED(TX_RED[7:0]),			// in    [TX] [7:0] red
	.TX_GRN(TX_GRN[7:0]),			// in    [TX] [7:0] green
	.TX_BLU(TX_BLU[7:0]),			// in    [TX] [7:0] blue
	.TX_HS(TX_HS),					// in    [TX] hsync
	.TX_VS(TX_VS),					// in    [TX] vsync
	.TX_C0(1'b0),					// in    [TX] c0
	.TX_C1(1'b0),					// in    [TX] c1
	.TX_C2(1'b0),					// in    [TX] c2
	.TX_C3(1'b0),					// in    [TX] c3
	.TX_DE(TX_DE),					// in    [TX] de

	.CLK(TX_CLK),					// in    [DVI] clk
	.CLKx5(TX_CLKx5),				// in    [DVI] clk x5 : dvi ddr
	.RESET_N(RESET_N)				// in    [DVI] #reset
);

`endif

	// ---- dac out ----

	wire	OPT_LOCKED;
	wire	OPT_OUT;
	wire	PWM_L_OUT;
	wire	PWM_R_OUT;

	assign GPIO0_SPD_TX=OPT_OUT;

	assign GPIO0_DA0=PWM_L_OUT;
	assign GPIO0_DA1=PWM_R_OUT;
//	assign GPIO1_PF[0]=1'bz;
//	assign GPIO1_PF[1]=1'bz;

/*
generate
	if (opn2==0)
begin

	assign GPIO0_DA0=PWM_L_OUT;
	assign GPIO0_DA1=PWM_R_OUT;
	assign GPIO1_PF[0]=1'bz;
	assign GPIO1_PF[1]=1'bz;

end
	else
begin

	assign GPIO0_DA0=1'bz;
	assign GPIO0_DA1=1'bz;
	assign GPIO1_PF[0]=PWM_L_OUT;
	assign GPIO1_PF[1]=PWM_R_OUT;

end
endgenerate
*/

	// ---- dai in : OC spdif_interface ----

	wire	[15:0] dai_lch_data,dai_rch_data;
	wire	dai_req;

`ifndef dai_in

	assign OPT_LOCKED=1'b0;

	assign dai_lch_data[15:0]=16'b0;
	assign dai_rch_data[15:0]=16'b0;
	assign dai_req=1'b0;

`else

spdif_interface spdif_interface(
	.wb_clk_i(CLK100),					// : in  std_logic;   -- wishbone clock
	.rxen(RESET_N),						// : in  std_logic;   -- phase detector enable
	.spdif(GPIO0_SPD_RX),				// : in  std_logic;   -- SPDIF input signal

	.spdif_o(),							// : out std_logic;   -- SPDIF input signal

	.lock(OPT_LOCKED),					// : out std_logic;   -- true if locked to spdif input
	.lock_evt(),						// : out std_logic;   -- lock status change event
	.rx_data(),							// : out std_logic;   -- recevied data
	.rx_data_en(),						// : out std_logic;   -- received data enable
	.rx_block_start(),					// : out std_logic;   -- start-of-block pulse
	.rx_frame_start(),					// : out std_logic;   -- start-of-frame pulse
	.rx_channel_a(),					// : out std_logic;   -- 1 if channel A frame is recevied
	.rx_error(),						// : out std_logic;   -- signal error was detected
	.ud_a_en(),							// : out std_logic;   -- user data ch. A enable
	.ud_b_en(),							// : out std_logic;   -- user data ch. B enable
	.cs_a_en(),							// : out std_logic;   -- channel status ch. A enable
	.cs_b_en(),							// : out std_logic;   -- channel status ch. B enable
	.wr_en(dai_req),					// : out 
	.wr_addr(),							// : out 
	.wr_data_lch(dai_lch_data[15:0]),	// : out 
	.wr_data_rch(dai_rch_data[15:0]),	// : out 
	.stat_paritya(),					// : out 
	.stat_parityb(),					// : out 
	.stat_lsbf(),						// : out 
	.stat_hsbf()						// : out 
);

`endif

	// ---- sdo out ----

	wire	SDO_CLK;
	wire	sdo_sync;
	wire	sdo_out;

	wire	[15:0] sdo_lch_data,sdo_rch_data;
	wire	sdo_req;

	assign SDO_CLK=CLK25;
	assign OPT_OUT=sdo_out;

//	assign sdo_lch_data[15:0]=dai_lch_data[15:0];
//	assign sdo_rch_data[15:0]=dai_rch_data[15:0];
//	assign sdo_req=dai_req;

`ifndef dai_out

	assign sdo_sync=1'b0;
	assign sdo_out=1'bz;

`else

	// ---- sdo clock sync ----

	wire	[2:0] sdo_sync_w;
	reg		[2:0] sdo_sync_r;

	wire	[23:0] sdo_lch_data_w,sdo_rch_data_w;
	reg		[23:0] sdo_lch_data_r,sdo_rch_data_r;

	wire	[23:0] sdo_lch;
	wire	[23:0] sdo_rch;
	wire	sdo_ch_req;

	assign sdo_ch_req=sdo_sync_r[2];
	assign sdo_lch[23:0]=sdo_lch_data_r[23:0];
	assign sdo_rch[23:0]=sdo_rch_data_r[23:0];

	always @(posedge SDO_CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				sdo_sync_r[2:0] <= 3'b000;
				sdo_lch_data_r[23:0] <= 24'h0;
				sdo_rch_data_r[23:0] <= 24'h0;
			end
		else
			begin
				sdo_sync_r[2:0] <= sdo_sync_w[2:0];
				sdo_lch_data_r[23:0] <= sdo_lch_data_w[23:0];
				sdo_rch_data_r[23:0] <= sdo_rch_data_w[23:0];
			end
	end

	assign sdo_sync_w[0]=sdo_req;
	assign sdo_sync_w[1]=sdo_sync_r[0];
	assign sdo_sync_w[2]=
			(sdo_sync_r[1:0]==2'b00) ? 1'b0 :
			(sdo_sync_r[1:0]==2'b01) ? 1'b1 :
			(sdo_sync_r[1:0]==2'b11) ? 1'b0 :
			(sdo_sync_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign sdo_lch_data_w[23:0]=(sdo_sync_r[2]==1'b1) ? {sdo_lch_data[15:0],8'b0} : sdo_lch_data_r[23:0];
	assign sdo_rch_data_w[23:0]=(sdo_sync_r[2]==1'b1) ? {sdo_rch_data[15:0],8'b0} : sdo_rch_data_r[23:0];

	// ---- sdo out ----

sdoenc sdo(
	.sdo_sync(sdo_sync),				// out   [DAC] spdif frame sync
	.sdo_out(sdo_out),					// out   [DAC] spdif out

	.dac_lch(sdo_lch[23:0]),			// in    [DAC] [23:0] dac left data
	.dac_rch(sdo_rch[23:0]),			// in    [DAC] [23:0] dac right data
	.dac_req(sdo_ch_req),				// in    [DAC] dac req

	.freq_mode(4'b0010),				// in    [DAC] [3:0] freq mode

	.dac_rst_n(RESET_N),				// in    [DAC] #reset
	.dac_clk(SDO_CLK)					// in    [DAC] clock (48KHz*512)
);

`endif

	// ---- dac out ----

	wire	DAC_CLK;
	wire	dac_l_out,dac_r_out;
	wire	[15:0] dac_lch_data,dac_rch_data;
	wire	dac_req;

	assign DAC_CLK=CLK54;
	assign PWM_L_OUT=dac_l_out;
	assign PWM_R_OUT=dac_r_out;

//	assign dac_lch_data[15:0]=dai_lch_data[15:0];
//	assign dac_rch_data[15:0]=dai_rch_data[15:0];
//	assign dac_req=dai_req;

	wire	[23:0] dac_lch;
	wire	[23:0] dac_rch;
	wire	dac_ch_req;

`ifndef dac_ip

	assign dac_ch_req=1'b1;
	assign dac_lch[23:0]={dac_lch_data[15:0],8'b00};
	assign dac_rch[23:0]={dac_rch_data[15:0],8'b00};

`else

	// ---- dac clock sync ----

	wire	[2:0] dac_sync_w;
	reg		[2:0] dac_sync_r;

	wire	[15:0] dac_lch_data_w,dac_rch_data_w;
	reg		[15:0] dac_lch_data_r,dac_rch_data_r;

	wire	[8:0] dac_ip_count_w;
	wire	dac_ip_load_w;
	wire	[15:0] dac_ip_lch_data0_w;
	wire	[15:0] dac_ip_rch_data0_w;
	wire	[15:0] dac_ip_lch_data1_w;
	wire	[15:0] dac_ip_rch_data1_w;
	wire	[15:0] dac_ip_lch_data2_w;
	wire	[15:0] dac_ip_rch_data2_w;
	wire	[23:0] dac_ip_lch_data3_w;
	wire	[23:0] dac_ip_rch_data3_w;

	reg		[8:0] dac_ip_count_r;
	reg		dac_ip_load_r;
	reg		[15:0] dac_ip_lch_data0_r;
	reg		[15:0] dac_ip_rch_data0_r;
	reg		[15:0] dac_ip_lch_data1_r;
	reg		[15:0] dac_ip_rch_data1_r;
	reg		[15:0] dac_ip_lch_data2_r;
	reg		[15:0] dac_ip_rch_data2_r;
	reg		[23:0] dac_ip_lch_data3_r;
	reg		[23:0] dac_ip_rch_data3_r;

	assign dac_ch_req=1'b1;
	assign dac_lch[23:0]=dac_ip_lch_data3_r[23:0];
	assign dac_rch[23:0]=dac_ip_rch_data3_r[23:0];

	always @(posedge DAC_CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				dac_sync_r[2:0] <= 3'b000;
				dac_lch_data_r[15:0] <= 16'h0;
				dac_rch_data_r[15:0] <= 16'h0;
				dac_ip_count_r[8:0] <= 9'b0;
				dac_ip_load_r <= 1'b0;
				dac_ip_lch_data0_r[15:0] <= 16'h0;
				dac_ip_rch_data0_r[15:0] <= 16'h0;
				dac_ip_lch_data1_r[15:0] <= 16'h0;
				dac_ip_rch_data1_r[15:0] <= 16'h0;
				dac_ip_lch_data2_r[15:0] <= 16'h0;
				dac_ip_rch_data2_r[15:0] <= 16'h0;
				dac_ip_lch_data3_r[23:0] <= 24'h0;
				dac_ip_rch_data3_r[23:0] <= 24'h0;
			end
		else
			begin
				dac_sync_r[2:0] <= dac_sync_w[2:0];
				dac_lch_data_r[15:0] <= dac_lch_data_w[15:0];
				dac_rch_data_r[15:0] <= dac_rch_data_w[15:0];
				dac_ip_count_r[8:0] <= dac_ip_count_w[8:0];
				dac_ip_load_r <= dac_ip_load_w;
				dac_ip_lch_data0_r[15:0] <= dac_ip_lch_data0_w[15:0];
				dac_ip_rch_data0_r[15:0] <= dac_ip_rch_data0_w[15:0];
				dac_ip_lch_data1_r[15:0] <= dac_ip_lch_data1_w[15:0];
				dac_ip_rch_data1_r[15:0] <= dac_ip_rch_data1_w[15:0];
				dac_ip_lch_data2_r[15:0] <= dac_ip_lch_data2_w[15:0];
				dac_ip_rch_data2_r[15:0] <= dac_ip_rch_data2_w[15:0];
				dac_ip_lch_data3_r[23:0] <= dac_ip_lch_data3_w[23:0];
				dac_ip_rch_data3_r[23:0] <= dac_ip_rch_data3_w[23:0];
			end
	end

	assign dac_sync_w[0]=dac_req;
	assign dac_sync_w[1]=dac_sync_r[0];
	assign dac_sync_w[2]=
			(dac_sync_r[1:0]==2'b00) ? 1'b0 :
			(dac_sync_r[1:0]==2'b01) ? 1'b1 :
			(dac_sync_r[1:0]==2'b11) ? 1'b0 :
			(dac_sync_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign dac_lch_data_w[15:0]=(dac_sync_r[2]==1'b1) ? dac_lch_data[15:0] : dac_lch_data_r[15:0];
	assign dac_rch_data_w[15:0]=(dac_sync_r[2]==1'b1) ? dac_rch_data[15:0] : dac_rch_data_r[15:0];

	assign dac_ip_count_w[8:0]=dac_ip_count_r[8:0]+9'b01;

	assign dac_ip_load_w=(dac_ip_count_r[6:0]==7'b0) ? 1'b1 : 1'b0;

	assign dac_ip_lch_data0_w[15:0]=(dac_ip_load_r==1'b1) ? dac_lch_data_r[15:0] : dac_ip_lch_data0_r[15:0];
	assign dac_ip_rch_data0_w[15:0]=(dac_ip_load_r==1'b1) ? dac_rch_data_r[15:0] : dac_ip_rch_data0_r[15:0];

	assign dac_ip_lch_data1_w[15:0]=(dac_ip_load_r==1'b1) ? dac_ip_lch_data0_r[15:0] : dac_ip_lch_data1_r[15:0];
	assign dac_ip_rch_data1_w[15:0]=(dac_ip_load_r==1'b1) ? dac_ip_rch_data0_r[15:0] : dac_ip_rch_data1_r[15:0];

	wire	[23:0] dac_ip_lch_tmp,dac_ip_rch_tmp;

	assign dac_ip_lch_tmp[23:17]=(dac_ip_lch_data2_r[15]==1'b1) ? 7'b1111111 : 7'b0;
	assign dac_ip_lch_tmp[16:0]={dac_ip_lch_data2_r[15:0],1'b0};
	assign dac_ip_rch_tmp[23:17]=(dac_ip_rch_data2_r[15]==1'b1) ? 7'b1111111 : 7'b0;
	assign dac_ip_rch_tmp[16:0]={dac_ip_rch_data2_r[15:0],1'b0};

	assign dac_ip_lch_data2_w[15:0]=(dac_ip_load_r==1'b1) ? dac_ip_lch_data0_r[15:0]-dac_ip_lch_data1_r[15:0] : dac_ip_lch_data2_r[15:0];
	assign dac_ip_rch_data2_w[15:0]=(dac_ip_load_r==1'b1) ? dac_ip_rch_data0_r[15:0]-dac_ip_rch_data1_r[15:0] : dac_ip_rch_data2_r[15:0];

	assign dac_ip_lch_data3_w[23:0]=(dac_ip_load_r==1'b1) ? {dac_ip_lch_data1_r[15:0],8'b0} : dac_ip_lch_data3_r[23:0]+dac_ip_lch_tmp[23:0];
	assign dac_ip_rch_data3_w[23:0]=(dac_ip_load_r==1'b1) ? {dac_ip_rch_data1_r[15:0],8'b0} : dac_ip_rch_data3_r[23:0]+dac_ip_rch_tmp[23:0];

`endif


`ifndef dac_out

	assign dac_l_out=1'b0;
	assign dac_r_out=1'b0;

`else

	// ---- dac out ----

	wire	dac_lch_out,dac_rch_out;
	wire	dac_lch_out_w,dac_rch_out_w;
	reg		dac_lch_out_r,dac_rch_out_r;

	assign dac_l_out=dac_lch_out_r;
	assign dac_r_out=dac_rch_out_r;

	always @(posedge DAC_CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
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

	.dac_rst_n(RESET_N),				// in    [DAC] #reset
	.dac_clk(DAC_CLK)					// in    [DAC] clock (48KHz*512)
);

`endif

	// ---- TG68 ----

	wire	[15:0] DRAM_WDATA;
	wire	[15:0] DRAM_RDATA;
	wire	DRAM_OE;

	wire	mem_clk;

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


generate
	if (SIM_WO_SDR==1)
begin

	assign MEM_INIT_DONE=SYSRST_N;

	assign mem_cmd_ack=mem_cmd_req;
	assign mem_wr_ack=mem_cmd_req;
	assign mem_rd_ack=mem_cmd_req;
	assign mem_rd_data[31:0]=32'b0;

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

end
	else
begin

	assign DRAM_DQ[15:0]=(DRAM_OE==1'b1) ? DRAM_WDATA[15:0] : 16'hzzzz;
	assign DRAM_RDATA[15:0]=DRAM_DQ[15:0];

mg_sdr #(
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

	.mem_cmd_req(mem_cmd_req),						// in    [MEM] cmd req
	.mem_cmd_rd(mem_cmd_instr[0]),					// in    [MEM] cmd rd/#wr
	.mem_cmd_addr({2'b0,mem_cmd_byte_addr[29:0]}),	// in    [MEM] cmd addr[31:0]
	.mem_cmd_ack(mem_cmd_ack),						// out   [MEM] cmd ack
	.mem_wr_mask(mem_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// in    [MEM] wr wdata[31:0]
	.mem_wr_ack(mem_wr_ack),						// out   [MEM] wr ack
	.mem_rd_data(mem_rd_data[31:0]),				// out   [MEM] rd rdata[31:0]
	.mem_rd_ack(mem_rd_ack),						// out   [MEM] rd ack

	.mem_init_done(MEM_INIT_DONE),	// out   [SYS] init_done
	.mem_t0(CLK7_T0),				// in    [SYS] state T0
	.mem_clk(mem_clk),				// in    [SYS] clk 54MHz
	.mem_rst_n(SYSRST_N)			// in    [SYS] #reset
);

end
endgenerate

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
	.init_done(MEM_INIT_DONE),						// in    [MEM] #init/done

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

	.p0_cmd_req(0),					// in    [MEM] cmd req
	.p0_cmd_instr(0),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	.p0_cmd_bl(0),					// in    [MEM] cmd blen[5:0](=0)
	.p0_cmd_byte_addr(0),			// in    [MEM] cmd addr[29:0]
	.p0_cmd_ack(),					// out   [MEM] cmd ack
	.p0_wr_mask(0),					// in    [MEM] wr mask[3:0]
	.p0_wr_data(0),					// in    [MEM] wr wdata[31:0]
	.p0_rd_data(),					// out   [MEM] rd rdata[31:0]

//	.p0_cmd_req(p0_cmd_req),						// in    [MEM] cmd req
//	.p0_cmd_instr(p0_cmd_instr[3:0]),				// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
//	.p0_cmd_bl(p0_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0](=0)
//	.p0_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
//	.p0_cmd_ack(p0_cmd_ack),						// out   [MEM] cmd ack
//	.p0_wr_mask(p0_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
//	.p0_wr_data(p0_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
//	.p0_rd_data(p0_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]

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

	.mem_rst_n(SYSRST_N),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	wire	[7:0] PSG_OUT;
	wire	[15:0] FM_OUT_L;
	wire	[15:0] FM_OUT_R;

	wire	[7:0] KEY1;
	wire	[7:0] KEY2;

	wire	[7:0] hid_key1;
	wire	[7:0] hid_key2;

generate
	if (pad_1p==1'b1)
begin

	reg		[7:0] key1_in_r;

	assign KEY1[7:0]=key1_in_r[7:0];

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				key1_in_r[7:0] <= 8'hff;
			end
		else
			begin
				key1_in_r[7:0] <= hid_key1[7:0];
			end
	end

end
	else
begin

	assign KEY1[7:0]=8'hff;

end
endgenerate

generate
	if (pad_2p==1'b1)
begin

	reg		[7:0] key2_in_r;

	assign KEY2[7:0]=key2_in_r[7:0];

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				key2_in_r[7:0] <= 8'hff;
			end
		else
			begin
				key2_in_r[7:0] <= hid_key2[7:0];
			end
	end

end
	else
begin

	assign KEY2[7:0]=8'hff;

end
endgenerate

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

	reg		[7:0] fl_ack_r;

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				fl_ack_r[7:0] <= 8'b0;
			end
		else
			begin
				fl_ack_r[7:0] <= (CART_REQ==1'b1) ? {fl_ack_r[6:0],1'b1} : 8'b0;
			end
	end

	assign FL_ADDR[21:0]=CART_ADDR[22:1];
	assign FL_DQ[15:0]=16'hzzzz;
	assign FL_CE_N=(CART_REQ==1'b1) & (CART_WE==1'b0) ? 1'b0 : 1'b1;
	assign FL_OE_N=1'b0;
	assign FL_WE_N=1'b1;
	assign FL_RST_N=RESET_N;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b0;

	assign CART_ACK=fl_ack_r[6];
	assign CART_RDATA[31:0]={FL_DQ[15:0],FL_DQ[15:0]};
//	assign CART_RDATA[31:24]=FL_DQ[7:0];
//	assign CART_RDATA[23:16]=FL_DQ[15:8];
//	assign CART_RDATA[15:8]=FL_DQ[7:0];
//	assign CART_RDATA[7:0]=FL_DQ[15:8];

	assign p0_cmd_req=1'b0;
	assign p0_cmd_instr[3:0]=4'b0;
	assign p0_cmd_bl[5:0]=6'b0;
	assign p0_cmd_byte_addr[29:0]=30'b0;
	assign p0_wr_mask[3:0]=4'b0;
	assign p0_wr_data[31:0]=32'b0;

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
	assign VRAM32_RDATA[31:0]=(DEBUG==0) ? p7_rd_data[31:0] : {~VRAM32_ADDR[15:2],2'b11,VRAM32_ADDR[15:2],2'b0};


	wire	[15:0] DEBUG_OUT;
	wire	[15:0] DEBUG_VDP;
	wire	[15:0] DEBUG_FM;
	wire	[15:0] DEBUG_Z;

	reg		[10:0] fm_out_count_r;
	reg		[15:0] FM_OUT_L_r;
	reg		[15:0] FM_OUT_R_r;

	always @(posedge CLK25 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				fm_out_count_r[10:0] <= 11'b0;
				FM_OUT_L_r[15:0] <= 16'b0;
				FM_OUT_R_r[15:0] <= 16'b0;
			end
		else
			begin
				fm_out_count_r[10] <= (fm_out_count_r[8:0]==9'b0) ? !fm_out_count_r[10] : fm_out_count_r[10];
				fm_out_count_r[9] <= (fm_out_count_r[8:0]==9'b0) ? 1'b1 : 1'b0;
				fm_out_count_r[8:0] <= fm_out_count_r[8:0]+9'b01;
				FM_OUT_L_r[15:0] <= (fm_out_count_r[9]==1'b1) ? FM_OUT_L[15:0] : FM_OUT_L_r[15:0];
				FM_OUT_R_r[15:0] <= (fm_out_count_r[9]==1'b1) ? FM_OUT_R[15:0] : FM_OUT_R_r[15:0];
			end
	end

	assign sdo_lch_data[15:0]=FM_OUT_L_r[15:0];
	assign sdo_rch_data[15:0]=FM_OUT_R_r[15:0];
	assign sdo_req=fm_out_count_r[10];

	assign dac_lch_data[15:0]=FM_OUT_L[15:0];
	assign dac_rch_data[15:0]=FM_OUT_R[15:0];

`ifdef dac_ip
	assign dac_req=fm_out_count_r[9];
`else
	assign dac_req=1'b1;
`endif

	wire	[1:0] YM_ADDR;
	wire	[7:0] YM_WDATA;
	wire	[7:0] YM_RDATA;
	wire	YM_DOE;
	wire	YM_WR_N;
	wire	YM_RD_N;
	wire	YM_CS_N;
	wire	YM_RESET_N;
	wire	YM_CLK;

generate
	if (opn2==0)
begin

	assign GPIO1_PB[7:0]=8'hzz;
	assign GPIO1_PA[7:0]=8'hzz;
	assign YM_RDATA[7:0]=8'b0;

end
	else
begin

	assign GPIO1_PA[7:0]=(YM_DOE==1'b1) ? {YM_WDATA[7],YM_WDATA[5],YM_WDATA[3],YM_WDATA[1],YM_WDATA[6],YM_WDATA[4],YM_WDATA[2],YM_WDATA[0]} : 8'hzz;
	assign GPIO1_PB[0]=YM_CLK;
	assign GPIO1_PB[4]=YM_ADDR[1];
	assign GPIO1_PB[1]=YM_ADDR[0];
	assign GPIO1_PB[5]=YM_RD_N;
	assign GPIO1_PB[2]=YM_WR_N;
	assign GPIO1_PB[6]=YM_CS_N;
	assign GPIO1_PB[3]=YM_RESET_N;
	assign GPIO1_PB[7]=1'bz;
	assign YM_RDATA[7:0]=8'b0;

end
endgenerate

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

	.debug_sca(1'b0),
	.debug_scw(1'b0),
	.debug_scb(1'b0),
	.debug_spr(1'b0),
	.debug_dma(1'b0),

//	.RESET(!RESET_N),			// in 
	.RESET(!MEM_INIT_DONE),			// in 

	.PSG_OUT(PSG_OUT),		// out
	.FM_OUT_L(FM_OUT_L),	// 
	.FM_OUT_R(FM_OUT_R),	// 

	.YM_ADDR(YM_ADDR[1:0]),
	.YM_WDATA(YM_WDATA[7:0]),
	.YM_RDATA(YM_RDATA[7:0]),
	.YM_DOE(YM_DOE),
	.YM_WR_N(YM_WR_N),
	.YM_RD_N(YM_RD_N),
	.YM_CS_N(YM_CS_N),
	.YM_RESET_N(YM_RESET_N),
	.YM_CLK(YM_CLK),

//	.VERSION({Sw[1:0],6'b100000}),	// JPN,NTSC,no_CD,1'b0,4'b0000
	.VERSION({2'b00,6'b100000}),	// JPN,NTSC,no_CD,1'b0,4'b0000

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
	.CART_BE(CART_BE),			
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

	// ---- debug ----

	reg		[7:0] led_level_r;
	reg		[7:0] led_debug_r;
	reg		[7:0] led_level_out_r;
	wire	[7:0] led_level_w;
	wire	[7:0] led_debug_w;
	wire	[7:0] led_level_out_w;

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				led_level_r[7:0] <= 8'b0;
				led_debug_r[7:0] <= 8'b0;
				led_level_out_r[7:0] <= 8'b0;
			end
		else
			begin
`ifdef dac_out
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

	assign LEDG[9]=SYSRST_N;
	assign LEDG[8]=MEM_INIT_DONE;

//	assign LEDG[7:0]=(SW[0]==1'b0) ? led_debug_r[7:0] : led_level_out_r[7:0];
	assign LEDG[7:0]=led_debug_r[7:0];


`ifdef use_hid

	// ---- usb-hid(low speed device) ----

	assign GPIO0_USB2=1'b0;	// host active
	assign GPIO0_USB3=1'b1;
	assign GPIO0_USB4=1'b1;

	wire	u_dm_in;
	wire	u_dp_in;
	wire	u_vs;
	wire	u_rst_n;

	assign GPIO0_USB0=1'bz;
	assign GPIO0_USB1=1'bz;

	assign u_dm_in=GPIO0_USB0;
	assign u_dp_in=GPIO0_USB1;

	reg		[2:0] u_vs_r;
	wire	[2:0] u_vs_w;

	reg		[8:0] u_rst_n_r;
	wire	[8:0] u_rst_n_w;

	assign u_vs=u_vs_r[2];
	assign u_rst_n=u_rst_n_r[8];

	always @(posedge CLK54 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				u_vs_r[2:0] <= 3'b0;
			end
		else
			begin
				u_vs_r[2:0] <= u_vs_w[2:0];
			end
	end

	assign u_vs_w[2]=(u_vs_r[1:0]==2'b01) ? !u_vs_r[2] : u_vs_r[2];
	assign u_vs_w[1:0]={u_vs_r[0],VGA_FIELD};

	always @(posedge CLK12 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				u_rst_n_r[8:0] <= 9'b0;
			end
		else
			begin
				u_rst_n_r[8:0] <= u_rst_n_w[8:0];
			end
	end

//	assign u_rst_n_w[8]=
//			(u_rst_n_r[8]==1'b1) ? 1'b1 :
//			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[7:4]==4'hf) ? 1'b1 :
//			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[7:4]!=4'hf) ? 1'b0 :
//			1'b0;
//	assign u_rst_n_w[7:4]=
//			(u_rst_n_r[8]==1'b1) ? 4'b0 :
//			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[3:2]==2'b01) ? u_rst_n_r[7:4]+4'h1 :
//			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[3:2]!=2'b01) ? u_rst_n_r[7:4] :
//			4'b0;
//	assign u_rst_n_w[3:0]={u_rst_n_r[2:0],u_vs};

	assign u_rst_n_w[8]=
			(u_rst_n_r[8]==1'b1) ? 1'b1 :
			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[7:0]==8'hff) ? 1'b1 :
			(u_rst_n_r[8]==1'b0) & (u_rst_n_r[7:0]!=8'hff) ? 1'b0 :
			1'b0;

	assign u_rst_n_w[7:0]=
			(u_rst_n_r[8]==1'b1) ? 8'b0 :
			(u_rst_n_r[8]==1'b0) ? u_rst_n_r[7:0]+8'h01 :
			8'b0;

ukp ukp(
	.usbclk(CLK12),		// #12MHz
	.reset_n(u_rst_n),	// #reset

	.usb_dm(GPIO0_USB0), 
	.usb_dp(GPIO0_USB1), 

	.rcv_data(),
	.rcv_addr(),
	.rcv_req(),
	.rcv_connected(),

	.data_out(),
	.usb_dm_out(),
	.usb_dm_oe(),
	.usb_dm_in(u_dm_in),
	.usb_dp_out(),
	.usb_dp_oe(),
	.usb_dp_in(u_dp_in),
	.sample_out(),
	.ins_out(),
	.timing_out()

);

	wire	rcv_data_m;
	wire	rcv_data_p;
	wire	[7:0] rcv_data;
	wire	rcv_data_load;
	wire	rcv_data_sync;
	wire	[7:0] rcv_count;
	wire	rcv_eop;
	wire	[4:0] rcv_crc5;
	wire	rcv_crc5_load;
	wire	[15:0] rcv_crc16;
	wire	rcv_crc16_load;
	wire	rcv_bit_sync6;
	wire	rcv_bit;
	wire	rcv_bit_load;

low_rcv rcv(
	.u_dm_in(GPIO0_USB0),	// -D
	.u_dp_in(GPIO0_USB1),	// +D

	.rcv_data_m(rcv_data_m),		// -D
	.rcv_data_p(rcv_data_p),		// +D

	.rcv_data(rcv_data[7:0]),			// recieve data
	.rcv_data_load(rcv_data_load),		// data latch timing
	.rcv_data_sync(rcv_data_sync),		// bit latch timing
	.rcv_count(rcv_count),				// bit count
	.rcv_eop(rcv_eop),					// find eop
	.rcv_crc5(rcv_crc5),				// crc5
	.rcv_crc5_load(rcv_crc5_load),		// crc5 latch timing
	.rcv_crc16(rcv_crc16),				// crc16
	.rcv_crc16_load(rcv_crc16_load),	// crc16 latch timing
	.rcv_bit_sync6(rcv_bit_sync6),		// find 1x6
	.rcv_bit(rcv_bit),					// recieve bit
	.rcv_bit_load(rcv_bit_load),		// bit latch timing

	.CLK12(CLK12),			// 12MHz (=1.5x8)
	.RESET_N(u_rst_n)		// #reset
);


	reg		[7:0] rcv_data1_r;
	reg		[7:0] rcv_data2_r;
	reg		[7:0] rcv_data3_r;
	reg		[7:0] rcv_data4_r;
	reg		[7:0] rcv_data5_r;
	reg		[7:0] rcv_data6_r;
	reg		[7:0] rcv_data7_r;
	reg		[7:0] rcv_data8_r;

	wire	[7:0] rcv_data1_w;
	wire	[7:0] rcv_data2_w;
	wire	[7:0] rcv_data3_w;
	wire	[7:0] rcv_data4_w;
	wire	[7:0] rcv_data5_w;
	wire	[7:0] rcv_data6_w;
	wire	[7:0] rcv_data7_w;
	wire	[7:0] rcv_data8_w;

	reg		rcv_req_r;
	reg		rcv_u_r;
	reg		rcv_d_r;
	reg		rcv_l_r;
	reg		rcv_r_r;
	reg		rcv_a_r;
	reg		rcv_b_r;
	reg		rcv_c_r;
	reg		rcv_s_r;

	wire	rcv_req_w;
	wire	rcv_u_w;
	wire	rcv_d_w;
	wire	rcv_l_w;
	wire	rcv_r_w;
	wire	rcv_a_w;
	wire	rcv_b_w;
	wire	rcv_c_w;
	wire	rcv_s_w;

	assign hid_key1[7]=rcv_s_r;
	assign hid_key1[6]=rcv_c_r;
	assign hid_key1[5]=rcv_b_r;
	assign hid_key1[4]=rcv_a_r;
	assign hid_key1[3]=rcv_r_r;
	assign hid_key1[2]=rcv_l_r;
	assign hid_key1[1]=rcv_d_r;
	assign hid_key1[0]=rcv_u_r;
	assign hid_key2[7:0]=8'hff;

	always @(posedge CLK12 or negedge u_rst_n)
	begin
		if (u_rst_n==1'b0)
			begin
				rcv_data1_r[7:0] <= 8'b0;
				rcv_data2_r[7:0] <= 8'b0;
				rcv_data3_r[7:0] <= 8'b0;
				rcv_data4_r[7:0] <= 8'b0;
				rcv_data5_r[7:0] <= 8'b0;
				rcv_data6_r[7:0] <= 8'b0;
				rcv_data7_r[7:0] <= 8'b0;
				rcv_data8_r[7:0] <= 8'b0;
				rcv_req_r <= 1'b0;
				rcv_u_r <= 1'b1;
				rcv_d_r <= 1'b1;
				rcv_l_r <= 1'b1;
				rcv_r_r <= 1'b1;
				rcv_a_r <= 1'b1;
				rcv_b_r <= 1'b1;
				rcv_c_r <= 1'b1;
				rcv_s_r <= 1'b1;
			end
		else
			begin
				rcv_data1_r[7:0] <= rcv_data1_w[7:0];
				rcv_data2_r[7:0] <= rcv_data2_w[7:0];
				rcv_data3_r[7:0] <= rcv_data3_w[7:0];
				rcv_data4_r[7:0] <= rcv_data4_w[7:0];
				rcv_data5_r[7:0] <= rcv_data5_w[7:0];
				rcv_data6_r[7:0] <= rcv_data6_w[7:0];
				rcv_data7_r[7:0] <= rcv_data7_w[7:0];
				rcv_data8_r[7:0] <= rcv_data8_w[7:0];
				rcv_req_r <= rcv_req_w;
				rcv_u_r <= rcv_u_w;
				rcv_d_r <= rcv_d_w;
				rcv_l_r <= rcv_l_w;
				rcv_r_r <= rcv_r_w;
				rcv_a_r <= rcv_a_w;
				rcv_b_r <= rcv_b_w;
				rcv_c_r <= rcv_c_w;
				rcv_s_r <= rcv_s_w;
			end
	end

	assign rcv_data1_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h2) ? rcv_data[7:0] : rcv_data1_r[7:0];
	assign rcv_data2_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h3) ? rcv_data[7:0] : rcv_data2_r[7:0];
	assign rcv_data3_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h4) ? rcv_data[7:0] : rcv_data3_r[7:0];
	assign rcv_data4_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h5) ? rcv_data[7:0] : rcv_data4_r[7:0];
	assign rcv_data5_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h6) ? rcv_data[7:0] : rcv_data5_r[7:0];
	assign rcv_data6_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h7) ? rcv_data[7:0] : rcv_data6_r[7:0];
	assign rcv_data7_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h8) ? rcv_data[7:0] : rcv_data7_r[7:0];
	assign rcv_data8_w[7:0]=(rcv_data_load==1'b1) & (rcv_count[6:3]==4'h9) ? rcv_data[7:0] : rcv_data8_r[7:0];

	// ---- elecom jc-u2912frd ----

	parameter	hid_pad_u1=8'h3_7;	// 3[7:6]==2'b00 ? up
	parameter	hid_pad_u0=8'h3_6;
	parameter	hid_pad_d1=8'h3_7;	// 3[7:6]==2'b11 ? down
	parameter	hid_pad_d0=8'h3_6;
	parameter	hid_pad_l1=8'h2_7;	// 2[7:6]==2'b00 ? left
	parameter	hid_pad_l0=8'h2_6;
	parameter	hid_pad_r1=8'h2_7;	// 2[7:6]==2'b11 ? right
	parameter	hid_pad_r0=8'h2_6;
	parameter	hid_pad_b1=8'h7_4;	// a
	parameter	hid_pad_b2=8'h7_5;	// b
	parameter	hid_pad_b3=8'h7_6;	// 
	parameter	hid_pad_b4=8'h7_7;	// c
	parameter	hid_pad_b5=8'h8_0;	// 
	parameter	hid_pad_b6=8'h8_1;	// 
	parameter	hid_pad_b7=8'h8_2;	// 
	parameter	hid_pad_b8=8'h8_3;	// 
	parameter	hid_pad_b9=8'h8_4;	// 
	parameter	hid_pad_b10=8'h8_5;	// 
	parameter	hid_pad_b11=8'h8_6;	// 
	parameter	hid_pad_b12=8'h8_7;	// start

	assign rcv_req_w=
			(rcv_eop==1'b1) ? 1'b0 :
			(rcv_eop==1'b0) & (rcv_data_load==1'b1) & (rcv_count[6:3]==4'h1) & (rcv_data[7:4]==4'hc) ? 1'b1 :	// data0
			(rcv_eop==1'b0) & (rcv_data_load==1'b1) & (rcv_count[6:3]==4'h1) & (rcv_data[7:4]==4'h4) ? 1'b1 :	// data1
			(rcv_eop==1'b0) & (rcv_data_load==1'b1) & (rcv_count[6:3]==4'h1) & (rcv_data[7:4]==4'h8) ? 1'b1 :	// data2
			(rcv_eop==1'b0) & (rcv_data_load==1'b1) & (rcv_count[6:3]==4'h1) & (rcv_data[7:4]==4'h0) ? 1'b1 :	// mdata
			rcv_req_r;

	assign rcv_u_w=
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_u1[7:4]) & ({rcv_data[hid_pad_u1[2:0]],rcv_data[hid_pad_u0[2:0]]}==2'b00) ? 1'b0 :
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_u1[7:4]) & ({rcv_data[hid_pad_u1[2:0]],rcv_data[hid_pad_u0[2:0]]}!=2'b00) ? 1'b1 :
			rcv_u_r;
	assign rcv_d_w=
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_d1[7:4]) & ({rcv_data[hid_pad_d1[2:0]],rcv_data[hid_pad_d0[2:0]]}==2'b11) ? 1'b0 :
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_d1[7:4]) & ({rcv_data[hid_pad_d1[2:0]],rcv_data[hid_pad_d0[2:0]]}!=2'b11) ? 1'b1 :
			rcv_d_r;
	assign rcv_l_w=
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_l1[7:4]) & ({rcv_data[hid_pad_l1[2:0]],rcv_data[hid_pad_l0[2:0]]}==2'b00) ? 1'b0 :
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_l1[7:4]) & ({rcv_data[hid_pad_l1[2:0]],rcv_data[hid_pad_l0[2:0]]}!=2'b00) ? 1'b1 :
			rcv_l_r;
	assign rcv_r_w=
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_r1[7:4]) & ({rcv_data[hid_pad_r1[2:0]],rcv_data[hid_pad_r0[2:0]]}==2'b11) ? 1'b0 :
			({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_r1[7:4]) & ({rcv_data[hid_pad_r1[2:0]],rcv_data[hid_pad_r0[2:0]]}!=2'b11) ? 1'b1 :
			rcv_r_r;

	assign rcv_a_w=({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_b1[7:4]) ? !rcv_data[hid_pad_b1[2:0]] : rcv_a_r;
	assign rcv_b_w=({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_b2[7:4]) ? !rcv_data[hid_pad_b2[2:0]] : rcv_b_r;
	assign rcv_c_w=({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_b4[7:4]) ? !rcv_data[hid_pad_b4[2:0]] : rcv_c_r;
	assign rcv_s_w=({rcv_req_r,rcv_data_load}==2'b11) & (rcv_count[6:3]==hid_pad_b12[7:4]) ? !rcv_data[hid_pad_b12[2:0]] : rcv_s_r;

`else

	assign hid_key1[7:0]=GPIO1_PC[7:0];
	assign hid_key2[7:0]=8'hff;

	assign GPIO0_USB2=1'b1;
	assign GPIO0_USB3=1'b1;
	assign GPIO0_USB4=1'b1;

	assign GPIO0_USB0=1'bz;
	assign GPIO0_USB1=1'bz;

`endif

endmodule

