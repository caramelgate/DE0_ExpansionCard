//------------------------------------------------------------------------------
//
//  sdoenc.v : digital audio out encode module
//
//  LICENSE : "as-is"
//  Copyright (C) 2003-2008,2013 TakeshiNagashima nagashima@caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2003/nov/23 release 0.0  : connection test
//
//------------------------------------------------------------------------------

module sdoenc(
	output			sdo_sync,			// out   [DAC] spdif frame sync
	output			sdo_out,			// out   [DAC] spdif out

	input	[23:0]	dac_lch,			// in    [DAC] [23:0] dac left data
	input	[23:0]	dac_rch,			// in    [DAC] [23:0] dac right data
	input			dac_req,			// in    [DAC] dac req

	input	[3:0]	freq_mode,			// in    [DAC] [3:0] freq mode

	input			dac_rst_n,			// in    [DAC] #reset
	input			dac_clk				// in    [DAC] clock (48KHz*512)
);

//--------------------------------------------------------------
//  constant

	localparam	enc_pre_x0=8'b11100010;		// preamble X : 0_11100010_1
	localparam	enc_pre_x1=8'b00011101;		// preamble X : 1_00011101_0
	localparam	enc_pre_y0=8'b11100100;		// preamble Y : 0_11100100_1
	localparam	enc_pre_y1=8'b00011011;		// preamble Y : 1_00011011_0
	localparam	enc_pre_z0=8'b11101000;		// preamble Z : 0_11101000_1
	localparam	enc_pre_z1=8'b00010111;		// preamble Z : 1_00010111_0

//--------------------------------------------------------------
//  signal

	// ---- spdif encode ---

	wire	[23:0] dac_lch_w,dac_rch_w;
	reg		[23:0] dac_lch_r,dac_rch_r;

	wire	spdif_sync_w;
	reg		spdif_sync_r;

	wire	spdif_out_w;
	reg		spdif_out_r;

	wire	[1:0] enc_sub_count_w;
	reg		[1:0] enc_sub_count_r;

	wire	enc_sub_inc_w;
	reg		enc_sub_inc_r;

	wire	[6:0] enc_sub_w;
	reg		[6:0] enc_sub_r;

	wire	[7:0] enc_frame_w;
	reg		[7:0] enc_frame_r;

	wire	[1:0] enc_sub_shift;
	wire	[1:0] enc_frame_inc;

	wire	enc_sub_p_w;
	reg		enc_sub_p_r;

	wire	enc_sub_out_w;
	reg		enc_sub_out_r;

	wire	[7:0] enc_pre_w;
	reg		[7:0] enc_pre_r;

	wire	[31:0] enc_sub_rch_w;
	reg		[31:0] enc_sub_rch_r;

	wire	[31:0] enc_sub_data_w;
	reg		[31:0] enc_sub_data_r;

	wire	enc_p_w;
	reg		enc_p_r;

	wire	[2:0] enc_pre_sel;

//--------------------------------------------------------------
//  design

	assign sdo_sync=spdif_sync_r;
	assign sdo_out=spdif_out_r;

	// ---- spdif encode ----

	//           0    2    4    6    8    10   12   14   16   18   20   22   24   26   28   30  
	//          +----+----+----+----+----+----+----+----*----+----+----+----+----+----+----+----+
	//  frame-0 |pre-Z    |0 0 |0 0 |l-ch 20bit lsb                                msb|V U |C P |
	//          +----+----+----+----+----+----+----+----*----+----+----+----+----+----+----+----+
	//          |pre-Y    |0 0 |0 0 |r-ch 20bit lsb                                msb|V U |C P |
	//          +----+----+----+----+----+----+----+----*----+----+----+----+----+----+----+----+
	//  frame-1 |pre-X    |0 0 |0 0 |l-ch 20bit lsb                                msb|V U |C P |
	//          +----+----+----+----+----+----+----+----*----+----+----+----+----+----+----+----+
	//          |pre-Y    |0 0 |0 0 |r-ch 20bit lsb                                msb|V U |C P |
	//          +----+----+----+----+----+----+----+----*----+----+----+----+----+----+----+----+
	//  preamble-Z : 11101000 / 00010111
	//  preamble-Y : 11100100 / 00011011
	//  preamble-X : 11100010 / 00011101
	//  V : validity
	//  U : user data
	//  C : channel status
	//  P : even parity

	wire	enc_sub_c_w;
	reg		enc_sub_c_r;

	always @(posedge dac_clk or negedge dac_rst_n)
	begin
		if (dac_rst_n==1'b0)
			begin
				dac_lch_r[23:0] <= 24'h000000;
				dac_rch_r[23:0] <= 24'h000000;

				spdif_sync_r <= 1'b0;
				spdif_out_r <= 1'b0;

				enc_sub_count_r[1:0] <= 2'b00;
				enc_sub_inc_r <= 1'b0;
				enc_sub_r[6:0] <= 7'b0000000;
				enc_frame_r[7:0] <= 8'b00000000;

				enc_sub_p_r <= 1'b0;

				enc_sub_c_r <= 1'b0;

				enc_sub_out_r <= 1'b0;
				enc_pre_r[7:0] <= 8'h00;
				enc_sub_rch_r[31:0] <= 32'h00000000;
				enc_sub_data_r[31:0] <= 32'h00000000;
				enc_p_r <= 1'b0;
			end
		else
			begin
				dac_lch_r[23:0] <= dac_lch_w[23:0];
				dac_rch_r[23:0] <= dac_rch_w[23:0];

				spdif_sync_r <= spdif_sync_w;
				spdif_out_r <= spdif_out_w;

				enc_sub_count_r[1:0] <= enc_sub_count_w[1:0];
				enc_sub_inc_r <= enc_sub_inc_w;
				enc_sub_r[6:0] <= enc_sub_w[6:0];
				enc_frame_r[7:0] <= enc_frame_w[7:0];

				enc_sub_p_r <= enc_sub_p_w;

				enc_sub_c_r <= enc_sub_c_w;

				enc_sub_out_r <= enc_sub_out_w;
				enc_pre_r[7:0] <= enc_pre_w[7:0];
				enc_sub_rch_r[31:0] <= enc_sub_rch_w[31:0];
				enc_sub_data_r[31:0] <= enc_sub_data_w[31:0];
				enc_p_r <= enc_p_w;
			end
	end

	assign dac_lch_w[23:0]=(dac_req==1'b1) ? dac_lch[23:0] : dac_lch_r[23:0];
	assign dac_rch_w[23:0]=(dac_req==1'b1) ? dac_rch[23:0] : dac_rch_r[23:0];

	assign spdif_sync_w=
			(enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:1]==2'b11) ? 1'b1 :
			(enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:1]!=2'b11) ? 1'b0 :
			(enc_frame_inc[0]==1'b0) ? spdif_sync_r :
			1'b0;

	assign spdif_out_w=enc_sub_out_w;

	assign enc_sub_count_w[1:0]=enc_sub_count_r[1:0]+2'b01;
	assign enc_sub_inc_w=(enc_sub_count_r[1:0]==2'b10) ? 1'b1 : 1'b0;

	assign enc_sub_w[6:0]=(enc_sub_shift[0]==1'b1) ? enc_sub_r[6:0]+7'b0000001 : enc_sub_r[6:0];

	wire	[7:0] enc_frame_tmp;

	assign enc_frame_tmp[7:6]=
			(enc_frame_r[7:6]==2'b00) & (enc_frame_r[5:0]==6'b111111) ? 2'b01 :
			(enc_frame_r[7:6]==2'b00) & (enc_frame_r[5:0]!=6'b111111) ? 2'b00 :
			(enc_frame_r[7:6]==2'b01) & (enc_frame_r[5:0]==6'b111111) ? 2'b10 :
			(enc_frame_r[7:6]==2'b01) & (enc_frame_r[5:0]!=6'b111111) ? 2'b01 :
			(enc_frame_r[7:6]==2'b10) & (enc_frame_r[5:0]==6'b111111) ? 2'b00 :
			(enc_frame_r[7:6]==2'b10) & (enc_frame_r[5:0]!=6'b111111) ? 2'b10 :
			(enc_frame_r[7:6]==2'b11) ? 2'b00 :
			2'b00;

	assign enc_frame_tmp[5:0]=
			(enc_frame_r[7:6]==2'b00) ? enc_frame_r[5:0]+6'b000001 :
			(enc_frame_r[7:6]==2'b01) ? enc_frame_r[5:0]+6'b000001 :
			(enc_frame_r[7:6]==2'b10) ? enc_frame_r[5:0]+6'b000001 :
			(enc_frame_r[7:6]==2'b11) ? 6'b000000 :
			6'b000000;

	assign enc_frame_w[7:0]=(enc_sub_shift[0]==1'b1) & (enc_frame_inc[1:0]==2'b11) ? enc_frame_tmp[7:0] : enc_frame_r[7:0];

	assign enc_sub_shift[0]=enc_sub_inc_r;
	assign enc_sub_shift[1]=enc_sub_r[0];
	assign enc_sub_p_w=(enc_sub_r[5:1]==5'b11111) ? 1'b1 : 1'b0;
	assign enc_frame_inc[0]=(enc_sub_r[5:0]==6'b111111) ? 1'b1 : 1'b0;
	assign enc_frame_inc[1]=enc_sub_r[6];

	wire	enc_sub_out_tmp0;
	wire	enc_sub_out_tmp1;
	wire	enc_sub_out_tmp2;

	assign enc_sub_out_tmp0=
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) ? !enc_sub_out_r :
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b0) ? enc_pre_r[6] :
			(enc_sub_shift[0]==1'b0) ? enc_sub_out_r :
			1'b0;

	assign enc_sub_out_tmp1=
			(enc_sub_shift[1:0]==2'b11) ? !enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_data_r[0]==1'b0) ? enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_data_r[0]==1'b1) ? !enc_sub_out_r :
			(enc_sub_shift[0]==1'b0) ? enc_sub_out_r :
			1'b0;

	assign enc_sub_out_tmp2=
			(enc_sub_shift[1:0]==2'b11) ? !enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_p_r==1'b0) & (enc_sub_data_r[0]==1'b0) ? enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_p_r==1'b0) & (enc_sub_data_r[0]==1'b1) ? !enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_p_r==1'b1) & (enc_p_r==1'b0) ? enc_sub_out_r :
			(enc_sub_shift[1:0]==2'b01) & (enc_sub_p_r==1'b1) & (enc_p_r==1'b1) ? !enc_sub_out_r :
			(enc_sub_shift[0]==1'b0) ? enc_sub_out_r :
			1'b0;

	assign enc_sub_out_w=
			(enc_sub_r[5:3]==3'b000) ? enc_sub_out_tmp0 :
			(enc_sub_r[5:3]==3'b001) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b010) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b011) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b100) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b101) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b110) ? enc_sub_out_tmp1 :
			(enc_sub_r[5:3]==3'b111) ? enc_sub_out_tmp2 :
			1'b0;

	assign enc_pre_sel[2]=enc_sub_out_r;
	assign enc_pre_sel[1]=enc_sub_r[6];
	assign enc_pre_sel[0]=(enc_frame_r[7:0]==8'h00) ? 1'b1 : 1'b0;

	assign enc_pre_w[7:0]=
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:1]==2'b00) ? enc_pre_y0[7:0] :		// 0 pre-Y0
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:1]==2'b10) ? enc_pre_y1[7:0] :		// 1 pre-Y1
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:0]==3'b010) ? enc_pre_x0[7:0] :	// 0 pre-X0
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:0]==3'b110) ? enc_pre_x1[7:0] :	// 1 pre-X1
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:0]==3'b011) ? enc_pre_z0[7:0] :	// 0 pre-Z0
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b1) & (enc_pre_sel[2:0]==3'b111) ? enc_pre_z1[7:0] :	// 1 pre-Z1
			(enc_sub_shift[0]==1'b1) & (enc_frame_inc[0]==1'b0) ? {enc_pre_r[6:0],1'b0} :
			(enc_sub_shift[0]==1'b0) ? enc_pre_r[7:0] :
			8'h00;

	wire	enc_sub_c_tmp;
	wire	[31:0] enc_sub_data_lch_tmp;
	wire	[31:0] enc_sub_data_rch_tmp;

	assign enc_sub_c_w=
			(enc_frame_r[7:0]==8'h18) ? freq_mode[0] :
			(enc_frame_r[7:0]==8'h19) ? freq_mode[1] :
			(enc_frame_r[7:0]==8'h1a) ? freq_mode[2] :
			(enc_frame_r[7:0]==8'h1b) ? freq_mode[3] :
			1'b0;

	assign enc_sub_c_tmp=enc_sub_c_r;

	assign enc_sub_data_lch_tmp[31:0]={1'b0,enc_sub_c_tmp,2'b00,dac_lch_r[23:0],4'h0};
	assign enc_sub_data_rch_tmp[31:0]={1'b0,enc_sub_c_tmp,2'b00,enc_sub_rch_r[31:8],4'h0};

	assign enc_sub_rch_w[31:0]=(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[1:0]==2'b11) ? {dac_rch_r[23:0],8'h00} : enc_sub_rch_r[31:0];

	assign enc_sub_data_w[31:0]=
			(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[1:0]==2'b11) ? enc_sub_data_lch_tmp[31:0] :
			(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[1:0]==2'b01) ? enc_sub_data_rch_tmp[31:0] :
			(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[0]==1'b0) ? {1'b0,enc_sub_data_r[31:1]} :
			(enc_sub_shift[1:0]!=2'b11) ? enc_sub_data_r[31:0] :
			32'h00000000;

	assign enc_p_w=
			(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[0]==1'b1) ? 1'b0 :
			(enc_sub_shift[1:0]==2'b11) & (enc_frame_inc[0]==1'b0) ? enc_p_r ^ enc_sub_data_r[0] :
			(enc_sub_shift[1:0]!=2'b11) ? enc_p_r :
			1'b0;

endmodule
