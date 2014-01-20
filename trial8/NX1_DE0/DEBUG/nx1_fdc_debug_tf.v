//------------------------------------------------------------------------------
//
//  nx1_debug_tf.v : test fixture
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/13 release 0.0  z80+fdc debug
//
//------------------------------------------------------------------------------

`timescale 1ns / 100ps

module tf (
);

	wire	CLK50;
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
				RST_N_r[8] <= (RST_N_r[7:1]==7'h3f) ? 1'b1 : RST_N_r[8];
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

/*
nx1_de0ec8 #(
	.def_DEVICE(1),	// 1=altera
	.def_sram(0),
	.def_use_ipl(0),
	.def_EXTEND_BIOS(0),	// extend BIOS MENU & NoICE-Z80 resource-free monitor
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
*/

	wire	MREQ_N;
	wire	[7:0] RDATA;
	wire	[7:0] WDATA;
	wire	[15:0] ADDR;
	wire	M1_N;
	wire	IORQ_N;
	wire	RD_N;
	wire	WR_N;
	wire	WAIT_N;
	wire	RFSH_N;

fz80c Z80(
  .reset_n(RST_N),
  .clk(CLK32),
  .mreq_n(MREQ_N), 
  .int_n(1'b1),
  .nmi_n(1'b1),
  .di(RDATA[7:0]),
  .A(ADDR[15:0]),
  .do(WDATA[7:0]),
  .m1_n(M1_N),
  .iorq_n(IORQ_N), 
  .rd_n(RD_N),
  .wr_n(WR_N),
  .wait_n(WAIT_N),
  .rfsh_n(RFSH_N),
  .halt_n(),
  .busrq_n(1'b1),
  .busak_n()
);

	wire	[19:0] faddr;
	wire	frd;
	tri1	[15:0] frdata;

	reg		[19:0] faddr_r;
	reg		rd_r;
	reg		[7:0] rdata_r;
	reg		wr_r;
	reg		[7:0] wdata_r;

	always @(posedge CLK32 or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				faddr_r[19:0] <= 20'b0;
				rd_r <= 1'b0;
				rdata_r[7:0] <= 8'b0;
				wr_r <= 1'b0;
				wdata_r[7:0] <= 8'b0;
			end
		else
			begin
				faddr_r[19:0] <= faddr[19:0];
				rd_r <= !RD_N;
				rdata_r[7:0] <= RDATA[7:0];
				wr_r <= !WR_N;
				wdata_r[7:0] <= WDATA[7:0];
			end
	end

	wire	dbg_msg_io;
	wire	dbg_msg_fdc;
	wire	dbg_msg_text;

	assign dbg_msg_io=1'b0;
	assign dbg_msg_fdc=1'b0;
	assign dbg_msg_text=1'b1;

	always @(posedge MREQ_N or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
			end
		else
			begin
				if ((dbg_msg_io==1'b1) & (RFSH_N==1'b1) & (rd_r==1'b1)) $display("MEM RD %4H %2H",ADDR,rdata_r);
				if ((dbg_msg_io==1'b1) & (RFSH_N==1'b1) & (wr_r==1'b1)) $display("MEM WR %4H %2H",ADDR,wdata_r);
			end
	end

	always @(posedge IORQ_N or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
			end
		else
			begin
			//	if (rd_r==1'b1) $display("IO RD %4H %2H",ADDR,rdata_r);
			//	if (wr_r==1'b1) $display("IO WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_fdc==1'b1) & (rd_r==1'b1) & (ADDR[15:0]==16'h0ff8)) $display("FDC STAT RD %4H %2H",ADDR,rdata_r);
				if ((dbg_msg_fdc==1'b1) & (rd_r==1'b1) & (ADDR[15:0]==16'h0ff9)) $display("FDC TRAC RD %4H %2H",ADDR,rdata_r);
				if ((dbg_msg_fdc==1'b1) & (rd_r==1'b1) & (ADDR[15:0]==16'h0ffa)) $display("FDC SECT RD %4H %2H",ADDR,rdata_r);
				if ((dbg_msg_fdc==1'b1) & (rd_r==1'b1) & (ADDR[15:0]==16'h0ffb)) $display("FDC DATA RD %4H %2H %6H",ADDR,rdata_r,faddr_r);
				if ((dbg_msg_fdc==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ff8)) $display("FDC CMD  WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_fdc==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ff9)) $display("FDC TRAC WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_fdc==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ffa)) $display("FDC SECT WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_fdc==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ffb)) $display("FDC DATA WR %4H %2H",ADDR,wdata_r);
			//	if ((rd_r==1'b1) & (ADDR[15:0]==16'h0ffb) & (faddr_r[19:8]!=12'h000)) $stop;
			end
	end

	always @(posedge IORQ_N or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
			end
		else
			begin
				if ((dbg_msg_text==1'b1) & (wr_r==1'b1) & (ADDR[15:12]==4'h3) & (wdata_r[7:0]>8'h1f)) $display("%2h",wdata_r);
				if ((dbg_msg_text==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ff8)) $display("FDC CMD  WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_text==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ff9)) $display("FDC TRAC WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_text==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ffa)) $display("FDC SECT WR %4H %2H",ADDR,wdata_r);
				if ((dbg_msg_text==1'b1) & (wr_r==1'b1) & (ADDR[15:0]==16'h0ffb)) $display("FDC DATA WR %4H %2H",ADDR,wdata_r);
				if ((rd_r==1'b1) & (ADDR[15:8]==8'h1e)) $stop;
				if ((wr_r==1'b1) & (ADDR[15:8]==8'h1e)) $stop;
			end
	end


	wire	ipl_cs;
	wire	ipl_wait_n;
	wire	[7:0] ipl_rdata;
	wire	ram_cs;
	wire	ram_wait_n;
	wire	[7:0] ram_rdata;
	wire	fdc_cs;
	wire	fdc_wait_n;
	wire	[7:0] fdc_rdata;

	assign ipl_cs=(ADDR[15]==1'b0) & (MREQ_N==1'b0) & (RD_N==1'b0) ? 1'b1 : 1'b0;
	assign ram_cs=
			(ADDR[15]==1'b0) & (MREQ_N==1'b0) & (WR_N==1'b0) ? 1'b1 :
			(ADDR[15]==1'b1) & (MREQ_N==1'b0) & ((RD_N==1'b0) | (WR_N==1'b0)) ? 1'b1 :
			1'b0;
	assign fdc_cs=(ADDR[15:4]==12'h0ff) & (IORQ_N==1'b0) & ((RD_N==1'b0) | (WR_N==1'b0)) ? 1'b1 : 1'b0;

	assign RDATA[7:0]=ipl_rdata[7:0] | ram_rdata[7:0] | fdc_rdata[7:0];

	assign WAIT_N=ipl_wait_n & ram_wait_n & fdc_wait_n;

	wire	[7:0] dpram8x16k_rdata;

	assign ram_wait_n=1'b1;
	assign ram_rdata[7:0]=(ram_cs==1'b1) ? dpram8x16k_rdata[7:0] : 8'b0;

alt_altsyncram_c3dp8x16k dpram8x16k(
	.data(WDATA[7:0]),
	.rdaddress(ADDR[13:0]),
	.rdclock(!CLK32),
	.wraddress(ADDR[13:0]),
	.wrclock(!CLK32),
	.wren(ram_cs & !WR_N),
	.q(dpram8x16k_rdata[7:0])
);

	wire	[7:0] rom_ipl_rdata;

	assign ipl_wait_n=1'b1;
	assign ipl_rdata[7:0]=(ipl_cs==1'b1) ? rom_ipl_rdata[7:0] : 8'b0;

alt_altsyncram_rom8x4k rom_ipl(
	.address(ADDR[11:0]),
	.clock(!CLK32),
	.q(rom_ipl_rdata[7:0])
);


n8877 #(
	.busfree(8'b00)
) fdc8877 (
	.faddr(faddr[19:0]),			// out   [MEM] addr
	.frd(frd),						// out   [MEM] rd req
	.frdata(frdata[15:0]),			// in    [MEM] read data

	.addr(ADDR[2:0]),
	.wdata(WDATA[7:0]),
	.rdata(fdc_rdata[7:0]),
	.wr(!WR_N),
//	input			req,
//	output			ack,

	.cs(fdc_cs),
	.wait_n(fdc_wait_n),

	.rst_n(RST_N),
	.clk(CLK32)
);

	assign frdata[15:8]=frdata[7:0];

alt_altsyncram_rom8x16k fdd(
	.address(faddr[13:0]),
	.clock(CLK32),
	.q(frdata[7:0])
);

/*
	assign {frdata[7:0],frdata[15:8]}=
			(faddr[8:1]==8'h00) ? 16'h0120 :	// 01," "
			(faddr[8:1]==8'h01) ? 16'h2122 :	// "  "
			(faddr[8:1]==8'h02) ? 16'h2324 :	// "  "
			(faddr[8:1]==8'h03) ? 16'h2526 :	// "  "
			(faddr[8:1]==8'h04) ? 16'h2728 :	// "  "
			(faddr[8:1]==8'h05) ? 16'h292a :	// "  "
			(faddr[8:1]==8'h06) ? 16'h2b2c :	// "  "
			(faddr[8:1]==8'h07) ? 16'h5379 :	// "Sy"
			(faddr[8:1]==8'h08) ? 16'h7320 :	// "s",20
			(faddr[8:1]==8'h09) ? 16'h00_02 :	// size 0200
			(faddr[8:1]==8'h0a) ? 16'h00_80 :	// load 8000
			(faddr[8:1]==8'h0b) ? 16'h00_81 :	// exec 8100
			(faddr[8:1]==8'h0c) ? 16'h23_01 :	// 
			(faddr[8:1]==8'h0d) ? 16'h67_45 :	// 
			(faddr[8:1]==8'h0e) ? 16'hab_89 :	// 
			(faddr[8:1]==8'h0f) ? 16'h10_00 :	// sect 0010
			16'he5e5;
*/

endmodule
