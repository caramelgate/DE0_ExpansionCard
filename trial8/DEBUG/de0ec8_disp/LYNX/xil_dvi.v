//------------------------------------------------------------------------------
//
//  xil_dvi.v : xilinx dvi output module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2009/mar/09 release 1.0a dvi(tmds) display test
//       jul/21 release 1.0b signal rename , delete dcm
//       aug/24 release 1.0c lvds polarity select
//  2012/jun/09 release 1.1  zynq-7000 FDDRRSE -> ODDR
//  2013/feb/20 release 1.1a select differential / single_end
//
//------------------------------------------------------------------------------
//
//  refer to
//
//  DDWG Digital Display working Group
//  Digital Visual Interface Revision 1.0 02/April/1999
//  http://www.ddwg.org
//  See FAQS and Adopter's Agreement.
//
//  This code implemented it according to DDWG DVI Revision 1.0. 
//  As for the TMDS encoding and decoding algorithm, DDWG owns a right.
//
//------------------------------------------------------------------------------

module xil_dvi #(
	parameter	DEVICE=0,			// device 7series=7 / other=0
	parameter	DVI_TX0=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TX1=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TX2=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TXC=0,			// polarity 0=normal / 1=invert
	parameter	differential=1		// select diff=1 , single_end=0
) (
	output			DVI_TX0_N,				// out   [TX] TX[0]-N (CML)
	output			DVI_TX0_P,				// out   [TX] TX[0]-P (CML)
	output			DVI_TX1_N,				// out   [TX] TX[1]-N (CML)
	output			DVI_TX1_P,				// out   [TX] TX[1]-P (CML)
	output			DVI_TX2_N,				// out   [TX] TX[2]-N (CML)
	output			DVI_TX2_P,				// out   [TX] TX[2]-P (CML)
	output			DVI_TXC_N,				// out   [TX] TX_CLK-N (CML)
	output			DVI_TXC_P,				// out   [TX] TX_CLK-P (CML)

	input	[7:0]	TX_RED,					// in    [TX] [7:0] red
	input	[7:0]	TX_GRN,					// in    [TX] [7:0] green
	input	[7:0]	TX_BLU,					// in    [TX] [7:0] blue
	input			TX_HS,					// in    [TX] hsync
	input			TX_VS,					// in    [TX] vsync
	input			TX_C0,					// in    [TX] c0
	input			TX_C1,					// in    [TX] c1
	input			TX_C2,					// in    [TX] c2
	input			TX_C3,					// in    [TX] c3
	input			TX_DE,					// in    [TX] de

	input			CLK,					// in    [DVI] clk
	input			CLKx5,					// in    [DVI] clk x5 : dvi ddr
	input			RESET_N					// in    [DVI] #reset
);

//--------------------------------------------------------------
//  local parameter

//--------------------------------------------------------------
//	signal

	reg		[9:0] ch0_enc_r;
	reg		[9:0] ch1_enc_r;
	reg		[9:0] ch2_enc_r;

	wire	[9:0] ch0_enc_w;
	wire	[9:0] ch1_enc_w;
	wire	[9:0] ch2_enc_w;

	reg		tx_r;
	reg		ch_de_r;
	reg		[9:0] ch0_in_r;
	reg		[9:0] ch1_in_r;
	reg		[9:0] ch2_in_r;

	wire	tx_w;
	wire	ch_de_w;
	wire	[9:0] ch0_in_w;
	wire	[9:0] ch1_in_w;
	wire	[9:0] ch2_in_w;

	wire	[9:0] ch0_enc;
	wire	[9:0] ch1_enc;
	wire	[9:0] ch2_enc;

	wire	tx_req;

	reg		[3:0] tx_req_r;
	wire	[3:0] tx_req_w;

	reg		[1:0] tx0_out_r;
	reg		[1:0] tx1_out_r;
	reg		[1:0] tx2_out_r;
	reg		[1:0] tx3_out_r;

	wire	[1:0] tx0_out_w;
	wire	[1:0] tx1_out_w;
	wire	[1:0] tx2_out_w;
	wire	[1:0] tx3_out_w;

	reg		[9:0] tx0_r;
	reg		[9:0] tx1_r;
	reg		[9:0] tx2_r;
	reg		[9:0] tx3_r;

	wire	[9:0] tx0_w;
	wire	[9:0] tx1_w;
	wire	[9:0] tx2_w;
	wire	[9:0] tx3_w;

	wire	tx_ch0_ddr;
	wire	tx_ch1_ddr;
	wire	tx_ch2_ddr;
	wire	tx_ck_ddr;

//--------------------------------------------------------------
//	design

	always @(posedge CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				tx_r <= 1'b0;
				ch0_enc_r[9:0] <= 10'b0;
				ch1_enc_r[9:0] <= 10'b0;
				ch2_enc_r[9:0] <= 10'b0;
				ch_de_r <= 1'b0;
				ch0_in_r[9:0] <= 10'b0;
				ch1_in_r[9:0] <= 10'b0;
				ch2_in_r[9:0] <= 10'b0;
			end
		else
			begin
				tx_r <= tx_w;
				ch0_enc_r[9:0] <= ch0_enc_w[9:0];
				ch1_enc_r[9:0] <= ch1_enc_w[9:0];
				ch2_enc_r[9:0] <= ch2_enc_w[9:0];
				ch_de_r <= ch_de_w;
				ch0_in_r[9:0] <= ch0_in_w[9:0];
				ch1_in_r[9:0] <= ch1_in_w[9:0];
				ch2_in_r[9:0] <= ch2_in_w[9:0];
			end
	end

	assign tx_w=!tx_r;

	assign ch0_enc_w[9:0]=ch0_enc[9:0];
	assign ch1_enc_w[9:0]=ch1_enc[9:0];
	assign ch2_enc_w[9:0]=ch2_enc[9:0];

	// channel assign

	assign ch_de_w=TX_DE;
	assign ch0_in_w[9:0]={TX_VS,TX_HS,TX_BLU[7:0]};
	assign ch1_in_w[9:0]={TX_C1,TX_C0,TX_GRN[7:0]};
	assign ch2_in_w[9:0]={TX_C3,TX_C2,TX_RED[7:0]};

	// tmds 8bit -> 10bit encode

dvi_data_enc enc0(
	.ch_in(ch0_in_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch0_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

dvi_data_enc enc1(
	.ch_in(ch1_in_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch1_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

dvi_data_enc enc2(
	.ch_in(ch2_in_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch2_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

	// x5(ddr clk) sync

	assign tx_req=tx_req_r[3];

	always @(posedge CLKx5 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				tx_req_r[3:0] <= 4'b0;
				tx0_r[9:0] <= 10'b0;
				tx1_r[9:0] <= 10'b0;
				tx2_r[9:0] <= 10'b0;
				tx3_r[9:0] <= 10'b0;
				tx0_out_r[1:0] <= 2'b0;
				tx1_out_r[1:0] <= 2'b0;
				tx2_out_r[1:0] <= 2'b0;
				tx3_out_r[1:0] <= 2'b0;
			end
		else
			begin
				tx_req_r[3:0] <= tx_req_w[3:0];
				tx0_r[9:0] <= tx0_w[9:0];
				tx1_r[9:0] <= tx1_w[9:0];
				tx2_r[9:0] <= tx2_w[9:0];
				tx3_r[9:0] <= tx3_w[9:0];
				tx0_out_r[1:0] <= tx0_out_w[1:0];
				tx1_out_r[1:0] <= tx1_out_w[1:0];
				tx2_out_r[1:0] <= tx2_out_w[1:0];
				tx3_out_r[1:0] <= tx3_out_w[1:0];
			end
	end

	assign tx_req_w[0]=tx_r;
	assign tx_req_w[1]=tx_req_r[0];
	assign tx_req_w[2]=tx_req_r[1];
	assign tx_req_w[3]=(tx_req_r[1:0]==2'b01) | (tx_req_r[1:0]==2'b10) ? 1'b1 : 1'b0;

	assign tx0_w[9:0]=(tx_req==1'b1) ? ch0_enc_r[9:0] : {2'b00,tx0_r[9:2]};
	assign tx1_w[9:0]=(tx_req==1'b1) ? ch1_enc_r[9:0] : {2'b00,tx1_r[9:2]};
	assign tx2_w[9:0]=(tx_req==1'b1) ? ch2_enc_r[9:0] : {2'b00,tx2_r[9:2]};
	assign tx3_w[9:0]=(tx_req==1'b1) ? 10'b0000011111 : {2'b00,tx3_r[9:2]};

	assign tx0_out_w[1:0]=(DVI_TX0==1'b0) ? tx0_r[1:0] : ~tx0_r[1:0];
	assign tx1_out_w[1:0]=(DVI_TX1==1'b0) ? tx1_r[1:0] : ~tx1_r[1:0];
	assign tx2_out_w[1:0]=(DVI_TX2==1'b0) ? tx2_r[1:0] : ~tx2_r[1:0];
	assign tx3_out_w[1:0]=(DVI_TXC==1'b0) ? tx3_r[1:0] : ~tx3_r[1:0];

	// ---- output ----

generate
	if (DEVICE==7)
begin
ODDR DDR_tx0_p(.Q(tx_ch0_ddr),.C(CLKx5),.CE(1'b1),.D1( tx0_out_r[1]),.D2( tx0_out_r[0]),.R(1'b0),.S(1'b0));
ODDR DDR_tx1_p(.Q(tx_ch1_ddr),.C(CLKx5),.CE(1'b1),.D1( tx1_out_r[1]),.D2( tx1_out_r[0]),.R(1'b0),.S(1'b0));
ODDR DDR_tx3_p(.Q(tx_ck_ddr),.C(CLKx5),.CE(1'b1),.D1( tx3_out_r[1]),.D2( tx3_out_r[0]),.R(1'b0),.S(1'b0));
ODDR DDR_tx2_p(.Q(tx_ch2_ddr),.C(CLKx5),.CE(1'b1),.D1( tx2_out_r[1]),.D2( tx2_out_r[0]),.R(1'b0),.S(1'b0));
end
	else
begin
FDDRRSE DDR_tx0_p(.Q(tx_ch0_ddr),.C0(CLKx5),.C1(~CLKx5),.CE(1'b1),.D0( tx0_out_r[1]),.D1( tx0_out_r[0]),.R(1'b0),.S(1'b0));
FDDRRSE DDR_tx1_p(.Q(tx_ch1_ddr),.C0(CLKx5),.C1(~CLKx5),.CE(1'b1),.D0( tx1_out_r[1]),.D1( tx1_out_r[0]),.R(1'b0),.S(1'b0));
FDDRRSE DDR_tx3_p(.Q(tx_ck_ddr),.C0(CLKx5),.C1(~CLKx5),.CE(1'b1),.D0( tx3_out_r[1]),.D1( tx3_out_r[0]),.R(1'b0),.S(1'b0));
FDDRRSE DDR_tx2_p(.Q(tx_ch2_ddr),.C0(CLKx5),.C1(~CLKx5),.CE(1'b1),.D0( tx2_out_r[1]),.D1( tx2_out_r[0]),.R(1'b0),.S(1'b0));
end
endgenerate

generate
	if ((DVI_TX0==0) & (differential==0))
		assign {DVI_TX0_P,DVI_TX0_N}={tx_ch0_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX0==1) & (differential==0))
		assign {DVI_TX0_P,DVI_TX0_N}={!tx_ch0_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX0==0) & (differential==1))
		OBUFDS LVDS_tx0(.O(DVI_TX0_P),.OB(DVI_TX0_N),.I(tx_ch0_ddr));
endgenerate

generate
	if ((DVI_TX0==1) & (differential==1))
		OBUFDS LVDS_tx0(.O(DVI_TX0_N),.OB(DVI_TX0_P),.I(tx_ch0_ddr));
endgenerate

generate
	if ((DVI_TX1==0) & (differential==0))
		assign {DVI_TX1_P,DVI_TX1_N}={tx_ch1_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX1==1) & (differential==0))
		assign {DVI_TX1_P,DVI_TX1_N}={!tx_ch1_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX1==0) & (differential==1))
		OBUFDS LVDS_tx1(.O(DVI_TX1_P),.OB(DVI_TX1_N),.I(tx_ch1_ddr));
endgenerate

generate
	if ((DVI_TX1==1) & (differential==1))
		OBUFDS LVDS_tx1(.O(DVI_TX1_N),.OB(DVI_TX1_P),.I(tx_ch1_ddr));
endgenerate

generate
	if ((DVI_TX2==0) & (differential==0))
		assign {DVI_TX2_P,DVI_TX2_N}={tx_ch2_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX2==1) & (differential==0))
		assign {DVI_TX2_P,DVI_TX2_N}={!tx_ch2_ddr,1'b0};
endgenerate

generate
	if ((DVI_TX2==0) & (differential==1))
		OBUFDS LVDS_tx2(.O(DVI_TX2_P),.OB(DVI_TX2_N),.I(tx_ch2_ddr));
endgenerate

generate
	if ((DVI_TX2==1) & (differential==1))
		OBUFDS LVDS_tx2(.O(DVI_TX2_N),.OB(DVI_TX2_P),.I(tx_ch2_ddr));
endgenerate

generate
	if ((DVI_TXC==0) & (differential==0))
		assign {DVI_TXC_P,DVI_TXC_N}={tx_ck_ddr,1'b0};
endgenerate

generate
	if ((DVI_TXC==1) & (differential==0))
		assign {DVI_TXC_P,DVI_TXC_N}={!tx_ck_ddr,1'b0};
endgenerate

generate
	if ((DVI_TXC==0) & (differential==1))
		OBUFDS LVDS_tx3(.O(DVI_TXC_P),.OB(DVI_TXC_N),.I(tx_ck_ddr));
endgenerate

generate
	if ((DVI_TXC==1) & (differential==1))
		OBUFDS LVDS_tx3(.O(DVI_TXC_N),.OB(DVI_TXC_P),.I(tx_ck_ddr));
endgenerate

endmodule

