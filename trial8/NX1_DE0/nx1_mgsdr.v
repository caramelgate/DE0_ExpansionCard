//-----------------------------------------------------------------------------
//
//  nx1_mgsdr.v : sdr-sdram module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/feb/04 release 0.0  connection test
//       mar/27 release 0.1  interface change
//  2014/jan/04 release 0.1a rename nx1_mgsd.v , burst=8
//       jan/10 release 0.2a preview
//
//------------------------------------------------------------------------------
//
//  clk=54MHz , cl=2 , data=16bit , burst=8
//
//
//------------------------------------------------------------------------------

module nx1_mgsdr #(
	parameter	DEVICE=1,		// 0=xilinx , 1=altera
	parameter	SIM_FAST=0		// 
) (
	output	[11:0]	sdr_addr,			// out   [SDR] addr[11:0]
	output	[1:0]	sdr_ba,				// out   [SDR] bank[1:0]
	output			sdr_cas_n,			// out   [SDR] #cas
	output			sdr_cke,			// out   [SDR] cke
	output			sdr_clk,			// out   [SDR] clk
	output			sdr_cs_n,			// out   [SDR] #cs
	output	[15:0]	sdr_wdata,			// out   [SDR] write data[15:0]
	input	[15:0]	sdr_rdata,			// in    [SDR] read data[15:0]
	output			sdr_oe,				// out   [SDR] data oe
	output	[1:0]	sdr_dqm,			// out   [SDR] dqm[1:0]
	output			sdr_ras_n,			// out   [SDR] #ras
	output			sdr_we_n,			// out   [SDR] #we

	input			mem_cmd_req,		// in    [MEM] cmd req
	input	[2:0]	mem_cmd_instr,		// in    [MEM] cmd inst[2:0]
	input	[5:0]	mem_cmd_bl,			// in    [MEM] cmd blen[5:0]
	input	[29:0]	mem_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	input	[2:0]	mem_cmd_master,		// in    [MEM] cmd master[2:0]
	output			mem_cmd_ack,		// out   [MEM] cmd ack
	input	[3:0]	mem_wr_mask,		// in    [MEM] wr mask[3:0]
	input	[31:0]	mem_wr_data,		// in    [MEM] wr wdata[31:0]
	output			mem_wr_ack,			// out   [MEM] wr ack
	output	[2:0]	mem_wr_master,		// out   [MEM] wr master[2:0]
	output			mem_rd_req,			// out   [MEM] rd req
	output	[31:0]	mem_rd_data,		// out   [MEM] rd rdata[31:0]
	output	[2:0]	mem_rd_master,		// out   [MEM] rd master[2:0]

	output			mem_init_done,		// out   [SYS] init_done
	input			mem_clk1,			// in    [SYS] clk +90deg
	input			mem_clk,			// in    [SYS] clk 54MHz
	input			mem_rst_n			// in    [SYS] #reset
);

/*

clk       T0    T1    T2    T3    T4    T5    Tx    T0    T1
   __    __    __    __    __    __    __    __    __    __    __    __ 
__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \
          _____                                     _____ 
abt      X_REQ_X                                   X_REQ_X
                                              _____
ack                                         _/(ACK)\_
              _       _
ras            \_RAS_/
                          _       _
cas                        \_CAS_/
                            _____ _____ 
wdata                      X_D0__X_D1__X
                                     _____ _____ 
rdata                               X_D0__X_D1__X
            __    __    __    __    __    __    __    __    __    __    __ 
sdclk    __/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \
*/

generate
	if (DEVICE==0)
begin

ODDR oddr_sdrclk(.Q(sdr_clk),.C(mem_clk1),.CE(1'b1),.D1(1'b1),.D2(1'b0),.R(1'b0),.S(1'b0));
//ODDR oddr_sdrclk(.Q(sdr_clk),.C(mem_clk),.CE(1'b1),.D1(1'b0),.D2(1'b1),.R(1'b0),.S(1'b0));

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altddio_bidir altddio_sdrclk (
	.aclr(!mem_rst_n),
	.datain_h(1'b1),
	.datain_l(1'b0),
	.inclock(mem_clk1),
	.oe(1'b1),
	.outclock(mem_clk1),
	.combout(),
	.dataout_h(),
	.dataout_l(),
	.padio(sdr_clk)
);

/*
alt_altddio_bidir altddio_sdrclk (
	.aclr(!mem_rst_n),
	.datain_h(1'b0),
	.datain_l(1'b1),
	.inclock(mem_clk),
	.oe(1'b1),
	.outclock(mem_clk),
	.combout(),
	.dataout_h(),
	.dataout_l(),
	.padio(sdr_clk)
);
*/
end
endgenerate

generate
	if ((DEVICE!=0) & (DEVICE!=1))

	assign sdr_clk=mem_clk1;
//	assign sdr_clk=mem_clk;

endgenerate

	wire	sdrc_req;
	wire	[31:0] sdrc_addr;
//	wire	[31:0] sdrc_rdata;
	wire	[31:0] sdrc_wdata;
	wire	[3:0] sdrc_be;
	wire	sdrc_rd;
//	wire	sdrc_wr;
//	wire	[31:0] sdrc_addr_sel;
//	wire	[31:0] sdrc_wdata_sel;
//	wire	[3:0] sdrc_be_sel;
	wire	[5:0] sdrc_bl;

	reg		sdrc_init_done_r;
	reg		sdrc_ref_req_r;
	reg		[11:0] sdrc_count_r;
	reg		[5:0] sdrc_state_r;
	reg		[5:0] sdrc_bl_r;
	reg		sdrc_ack_r;
	reg		sdrc_cmd_ack_r;
	reg		sdrc_rd_ack_r;
	reg		sdrc_wr_ack_r;
	reg		sdrc_cs_n_r;
	reg		sdrc_ras_n_r;
	reg		sdrc_cas_n_r;
	reg		sdrc_we_n_r;
	reg		sdrc_oe_r;
	reg		[13:0] sdrc_addr_out_r;
	reg		[15:0] sdrc_wdata_out_r;
	reg		[1:0] sdrc_be_out_r;
	reg		[31:0] sdrc_addr_r;
	reg		[31:0] sdrc_wdata_r;
	reg		[31:0] sdrc_rdata_r;
	reg		[3:0] sdrc_be_r;
	reg		sdrc_load_r;
	reg		sdrc_store_r;

	wire	sdrc_init_done_w;
	wire	sdrc_ref_req_w;
	wire	[11:0] sdrc_count_w;
	wire	[5:0] sdrc_state_w;
	wire	[5:0] sdrc_bl_w;
	wire	sdrc_ack_w;
	wire	sdrc_cmd_ack_w;
	wire	sdrc_rd_ack_w;
	wire	sdrc_wr_ack_w;
	wire	sdrc_cs_n_w;
	wire	sdrc_ras_n_w;
	wire	sdrc_cas_n_w;
	wire	sdrc_we_n_w;
	wire	sdrc_oe_w;
	wire	[13:0] sdrc_addr_out_w;
	wire	[15:0] sdrc_wdata_out_w;
	wire	[1:0] sdrc_be_out_w;
	wire	[31:0] sdrc_addr_w;
	wire	[31:0] sdrc_wdata_w;
	wire	[31:0] sdrc_rdata_w;
	wire	[3:0] sdrc_be_w;
	wire	sdrc_load_w;
	wire	sdrc_store_w;

	localparam	sdrc_st00=0;
	localparam	sdrc_st01=1;
	localparam	sdrc_st02=2;
	localparam	sdrc_st03=3;
	localparam	sdrc_st10=4;
	localparam	sdrc_st11=5;
	localparam	sdrc_st12=6;
	localparam	sdrc_st13=7;
	localparam	sdrc_st14=8;
	localparam	sdrc_st15=9;
	localparam	sdrc_st16=10;
	localparam	sdrc_st17=11;
	localparam	sdrc_st20=12;	// ras
	localparam	sdrc_st21=13;
	localparam	sdrc_st22=14;	// cas
	localparam	sdrc_st23=15;
	localparam	sdrc_st24=16;
	localparam	sdrc_st25=17;	// rd0
	localparam	sdrc_st26=18;	// rd1
	localparam	sdrc_st27=19;	// rd2
	localparam	sdrc_st28=20;	// rd3
	localparam	sdrc_st29=21;	// rd4
	localparam	sdrc_st2a=22;	// rd5
	localparam	sdrc_st2b=23;	// rd6
	localparam	sdrc_st2c=24;	// rd7
	localparam	sdrc_st2d=25;
	localparam	sdrc_st30=26;	// ras
	localparam	sdrc_st31=27;
	localparam	sdrc_st32=28;	// cas wr0
	localparam	sdrc_st33=29;	// wr1
	localparam	sdrc_st34=30;	// wr2
	localparam	sdrc_st35=31;	// wr3
	localparam	sdrc_st36=32;	// wr4
	localparam	sdrc_st37=33;	// wr5
	localparam	sdrc_st38=34;	// wr5
	localparam	sdrc_st39=35;	// wr6
	localparam	sdrc_st3a=36;	// wr7
	localparam	sdrc_st3b=37;
	localparam	sdrc_st3c=38;
	localparam	sdrc_st3d=39;

	assign sdr_addr[11:0]=sdrc_addr_out_r[11:0];
	assign sdr_ba[1:0]=sdrc_addr_out_r[13:12];
	assign sdr_cas_n=sdrc_cas_n_r;
	assign sdr_cke=mem_rst_n;
	assign sdr_cs_n=sdrc_cs_n_r;
	assign sdr_wdata[15:0]=sdrc_wdata_out_r[15:0];
	assign sdr_oe=sdrc_oe_r;
	assign sdr_dqm[1:0]={!sdrc_be_out_r[1],!sdrc_be_out_r[0]};
	assign sdr_ras_n=sdrc_ras_n_r;
	assign sdr_we_n=sdrc_we_n_r;

	assign mem_init_done=sdrc_init_done_r;

	wire	mem_t0;
	reg		[3:0] mem_t0_r;
	wire	[3:0] mem_t0_w;

	reg		[2:0] mem_cmd_master_r;
	wire	[2:0] mem_cmd_master_w;

	assign mem_t0=mem_t0_r[3];

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem_t0_r[3:0] <= 4'b0;
				mem_cmd_master_r[2:0] <= 3'b0;
				sdrc_init_done_r <= 1'b0;
				sdrc_ref_req_r <= 1'b0;
				sdrc_count_r[11:0] <= 12'b0;
				sdrc_state_r <= sdrc_st00;
				sdrc_bl_r[5:0] <= 6'b0;
				sdrc_ack_r <= 1'b0;
				sdrc_cmd_ack_r <= 1'b0;
				sdrc_rd_ack_r <= 1'b0;
				sdrc_wr_ack_r <= 1'b0;
				sdrc_cs_n_r <= 1'b1;
				sdrc_ras_n_r <= 1'b1;
				sdrc_cas_n_r <= 1'b1;
				sdrc_we_n_r <= 1'b1;
				sdrc_oe_r <= 1'b0;
				sdrc_addr_out_r[13:0] <= 14'b0;
				sdrc_wdata_out_r[15:0] <= 16'b0;
				sdrc_be_out_r[1:0] <= 2'b0;
				sdrc_addr_r[31:0] <= 32'b0;
				sdrc_wdata_r[31:0] <= 32'b0;
				sdrc_rdata_r[31:0] <= 32'b0;
				sdrc_be_r[3:0] <= 4'b0;
				sdrc_load_r <= 1'b0;
				sdrc_store_r <= 1'b0;
			end
		else
			begin
				mem_t0_r[3:0] <= mem_t0_w[3:0];
				mem_cmd_master_r[2:0] <= mem_cmd_master_w[2:0];
				sdrc_init_done_r <= sdrc_init_done_w;
				sdrc_ref_req_r <= sdrc_ref_req_w;
				sdrc_count_r[11:0] <= sdrc_count_w[11:0];
				sdrc_state_r <= sdrc_state_w;
				sdrc_bl_r[5:0] <= sdrc_bl_w[5:0];
				sdrc_ack_r <= sdrc_ack_w;
				sdrc_cmd_ack_r <= sdrc_cmd_ack_w;
				sdrc_rd_ack_r <= sdrc_rd_ack_w;
				sdrc_wr_ack_r <= sdrc_wr_ack_w;
				sdrc_cs_n_r <= sdrc_cs_n_w;
				sdrc_ras_n_r <= sdrc_ras_n_w;
				sdrc_cas_n_r <= sdrc_cas_n_w;
				sdrc_we_n_r <= sdrc_we_n_w;
				sdrc_oe_r <= sdrc_oe_w;
				sdrc_addr_out_r[13:0] <= sdrc_addr_out_w[13:0];
				sdrc_wdata_out_r[15:0] <= sdrc_wdata_out_w[15:0];
				sdrc_be_out_r[1:0] <= sdrc_be_out_w[1:0];
				sdrc_addr_r[31:0] <= sdrc_addr_w[31:0];
				sdrc_wdata_r[31:0] <= sdrc_wdata_w[31:0];
				sdrc_rdata_r[31:0] <= sdrc_rdata_w[31:0];
				sdrc_be_r[3:0] <= sdrc_be_w[3:0];
				sdrc_load_r <= sdrc_load_w;
				sdrc_store_r <= sdrc_store_w;
			end
	end

	assign mem_t0_w[3]=(mem_t0_r[2:0]==3'b110) ? 1'b1 : 1'b0;
	assign mem_t0_w[2:0]=(mem_t0_r[2:0]==3'b110) ? 3'b0 : mem_t0_r[2:0]+3'b01;

	assign mem_cmd_master_w[2:0]=(sdrc_state_r==sdrc_st10) ? mem_cmd_master[2:0] : mem_cmd_master_r[2:0];

	assign sdrc_init_done_w=(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) ? 1'b1 : sdrc_init_done_r;

	assign sdrc_count_w[11:0]=
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b0) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b1) ? sdrc_count_r[11:0]+12'h01 :
			(sdrc_state_r==sdrc_st01) ? 12'b0 :
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b0) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b1) ? sdrc_count_r[11:0]+12'h01 :
			(sdrc_state_r==sdrc_st03) ? 12'b0 :

			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b0) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) ? sdrc_count_r[11:0]+12'h01 :
			(sdrc_state_r==sdrc_st11) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st12) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st13) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st14) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st15) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st16) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st17) ? sdrc_count_r[11:0] :

			(sdrc_state_r==sdrc_st20) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st21) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st22) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st23) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st24) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st25) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st26) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st27) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st28) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st29) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st2a) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st2b) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st2c) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st2d) ? sdrc_count_r[11:0] :

			(sdrc_state_r==sdrc_st30) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st31) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st32) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st33) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st34) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st35) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st36) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st37) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st38) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st39) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st3a) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st3b) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st3c) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st3d) ? sdrc_count_r[11:0] :
			12'h0;

	assign sdrc_ref_req_w=
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b0) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b1) & (SIM_FAST==1'b0) & (sdrc_count_r[10:0]==11'h7ff) ? 1'b1 :
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b1) & (SIM_FAST==1'b1) & (sdrc_count_r[4:0]==5'h1f) ? 1'b1 :
			(sdrc_state_r==sdrc_st01) ? 1'b0 :
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b0) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b1) & (sdrc_count_r[2:0]==3'h7) ? 1'b1 :
			(sdrc_state_r==sdrc_st03) ? 1'b0 :

			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b0) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (SIM_FAST==1'b0) & (sdrc_count_r[6:0]==7'h7f) ? 1'b1 :
			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (SIM_FAST==1'b0) & (sdrc_count_r[6:0]!=7'h7f) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (SIM_FAST==1'b1) & (sdrc_count_r[4:0]==5'h1f) ? 1'b1 :
			(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (SIM_FAST==1'b1) & (sdrc_count_r[4:0]!=5'h1f) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st11) ? 1'b0 :
			(sdrc_state_r==sdrc_st12) ? 1'b0 :
			(sdrc_state_r==sdrc_st13) ? 1'b0 :
			(sdrc_state_r==sdrc_st14) ? 1'b0 :
			(sdrc_state_r==sdrc_st15) ? 1'b0 :
			(sdrc_state_r==sdrc_st16) ? 1'b0 :
			(sdrc_state_r==sdrc_st17) ? 1'b0 :

			(sdrc_state_r==sdrc_st20) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st21) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st22) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st23) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st24) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st25) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st26) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st27) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st28) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st29) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st2a) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st2b) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st2c) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st2d) ? sdrc_ref_req_r :

			(sdrc_state_r==sdrc_st30) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st31) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st32) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st33) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st34) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st35) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st36) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st37) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st38) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st39) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st3a) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st3b) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st3c) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st3d) ? sdrc_ref_req_r :
			1'b0;

	assign sdrc_state_w=
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b0) ? sdrc_st00 :	// wiat
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b1) & (sdrc_ref_req_r==1'b0) ? sdrc_st00 :	// wait 200us
			(sdrc_state_r==sdrc_st00) & (mem_t0==1'b1) & (sdrc_ref_req_r==1'b1) ? sdrc_st01 :	// 200us done
			(sdrc_state_r==sdrc_st01) & (mem_t0==1'b0) ? sdrc_st01 :	// wait
			(sdrc_state_r==sdrc_st01) & (mem_t0==1'b1) ? sdrc_st02 :	// precharge all
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b0) ? sdrc_st02 :	// wait
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b1) & (sdrc_ref_req_r==1'b0) ? sdrc_st02 :	// wait refresh
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b1) & (sdrc_ref_req_r==1'b1) ? sdrc_st03 :	// refresh
			(sdrc_state_r==sdrc_st03) & (mem_t0==1'b0) ? sdrc_st03 :	// wait
			(sdrc_state_r==sdrc_st03) & (mem_t0==1'b1) ? sdrc_st10 :	// mode set

		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b0) ? sdrc_st10 :	// wait
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b0) & (sdrc_ref_req_r==1'b0) ? sdrc_st10 :	// wait
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b0) & (sdrc_ref_req_r==1'b1) ? sdrc_st11 :	// refresh
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? sdrc_st20 :	// read
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? sdrc_st30 :	// write

			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b1) ? sdrc_st11 :	// refresh
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b0) ? sdrc_st10 :	// wait
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? sdrc_st20 :	// read
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? sdrc_st30 :	// write

			(sdrc_state_r==sdrc_st11) ? sdrc_st12 :	// refresh
			(sdrc_state_r==sdrc_st12) ? sdrc_st13 :
			(sdrc_state_r==sdrc_st13) ? sdrc_st14 :
			(sdrc_state_r==sdrc_st14) ? sdrc_st15 :
			(sdrc_state_r==sdrc_st15) ? sdrc_st16 :
			(sdrc_state_r==sdrc_st16) ? sdrc_st17 :
			(sdrc_state_r==sdrc_st17) ? sdrc_st10 :

			(sdrc_state_r==sdrc_st20) ? sdrc_st21 :	// read
			(sdrc_state_r==sdrc_st21) ? sdrc_st22 :
			(sdrc_state_r==sdrc_st22) ? sdrc_st23 :
			(sdrc_state_r==sdrc_st23) ? sdrc_st24 :
			(sdrc_state_r==sdrc_st24) ? sdrc_st25 :
			(sdrc_state_r==sdrc_st25) ? sdrc_st26 :
			(sdrc_state_r==sdrc_st26) ? sdrc_st27 :
			(sdrc_state_r==sdrc_st27) ? sdrc_st28 :
			(sdrc_state_r==sdrc_st28) ? sdrc_st29 :
			(sdrc_state_r==sdrc_st29) ? sdrc_st2a :
			(sdrc_state_r==sdrc_st2a) ? sdrc_st2b :
			(sdrc_state_r==sdrc_st2b) ? sdrc_st2c :
			(sdrc_state_r==sdrc_st2c) ? sdrc_st2d :
			(sdrc_state_r==sdrc_st2d) ? sdrc_st10 :

			(sdrc_state_r==sdrc_st30) ? sdrc_st31 :	// write
			(sdrc_state_r==sdrc_st31) ? sdrc_st32 :
			(sdrc_state_r==sdrc_st32) ? sdrc_st33 :
			(sdrc_state_r==sdrc_st33) ? sdrc_st34 :
			(sdrc_state_r==sdrc_st34) ? sdrc_st35 :
			(sdrc_state_r==sdrc_st35) ? sdrc_st36 :
			(sdrc_state_r==sdrc_st36) ? sdrc_st37 :
			(sdrc_state_r==sdrc_st37) ? sdrc_st38 :
			(sdrc_state_r==sdrc_st38) ? sdrc_st39 :
			(sdrc_state_r==sdrc_st39) ? sdrc_st3a :
			(sdrc_state_r==sdrc_st3a) ? sdrc_st3b :
			(sdrc_state_r==sdrc_st3b) ? sdrc_st3c :
			(sdrc_state_r==sdrc_st3c) ? sdrc_st3d :
			(sdrc_state_r==sdrc_st3d) ? sdrc_st10 :
			sdrc_st00;

	assign sdrc_bl_w[5:0]=
			(sdrc_state_r==sdrc_st00) ? 6'b0 :
			(sdrc_state_r==sdrc_st01) ? 6'b0 :
			(sdrc_state_r==sdrc_st02) ? 6'b0 :
			(sdrc_state_r==sdrc_st03) ? 6'b0 :
			(sdrc_state_r==sdrc_st10) ? sdrc_bl[5:0] :
			(sdrc_state_r==sdrc_st11) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st12) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st13) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st14) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st15) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st16) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st17) ? sdrc_bl_r[5:0] :

			(sdrc_state_r==sdrc_st20) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st21) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st22) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st23) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st24) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st25) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st26) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st27) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st28) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st29) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st2a) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st2b) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st2c) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st2d) ? sdrc_bl_r[5:0]-6'b0100 :

			(sdrc_state_r==sdrc_st30) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st31) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st32) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st33) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st34) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st35) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st36) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st37) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st38) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st39) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st3a) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st3b) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st3c) ? sdrc_bl_r[5:0] :
			(sdrc_state_r==sdrc_st3d) ? sdrc_bl_r[5:0]-6'b0100 :
			6'b0;

	assign sdrc_ack_w=
			(sdrc_state_r==sdrc_st2d) ? 1'b1 :
			(sdrc_state_r==sdrc_st3d) ? 1'b1 :
			1'b0;

	assign sdrc_cmd_ack_w=
			(sdrc_state_r==sdrc_st21) ? 1'b1 :
			(sdrc_state_r==sdrc_st31) ? 1'b1 :
			1'b0;
	assign sdrc_rd_ack_w=(sdrc_state_r==sdrc_st25) ? 1'b1 : 1'b0;
	assign sdrc_wr_ack_w=(sdrc_state_r==sdrc_st35) ? 1'b1 : 1'b0;

	assign {sdrc_cs_n_w,sdrc_ras_n_w,sdrc_cas_n_w,sdrc_we_n_w}=
			(sdrc_state_r==sdrc_st00) ? 4'b1111 :
			(sdrc_state_r==sdrc_st01) & (mem_t0==1'b0) ? 4'b1111 :	//
			(sdrc_state_r==sdrc_st01) & (mem_t0==1'b1) ? 4'b0010 :	// precharge all
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b0) ? 4'b1111 :	// 
			(sdrc_state_r==sdrc_st02) & (mem_t0==1'b1) ? 4'b0001 :	// refresh
			(sdrc_state_r==sdrc_st03) & (mem_t0==1'b0) ? 4'b1111 :	// 
			(sdrc_state_r==sdrc_st03) & (mem_t0==1'b1) ? 4'b0000 :	// mode set

	//		(sdrc_state_r==sdrc_st10) & (mem_t0==1'b0) ? 4'b1111 :	// wait
	//		(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b0) & (sdrc_ref_req_r==1'b0) ? 4'b1111 :	// wait
	//		(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b0) & (sdrc_ref_req_r==1'b1) ? 4'b0001 :	// refresh
	//		(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? 4'b0011 :	// read
	//		(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? 4'b0011 :	// write

			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b1) ? 4'b0001 :	// refresh
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b0)  ? 4'b1111 :	// wait
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? 4'b1111 :	// read
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? 4'b1111 :	// write

			(sdrc_state_r==sdrc_st11) ? 4'b1111 :
			(sdrc_state_r==sdrc_st12) ? 4'b1111 :
			(sdrc_state_r==sdrc_st13) ? 4'b1111 :
			(sdrc_state_r==sdrc_st14) ? 4'b1111 :
			(sdrc_state_r==sdrc_st15) ? 4'b1111 :
			(sdrc_state_r==sdrc_st16) ? 4'b1111 :
			(sdrc_state_r==sdrc_st17) ? 4'b1111 :

			(sdrc_state_r==sdrc_st20) ? 4'b0011 :	// read : cs,ras
			(sdrc_state_r==sdrc_st21) ? 4'b1111 :
			(sdrc_state_r==sdrc_st22) ? 4'b0101 :	// read : cs,cas
			(sdrc_state_r==sdrc_st23) ? 4'b1111 :
			(sdrc_state_r==sdrc_st24) ? 4'b1111 :
			(sdrc_state_r==sdrc_st25) ? 4'b1111 :
			(sdrc_state_r==sdrc_st26) ? 4'b1111 :
			(sdrc_state_r==sdrc_st27) ? 4'b1111 :
			(sdrc_state_r==sdrc_st28) ? 4'b1111 :
			(sdrc_state_r==sdrc_st29) ? 4'b1111 :
			(sdrc_state_r==sdrc_st2a) ? 4'b1111 :
			(sdrc_state_r==sdrc_st2b) ? 4'b1111 :
			(sdrc_state_r==sdrc_st2c) ? 4'b1111 :
			(sdrc_state_r==sdrc_st2d) ? 4'b1111 :

			(sdrc_state_r==sdrc_st30) ? 4'b0011 :	// write : cs,ras
			(sdrc_state_r==sdrc_st31) ? 4'b1111 :
			(sdrc_state_r==sdrc_st32) ? 4'b0100 :	// write : cs,cas,wr
			(sdrc_state_r==sdrc_st33) ? 4'b1111 :
			(sdrc_state_r==sdrc_st34) ? 4'b1111 :
			(sdrc_state_r==sdrc_st35) ? 4'b1111 :
			(sdrc_state_r==sdrc_st36) ? 4'b1111 :
			(sdrc_state_r==sdrc_st38) ? 4'b1111 :
			(sdrc_state_r==sdrc_st39) ? 4'b1111 :
			(sdrc_state_r==sdrc_st3a) ? 4'b1111 :
			(sdrc_state_r==sdrc_st3b) ? 4'b1111 :
			(sdrc_state_r==sdrc_st3c) ? 4'b1111 :
			(sdrc_state_r==sdrc_st3d) ? 4'b1111 :
			4'b1111;

	wire	[13:0] sdrc_addr_mode;
	wire	[13:0] sdrc_addr_ras;
	wire	[13:0] sdrc_addr_cas;

	assign sdrc_addr_mode[13:0]=14'h0023;	//  cl=2, burst=8
	assign sdrc_addr_ras[13:0]={sdrc_addr[22:21],sdrc_addr[20:9]};
	assign sdrc_addr_cas[13:0]={sdrc_addr_out_r[13:12],4'b0100,sdrc_addr_r[8:4],3'b0};	// auto precharge

	assign {sdrc_addr_out_w[13:0],sdrc_oe_w,sdrc_be_out_w[1:0],sdrc_wdata_out_w[15:0]}=
			(sdrc_state_r==sdrc_st00) ? {14'h0fff,1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st01) ? {14'h0fff,1'b0,2'b0,16'b0} :				// precharge all
			(sdrc_state_r==sdrc_st02) ? {14'h0fff,1'b0,2'b0,16'b0} :				// refresh
			(sdrc_state_r==sdrc_st03) ? {sdrc_addr_mode[13:0],1'b0,2'b0,16'b0} :	// mode set

			(sdrc_state_r==sdrc_st10) ? {sdrc_addr_ras[13:0],1'b0,2'b0,16'b0} :	// ras
			(sdrc_state_r==sdrc_st11) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st12) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st13) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st14) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st15) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st16) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st17) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			(sdrc_state_r==sdrc_st20) ? {sdrc_addr_ras[13:0],1'b0,2'b0,16'b0} :	// ras
			(sdrc_state_r==sdrc_st21) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st22) ? {sdrc_addr_cas[13:0],1'b0,2'b11,16'b0} :	// rd auto precharge
			(sdrc_state_r==sdrc_st23) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :
			(sdrc_state_r==sdrc_st24) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :	// rd0
			(sdrc_state_r==sdrc_st25) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :
			(sdrc_state_r==sdrc_st26) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :	// rd2
			(sdrc_state_r==sdrc_st27) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :
			(sdrc_state_r==sdrc_st28) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :	// rd4
			(sdrc_state_r==sdrc_st29) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :
			(sdrc_state_r==sdrc_st2a) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :	// rd6
			(sdrc_state_r==sdrc_st2b) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st2c) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st2d) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			(sdrc_state_r==sdrc_st30) ? {sdrc_addr_ras[13:0],1'b0,2'b0,16'b0} :	// ras
			(sdrc_state_r==sdrc_st31) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st32) ? {sdrc_addr_cas[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :	// wr0 auto precharge
			(sdrc_state_r==sdrc_st33) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :
			(sdrc_state_r==sdrc_st34) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :	// wr2
			(sdrc_state_r==sdrc_st35) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :
			(sdrc_state_r==sdrc_st36) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :	// wr4
			(sdrc_state_r==sdrc_st37) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :
			(sdrc_state_r==sdrc_st38) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :	// wr6
			(sdrc_state_r==sdrc_st39) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :
			(sdrc_state_r==sdrc_st3a) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st3b) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st3c) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st3d) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			{14'b0,1'b0,2'b0,16'b0};

	assign sdrc_addr_w[31:0]=(sdrc_state_r==sdrc_st10) ? sdrc_addr[31:0] : sdrc_addr_r[31:0];

	assign sdrc_load_w=
		//	(sdrc_state_r==sdrc_st30) ? 1'b0 :
			(sdrc_state_r==sdrc_st30) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b00) ? 1'b1 :
			(sdrc_state_r==sdrc_st30) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b0 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st30) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st30) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st31) ? 1'b0 :
			(sdrc_state_r==sdrc_st32) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b01) ? 1'b1 :
			(sdrc_state_r==sdrc_st32) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b0 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st32) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st32) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st33) ? 1'b0 :
			(sdrc_state_r==sdrc_st34) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b10) ? 1'b1 :
			(sdrc_state_r==sdrc_st34) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b1 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st34) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st34) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st35) ? 1'b0 :
			(sdrc_state_r==sdrc_st36) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b11) ? 1'b1 :
			(sdrc_state_r==sdrc_st36) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b1 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st36) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b0 :
			(sdrc_state_r==sdrc_st36) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st37) ? 1'b0 :
			(sdrc_state_r==sdrc_st39) ? 1'b0 :
			(sdrc_state_r==sdrc_st3a) ? 1'b0 :
			(sdrc_state_r==sdrc_st3b) ? 1'b0 :
			(sdrc_state_r==sdrc_st3c) ? 1'b0 :
			(sdrc_state_r==sdrc_st3d) ? 1'b0 :
			1'b0;

	assign {sdrc_be_w[3:0],sdrc_wdata_w[31:0]}=
			(sdrc_state_r==sdrc_st10) ? 36'b0 :
			(sdrc_state_r==sdrc_st11) ? 36'b0 :
			(sdrc_state_r==sdrc_st12) ? 36'b0 :
			(sdrc_state_r==sdrc_st13) ? 36'b0 :
			(sdrc_state_r==sdrc_st14) ? 36'b0 :
			(sdrc_state_r==sdrc_st15) ? 36'b0 :
			(sdrc_state_r==sdrc_st16) ? 36'b0 :
			(sdrc_state_r==sdrc_st17) ? 36'b0 :
			(sdrc_state_r==sdrc_st20) ? 36'b0 :
			(sdrc_state_r==sdrc_st21) ? 36'b0 :
			(sdrc_state_r==sdrc_st22) ? 36'b0 :
			(sdrc_state_r==sdrc_st23) ? 36'b0 :
			(sdrc_state_r==sdrc_st24) ? 36'b0 :
			(sdrc_state_r==sdrc_st25) ? 36'b0 :
			(sdrc_state_r==sdrc_st26) ? 36'b0 :
			(sdrc_state_r==sdrc_st27) ? 36'b0 :
			(sdrc_state_r==sdrc_st28) ? 36'b0 :
			(sdrc_state_r==sdrc_st29) ? 36'b0 :
			(sdrc_state_r==sdrc_st2a) ? 36'b0 :
			(sdrc_state_r==sdrc_st2b) ? 36'b0 :
			(sdrc_state_r==sdrc_st2c) ? 36'b0 :
			(sdrc_state_r==sdrc_st2d) ? 36'b0 :
			(sdrc_state_r==sdrc_st30) ? 36'b0 :
			(sdrc_state_r==sdrc_st31) & (sdrc_load_r==1'b1) ? {sdrc_be[3:0],sdrc_wdata[31:0]} :
			(sdrc_state_r==sdrc_st31) & (sdrc_load_r==1'b0) ? {4'b0,32'b0} :
			(sdrc_state_r==sdrc_st32) ? {2'b0,sdrc_be_r[3:2],16'b0,sdrc_wdata_r[31:16]} :
			(sdrc_state_r==sdrc_st33) & (sdrc_load_r==1'b1) ? {sdrc_be[3:0],sdrc_wdata[31:0]} :
			(sdrc_state_r==sdrc_st33) & (sdrc_load_r==1'b0) ? {4'b0,32'b0} :
			(sdrc_state_r==sdrc_st34) ? {2'b0,sdrc_be_r[3:2],16'b0,sdrc_wdata_r[31:16]} :
			(sdrc_state_r==sdrc_st35) & (sdrc_load_r==1'b1) ? {sdrc_be[3:0],sdrc_wdata[31:0]} :
			(sdrc_state_r==sdrc_st35) & (sdrc_load_r==1'b0) ? {4'b0,32'b0} :
			(sdrc_state_r==sdrc_st36) ? {2'b0,sdrc_be_r[3:2],16'b0,sdrc_wdata_r[31:16]} :
			(sdrc_state_r==sdrc_st37) & (sdrc_load_r==1'b1) ? {sdrc_be[3:0],sdrc_wdata[31:0]} :
			(sdrc_state_r==sdrc_st37) & (sdrc_load_r==1'b0) ? {4'b0,32'b0} :
			(sdrc_state_r==sdrc_st38) ? {2'b0,sdrc_be_r[3:2],16'b0,sdrc_wdata_r[31:16]} :
			(sdrc_state_r==sdrc_st39) ? 36'b0 :
			(sdrc_state_r==sdrc_st3a) ? 36'b0 :
			(sdrc_state_r==sdrc_st3b) ? 36'b0 :
			(sdrc_state_r==sdrc_st3c) ? 36'b0 :
			(sdrc_state_r==sdrc_st3d) ? 36'b0 :
			36'b0;

	assign sdrc_store_w=
			(sdrc_state_r==sdrc_st20) ? 1'b0 :
			(sdrc_state_r==sdrc_st21) ? 1'b0 :
			(sdrc_state_r==sdrc_st22) ? 1'b0 :
			(sdrc_state_r==sdrc_st23) ? 1'b0 :
			(sdrc_state_r==sdrc_st24) ? 1'b0 :
			(sdrc_state_r==sdrc_st25) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b00) ? 1'b1 :
			(sdrc_state_r==sdrc_st25) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b0 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st25) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st25) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st26) ? 1'b0 :
			(sdrc_state_r==sdrc_st27) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b01) ? 1'b1 :
			(sdrc_state_r==sdrc_st27) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b0 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st27) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st27) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st28) ? 1'b0 :
			(sdrc_state_r==sdrc_st29) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b10) ? 1'b1 :
			(sdrc_state_r==sdrc_st29) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b1 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st29) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st29) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st2a) ? 1'b0 :
			(sdrc_state_r==sdrc_st2b) & (sdrc_bl_r[1:0]==2'b00) & (sdrc_addr_r[3:2]==2'b11) ? 1'b1 :
			(sdrc_state_r==sdrc_st2b) & (sdrc_bl_r[1:0]==2'b01) & (sdrc_addr_r[3]  ==1'b1 ) ? 1'b1 :
			(sdrc_state_r==sdrc_st2b) & (sdrc_bl_r[1:0]==2'b10)                             ? 1'b0 :
			(sdrc_state_r==sdrc_st2b) & (sdrc_bl_r[1:0]==2'b11)                             ? 1'b1 :
			(sdrc_state_r==sdrc_st2c) ? 1'b0 :
			(sdrc_state_r==sdrc_st2d) ? 1'b0 :
			1'b0;

	assign sdrc_rdata_w[31:0]={sdr_rdata[15:0],sdrc_rdata_r[31:16]};

	//

	assign sdrc_req=mem_cmd_req;
	assign sdrc_bl[5:0]=mem_cmd_bl[5:0];
	assign sdrc_rd=mem_cmd_instr[0];
	assign sdrc_addr[31:0]={2'b0,mem_cmd_byte_addr[29:0]};
	assign mem_rd_data[31:0]=sdrc_rdata_r[31:0];
	assign sdrc_wdata[31:0]=mem_wr_data[31:0];
	assign sdrc_be[3:0]=~mem_wr_mask[3:0];
	assign mem_cmd_ack=sdrc_cmd_ack_r;
	assign mem_wr_ack=sdrc_load_r;//sdrc_wr_ack_r;
	assign mem_rd_req=sdrc_store_r;//sdrc_rd_ack_r;

	assign mem_wr_master[2:0]=mem_cmd_master_r[2:0];
	assign mem_rd_master[2:0]=mem_cmd_master_r[2:0];

/*
	input			mem_cmd_req,		// in    [MEM] cmd req
	input	[2:0]	mem_cmd_instr,		// in    [MEM] cmd inst[2:0]
	input	[5:0]	mem_cmd_bl,			// in    [MEM] cmd blen[5:0]
	input	[29:0]	mem_cmd_byte_addr,	// in    [MEM] cmd addr[29:0]
	input	[2:0]	mem_cmd_master,		// in    [MEM] cmd master[2:0]
	output			mem_cmd_ack,		// out   [MEM] cmd ack
	input	[3:0]	mem_wr_mask,		// in    [MEM] wr mask[3:0]
	input	[31:0]	mem_wr_data,		// in    [MEM] wr wdata[31:0]
	output			mem_wr_ack,			// out   [MEM] wr ack
	output	[2:0]	mem_wr_master,		// out   [MEM] wr master[2:0]
	output			mem_rd_req,			// out   [MEM] rd req
	output	[31:0]	mem_rd_data,		// out   [MEM] rd rdata[31:0]
	output	[2:0]	mem_rd_master,		// out   [MEM] rd master[2:0]
*/

endmodule

