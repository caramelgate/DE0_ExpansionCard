//------------------------------------------------------------------------------
//  nx1_mgarb.v : cellularram arbiter module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2012/feb/13 release 0.0  connection test
//       feb/22 release 0.1  mig style interface
//       feb/24 release 0.1a -> cram_mg.v , cram_mg_mt45w8mw16.v
//       feb/28 release 0.1b 32bit x6 port rw-rw-w-w-r-r
//  2013/dec/27 release 0.2  rw-rw-rw-r-r , rename nx1_mgarb.v , add altsyncram_c3
//  2014/jan/10 release 0.2a preview
//
//------------------------------------------------------------------------------

module nx1_mgarb #(
	parameter	DEVICE=4'h0			// device : 0=xilinx / 1=altera / 2= / 3= 
) (
	input			init_done,			// in    [MEM] #init/done

	output			mem_cmd_req,		// out   [MEM] cmd req
	output	[2:0]	mem_cmd_instr,		// out   [MEM] cmd inst[2:0]
	output	[5:0]	mem_cmd_bl,			// out   [MEM] cmd blen[5:0]
	output	[29:0]	mem_cmd_byte_addr,	// out   [MEM] cmd addr[29:0]
	output	[2:0]	mem_cmd_master,		// out   [MEM] cmd master[2:0]
	input			mem_cmd_ack,		// in    [MEM] cmd ack
	output	[3:0]	mem_wr_mask,		// out   [MEM] wr mask[3:0]
	output	[31:0]	mem_wr_data,		// out   [MEM] wr wdata[31:0]
	input			mem_wr_ack,			// in    [MEM] wr ack
	input	[2:0]	mem_wr_master,		// in    [MEM] wr master[2:0]
	input			mem_rd_req,			// in    [MEM] rd req
	input	[31:0]	mem_rd_data,		// in    [MEM] rd rdata[31:0]
	input	[2:0]	mem_rd_master,		// in    [MEM] rd master[2:0]

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

	input			p1_cmd_clk,			// in    [MIG] cmd clk
	input			p1_cmd_en,			// in    [MIG] cmd en
	input	[2:0]	p1_cmd_instr,		// in    [MIG] cmd inst[2:0]
	input	[5:0]	p1_cmd_bl,			// in    [MIG] cmd blen[5:0]
	input	[29:0]	p1_cmd_byte_addr,	// in    [MIG] cmd addr[29:0]
	output			p1_cmd_empty,		// out   [MIG] cmd empt
	output			p1_cmd_full,		// out   [MIG] cmd full
	input			p1_wr_clk,			// in    [MIG] wr clk
	input			p1_wr_en,			// in    [MIG] wr en
	input	[3:0]	p1_wr_mask,			// in    [MIG] wr mask[3:0]
	input	[31:0]	p1_wr_data,			// in    [MIG] wr wdata[31:0]
	output			p1_wr_full,			// out   [MIG] wr full
	output			p1_wr_empty,		// out   [MIG] wr empt
	output	[6:0]	p1_wr_count,		// out   [MIG] wr count[6:0]
	output			p1_wr_underrun,		// out   [MIG] wr over
	output			p1_wr_error,		// out   [MIG] wr err
	input			p1_rd_clk,			// in    [MIG] rd clk
	input			p1_rd_en,			// in    [MIG] rd en
	output	[31:0]	p1_rd_data,			// out   [MIG] rd rdata[31:0]
	output			p1_rd_full,			// out   [MIG] rd full
	output			p1_rd_empty,		// out   [MIG] rd empt
	output	[6:0]	p1_rd_count,		// out   [MIG] rd count[6:0]
	output			p1_rd_overflow,		// out   [MIG] rd over
	output			p1_rd_error,		// out   [MIG] rd err

	input			p2_cmd_clk,			// in    [MIG] cmd clk
	input			p2_cmd_en,			// in    [MIG] cmd en
	input	[2:0]	p2_cmd_instr,		// in    [MIG] cmd inst[2:0]
	input	[5:0]	p2_cmd_bl,			// in    [MIG] cmd blen[5:0]
	input	[29:0]	p2_cmd_byte_addr,	// in    [MIG] cmd addr[29:0]
	output			p2_cmd_empty,		// out   [MIG] cmd empt
	output			p2_cmd_full,		// out   [MIG] cmd full
	input			p2_wr_clk,			// in    [MIG] wr clk
	input			p2_wr_en,			// in    [MIG] wr en
	input	[3:0]	p2_wr_mask,			// in    [MIG] wr mask[3:0]
	input	[31:0]	p2_wr_data,			// in    [MIG] wr wdata[31:0]
	output			p2_wr_full,			// out   [MIG] wr full
	output			p2_wr_empty,		// out   [MIG] wr empt
	output	[6:0]	p2_wr_count,		// out   [MIG] wr count[6:0]
	output			p2_wr_underrun,		// out   [MIG] wr over
	output			p2_wr_error,		// out   [MIG] wr err
	input			p2_rd_clk,			// in    [MIG] rd clk
	input			p2_rd_en,			// in    [MIG] rd en
	output	[31:0]	p2_rd_data,			// out   [MIG] rd rdata[31:0]
	output			p2_rd_full,			// out   [MIG] rd full
	output			p2_rd_empty,		// out   [MIG] rd empt
	output	[6:0]	p2_rd_count,		// out   [MIG] rd count[6:0]
	output			p2_rd_overflow,		// out   [MIG] rd over
	output			p2_rd_error,		// out   [MIG] rd err

	input			p3_cmd_clk,			// in    [MIG] cmd clk
	input			p3_cmd_en,			// in    [MIG] cmd en
	input	[2:0]	p3_cmd_instr,		// in    [MIG] cmd inst[2:0]
	input	[5:0]	p3_cmd_bl,			// in    [MIG] cmd blen[5:0]
	input	[29:0]	p3_cmd_byte_addr,	// in    [MIG] cmd addr[29:0]
	output			p3_cmd_empty,		// out   [MIG] cmd empt
	output			p3_cmd_full,		// out   [MIG] cmd full
	input			p3_rd_clk,			// in    [MIG] rd clk
	input			p3_rd_en,			// in    [MIG] rd en
	output	[31:0]	p3_rd_data,			// out   [MIG] rd rdata[31:0]
	output			p3_rd_full,			// out   [MIG] rd full
	output			p3_rd_empty,		// out   [MIG] rd empt
	output	[6:0]	p3_rd_count,		// out   [MIG] rd count[6:0]
	output			p3_rd_overflow,		// out   [MIG] rd over
	output			p3_rd_error,		// out   [MIG] rd err

	input			p4_cmd_clk,			// in    [MIG] cmd clk
	input			p4_cmd_en,			// in    [MIG] cmd en
	input	[2:0]	p4_cmd_instr,		// in    [MIG] cmd inst[2:0]
	input	[5:0]	p4_cmd_bl,			// in    [MIG] cmd blen[5:0]
	input	[29:0]	p4_cmd_byte_addr,	// in    [MIG] cmd addr[29:0]
	output			p4_cmd_empty,		// out   [MIG] cmd empt
	output			p4_cmd_full,		// out   [MIG] cmd full
	input			p4_rd_clk,			// in    [MIG] rd clk
	input			p4_rd_en,			// in    [MIG] rd en
	output	[31:0]	p4_rd_data,			// out   [MIG] rd rdata[31:0]
	output			p4_rd_full,			// out   [MIG] rd full
	output			p4_rd_empty,		// out   [MIG] rd empt
	output	[6:0]	p4_rd_count,		// out   [MIG] rd count[6:0]
	output			p4_rd_overflow,		// out   [MIG] rd over
	output			p4_rd_error,		// out   [MIG] rd err

	input			mem_rst_n,			// in    [MEM] #rst
	input			mem_clk				// in    [MEM] clk
);

//	parameter	p0_cmd_single=0;	// 1:cmdbuff single / 0:cmdbuff depth=4
//	parameter	p0_cmd_async=1;		// 0:p?_?_clk=mem_clk / 1:async p?_?_clk,mem_clk
//	parameter	p0_wr_single=0;		// 1:wrbuff single / 0:wrbuff depth=64
//	parameter	p0_wr_async=1;		// 
//	parameter	p0_rd_single=0;		// 1:rdbuff single / 0:rdbuff depth=64
//	parameter	p0_rd_async=1;		// 

	// access control

	wire	[2:0] mem_master;

	wire	mem0_cmd_req;
	wire	[2:0] mem0_cmd_instr;
	wire	[5:0] mem0_cmd_bl;
	wire	[29:0] mem0_cmd_byte_addr;
	wire	mem0_cmd_ack;
	wire	[3:0] mem0_wr_mask;
	wire	[31:0] mem0_wr_data;
	wire	mem0_wr_ack;
	wire	mem0_rd_req;
	wire	[31:0] mem0_rd_data;

	wire	mem1_cmd_req;
	wire	[2:0] mem1_cmd_instr;
	wire	[5:0] mem1_cmd_bl;
	wire	[29:0] mem1_cmd_byte_addr;
	wire	mem1_cmd_ack;
	wire	[3:0] mem1_wr_mask;
	wire	[31:0] mem1_wr_data;
	wire	mem1_wr_ack;
	wire	mem1_rd_req;
	wire	[31:0] mem1_rd_data;

	wire	mem2_cmd_req;
	wire	[2:0] mem2_cmd_instr;
	wire	[5:0] mem2_cmd_bl;
	wire	[29:0] mem2_cmd_byte_addr;
	wire	mem2_cmd_ack;
	wire	[3:0] mem2_wr_mask;
	wire	[31:0] mem2_wr_data;
	wire	mem2_wr_ack;
	wire	mem2_rd_req;
	wire	[31:0] mem2_rd_data;

	wire	mem3_cmd_req;
	wire	[2:0] mem3_cmd_instr;
	wire	[5:0] mem3_cmd_bl;
	wire	[29:0] mem3_cmd_byte_addr;
	wire	mem3_cmd_ack;
	wire	[3:0] mem3_wr_mask;
	wire	[31:0] mem3_wr_data;
	wire	mem3_wr_ack;
	wire	mem3_rd_req;
	wire	[31:0] mem3_rd_data;

	wire	mem4_cmd_req;
	wire	[2:0] mem4_cmd_instr;
	wire	[5:0] mem4_cmd_bl;
	wire	[29:0] mem4_cmd_byte_addr;
	wire	mem4_cmd_ack;
	wire	[3:0] mem4_wr_mask;
	wire	[31:0] mem4_wr_data;
	wire	mem4_wr_ack;
	wire	mem4_rd_req;
	wire	[31:0] mem4_rd_data;

	wire	mem5_cmd_req;
	wire	[2:0] mem5_cmd_instr;
	wire	[5:0] mem5_cmd_bl;
	wire	[29:0] mem5_cmd_byte_addr;
	wire	mem5_cmd_ack;
	wire	[3:0] mem5_wr_mask;
	wire	[31:0] mem5_wr_data;
	wire	mem5_wr_ack;
	wire	mem5_rd_req;
	wire	[31:0] mem5_rd_data;

	reg		[2:0] mem_master_r;
	reg		[2:0] mem_pri_r;
	reg		mem_cmd_req_r;
	reg		mem_cmd_ack_r;
	wire	[2:0] mem_master_w;
	wire	[2:0] mem_pri_w;
	wire	mem_cmd_req_w;
	wire	mem_cmd_ack_w;

	assign mem_master[2:0]=mem_master_r[2:0];

	assign mem_cmd_req=mem_cmd_req_r;

	assign mem_cmd_instr[2:0]=
			(mem_master[2:0]==3'h0) ? mem0_cmd_instr[2:0] :
			(mem_master[2:0]==3'h1) ? mem1_cmd_instr[2:0] :
			(mem_master[2:0]==3'h2) ? mem2_cmd_instr[2:0] :
			(mem_master[2:0]==3'h3) ? mem3_cmd_instr[2:0] :
			(mem_master[2:0]==3'h4) ? mem4_cmd_instr[2:0] :
			(mem_master[2:0]==3'h5) ? mem5_cmd_instr[2:0] :
			3'b0;
	assign mem_cmd_bl[5:0]=
			(mem_master[2:0]==3'h0) ? mem0_cmd_bl[5:0] :
			(mem_master[2:0]==3'h1) ? mem1_cmd_bl[5:0] :
			(mem_master[2:0]==3'h2) ? mem2_cmd_bl[5:0] :
			(mem_master[2:0]==3'h3) ? mem3_cmd_bl[5:0] :
			(mem_master[2:0]==3'h4) ? mem4_cmd_bl[5:0] :
			(mem_master[2:0]==3'h5) ? mem5_cmd_bl[5:0] :
			6'b0;
	assign mem_cmd_byte_addr[29:0]=
			(mem_master[2:0]==3'h0) ? mem0_cmd_byte_addr[29:0] :
			(mem_master[2:0]==3'h1) ? mem1_cmd_byte_addr[29:0] :
			(mem_master[2:0]==3'h2) ? mem2_cmd_byte_addr[29:0] :
			(mem_master[2:0]==3'h3) ? mem3_cmd_byte_addr[29:0] :
			(mem_master[2:0]==3'h4) ? mem4_cmd_byte_addr[29:0] :
			(mem_master[2:0]==3'h5) ? mem5_cmd_byte_addr[29:0] :
			30'b0;
	assign mem_cmd_master[2:0]=mem_master[2:0];

	assign mem0_cmd_ack=(mem_master[2:0]==3'h0) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem1_cmd_ack=(mem_master[2:0]==3'h1) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem2_cmd_ack=(mem_master[2:0]==3'h2) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem3_cmd_ack=(mem_master[2:0]==3'h3) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem4_cmd_ack=(mem_master[2:0]==3'h4) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem5_cmd_ack=(mem_master[2:0]==3'h5) & (mem_cmd_ack==1'b1) ? 1'b1 : 1'b0;

	assign mem_wr_mask[3:0]=
			(mem_wr_master[2:0]==2'h0) ? mem0_wr_mask[3:0] :
			(mem_wr_master[2:0]==2'h1) ? mem1_wr_mask[3:0] :
			(mem_wr_master[2:0]==2'h2) ? mem2_wr_mask[3:0] :
			(mem_wr_master[2:0]==2'h3) ? mem3_wr_mask[3:0] :
			(mem_wr_master[2:0]==2'h4) ? mem4_wr_mask[3:0] :
			(mem_wr_master[2:0]==2'h5) ? mem5_wr_mask[3:0] :
			4'b1111;

	assign mem_wr_data[31:0]=
			(mem_wr_master[2:0]==2'h0) ? mem0_wr_data[31:0] :
			(mem_wr_master[2:0]==2'h1) ? mem1_wr_data[31:0] :
			(mem_wr_master[2:0]==2'h2) ? mem2_wr_data[31:0] :
			(mem_wr_master[2:0]==2'h3) ? mem3_wr_data[31:0] :
			(mem_wr_master[2:0]==2'h4) ? mem4_wr_data[31:0] :
			(mem_wr_master[2:0]==2'h5) ? mem5_wr_data[31:0] :
			32'b0;

	assign mem0_wr_ack=(mem_wr_master[2:0]==3'h0) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem1_wr_ack=(mem_wr_master[2:0]==3'h1) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem2_wr_ack=(mem_wr_master[2:0]==3'h2) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem3_wr_ack=(mem_wr_master[2:0]==3'h3) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem4_wr_ack=(mem_wr_master[2:0]==3'h4) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem5_wr_ack=(mem_wr_master[2:0]==3'h5) & (mem_wr_ack==1'b1) ? 1'b1 : 1'b0;
	assign mem0_rd_req=(mem_rd_master[2:0]==3'h0) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem1_rd_req=(mem_rd_master[2:0]==3'h1) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem2_rd_req=(mem_rd_master[2:0]==3'h2) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem3_rd_req=(mem_rd_master[2:0]==3'h3) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem4_rd_req=(mem_rd_master[2:0]==3'h4) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem5_rd_req=(mem_rd_master[2:0]==3'h5) & (mem_rd_req==1'b1) ? 1'b1 : 1'b0;
	assign mem0_rd_data[31:0]=mem_rd_data[31:0];
	assign mem1_rd_data[31:0]=mem_rd_data[31:0];
	assign mem2_rd_data[31:0]=mem_rd_data[31:0];
	assign mem3_rd_data[31:0]=mem_rd_data[31:0];
	assign mem4_rd_data[31:0]=mem_rd_data[31:0];
	assign mem5_rd_data[31:0]=mem_rd_data[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem_master_r[2:0] <= 3'b0;
				mem_pri_r[2:0] <= 3'b0;
				mem_cmd_req_r <= 1'b0;
			end
		else
			begin
				mem_master_r[2:0] <= mem_master_w[2:0];
				mem_pri_r[2:0] <= mem_pri_w[2:0];
				mem_cmd_req_r <= mem_cmd_req_w;
			end
	end

	wire	mem_req_tmp;
	wire	[2:0] mem_req_master_tmp;

	wire	mem_pri0_req_tmp;
	wire	mem_pri1_req_tmp;
	wire	mem_pri2_req_tmp;
	wire	mem_pri3_req_tmp;
	wire	mem_pri4_req_tmp;
	wire	mem_pri5_req_tmp;
	wire	mem_pri6_req_tmp;
	wire	mem_pri7_req_tmp;

	wire	[2:0] mem_pri0_req_master_tmp;
	wire	[2:0] mem_pri1_req_master_tmp;
	wire	[2:0] mem_pri2_req_master_tmp;
	wire	[2:0] mem_pri3_req_master_tmp;
	wire	[2:0] mem_pri4_req_master_tmp;
	wire	[2:0] mem_pri5_req_master_tmp;
	wire	[2:0] mem_pri6_req_master_tmp;
	wire	[2:0] mem_pri7_req_master_tmp;

	assign mem_req_tmp=
			({mem0_cmd_req,mem1_cmd_req,mem2_cmd_req,mem3_cmd_req,mem4_cmd_req,mem5_cmd_req}!=6'b000000) ? 1'b1 : 1'b0;
	assign mem_req_master_tmp[2:0]=
			(mem_pri_r[2:0]==3'h0) ? mem_pri0_req_master_tmp[2:0] :
			(mem_pri_r[2:0]==3'h1) ? mem_pri1_req_master_tmp[2:0] :
			(mem_pri_r[2:0]==3'h2) ? mem_pri2_req_master_tmp[2:0] :
			(mem_pri_r[2:0]==3'h3) ? mem_pri3_req_master_tmp[2:0] :
			(mem_pri_r[2:0]==3'h4) ? mem_pri4_req_master_tmp[2:0] :
			(mem_pri_r[2:0]==3'h5) ? mem_pri5_req_master_tmp[2:0] :
			3'h0;

	assign mem_pri0_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h0) & ({mem1_cmd_req}==1'b1) ? 3'h1 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h0) & ({mem2_cmd_req,mem1_cmd_req}==2'b10) ? 3'h2 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h0) & ({mem3_cmd_req,mem2_cmd_req,mem1_cmd_req}==3'b100) ? 3'h3 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h0) & ({mem0_cmd_req,mem3_cmd_req,mem2_cmd_req,mem1_cmd_req}==4'b1000) ? 3'h0 :
			3'h1;
	assign mem_pri1_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h1) & ({mem2_cmd_req}==1'b1) ? 3'h2 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h1) & ({mem3_cmd_req,mem2_cmd_req}==2'b10) ? 3'h3 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h1) & ({mem0_cmd_req,mem3_cmd_req,mem2_cmd_req}==3'b100) ? 3'h0 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h1) & ({mem1_cmd_req,mem0_cmd_req,mem3_cmd_req,mem2_cmd_req}==4'b1000) ? 3'h1 :
			3'h2;
	assign mem_pri2_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h2) & ({mem3_cmd_req}==1'b1) ? 3'h3 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h2) & ({mem0_cmd_req,mem3_cmd_req}==2'b10) ? 3'h0 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h2) & ({mem1_cmd_req,mem0_cmd_req,mem3_cmd_req}==3'b100) ? 3'h1 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h2) & ({mem2_cmd_req,mem1_cmd_req,mem0_cmd_req,mem3_cmd_req}==4'b1000) ? 3'h2 :
			3'h3;
	assign mem_pri3_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h3) & ({mem0_cmd_req}==1'b1) ? 3'h0 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h3) & ({mem1_cmd_req,mem0_cmd_req}==2'b10) ? 3'h1 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h3) & ({mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==3'b100) ? 3'h2 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h3) & ({mem3_cmd_req,mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==4'b1000) ? 3'h3 :
			3'h0;
	assign mem_pri4_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h4) & ({mem0_cmd_req}==1'b1) ? 3'h0 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h4) & ({mem1_cmd_req,mem0_cmd_req}==2'b10) ? 3'h1 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h4) & ({mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==3'b100) ? 3'h2 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h4) & ({mem3_cmd_req,mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==4'b1000) ? 3'h3 :
			3'h0;
	assign mem_pri5_req_master_tmp[2:0]=
			({mem5_cmd_req}==1'b1) ? 3'h5 :
			({mem4_cmd_req,mem5_cmd_req}==2'b10) ? 3'h4 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h5) & ({mem0_cmd_req}==1'b1) ? 3'h0 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h5) & ({mem1_cmd_req,mem0_cmd_req}==2'b10) ? 3'h1 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h5) & ({mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==3'b100) ? 3'h2 :
			({mem4_cmd_req,mem5_cmd_req}==2'b00) & (mem_pri_r[2:0]==3'h5) & ({mem3_cmd_req,mem2_cmd_req,mem1_cmd_req,mem0_cmd_req}==4'b1000) ? 3'h3 :
			3'h0;

	assign mem_master_w[2:0]=(mem_cmd_req_r==1'b0) & (mem_req_tmp==1'b1) ? mem_req_master_tmp[2:0] : mem_master_r[2:0];

	assign mem_pri_w[2:0]=(mem_cmd_req_r==1'b0) & (mem_req_tmp==1'b1) ? mem_master_r[2:0] : mem_pri_r[2:0];

	assign mem_cmd_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (mem_cmd_req_r==1'b0) & (mem_req_tmp==1'b1) ? 1'b1 :
			(init_done==1'b1) & (mem_cmd_req_r==1'b0) & (mem_req_tmp==1'b0) ? 1'b0 :
			(init_done==1'b1) & (mem_cmd_req_r==1'b1) & (mem_cmd_ack==1'b1) ? 1'b0 :
			(init_done==1'b1) & (mem_cmd_req_r==1'b1) & (mem_cmd_ack==1'b0) ? 1'b1 :
			1'b0;

	// p0 interface

nx1_mgbuff #(
	.DEVICE(DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) p0_buff (
	.p0_cmd_clk(p0_cmd_clk),						// in    [MIG] cmd clk
	.p0_cmd_en(p0_cmd_en),							// in    [MIG] cmd en
	.p0_cmd_instr(p0_cmd_instr[2:0]),				// in    [MIG] cmd inst[2:0]
	.p0_cmd_bl(p0_cmd_bl[5:0]),						// in    [MIG] cmd blen[5:0]
	.p0_cmd_byte_addr(p0_cmd_byte_addr[29:0]),		// in    [MIG] cmd addr[29:0]
	.p0_cmd_empty(p0_cmd_empty),					// out   [MIG] cmd empt
	.p0_cmd_full(p0_cmd_full),						// out   [MIG] cmd full
	.p0_wr_clk(p0_wr_clk),							// in    [MIG] wr clk
	.p0_wr_en(p0_wr_en),							// in    [MIG] wr en
	.p0_wr_mask(p0_wr_mask[3:0]),					// in    [MIG] wr mask[3:0]
	.p0_wr_data(p0_wr_data[31:0]),					// in    [MIG] wr wdata[31:0]
	.p0_wr_full(p0_wr_full),						// out   [MIG] wr full
	.p0_wr_empty(p0_wr_empty),						// out   [MIG] wr empt
	.p0_wr_count(p0_wr_count[6:0]),					// out   [MIG] wr count[6:0]
	.p0_wr_underrun(p0_wr_underrun),				// out   [MIG] wr over
	.p0_wr_error(p0_wr_error),						// out   [MIG] wr err
	.p0_rd_clk(p0_rd_clk),							// in    [MIG] rd clk
	.p0_rd_en(p0_rd_en),							// in    [MIG] rd en
	.p0_rd_data(p0_rd_data[31:0]),					// out   [MIG] rd rdata[31:0]
	.p0_rd_full(p0_rd_full),						// out   [MIG] rd full
	.p0_rd_empty(p0_rd_empty),						// out   [MIG] rd empt
	.p0_rd_count(p0_rd_count[6:0]),					// out   [MIG] rd count[6:0]
	.p0_rd_overflow(p0_rd_overflow),				// out   [MIG] rd over
	.p0_rd_error(p0_rd_error),						// out   [MIG] rd err

	.mem0_cmd_req(mem0_cmd_req),					// out   [MEM] 
	.mem0_cmd_instr(mem0_cmd_instr[2:0]),			// out   [MEM] 
	.mem0_cmd_bl(mem0_cmd_bl[5:0]),					// out   [MEM] 
	.mem0_cmd_byte_addr(mem0_cmd_byte_addr[29:0]),	// out   [MEM] 
	.mem0_cmd_ack(mem0_cmd_ack),					// in    [MEM] 
	.mem0_wr_mask(mem0_wr_mask[3:0]),				// out   [MEM] 
	.mem0_wr_data(mem0_wr_data[31:0]),				// out   [MEM] 
	.mem0_wr_ack(mem0_wr_ack),						// in    [MEM] 
	.mem0_rd_req(mem0_rd_req),						// in    [MEM] 
	.mem0_rd_data(mem0_rd_data[31:0]),				// in    [MEM] 

	.mem_rst_n(mem_rst_n),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	// p1 interface

nx1_mgbuff #(
	.DEVICE(DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) p1_buff(
	.p0_cmd_clk(p1_cmd_clk),						// in    [MIG] cmd clk
	.p0_cmd_en(p1_cmd_en),							// in    [MIG] cmd en
	.p0_cmd_instr(p1_cmd_instr[2:0]),				// in    [MIG] cmd inst[2:0]
	.p0_cmd_bl(p1_cmd_bl[5:0]),						// in    [MIG] cmd blen[5:0]
	.p0_cmd_byte_addr(p1_cmd_byte_addr[29:0]),		// in    [MIG] cmd addr[29:0]
	.p0_cmd_empty(p1_cmd_empty),					// out   [MIG] cmd empt
	.p0_cmd_full(p1_cmd_full),						// out   [MIG] cmd full
	.p0_wr_clk(p1_wr_clk),							// in    [MIG] wr clk
	.p0_wr_en(p1_wr_en),							// in    [MIG] wr en
	.p0_wr_mask(p1_wr_mask[3:0]),					// in    [MIG] wr mask[3:0]
	.p0_wr_data(p1_wr_data[31:0]),					// in    [MIG] wr wdata[31:0]
	.p0_wr_full(p1_wr_full),						// out   [MIG] wr full
	.p0_wr_empty(p1_wr_empty),						// out   [MIG] wr empt
	.p0_wr_count(p1_wr_count[6:0]),					// out   [MIG] wr count[6:0]
	.p0_wr_underrun(p1_wr_underrun),				// out   [MIG] wr over
	.p0_wr_error(p1_wr_error),						// out   [MIG] wr err
	.p0_rd_clk(p1_rd_clk),							// in    [MIG] rd clk
	.p0_rd_en(p1_rd_en),							// in    [MIG] rd en
	.p0_rd_data(p1_rd_data[31:0]),					// out   [MIG] rd rdata[31:0]
	.p0_rd_full(p1_rd_full),						// out   [MIG] rd full
	.p0_rd_empty(p1_rd_empty),						// out   [MIG] rd empt
	.p0_rd_count(p1_rd_count[6:0]),					// out   [MIG] rd count[6:0]
	.p0_rd_overflow(p1_rd_overflow),				// out   [MIG] rd over
	.p0_rd_error(p1_rd_error),						// out   [MIG] rd err

	.mem0_cmd_req(mem1_cmd_req),					// out   [MEM] 
	.mem0_cmd_instr(mem1_cmd_instr[2:0]),			// out   [MEM] 
	.mem0_cmd_bl(mem1_cmd_bl[5:0]),					// out   [MEM] 
	.mem0_cmd_byte_addr(mem1_cmd_byte_addr[29:0]),	// out   [MEM] 
	.mem0_cmd_ack(mem1_cmd_ack),					// in    [MEM] 
	.mem0_wr_mask(mem1_wr_mask[3:0]),				// out   [MEM] 
	.mem0_wr_data(mem1_wr_data[31:0]),				// out   [MEM] 
	.mem0_wr_ack(mem1_wr_ack),						// in    [MEM] 
	.mem0_rd_req(mem1_rd_req),						// in    [MEM] 
	.mem0_rd_data(mem1_rd_data[31:0]),				// in    [MEM] 

	.mem_rst_n(mem_rst_n),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	// p2 interface

nx1_mgbuff #(
	.DEVICE(DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) p2_buff(
	.p0_cmd_clk(p2_cmd_clk),						// in    [MIG] cmd clk
	.p0_cmd_en(p2_cmd_en),							// in    [MIG] cmd en
	.p0_cmd_instr(p2_cmd_instr[2:0]),				// in    [MIG] cmd inst[2:0]
	.p0_cmd_bl(p2_cmd_bl[5:0]),						// in    [MIG] cmd blen[5:0]
	.p0_cmd_byte_addr(p2_cmd_byte_addr[29:0]),		// in    [MIG] cmd addr[29:0]
	.p0_cmd_empty(p2_cmd_empty),					// out   [MIG] cmd empt
	.p0_cmd_full(p2_cmd_full),						// out   [MIG] cmd full
	.p0_wr_clk(p2_wr_clk),							// in    [MIG] wr clk
	.p0_wr_en(p2_wr_en),							// in    [MIG] wr en
	.p0_wr_mask(p2_wr_mask[3:0]),					// in    [MIG] wr mask[3:0]
	.p0_wr_data(p2_wr_data[31:0]),					// in    [MIG] wr wdata[31:0]
	.p0_wr_full(p2_wr_full),						// out   [MIG] wr full
	.p0_wr_empty(p2_wr_empty),						// out   [MIG] wr empt
	.p0_wr_count(p2_wr_count[6:0]),					// out   [MIG] wr count[6:0]
	.p0_wr_underrun(p2_wr_underrun),				// out   [MIG] wr over
	.p0_wr_error(p2_wr_error),						// out   [MIG] wr err
	.p0_rd_clk(p2_rd_clk),							// in    [MIG] rd clk
	.p0_rd_en(p2_rd_en),							// in    [MIG] rd en
	.p0_rd_data(p2_rd_data[31:0]),					// out   [MIG] rd rdata[31:0]
	.p0_rd_full(p2_rd_full),						// out   [MIG] rd full
	.p0_rd_empty(p2_rd_empty),						// out   [MIG] rd empt
	.p0_rd_count(p2_rd_count[6:0]),					// out   [MIG] rd count[6:0]
	.p0_rd_overflow(p2_rd_overflow),				// out   [MIG] rd over
	.p0_rd_error(p2_rd_error),						// out   [MIG] rd err

	.mem0_cmd_req(mem2_cmd_req),					// out   [MEM] 
	.mem0_cmd_instr(mem2_cmd_instr[2:0]),			// out   [MEM] 
	.mem0_cmd_bl(mem2_cmd_bl[5:0]),					// out   [MEM] 
	.mem0_cmd_byte_addr(mem2_cmd_byte_addr[29:0]),	// out   [MEM] 
	.mem0_cmd_ack(mem2_cmd_ack),					// in    [MEM] 
	.mem0_wr_mask(mem2_wr_mask[3:0]),				// out   [MEM] 
	.mem0_wr_data(mem2_wr_data[31:0]),				// out   [MEM] 
	.mem0_wr_ack(mem2_wr_ack),						// in    [MEM] 
	.mem0_rd_req(mem2_rd_req),						// in    [MEM] 
	.mem0_rd_data(mem2_rd_data[31:0]),				// in    [MEM] 

	.mem_rst_n(mem_rst_n),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	// p3 interface

	assign mem3_wr_mask[3:0]=32'b0;
	assign mem3_wr_data[31:0]=32'b0;

nx1_mgbuff #(
	.DEVICE(DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) p3_buff(
	.p0_cmd_clk(p3_cmd_clk),						// in    [MIG] cmd clk
	.p0_cmd_en(p3_cmd_en),							// in    [MIG] cmd en
	.p0_cmd_instr(p3_cmd_instr[2:0]),				// in    [MIG] cmd inst[2:0]
	.p0_cmd_bl(p3_cmd_bl[5:0]),						// in    [MIG] cmd blen[5:0]
	.p0_cmd_byte_addr(p3_cmd_byte_addr[29:0]),		// in    [MIG] cmd addr[29:0]
	.p0_cmd_empty(p3_cmd_empty),					// out   [MIG] cmd empt
	.p0_cmd_full(p3_cmd_full),						// out   [MIG] cmd full
	.p0_wr_clk(1'b0),								// in    [MIG] wr clk
	.p0_wr_en(1'b0),								// in    [MIG] wr en
	.p0_wr_mask(4'b0),								// in    [MIG] wr mask[3:0]
	.p0_wr_data(32'b0),								// in    [MIG] wr wdata[31:0]
	.p0_wr_full(),									// out   [MIG] wr full
	.p0_wr_empty(),									// out   [MIG] wr empt
	.p0_wr_count(),									// out   [MIG] wr count[6:0]
	.p0_wr_underrun(),								// out   [MIG] wr over
	.p0_wr_error(),									// out   [MIG] wr err
	.p0_rd_clk(p3_rd_clk),							// in    [MIG] rd clk
	.p0_rd_en(p3_rd_en),							// in    [MIG] rd en
	.p0_rd_data(p3_rd_data[31:0]),					// out   [MIG] rd rdata[31:0]
	.p0_rd_full(p3_rd_full),						// out   [MIG] rd full
	.p0_rd_empty(p3_rd_empty),						// out   [MIG] rd empt
	.p0_rd_count(p3_rd_count[6:0]),					// out   [MIG] rd count[6:0]
	.p0_rd_overflow(p3_rd_overflow),				// out   [MIG] rd over
	.p0_rd_error(p3_rd_error),						// out   [MIG] rd err

	.mem0_cmd_req(mem3_cmd_req),					// out   [MEM] 
	.mem0_cmd_instr(mem3_cmd_instr[2:0]),			// out   [MEM] 
	.mem0_cmd_bl(mem3_cmd_bl[5:0]),					// out   [MEM] 
	.mem0_cmd_byte_addr(mem3_cmd_byte_addr[29:0]),	// out   [MEM] 
	.mem0_cmd_ack(mem3_cmd_ack),					// in    [MEM] 
	.mem0_wr_mask(),								// out   [MEM] 
	.mem0_wr_data(),								// out   [MEM] 
	.mem0_wr_ack(1'b0),								// in    [MEM] 
	.mem0_rd_req(mem3_rd_req),						// in    [MEM] 
	.mem0_rd_data(mem3_rd_data[31:0]),				// in    [MEM] 

	.mem_rst_n(mem_rst_n),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	// p4 interface

	assign mem4_wr_mask[3:0]=32'b0;
	assign mem4_wr_data[31:0]=32'b0;

nx1_mgbuff #(
	.DEVICE(DEVICE)			// device : 0=xilinx / 1=altera / 2= / 3= 
) p4_buff(
	.p0_cmd_clk(p4_cmd_clk),						// in    [MIG] cmd clk
	.p0_cmd_en(p4_cmd_en),							// in    [MIG] cmd en
	.p0_cmd_instr(p4_cmd_instr[2:0]),				// in    [MIG] cmd inst[2:0]
	.p0_cmd_bl(p4_cmd_bl[5:0]),						// in    [MIG] cmd blen[5:0]
	.p0_cmd_byte_addr(p4_cmd_byte_addr[29:0]),		// in    [MIG] cmd addr[29:0]
	.p0_cmd_empty(p4_cmd_empty),					// out   [MIG] cmd empt
	.p0_cmd_full(p4_cmd_full),						// out   [MIG] cmd full
	.p0_wr_clk(1'b0),								// in    [MIG] wr clk
	.p0_wr_en(1'b0),								// in    [MIG] wr en
	.p0_wr_mask(4'b0),								// in    [MIG] wr mask[3:0]
	.p0_wr_data(32'b0),								// in    [MIG] wr wdata[31:0]
	.p0_wr_full(),									// out   [MIG] wr full
	.p0_wr_empty(),									// out   [MIG] wr empt
	.p0_wr_count(),									// out   [MIG] wr count[6:0]
	.p0_wr_underrun(),								// out   [MIG] wr over
	.p0_wr_error(),									// out   [MIG] wr err
	.p0_rd_clk(p4_rd_clk),							// in    [MIG] rd clk
	.p0_rd_en(p4_rd_en),							// in    [MIG] rd en
	.p0_rd_data(p4_rd_data[31:0]),					// out   [MIG] rd rdata[31:0]
	.p0_rd_full(p4_rd_full),						// out   [MIG] rd full
	.p0_rd_empty(p4_rd_empty),						// out   [MIG] rd empt
	.p0_rd_count(p4_rd_count[6:0]),					// out   [MIG] rd count[6:0]
	.p0_rd_overflow(p4_rd_overflow),				// out   [MIG] rd over
	.p0_rd_error(p4_rd_error),						// out   [MIG] rd err

	.mem0_cmd_req(mem4_cmd_req),					// out   [MEM] 
	.mem0_cmd_instr(mem4_cmd_instr[2:0]),			// out   [MEM] 
	.mem0_cmd_bl(mem4_cmd_bl[5:0]),					// out   [MEM] 
	.mem0_cmd_byte_addr(mem4_cmd_byte_addr[29:0]),	// out   [MEM] 
	.mem0_cmd_ack(mem4_cmd_ack),					// in    [MEM] 
	.mem0_wr_mask(),								// out   [MEM] 
	.mem0_wr_data(),								// out   [MEM] 
	.mem0_wr_ack(1'b0),								// in    [MEM] 
	.mem0_rd_req(mem4_rd_req),						// in    [MEM] 
	.mem0_rd_data(mem4_rd_data[31:0]),				// in    [MEM] 

	.mem_rst_n(mem_rst_n),							// in    [MEM] #rst
	.mem_clk(mem_clk)								// in    [MEM] clk
);

	// p5 interface

	assign mem5_cmd_req=1'b0;
	assign mem5_cmd_instr[2:0]=3'b0;
	assign mem5_cmd_bl[5:0]=6'b0;
	assign mem5_cmd_byte_addr[29:0]=30'b0;
	assign mem5_wr_mask[3:0]=32'b0;
	assign mem5_wr_data[31:0]=32'b0;

endmodule
