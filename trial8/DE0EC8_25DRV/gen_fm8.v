//-----------------------------------------------------------------------------
//
//  gen_fm8.v : 25drv fm module
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

module gen_fm8 #(
	parameter	DEVICE=0,	//
	parameter	opn2=0		// 0=rtl / 1=connect YM2612
) (
	output	[15:0]	debug_out,

	output	[15:0]	FM_OUT_L,
	output	[15:0]	FM_OUT_R,
	input	[7:0]	MIX_PSG,

	output	[1:0]	YM_ADDR,
	output	[7:0]	YM_WDATA,
	input	[7:0]	YM_RDATA,
	output			YM_DOE,
	output			YM_WR_N,
	output			YM_RD_N,
	output			YM_CS_N,
	output			YM_RESET_N,
	output			YM_CLK,

	input			RST_N,
	input			MCLK,
	input			SEL,
	input	[1:0]	ADDR,
	input			RNW,
	input	[7:0]	WDATA,
	output	[7:0]	RDATA,
	output			ACK
);


	wire	ym_ack;
	wire	[1:0] ym_addr;
	wire	[7:0] ym_wdata;
	wire	ym_wr;
	wire	ym_we;
	wire	ym_ce;

	assign ACK=ym_ack;

	reg		[2:0] ym_req_r;
	reg		[3:0] ym_wait_r;
	reg		ym_ack_r;
	reg		[1:0] ym_addr_r;
	reg		[7:0] ym_wdata_r;
	reg		ym_wr_r;
	reg		ym_we_r;
	reg		ym_ce_r;
	wire	[2:0] ym_req_w;
	wire	[3:0] ym_wait_w;
	wire	ym_ack_w;
	wire	[1:0] ym_addr_w;
	wire	[7:0] ym_wdata_w;
	wire	ym_wr_w;
	wire	ym_we_w;
	wire	ym_ce_w;

	assign ym_ack=ym_ack_r;
	assign ym_addr[1:0]=ym_addr_r[1:0];
	assign ym_wdata[7:0]=ym_wdata_r[7:0];
	assign ym_wr=ym_wr_r;
	assign ym_we=ym_we_r;
	assign ym_ce=ym_ce_r;

	always @(negedge RST_N or posedge MCLK)
	begin
		if (RST_N == 1'b0)
			begin
				ym_req_r[2:0] <= 3'b0;
				ym_wait_r[3:0] <= 4'b0;
				ym_ack_r <= 1'b0;
				ym_addr_r[1:0] <= 2'b0;
				ym_wdata_r[7:0] <= 8'b0;
				ym_wr_r <= 1'b0;
				ym_we_r <= 1'b0;
				ym_ce_r <= 1'b0;
			end
		else
			begin
				ym_req_r[2:0] <= ym_req_w[2:0];
				ym_wait_r[3:0] <= ym_wait_w[3:0];
				ym_ack_r <= ym_ack_w;
				ym_addr_r[1:0] <= ym_addr_w[1:0];
				ym_wdata_r[7:0] <= ym_wdata_w[7:0];
				ym_wr_r <= ym_wr_w;
				ym_we_r <= ym_we_w;
				ym_ce_r <= ym_ce_w;
			end
	end

generate
	if (opn2==1)
begin

	assign ym_req_w[2:0]=
			(ym_req_r[2:0]==3'b000) & (SEL==1'b0) ? 3'b000 :
			(ym_req_r[2:0]==3'b000) & (SEL==1'b1) & (RNW==1'b0) ? 3'b001 :
			(ym_req_r[2:0]==3'b000) & (SEL==1'b1) & (RNW==1'b1) ? 3'b111 :
			(ym_req_r[2:0]==3'b001) ? 3'b011 :
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]==3'b010) ? 3'b010 :
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]!=3'b010) ? 3'b011 :
			(ym_req_r[2:0]==3'b010) & (ym_wait_r[2:0]==3'b101) ? 3'b000 :
			(ym_req_r[2:0]==3'b010) & (ym_wait_r[2:0]!=3'b101) ? 3'b010 :
			(ym_req_r[2:0]==3'b100) ? 3'b101 :
			(ym_req_r[2:0]==3'b101) ? 3'b111 :
			(ym_req_r[2:0]==3'b111) ? 3'b110 :
			(ym_req_r[2:0]==3'b110) ? 3'b000 :
			3'b0;

	assign ym_wait_w[3:0]=
			(ym_req_r[2:0]==3'b000) ? 4'b0 :
			(ym_req_r[2:0]==3'b001) ? 4'b0 :
			(ym_req_r[2:0]==3'b011) ? ym_wait_r[3:0]+4'b01 :
			(ym_req_r[2:0]==3'b010) ? ym_wait_r[3:0]+4'b01 :
			4'b0;

	assign ym_ack_w=
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]==3'b010) ? 1'b1 :
			(ym_req_r[2:0]==3'b111) ? 1'b1 :
			1'b0;

	assign ym_addr_w[1:0]=
			(ym_req_r[2:0]==3'b000) ? ADDR[1:0] :
			(ym_req_r[2:0]!=3'b000) ? ym_addr_r[1:0] :
			2'b0;

	assign ym_wdata_w[7:0]=
			(ym_req_r[2:0]==3'b000) ? WDATA[7:0] :
			(ym_req_r[2:0]!=3'b000) ? ym_wdata_r[7:0] :
			8'b0;

	assign ym_wr_w=
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]==3'b010) ? 1'b1 :
			1'b0;

	assign ym_we_w=
			(ym_req_r[2:0]==3'b000) & (SEL==1'b1) & (RNW==1'b0) ? 1'b1 :
			(ym_req_r[2:0]==3'b001) ? 1'b1 :
			(ym_req_r[2:0]==3'b011) ? 1'b1 :
			1'b0;

	assign ym_ce_w=
			(ym_req_r[2:0]==3'b001) ? 1'b1 :
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]==3'b010) ? 1'b0 :
			(ym_req_r[2:0]==3'b011) & (ym_wait_r[2:0]!=3'b010) ? 1'b1 :
			1'b0;

end
	else
begin

	assign ym_req_w[2:0]=
			(ym_req_r[2:0]==3'b000) & (SEL==1'b0) ? 3'b000 :
			(ym_req_r[2:0]==3'b000) & (SEL==1'b1) & (RNW==1'b0) ? 3'b011 :
			(ym_req_r[2:0]==3'b000) & (SEL==1'b1) & (RNW==1'b1) ? 3'b111 :
			(ym_req_r[2:0]==3'b001) ? 3'b011 :
			(ym_req_r[2:0]==3'b011) ? 3'b010 :
			(ym_req_r[2:0]==3'b010) ? 3'b000 :
			(ym_req_r[2:0]==3'b100) ? 3'b101 :
			(ym_req_r[2:0]==3'b101) ? 3'b111 :
			(ym_req_r[2:0]==3'b111) ? 3'b110 :
			(ym_req_r[2:0]==3'b110) ? 3'b000 :
			3'b0;

	assign ym_wait_w[3:0]=
			(ym_req_r[2:0]==3'b000) ? 4'b0 :
			(ym_req_r[2:0]==3'b001) ? 4'b0 :
			(ym_req_r[2:0]==3'b011) ? ym_wait_r[3:0]+4'b01 :
			(ym_req_r[2:0]==3'b010) ? ym_wait_r[3:0]+4'b01 :
			4'b0;

	assign ym_ack_w=
			(ym_req_r[2:0]==3'b011) ? 1'b1 :
			(ym_req_r[2:0]==3'b111) ? 1'b1 :
			1'b0;

	assign ym_addr_w[1:0]=
			(ym_req_r[2:0]==3'b000) ? ADDR[1:0] :
			(ym_req_r[2:0]!=3'b000) ? ym_addr_r[1:0] :
			2'b0;

	assign ym_wdata_w[7:0]=
			(ym_req_r[2:0]==3'b000) ? WDATA[7:0] :
			(ym_req_r[2:0]!=3'b000) ? ym_wdata_r[7:0] :
			8'b0;

	assign ym_wr_w=
			(ym_req_r[2:0]==3'b011) ? 1'b1 :
			1'b0;

	assign ym_we_w=1'b0;

	assign ym_ce_w=1'b0;

end
endgenerate

//	reg		FF_DTACK_N;

	wire	[7:0] STATUS;
	reg		TA_OVF;
	reg		TB_OVF;

	reg		[7:0] REG_ADDR;

//	assign DTACK_N=FF_DTACK_N;

	assign STATUS[7]=1'b0;	// BUSY flag
	assign STATUS[6:2]={TA_OVF,TB_OVF,TA_OVF,TB_OVF,TA_OVF};//5'b00000;
	assign STATUS[1]=TB_OVF;
	assign STATUS[0]=TA_OVF;
	assign RDATA[7:0]=STATUS;

	assign YM_ADDR[1:0]=ym_addr[1:0];
	assign YM_WDATA[7:0]=ym_wdata[7:0];
	assign YM_DOE=ym_we;
	assign YM_WR_N=!ym_ce;
	assign YM_RD_N=1'b1;
	assign YM_CS_N=!ym_ce;
	assign YM_RESET_N=RST_N;
	assign YM_CLK=MCLK;

//generate
//	if (DEVICE==1'b0)
//begin
//end
//	else
//begin
//end
//endgenerate

	// CPU INTERFACE

	reg		[7:0] FMREG21;
	reg		[7:0] FMREG22;
	reg		[7:0] FMREG23;
	reg		[7:0] FMREG24;
	reg		[7:0] FMREG25;
	reg		[7:0] FMREG26;
	reg		[7:0] FMREG27;
	reg		[7:0] FMREG28;
	reg		[7:0] FMREG29;
	reg		[7:0] FMREG2A;
	reg		[7:0] FMREG2B;
	reg		[7:0] FMREG2C;

	wire	REG_ADDR_WR;
	wire	FMREG21_WR;
	wire	FMREG22_WR;
	wire	FMREG23_WR;
	wire	FMREG24_WR;
	wire	FMREG25_WR;
	wire	FMREG26_WR;
	wire	FMREG27_WR;
	wire	FMREG28_WR;
	wire	FMREG29_WR;
	wire	FMREG2A_WR;
	wire	FMREG2B_WR;
	wire	FMREG2C_WR;

	reg		[9:0] TA_VALUE;
	reg		[7:0] TA_DIV;
	reg		[7:0] TB_VALUE;
	reg		[11:0] TB_DIV;
	reg		TA_RESETCLK;
	reg		TB_RESETCLK;

	wire	[9:0] TA_BASE;
	wire	[7:0] TB_BASE;
	wire	TA_LOAD;
	wire	TB_LOAD;
	wire	TB_EN;
	wire	TA_EN;

	wire	[7:0] FM_DAC_DATA;
	wire	FM_DAC_SEL;
	wire	[3:0] FM_LFO;
	wire	[3:0] FM_SLOT;
	wire	[2:0] FM_CH;
	wire	[1:0] FM_CH3_MODE;

//	wire	[7:0] FM_DAC;
	reg		[7:0] FM_DAC_OUT;
	reg		[7:0] MIX_PSG_IN;

	assign TA_BASE[9:0]={FMREG24[7:0],FMREG25[1:0]};
	assign TA_EN=FMREG27[3];
	assign TB_EN=FMREG27[4];
	assign TA_LOAD=FMREG27[0];
	assign TB_LOAD=FMREG27[1];
	assign TB_BASE[7:0]=FMREG26[7:0];
	assign FM_DAC_DATA[7:0]=(FM_DAC_SEL==1'b1) ? {!FMREG2A[7],FMREG2A[6:0]} : 8'h00;
	assign FM_DAC_SEL=FMREG2B[7];

	assign FM_LFO[3:0]=FMREG22[3:0];
	assign FM_SLOT[3:0]=FMREG28[7:4];
	assign FM_CH[2:0]=FMREG28[2:0];
	assign FM_CH3_MODE=FMREG28[7:6];

//	wire	FMREG_WR;

//	assign FMREG_WR=(SEL==1'b1) & (FF_DTACK_N==1'b1) & (RNW==1'b0) ? 1'b1 : 1'b0;

	assign REG_ADDR_WR=(ym_wr==1'b1) & (ym_addr[1:0]==2'b00) ? 1'b1 : 1'b0;
	assign FMREG21_WR=(REG_ADDR[7:0]==8'h21) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG22_WR=(REG_ADDR[7:0]==8'h22) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG23_WR=(REG_ADDR[7:0]==8'h23) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG24_WR=(REG_ADDR[7:0]==8'h24) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG25_WR=(REG_ADDR[7:0]==8'h25) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG26_WR=(REG_ADDR[7:0]==8'h26) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG27_WR=(REG_ADDR[7:0]==8'h27) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG28_WR=(REG_ADDR[7:0]==8'h28) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG29_WR=(REG_ADDR[7:0]==8'h29) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG2A_WR=(REG_ADDR[7:0]==8'h2A) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG2B_WR=(REG_ADDR[7:0]==8'h2B) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign FMREG2C_WR=(REG_ADDR[7:0]==8'h2C) & (ym_wr==1'b1) & (ym_addr[1:0]==2'b01) ? 1'b1 : 1'b0;


	always @(negedge RST_N or posedge MCLK)
	begin
		if (RST_N == 1'b0)
			begin
			//	FF_DTACK_N	<= 1'b1;
				REG_ADDR[7:0] <= 8'b0;

				FMREG21[7:0] <= 8'b0;
				FMREG22[7:0] <= 8'b0;
				FMREG23[7:0] <= 8'b0;
				FMREG24[7:0] <= 8'b0;
				FMREG25[7:0] <= 8'b0;
				FMREG26[7:0] <= 8'b0;
				FMREG27[7:0] <= 8'b0;
				FMREG28[7:0] <= 8'b0;
				FMREG29[7:0] <= 8'b0;
				FMREG2A[7:0] <= 8'h80;
				FMREG2B[7:0] <= 8'b0;
				FMREG2C[7:0] <= 8'b0;

				TA_RESETCLK <= 1'b1;
				TB_RESETCLK <= 1'b1;
				FM_DAC_OUT[7:0] <= 8'h80;
				MIX_PSG_IN[7:0] <= 8'h80;
			end
		else
			begin
			//	FF_DTACK_N <= (SEL==1'b1) ? 1'b0 : 1'b1;
				REG_ADDR[7:0] <= (REG_ADDR_WR==1'b1) ? ym_wdata[7:0] : REG_ADDR[7:0];

				FMREG21[7:0] <= (FMREG21_WR==1'b1) ? ym_wdata[7:0] : FMREG21[7:0];
				FMREG22[7:0] <= (FMREG22_WR==1'b1) ? ym_wdata[7:0] : FMREG22[7:0];
				FMREG23[7:0] <= (FMREG23_WR==1'b1) ? ym_wdata[7:0] : FMREG23[7:0];
				FMREG24[7:0] <= (FMREG24_WR==1'b1) ? ym_wdata[7:0] : FMREG24[7:0];
				FMREG25[7:0] <= (FMREG25_WR==1'b1) ? ym_wdata[7:0] : FMREG25[7:0];
				FMREG26[7:0] <= (FMREG26_WR==1'b1) ? ym_wdata[7:0] : FMREG26[7:0];
				FMREG27[7:0] <= (FMREG27_WR==1'b1) ? ym_wdata[7:0] : FMREG27[7:0];
				FMREG28[7:0] <= (FMREG28_WR==1'b1) ? ym_wdata[7:0] : FMREG28[7:0];
				FMREG29[7:0] <= (FMREG29_WR==1'b1) ? ym_wdata[7:0] : FMREG29[7:0];
				FMREG2A[7:0] <= (FMREG2A_WR==1'b1) ? ym_wdata[7:0] : FMREG2A[7:0];
				FMREG2B[7:0] <= (FMREG2B_WR==1'b1) ? ym_wdata[7:0] : FMREG2B[7:0];
				FMREG2C[7:0] <= (FMREG2C_WR==1'b1) ? ym_wdata[7:0] : FMREG2C[7:0];

				TA_RESETCLK <= (FMREG27_WR==1'b1) & (ym_wdata[4]==1'b1) ? 1'b1 : 1'b0;
				TB_RESETCLK <= (FMREG27_WR==1'b1) & (ym_wdata[5]==1'b1) ? 1'b1 : 1'b0;
				FM_DAC_OUT[7:0] <= FM_DAC_DATA[7:0];
				MIX_PSG_IN[7:0] <= MIX_PSG[7:0];
			end
	end

	// http://gendev.spritesmind.net/forum/viewtopic.php?t=386&start=90
	// To calculate Timer A period in microseconds:

	// TimerA = 144 * (1024 - NA) / M
	// NA:     0~1023
	// M:      Master clock (MHz)

	// Eg, where clock = 7.61Mhz
	// TimerA(MAX) = 144 * (1024 - 0) / 7.61 = 19376.61 microseconds
	// TimerA(MIN) = 144 * (1024 - 1023) / 7.61 = 18.92 microseconds


	// To calculate Timer B period in microseconds:

	// TimerB = (144*16) * (256 - NA) / M
	// NB:     0~255
	// M:      Master clock (MHz)

	// Eg, where clock = 7.61Mhz
	// TimerB(MAX) = (144*16) * (256 - 0) / 7.61 = 77506.44 microseconds
	// TimerB(MIN) = (144*16) * (256 - 255) / 7.61 = 302.76 microseconds

	// TIMER A

	wire	TA_DIV_OVER;
	wire	TA_VALUE_OVER;

	assign TA_DIV_OVER=(TA_DIV==8'b10001111) ? 1'b1 : 1'b0;
	assign TA_VALUE_OVER=(TA_VALUE==10'b1111111111) ? 1'b1 :1'b0;

	always @(negedge RST_N or posedge MCLK)
	begin
		if (RST_N==1'b0)
			begin
				TA_OVF <= 1'b0;
				TA_VALUE <= 10'b0;
				TA_DIV <= 8'b0;
			end
		else
			begin
				TA_OVF <=
					(TA_RESETCLK==1'b1) ? 1'b0 :
					(TA_RESETCLK==1'b0) &  ((TA_DIV_OVER==1'b1) & (TA_VALUE_OVER==1'b1) & (TA_EN==1'b1)) ? 1'b1 :
					(TA_RESETCLK==1'b0) & !((TA_DIV_OVER==1'b1) & (TA_VALUE_OVER==1'b1) & (TA_EN==1'b1)) ? TA_OVF :
					1'b0;
				TA_VALUE <=
					(TA_LOAD==1'b0) ? TA_BASE :
					(TA_LOAD==1'b1) & (TA_DIV_OVER==1'b0) ? TA_VALUE :
					(TA_LOAD==1'b1) & (TA_DIV_OVER==1'b1) & (TA_VALUE_OVER==1'b0) ? TA_VALUE+1 :
					(TA_LOAD==1'b1) & (TA_DIV_OVER==1'b1) & (TA_VALUE_OVER==1'b1) ? TA_BASE :
					10'b0;
				TA_DIV <=
					(TA_LOAD==1'b0) ? 8'b0 :
					(TA_LOAD==1'b1) & (TA_DIV_OVER==1'b0) ? TA_DIV+1 :
					(TA_LOAD==1'b1) & (TA_DIV_OVER==1'b1) ? 8'b0 :
					8'b0;
			end
	end


	// TIMER B

	wire	TB_DIV_OVER;
	wire	TB_VALUE_OVER;

	assign TB_DIV_OVER=(TB_DIV==12'b100011111111) ? 1'b1 : 1'b0;
	assign TB_VALUE_OVER=(TB_VALUE==8'b11111111) ? 1'b1 :1'b0;

	always @(negedge RST_N or posedge MCLK)
	begin
		if (RST_N==1'b0)
			begin
				TB_OVF <= 1'b0;
				TB_VALUE <= 8'b0;
				TB_DIV <= 12'b0;
			end
		else
			begin
				TB_OVF <=
					(TB_RESETCLK==1'b1) ? 1'b0 :
					(TB_RESETCLK==1'b1) &  ((TB_DIV_OVER==1'b1) & (TB_VALUE_OVER==1'b1) & (TB_EN==1'b1)) ? 1'b1 :
					(TB_RESETCLK==1'b1) & !((TB_DIV_OVER==1'b1) & (TB_VALUE_OVER==1'b1) & (TB_EN==1'b1)) ? TB_OVF :
					1'b0;
				TB_VALUE <=
					(TB_LOAD==1'b0) ? TB_BASE :
					(TB_LOAD==1'b1) & (TB_DIV_OVER==1'b0) ? TB_VALUE :
					(TB_LOAD==1'b1) & (TB_DIV_OVER==1'b1) & (TB_VALUE_OVER==1'b0) ? TB_VALUE+1 :
					(TB_LOAD==1'b1) & (TB_DIV_OVER==1'b1) & (TB_VALUE_OVER==1'b1) ? TB_BASE :
					8'b0;
				TB_DIV <=
					(TB_LOAD==1'b0) ? 12'b0 :
					(TB_LOAD==1'b1) & (TB_DIV_OVER==1'b0) ? TB_DIV+1 :
					(TB_LOAD==1'b1) & (TB_DIV_OVER==1'b1) ? 12'b0 :
					12'b0;
			end
	end

generate
	if (opn2==1)
begin

	wire	[15:0] FM_OUT;

	assign FM_OUT_L[15:0]=FM_OUT[15:0];
	assign FM_OUT_R[15:0]=FM_OUT[15:0];

	assign FM_OUT[15:0]={FM_DAC_OUT[7],FM_DAC_OUT[7:0],6'b0}+{MIX_PSG_IN[7],MIX_PSG_IN[7:0],6'b0};

	assign debug_out[15:0]=16'b0;

end
	else
begin

	wire	[7:0] vm_status;

vm8_parameter vm_opxx(
	.debug_out(debug_out),

	.mclk(MCLK),
	.reset(!RST_N),
	.wdata(ym_wdata[7:0]),
	.waddr(ym_addr[1:0]),
	.we(ym_wr),
	.status(vm_status[7:0]),

	.psg_in(MIX_PSG_IN[7:0]),
	.dac_out(),
	.chl_out(FM_OUT_L[15:0]),
	.chr_out(FM_OUT_R[15:0])
);

end
endgenerate

endmodule
