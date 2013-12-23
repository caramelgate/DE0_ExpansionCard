// UKP
// version 1.0

//`define DEBUG

module ukp(
//	clk, 
//	vcoclk, 
	input			usbclk,			// clk 12MHz
	input			reset_n,		// #reset
//	vtune, 
//	clk_out, 
	inout			usb_dm,
	inout			usb_dp,
//	output			record_n,

	output	[7:0]	rcv_data,
	output	[7:0]	rcv_addr,
	output	[7:0]	rcv_req,
	output			rcv_connected,

	output	[7:0]	data0,
	output	[7:0]	data1,
	output	[7:0]	data2,
	output	[7:0]	data3,
	output	[7:0]	data4,
	output	[7:0]	data5,
	output	[7:0]	data6,
	output	[7:0]	data7,
	output	[7:0]	data8,
	output	[7:0]	data9,
	output	[7:0]	data10,
	output	[7:0]	data11,
	output	[7:0]	data12,
	output	[7:0]	data13,
	output	[7:0]	data14,
	output	[7:0]	data15,

	output	[7:0]	data_out,		// debug
	output			usb_dm_out,		// debug
	output			usb_dm_oe,		// debug
	output			usb_dm_in,		// debug
	output			usb_dp_out,		// debug
	output			usb_dp_oe,		// debug
	output			usb_dp_in,		// debug
	output			sample_out,		// debug
	output			ins_out,		// debug
	output			timing_out		// debug

//`ifdef DEBUG
//	sclk, sdata
//`else
//	kbd_adr, kbd_data
//`endif
);
//	input clk; // 14.318MHz
//	input vcoclk; // 48MHz
//	input usbclk; // 12MHz
//	input	reset_n;
//	output vtune;
//	output clk_out;
//	output record_n;
//	inout usb_dm, usb_dp;
//`ifdef DEBUG
//	input sclk;
//	output sdata;
//`else
//	input [3:0] kbd_adr;
//	output [7:0] kbd_data;
//`endif

//	output	[7:0] data_out;
//	output	usb_dm_out;
//	output	usb_dm_oe;
//	output	usb_dm_in;
//	output	usb_dp_out;
//	output	usb_dp_oe;
//	output	usb_dp_in;
//	output	sample_out;
//	output	ins_out;
//	output	timing_out;

	reg		[7:0] data0_r;
	reg		[7:0] data1_r;
	reg		[7:0] data2_r;
	reg		[7:0] data3_r;
	reg		[7:0] data4_r;
	reg		[7:0] data5_r;
	reg		[7:0] data6_r;
	reg		[7:0] data7_r;
	reg		[7:0] data8_r;
	reg		[7:0] data9_r;
	reg		[7:0] data10_r;
	reg		[7:0] data11_r;
	reg		[7:0] data12_r;
	reg		[7:0] data13_r;
	reg		[7:0] data14_r;
	reg		[7:0] data15_r;

	assign data0[7:0]=data0_r[7:0];
	assign data1[7:0]=data1_r[7:0];
	assign data2[7:0]=data2_r[7:0];
	assign data3[7:0]=data3_r[7:0];
	assign data4[7:0]=data4_r[7:0];
	assign data5[7:0]=data5_r[7:0];
	assign data6[7:0]=data6_r[7:0];
	assign data7[7:0]=data7_r[7:0];
	assign data8[7:0]=data8_r[7:0];
	assign data9[7:0]=data9_r[7:0];
	assign data10[7:0]=data10_r[7:0];
	assign data11[7:0]=data11_r[7:0];
	assign data12[7:0]=data12_r[7:0];
	assign data13[7:0]=data13_r[7:0];
	assign data14[7:0]=data14_r[7:0];
	assign data15[7:0]=data15_r[7:0];

	parameter S_OPCODE = 0;
	parameter S_LDI0 = 1;
	parameter S_LDI1 = 2;
	parameter S_B0 = 3;
	parameter S_B1 = 4;

	function sel4;
		input [1:0] sel;
		input [3:0] a;
		case (sel)
			2'b00: sel4 = a[3];
			2'b01: sel4 = a[2];
			2'b10: sel4 = a[1];
			2'b11: sel4 = a[0];
		endcase
	endfunction

//	function [3:0] decode4;
//		input [1:0] sel;
//		input g;
//		if (g)
//			case (sel)
//				2'b00: decode4 = 4'b0001;
//				2'b01: decode4 = 4'b0010;
//				2'b10: decode4 = 4'b0100;
//				2'b11: decode4 = 4'b1000;
//			endcase
//		else decode4 = 4'b0000;
//	endfunction

	wire [3:0] inst;
	wire sample;
	reg connected, inst_ready, g, p, m, cond, nak, dm1; //reg connected = 0, inst_ready = 0, g = 0, p = 0, m = 0, cond = 0, nak = 0, dm1 = 0;
//	reg bank, record1; //reg bank = 0, record1 = 0;
	reg [2:0] state; //reg [2:0] state = 0;
	reg [7:0] w; //reg [7:0] w = 0;
	reg [9:0] pc; //reg [9:0] pc = 0;
	reg [2:0] timing; //reg [2:0] timing = 0;
	reg [3:0] tmp; //reg [3:0] tmp = 0;
	reg [13:0] interval; //reg [13:0] interval = 0;
	reg [7:0] bitadr; //reg [5:0] bitadr = 0;
	reg [7:0] data; //reg [7:0] data = 0;
//	clockgen clockgen(.refclk(clk), .vcoclk(vcoclk), .vtune(vtune), .clk_out(clk_out));

	ukprom ukprom(.clk(usbclk), .adr(pc), .data(inst));

	wire interval_cy = interval == 12001;
	wire next = ~(state == S_OPCODE & (
		~inst[3] & inst[2] & timing != 0 |
		~inst[3] & ~inst[2] & inst[1] & usb_dm |
		inst == 4'b1110 & ~interval_cy |
		inst == 4'b1101 & (~sample | (usb_dp | usb_dm) & w != 1)
	));

	wire branch = state == S_B1 & cond;
//	wire record;
//	wire [7:0] map;
//	wire [3:0] keydata;

	always @(posedge usbclk or negedge reset_n) 
	begin
		if (reset_n==1'b0)
			begin
				connected <= 1'b0;
				inst_ready <= 1'b0;
				g <= 1'b0;
				p <= 1'b0;
				m <= 1'b0;
				cond <= 1'b0;
				nak <= 1'b0;
				dm1 <= 1'b0;
			//	bank <= 1'b0;
			//	record1 <= 1'b0;
				state[2:0] <= 3'b0;
				w[7:0] <= 8'b0;
				pc[9:0] <= 10'b0;
				timing[2:0] <= 3'b0;
				tmp[3:0] <= 4'b0;
				interval[13:0] <= 14'b0;
				bitadr[7:0] <= 8'b0;
				data[7:0] <= 8'b0;
			end
		else
			begin
				if (inst_ready) 
					begin
						if (state == S_OPCODE) 
							begin
								if (inst == 4'b0001) state <= S_LDI0;
								if (inst == 4'b1100) connected <= ~connected;
								if (~inst[3] & inst[2] & timing == 0) 
									begin
										g <= ~inst[1] | ~inst[0];
										p <= ~inst[1] & inst[0];
										m <= inst[1] & ~inst[0];
									end
								if (inst[3] & ~inst[2]) 
									begin
										state <= S_B0;
										cond <= sel4(inst[1:0], { ~usb_dm, connected, nak, w != 1 });
									end
								if (inst == 4'b1011 | inst == 4'b1101 & sample) w <= w - 1;
							end
						if (state == S_LDI0) 
							begin
								w[3:0] <= inst;
								state <= S_LDI1;
							end
						if (state == S_LDI1) 
							begin
								w[7:4] <= inst;
								state <= S_OPCODE;
							end
						if (state == S_B0) 
							begin
								tmp <= inst;
								state <= S_B1;
							end
						if (state == S_B1) 
							begin
								state <= S_OPCODE;
							end
						if (next | branch) 
							begin
								pc <= branch ? { inst, tmp, 2'b00 } : pc + 1;
								inst_ready <= 0;
							end
					end
				else 
					begin
						inst_ready <= 1;
					end
				if (inst_ready & state == S_OPCODE & inst == 4'b0010) 
					begin
						timing <= 0;
						bitadr <= 0;
						nak <= 1;
					end
				else 
					begin
						timing <= timing + 1;
					end
				if (sample) 
					begin
						if (bitadr == 8) 
							begin
								nak <= usb_dm;
							end
						data[6:0] <= data[7:1];
						data[7] <= dm1 ~^ usb_dm;
						dm1 <= usb_dm;
						bitadr <= bitadr + 1;
					end
				interval <= interval_cy ? 0 : interval + 1;
			//	record1 <= record;
			//	if (~record & record1) bank <= ~bank;
			end
	end

	assign usb_dp = g ? p : 1'bZ;
	assign usb_dm = g ? m : 1'bZ;
	assign sample = inst_ready & state == S_OPCODE & inst == 4'b1101 & timing == 1;

	assign rcv_data[7:0]=data[7:0];
	assign rcv_addr[7:0]=bitadr[7:0];
	assign rcv_req=(timing[2:0]==3'b001) ? 1'b1 : 1'b0;
	assign rcv_connected=connected;

	assign data_out[7:0]=data[7:0];
	assign usb_dm_out=m;
	assign usb_dm_oe=g;
	assign usb_dm_in=usb_dm;
	assign usb_dp_out=p;
	assign usb_dp_oe=g;
	assign usb_dp_in=usb_dp;
	assign sample_out=sample;
	assign ins_out=({usb_dm_in,usb_dp_in}==2'b00) ? 1'b0 : 1'b1;
	assign timing_out=(bitadr[7:3]!=5'b0) & (bitadr[2:0]==3'b0) & (timing[2:0]==3'b001) ? 1'b1 : 1'b0;

	always @(posedge usbclk or negedge reset_n)
	begin
		if (reset_n==1'b0)
			begin
				data0_r[7:0] <= 8'b0;
				data1_r[7:0] <= 8'b0;
				data2_r[7:0] <= 8'b0;
				data3_r[7:0] <= 8'b0;
				data4_r[7:0] <= 8'b0;
				data5_r[7:0] <= 8'b0;
				data6_r[7:0] <= 8'b0;
				data7_r[7:0] <= 8'b0;
				data8_r[7:0] <= 8'b0;
				data9_r[7:0] <= 8'b0;
				data10_r[7:0] <= 8'b0;
				data11_r[7:0] <= 8'b0;
				data12_r[7:0] <= 8'b0;
				data13_r[7:0] <= 8'b0;
				data14_r[7:0] <= 8'b0;
				data15_r[7:0] <= 8'b0;
			end
		else
			begin
				data0_r[7:0]  <= {6'b0,connected};
				data1_r[7:0]  <= (bitadr[6:0]==7'b0001000) & (timing[2:0]==3'b001) ? data[7:0] : data1_r[7:0];
				data2_r[7:0]  <= (bitadr[6:0]==7'b0010000) & (timing[2:0]==3'b001) ? data[7:0] : data2_r[7:0];
				data3_r[7:0]  <= (bitadr[6:0]==7'b0011000) & (timing[2:0]==3'b001) ? data[7:0] : data3_r[7:0];
				data4_r[7:0]  <= (bitadr[6:0]==7'b0100000) & (timing[2:0]==3'b001) ? data[7:0] : data4_r[7:0];
				data5_r[7:0]  <= (bitadr[6:0]==7'b0101000) & (timing[2:0]==3'b001) ? data[7:0] : data5_r[7:0];
				data6_r[7:0]  <= (bitadr[6:0]==7'b0110000) & (timing[2:0]==3'b001) ? data[7:0] : data6_r[7:0];
				data7_r[7:0]  <= (bitadr[6:0]==7'b0111000) & (timing[2:0]==3'b001) ? data[7:0] : data7_r[7:0];
				data8_r[7:0]  <= (bitadr[6:0]==7'b1000000) & (timing[2:0]==3'b001) ? data[7:0] : data8_r[7:0];
				data9_r[7:0]  <= (bitadr[6:0]==7'b1001000) & (timing[2:0]==3'b001) ? data[7:0] : data9_r[7:0];
				data10_r[7:0] <= (bitadr[6:0]==7'b1010000) & (timing[2:0]==3'b001) ? data[7:0] : data10_r[7:0];
				data11_r[7:0] <= (bitadr[6:0]==7'b1011000) & (timing[2:0]==3'b001) ? data[7:0] : data11_r[7:0];
				data12_r[7:0] <= (bitadr[6:0]==7'b1100000) & (timing[2:0]==3'b001) ? data[7:0] : data12_r[7:0];
				data13_r[7:0] <= (bitadr[6:0]==7'b1101000) & (timing[2:0]==3'b001) ? data[7:0] : data13_r[7:0];
				data14_r[7:0] <= (bitadr[6:0]==7'b1110000) & (timing[2:0]==3'b001) ? data[7:0] : data14_r[7:0];
				data15_r[7:0] <= (bitadr[6:0]==7'b1111000) & (timing[2:0]==3'b001) ? data[7:0] : data15_r[7:0];
			end
	end

//`ifdef DEBUG
//	reg [6:0] readadr = 0;
//	reg [4:0] s_timing = 0;
//	reg sclk1 = 0, sclk2 = 0;
//	always @(posedge clk) begin
//		if (sclk1 ^ sclk2) begin
//			readadr <= readadr + 1;
//		end
//		else if (sclk2) begin
//			if (s_timing == 31) readadr <= 0;
//			else s_timing <= s_timing + 1;
//		end
//		else s_timing <= 0;
//		sclk1 <= sclk;
//		sclk2 <= sclk1;
//	end
//`endif
//	assign record = connected & ~nak;
//	assign record_n = ~record;
//	keymap keymap(.clk(usbclk), .adr({ ~timing[0], data[6:0] }), .data(map));
//	wire mod = bitadr == 24;
//	assign keydata = mod ? { data[0] | data[4], data[1] | data[5], data[2] | data[6], data[3] | data[7] } : decode4(map[1:0], record1);
//	wire [4:0] kbd_adr_in = record1 ? mod ? 5'b10001 : map[6:2] : interval[4:0];
//`ifdef DEBUG
//	RAMB4_S1_S4 keyboard(
//		.CLKA(usbclk), .ADDRA({ 4'b0000, ~bank, readadr }), .DIA(1'b0), .DOA(sdata),
//		.WEA(1'b0), .ENA(1'b1), .RSTA(1'b0),
//		.WEB(~record1 | (mod | bitadr == 40 | bitadr == 48) & (timing == 0 | timing == 1)), 
//		.ENB(~record1 | mod | map[7]), .RSTB(1'b0), .CLKB(usbclk), 
//		.ADDRB({ 4'b0000, bank, kbd_adr_in }), .DIB(keydata));
//`else
//	RAMB4_S4_S8 keyboard(
//		.CLKB(clk), .ADDRB({ 4'b0000, ~bank, kbd_adr}), .DIB(8'h00), .DOB(kbd_data),
//		.WEA(~record1 | (mod | bitadr == 40 | bitadr == 48) & (timing == 0 | timing == 1)), 
//		.ENA(~record1 | mod | map[7]), .RSTA(1'b0), .CLKA(usbclk), 
//		.ADDRA({ 4'b0000, bank, kbd_adr_in }), .DIA(keydata), 
//		.WEB(1'b0), .ENB(1'b1), .RSTB(1'b0));
//`endif
endmodule

