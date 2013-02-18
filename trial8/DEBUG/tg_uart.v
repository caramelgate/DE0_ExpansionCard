//------------------------------------------------------------------------------
//
//  tg_uart.v : serial controller (8bit parity-none stop1) module
//
//  LICENSE : "as-is"
//  TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2012/mar/03 release 0.0  connection test
//
//------------------------------------------------------------------------------

module tg_uart #(
	parameter	baud38400  =16'd40		// 25Mhz : 38400x16=40
) (
	output			uart_tx,			// out   [UART] send
	output			uart_tx_busy,		// out   [UART] send busy

	input			uart_rx,			// in    [UART] recieve
	output			uart_rx_ready,		// out   [UART] recieve data ready

	input	[7:0]	io_wdata,			// in    [UART] [7:0] io write data input
	output	[7:0]	io_rdata,			// out   [UART] [7:0] io read data output
	input			io_req,				// in    [UART] io req
	input			io_wr,				// in    [UART] io #read/write
	output			io_ack,				// out   [UART] io ack/#busy
	input			io_clk,				// in    [UART] clk
	input			io_rst_n			// in    [UART] #rst
);

//--------------------------------------------------------------
//  local parameter

	localparam	txst00=2'b00;
	localparam	txst01=2'b01;
	localparam	txst02=2'b11;
	localparam	txst03=2'b10;

	localparam	rxst00=2'b00;
	localparam	rxst01=2'b01;
	localparam	rxst02=2'b11;
	localparam	rxst03=2'b10;

//--------------------------------------------------------------
//  signal

	reg		[7:0] tx_data_r;
	reg		tx_busy_r;
	reg		[1:0] txstate_r;
	reg		[15:0] tx_count_r;
	reg		[3:0] tx_count9_r;
	reg		[9:0] tx_out_r;
	wire	[7:0] tx_data_w;
	wire	tx_busy_w;
	wire	[1:0] txstate_w;
	wire	[15:0] tx_count_w;
	wire	[3:0] tx_count9_w;
	wire	[9:0] tx_out_w;

	wire	tx_count_end;

	reg		[3:0] rx_in_r;
	reg		[1:0] rxstate_r;
	reg		[15:0] rx_count_r;
	reg		[3:0] rx_count9_r;
	reg		[9:0] rx_data_r;
	reg		[7:0] rx_rdata_r;
	reg		rx_full_r;
	wire	[3:0] rx_in_w;
	wire	[1:0] rxstate_w;
	wire	[15:0] rx_count_w;
	wire	[3:0] rx_count9_w;
	wire	[9:0] rx_data_w;
	wire	[7:0] rx_rdata_w;
	wire	rx_full_w;

	wire	rx_count_low_end;
	wire	rx_count_end;

//--------------------------------------------------------------
//  design

	assign io_ack=io_req;

	// ---- send ----

	assign uart_tx=tx_out_r[0];
	assign uart_tx_busy=tx_busy_r;

	always @(posedge io_clk or negedge io_rst_n)
	begin
		if (io_rst_n==1'b0)
			begin
				tx_data_r[7:0] <= 8'b0;
				tx_busy_r <= 1'b0;
				txstate_r <= txst00;
				tx_count_r[15:0] <= 16'b0;
				tx_count9_r[3:0] <= 4'b0;
				tx_out_r[9:0] <= 10'b11111111;
			end
		else
			begin
				tx_data_r[7:0] <= tx_data_w[7:0];
				tx_busy_r <= tx_busy_w;
				txstate_r <= txstate_w;
				tx_count_r[15:0] <= tx_count_w[15:0];
				tx_count9_r[3:0] <= tx_count9_w[3:0];
				tx_out_r[9:0] <= tx_out_w[9:0];
			end
	end

	wire	tx_done;

	assign tx_count_end=(tx_count_r[15:4]==baud38400[11:0]) & (tx_count_r[3:0]==4'hf) ? 1'b1 : 1'b0;

	assign tx_data_w[7:0]=({io_req,io_wr}==2'b11) ? io_wdata[7:0] : tx_data_r[7:0];
	assign tx_busy_w=
			({io_req,io_wr}==2'b11) ? 1'b1 :
			({io_req,io_wr}!=2'b11) & (tx_done==1'b1) ? 1'b0 :
			({io_req,io_wr}!=2'b11) & (tx_done==1'b0) ? tx_busy_r :
			1'b0;

	assign txstate_w=
			(txstate_r==txst00) & (tx_busy_r==1'b0) ? txst00 :
			(txstate_r==txst00) & (tx_busy_r==1'b1) ? txst01 :
			(txstate_r==txst01) & (tx_count_end==1'b0) ? txst01 :
			(txstate_r==txst01) & (tx_count_end==1'b1) & (tx_count9_r[3:0]==4'd10) ? txst02 :
			(txstate_r==txst01) & (tx_count_end==1'b1) & (tx_count9_r[3:0]!=4'd10) ? txst01 :
			(txstate_r==txst02) ? txst00 :
			(txstate_r==txst03) ? txst00 :
			txst00;

	assign tx_done=(txstate_r==txst02) ? 1'b1 :1'b0;

	assign tx_count_w[15:0]=
			(txstate_r==txst00) ? 16'b0 :
			(txstate_r==txst01) & (tx_count_end==1'b0) ? tx_count_r[15:0]+16'h01:
			(txstate_r==txst01) & (tx_count_end==1'b1) ? 16'h0 :
			(txstate_r==txst02) ? 16'h0 :
			(txstate_r==txst03) ? 16'h0 :
			16'h0;

	assign tx_count9_w[3:0]=
			(txstate_r==txst00) ? 4'b0 :
			(txstate_r==txst01) & (tx_count_end==1'b0) ? tx_count9_r[3:0] :
			(txstate_r==txst01) & (tx_count_end==1'b1) ? tx_count9_r[3:0]+4'h1 :
			(txstate_r==txst02) ? 4'h0 :
			(txstate_r==txst03) ? 4'h0 :
			4'h0;

	assign tx_out_w[9:0]=
			(txstate_r==txst00) & (tx_busy_r==1'b0) ? {1'b1,tx_data_r[7:0],1'b1} :
			(txstate_r==txst00) & (tx_busy_r==1'b1) ? {1'b1,tx_data_r[7:0],1'b0} :
			(txstate_r!=txst00) & (tx_count_end==1'b1) ? {1'b1,tx_out_r[9:1]} :
			(txstate_r!=txst00) & (tx_count_end==1'b0) ? tx_out_r[9:0] :
			10'b0;

	// ---- recieve ----

	assign uart_rx_ready=rx_full_r;
	assign io_rdata[7:0]=rx_rdata_r[7:0];

	always @(posedge io_clk or negedge io_rst_n)
	begin
		if (io_rst_n==1'b0)
			begin
				rx_in_r[3:0] <= 8'b0;
				rxstate_r <= rxst00;
				rx_count_r[15:0] <= 16'b0;
				rx_count9_r[3:0] <= 4'b0;
				rx_data_r[9:0] <= 10'b0;
				rx_rdata_r[7:0] <= 8'b0;
				rx_full_r <= 1'b0;
			end
		else
			begin
				rx_in_r[3:0] <= rx_in_w[3:0];
				rxstate_r <= rxstate_w;
				rx_count_r[15:0] <= rx_count_w[15:0];
				rx_count9_r[3:0] <= rx_count9_w[3:0];
				rx_data_r[9:0] <= rx_data_w[9:0];
				rx_rdata_r[7:0] <= rx_rdata_w[7:0];
				rx_full_r <= rx_full_w;
			end
	end

	wire	rx_edge;
	wire	rx_done;

	assign rx_count_low_end=(rx_count_r[15:4]==baud38400[11:0]) ? 1'b1 : 1'b0;

	assign rx_count_end=(rx_count_r[3:0]==4'hf) & (rx_count_low_end==1'b1) ? 1'b1 : 1'b0;

	assign rx_in_w[0]=uart_rx;
	assign rx_in_w[1]=rx_in_r[0];
	assign rx_in_w[2]=rx_in_r[1];
	assign rx_in_w[3]=rx_in_r[2];

	assign rx_edge=(rx_in_r[3:2]==2'b10) ? 1'b1 : 1'b0;

	assign rxstate_w=
			(rxstate_r==rxst00) & (rx_edge==1'b0) ? rxst00 :
			(rxstate_r==rxst00) & (rx_edge==1'b1) ? rxst01 :
			(rxstate_r==rxst01) & (rx_count_end==1'b0) ? rxst01 :
			(rxstate_r==rxst01) & (rx_count_end==1'b1) & (rx_count9_r[3:0]==4'd9) ? rxst02 :
			(rxstate_r==rxst01) & (rx_count_end==1'b1) & (rx_count9_r[3:0]!=4'd9) ? rxst01 :
			(rxstate_r==rxst02) ? rxst00 :
			(rxstate_r==rxst03) ? rxst00 :
			rxst00;

	assign rx_done=(rxstate_r==rxst02) ? 1'b1 :1'b0;

	assign rx_count_w[3:0]=
			(rxstate_r==rxst00) ? 4'b0 :
			(rxstate_r==rxst01) & (rx_count_low_end==1'b0) ? rx_count_r[3:0] :
			(rxstate_r==rxst01) & (rx_count_low_end==1'b1) ? rx_count_r[3:0]+4'h1:
			(rxstate_r==rxst02) ? 4'h0 :
			(rxstate_r==rxst03) ? 4'h0 :
			4'h0;

	assign rx_count_w[15:4]=
			(rxstate_r==rxst00) ? 12'b0 :
			(rxstate_r==rxst01) & (rx_count_low_end==1'b0) ? rx_count_r[15:4]+12'h01:
			(rxstate_r==rxst01) & (rx_count_low_end==1'b1) ? 12'h0 :
			(rxstate_r==rxst02) ? 12'h0 :
			(rxstate_r==rxst03) ? 12'h0 :
			12'h0;

	assign rx_count9_w[3:0]=
			(rxstate_r==rxst00) ? 4'b0 :
			(rxstate_r==rxst01) & (rx_count_end==1'b0) ? rx_count9_r[3:0] :
			(rxstate_r==rxst01) & (rx_count_end==1'b1) ? rx_count9_r[3:0]+4'h1 :
			(rxstate_r==rxst02) ? 4'h0 :
			(rxstate_r==rxst03) ? 4'h0 :
			4'h0;

	assign rx_data_w[9:0]=(rx_count_r[3:0]==4'h8) & (rx_count_low_end==1'b1) ? {rx_in_r[3],rx_data_r[9:1]} : rx_data_r[9:0];
	assign rx_rdata_w[7:0]=(rx_done==1'b1) ? rx_data_r[8:1] : rx_rdata_r[7:0];

	assign rx_full_w=
			(rx_done==1'b1) ? 1'b1 :
			(rx_done==1'b0) & ({io_req,io_wr}==2'b10) ? 1'b0 :
			(rx_done==1'b0) & ({io_req,io_wr}!=2'b10) ? rx_full_r :
			1'b0;

endmodule
