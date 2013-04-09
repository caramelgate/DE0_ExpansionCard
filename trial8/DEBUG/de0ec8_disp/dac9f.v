//------------------------------------------------------------------------------
//
//  dac9f.v : dac type9f module
//
//  LICENSE : "as-is"
//  Copyright (C) 2003-2008,2013 TakeshiNagashima nagashima@caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2004/mar/25 release 0.0  : connection test
//
//------------------------------------------------------------------------------
//
//	da : pwm + delta-sigma trial 1.2
//

module dac9f(
	output			dac_lch_out,		// out   [DAC] dac left out
	output			dac_rch_out,		// out   [DAC] dac right out

	input	[19:0]	dac_lch,			// in    [DAC] [19:0] dac left data
	input	[19:0]	dac_rch,			// in    [DAC] [19:0] dac right data
	input			dac_req,			// in    [DAC] dac req

	input			dac_rst_n,			// in    [DAC] #reset
	input			dac_clk				// in    [DAC] clock (48KHz*512)
);

//--------------------------------------------------------------
//  constant


//--------------------------------------------------------------
//  signal

	// ---- ----

	wire	[23:0] dac_lch_w,dac_rch_w;
	reg		[23:0] dac_lch_r,dac_rch_r;
	wire	dac_req_w;
	reg		dac_req_r;

	// ---- da ----

	wire	da_rch_out_w,da_lch_out_w;
	reg		da_rch_out_r,da_lch_out_r;

//--------------------------------------------------------------
//  design

	// ---- connect ----

	assign dac_lch_out=da_lch_out_r;
	assign dac_rch_out=da_rch_out_r;

	// ---- ----

	always @(posedge dac_clk or negedge dac_rst_n)
	begin
		if (dac_rst_n==1'b0)
			begin
				dac_lch_r[23:0] <= 24'h000000;
				dac_rch_r[23:0] <= 24'h000000;
				dac_req_r <= 1'b0;
			end
		else
			begin
				dac_lch_r[23:0] <= dac_lch_w[23:0];
				dac_rch_r[23:0] <= dac_rch_w[23:0];
				dac_req_r <= dac_req_w;
			end
	end

	wire	[23:0] dac_lch_tmp,dac_rch_tmp;

	assign dac_lch_tmp[23:0]={dac_lch[19],dac_lch[19],dac_lch[19],dac_lch[19:0],1'b0};
	assign dac_rch_tmp[23:0]={dac_rch[19],dac_rch[19],dac_rch[19],dac_rch[19:0],1'b0};

//	assign dac_lch_w[23:0]=(dac_req==1'b1) ? {dac_lch_tmp[22:0],1'b0}+{dac_lch_tmp[23:0]} : dac_lch_r[23:0];
//	assign dac_rch_w[23:0]=(dac_req==1'b1) ? {dac_rch_tmp[22:0],1'b0}+{dac_rch_tmp[23:0]} : dac_rch_r[23:0];

	assign dac_lch_w[23:0]=(dac_req==1'b1) ? {dac_lch_tmp[22:0],1'b0} : dac_lch_r[23:0];
	assign dac_rch_w[23:0]=(dac_req==1'b1) ? {dac_rch_tmp[22:0],1'b0} : dac_rch_r[23:0];

	assign dac_req_w=dac_req;

	// ---- da ----

	wire	[2:0] da_lch_pwm_w,da_rch_pwm_w;
	reg		[2:0] da_lch_pwm_r,da_rch_pwm_r;

	wire	[27:0] da_lch_work0_w,da_rch_work0_w;
	wire	[27:0] da_lch_work1_w,da_rch_work1_w;
	reg		[27:0] da_lch_work0_r,da_rch_work0_r;
	reg		[27:0] da_lch_work1_r,da_rch_work1_r;

	wire	[3:0] da_count_w;
	reg		[3:0] da_count_r;

	wire	[1:0] da_req_w;
	reg		[1:0] da_req_r;

	always @(posedge dac_clk or negedge dac_rst_n)
	begin
		if (dac_rst_n==1'b0)
			begin
				da_lch_out_r <= 1'b0;
				da_rch_out_r <= 1'b0;

				da_lch_pwm_r[2:0] <= 3'b000;
				da_rch_pwm_r[2:0] <= 3'b000;

				da_count_r[3:0] <= 4'h0;

				da_req_r[1:0] <= 2'b00;

				da_lch_work0_r[27:0] <= 28'h0000000;
				da_rch_work0_r[27:0] <= 28'h0000000;
				da_lch_work1_r[27:0] <= 28'h0000000;
				da_rch_work1_r[27:0] <= 28'h0000000;
			end
		else
			begin
				da_lch_out_r <= da_lch_out_w;
				da_rch_out_r <= da_rch_out_w;

				da_lch_pwm_r[2:0] <= da_lch_pwm_w[2:0];
				da_rch_pwm_r[2:0] <= da_rch_pwm_w[2:0];

				da_count_r[3:0] <= da_count_w[3:0];

				da_req_r[1:0] <= da_req_w[1:0];

				da_lch_work0_r[27:0] <= da_lch_work0_w[27:0];
				da_rch_work0_r[27:0] <= da_rch_work0_w[27:0];
				da_lch_work1_r[27:0] <= da_lch_work1_w[27:0];
				da_rch_work1_r[27:0] <= da_rch_work1_w[27:0];
			end
	end

	wire	[3:0] da_lch_pwm_tmp,da_rch_pwm_tmp;

	assign da_lch_out_w=
			(da_req_r[0]==1'b1) ? 1'b1 :
			(da_req_r[0]==1'b0) & (da_lch_pwm_r[2:1]==2'b00) ? 1'b0 :
			(da_req_r[0]==1'b0) & (da_lch_pwm_r[2:1]!=2'b00) ? da_lch_out_r :
			1'b0;
	assign da_rch_out_w=
			(da_req_r[0]==1'b1) ? 1'b1 :
			(da_req_r[0]==1'b0) & (da_rch_pwm_r[2:1]==2'b00) ? 1'b0 :
			(da_req_r[0]==1'b0) & (da_rch_pwm_r[2:1]!=2'b00) ? da_rch_out_r :
			1'b0;

	assign da_lch_pwm_tmp[3:0]=
			(da_lch_work0_r[27:26]==2'b01)    ? 4'b0111 :
			(da_lch_work0_r[27:25]==3'b001)   ? 4'b0111 :
			(da_lch_work0_r[27:23]==5'b00011) ? 4'b0111 :
			(da_lch_work0_r[27:23]==5'b00010) ? 4'b0110 :
			(da_lch_work0_r[27:23]==5'b00001) ? 4'b0101 :
			(da_lch_work0_r[27:23]==5'b00000) ? 4'b0100 :
			(da_lch_work0_r[27:23]==5'b11111) ? 4'b0100 :
			(da_lch_work0_r[27:23]==5'b11110) ? 4'b0011 :
			(da_lch_work0_r[27:23]==5'b11101) ? 4'b0010 :
			(da_lch_work0_r[27:23]==5'b11100) ? 4'b0001 :
			(da_lch_work0_r[27:25]==3'b110)   ? 4'b0001 :
			(da_lch_work0_r[27:26]==2'b10)    ? 4'b0001 :
			4'b0000;

	assign da_rch_pwm_tmp[3:0]=
			(da_rch_work0_r[27:26]==2'b01)    ? 4'b0111 :
			(da_rch_work0_r[27:25]==3'b001)   ? 4'b0111 :
			(da_rch_work0_r[27:23]==5'b00011) ? 4'b0111 :
			(da_rch_work0_r[27:23]==5'b00010) ? 4'b0110 :
			(da_rch_work0_r[27:23]==5'b00001) ? 4'b0101 :
			(da_rch_work0_r[27:23]==5'b00000) ? 4'b0100 :
			(da_rch_work0_r[27:23]==5'b11111) ? 4'b0100 :
			(da_rch_work0_r[27:23]==5'b11110) ? 4'b0011 :
			(da_rch_work0_r[27:23]==5'b11101) ? 4'b0010 :
			(da_rch_work0_r[27:23]==5'b11100) ? 4'b0001 :
			(da_rch_work0_r[27:25]==3'b110)   ? 4'b0001 :
			(da_rch_work0_r[27:26]==2'b10)    ? 4'b0001 :
			4'b0000;

	assign da_lch_pwm_w[2:0]=(da_req_r[0]==1'b1) ? da_lch_pwm_tmp[2:0] : da_lch_pwm_r[2:0]-3'b001;
	assign da_rch_pwm_w[2:0]=(da_req_r[0]==1'b1) ? da_rch_pwm_tmp[2:0] : da_rch_pwm_r[2:0]-3'b001;

	assign da_count_w[3:0]=da_count_r[3:0]+4'h1;

	assign da_req_w[0]=(da_count_r[2:0]==3'b111) ? 1'b1 : 1'b0;
	assign da_req_w[1]=da_req_r[0];

	wire	[27:0] da_lch_work0_tmp,da_rch_work0_tmp;

	wire	[27:0] da_lch_work0_add0,da_rch_work0_add0;
	wire	[27:0] da_lch_work0_add1,da_rch_work0_add1;
	wire	[27:0] da_lch_work0_add2,da_rch_work0_add2;
	wire	[27:0] da_lch_work0_add3,da_rch_work0_add3;
	wire	[27:0] da_lch_work0_add4,da_rch_work0_add4;
	wire	[27:0] da_lch_work0_add5,da_rch_work0_add5;

	assign da_lch_work0_add0[27:0]={dac_lch_r[23],dac_lch_r[23:1],4'h0};
	assign da_rch_work0_add0[27:0]={dac_rch_r[23],dac_rch_r[23:1],4'h0};

	assign da_lch_work0_add1[27:0]=
			(da_lch_work0_r[27]==1'b0) & (da_lch_work0_r[26]==1'b1) ? {5'b00111,da_lch_work0_r[22:0]} :
			(da_lch_work0_r[27]==1'b0) & (da_lch_work0_r[26]==1'b0) ? da_lch_work0_r[27:0] :
			(da_lch_work0_r[27]==1'b1) & (da_lch_work0_r[26]==1'b1) ? da_lch_work0_r[27:0] :
			(da_lch_work0_r[27]==1'b1) & (da_lch_work0_r[26]==1'b0) ? {5'b11001,da_lch_work0_r[22:0]} :
			28'h0000000;
	assign da_rch_work0_add1[27:0]=
			(da_rch_work0_r[27]==1'b0) & (da_rch_work0_r[26]==1'b1) ? {5'b00111,da_rch_work0_r[22:0]} :
			(da_rch_work0_r[27]==1'b0) & (da_rch_work0_r[26]==1'b0) ? da_rch_work0_r[27:0] :
			(da_rch_work0_r[27]==1'b1) & (da_rch_work0_r[26]==1'b1) ? da_rch_work0_r[27:0] :
			(da_rch_work0_r[27]==1'b1) & (da_rch_work0_r[26]==1'b0) ? {5'b11001,da_rch_work0_r[22:0]} :
			28'h0000000;

	assign da_lch_work0_add2[27:0]=
			(da_lch_work0_r[27:26]==2'b01)    ? 28'he800000 :
			(da_lch_work0_r[27:25]==3'b001)   ? 28'he800000 :
			(da_lch_work0_r[27:23]==5'b00011) ? 28'he800000 :
			(da_lch_work0_r[27:23]==5'b00010) ? 28'hf000000 :
			(da_lch_work0_r[27:23]==5'b00001) ? 28'hf800000 :
			(da_lch_work0_r[27:23]==5'b00000) ? 28'h0000000 :
			(da_lch_work0_r[27:23]==5'b11111) ? 28'h0000000 :
			(da_lch_work0_r[27:23]==5'b11110) ? 28'h0800000 :
			(da_lch_work0_r[27:23]==5'b11101) ? 28'h1000000 :
			(da_lch_work0_r[27:23]==5'b11100) ? 28'h1800000 :
			(da_lch_work0_r[27:25]==3'b110)   ? 28'h1800000 :
			(da_lch_work0_r[27:26]==2'b10)    ? 28'h1800000 :
			28'h0000000;

	assign da_rch_work0_add2[27:0]=
			(da_rch_work0_r[27:26]==2'b01)    ? 28'he800000 :
			(da_rch_work0_r[27:25]==3'b001)   ? 28'he800000 :
			(da_rch_work0_r[27:23]==5'b00011) ? 28'he800000 :
			(da_rch_work0_r[27:23]==5'b00010) ? 28'hf000000 :
			(da_rch_work0_r[27:23]==5'b00001) ? 28'hf800000 :
			(da_rch_work0_r[27:23]==5'b00000) ? 28'h0000000 :
			(da_rch_work0_r[27:23]==5'b11111) ? 28'h0000000 :
			(da_rch_work0_r[27:23]==5'b11110) ? 28'h0800000 :
			(da_rch_work0_r[27:23]==5'b11101) ? 28'h1000000 :
			(da_rch_work0_r[27:23]==5'b11100) ? 28'h1800000 :
			(da_rch_work0_r[27:25]==3'b110)   ? 28'h1800000 :
			(da_rch_work0_r[27:26]==2'b10)    ? 28'h1800000 :
			28'h0000000;

	wire	[27:0] da_lch_work1_tmp,da_rch_work1_tmp;
	wire	[27:0] da_lch_work2_tmp,da_rch_work2_tmp;

	assign da_lch_work1_tmp[27:0]=
			(da_lch_work0_r[27]==1'b0) ? {5'b00000,da_lch_work0_r[22:4],4'h0} :
			(da_lch_work0_r[27]==1'b1) ? {5'b11111,da_lch_work0_r[22:4],4'h0} :
			28'h0000000;

	assign da_rch_work1_tmp[27:0]=
			(da_rch_work0_r[27]==1'b0) ? {5'b00000,da_rch_work0_r[22:4],4'h0} :
			(da_rch_work0_r[27]==1'b1) ? {5'b11111,da_rch_work0_r[22:4],4'h0} :
			28'h0000000;

	assign da_lch_work2_tmp[27:4]=~da_lch_work1_tmp[27:4]+24'h00001;
	assign da_lch_work2_tmp[3:0]=4'h0;

	assign da_rch_work2_tmp[27:4]=~da_rch_work1_tmp[27:4]+24'h00001;
	assign da_rch_work2_tmp[3:0]=4'h0;

	assign da_lch_work0_add3[27:0]={da_lch_work1_tmp[27:4],4'h0};
	assign da_rch_work0_add3[27:0]={da_rch_work1_tmp[27:4],4'h0};

	assign da_lch_work0_add4[27:0]={da_lch_work1_r[27:4],4'h0};
	assign da_rch_work0_add4[27:0]={da_rch_work1_r[27:4],4'h0};

	assign da_lch_work0_add5[27:0]=(da_lch_work0_r[27]==1'b1) ? 28'h0000010 : 28'hffffff0;
	assign da_rch_work0_add5[27:0]=(da_rch_work0_r[27]==1'b1) ? 28'h0000010 : 28'hffffff0;

	assign da_lch_work0_tmp[27:0]=da_lch_work0_add0[27:0]+da_lch_work0_add1[27:0]+da_lch_work0_add2[27:0]+da_lch_work0_add3[27:0]+da_lch_work0_add4[27:0]+da_lch_work0_add5[27:0];
	assign da_rch_work0_tmp[27:0]=da_rch_work0_add0[27:0]+da_rch_work0_add1[27:0]+da_rch_work0_add2[27:0]+da_rch_work0_add3[27:0]+da_rch_work0_add4[27:0]+da_rch_work0_add5[27:0];

	assign da_lch_work0_w[27:0]=(da_req_r[0]==1'b1) ? {da_lch_work0_tmp[27:4],4'h0} : da_lch_work0_r[27:0];
	assign da_rch_work0_w[27:0]=(da_req_r[0]==1'b1) ? {da_rch_work0_tmp[27:4],4'h0} : da_rch_work0_r[27:0];

	assign da_lch_work1_w[27:0]=(da_req_r[0]==1'b1) ? {da_lch_work2_tmp[27:4],4'h0} : da_lch_work1_r[27:0];
	assign da_rch_work1_w[27:0]=(da_req_r[0]==1'b1) ? {da_rch_work2_tmp[27:4],4'h0} : da_rch_work1_r[27:0];

endmodule
