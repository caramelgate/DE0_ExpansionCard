//-----------------------------------------------------------------------------
//
//  low_snd.v : lowspeed send top module
//
//  LICENSE : as-is
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/jun/21 release 0.0  connection test
//
//------------------------------------------------------------------------------

module low_snd #(
	parameter	count1ms=1500,		// 1ms:1.5MHz
	parameter	busreset=10			// reset 10ms
) (
	output			u_dm_out,		// -D
	output			u_dm_oe,		// -D oe
	output			u_dp_out,		// +D
	output			u_dp_oe,		// +D oe

	output			tick,			// count 8clk
	output			tick1ms,		// count 1ms

	input	[1:0]	snd_cmd,		// command token/data/handshake/special
	input			snd_cmd_req,	// command req
	output			snd_cmd_ack,	// command ack

	input	[3:0]	snd_pid,		// pid
	input	[7:0]	snd_len,		// data length
	input	[63:0]	snd_data,		// send data

	input			CLK12,			// 12MHz (=1.5x8)
	input			RESET_N			// #reset
);


//	snd_cmd + sndpid
//		01_1101 : token setup
//		01_0101 : token sof
//		01_1001 : token in
//		01_0001 : token out
//		11_1111 : data mdata
//		11_0111 : data data2
//		11_1011 : data data1
//		11_0011 : data data0
//		10_0110 : handshake nyet
//		10_1110 : handshake stall
//		10_1010 : handshake nak
//		10_0010 : handshake ack
//		00_0100 : special ping
//		00_1000 : special split
//		00_1100 : special err
//		00_1100 : special pre
//		00_0000 : busfunction reset
//		00_0001 : busfunction eop(tick)


	reg		[79:0] snd_byte_data_r;
	reg		[2:0] snd_bit_count_r;
	reg		[7:0] snd_byte_count_r;

	reg		snd_data_p_out_r;
	reg		snd_data_p_oe_r;
	reg		snd_data_m_out_r;
	reg		snd_data_m_oe_r;
	reg		snd_clk_r;
	reg		[2:0] snd_clk_count_r;
	reg		snd_1ms_r;
	reg		[11:0] snd_1ms_count_r;
	reg		[4:0] snd_data_crc5_r;
	reg		[4:0] snd_data_crc5_out_r;
	reg		[15:0] snd_data_crc16_r;
	reg		[15:0] snd_data_crc16_out_r;

	wire	[79:0] snd_byte_data_w;
	wire	[2:0] snd_bit_count_w;
	wire	[7:0] snd_byte_count_w;

	wire	snd_data_p_out_w;
	wire	snd_data_p_oe_w;
	wire	snd_data_m_out_w;
	wire	snd_data_m_oe_w;
	wire	snd_clk_w;
	wire	[2:0] snd_clk_count_w;
	wire	snd_1ms_w;
	wire	[11:0] snd_1ms_count_w;
	wire	[4:0] snd_data_crc5_w;
	wire	[4:0] snd_data_crc5_out_w;
	wire	[15:0] snd_data_crc16_w;
	wire	[15:0] snd_data_crc16_out_w;

	reg		[3:0] snd_state_r;
	reg		[7:0] snd_count_r;
	reg		snd_count_done_r;
	reg		snd_cmd_ack_r;

	wire	[3:0] snd_state_w;
	wire	[7:0] snd_count_w;
	wire	snd_count_done_w;
	wire	snd_cmd_ack_w;

	assign u_dm_out=snd_data_m_out_r;
	assign u_dm_oe=snd_data_m_oe_r;
	assign u_dp_out=snd_data_p_out_r;
	assign u_dp_oe=snd_data_p_oe_r;

	assign tick=snd_clk_r;
	assign tick1ms=snd_1ms_r;

	assign snd_cmd_ack=snd_cmd_ack_r;

	always @(posedge CLK12 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				snd_clk_r <= 1'b0;
				snd_clk_count_r[2:0] <= 3'b0;
				snd_1ms_r <= 1'b0;
				snd_1ms_count_r[11:0] <= 12'b0;

				snd_state_r[3:0] <= 4'b0;
				snd_count_r[7:0] <= 8'b0;
				snd_count_done_r <= 1'b0;
				snd_cmd_ack_r <= 1'b0;

				snd_byte_data_r[79:0] <= 80'b0;
				snd_bit_count_r[2:0] <= 3'b0;
				snd_byte_count_r[7:0] <= 8'b0;

				snd_data_crc5_r[4:0] <= 5'b11111;
				snd_data_crc5_out_r[4:0] <= 5'b11111;
				snd_data_crc16_r[15:0] <= 16'hffff;
				snd_data_crc16_out_r[15:0] <= 16'h0000;

				snd_data_p_out_r <= 1'b0;
				snd_data_p_oe_r <= 1'b0;
				snd_data_m_out_r <= 1'b0;
				snd_data_m_oe_r <= 1'b0;
			end
		else
			begin
				snd_clk_r <= snd_clk_w;
				snd_clk_count_r[2:0] <= snd_clk_count_w[2:0];
				snd_1ms_r <= snd_1ms_w;
				snd_1ms_count_r[11:0] <= snd_1ms_count_w[11:0];

				snd_state_r[3:0] <= snd_state_w[3:0];
				snd_count_r[7:0] <= snd_count_w[7:0];
				snd_count_done_r <= snd_count_done_w;
				snd_cmd_ack_r <= snd_cmd_ack_w;

				snd_byte_data_r[79:0] <= snd_byte_data_w[79:0];
				snd_bit_count_r[2:0] <= snd_bit_count_w[2:0];
				snd_byte_count_r[7:0] <= snd_byte_count_w[7:0];

				snd_data_crc5_r[4:0] <= snd_data_crc5_w[4:0];
				snd_data_crc5_out_r[4:0] <= snd_data_crc5_out_w[4:0];
				snd_data_crc16_r[15:0] <= snd_data_crc16_w[15:0];
				snd_data_crc16_out_r[15:0] <= snd_data_crc16_out_w[15:0];

				snd_data_p_out_r <= snd_data_p_out_w;
				snd_data_p_oe_r <= snd_data_p_oe_w;
				snd_data_m_out_r <= snd_data_m_out_w;
				snd_data_m_oe_r <= snd_data_m_oe_w;
			end
	end

	assign snd_clk_w=(snd_clk_count_r[2:0]==3'b111) ? 1'b1 : 1'b0;
	assign snd_clk_count_w[2:0]=snd_clk_count_r[2:0]+3'b01;

	assign snd_1ms_w=
			(snd_clk_r==1'b0) ? snd_1ms_r :
			(snd_clk_r==1'b1) & (snd_1ms_count_r[11:0]!=count1ms-1) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_1ms_count_r[11:0]==count1ms-1) ? 1'b1 :
			1'b0;

	assign snd_1ms_count_w[11:0]=
			(snd_clk_r==1'b0) ? snd_1ms_count_r[11:0] :
			(snd_clk_r==1'b1) & (snd_1ms_count_r[11:0]!=count1ms-1) ? snd_1ms_count_r[11:0]+12'b01 :
			(snd_clk_r==1'b1) & (snd_1ms_count_r[11:0]==count1ms-1) ? 12'b0 :
			12'b0;


	wire	snd_bit_count6;
	wire	snd_bit_token_crc5;
	wire	snd_bit_token_crc5_load;
	wire	snd_bit_token_end;
	wire	snd_bit_data_crc16;
	wire	snd_bit_data_crc16_load;
	wire	snd_bit_data_end;
	wire	snd_bit_handshake_crc5;	// dummy
	wire	snd_bit_handshake_end;

	assign snd_bit_count6=(snd_bit_count_r[2:0]==3'b110) ? 1'b1 : 1'b0;

	assign snd_bit_token_crc5=(snd_byte_count_r[7:0]==8'd26) ? 1'b1 : 1'b0;
	assign snd_bit_token_crc5_load=(snd_byte_count_r[7:0]==8'd11) ? 1'b1 : 1'b0;
	assign snd_bit_token_end=(snd_byte_count_r[7:0]==8'd31) ? 1'b1 : 1'b0;
	assign snd_bit_data_crc16=(snd_byte_count_r[7:0]==({snd_len[4:0],3'b0}+8'd16-8'd1)) ? 1'b1 : 1'b0;
	assign snd_bit_data_crc16_load=(snd_byte_count_r[7:0]==({snd_len[4:0],3'b0}+8'd16-8'd1-8'd15)) ? 1'b1 : 1'b0;
	assign snd_bit_data_end=(snd_byte_count_r[7:0]==({snd_len[4:0],3'b0}+8'd16+8'd16-8'd1)) ? 1'b1 : 1'b0;
	assign snd_bit_handshake_crc5=snd_bit_handshake_end;
	assign snd_bit_handshake_end=(snd_byte_count_r[7:0]==8'd15) ? 1'b1 : 1'b0;

	assign snd_state_w[3:0]=
			(snd_clk_r==1'b0) ? snd_state_r[3:0] :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b0) ? 4'b0000 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) & (snd_cmd[1:0]==2'b00) & (snd_pid[1:0]==2'b00) ? 4'b0001 :	// reset
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) & (snd_cmd[1:0]==2'b00) & (snd_pid[1:0]==2'b01) ? 4'b0011 :	// eop(tick)
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) & (snd_cmd[1:0]==2'b01) ? 4'b0100 :	// token
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) & (snd_cmd[1:0]==2'b11) ? 4'b1100 :	// data
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) & (snd_cmd[1:0]==2'b10) ? 4'b1000 :	// handshake

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b0) ? 4'b0001 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b1) ? 4'b0010 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b0) ? 4'b0011 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b1) ? 4'b0010 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0010) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b0) ? 4'b0100 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b1) & (snd_bit_count6==1'b1) ? 4'b0100 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b1) & (snd_bit_count6==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_token_end==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_token_end==1'b1) ? 4'b0111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b0) ? 4'b0111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b1) ? 4'b0110 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b0) ? 4'b1100 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b1) & (snd_bit_count6==1'b1) ? 4'b1100 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b1) & (snd_bit_count6==1'b0) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_data_end==1'b0) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_data_end==1'b1) ? 4'b1111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b0) ? 4'b1111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b1) ? 4'b1110 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_end==1'b0) ? 4'b1000 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_end==1'b1) & (snd_bit_count6==1'b1) ? 4'b1000:
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_end==1'b1) & (snd_bit_count6==1'b0) ? 4'b1011 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_handshake_end==1'b0) ? 4'b1001 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_handshake_end==1'b1) ? 4'b1011 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b0) ? 4'b1011 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b1) ? 4'b1010 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 4'b0000 :

			4'b0000;

	assign snd_count_w[7:0]=
			(snd_clk_r==1'b0) ? snd_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_1ms_r==1'b0) ? snd_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_1ms_r==1'b1) ? snd_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) ? snd_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0010) ? 8'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? snd_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 8'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? snd_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 8'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) ? snd_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 8'b0 :
			8'b0;

	assign snd_count_done_w=
			(snd_clk_r==1'b0) ? snd_count_done_r :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_1ms_r==1'b1) & (snd_count_r[7:0]==busreset-1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_r[7:0]==8'b01) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_r[7:0]==8'b01) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_r[7:0]==8'b01) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_r[7:0]==8'b01) ? 1'b1 :
			1'b0;

	assign snd_cmd_ack_w=
			(snd_clk_r==1'b0) ? snd_cmd_ack_r :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b0) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b0) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0010) ? 1'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b0) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 1'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b0) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 1'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b0) ? 1'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b1) ? 1'b1 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 1'b0 :
			1'b0;

	assign snd_byte_data_w[79:0]=
			(snd_clk_r==1'b0) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? {snd_data[63:0],!snd_pid[3],!snd_pid[2],!snd_pid[1],!snd_pid[0],snd_pid[3:0],8'h80} :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b0) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b0) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b1) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_token_crc5==1'b1) & (snd_bit_count6==1'b0) ? {74'b0,snd_data_crc5_out_r[4:0]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? 80'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 80'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b0) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b0) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b1) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_data_crc16==1'b1) & (snd_bit_count6==1'b0) ? {64'b0,snd_data_crc16_out_r[15:0]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? 80'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 80'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_crc5==1'b0) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_crc5==1'b0) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_crc5==1'b1) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_handshake_crc5==1'b1) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b1) ? snd_byte_data_r[79:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b0) ? {1'b0,snd_byte_data_r[79:1]} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) ? 80'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 80'b0 :

			80'b0;

	assign snd_bit_count_w[2:0]=
			(snd_clk_r==1'b0) ? snd_bit_count_r[2:0] :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 3'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 3'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_byte_data_r[0]==1'b0) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]==2'b11) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_byte_data_r[0]==1'b1) & (snd_bit_count_r[2:1]!=2'b11) ? snd_bit_count_r[2:0]+3'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) ? 3'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 3'b0 :
			3'b0;

	assign snd_byte_count_w[7:0]=
			(snd_clk_r==1'b0) ? snd_byte_count_r[7:0] :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 8'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 8'b0 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) ? 8'b0 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 8'b0 :
			8'b0;

	wire	[4:0] snd_data_crc5_tmp;
	wire	[4:0] snd_data_crc5_out_tmp;

	assign snd_data_crc5_tmp[0]=snd_data_crc5_r[4] ^ snd_byte_data_r[16];
	assign snd_data_crc5_tmp[1]=snd_data_crc5_r[0];
	assign snd_data_crc5_tmp[2]=snd_data_crc5_r[1] ^ snd_byte_data_r[16] ^ snd_data_crc5_r[4];
	assign snd_data_crc5_tmp[3]=snd_data_crc5_r[2];
	assign snd_data_crc5_tmp[4]=snd_data_crc5_r[3];

	assign snd_data_crc5_w[4:0]=
			(snd_clk_r==1'b0) ? snd_data_crc5_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 5'b11111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count_r[2:1]==2'b11) ? snd_data_crc5_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count_r[2:1]!=2'b11) ? snd_data_crc5_tmp[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) ? snd_data_crc5_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? snd_data_crc5_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? snd_data_crc5_r[4:0] :
			5'b11111;

	assign snd_data_crc5_out_tmp[4:0]={!snd_data_crc5_r[0],!snd_data_crc5_r[1],!snd_data_crc5_r[2],!snd_data_crc5_r[3],!snd_data_crc5_r[4]};

	assign snd_data_crc5_out_w[4:0]=
			(snd_clk_r==1'b0) ? snd_data_crc5_out_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 5'b11111 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count_r[2:1]==2'b11) ? snd_data_crc5_out_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count_r[2:1]!=2'b11) & (snd_bit_token_crc5_load==1'b1) ? snd_data_crc5_out_tmp[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count_r[2:1]!=2'b11) & (snd_bit_token_crc5_load==1'b0) ? snd_data_crc5_out_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) ? snd_data_crc5_out_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) ? snd_data_crc5_out_r[4:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? snd_data_crc5_out_r[4:0] :
			5'b11111;

	wire	[15:0] snd_data_crc16_tmp;
	wire	[15:0] snd_data_crc16_out_tmp;

	assign snd_data_crc16_tmp[0]=snd_data_crc16_r[15] ^ snd_byte_data_r[16];
	assign snd_data_crc16_tmp[1]=snd_data_crc16_r[0];
	assign snd_data_crc16_tmp[2]=snd_data_crc16_r[1] ^ snd_byte_data_r[16] ^ snd_data_crc16_r[15];
	assign snd_data_crc16_tmp[3]=snd_data_crc16_r[2];
	assign snd_data_crc16_tmp[4]=snd_data_crc16_r[3];
	assign snd_data_crc16_tmp[5]=snd_data_crc16_r[4];
	assign snd_data_crc16_tmp[6]=snd_data_crc16_r[5];
	assign snd_data_crc16_tmp[7]=snd_data_crc16_r[6];
	assign snd_data_crc16_tmp[8]=snd_data_crc16_r[7];
	assign snd_data_crc16_tmp[9]=snd_data_crc16_r[8];
	assign snd_data_crc16_tmp[10]=snd_data_crc16_r[9];
	assign snd_data_crc16_tmp[11]=snd_data_crc16_r[10];
	assign snd_data_crc16_tmp[12]=snd_data_crc16_r[11];
	assign snd_data_crc16_tmp[13]=snd_data_crc16_r[12];
	assign snd_data_crc16_tmp[14]=snd_data_crc16_r[13];
	assign snd_data_crc16_tmp[15]=snd_data_crc16_r[14] ^ snd_byte_data_r[16] ^ snd_data_crc16_r[15];

	assign snd_data_crc16_w[15:0]=
			(snd_clk_r==1'b0) ? snd_data_crc16_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 16'hffff :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count_r[2:1]==2'b11) ? snd_data_crc16_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count_r[2:1]!=2'b11) ? snd_data_crc16_tmp[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) ? snd_data_crc16_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? snd_data_crc16_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? snd_data_crc16_r[15:0] :
			16'hffff;

	assign snd_data_crc16_out_tmp[15:12]={!snd_data_crc16_r[0],!snd_data_crc16_r[1],!snd_data_crc16_r[2],!snd_data_crc16_r[3]};
	assign snd_data_crc16_out_tmp[11:8]={!snd_data_crc16_r[4],!snd_data_crc16_r[5],!snd_data_crc16_r[6],!snd_data_crc16_r[7]};
	assign snd_data_crc16_out_tmp[7:4]={!snd_data_crc16_r[8],!snd_data_crc16_r[9],!snd_data_crc16_r[10],!snd_data_crc16_r[11]};
	assign snd_data_crc16_out_tmp[3:0]={!snd_data_crc16_r[12],!snd_data_crc16_r[13],!snd_data_crc16_r[14],!snd_data_crc16_r[15]};

	assign snd_data_crc16_out_w[15:0]=
			(snd_clk_r==1'b0) ? snd_data_crc16_out_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) ? 16'h0000 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count_r[2:1]==2'b11) ? snd_data_crc16_out_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count_r[2:1]!=2'b11) & (snd_bit_data_crc16_load==1'b1) ? snd_data_crc16_out_tmp[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count_r[2:1]!=2'b11) & (snd_bit_data_crc16_load==1'b0) ? snd_data_crc16_out_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) ? snd_data_crc16_out_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) ? snd_data_crc16_out_r[15:0] :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? snd_data_crc16_out_r[15:0] :
			16'h0000;

	assign {snd_data_m_out_w,snd_data_m_oe_w,snd_data_p_out_w,snd_data_p_oe_w}=
			(snd_clk_r==1'b0) ? {snd_data_m_out_r,snd_data_m_oe_r,snd_data_p_out_r,snd_data_p_oe_r} :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b0) ? 4'b0000 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0000) & (snd_cmd_req==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0001) & (snd_count_done_r==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0011) & (snd_count_done_r==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0010) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0100) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0101) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0111) & (snd_count_done_r==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b0110) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1100) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1101) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1111) & (snd_count_done_r==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1110) ? 4'b0000 :

			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1000) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b0) ? {snd_data_m_out_r ^ !snd_byte_data_r[0],1'b1,!(snd_data_m_out_r ^ !snd_byte_data_r[0]),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1001) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b0) ? 4'b0101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b0) & (snd_bit_count6==1'b1) ? {snd_data_m_out_r ^ 1'b1,1'b1,!(snd_data_m_out_r ^ 1'b1),1'b1} :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1011) & (snd_count_done_r==1'b1) ? 4'b1101 :
			(snd_clk_r==1'b1) & (snd_state_r[3:0]==4'b1010) ? 4'b0000 :
			4'b0000;


endmodule

/*
	reg		[7:0] snd_data_p_in_r;
	reg		[7:0] snd_data_m_in_r;
	reg		snd_clk_sync_lock_r;
	reg		[2:0] snd_clk_sync_count_r;
	reg		snd_clk_sync_r;
	reg		[2:0] snd_bit_sync_r;
	reg		snd_bit_sync6_r;
	reg		snd_data_sync_r;
	reg		snd_data_load_r;
	reg		snd_eop_r;
	reg		[2:0] snd_eop_sync_r;
	reg		[7:0] snd_byte_count_r;
	reg		[3:0] snd_data_count_r;
	reg		[8:0] snd_data_in_r;
	reg		[7:0] snd_data_r;
	reg		snd_data_pid_r;

	wire	[7:0] snd_data_p_in_w;
	wire	[7:0] snd_data_m_in_w;
	wire	snd_clk_sync_lock_w;
	wire	[2:0] snd_clk_sync_count_w;
	wire	snd_clk_sync_w;
	wire	[2:0] snd_bit_sync_w;
	wire	snd_bit_sync6_w;
	wire	snd_data_sync_w;
	wire	snd_data_load_w;
	wire	snd_eop_w;
	wire	[2:0] snd_eop_sync_w;
	wire	[7:0] snd_byte_count_w;
	wire	[3:0] snd_data_count_w;
	wire	[8:0] snd_data_in_w;
	wire	[7:0] snd_data_w;
	wire	snd_data_pid_w;

	assign snd_data[7:0]=snd_data_r[7:0];
	assign snd_data_load=snd_data_load_r;
	assign snd_data_sync=snd_data_sync_r;
	assign snd_eop=snd_eop_r;
	assign snd_crc5[4:0]=snd_data_crc5_out_r[7:3];
	assign snd_crc5_load=snd_data_crc5_load_r;
	assign snd_crc16[15:0]=snd_data_crc16_out_r[15:0];
	assign snd_crc16_load=snd_data_crc16_load_r;
	assign snd_bit_sync6=snd_bit_sync6_r;
	assign snd_bit=snd_data_in_r[7];
	assign snd_bit_load=(snd_clk_sync_count_r[2:0]==3'b100) ? 1'b1 : 1'b0;


	always @(posedge CLK12 or negedge RESET_N)
	begin
		if (RESET_N==1'b0)
			begin
				snd_data_p_in_r[7:0] <= 8'b0;
				snd_data_m_in_r[7:0] <= 8'b0;
				snd_clk_sync_lock_r <= 1'b0;
				snd_clk_sync_count_r[2:0] <= 3'b0;
				snd_clk_sync_r <= 1'b0;
				snd_bit_sync_r[2:0] <= 3'b0;
				snd_bit_sync6_r <= 1'b0;
				snd_byte_count_r[7:0] <= 8'b0;
				snd_data_count_r[3:0] <= 4'b0;
				snd_data_sync_r <= 1'b0;
				snd_data_load_r <= 1'b0;
				snd_eop_r <= 1'b0;
				snd_eop_sync_r[2:0] <= 3'b0;
				snd_data_in_r[8:0] <= 9'h100;
				snd_data_r[7:0] <= 8'h00;
				snd_data_pid_r <= 1'b0;
			end
		else
			begin
				snd_data_p_in_r[7:0] <= snd_data_p_in_w[7:0];
				snd_data_m_in_r[7:0] <= snd_data_m_in_w[7:0];
				snd_clk_sync_lock_r <= snd_clk_sync_lock_w;
				snd_clk_sync_count_r[2:0] <= snd_clk_sync_count_w[2:0];
				snd_clk_sync_r <= snd_clk_sync_w;
				snd_bit_sync_r[2:0] <= snd_bit_sync_w[2:0];
				snd_bit_sync6_r <= snd_bit_sync6_w;
				snd_byte_count_r[7:0] <= snd_byte_count_w[7:0];
				snd_data_count_r[3:0] <= snd_data_count_w[3:0];
				snd_data_sync_r <= snd_data_sync_w;
				snd_data_load_r <= snd_data_load_w;
				snd_eop_r <= snd_eop_w;
				snd_eop_sync_r[2:0] <= snd_eop_sync_w[2:0];
				snd_data_in_r[8:0] <= snd_data_in_w[8:0];
				snd_data_r[7:0] <= snd_data_w[7:0];
				snd_data_pid_r <= snd_data_pid_w;
			end
	end

	assign snd_data_p_in_w[7:0]={snd_data_p_in_r[6:0],u_dp_in};	// +D sample
	assign snd_data_m_in_w[7:0]={snd_data_m_in_r[6:0],u_dm_in};	// -D sample

	assign snd_clk_sync_lock_w=
			(snd_clk_sync_lock_r==1'b0) & ({snd_data_p_in_r[5],snd_data_m_in_r[3:2]}==3'b010) & (snd_data_in_r[7:6]==2'b00) ? 1'b1 :	// clock lock
			(snd_clk_sync_lock_r==1'b0) & ({snd_data_p_in_r[5],snd_data_m_in_r[3:2]}==3'b010) & (snd_data_in_r[7:6]!=2'b00) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b0) & ({snd_data_p_in_r[5],snd_data_m_in_r[3:2]}!=3'b010) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_bit_sync_r[2:0]==3'b111) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_bit_sync_r[2:0]!=3'b111) & (snd_eop_r==1'b1) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_bit_sync_r[2:0]!=3'b111) & (snd_eop_r==1'b0) ? 1'b1 :
			1'b0;

	assign snd_clk_sync_count_w[2:0]=
			(snd_clk_sync_lock_r==1'b0) & ({snd_data_p_in_r[5],snd_data_m_in_r[3:2]}==3'b010) ? 3'b0 :
			(snd_clk_sync_lock_r==1'b0) & ({snd_data_p_in_r[5],snd_data_m_in_r[3:2]}!=3'b010) ? snd_clk_sync_count_r[2:0]+3'b001 :
			(snd_clk_sync_lock_r==1'b1) ? snd_clk_sync_count_r[2:0]+3'b001 :
			3'b000;

	assign snd_clk_sync_w=(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b000) ? 1'b1 : 1'b0;

//	wire	snd_bit_sync6;
//	assign snd_bit_sync6=(snd_bit_sync_r[2:0]==3'b101) & (snd_data_m_in_r[5]==snd_data_in_r[8]) ? 1'b1 : 1'b0;
//	assign snd_bit_sync6=1'b0;

	wire	snd_bit_sync6_skip;

	assign snd_bit_sync6_skip=(snd_bit_sync_r[2:0]==3'b110) ? 1'b1 : 1'b0;

	assign snd_bit_sync_w[2:0]=
			(snd_clk_sync_lock_r==1'b0) ? 3'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_m_in_r[5]==snd_data_in_r[8]) ? snd_bit_sync_r[2:0]+3'b01 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_m_in_r[5]!=snd_data_in_r[8]) ? 3'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]!=3'b100) ? snd_bit_sync_r[2:0] :
			3'b0;

	assign snd_bit_sync6_w=
			(snd_clk_sync_lock_r==1'b0) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b0) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b1) ? 1'b1 :
			snd_bit_sync6_r;

	assign snd_byte_count_w[7:0]=
			(snd_clk_sync_lock_r==1'b0) ? 8'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]!=3'b100) ? snd_byte_count_r[7:0] :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b0) ? snd_byte_count_r[7:0]+8'b01 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b1) ? snd_byte_count_r[7:0] :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) ? 8'b0 :
			8'b0;

	assign snd_data_count_w[3:0]=
			(snd_clk_sync_lock_r==1'b0) ? 4'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]!=3'b100) ? snd_data_count_r[3:0] :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b0) ? snd_data_count_r[3:0]+4'b01 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_bit_sync6_skip==1'b1) ? snd_data_count_r[3:0] :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) ? 4'b0 :
			4'b0;

	assign snd_data_sync_w=
			(snd_clk_sync_lock_r==1'b0) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]!=3'b100) ? snd_data_sync_r :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) ? 1'b1 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) & (snd_data_in_r[7:2]!=6'b1000_00) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) & (snd_data_in_r[7:2]==6'b1000_00) ? 1'b1 :
			1'b0;

	assign snd_data_load_w=
			(snd_clk_sync_lock_r==1'b0) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_count_r[2:0]==3'b111) & (snd_bit_sync6_skip==1'b0) ? 1'b1 : //!snd_data_load_r :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_count_r[2:0]==3'b111) & (snd_bit_sync6_skip==1'b1) ? 1'b0 : //snd_data_load_r :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_count_r[2:0]!=3'b111) ? 1'b0 ://snd_data_load_r :
			1'b0; //snd_data_load_r;

	assign snd_eop_w=
			(snd_eop_sync_r[1:0]==2'b11) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_m_in_r[5]==1'b1) ? 1'b1 :
			1'b0;

	assign snd_eop_sync_w[2:0]=
			(snd_clk_sync_count_r[2:0]==3'b100) & ({snd_data_p_in_r[5],snd_data_m_in_r[5]}==2'b00) ? {snd_eop_sync_r[1:0],1'b1} :
			(snd_clk_sync_count_r[2:0]==3'b100) & ({snd_data_p_in_r[5],snd_data_m_in_r[5]}!=2'b00) ? {snd_eop_sync_r[1:0],1'b0} :
			snd_eop_sync_r[2:0];

	assign snd_data_in_w[8]=
			(snd_clk_sync_count_r[2:0]==3'b100) ? snd_data_m_in_r[5] :
			snd_data_in_r[8];

	assign snd_data_in_w[7:0]=
			(snd_bit_sync6_skip==1'b0) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_m_in_r[5]==snd_data_in_r[8]) ? {1'b1,snd_data_in_r[7:1]} :
			(snd_bit_sync6_skip==1'b0) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_m_in_r[5]!=snd_data_in_r[8]) ? {1'b0,snd_data_in_r[7:1]} :
			(snd_bit_sync6_skip==1'b1) ? snd_data_in_r[7:0] :
			snd_data_in_r[7:0];

	assign snd_data_w[7:0]=
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_data_count_r[2:0]==3'b111) & (snd_bit_sync6_skip==1'b0) ? snd_data_in_r[7:0] :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) ? 8'h80 :
			snd_data_r[7:0];

	assign snd_data_pid_w=
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b1) & (snd_data_count_r[2:0]==3'b111) & (snd_bit_sync6_skip==1'b0) ? 1'b0 :
			(snd_clk_sync_lock_r==1'b1) & (snd_clk_sync_count_r[2:0]==3'b100) & (snd_data_sync_r==1'b0) ? 1'b1 :
			snd_data_pid_r;


*/
