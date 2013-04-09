//------------------------------------------------------------------------------
//
//  dispgen_vga.v : display colorbar module
//
//------------------------------------------------------------------------------

module dispgen_vga(
	D_RED,						// out   [CRT] [7:0] red
	D_GRN,						// out   [CRT] [7:0] green
	D_BLU,						// out   [CRT] [7:0] blue
	D_HSYNC_N,					// out   [CRT] #hsync
	D_VSYNC_N,					// out   [CRT] #vsync
	D_BLANK_N,					// out   [CRT] #blank

	D_HCOUNT,
	D_VCOUNT,

	D_MODE,						// in    [] [3:0] sim/#normal

	D_RST_N,					// in    [] : #reset
	D_CLK						// in    [CRT] dot clock
);

//--------------------------------------------------------------
//  port

	output	[7:0] D_RED;
	output	[7:0] D_GRN;
	output	[7:0] D_BLU;
	output	D_HSYNC_N;
	output	D_VSYNC_N;
	output	D_BLANK_N;

	output	[9:0] D_HCOUNT;
	output	[9:0] D_VCOUNT;

	input	[3:0] D_MODE;

	input	D_RST_N;
	input	D_CLK;

//--------------------------------------------------------------
//  constant

	parameter	param_hpos=12'h000;			// 0   : horizontal posiotn
	parameter	param_vpos=12'h000;			// 0   : vertical position

	// ---- 25MHz 640*480@60Hz(vga) timing ----

	parameter	param640x480_hcount_sbp=12'h05f;	//  96 : start back porch(end hsync)
//	parameter	param640x480_hcount_ebp=12'h08f;	// 144 : end back porch(start active video)
	parameter	param640x480_hcount_sav=12'h08f;	// 144 : start active video
	parameter	param640x480_hcount_eav=12'h30f;	// 784 : end active video
//	parameter	param640x480_hcount_sfp=12'h30f;	// 784 : start front porch(end active video)
//	parameter	param640x480_hcount_efp=12'h31f;	// 800 : end front porch(start hsync)
	parameter	param640x480_hcount_end=12'h31f;	// 800 : end horizontal

	parameter	param640x480_vcount_sbp=12'h001;	//   2 : start back porch(end vsync)
//	parameter	param640x480_vcount_ebp=12'h022;	//  35 : end back porch(start active video)
	parameter	param640x480_vcount_sav=12'h022;	//  35 : start active video
	parameter	param640x480_vcount_eav=12'h202;	// 515 : end active video
//	parameter	param640x480_vcount_sfp=12'h202;	// 515 : start front porch(end active video)
//	parameter	param640x480_vcount_efp=12'h20c;	// 525 : end front porch(start vsync)
	parameter	param640x480_vcount_end=12'h20c;	// 525 : end vertical

	parameter	param640x480_hsize=12'h27f;		// 640 : horizontal size
	parameter	param640x480_vsize=12'h1df;		// 480 : vertical size

//--------------------------------------------------------------
//  signal

	wire	[31:0] data_out;
	wire	hsync_out_n;
	wire	vsync_out_n;
	wire	blank_out_n;

	wire	[9:0] hcount_out;
	wire	[9:0] vcount_out;

	wire	[9:0] hcount_out_w;
	wire	[9:0] vcount_out_w;
	reg		[9:0] hcount_out_r;
	reg		[9:0] vcount_out_r;

	wire	[31:0] data_out_w;
	reg		[31:0] data_out_r;
	wire	[7:0] hsync_out_n_w;
	reg		[7:0] hsync_out_n_r;
	wire	[7:0] vsync_out_n_w;
	reg		[7:0] vsync_out_n_r;
	wire	[7:0] blank_out_n_w;
	reg		[7:0] blank_out_n_r;

	wire	[11:0] hcount_w;
	reg		[11:0] hcount_r;
	wire	[11:0] vcount_w;
	reg		[11:0] vcount_r;
	wire	[11:0] hcount_inc;
	wire	[11:0] vcount_inc;
	wire	hcount_end;
	wire	[7:0] htiming_w;
	reg		[7:0] htiming_r;
	wire	vcount_end;
	wire	[7:0] vtiming_w;
	reg		[7:0] vtiming_r;

	wire	hsync_n_w;
	reg		hsync_n_r;
	wire	vsync_n_w;
	reg		vsync_n_r;
	wire	hblank_n_w;
	reg		hblank_n_r;
	wire	vblank_n_w;
	reg		vblank_n_r;
	wire	vnext_w;
	reg		vnext_r;
	wire	blank_n_w;
	reg		blank_n_r;

//--------------------------------------------------------------
//  design

	// ---- ----

	reg		[3:0] mode_r;

	always @(posedge D_CLK or negedge D_RST_N)
	begin
		if (D_RST_N==1'b0)
			begin
				mode_r[3:0] <= 4'b0;
			end
		else
			begin
				mode_r[3:0] <= D_MODE[3:0];
			end
	end

	// ---- display signal ----

	assign D_RED[7:0]=data_out[23:16];
	assign D_GRN[7:0]=data_out[15:8];
	assign D_BLU[7:0]=data_out[7:0];

	assign D_HSYNC_N=hsync_out_n;
	assign D_VSYNC_N=vsync_out_n;
	assign D_BLANK_N=blank_out_n;

	// ---- diplay timing control ----

	wire	[11:0] reg_hcount_sbp_w;
	wire	[11:0] reg_hcount_sav_w;
	wire	[11:0] reg_hcount_eav_w;
	wire	[11:0] reg_hcount_end_w;
	wire	[11:0] reg_vcount_sbp_w;
	wire	[11:0] reg_vcount_sav_w;
	wire	[11:0] reg_vcount_eav_w;
	wire	[11:0] reg_vcount_end_w;
	wire	[11:0] reg_hsize_w;
	wire	[11:0] reg_vsize_w;

	reg		[11:0] reg_hcount_sbp_r;
	reg		[11:0] reg_hcount_sav_r;
	reg		[11:0] reg_hcount_eav_r;
	reg		[11:0] reg_hcount_end_r;
	reg		[11:0] reg_vcount_sbp_r;
	reg		[11:0] reg_vcount_sav_r;
	reg		[11:0] reg_vcount_eav_r;
	reg		[11:0] reg_vcount_end_r;
	reg		[11:0] reg_hsize_r;
	reg		[11:0] reg_vsize_r;

	always @(posedge D_CLK or negedge D_RST_N)
	begin
		if (D_RST_N==1'b0)
			begin
				reg_hcount_sbp_r[11:0] <= param640x480_hcount_sbp[11:0];
				reg_hcount_sav_r[11:0] <= param640x480_hcount_sav[11:0];
				reg_hcount_eav_r[11:0] <= param640x480_hcount_eav[11:0];
				reg_hcount_end_r[11:0] <= param640x480_hcount_end[11:0];
				reg_vcount_sbp_r[11:0] <= param640x480_vcount_sbp[11:0];
				reg_vcount_sav_r[11:0] <= param640x480_vcount_sav[11:0];
				reg_vcount_eav_r[11:0] <= param640x480_vcount_eav[11:0];
				reg_vcount_end_r[11:0] <= param640x480_vcount_end[11:0];
				reg_hsize_r[11:0] <= param640x480_hsize[11:0];
				reg_vsize_r[11:0] <= param640x480_vsize[11:0];
			end
		else
			begin
				reg_hcount_sbp_r[11:0] <= reg_hcount_sbp_w[11:0];
				reg_hcount_sav_r[11:0] <= reg_hcount_sav_w[11:0];
				reg_hcount_eav_r[11:0] <= reg_hcount_eav_w[11:0];
				reg_hcount_end_r[11:0] <= reg_hcount_end_w[11:0];
				reg_vcount_sbp_r[11:0] <= reg_vcount_sbp_w[11:0];
				reg_vcount_sav_r[11:0] <= reg_vcount_sav_w[11:0];
				reg_vcount_eav_r[11:0] <= reg_vcount_eav_w[11:0];
				reg_vcount_end_r[11:0] <= reg_vcount_end_w[11:0];
				reg_hsize_r[11:0] <= reg_hsize_w[11:0];
				reg_vsize_r[11:0] <= reg_vsize_w[11:0];
			end
	end

	assign reg_hcount_sbp_w[11:0]=param640x480_hcount_sbp[11:0];
	assign reg_hcount_sav_w[11:0]=param640x480_hcount_sav[11:0];
	assign reg_hcount_eav_w[11:0]=param640x480_hcount_eav[11:0];
	assign reg_hcount_end_w[11:0]=param640x480_hcount_end[11:0];
	assign reg_vcount_sbp_w[11:0]=param640x480_vcount_sbp[11:0];
	assign reg_vcount_sav_w[11:0]=param640x480_vcount_sav[11:0];
	assign reg_vcount_eav_w[11:0]=param640x480_vcount_eav[11:0];
	assign reg_vcount_end_w[11:0]=param640x480_vcount_end[11:0];
	assign reg_hsize_w[11:0]=param640x480_hsize[11:0];
	assign reg_vsize_w[11:0]=param640x480_vsize[11:0];

	// ---- ----

	always @(posedge D_CLK or negedge D_RST_N)
	begin
		if (D_RST_N==1'b0)
			begin
				hcount_r[11:0] <= 12'h001;
				htiming_r[7:0] <= 8'h00;
				vcount_r[11:0] <= 12'h000;
				vtiming_r[7:0] <= 8'h00;
				hsync_n_r <= 1'b0;
				vsync_n_r <= 1'b0;
				hblank_n_r <= 1'b0;
				vblank_n_r <= 1'b0;
				vnext_r <= 1'b0;
				blank_n_r <= 1'b0;
			end
		else
			begin
				hcount_r[11:0] <= hcount_w[11:0];
				htiming_r[7:0] <= htiming_w[7:0];
				vcount_r[11:0] <= vcount_w[11:0];
				vtiming_r[7:0] <= vtiming_w[7:0];
				hsync_n_r <= hsync_n_w;
				vsync_n_r <= vsync_n_w;
				hblank_n_r <= hblank_n_w;
				vblank_n_r <= vblank_n_w;
				vnext_r <= vnext_w;
				blank_n_r <= blank_n_w;
			end
	end

	assign hcount_inc[11:0]=hcount_r[11:0]+12'h001;
	assign vcount_inc[11:0]=vcount_r[11:0]+12'h001;

	assign hcount_end=(htiming_r[7]==1'b1) ? 1'b1 : 1'b0;
	assign vcount_end=(vtiming_r[7]==1'b1) ? 1'b1 : 1'b0;

	assign hcount_w[11:0]=
			(hcount_end==1'b1) ? 12'h001 :
			(hcount_end==1'b0) ? hcount_inc[11:0] :
			12'h001;

	assign vcount_w[11:0]=
			(hcount_end==1'b1) & (vcount_end==1'b1) ? 12'h000 :
			(hcount_end==1'b1) & (vcount_end==1'b0) ? vcount_inc[11:0] :
			(hcount_end==1'b0) ? vcount_r[11:0] :
			12'h000;

	assign htiming_w[0]=(hcount_r[2:0]==3'b110) ? 1'b1 : 1'b0;
	assign htiming_w[1]=(hcount_r[11:0]==reg_hcount_sbp_r[11:0]) ? 1'b1 : 1'b0;
	assign htiming_w[2]=1'b0;
	assign htiming_w[3]=(hcount_r[11:0]==reg_hcount_sav_r[11:0]) ? 1'b1 : 1'b0;
	assign htiming_w[4]=(hcount_r[11:0]==reg_hcount_eav_r[11:0]) ? 1'b1 : 1'b0;
	assign htiming_w[5]=1'b0;
	assign htiming_w[6]=1'b0;
	assign htiming_w[7]=(hcount_r[11:0]==reg_hcount_end_r[11:0]) ? 1'b1 : 1'b0;

	assign vtiming_w[0]=(hcount_r[2:0]==3'b101) ? 1'b1 : 1'b0;
	assign vtiming_w[1]=(vcount_r[11:0]==reg_vcount_sbp_r[11:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[2]=1'b0;
	assign vtiming_w[3]=(vcount_r[11:0]==reg_vcount_sav_r[11:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[4]=(vcount_r[11:0]==reg_vcount_eav_r[11:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[5]=1'b0;
	assign vtiming_w[6]=1'b0;
	assign vtiming_w[7]=(vcount_r[11:0]==reg_vcount_end_r[11:0]) ? 1'b1 : 1'b0;

	assign hsync_n_w=
			(htiming_r[7]==1'b1) ? 1'b0 :
			(htiming_r[7]==1'b0) & (htiming_r[1]==1'b1) ? 1'b1 :
			(htiming_r[7]==1'b0) & (htiming_r[1]==1'b0) ? hsync_n_r :
			1'b0;

	assign vsync_n_w=
			(hcount_end==1'b1) & (vtiming_r[7]==1'b1) ? 1'b0 :
			(hcount_end==1'b1) & (vtiming_r[7]==1'b0) & (vtiming_r[1]==1'b1) ? 1'b1 :
			(hcount_end==1'b1) & (vtiming_r[7]==1'b0) & (vtiming_r[1]==1'b0) ? vsync_n_r :
			(hcount_end==1'b0) ? vsync_n_r :
			1'b0;

	assign hblank_n_w=
			(htiming_r[4]==1'b1) ? 1'b0 :
			(htiming_r[4]==1'b0) & (htiming_r[3]==1'b1) ? 1'b1 :
			(htiming_r[4]==1'b0) & (htiming_r[3]==1'b0) ? hblank_n_r :
			1'b0;

	assign vblank_n_w=
			(hcount_end==1'b1) & (vtiming_r[4]==1'b1) ? 1'b0 :
			(hcount_end==1'b1) & (vtiming_r[4]==1'b0) & (vtiming_r[3]==1'b1) ? 1'b1 :
			(hcount_end==1'b1) & (vtiming_r[4]==1'b0) & (vtiming_r[3]==1'b0) ? vblank_n_r :
			(hcount_end==1'b0) ? vblank_n_r :
			1'b0;

	assign vnext_w=
			(hcount_end==1'b1) & (vblank_n_r==1'b0) ? 1'b0 :
			(hcount_end==1'b1) & (vblank_n_r==1'b1) ? !vnext_r :
			(hcount_end==1'b0) ? vnext_r :
			1'b0;

	assign blank_n_w=(hblank_n_w==1'b0) | (vblank_n_w==1'b0) ? 1'b0 : 1'b1;

	// ---- buff output control ----

	assign data_out[31:0]=data_out_r[31:0];
	assign hsync_out_n=hsync_out_n_r[2];
	assign vsync_out_n=vsync_out_n_r[2];
	assign blank_out_n=blank_out_n_r[2];

	assign hcount_out[9:0]=hcount_out_r[9:0];
	assign vcount_out[9:0]=vcount_out_r[9:0];

	wire	[31:0] data_select0_w;
	wire	[31:0] data_select1_w;
	wire	[31:0] data_select2_w;
	wire	[31:0] data_select3_w;
	reg		[31:0] data_select0_r;
	reg		[31:0] data_select1_r;
	reg		[31:0] data_select2_r;
	reg		[31:0] data_select3_r;

	wire	[11:0] hdisp_count_w;
	wire	[11:0] vdisp_count_w;
	wire	[3:0] hdisp_select_w;
	wire	[3:0] vdisp_select_w;
	reg		[11:0] hdisp_count_r;
	reg		[11:0] vdisp_count_r;
	reg		[3:0] hdisp_select_r;
	reg		[3:0] vdisp_select_r;

	always @(posedge D_CLK or negedge D_RST_N)
	begin
		if (D_RST_N==1'b0)
			begin
				hcount_out_r[9:0] <= 10'b0;
				vcount_out_r[9:0] <= 10'b0;
			end
		else
			begin
				hcount_out_r[9:0] <= (blank_out_n_r[2]==1'b0) ? 10'b0 : hcount_out_r[9:0]+1;
				vcount_out_r[9:0] <= vdisp_count_r[9:0];
			end
	end

	always @(posedge D_CLK or negedge D_RST_N)
	begin
		if (D_RST_N==1'b0)
			begin
				data_out_r[31:0] <= 32'h00000000;
				hsync_out_n_r[7:0] <= 8'b00;
				vsync_out_n_r[7:0] <= 8'b00;
				blank_out_n_r[7:0] <= 8'b00;

				data_select0_r[31:0] <= 32'h00000000;
				data_select1_r[31:0] <= 32'h00000000;
				data_select2_r[31:0] <= 32'h00000000;
				data_select3_r[31:0] <= 32'h00000000;
				hdisp_count_r[11:0] <= 12'b00;
				vdisp_count_r[11:0] <= 12'b00;
				hdisp_select_r[3:0] <= 4'b00;
				vdisp_select_r[3:0] <= 4'b00;
			end
		else
			begin
				data_out_r[31:0] <= data_out_w[31:0];
				hsync_out_n_r[7:0] <= hsync_out_n_w[7:0];
				vsync_out_n_r[7:0] <= vsync_out_n_w[7:0];
				blank_out_n_r[7:0] <= blank_out_n_w[7:0];

				data_select0_r[31:0] <= data_select0_w[31:0];
				data_select1_r[31:0] <= data_select1_w[31:0];
				data_select2_r[31:0] <= data_select2_w[31:0];
				data_select3_r[31:0] <= data_select3_w[31:0];
				hdisp_count_r[11:0] <= hdisp_count_w[11:0];
				vdisp_count_r[11:0] <= vdisp_count_w[11:0];
				hdisp_select_r[3:0] <= hdisp_select_w[3:0];
				vdisp_select_r[3:0] <= vdisp_select_w[3:0];
			end
	end

	assign hsync_out_n_w[7:0]={hsync_out_n_r[6:0],hsync_n_r};
	assign vsync_out_n_w[7:0]={vsync_out_n_r[6:0],vsync_n_r};
	assign blank_out_n_w[7:0]={blank_out_n_r[6:0],blank_n_r};

	assign data_out_w[31:0]=
			(blank_out_n_r[1]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b1) ? {8'h00,24'hffffff} :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h0) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h1) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h2) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h3) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h4) ? data_select1_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h5) ? data_select2_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h6) ? data_select3_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (mode_r[0]==1'b0) & (vdisp_select_r[3:1]==3'h7) ? data_select3_r[31:0] :
			32'h00000000;

	assign data_select0_w[31:0]=
			(blank_out_n_r[0]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h0) ? {8'h00,24'h676767} :	// 40% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h1) ? {8'h00,24'hbfbfbf} :	// 75% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h2) ? {8'h00,24'hbfbf00} :	// 75% yellow
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h3) ? {8'h00,24'h00bfbf} :	// 75% cyan
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h4) ? {8'h00,24'h00bf00} :	// 75% green
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h5) ? {8'h00,24'hbf00bf} :	// 75% magenda
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h6) ? {8'h00,24'hbf0000} :	// 75% red
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h7) ? {8'h00,24'h0000bf} :	// 75% blu
			32'h00000000;

	assign data_select1_w[31:0]=
			(blank_out_n_r[0]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h0) ? {8'h00,24'h00ffff} :	// 100% cyan
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h1) ? {8'h00,24'hffffff} :	// 100% white
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h2) ? {8'h00,24'hbfbfbf} :	// 75% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h3) ? {8'h00,24'hbfbfbf} :	// 75% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h4) ? {8'h00,24'hbfbfbf} :	// 75% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h5) ? {8'h00,24'hbfbfbf} :	// 75% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h6) ? {8'h00,24'hbfbfbf} :	// 75% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h7) ? {8'h00,24'hbfbfbf} :	// 75% white
			32'h00000000;

	assign data_select2_w[31:0]=
			(blank_out_n_r[0]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h0) ? {8'h00,24'hffff00} :	// 100% yellow
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h1) ? {8'h00,24'hffffff} :	// 100% white
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h2) ? {8'h00,24'h000000} :	// 00% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h3) ? {8'h00,24'h333333} :	// 20% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h4) ? {8'h00,24'h666666} :	// 40% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h5) ? {8'h00,24'h999999} :	// 60% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h6) ? {8'h00,24'hcccccc} :	// 80% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h7) ? {8'h00,24'hffffff} :	// 100% white
			32'h00000000;

	assign data_select3_w[31:0]=
			(blank_out_n_r[0]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h0) ? {8'h00,24'h262626} :	// 15% gray
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h1) ? {8'h00,24'h000000} :	// 00% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h2) ? {8'h00,24'h000000} :	// 00% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h3) ? {8'h00,24'hffffff} :	// 100% white
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h4) ? {8'h00,24'hffffff} :	// 100% white
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h5) ? {8'h00,24'h000000} :	// 00% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h6) ? {8'h00,24'h000000} :	// 00% black
			(blank_out_n_r[0]==1'b1) & (hdisp_select_r[3:1]==3'h7) ? {8'h00,24'h000000} :	// 00% black
			32'h00000000;

	assign hdisp_count_w[11:0]=(blank_n_r==1'b0) ? 12'h0 : hdisp_count_r[11:0]+12'h001;
	assign vdisp_count_w[11:0]=
			(vsync_n_r==1'b0) ? 12'h0 :
			(vsync_n_r==1'b1) & (blank_out_n_r[1:0]==2'b10) ? vdisp_count_r[11:0]+12'h001 :
			(vsync_n_r==1'b1) & (blank_out_n_r[1:0]!=2'b10) ? vdisp_count_r[11:0] :
			12'h0;

	assign hdisp_select_w[3:0]=
			(blank_n_r==1'b0) ? 4'h0 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h028) ? 4'h1 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h050) ? 4'h2 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h078) ? 4'h3 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h0a0) ? 4'h4 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h0c8) ? 4'h5 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h0f0) ? 4'h6 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h118) ? 4'h7 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h140) ? 4'h8 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h168) ? 4'h9 :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h190) ? 4'ha :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h1b8) ? 4'hb :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h1e0) ? 4'hc :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h208) ? 4'hd :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h230) ? 4'he :
			(blank_n_r==1'b1) & (hdisp_count_r[11:0]==12'h258) ? 4'hf :
			hdisp_select_r[3:0];
	assign vdisp_select_w[3:0]=
			(vblank_n_r==1'b0) ? 4'h0 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h01e) ? 4'h1 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h03c) ? 4'h2 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h05a) ? 4'h3 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h078) ? 4'h4 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h096) ? 4'h5 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h0b4) ? 4'h6 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h0d2) ? 4'h7 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h0f0) ? 4'h8 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h10e) ? 4'h9 :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h12c) ? 4'ha :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h14a) ? 4'hb :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h168) ? 4'hc :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h186) ? 4'hd :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h1a4) ? 4'he :
			(vblank_n_r==1'b1) & (vdisp_count_r[11:0]==12'h1c2) ? 4'hf :
			vdisp_select_r[3:0];

endmodule
