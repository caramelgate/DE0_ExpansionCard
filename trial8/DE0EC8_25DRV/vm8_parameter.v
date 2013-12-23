//-----------------------------------------------------------------------------
//
//  vm8_parameter.v : 25drv fm regsters module
//
//  LICENSE : as-is
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/16 release 0.0  rewrite fpgagen module and connection test
//       dec/23 release 0.1  preview
//
//------------------------------------------------------------------------------

module vm8_parameter(
	output	[15:0]	debug_out,

	input			mclk,
	input			reset,
	input	[7:0]	wdata,
	input	[1:0]	waddr,
	input			we,
	output	[7:0]	status,

	input	[7:0]	psg_in,
	output	[7:0]	dac_out,
	output	[15:0]	chl_out,
	output	[15:0]	chr_out
);

	wire	wreq;
	wire	wreq0;
	wire	wreq1;
	wire	[7:0] index;
	wire	[8:0] index0;
	wire	[8:0] index1;

	reg		[7:0] index_r;
	reg		[7:0] index0_r;
	reg		[7:0] index1_r;
	reg		[7:0] wdata_r;
	reg		wreq_r;
	reg		wreq0_r;
	reg		wreq1_r;
	wire	[7:0] index_w;
	wire	[7:0] index0_w;
	wire	[7:0] index1_w;
	wire	[7:0] wdata_w;
	wire	wreq_w;
	wire	wreq0_w;
	wire	wreq1_w;

	reg		[7:0] reg022_r;
	reg		[7:0] reg027_r;
	reg		[7:0] reg028_ch1_r;
	reg		[7:0] reg028_ch2_r;
	reg		[7:0] reg028_ch3_r;
	reg		[7:0] reg028_ch4_r;
	reg		[7:0] reg028_ch5_r;
	reg		[7:0] reg028_ch6_r;
	reg		[7:0] reg02a_r;
	reg		[7:0] reg02b_r;

	wire	[7:0] dac;

	assign dac_out[7:0]=(reg02b_r[7]==1'b0) ? 8'h00 : {!reg02a_r[7],reg02a_r[6:0]};

	assign dac[7:0]=(reg02b_r[7]==1'b0) ? 8'h00 : {!reg02a_r[7],reg02a_r[6:0]};

//	assign wreq=(we==1'b1) & (be[0]==1'b1) ? 1'b1 : 1'b0;
//	assign wreq0=(we==1'b1) & ({waddr[1],be[0]}==2'b01) ? 1'b1 : 1'b0;
//	assign wreq1=(we==1'b1) & ({waddr[1],be[0]}==2'b11) ? 1'b1 : 1'b0;
	assign wreq=wreq_r;
	assign wreq0=wreq0_r;
	assign wreq1=wreq1_r;
	assign index[7:0]=index_r[7:0];
	assign index0[8:0]={waddr[1],index0_r[7:0]};
	assign index1[8:0]={waddr[1],index1_r[7:0]};

	always @(posedge mclk or posedge reset)
	begin
		if (reset==1'b1)
			begin
				index_r[7:0] <= 8'b0;
				index0_r[7:0] <= 8'b0;
				index1_r[7:0] <= 8'b0;
				wdata_r[7:0] <= 8'b0;
				wreq_r <= 1'b0;
				wreq0_r <= 1'b0;
				wreq1_r <= 1'b0;

				reg022_r[7:0] <= 8'b0;
				reg027_r[7:0] <= 8'b0;
				reg028_ch1_r[7:0] <= 8'b0;
				reg028_ch2_r[7:0] <= 8'b0;
				reg028_ch3_r[7:0] <= 8'b0;
				reg028_ch4_r[7:0] <= 8'b0;
				reg028_ch5_r[7:0] <= 8'b0;
				reg028_ch6_r[7:0] <= 8'b0;
				reg02a_r[7:0] <= 8'h80;
				reg02b_r[7:0] <= 8'b0;
			end
		else
			begin
				index_r[7:0] <= index_w[7:0];
				index0_r[7:0] <= index0_w[7:0];
				index1_r[7:0] <= index1_w[7:0];
				wdata_r[7:0] <= wdata_w[7:0];
				wreq_r <= wreq_w;
				wreq0_r <= wreq0_w;
				wreq1_r <= wreq1_w;

				reg022_r[7:0] <= (index[7:0]==8'h22) & (wreq==1'b1) ? wdata_r[7:0] : reg022_r[7:0];
				reg027_r[7:0] <= (index[7:0]==8'h27) & (wreq==1'b1) ? wdata_r[7:0] : reg027_r[7:0];
				reg028_ch1_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h0) ? wdata_r[7:0] : reg028_ch1_r[7:0];
				reg028_ch2_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h1) ? wdata_r[7:0] : reg028_ch2_r[7:0];
				reg028_ch3_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h2) ? wdata_r[7:0] : reg028_ch3_r[7:0];
				reg028_ch4_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h4) ? wdata_r[7:0] : reg028_ch4_r[7:0];
				reg028_ch5_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h5) ? wdata_r[7:0] : reg028_ch5_r[7:0];
				reg028_ch6_r[7:0] <= (index[7:0]==8'h28) & (wreq==1'b1) & (wdata_r[2:0]==3'h6) ? wdata_r[7:0] : reg028_ch6_r[7:0];
				reg02a_r[7:0] <= (index[7:0]==8'h2a) & (wreq==1'b1) ? wdata_r[7:0] : reg02a_r[7:0];
				reg02b_r[7:0] <= (index[7:0]==8'h2b) & (wreq==1'b1) ? wdata_r[7:0] : reg02b_r[7:0];
			end
	end

	assign index_w[7:0]=(we==1'b1) & (waddr[0]==1'b0) ? wdata[7:0] : index_r[7:0];
	assign index0_w[7:0]=(we==1'b1) & (waddr[1:0]==2'b00) ? wdata[7:0] : index0_r[7:0];
	assign index1_w[7:0]=(we==1'b1) & (waddr[1:0]==2'b10) ? wdata[7:0] : index1_r[7:0];

	assign wdata_w[7:0]=wdata[7:0];
	assign wreq_w=(we==1'b1) & (waddr[0]==1'b1) ? 1'b1 : 1'b0;
	assign wreq0_w=(we==1'b1) & (waddr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign wreq1_w=(we==1'b1) & (waddr[1:0]==2'b11) ? 1'b1 : 1'b0;

	//

	reg		[7:0] reg030_r,reg130_r;
	reg		[7:0] reg031_r,reg131_r;
	reg		[7:0] reg032_r,reg132_r;
	reg		[7:0] reg034_r,reg134_r;
	reg		[7:0] reg035_r,reg135_r;
	reg		[7:0] reg036_r,reg136_r;
	reg		[7:0] reg038_r,reg138_r;
	reg		[7:0] reg039_r,reg139_r;
	reg		[7:0] reg03a_r,reg13a_r;
	reg		[7:0] reg03c_r,reg13c_r;
	reg		[7:0] reg03d_r,reg13d_r;
	reg		[7:0] reg03e_r,reg13e_r;
	reg		[7:0] reg040_r,reg140_r;
	reg		[7:0] reg041_r,reg141_r;
	reg		[7:0] reg042_r,reg142_r;
	reg		[7:0] reg044_r,reg144_r;
	reg		[7:0] reg045_r,reg145_r;
	reg		[7:0] reg046_r,reg146_r;
	reg		[7:0] reg048_r,reg148_r;
	reg		[7:0] reg049_r,reg149_r;
	reg		[7:0] reg04a_r,reg14a_r;
	reg		[7:0] reg04c_r,reg14c_r;
	reg		[7:0] reg04d_r,reg14d_r;
	reg		[7:0] reg04e_r,reg14e_r;
	reg		[7:0] reg050_r,reg150_r;
	reg		[7:0] reg051_r,reg151_r;
	reg		[7:0] reg052_r,reg152_r;
	reg		[7:0] reg054_r,reg154_r;
	reg		[7:0] reg055_r,reg155_r;
	reg		[7:0] reg056_r,reg156_r;
	reg		[7:0] reg058_r,reg158_r;
	reg		[7:0] reg059_r,reg159_r;
	reg		[7:0] reg05a_r,reg15a_r;
	reg		[7:0] reg05c_r,reg15c_r;
	reg		[7:0] reg05d_r,reg15d_r;
	reg		[7:0] reg05e_r,reg15e_r;
	reg		[7:0] reg060_r,reg160_r;
	reg		[7:0] reg061_r,reg161_r;
	reg		[7:0] reg062_r,reg162_r;
	reg		[7:0] reg064_r,reg164_r;
	reg		[7:0] reg065_r,reg165_r;
	reg		[7:0] reg066_r,reg166_r;
	reg		[7:0] reg068_r,reg168_r;
	reg		[7:0] reg069_r,reg169_r;
	reg		[7:0] reg06a_r,reg16a_r;
	reg		[7:0] reg06c_r,reg16c_r;
	reg		[7:0] reg06d_r,reg16d_r;
	reg		[7:0] reg06e_r,reg16e_r;
	reg		[7:0] reg070_r,reg170_r;
	reg		[7:0] reg071_r,reg171_r;
	reg		[7:0] reg072_r,reg172_r;
	reg		[7:0] reg074_r,reg174_r;
	reg		[7:0] reg075_r,reg175_r;
	reg		[7:0] reg076_r,reg176_r;
	reg		[7:0] reg078_r,reg178_r;
	reg		[7:0] reg079_r,reg179_r;
	reg		[7:0] reg07a_r,reg17a_r;
	reg		[7:0] reg07c_r,reg17c_r;
	reg		[7:0] reg07d_r,reg17d_r;
	reg		[7:0] reg07e_r,reg17e_r;
	reg		[7:0] reg080_r,reg180_r;
	reg		[7:0] reg081_r,reg181_r;
	reg		[7:0] reg082_r,reg182_r;
	reg		[7:0] reg084_r,reg184_r;
	reg		[7:0] reg085_r,reg185_r;
	reg		[7:0] reg086_r,reg186_r;
	reg		[7:0] reg088_r,reg188_r;
	reg		[7:0] reg089_r,reg189_r;
	reg		[7:0] reg08a_r,reg18a_r;
	reg		[7:0] reg08c_r,reg18c_r;
	reg		[7:0] reg08d_r,reg18d_r;
	reg		[7:0] reg08e_r,reg18e_r;
	reg		[7:0] reg090_r,reg190_r;
	reg		[7:0] reg091_r,reg191_r;
	reg		[7:0] reg092_r,reg192_r;
	reg		[7:0] reg094_r,reg194_r;
	reg		[7:0] reg095_r,reg195_r;
	reg		[7:0] reg096_r,reg196_r;
	reg		[7:0] reg098_r,reg198_r;
	reg		[7:0] reg099_r,reg199_r;
	reg		[7:0] reg09a_r,reg19a_r;
	reg		[7:0] reg09c_r,reg19c_r;
	reg		[7:0] reg09d_r,reg19d_r;
	reg		[7:0] reg09e_r,reg19e_r;
	reg		[7:0] reg0a0_r,reg1a0_r;
	reg		[7:0] reg0a1_r,reg1a1_r;
	reg		[7:0] reg0a2_r,reg1a2_r;
	reg		[7:0] reg0a4_r,reg1a4_r;
	reg		[7:0] reg0a5_r,reg1a5_r;
	reg		[7:0] reg0a6_r,reg1a6_r;
	reg		[7:0] reg0a8_r,reg1a8_r;
	reg		[7:0] reg0a9_r,reg1a9_r;
	reg		[7:0] reg0aa_r,reg1aa_r;
	reg		[7:0] reg0ac_r,reg1ac_r;
	reg		[7:0] reg0ad_r,reg1ad_r;
	reg		[7:0] reg0ae_r,reg1ae_r;
	reg		[7:0] reg0b0_r,reg1b0_r;
	reg		[7:0] reg0b1_r,reg1b1_r;
	reg		[7:0] reg0b2_r,reg1b2_r;
	reg		[7:0] reg0b4_r,reg1b4_r;
	reg		[7:0] reg0b5_r,reg1b5_r;
	reg		[7:0] reg0b6_r,reg1b6_r;
	reg		[7:0] reg0b8_r,reg1b8_r;
	reg		[7:0] reg0b9_r,reg1b9_r;
	reg		[7:0] reg0ba_r,reg1ba_r;
	reg		[7:0] reg0bc_r,reg1bc_r;
	reg		[7:0] reg0bd_r,reg1bd_r;
	reg		[7:0] reg0be_r,reg1be_r;

	always @(posedge mclk or posedge reset)
	begin
		if (reset==1'b1)
			begin
				reg030_r[7:0] <= 8'b0;
				reg031_r[7:0] <= 8'b0;
				reg032_r[7:0] <= 8'b0;
				reg034_r[7:0] <= 8'b0;
				reg035_r[7:0] <= 8'b0;
				reg036_r[7:0] <= 8'b0;
				reg038_r[7:0] <= 8'b0;
				reg039_r[7:0] <= 8'b0;
				reg03a_r[7:0] <= 8'b0;
				reg03c_r[7:0] <= 8'b0;
				reg03d_r[7:0] <= 8'b0;
				reg03e_r[7:0] <= 8'b0;
				reg040_r[7:0] <= 8'b0;
				reg041_r[7:0] <= 8'b0;
				reg042_r[7:0] <= 8'b0;
				reg044_r[7:0] <= 8'b0;
				reg045_r[7:0] <= 8'b0;
				reg046_r[7:0] <= 8'b0;
				reg048_r[7:0] <= 8'b0;
				reg049_r[7:0] <= 8'b0;
				reg04a_r[7:0] <= 8'b0;
				reg04c_r[7:0] <= 8'b0;
				reg04d_r[7:0] <= 8'b0;
				reg04e_r[7:0] <= 8'b0;
				reg050_r[7:0] <= 8'b0;
				reg051_r[7:0] <= 8'b0;
				reg052_r[7:0] <= 8'b0;
				reg054_r[7:0] <= 8'b0;
				reg055_r[7:0] <= 8'b0;
				reg056_r[7:0] <= 8'b0;
				reg058_r[7:0] <= 8'b0;
				reg059_r[7:0] <= 8'b0;
				reg05a_r[7:0] <= 8'b0;
				reg05c_r[7:0] <= 8'b0;
				reg05d_r[7:0] <= 8'b0;
				reg05e_r[7:0] <= 8'b0;
				reg060_r[7:0] <= 8'b0;
				reg061_r[7:0] <= 8'b0;
				reg062_r[7:0] <= 8'b0;
				reg064_r[7:0] <= 8'b0;
				reg065_r[7:0] <= 8'b0;
				reg066_r[7:0] <= 8'b0;
				reg068_r[7:0] <= 8'b0;
				reg069_r[7:0] <= 8'b0;
				reg06a_r[7:0] <= 8'b0;
				reg06c_r[7:0] <= 8'b0;
				reg06d_r[7:0] <= 8'b0;
				reg06e_r[7:0] <= 8'b0;
				reg070_r[7:0] <= 8'b0;
				reg071_r[7:0] <= 8'b0;
				reg072_r[7:0] <= 8'b0;
				reg074_r[7:0] <= 8'b0;
				reg075_r[7:0] <= 8'b0;
				reg076_r[7:0] <= 8'b0;
				reg078_r[7:0] <= 8'b0;
				reg079_r[7:0] <= 8'b0;
				reg07a_r[7:0] <= 8'b0;
				reg07c_r[7:0] <= 8'b0;
				reg07d_r[7:0] <= 8'b0;
				reg07e_r[7:0] <= 8'b0;
				reg080_r[7:0] <= 8'b0;
				reg081_r[7:0] <= 8'b0;
				reg082_r[7:0] <= 8'b0;
				reg084_r[7:0] <= 8'b0;
				reg085_r[7:0] <= 8'b0;
				reg086_r[7:0] <= 8'b0;
				reg088_r[7:0] <= 8'b0;
				reg089_r[7:0] <= 8'b0;
				reg08a_r[7:0] <= 8'b0;
				reg08c_r[7:0] <= 8'b0;
				reg08d_r[7:0] <= 8'b0;
				reg08e_r[7:0] <= 8'b0;
				reg090_r[7:0] <= 8'b0;
				reg091_r[7:0] <= 8'b0;
				reg092_r[7:0] <= 8'b0;
				reg094_r[7:0] <= 8'b0;
				reg095_r[7:0] <= 8'b0;
				reg096_r[7:0] <= 8'b0;
				reg098_r[7:0] <= 8'b0;
				reg099_r[7:0] <= 8'b0;
				reg09a_r[7:0] <= 8'b0;
				reg09c_r[7:0] <= 8'b0;
				reg09d_r[7:0] <= 8'b0;
				reg09e_r[7:0] <= 8'b0;
				reg0a0_r[7:0] <= 8'b0;
				reg0a1_r[7:0] <= 8'b0;
				reg0a2_r[7:0] <= 8'b0;
				reg0a4_r[7:0] <= 8'b0;
				reg0a5_r[7:0] <= 8'b0;
				reg0a6_r[7:0] <= 8'b0;
				reg0a8_r[7:0] <= 8'b0;
				reg0a9_r[7:0] <= 8'b0;
				reg0aa_r[7:0] <= 8'b0;
				reg0ac_r[7:0] <= 8'b0;
				reg0ad_r[7:0] <= 8'b0;
				reg0ae_r[7:0] <= 8'b0;
				reg0b0_r[7:0] <= 8'b0;
				reg0b1_r[7:0] <= 8'b0;
				reg0b2_r[7:0] <= 8'b0;
				reg0b4_r[7:0] <= 8'b0;
				reg0b5_r[7:0] <= 8'b0;
				reg0b6_r[7:0] <= 8'b0;
				reg0b8_r[7:0] <= 8'b0;
				reg0b9_r[7:0] <= 8'b0;
				reg0ba_r[7:0] <= 8'b0;
				reg0bc_r[7:0] <= 8'b0;
				reg0bd_r[7:0] <= 8'b0;
				reg0be_r[7:0] <= 8'b0;
				reg130_r[7:0] <= 8'b0;
				reg131_r[7:0] <= 8'b0;
				reg132_r[7:0] <= 8'b0;
				reg134_r[7:0] <= 8'b0;
				reg135_r[7:0] <= 8'b0;
				reg136_r[7:0] <= 8'b0;
				reg138_r[7:0] <= 8'b0;
				reg139_r[7:0] <= 8'b0;
				reg13a_r[7:0] <= 8'b0;
				reg13c_r[7:0] <= 8'b0;
				reg13d_r[7:0] <= 8'b0;
				reg13e_r[7:0] <= 8'b0;
				reg140_r[7:0] <= 8'b0;
				reg141_r[7:0] <= 8'b0;
				reg142_r[7:0] <= 8'b0;
				reg144_r[7:0] <= 8'b0;
				reg145_r[7:0] <= 8'b0;
				reg146_r[7:0] <= 8'b0;
				reg148_r[7:0] <= 8'b0;
				reg149_r[7:0] <= 8'b0;
				reg14a_r[7:0] <= 8'b0;
				reg14c_r[7:0] <= 8'b0;
				reg14d_r[7:0] <= 8'b0;
				reg14e_r[7:0] <= 8'b0;
				reg150_r[7:0] <= 8'b0;
				reg151_r[7:0] <= 8'b0;
				reg152_r[7:0] <= 8'b0;
				reg154_r[7:0] <= 8'b0;
				reg155_r[7:0] <= 8'b0;
				reg156_r[7:0] <= 8'b0;
				reg158_r[7:0] <= 8'b0;
				reg159_r[7:0] <= 8'b0;
				reg15a_r[7:0] <= 8'b0;
				reg15c_r[7:0] <= 8'b0;
				reg15d_r[7:0] <= 8'b0;
				reg15e_r[7:0] <= 8'b0;
				reg160_r[7:0] <= 8'b0;
				reg161_r[7:0] <= 8'b0;
				reg162_r[7:0] <= 8'b0;
				reg164_r[7:0] <= 8'b0;
				reg165_r[7:0] <= 8'b0;
				reg166_r[7:0] <= 8'b0;
				reg168_r[7:0] <= 8'b0;
				reg169_r[7:0] <= 8'b0;
				reg16a_r[7:0] <= 8'b0;
				reg16c_r[7:0] <= 8'b0;
				reg16d_r[7:0] <= 8'b0;
				reg16e_r[7:0] <= 8'b0;
				reg170_r[7:0] <= 8'b0;
				reg171_r[7:0] <= 8'b0;
				reg172_r[7:0] <= 8'b0;
				reg174_r[7:0] <= 8'b0;
				reg175_r[7:0] <= 8'b0;
				reg176_r[7:0] <= 8'b0;
				reg178_r[7:0] <= 8'b0;
				reg179_r[7:0] <= 8'b0;
				reg17a_r[7:0] <= 8'b0;
				reg17c_r[7:0] <= 8'b0;
				reg17d_r[7:0] <= 8'b0;
				reg17e_r[7:0] <= 8'b0;
				reg180_r[7:0] <= 8'b0;
				reg181_r[7:0] <= 8'b0;
				reg182_r[7:0] <= 8'b0;
				reg184_r[7:0] <= 8'b0;
				reg185_r[7:0] <= 8'b0;
				reg186_r[7:0] <= 8'b0;
				reg188_r[7:0] <= 8'b0;
				reg189_r[7:0] <= 8'b0;
				reg18a_r[7:0] <= 8'b0;
				reg18c_r[7:0] <= 8'b0;
				reg18d_r[7:0] <= 8'b0;
				reg18e_r[7:0] <= 8'b0;
				reg190_r[7:0] <= 8'b0;
				reg191_r[7:0] <= 8'b0;
				reg192_r[7:0] <= 8'b0;
				reg194_r[7:0] <= 8'b0;
				reg195_r[7:0] <= 8'b0;
				reg196_r[7:0] <= 8'b0;
				reg198_r[7:0] <= 8'b0;
				reg199_r[7:0] <= 8'b0;
				reg19a_r[7:0] <= 8'b0;
				reg19c_r[7:0] <= 8'b0;
				reg19d_r[7:0] <= 8'b0;
				reg19e_r[7:0] <= 8'b0;
				reg1a0_r[7:0] <= 8'b0;
				reg1a1_r[7:0] <= 8'b0;
				reg1a2_r[7:0] <= 8'b0;
				reg1a4_r[7:0] <= 8'b0;
				reg1a5_r[7:0] <= 8'b0;
				reg1a6_r[7:0] <= 8'b0;
				reg1a8_r[7:0] <= 8'b0;
				reg1a9_r[7:0] <= 8'b0;
				reg1aa_r[7:0] <= 8'b0;
				reg1ac_r[7:0] <= 8'b0;
				reg1ad_r[7:0] <= 8'b0;
				reg1ae_r[7:0] <= 8'b0;
				reg1b0_r[7:0] <= 8'b0;
				reg1b1_r[7:0] <= 8'b0;
				reg1b2_r[7:0] <= 8'b0;
				reg1b4_r[7:0] <= 8'b0;
				reg1b5_r[7:0] <= 8'b0;
				reg1b6_r[7:0] <= 8'b0;
				reg1b8_r[7:0] <= 8'b0;
				reg1b9_r[7:0] <= 8'b0;
				reg1ba_r[7:0] <= 8'b0;
				reg1bc_r[7:0] <= 8'b0;
				reg1bd_r[7:0] <= 8'b0;
				reg1be_r[7:0] <= 8'b0;
			end
		else
			begin
				reg030_r[7:0] <= (index0[7:0]==8'h30) & (wreq0==1'b1) ? wdata_r[7:0] : reg030_r[7:0];
				reg031_r[7:0] <= (index0[7:0]==8'h31) & (wreq0==1'b1) ? wdata_r[7:0] : reg031_r[7:0];
				reg032_r[7:0] <= (index0[7:0]==8'h32) & (wreq0==1'b1) ? wdata_r[7:0] : reg032_r[7:0];
				reg034_r[7:0] <= (index0[7:0]==8'h34) & (wreq0==1'b1) ? wdata_r[7:0] : reg034_r[7:0];
				reg035_r[7:0] <= (index0[7:0]==8'h35) & (wreq0==1'b1) ? wdata_r[7:0] : reg035_r[7:0];
				reg036_r[7:0] <= (index0[7:0]==8'h36) & (wreq0==1'b1) ? wdata_r[7:0] : reg036_r[7:0];
				reg038_r[7:0] <= (index0[7:0]==8'h38) & (wreq0==1'b1) ? wdata_r[7:0] : reg038_r[7:0];
				reg039_r[7:0] <= (index0[7:0]==8'h39) & (wreq0==1'b1) ? wdata_r[7:0] : reg039_r[7:0];
				reg03a_r[7:0] <= (index0[7:0]==8'h3a) & (wreq0==1'b1) ? wdata_r[7:0] : reg03a_r[7:0];
				reg03c_r[7:0] <= (index0[7:0]==8'h3c) & (wreq0==1'b1) ? wdata_r[7:0] : reg03c_r[7:0];
				reg03d_r[7:0] <= (index0[7:0]==8'h3d) & (wreq0==1'b1) ? wdata_r[7:0] : reg03d_r[7:0];
				reg03e_r[7:0] <= (index0[7:0]==8'h3e) & (wreq0==1'b1) ? wdata_r[7:0] : reg03e_r[7:0];
				reg040_r[7:0] <= (index0[7:0]==8'h40) & (wreq0==1'b1) ? wdata_r[7:0] : reg040_r[7:0];
				reg041_r[7:0] <= (index0[7:0]==8'h41) & (wreq0==1'b1) ? wdata_r[7:0] : reg041_r[7:0];
				reg042_r[7:0] <= (index0[7:0]==8'h42) & (wreq0==1'b1) ? wdata_r[7:0] : reg042_r[7:0];
				reg044_r[7:0] <= (index0[7:0]==8'h44) & (wreq0==1'b1) ? wdata_r[7:0] : reg044_r[7:0];
				reg045_r[7:0] <= (index0[7:0]==8'h45) & (wreq0==1'b1) ? wdata_r[7:0] : reg045_r[7:0];
				reg046_r[7:0] <= (index0[7:0]==8'h46) & (wreq0==1'b1) ? wdata_r[7:0] : reg046_r[7:0];
				reg048_r[7:0] <= (index0[7:0]==8'h48) & (wreq0==1'b1) ? wdata_r[7:0] : reg048_r[7:0];
				reg049_r[7:0] <= (index0[7:0]==8'h49) & (wreq0==1'b1) ? wdata_r[7:0] : reg049_r[7:0];
				reg04a_r[7:0] <= (index0[7:0]==8'h4a) & (wreq0==1'b1) ? wdata_r[7:0] : reg04a_r[7:0];
				reg04c_r[7:0] <= (index0[7:0]==8'h4c) & (wreq0==1'b1) ? wdata_r[7:0] : reg04c_r[7:0];
				reg04d_r[7:0] <= (index0[7:0]==8'h4d) & (wreq0==1'b1) ? wdata_r[7:0] : reg04d_r[7:0];
				reg04e_r[7:0] <= (index0[7:0]==8'h4e) & (wreq0==1'b1) ? wdata_r[7:0] : reg04e_r[7:0];
				reg050_r[7:0] <= (index0[7:0]==8'h50) & (wreq0==1'b1) ? wdata_r[7:0] : reg050_r[7:0];
				reg051_r[7:0] <= (index0[7:0]==8'h51) & (wreq0==1'b1) ? wdata_r[7:0] : reg051_r[7:0];
				reg052_r[7:0] <= (index0[7:0]==8'h52) & (wreq0==1'b1) ? wdata_r[7:0] : reg052_r[7:0];
				reg054_r[7:0] <= (index0[7:0]==8'h54) & (wreq0==1'b1) ? wdata_r[7:0] : reg054_r[7:0];
				reg055_r[7:0] <= (index0[7:0]==8'h55) & (wreq0==1'b1) ? wdata_r[7:0] : reg055_r[7:0];
				reg056_r[7:0] <= (index0[7:0]==8'h56) & (wreq0==1'b1) ? wdata_r[7:0] : reg056_r[7:0];
				reg058_r[7:0] <= (index0[7:0]==8'h58) & (wreq0==1'b1) ? wdata_r[7:0] : reg058_r[7:0];
				reg059_r[7:0] <= (index0[7:0]==8'h59) & (wreq0==1'b1) ? wdata_r[7:0] : reg059_r[7:0];
				reg05a_r[7:0] <= (index0[7:0]==8'h5a) & (wreq0==1'b1) ? wdata_r[7:0] : reg05a_r[7:0];
				reg05c_r[7:0] <= (index0[7:0]==8'h5c) & (wreq0==1'b1) ? wdata_r[7:0] : reg05c_r[7:0];
				reg05d_r[7:0] <= (index0[7:0]==8'h5d) & (wreq0==1'b1) ? wdata_r[7:0] : reg05d_r[7:0];
				reg05e_r[7:0] <= (index0[7:0]==8'h5e) & (wreq0==1'b1) ? wdata_r[7:0] : reg05e_r[7:0];
				reg060_r[7:0] <= (index0[7:0]==8'h60) & (wreq0==1'b1) ? wdata_r[7:0] : reg060_r[7:0];
				reg061_r[7:0] <= (index0[7:0]==8'h61) & (wreq0==1'b1) ? wdata_r[7:0] : reg061_r[7:0];
				reg062_r[7:0] <= (index0[7:0]==8'h62) & (wreq0==1'b1) ? wdata_r[7:0] : reg062_r[7:0];
				reg064_r[7:0] <= (index0[7:0]==8'h64) & (wreq0==1'b1) ? wdata_r[7:0] : reg064_r[7:0];
				reg065_r[7:0] <= (index0[7:0]==8'h65) & (wreq0==1'b1) ? wdata_r[7:0] : reg065_r[7:0];
				reg066_r[7:0] <= (index0[7:0]==8'h66) & (wreq0==1'b1) ? wdata_r[7:0] : reg066_r[7:0];
				reg068_r[7:0] <= (index0[7:0]==8'h68) & (wreq0==1'b1) ? wdata_r[7:0] : reg068_r[7:0];
				reg069_r[7:0] <= (index0[7:0]==8'h69) & (wreq0==1'b1) ? wdata_r[7:0] : reg069_r[7:0];
				reg06a_r[7:0] <= (index0[7:0]==8'h6a) & (wreq0==1'b1) ? wdata_r[7:0] : reg06a_r[7:0];
				reg06c_r[7:0] <= (index0[7:0]==8'h6c) & (wreq0==1'b1) ? wdata_r[7:0] : reg06c_r[7:0];
				reg06d_r[7:0] <= (index0[7:0]==8'h6d) & (wreq0==1'b1) ? wdata_r[7:0] : reg06d_r[7:0];
				reg06e_r[7:0] <= (index0[7:0]==8'h6e) & (wreq0==1'b1) ? wdata_r[7:0] : reg06e_r[7:0];
				reg070_r[7:0] <= (index0[7:0]==8'h70) & (wreq0==1'b1) ? wdata_r[7:0] : reg070_r[7:0];
				reg071_r[7:0] <= (index0[7:0]==8'h71) & (wreq0==1'b1) ? wdata_r[7:0] : reg071_r[7:0];
				reg072_r[7:0] <= (index0[7:0]==8'h72) & (wreq0==1'b1) ? wdata_r[7:0] : reg072_r[7:0];
				reg074_r[7:0] <= (index0[7:0]==8'h74) & (wreq0==1'b1) ? wdata_r[7:0] : reg074_r[7:0];
				reg075_r[7:0] <= (index0[7:0]==8'h75) & (wreq0==1'b1) ? wdata_r[7:0] : reg075_r[7:0];
				reg076_r[7:0] <= (index0[7:0]==8'h76) & (wreq0==1'b1) ? wdata_r[7:0] : reg076_r[7:0];
				reg078_r[7:0] <= (index0[7:0]==8'h78) & (wreq0==1'b1) ? wdata_r[7:0] : reg078_r[7:0];
				reg079_r[7:0] <= (index0[7:0]==8'h79) & (wreq0==1'b1) ? wdata_r[7:0] : reg079_r[7:0];
				reg07a_r[7:0] <= (index0[7:0]==8'h7a) & (wreq0==1'b1) ? wdata_r[7:0] : reg07a_r[7:0];
				reg07c_r[7:0] <= (index0[7:0]==8'h7c) & (wreq0==1'b1) ? wdata_r[7:0] : reg07c_r[7:0];
				reg07d_r[7:0] <= (index0[7:0]==8'h7d) & (wreq0==1'b1) ? wdata_r[7:0] : reg07d_r[7:0];
				reg07e_r[7:0] <= (index0[7:0]==8'h7e) & (wreq0==1'b1) ? wdata_r[7:0] : reg07e_r[7:0];
				reg080_r[7:0] <= (index0[7:0]==8'h80) & (wreq0==1'b1) ? wdata_r[7:0] : reg080_r[7:0];
				reg081_r[7:0] <= (index0[7:0]==8'h81) & (wreq0==1'b1) ? wdata_r[7:0] : reg081_r[7:0];
				reg082_r[7:0] <= (index0[7:0]==8'h82) & (wreq0==1'b1) ? wdata_r[7:0] : reg082_r[7:0];
				reg084_r[7:0] <= (index0[7:0]==8'h84) & (wreq0==1'b1) ? wdata_r[7:0] : reg084_r[7:0];
				reg085_r[7:0] <= (index0[7:0]==8'h85) & (wreq0==1'b1) ? wdata_r[7:0] : reg085_r[7:0];
				reg086_r[7:0] <= (index0[7:0]==8'h86) & (wreq0==1'b1) ? wdata_r[7:0] : reg086_r[7:0];
				reg088_r[7:0] <= (index0[7:0]==8'h88) & (wreq0==1'b1) ? wdata_r[7:0] : reg088_r[7:0];
				reg089_r[7:0] <= (index0[7:0]==8'h89) & (wreq0==1'b1) ? wdata_r[7:0] : reg089_r[7:0];
				reg08a_r[7:0] <= (index0[7:0]==8'h8a) & (wreq0==1'b1) ? wdata_r[7:0] : reg08a_r[7:0];
				reg08c_r[7:0] <= (index0[7:0]==8'h8c) & (wreq0==1'b1) ? wdata_r[7:0] : reg08c_r[7:0];
				reg08d_r[7:0] <= (index0[7:0]==8'h8d) & (wreq0==1'b1) ? wdata_r[7:0] : reg08d_r[7:0];
				reg08e_r[7:0] <= (index0[7:0]==8'h8e) & (wreq0==1'b1) ? wdata_r[7:0] : reg08e_r[7:0];
				reg090_r[7:0] <= (index0[7:0]==8'h90) & (wreq0==1'b1) ? wdata_r[7:0] : reg090_r[7:0];
				reg091_r[7:0] <= (index0[7:0]==8'h91) & (wreq0==1'b1) ? wdata_r[7:0] : reg091_r[7:0];
				reg092_r[7:0] <= (index0[7:0]==8'h92) & (wreq0==1'b1) ? wdata_r[7:0] : reg092_r[7:0];
				reg094_r[7:0] <= (index0[7:0]==8'h94) & (wreq0==1'b1) ? wdata_r[7:0] : reg094_r[7:0];
				reg095_r[7:0] <= (index0[7:0]==8'h95) & (wreq0==1'b1) ? wdata_r[7:0] : reg095_r[7:0];
				reg096_r[7:0] <= (index0[7:0]==8'h96) & (wreq0==1'b1) ? wdata_r[7:0] : reg096_r[7:0];
				reg098_r[7:0] <= (index0[7:0]==8'h98) & (wreq0==1'b1) ? wdata_r[7:0] : reg098_r[7:0];
				reg099_r[7:0] <= (index0[7:0]==8'h99) & (wreq0==1'b1) ? wdata_r[7:0] : reg099_r[7:0];
				reg09a_r[7:0] <= (index0[7:0]==8'h9a) & (wreq0==1'b1) ? wdata_r[7:0] : reg09a_r[7:0];
				reg09c_r[7:0] <= (index0[7:0]==8'h9c) & (wreq0==1'b1) ? wdata_r[7:0] : reg09c_r[7:0];
				reg09d_r[7:0] <= (index0[7:0]==8'h9d) & (wreq0==1'b1) ? wdata_r[7:0] : reg09d_r[7:0];
				reg09e_r[7:0] <= (index0[7:0]==8'h9e) & (wreq0==1'b1) ? wdata_r[7:0] : reg09e_r[7:0];
				reg0a0_r[7:0] <= (index0[7:0]==8'ha0) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a0_r[7:0];
				reg0a1_r[7:0] <= (index0[7:0]==8'ha1) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a1_r[7:0];
				reg0a2_r[7:0] <= (index0[7:0]==8'ha2) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a2_r[7:0];
				reg0a4_r[7:0] <= (index0[7:0]==8'ha4) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a4_r[7:0];
				reg0a5_r[7:0] <= (index0[7:0]==8'ha5) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a5_r[7:0];
				reg0a6_r[7:0] <= (index0[7:0]==8'ha6) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a6_r[7:0];
				reg0a8_r[7:0] <= (index0[7:0]==8'ha8) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a8_r[7:0];
				reg0a9_r[7:0] <= (index0[7:0]==8'ha9) & (wreq0==1'b1) ? wdata_r[7:0] : reg0a9_r[7:0];
				reg0aa_r[7:0] <= (index0[7:0]==8'haa) & (wreq0==1'b1) ? wdata_r[7:0] : reg0aa_r[7:0];
				reg0ac_r[7:0] <= (index0[7:0]==8'hac) & (wreq0==1'b1) ? wdata_r[7:0] : reg0ac_r[7:0];
				reg0ad_r[7:0] <= (index0[7:0]==8'had) & (wreq0==1'b1) ? wdata_r[7:0] : reg0ad_r[7:0];
				reg0ae_r[7:0] <= (index0[7:0]==8'hae) & (wreq0==1'b1) ? wdata_r[7:0] : reg0ae_r[7:0];
				reg0b0_r[7:0] <= (index0[7:0]==8'hb0) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b0_r[7:0];
				reg0b1_r[7:0] <= (index0[7:0]==8'hb1) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b1_r[7:0];
				reg0b2_r[7:0] <= (index0[7:0]==8'hb2) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b2_r[7:0];
				reg0b4_r[7:0] <= (index0[7:0]==8'hb4) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b4_r[7:0];
				reg0b5_r[7:0] <= (index0[7:0]==8'hb5) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b5_r[7:0];
				reg0b6_r[7:0] <= (index0[7:0]==8'hb6) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b6_r[7:0];
				reg0b8_r[7:0] <= (index0[7:0]==8'hb8) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b8_r[7:0];
				reg0b9_r[7:0] <= (index0[7:0]==8'hb9) & (wreq0==1'b1) ? wdata_r[7:0] : reg0b9_r[7:0];
				reg0ba_r[7:0] <= (index0[7:0]==8'hba) & (wreq0==1'b1) ? wdata_r[7:0] : reg0ba_r[7:0];
				reg0bc_r[7:0] <= (index0[7:0]==8'hbc) & (wreq0==1'b1) ? wdata_r[7:0] : reg0bc_r[7:0];
				reg0bd_r[7:0] <= (index0[7:0]==8'hbd) & (wreq0==1'b1) ? wdata_r[7:0] : reg0bd_r[7:0];
				reg0be_r[7:0] <= (index0[7:0]==8'hbe) & (wreq0==1'b1) ? wdata_r[7:0] : reg0be_r[7:0];
				reg130_r[7:0] <= (index1[7:0]==8'h30) & (wreq1==1'b1) ? wdata_r[7:0] : reg130_r[7:0];
				reg131_r[7:0] <= (index1[7:0]==8'h31) & (wreq1==1'b1) ? wdata_r[7:0] : reg131_r[7:0];
				reg132_r[7:0] <= (index1[7:0]==8'h32) & (wreq1==1'b1) ? wdata_r[7:0] : reg132_r[7:0];
				reg134_r[7:0] <= (index1[7:0]==8'h34) & (wreq1==1'b1) ? wdata_r[7:0] : reg134_r[7:0];
				reg135_r[7:0] <= (index1[7:0]==8'h35) & (wreq1==1'b1) ? wdata_r[7:0] : reg135_r[7:0];
				reg136_r[7:0] <= (index1[7:0]==8'h36) & (wreq1==1'b1) ? wdata_r[7:0] : reg136_r[7:0];
				reg138_r[7:0] <= (index1[7:0]==8'h38) & (wreq1==1'b1) ? wdata_r[7:0] : reg138_r[7:0];
				reg139_r[7:0] <= (index1[7:0]==8'h39) & (wreq1==1'b1) ? wdata_r[7:0] : reg139_r[7:0];
				reg13a_r[7:0] <= (index1[7:0]==8'h3a) & (wreq1==1'b1) ? wdata_r[7:0] : reg13a_r[7:0];
				reg13c_r[7:0] <= (index1[7:0]==8'h3c) & (wreq1==1'b1) ? wdata_r[7:0] : reg13c_r[7:0];
				reg13d_r[7:0] <= (index1[7:0]==8'h3d) & (wreq1==1'b1) ? wdata_r[7:0] : reg13d_r[7:0];
				reg13e_r[7:0] <= (index1[7:0]==8'h3e) & (wreq1==1'b1) ? wdata_r[7:0] : reg13e_r[7:0];
				reg140_r[7:0] <= (index1[7:0]==8'h40) & (wreq1==1'b1) ? wdata_r[7:0] : reg140_r[7:0];
				reg141_r[7:0] <= (index1[7:0]==8'h41) & (wreq1==1'b1) ? wdata_r[7:0] : reg141_r[7:0];
				reg142_r[7:0] <= (index1[7:0]==8'h42) & (wreq1==1'b1) ? wdata_r[7:0] : reg142_r[7:0];
				reg144_r[7:0] <= (index1[7:0]==8'h44) & (wreq1==1'b1) ? wdata_r[7:0] : reg144_r[7:0];
				reg145_r[7:0] <= (index1[7:0]==8'h45) & (wreq1==1'b1) ? wdata_r[7:0] : reg145_r[7:0];
				reg146_r[7:0] <= (index1[7:0]==8'h46) & (wreq1==1'b1) ? wdata_r[7:0] : reg146_r[7:0];
				reg148_r[7:0] <= (index1[7:0]==8'h48) & (wreq1==1'b1) ? wdata_r[7:0] : reg148_r[7:0];
				reg149_r[7:0] <= (index1[7:0]==8'h49) & (wreq1==1'b1) ? wdata_r[7:0] : reg149_r[7:0];
				reg14a_r[7:0] <= (index1[7:0]==8'h4a) & (wreq1==1'b1) ? wdata_r[7:0] : reg14a_r[7:0];
				reg14c_r[7:0] <= (index1[7:0]==8'h4c) & (wreq1==1'b1) ? wdata_r[7:0] : reg14c_r[7:0];
				reg14d_r[7:0] <= (index1[7:0]==8'h4d) & (wreq1==1'b1) ? wdata_r[7:0] : reg14d_r[7:0];
				reg14e_r[7:0] <= (index1[7:0]==8'h4e) & (wreq1==1'b1) ? wdata_r[7:0] : reg14e_r[7:0];
				reg150_r[7:0] <= (index1[7:0]==8'h50) & (wreq1==1'b1) ? wdata_r[7:0] : reg150_r[7:0];
				reg151_r[7:0] <= (index1[7:0]==8'h51) & (wreq1==1'b1) ? wdata_r[7:0] : reg151_r[7:0];
				reg152_r[7:0] <= (index1[7:0]==8'h52) & (wreq1==1'b1) ? wdata_r[7:0] : reg152_r[7:0];
				reg154_r[7:0] <= (index1[7:0]==8'h54) & (wreq1==1'b1) ? wdata_r[7:0] : reg154_r[7:0];
				reg155_r[7:0] <= (index1[7:0]==8'h55) & (wreq1==1'b1) ? wdata_r[7:0] : reg155_r[7:0];
				reg156_r[7:0] <= (index1[7:0]==8'h56) & (wreq1==1'b1) ? wdata_r[7:0] : reg156_r[7:0];
				reg158_r[7:0] <= (index1[7:0]==8'h58) & (wreq1==1'b1) ? wdata_r[7:0] : reg158_r[7:0];
				reg159_r[7:0] <= (index1[7:0]==8'h59) & (wreq1==1'b1) ? wdata_r[7:0] : reg159_r[7:0];
				reg15a_r[7:0] <= (index1[7:0]==8'h5a) & (wreq1==1'b1) ? wdata_r[7:0] : reg15a_r[7:0];
				reg15c_r[7:0] <= (index1[7:0]==8'h5c) & (wreq1==1'b1) ? wdata_r[7:0] : reg15c_r[7:0];
				reg15d_r[7:0] <= (index1[7:0]==8'h5d) & (wreq1==1'b1) ? wdata_r[7:0] : reg15d_r[7:0];
				reg15e_r[7:0] <= (index1[7:0]==8'h5e) & (wreq1==1'b1) ? wdata_r[7:0] : reg15e_r[7:0];
				reg160_r[7:0] <= (index1[7:0]==8'h60) & (wreq1==1'b1) ? wdata_r[7:0] : reg160_r[7:0];
				reg161_r[7:0] <= (index1[7:0]==8'h61) & (wreq1==1'b1) ? wdata_r[7:0] : reg161_r[7:0];
				reg162_r[7:0] <= (index1[7:0]==8'h62) & (wreq1==1'b1) ? wdata_r[7:0] : reg162_r[7:0];
				reg164_r[7:0] <= (index1[7:0]==8'h64) & (wreq1==1'b1) ? wdata_r[7:0] : reg164_r[7:0];
				reg165_r[7:0] <= (index1[7:0]==8'h65) & (wreq1==1'b1) ? wdata_r[7:0] : reg165_r[7:0];
				reg166_r[7:0] <= (index1[7:0]==8'h66) & (wreq1==1'b1) ? wdata_r[7:0] : reg166_r[7:0];
				reg168_r[7:0] <= (index1[7:0]==8'h68) & (wreq1==1'b1) ? wdata_r[7:0] : reg168_r[7:0];
				reg169_r[7:0] <= (index1[7:0]==8'h69) & (wreq1==1'b1) ? wdata_r[7:0] : reg169_r[7:0];
				reg16a_r[7:0] <= (index1[7:0]==8'h6a) & (wreq1==1'b1) ? wdata_r[7:0] : reg16a_r[7:0];
				reg16c_r[7:0] <= (index1[7:0]==8'h6c) & (wreq1==1'b1) ? wdata_r[7:0] : reg16c_r[7:0];
				reg16d_r[7:0] <= (index1[7:0]==8'h6d) & (wreq1==1'b1) ? wdata_r[7:0] : reg16d_r[7:0];
				reg16e_r[7:0] <= (index1[7:0]==8'h6e) & (wreq1==1'b1) ? wdata_r[7:0] : reg16e_r[7:0];
				reg170_r[7:0] <= (index1[7:0]==8'h70) & (wreq1==1'b1) ? wdata_r[7:0] : reg170_r[7:0];
				reg171_r[7:0] <= (index1[7:0]==8'h71) & (wreq1==1'b1) ? wdata_r[7:0] : reg171_r[7:0];
				reg172_r[7:0] <= (index1[7:0]==8'h72) & (wreq1==1'b1) ? wdata_r[7:0] : reg172_r[7:0];
				reg174_r[7:0] <= (index1[7:0]==8'h74) & (wreq1==1'b1) ? wdata_r[7:0] : reg174_r[7:0];
				reg175_r[7:0] <= (index1[7:0]==8'h75) & (wreq1==1'b1) ? wdata_r[7:0] : reg175_r[7:0];
				reg176_r[7:0] <= (index1[7:0]==8'h76) & (wreq1==1'b1) ? wdata_r[7:0] : reg176_r[7:0];
				reg178_r[7:0] <= (index1[7:0]==8'h78) & (wreq1==1'b1) ? wdata_r[7:0] : reg178_r[7:0];
				reg179_r[7:0] <= (index1[7:0]==8'h79) & (wreq1==1'b1) ? wdata_r[7:0] : reg179_r[7:0];
				reg17a_r[7:0] <= (index1[7:0]==8'h7a) & (wreq1==1'b1) ? wdata_r[7:0] : reg17a_r[7:0];
				reg17c_r[7:0] <= (index1[7:0]==8'h7c) & (wreq1==1'b1) ? wdata_r[7:0] : reg17c_r[7:0];
				reg17d_r[7:0] <= (index1[7:0]==8'h7d) & (wreq1==1'b1) ? wdata_r[7:0] : reg17d_r[7:0];
				reg17e_r[7:0] <= (index1[7:0]==8'h7e) & (wreq1==1'b1) ? wdata_r[7:0] : reg17e_r[7:0];
				reg180_r[7:0] <= (index1[7:0]==8'h80) & (wreq1==1'b1) ? wdata_r[7:0] : reg180_r[7:0];
				reg181_r[7:0] <= (index1[7:0]==8'h81) & (wreq1==1'b1) ? wdata_r[7:0] : reg181_r[7:0];
				reg182_r[7:0] <= (index1[7:0]==8'h82) & (wreq1==1'b1) ? wdata_r[7:0] : reg182_r[7:0];
				reg184_r[7:0] <= (index1[7:0]==8'h84) & (wreq1==1'b1) ? wdata_r[7:0] : reg184_r[7:0];
				reg185_r[7:0] <= (index1[7:0]==8'h85) & (wreq1==1'b1) ? wdata_r[7:0] : reg185_r[7:0];
				reg186_r[7:0] <= (index1[7:0]==8'h86) & (wreq1==1'b1) ? wdata_r[7:0] : reg186_r[7:0];
				reg188_r[7:0] <= (index1[7:0]==8'h88) & (wreq1==1'b1) ? wdata_r[7:0] : reg188_r[7:0];
				reg189_r[7:0] <= (index1[7:0]==8'h89) & (wreq1==1'b1) ? wdata_r[7:0] : reg189_r[7:0];
				reg18a_r[7:0] <= (index1[7:0]==8'h8a) & (wreq1==1'b1) ? wdata_r[7:0] : reg18a_r[7:0];
				reg18c_r[7:0] <= (index1[7:0]==8'h8c) & (wreq1==1'b1) ? wdata_r[7:0] : reg18c_r[7:0];
				reg18d_r[7:0] <= (index1[7:0]==8'h8d) & (wreq1==1'b1) ? wdata_r[7:0] : reg18d_r[7:0];
				reg18e_r[7:0] <= (index1[7:0]==8'h8e) & (wreq1==1'b1) ? wdata_r[7:0] : reg18e_r[7:0];
				reg190_r[7:0] <= (index1[7:0]==8'h90) & (wreq1==1'b1) ? wdata_r[7:0] : reg190_r[7:0];
				reg191_r[7:0] <= (index1[7:0]==8'h91) & (wreq1==1'b1) ? wdata_r[7:0] : reg191_r[7:0];
				reg192_r[7:0] <= (index1[7:0]==8'h92) & (wreq1==1'b1) ? wdata_r[7:0] : reg192_r[7:0];
				reg194_r[7:0] <= (index1[7:0]==8'h94) & (wreq1==1'b1) ? wdata_r[7:0] : reg194_r[7:0];
				reg195_r[7:0] <= (index1[7:0]==8'h95) & (wreq1==1'b1) ? wdata_r[7:0] : reg195_r[7:0];
				reg196_r[7:0] <= (index1[7:0]==8'h96) & (wreq1==1'b1) ? wdata_r[7:0] : reg196_r[7:0];
				reg198_r[7:0] <= (index1[7:0]==8'h98) & (wreq1==1'b1) ? wdata_r[7:0] : reg198_r[7:0];
				reg199_r[7:0] <= (index1[7:0]==8'h99) & (wreq1==1'b1) ? wdata_r[7:0] : reg199_r[7:0];
				reg19a_r[7:0] <= (index1[7:0]==8'h9a) & (wreq1==1'b1) ? wdata_r[7:0] : reg19a_r[7:0];
				reg19c_r[7:0] <= (index1[7:0]==8'h9c) & (wreq1==1'b1) ? wdata_r[7:0] : reg19c_r[7:0];
				reg19d_r[7:0] <= (index1[7:0]==8'h9d) & (wreq1==1'b1) ? wdata_r[7:0] : reg19d_r[7:0];
				reg19e_r[7:0] <= (index1[7:0]==8'h9e) & (wreq1==1'b1) ? wdata_r[7:0] : reg19e_r[7:0];
				reg1a0_r[7:0] <= (index1[7:0]==8'ha0) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a0_r[7:0];
				reg1a1_r[7:0] <= (index1[7:0]==8'ha1) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a1_r[7:0];
				reg1a2_r[7:0] <= (index1[7:0]==8'ha2) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a2_r[7:0];
				reg1a4_r[7:0] <= (index1[7:0]==8'ha4) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a4_r[7:0];
				reg1a5_r[7:0] <= (index1[7:0]==8'ha5) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a5_r[7:0];
				reg1a6_r[7:0] <= (index1[7:0]==8'ha6) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a6_r[7:0];
				reg1a8_r[7:0] <= (index1[7:0]==8'ha8) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a8_r[7:0];
				reg1a9_r[7:0] <= (index1[7:0]==8'ha9) & (wreq1==1'b1) ? wdata_r[7:0] : reg1a9_r[7:0];
				reg1aa_r[7:0] <= (index1[7:0]==8'haa) & (wreq1==1'b1) ? wdata_r[7:0] : reg1aa_r[7:0];
				reg1ac_r[7:0] <= (index1[7:0]==8'hac) & (wreq1==1'b1) ? wdata_r[7:0] : reg1ac_r[7:0];
				reg1ad_r[7:0] <= (index1[7:0]==8'had) & (wreq1==1'b1) ? wdata_r[7:0] : reg1ad_r[7:0];
				reg1ae_r[7:0] <= (index1[7:0]==8'hae) & (wreq1==1'b1) ? wdata_r[7:0] : reg1ae_r[7:0];
				reg1b0_r[7:0] <= (index1[7:0]==8'hb0) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b0_r[7:0];
				reg1b1_r[7:0] <= (index1[7:0]==8'hb1) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b1_r[7:0];
				reg1b2_r[7:0] <= (index1[7:0]==8'hb2) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b2_r[7:0];
				reg1b4_r[7:0] <= (index1[7:0]==8'hb4) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b4_r[7:0];
				reg1b5_r[7:0] <= (index1[7:0]==8'hb5) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b5_r[7:0];
				reg1b6_r[7:0] <= (index1[7:0]==8'hb6) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b6_r[7:0];
				reg1b8_r[7:0] <= (index1[7:0]==8'hb8) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b8_r[7:0];
				reg1b9_r[7:0] <= (index1[7:0]==8'hb9) & (wreq1==1'b1) ? wdata_r[7:0] : reg1b9_r[7:0];
				reg1ba_r[7:0] <= (index1[7:0]==8'hba) & (wreq1==1'b1) ? wdata_r[7:0] : reg1ba_r[7:0];
				reg1bc_r[7:0] <= (index1[7:0]==8'hbc) & (wreq1==1'b1) ? wdata_r[7:0] : reg1bc_r[7:0];
				reg1bd_r[7:0] <= (index1[7:0]==8'hbd) & (wreq1==1'b1) ? wdata_r[7:0] : reg1bd_r[7:0];
				reg1be_r[7:0] <= (index1[7:0]==8'hbe) & (wreq1==1'b1) ? wdata_r[7:0] : reg1be_r[7:0];
			end
	end

//			7	6	5	4	3	2	1	0
//	$22		-	-	-	-	lfo	lfof[2:0]	
//			7	6	5	4	3	2	1	0
//	$30		-	dt[2:0]		mul[3:0]		ch1-slot1/ch4-slot1
//	$31		-	dt[2:0]		mul[3:0]		ch2-slot1/ch5-slot1
//	$32		-	dt[2:0]		mul[3:0]		ch3-slot1/ch6-slot1
//	$33
//	$34		-	dt[2:0]		mul[3:0]		ch1-slot3/ch4-slot3
//	$35		-	dt[2:0]		mul[3:0]		ch2-slot3/ch5-slot3
//	$36		-	dt[2:0]		mul[3:0]		ch3-slot3/ch6-slot3
//	$37
//	$38		-	dt[2:0]		mul[3:0]		ch1-slot2/ch4-slot2
//	$39		-	dt[2:0]		mul[3:0]		ch2-slot2/ch5-slot2
//	$3a		-	dt[2:0]		mul[3:0]		ch3-slot2/ch6-slot2
//	$3b
//	$3c		-	dt[2:0]		mul[3:0]		ch1-slot4/ch4-slot4
//	$3d		-	dt[2:0]		mul[3:0]		ch2-slot4/ch5-slot4
//	$3e		-	dt[2:0]		mul[3:0]		ch3-slot4/ch6-slot4
//	$3f
//			7	6	5	4	3	2	1	0
//	$40		-	tl[6:0]						ch1-slot1/ch4-slot1
//	$41		-	tl[6:0]						ch2-slot1/ch5-slot1
//	$42		-	tl[6:0]						ch3-slot1/ch6-slot1
//	$43
//	$44		-	tl[6:0]						ch1-slot3/ch4-slot3
//	$45		-	tl[6:0]						ch2-slot3/ch5-slot3
//	$46		-	tl[6:0]						ch3-slot3/ch6-slot3
//	$47
//	$48		-	tl[6:0]						ch1-slot2/ch4-slot2
//	$49		-	tl[6:0]						ch2-slot2/ch5-slot2
//	$4a		-	tl[6:0]						ch3-slot2/ch6-slot2
//	$4b
//	$4c		-	tl[6:0]						ch1-slot4/ch4-slot4
//	$4d		-	tl[6:0]						ch2-slot4/ch5-slot4
//	$4e		-	tl[6:0]						ch3-slot4/ch6-slot4
//	$4f
//			7	6	5	4	3	2	1	0
//	$50		ks[1:0]	-	ar[4:0]				ch1-slot1/ch4-slot1
//	$51		ks[1:0]	-	ar[4:0]				ch2-slot1/ch5-slot1
//	$52		ks[1:0]	-	ar[4:0]				ch3-slot1/ch6-slot1
//	$53		
//	$54		ks[1:0]	-	ar[4:0]				ch1-slot3/ch6-slot3
//	$55		ks[1:0]	-	ar[4:0]				ch2-slot3/ch5-slot3
//	$56		ks[1:0]	-	ar[4:0]				ch3-slot3/ch5-slot3
//	$57
//	$58		ks[1:0]	-	ar[4:0]				ch1-slot2/ch4-slot2
//	$59		ks[1:0]	-	ar[4:0]				ch2-slot2/ch5-slot2
//	$5a		ks[1:0]	-	ar[4:0]				ch3-slot2/ch6-slot2
//	$5b		
//	$5c		ks[1:0]	-	ar[4:0]				ch1-slot4/ch4-slot4
//	$5d		ks[1:0]	-	ar[4:0]				ch2-slot4/ch5-slot4
//	$5e		ks[1:0]	-	ar[4:0]				ch3-slot4/ch6-slot4
//	$5f
//			7	6	5	4	3	2	1	0
//	$60		am	-	-	dr[4:0]				ch1-slot1/ch4-slot1
//	$61		am	-	-	dr[4:0]				ch2-slot1/ch5-slot1
//	$62		am	-	-	dr[4:0]				ch3-slot1/ch6-slot1
//	$63
//	$64		am	-	-	dr[4:0]				ch1-slot3/ch4-slot3
//	$65		am	-	-	dr[4:0]				ch2-slot3/ch5-slot3
//	$66		am	-	-	dr[4:0]				ch3-slot3/ch6-slot3
//	$67
//	$68		am	-	-	dr[4:0]				ch1-slot2/ch4-slot2
//	$69		am	-	-	dr[4:0]				ch2-slot2/ch5-slot2
//	$6a		am	-	-	dr[4:0]				ch3-slot2/ch6-slot2
//	$6b
//	$6c		am	-	-	dr[4:0]				ch1-slot4/ch4-slot4
//	$6d		am	-	-	dr[4:0]				ch2-slot4/ch5-slot4
//	$6e		am	-	-	dr[4:0]				ch3-slot4/ch6-slot4
//	$6f
//			7	6	5	4	3	2	1	0
//	$70		-	-	-	sr[4:0]				ch1-slot1/ch4-slot1
//	$71		-	-	-	sr[4:0]				ch2-slot1/ch5-slot1
//	$72		-	-	-	sr[4:0]				ch3-slot1/ch6-slot1
//	$73
//	$74		-	-	-	sr[4:0]				ch1-slot3/ch4-slot3
//	$75		-	-	-	sr[4:0]				ch2-slot3/ch5-slot3
//	$76		-	-	-	sr[4:0]				ch3-slot3/ch6-slot3
//	$77
//	$78		-	-	-	sr[4:0]				ch1-slot2/ch4-slot2
//	$79		-	-	-	sr[4:0]				ch2-slot2/ch5-slot2
//	$7a		-	-	-	sr[4:0]				ch3-slot2/ch6-slot2
//	$7b
//	$7c		-	-	-	sr[4:0]				ch1-slot4/ch4-slot4
//	$7d		-	-	-	sr[4:0]				ch2-slot4/ch5-slot4
//	$7e		-	-	-	sr[4:0]				ch3-slot4/ch6-slot4
//	$7f
//			7	6	5	4	3	2	1	0
//	$80		sl[3:0]			rr[3:0]			ch1-slot1/ch4-slot1
//	$81		sl[3:0]			rr[3:0]			ch2-slot1/ch5-slot1
//	$82		sl[3:0]			rr[3:0]			ch3-slot1/ch6-slot1
//	$83
//	$84		sl[3:0]			rr[3:0]			ch1-slot3/ch4-slot3
//	$85		sl[3:0]			rr[3:0]			ch2-slot3/ch5-slot3
//	$86		sl[3:0]			rr[3:0]			ch3-slot3/ch6-slot3
//	$87
//	$88		sl[3:0]			rr[3:0]			ch1-slot2/ch4-slot2
//	$89		sl[3:0]			rr[3:0]			ch2-slot2/ch5-slot2
//	$8a		sl[3:0]			rr[3:0]			ch3-slot2/ch6-slot2
//	$8b
//	$8c		sl[3:0]			rr[3:0]			ch1-slot4/ch4-slot4
//	$8d		sl[3:0]			rr[3:0]			ch2-slot4/ch5-slot4
//	$8e		sl[3:0]			rr[3:0]			ch3-slot4/ch6-slot4
//			7	6	5	4	3	2	1	0
//	$90		-	-	-	-	eg[3:0]			ch1-slot1/ch4-slot1
//	$91		-	-	-	-	eg[3:0]			ch2-slot1/ch5-slot1
//	$92		-	-	-	-	eg[3:0]			ch3-slot1/ch6-slot1
//	$93
//	$94		-	-	-	-	eg[3:0]			ch1-slot3/ch4-slot3
//	$95		-	-	-	-	eg[3:0]			ch2-slot3/ch5-slot3
//	$96		-	-	-	-	eg[3:0]			ch3-slot3/ch6-slot3
//	$97
//	$98		-	-	-	-	eg[3:0]			ch1-slot2/ch4-slot2
//	$99		-	-	-	-	eg[3:0]			ch2-slot2/ch5-slot2
//	$9a		-	-	-	-	eg[3:0]			ch3-slot2/ch6-slot2
//	$9b
//	$9c		-	-	-	-	eg[3:0]			ch1-slot4/ch4-slot4
//	$9d		-	-	-	-	eg[3:0]			ch2-slot4/ch5-slot4
//	$9e		-	-	-	-	eg[3:0]			ch3-slot4/ch6-slot4
//	$9f
//			7	6	5	4	3	2	1	0
//	$a0		fnum[7:0]						ch1/ch4
//	$a1		fnum[7:0]						ch2/ch5
//	$a2		fnum[7:0]						ch3-slot4/ch6-slot4
//	$a3
//	$a4		-	-	blk[2:0]	fnum[10:8]	ch1/ch4
//	$a5		-	-	blk[2:0]	fnum[10:8]	ch2/ch5
//	$a6		-	-	blk[2:0]	fnum[10:8]	ch3-slot4/ch6-slot4
//	$a7
//	$a8		fnum[7:0]						ch1-slot3/ch4-slot3
//	$a9		fnum[7:0]						ch2-slot1/ch5-slot1
//	$aa		fnum[7:0]						ch3-slot2/ch6-slot3
//	$ab
//	$ac		-	-	blk[2:0]	fnum[10:8]	ch3-slot3/ch6-slot3
//	$ad		-	-	blk[2:0]	fnum[10:8]	ch3-slot1/ch6-slot1
//	$ae		-	-	blk[2:0]	fnum[10:8]	ch3-slot2/ch6-slot2
//	$af
//			7	6	5	4	3	2	1	0
//	$b0		-	-	fb[2:0]		alg[2:0]	ch1/ch4
//	$b1		-	-	fb[2:0]		alg[2:0]	ch2/ch5
//	$b2		-	-	fb[2:0]		alg[2:0]	ch3/ch6
//	$b3
//	$b4		l	r	ams[1:0]-	pms[2:0]	ch1/ch4
//	$b5		l	r	ams[1:0]-	pms[2:0]	ch2/ch5
//	$b6		l	r	ams[1:0]-	pms[2:0]	ch3/ch6
//	$b7

//			7	6	5	4	3	2	1	0
//	$30		-	dt[2:0]		mul[3:0]		ch1-slot1/ch4-slot1
//	$40		-	tl[6:0]						ch1-slot1/ch4-slot1
//	$50		ks[1:0]	-	ar[4:0]				ch1-slot1/ch4-slot1
//	$60		am	-	-	dr[4:0]				ch1-slot1/ch4-slot1
//	$70		-	-	-	sr[4:0]				ch1-slot1/ch4-slot1
//	$80		sl[3:0]			rr[3:0]			ch1-slot1/ch4-slot1
//	$90		-	-	-	-	eg[3:0]			ch1-slot1/ch4-slot1
//	$a0		fnum[7:0]						ch1/ch4
//	$a4		-	-	blk[2:0]	fnum[10:8]	ch1/ch4
//	$b0		-	-	fb[2:0]		alg[2:0]	ch1/ch4
//	$b4		l	r	ams[1:0]-	pms[2:0]	ch1/ch4

	reg		[20:0] ch1_freq_r;
	reg		[20:0] ch2_freq_r;
	reg		[20:0] ch3_freq_r;
	reg		[20:0] ch4_freq_r;
	reg		[20:0] ch5_freq_r;
	reg		[20:0] ch6_freq_r;
	wire	[20:0] ch1_freq_w;
	wire	[20:0] ch2_freq_w;
	wire	[20:0] ch3_freq_w;
	wire	[20:0] ch4_freq_w;
	wire	[20:0] ch5_freq_w;
	wire	[20:0] ch6_freq_w;

	reg		[15:0] ch_psg_r;
	reg		[15:0] ch_dac_r;
	reg		[15:0] ch1_out_r;
	reg		[15:0] ch2_out_r;
	reg		[15:0] ch3_out_r;
	reg		[15:0] ch4_out_r;
	reg		[15:0] ch5_out_r;
	reg		[15:0] ch6_out_r;
	wire	[15:0] ch_psg_w;
	wire	[15:0] ch_dac_w;
	wire	[15:0] ch1_out_w;
	wire	[15:0] ch2_out_w;
	wire	[15:0] ch3_out_w;
	wire	[15:0] ch4_out_w;
	wire	[15:0] ch5_out_w;
	wire	[15:0] ch6_out_w;

	reg		[7:0] slot144_r;
	wire	[7:0] slot144_w;

	always @(posedge mclk or posedge reset)
	begin
		if (reset==1'b1)
			begin
				slot144_r[7:0] <= 8'b0;
				ch1_freq_r[20:0] <= 21'b0;
				ch2_freq_r[20:0] <= 21'b0;
				ch3_freq_r[20:0] <= 21'b0;
				ch4_freq_r[20:0] <= 21'b0;
				ch5_freq_r[20:0] <= 21'b0;
				ch6_freq_r[20:0] <= 21'b0;
				ch_psg_r[15:0] <= 16'b0;
				ch_dac_r[15:0] <= 16'b0;
				ch1_out_r[15:0] <= 16'b0;
				ch2_out_r[15:0] <= 16'b0;
				ch3_out_r[15:0] <= 16'b0;
				ch4_out_r[15:0] <= 16'b0;
				ch5_out_r[15:0] <= 16'b0;
				ch6_out_r[15:0] <= 16'b0;
			end
		else
			begin
				slot144_r[7:0] <= slot144_w[7:0];
				ch1_freq_r[20:0] <= ch1_freq_w[20:0];
				ch2_freq_r[20:0] <= ch2_freq_w[20:0];
				ch3_freq_r[20:0] <= ch3_freq_w[20:0];
				ch4_freq_r[20:0] <= ch4_freq_w[20:0];
				ch5_freq_r[20:0] <= ch5_freq_w[20:0];
				ch6_freq_r[20:0] <= ch6_freq_w[20:0];
				ch_psg_r[15:0] <= ch_psg_w[15:0];
				ch_dac_r[15:0] <= ch_dac_w[15:0];
				ch1_out_r[15:0] <= ch1_out_w[15:0];
				ch2_out_r[15:0] <= ch2_out_w[15:0];
				ch3_out_r[15:0] <= ch3_out_w[15:0];
				ch4_out_r[15:0] <= ch4_out_w[15:0];
				ch5_out_r[15:0] <= ch5_out_w[15:0];
				ch6_out_r[15:0] <= ch6_out_w[15:0];
			end
	end

	assign slot144_w[7:0]=(slot144_r[7:0]==8'd143) ? 8'b0 : slot144_r[7:0]+8'b01;

// fnum=(144 * 440Hz * 2^20 / clk) / 2^(blk-1)
//
// 1038=(144 * out * 2^20 / 8MHz) / 2^(blk-1)
// 1038*2^(blk-1) * 8MHz / (144 * 2^20) = out


	wire	[13:0] ch144_fnum;

	assign ch144_fnum[13:0]=
			(slot144_r[7:2]==6'h00) ? {reg0a4_r[5:3],reg0a4_r[2:0],reg0a0_r[7:0]} :
			(slot144_r[7:2]==6'h02) ? {reg0a5_r[5:3],reg0a5_r[2:0],reg0a1_r[7:0]} :
			(slot144_r[7:2]==6'h04) ? {reg0a6_r[5:3],reg0a6_r[2:0],reg0a2_r[7:0]} :
			(slot144_r[7:2]==6'h06) ? {reg1a4_r[5:3],reg1a4_r[2:0],reg0a0_r[7:0]} :
			(slot144_r[7:2]==6'h08) ? {reg1a5_r[5:3],reg1a5_r[2:0],reg0a1_r[7:0]} :
			(slot144_r[7:2]==6'h0a) ? {reg1a6_r[5:3],reg1a6_r[2:0],reg0a2_r[7:0]} :
			14'b0;

//	assign tl[6:0]={ch_out_r[25:20],1'b0};
//	assign blk[2:0]=ch_out1_r[15:13];
//	assign fnum[8:0]=ch_out1_r[12:4];

	wire	[20:0] ch_fnum;

	assign ch_fnum[20:0]=
			(ch144_fnum[13:11]==3'h7) ? {3'b0,ch144_fnum[10:0],7'b0} :
			(ch144_fnum[13:11]==3'h6) ? {4'b0,ch144_fnum[10:0],6'b0} :
			(ch144_fnum[13:11]==3'h5) ? {5'b0,ch144_fnum[10:0],5'b0} :
			(ch144_fnum[13:11]==3'h4) ? {6'b0,ch144_fnum[10:0],4'b0} :
			(ch144_fnum[13:11]==3'h3) ? {7'b0,ch144_fnum[10:0],3'b0} :
			(ch144_fnum[13:11]==3'h2) ? {8'b0,ch144_fnum[10:0],2'b0} :
			(ch144_fnum[13:11]==3'h1) ? {9'b0,ch144_fnum[10:0],1'b0} :
			(ch144_fnum[13:11]==3'h0) ? {10'b0,ch144_fnum[10:0]} :
			21'b0;

	assign ch1_freq_w[20:0]=(slot144_r[7:2]==6'h00) & (slot144_r[1:0]==2'b01) ? ch1_freq_r[20:0]+ch_fnum[20:0] : ch1_freq_r[20:0];
	assign ch2_freq_w[20:0]=(slot144_r[7:2]==6'h02) & (slot144_r[1:0]==2'b01) ? ch2_freq_r[20:0]+ch_fnum[20:0] : ch2_freq_r[20:0];
	assign ch3_freq_w[20:0]=(slot144_r[7:2]==6'h04) & (slot144_r[1:0]==2'b01) ? ch3_freq_r[20:0]+ch_fnum[20:0] : ch3_freq_r[20:0];
	assign ch4_freq_w[20:0]=(slot144_r[7:2]==6'h06) & (slot144_r[1:0]==2'b01) ? ch4_freq_r[20:0]+ch_fnum[20:0] : ch4_freq_r[20:0];
	assign ch5_freq_w[20:0]=(slot144_r[7:2]==6'h08) & (slot144_r[1:0]==2'b01) ? ch5_freq_r[20:0]+ch_fnum[20:0] : ch5_freq_r[20:0];
	assign ch6_freq_w[20:0]=(slot144_r[7:2]==6'h0a) & (slot144_r[1:0]==2'b01) ? ch6_freq_r[20:0]+ch_fnum[20:0] : ch6_freq_r[20:0];

	wire	[27:0] ch1_mul;
	wire	[27:0] ch2_mul;
	wire	[27:0] ch3_mul;
	wire	[27:0] ch4_mul;
	wire	[27:0] ch5_mul;
	wire	[27:0] ch6_mul;

	assign ch1_mul[27:0]={ch1_freq_r[20],ch1_freq_r[19:0]} * {1'b0,~reg040_r[6:0]};
	assign ch2_mul[27:0]={ch2_freq_r[20],ch2_freq_r[19:0]} * {1'b0,~reg041_r[6:0]};
	assign ch3_mul[27:0]={ch3_freq_r[20],ch3_freq_r[19:0]} * {1'b0,~reg042_r[6:0]};
	assign ch4_mul[27:0]={ch4_freq_r[20],ch4_freq_r[19:0]} * {1'b0,~reg140_r[6:0]};
	assign ch5_mul[27:0]={ch5_freq_r[20],ch5_freq_r[19:0]} * {1'b0,~reg141_r[6:0]};
	assign ch6_mul[27:0]={ch6_freq_r[20],ch6_freq_r[19:0]} * {1'b0,~reg142_r[6:0]};

	wire	[27:0] ch1_mult;
	wire	[27:0] ch2_mult;
	wire	[27:0] ch3_mult;
	wire	[27:0] ch4_mult;
	wire	[27:0] ch5_mult;
	wire	[27:0] ch6_mult;

xil_multiplier_s21xu7 ch1_mult_s21xu7(
	.clk(mclk),
	.a(ch1_freq_r[20:0]),
	.b(~reg040_r[6:0]),
	.p(ch1_mult[27:0])
);

xil_multiplier_s21xu7 ch2_mult_s21xu7(
	.clk(mclk),
	.a(ch2_freq_r[20:0]),
	.b(~reg140_r[6:0]),
	.p(ch2_mult[27:0])
);

xil_multiplier_s21xu7 ch3_mult_s21xu7(
	.clk(mclk),
	.a(ch3_freq_r[20:0]),
	.b(~reg141_r[6:0]),
	.p(ch3_mult[27:0])
);

xil_multiplier_s21xu7 ch4_mult_s21xu7(
	.clk(mclk),
	.a(ch4_freq_r[20:0]),
	.b(~reg142_r[6:0]),
	.p(ch4_mult[27:0])
);

xil_multiplier_s21xu7 ch5_mult_s21xu7(
	.clk(mclk),
	.a(ch5_freq_r[20:0]),
	.b(~reg142_r[6:0]),
	.p(ch5_mult[27:0])
);

xil_multiplier_s21xu7 ch6_mult_s21xu7(
	.clk(mclk),
	.a(ch6_freq_r[20:0]),
	.b(~reg142_r[6:0]),
	.p(ch6_mult[27:0])
);


	assign ch_psg_w[15:0]={psg_in[7:0],8'b0};
	assign ch_dac_w[15:0]={dac[7:0],8'b0};

	assign ch1_out_w[15:0]=
			((slot144_r[7:2]==6'h00) & (slot144_r[1:0]==2'b10)) & (reg028_ch1_r[7:4]!=4'h0) ? {ch1_mult[27],ch1_mult[26:12]} :
			((slot144_r[7:2]==6'h00) & (slot144_r[1:0]==2'b10)) & (reg028_ch1_r[7:4]==4'h0) ? 16'b0 :
			!((slot144_r[7:2]==6'h00) & (slot144_r[1:0]==2'b10)) ? ch1_out_r[15:0] :
			16'b0;
	assign ch2_out_w[15:0]=
			((slot144_r[7:2]==6'h02) & (slot144_r[1:0]==2'b10)) & (reg028_ch2_r[7:4]!=4'h0) ? {ch2_mult[27],ch2_mult[26:12]} :
			((slot144_r[7:2]==6'h02) & (slot144_r[1:0]==2'b10)) & (reg028_ch2_r[7:4]==4'h0) ? 16'b0 :
			!((slot144_r[7:2]==6'h02) & (slot144_r[1:0]==2'b10)) ? ch2_out_r[15:0] :
			16'b0;
	assign ch3_out_w[15:0]=
			((slot144_r[7:2]==6'h04) & (slot144_r[1:0]==2'b10)) & (reg028_ch3_r[7:4]!=4'h0) ? {ch3_mult[27],ch3_mult[26:12]} :
			((slot144_r[7:2]==6'h04) & (slot144_r[1:0]==2'b10)) & (reg028_ch3_r[7:4]==4'h0) ? 16'b0 :
			!((slot144_r[7:2]==6'h04) & (slot144_r[1:0]==2'b10)) ? ch3_out_r[15:0] :
			16'b0;
	assign ch4_out_w[15:0]=
			((slot144_r[7:2]==6'h06) & (slot144_r[1:0]==2'b10)) & (reg028_ch4_r[7:4]!=4'h0) ? {ch4_mult[27],ch4_mult[26:12]} :
			((slot144_r[7:2]==6'h06) & (slot144_r[1:0]==2'b10)) & (reg028_ch4_r[7:4]==4'h0) ? 16'b0 :
			!((slot144_r[7:2]==6'h06) & (slot144_r[1:0]==2'b10)) ? ch4_out_r[15:0] :
			16'b0;
	assign ch5_out_w[15:0]=
			((slot144_r[7:2]==6'h08) & (slot144_r[1:0]==2'b10)) & (reg028_ch5_r[7:4]!=4'h0) ? {ch5_mult[27],ch5_mult[26:12]} :
			((slot144_r[7:2]==6'h08) & (slot144_r[1:0]==2'b10)) & (reg028_ch5_r[7:4]==4'h0) ? 16'b0 :
			!((slot144_r[7:2]==6'h08) & (slot144_r[1:0]==2'b10)) ? ch5_out_r[15:0] :
			16'b0;
	assign ch6_out_w[15:0]=
			(reg02b_r[7]==1'b0) & ((slot144_r[7:2]==6'h0a) & (slot144_r[1:0]==2'b10)) & (reg028_ch6_r[7:4]!=4'h0) ? {ch6_mult[27],ch6_mult[26:12]} :
			(reg02b_r[7]==1'b0) & ((slot144_r[7:2]==6'h0a) & (slot144_r[1:0]==2'b10)) & (reg028_ch6_r[7:4]==4'h0) ? 16'b0 :
			(reg02b_r[7]==1'b0) & !((slot144_r[7:2]==6'h0a) & (slot144_r[1:0]==2'b10)) ? ch6_out_r[15:0] :
			16'b0;

	wire	ch1_out;
	wire	ch2_out;
	wire	ch3_out;
	wire	ch4_out;
	wire	ch5_out;
	wire	ch6_out;

	assign ch1_out=ch1_freq_r[20];
	assign ch2_out=ch2_freq_r[20];
	assign ch3_out=ch3_freq_r[20];
	assign ch4_out=ch4_freq_r[20];
	assign ch5_out=ch5_freq_r[20];
	assign ch6_out=ch6_freq_r[20];

	wire	[18:0] ch144_out_w;
	reg		[18:0] ch144_out_r;

	assign chl_out[15:0]=ch144_out_r[18:3];
	assign chr_out[15:0]=ch144_out_r[18:3];

	always @(posedge mclk or posedge reset)
	begin
		if (reset==1'b1)
			begin
				ch144_out_r <= 19'b0;
			end
		else
			begin
				ch144_out_r <= ch144_out_w;
			end
	end

	assign ch144_out_w=(slot144_r[7:2]==6'h00) & (slot144_r[1:0]==2'b01) ? 
			{ch_psg_r[15],ch_psg_r[15],ch_psg_r[15],ch_psg_r[15:0]}
			+{ch_dac_r[15],ch_dac_r[15],ch_dac_r[15],ch_dac_r[15:0]}
			+{ch1_out_r[15],ch1_out_r[15],ch1_out_r[15],ch1_out_r[15:0]}
			+{ch2_out_r[15],ch2_out_r[15],ch2_out_r[15],ch2_out_r[15:0]}
			+{ch3_out_r[15],ch3_out_r[15],ch3_out_r[15],ch3_out_r[15:0]}
			+{ch4_out_r[15],ch4_out_r[15],ch4_out_r[15],ch4_out_r[15:0]}
			+{ch5_out_r[15],ch5_out_r[15],ch5_out_r[15],ch5_out_r[15:0]}
			+{ch6_out_r[15],ch6_out_r[15],ch6_out_r[15],ch6_out_r[15:0]} : ch144_out_r[18:0];


	//

	reg		[15:0] fn0_sel_r;
	reg		[15:0] fn1_sel_r;
	reg		[15:0] fn2_sel_r;
	reg		[15:0] fn3_sel_r;
	reg		[15:0] fn4_sel_r;
	reg		[15:0] fn5_sel_r;
	reg		[15:0] fn6_sel_r;
	reg		[15:0] fn7_sel_r;

	reg		fn0_out_r;
	reg		fn1_out_r;
	reg		fn2_out_r;
	reg		fn3_out_r;
	reg		fn4_out_r;
	reg		fn5_out_r;
	reg		fn6_out_r;
	reg		fn7_out_r;

	wire	fn0_sel;
	wire	fn1_sel;
	wire	fn2_sel;
	wire	fn3_sel;
	wire	fn4_sel;
	wire	fn5_sel;
	wire	fn6_sel;
	wire	fn7_sel;

	assign fn0_sel=(we==1'b1) & (waddr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign fn1_sel=(we==1'b1) & (waddr[1:0]==2'b00) ? 1'b1 : 1'b0;
	assign fn2_sel=(we==1'b1) & (waddr[1:0]==2'b11) ? 1'b1 : 1'b0;
	assign fn3_sel=(we==1'b1) & (waddr[1:0]==2'b10) ? 1'b1 : 1'b0;
	assign fn4_sel=(index0[7:0]==8'h28) & (wreq0==1'b1) ? 1'b1 : 1'b0;
	assign fn5_sel=(index0[7:0]==8'h2a) & (wreq0==1'b1) ? 1'b1 : 1'b0;
	assign fn6_sel=(index0[7:0]==8'h2b) & (wreq0==1'b1) ? 1'b1 : 1'b0;
	assign fn7_sel=(index0[7:0]==8'h40) & (wreq0==1'b1) ? 1'b1 : 1'b0;

	assign debug_out[7]=(reg02b_r[7]==1'b0) ? 1'b0 : 1'b1;
	assign debug_out[6]=(reg027_r[7:6]==2'b0) ? 1'b0 : 1'b1;
	assign debug_out[5]=(reg028_ch6_r[7:4]==4'b0) ? 1'b0 : 1'b1;
	assign debug_out[4]=(reg028_ch5_r[7:4]==4'b0) ? 1'b0 : 1'b1;
	assign debug_out[3]=(reg028_ch4_r[7:4]==4'b0) ? 1'b0 : 1'b1;
	assign debug_out[2]=(reg028_ch3_r[7:4]==4'b0) ? 1'b0 : 1'b1;
	assign debug_out[1]=(reg028_ch2_r[7:4]==4'b0) ? 1'b0 : 1'b1;
	assign debug_out[0]=(reg028_ch1_r[7:4]==4'b0) ? 1'b0 : 1'b1;

	assign debug_out[15:8]={fn7_out_r,fn6_out_r,fn5_out_r,fn4_out_r,fn3_out_r,fn2_out_r,fn1_out_r,fn0_out_r};

	always @(posedge mclk or posedge reset)
	begin
		if (reset==1'b1)
			begin
				fn0_sel_r[15:0] <= 16'b0;
				fn1_sel_r[15:0] <= 16'b0;
				fn2_sel_r[15:0] <= 16'b0;
				fn3_sel_r[15:0] <= 16'b0;
				fn4_sel_r[15:0] <= 16'b0;
				fn5_sel_r[15:0] <= 16'b0;
				fn6_sel_r[15:0] <= 16'b0;
				fn7_sel_r[15:0] <= 16'b0;

				fn0_out_r <= 1'b0;
				fn1_out_r <= 1'b0;
				fn2_out_r <= 1'b0;
				fn3_out_r <= 1'b0;
				fn4_out_r <= 1'b0;
				fn5_out_r <= 1'b0;
				fn6_out_r <= 1'b0;
				fn7_out_r <= 1'b0;
			end
		else
			begin
				fn0_sel_r[15:0] <=
					(fn0_sel==1'b1) ? 16'hffff :
					(fn0_sel==1'b0) & (fn0_sel_r[15:0]!=16'b0) ? fn0_sel_r[15:0]-16'b01 :
					(fn0_sel==1'b0) & (fn0_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn1_sel_r[15:0] <=
					(fn1_sel==1'b1) ? 16'hffff :
					(fn1_sel==1'b0) & (fn1_sel_r[15:0]!=16'b0) ? fn1_sel_r[15:0]-16'b01 :
					(fn1_sel==1'b0) & (fn1_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn2_sel_r[15:0] <=
					(fn2_sel==1'b1) ? 16'hffff :
					(fn2_sel==1'b0) & (fn2_sel_r[15:0]!=16'b0) ? fn2_sel_r[15:0]-16'b01 :
					(fn2_sel==1'b0) & (fn2_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn3_sel_r[15:0] <=
					(fn3_sel==1'b1) ? 16'hffff :
					(fn3_sel==1'b0) & (fn3_sel_r[15:0]!=16'b0) ? fn3_sel_r[15:0]-16'b01 :
					(fn3_sel==1'b0) & (fn3_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn4_sel_r[15:0] <=
					(fn4_sel==1'b1) ? 16'hffff :
					(fn4_sel==1'b0) & (fn4_sel_r[15:0]!=16'b0) ? fn4_sel_r[15:0]-16'b01 :
					(fn4_sel==1'b0) & (fn4_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn5_sel_r[15:0] <=
					(fn5_sel==1'b1) ? 16'hffff :
					(fn5_sel==1'b0) & (fn5_sel_r[15:0]!=16'b0) ? fn5_sel_r[15:0]-16'b01 :
					(fn5_sel==1'b0) & (fn5_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn6_sel_r[15:0] <=
					(fn6_sel==1'b1) ? 16'hffff :
					(fn6_sel==1'b0) & (fn6_sel_r[15:0]!=16'b0) ? fn6_sel_r[15:0]-16'b01 :
					(fn6_sel==1'b0) & (fn6_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;
				fn7_sel_r[15:0] <=
					(fn7_sel==1'b1) ? 16'hffff :
					(fn7_sel==1'b0) & (fn7_sel_r[15:0]!=16'b0) ? fn7_sel_r[15:0]-16'b01 :
					(fn7_sel==1'b0) & (fn7_sel_r[15:0]==16'b0) ? 16'b0 :
					16'b0;

				fn0_out_r <= (fn0_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn1_out_r <= (fn1_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn2_out_r <= (fn2_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn3_out_r <= (fn3_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn4_out_r <= (fn4_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn5_out_r <= (fn5_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn6_out_r <= (fn6_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
				fn7_out_r <= (fn7_sel_r[15:0]==16'b0) ? 1'b0 : 1'b1;
			end
	end

endmodule
