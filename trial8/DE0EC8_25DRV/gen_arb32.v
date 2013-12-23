//------------------------------------------------------------------------------
//  gen_arb32.v : arbiter32 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------

module gen_arb32 #(
	parameter	p0_size=2,		// size=1(8),2(16),4(32)
	parameter	p1_size=2,
	parameter	p2_size=2,
	parameter	p3_size=2
) (
	output	[31:0]	dev_addr,			// out
	output	[31:0]	dev_wdata,			// out
	output	[3:0]	dev_be,				// out
	input	[31:0]	dev_rdata,			// in
	output			dev_wr,				// out
	output			dev_req,			// out
	input			dev_ack,			// in

	input	[31:0]	p0_addr,			// in
	input	[31:0]	p0_wdata,			// in
	input	[3:0]	p0_be,				// in
	output	[31:0]	p0_rdata,			// out
	input			p0_wr,				// in
	input			p0_req,				// in
	output			p0_ack,				// out
	input			p0_busreq,			// in
	output			p0_busack,			// out

	input	[31:0]	p1_addr,			// in
	input	[31:0]	p1_wdata,			// in
	input	[3:0]	p1_be,				// in
	output	[31:0]	p1_rdata,			// out
	input			p1_wr,				// in
	input			p1_req,				// in
	output			p1_ack,				// out

	input	[31:0]	p2_addr,			// in
	input	[31:0]	p2_wdata,			// in
	input	[3:0]	p2_be,				// in
	output	[31:0]	p2_rdata,			// out
	input			p2_wr,				// in
	input			p2_req,				// in
	output			p2_ack,				// out

	input	[31:0]	p3_addr,			// in
	input	[31:0]	p3_wdata,			// in
	input	[3:0]	p3_be,				// in
	output	[31:0]	p3_rdata,			// out
	input			p3_wr,				// in
	input			p3_req,				// in
	output			p3_ack,				// out

	input			dev_clk,			// in
	input			dev_rst_n			// in
);

	assign p0_busack=p0_busreq;

	reg		[1:0] mem_dev_req_r;
	reg		[1:0] mem_dev_master_r;
	reg		[31:0] mem_dev_addr_r;
	reg		[31:0] mem_dev_wdata_r;
	reg		[3:0] mem_dev_be_r;
	reg		mem_dev_ce_r;
	reg		mem_dev_wr_r;
	reg		[31:0] mem_dev_rdata_r;
	reg		mem_dev_ack_r;
	wire	[1:0] mem_dev_req_w;
	wire	[1:0] mem_dev_master_w;
	wire	[31:0] mem_dev_addr_w;
	wire	[31:0] mem_dev_wdata_w;
	wire	[3:0] mem_dev_be_w;
	wire	mem_dev_ce_w;
	wire	mem_dev_wr_w;
	wire	[31:0] mem_dev_rdata_w;
	wire	mem_dev_ack_w;

	wire	p0_dev_req;
	wire	p1_dev_req;
	wire	p2_dev_req;
	wire	p3_dev_req;

	reg		[2:0] p0_dev_req_r;
	reg		[2:0] p1_dev_req_r;
	reg		[2:0] p2_dev_req_r;
	reg		[2:0] p3_dev_req_r;
	reg		p0_dev_ack_r;
	reg		p1_dev_ack_r;
	reg		p2_dev_ack_r;
	reg		p3_dev_ack_r;
	reg		[31:0] p0_dev_rdata_r;
	reg		[31:0] p1_dev_rdata_r;
	reg		[31:0] p2_dev_rdata_r;
	reg		[31:0] p3_dev_rdata_r;
	wire	[2:0] p0_dev_req_w;
	wire	[2:0] p1_dev_req_w;
	wire	[2:0] p2_dev_req_w;
	wire	[2:0] p3_dev_req_w;
	wire	p0_dev_ack_w;
	wire	p1_dev_ack_w;
	wire	p2_dev_ack_w;
	wire	p3_dev_ack_w;
	wire	[31:0] p0_dev_rdata_w;
	wire	[31:0] p1_dev_rdata_w;
	wire	[31:0] p2_dev_rdata_w;
	wire	[31:0] p3_dev_rdata_w;

	assign dev_req=mem_dev_ce_r;
	assign dev_wr=mem_dev_wr_r;
	assign dev_addr[31:0]=mem_dev_addr_r[31:0];
	assign dev_wdata[31:0]=mem_dev_wdata_r[31:0];
	assign dev_be[3:0]=mem_dev_be_r[3:0];

	assign p0_dev_req=p0_dev_req_r[2];
	assign p1_dev_req=p1_dev_req_r[2];
	assign p2_dev_req=p2_dev_req_r[2];
	assign p3_dev_req=p3_dev_req_r[2];

	assign p0_ack=p0_dev_ack_r;
	assign p1_ack=p1_dev_ack_r;
	assign p2_ack=p2_dev_ack_r;
	assign p3_ack=p3_dev_ack_r;

	assign p0_rdata[31:0]=p0_dev_rdata_r[31:0];
	assign p1_rdata[31:0]=p1_dev_rdata_r[31:0];
	assign p2_rdata[31:0]=p2_dev_rdata_r[31:0];
	assign p3_rdata[31:0]=p3_dev_rdata_r[31:0];

	always @(negedge dev_rst_n or posedge dev_clk)
	begin
		if (dev_rst_n==1'b0)
			begin
				p0_dev_req_r[2:0] <= 3'b0;
				p1_dev_req_r[2:0] <= 3'b0;
				p2_dev_req_r[2:0] <= 3'b0;
				p3_dev_req_r[2:0] <= 3'b0;
				p0_dev_ack_r <= 1'b0;
				p1_dev_ack_r <= 1'b0;
				p2_dev_ack_r <= 1'b0;
				p3_dev_ack_r <= 1'b0;
				p0_dev_rdata_r[31:0] <= 32'b0;
				p1_dev_rdata_r[31:0] <= 32'b0;
				p2_dev_rdata_r[31:0] <= 32'b0;
				p3_dev_rdata_r[31:0] <= 32'b0;
			end
		else
			begin
				p0_dev_req_r[2:0] <= p0_dev_req_w[2:0];
				p1_dev_req_r[2:0] <= p1_dev_req_w[2:0];
				p2_dev_req_r[2:0] <= p2_dev_req_w[2:0];
				p3_dev_req_r[2:0] <= p3_dev_req_w[2:0];
				p0_dev_ack_r <= p0_dev_ack_w;
				p1_dev_ack_r <= p1_dev_ack_w;
				p2_dev_ack_r <= p2_dev_ack_w;
				p3_dev_ack_r <= p3_dev_ack_w;
				p0_dev_rdata_r[31:0] <= p0_dev_rdata_w[31:0];
				p1_dev_rdata_r[31:0] <= p1_dev_rdata_w[31:0];
				p2_dev_rdata_r[31:0] <= p2_dev_rdata_w[31:0];
				p3_dev_rdata_r[31:0] <= p3_dev_rdata_w[31:0];
			end
	end

	assign p0_dev_req_w[2:0]=
			(p0_dev_req_r[1:0]==2'b00) & (p0_req==1'b0) ? 3'b000 :
			(p0_dev_req_r[1:0]==2'b00) & (p0_req==1'b1) ? 3'b101 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b0) ? 3'b101 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) ? 3'b011 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b00) ? 3'b101 :
			(p0_dev_req_r[1:0]==2'b11) & (p0_req==1'b0) ? 3'b000 :
			(p0_dev_req_r[1:0]==2'b11) & (p0_req==1'b1) ? 3'b011 :
			(p0_dev_req_r[1:0]==2'b10) ? 3'b000 :
			3'b00;

	assign p1_dev_req_w[2:0]=
			(p1_dev_req_r[1:0]==2'b00) & (p1_req==1'b0) ? 3'b000 :
			(p1_dev_req_r[1:0]==2'b00) & (p1_req==1'b1) ? 3'b101 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b0) ? 3'b101 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) ? 3'b011 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b01) ? 3'b101 :
			(p1_dev_req_r[1:0]==2'b11) & (p1_req==1'b0) ? 3'b000 :
			(p1_dev_req_r[1:0]==2'b11) & (p1_req==1'b1) ? 3'b011 :
			(p1_dev_req_r[1:0]==2'b10) ? 3'b000 :
			3'b00;

	assign p2_dev_req_w[2:0]=
			(p2_dev_req_r[1:0]==2'b00) & (p2_req==1'b0) ? 3'b000 :
			(p2_dev_req_r[1:0]==2'b00) & (p2_req==1'b1) ? 3'b101 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b0) ? 3'b101 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) ? 3'b011 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b10) ? 3'b101 :
			(p2_dev_req_r[1:0]==2'b11) & (p2_req==1'b0) ? 3'b000 :
			(p2_dev_req_r[1:0]==2'b11) & (p2_req==1'b1) ? 3'b011 :
			(p2_dev_req_r[1:0]==2'b10) ? 3'b000 :
			3'b00;

	assign p3_dev_req_w[2:0]=
			(p3_dev_req_r[1:0]==2'b00) & (p3_req==1'b0) ? 3'b000 :
			(p3_dev_req_r[1:0]==2'b00) & (p3_req==1'b1) ? 3'b101 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b0) ? 3'b101 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) ? 3'b011 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b11) ? 3'b101 :
			(p3_dev_req_r[1:0]==2'b11) & (p3_req==1'b0) ? 3'b000 :
			(p3_dev_req_r[1:0]==2'b11) & (p3_req==1'b1) ? 3'b011 :
			(p3_dev_req_r[1:0]==2'b10) ? 3'b000 :
			3'b00;

	assign p0_dev_ack_w=
			(p0_dev_req_r[1:0]==2'b00) ? 1'b0 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b0) ? 1'b0 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) ? 1'b1 :
			(p0_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b00) ? 1'b0 :
			(p0_dev_req_r[1:0]==2'b11) ? 1'b0 :
		//	(p0_dev_req_r[1:0]==2'b11) & (p0_req==1'b0) ? 1'b0 :
		//	(p0_dev_req_r[1:0]==2'b11) & (p0_req==1'b1) ? 1'b1 :
			(p0_dev_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign p1_dev_ack_w=
			(p1_dev_req_r[1:0]==2'b00) ? 1'b0 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b0) ? 1'b0 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) ? 1'b1 :
			(p1_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b01) ? 1'b0 :
			(p1_dev_req_r[1:0]==2'b11) ? 1'b0 :
		//	(p1_dev_req_r[1:0]==2'b11) & (p1_req==1'b0) ? 1'b0 :
		//	(p1_dev_req_r[1:0]==2'b11) & (p1_req==1'b1) ? 1'b1 :
			(p1_dev_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign p2_dev_ack_w=
			(p2_dev_req_r[1:0]==2'b00) ? 1'b0 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b0) ? 1'b0 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) ? 1'b1 :
			(p2_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b10) ? 1'b0 :
			(p2_dev_req_r[1:0]==2'b11) ? 1'b0 :
		//	(p2_dev_req_r[1:0]==2'b11) & (p2_req==1'b0) ? 1'b0 :
		//	(p2_dev_req_r[1:0]==2'b11) & (p2_req==1'b1) ? 1'b1 :
			(p2_dev_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign p3_dev_ack_w=
			(p3_dev_req_r[1:0]==2'b00) ? 1'b0 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b0) ? 1'b0 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) ? 1'b1 :
			(p3_dev_req_r[1:0]==2'b01) & (mem_dev_master_r[1:0]!=2'b11) ? 1'b0 :
			(p3_dev_req_r[1:0]==2'b11) ? 3'b0 :
		//	(p3_dev_req_r[1:0]==2'b11) & (p3_req==1'b0) ? 1'b0 :
		//	(p3_dev_req_r[1:0]==2'b11) & (p3_req==1'b1) ? 1'b1 :
			(p3_dev_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

generate
	if (p0_size==1)

	assign p0_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1:0]==2'b00) ? {mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24]} :
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1:0]==2'b01) ? {mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16]} :
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1:0]==2'b10) ? {mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8]} :
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1:0]==2'b11) ? {mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0]} :
			p0_dev_rdata_r[31:0];

endgenerate

generate
	if (p0_size==2)

	assign p0_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1]==1'b0) ? {mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16]} :
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) & (p0_addr[1]==1'b1) ? {mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0]} :
			p0_dev_rdata_r[31:0];

endgenerate

generate
	if ((p0_size!=1) & (p0_size!=2))

	assign p0_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b00) & (mem_dev_ack_r==1'b1) ? mem_dev_rdata_r[31:0] :
			p0_dev_rdata_r[31:0];

endgenerate

generate
	if (p1_size==1)

	assign p1_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1:0]==2'b00) ? {mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24]} :
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1:0]==2'b01) ? {mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16]} :
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1:0]==2'b10) ? {mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8]} :
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1:0]==2'b11) ? {mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0]} :
			p1_dev_rdata_r[31:0];

endgenerate

generate
	if (p1_size==2)

	assign p1_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1]==1'b0) ? {mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16]} :
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) & (p1_addr[1]==1'b1) ? {mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0]} :
			p1_dev_rdata_r[31:0];

endgenerate

generate
	if ((p1_size!=1) & (p1_size!=2))

	assign p1_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b01) & (mem_dev_ack_r==1'b1) ? mem_dev_rdata_r[31:0] :
			p1_dev_rdata_r[31:0];

endgenerate

generate
	if (p2_size==1)

	assign p2_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1:0]==2'b00) ? {mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24]} :
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1:0]==2'b01) ? {mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16]} :
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1:0]==2'b10) ? {mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8]} :
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1:0]==2'b11) ? {mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0]} :
			p2_dev_rdata_r[31:0];

endgenerate

generate
	if (p2_size==2)

	assign p2_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1]==1'b0) ? {mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16]} :
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) & (p2_addr[1]==1'b1) ? {mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0]} :
			p2_dev_rdata_r[31:0];

endgenerate

generate
	if ((p2_size!=1) & (p2_size!=2))

	assign p2_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b10) & (mem_dev_ack_r==1'b1) ? mem_dev_rdata_r[31:0] :
			p2_dev_rdata_r[31:0];

endgenerate

generate
	if (p3_size==1)

	assign p3_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1:0]==2'b00) ? {mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24],mem_dev_rdata_r[31:24]} :
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1:0]==2'b01) ? {mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16],mem_dev_rdata_r[23:16]} :
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1:0]==2'b10) ? {mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8],mem_dev_rdata_r[15:8]} :
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1:0]==2'b11) ? {mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0],mem_dev_rdata_r[7:0]} :
			p3_dev_rdata_r[31:0];

endgenerate

generate
	if (p3_size==2)

	assign p3_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1]==1'b0) ? {mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16],mem_dev_rdata_r[31:16]} :
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) & (p3_addr[1]==1'b1) ? {mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0],mem_dev_rdata_r[15:0]} :
			p3_dev_rdata_r[31:0];

endgenerate

generate
	if ((p3_size!=1) & (p3_size!=2))

	assign p3_dev_rdata_w[31:0]=
			(mem_dev_master_r[1:0]==2'b11) & (mem_dev_ack_r==1'b1) ? mem_dev_rdata_r[31:0] :
			p3_dev_rdata_r[31:0];

endgenerate

	always @(negedge dev_rst_n or posedge dev_clk)
	begin
		if (dev_rst_n==1'b0)
			begin
				mem_dev_req_r[1:0] <= 2'b0;
				mem_dev_master_r[1:0] <= 2'b0;

				mem_dev_addr_r[31:0] <= 32'b0;
				mem_dev_wdata_r[31:0] <= 32'b0;
				mem_dev_be_r[3:0] <= 4'b0;
				mem_dev_ce_r <= 1'b0;
				mem_dev_wr_r <= 1'b0;
				mem_dev_rdata_r[31:0] <= 32'b0;
				mem_dev_ack_r <= 1'b0;
			end
		else
			begin
				mem_dev_req_r[1:0] <= mem_dev_req_w[1:0];
				mem_dev_master_r[1:0] <= mem_dev_master_w[1:0];

				mem_dev_addr_r[31:0] <= mem_dev_addr_w[31:0];
				mem_dev_wdata_r[31:0] <= mem_dev_wdata_w[31:0];
				mem_dev_be_r[3:0] <= mem_dev_be_w[3:0];
				mem_dev_ce_r <= mem_dev_ce_w;
				mem_dev_wr_r <= mem_dev_wr_w;
				mem_dev_rdata_r[31:0] <= mem_dev_rdata_w[31:0];
				mem_dev_ack_r <= mem_dev_ack_w;
			end
	end

	assign mem_dev_req_w[1:0]=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) & ({p0_dev_req}==1'b0) ? 2'b00 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) & ({p0_dev_req}!=1'b0) ? 2'b01 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req,p3_dev_req}==4'b0000) ? 2'b00 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req,p3_dev_req}!=4'b0000) ? 2'b01 :
			(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b0) ? 2'b01 :
			(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b1) ? 2'b11 :
			(mem_dev_req_r[1:0]==2'b11) ? 2'b10 :
			(mem_dev_req_r[1:0]==2'b10) ? 2'b00 :
			2'b00;

	assign mem_dev_master_w[1:0]=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) ? 2'b00 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req                      }==1'b1  ) ? 2'b00 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req           }==2'b01 ) ? 2'b01 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b001) ? 2'b10 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b000) ? 2'b11 :
			(mem_dev_req_r[1:0]!=2'b00) ? mem_dev_master_r[1:0] :
			2'b0;

	assign mem_dev_addr_w[31:0]=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) ? p0_addr[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req                      }==1'b1  ) ? p0_addr[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req           }==2'b01 ) ? p1_addr[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b001) ? p2_addr[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b000) ? p3_addr[31:0] :
			(mem_dev_req_r[1:0]!=2'b00) ? mem_dev_addr_r[31:0] :
			32'b0;

	assign mem_dev_wdata_w[31:0]=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) ? p0_wdata[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req                      }==1'b1  ) ? p0_wdata[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req           }==2'b01 ) ? p1_wdata[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b001) ? p2_wdata[31:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b000) ? p3_wdata[31:0] :
			(mem_dev_req_r[1:0]!=2'b00) ? mem_dev_wdata_r[31:0] :
			32'b0;

	assign mem_dev_be_w[3:0]=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) ? p0_be[3:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req                      }==1'b1  ) ? p0_be[3:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req           }==2'b01 ) ? p1_be[3:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b001) ? p2_be[3:0] :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b000) ? p3_be[3:0] :
			(mem_dev_req_r[1:0]!=2'b00) ? mem_dev_be_r[3:0] :
			4'b0;

	assign mem_dev_ce_w=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) & ({p0_dev_req}==1'b0) ? 1'b0 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) & ({p0_dev_req}!=1'b0) ? 1'b1 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req,p3_dev_req}==4'b0000) ? 1'b0 :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req,p3_dev_req}!=4'b0000) ? 1'b1 :
			(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b0) ? 1'b1 :
			(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b1) ? 1'b0 :
			(mem_dev_req_r[1:0]==2'b11) ? 1'b0 :
			(mem_dev_req_r[1:0]==2'b10) ? 1'b0 :
			1'b0;

	assign mem_dev_wr_w=
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b1) ? p0_wr :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req                      }==1'b1  ) ? p0_wr :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req           }==2'b01 ) ? p1_wr :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b001) ? p2_wr :
			(mem_dev_req_r[1:0]==2'b00) & (p0_busreq==1'b0) & ({p0_dev_req,p1_dev_req,p2_dev_req}==3'b000) ? p3_wr :
			(mem_dev_req_r[1:0]!=2'b00) ? mem_dev_wr_r :
			1'b0;

	assign mem_dev_rdata_w[31:0]=(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b1) ? dev_rdata[31:0] : mem_dev_rdata_r[31:0];

	assign mem_dev_ack_w=(mem_dev_req_r[1:0]==2'b01) & (dev_ack==1'b1) ? 1'b1 : 1'b0;

endmodule
