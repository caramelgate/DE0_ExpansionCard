//-----------------------------------------------------------------------------
//
//  gen_io.v : 25drv io module
//
//  LICENSE : as-is (same as fpgagen)
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/16 release 0.0  rewrite fpgagen module and connection test
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

module gen_io #(
	parameter	pad_1p=1,
	parameter	pad_2p=0
) (
	input			RST_N,
	input			MCLK,
	input			CLK,

	input	[7:0]	VERSION,

	input			P1_UP,
	input			P1_DOWN,
	input			P1_LEFT,
	input			P1_RIGHT,
	input			P1_A,
	input			P1_B,
	input			P1_C,
	input			P1_START,

	input			P2_UP,
	input			P2_DOWN,
	input			P2_LEFT,
	input			P2_RIGHT,
	input			P2_A,
	input			P2_B,
	input			P2_C,
	input			P2_START,

	input			io_req,
	input	[4:0]	io_addr,
	input			io_wr,
	input	[1:0]	io_be,
	input	[15:0]	io_wdata,
	output	[15:0]	io_rdata,
	output			io_ack
);

	reg 	io_ack_r;

	reg 	[7:0] VERS_r;
	reg 	[7:0] DAT_A_r;
	reg 	[7:0] DAT_B_r;
	reg 	[7:0] DAT_C_r;
	reg 	[7:0] CTL_A_r;
	reg 	[7:0] CTL_B_r;
	reg 	[7:0] CTL_C_r;
	reg 	[7:0] TXD_A_r;
	reg 	[7:0] TXD_B_r;
	reg 	[7:0] TXD_C_r;
	reg 	[7:0] RXD_A_r;
	reg 	[7:0] RXD_B_r;
	reg 	[7:0] RXD_C_r;
	reg 	[7:0] SCT_A_r;
	reg 	[7:0] SCT_B_r;
	reg 	[7:0] SCT_C_r;

	wire	[7:0] DAT_A_w;
	wire	[7:0] DAT_B_w;
	wire	[7:0] DAT_C_w;
	wire	[7:0] CTL_A_w;
	wire	[7:0] CTL_B_w;
	wire	[7:0] CTL_C_w;
	wire	[7:0] TXD_A_w;
	wire	[7:0] TXD_B_w;
	wire	[7:0] TXD_C_w;
	wire	[7:0] RXD_A_w;
	wire	[7:0] RXD_B_w;
	wire	[7:0] RXD_C_w;
	wire	[7:0] SCT_A_w;
	wire	[7:0] SCT_B_w;
	wire	[7:0] SCT_C_w;

	wire	[7:0] wdata;
	reg 	[7:0] rdata_r;
	wire	[7:0] rdata_w;

	assign io_rdata={8'b0,rdata_r[7:0]};
	assign io_ack=(io_req==1'b1) ? io_ack_r : 1'b0;

	assign wdata=(io_be[1]==1'b1) ? io_wdata[15:8] : io_wdata[7:0];

	always @(negedge RST_N or posedge MCLK)
	begin
		if (RST_N==1'b0)
			begin
				io_ack_r <= 1'b0;
				rdata_r <=  8'hff;

				VERS_r <= 8'hA0;
				DAT_A_r <= 8'h7F;
				DAT_B_r <= 8'h7F;
				DAT_C_r <= 8'h7F;
				CTL_A_r <= 8'h00;
				CTL_B_r <= 8'h00;
				CTL_C_r <= 8'h00;
				TXD_A_r <= 8'hFF;
				RXD_A_r <= 8'h00;
				SCT_A_r <= 8'h00;
				TXD_B_r <= 8'hFF;
				RXD_B_r <= 8'h00;
				SCT_B_r <= 8'h00;
				TXD_C_r <= 8'hFF;
				RXD_C_r <= 8'h00;
				SCT_C_r <= 8'h00;
			end
		else
			begin
				io_ack_r <= (io_req==1'b1) ? 1'b1 : 1'b0;
				rdata_r <=  rdata_w;

				VERS_r <= VERSION;
				DAT_A_r <= DAT_A_w;
				DAT_B_r <= DAT_B_w;
				DAT_C_r <= DAT_C_w;
				CTL_A_r <= CTL_A_w;
				CTL_B_r <= CTL_B_w;
				CTL_C_r <= CTL_C_w;
				TXD_A_r <= TXD_A_w;
				RXD_A_r <= RXD_A_w;
				SCT_A_r <= SCT_A_w;
				TXD_B_r <= TXD_B_w;
				RXD_B_r <= RXD_B_w;
				SCT_B_r <= SCT_B_w;
				TXD_C_r <= TXD_C_w;
				RXD_C_r <= RXD_C_w;
				SCT_C_r <= SCT_C_w;
			end
	end

	wire	[7:0] RD_01;
	wire	[7:0] RD_02;
	wire	[7:0] RD_03;

	assign rdata_w[7:0]=
			(io_addr[4:1]==4'h0) ? VERS_r[7:0] :
			(io_addr[4:1]==4'h1) ? RD_01[7:0] :
			(io_addr[4:1]==4'h2) ? RD_02[7:0] :
			(io_addr[4:1]==4'h3) ? RD_03[7:0] :
			(io_addr[4:1]==4'h4) ? CTL_A_r[7:0] :
			(io_addr[4:1]==4'h5) ? CTL_B_r[7:0] :
			(io_addr[4:1]==4'h6) ? CTL_C_r[7:0] :
			(io_addr[4:1]==4'h7) ? TXD_A_r[7:0] :
			(io_addr[4:1]==4'h8) ? RXD_A_r[7:0] :
			(io_addr[4:1]==4'h9) ? SCT_A_r[7:0] :
			(io_addr[4:1]==4'ha) ? TXD_B_r[7:0] :
			(io_addr[4:1]==4'hb) ? RXD_B_r[7:0] :
			(io_addr[4:1]==4'hc) ? SCT_B_r[7:0] :
			(io_addr[4:1]==4'hd) ? TXD_C_r[7:0] :
			(io_addr[4:1]==4'he) ? RXD_C_r[7:0] :
			(io_addr[4:1]==4'hf) ? SCT_C_r[7:0] :
			8'b0;

generate
	if (pad_1p==0)
begin

	assign RD_01[7]=DAT_A_r[7];
	assign RD_01[6]=DAT_A_r[6];
	assign RD_01[5]=1'b1;
	assign RD_01[4]=1'b1;
	assign RD_01[3]=1'b1;
	assign RD_01[2]=1'b1;
	assign RD_01[1]=1'b1;
	assign RD_01[0]=1'b1;

end
	else
begin

	assign RD_01[7]=DAT_A_r[7];
	assign RD_01[6]=DAT_A_r[6];
	assign RD_01[5]=
			(CTL_A_r[5]==1'b0) & (DAT_A_r[6]==1'b0) ? P1_START :
			(CTL_A_r[5]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_C :
			DAT_A_r[5];
	assign RD_01[4]=
			(CTL_A_r[4]==1'b0) & (DAT_A_r[6]==1'b0) ? P1_A :
			(CTL_A_r[4]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_B :
			DAT_A_r[4];
	assign RD_01[3]=
			(CTL_A_r[3]==1'b0) & (DAT_A_r[6]==1'b0) ? 1'b0 :
			(CTL_A_r[3]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_RIGHT :
			DAT_A_r[3];
	assign RD_01[2]=
			(CTL_A_r[2]==1'b0) & (DAT_A_r[6]==1'b0) ? 1'b0 :
			(CTL_A_r[2]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_LEFT :
			DAT_A_r[2];
	assign RD_01[1]=
			(CTL_A_r[1]==1'b0) & (DAT_A_r[6]==1'b0) ? P1_DOWN :
			(CTL_A_r[1]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_DOWN :
			DAT_A_r[1];
	assign RD_01[0]=
			(CTL_A_r[0]==1'b0) & (DAT_A_r[6]==1'b0) ? P1_UP :
			(CTL_A_r[0]==1'b0) & (DAT_A_r[6]==1'b1) ? P1_UP :
			DAT_A_r[0];

end
endgenerate

generate
	if (pad_2p==0)
begin

	assign RD_02[7]=DAT_B_r[7];
	assign RD_02[6]=DAT_B_r[6];
	assign RD_02[5]=1'b1;
	assign RD_02[4]=1'b1;
	assign RD_02[3]=1'b1;
	assign RD_02[2]=1'b1;
	assign RD_02[1]=1'b1;
	assign RD_02[0]=1'b1;

end
	else
begin

	assign RD_02[7]=DAT_B_r[7];
	assign RD_02[6]=DAT_B_r[6];
	assign RD_02[5]=
			(CTL_B_r[5]==1'b0) & (DAT_B_r[6]==1'b0) ? P2_START :
			(CTL_B_r[5]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_C :
			DAT_B_r[5];
	assign RD_02[4]=
			(CTL_B_r[4]==1'b0) & (DAT_B_r[6]==1'b0) ? P2_A :
			(CTL_B_r[4]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_B :
			DAT_B_r[4];
	assign RD_02[3]=
			(CTL_B_r[3]==1'b0) & (DAT_B_r[6]==1'b0) ? 1'b0 :
			(CTL_B_r[3]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_RIGHT :
			DAT_B_r[3];
	assign RD_02[2]=
			(CTL_B_r[2]==1'b0) & (DAT_B_r[6]==1'b0) ? 1'b0 :
			(CTL_B_r[2]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_LEFT :
			DAT_B_r[2];
	assign RD_02[1]=
			(CTL_B_r[1]==1'b0) & (DAT_B_r[6]==1'b0) ? P2_DOWN :
			(CTL_B_r[1]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_DOWN :
			DAT_B_r[1];
	assign RD_02[0]=
			(CTL_B_r[0]==1'b0) & (DAT_B_r[6]==1'b0) ? P2_UP :
			(CTL_B_r[0]==1'b0) & (DAT_B_r[6]==1'b1) ? P2_UP :
			DAT_B_r[0];

end
endgenerate

	assign RD_03[7:0]=DAT_C_r[7:0];

	wire	io_wreq;

	assign io_wreq=(io_wr==1'b1) & (io_req==1'b1) & (io_ack_r==1'b0) ? 1'b1 : 1'b0;

	assign DAT_A_w[7]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) ? wdata[7] : DAT_A_r[7];
	assign DAT_A_w[6]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[6]==1'b1) ? wdata[6] : DAT_A_r[6];
	assign DAT_A_w[5]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[5]==1'b1) ? wdata[5] : DAT_A_r[5];
	assign DAT_A_w[4]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[4]==1'b1) ? wdata[4] : DAT_A_r[4];
	assign DAT_A_w[3]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[3]==1'b1) ? wdata[3] : DAT_A_r[3];
	assign DAT_A_w[2]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[2]==1'b1) ? wdata[2] : DAT_A_r[2];
	assign DAT_A_w[1]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[1]==1'b1) ? wdata[1] : DAT_A_r[1];
	assign DAT_A_w[0]=(io_addr[4:1]==4'h1) & (io_wreq==1'b1) & (CTL_A_r[0]==1'b1) ? wdata[0] : DAT_A_r[0];

	assign DAT_B_w[7]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) ? wdata[7] : DAT_B_r[7];
	assign DAT_B_w[6]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[6]==1'b1) ? wdata[6] : DAT_B_r[6];
	assign DAT_B_w[5]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[5]==1'b1) ? wdata[5] : DAT_B_r[5];
	assign DAT_B_w[4]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[4]==1'b1) ? wdata[4] : DAT_B_r[4];
	assign DAT_B_w[3]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[3]==1'b1) ? wdata[3] : DAT_B_r[3];
	assign DAT_B_w[2]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[2]==1'b1) ? wdata[2] : DAT_B_r[2];
	assign DAT_B_w[1]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[1]==1'b1) ? wdata[1] : DAT_B_r[1];
	assign DAT_B_w[0]=(io_addr[4:1]==4'h2) & (io_wreq==1'b1) & (CTL_B_r[0]==1'b1) ? wdata[0] : DAT_B_r[0];

	assign DAT_C_w[7]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) ? wdata[7] : DAT_C_r[7];
	assign DAT_C_w[6]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[6]==1'b1) ? wdata[6] : DAT_C_r[6];
	assign DAT_C_w[5]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[5]==1'b1) ? wdata[5] : DAT_C_r[5];
	assign DAT_C_w[4]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[4]==1'b1) ? wdata[4] : DAT_C_r[4];
	assign DAT_C_w[3]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[3]==1'b1) ? wdata[3] : DAT_C_r[3];
	assign DAT_C_w[2]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[2]==1'b1) ? wdata[2] : DAT_C_r[2];
	assign DAT_C_w[1]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[1]==1'b1) ? wdata[1] : DAT_C_r[1];
	assign DAT_C_w[0]=(io_addr[4:1]==4'h3) & (io_wreq==1'b1) & (CTL_C_r[0]==1'b1) ? wdata[0] : DAT_C_r[0];

	assign CTL_A_w=(io_addr[4:1]==4'h4) & (io_wreq==1'b1) ? wdata : CTL_A_r;
	assign CTL_B_w=(io_addr[4:1]==4'h5) & (io_wreq==1'b1) ? wdata : CTL_B_r;
	assign CTL_C_w=(io_addr[4:1]==4'h6) & (io_wreq==1'b1) ? wdata : CTL_C_r;
	assign TXD_A_w=(io_addr[4:1]==4'h7) & (io_wreq==1'b1) ? wdata : TXD_A_r;
	assign RXD_A_w=(io_addr[4:1]==4'h8) & (io_wreq==1'b1) ? wdata : RXD_A_r;
	assign SCT_A_w=(io_addr[4:1]==4'h9) & (io_wreq==1'b1) ? wdata : SCT_A_r;
	assign TXD_B_w=(io_addr[4:1]==4'ha) & (io_wreq==1'b1) ? wdata : TXD_B_r;
	assign RXD_B_w=(io_addr[4:1]==4'hb) & (io_wreq==1'b1) ? wdata : RXD_B_r;
	assign SCT_B_w=(io_addr[4:1]==4'hc) & (io_wreq==1'b1) ? wdata : SCT_B_r;
	assign TXD_C_w=(io_addr[4:1]==4'hd) & (io_wreq==1'b1) ? wdata : TXD_C_r;
	assign RXD_C_w=(io_addr[4:1]==4'he) & (io_wreq==1'b1) ? wdata : RXD_C_r;
	assign SCT_C_w=(io_addr[4:1]==4'hf) & (io_wreq==1'b1) ? wdata : SCT_C_r;

endmodule
