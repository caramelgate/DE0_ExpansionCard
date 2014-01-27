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
	wire	CLK64;
	wire	RST_N;

	// ---- 50MHz ----

	reg		CLK50_r;

	initial
	begin
		forever
		begin
			CLK50_r <= 1'b0; #10;
			CLK50_r <= 1'b1; #10;
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

	parameter	busfree=8'h0;
	parameter	def_DEVICE=1;			// 0=Xilinx , 1=Altera
	parameter	def_X1TURBO=0;
	parameter	def_VBASE=32'h00180000;	// video base address
	parameter	SIM_FAST=1;				// fast simulation
	parameter	DEBUG=0;					// 

	wire	DRAM_OE;
	wire	MEM_INIT_DONE;
	wire	[15:0] DRAM_WDATA;
	wire	[15:0] DRAM_RDATA;

	wire	sys_clk;
	wire	mem_clk;
//	wire	mem_clk1;
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

//	wire	CLK50D;

	assign sys_clk=CLK32;	// 
//	assign mem_clk=CLK64;
	assign mem_clk=CLK50;	// sdr clock
//	assign mem_clk1=CLK50D;	// sdr clock
	assign mem_rst_n=RST_N;

	assign DRAM_DQ[15:0]=(DRAM_OE==1'b1) ? DRAM_WDATA[15:0] : 16'hzzzz;
//	assign DRAM_RDATA[15:0]=DRAM_DQ[15:0];

	reg		[15:0] dr_dq_r;

	always @(posedge DRAM_CLK or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				dr_dq_r[15:0] <= 16'b0;
			end
		else
			begin
				dr_dq_r[15:0] <= (DRAM_CAS_N==1'b0) ? {DRAM_ADDR[11:0],4'b0} : dr_dq_r[15:0]+16'b01;
			end
	end

	assign DRAM_RDATA[15:0]=dr_dq_r[15:0];

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
//	.mem_clk1(mem_clk1),			// in    [SYS] clk +90deg
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

	assign p0_cmd_clk=sys_clk;
	assign p0_cmd_en=1'b0;
	assign p0_cmd_instr[2:0]=3'b0;
	assign p0_cmd_bl[5:0]=6'b0;
	assign p0_cmd_byte_addr[29:0]=30'b0;
	assign p0_wr_clk=sys_clk;
	assign p0_wr_en=1'b0;
	assign p0_wr_mask[3:0]=4'b1111;
	assign p0_wr_data[31:0]=32'b0;
	assign p0_rd_clk=sys_clk;
	assign p0_rd_en=1'b0;

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

	assign p4_cmd_clk=sys_clk;
	assign p4_rd_clk=sys_clk;

	wire	EX_HS;
	wire	EX_VS;
	wire	EX_DE;
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

syncgen #(
	.hor_total(16'd1344),		// horizontal total
	.hor_addr (16'd1024),		// horizontal display
	.hor_fp   (16'd24),			// horizontal front porch (+margin)
	.hor_sync (16'd136),		// horizontal sync
	.hor_bp   (16'd160),		// horizontal back porch (+margin)
	.ver_total(16'd806),		// vertical total
	.ver_addr (16'd768),		// vertical display
	.ver_fp   (16'd36),//3),			// vertical front porch (+margin)
	.ver_sync (16'd1),//6),			// vertical sync
	.ver_bp   (16'd1),//29),			// vertical back porch (+margin)
	.hor_wpos (16'h0007),		// horizontal window start
	.ver_wpos (16'h0000),		// vertical window start
	.hor_up   (16'h8000),		// horizontal resize
	.ver_up   (16'h4000)		// vertical resize
) syncgen (
	.HSYNC_N(EX_HS),			// out   [SYNC] #hsync
	.VSYNC_N(EX_VS),			// out   [SYNC] #vsync
	.BLANK_N(EX_DE),			// out   [SYNC] #blank

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

	.RST_N(RST_N),			// in    [SYNC] #reset
	.CLK(CLK64)				// in    [SYNC] dot clock
);



nx1_vid #(
	.busfree(busfree),				// idle busdata
	.def_DEVICE(def_DEVICE),		// 0=Xilinx , 1=Altera
	.def_X1TURBO(def_X1TURBO),		// 0=X1 , 1=X1turbo (subset yet) , 2=X1TURBOZ (future...)
	.def_VBASE(def_VBASE),			// video base address
	.SIM_FAST(SIM_FAST),			// fast simulation
	.DEBUG(DEBUG)					// 
) nx1_vid (

	.EX_HS(EX_HS),				// in    [SYNC] horizontal sync
	.EX_VS(EX_VS),				// in    [SYNC] vertical sync
	.EX_DE(EX_DE),				// in    [SYNC] disp/#blank
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

	.vram_clk(sys_clk),							// in    [VRAM] clk
	.vram_init_done(MEM_INIT_DONE),				// in    [VRAM] init done
	.vram_cmd_en(p4_cmd_en),						// out   [VRAM] cmd en
	.vram_cmd_instr(p4_cmd_instr[2:0]),			// out   [VRAM] cmd inst[2:0]
	.vram_cmd_bl(p4_cmd_bl[5:0]),					// out   [VRAM] cmd blen[5:0]
	.vram_cmd_byte_addr(p4_cmd_byte_addr[29:0]),	// out   [VRAM] cmd addr[29:0]
	.vram_cmd_empty(p4_cmd_empty),				// in    [VRAM] cmd empt
	.vram_cmd_full(p4_cmd_full),					// in    [VRAM] cmd full
	.vram_rd_en(p4_rd_en),						// out   [VRAM] rd en
	.vram_rd_data(p4_rd_data[31:0]),				// in    [VRAM] rd rdata[31:0]
	.vram_rd_full(p4_rd_full),					// in    [VRAM] rd full
	.vram_rd_empty(p4_rd_empty),					// in    [VRAM] rd empt
	.vram_rd_count(p4_rd_count[6:0]),				// in    [VRAM] rd count[6:0]
	.vram_rd_overflow(p4_rd_overflow),			// in    [VRAM] rd over
	.vram_rd_error(p4_rd_error),					// in    [VRAM] rd err

	.I_RESET(!RST_N),
	.I_CCLK(CLK32),//ZCLK),
	.I_CCKE(1'b0),//ZCLK),
  .I_A(16'b0),
  .I_D(8'b0),
  .O_D(),
  .O_DE(),
  .I_WR(1'b0),
  .I_RD(1'b0),
  .O_VWAIT(),
  .defchr_enable(1'b0),
  .I_CRTC_CS(1'b0),
  .I_CG_CS(1'b0),
  .I_PAL_CS(1'b0),
  .I_TXT_CS(1'b0), .I_ATT_CS(1'b0), .I_KAN_CS(1'b0),
//  .I_GRB_CS(gr_b_cs), .I_GRR_CS(gr_r_cs), .I_GRG_CS(gr_g_cs),
  .I_VCLK(CLK64),  .I_CLK1(1'b0),
  .I_W40(1'b0),
  .I_HIRESO(1'b0),
  .I_LINE400(1'b0),
  .I_TEXT12(1'b0),
  .I_PCG_TURBO(1'b0),
  .I_CG16(1'b0),
  .I_UDLINE(1'b0),
  .I_BLACK_COL(1'b0),
  .I_TXT_BLACK(1'b0),
  .I_GR0_BLACK(1'b0),
  .I_GR1_BLACK(1'b0),
  .I_BLK_BLACK(1'b0),
	.text_rdata(),
	.attr_rdata(),
	.ktext_rdata(),

	.cg_rdata(),

	.v_red(),
	.v_grn(),
	.v_blu(),
	.v_hs(),
	.v_vs(),
	.v_de(),
	.v_whs(),
	.v_wvs(),
	.v_wde(),

	.O_R()  ,
	.O_G()   ,
	.O_B(),
	.O_HSYNC() ,
	.O_VSYNC(),
	.O_VDISP()
);


//	assign CLK50D=!CLK50;

/*
alt_altpll_50x50D clkgen_50x50D(
	.areset(!RST_N),
	.inclk0(CLK50),
	.c0(CLK50D),
	.locked()
);
*/


endmodule
