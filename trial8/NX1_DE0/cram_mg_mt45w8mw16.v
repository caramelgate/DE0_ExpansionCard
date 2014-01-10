//------------------------------------------------------------------------------
//  cram_mg_mt45w8mw16.v : cellularram mt45w8mw16 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2012/feb/13 release 0.0  connection test
//       feb/22 release 0.1  mig style interface
//       feb/24 release 0.1a -> cram_mg.v , cram_mg_mt45w8mw16.v
//
//------------------------------------------------------------------------------

module cram_mg_mt45w8mw16 #(
	parameter	DEVICE=4'h0,		// device : 0=xilinx / 1=altera / 2= / 3= 
	parameter	count150us=20000	// 133MHz 150us=20000clk
) (
	output			mt_oe_n,			// out   [MEM] #mem_oe (P30-OE)
	output			mt_wr_n,			// out   [MEM] #mem_wr (P30-WE)
	output			mt_adv_n,			// out   [MEM] #mem_adv (P30-ADV)
	input			mt_wait_n,			// in    [MEM] #mem_wait/ready (P30-WAIT)
	output			mt_clk,				// out   [MEM] mem_clk (P30-CLK)
	output			ram_cs_n,			// out   [MEM] #ram_cs (MT-CE)
	output			ram_cre,			// out   [MEM] ram_cre (MT-CRE)
	output			ram_ub_n,			// out   [MEM] #ram_ub (MT-UB)
	output			ram_lb_n,			// out   [MEM] #ram_lb (MT-LB )
	output	[26:1]	mt_addr,			// out   [MEM] mem_addr[26:1] (P30-A0..A25)
	output			flash_cs_n,			// out   [MEM] #falsh_cs (P30-CE)
	output			flash_rst_n,		// out   [MEM] #flash_rst (P30-RST)
	input	[15:0]	mt_rdata,			// in    [MEM] mem_data[15:0] in (P30-DQ0..DQ15)
	output	[15:0]	mt_wdata,			// out   [MEM] mem_data[15:0] out (P30-DQ0..DQ15)
	output			mt_wdata_oe,		// out   [MEM] mem_data_oe

	output			quad_spi_cs_n,		// out   [MEM] #spi_cs (CS)
	output			quad_spi_sck,		// out   [MEM] spi_sck (SCK)
	input			quad_spi_d_in,		// in    [MEM] spi_d in (SDI)
	output			quad_spi_d_out,		// out   [MEM] spi_d out (SDI)
	output			quad_spi_d_oe,		// out   [MEM] spi_d oe (SDI)
//	inout	[2:0]	quad_spi_dq,		// inout [MEM] spi_dq (P30-DQ0..DQ2)

	output			init_done,			// out   [MEM] #init/done
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

	input			mem_rst_n,			// in    [MEM] #rst
	input			mem_clk				// in    [MEM] clk
);


	assign flash_cs_n=1'b1;
	assign flash_rst_n=mem_rst_n;

	assign quad_spi_cs_n=1'b1;
	assign quad_spi_sck=1'b1;
	assign quad_spi_d_out=1'b0;
	assign quad_spi_d_oe=1'b0;

	// initiallize

	wire	done150us_w;
	wire	[15:0] count150us_w;
	reg		done150us_r;
	reg		[15:0] count150us_r;

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				done150us_r <= 1'b0;
				count150us_r[15:0] <= 16'b0;
			end
		else
			begin
				done150us_r <= done150us_w;
				count150us_r[15:0] <= count150us_w[15:0];
			end
	end

	assign done150us_w=(count150us_r[15:0]==count150us) ? 1'b1 : done150us_r;
	assign count150us_w[15:0]=(done150us_r==1'b1) ? 16'h0 : count150us_r[15:0]+16'h01;

	// 

	localparam	mst00=4'b0000;	// reset
	localparam	mst01=4'b0001;
	localparam	mst02=4'b0011;
	localparam	mst03=4'b0010;
	localparam	mst04=4'b0100;
	localparam	mst05=4'b0101;
	localparam	mst06=4'b0111;
	localparam	mst07=4'b0110;
	localparam	mst10=4'b1000;	// normal
	localparam	mst11=4'b1001;
	localparam	mst12=4'b1011;
	localparam	mst13=4'b1010;
	localparam	mst14=4'b1100;
	localparam	mst15=4'b1101;
	localparam	mst16=4'b1111;
	localparam	mst17=4'b1110;

	parameter BCR=
			{
			6'b0,	// [25:20] reserved
			2'b10,	// [19:18] select BCR
			2'b00,	// [17:16] reserved
			1'b0,	// [15] operaion mode : syncronous
			1'b0,	// [14] initial access latency : variable
			3'b011,	// [13:11] latency counter : code 3
			1'b0,	// [10] wait polality : active low
			1'b0,	// [9] reserved
			1'b1,	// [8] wait configuration : asserted one data cycle befrore delay
			1'b0,	// [7] reserved
			1'b0,	// [6] reserved
			2'b01,	// [5:4] drive strength : 1/2
			1'b0,	// [3] burst wrap : no wrap
			3'b111	// [2:0] burst length : countinuous burst
			};

	parameter RCR=
			{
			6'b0,	// [25:20] reserved
			1'b0,	// [19] select RCR
			11'b0,	// [18:8] reserved
			1'b0,	// [7] page mode : disable
			2'b00,	// [6:5] reserved
			1'b1,	// [4] deep power-down : disable
			1'b0,	// [3] reserved
			3'b00	// [2:0] refresh coverage : full array
			};

	wire	mem_cmd_en;

	reg		mem_cmd_ack_r;
	wire	mem_cmd_ack_w;

	reg		mem_init_r;
	reg		[3:0] mem_state_r;
	reg		[6:0] data_count_r;

	wire	mem_init_w;
	wire	[3:0] mem_state_w;
	wire	[6:0] data_count_w;

	reg		[2:0] mem_master_r;
	reg		[26:1] mem_addr_r;
	reg		[1:0] mem_be_n_r;
	reg		[31:0] mem_wdata_r;
	reg		[31:0] mem_rdata_r;
	reg		mem_wdata_req_r;
	reg		mem_rdata_req_r;
	reg		mem_write_r;
	reg		mem_we_n_r;
	reg		mem_oe_n_r;
	reg		mem_cre_r;
	reg		mem_adv_n_r;
	reg		psram_ce_n_r;
	reg		flash_ce_n_r;

	wire	[2:0] mem_master_w;
	wire	[26:1] mem_addr_w;
	wire	[1:0] mem_be_n_w;
	wire	[31:0] mem_wdata_w;
	wire	[31:0] mem_rdata_w;
	wire	mem_wdata_req_w;
	wire	mem_rdata_req_w;
	wire	mem_write_w;
	wire	mem_we_n_w;
	wire	mem_oe_n_w;
	wire	mem_cre_w;
	wire	mem_adv_n_w;
	wire	psram_ce_n_w;
	wire	flash_ce_n_w;

	reg		[3:0] mem_init_count_r;
	reg		mem_init_wait_r;
	reg		mem_init_cre_r;
	reg		mem_init_adv_r;
	reg		mem_init_ce_r;
	reg		mem_init_we_r;
	wire	[3:0] mem_init_count_w;
	wire	mem_init_wait_w;
	wire	mem_init_cre_w;
	wire	mem_init_adv_w;
	wire	mem_init_ce_w;
	wire	mem_init_we_w;

	reg		[15:0] mem_rdata_in_r;
	reg		mem_wait_in_r;
	wire	[15:0] mem_rdata_in_w;
	wire	mem_wait_in_w;

	assign init_done=mem_init_r;

	assign mt_oe_n=mem_oe_n_r;
	assign mt_wr_n=mem_we_n_r;
	assign mt_adv_n=mem_adv_n_r;

generate
	if (DEVICE==4'h0)

FDDRRSE DDR_mt_clk(.Q(mt_clk),.C0(mem_clk),.C1(~mem_clk),.CE(1'b1),.D0(1'b0),.D1(mem_init_r),.R(1'b0),.S(1'b0));

else

	assign mt_clk=(mem_init_r==1'b0) ? 1'b0 : !mem_clk;

endgenerate

	assign ram_cs_n=psram_ce_n_r;
	assign ram_cre=mem_cre_r;
	assign ram_ub_n=mem_be_n_r[1];
	assign ram_lb_n=mem_be_n_r[0];
	assign mt_addr[26:1]=mem_addr_r[26:1];
	assign mt_wdata[15:0]=mem_wdata_r[15:0];
	assign mt_wdata_oe=mem_write_r;

	assign mem_cmd_ack=mem_cmd_ack_r;
	assign mem_wr_ack=mem_wdata_req_r;
	assign mem_wr_master[2:0]=mem_master_r[2:0];
	assign mem_rd_req=mem_rdata_req_r;
	assign mem_rd_data[31:0]=mem_rdata_r[31:0];
	assign mem_rd_master[2:0]=mem_master_r[2:0];

	assign mem_cmd_en=mem_cmd_req;

	always @(negedge mem_clk)
	begin
		mem_rdata_in_r[15:0] <= mem_rdata_in_w[15:0];
		mem_wait_in_r <= mem_wait_in_w;
	end

	assign mem_rdata_in_w[15:0]=mt_rdata[15:0];
	assign mem_wait_in_w=(mt_wait_n===1'b1) ? 1'b1 : 1'b0;

	always @(posedge mem_clk or negedge mem_rst_n)
	begin
		if (mem_rst_n==1'b0)
			begin
				mem_init_r <= 1'b0;
				mem_state_r <= mst00;
				mem_cmd_ack_r <= 1'b0;
				data_count_r[6:0] <= 7'b0;
				mem_master_r[2:0] <= 3'b0;
				mem_addr_r[26:1] <= 26'b0;
				mem_be_n_r[1:0] <= 2'b11;
				mem_wdata_r[31:0] <= 32'b0;
				mem_rdata_r[31:0] <= 32'b0;
				mem_wdata_req_r <= 1'b0;
				mem_rdata_req_r <= 1'b0;
				mem_write_r <= 1'b0;
				mem_we_n_r <= 1'b1;
				mem_oe_n_r <= 1'b1;
				mem_cre_r <= 1'b0;
				mem_adv_n_r <= 1'b1;
				psram_ce_n_r <= 1'b1;
				flash_ce_n_r <= 1'b1;
				mem_init_count_r[3:0] <= 4'b0;
				mem_init_wait_r <= 1'b0;
				mem_init_cre_r <= 1'b0;
				mem_init_adv_r <= 1'b0;
				mem_init_ce_r <= 1'b0;
				mem_init_we_r <= 1'b0;
			end
		else
			begin
				mem_init_r <= mem_init_w;
				mem_state_r <= mem_state_w;
				mem_cmd_ack_r <= mem_cmd_ack_w;
				data_count_r[6:0] <= data_count_w[6:0];
				mem_master_r[2:0] <= mem_master_w[2:0];
				mem_addr_r[26:1] <= mem_addr_w[26:1];
				mem_be_n_r[1:0] <= mem_be_n_w[1:0];
				mem_wdata_r[31:0] <= mem_wdata_w[31:0];
				mem_rdata_r[31:0] <= mem_rdata_w[31:0];
				mem_wdata_req_r <= mem_wdata_req_w;
				mem_rdata_req_r <= mem_rdata_req_w;
				mem_write_r <= mem_write_w;
				mem_we_n_r <= mem_we_n_w;
				mem_oe_n_r <= mem_oe_n_w;
				mem_cre_r <= mem_cre_w;
				mem_adv_n_r <= mem_adv_n_w;
				psram_ce_n_r <= psram_ce_n_w;
				flash_ce_n_r <= flash_ce_n_w;
				mem_init_count_r[3:0] <= mem_init_count_w[3:0];
				mem_init_wait_r <= mem_init_wait_w;
				mem_init_cre_r <= mem_init_cre_w;
				mem_init_adv_r <= mem_init_adv_w;
				mem_init_ce_r <= mem_init_ce_w;
				mem_init_we_r <= mem_init_we_w;
			end
	end

	assign mem_init_w=(mem_state_r==mst10) ? 1'b1 : mem_init_r;

	assign mem_init_count_w[3:0]=
			(mem_state_r==mst00) ? 4'b0 :
			(mem_state_r==mst01) ? mem_init_count_r[3:0]+4'b01 :
			(mem_state_r==mst02) ? 4'b0 :
			(mem_state_r==mst03) ? mem_init_count_r[3:0]+4'b01 :
			4'b0;

	assign mem_init_wait_w=(mem_init_count_r[3:0]==4'b1110) ? 1'b0 : 1'b1;

	assign {mem_init_cre_w,mem_init_adv_w,mem_init_ce_w,mem_init_we_w}=
			(mem_init_count_r[3:0]==4'h0) ? 4'b0111 :
			(mem_init_count_r[3:0]==4'h1) ? 4'b1111 :
			(mem_init_count_r[3:0]==4'h2) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h3) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h4) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h5) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h6) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h7) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h8) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'h9) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'ha) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'hb) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'hc) ? 4'b1000 :
			(mem_init_count_r[3:0]==4'hd) ? 4'b1111 :
			(mem_init_count_r[3:0]==4'he) ? 4'b0111 :
			(mem_init_count_r[3:0]==4'hf) ? 4'b0111 :
			4'b0111;

	assign mem_state_w=
			(mem_state_r==mst00) & (done150us_r==1'b0) ? mst00 :		// wait power on reset
			(mem_state_r==mst00) & (done150us_r==1'b1) ? mst01 :		// 150us done
			(mem_state_r==mst01) & (mem_init_wait_r==1'b0) ? mst02 :
			(mem_state_r==mst01) & (mem_init_wait_r==1'b1) ? mst01 :	// RCR
			(mem_state_r==mst02) ? mst03 :
			(mem_state_r==mst03) & (mem_init_wait_r==1'b0) ? mst10 :
			(mem_state_r==mst03) & (mem_init_wait_r==1'b1) ? mst03 :	// BCR
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? mst10 :			// wait
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? mst11 :			// request
			(mem_state_r==mst11) & ({mem_adv_n_r,mem_wait_in_r}==2'b11) ? mst12 :
			(mem_state_r==mst11) & ({mem_adv_n_r,mem_wait_in_r}!=2'b11) ? mst11 :
			(mem_state_r==mst12) & (data_count_r[6:0]==7'h00) ? mst13 :
			(mem_state_r==mst12) & (data_count_r[6:0]!=7'h00) ? mst12 :
			(mem_state_r==mst13) ? mst10 :
			(mem_state_r==mst14) ? mst10 :
			(mem_state_r==mst15) ? mst10 :
			(mem_state_r==mst16) ? mst10 :
			(mem_state_r==mst17) ? mst10 :
			mst00;

//	assign mem_cmd_ack_w=(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? !mem_cmd_ack_r : mem_cmd_ack_r;
	assign mem_cmd_ack_w=(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? 1'b1 : 1'b0;

	assign data_count_w[6:0]=
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? {mem_cmd_bl[5:0],1'b0} :
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? data_count_r[6:0] :
			(mem_state_r==mst11) ? data_count_r[6:0] :
			(mem_state_r==mst12) ? data_count_r[6:0]-7'h01 :
			(mem_state_r==mst13) ? data_count_r[6:0] :
			7'b0;

	assign mem_master_w[2:0]=
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? mem_cmd_master[2:0] :
			mem_master_r[2:0];

	assign mem_addr_w[26:1]=
			(mem_state_r==mst00) ? RCR[25:0] :
			(mem_state_r==mst01) ? RCR[25:0] :
			(mem_state_r==mst02) ? BCR[25:0] :
			(mem_state_r==mst03) ? BCR[25:0] :
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? {mem_cmd_byte_addr[26:2],1'b0} :
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? mem_addr_r[26:1] :
			mem_addr_r[26:1];

	assign mem_be_n_w[1:0]=
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? 2'b11 :
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) & (mem_cmd_instr[0]==1'b1) ? 2'b00 :	// read
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) & (mem_cmd_instr[0]==1'b0) ? 2'b11 :
			(mem_state_r==mst11) & (mem_write_r==1'b0) ? 2'b00 :
			(mem_state_r==mst11) & (mem_write_r==1'b1) ? mem_wr_mask[1:0] :
			(mem_state_r==mst12) & (mem_write_r==1'b0) ? 2'b00 :
			(mem_state_r==mst12) & (mem_write_r==1'b1) & (data_count_r[0]==1'b0) ? mem_wr_mask[3:2] :
			(mem_state_r==mst12) & (mem_write_r==1'b1) & (data_count_r[0]==1'b1) ? mem_wr_mask[1:0] :
			(mem_state_r==mst13) ? 2'b11 :
			2'b11;

	assign mem_wdata_w[31:0]=
			(mem_state_r==mst10) ? mem_wr_data[31:0] :
			(mem_state_r==mst11) ? mem_wr_data[31:0] :
			(mem_state_r==mst12) & (data_count_r[0]==1'b0) ? {16'h0,mem_wr_data[31:16]} :
			(mem_state_r==mst12) & (data_count_r[0]==1'h1) ? mem_wr_data[31:0] :
			(mem_state_r==mst13) ? mem_wr_data[31:0] :
			32'b0;

	assign mem_rdata_w[31:0]=
			(mem_state_r==mst12) & (data_count_r[0]==1'b0) ? {mem_rdata_r[31:16],mem_rdata_in_r[15:0]} :
			(mem_state_r==mst12) & (data_count_r[0]==1'b1) ? {mem_rdata_in_r[15:0],mem_rdata_r[15:0]} :
			(mem_state_r==mst13) ? {mem_rdata_in_r[15:0],mem_rdata_r[15:0]} :
			32'b0;

	assign mem_wdata_req_w=
			(mem_state_r==mst11) & (mem_write_r==1'b1) & ({mem_adv_n_r,mem_wait_in_r}==2'b11) ? 1'b1 :
			(mem_state_r==mst12) & (mem_write_r==1'b1) & (data_count_r[0]==1'b1) ? 1'b1 :
			1'b0;
	assign mem_rdata_req_w=
			(mem_state_r==mst12) & (mem_write_r==1'b0) & (data_count_r[0]==1'b1) ? 1'b1 :
			(mem_state_r==mst13) & (mem_write_r==1'b0) ? 1'b1 :
			1'b0;

	assign mem_write_w=
			(mem_state_r==mst10) & ({mem_cmd_en,mem_cmd_instr[0]}==2'b10) ? 1'b1 :	// write
			(mem_state_r==mst10) & ({mem_cmd_en,mem_cmd_instr[0]}!=2'b10) ? 1'b0 :
			mem_write_r;

	assign mem_we_n_w=
			(mem_state_r==mst00) ? 1'b1 :
			(mem_state_r==mst01) ? mem_init_we_r :
			(mem_state_r==mst02) ? 1'b1 :
			(mem_state_r==mst03) ? mem_init_we_r :
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) & (mem_cmd_instr[0]==1'b0) ? 1'b0 :	// write
			1'b1;
	assign mem_oe_n_w=
			(mem_state_r==mst10) ? 1'b1 :
			(mem_state_r==mst11) & (mem_write_r==1'b0) ? 1'b0 : 
			(mem_state_r==mst11) & (mem_write_r==1'b1) ? 1'b1 : 
			(mem_state_r==mst12) & (data_count_r[6:0]==7'h00) ? mem_oe_n_r :
			(mem_state_r==mst12) & (data_count_r[6:0]!=7'h00) ? mem_oe_n_r :
			(mem_state_r==mst13) ? 1'b1 :
			1'b1;
	assign mem_adv_n_w=
			(mem_state_r==mst00) ? 1'b1 :
			(mem_state_r==mst01) ? mem_init_adv_r :
			(mem_state_r==mst02) ? 1'b1 :
			(mem_state_r==mst03) ? mem_init_adv_r :
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? 1'b0 :
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? 1'b1 :
			1'b1;
	assign mem_cre_w=
			(mem_state_r==mst00) ? 1'b0 :
			(mem_state_r==mst01) ? mem_init_cre_r :
			(mem_state_r==mst02) ? 1'b0 :
			(mem_state_r==mst03) ? mem_init_cre_r :
			1'b0;
	assign psram_ce_n_w=
			(mem_state_r==mst00) ? 1'b1 :
			(mem_state_r==mst01) ? mem_init_ce_r :
			(mem_state_r==mst02) ? 1'b1 :
			(mem_state_r==mst03) ? mem_init_ce_r :
			(mem_state_r==mst10) & (mem_cmd_en==1'b1) ? 1'b0 :
			(mem_state_r==mst10) & (mem_cmd_en==1'b0) ? 1'b1 :
			(mem_state_r==mst11) ? 1'b0 :
			(mem_state_r==mst12) & (data_count_r[6:0]==7'h00) ? 1'b0 :
			(mem_state_r==mst12) & (data_count_r[6:0]!=7'h00) ? 1'b0 :
			(mem_state_r==mst13) ? 1'b1 :
			(mem_state_r==mst14) ? 1'b1 :
			(mem_state_r==mst15) ? 1'b1 :
			(mem_state_r==mst16) ? 1'b1 :
			(mem_state_r==mst17) ? 1'b1 :
			1'b1;
	assign flash_ce_n_w=1'b1;

endmodule
