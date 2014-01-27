//------------------------------------------------------------------------------
//  nx1_mgbuff.v : mg - cellularram interface module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2012/feb/13 release 0.0  connection test
//       feb/22 release 0.1  mig style interface
//       feb/24 release 0.1a -> cram_mg.v , cram_mg_mt45w8mw16.v
//       feb/28 release 0.1b 32bit x6 port
//  2013/dec/27 release 0.2  rename nx1_mgbuff.v , add altsyncram_c3
//  2014/jan/10 release 0.2a preview
//
//------------------------------------------------------------------------------

module nx1_mgbuff #(
	parameter	DEVICE=4'h0			// device : 0=xilinx / 1=altera / 2= / 3= 
) (
	input			p0_cmd_clk,			// in    [MIG] cmd clk
	input			p0_cmd_en,			// in    [MIG] cmd en
	input	[2:0]	p0_cmd_instr,		// in    [MIG] cmd inst[2:0]
	input	[5:0]	p0_cmd_bl,			// in    [MIG] cmd blen[5:0]
	input	[29:0]	p0_cmd_byte_addr,	// in    [MIG] cmd addr[29:0]
	output			p0_cmd_empty,		// out   [MIG] cmd empt
	output			p0_cmd_full,		// out   [MIG] cmd full
	input			p0_wr_clk,			// in    [MIG] wr clk
	input			p0_wr_en,			// in    [MIG] wr en
	input	[3:0]	p0_wr_mask,			// in    [MIG] wr mask[3:0]
	input	[31:0]	p0_wr_data,			// in    [MIG] wr wdata[31:0]
	output			p0_wr_full,			// out   [MIG] wr full
	output			p0_wr_empty,		// out   [MIG] wr empt
	output	[6:0]	p0_wr_count,		// out   [MIG] wr count[6:0]
	output			p0_wr_underrun,		// out   [MIG] wr over
	output			p0_wr_error,		// out   [MIG] wr err
	input			p0_rd_clk,			// in    [MIG] rd clk
	input			p0_rd_en,			// in    [MIG] rd en
	output	[31:0]	p0_rd_data,			// out   [MIG] rd rdata[31:0]
	output			p0_rd_full,			// out   [MIG] rd full
	output			p0_rd_empty,		// out   [MIG] rd empt
	output	[6:0]	p0_rd_count,		// out   [MIG] rd count[6:0]
	output			p0_rd_overflow,		// out   [MIG] rd over
	output			p0_rd_error,		// out   [MIG] rd err

	output			mem0_cmd_req,		// out   [MEM] 
	output	[2:0]	mem0_cmd_instr,		// out   [MEM] 
	output	[5:0]	mem0_cmd_bl,		// out   [MEM] 
	output	[29:0]	mem0_cmd_byte_addr,	// out   [MEM] 
	input			mem0_cmd_ack,		// in    [MEM] 
	output	[3:0]	mem0_wr_mask,		// out   [MEM] 
	output	[31:0]	mem0_wr_data,		// out   [MEM] 
	input			mem0_wr_ack,		// in    [MEM] 
	input			mem0_rd_req,		// in    [MEM] 
	input	[31:0]	mem0_rd_data,		// in    [MEM] 

	input			mem_rst_n,			// in    [MEM] #rst
	input			mem_clk				// in    [MEM] clk
);


	// cmd buff

	reg		[2:0] p0_cmd_instr_r;
	reg		[5:0] p0_cmd_bl_r;
	reg		[29:0] p0_cmd_byte_addr_r;
	reg		[2:0] p0_cmd_req_r;
	reg		[3:0] p0_cmd_ack_r;
	wire	[2:0] p0_cmd_instr_w;
	wire	[5:0] p0_cmd_bl_w;
	wire	[29:0] p0_cmd_byte_addr_w;
	wire	[2:0] p0_cmd_req_w;
	wire	[3:0] p0_cmd_ack_w;

	wire	p0_cmd_req;
	wire	p0_cmd_ack;
	wire	p0_cmd_read;

	reg		mem0_cmd_en_r;
	reg		[3:0] mem0_cmd_req_r;
	reg		mem0_cmd_ack_r;
	wire	mem0_cmd_en_w;
	wire	[3:0] mem0_cmd_req_w;
	wire	mem0_cmd_ack_w;


	assign p0_cmd_req=p0_cmd_req_r[2];
	assign p0_cmd_read=p0_cmd_req_r[1];

//	always @(negedge p0_cmd_clk or negedge mem_rst_n)
	always @(posedge p0_cmd_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p0_cmd_ack_r[0] <= 1'b0;
			end
		else
			begin
				p0_cmd_ack_r[0] <= p0_cmd_ack_w[0];
			end
	end

	always @(posedge p0_cmd_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p0_cmd_instr_r[2:0] <= 3'b0;
				p0_cmd_bl_r[5:0] <= 6'b0;
				p0_cmd_byte_addr_r[29:0] <= 30'b0;
				p0_cmd_req_r[2:0] <= 3'b0;
				p0_cmd_ack_r[1] <= 1'b0;
				p0_cmd_ack_r[2] <= 1'b0;
				p0_cmd_ack_r[3] <= 1'b0;
			end
		else
			begin
				p0_cmd_instr_r[2:0] <= p0_cmd_instr_w[2:0];
				p0_cmd_bl_r[5:0] <= p0_cmd_bl_w[5:0];
				p0_cmd_byte_addr_r[29:0] <= p0_cmd_byte_addr_w[29:0];
				p0_cmd_req_r[2:0] <= p0_cmd_req_w[2:0];
				p0_cmd_ack_r[1] <= p0_cmd_ack_w[1];
				p0_cmd_ack_r[2] <= p0_cmd_ack_w[2];
				p0_cmd_ack_r[3] <= p0_cmd_ack_w[3];
			end
	end

	assign p0_cmd_instr_w[2:0]=(p0_cmd_read==1'b1) ? p0_cmd_rdata[38:36] : p0_cmd_instr_r[2:0];
	assign p0_cmd_bl_w[5:0]=(p0_cmd_read==1'b1) ? p0_cmd_rdata[35:30] : p0_cmd_bl_r[5:0];
	assign p0_cmd_byte_addr_w[29:0]=(p0_cmd_read==1'b1) ? p0_cmd_rdata[29:0] : p0_cmd_byte_addr_r[29:0];

	assign p0_cmd_req_w[0]=
			(p0_cmd_req_r[0]==1'b0) & (p0_cmd_empty==1'b1) ? 1'b0 :
			(p0_cmd_req_r[0]==1'b0) & (p0_cmd_empty==1'b0) ? 1'b1 :
			(p0_cmd_req_r[0]==1'b1) & (p0_cmd_ack==1'b0) ? 1'b1 :
			(p0_cmd_req_r[0]==1'b1) & (p0_cmd_ack==1'b1) ? 1'b0 :
			2'b00;
	assign p0_cmd_req_w[1]=({p0_cmd_req_r[0],p0_cmd_empty}==2'b00) ? 1'b1 : 1'b0;
	assign p0_cmd_req_w[2]=({p0_cmd_req_r[0],p0_cmd_empty}==2'b00) ? !p0_cmd_req_r[2] : p0_cmd_req_r[2];
	assign p0_cmd_ack=((p0_cmd_ack_r[2:1]==2'b01) | (p0_cmd_ack_r[2:1]==2'b10)) ? 1'b1 : 1'b0;

	assign p0_cmd_ack_w[0]=mem0_cmd_ack_r;
	assign p0_cmd_ack_w[1]=p0_cmd_ack_r[0];
	assign p0_cmd_ack_w[2]=p0_cmd_ack_r[1];
	assign p0_cmd_ack_w[3]=p0_cmd_ack_r[2];

	wire	[2:0] p0_cmd_wr_addr;
	wire	[38:0] p0_cmd_rdata;

	reg		[2:0] p0_cmd_waddr_r;
	reg		[2:0] p0_cmd_raddr_r;
	wire	[2:0] p0_cmd_waddr_w;
	wire	[2:0] p0_cmd_raddr_w;

	always @(posedge p0_cmd_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p0_cmd_waddr_r[2:0] <= 3'b0;
				p0_cmd_raddr_r[2:0] <= 3'b0;
			end
		else
			begin
				p0_cmd_waddr_r[2:0] <= p0_cmd_waddr_w[2:0];
				p0_cmd_raddr_r[2:0] <= p0_cmd_raddr_w[2:0];
			end
	end

	assign p0_cmd_waddr_w[2:0]=(p0_cmd_en==1'b1) ? p0_cmd_waddr_r[2:0]+3'b01 : p0_cmd_waddr_r[2:0];
	assign p0_cmd_raddr_w[2:0]=(p0_cmd_read==1'b1) ? p0_cmd_raddr_r[2:0]+3'b01 : p0_cmd_raddr_r[2:0];

	assign p0_cmd_wr_addr[2:0]=(p0_cmd_waddr_r[2:0]-p0_cmd_raddr_r[2:0]);

	assign p0_cmd_full=(p0_cmd_wr_addr[2]==1'b1) ? 1'b1 : 1'b0;
	assign p0_cmd_empty=(p0_cmd_wr_addr[2:0]==3'b0) ? 1'b1 : 1'b0;

generate
	if (DEVICE==0)
begin

	wire	[63:0] cmd_rd_data;

	assign p0_cmd_rdata[38:0]=cmd_rd_data[38:0];

xil_blk_mem_gen_v7_2_dp64x16 p0_cmd_fifo(
	.clka(p0_cmd_clk),
	.ena(1'b1),
	.wea(p0_cmd_en),
	.addra({2'b0,p0_cmd_waddr_r[1:0]}),
	.dina({25'b0,p0_cmd_instr[2:0],p0_cmd_bl[5:0],p0_cmd_byte_addr[29:0]}),
	.clkb(mem_clk),
	.enb(1'b1),
	.addrb({2'b0,p0_cmd_raddr_r[1:0]}),
	.doutb(cmd_rd_data[63:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

	wire	[63:0] cmd_rd_data;

	assign p0_cmd_rdata[38:0]=cmd_rd_data[38:0];

alt_altsyncram_c3dp64x16 p0_cmd_fifo(
	.data({25'b0,p0_cmd_instr[2:0],p0_cmd_bl[5:0],p0_cmd_byte_addr[29:0]}),
	.rdaddress({2'b0,p0_cmd_raddr_r[1:0]}),
	.rdclock(mem_clk),
	.wraddress({2'b0,p0_cmd_waddr_r[1:0]}),
	.wrclock(p0_cmd_clk),
	.wren(p0_cmd_en),
	.q(cmd_rd_data[63:0])
);

end
endgenerate

	assign mem0_cmd_req=mem0_cmd_en_r;
	assign mem0_cmd_instr[2:0]=p0_cmd_instr_r[2:0];
	assign mem0_cmd_bl[5:0]=p0_cmd_bl_r[5:0];
	assign mem0_cmd_byte_addr[29:0]=p0_cmd_byte_addr_r[29:0];

//	always @(negedge mem_clk or negedge mem_rst_n)
	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_cmd_req_r[0] <= 1'b0;
			end
		else
			begin
				mem0_cmd_req_r[0] <= mem0_cmd_req_w[0];
			end
	end

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_cmd_en_r <= 1'b0;
				mem0_cmd_req_r[1] <= 1'b0;
				mem0_cmd_req_r[2] <= 1'b0;
				mem0_cmd_req_r[3] <= 1'b0;
				mem0_cmd_ack_r <= 1'b0;
			end
		else
			begin
				mem0_cmd_en_r <= mem0_cmd_en_w;
				mem0_cmd_req_r[1] <= mem0_cmd_req_w[1];
				mem0_cmd_req_r[2] <= mem0_cmd_req_w[2];
				mem0_cmd_req_r[3] <= mem0_cmd_req_w[3];
				mem0_cmd_ack_r <= mem0_cmd_ack_w;
			end
	end

	assign mem0_cmd_req_w[0]=p0_cmd_req;
	assign mem0_cmd_req_w[1]=mem0_cmd_req_r[0];
	assign mem0_cmd_req_w[2]=mem0_cmd_req_r[1];
	assign mem0_cmd_req_w[3]=mem0_cmd_req_r[2];

	assign mem0_cmd_en_w=
			 ((mem0_cmd_req_r[2:1]==2'b10) | (mem0_cmd_req_r[2:1]==2'b01)) ? 1'b1 :
			!((mem0_cmd_req_r[2:1]==2'b10) | (mem0_cmd_req_r[2:1]==2'b01)) & (mem0_cmd_ack==1'b1) ? 1'b0 :
			!((mem0_cmd_req_r[2:1]==2'b10) | (mem0_cmd_req_r[2:1]==2'b01)) & (mem0_cmd_ack==1'b0) ? mem0_cmd_en_r :
			1'b0;

	assign mem0_cmd_ack_w=(mem0_cmd_ack==1'b1) ? !mem0_cmd_ack_r : mem0_cmd_ack_r;

	// wr buff

	wire	mem0_wbuff_rd;
	wire	[35:0] mem0_wbuff_rdata;
	reg		[6:0] mem0_p0_wr_addr_r;
	wire	[6:0] mem0_p0_wr_addr_w;

	reg		[6:0] mem0_wbuff_raddr_r;
	wire	[6:0] mem0_wbuff_raddr_w;

	assign mem0_wbuff_rd=mem0_wr_ack;
	assign {mem0_wr_mask[3:0],mem0_wr_data[31:0]}=mem0_wbuff_rdata[35:0];

	always @(posedge p0_wr_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_p0_wr_addr_r[6:0] <= 7'b0;
			end
		else
			begin
				mem0_p0_wr_addr_r[6:0] <= mem0_p0_wr_addr_w[6:0];
			end
	end

	assign mem0_p0_wr_addr_w[6:0]=(p0_wr_en==1'b1) ? mem0_p0_wr_addr_r[6:0]+7'b01 : mem0_p0_wr_addr_r[6:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_wbuff_raddr_r[6:0] <= 7'b0;
			end
		else
			begin
				mem0_wbuff_raddr_r[6:0] <= mem0_wbuff_raddr_w[6:0];
			end
	end

	assign mem0_wbuff_raddr_w[6:0]=(mem0_wbuff_rd==1'b1) ? mem0_wbuff_raddr_r[6:0]+7'b01 : mem0_wbuff_raddr_r[6:0];

	wire	[6:0] mem0_wr_addr;

	assign mem0_wr_addr[6:0]=(mem0_p0_wr_addr_r[6:0]-mem0_wbuff_raddr_r[6:0]);

	assign p0_wr_count[6:0]=mem0_wr_addr[6:0];
	assign p0_wr_full=(mem0_wr_addr[6]==1'b1) ? 1'b1 : 1'b0;
	assign p0_wr_empty=(mem0_wr_addr[6:0]==7'h00) ? 1'b1 : 1'b0;
	assign p0_wr_underrun=(mem0_wr_addr[6]==1'b1) & (mem0_wr_addr[5:0]!=6'h00) ? 1'b1 : 1'b0;
	assign p0_wr_error=(mem0_wr_addr[6]==1'b1) & (mem0_wr_addr[5:0]!=6'h00) ? 1'b1 : 1'b0;

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_v7_2_dp36x64 p0_wr_buff(
	.clka(p0_wr_clk),
	.ena(1'b1),
	.wea(p0_wr_en),
	.addra(mem0_p0_wr_addr_r[5:0]),
	.dina({p0_wr_mask[3:0],p0_wr_data[31:0]}),
	.clkb(mem_clk),
	.enb(1'b1),
	.addrb(mem0_wbuff_raddr_r[5:0]),
	.doutb(mem0_wbuff_rdata[35:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_c3dp36x64 p0_wr_buff(
	.data({p0_wr_mask[3:0],p0_wr_data[31:0]}),
	.rdaddress(mem0_wbuff_raddr_r[5:0]),
	.rdclock(mem_clk),
	.wraddress(mem0_p0_wr_addr_r[5:0]),
	.wrclock(p0_wr_clk),
	.wren(p0_wr_en),
	.q(mem0_wbuff_rdata[35:0])
);

end
endgenerate

	// rd buff

	wire	mem0_rbuff_wr;
	wire	[31:0] mem0_rbuff_wdata;

	reg		[6:0] mem0_rbuff_waddr_r;
	wire	[6:0] mem0_rbuff_waddr_w;

	reg		[6:0] mem0_p0_rd_addr_r;
	reg		[6:0] mem0_p0_rd_buff_r;
	wire	[6:0] mem0_p0_rd_addr_w;
	wire	[6:0] mem0_p0_rd_buff_w;

	assign mem0_rbuff_wr=mem0_rd_req;
	assign mem0_rbuff_wdata[31:0]=mem0_rd_data[31:0];

	reg		[3:0] mem0_rbuff_waddr_ack_r;
	reg		mem0_rbuff_waddr_req_r;
	reg		[6:0] mem0_rbuff_waddr_point_r;
	wire	[3:0] mem0_rbuff_waddr_ack_w;
	wire	mem0_rbuff_waddr_req_w;
	wire	[6:0] mem0_rbuff_waddr_point_w;

//	always @(negedge mem_clk or negedge mem_rst_n)
	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_rbuff_waddr_ack_r[0] <= 1'b0;
			end
		else
			begin
				mem0_rbuff_waddr_ack_r[0] <= mem0_rbuff_waddr_ack_w[0];
			end
	end

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
			//	mem0_wbuff_raddr_r[6:0] <= 7'b0;
				mem0_rbuff_waddr_r[6:0] <= 7'b0;
				mem0_rbuff_waddr_ack_r[1] <= 1'b0;
				mem0_rbuff_waddr_ack_r[2] <= 1'b0;
				mem0_rbuff_waddr_ack_r[3] <= 1'b0;
				mem0_rbuff_waddr_req_r <= 1'b0;
				mem0_rbuff_waddr_point_r[6:0] <= 7'b0;
			end
		else
			begin
			//	mem0_wbuff_raddr_r[6:0] <= mem0_wbuff_raddr_w[6:0];
				mem0_rbuff_waddr_r[6:0] <= mem0_rbuff_waddr_w[6:0];
				mem0_rbuff_waddr_ack_r[1] <= mem0_rbuff_waddr_ack_w[1];
				mem0_rbuff_waddr_ack_r[2] <= mem0_rbuff_waddr_ack_w[2];
				mem0_rbuff_waddr_ack_r[3] <= mem0_rbuff_waddr_ack_w[3];
				mem0_rbuff_waddr_req_r <= mem0_rbuff_waddr_req_w;
				mem0_rbuff_waddr_point_r[6:0] <= mem0_rbuff_waddr_point_w[6:0];
			end
	end

	assign mem0_rbuff_waddr_w[6:0]=(mem0_rbuff_wr==1'b1) ? mem0_rbuff_waddr_r[6:0]+7'b01 : mem0_rbuff_waddr_r[6:0];

	assign mem0_rbuff_waddr_ack_w[0]=mem0_p0_rd_buff_req_r;
	assign mem0_rbuff_waddr_ack_w[1]=mem0_rbuff_waddr_ack_r[0];
	assign mem0_rbuff_waddr_ack_w[2]=mem0_rbuff_waddr_ack_r[1];
	assign mem0_rbuff_waddr_ack_w[3]=mem0_rbuff_waddr_ack_r[2];
	assign mem0_rbuff_waddr_req_w=((mem0_rbuff_waddr_ack_r[2:1]==2'b01) | (mem0_rbuff_waddr_ack_r[2:1]==2'b10)) ? !mem0_rbuff_waddr_req_r : mem0_rbuff_waddr_req_r;
	assign mem0_rbuff_waddr_point_w[6:0]=((mem0_rbuff_waddr_ack_r[2:1]==2'b01) | (mem0_rbuff_waddr_ack_r[2:1]==2'b10)) ? mem0_rbuff_waddr_r[6:0] : mem0_rbuff_waddr_point_r[6:0];

	reg		[3:0] mem0_p0_rd_buff_ack_r;
	reg		mem0_p0_rd_buff_req_r;
	wire	[3:0] mem0_p0_rd_buff_ack_w;
	wire	mem0_p0_rd_buff_req_w;

//	always @(negedge p0_rd_clk or negedge mem_rst_n)
	always @(posedge p0_rd_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_p0_rd_buff_ack_r[0] <= 1'b0;
			end
		else
			begin
				mem0_p0_rd_buff_ack_r[0] <= mem0_p0_rd_buff_ack_w[0];
			end
	end

	always @(posedge p0_rd_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem0_p0_rd_addr_r[6:0] <= 7'b0;
				mem0_p0_rd_buff_ack_r[1] <= 1'b0;
				mem0_p0_rd_buff_ack_r[2] <= 1'b0;
				mem0_p0_rd_buff_ack_r[3] <= 1'b0;
				mem0_p0_rd_buff_req_r <= 1'b1;
				mem0_p0_rd_buff_r[6:0] <= 7'b0;
			end
		else
			begin
				mem0_p0_rd_addr_r[6:0] <= mem0_p0_rd_addr_w[6:0];
				mem0_p0_rd_buff_ack_r[1] <= mem0_p0_rd_buff_ack_w[1];
				mem0_p0_rd_buff_ack_r[2] <= mem0_p0_rd_buff_ack_w[2];
				mem0_p0_rd_buff_ack_r[3] <= mem0_p0_rd_buff_ack_w[3];
				mem0_p0_rd_buff_req_r <= mem0_p0_rd_buff_req_w;
				mem0_p0_rd_buff_r[6:0] <= mem0_p0_rd_buff_w[6:0];
			end
	end

	assign mem0_p0_rd_addr_w[6:0]=(p0_rd_en==1'b1) ? mem0_p0_rd_addr_r[6:0]+7'b01 : mem0_p0_rd_addr_r[6:0];

	assign mem0_p0_rd_buff_ack_w[0]=mem0_rbuff_waddr_req_r;
	assign mem0_p0_rd_buff_ack_w[1]=mem0_p0_rd_buff_ack_r[0];
	assign mem0_p0_rd_buff_ack_w[2]=mem0_p0_rd_buff_ack_r[1];
	assign mem0_p0_rd_buff_ack_w[3]=mem0_p0_rd_buff_ack_r[2];
	assign mem0_p0_rd_buff_req_w=((mem0_p0_rd_buff_ack_r[2:1]==2'b01) | (mem0_p0_rd_buff_ack_r[2:1]==2'b10)) ? !mem0_p0_rd_buff_req_r : mem0_p0_rd_buff_req_r;
	assign mem0_p0_rd_buff_w[6:0]=((mem0_p0_rd_buff_ack_r[2:1]==2'b01) | (mem0_p0_rd_buff_ack_r[2:1]==2'b10)) ? mem0_rbuff_waddr_point_r[6:0] : mem0_p0_rd_buff_r[6:0];

	wire	[6:0] mem0_rd_addr;

//	assign mem0_rd_addr[6:0]=(mem0_rbuff_waddr_r[6:0]-mem0_p0_rd_addr_r[6:0]);	// sync
	assign mem0_rd_addr[6:0]=(mem0_p0_rd_buff_r[6:0]-mem0_p0_rd_addr_r[6:0]);	// async

	assign p0_rd_count[6:0]=mem0_rd_addr[6:0];
	assign p0_rd_full=(mem0_rd_addr[6]==1'b1) ? 1'b1 : 1'b0;
	assign p0_rd_empty=(mem0_rd_addr[6:0]==7'h00) ? 1'b1 : 1'b0;
	assign p0_rd_overflow=(mem0_rd_addr[6]==1'b1) & (mem0_rd_addr[5:0]!=6'h00) ? 1'b1 : 1'b0;
	assign p0_rd_error=(mem0_rd_addr[6]==1'b1) & (mem0_rd_addr[5:0]!=6'h00) ? 1'b1 : 1'b0;

generate
	if (DEVICE==0)
begin

	wire	[35:0] buff_rd_data;

	assign p0_rd_data[31:0]=buff_rd_data[31:0];

xil_blk_mem_gen_v7_2_dp36x64 p0_rd_buff(
	.clka(mem_clk),
	.ena(1'b1),
	.wea(mem0_rbuff_wr),
	.addra(mem0_rbuff_waddr_r[5:0]),
	.dina({4'b0,mem0_rbuff_wdata[31:0]}),
	.clkb(p0_rd_clk),
	.enb(1'b1),
	.addrb(mem0_p0_rd_addr_w[5:0]),
	.doutb(buff_rd_data[35:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

	wire	[35:0] buff_rd_data;

	assign p0_rd_data[31:0]=buff_rd_data[31:0];

alt_altsyncram_c3dp36x64 p0_rd_buff(
	.data({4'b0,mem0_rbuff_wdata[31:0]}),
	.rdaddress(mem0_p0_rd_addr_w[5:0]),
	.rdclock(p0_rd_clk),
	.wraddress(mem0_rbuff_waddr_r[5:0]),
	.wrclock(mem_clk),
	.wren(mem0_rbuff_wr),
	.q(buff_rd_data[35:0])
);

end
endgenerate

endmodule
