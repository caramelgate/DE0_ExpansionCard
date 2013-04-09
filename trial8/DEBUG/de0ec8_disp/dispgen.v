//------------------------------------------------------------------------------
//
//  dispgen.v : display colorbar module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

module dispgen(
	output	[7:0]	D_RED,				// out   [CRT] [7:0] red
	output	[7:0]	D_GRN,				// out   [CRT] [7:0] green
	output	[7:0]	D_BLU,				// out   [CRT] [7:0] blue
	output			D_HS,				// out   [CRT] #hsync
	output			D_VS,				// out   [CRT] #vsync
	output			D_DE,				// out   [CRT] #blank/de

	input			TX_HS,				// in    [CRT] #hsync
	input			TX_VS,				// in    [CRT] #vsync
	input			TX_DE,				// in    [CRT] #blank
	input			TX_CLK,				// in    [CRT] cke

	input			RST_N,				// in    [CRT] #reset
	input			CLK					// in    [CRT] clock
);

//--------------------------------------------------------------
//  constant

//--------------------------------------------------------------
//  signal

	wire	[31:0] data_out;
	wire	hsync_out_n;
	wire	vsync_out_n;
	wire	blank_out_n;

	wire	[31:0] data_out_w;
	reg		[31:0] data_out_r;
	wire	[7:0] hsync_out_n_w;
	reg		[7:0] hsync_out_n_r;
	wire	[7:0] vsync_out_n_w;
	reg		[7:0] vsync_out_n_r;
	wire	[7:0] blank_out_n_w;
	reg		[7:0] blank_out_n_r;


//--------------------------------------------------------------
//  design

	// ---- display signal ----

	assign D_RED[7:0]=data_out[23:16];
	assign D_GRN[7:0]=data_out[15:8];
	assign D_BLU[7:0]=data_out[7:0];
	assign D_HS=hsync_out_n;
	assign D_VS=vsync_out_n;
	assign D_DE=blank_out_n;

//	assign D_RED[7:0]=8'b0;
//	assign D_GRN[7:0]=8'b0;
//	assign D_BLU[7:0]=8'b0;
//	assign D_HS=TX_HS;
//	assign D_VS=TX_VS;
//	assign D_DE=TX_DE;


	// ---- data output control ----

	assign data_out[31:0]=data_out_r[31:0];
	assign hsync_out_n=hsync_out_n_r[2];
	assign vsync_out_n=vsync_out_n_r[2];
	assign blank_out_n=blank_out_n_r[2];

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

	always @(posedge CLK or negedge RST_N)
	begin
		if (RST_N==1'b0)
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
				data_out_r[31:0] <= (TX_CLK==1'b1) ? data_out_w[31:0] : data_out_r[31:0];
				hsync_out_n_r[7:0] <= (TX_CLK==1'b1) ? hsync_out_n_w[7:0] : hsync_out_n_r[7:0];
				vsync_out_n_r[7:0] <= (TX_CLK==1'b1) ? vsync_out_n_w[7:0] : vsync_out_n_r[7:0];
				blank_out_n_r[7:0] <= (TX_CLK==1'b1) ? blank_out_n_w[7:0] : blank_out_n_r[7:0];

				data_select0_r[31:0] <= (TX_CLK==1'b1) ? data_select0_w[31:0] : data_select0_r[31:0];
				data_select1_r[31:0] <= (TX_CLK==1'b1) ? data_select1_w[31:0] : data_select1_r[31:0];
				data_select2_r[31:0] <= (TX_CLK==1'b1) ? data_select2_w[31:0] : data_select2_r[31:0];
				data_select3_r[31:0] <= (TX_CLK==1'b1) ? data_select3_w[31:0] : data_select3_r[31:0];
				hdisp_count_r[11:0] <= (TX_CLK==1'b1) ? hdisp_count_w[11:0] : hdisp_count_r[11:0];
				vdisp_count_r[11:0] <= (TX_CLK==1'b1) ? vdisp_count_w[11:0] : vdisp_count_r[11:0];
				hdisp_select_r[3:0] <= (TX_CLK==1'b1) ? hdisp_select_w[3:0] : hdisp_select_r[3:0];
				vdisp_select_r[3:0] <= (TX_CLK==1'b1) ? vdisp_select_w[3:0] : vdisp_select_r[3:0];
			end
	end

	assign hsync_out_n_w[7:0]={hsync_out_n_r[6:0],TX_HS};
	assign vsync_out_n_w[7:0]={vsync_out_n_r[6:0],TX_VS};
	assign blank_out_n_w[7:0]={blank_out_n_r[6:0],TX_DE};

	assign data_out_w[31:0]=
			(blank_out_n_r[1]==1'b0) ? {8'h00,24'h000000} :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h0) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h1) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h2) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h3) ? data_select0_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h4) ? data_select1_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h5) ? data_select2_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h6) ? data_select3_r[31:0] :
			(blank_out_n_r[1]==1'b1) & (vdisp_select_r[3:1]==3'h7) ? data_select3_r[31:0] :
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

	assign hdisp_count_w[11:0]=(TX_DE==1'b0) ? 12'h0 : hdisp_count_r[11:0]+12'h001;
	assign vdisp_count_w[11:0]=
			(TX_VS==1'b0) ? 12'h0 :
			(TX_VS==1'b1) & (blank_out_n_r[1:0]==2'b10) ? vdisp_count_r[11:0]+12'h001 :
			(TX_VS==1'b1) & (blank_out_n_r[1:0]!=2'b10) ? vdisp_count_r[11:0] :
			12'h0;

	assign hdisp_select_w[3:0]=
			(TX_DE==1'b0) ? 4'h0 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h028) ? 4'h1 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h050) ? 4'h2 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h078) ? 4'h3 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h0a0) ? 4'h4 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h0c8) ? 4'h5 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h0f0) ? 4'h6 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h118) ? 4'h7 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h140) ? 4'h8 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h168) ? 4'h9 :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h190) ? 4'ha :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h1b8) ? 4'hb :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h1e0) ? 4'hc :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h208) ? 4'hd :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h230) ? 4'he :
			(TX_DE==1'b1) & (hdisp_count_r[11:0]==12'h258) ? 4'hf :
			hdisp_select_r[3:0];
	assign vdisp_select_w[3:0]=
			(TX_VS==1'b0) ? 4'h0 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h01e) ? 4'h1 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h03c) ? 4'h2 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h05a) ? 4'h3 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h078) ? 4'h4 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h096) ? 4'h5 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h0b4) ? 4'h6 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h0d2) ? 4'h7 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h0f0) ? 4'h8 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h10e) ? 4'h9 :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h12c) ? 4'ha :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h14a) ? 4'hb :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h168) ? 4'hc :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h186) ? 4'hd :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h1a4) ? 4'he :
			(TX_VS==1'b1) & (vdisp_count_r[11:0]==12'h1c2) ? 4'hf :
			vdisp_select_r[3:0];

endmodule
