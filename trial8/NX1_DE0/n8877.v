//------------------------------------------------------------------------------
//
//	n8877s.v : mb8877 fake module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/11 release 0.0  
//
//------------------------------------------------------------------------------


module n8877 #(
	parameter	def_wp=4'b1111,
	parameter	busfree=8'b00
) (
	output	[19:0]	faddr,			// out   [MEM] addr
	output			frd,			// out   [MEM] rd req
	input	[15:0]	frdata,			// in    [MEM] read data

	input	[2:0]	addr,
	input	[7:0]	wdata,
	output	[7:0]	rdata,
	input			wr,
//	input			req,
//	output			ack,

	input			cs,
	output			wait_n,

	input			rst_n,
	input			clk
);

	wire	req;
	wire	ack;

	reg		[3:0] req_r;
	reg		wait_n_r;
	wire	[3:0] req_w;
	wire	wait_n_w;

	assign wait_n=(cs==1'b1) ? wait_n_r : 1'b1;

	assign req=req_r[3];


	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n==1'b0)
			begin
				req_r[3:0] <= 4'b0;
				wait_n_r <= 1'b0;
			end
		else
			begin
				req_r[3:0] <= req_w[3:0];
				wait_n_r <= wait_n_w;
			end
	end

	assign req_w[0]=cs;
	assign req_w[1]=req_r[0];
	assign req_w[2]=(req_r[1:0]==2'b01) ? 1'b1 : 1'b0;
	assign req_w[3]=
			(req_r[1:0]==2'b01) ? 1'b1 :
			(req_r[1:0]!=2'b01) & (ack==1'b1) ? 1'b0 :
			(req_r[1:0]!=2'b01) & (ack==1'b0) ? req_r[3] :
			1'b0;

	assign wait_n_w=
			(req_r[0]==1'b0) ? 1'b0 :
			(req_r[1]==1'b1) & (ack==1'b1) ? 1'b1 :
			(req_r[1]==1'b1) & (ack==1'b0) ? wait_n_r :
			1'b0;

//	3'b000 : 8877 status / command
//	3'b001 : 8877 track
//	3'b010 : 8877 sector
//	3'b011 : 8877 data
//	3'b1xx : m-on,2'b0,h-side,2'b0,drvsel[1:0]

	wire	[7:0] status;
	wire	[7:0] command;
	wire	[7:0] track;
	wire	[7:0] sector;
	wire	head;
	wire	[1:0] drvsel;

	localparam	fdst00=4'b0000;
	localparam	fdst01=4'b0001;
	localparam	fdst02=4'b0011;
	localparam	fdst03=4'b0010;
	localparam	fdst04=4'b0100;
	localparam	fdst05=4'b0101;
	localparam	fdst06=4'b0111;
	localparam	fdst07=4'b0110;
	localparam	fdst10=4'b1000;
	localparam	fdst11=4'b1001;
	localparam	fdst12=4'b1011;
	localparam	fdst13=4'b1010;
	localparam	fdst14=4'b1100;
	localparam	fdst15=4'b1101;
	localparam	fdst16=4'b1111;
	localparam	fdst17=4'b1110;

	reg		[3:0] fdc_state_r;
	reg		ack_r;
	reg		[7:0] rdata_r;
	reg		fdc_busy_r;
	reg		[7:0] fdc_stat_r;
	reg		[7:0] fdc_cmd_r;
	reg		[7:0] fdc_track_r;
	reg		[7:0] fdc_sect_r;
	reg		[7:0] fdc_data_r;
	reg		fdc_head_r;
	reg		[1:0] fdc_drv_r;
	reg		[19:0] faddr_r;
	reg		[15:0] frdata_r;
	reg		frd_r;

	wire	[3:0] fdc_state_w;
	wire	ack_w;
	wire	[7:0] rdata_w;
	wire	fdc_busy_w;
	wire	[7:0] fdc_stat_w;
	wire	[7:0] fdc_cmd_w;
	wire	[7:0] fdc_track_w;
	wire	[7:0] fdc_sect_w;
	wire	[7:0] fdc_data_w;
	wire	fdc_head_w;
	wire	[1:0] fdc_drv_w;
	wire	[19:0] faddr_w;
	wire	[15:0] frdata_w;
	wire	frd_w;

	assign faddr[19:0]=faddr_r[19:0];
	assign frd=frd_r;

	assign rdata[7:0]=(cs==1) ?rdata_r[7:0] : busfree[7:0];
	assign ack=ack_r;

	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n==1'b0)
			begin
				fdc_state_r <= fdst00;
				ack_r <= 1'b0;
				rdata_r[7:0] <= busfree[7:0];
				fdc_busy_r <= 1'b0;
				fdc_stat_r[7:0] <= 8'b0;
				fdc_cmd_r[7:0] <= 8'b0;
				fdc_track_r[7:0] <= 8'b0;
				fdc_sect_r[7:0] <= 8'b0;
				fdc_data_r[7:0] <= 8'he5;
				fdc_head_r <= 1'b0;
				fdc_drv_r[1:0] <= 2'b0;
				faddr_r[19:0] <= 20'b0;
				frdata_r[15:0] <= 16'b0;
				frd_r <= 1'b0;
			end
		else
			begin
				fdc_state_r <= fdc_state_w;
				ack_r <= ack_w;
				rdata_r[7:0] <= rdata_w[7:0];
				fdc_busy_r <= fdc_busy_w;
				fdc_stat_r[7:0] <= fdc_stat_w[7:0];
				fdc_cmd_r[7:0] <= fdc_cmd_w[7:0];
				fdc_track_r[7:0] <= fdc_track_w[7:0];
				fdc_sect_r[7:0] <= fdc_sect_w[7:0];
				fdc_data_r[7:0] <= fdc_data_w[7:0];
				fdc_head_r <= fdc_head_w;
				fdc_drv_r[1:0] <= fdc_drv_w[1:0];
				faddr_r[19:0] <= faddr_w[19:0];
				frdata_r[15:0] <= frdata_w[15:0];
				frd_r <= frd_w;
			end
	end

	assign fdc_state_w=
			(fdc_state_r==fdst00) ? fdst01 :	// init
			(fdc_state_r==fdst01) ? fdst02 :
			(fdc_state_r==fdst02) ? fdst03 :
			(fdc_state_r==fdst03) ? fdst04 :
			(fdc_state_r==fdst04) ? fdst05 :
			(fdc_state_r==fdst05) ? fdst06 :
			(fdc_state_r==fdst06) ? fdst07 :
			(fdc_state_r==fdst07) ? fdst10 :	// done

			(fdc_state_r==fdst10) & (req==1'b0) ? fdst10 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) ? fdst11 :	// write cmd
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b001) ? fdst11 :	// write track
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b010) ? fdst11 :	// write sect
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b0) ? fdst11 :	// write data
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b1) ? fdst12 :	// write media
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2]==3'b1) ? fdst11 :	// write drvsel
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b000) ? fdst11 :	// read stat
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b001) ? fdst11 :	// read track
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b010) ? fdst11 :	// read sect
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b0) ? fdst11 :	// read data
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b1) ? fdst14 :	// read media
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2]==1'b1) ? fdst11 :	// set density
			(fdc_state_r==fdst11) ? fdst10 :

			(fdc_state_r==fdst12) ? fdst13 :
			(fdc_state_r==fdst13) ? fdst10 :

			(fdc_state_r==fdst14) ? fdst15 :
			(fdc_state_r==fdst15) ? fdst16 :
			(fdc_state_r==fdst16) ? fdst17 :
			(fdc_state_r==fdst17) ? fdst10 :
			fdst00;

	assign ack_w=
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b001) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b010) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b0) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b1) ? 1'b0 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2]==1'b1) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b000) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b001) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b010) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b0) ? 1'b1 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b1) ? 1'b0 :
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2]==1'b1) ? 1'b1 :
			(fdc_state_r==fdst12) ? 1'b1 :
			(fdc_state_r==fdst16) ? 1'b1 :
			1'b0;

	assign rdata_w[7:0]=
		//	(fdc_state_r==fdst10) & (req==1'b0) ? busfree[7:0] :
		//	(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b000) ? fdc_stat_r[7:0] :
		//	(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b001) ? fdc_track_r[7:0] :
		//	(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b010) ? fdc_sect_r[7:0] :
		//	(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b011) ? fdc_data_r[7:0] :
		//	(fdc_state_r==fdst10) & (req==1'b1) & (addr[2]==3'b1) ? busfree[7:0] :
		//	(fdc_state_r==fdst11) ? busfree[7:0] :
		//	(fdc_state_r==fdst12) ? rdata_r[7:0] :
		//	(fdc_state_r==fdst13) ? busfree[7:0] :

			(fdc_state_r==fdst10) & (req==1'b0) ? rdata_r[7:0] :
			(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b000) ? fdc_stat_r[7:0] :
			(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b001) ? fdc_track_r[7:0] :
			(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b010) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst10) & (req==1'b1) & (addr[2:0]==3'b011) ? fdc_data_r[7:0] :
			(fdc_state_r==fdst10) & (req==1'b1) & (addr[2]==3'b1) ? busfree[7:0] :
			(fdc_state_r==fdst11) ? rdata_r[7:0] :
			(fdc_state_r==fdst12) ? rdata_r[7:0] :
			(fdc_state_r==fdst13) ? rdata_r[7:0] :

			(fdc_state_r==fdst14) ? rdata_r[7:0] :
			(fdc_state_r==fdst15) ? rdata_r[7:0] :
			(fdc_state_r==fdst16) & (faddr_r[0]==1'b0) ? frdata_r[7:0] :
			(fdc_state_r==fdst16) & (faddr_r[0]==1'b1) ? frdata_r[15:8] :
			(fdc_state_r==fdst17) ? rdata_r[7:0] :
			busfree[7:0];


	wire	track00;
	wire	index;

	assign track00=(fdc_track_r[7:0]==8'b0) ? 1'b1 : 1'b0;
	assign index=1'b1;

	assign fdc_busy_w=
			(fdc_state_r==fdst10) & !((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) ? fdc_busy_r :
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7]==1'b0 ) ? 1'b0 :
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:5]==3'b100 ) ? 1'b1 :	// cmd2-8 : read data
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:5]==3'b101 ) ? 1'b1 :	// cmd2-a : write data
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:4]==4'b1100) ? 1'b1 :	// cmd2-c : read id
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:4]==4'b1110) ? 1'b1 :	// cmd2-e : read track
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:4]==4'b1111) ? 1'b1 :	// cmd2-f : write track
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000)) & (wdata[7:4]==4'b1101) ? 1'b0 :	// cmd2-d : interrupt
			(fdc_state_r==fdst11) ? fdc_busy_r :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_0) & (faddr_r[7:0]==8'hff) ? 1'b0 :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_0) & (faddr_r[7:0]!=8'hff) ? fdc_busy_r :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}!=3'b10_0) ? fdc_busy_r :
			(fdc_state_r==fdst13) ? fdc_busy_r :
			(fdc_state_r==fdst14) ? fdc_busy_r :
			(fdc_state_r==fdst15) ? fdc_busy_r :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_0) & (faddr_r[7:0]==8'hff) ? 1'b0 :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_0) & (faddr_r[7:0]!=8'hff) ? fdc_busy_r :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}!=3'b10_0) ? fdc_busy_r :
			(fdc_state_r==fdst17) ? fdc_busy_r :
			1'b0;

	assign fdc_stat_w[7:0]=
			(fdc_cmd_r[7:4]==4'b0000) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd1-0 : seek00
			(fdc_cmd_r[7:4]==4'b0001) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd1-1 : seek
			(fdc_cmd_r[7:5]==3'b001 ) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd1-2 : seek
			(fdc_cmd_r[7:5]==3'b010 ) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd1-4 : seek-1
			(fdc_cmd_r[7:5]==3'b011 ) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd1-6 : seek+1
			(fdc_cmd_r[7:5]==3'b100 ) ? {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,fdc_busy_r} :	// cmd2-8 : read data
			(fdc_cmd_r[7:5]==3'b101 ) ? {1'b0,def_wp[0],1'b1,1'b0,1'b0,1'b0,1'b1,fdc_busy_r} :	// cmd2-a : write data
			(fdc_cmd_r[7:4]==4'b1100) ? {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,fdc_busy_r} :	// cmd3-c : read id
			(fdc_cmd_r[7:4]==4'b1110) ? {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,fdc_busy_r} :	// cmd3-e : read track
			(fdc_cmd_r[7:4]==4'b1111) ? {1'b0,def_wp[0],1'b1,1'b0,1'b0,1'b0,1'b1,fdc_busy_r} :	// cmd3-f : write track
			(fdc_cmd_r[7:4]==4'b1101) ? {1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r} :	// cmd4-d : interrupt
			{1'b0,def_wp[0],fdc_cmd_r[4],1'b0,1'b0,track00,index,fdc_busy_r};

	assign fdc_cmd_w[7:0]=(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) ? wdata[7:0] : fdc_cmd_r[7:0];
	assign fdc_track_w[7:0]=
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) & (wdata[7:4]==4'b0000) ? 8'b0 :	// cmd1-0 : seek00
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) & (wdata[7:5]==3'b010 ) ? fdc_track_r[7:0]-8'b01 :	// cmd1-4 : seek-1
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) & (wdata[7:5]==3'b011 ) ? fdc_track_r[7:0]+8'b01 :	// cmd1-6 : seek+1
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b001) ? wdata[7:0] :
			fdc_track_r[7:0];

	assign fdc_sect_w[7:0]=
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b010)) ? wdata[7:0] :
			(fdc_state_r==fdst10) & !((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b010)) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst11) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_1) & (faddr_r[7:0]==8'hff) ? fdc_sect_r[7:0]+8'b01 :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_1) & (faddr_r[7:0]!=8'hff) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst12) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}!=3'b10_1) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst13) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst14) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst15) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_1) & (faddr_r[7:0]==8'hff) ? fdc_sect_r[7:0]+8'b01 :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}==3'b10_1) & (faddr_r[7:0]!=8'hff) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst16) & ({fdc_cmd_r[7:6],fdc_cmd_r[4]}!=3'b10_1) ? fdc_sect_r[7:0] :
			(fdc_state_r==fdst17) ? fdc_sect_r[7:0] :
			fdc_sect_r[7:0];

	assign fdc_data_w[7:0]=(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b011) ? wdata[7:0] : fdc_data_r[7:0];
	assign fdc_head_w=(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2]==1'b1) ? wdata[4] : fdc_head_r;
	assign fdc_drv_w[1:0]=(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b1) & (addr[2]==1'b1) ? wdata[1:0] : fdc_drv_r[1:0];

	assign faddr_w[11:8]=(fdc_state_r==fdst10) ? {fdc_sect_r[3:0]-4'b01} : faddr_r[11:8];
	assign faddr_w[12]=(fdc_state_r==fdst10) ? fdc_head_r : faddr_r[12];
	assign faddr_w[19:13]=(fdc_state_r==fdst10) ? fdc_track_r[6:0] : faddr_r[19:13];

	assign faddr_w[7:0]=
			(fdc_state_r==fdst10) & !((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) & (wdata[7]!=1'b1)) ? faddr_r[7:0] :	//
			(fdc_state_r==fdst10) &  ((req==1'b1) & (wr==1'b1) & (addr[2:0]==3'b000) & (wdata[7]==1'b1)) ? 8'b0 :	// cmd2,cmd3
			(fdc_state_r==fdst11) ? faddr_r[7:0] :
			(fdc_state_r==fdst12) ? faddr_r[7:0]+8'b01 :
			(fdc_state_r==fdst13) ? faddr_r[7:0] :
			(fdc_state_r==fdst14) ? faddr_r[7:0] :
			(fdc_state_r==fdst15) ? faddr_r[7:0] :
			(fdc_state_r==fdst16) ? faddr_r[7:0]+8'b01 :
			(fdc_state_r==fdst17) ? faddr_r[7:0] :
			faddr_r[7:0];

	assign frd_w=
			(fdc_state_r==fdst10) & (req==1'b1) & (wr==1'b0) & (addr[2:0]==3'b011) & (fdc_busy_r==1'b1) ? 1'b1 :
			(fdc_state_r==fdst14) ? 1'b1 :
			(fdc_state_r==fdst15) ? 1'b1 :
			(fdc_state_r==fdst16) ? 1'b0 :
			(fdc_state_r==fdst17) ? 1'b0 :
			1'b0;

	assign frdata_w[15:0]=frdata[15:0];

endmodule

