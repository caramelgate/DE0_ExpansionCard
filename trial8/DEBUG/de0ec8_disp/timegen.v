//------------------------------------------------------------------------------
//
//  timegen.v : display timing generator module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2013/feb/22 release 0.0  connection test
//
//------------------------------------------------------------------------------

module timegen #(
	parameter	hor_total=16'd800,		// horizontal total
	parameter	hor_addr =16'd640,		// horizontal display
	parameter	hor_fp   =16'd56,		// horizontal front porch (+margin)
	parameter	hor_sync =16'd32,		// horizontal sync
	parameter	hor_bp   =16'd88,		// horizontal back porch (+margin)
	parameter	ver_total=16'd511,		// vertical total
	parameter	ver_addr =16'd480,		// vertical display
	parameter	ver_fp   =16'd11,		// vertical front porch (+margin)
	parameter	ver_sync =16'd4,		// vertical sync
	parameter	ver_bp   =16'd16		// vertical back porch (+margin)
) (
	output			HSYNC_N,			// out   [CRT] #hsync
	output			VSYNC_N,			// out   [CRT] #vsync
	output			BLANK_N,			// out   [CRT] #blank/de

	input			RST_N,				// in    [CRT] #reset
	input			CLK					// in    [CRT] dot clock
);

//--------------------------------------------------------------
//  constant

//--------------------------------------------------------------
//  signal

	wire	[15:0] hcount_w;
	reg		[15:0] hcount_r;
	wire	[15:0] vcount_w;
	reg		[15:0] vcount_r;
	wire	[15:0] hcount_inc;
	wire	[15:0] vcount_inc;
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

	// ---- display signal ----

	assign HSYNC_N=hsync_n_r;
	assign VSYNC_N=vsync_n_r;
	assign BLANK_N=blank_n_r;

	// ---- diplay timing control ----

	wire	[15:0] h_sbp;
	wire	[15:0] h_sav;
	wire	[15:0] h_eav;
	wire	[15:0] h_end;
	wire	[15:0] v_sbp;
	wire	[15:0] v_sav;
	wire	[15:0] v_eav;
	wire	[15:0] v_end;

	assign h_sbp[15:0]=hor_sync[15:0]-1;
	assign h_sav[15:0]=hor_sync[15:0]+hor_bp[15:0]-1;
	assign h_eav[15:0]=hor_sync[15:0]+hor_bp[15:0]+hor_addr[15:0]-1;
	assign h_end[15:0]=hor_total[15:0]-1;
	assign v_sbp[15:0]=ver_sync[15:0]-1;
	assign v_sav[15:0]=ver_sync[15:0]+ver_bp[15:0]-1;
	assign v_eav[15:0]=ver_sync[15:0]+ver_bp[15:0]+ver_addr[15:0]-1;
	assign v_end[15:0]=ver_total[15:0]-1;

	// ---- ----

	always @(posedge CLK or negedge RST_N)
	begin
		if (RST_N==1'b0)
			begin
				hcount_r[15:0] <= 16'h001;
				htiming_r[7:0] <= 8'h00;
				vcount_r[15:0] <= 16'h000;
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
				hcount_r[15:0] <= hcount_w[15:0];
				htiming_r[7:0] <= htiming_w[7:0];
				vcount_r[15:0] <= vcount_w[15:0];
				vtiming_r[7:0] <= vtiming_w[7:0];
				hsync_n_r <= hsync_n_w;
				vsync_n_r <= vsync_n_w;
				hblank_n_r <= hblank_n_w;
				vblank_n_r <= vblank_n_w;
				vnext_r <= vnext_w;
				blank_n_r <= blank_n_w;
			end
	end

	assign hcount_inc[15:0]=hcount_r[15:0]+16'h001;
	assign vcount_inc[15:0]=vcount_r[15:0]+16'h001;

	assign hcount_end=(htiming_r[7]==1'b1) ? 1'b1 : 1'b0;
	assign vcount_end=(vtiming_r[7]==1'b1) ? 1'b1 : 1'b0;

	assign hcount_w[15:0]=
			(hcount_end==1'b1) ? 16'h001 :
			(hcount_end==1'b0) ? hcount_inc[15:0] :
			16'h001;

	assign vcount_w[15:0]=
			(hcount_end==1'b1) & (vcount_end==1'b1) ? 16'h000 :
			(hcount_end==1'b1) & (vcount_end==1'b0) ? vcount_inc[15:0] :
			(hcount_end==1'b0) ? vcount_r[15:0] :
			16'h000;

	assign htiming_w[0]=(hcount_r[2:0]==3'b110) ? 1'b1 : 1'b0;
	assign htiming_w[1]=(hcount_r[15:0]==h_sbp[15:0]) ? 1'b1 : 1'b0;
	assign htiming_w[2]=1'b0;
	assign htiming_w[3]=(hcount_r[15:0]==h_sav[15:0]) ? 1'b1 : 1'b0;
	assign htiming_w[4]=(hcount_r[15:0]==h_eav[15:0]) ? 1'b1 : 1'b0;
	assign htiming_w[5]=1'b0;
	assign htiming_w[6]=1'b0;
	assign htiming_w[7]=(hcount_r[15:0]==h_end[15:0]) ? 1'b1 : 1'b0;

	assign vtiming_w[0]=(hcount_r[2:0]==3'b101) ? 1'b1 : 1'b0;
	assign vtiming_w[1]=(vcount_r[15:0]==v_sbp[15:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[2]=1'b0;
	assign vtiming_w[3]=(vcount_r[15:0]==v_sav[15:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[4]=(vcount_r[15:0]==v_eav[15:0]) ? 1'b1 : 1'b0;
	assign vtiming_w[5]=1'b0;
	assign vtiming_w[6]=1'b0;
	assign vtiming_w[7]=(vcount_r[15:0]==v_end[15:0]) ? 1'b1 : 1'b0;

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

endmodule
