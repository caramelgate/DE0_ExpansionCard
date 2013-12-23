//-----------------------------------------------------------------------------
//
//  mg_sdr.v : sdr-sdram module
//
//  LICENSE : "as-is"
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/feb/04 release 0.0  connection test
//       mar/27 release 0.1  interface change
//
//------------------------------------------------------------------------------
//
//  clk=54MHz , cl=2 , data=16bit , burst=2
//
//
//------------------------------------------------------------------------------

module mg_sdr #(
	parameter	DEVICE=1,		// 0=xilinx , 1=altera
	parameter	SIM_FAST=0		// 
) (
	output	[12:0]	sdr_addr,		// out   [SDR] addr[12:0]
	output	[1:0]	sdr_ba,			// out   [SDR] bank[1:0]
	output			sdr_cas_n,		// out   [SDR] #cas
	output			sdr_cke,		// out   [SDR] cke
	output			sdr_clk,		// out   [SDR] clk
	output			sdr_cs_n,		// out   [SDR] #cs
	output	[15:0]	sdr_wdata,		// out   [SDR] write data[15:0]
	input	[15:0]	sdr_rdata,		// in    [SDR] read data[15:0]
	output			sdr_oe,			// out   [SDR] data oe
	output	[1:0]	sdr_dqm,		// out   [SDR] dqm[1:0]
	output			sdr_ras_n,		// out   [SDR] #ras
	output			sdr_we_n,		// out   [SDR] #we

	input			mem_cmd_req,	// in    [MEM] cmd req
	input			mem_cmd_rd,		// in    [MEM] cmd rd/#wr
	input	[31:0]	mem_cmd_addr,	// in    [MEM] cmd addr[31:0]
	output			mem_cmd_ack,	// out   [MEM] cmd ack
	input	[3:0]	mem_wr_mask,	// in    [MEM] wr mask[3:0]
	input	[31:0]	mem_wr_data,	// in    [MEM] wr wdata[31:0]
	output			mem_wr_ack,		// out   [MEM] wr ack
	output	[31:0]	mem_rd_data,	// out   [MEM] rd rdata[31:0]
	output			mem_rd_ack,		// out   [MEM] rd ack

	output			mem_init_done,	// out   [SYS] init_done
	input			mem_t0,			// in    [SYS] state T0
	input			mem_clk,		// in    [SYS] clk 54MHz
	input			mem_rst_n		// in    [SYS] #reset
);

/*

clk       T0    T1    T2    T3    T4    T5    T6    T0    T1
   __    __    __    __    __    __    __    __    __    __    __    __ 
__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \
          _____                                     _____ 
abt      X_REQ_X                                   X_REQ_X
                                              _____
ack                                         _/ ACK \_
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

ODDR oddr_sdrclk(.Q(sdr_clk),.C(mem_clk),.CE(1'b1),.D1(1'b0),.D2(1'b1),.R(1'b0),.S(1'b0));

end
endgenerate

generate
	if (DEVICE==1)
begin

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

end
endgenerate

generate
	if ((DEVICE!=0) & (DEVICE!=1))

	assign sdr_clk=!mem_clk;

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

	reg		sdrc_init_done_r;
	reg		sdrc_ref_req_r;
	reg		[11:0] sdrc_count_r;
	reg		[5:0] sdrc_state_r;
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

	wire	sdrc_init_done_w;
	wire	sdrc_ref_req_w;
	wire	[11:0] sdrc_count_w;
	wire	[5:0] sdrc_state_w;
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
	localparam	sdrc_st21=11;
	localparam	sdrc_st22=12;
	localparam	sdrc_st23=13;
	localparam	sdrc_st24=14;
	localparam	sdrc_st25=15;
	localparam	sdrc_st26=16;
	localparam	sdrc_st31=17;
	localparam	sdrc_st32=18;
	localparam	sdrc_st33=19;
	localparam	sdrc_st34=20;
	localparam	sdrc_st35=21;
	localparam	sdrc_st36=22;

	assign sdr_addr[12:0]={1'b0,sdrc_addr_out_r[11:0]};
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

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				sdrc_init_done_r <= 1'b0;
				sdrc_ref_req_r <= 1'b0;
				sdrc_count_r[11:0] <= 12'b0;
				sdrc_state_r <= sdrc_st00;
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
			end
		else
			begin
				sdrc_init_done_r <= sdrc_init_done_w;
				sdrc_ref_req_r <= sdrc_ref_req_w;
				sdrc_count_r[11:0] <= sdrc_count_w[11:0];
				sdrc_state_r <= sdrc_state_w;
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
			end
	end

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

			(sdrc_state_r==sdrc_st21) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st22) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st23) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st24) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st25) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st26) ? sdrc_count_r[11:0] :

			(sdrc_state_r==sdrc_st31) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st32) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st33) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st34) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st35) ? sdrc_count_r[11:0] :
			(sdrc_state_r==sdrc_st36) ? sdrc_count_r[11:0] :
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
			(sdrc_state_r==sdrc_st11) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st12) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st13) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st14) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st15) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st16) ? sdrc_ref_req_r :

			(sdrc_state_r==sdrc_st21) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st22) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st23) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st24) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st25) ? sdrc_ref_req_r :
			(sdrc_state_r==sdrc_st26) ? sdrc_ref_req_r :

			(sdrc_state_r==sdrc_st31) ? 1'b0 :
			(sdrc_state_r==sdrc_st32) ? 1'b0 :
			(sdrc_state_r==sdrc_st33) ? 1'b0 :
			(sdrc_state_r==sdrc_st34) ? 1'b0 :
			(sdrc_state_r==sdrc_st35) ? 1'b0 :
			(sdrc_state_r==sdrc_st36) ? 1'b0 :
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
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b0) & (sdrc_ref_req_r==1'b1) ? sdrc_st31 :	// refresh
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? sdrc_st21 :	// read
		//	(sdrc_state_r==sdrc_st10) & (mem_t0==1'b1) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? sdrc_st11 :	// write

			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b1) ? sdrc_st31 :	// refresh
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b0) ? sdrc_st10 :	// wait
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? sdrc_st21 :	// read
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? sdrc_st11 :	// write

			(sdrc_state_r==sdrc_st11) ? sdrc_st12 :
			(sdrc_state_r==sdrc_st12) ? sdrc_st13 :
			(sdrc_state_r==sdrc_st13) ? sdrc_st14 :
			(sdrc_state_r==sdrc_st14) ? sdrc_st15 :
			(sdrc_state_r==sdrc_st15) ? sdrc_st16 :
			(sdrc_state_r==sdrc_st16) ? sdrc_st10 :

			(sdrc_state_r==sdrc_st21) ? sdrc_st22 :
			(sdrc_state_r==sdrc_st22) ? sdrc_st23 :
			(sdrc_state_r==sdrc_st23) ? sdrc_st24 :
			(sdrc_state_r==sdrc_st24) ? sdrc_st25 :
			(sdrc_state_r==sdrc_st25) ? sdrc_st26 :
			(sdrc_state_r==sdrc_st26) ? sdrc_st10 :

			(sdrc_state_r==sdrc_st31) ? sdrc_st32 :
			(sdrc_state_r==sdrc_st32) ? sdrc_st33 :
			(sdrc_state_r==sdrc_st33) ? sdrc_st34 :
			(sdrc_state_r==sdrc_st34) ? sdrc_st35 :
			(sdrc_state_r==sdrc_st35) ? sdrc_st36 :
			(sdrc_state_r==sdrc_st36) ? sdrc_st10 :
			sdrc_st00;

	assign sdrc_ack_w=
			(sdrc_state_r==sdrc_st15) ? 1'b1 :
			(sdrc_state_r==sdrc_st25) ? 1'b1 :
			1'b0;

	assign sdrc_cmd_ack_w=
			(sdrc_state_r==sdrc_st11) ? 1'b1 :
			(sdrc_state_r==sdrc_st21) ? 1'b1 :
			1'b0;
	assign sdrc_rd_ack_w=(sdrc_state_r==sdrc_st25) ? 1'b1 : 1'b0;
	assign sdrc_wr_ack_w=(sdrc_state_r==sdrc_st15) ? 1'b1 : 1'b0;

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
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b1) ? 4'b0011 :	// read
			(sdrc_state_r==sdrc_st10) & (sdrc_ref_req_r==1'b0) & (sdrc_req==1'b1) & (sdrc_rd==1'b0) ? 4'b0011 :	// write

			(sdrc_state_r==sdrc_st11) ? 4'b1111 :
			(sdrc_state_r==sdrc_st12) ? 4'b0100 :
			(sdrc_state_r==sdrc_st13) ? 4'b1111 :
			(sdrc_state_r==sdrc_st14) ? 4'b1111 :
			(sdrc_state_r==sdrc_st15) ? 4'b1111 :
			(sdrc_state_r==sdrc_st16) ? 4'b1111 :

			(sdrc_state_r==sdrc_st21) ? 4'b1111 :
			(sdrc_state_r==sdrc_st22) ? 4'b0101 :
			(sdrc_state_r==sdrc_st23) ? 4'b1111 :
			(sdrc_state_r==sdrc_st24) ? 4'b1111 :
			(sdrc_state_r==sdrc_st25) ? 4'b1111 :
			(sdrc_state_r==sdrc_st26) ? 4'b1111 :

			(sdrc_state_r==sdrc_st31) ? 4'b1111 :
			(sdrc_state_r==sdrc_st32) ? 4'b1111 :
			(sdrc_state_r==sdrc_st33) ? 4'b1111 :
			(sdrc_state_r==sdrc_st34) ? 4'b1111 :
			(sdrc_state_r==sdrc_st35) ? 4'b1111 :
			(sdrc_state_r==sdrc_st36) ? 4'b1111 :
			4'b1111;

	wire	[13:0] sdrc_addr_mode;
	wire	[13:0] sdrc_addr_ras;
	wire	[13:0] sdrc_addr_cas;

	assign sdrc_addr_mode[13:0]=14'h0021;	//  cl=2, burst=2
	assign sdrc_addr_ras[13:0]={sdrc_addr[22:21],sdrc_addr[20:9]};
	assign sdrc_addr_cas[13:0]={sdrc_addr_out_r[13:12],4'b0100,sdrc_addr_r[8:2],1'b0};	// auto precharge

	assign {sdrc_addr_out_w[13:0],sdrc_oe_w,sdrc_be_out_w[1:0],sdrc_wdata_out_w[15:0]}=
			(sdrc_state_r==sdrc_st00) ? {14'h0fff,1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st01) ? {14'h0fff,1'b0,2'b0,16'b0} :				// precharge all
			(sdrc_state_r==sdrc_st02) ? {14'h0fff,1'b0,2'b0,16'b0} :				// refresh
			(sdrc_state_r==sdrc_st03) ? {sdrc_addr_mode[13:0],1'b0,2'b0,16'b0} :	// mode set

			(sdrc_state_r==sdrc_st10) ? {sdrc_addr_ras[13:0],1'b0,2'b0,16'b0} :	// ras
			(sdrc_state_r==sdrc_st11) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st12) ? {sdrc_addr_cas[13:0],1'b1,sdrc_be_r[1:0],sdrc_wdata_r[15:0]} :	// wr auto precharge
			(sdrc_state_r==sdrc_st13) ? {sdrc_addr_out_r[13:0],1'b1,sdrc_be_r[3:2],sdrc_wdata_r[31:16]} :
			(sdrc_state_r==sdrc_st14) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st15) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st16) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			(sdrc_state_r==sdrc_st21) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st22) ? {sdrc_addr_cas[13:0],1'b0,2'b11,16'b0} :	// rd auto precharge
			(sdrc_state_r==sdrc_st23) ? {sdrc_addr_out_r[13:0],1'b0,2'b11,16'b0} :
			(sdrc_state_r==sdrc_st24) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st25) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st26) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			(sdrc_state_r==sdrc_st31) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st32) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st33) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st34) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st35) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :
			(sdrc_state_r==sdrc_st36) ? {sdrc_addr_out_r[13:0],1'b0,2'b0,16'b0} :

			{14'b0,1'b0,2'b0,16'b0};

	assign sdrc_addr_w[31:0]=(sdrc_state_r==sdrc_st10) ? sdrc_addr[31:0] : sdrc_addr_r[31:0];
	assign sdrc_wdata_w[31:0]=(sdrc_state_r==sdrc_st10) ? sdrc_wdata[31:0] : sdrc_wdata_r[31:0];
	assign sdrc_rdata_w[31:0]={sdr_rdata[15:0],sdrc_rdata_r[31:16]};
	assign sdrc_be_w[3:0]=(sdrc_state_r==sdrc_st10) ? sdrc_be[3:0] : sdrc_be_r[3:0];

	//

	assign sdrc_req=mem_cmd_req;
	assign sdrc_rd=mem_cmd_rd;
	assign sdrc_addr[31:0]=mem_cmd_addr[31:0];
	assign mem_rd_data[31:0]=sdrc_rdata_r[31:0];
	assign sdrc_wdata[31:0]=mem_wr_data[31:0];
	assign sdrc_be[3:0]=~mem_wr_mask[3:0];
	assign mem_cmd_ack=sdrc_cmd_ack_r;
	assign mem_wr_ack=sdrc_wr_ack_r;
	assign mem_rd_ack=sdrc_rd_ack_r;

endmodule

