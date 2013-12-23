//------------------------------------------------------------------------------
//
//  sp3a_xy64.v : 64bit bus connection module
//
//  LICENSE : "as-is"
//  copyright (C) 2000, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2000        release 1.0  at one's own risk
//  2009/mar/01              bus width adjust
//
//------------------------------------------------------------------------------

module sp3a_xy64(
	iy_addr,			// out   [I-Y] [31:0] addr output
	iy_rdata,			// in    [I-Y] [63:0] data input
	iy_wdata,			// out   [I-Y] [63:0] data output
	iy_be,				// out   [I-Y] [7:0] be
	iy_rd,				// out   [I-Y] read/#write
	iy_busy,			// in    [I-Y] busy/#ready
	iy_req,				// out   [I-Y] req
	iy_ack,				// in    [I-Y] ack
	iy_err,				// in    [I-Y] exception error
	iy_clk,				// in    [I-Y] y-clk

	ix_addr,			// in    [I-X] [31:0] addr input
	ix_rdata,			// out   [I-X] [63:0] data output
	ix_wdata,			// in    [I-X] [63:0] data input
	ix_be,				// in    [I-X] [7:0] be
	ix_rd,				// in    [I-X] read/#write
	ix_busy,			// out   [I-X] busy/#ready
	ix_req,				// in    [I-X] req
	ix_ack,				// out   [I-X] ack
	ix_err,				// out   [I-X] exception error
	ix_rst_n,			// in    [I-X] #reset
	ix_clk				// in    [I-X] x-clk
);

//--------------------------------------------------------------
//  port

	output	[31:0] iy_addr;
	input	[63:0] iy_rdata;
	output	[63:0] iy_wdata;
	output	[7:0] iy_be;
	output	iy_rd;
	input	iy_busy;
	output	iy_req;
	input	iy_ack;
	input	iy_err;
	input	iy_clk;

	input	[31:0] ix_addr;
	output	[63:0] ix_rdata;
	input	[63:0] ix_wdata;
	input	[7:0] ix_be;
	input	ix_rd;
	output	ix_busy;
	input	ix_req;
	output	ix_ack;
	output	ix_err;

	input	ix_rst_n;
	input	ix_clk;

//--------------------------------------------------------------
//  constant

	// ---- connect state ----

	parameter	ixck_iy_st00=1'b0;	// target idle
	parameter	ixck_iy_st01=1'b1;	// target busy

//--------------------------------------------------------------
//  signal

	// ---- ix - iy interconnect ----

	wire	ixck_iy_busy;
	wire	ixck_iy_ack;

	wire	[31:0] ixck_iy_addr_w;
	reg		[31:0] ixck_iy_addr_r;

	wire	[63:0] ixck_iy_wdata_out_w;
	reg		[63:0] ixck_iy_wdata_out_r;

	wire	[7:0] ixck_iy_be_w;
	reg		[7:0] ixck_iy_be_r;

	wire	ixck_iy_rd_w;
	reg		ixck_iy_rd_r;

	wire	ixck_iy_req_w;
	reg		ixck_iy_req_r;

	wire	[2:0] ixck_iy_ack_w;
	reg		[2:0] ixck_iy_ack_r;

	wire	ixck_iy_state_w;
	reg		ixck_iy_state_r;

	wire	[2:0] ixck_iy_err_w;
	reg		[2:0] ixck_iy_err_r;

	wire	[2:0] iyck_iy_req_w;
	reg		[2:0] iyck_iy_req_r;

	wire	[63:0] iyck_iy_wdata_in_w;
	reg		[63:0] iyck_iy_wdata_in_r;

	wire	[2:0] iyck_iy_err_w;
	reg		[2:0] iyck_iy_err_r;

//--------------------------------------------------------------
//  design

	assign ix_rdata[63:0]=iyck_iy_wdata_in_r[63:0];
	assign ix_busy=ixck_iy_busy;
	assign ix_ack=ixck_iy_ack;
	assign ix_err=ixck_iy_err_r[2];

	// ---- ix - iy interconnect ----

	assign iy_addr[31:0]=ixck_iy_addr_r[31:0];
	assign iy_wdata[63:0]=ixck_iy_wdata_out_r[63:0];
	assign iy_be[7:0]=ixck_iy_be_r[7:0];
	assign iy_rd=ixck_iy_rd_r;
	assign iy_req=iyck_iy_req_r[2];

	// ---- ----

	assign ixck_iy_busy=(ixck_iy_state_r==ixck_iy_st00) ? 1'b0 : 1'b1;
	assign ixck_iy_ack=
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b0) & (ix_rd==1'b0) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b0) & (ix_rd==1'b1) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b1) & (ix_rd==1'b0) ? 1'b1 :
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b1) & (ix_rd==1'b1) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b0) & (ixck_iy_rd_r==1'b0) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b1) & (ixck_iy_rd_r==1'b0) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b0) & (ixck_iy_rd_r==1'b1) ? 1'b0 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b1) & (ixck_iy_rd_r==1'b1) ? 1'b1 :
			1'b0;

	always @(posedge ix_clk or negedge ix_rst_n)
	begin
		if (ix_rst_n==1'b0)
			begin
				ixck_iy_state_r <= ixck_iy_st00;
				ixck_iy_wdata_out_r[63:0] <= 64'h00000000;
				ixck_iy_be_r[7:0] <= 8'h0;
				ixck_iy_addr_r[31:0] <= 64'h00000000;
				ixck_iy_rd_r <= 1'b0;
				ixck_iy_req_r <= 1'b0;
				ixck_iy_ack_r[0] <= 1'b0;
				ixck_iy_ack_r[1] <= 1'b0;
				ixck_iy_ack_r[2] <= 1'b0;
				ixck_iy_err_r[2:0] <= 3'b111;
			end
		else
			begin
				ixck_iy_state_r <= ixck_iy_state_w;
				ixck_iy_wdata_out_r[63:0] <= ixck_iy_wdata_out_w[63:0];
				ixck_iy_be_r[7:0] <= ixck_iy_be_w[7:0];
				ixck_iy_addr_r[31:0] <= ixck_iy_addr_w[31:0];
				ixck_iy_rd_r <= ixck_iy_rd_w;
				ixck_iy_req_r <= ixck_iy_req_w;
				ixck_iy_ack_r[0] <= ixck_iy_ack_w[0];
				ixck_iy_ack_r[1] <= ixck_iy_ack_w[1];
				ixck_iy_ack_r[2] <= ixck_iy_ack_w[2];
				ixck_iy_err_r[2:0] <= ixck_iy_err_w[2:0];
			end
	end

	always @(posedge iy_clk or negedge ix_rst_n)
	begin
		if (ix_rst_n==1'b0)
			begin
				iyck_iy_req_r[0] <= 1'b0;
				iyck_iy_req_r[1] <= 1'b0;
				iyck_iy_req_r[2] <= 1'b0;
				iyck_iy_wdata_in_r[63:0] <= 64'h00000000;
				iyck_iy_err_r[2:0] <= 3'b111;
			end
		else
			begin
				iyck_iy_req_r[0] <= iyck_iy_req_w[0];
				iyck_iy_req_r[1] <= iyck_iy_req_w[1];
				iyck_iy_req_r[2] <= iyck_iy_req_w[2];
				iyck_iy_wdata_in_r[63:0] <= iyck_iy_wdata_in_w[63:0];
				iyck_iy_err_r[2:0] <= iyck_iy_err_w[2:0];
			end
	end

	assign ixck_iy_state_w=
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b0) ? ixck_iy_st00 :
			(ixck_iy_state_r==ixck_iy_st00) & (ix_req==1'b1) ? ixck_iy_st01 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b0) ? ixck_iy_st01 :
			(ixck_iy_state_r==ixck_iy_st01) & (ixck_iy_ack_r[2]==1'b1) ? ixck_iy_st00 :
			ixck_iy_st00;

	assign ixck_iy_wdata_out_w[63:0]=
			(ixck_iy_busy==1'b1) ? ixck_iy_wdata_out_r[63:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b1) & (ix_rd==1'b1) ? ixck_iy_wdata_out_r[63:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b1) & (ix_rd==1'b0) ? ix_wdata[63:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b0) ? ixck_iy_wdata_out_r[63:0] :
			64'h00000000;

	assign ixck_iy_be_w[7:0]=
			(ixck_iy_busy==1'b1) ? ixck_iy_be_r[7:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b1) ? ix_be[7:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b0) ? 8'h0 :
			8'h0;

	assign ixck_iy_addr_w[31:0]=
			(ixck_iy_busy==1'b1) ? ixck_iy_addr_r[31:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b1) ? ix_addr[31:0] :
			(ixck_iy_busy==1'b0) & (ix_req==1'b0) ? 64'h00000000 :
			64'h00000000;

	assign ixck_iy_rd_w=
			(ixck_iy_busy==1'b1) ? ixck_iy_rd_r :
			(ixck_iy_busy==1'b0) & (ix_req==1'b1) ? ix_rd :
			(ixck_iy_busy==1'b0) & (ix_req==1'b0) ? 1'b0 :
			1'b0;

	assign ixck_iy_req_w=
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b000) ? 1'b0 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b001) ? 1'b1 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b010) ? 1'b1 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b011) ? 1'b0 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b100) ? 1'b0 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b101) ? 1'b0 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b110) ? 1'b1 :
			({ixck_iy_busy,ixck_iy_req_r,ix_req}==3'b111) ? 1'b1 :
			1'b0;

	assign ixck_iy_ack_w[0]=iyck_iy_req_r[1];
	assign ixck_iy_ack_w[1]=ixck_iy_ack_r[0];
	assign ixck_iy_ack_w[2]=
			(ixck_iy_ack_r[1:0]==2'b01) ? 1'b1 :
			(ixck_iy_ack_r[1:0]==2'b10) ? 1'b1 :
			(ixck_iy_ack_r[1:0]==2'b00) ? 1'b0 :
			(ixck_iy_ack_r[1:0]==2'b11) ? 1'b0 :
			1'b0;

	assign ixck_iy_err_w[0]=iyck_iy_err_r[2];
	assign ixck_iy_err_w[1]=ixck_iy_err_r[0];
	assign ixck_iy_err_w[2]=
			(ixck_iy_err_r[1:0]==2'b00) ? 1'b0 :
			(ixck_iy_err_r[1:0]==2'b01) ? 1'b1 :
			(ixck_iy_err_r[1:0]==2'b11) ? 1'b0 :
			(ixck_iy_err_r[1:0]==2'b10) ? 1'b1 :
			1'b0;

	assign iyck_iy_req_w[0]=ixck_iy_req_r;
	assign iyck_iy_req_w[2:1]=
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0000) ? 2'b00 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0010) ? 2'b10 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0110) ? 2'b01 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0100) ? 2'b11 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0001) ? 2'b00 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0011) ? 2'b01 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0111) ? 2'b01 :
			({iy_err,iyck_iy_req_r[1:0],iy_ack}==4'b0101) ? 2'b00 :
			(iy_err==1'b1) ? {1'b0,iyck_iy_req_r[0]} :
			2'b00;

	assign iyck_iy_wdata_in_w[63:0]=
			({ixck_iy_rd_r,iy_ack}==2'b00) ? iyck_iy_wdata_in_r[63:0] :
			({ixck_iy_rd_r,iy_ack}==2'b01) ? iyck_iy_wdata_in_r[63:0] :
			({ixck_iy_rd_r,iy_ack}==2'b10) ? iyck_iy_wdata_in_r[63:0] :
			({ixck_iy_rd_r,iy_ack}==2'b11) ? iy_rdata[63:0] :
			64'h00000000;

	assign iyck_iy_err_w[0]=ixck_iy_err_r[1];
	assign iyck_iy_err_w[1]=iyck_iy_err_r[0];

	assign iyck_iy_err_w[2]=
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b000) ? 1'b0 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b100) ? 1'b1 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b110) ? 1'b1 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b010) ? 1'b0 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b001) ? 1'b1 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b101) ? 1'b1 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b111) ? 1'b0 :
			({iyck_iy_err_r[2],iyck_iy_err_r[1],iy_err}==3'b011) ? 1'b0 :
			1'b0;

endmodule

