//------------------------------------------------------------------------------
//
//  xil_z_lvds6.v : xilinx zynq-7000 lvds/rgb666 output module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2009/aug/17 release 0.0  lcd lvds/rgb666 display test
//       aug/22 release 0.0a cut out lvds/rgb666
//  2012/mar/19 release 0.1  polarity select
//  2012/jun/09 release 0.2  zynq-7000
//  2013/apr/08 release 0.3  select differential / single_end
//
//------------------------------------------------------------------------------

module xil_lvds6 #(
	parameter	DEVICE=0,		// device 7series=7 / other=0
	parameter	LCD_TX0=0,		// polarity 0=normal / 1=invert
	parameter	LCD_TX1=0,		// polarity 0=normal / 1=invert
	parameter	LCD_TX2=0,		// polarity 0=normal / 1=invert
	parameter	LCD_TXC=0,		// polarity 0=normal / 1=invert
	parameter	differential=1	// select diff=1 , single_end=0
) (
	output			LCD_TX0_N,				// out   [LCD] ch0-n lvds
	output			LCD_TX0_P,				// out   [LCD] ch0-p lvds
	output			LCD_TX1_N,				// out   [LCD] ch1-n lvds
	output			LCD_TX1_P,				// out   [LCD] ch1-p lvds
	output			LCD_TX2_N,				// out   [LCD] ch2-n lvds
	output			LCD_TX2_P,				// out   [LCD] ch2-p lvds
	output			LCD_TXC_N,				// out   [LCD] clk-n lvds
	output			LCD_TXC_P,				// out   [LCD] clk-p lvds

	input	[7:0]	TX_RED,					// in    [TX] [7:0] red
	input	[7:0]	TX_GRN,					// in    [TX] [7:0] green
	input	[7:0]	TX_BLU,					// in    [TX] [7:0] blue
	input			TX_HS,					// in    [TX] hsync
	input			TX_VS,					// in    [TX] vsync
	input			TX_DE,					// in    [TX] de

	input			CLK,					// in    [DVI] clk
	input			CLK_div2x7,				// in    [DVI] clk /2x7 : lvds ddr
	input			RESET_N					// in    [DVI] #reset
);

//--------------------------------------------------------------
//  override parameter

//--------------------------------------------------------------
//  local parameter

//--------------------------------------------------------------
//	signal

	wire	tx_ch0_lcd;
	wire	tx_ch1_lcd;
	wire	tx_ch2_lcd;
	wire	tx_ch3_lcd;
	wire	tx_chc_lcd;

	reg		[13:0] lvds_ch0_r;
	reg		[13:0] lvds_ch1_r;
	reg		[13:0] lvds_ch2_r;

	wire	[13:0] lvds_ch0_w;
	wire	[13:0] lvds_ch1_w;
	wire	[13:0] lvds_ch2_w;

	wire	lvds_tx_req;

	reg		[3:0] lvds_tx_req_r;
	wire	[3:0] lvds_tx_req_w;

	reg		[1:0] lvds_tx0_out_r;
	reg		[1:0] lvds_tx1_out_r;
	reg		[1:0] lvds_tx2_out_r;
	reg		[1:0] lvds_txc_out_r;

	wire	[1:0] lvds_tx0_out_w;
	wire	[1:0] lvds_tx1_out_w;
	wire	[1:0] lvds_tx2_out_w;
	wire	[1:0] lvds_txc_out_w;

	reg		[13:0] lvds_tx0_r;
	reg		[13:0] lvds_tx1_r;
	reg		[13:0] lvds_tx2_r;
	reg		[13:0] lvds_txc_r;

	wire	[13:0] lvds_tx0_w;
	wire	[13:0] lvds_tx1_w;
	wire	[13:0] lvds_tx2_w;
	wire	[13:0] lvds_txc_w;

//--------------------------------------------------------------
//	design

generate
	if (DEVICE==7)
begin

ODDR LCD_tx0_p(.Q(tx_ch0_lcd),.C(CLK_div2x7),.CE(1'b1),.D1( lvds_tx0_out_r[0]),.D2( lvds_tx0_out_r[1]),.R(1'b0),.S(1'b0));
ODDR LCD_tx1_p(.Q(tx_ch1_lcd),.C(CLK_div2x7),.CE(1'b1),.D1( lvds_tx1_out_r[0]),.D2( lvds_tx1_out_r[1]),.R(1'b0),.S(1'b0));
ODDR LCD_tx2_p(.Q(tx_ch2_lcd),.C(CLK_div2x7),.CE(1'b1),.D1( lvds_tx2_out_r[0]),.D2( lvds_tx2_out_r[1]),.R(1'b0),.S(1'b0));
ODDR LCD_txc_p(.Q(tx_chc_lcd),.C(CLK_div2x7),.CE(1'b1),.D1( lvds_txc_out_r[0]),.D2( lvds_txc_out_r[1]),.R(1'b0),.S(1'b0));

end
	else
begin

FDDRRSE LCD_tx0_p(.Q(tx_ch0_lcd),.C0(CLK_div2x7),.C1(~CLK_div2x7),.CE(1'b1),.D0( lvds_tx0_out_r[0]),.D1( lvds_tx0_out_r[1]),.R(1'b0),.S(1'b0));
FDDRRSE LCD_tx1_p(.Q(tx_ch1_lcd),.C0(CLK_div2x7),.C1(~CLK_div2x7),.CE(1'b1),.D0( lvds_tx1_out_r[0]),.D1( lvds_tx1_out_r[1]),.R(1'b0),.S(1'b0));
FDDRRSE LCD_tx2_p(.Q(tx_ch2_lcd),.C0(CLK_div2x7),.C1(~CLK_div2x7),.CE(1'b1),.D0( lvds_tx2_out_r[0]),.D1( lvds_tx2_out_r[1]),.R(1'b0),.S(1'b0));
FDDRRSE LCD_txc_p(.Q(tx_chc_lcd),.C0(CLK_div2x7),.C1(~CLK_div2x7),.CE(1'b1),.D0( lvds_txc_out_r[0]),.D1( lvds_txc_out_r[1]),.R(1'b0),.S(1'b0));

end
endgenerate

generate
	if (differential==0)
begin

	assign {LCD_TX0_P,LCD_TX0_N}={tx_ch0_lcd,1'b0};
	assign {LCD_TX1_P,LCD_TX1_N}={tx_ch1_lcd,1'b0};
	assign {LCD_TX2_P,LCD_TX2_N}={tx_ch2_lcd,1'b0};
	assign {LCD_TXC_P,LCD_TXC_N}={tx_chc_lcd,1'b0};

end
endgenerate

generate
	if ((differential==1) & (LCD_TX0==0))
		OBUFDS LVDS_tx0(.O(LCD_TX0_P),.OB(LCD_TX0_N),.I(tx_ch0_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TX0==1))
		OBUFDS LVDS_tx0(.OB(LCD_TX0_P),.O(LCD_TX0_N),.I(tx_ch0_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TX1==0))
		OBUFDS LVDS_tx0(.O(LCD_TX1_P),.OB(LCD_TX1_N),.I(tx_ch1_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TX1==1))
		OBUFDS LVDS_tx0(.OB(LCD_TX1_P),.O(LCD_TX1_N),.I(tx_ch1_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TX2==0))
		OBUFDS LVDS_tx0(.O(LCD_TX2_P),.OB(LCD_TX2_N),.I(tx_ch2_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TX2==1))
		OBUFDS LVDS_tx0(.OB(LCD_TX2_P),.O(LCD_TX2_N),.I(tx_ch2_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TXC==0))
		OBUFDS LVDS_tx0(.O(LCD_TXC_P),.OB(LCD_TXC_N),.I(tx_chc_lcd));
endgenerate

generate
	if ((differential==1) & (LCD_TXC==1))
		OBUFDS LVDS_tx0(.OB(LCD_TXC_P),.O(LCD_TXC_N),.I(tx_chc_lcd));
endgenerate

	reg		CLK_div2_r;

	always @(posedge CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				CLK_div2_r <= 1'b0;
				lvds_ch0_r[13:0] <= 14'b0;
				lvds_ch1_r[13:0] <= 14'b0;
				lvds_ch2_r[13:0] <= 14'b0;
			end
		else
			begin
				CLK_div2_r <= !CLK_div2_r;
				lvds_ch0_r[13:0] <= lvds_ch0_w[13:0];
				lvds_ch1_r[13:0] <= lvds_ch1_w[13:0];
				lvds_ch2_r[13:0] <= lvds_ch2_w[13:0];
			end
	end

	assign lvds_ch0_w[13:7]=lvds_ch0_r[6:0];
	assign lvds_ch1_w[13:7]=lvds_ch1_r[6:0];
	assign lvds_ch2_w[13:7]=lvds_ch2_r[6:0];

	assign lvds_ch0_w[6:0]=(TX_DE==1'b1) ? {TX_GRN[2],TX_RED[7:2]} : 7'b0;
	assign lvds_ch1_w[6:0]=(TX_DE==1'b1) ? {TX_BLU[3:2],TX_GRN[7:3]} : 7'b0;
	assign lvds_ch2_w[6:0]=(TX_DE==1'b1) ? {TX_DE,TX_VS,TX_HS,TX_BLU[7:4]} : {TX_DE,TX_VS,TX_HS,4'b0};
//	assign lvds_ch0_w[6:0]={TX_DE,TX_VS,TX_HS,4'b0};
//	assign lvds_ch1_w[6:0]={TX_DE,TX_VS,TX_HS,4'b0};
//	assign lvds_ch2_w[6:0]={TX_DE,TX_VS,TX_HS,4'b0};

	assign lvds_tx_req=lvds_tx_req_r[3];

	always @(posedge CLK_div2x7 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				lvds_tx_req_r[3:0] <= 4'b0;
				lvds_tx0_r[13:0] <= 14'b0;
				lvds_tx1_r[13:0] <= 14'b0;
				lvds_tx2_r[13:0] <= 14'b0;
				lvds_txc_r[13:0] <= 14'b0;
				lvds_tx0_out_r[1:0] <= 2'b0;
				lvds_tx1_out_r[1:0] <= 2'b0;
				lvds_tx2_out_r[1:0] <= 2'b0;
				lvds_txc_out_r[1:0] <= 2'b0;
			end
		else
			begin
				lvds_tx_req_r[3:0] <= lvds_tx_req_w[3:0];
				lvds_tx0_r[13:0] <= lvds_tx0_w[13:0];
				lvds_tx1_r[13:0] <= lvds_tx1_w[13:0];
				lvds_tx2_r[13:0] <= lvds_tx2_w[13:0];
				lvds_txc_r[13:0] <= lvds_txc_w[13:0];
				lvds_tx0_out_r[1:0] <= lvds_tx0_out_w[1:0];
				lvds_tx1_out_r[1:0] <= lvds_tx1_out_w[1:0];
				lvds_tx2_out_r[1:0] <= lvds_tx2_out_w[1:0];
				lvds_txc_out_r[1:0] <= lvds_txc_out_w[1:0];
			end
	end

	assign lvds_tx_req_w[0]=CLK_div2_r;
	assign lvds_tx_req_w[1]=lvds_tx_req_r[0];
	assign lvds_tx_req_w[2]=lvds_tx_req_r[1];
	assign lvds_tx_req_w[3]=(lvds_tx_req_r[2:1]==2'b01) ? 1'b1 : 1'b0;

	assign lvds_tx0_w[13:0]=(lvds_tx_req==1'b1) ? lvds_ch0_r[13:0] : {lvds_tx0_r[11:0],2'b0};
	assign lvds_tx1_w[13:0]=(lvds_tx_req==1'b1) ? lvds_ch1_r[13:0] : {lvds_tx1_r[11:0],2'b0};
	assign lvds_tx2_w[13:0]=(lvds_tx_req==1'b1) ? lvds_ch2_r[13:0] : {lvds_tx2_r[11:0],2'b0};
	assign lvds_txc_w[13:0]=(lvds_tx_req==1'b1) ? 14'b11000111100011 : {lvds_txc_r[11:0],2'b0};

	assign lvds_tx0_out_w[1:0]=(LCD_TX0==1'b0) ? {lvds_tx0_r[13],lvds_tx0_r[12]} : {!lvds_tx0_r[13],!lvds_tx0_r[12]};
	assign lvds_tx1_out_w[1:0]=(LCD_TX1==1'b0) ? {lvds_tx1_r[13],lvds_tx1_r[12]} : {!lvds_tx1_r[13],!lvds_tx1_r[12]};
	assign lvds_tx2_out_w[1:0]=(LCD_TX2==1'b0) ? {lvds_tx2_r[13],lvds_tx2_r[12]} : {!lvds_tx2_r[13],!lvds_tx2_r[12]};
	assign lvds_txc_out_w[1:0]=(LCD_TXC==1'b0) ? {lvds_txc_r[13],lvds_txc_r[12]} : {!lvds_txc_r[13],!lvds_txc_r[12]};

endmodule

