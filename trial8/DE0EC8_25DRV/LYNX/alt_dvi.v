//------------------------------------------------------------------------------
//
//  alt_dvi.v : altera cyclone3 dvi output module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2009/may/28 release 0.0  cutout dvi-out module
//
//------------------------------------------------------------------------------

module alt_dvi #(
	parameter	DVI_TX0=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TX1=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TX2=0,			// polarity 0=normal / 1=invert
	parameter	DVI_TXC=0,			// polarity 0=normal / 1=invert
	parameter	differential=1		// select diff(lvds)=1 , single_end=0
) (
	output			DVI_TX0_P,			// out   [DVI] lvds tx0-p : dvi tx0 out
	output			DVI_TX1_P,			// out   [DVI] lvds tx1-p : dvi tx1 out
	output			DVI_TX2_P,			// out   [DVI] lvds tx2-p : dvi tx2 out
	output			DVI_TXC_P,			// out   [DVI] lvds tx3-p : dvi clk out

	input	[7:0]	TX_RED,				// in    [DVI] [7:0] red
	input	[7:0]	TX_GRN,				// in    [DVI] [7:0] green
	input	[7:0]	TX_BLU,				// in    [DVI] [7:0] red
	input			TX_HS,				// in    [DVI] hsync
	input			TX_VS,				// in    [DVI] vsync
	input			TX_C0,				// in    [DVI] c0
	input			TX_C1,				// in    [DVI] c1
	input			TX_C2,				// in    [DVI] c2
	input			TX_C3,				// in    [DVI] c3
	input			TX_DE,				// in    [DVI] de/#blank

	input			CLK,				// in    [DVI] clk
	input			CLKx5,				// in    [DVI] clk x5 : dvi ddr
	input			RESET_N				// in    [DVI] #reset
);

//--------------------------------------------------------------
//  local parameter

//--------------------------------------------------------------
//  signal

//--------------------------------------------------------------
//  design

	reg		[9:0] ch0_enc_r;
	reg		[9:0] ch1_enc_r;
	reg		[9:0] ch2_enc_r;

	wire	[9:0] ch0_enc_w;
	wire	[9:0] ch1_enc_w;
	wire	[9:0] ch2_enc_w;

	reg		tx_r;
	reg		ch_de_r;
	reg		[9:0] dvi_ch0_r;
	reg		[9:0] dvi_ch1_r;
	reg		[9:0] dvi_ch2_r;

	wire	tx_w;
	wire	ch_de_w;
	wire	[9:0] dvi_ch0_w;
	wire	[9:0] dvi_ch1_w;
	wire	[9:0] dvi_ch2_w;

	wire	[9:0] ch0_enc;
	wire	[9:0] ch1_enc;
	wire	[9:0] ch2_enc;

	wire	[9:0] ch0_enc_out;
	wire	[9:0] ch1_enc_out;
	wire	[9:0] ch2_enc_out;

	always @(posedge CLK or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				tx_r <= 1'b0;
				ch0_enc_r[9:0] <= 10'b0;
				ch1_enc_r[9:0] <= 10'b0;
				ch2_enc_r[9:0] <= 10'b0;
				ch_de_r <= 1'b0;
				dvi_ch0_r[9:0] <= 10'b0;
				dvi_ch1_r[9:0] <= 10'b0;
				dvi_ch2_r[9:0] <= 10'b0;
			end
		else
			begin
				tx_r <= tx_w;
				ch0_enc_r[9:0] <= ch0_enc_w[9:0];
				ch1_enc_r[9:0] <= ch1_enc_w[9:0];
				ch2_enc_r[9:0] <= ch2_enc_w[9:0];
				ch_de_r <= ch_de_w;
				dvi_ch0_r[9:0] <= dvi_ch0_w[9:0];
				dvi_ch1_r[9:0] <= dvi_ch1_w[9:0];
				dvi_ch2_r[9:0] <= dvi_ch2_w[9:0];
			end
	end

	assign tx_w=!tx_r;

	assign ch0_enc_w[9:0]=ch0_enc[9:0];
	assign ch1_enc_w[9:0]=ch1_enc[9:0];
	assign ch2_enc_w[9:0]=ch2_enc[9:0];

	assign ch_de_w=TX_DE;
	assign dvi_ch0_w[9:0]={TX_VS,TX_HS,TX_BLU[7:0]};
	assign dvi_ch1_w[9:0]={TX_C1,TX_C0,TX_GRN[7:0]};
	assign dvi_ch2_w[9:0]={TX_C3,TX_C2,TX_RED[7:0]};

dvi_data_enc enc0(
	.ch_in(dvi_ch0_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch0_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

dvi_data_enc enc1(
	.ch_in(dvi_ch1_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch1_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

dvi_data_enc enc2(
	.ch_in(dvi_ch2_r[9:0]),		// in    [ENC] [9:0]
	.ch_de(ch_de_r),			// in    [ENC] 
	.ch_out(ch2_enc[9:0]),		// out   [ENC] [9:0]

	.rst_n(RESET_N),			// in    [ENC] 
	.clk(CLK)					// in    [ENC] 
);

	assign ch0_enc_out[9:5]={ch0_enc[0],ch0_enc[1],ch0_enc[2],ch0_enc[3],ch0_enc[4]};
	assign ch0_enc_out[4:0]={ch0_enc[5],ch0_enc[6],ch0_enc[7],ch0_enc[8],ch0_enc[9]};
	assign ch1_enc_out[9:5]={ch1_enc[0],ch1_enc[1],ch1_enc[2],ch1_enc[3],ch1_enc[4]};
	assign ch1_enc_out[4:0]={ch1_enc[5],ch1_enc[6],ch1_enc[7],ch1_enc[8],ch1_enc[9]};
	assign ch2_enc_out[9:5]={ch2_enc[0],ch2_enc[1],ch2_enc[2],ch2_enc[3],ch2_enc[4]};
	assign ch2_enc_out[4:0]={ch2_enc[5],ch2_enc[6],ch2_enc[7],ch2_enc[8],ch2_enc[9]};

generate
	if (differential==1)
begin

alt_dvi_out_x4_raw dvi_out_x4_raw(
	.tx_in({10'b1111100000,ch2_enc_out[9:0],ch1_enc_out[9:0],ch0_enc_out[9:0]}),
	.tx_inclock(CLKx5),
	.tx_syncclock(CLK),
	.tx_out({DVI_TXC_P,DVI_TX2_P,DVI_TX1_P,DVI_TX0_P})
);

end
	else
begin

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

//alt_altddio_out DDR_tx0_p(.aclr(1'b0),.datain_h( tx0_out_r[1]),.datain_l( tx0_out_r[0]),.outclock(CLKx5),.dataout(tx_ch0_ddr));
//alt_altddio_out DDR_tx1_p(.aclr(1'b0),.datain_h( tx1_out_r[1]),.datain_l( tx1_out_r[0]),.outclock(CLKx5),.dataout(tx_ch1_ddr));
//alt_altddio_out DDR_tx2_p(.aclr(1'b0),.datain_h( tx2_out_r[1]),.datain_l( tx2_out_r[0]),.outclock(CLKx5),.dataout(tx_ch2_ddr));
//alt_altddio_out DDR_tx3_p(.aclr(1'b0),.datain_h( tx3_out_r[1]),.datain_l( tx3_out_r[0]),.outclock(CLKx5),.dataout(tx_ck_ddr));

alt_altddio_out DDR_tx0_p(.aclr(1'b0),.datain_h( tx0_out_r[0]),.datain_l( tx0_out_r[1]),.outclock(CLKx5),.dataout(tx_ch0_ddr));
alt_altddio_out DDR_tx1_p(.aclr(1'b0),.datain_h( tx1_out_r[0]),.datain_l( tx1_out_r[1]),.outclock(CLKx5),.dataout(tx_ch1_ddr));
alt_altddio_out DDR_tx2_p(.aclr(1'b0),.datain_h( tx2_out_r[0]),.datain_l( tx2_out_r[1]),.outclock(CLKx5),.dataout(tx_ch2_ddr));
alt_altddio_out DDR_tx3_p(.aclr(1'b0),.datain_h( tx3_out_r[0]),.datain_l( tx3_out_r[1]),.outclock(CLKx5),.dataout(tx_ck_ddr));

	assign DVI_TX0_P=tx_ch0_ddr;
	assign DVI_TX1_P=tx_ch1_ddr;
	assign DVI_TX2_P=tx_ch2_ddr;
	assign DVI_TXC_P=tx_ck_ddr;

end
endgenerate

endmodule
