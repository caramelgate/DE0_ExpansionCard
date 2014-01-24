//------------------------------------------------------------------------------
//
//  nx1_de0_tf.v : test fixture
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/nov/28 release 0.0  
//
//------------------------------------------------------------------------------

`timescale 1ns / 100ps

module tf (
);

	wire	CLK50;
	wire	CLK64;
	wire	CLK32;
	wire	RST_N;

	// ---- 50MHz ----

	reg		CLK50_r;

	initial
	begin
		forever
		begin
			CLK50_r <= 1'b0; #8;
			CLK50_r <= 1'b1; #8;
		end
	end

	assign CLK50=CLK50_r;

	// ---- 64MHz ----

	reg		CLK64_r;

	initial
	begin
		forever
		begin
			CLK64_r <= 1'b0; #8;
			CLK64_r <= 1'b1; #8;
		end
	end

	assign CLK64=CLK64_r;

	// ---- 32MHz ----

	reg		CLK32_r;

	initial
	begin
		forever
		begin
			CLK32_r <= 1'b0; #16;
			CLK32_r <= 1'b1; #16;
		end
	end

	assign CLK32=CLK32_r;

	// ---- reset ----

	reg		[8:0] RST_N_r;

	initial
	begin
		RST_N_r[0] <= 'b1; #2;
		RST_N_r[0] <= 'b0; #200;
		RST_N_r[0] <= 'b1; #1;
	end

	always @(posedge CLK50 or negedge RST_N_r[0])
	begin
		if (RST_N_r[0]==1'b0)
			begin
				RST_N_r[8:1] <= 8'h00;
			end
		else
			begin
				RST_N_r[8] <= (RST_N_r[7:1]==7'h0f) ? 1'b1 : RST_N_r[8];
				RST_N_r[7:1] <= RST_N_r[7:1]+7'h01;
			end
	end

	assign RST_N=RST_N_r[8];

	// ---- ----

	tri1			CLOCK_50;		// in    [SYS] 50MHz
	tri1			CLOCK_50_2;		// in    [SYS] 50MHz

//	tri1	[31:0]	GPIO0_D;		// tri1 [GPIO] gpio[31:0]
//	tri1	[1:0]	GPIO0_CLKIN;	// tri1 [GPIO] clkin[1:0]
//	tri1	[1:0]	GPIO0_CLKOUT;	// tri1 [GPIO] clkout[1:0]
//	tri1	[31:0]	GPIO1_D;		// tri1 [GPIO] gpio[31:0]
//	tri1	[1:0]	GPIO1_CLKIN;	// tri1 [GPIO] clkin[1:0]
//	tri1	[1:0]	GPIO1_CLKOUT;	// tri1 [GPIO] clkout[1:0]

	tri1			GPIO0_ETH_RXCLK;	// in    [GPIO0] eth rxclk
	tri1			GPIO0_ETH_TXCLK;	// in    [GPIO0] eth txclk
	wire			GPIO0_ETH_CLK;		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
	tri1			GPIO0_ETH_CLKFB;	// in    [GPIO0] eth clkfb (RMII=50MHz)
	wire			GPIO0_ETH_RST_N;	// out   [GPIO0] eth #rst
	wire			GPIO0_ETH_MDC;		// out   [GPIO0] eth mdc
	tri1			GPIO0_ETH_MDIO;		// tri1 [GPIO0] eth mdio
	tri1			GPIO0_ETH_RXDV;		// tri1 [GPIO0] eth rxdv (MII/RMII mode)
	tri1			GPIO0_ETH_CRS;		// in    [GPIO0] eth crs
	tri1			GPIO0_ETH_RXER;		// in    [GPIO0] eth rxer
	tri1			GPIO0_ETH_COL;		// in    [GPIO0] eth col
	tri1	[3:0]	GPIO0_ETH_RXD;		// in    [GPIO0] eth rxd
	wire			GPIO0_ETH_TXEN;		// out   [GPIO0] eth txen
	wire	[3:0]	GPIO0_ETH_TXD;		// out   [GPIO0] eth txd
	wire			GPIO0_SPD_TX;		// out   [GPIO0] optical tx
	tri1			GPIO0_SPD_RX;		// in    [GPIO0] optical rx
	wire			GPIO0_DA0;			// out   [GPIO0] DA0(L) out
	wire			GPIO0_DA1;			// out   [GPIO0] DA1(R) out
	tri1			GPIO0_SD_DO;		// in    [GPIO0] sd dout (<- card out)
	wire			GPIO0_SD_SCK;		// out   [GPIO0] sd sck  (-> card in)
	wire			GPIO0_SD_DI;		// out   [GPIO0] sd din  (-> card in)
	wire			GPIO0_SD_CS;		// out   [GPIO0] sd cs   (-> card in)
	tri1			GPIO0_USB0;			// tri1 [GPIO0] usb DM
	tri1			GPIO0_USB1;			// tri1 [GPIO0] usb DP
	wire			GPIO0_USB2;			// out   [GPIO0] usb host pd
	wire			GPIO0_USB3;			// out   [GPIO0] usb dev DM pu
	wire			GPIO0_USB4;			// out   [GPIO0] usb dev DP pu
	tri1			GPIO0_USB5;			// in    [GPIO0] usb dev power sense
	wire			GPIO0_UTX;			// out   [GPIO0] uart tx out
	tri1			GPIO0_URX;			// in    [GPIO0] uart rx in

	tri1	[7:0]	GPIO1_PC;		// tri1 [GPIO1] sv1
	tri1	[7:0]	GPIO1_PB;		// tri1 [GPIO1] sv2
	tri1	[7:0]	GPIO1_PA;		// tri1 [GPIO1] sv3
	tri1	[1:0]	GPIO1_PF;		// tri1 [GPIO1] sv4
	tri1	[3:0]	GPIO1_TX;		// out   [GPIO1] video out
	tri1			GPIO1_PLLFB;	// out   [GPIO1] pllfb -> pll
	tri1			GPIO1_HPD;		// in    [GPIO1] hpd in
	tri1			GPIO1_SCL;		// tri1 [GPIO1] ddc scl
	tri1			GPIO1_SDA;		// tri1 [GPIO1] ddc sda
	tri1			GPIO1_PLL;		// in    [GPIO1] pllfb -> pll
	tri1			GPIO1_CLK;		// in    [GPIO1] option (27MHz or 24.576MHz)

	tri1	[2:0]	BUTTON;			// in    [SW] button[2:0]

	tri1	[9:0]	SW;				// in    [SW] sw[9:0]

	wire	[9:0]	LEDG;			// out   [LED] led green[9:0]
	wire	[6:0]	HEX0_D;			// out   [LED] led hex0[6:0]
	wire			HEX0_DP;		// out   [LED] led hex0 point
	wire	[6:0]	HEX1_D;			// out   [LED] led hex1[6:0]
	wire			HEX1_DP;		// out   [LED] led hex1 point
	wire	[6:0]	HEX2_D;			// out   [LED] led hex2[6:0]
	wire			HEX2_DP;		// out   [LED] led hex2 point
	wire	[6:0]	HEX3_D;			// out   [LED] led hex3[6:0]
	wire			HEX3_DP;		// out   [LED] led hex3 point

	tri1			PS2_KBCLK;		// out   [KBD] clock
	tri1			PS2_KBDAT;		// out   [KBD] data
	tri1			PS2_MSCLK;		// out   [MS] clock
	tri1			PS2_MSDAT;		// out   [MS] data
	tri1			UART_RXD;		// in    [UART] rxd
	wire			UART_TXD;		// out   [UART] txd
	tri1			UART_RTS;		// in    [UART] rts
	wire			UART_CTS;		// out   [UART] cts

	wire	[3:0]	VGA_R;			// out   [VIDEO] red[3:0]
	wire	[3:0]	VGA_G;			// out   [VIDEO] green[3:0]
	wire	[3:0]	VGA_B;			// out   [VIDEO] blue[3:0]
	wire			VGA_HS;			// out   [VIDEO] hsync
	wire			VGA_VS;			// out   [VIDEO] vsync

	tri1	[7:0]	LCD_DATA;		// tri1 [LCD] lcd data[7:0]
	wire			LCD_RW;			// out   [LCD] lcd rw
	wire			LCD_RS;			// out   [LCD] lcd rs
	wire			LCD_EN;			// out   [LCD] lcd en
	wire			LCD_BLON;		// out   [LCD] lcd backlight on

	wire	[12:0]	DRAM_ADDR;		// out   [SDR] addr[12:0]
	wire	[1:0]	DRAM_BA;		// out   [SDR] bank[1:0]
	wire			DRAM_CAS_N;		// out   [SDR] #cas
	wire			DRAM_CKE;		// out   [SDR] cke
	wire			DRAM_CLK;		// out   [SDR] clk
	wire			DRAM_CS_N;		// out   [SDR] #cs
	tri1	[15:0]	DRAM_DQ;		// tri1 [SDR] data[15:0]
	wire	[1:0]	DRAM_DQM;		// out   [SDR] dqm[1:0]
	wire			DRAM_RAS_N;		// out   [SDR] #ras
	wire			DRAM_WE_N;		// out   [SDR] #we

	wire	[21:0]	FL_ADDR;		// out   [FLASH]
	tri1	[15:0]	FL_DQ;			// tri1 [FLASH]
	wire			FL_CE_N;		// out   [FLASH]
	wire			FL_OE_N;		// out   [FLASH]
	wire			FL_WE_N;		// out   [FLASH]
	wire			FL_RST_N;		// out   [FLASH]
	wire			FL_BYTE_N;		// out   [FLASH] flash #byte
	tri1			FL_RY;			// in    [FLASH] flash ready/#busy
	wire			FL_WP_N;		// out   [FLASH] flash #wp

	tri1			SD_DAT;			// in    [SD] spi dat_i(sd -> host)
	wire			SD_CMD;			// out   [SD] spi dat_o(host -> sd)
	wire			SD_CLK;			// out   [SD] spi clk
	wire			SD_DAT3;		// out   [SD] spi cs
	tri1			SD_WP_N;			// in    [SD] sd #wp

	assign BUTTON[2]=1'b1;
	assign BUTTON[1]=1'b1;
	assign BUTTON[0]=RST_N;

nx1_de0ec8 #(
	.def_DEVICE(1),	// 1=altera
	.def_sram(1),
	.def_use_ipl(1),
	.def_fdd_flash(0),		// flash fdd image
	.SIM_FAST(1),			// 
	.DEBUG(1)				// 
) nx1_de0ec8 (
	.CLOCK_50(CLK50),		// in    [SYS] 50MHz
	.CLOCK_50_2(CLK64),		// in    [SYS] 50MHz

//	[31:0]	GPIO0_D),		// inout [GPIO] gpio[31:0]
//	[1:0]	GPIO0_CLKIN),	// inout [GPIO] clkin[1:0]
//	[1:0]	GPIO0_CLKOUT),	// inout [GPIO] clkout[1:0]
//	[31:0]	GPIO1_D),		// inout [GPIO] gpio[31:0]
//	[1:0]	GPIO1_CLKIN),	// inout [GPIO] clkin[1:0]
//	[1:0]	GPIO1_CLKOUT),	// inout [GPIO] clkout[1:0]

	.GPIO0_ETH_RXCLK(GPIO0_ETH_RXCLK),	// in    [GPIO0] eth rxclk
	.GPIO0_ETH_TXCLK(GPIO0_ETH_TXCLK),	// in    [GPIO0] eth txclk
	.GPIO0_ETH_CLK(GPIO0_ETH_CLK),		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
	.GPIO0_ETH_CLKFB(GPIO0_ETH_CLKFB),	// in    [GPIO0] eth clkfb (RMII=50MHz)
	.GPIO0_ETH_RST_N(GPIO0_ETH_RST_N),	// out   [GPIO0] eth #rst
	.GPIO0_ETH_MDC(GPIO0_ETH_MDC),		// out   [GPIO0] eth mdc
	.GPIO0_ETH_MDIO(GPIO0_ETH_MDIO),		// inout [GPIO0] eth mdio
	.GPIO0_ETH_RXDV(GPIO0_ETH_RXDV),		// inout [GPIO0] eth rxdv (MII/RMII mode)
	.GPIO0_ETH_CRS(GPIO0_ETH_CRS),		// in    [GPIO0] eth crs
	.GPIO0_ETH_RXER(GPIO0_ETH_RXER),		// in    [GPIO0] eth rxer
	.GPIO0_ETH_COL(GPIO0_ETH_COL),		// in    [GPIO0] eth col
	.GPIO0_ETH_RXD(GPIO0_ETH_RXD),		// in    [GPIO0] eth rxd
	.GPIO0_ETH_TXEN(GPIO0_ETH_TXEN),		// out   [GPIO0] eth txen
	.GPIO0_ETH_TXD(GPIO0_ETH_TXD),		// out   [GPIO0] eth txd
	.GPIO0_SPD_TX(GPIO0_SPD_TX),		// out   [GPIO0] optical tx
	.GPIO0_SPD_RX(GPIO0_SPD_RX),		// in    [GPIO0] optical rx
	.GPIO0_DA0(GPIO0_DA0),			// out   [GPIO0] DA0(L) out
	.GPIO0_DA1(GPIO0_DA1),			// out   [GPIO0] DA1(R) out
	.GPIO0_SD_DO(GPIO0_SD_DO),		// in    [GPIO0] sd dout (<- card out)
	.GPIO0_SD_SCK(GPIO0_SD_SCK),		// out   [GPIO0] sd sck  (-> card in)
	.GPIO0_SD_DI(GPIO0_SD_DI),		// out   [GPIO0] sd din  (-> card in)
	.GPIO0_SD_CS(GPIO0_SD_CS),		// out   [GPIO0] sd cs   (-> card in)
	.GPIO0_USB0(GPIO0_USB0),			// inout [GPIO0] usb DM
	.GPIO0_USB1(GPIO0_USB1),			// inout [GPIO0] usb DP
	.GPIO0_USB2(GPIO0_USB2),			// out   [GPIO0] usb host pd
	.GPIO0_USB3(GPIO0_USB3),			// out   [GPIO0] usb dev DM pu
	.GPIO0_USB4(GPIO0_USB4),			// out   [GPIO0] usb dev DP pu
	.GPIO0_USB5(GPIO0_USB5),			// in    [GPIO0] usb dev power sense
	.GPIO0_UTX(GPIO0_UTX),			// out   [GPIO0] uart tx out
	.GPIO0_URX(GPIO0_URX),			// in    [GPIO0] uart rx in

	.GPIO1_PC(GPIO1_PC),		// inout [GPIO1] sv1
	.GPIO1_PB(GPIO1_PB),		// inout [GPIO1] sv2
	.GPIO1_PA(GPIO1_PA),		// inout [GPIO1] sv3
	.GPIO1_PF(GPIO1_PF),		// inout [GPIO1] sv4
	.GPIO1_TX(GPIO1_TX),		// out   [GPIO1] video out
	.GPIO1_PLLFB(GPIO1_PLLFB),	// out   [GPIO1] pllfb -> pll
	.GPIO1_HPD(GPIO1_HPD),		// in    [GPIO1] hpd in
	.GPIO1_SCL(GPIO1_SCL),		// inout [GPIO1] ddc scl
	.GPIO1_SDA(GPIO1_SDA),		// inout [GPIO1] ddc sda
	.GPIO1_PLL(GPIO1_PLL),		// in    [GPIO1] pllfb -> pll
	.GPIO1_CLK(CLK32),		// in    [GPIO1] option (27MHz or 24.576MHz)

	.BUTTON(BUTTON),			// in    [SW] button[2:0]

	.SW(SW),				// in    [SW] sw[9:0]

	.LEDG(LEDG),			// out   [LED] led green[9:0]
	.HEX0_D(HEX0_D),			// out   [LED] led hex0[6:0]
	.HEX0_DP(HEX0_DP),		// out   [LED] led hex0 point
	.HEX1_D(HEX1_D),			// out   [LED] led hex1[6:0]
	.HEX1_DP(HEX1_DP),		// out   [LED] led hex1 point
	.HEX2_D(HEX2_D),			// out   [LED] led hex2[6:0]
	.HEX2_DP(HEX2_DP),		// out   [LED] led hex2 point
	.HEX3_D(HEX3_D),			// out   [LED] led hex3[6:0]
	.HEX3_DP(HEX3_DP),		// out   [LED] led hex3 point

	.PS2_KBCLK(PS2_KBCLK),		// out   [KBD] clock
	.PS2_KBDAT(PS2_KBDAT),		// out   [KBD] data
	.PS2_MSCLK(PS2_MSCLK),		// out   [MS] clock
	.PS2_MSDAT(PS2_MSDAT),		// out   [MS] data
	.UART_RXD(UART_RXD),		// in    [UART] rxd
	.UART_TXD(UART_TXD),		// out   [UART] txd
	.UART_RTS(UART_RTS),		// in    [UART] rts
	.UART_CTS(UART_CTS),		// out   [UART] cts

	.VGA_R(VGA_R),			// out   [VIDEO] red[3:0]
	.VGA_G(VGA_G),			// out   [VIDEO] green[3:0]
	.VGA_B(VGA_B),			// out   [VIDEO] blue[3:0]
	.VGA_HS(VGA_HS),			// out   [VIDEO] hsync
	.VGA_VS(VGA_VS),			// out   [VIDEO] vsync

	.LCD_DATA(LCD_DATA),		// inout [LCD] lcd data[7:0]
	.LCD_RW(LCD_RW),			// out   [LCD] lcd rw
	.LCD_RS(LCD_RS),			// out   [LCD] lcd rs
	.LCD_EN(LCD_EN),			// out   [LCD] lcd en
	.LCD_BLON(LCD_BLON),		// out   [LCD] lcd backlight on

	.DRAM_ADDR(DRAM_ADDR),		// out   [SDR] addr[12:0]
	.DRAM_BA(DRAM_BA),		// out   [SDR] bank[1:0]
	.DRAM_CAS_N(DRAM_CAS_N),		// out   [SDR] #cas
	.DRAM_CKE(DRAM_CKE),		// out   [SDR] cke
	.DRAM_CLK(DRAM_CLK),		// out   [SDR] clk
	.DRAM_CS_N(DRAM_CS_N),		// out   [SDR] #cs
	.DRAM_DQ(DRAM_DQ),		// inout [SDR] data[15:0]
	.DRAM_DQM(DRAM_DQM),		// out   [SDR] dqm[1:0]
	.DRAM_RAS_N(DRAM_RAS_N),		// out   [SDR] #ras
	.DRAM_WE_N(DRAM_WE_N),		// out   [SDR] #we

	.FL_ADDR(FL_ADDR),		// out   [FLASH]
	.FL_DQ(FL_DQ),			// inout [FLASH]
	.FL_CE_N(FL_CE_N),		// out   [FLASH]
	.FL_OE_N(FL_OE_N),		// out   [FLASH]
	.FL_WE_N(FL_WE_N),		// out   [FLASH]
	.FL_RST_N(FL_RST_N),		// out   [FLASH]
	.FL_BYTE_N(FL_BYTE_N),		// out   [FLASH] flash #byte
	.FL_RY(FL_RY),			// in    [FLASH] flash ready/#busy
	.FL_WP_N(FL_WP_N),		// out   [FLASH] flash #wp

	.SD_DAT(SD_DAT),			// in    [SD] spi dat_i(sd -> host)
	.SD_CMD(SD_CMD),			// out   [SD] spi dat_o(host -> sd)
	.SD_CLK(SD_CLK),			// out   [SD] spi clk
	.SD_DAT3(SD_DAT3),		// out   [SD] spi cs
	.SD_WP_N(SD_WP_N)			// in    [SD] sd #wp
);

endmodule
