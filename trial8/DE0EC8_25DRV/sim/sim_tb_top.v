`timescale 1ps/1ps

module sim_tb_top;

	parameter DEBUG_EN=0;

	reg		clk50;

	initial
	begin
		forever
			begin
				clk50 <= 1'b0;	# 5000;
				clk50 <= 1'b1;	# 5000;
			end
	end

	reg		rst_n;

	initial
	begin
		rst_n = 1'b0;	#100000;
		rst_n = 1'b1;
	end


	wire			CLOCK_50;
	wire			CLOCK_50_2;

	wire			GPIO0_ETH_RXCLK;
	wire			GPIO0_ETH_TXCLK;
	wire			GPIO0_ETH_CLK;
	wire			GPIO0_ETH_CLKFB;
	wire			GPIO0_ETH_RST_N;
	wire			GPIO0_ETH_MDC;
	wire			GPIO0_ETH_MDIO;
	wire			GPIO0_ETH_RXDV;
	wire			GPIO0_ETH_CRS;
	wire			GPIO0_ETH_RXER;
	wire			GPIO0_ETH_COL;
	wire	[3:0]	GPIO0_ETH_RXD;
	wire			GPIO0_ETH_TXEN;
	wire	[3:0]	GPIO0_ETH_TXD;
	wire			GPIO0_SPD_TX;
	tri0			GPIO0_SPD_RX;
	wire			GPIO0_DA0;
	wire			GPIO0_DA1;
	tri0			GPIO0_SD_DO;
	wire			GPIO0_SD_SCK;
	wire			GPIO0_SD_DI;
	wire			GPIO0_SD_CS;
	wire			GPIO0_USB0;
	wire			GPIO0_USB1;
	wire			GPIO0_USB2;
	wire			GPIO0_USB3;
	wire			GPIO0_USB4;
	wire			GPIO0_USB5;
	wire			GPIO0_UTX;
	wire			GPIO0_URX;

	tri1	[7:0]	GPIO1_PC;
	tri1	[7:0]	GPIO1_PB;
	tri1	[7:0]	GPIO1_PA;
	wire	[1:0]	GPIO1_PF;
	wire	[3:0]	GPIO1_TX;
	wire			GPIO1_PLLFB;
	wire			GPIO1_HPD;
	wire			GPIO1_SCL;
	wire			GPIO1_SDA;
	wire			GPIO1_PLL;
	wire			GPIO1_CLK;

	tri1	[2:0]	BUTTON;

	tri1	[9:0]	SW;

	wire	[9:0]	LEDG;
	wire	[6:0]	HEX0_D;
	wire			HEX0_DP;
	wire	[6:0]	HEX1_D;
	wire			HEX1_DP;
	wire	[6:0]	HEX2_D;
	wire			HEX2_DP;
	wire	[6:0]	HEX3_D;
	wire			HEX3_DP;

	wire			PS2_KBCLK;
	wire			PS2_KBDAT;
	wire			PS2_MSCLK;
	wire			PS2_MSDAT;
	wire			UART_RXD;
	wire			UART_TXD;
	wire			UART_RTS;
	wire			UART_CTS;

	wire	[3:0]	VGA_R;
	wire	[3:0]	VGA_G;
	wire	[3:0]	VGA_B;
	wire			VGA_HS;
	wire			VGA_VS;

	wire	[7:0]	LCD_DATA;
	wire			LCD_RW;
	wire			LCD_RS;
	wire			LCD_EN;
	wire			LCD_BLON;

	wire	[12:0]	DRAM_ADDR;
	wire	[1:0]	DRAM_BA;
	wire			DRAM_CAS_N;
	wire			DRAM_CKE;
	wire			DRAM_CLK;
	wire			DRAM_CS_N;
	tri1	[15:0]	DRAM_DQ;
	wire	[1:0]	DRAM_DQM;
	wire			DRAM_RAS_N;
	wire			DRAM_WE_N;

	wire	[21:0]	FL_ADDR;
	tri0	[15:0]	FL_DQ;
	wire			FL_CE_N;
	wire			FL_OE_N;
	wire			FL_WE_N;
	wire			FL_RST_N;
	wire			FL_BYTE_N;
	wire			FL_RY;
	wire			FL_WP_N;

	wire			SD_DAT;
	wire			SD_CMD;
	wire			SD_CLK;
	wire			SD_DAT3;
	wire			SD_WP_N;

	assign CLOCK_50=clk50;
	assign CLOCK_50_2=clk50;

	assign BUTTON[0]=rst_n;
	assign BUTTON[1]=1'b1;
	assign BUTTON[2]=1'b1;

de0ec8_25drv #(
	.DEVICE(1),			// 1=altera
	.SIM_WO_TG68(0),	// reduced simulation : without TG68
	.SIM_WO_SDR(0),		// redused simulation : without sdr-sdram
	.SIM_FAST(1),		// fast simulation
	.SIM_WO_VDP(0),		//
	.SIM_WO_OS(1),		//
	.DEBUG(0)			// 
) gen_top (
	.CLOCK_50(CLOCK_50),				// in    [SYS] 50MHz
	.CLOCK_50_2(CLOCK_50_2),			// in    [SYS] 50MHz

	.GPIO0_ETH_RXCLK(GPIO0_ETH_RXCLK),	// in    [GPIO0] eth rxclk
	.GPIO0_ETH_TXCLK(GPIO0_ETH_TXCLK),	// in    [GPIO0] eth txclk
	.GPIO0_ETH_CLK(GPIO0_ETH_CLK),		// out   [GPIO0] eth clk (MII=25MHz/RMII=50MHz)
	.GPIO0_ETH_CLKFB(GPIO0_ETH_CLKFB),	// in    [GPIO0] eth clkfb (RMII=50MHz)
	.GPIO0_ETH_RST_N(GPIO0_ETH_RST_N),	// out   [GPIO0] eth #rst
	.GPIO0_ETH_MDC(GPIO0_ETH_MDC),		// out   [GPIO0] eth mdc
	.GPIO0_ETH_MDIO(GPIO0_ETH_MDIO),	// inout [GPIO0] eth mdio
	.GPIO0_ETH_RXDV(GPIO0_ETH_RXDV),	// in    [GPIO0] eth rxdv (MII/RMII mode)
	.GPIO0_ETH_CRS(GPIO0_ETH_CRS),		// in    [GPIO0] eth crs
	.GPIO0_ETH_RXER(GPIO0_ETH_RXER),	// in    [GPIO0] eth rxer
	.GPIO0_ETH_COL(GPIO0_ETH_COL),		// in    [GPIO0] eth col
	.GPIO0_ETH_RXD(GPIO0_ETH_RXD),		// in    [GPIO0] eth rxd
	.GPIO0_ETH_TXEN(GPIO0_ETH_TXEN),	// out   [GPIO0] eth txen
	.GPIO0_ETH_TXD(GPIO0_ETH_TXD),		// out   [GPIO0] eth txd
	.GPIO0_SPD_TX(GPIO0_SPD_TX),		// out   [GPIO0] optical tx
	.GPIO0_SPD_RX(GPIO0_SPD_RX),		// in    [GPIO0] optical rx
	.GPIO0_DA0(GPIO0_DA0),				// out   [GPIO0] DA0(L) out
	.GPIO0_DA1(GPIO0_DA1),				// out   [GPIO0] DA1(R) out
	.GPIO0_SD_DO(GPIO0_SD_DO),			// in    [GPIO0] sd dout (<- card out)
	.GPIO0_SD_SCK(GPIO0_SD_SCK),		// out   [GPIO0] sd sck  (-> card in)
	.GPIO0_SD_DI(GPIO0_SD_DI),			// out   [GPIO0] sd din  (-> card in)
	.GPIO0_SD_CS(GPIO0_SD_CS),			// out   [GPIO0] sd cs   (-> card in)
	.GPIO0_USB0(GPIO0_USB0),			// inout [GPIO0] usb DM
	.GPIO0_USB1(GPIO0_USB1),			// inout [GPIO0] usb DP
	.GPIO0_USB2(GPIO0_USB2),			// out   [GPIO0] usb host pd
	.GPIO0_USB3(GPIO0_USB3),			// out   [GPIO0] usb dev DM pu
	.GPIO0_USB4(GPIO0_USB4),			// out   [GPIO0] usb dev DP pu
	.GPIO0_USB5(GPIO0_USB5),			// in    [GPIO0] usb dev power sense
	.GPIO0_UTX(GPIO0_UTX),				// out   [GPIO0] uart tx out
	.GPIO0_URX(GPIO0_URX),				// in    [GPIO0] uart rx in

	.GPIO1_PC(GPIO1_PC),				// inout [GPIO1] sv1
	.GPIO1_PB(GPIO1_PB),				// inout [GPIO1] sv2
	.GPIO1_PA(GPIO1_PA),				// inout [GPIO1] sv3
	.GPIO1_PF(GPIO1_PF),				// inout [GPIO1] sv4
	.GPIO1_TX(GPIO1_TX),				// out   [GPIO1] video out
	.GPIO1_PLLFB(GPIO1_PLLFB),			// out   [GPIO1] pllfb -> pll
	.GPIO1_HPD(GPIO1_HPD),				// in    [GPIO1] hpd in
	.GPIO1_SCL(GPIO1_SCL),				// inout [GPIO1] ddc scl
	.GPIO1_SDA(GPIO1_SDA),				// inout [GPIO1] ddc sda
	.GPIO1_PLL(GPIO1_PLL),				// in    [GPIO1] pllfb -> pll
	.GPIO1_CLK(GPIO1_CLK),				// in    [GPIO1] option (27MHz or 24.576MHz)

	.BUTTON(BUTTON),					// in    [SW] button[2:0]

	.SW(SW),							// in    [SW] sw[9:0]

	.LEDG(LEDG),						// out   [LED] led green[9:0]
	.HEX0_D(HEX0_D),					// out   [LED] led hex0[6:0]
	.HEX0_DP(HEX0_DP),					// out   [LED] led hex0 point
	.HEX1_D(HEX1_D),					// out   [LED] led hex1[6:0]
	.HEX1_DP(HEX1_DP),					// out   [LED] led hex1 point
	.HEX2_D(HEX2_D),					// out   [LED] led hex2[6:0]
	.HEX2_DP(HEX2_DP),					// out   [LED] led hex2 point
	.HEX3_D(HEX3_D),					// out   [LED] led hex3[6:0]
	.HEX3_DP(HEX3_DP),					// out   [LED] led hex3 point

	.PS2_KBCLK(PS2_KBCLK),				// out   [KBD] clock
	.PS2_KBDAT(PS2_KBDAT),				// out   [KBD] data
	.PS2_MSCLK(PS2_MSCLK),				// out   [MS] clock
	.PS2_MSDAT(PS2_MSDAT),				// out   [MS] data
	.UART_RXD(UART_RXD),				// in    [UART] rxd
	.UART_TXD(UART_TXD),				// out   [UART] txd
	.UART_RTS(UART_RTS),				// in    [UART] rts
	.UART_CTS(UART_CTS),				// out   [UART] cts

	.VGA_R(VGA_R),						// out   [VIDEO] red[3:0]
	.VGA_G(VGA_G),						// out   [VIDEO] green[3:0]
	.VGA_B(VGA_B),						// out   [VIDEO] blue[3:0]
	.VGA_HS(VGA_HS),					// out   [VIDEO] hsync
	.VGA_VS(VGA_VS),					// out   [VIDEO] vsync

	.LCD_DATA(LCD_DATA),				// inout [LCD] lcd data[7:0]
	.LCD_RW(LCD_RW),					// out   [LCD] lcd rw
	.LCD_RS(LCD_RS),					// out   [LCD] lcd rs
	.LCD_EN(LCD_EN),					// out   [LCD] lcd en
	.LCD_BLON(LCD_BLON),				// out   [LCD] lcd backlight on

	.DRAM_ADDR(DRAM_ADDR),				// out   [SDR] addr[12:0]
	.DRAM_BA(DRAM_BA),					// out   [SDR] bank[1:0]
	.DRAM_CAS_N(DRAM_CAS_N),			// out   [SDR] #cas
	.DRAM_CKE(DRAM_CKE),				// out   [SDR] cke
	.DRAM_CLK(DRAM_CLK),				// out   [SDR] clk
	.DRAM_CS_N(DRAM_CS_N),				// out   [SDR] #cs
	.DRAM_DQ(DRAM_DQ),					// inout [SDR] data[15:0]
	.DRAM_DQM(DRAM_DQM),				// out   [SDR] dqm[1:0]
	.DRAM_RAS_N(DRAM_RAS_N),			// out   [SDR] #ras
	.DRAM_WE_N(DRAM_WE_N),				// out   [SDR] #we

	.FL_ADDR(FL_ADDR),					// out   [FLASH]
	.FL_DQ(FL_DQ),						// inout [FLASH]
	.FL_CE_N(FL_CE_N),					// out   [FLASH]
	.FL_OE_N(FL_OE_N),					// out   [FLASH]
	.FL_WE_N(FL_WE_N),					// out   [FLASH]
	.FL_RST_N(FL_RST_N),				// out   [FLASH]
	.FL_BYTE_N(FL_BYTE_N),				// out   [FLASH] flash #byte
	.FL_RY(FL_RY),						// in    [FLASH] flash ready/#busy
	.FL_WP_N(FL_WP_N),					// out   [FLASH] flash #wp

	.SD_DAT(SD_DAT),					// in    [SD] spi dat_i(sd -> host)
	.SD_CMD(SD_CMD),					// out   [SD] spi dat_o(host -> sd)
	.SD_CLK(SD_CLK),					// out   [SD] spi clk
	.SD_DAT3(SD_DAT3),					// out   [SD] spi cs
	.SD_WP_N(SD_WP_N)					// in    [SD] sd #wp
);

	wire	[15:0] cart_rdata;

//	assign FL_DQ[15:0]=(FL_OE_N==1'b0) & (FL_CE_N==1'b0) ? {cart_rdata[7:0],cart_rdata[15:8]} : 16'hzzzz;	// i-impact
	assign FL_DQ[15:0]=(FL_OE_N==1'b0) & (FL_CE_N==1'b0) ? cart_rdata[15:0] : 16'hzzzz;	// q-programmer

xil_blk_mem_gen_16x16k cart(
	.clka(clk50),
	.ena(1'b1),
	.wea(2'b00),
	.addra(FL_ADDR[13:0]),
	.dina(16'h0),
	.clkb(clk50),
	.enb(1'b1),
	.addrb(FL_ADDR[13:0]),
	.doutb(cart_rdata)
);

endmodule
