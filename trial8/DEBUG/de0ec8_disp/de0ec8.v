//-----------------------------------------------------------------------------
//
//  de0ec8.v : de0 expansion card trial8 test module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/feb/21 release 0.0  connection test
//
//------------------------------------------------------------------------------

//`define use_digilent_mouse

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

	assign GPIO1_PC[7:0]=8'hzz;
	assign GPIO1_PB[7:0]=8'hzz;
	assign GPIO1_PA[7:0]=8'hzz;
	assign GPIO1_PF[1:0]=2'bzz;
//	assign GPIO1_TX[3:0]=4'hz;
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

//	assign LEDG[9:0]=10'b0;
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

	assign FL_CE_N=1'b1;
	assign FL_ADDR[21:0]=22'hzzzzzz;
	assign FL_DQ[15:0]=16'hzzzz;
	assign FL_OE_N=1'b1;
	assign FL_WE_N=1'b1;
	assign FL_RST_N=1'b0;
	assign FL_BYTE_N=1'b1;
	assign FL_WP_N=1'b0;

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
	wire	CLK25;
	wire	CLK25x5;
	wire	CLK125;
	wire	CLK7_T0;
	wire	CLK7_T6;
	wire	CLK100;
	wire	CLK100d;
//	wire	MEM_INIT_DONE;

	reg		[4:0] rst0_r;
	reg		[8:0] rst_r;
	wire	[4:0] rst0_w;
	wire	[8:0] rst_w;

	assign SYSRST_N=pll0_locked;
	assign RESET_N=rst_r[8];
	assign pll0_rst_n=rst0_r[4];

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

	always @(posedge CLK25 or negedge pll0_locked)
	begin
		if (pll0_locked==1'b0)
			begin
				rst_r[8:0] <= 9'b0;
			end
		else
			begin
				rst_r[8:0] <= rst_w[8:0];
			end
	end

	assign rst_w[8]=
			(rst_r[3]==1'b0) ? 1'b0 :
			(rst_r[3]==1'b1) & (rst_r[7:4]==4'hf) ? 1'b1 :
			(rst_r[3]==1'b1) & (rst_r[7:4]!=4'hf) ? rst_r[8] :
			1'b0;
	assign rst_w[7:4]=(rst_r[3]==1'b0) & (rst_r[8]==1'b1) ? 8'h0 : rst_r[7:4]+4'h1;
//	assign rst_w[3:0]={rst_r[2:0],MEM_INIT_DONE};
	assign rst_w[3:0]={rst_r[2:0],1'b1};

generate
	if (SIM_FAST==0)
begin

	assign CLK25x5=CLK125;

alt_altpll_50x25x125 pll_50x25x125(
	.areset(!pll0_rst_n),
	.inclk0(CLOCK_50),
	.c0(CLK25),
	.c1(CLK125),
	.locked(pll0_locked)
);

alt_pll_50x100x100d pll_50x100x100d(
	.areset(!pll0_rst_n),
	.inclk0(CLOCK_50),
	.c0(CLK100),
	.c1(CLK100d),
	.locked()
);

end
	else
begin

	assign CLK25=CLOCK_50;
	assign CLK25x5=CLOCK_50;
	assign CLK125=CLOCK_50;
	assign pll0_locked=pll0_rst_n;

	assign CLK100=CLOCK_50;
	assign CLK100d=!CLOCK_50;

end
endgenerate

// 50/2=25 25*3*7/2/11=23.863 23.863*9/4=53.693
// 27*5*7/3/11=28.636 28.636*15/8=53.693
// 3.57(NTSC)*8=28.636 28.636*15/8=53.693
// 27*2=54

// 53.693/15=3.57
// 53.693/7=7.67


	wire	[7:0] D_RED;
	wire	[7:0] D_GRN;
	wire	[7:0] D_BLU;
	wire	D_HS;
	wire	D_VS;
	wire	D_DE;
	wire	[9:0] D_HCOUNT;
	wire	[9:0] D_VCOUNT;

	wire	[7:0] TX_RED;
	wire	[7:0] TX_GRN;
	wire	[7:0] TX_BLU;
	wire	TX_HS;
	wire	TX_VS;
	wire	TX_DE;



	reg		[3:0] VGA_R_r;
	reg		[3:0] VGA_G_r;
	reg		[3:0] VGA_B_r;
	reg		VGA_HS_r;
	reg		VGA_VS_r;

	assign VGA_R[3:0]=VGA_R_r[3:0];
	assign VGA_G[3:0]=VGA_G_r[3:0];
	assign VGA_B[3:0]=VGA_B_r[3:0];
	assign VGA_HS=VGA_HS_r;
	assign VGA_VS=VGA_VS_r;

	always @(posedge CLK25 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				VGA_R_r[3:0] <= 4'b0;
				VGA_G_r[3:0] <= 4'b0;
				VGA_B_r[3:0] <= 4'b0;
				VGA_HS_r <= 1'b0;
				VGA_VS_r <= 1'b0;
			end
		else
			begin
				VGA_R_r[3:0] <= (TX_DE==1'b1) ? TX_RED[7:4] : 4'b0;
				VGA_G_r[3:0] <= (TX_DE==1'b1) ? TX_GRN[7:4] : 4'b0;
				VGA_B_r[3:0] <= (TX_DE==1'b1) ? TX_BLU[7:4] : 4'b0;
				VGA_HS_r <= TX_HS;
				VGA_VS_r <= TX_VS;
			end
	end

	wire	TG_HS;
	wire	TG_VS;
	wire	TG_DE;

timegen #(
		// VESA CVT : 0.31M3-R 25MHz 640x480@60Hz reduced blanking
	.hor_total(16'd816),		// horizontal total
	.hor_addr (16'd640),		// horizontal display
	.hor_fp   (16'd56),			// horizontal front porch (+margin)
	.hor_sync (16'd32),			// horizontal sync
	.hor_bp   (16'd88),			// horizontal back porch (+margin)
	.ver_total(16'd511),		// vertical total
	.ver_addr (16'd480),		// vertical display
	.ver_fp   (16'd11),			// vertical front porch (+margin)
	.ver_sync (16'd4),			// vertical sync
	.ver_bp   (16'd16)			// vertical back porch (+margin)
) timegen (
	.HSYNC_N(TG_HS),			// out   [CRT] #hsync
	.VSYNC_N(TG_VS),			// out   [CRT] #vsync
	.BLANK_N(TG_DE),			// out   [CRT] #blank/de

	.RST_N(RESET_N),				// in    [CRT] #reset
	.CLK(CLK25)					// in    [CRT] dot clock
);

dispgen dispgen(
	.D_RED(D_RED[7:0]),		// out   [CRT] [7:0] red
	.D_GRN(D_GRN[7:0]),		// out   [CRT] [7:0] green
	.D_BLU(D_BLU[7:0]),		// out   [CRT] [7:0] blue
	.D_HS(D_HS),				// out   [CRT] #hsync
	.D_VS(D_VS),				// out   [CRT] #vsync
	.D_DE(D_DE),				// out   [CRT] #blank/de

	.TX_HS(TG_HS),				// in    [CRT] #hsync
	.TX_VS(TG_VS),				// in    [CRT] #vsync
	.TX_DE(TG_DE),				// in    [CRT] #blank/de
	.TX_CLK(1'b1),				// in    [CRT] cke

	.RST_N(RESET_N),				// in    [CRT] #reset
	.CLK(CLK25)					// in    [CRT] dot clock
);

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

	.CLK(CLK25),					// in    [DVI] clk
	.CLKx5(CLK25x5),				// in    [DVI] clk x5 : dvi ddr
	.RESET_N(RESET_N)					// in    [DVI] #reset
);

	assign TX_RED[3:0]=D_RED[3:0];
	assign TX_GRN[3:0]=D_GRN[3:0];
	assign TX_BLU[3:0]=D_BLU[3:0];
	assign TX_HS=D_HS;
	assign TX_VS=D_VS;
	assign TX_DE=D_DE;

	reg		D_DE_r;
	reg		[10:0] D_HCOUNT_r;
	reg		[10:0] D_VCOUNT_r;
	reg		[3:0] SWITCH_r;

	always @(posedge CLK25 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				D_DE_r <= 1'b0;
				D_HCOUNT_r[10:0] <= 11'b0;
				D_VCOUNT_r[10:0] <= 11'b0;
				SWITCH_r[3:0] <= 4'b01;
			end
		else
			begin
				D_DE_r <= D_DE;
				D_HCOUNT_r[10:0] <= (D_DE==1'b1) ? D_HCOUNT_r[10:0]+11'b01 : 11'b0;
				D_VCOUNT_r[10:0] <= 
					(D_VS==1'b0) ? 11'b0 :
					(D_VS==1'b1) & ({D_DE,D_DE_r}==2'b01) ? D_VCOUNT_r[10:0]+11'b01 :
					(D_VS==1'b1) & ({D_DE,D_DE_r}!=2'b01) ? D_VCOUNT_r[10:0] :
					11'b0;
				SWITCH_r[3:0] <= {SWITCH_r[2:0],1'b0};
			end
	end

	wire	[9:0] ms_xpos;
	wire	[9:0] ms_ypos;
	wire	[1:0] ms_sw;

	assign {GPIO0_USB2,GPIO0_USB4,GPIO0_USB3}=3'b100;	// usb DM,DP pullup : ps2 mode

`ifdef use_digilent_mouse

MouseRefComp digilent_MouseRefComp(
	.CLK(CLK100),			// in    std_logic; 
	.RESOLUTION(1'b0),		// in    std_logic; 
	.RST(!RESET_N),			// in    std_logic; 
	.SWITCH(SWITCH_r[3]),	// in    std_logic; 
	.LEFT(ms_sw[0]),		// out   std_logic; 
	.MIDDLE(),				// out   std_logic; 
	.NEW_EVENT(),			// out   std_logic; 
	.RIGHT(ms_sw[1]),		// out   std_logic; 
	.XPOS(ms_xpos[9:0]),	// out   std_logic_vector (9 downto 0); 
	.YPOS(ms_ypos[9:0]),	// out   std_logic_vector (9 downto 0); 
	.ZPOS(),				// out   std_logic_vector (3 downto 0); 
//	.PS2_CLK(PS2_KBCLK),	// inout std_logic; 
//	.PS2_DATA(PS2_KBDAT)	// inout std_logic
	.PS2_CLK(GPIO0_USB1),	// inout std_logic; 
	.PS2_DATA(GPIO0_USB0)	// inout std_logic
);

mouse_displayer digilent_mouse_displayer(
	.clk(CLK100),					// in std_logic;

	.pixel_clk(CLK25),				// in std_logic;
	.xpos(ms_xpos[9:0]),			// in std_logic_vector(9 downto 0);
	.ypos(ms_ypos[9:0]),			// in std_logic_vector(9 downto 0);

	.hcount(D_HCOUNT_r[9:0]),		// in std_logic_vector(10 downto 0);
	.vcount(D_VCOUNT_r[9:0]),		// in std_logic_vector(10 downto 0);
	.blank(!D_DE),					// in std_logic;

	.red_in(D_RED[7:4]),			// in std_logic_vector(3 downto 0);
	.green_in(D_GRN[7:4]),			// in std_logic_vector(3 downto 0);
	.blue_in(D_BLU[7:4]),			// in std_logic_vector(3 downto 0);

	.red_out(TX_RED[7:4]),			// out std_logic_vector(3 downto 0);
	.green_out(TX_GRN[7:4]),		// out std_logic_vector(3 downto 0);
	.blue_out(TX_BLU[7:4])			// out std_logic_vector(3 downto 0)
);

`else

	assign ms_sw[1:0]=2'b00;

	assign GPIO0_USB1=1'bz;
	assign GPIO0_USB0=1'bz;

	assign TX_RED[7:4]=D_RED[7:4];
	assign TX_GRN[7:4]=D_GRN[7:4];
	assign TX_BLU[7:4]=D_BLU[7:4];

`endif

	// ---- dac test ----

	wire	OPT_LOCKED;
	wire	PWM_L_OUT;
	wire	PWM_R_OUT;

//	assign GPIO0_DA0=1'bz;
//	assign GPIO0_DA1=1'bz;
//	assign OPT_LOCKED=1'b0;

	assign GPIO0_DA0=PWM_L_OUT;
	assign GPIO0_DA1=PWM_R_OUT;

	// ---- dai in ----

	wire	[15:0] dai_lch_data,dai_rch_data;
	wire	dai_req;

	// ---- sdo clock sync ----

	wire	[2:0] sdo_sync_w;
	reg		[2:0] sdo_sync_r;

	wire	[23:0] sdo_lch_data_w,sdo_rch_data_w;
	reg		[23:0] sdo_lch_data_r,sdo_rch_data_r;

	wire	[23:0] sdo_lch;
	wire	[23:0] sdo_rch;
	wire	sdo_req;

	// ---- dac clock sync ----

	wire	[2:0] dac_sync_w;
	reg		[2:0] dac_sync_r;

	wire	[15:0] dac_lch_data_w,dac_rch_data_w;
	reg		[15:0] dac_lch_data_r,dac_rch_data_r;

	wire	[23:0] dac_lch;
	wire	[23:0] dac_rch;
	wire	dac_req;

	// ---- sdo out ----

	wire	sdo_sync;
	wire	sdo_out;

	// ---- dac out ----

	wire	dac_lch_out,dac_rch_out;

	wire	dac_lch_out_w,dac_rch_out_w;
	reg		dac_lch_out_r,dac_rch_out_r;

	// ---- OC spdif_interface ----

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

	// ---- sdo clock sync ----

	assign sdo_req=sdo_sync_r[2];
	assign sdo_lch[23:0]=sdo_lch_data_r[23:0];
	assign sdo_rch[23:0]=sdo_rch_data_r[23:0];

	always @(posedge CLK100 or negedge RESET_N)
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

	assign sdo_sync_w[0]=dai_req;
	assign sdo_sync_w[1]=sdo_sync_r[0];
	assign sdo_sync_w[2]=
			(sdo_sync_r[1:0]==2'b00) ? 1'b0 :
			(sdo_sync_r[1:0]==2'b01) ? 1'b1 :
			(sdo_sync_r[1:0]==2'b11) ? 1'b0 :
			(sdo_sync_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign sdo_lch_data_w[23:0]=(sdo_sync_r[2]==1'b1) ? {dai_lch_data[15:0],8'b0} : sdo_lch_data_r[23:0];
	assign sdo_rch_data_w[23:0]=(sdo_sync_r[2]==1'b1) ? {dai_rch_data[15:0],8'b0} : sdo_rch_data_r[23:0];

	// ---- sdo out ----

	assign PMOD_OPT_OUT=sdo_out;

sdoenc sdo(
	.sdo_sync(sdo_sync),				// out   [DAC] spdif frame sync
	.sdo_out(sdo_out),					// out   [DAC] spdif out

	.dac_lch(sdo_lch[23:0]),			// in    [DAC] [23:0] dac left data
	.dac_rch(sdo_rch[23:0]),			// in    [DAC] [23:0] dac right data
	.dac_req(sdo_req),					// in    [DAC] dac req

	.freq_mode(4'b0010),				// in    [DAC] [3:0] freq mode

	.dac_rst_n(RESET_N),				// in    [DAC] #reset
	.dac_clk(CLK100)					// in    [DAC] clock (48KHz*512)
);

	// ---- dac clock sync ----

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


	assign dac_req=1'b1;
	assign dac_lch[23:0]=dac_ip_lch_data3_r[23:0];
	assign dac_rch[23:0]=dac_ip_rch_data3_r[23:0];

	always @(posedge CLK100 or negedge RESET_N)
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

	assign dac_sync_w[0]=dai_req;
	assign dac_sync_w[1]=dac_sync_r[0];
	assign dac_sync_w[2]=
			(dac_sync_r[1:0]==2'b00) ? 1'b0 :
			(dac_sync_r[1:0]==2'b01) ? 1'b1 :
			(dac_sync_r[1:0]==2'b11) ? 1'b0 :
			(dac_sync_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign dac_lch_data_w[15:0]=(dac_sync_r[2]==1'b1) ? dai_lch_data[15:0] : dac_lch_data_r[15:0];
	assign dac_rch_data_w[15:0]=(dac_sync_r[2]==1'b1) ? dai_rch_data[15:0] : dac_rch_data_r[15:0];

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

	// ---- dac out ----

	assign PWM_L_OUT=dac_lch_out_r;
	assign PWM_R_OUT=dac_rch_out_r;

	always @(posedge CLK100 or negedge RESET_N)
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
	.dac_req(dac_req),					// in    [DAC] dac req

	.dac_rst_n(RESET_N),				// in    [DAC] #reset
	.dac_clk(CLK100)					// in    [DAC] clock (48KHz*512)
);

	// ---- status display ----

	reg		[4:0] USB_STAT_r;

	assign LEDG[0]=RESET_N;
	assign LEDG[1]=USB_STAT_r[0];
	assign LEDG[2]=USB_STAT_r[1];
	assign LEDG[3]=USB_STAT_r[2];
	assign LEDG[4]=USB_STAT_r[3];
	assign LEDG[5]=USB_STAT_r[4];
	assign LEDG[6]=ms_sw[0];
	assign LEDG[7]=ms_sw[1];
	assign LEDG[8]=1'b0;
	assign LEDG[9]=OPT_LOCKED;

//	assign GPIO0_USB0=1'bz;
//	assign GPIO0_USB1=1'bz;
//
//	assign {GPIO0_USB2,GPIO0_USB4,GPIO0_USB3}=
//			(SW[1:0]==2'b00) ? 3'b011 :
//			(SW[1:0]==2'b01) ? 3'b010 :
//			(SW[1:0]==2'b10) ? 3'b001 :
//			(SW[1:0]==2'b11) ? 3'b100 :
//			3'b111;

	always @(posedge CLK25 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				USB_STAT_r[4:0] <= 4'b0;
			end
		else
			begin
				USB_STAT_r[0] <= GPIO0_USB0;
				USB_STAT_r[1] <= GPIO0_USB1;
				USB_STAT_r[2] <= SW[0];
				USB_STAT_r[3] <= SW[1];
				USB_STAT_r[4] <= GPIO0_USB5;
			end
	end


endmodule

