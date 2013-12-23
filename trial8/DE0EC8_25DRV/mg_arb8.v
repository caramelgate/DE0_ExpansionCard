//------------------------------------------------------------------------------
//  mg_arb8.v : cellularram interface module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2012/feb/13 release 0.0  connection test
//       feb/22 release 0.1  mig semi-compatible signal
//       feb/23 release 0.1a -> cram_mg.v , cram_mg_mt45w8mw16.v
//  2013/mar/20 release 0.1b +flash read , reduce , rename mg_arb
//       apr/18 release 0.1c 4port -> 8port
//
//------------------------------------------------------------------------------

module mg_arb8 (
	input			init_done,			// in    [MEM] #init/done

	output			mem_cmd_req,		// out   [MEM] cmd req
	output	[3:0]	mem_cmd_instr,		// out   [MEM] cmd device(flash=1),inst[2:0]
	output	[5:0]	mem_cmd_bl,			// out   [MEM] cmd blen[5:0](flash=0)
	output	[29:0]	mem_cmd_byte_addr,	// out   [MEM] cmd addr[29:0]
	input			mem_cmd_ack,		// in    [MEM] cmd ack
	output	[3:0]	mem_wr_mask,		// out   [MEM] wr mask[3:0]
	output	[31:0]	mem_wr_data,		// out   [MEM] wr wdata[31:0]
	input			mem_wr_ack,			// in    [MEM] wr ack
	input	[31:0]	mem_rd_data,		// in    [MEM] rd rdata[31:0]
	input			mem_rd_ack,			// in    [MEM] rd ack

	input			p0_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p0_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p0_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p0_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p0_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p0_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p0_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p0_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p1_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p1_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p1_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p1_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p1_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p1_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p1_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p1_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p2_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p2_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p2_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p2_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p2_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p2_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p2_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p2_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p3_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p3_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p3_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p3_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p3_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p3_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p3_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p3_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p4_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p4_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p4_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p4_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p4_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p4_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p4_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p4_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p5_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p5_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p5_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p5_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p5_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p5_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p5_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p5_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p6_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p6_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p6_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p6_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p6_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p6_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p6_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p6_rd_data,			// out   [MEM] rd rdata[31:0]

	input			p7_cmd_req,			// in    [MEM] cmd req
	input	[3:0]	p7_cmd_instr,		// in    [MEM] cmd inst[3:0](={flash,0,0,rd})
	input	[5:0]	p7_cmd_bl,			// in    [MEM] cmd blen[5:0](=0)
	input	[29:0]	p7_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	output			p7_cmd_ack,			// out   [MEM] cmd ack
	input	[3:0]	p7_wr_mask,			// in    [MEM] wr mask[3:0]
	input	[31:0]	p7_wr_data,			// in    [MEM] wr wdata[31:0]
	output	[31:0]	p7_rd_data,			// out   [MEM] rd rdata[31:0]

	input			mem_rst_n,			// in    [MEM] #rst
	input			mem_clk				// in    [MEM] clk
);


	reg		[2:0] mem_master_r;
	reg		[1:0] mem_req_r;
	reg		mem_cmd_req_r;
	reg		[3:0] mem_cmd_instr_r;
	reg		[5:0] mem_cmd_bl_r;
	reg		[29:0] mem_cmd_byte_addr_r;
	reg		[3:0] mem_wr_mask_r;
	reg		[31:0] mem_wr_data_r;
	wire	[2:0] mem_master_w;
	wire	mem_cmd_req_w;
	wire	[1:0] mem_req_w;
	wire	[3:0] mem_cmd_instr_w;
	wire	[5:0] mem_cmd_bl_w;
	wire	[29:0] mem_cmd_byte_addr_w;
	wire	[3:0] mem_wr_mask_w;
	wire	[31:0] mem_wr_data_w;

	reg		[3:0] p0_cmd_instr_r;
	reg		[5:0] p0_cmd_bl_r;
	reg		[29:0] p0_cmd_byte_addr_r;
	reg		p0_req_r;
	reg		[1:0] p0_cmd_req_r;
	reg		p0_cmd_ack_r;
	reg		[3:0] p0_wr_mask_r;
	reg		[31:0] p0_wr_data_r;
	reg		[31:0] p0_rd_data_r;
	wire	[3:0] p0_cmd_instr_w;
	wire	[5:0] p0_cmd_bl_w;
	wire	[29:0] p0_cmd_byte_addr_w;
	wire	p0_req_w;
	wire	[1:0] p0_cmd_req_w;
	wire	p0_cmd_ack_w;
	wire	[3:0] p0_wr_mask_w;
	wire	[31:0] p0_wr_data_w;
	wire	[31:0] p0_rd_data_w;

	reg		[3:0] p1_cmd_instr_r;
	reg		[5:0] p1_cmd_bl_r;
	reg		[29:0] p1_cmd_byte_addr_r;
	reg		p1_req_r;
	reg		[1:0] p1_cmd_req_r;
	reg		p1_cmd_ack_r;
	reg		[3:0] p1_wr_mask_r;
	reg		[31:0] p1_wr_data_r;
	reg		[31:0] p1_rd_data_r;
	wire	[3:0] p1_cmd_instr_w;
	wire	[5:0] p1_cmd_bl_w;
	wire	[29:0] p1_cmd_byte_addr_w;
	wire	p1_req_w;
	wire	[1:0] p1_cmd_req_w;
	wire	p1_cmd_ack_w;
	wire	[3:0] p1_wr_mask_w;
	wire	[31:0] p1_wr_data_w;
	wire	[31:0] p1_rd_data_w;

	reg		[3:0] p2_cmd_instr_r;
	reg		[5:0] p2_cmd_bl_r;
	reg		[29:0] p2_cmd_byte_addr_r;
	reg		p2_req_r;
	reg		[1:0] p2_cmd_req_r;
	reg		p2_cmd_ack_r;
	reg		[3:0] p2_wr_mask_r;
	reg		[31:0] p2_wr_data_r;
	reg		[31:0] p2_rd_data_r;
	wire	[3:0] p2_cmd_instr_w;
	wire	[5:0] p2_cmd_bl_w;
	wire	[29:0] p2_cmd_byte_addr_w;
	wire	p2_req_w;
	wire	[1:0] p2_cmd_req_w;
	wire	p2_cmd_ack_w;
	wire	[3:0] p2_wr_mask_w;
	wire	[31:0] p2_wr_data_w;
	wire	[31:0] p2_rd_data_w;

	reg		[3:0] p3_cmd_instr_r;
	reg		[5:0] p3_cmd_bl_r;
	reg		[29:0] p3_cmd_byte_addr_r;
	reg		p3_req_r;
	reg		[1:0] p3_cmd_req_r;
	reg		p3_cmd_ack_r;
	reg		[3:0] p3_wr_mask_r;
	reg		[31:0] p3_wr_data_r;
	reg		[31:0] p3_rd_data_r;
	wire	[3:0] p3_cmd_instr_w;
	wire	[5:0] p3_cmd_bl_w;
	wire	[29:0] p3_cmd_byte_addr_w;
	wire	p3_req_w;
	wire	[1:0] p3_cmd_req_w;
	wire	p3_cmd_ack_w;
	wire	[3:0] p3_wr_mask_w;
	wire	[31:0] p3_wr_data_w;
	wire	[31:0] p3_rd_data_w;

	reg		[3:0] p4_cmd_instr_r;
	reg		[5:0] p4_cmd_bl_r;
	reg		[29:0] p4_cmd_byte_addr_r;
	reg		p4_req_r;
	reg		[1:0] p4_cmd_req_r;
	reg		p4_cmd_ack_r;
	reg		[3:0] p4_wr_mask_r;
	reg		[31:0] p4_wr_data_r;
	reg		[31:0] p4_rd_data_r;
	wire	[3:0] p4_cmd_instr_w;
	wire	[5:0] p4_cmd_bl_w;
	wire	[29:0] p4_cmd_byte_addr_w;
	wire	p4_req_w;
	wire	[1:0] p4_cmd_req_w;
	wire	p4_cmd_ack_w;
	wire	[3:0] p4_wr_mask_w;
	wire	[31:0] p4_wr_data_w;
	wire	[31:0] p4_rd_data_w;

	reg		[3:0] p5_cmd_instr_r;
	reg		[5:0] p5_cmd_bl_r;
	reg		[29:0] p5_cmd_byte_addr_r;
	reg		p5_req_r;
	reg		[1:0] p5_cmd_req_r;
	reg		p5_cmd_ack_r;
	reg		[3:0] p5_wr_mask_r;
	reg		[31:0] p5_wr_data_r;
	reg		[31:0] p5_rd_data_r;
	wire	[3:0] p5_cmd_instr_w;
	wire	[5:0] p5_cmd_bl_w;
	wire	[29:0] p5_cmd_byte_addr_w;
	wire	p5_req_w;
	wire	[1:0] p5_cmd_req_w;
	wire	p5_cmd_ack_w;
	wire	[3:0] p5_wr_mask_w;
	wire	[31:0] p5_wr_data_w;
	wire	[31:0] p5_rd_data_w;

	reg		[3:0] p6_cmd_instr_r;
	reg		[5:0] p6_cmd_bl_r;
	reg		[29:0] p6_cmd_byte_addr_r;
	reg		p6_req_r;
	reg		[1:0] p6_cmd_req_r;
	reg		p6_cmd_ack_r;
	reg		[3:0] p6_wr_mask_r;
	reg		[31:0] p6_wr_data_r;
	reg		[31:0] p6_rd_data_r;
	wire	[3:0] p6_cmd_instr_w;
	wire	[5:0] p6_cmd_bl_w;
	wire	[29:0] p6_cmd_byte_addr_w;
	wire	p6_req_w;
	wire	[1:0] p6_cmd_req_w;
	wire	p6_cmd_ack_w;
	wire	[3:0] p6_wr_mask_w;
	wire	[31:0] p6_wr_data_w;
	wire	[31:0] p6_rd_data_w;

	reg		[3:0] p7_cmd_instr_r;
	reg		[5:0] p7_cmd_bl_r;
	reg		[29:0] p7_cmd_byte_addr_r;
	reg		p7_req_r;
	reg		[1:0] p7_cmd_req_r;
	reg		p7_cmd_ack_r;
	reg		[3:0] p7_wr_mask_r;
	reg		[31:0] p7_wr_data_r;
	reg		[31:0] p7_rd_data_r;
	wire	[3:0] p7_cmd_instr_w;
	wire	[5:0] p7_cmd_bl_w;
	wire	[29:0] p7_cmd_byte_addr_w;
	wire	p7_req_w;
	wire	[1:0] p7_cmd_req_w;
	wire	p7_cmd_ack_w;
	wire	[3:0] p7_wr_mask_w;
	wire	[31:0] p7_wr_data_w;
	wire	[31:0] p7_rd_data_w;

	assign mem_cmd_req=mem_cmd_req_r;
	assign mem_cmd_instr[3:0]=mem_cmd_instr_r[3:0];
	assign mem_cmd_bl[5:0]=mem_cmd_bl_r[5:0];
	assign mem_cmd_byte_addr[29:0]=mem_cmd_byte_addr_r[29:0];
	assign mem_wr_mask[3:0]=mem_wr_mask_r[3:0];
	assign mem_wr_data[31:0]=mem_wr_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if(mem_rst_n==1'b0)
			begin
				mem_master_r[2:0] <= 3'b0;
				mem_req_r[1:0] <= 2'b0;
				mem_cmd_req_r <= 1'b0;
				mem_cmd_instr_r[3:0] <= 4'b0;
				mem_cmd_bl_r[5:0] <= 6'b0;
				mem_cmd_byte_addr_r[29:0] <= 30'b0;
				mem_wr_mask_r[3:0] <= 4'b0;
				mem_wr_data_r[31:0] <= 32'b0;
			end
		else
			begin
				mem_master_r[2:0] <= mem_master_w[2:0];
				mem_req_r[1:0] <= mem_req_w[1:0];
				mem_cmd_req_r <= mem_cmd_req_w;
				mem_cmd_instr_r[3:0] <= mem_cmd_instr_w[3:0];
				mem_cmd_bl_r[5:0] <= mem_cmd_bl_w[5:0];
				mem_cmd_byte_addr_r[29:0] <= mem_cmd_byte_addr_w[29:0];
				mem_wr_mask_r[3:0] <= mem_wr_mask_w[3:0];
				mem_wr_data_r[31:0] <= mem_wr_data_w[31:0];
			end
	end

	assign mem_master_w[2:0]=
			(mem_req_r[1:0]==2'b00) & ({p0_req_r                                                      }==1'b1      ) ? 3'b000 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r                                             }==2'b01     ) ? 3'b001 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r                                    }==3'b001    ) ? 3'b010 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r                           }==4'b0001   ) ? 3'b011 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r                  }==5'b00001  ) ? 3'b100 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r         }==6'b000001 ) ? 3'b101 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r}==7'b0000001) ? 3'b110 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r}==7'b0000000) ? 3'b111 :
			(mem_req_r[1:0]!=2'b00) ? mem_master_r[2:0] :
			3'b000;
	assign mem_req_w[1:0]=
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r,p7_req_r}==8'b0) ? 2'b00 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r,p7_req_r}!=8'b0) ? 2'b01 :
			(mem_req_r[1:0]==2'b01) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(mem_req_r[1:0]==2'b01) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(mem_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(mem_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b00 :
			(mem_req_r[1:0]==2'b10) ? 2'b00 :
			2'b00;
	assign mem_cmd_req_w=
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r,p7_req_r}==8'b0) ? 1'b0 :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r,p7_req_r}!=8'b0) ? 1'b1 :
			(mem_req_r[1:0]==2'b01) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(mem_req_r[1:0]==2'b01) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;
	assign {mem_cmd_instr_w[3:0],mem_cmd_bl_w[5:0],mem_cmd_byte_addr_w[29:0],mem_wr_mask_w[3:0],mem_wr_data_w[31:0]}=
			(mem_req_r[1:0]==2'b00) & ({p0_req_r                                                      }==1'b1      ) ? {p0_cmd_instr_r[3:0],p0_cmd_bl_r[5:0],p0_cmd_byte_addr_r[29:0],p0_wr_mask_r[3:0],p0_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r                                             }==2'b01     ) ? {p1_cmd_instr_r[3:0],p1_cmd_bl_r[5:0],p1_cmd_byte_addr_r[29:0],p1_wr_mask_r[3:0],p1_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r                                    }==3'b001    ) ? {p2_cmd_instr_r[3:0],p2_cmd_bl_r[5:0],p2_cmd_byte_addr_r[29:0],p2_wr_mask_r[3:0],p2_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r                           }==4'b0001   ) ? {p3_cmd_instr_r[3:0],p3_cmd_bl_r[5:0],p3_cmd_byte_addr_r[29:0],p3_wr_mask_r[3:0],p3_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r                  }==5'b00001  ) ? {p4_cmd_instr_r[3:0],p4_cmd_bl_r[5:0],p4_cmd_byte_addr_r[29:0],p4_wr_mask_r[3:0],p4_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r         }==6'b000001 ) ? {p5_cmd_instr_r[3:0],p5_cmd_bl_r[5:0],p5_cmd_byte_addr_r[29:0],p5_wr_mask_r[3:0],p5_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r}==7'b0000001) ? {p6_cmd_instr_r[3:0],p6_cmd_bl_r[5:0],p6_cmd_byte_addr_r[29:0],p6_wr_mask_r[3:0],p6_wr_data_r[31:0]} :
			(mem_req_r[1:0]==2'b00) & ({p0_req_r,p1_req_r,p2_req_r,p3_req_r,p4_req_r,p5_req_r,p6_req_r}==7'b0000000) ? {p7_cmd_instr_r[3:0],p7_cmd_bl_r[5:0],p7_cmd_byte_addr_r[29:0],p7_wr_mask_r[3:0],p7_wr_data_r[31:0]} :
			(mem_req_r[1:0]!=2'b00) ? {mem_cmd_instr_r[3:0],mem_cmd_bl_r[5:0],mem_cmd_byte_addr_r[29:0],mem_wr_mask_r[3:0],mem_wr_data_r[31:0]} :
			{4'b0,6'b0,30'b0,4'b0,32'b0};

	// ---- p0 ----

	assign p0_cmd_ack=p0_cmd_ack_r;
	assign p0_rd_data[31:0]=p0_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p0_cmd_instr_r[3:0] <= 4'b0;
				p0_cmd_bl_r[5:0] <= 6'b0;
				p0_cmd_byte_addr_r[29:0] <= 30'b0;
				p0_req_r <= 1'b0;
				p0_cmd_req_r[1:0] <= 2'b0;
				p0_cmd_ack_r <= 4'b0;
				p0_wr_mask_r[3:0] <= 4'b0;
				p0_wr_data_r[31:0] <= 32'b0;
				p0_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p0_cmd_instr_r[3:0] <= p0_cmd_instr_w[3:0];
				p0_cmd_bl_r[5:0] <= p0_cmd_bl_w[5:0];
				p0_cmd_byte_addr_r[29:0] <= p0_cmd_byte_addr_w[29:0];
				p0_req_r <= p0_req_w;
				p0_cmd_req_r[1:0] <= p0_cmd_req_w[1:0];
				p0_cmd_ack_r <= p0_cmd_ack_w;
				p0_wr_mask_r[3:0] <= p0_wr_mask_w[3:0];
				p0_wr_data_r[31:0] <= p0_wr_data_w[31:0];
				p0_rd_data_r[31:0] <= p0_rd_data_w[31:0];
			end
	end

	assign p0_cmd_instr_w[3:0]=(p0_cmd_req_r[1:0]==2'b00) ? p0_cmd_instr[3:0] : p0_cmd_instr_r[3:0];
	assign p0_cmd_bl_w[5:0]=(p0_cmd_req_r[1:0]==2'b00) ? p0_cmd_bl[5:0] : p0_cmd_bl_r[5:0];
	assign p0_cmd_byte_addr_w[29:0]=(p0_cmd_req_r[1:0]==2'b00) ? p0_cmd_byte_addr[29:0] : p0_cmd_byte_addr_r[29:0];

	assign p0_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b00) & (p0_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b00) & (p0_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b000) ? 1'b1 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b000) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b000) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p0_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b00) & (p0_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b00) & (p0_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b000) ? 2'b01 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b000) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b000) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p0_cmd_ack_w=(init_done==1'b1) & (p0_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p0_wr_mask_w[3:0]=(p0_cmd_req_r[1:0]==2'b00) ? p0_wr_mask[3:0] : p0_wr_mask_r[3:0];
	assign p0_wr_data_w[31:0]=(p0_cmd_req_r[1:0]==2'b00) ? p0_wr_data[31:0] : p0_wr_data_r[31:0];
	assign p0_rd_data_w[31:0]=(p0_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p0_rd_data_r[31:0];

	// ---- p1 ----

	assign p1_cmd_ack=p1_cmd_ack_r;
	assign p1_rd_data[31:0]=p1_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p1_cmd_instr_r[3:0] <= 4'b0;
				p1_cmd_bl_r[5:0] <= 6'b0;
				p1_cmd_byte_addr_r[29:0] <= 30'b0;
				p1_req_r <= 1'b0;
				p1_cmd_req_r[1:0] <= 2'b0;
				p1_cmd_ack_r <= 4'b0;
				p1_wr_mask_r[3:0] <= 4'b0;
				p1_wr_data_r[31:0] <= 32'b0;
				p1_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p1_cmd_instr_r[3:0] <= p1_cmd_instr_w[3:0];
				p1_cmd_bl_r[5:0] <= p1_cmd_bl_w[5:0];
				p1_cmd_byte_addr_r[29:0] <= p1_cmd_byte_addr_w[29:0];
				p1_req_r <= p1_req_w;
				p1_cmd_req_r[1:0] <= p1_cmd_req_w[1:0];
				p1_cmd_ack_r <= p1_cmd_ack_w;
				p1_wr_mask_r[3:0] <= p1_wr_mask_w[3:0];
				p1_wr_data_r[31:0] <= p1_wr_data_w[31:0];
				p1_rd_data_r[31:0] <= p1_rd_data_w[31:0];
			end
	end

	assign p1_cmd_instr_w[3:0]=(p1_cmd_req_r[1:0]==2'b00) ? p1_cmd_instr[3:0] : p1_cmd_instr_r[3:0];
	assign p1_cmd_bl_w[5:0]=(p1_cmd_req_r[1:0]==2'b00) ? p1_cmd_bl[5:0] : p1_cmd_bl_r[5:0];
	assign p1_cmd_byte_addr_w[29:0]=(p1_cmd_req_r[1:0]==2'b00) ? p1_cmd_byte_addr[29:0] : p1_cmd_byte_addr_r[29:0];

	assign p1_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b00) & (p1_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b00) & (p1_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b001) ? 1'b1 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b001) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b001) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p1_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b00) & (p1_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b00) & (p1_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b001) ? 2'b01 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b001) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b001) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p1_cmd_ack_w=(init_done==1'b1) & (p1_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p1_wr_mask_w[3:0]=(p1_cmd_req_r[1:0]==2'b00) ? p1_wr_mask[3:0] : p1_wr_mask_r[3:0];
	assign p1_wr_data_w[31:0]=(p1_cmd_req_r[1:0]==2'b00) ? p1_wr_data[31:0] : p1_wr_data_r[31:0];
	assign p1_rd_data_w[31:0]=(p1_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p1_rd_data_r[31:0];

	// ---- p2 ----

	assign p2_cmd_ack=p2_cmd_ack_r;
	assign p2_rd_data[31:0]=p2_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p2_cmd_instr_r[3:0] <= 4'b0;
				p2_cmd_bl_r[5:0] <= 6'b0;
				p2_cmd_byte_addr_r[29:0] <= 30'b0;
				p2_req_r <= 1'b0;
				p2_cmd_req_r[1:0] <= 2'b0;
				p2_cmd_ack_r <= 4'b0;
				p2_wr_mask_r[3:0] <= 4'b0;
				p2_wr_data_r[31:0] <= 32'b0;
				p2_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p2_cmd_instr_r[3:0] <= p2_cmd_instr_w[3:0];
				p2_cmd_bl_r[5:0] <= p2_cmd_bl_w[5:0];
				p2_cmd_byte_addr_r[29:0] <= p2_cmd_byte_addr_w[29:0];
				p2_req_r <= p2_req_w;
				p2_cmd_req_r[1:0] <= p2_cmd_req_w[1:0];
				p2_cmd_ack_r <= p2_cmd_ack_w;
				p2_wr_mask_r[3:0] <= p2_wr_mask_w[3:0];
				p2_wr_data_r[31:0] <= p2_wr_data_w[31:0];
				p2_rd_data_r[31:0] <= p2_rd_data_w[31:0];
			end
	end

	assign p2_cmd_instr_w[3:0]=(p2_cmd_req_r[1:0]==2'b00) ? p2_cmd_instr[3:0] : p2_cmd_instr_r[3:0];
	assign p2_cmd_bl_w[5:0]=(p2_cmd_req_r[1:0]==2'b00) ? p2_cmd_bl[5:0] : p2_cmd_bl_r[5:0];
	assign p2_cmd_byte_addr_w[29:0]=(p2_cmd_req_r[1:0]==2'b00) ? p2_cmd_byte_addr[29:0] : p2_cmd_byte_addr_r[29:0];

	assign p2_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b00) & (p2_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b00) & (p2_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b010) ? 1'b1 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b010) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b010) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p2_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b00) & (p2_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b00) & (p2_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b010) ? 2'b01 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b010) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b010) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p2_cmd_ack_w=(init_done==1'b1) & (p2_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p2_wr_mask_w[3:0]=(p2_cmd_req_r[1:0]==2'b00) ? p2_wr_mask[3:0] : p2_wr_mask_r[3:0];
	assign p2_wr_data_w[31:0]=(p2_cmd_req_r[1:0]==2'b00) ? p2_wr_data[31:0] : p2_wr_data_r[31:0];
	assign p2_rd_data_w[31:0]=(p2_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p2_rd_data_r[31:0];

	// ---- p3 ----

	assign p3_cmd_ack=p3_cmd_ack_r;
	assign p3_rd_data[31:0]=p3_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p3_cmd_instr_r[3:0] <= 4'b0;
				p3_cmd_bl_r[5:0] <= 6'b0;
				p3_cmd_byte_addr_r[29:0] <= 30'b0;
				p3_req_r <= 1'b0;
				p3_cmd_req_r[1:0] <= 2'b0;
				p3_cmd_ack_r <= 4'b0;
				p3_wr_mask_r[3:0] <= 4'b0;
				p3_wr_data_r[31:0] <= 32'b0;
				p3_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p3_cmd_instr_r[3:0] <= p3_cmd_instr_w[3:0];
				p3_cmd_bl_r[5:0] <= p3_cmd_bl_w[5:0];
				p3_cmd_byte_addr_r[29:0] <= p3_cmd_byte_addr_w[29:0];
				p3_req_r <= p3_req_w;
				p3_cmd_req_r[1:0] <= p3_cmd_req_w[1:0];
				p3_cmd_ack_r <= p3_cmd_ack_w;
				p3_wr_mask_r[3:0] <= p3_wr_mask_w[3:0];
				p3_wr_data_r[31:0] <= p3_wr_data_w[31:0];
				p3_rd_data_r[31:0] <= p3_rd_data_w[31:0];
			end
	end

	assign p3_cmd_instr_w[3:0]=(p3_cmd_req_r[1:0]==2'b00) ? p3_cmd_instr[3:0] : p3_cmd_instr_r[3:0];
	assign p3_cmd_bl_w[5:0]=(p3_cmd_req_r[1:0]==2'b00) ? p3_cmd_bl[5:0] : p3_cmd_bl_r[5:0];
	assign p3_cmd_byte_addr_w[29:0]=(p3_cmd_req_r[1:0]==2'b00) ? p3_cmd_byte_addr[29:0] : p3_cmd_byte_addr_r[29:0];

	assign p3_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b00) & (p3_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b00) & (p3_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b011) ? 1'b1 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b011) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b011) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p3_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b00) & (p3_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b00) & (p3_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b011) ? 2'b01 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b011) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b011) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p3_cmd_ack_w=(init_done==1'b1) & (p3_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p3_wr_mask_w[3:0]=(p3_cmd_req_r[1:0]==2'b00) ? p3_wr_mask[3:0] : p3_wr_mask_r[3:0];
	assign p3_wr_data_w[31:0]=(p3_cmd_req_r[1:0]==2'b00) ? p3_wr_data[31:0] : p3_wr_data_r[31:0];
	assign p3_rd_data_w[31:0]=(p3_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p3_rd_data_r[31:0];

	// ---- p4 ----

	assign p4_cmd_ack=p4_cmd_ack_r;
	assign p4_rd_data[31:0]=p4_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p4_cmd_instr_r[3:0] <= 4'b0;
				p4_cmd_bl_r[5:0] <= 6'b0;
				p4_cmd_byte_addr_r[29:0] <= 30'b0;
				p4_req_r <= 1'b0;
				p4_cmd_req_r[1:0] <= 2'b0;
				p4_cmd_ack_r <= 4'b0;
				p4_wr_mask_r[3:0] <= 4'b0;
				p4_wr_data_r[31:0] <= 32'b0;
				p4_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p4_cmd_instr_r[3:0] <= p4_cmd_instr_w[3:0];
				p4_cmd_bl_r[5:0] <= p4_cmd_bl_w[5:0];
				p4_cmd_byte_addr_r[29:0] <= p4_cmd_byte_addr_w[29:0];
				p4_req_r <= p4_req_w;
				p4_cmd_req_r[1:0] <= p4_cmd_req_w[1:0];
				p4_cmd_ack_r <= p4_cmd_ack_w;
				p4_wr_mask_r[3:0] <= p4_wr_mask_w[3:0];
				p4_wr_data_r[31:0] <= p4_wr_data_w[31:0];
				p4_rd_data_r[31:0] <= p4_rd_data_w[31:0];
			end
	end

	assign p4_cmd_instr_w[3:0]=(p4_cmd_req_r[1:0]==2'b00) ? p4_cmd_instr[3:0] : p4_cmd_instr_r[3:0];
	assign p4_cmd_bl_w[5:0]=(p4_cmd_req_r[1:0]==2'b00) ? p4_cmd_bl[5:0] : p4_cmd_bl_r[5:0];
	assign p4_cmd_byte_addr_w[29:0]=(p4_cmd_req_r[1:0]==2'b00) ? p4_cmd_byte_addr[29:0] : p4_cmd_byte_addr_r[29:0];

	assign p4_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b00) & (p4_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b00) & (p4_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b100) ? 1'b1 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b100) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b100) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p4_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b00) & (p4_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b00) & (p4_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b100) ? 2'b01 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b100) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b100) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p4_cmd_ack_w=(init_done==1'b1) & (p4_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p4_wr_mask_w[3:0]=(p4_cmd_req_r[1:0]==2'b00) ? p4_wr_mask[3:0] : p4_wr_mask_r[3:0];
	assign p4_wr_data_w[31:0]=(p4_cmd_req_r[1:0]==2'b00) ? p4_wr_data[31:0] : p4_wr_data_r[31:0];
	assign p4_rd_data_w[31:0]=(p4_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p4_rd_data_r[31:0];

	// ---- p5 ----

	assign p5_cmd_ack=p5_cmd_ack_r;
	assign p5_rd_data[31:0]=p5_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p5_cmd_instr_r[3:0] <= 4'b0;
				p5_cmd_bl_r[5:0] <= 6'b0;
				p5_cmd_byte_addr_r[29:0] <= 30'b0;
				p5_req_r <= 1'b0;
				p5_cmd_req_r[1:0] <= 2'b0;
				p5_cmd_ack_r <= 4'b0;
				p5_wr_mask_r[3:0] <= 4'b0;
				p5_wr_data_r[31:0] <= 32'b0;
				p5_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p5_cmd_instr_r[3:0] <= p5_cmd_instr_w[3:0];
				p5_cmd_bl_r[5:0] <= p5_cmd_bl_w[5:0];
				p5_cmd_byte_addr_r[29:0] <= p5_cmd_byte_addr_w[29:0];
				p5_req_r <= p5_req_w;
				p5_cmd_req_r[1:0] <= p5_cmd_req_w[1:0];
				p5_cmd_ack_r <= p5_cmd_ack_w;
				p5_wr_mask_r[3:0] <= p5_wr_mask_w[3:0];
				p5_wr_data_r[31:0] <= p5_wr_data_w[31:0];
				p5_rd_data_r[31:0] <= p5_rd_data_w[31:0];
			end
	end

	assign p5_cmd_instr_w[3:0]=(p5_cmd_req_r[1:0]==2'b00) ? p5_cmd_instr[3:0] : p5_cmd_instr_r[3:0];
	assign p5_cmd_bl_w[5:0]=(p5_cmd_req_r[1:0]==2'b00) ? p5_cmd_bl[5:0] : p5_cmd_bl_r[5:0];
	assign p5_cmd_byte_addr_w[29:0]=(p5_cmd_req_r[1:0]==2'b00) ? p5_cmd_byte_addr[29:0] : p5_cmd_byte_addr_r[29:0];

	assign p5_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b00) & (p5_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b00) & (p5_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b101) ? 1'b1 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b101) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b101) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p5_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b00) & (p5_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b00) & (p5_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b101) ? 2'b01 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b101) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b101) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p5_cmd_ack_w=(init_done==1'b1) & (p5_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p5_wr_mask_w[3:0]=(p5_cmd_req_r[1:0]==2'b00) ? p5_wr_mask[3:0] : p5_wr_mask_r[3:0];
	assign p5_wr_data_w[31:0]=(p5_cmd_req_r[1:0]==2'b00) ? p5_wr_data[31:0] : p5_wr_data_r[31:0];
	assign p5_rd_data_w[31:0]=(p5_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p5_rd_data_r[31:0];

	// ---- p6 ----

	assign p6_cmd_ack=p6_cmd_ack_r;
	assign p6_rd_data[31:0]=p6_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p6_cmd_instr_r[3:0] <= 4'b0;
				p6_cmd_bl_r[5:0] <= 6'b0;
				p6_cmd_byte_addr_r[29:0] <= 30'b0;
				p6_req_r <= 1'b0;
				p6_cmd_req_r[1:0] <= 2'b0;
				p6_cmd_ack_r <= 4'b0;
				p6_wr_mask_r[3:0] <= 4'b0;
				p6_wr_data_r[31:0] <= 32'b0;
				p6_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p6_cmd_instr_r[3:0] <= p6_cmd_instr_w[3:0];
				p6_cmd_bl_r[5:0] <= p6_cmd_bl_w[5:0];
				p6_cmd_byte_addr_r[29:0] <= p6_cmd_byte_addr_w[29:0];
				p6_req_r <= p6_req_w;
				p6_cmd_req_r[1:0] <= p6_cmd_req_w[1:0];
				p6_cmd_ack_r <= p6_cmd_ack_w;
				p6_wr_mask_r[3:0] <= p6_wr_mask_w[3:0];
				p6_wr_data_r[31:0] <= p6_wr_data_w[31:0];
				p6_rd_data_r[31:0] <= p6_rd_data_w[31:0];
			end
	end

	assign p6_cmd_instr_w[3:0]=(p6_cmd_req_r[1:0]==2'b00) ? p6_cmd_instr[3:0] : p6_cmd_instr_r[3:0];
	assign p6_cmd_bl_w[5:0]=(p6_cmd_req_r[1:0]==2'b00) ? p6_cmd_bl[5:0] : p6_cmd_bl_r[5:0];
	assign p6_cmd_byte_addr_w[29:0]=(p6_cmd_req_r[1:0]==2'b00) ? p6_cmd_byte_addr[29:0] : p6_cmd_byte_addr_r[29:0];

	assign p6_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b00) & (p6_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b00) & (p6_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b110) ? 1'b1 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b110) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b110) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p6_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b00) & (p6_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b00) & (p6_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b110) ? 2'b01 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b110) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b110) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p6_cmd_ack_w=(init_done==1'b1) & (p6_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p6_wr_mask_w[3:0]=(p6_cmd_req_r[1:0]==2'b00) ? p6_wr_mask[3:0] : p6_wr_mask_r[3:0];
	assign p6_wr_data_w[31:0]=(p6_cmd_req_r[1:0]==2'b00) ? p6_wr_data[31:0] : p6_wr_data_r[31:0];
	assign p6_rd_data_w[31:0]=(p6_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p6_rd_data_r[31:0];

	// ---- p7 ----

	assign p7_cmd_ack=p7_cmd_ack_r;
	assign p7_rd_data[31:0]=p7_rd_data_r[31:0];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				p7_cmd_instr_r[3:0] <= 4'b0;
				p7_cmd_bl_r[5:0] <= 6'b0;
				p7_cmd_byte_addr_r[29:0] <= 30'b0;
				p7_req_r <= 1'b0;
				p7_cmd_req_r[1:0] <= 2'b0;
				p7_cmd_ack_r <= 4'b0;
				p7_wr_mask_r[3:0] <= 4'b0;
				p7_wr_data_r[31:0] <= 32'b0;
				p7_rd_data_r[31:0] <= 32'b0;
			end
		else
			begin
				p7_cmd_instr_r[3:0] <= p7_cmd_instr_w[3:0];
				p7_cmd_bl_r[5:0] <= p7_cmd_bl_w[5:0];
				p7_cmd_byte_addr_r[29:0] <= p7_cmd_byte_addr_w[29:0];
				p7_req_r <= p7_req_w;
				p7_cmd_req_r[1:0] <= p7_cmd_req_w[1:0];
				p7_cmd_ack_r <= p7_cmd_ack_w;
				p7_wr_mask_r[3:0] <= p7_wr_mask_w[3:0];
				p7_wr_data_r[31:0] <= p7_wr_data_w[31:0];
				p7_rd_data_r[31:0] <= p7_rd_data_w[31:0];
			end
	end

	assign p7_cmd_instr_w[3:0]=(p7_cmd_req_r[1:0]==2'b00) ? p7_cmd_instr[3:0] : p7_cmd_instr_r[3:0];
	assign p7_cmd_bl_w[5:0]=(p7_cmd_req_r[1:0]==2'b00) ? p7_cmd_bl[5:0] : p7_cmd_bl_r[5:0];
	assign p7_cmd_byte_addr_w[29:0]=(p7_cmd_req_r[1:0]==2'b00) ? p7_cmd_byte_addr[29:0] : p7_cmd_byte_addr_r[29:0];

	assign p7_req_w=
			(init_done==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b00) & (p7_cmd_req==1'b0) ? 1'b0 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b00) & (p7_cmd_req==1'b1) ? 1'b1 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b111) ? 1'b1 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b111) & (mem_cmd_ack==1'b0) ? 1'b1 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b111) & (mem_cmd_ack==1'b1) ? 1'b0 :
			1'b0;

	assign p7_cmd_req_w[1:0]=
			(init_done==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b00) & (p7_cmd_req==1'b0) ? 2'b00 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b00) & (p7_cmd_req==1'b1) ? 2'b01 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]!=3'b111) ? 2'b01 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b111) & (mem_cmd_ack==1'b0) ? 2'b01 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b01) & (mem_master_r[2:0]==3'b111) & (mem_cmd_ack==1'b1) ? 2'b11 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}==2'b00) ? 2'b11 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 2'b10 :
			(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b10) ? 2'b00 :
			2'b0;

	assign p7_cmd_ack_w=(init_done==1'b1) & (p7_cmd_req_r[1:0]==2'b11) & ({mem_wr_ack,mem_rd_ack}!=2'b00) ? 1'b1 : 1'b0;

	assign p7_wr_mask_w[3:0]=(p7_cmd_req_r[1:0]==2'b00) ? p7_wr_mask[3:0] : p7_wr_mask_r[3:0];
	assign p7_wr_data_w[31:0]=(p7_cmd_req_r[1:0]==2'b00) ? p7_wr_data[31:0] : p7_wr_data_r[31:0];
	assign p7_rd_data_w[31:0]=(p7_cmd_req_r[1:0]==2'b11) ? mem_rd_data[31:0] : p7_rd_data_r[31:0];

endmodule
