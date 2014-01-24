//------------------------------------------------------------------------------
//
//	n8255.v : syncronous 8255 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/11 release 0.0  
//
//------------------------------------------------------------------------------

module n8255 #(
	parameter	busfree=8'hff
) (
	input			CLK,		// in    [CPU] clk
	input			RESET,		// in    [CPU] reset
	input	[1:0]	ADDR,		// in    [CPU] addr[1:0]
//	input			REQ,		// in    [CPU] req
//	output			ACK,		// out   [CPU] ack/#wait
	input			WR,			// in    [CPU] wr
	input	[7:0]	WDATA,		// in    [CPU] cs
	output	[7:0]	RDATA,		// in    [CPU] cs

	input			CS,
	output			WAIT_N,

	output			PC5_fall,	// out   [PPI] multibank req
	input	[7:0]	PA_IN,		// in    [PPI] na
	input	[7:0]	PB_IN,		// in    [PPI] -- 
	input	[7:0]	PC_IN,		// in    [PPI] na
	output	[7:0]	PA_OUT,		// out   [PPI] -- printer data --
	output	[7:0]	PB_OUT,		// out   [PPI] na
	output	[7:0]	PC_OUT		// out   [PPI] -- 
);

	reg		[1:0] ack_r;
	reg		[7:0] rdata_r;
	reg		[7:0] mode_r;
	reg		[7:0] porta_r;
	reg		[7:0] portb_r;
	reg		[7:0] portc_r;
	reg		[1:0] portc5_r;
	wire	[1:0] ack_w;
	wire	[7:0] rdata_w;
	wire	[7:0] mode_w;
	wire	[7:0] porta_w;
	wire	[7:0] portb_w;
	wire	[7:0] portc_w;
	wire	[1:0] portc5_w;

	wire	wr_req;

	assign WAIT_N=(CS==1'b1) ? ack_r[0] : 1'b1;
	assign RDATA[7:0]=rdata_r[7:0];

	assign PA_OUT[7:0]=porta_r[7:0];
	assign PB_OUT[7:0]=8'b0;	// na
	assign PC_OUT[7:0]=portc_r[7:0];

	assign PC5_fall=portc5_r[1];

	always @(posedge CLK or posedge RESET)
	begin
		if (RESET==1'b1)
			begin
				ack_r[1:0] <= 2'b0;
				rdata_r[7:0] <= busfree[7:0];
				mode_r[7:0] <= 8'b0;
				porta_r[7:0] <= 8'hff;
				portb_r[7:0] <= 8'b0;
				portc_r[7:0] <= 8'hff;
				portc5_r[1:0] <= 2'b11;
			end
		else
			begin
				ack_r[1:0] <= ack_w[1:0];
				rdata_r[7:0] <= rdata_w[7:0];
				mode_r[7:0] <= mode_w[7:0];
				porta_r[7:0] <= porta_w[7:0];
				portb_r[7:0] <= portb_w[7:0];
				portc_r[7:0] <= portc_w[7:0];
				portc5_r[1:0] <= portc5_w[1:0];
			end
	end

	assign ack_w[0]=(CS==1'b1) ? 1'b1 : 1'b0;
	assign ack_w[1]=ack_r[0];

	assign wr_req=(ack_r[1:0]==2'b01) & (WR==1'b1) ? 1'b1 : 1'b0;

	assign rdata_w[7:0]=
			(CS==1'b0) ? busfree[7:0] :
			(CS==1'b1) & (ADDR[1:0]==2'b00) ? porta_r[7:0] :
			(CS==1'b1) & (ADDR[1:0]==2'b01) ? PB_IN[7:0] :
			(CS==1'b1) & (ADDR[1:0]==2'b10) ? portc_r[7:0] :
			(CS==1'b1) & (ADDR[1:0]==2'b11) ? mode_r[7:0] :
			busfree[7:0];

	assign mode_w[7:0]=({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b1) ? WDATA[7:0] : mode_r[7:0];

	assign porta_w[7:0]=({wr_req,ADDR[1:0]}==3'b100) ? WDATA[7:0] : porta_r[7:0];
	assign portb_w[7:0]=({wr_req,ADDR[1:0]}==3'b101) ? WDATA[7:0] : portb_r[7:0];
	assign portc_w[7:0]=
			({wr_req,ADDR[1:0]}==3'b110) ? WDATA[7:0] :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b000) ? {portc_r[7:1],WDATA[0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b001) ? {portc_r[7:2],WDATA[0],portc_r[0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b010) ? {portc_r[7:3],WDATA[0],portc_r[1:0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b011) ? {portc_r[7:4],WDATA[0],portc_r[2:0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b100) ? {portc_r[7:5],WDATA[0],portc_r[3:0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b101) ? {portc_r[7:6],WDATA[0],portc_r[4:0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b110) ? {portc_r[7],WDATA[0],portc_r[5:0]} :
			({wr_req,ADDR[1:0]}==3'b111) & (WDATA[7]==1'b0) & (WDATA[3:1]==3'b111) ? {WDATA[0],portc_r[6:0]} :
			portc_r[7:0];

	assign portc5_w[0]=portc_r[5];
	assign portc5_w[1]=({portc5_r[0],portc_r[5]}==2'b10) ? 1'b1 : 1'b0;

endmodule
