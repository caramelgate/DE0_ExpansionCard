//-----------------------------------------------------------------------------
//
//  nx1_de0ec8.v : ese x1 de0+de0ec8 module
//
//  LICENSE : "as-is"
//  copyright (C) 2014, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/nov/28 release 0.0  modifyed and downgrade for de1(altera cyclone2)
//  2014/jan/01 release 0.0a de0(cyclone3)
//       jan/10 release 0.1  preview
//       jan/17 release 0.1a +FDC
//
//------------------------------------------------------------------------------

module nx1_de0ec8 #(
	parameter	def_DEVICE=1,			// 1=altera
	parameter	def_sram=0,				// main memory sdr / syncram
	parameter	def_reso=2,				// screen resoluton 0=800x480 / 1=1024x600 / 2=1024x768
	parameter	def_use_ipl=1,			// fast simulation : ipl skip
	parameter	def_fdd_flash=0,		// flash fdd image
//	parameter	def_EXTEND_BIOS=0,		// extend BIOS MENU & NoICE-Z80 resource-free monitor
	parameter	SIM_FAST=0,				// fast simulation
	parameter	DEBUG=0,				// 
	parameter	def_MBASE=32'h00000000,	// main memory base address
	parameter	def_BBASE=32'h00100000,	// bank memory base address
	parameter	def_VBASE=32'h00180000	// video base address
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

//	assign PS2_KBCLK=1'bz;
//	assign PS2_KBDAT=1'bz;
	assign PS2_MSCLK=1'bz;
	assign PS2_MSDAT=1'bz;
//	assign UART_TXD=1'bz;
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

//	assign SD_CMD=1'bz;
//	assign SD_CLK=1'bz;
//	assign SD_DAT3=1'bz;

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

//	wire	RST_IN_N;
//	assign RST_IN_N=BUTTON[0];

//--------------------------------------------------------------
//  design

	wire	uart_tx;
	wire	uart_rx;
	wire	[7:0] switch;
//	wire	[3:0] button;
	wire	[7:0] led;

	assign uart_rx=UART_RXD;
	assign UART_TXD=uart_tx;

	wire	clk_reset;
	wire	sys_reset;

	wire	clk50M;
	wire	clk24M;
	wire	clk32M;
	wire	clk64M;
	wire	clk128M;

	assign clk50M=CLOCK_50;
	assign clk24M=CLOCK_50;//CLK24;

	wire	[3:0] sbank;
	wire	[15:0] sa;
	wire	[7:0] sram_dr;
	wire	[7:0] cbus_wdata;
	wire	srd_n;
	wire	swr_n;
	wire	ipl_cs;
	wire	mram_cs;
	wire	gr_b_cs;
	wire	gr_r_cs;
	wire	gr_g_cs;
	wire	gram_wp;
	wire	gram_rp;

//	wire	[13:0] vaddr;
//	wire	[7:0] grb_dr;
//	wire	[7:0] grr_dr;
//	wire	[7:0] grg_dr;

	wire	ext_reset;
	wire	ext_nmi;
	wire	ext_joya_dn;
	wire	ext_joya_t1;
	wire	ext_ipl_kill;
	wire	ext_trap_en;
	wire	defchr_disable;
	wire	ext_eco_mode;

	wire	[7:0] joy_a_n;
	wire	[7:0] joy_b_n;

	assign joy_a_n[7:0]=8'hff;
	assign joy_b_n[7:0]=8'hff;

	wire	ps2_clk_t;
	wire	ps2_dat_t;

	assign PS2_KBCLK=ps2_clk_t ? 1'bz : 1'b0;
	assign PS2_KBDAT=ps2_dat_t ? 1'bz : 1'b0;

	assign switch[7:0]=SW[7:0];
//	assign button[3:0]={!KEY3,!KEY2,!KEY1,!KEY0};

//	assign LEDR[9:0]=10'hzzz;
	assign LEDG[9:8]=2'b0;
	assign LEDG[7:0]=led[7:0];

	wire	[3:0] fd5_lamp;

	assign led[0]=fd5_lamp[0] & ~ext_eco_mode;
	assign led[1]=fd5_lamp[1] & ~ext_eco_mode;
	assign led[2]=1'b0; // ipl_sel & ipl_enable & ~ext_eco_mode;
	assign led[3]=1'b0; // width40 & ~ext_eco_mode;
	assign led[4]=1'b0; // clk1 & ~ext_eco_mode;
	assign led[5]=1'b0; // key_brk_n & ~ext_eco_mode;
	assign led[6]=~uart_rx & ~ext_eco_mode;
	assign led[7]=~uart_tx & ~ext_eco_mode;

	wire	[7:0] v_red;
	wire	[7:0] v_grn;
	wire	[7:0] v_blu;
	wire	v_vsync;
	wire	v_hsync;
	wire	v_de;

	wire	hsync_n;
	wire	vsync_n;
	wire	blank_n;
	wire	ex_hsync;
	wire	ex_vsync;

	wire	crtc_hs;
	wire	crtc_vs;
	wire	crtc_de;

	assign VGA_R[3:0]=(blank_n==1'b0) ? 4'b0 : v_red[7:4];
	assign VGA_G[3:0]=(blank_n==1'b0) ? 4'b0 : v_grn[7:4];
	assign VGA_B[3:0]=(blank_n==1'b0) ? 4'b0 : v_blu[7:4];

	assign VGA_HS=hsync_n;
	assign VGA_VS=vsync_n;

	assign ext_reset=!BUTTON[0];
	assign ext_nmi=!BUTTON[1];
	assign ext_joya_dn=1'b0;//!BUTTON[1];
	assign ext_joya_t1=1'b0;//!BUTTON[0];

	assign ext_ipl_kill=switch[1];
	assign ext_trap_en=switch[7];
	assign defchr_disable=switch[0];
	assign ext_eco_mode=switch[5];

	wire	lock32M;

generate
	if (SIM_FAST==1)
begin

	assign clk32M=GPIO1_CLK;
	assign clk64M=CLOCK_50_2;
	assign clk128M=CLOCK_50_2;
	assign lock32M=!ext_reset;

end
	else
begin

alt_altpll_50x32x64x128 clkgen1(
	.areset(ext_reset),
	.inclk0(CLOCK_50),
	.c0(clk32M),
	.c1(clk64M),
	.c2(clk128M),
	.locked(lock32M)
);

end
endgenerate

	wire	EX_HDISP;
	wire	EX_VDISP;
	wire	EX_HWSAV;
	wire	EX_HBP;
	wire	EX_HSAV;
	wire	EX_HEAV;
	wire	EX_HC;
	wire	EX_VWSAV;
	wire	EX_VSAV;
	wire	EX_VEAV;
	wire	EX_VC;
	wire	EX_CLK;

//	assign EX_CLK=clk25M;	// reso 640x480

generate
	if ((DEBUG==0) & ((def_reso==0) | ((def_reso!=1) & (def_reso!=2) & (def_reso!=3))))	// 800x480
begin

	assign EX_CLK=clk32M;	// reso 800x480

syncgen #(
	.hor_total(16'd1056),		// horizontal total
	.hor_addr (16'd800),		// horizontal display
	.hor_fp   (16'd40),			// horizontal front porch (+margin)
	.hor_sync (16'd88),			// horizontal sync
	.hor_bp   (16'd128),		// horizontal back porch (+margin)
	.ver_total(16'd525),		// vertical total
	.ver_addr (16'd480),		// vertical display
	.ver_fp   (16'd8),			// vertical front porch (+margin)
	.ver_sync (16'd2),			// vertical sync
	.ver_bp   (16'd35),			// vertical back porch (+margin)
	.hor_wpos (16'h0000),		// horizontal window start
	.ver_wpos (16'h0000),		// vertical window start
	.hor_up   (16'h8000),		// horizontal resize
	.ver_up   (16'h4000)		// vertical resize
) syncgen (
	.HSYNC_N(hsync_n),			// out   [SYNC] #hsync
	.VSYNC_N(vsync_n),			// out   [SYNC] #vsync
	.BLANK_N(blank_n),			// out   [SYNC] #blank

	.EX_HDISP(EX_HDISP),		// out   [SYNC] horizontal disp
	.EX_VDISP(EX_VDISP),		// out   [SYNC] vertical disp
	.EX_HBP(EX_HBP),			// out   [SYNC] horizontal backporch
	.EX_HWSAV(EX_HWSAV),		// out   [SYNC] horizontal window sav
	.EX_HSAV(EX_HSAV),			// out   [SYNC] horizontal sav
	.EX_HEAV(EX_HEAV),			// out   [SYNC] horizontal eav
	.EX_HC(EX_HC),				// out   [SYNC] horizontal countup
	.EX_VWSAV(EX_VWSAV),		// out   [SYNC] vertical window sav
	.EX_VSAV(EX_VSAV),			// out   [SYNC] vertical sav
	.EX_VEAV(EX_VEAV),			// out   [SYNC] vertical eav
	.EX_VC(EX_VC),				// out   [SYNC] vertical countup

	.RST_N(lock32M),			// in    [SYNC] #reset
	.CLK(EX_CLK)				// in    [SYNC] dot clock
);

end
endgenerate

generate
	if ((DEBUG==0) & (def_reso==1))	// 1024x600
begin

	assign EX_CLK=clk64M;	// reso 1024x600 / 1024x768

syncgen #(
	.hor_total(16'd1344),		// horizontal total
	.hor_addr (16'd1024),		// horizontal display
	.hor_fp   (16'd24),			// horizontal front porch (+margin)
	.hor_sync (16'd136),		// horizontal sync
	.hor_bp   (16'd160),		// horizontal back porch (+margin)
	.ver_total(16'd806),		// vertical total
	.ver_addr (16'd600),		// vertical display
	.ver_fp   (16'd3+16'd168),	// vertical front porch (+margin)
	.ver_sync (16'd6),			// vertical sync
	.ver_bp   (16'd29),			// vertical back porch (+margin)
	.hor_wpos (16'h0000),		// horizontal window start
	.ver_wpos (16'h0000),		// vertical window start
	.hor_up   (16'h8000),		// horizontal resize
	.ver_up   (16'h4000)		// vertical resize
) syncgen (
	.HSYNC_N(hsync_n),			// out   [SYNC] #hsync
	.VSYNC_N(vsync_n),			// out   [SYNC] #vsync
	.BLANK_N(blank_n),			// out   [SYNC] #blank

	.EX_HDISP(EX_HDISP),		// out   [SYNC] horizontal disp
	.EX_VDISP(EX_VDISP),		// out   [SYNC] vertical disp
	.EX_HBP(EX_HBP),			// out   [SYNC] horizontal backporch
	.EX_HWSAV(EX_HWSAV),		// out   [SYNC] horizontal window sav
	.EX_HSAV(EX_HSAV),			// out   [SYNC] horizontal sav
	.EX_HEAV(EX_HEAV),			// out   [SYNC] horizontal eav
	.EX_HC(EX_HC),				// out   [SYNC] horizontal countup
	.EX_VWSAV(EX_VWSAV),		// out   [SYNC] vertical window sav
	.EX_VSAV(EX_VSAV),			// out   [SYNC] vertical sav
	.EX_VEAV(EX_VEAV),			// out   [SYNC] vertical eav
	.EX_VC(EX_VC),				// out   [SYNC] vertical countup

	.RST_N(lock32M),			// in    [SYNC] #reset
	.CLK(EX_CLK)				// in    [SYNC] dot clock
);

end
endgenerate

generate
	if ((DEBUG==0) & (def_reso==2))	// 1024x768
begin

	assign EX_CLK=clk64M;	// reso 1024x600 / 1024x768

syncgen #(
	.hor_total(16'd1344),		// horizontal total
	.hor_addr (16'd1024),		// horizontal display
	.hor_fp   (16'd24),			// horizontal front porch (+margin)
	.hor_sync (16'd136),		// horizontal sync
	.hor_bp   (16'd160),		// horizontal back porch (+margin)
	.ver_total(16'd806),		// vertical total
	.ver_addr (16'd768),		// vertical display
	.ver_fp   (16'd3),			// vertical front porch (+margin)
	.ver_sync (16'd6),			// vertical sync
	.ver_bp   (16'd29),			// vertical back porch (+margin)
	.hor_wpos (16'h0000),		// horizontal window start
	.ver_wpos (16'h0000),		// vertical window start
	.hor_up   (16'h8000),		// horizontal resize
	.ver_up   (16'h4000)		// vertical resize
) syncgen (
	.HSYNC_N(hsync_n),			// out   [SYNC] #hsync
	.VSYNC_N(vsync_n),			// out   [SYNC] #vsync
	.BLANK_N(blank_n),			// out   [SYNC] #blank

	.EX_HDISP(EX_HDISP),		// out   [SYNC] horizontal disp
	.EX_VDISP(EX_VDISP),		// out   [SYNC] vertical disp
	.EX_HBP(EX_HBP),			// out   [SYNC] horizontal backporch
	.EX_HWSAV(EX_HWSAV),		// out   [SYNC] horizontal window sav
	.EX_HSAV(EX_HSAV),			// out   [SYNC] horizontal sav
	.EX_HEAV(EX_HEAV),			// out   [SYNC] horizontal eav
	.EX_HC(EX_HC),				// out   [SYNC] horizontal countup
	.EX_VWSAV(EX_VWSAV),		// out   [SYNC] vertical window sav
	.EX_VSAV(EX_VSAV),			// out   [SYNC] vertical sav
	.EX_VEAV(EX_VEAV),			// out   [SYNC] vertical eav
	.EX_VC(EX_VC),				// out   [SYNC] vertical countup

	.RST_N(lock32M),			// in    [SYNC] #reset
	.CLK(EX_CLK)				// in    [SYNC] dot clock
);

end
endgenerate

generate
	if (DEBUG==1)	// 800x600
begin

	assign EX_CLK=clk32M;	// reso 800x480

syncgen #(
	.hor_total(16'd1056),		// horizontal total
	.hor_addr (16'd800),		// horizontal display
	.hor_fp   (16'd40),			// horizontal front porch (+margin)
	.hor_sync (16'd88),			// horizontal sync
	.hor_bp   (16'd128),		// horizontal back porch (+margin)
	.ver_total(16'd483),		// vertical total
	.ver_addr (16'd480),		// vertical display
	.ver_fp   (16'd1),			// vertical front porch (+margin)
	.ver_sync (16'd1),			// vertical sync
	.ver_bp   (16'd1),			// vertical back porch (+margin)
	.hor_wpos (16'h0000),		// horizontal window start
	.ver_wpos (16'h0000),		// vertical window start
	.hor_up   (16'h8000),		// horizontal resize
	.ver_up   (16'h8000)		// vertical resize
) syncgen (
	.HSYNC_N(hsync_n),			// out   [SYNC] #hsync
	.VSYNC_N(vsync_n),			// out   [SYNC] #vsync
	.BLANK_N(blank_n),			// out   [SYNC] #blank

	.EX_HDISP(EX_HDISP),		// out   [SYNC] horizontal disp
	.EX_VDISP(EX_VDISP),		// out   [SYNC] vertical disp
	.EX_HBP(EX_HBP),			// out   [SYNC] horizontal backporch
	.EX_HWSAV(EX_HWSAV),		// out   [SYNC] horizontal window sav
	.EX_HSAV(EX_HSAV),			// out   [SYNC] horizontal sav
	.EX_HEAV(EX_HEAV),			// out   [SYNC] horizontal eav
	.EX_HC(EX_HC),				// out   [SYNC] horizontal countup
	.EX_VWSAV(EX_VWSAV),		// out   [SYNC] vertical window sav
	.EX_VSAV(EX_VSAV),			// out   [SYNC] vertical sav
	.EX_VEAV(EX_VEAV),			// out   [SYNC] vertical eav
	.EX_VC(EX_VC),				// out   [SYNC] vertical countup

	.RST_N(lock32M),			// in    [SYNC] #reset
	.CLK(EX_CLK)				// in    [SYNC] dot clock
);

end
endgenerate

	assign clk_reset=ext_reset | ~lock32M;
	assign sys_reset=clk_reset;

	reg		[3:0] uart_pris;
	wire	uart_clk;
	wire	uart_clk_e;

	assign uart_clk=clk24M;
	assign uart_clk_e=(uart_pris==4'd12) ? 1'b1 : 1'b0;

	always @(posedge uart_clk or posedge clk_reset)
	begin
		if (clk_reset==1'b1)
			begin
				uart_pris <= 4'b0;
			end
		else
			begin
				uart_pris <= (uart_pris==12) ? 3'b0 : uart_pris + 4'b01;
			end
	end

	wire	[15:0] pcm_l;
	wire	[15:0] pcm_r;

	wire	DRAM_OE;
	wire	MEM_INIT_DONE;
	wire	[15:0] DRAM_WDATA;
	wire	[15:0] DRAM_RDATA;

	wire	sys_clk;
	wire	mem_clk;
	wire	mem_rst_n;

	wire	mem_cmd_req;
	wire	[2:0] mem_cmd_instr;
	wire	[5:0] mem_cmd_bl;
	wire	[29:0] mem_cmd_byte_addr;
	wire	[2:0] mem_cmd_master;
	wire	mem_cmd_ack;
	wire	[3:0] mem_wr_mask;
	wire	[31:0] mem_wr_data;
	wire	mem_wr_ack;
	wire	[2:0] mem_wr_master;
	wire	mem_rd_req;
	wire	[31:0] mem_rd_data;
	wire	[2:0] mem_rd_master;

	wire	p0_cmd_clk;
	wire	p0_cmd_en;
	wire	[2:0] p0_cmd_instr;
	wire	[5:0] p0_cmd_bl;
	wire	[29:0] p0_cmd_byte_addr;
	wire	p0_cmd_empty;
	wire	p0_cmd_full;
	wire	p0_wr_clk;
	wire	p0_wr_en;
	wire	[3:0] p0_wr_mask;
	wire	[31:0] p0_wr_data;
	wire	p0_wr_full;
	wire	p0_wr_empty;
	wire	[6:0] p0_wr_count;
	wire	p0_wr_underrun;
	wire	p0_wr_error;
	wire	p0_rd_clk;
	wire	p0_rd_en;
	wire	[31:0] p0_rd_data;
	wire	p0_rd_full;
	wire	p0_rd_empty;
	wire	[6:0] p0_rd_count;
	wire	p0_rd_overflow;
	wire	p0_rd_error;

	wire	p1_cmd_clk;
	wire	p1_cmd_en;
	wire	[2:0] p1_cmd_instr;
	wire	[5:0] p1_cmd_bl;
	wire	[29:0] p1_cmd_byte_addr;
	wire	p1_cmd_empty;
	wire	p1_cmd_full;
	wire	p1_wr_clk;
	wire	p1_wr_en;
	wire	[3:0] p1_wr_mask;
	wire	[31:0] p1_wr_data;
	wire	p1_wr_full;
	wire	p1_wr_empty;
	wire	[6:0] p1_wr_count;
	wire	p1_wr_underrun;
	wire	p1_wr_error;
	wire	p1_rd_clk;
	wire	p1_rd_en;
	wire	[31:0] p1_rd_data;
	wire	p1_rd_full;
	wire	p1_rd_empty;
	wire	[6:0] p1_rd_count;
	wire	p1_rd_overflow;
	wire	p1_rd_error;

	wire	p2_cmd_clk;
	wire	p2_cmd_en;
	wire	[2:0] p2_cmd_instr;
	wire	[5:0] p2_cmd_bl;
	wire	[29:0] p2_cmd_byte_addr;
	wire	p2_cmd_empty;
	wire	p2_cmd_full;
	wire	p2_wr_clk;
	wire	p2_wr_en;
	wire	[3:0] p2_wr_mask;
	wire	[31:0] p2_wr_data;
	wire	p2_wr_full;
	wire	p2_wr_empty;
	wire	[6:0] p2_wr_count;
	wire	p2_wr_underrun;
	wire	p2_wr_error;
	wire	p2_rd_clk;
	wire	p2_rd_en;
	wire	[31:0] p2_rd_data;
	wire	p2_rd_full;
	wire	p2_rd_empty;
	wire	[6:0] p2_rd_count;
	wire	p2_rd_overflow;
	wire	p2_rd_error;

	wire	p3_cmd_clk;
	wire	p3_cmd_en;
	wire	[2:0] p3_cmd_instr;
	wire	[5:0] p3_cmd_bl;
	wire	[29:0] p3_cmd_byte_addr;
	wire	p3_cmd_empty;
	wire	p3_cmd_full;
	wire	p3_rd_clk;
	wire	p3_rd_en;
	wire	[31:0] p3_rd_data;
	wire	p3_rd_full;
	wire	p3_rd_empty;
	wire	[6:0] p3_rd_count;
	wire	p3_rd_overflow;
	wire	p3_rd_error;

	wire	p4_cmd_clk;
	wire	p4_cmd_en;
	wire	[2:0] p4_cmd_instr;
	wire	[5:0] p4_cmd_bl;
	wire	[29:0] p4_cmd_byte_addr;
	wire	p4_cmd_empty;
	wire	p4_cmd_full;
	wire	p4_rd_clk;
	wire	p4_rd_en;
	wire	[31:0] p4_rd_data;
	wire	p4_rd_full;
	wire	p4_rd_empty;
	wire	[6:0] p4_rd_count;
	wire	p4_rd_overflow;
	wire	p4_rd_error;

	assign sys_clk=clk32M;	// 
//	assign mem_clk=clk32M;
	assign mem_clk=CLOCK_50;	// sdr clock
	assign mem_rst_n=!sys_reset;

	assign DRAM_DQ[15:0]=(DRAM_OE==1'b1) ? DRAM_WDATA[15:0] : 16'hzzzz;
	assign DRAM_RDATA[15:0]=DRAM_DQ[15:0];

	assign DRAM_ADDR[12]=1'b0;

nx1_mgsdr #(
	.DEVICE(def_DEVICE),	// 0=xilinx , 1=altera
	.SIM_FAST(SIM_FAST)		//
) mgsdr (
	.sdr_addr(DRAM_ADDR[11:0]),			// out   [SDR] addr[11:0]
	.sdr_ba(DRAM_BA[1:0]),				// out   [SDR] bank[1:0]
	.sdr_cas_n(DRAM_CAS_N),				// out   [SDR] #cas
	.sdr_cke(DRAM_CKE),					// out   [SDR] cke
	.sdr_clk(DRAM_CLK),					// out   [SDR] clk
	.sdr_cs_n(DRAM_CS_N),				// out   [SDR] #cs
	.sdr_wdata(DRAM_WDATA[15:0]),		// out   [SDR] write data[15:0]
	.sdr_rdata(DRAM_RDATA[15:0]),		// in    [SDR] read data[15:0]
	.sdr_oe(DRAM_OE),					// out   [SDR] data oe
	.sdr_dqm(DRAM_DQM[1:0]),			// out   [SDR] dqm[1:0]
	.sdr_ras_n(DRAM_RAS_N),				// out   [SDR] #ras
	.sdr_we_n(DRAM_WE_N),				// out   [SDR] #we

	.mem_cmd_req(mem_cmd_req),						// in    [MEM] cmd req
	.mem_cmd_instr(mem_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.mem_cmd_bl(mem_cmd_bl[5:0]),					// in    [MEM] cmd blen[5:0]
	.mem_cmd_byte_addr(mem_cmd_byte_addr[29:0]),	// in    [MEM] cmd addr[29:0]
	.mem_cmd_master(mem_cmd_master[2:0]),			// in    [MEM] cmd master[2:0]
	.mem_cmd_ack(mem_cmd_ack),						// out   [MEM] cmd ack
	.mem_wr_mask(mem_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// in    [MEM] wr wdata[31:0]
	.mem_wr_ack(mem_wr_ack),						// out   [MEM] wr ack
	.mem_wr_master(mem_wr_master[2:0]),				// out   [MEM] wr master[2:0]
	.mem_rd_req(mem_rd_req),						// out   [MEM] rd req
	.mem_rd_data(mem_rd_data[31:0]),				// out   [MEM] rd rdata[31:0]
	.mem_rd_master(mem_rd_master[2:0]),				// out   [MEM] rd master[2:0]

	.mem_init_done(MEM_INIT_DONE),	// out   [SYS] init_done
	.mem_clk(mem_clk),				// in    [SYS] clk 54MHz
	.mem_rst_n(mem_rst_n)			// in    [SYS] #reset
);

nx1_mgarb #(
	.DEVICE(def_DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) mgarb (
	.init_done(MEM_INIT_DONE),			// in    [MEM] #init/done

	.mem_cmd_req(mem_cmd_req),						// out   [MEM] cmd req
	.mem_cmd_instr(mem_cmd_instr[2:0]),				// out   [MEM] cmd inst[2:0]
	.mem_cmd_bl(mem_cmd_bl[5:0]),					// out   [MEM] cmd blen[5:0]
	.mem_cmd_byte_addr(mem_cmd_byte_addr[29:0]),	// out   [MEM] cmd addr[29:0]
	.mem_cmd_master(mem_cmd_master[2:0]),			// out   [MEM] cmd master[2:0]
	.mem_cmd_ack(mem_cmd_ack),						// in    [MEM] cmd ack
	.mem_wr_mask(mem_wr_mask[3:0]),					// out   [MEM] wr mask[3:0]
	.mem_wr_data(mem_wr_data[31:0]),				// out   [MEM] wr wdata[31:0]
	.mem_wr_ack(mem_wr_ack),						// in    [MEM] wr ack
	.mem_wr_master(mem_wr_master[2:0]),				// in    [MEM] wr master[2:0]
	.mem_rd_req(mem_rd_req),						// in    [MEM] rd req
	.mem_rd_data(mem_rd_data[31:0]),				// in    [MEM] rd rdata[31:0]
	.mem_rd_master(mem_rd_master[2:0]),				// in    [MEM] rd master[2:0]

	.p0_cmd_clk(p0_cmd_clk),						// in    [MEM] cmd clk
	.p0_cmd_en(p0_cmd_en),							// in    [MEM] cmd en
	.p0_cmd_instr(p0_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.p0_cmd_bl(p0_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0]
	.p0_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p0_cmd_empty(p0_cmd_empty),					// out   [MEM] cmd empt
	.p0_cmd_full(p0_cmd_full),						// out   [MEM] cmd full
	.p0_wr_clk(p0_wr_clk),							// in    [MEM] wr clk
	.p0_wr_en(p0_wr_en),							// in    [MEM] wr en
	.p0_wr_mask(p0_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p0_wr_data(p0_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p0_wr_full(p0_wr_full),						// out   [MEM] wr full
	.p0_wr_empty(p0_wr_empty),						// out   [MEM] wr empt
	.p0_wr_count(p0_wr_count[6:0]),					// out   [MEM] wr count[6:0]
	.p0_wr_underrun(p0_wr_underrun),				// out   [MEM] wr over
	.p0_wr_error(p0_wr_error),						// out   [MEM] wr err
	.p0_rd_clk(p0_rd_clk),							// in    [MEM] rd clk
	.p0_rd_en(p0_rd_en),							// in    [MEM] rd en
	.p0_rd_data(p0_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]
	.p0_rd_full(p0_rd_full),						// out   [MEM] rd full
	.p0_rd_empty(p0_rd_empty),						// out   [MEM] rd empt
	.p0_rd_count(p0_rd_count[6:0]),					// out   [MEM] rd count[6:0]
	.p0_rd_overflow(p0_rd_overflow),				// out   [MEM] rd over
	.p0_rd_error(p0_rd_error),						// out   [MEM] rd err

	.p1_cmd_clk(p1_cmd_clk),						// in    [MEM] cmd clk
	.p1_cmd_en(p1_cmd_en),							// in    [MEM] cmd en
	.p1_cmd_instr(p1_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.p1_cmd_bl(p1_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0]
	.p1_cmd_byte_addr(p1_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p1_cmd_empty(p1_cmd_empty),					// out   [MEM] cmd empt
	.p1_cmd_full(p1_cmd_full),						// out   [MEM] cmd full
	.p1_wr_clk(p1_wr_clk),							// in    [MEM] wr clk
	.p1_wr_en(p1_wr_en),							// in    [MEM] wr en
	.p1_wr_mask(p1_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p1_wr_data(p1_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p1_wr_full(p1_wr_full),						// out   [MEM] wr full
	.p1_wr_empty(p1_wr_empty),						// out   [MEM] wr empt
	.p1_wr_count(p1_wr_count[6:0]),					// out   [MEM] wr count[6:0]
	.p1_wr_underrun(p1_wr_underrun),				// out   [MEM] wr over
	.p1_wr_error(p1_wr_error),						// out   [MEM] wr err
	.p1_rd_clk(p1_rd_clk),							// in    [MEM] rd clk
	.p1_rd_en(p1_rd_en),							// in    [MEM] rd en
	.p1_rd_data(p1_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]
	.p1_rd_full(p1_rd_full),						// out   [MEM] rd full
	.p1_rd_empty(p1_rd_empty),						// out   [MEM] rd empt
	.p1_rd_count(p1_rd_count[6:0]),					// out   [MEM] rd count[6:0]
	.p1_rd_overflow(p1_rd_overflow),				// out   [MEM] rd over
	.p1_rd_error(p1_rd_error),						// out   [MEM] rd err

	.p2_cmd_clk(p2_cmd_clk),						// in    [MEM] cmd clk
	.p2_cmd_en(p2_cmd_en),							// in    [MEM] cmd en
	.p2_cmd_instr(p2_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.p2_cmd_bl(p2_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0]
	.p2_cmd_byte_addr(p2_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p2_cmd_empty(p2_cmd_empty),					// out   [MEM] cmd empt
	.p2_cmd_full(p2_cmd_full),						// out   [MEM] cmd full
	.p2_wr_clk(p2_wr_clk),							// in    [MEM] wr clk
	.p2_wr_en(p2_wr_en),							// in    [MEM] wr en
	.p2_wr_mask(p2_wr_mask[3:0]),					// in    [MEM] wr mask[3:0]
	.p2_wr_data(p2_wr_data[31:0]),					// in    [MEM] wr wdata[31:0]
	.p2_wr_full(p2_wr_full),						// out   [MEM] wr full
	.p2_wr_empty(p2_wr_empty),						// out   [MEM] wr empt
	.p2_wr_count(p2_wr_count[6:0]),					// out   [MEM] wr count[6:0]
	.p2_wr_underrun(p2_wr_underrun),				// out   [MEM] wr over
	.p2_wr_error(p2_wr_error),						// out   [MEM] wr err
	.p2_rd_clk(p2_rd_clk),							// in    [MEM] rd clk
	.p2_rd_en(p2_rd_en),							// in    [MEM] rd en
	.p2_rd_data(p2_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]
	.p2_rd_full(p2_rd_full),						// out   [MEM] rd full
	.p2_rd_empty(p2_rd_empty),						// out   [MEM] rd empt
	.p2_rd_count(p2_rd_count[6:0]),					// out   [MEM] rd count[6:0]
	.p2_rd_overflow(p2_rd_overflow),				// out   [MEM] rd over
	.p2_rd_error(p2_rd_error),						// out   [MEM] rd err

	.p3_cmd_clk(p3_cmd_clk),						// in    [MEM] cmd clk
	.p3_cmd_en(p3_cmd_en),							// in    [MEM] cmd en
	.p3_cmd_instr(p3_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.p3_cmd_bl(p3_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0]
	.p3_cmd_byte_addr(p3_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p3_cmd_empty(p3_cmd_empty),					// out   [MEM] cmd empt
	.p3_cmd_full(p3_cmd_full),						// out   [MEM] cmd full
	.p3_rd_clk(p3_rd_clk),							// in    [MEM] rd clk
	.p3_rd_en(p3_rd_en),							// in    [MEM] rd en
	.p3_rd_data(p3_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]
	.p3_rd_full(p3_rd_full),						// out   [MEM] rd full
	.p3_rd_empty(p3_rd_empty),						// out   [MEM] rd empt
	.p3_rd_count(p3_rd_count[6:0]),					// out   [MEM] rd count[6:0]
	.p3_rd_overflow(p3_rd_overflow),				// out   [MEM] rd over
	.p3_rd_error(p3_rd_error),						// out   [MEM] rd err

	.p4_cmd_clk(p4_cmd_clk),						// in    [MEM] cmd clk
	.p4_cmd_en(p4_cmd_en),							// in    [MEM] cmd en
	.p4_cmd_instr(p4_cmd_instr[2:0]),				// in    [MEM] cmd inst[2:0]
	.p4_cmd_bl(p4_cmd_bl[5:0]),						// in    [MEM] cmd blen[5:0]
	.p4_cmd_byte_addr(p4_cmd_byte_addr[29:0]),		// in    [MEM] cmd addr[29:0]
	.p4_cmd_empty(p4_cmd_empty),					// out   [MEM] cmd empt
	.p4_cmd_full(p4_cmd_full),						// out   [MEM] cmd full
	.p4_rd_clk(p4_rd_clk),							// in    [MEM] rd clk
	.p4_rd_en(p4_rd_en),							// in    [MEM] rd en
	.p4_rd_data(p4_rd_data[31:0]),					// out   [MEM] rd rdata[31:0]
	.p4_rd_full(p4_rd_full),						// out   [MEM] rd full
	.p4_rd_empty(p4_rd_empty),						// out   [MEM] rd empt
	.p4_rd_count(p4_rd_count[6:0]),					// out   [MEM] rd count[6:0]
	.p4_rd_overflow(p4_rd_overflow),				// out   [MEM] rd over
	.p4_rd_error(p4_rd_error),						// out   [MEM] rd err

	.mem_rst_n(mem_rst_n),				// in    [MEM] #rst
	.mem_clk(mem_clk)					// in    [MEM] clk
);

	assign p1_cmd_clk=sys_clk;
	assign p1_cmd_en=1'b0;
	assign p1_cmd_instr[2:0]=3'b0;
	assign p1_cmd_bl[5:0]=6'b0;
	assign p1_cmd_byte_addr[29:0]=30'b0;
	assign p1_wr_clk=sys_clk;
	assign p1_wr_en=1'b0;
	assign p1_wr_mask[3:0]=4'b1111;
	assign p1_wr_data[31:0]=32'b0;
	assign p1_rd_clk=sys_clk;
	assign p1_rd_en=1'b0;

	assign p2_cmd_clk=sys_clk;
	assign p2_cmd_en=1'b0;
	assign p2_cmd_instr[2:0]=3'b0;
	assign p2_cmd_bl[5:0]=6'b0;
	assign p2_cmd_byte_addr[29:0]=30'b0;
	assign p2_wr_clk=sys_clk;
	assign p2_wr_en=1'b0;
	assign p2_wr_mask[3:0]=4'b1111;
	assign p2_wr_data[31:0]=32'b0;
	assign p2_rd_clk=sys_clk;
	assign p2_rd_en=1'b0;

	assign p3_cmd_clk=sys_clk;
	assign p3_cmd_en=1'b0;
	assign p3_cmd_instr[2:0]=3'b0;
	assign p3_cmd_bl[5:0]=6'b0;
	assign p3_cmd_byte_addr[29:0]=30'b0;
	assign p3_rd_clk=sys_clk;
	assign p3_rd_en=1'b0;

	wire	[7:0] sdr_rdata;
	wire	[7:0] mem_rdata;
	wire	wait_n;
	wire	sdr_cs;
	wire	mem_cs;
	wire	z_ioreq;
	wire	[3:0] z_vplane;
	wire	z_multiplane;

	assign sdr_cs=(def_sram==0) & (mram_cs==1'b1) ? 1'b1 : 1'b0;
	assign mem_cs=(def_sram==1) & (mram_cs==1'b1) ? 1'b1 : 1'b0;

	assign p0_cmd_clk=sys_clk;
	assign p0_wr_clk=sys_clk;
	assign p0_rd_clk=sys_clk;

nx1_zbank #(
	.def_MBASE(def_MBASE),	// main memory base address
	.def_BBASE(def_BBASE),	// bank memory base address
	.def_VBASE(def_VBASE)	// video base address
) zbank (
	.mem_cmd_en(p0_cmd_en),							// out   [MEM] cmd en
	.mem_cmd_instr(p0_cmd_instr[2:0]),				// out   [MEM] cmd inst[2:0]
	.mem_cmd_bl(p0_cmd_bl[5:0]),					// out   [MEM] cmd blen[5:0]
	.mem_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// out   [MEM] cmd addr[29:0]
	.mem_cmd_empty(p0_cmd_empty),					// in    [MEM] cmd empt
	.mem_cmd_full(p0_cmd_full),						// in    [MEM] cmd full
	.mem_wr_en(p0_wr_en),							// out   [MEM] wr en
	.mem_wr_mask(p0_wr_mask[3:0]),					// out   [MEM] wr mask[3:0]
	.mem_wr_data(p0_wr_data[31:0]),					// out   [MEM] wr wdata[31:0]
	.mem_wr_full(p0_wr_full),						// in    [MEM] wr full
	.mem_wr_empty(p0_wr_empty),						// in    [MEM] wr empt
	.mem_wr_count(p0_wr_count[6:0]),				// in    [MEM] wr count[6:0]
	.mem_wr_underrun(p0_wr_underrun),				// in    [MEM] wr over
	.mem_wr_error(p0_wr_error),						// in    [MEM] wr err
	.mem_rd_en(p0_rd_en),							// out   [MEM] rd en
	.mem_rd_data(p0_rd_data[31:0]),					// in    [MEM] rd rdata[31:0]
	.mem_rd_full(p0_rd_full),						// in    [MEM] rd full
	.mem_rd_empty(p0_rd_empty),						// in    [MEM] rd empt
	.mem_rd_count(p0_rd_count[6:0]),				// in    [MEM] rd count[6:0]
	.mem_rd_overflow(p0_rd_overflow),				// in    [MEM] rd over
	.mem_rd_error(p0_rd_error),						// in    [MEM] rd err

	.mem_init_done(MEM_INIT_DONE),		// in    [MEM] init_done
	.mem_clk(sys_clk),					// in    [MEM] clk
	.mem_rst_n(!sys_reset),				// in    [MEM] #reset

	.z_wait_n(wait_n),
	.z_czbank({2'b10,sbank[3:0]}),
	.z_addr(sa[15:0]),
	.z_wdata(cbus_wdata[7:0]),
	.z_rdata(sdr_rdata[7:0]),
	.z_rd(~srd_n),
	.z_wr(~swr_n),
	.z_mreq(sdr_cs),
	.z_ioreq(z_ioreq),
	.z_vplane(z_vplane[3:0]),//{gr_g_cs,gr_r_cs,gr_b_cs,1'b0}),
	.z_multiplane(z_multiplane)
/*
	.z_ipl(z_ipl),				// out
	.z_addr(z_addr[15:0]),		// out
	.z_czbank(z_czbank[5:0]),	// out
	.z_mreq(z_mreq),			// out
	.z_ioreq(z_ioreq),			// out
	.z_rd(z_rd),				// out
	.z_wr(z_wr),				// out
	.z_wait(z_wait),			// in
	.z_fastcyc(z_fastcyc),		// in
	.z_vplane(z_vplane[3:0]),	// out
	.z_czvbank(z_czvbznk[3:0]),	// out
	.z_czvbank(z_czvbznk[3:0]),	// out
*/
);

generate
	if (def_sram==1)
begin

alt_altsyncram_c3dp8x16k dpram8x16k(
	.data(cbus_wdata),
	.rdaddress(sa[13:0]),
	.rdclock(sys_clk),
	.wraddress(sa[13:0]),
	.wrclock(sys_clk),
	.wren(mem_cs & !swr_n),
	.q(mem_rdata[7:0])
);

end
	else
begin

	assign mem_rdata[7:0]=8'b0;

end
endgenerate

	wire	[7:0] ipl_rdata;

alt_altsyncram_rom8x4k rom_ipl(
	.address(sa[11:0]),
	.clock(sys_clk),
	.q(ipl_rdata[7:0])
);

	assign sram_dr[7:0]=
			(def_sram==1) & (ipl_cs==1'b1) ? ipl_rdata[7:0] :
			(def_sram==1) & (ipl_cs==1'b0) ? mem_rdata[7:0] :
			(def_sram==0) & (ipl_cs==1'b1) ? ipl_rdata[7:0] :
			(def_sram==0) & (ipl_cs==1'b0) ? sdr_rdata[7:0] :
			sdr_rdata[7:0];

	assign p4_cmd_clk=mem_clk;
	assign p4_rd_clk=mem_clk;

	wire	[19:0] faddr;
	wire	frd;
	wire	[15:0] frdata;

generate
	if (def_fdd_flash==1)
begin

	assign FL_ADDR[21:0]={3'b000,faddr[19:1]};
	assign FL_DQ[15:0]=16'hzzzz;
	assign frdata[15:0]=FL_DQ[15:0];
	assign FL_CE_N=!frd;
	assign FL_OE_N=!frd;
	assign FL_WE_N=1'b1;
	assign FL_RST_N=!sys_reset;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b0;

end
	else
begin

	// ---- fdd test ----

	assign FL_ADDR[21:0]=22'b0;
	assign FL_DQ[15:0]=16'hzzzz;
	assign FL_CE_N=1'b1;
	assign FL_OE_N=1'b1;
	assign FL_WE_N=1'b1;
	assign FL_RST_N=1'b0;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b0;

	assign frdata[15:8]=frdata[7:0];

alt_altsyncram_rom8x16k fdd(
	.address(faddr[13:0]),
	.clock(CLK32),
	.q(frdata[7:0])
);

end
endgenerate

nx1_top #(
	.def_DEVICE(def_DEVICE),			// 0=Xilinx , 1=Altera
	.def_X1TURBO(0),					// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
//	.def_EXTEND_BIOS(def_EXTEND_BIOS),	// extend BIOS MENU & NoICE-Z80 resource-free monitor
	.def_use_ipl(def_use_ipl),			// fast simulation : ipl skip
	.SIM_FAST(SIM_FAST),				// fast simulation
	.DEBUG(DEBUG),						// 
	.def_MBASE(def_MBASE),	// main memory base address
	.def_BBASE(def_BBASE),	// bank memory base address
	.def_VBASE(def_VBASE)	// video base address
) nx1_top (
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
	.EX_CLK(EX_CLK),			// in    [SYNC] video clock
/*
	.mem_cmd_en(p0_cmd_en),							// out   [MEM] cmd en
	.mem_cmd_instr(p0_cmd_instr[2:0]),				// out   [MEM] cmd inst[2:0]
	.mem_cmd_bl(p0_cmd_bl[5:0]),					// out   [MEM] cmd blen[5:0]
	.mem_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// out   [MEM] cmd addr[29:0]
	.mem_cmd_empty(p0_cmd_empty),					// in    [MEM] cmd empt
	.mem_cmd_full(p0_cmd_full),						// in    [MEM] cmd full
	.mem_wr_en(p0_wr_en),							// out   [MEM] wr en
	.mem_wr_mask(p0_wr_mask[3:0]),					// out   [MEM] wr mask[3:0]
	.mem_wr_data(p0_wr_data[31:0]),					// out   [MEM] wr wdata[31:0]
	.mem_wr_full(p0_wr_full),						// in    [MEM] wr full
	.mem_wr_empty(p0_wr_empty),						// in    [MEM] wr empt
	.mem_wr_count(p0_wr_count[6:0]),				// in    [MEM] wr count[6:0]
	.mem_wr_underrun(p0_wr_underrun),				// in    [MEM] wr over
	.mem_wr_error(p0_wr_error),						// in    [MEM] wr err
	.mem_rd_en(p0_rd_en),							// out   [MEM] rd en
	.mem_rd_data(p0_rd_data[31:0]),					// in    [MEM] rd rdata[31:0]
	.mem_rd_full(p0_rd_full),						// in    [MEM] rd full
	.mem_rd_empty(p0_rd_empty),						// in    [MEM] rd empt
	.mem_rd_count(p0_rd_count[6:0]),				// in    [MEM] rd count[6:0]
	.mem_rd_overflow(p0_rd_overflow),				// in    [MEM] rd over
	.mem_rd_error(p0_rd_error),						// in    [MEM] rd err
*/
	.vram_clk(p4_cmd_clk),							// in    [VRAM] clk
	.vram_init_done(MEM_INIT_DONE),					// in    [VRAM] init done
	.vram_cmd_en(p4_cmd_en),						// out   [VRAM] cmd en
	.vram_cmd_instr(p4_cmd_instr[2:0]),				// out   [VRAM] cmd inst[2:0]
	.vram_cmd_bl(p4_cmd_bl[5:0]),					// out   [VRAM] cmd blen[5:0]
	.vram_cmd_byte_addr(p4_cmd_byte_addr[29:0]),	// out   [VRAM] cmd addr[29:0]
	.vram_cmd_empty(p4_cmd_empty),					// in    [VRAM] cmd empt
	.vram_cmd_full(p4_cmd_full),					// in    [VRAM] cmd full
	.vram_rd_en(p4_rd_en),							// out   [VRAM] rd en
	.vram_rd_data(p4_rd_data[31:0]),				// in    [VRAM] rd rdata[31:0]
	.vram_rd_full(p4_rd_full),						// in    [VRAM] rd full
	.vram_rd_empty(p4_rd_empty),					// in    [VRAM] rd empt
	.vram_rd_count(p4_rd_count[6:0]),				// in    [VRAM] rd count[6:0]
	.vram_rd_overflow(p4_rd_overflow),				// in    [VRAM] rd over
	.vram_rd_error(p4_rd_error),					// in    [VRAM] rd err
/*
	.z_ipl(z_ipl),				// out
	.z_addr(z_addr[15:0]),		// out
	.z_czbank(z_czbank[5:0]),	// out
	.z_mreq(z_mreq),			// out
	.z_rd(z_rd),				// out
	.z_wr(z_wr),				// out
	.z_wait(z_wait),			// in
	.z_fastcyc(z_fastcyc),		// in
	.z_vplane(z_vplane[3:0]),	// out
	.z_czvbank(z_czvbznk[3:0]),	// out
	.z_czvbank(z_czvbznk[3:0]),	// out
*/

	.z_ioreq(z_ioreq),				// out
	.z_vplane(z_vplane[3:0]),		// out
	.z_multiplane(z_multiplane),	// out

	.faddr(faddr[19:0]),			// out   [FDD] flash addr
	.frd(frd),						// out   [FDD] flash oe
	.frdata(frdata[15:0]),			// in    [FDD] flash read data

	.I_RESET(sys_reset),
	.I_CLK32M(sys_clk),
	.O_CBUS_BANK(sbank),
	.O_CBUS_ADDRESS(sa),
	.O_CBUS_DATA(cbus_wdata),
	.I_CBUS_DATA(sram_dr),
	.O_CBUS_RD_n(srd_n),
	.O_CBUS_WR_n(swr_n),
	.I_CBUS_WAIT_n(wait_n),//1'b1),
	.O_CBUS_CS_IPL(ipl_cs),
	.O_CBUS_CS_MRAM(mram_cs),
	.O_CBUS_CS_GRAMB(gr_b_cs),
	.O_CBUS_CS_GRAMR(gr_r_cs),
	.O_CBUS_CS_GRAMG(gr_g_cs),
	.O_CBUS_BANK_GRAM_R(gram_rp),
	.O_CBUS_BANK_GRAM_W(gram_wp),
	.O_XCF_CCLK(),
	.O_XCF_RESET(),
	.I_XCF_DIN(1'b0),
	.I_PS2_CLK(PS2_KBCLK),
	.I_PS2_DAT(PS2_KBDAT),
	.O_PS2_CLK_T(ps2_clk_t),
	.O_PS2_DAT_T(ps2_dat_t),
	.O_MMC_CLK(SD_CLK),
	.O_MMC_CS(SD_DAT3),
	.O_MMC_DOUT(SD_CMD),
	.I_MMC_DIN(SD_DAT),
	.I_MMC_INS(1'b0),
	.PCM_L(pcm_l[15:0]),
	.PCM_R(pcm_r[15:0]),
	.O_LED_FDD_RED(fd5_lamp),
	.O_LED_FDD_GREEN(),
	.I_NMI_n(~ext_nmi),
	.O_LED_POWER(),
	.O_LED_TIMER(),
	.I_IPL_n(~ext_reset),
	.I_DEFCHR_SW(defchr_disable),
	.O_LED_HIRESO(),
	.I_DSW(4'b0000),
	.I_ZDSW(2'b00),
	.O_LED_ANALOG(),
	.I_JOYA(joy_a_n),
	.O_JOYA(),
	.T_JOYA(),
	.I_JOYB(joy_b_n),
	.O_JOYB(),
	.T_JOYB(),
	.O_VGA_R(v_red[7:0]),
	.O_VGA_G(v_grn[7:0]),
	.O_VGA_B(v_blu[7:0]),
	.O_VGA_HS(v_hsync),
	.O_VGA_VS(v_vsync),
	.O_VGA_DE(v_de),
	.O_VGA_CLK(),
//	.I_FIRMWARE_EN(1'b0),
	.O_DBG_NUM4(),
	.O_DBG_DOT4(),
	.O_DBG_LED8(),
	.I_USART_CLK(uart_clk),
	.I_USART_CLKEN16(uart_clk_e),
	.I_USART_RX(uart_rx),
	.O_USART_TX(uart_tx)
);

endmodule

