//-----------------------------------------------------------------------------
//
//  low_rcv.v : lowspeed recieve top module
//
//  LICENSE : as-is
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/jun/17 release 0.0  connection test
//
//------------------------------------------------------------------------------

module low_rcv (
	input			u_dm_in,	// -D
	input			u_dp_in,	// +D

	output			rcv_data_m,		// -D
	output			rcv_data_p,		// +D

	output	[7:0]	rcv_data,		// recieve data
	output			rcv_data_load,	// data latch timing
	output			rcv_data_sync,	// bit latch timing
	output	[7:0]	rcv_count,		// bit count
	output			rcv_eop,		// find eop
	output	[4:0]	rcv_crc5,		// crc5
	output			rcv_crc5_load,	// crc5 latch timing
	output	[15:0]	rcv_crc16,		// crc16
	output			rcv_crc16_load,	// crc16 latch timing
	output			rcv_bit_sync6,	// find 1x6
	output			rcv_bit,		// recieve bit
	output			rcv_bit_load,	// bit latch timing

	input			CLK12,		// 12MHz (=1.5x8)
	input			RESET_N		// #reset
);



	reg		[7:0] rcv_data_p_in_r;
	reg		[7:0] rcv_data_m_in_r;
	reg		rcv_clk_sync_lock_r;
	reg		[2:0] rcv_clk_sync_count_r;
	reg		rcv_clk_sync_r;
	reg		[2:0] rcv_bit_sync_r;
	reg		rcv_bit_sync6_r;
	reg		rcv_data_sync_r;
	reg		rcv_data_load_r;
	reg		rcv_eop_r;
	reg		[2:0] rcv_eop_sync_r;
//	reg		[7:0] rcv_byte_count_r;
	reg		[7:0] rcv_data_count_r;
	reg		[8:0] rcv_data_in_r;
	reg		[7:0] rcv_data_r;
	reg		rcv_data_pid_r;
	reg		[4:0] rcv_data_crc5_r;
	reg		[7:0] rcv_data_crc5_out_r;
	reg		rcv_data_crc5_load_r;
	reg		[15:0] rcv_data_crc16_r;
	reg		[15:0] rcv_data_crc16_out_r;
	reg		rcv_data_crc16_load_r;

	wire	[7:0] rcv_data_p_in_w;
	wire	[7:0] rcv_data_m_in_w;
	wire	rcv_clk_sync_lock_w;
	wire	[2:0] rcv_clk_sync_count_w;
	wire	rcv_clk_sync_w;
	wire	[2:0] rcv_bit_sync_w;
	wire	rcv_bit_sync6_w;
	wire	rcv_data_sync_w;
	wire	rcv_data_load_w;
	wire	rcv_eop_w;
	wire	[2:0] rcv_eop_sync_w;
//	wire	[7:0] rcv_byte_count_w;
	wire	[7:0] rcv_data_count_w;
	wire	[8:0] rcv_data_in_w;
	wire	[7:0] rcv_data_w;
	wire	rcv_data_pid_w;
	wire	[4:0] rcv_data_crc5_w;
	wire	[7:0] rcv_data_crc5_out_w;
	wire	rcv_data_crc5_load_w;
	wire	[15:0] rcv_data_crc16_w;
	wire	[15:0] rcv_data_crc16_out_w;
	wire	rcv_data_crc16_load_w;

	assign rcv_data_m=rcv_data_m_in_r[0];
	assign rcv_data_p=rcv_data_p_in_r[0];

	assign rcv_data[7:0]=rcv_data_r[7:0];
	assign rcv_data_load=rcv_data_load_r;
	assign rcv_data_sync=rcv_data_sync_r;
	assign rcv_count[7:0]=rcv_data_count_r[7:0];
	assign rcv_eop=rcv_eop_r;
	assign rcv_crc5[4:0]=rcv_data_crc5_out_r[7:3];
	assign rcv_crc5_load=rcv_data_crc5_load_r;
	assign rcv_crc16[15:0]=rcv_data_crc16_out_r[15:0];
	assign rcv_crc16_load=rcv_data_crc16_load_r;
	assign rcv_bit_sync6=rcv_bit_sync6_r;
	assign rcv_bit=rcv_data_in_r[7];
	assign rcv_bit_load=(rcv_clk_sync_count_r[2:0]==3'b100) ? 1'b1 : 1'b0;


	always @(posedge CLK12 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				rcv_data_p_in_r[7:0] <= 8'b0;
				rcv_data_m_in_r[7:0] <= 8'b0;
				rcv_clk_sync_lock_r <= 1'b0;
				rcv_clk_sync_count_r[2:0] <= 3'b0;
				rcv_clk_sync_r <= 1'b0;
				rcv_bit_sync_r[2:0] <= 3'b0;
				rcv_bit_sync6_r <= 1'b0;
			//	rcv_byte_count_r[7:0] <= 8'b0;
				rcv_data_count_r[7:0] <= 8'b0;
				rcv_data_sync_r <= 1'b0;
				rcv_data_load_r <= 1'b0;
				rcv_eop_r <= 1'b0;
				rcv_eop_sync_r[2:0] <= 3'b0;
				rcv_data_in_r[8:0] <= 9'h100;
				rcv_data_r[7:0] <= 8'h00;
				rcv_data_pid_r <= 1'b0;
				rcv_data_crc5_r[4:0] <= 5'b11111;
				rcv_data_crc5_out_r[7:0] <= 8'b0;
				rcv_data_crc5_load_r <= 1'b0;
				rcv_data_crc16_r[15:0] <= 16'hffff;
				rcv_data_crc16_out_r[15:0] <= 16'hffff;
				rcv_data_crc16_load_r <= 1'b0;
			end
		else
			begin
				rcv_data_p_in_r[7:0] <= rcv_data_p_in_w[7:0];
				rcv_data_m_in_r[7:0] <= rcv_data_m_in_w[7:0];
				rcv_clk_sync_lock_r <= rcv_clk_sync_lock_w;
				rcv_clk_sync_count_r[2:0] <= rcv_clk_sync_count_w[2:0];
				rcv_clk_sync_r <= rcv_clk_sync_w;
				rcv_bit_sync_r[2:0] <= rcv_bit_sync_w[2:0];
				rcv_bit_sync6_r <= rcv_bit_sync6_w;
			//	rcv_byte_count_r[7:0] <= rcv_byte_count_w[7:0];
				rcv_data_count_r[7:0] <= rcv_data_count_w[7:0];
				rcv_data_sync_r <= rcv_data_sync_w;
				rcv_data_load_r <= rcv_data_load_w;
				rcv_eop_r <= rcv_eop_w;
				rcv_eop_sync_r[2:0] <= rcv_eop_sync_w[2:0];
				rcv_data_in_r[8:0] <= rcv_data_in_w[8:0];
				rcv_data_r[7:0] <= rcv_data_w[7:0];
				rcv_data_pid_r <= rcv_data_pid_w;
				rcv_data_crc5_r[4:0] <= rcv_data_crc5_w[4:0];
				rcv_data_crc5_out_r[7:0] <= rcv_data_crc5_out_w[7:0];
				rcv_data_crc5_load_r <= rcv_data_crc5_load_w;
				rcv_data_crc16_r[15:0] <= rcv_data_crc16_w[15:0];
				rcv_data_crc16_out_r[15:0] <= rcv_data_crc16_out_w[15:0];
				rcv_data_crc16_load_r <= rcv_data_crc16_load_w;
			end
	end

	assign rcv_data_p_in_w[7:0]={rcv_data_p_in_r[6:0],u_dp_in};	// +D sample
	assign rcv_data_m_in_w[7:0]={rcv_data_m_in_r[6:0],u_dm_in};	// -D sample

	assign rcv_clk_sync_lock_w=
			(rcv_clk_sync_lock_r==1'b0) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[3:2]}==3'b010) & (rcv_data_in_r[7:6]==2'b00) ? 1'b1 :	// clock lock
			(rcv_clk_sync_lock_r==1'b0) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[3:2]}==3'b010) & (rcv_data_in_r[7:6]!=2'b00) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b0) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[3:2]}!=3'b010) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_bit_sync_r[2:0]==3'b111) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_bit_sync_r[2:0]!=3'b111) & (rcv_eop_r==1'b1) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_bit_sync_r[2:0]!=3'b111) & (rcv_eop_r==1'b0) ? 1'b1 :
			1'b0;

	assign rcv_clk_sync_count_w[2:0]=
			(rcv_clk_sync_lock_r==1'b0) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[3:2]}==3'b010) ? 3'b0 :
			(rcv_clk_sync_lock_r==1'b0) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[3:2]}!=3'b010) ? rcv_clk_sync_count_r[2:0]+3'b001 :
			(rcv_clk_sync_lock_r==1'b1) ? rcv_clk_sync_count_r[2:0]+3'b001 :
			3'b000;

	assign rcv_clk_sync_w=(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b000) ? 1'b1 : 1'b0;

//	wire	rcv_bit_sync6;
//	assign rcv_bit_sync6=(rcv_bit_sync_r[2:0]==3'b101) & (rcv_data_m_in_r[5]==rcv_data_in_r[8]) ? 1'b1 : 1'b0;
//	assign rcv_bit_sync6=1'b0;

	wire	rcv_bit_sync6_skip;

	assign rcv_bit_sync6_skip=(rcv_bit_sync_r[2:0]==3'b110) ? 1'b1 : 1'b0;

	assign rcv_bit_sync_w[2:0]=
			(rcv_clk_sync_lock_r==1'b0) ? 3'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_m_in_r[5]==rcv_data_in_r[8]) ? rcv_bit_sync_r[2:0]+3'b01 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_m_in_r[5]!=rcv_data_in_r[8]) ? 3'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_bit_sync_r[2:0] :
			3'b0;

	assign rcv_bit_sync6_w=
			(rcv_clk_sync_lock_r==1'b0) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b0) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b1) ? 1'b1 :
			rcv_bit_sync6_r;

//	assign rcv_byte_count_w[7:0]=
//			(rcv_clk_sync_lock_r==1'b0) ? 8'b0 :
//			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_byte_count_r[7:0] :
//			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b0) ? rcv_byte_count_r[7:0]+8'b01 :
//			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b1) ? rcv_byte_count_r[7:0] :
//			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) ? 8'b0 :
//			8'b0;

	assign rcv_data_count_w[7:0]=
			(rcv_clk_sync_lock_r==1'b0) ? 8'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_count_r[7:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b0) ? rcv_data_count_r[7:0]+8'b01 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_bit_sync6_skip==1'b1) ? rcv_data_count_r[7:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) ? 8'b0 :
			8'b0;

	assign rcv_data_sync_w=
			(rcv_clk_sync_lock_r==1'b0) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_sync_r :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) ? 1'b1 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) & (rcv_data_in_r[7:2]!=6'b1000_00) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) & (rcv_data_in_r[7:2]==6'b1000_00) ? 1'b1 :
			1'b0;

	assign rcv_data_load_w=
			(rcv_clk_sync_lock_r==1'b0) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_count_r[2:0]==3'b111) & (rcv_bit_sync6_skip==1'b0) ? 1'b1 : //!rcv_data_load_r :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_count_r[2:0]==3'b111) & (rcv_bit_sync6_skip==1'b1) ? 1'b0 : //rcv_data_load_r :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_count_r[2:0]!=3'b111) ? 1'b0 ://rcv_data_load_r :
			1'b0; //rcv_data_load_r;

	assign rcv_eop_w=
			(rcv_eop_sync_r[0]==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_m_in_r[5]==1'b1) ? 1'b1 :
			1'b0;

	assign rcv_eop_sync_w[2:0]=
			(rcv_clk_sync_count_r[2:0]==3'b100) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[5]}==2'b00) ? {rcv_eop_sync_r[1:0],1'b1} :
			(rcv_clk_sync_count_r[2:0]==3'b100) & ({rcv_data_p_in_r[5],rcv_data_m_in_r[5]}!=2'b00) ? {rcv_eop_sync_r[1:0],1'b0} :
			rcv_eop_sync_r[2:0];

	assign rcv_data_in_w[8]=
			(rcv_clk_sync_count_r[2:0]==3'b100) ? rcv_data_m_in_r[5] :
			rcv_data_in_r[8];

	assign rcv_data_in_w[7:0]=
			(rcv_bit_sync6_skip==1'b0) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_m_in_r[5]==rcv_data_in_r[8]) ? {1'b1,rcv_data_in_r[7:1]} :
			(rcv_bit_sync6_skip==1'b0) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_m_in_r[5]!=rcv_data_in_r[8]) ? {1'b0,rcv_data_in_r[7:1]} :
			(rcv_bit_sync6_skip==1'b1) ? rcv_data_in_r[7:0] :
			rcv_data_in_r[7:0];

	assign rcv_data_w[7:0]=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_data_count_r[2:0]==3'b111) & (rcv_bit_sync6_skip==1'b0) ? rcv_data_in_r[7:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) ? 8'h80 :
			rcv_data_r[7:0];

	assign rcv_data_pid_w=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b1) & (rcv_data_count_r[2:0]==3'b111) & (rcv_bit_sync6_skip==1'b0) ? 1'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_sync_r==1'b0) ? 1'b1 :
			rcv_data_pid_r;

	wire	[4:0] rcv_data_crc5_tmp;
	wire	[4:0] rcv_data_crc5_out_tmp;

	assign rcv_data_crc5_tmp[0]=rcv_data_crc5_r[4] ^ rcv_data_in_r[7];
	assign rcv_data_crc5_tmp[1]=rcv_data_crc5_r[0];
	assign rcv_data_crc5_tmp[2]=rcv_data_crc5_r[1] ^ rcv_data_in_r[7] ^ rcv_data_crc5_r[4];
	assign rcv_data_crc5_tmp[3]=rcv_data_crc5_r[2];
	assign rcv_data_crc5_tmp[4]=rcv_data_crc5_r[3];

	assign rcv_data_crc5_w[4:0]=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b1) ? 5'b11111 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_bit_sync6_r!=1'b1) ? rcv_data_crc5_tmp[4:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_bit_sync6_r==1'b1) ? rcv_data_crc5_r[4:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_crc5_r[4:0] :
			(rcv_clk_sync_lock_r==1'b0) ? 5'b11111 :
			5'b11111;

	assign rcv_data_crc5_out_tmp[4:0]={!rcv_data_crc5_r[0],!rcv_data_crc5_r[1],!rcv_data_crc5_r[2],!rcv_data_crc5_r[3],!rcv_data_crc5_r[4]};

	assign rcv_data_crc5_out_w[7:0]=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b1) ? 8'b0 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[7:0]==8'h13) ? {rcv_data_crc5_out_tmp[4:0],3'b0} :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[7:0]!=8'h13) ? rcv_data_crc5_out_r[7:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_crc5_out_r[7:0] :
			(rcv_clk_sync_lock_r==1'b0) ? rcv_data_crc5_out_r[7:0] :
			8'b0;

	assign rcv_data_crc5_load_w=(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[7:0]==8'h13) ? 1'b1 :1'b0;

	wire	[15:0] rcv_data_crc16_tmp;
	wire	[15:0] rcv_data_crc16_out_tmp;

	assign rcv_data_crc16_tmp[0]=rcv_data_crc16_r[15] ^ rcv_data_in_r[7];
	assign rcv_data_crc16_tmp[1]=rcv_data_crc16_r[0];
	assign rcv_data_crc16_tmp[2]=rcv_data_crc16_r[1] ^ rcv_data_in_r[7] ^ rcv_data_crc16_r[15];
	assign rcv_data_crc16_tmp[3]=rcv_data_crc16_r[2];
	assign rcv_data_crc16_tmp[4]=rcv_data_crc16_r[3];
	assign rcv_data_crc16_tmp[5]=rcv_data_crc16_r[4];
	assign rcv_data_crc16_tmp[6]=rcv_data_crc16_r[5];
	assign rcv_data_crc16_tmp[7]=rcv_data_crc16_r[6];
	assign rcv_data_crc16_tmp[8]=rcv_data_crc16_r[7];
	assign rcv_data_crc16_tmp[9]=rcv_data_crc16_r[8];
	assign rcv_data_crc16_tmp[10]=rcv_data_crc16_r[9];
	assign rcv_data_crc16_tmp[11]=rcv_data_crc16_r[10];
	assign rcv_data_crc16_tmp[12]=rcv_data_crc16_r[11];
	assign rcv_data_crc16_tmp[13]=rcv_data_crc16_r[12];
	assign rcv_data_crc16_tmp[14]=rcv_data_crc16_r[13];
	assign rcv_data_crc16_tmp[15]=rcv_data_crc16_r[14] ^ rcv_data_in_r[7] ^ rcv_data_crc16_r[15];

	assign rcv_data_crc16_w[15:0]=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b1) ? 5'b11111 :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_bit_sync6_r!=1'b1) ? rcv_data_crc16_tmp[4:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_bit_sync6_r==1'b1) ? rcv_data_crc16_r[4:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_crc16_r[15:0] :
			(rcv_clk_sync_lock_r==1'b0) ? 16'hffff :
			16'hffff;

	assign rcv_data_crc16_out_tmp[15:12]={!rcv_data_crc16_r[0],!rcv_data_crc16_r[1],!rcv_data_crc16_r[2],!rcv_data_crc16_r[3]};
	assign rcv_data_crc16_out_tmp[11:8]={!rcv_data_crc16_r[4],!rcv_data_crc16_r[5],!rcv_data_crc16_r[6],!rcv_data_crc16_r[7]};
	assign rcv_data_crc16_out_tmp[7:4]={!rcv_data_crc16_r[8],!rcv_data_crc16_r[9],!rcv_data_crc16_r[10],!rcv_data_crc16_r[11]};
	assign rcv_data_crc16_out_tmp[3:0]={!rcv_data_crc16_r[12],!rcv_data_crc16_r[13],!rcv_data_crc16_r[14],!rcv_data_crc16_r[15]};

	assign rcv_data_crc16_out_w[15:0]=
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b1) ? 16'hffff :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[2:0]==3'b001) ? rcv_data_crc16_out_tmp[15:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[2:0]!=3'b001) ? rcv_data_crc16_out_r[15:0] :
			(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]!=3'b100) ? rcv_data_crc16_out_r[15:0] :
			(rcv_clk_sync_lock_r==1'b0) ? rcv_data_crc16_out_r[15:0] :
			16'hffff;

	assign rcv_data_crc16_load_w=(rcv_clk_sync_lock_r==1'b1) & (rcv_clk_sync_count_r[2:0]==3'b100) & (rcv_data_pid_r==1'b0) & (rcv_data_count_r[2:0]==3'b001) ? 1'b1 :1'b0;

endmodule

