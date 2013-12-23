//------------------------------------------------------------------------------
//
//  dvi_data_enc.v : data encode module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2009/mar/09 release 1.0a dvi(tmds) display test
//
//------------------------------------------------------------------------------
//
//  refer to
//
//  DDWG Digital Display working Group
//  Digital Visual Interface Revision 1.0 02/April/1999
//  http://www.ddwg.org
//  See FAQS and Adopter's Agreement.
//
//  This code implemented it according to DDWG DVI Revision 1.0. 
//  As for the TMDS encoding and decoding algorithm, DDWG owns a right.
//
//------------------------------------------------------------------------------

module dvi_data_enc(
	input	[9:0]	ch_in,					// in    [ENC] [9:0]
	input			ch_de,					// in    [ENC] 
	output	[9:0]	ch_out,					// out   [ENC] [9:0]

	input			rst_n,					// in    [ENC] 
	input			clk						// in    [ENC] 
);

//--------------------------------------------------------------
//	signal

	reg		st0_abort_r;
	reg		[9:0] st0_qm_r;

	wire	st0_abort_w;
	wire	[9:0] st0_qm_w;

	reg		[9:0] st1_qm_r;
	reg		[7:0] st1_cnt_r;
	wire	[9:0] st1_qm_w;
	wire	[7:0] st1_cnt_w;

//--------------------------------------------------------------
//	design

	assign ch_out[9:0]=st1_qm_r[9:0];

	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n==1'b0)
			begin
				st0_abort_r <= 1'b0;
				st0_qm_r <= 10'b0;
				st1_qm_r <= 10'b0;
				st1_cnt_r <= 4'b0;
			end
		else
			begin
				st0_abort_r <= st0_abort_w;
				st0_qm_r <= st0_qm_w;
				st1_qm_r <= st1_qm_w;
				st1_cnt_r <= st1_cnt_w;
			end
	end

	// -- stage 0 --

	assign st0_abort_w=(ch_de==1'b0) ? 1'b1 : 1'b0;

	wire	[3:0] st0_cnt1;
	wire	[3:0] st0_cnt1_hi;
	wire	[3:0] st0_cnt1_low;

	wire	[9:0] st0_qm_xor;
	wire	[9:0] st0_qm_xnor;

	assign st0_cnt1_hi[3:0]=
			(ch_in[7:4]==4'h0) ? 4'h0 :
			(ch_in[7:4]==4'h1) ? 4'h1 :
			(ch_in[7:4]==4'h2) ? 4'h1 :
			(ch_in[7:4]==4'h3) ? 4'h2 :
			(ch_in[7:4]==4'h4) ? 4'h1 :
			(ch_in[7:4]==4'h5) ? 4'h2 :
			(ch_in[7:4]==4'h6) ? 4'h2 :
			(ch_in[7:4]==4'h7) ? 4'h3 :
			(ch_in[7:4]==4'h8) ? 4'h1 :
			(ch_in[7:4]==4'h9) ? 4'h2 :
			(ch_in[7:4]==4'ha) ? 4'h2 :
			(ch_in[7:4]==4'hb) ? 4'h3 :
			(ch_in[7:4]==4'hc) ? 4'h2 :
			(ch_in[7:4]==4'hd) ? 4'h3 :
			(ch_in[7:4]==4'he) ? 4'h3 :
			(ch_in[7:4]==4'hf) ? 4'h4 :
			4'h0;

	assign st0_cnt1_low[3:0]=
			(ch_in[3:0]==4'h0) ? 4'h0 :
			(ch_in[3:0]==4'h1) ? 4'h1 :
			(ch_in[3:0]==4'h2) ? 4'h1 :
			(ch_in[3:0]==4'h3) ? 4'h2 :
			(ch_in[3:0]==4'h4) ? 4'h1 :
			(ch_in[3:0]==4'h5) ? 4'h2 :
			(ch_in[3:0]==4'h6) ? 4'h2 :
			(ch_in[3:0]==4'h7) ? 4'h3 :
			(ch_in[3:0]==4'h8) ? 4'h1 :
			(ch_in[3:0]==4'h9) ? 4'h2 :
			(ch_in[3:0]==4'ha) ? 4'h2 :
			(ch_in[3:0]==4'hb) ? 4'h3 :
			(ch_in[3:0]==4'hc) ? 4'h2 :
			(ch_in[3:0]==4'hd) ? 4'h3 :
			(ch_in[3:0]==4'he) ? 4'h3 :
			(ch_in[3:0]==4'hf) ? 4'h4 :
			4'h0;

	assign st0_cnt1[3:0]=st0_cnt1_hi[3:0]+st0_cnt1_low[3:0];

	assign st0_qm_xor[0]=ch_in[0];
	assign st0_qm_xor[1]=st0_qm_xor[0] ^ ch_in[1];
	assign st0_qm_xor[2]=st0_qm_xor[1] ^ ch_in[2];
	assign st0_qm_xor[3]=st0_qm_xor[2] ^ ch_in[3];
	assign st0_qm_xor[4]=st0_qm_xor[3] ^ ch_in[4];
	assign st0_qm_xor[5]=st0_qm_xor[4] ^ ch_in[5];
	assign st0_qm_xor[6]=st0_qm_xor[5] ^ ch_in[6];
	assign st0_qm_xor[7]=st0_qm_xor[6] ^ ch_in[7];
	assign st0_qm_xor[8]=1'b1;
	assign st0_qm_xor[9]=1'b0;

	assign st0_qm_xnor[0]=ch_in[0];
	assign st0_qm_xnor[1]=st0_qm_xnor[0] ~^ ch_in[1];
	assign st0_qm_xnor[2]=st0_qm_xnor[1] ~^ ch_in[2];
	assign st0_qm_xnor[3]=st0_qm_xnor[2] ~^ ch_in[3];
	assign st0_qm_xnor[4]=st0_qm_xnor[3] ~^ ch_in[4];
	assign st0_qm_xnor[5]=st0_qm_xnor[4] ~^ ch_in[5];
	assign st0_qm_xnor[6]=st0_qm_xnor[5] ~^ ch_in[6];
	assign st0_qm_xnor[7]=st0_qm_xnor[6] ~^ ch_in[7];
	assign st0_qm_xnor[8]=1'b0;
	assign st0_qm_xnor[9]=1'b0;

	wire	st0_sel;

	assign st0_sel=
			(st0_cnt1[3:2]==2'h01) & (st0_cnt1[2:0]==3'h0) & (ch_in[0]==1'b0) ? 1'b1 :
			(st0_cnt1[3:2]==2'h01) & (st0_cnt1[2:0]==3'h0) & (ch_in[0]==1'b1) ? 1'b0 :
			(st0_cnt1[3:2]==2'h01) & (st0_cnt1[2:0]!=3'h0) ? 1'b1 :
			(st0_cnt1[3:2]==2'h00) ? 1'b0 :
			(st0_cnt1[3]  ==1'h1) ? 1'b1 :
			1'b0;

	assign st0_qm_w=
			({ch_de,ch_in[9],ch_in[8]}==3'b000) ? 10'b1101010100 :
			({ch_de,ch_in[9],ch_in[8]}==3'b001) ? 10'b0010101011 :
			({ch_de,ch_in[9],ch_in[8]}==3'b010) ? 10'b0101010100 :
			({ch_de,ch_in[9],ch_in[8]}==3'b011) ? 10'b1010101011 :
			({ch_de,ch_in[9],ch_in[8]}==3'b011) ? 10'b1010101011 :
			(ch_de==1'b1) & (st0_sel==1'h0) ? st0_qm_xor[9:0] :
			(ch_de==1'b1) & (st0_sel==1'h1) ? st0_qm_xnor[9:0] :
			10'b0;

	// -- stage 1 --

	wire	[3:0] st1_cnt1;
	wire	[3:0] st1_cnt1_hi;
	wire	[3:0] st1_cnt1_low;

	assign st1_cnt1_hi[3:0]=
			(st0_qm_r[7:4]==4'h0) ? 4'h0 :
			(st0_qm_r[7:4]==4'h1) ? 4'h1 :
			(st0_qm_r[7:4]==4'h2) ? 4'h1 :
			(st0_qm_r[7:4]==4'h3) ? 4'h2 :
			(st0_qm_r[7:4]==4'h4) ? 4'h1 :
			(st0_qm_r[7:4]==4'h5) ? 4'h2 :
			(st0_qm_r[7:4]==4'h6) ? 4'h2 :
			(st0_qm_r[7:4]==4'h7) ? 4'h3 :
			(st0_qm_r[7:4]==4'h8) ? 4'h1 :
			(st0_qm_r[7:4]==4'h9) ? 4'h2 :
			(st0_qm_r[7:4]==4'ha) ? 4'h2 :
			(st0_qm_r[7:4]==4'hb) ? 4'h3 :
			(st0_qm_r[7:4]==4'hc) ? 4'h2 :
			(st0_qm_r[7:4]==4'hd) ? 4'h3 :
			(st0_qm_r[7:4]==4'he) ? 4'h3 :
			(st0_qm_r[7:4]==4'hf) ? 4'h4 :
			4'h0;

	assign st1_cnt1_low[3:0]=
			(st0_qm_r[3:0]==4'h0) ? 4'h0 :
			(st0_qm_r[3:0]==4'h1) ? 4'h1 :
			(st0_qm_r[3:0]==4'h2) ? 4'h1 :
			(st0_qm_r[3:0]==4'h3) ? 4'h2 :
			(st0_qm_r[3:0]==4'h4) ? 4'h1 :
			(st0_qm_r[3:0]==4'h5) ? 4'h2 :
			(st0_qm_r[3:0]==4'h6) ? 4'h2 :
			(st0_qm_r[3:0]==4'h7) ? 4'h3 :
			(st0_qm_r[3:0]==4'h8) ? 4'h1 :
			(st0_qm_r[3:0]==4'h9) ? 4'h2 :
			(st0_qm_r[3:0]==4'ha) ? 4'h2 :
			(st0_qm_r[3:0]==4'hb) ? 4'h3 :
			(st0_qm_r[3:0]==4'hc) ? 4'h2 :
			(st0_qm_r[3:0]==4'hd) ? 4'h3 :
			(st0_qm_r[3:0]==4'he) ? 4'h3 :
			(st0_qm_r[3:0]==4'hf) ? 4'h4 :
			4'h0;

	assign st1_cnt1[3:0]=st1_cnt1_hi[3:0]+st1_cnt1_low[3:0];

	wire	st1_case_cnt_eq;
	wire	st1_case_cnt_ne;
	wire	[1:0] st1_case_cnt_ne1;

	assign st1_case_cnt_eq=(st1_cnt_r[7:0]==8'h0) | (st1_cnt1[3:0]==4'h4) ? 1'b1 : 1'b0;
	assign st1_case_cnt_ne=(st1_case_cnt_ne1[1:0]==2'b00) ? 1'b0 : 1'b1;
	assign st1_case_cnt_ne1[0]=
			(((st1_cnt_r[7]==1'h0) & (st1_cnt_r[6:0]!=7'h0)) & ((st1_cnt1[3:2]==2'b01) & (st1_cnt1[1:0]!=2'b0))) ? 1'b1 :
			(((st1_cnt_r[7]==1'h0) & (st1_cnt_r[6:0]!=7'h0)) & ((st1_cnt1[3]==1'b1))) ? 1'b1 :
			1'b0;
	assign st1_case_cnt_ne1[1]=((st1_cnt_r[7]==1'h1) & (st1_cnt1[3:2]==2'b0)) ? 1'b1 : 1'b0;

	assign st1_qm_w[9:0]=
			(st0_abort_r==1'b1) ? st0_qm_r[9:0] :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b1) & (st0_qm_r[8]==1'b1) ? {!st0_qm_r[8],st0_qm_r[8], st0_qm_r[7:0]} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b1) & (st0_qm_r[8]==1'b0) ? {!st0_qm_r[8],st0_qm_r[8],~st0_qm_r[7:0]} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b1) ? {1'b1,st0_qm_r[8],~st0_qm_r[7:0]} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b0) ? {1'b0,st0_qm_r[8], st0_qm_r[7:0]} :
			10'b0;

	assign st1_cnt_w[7:0]=
			(st0_abort_r==1'b1) ? 8'h0 :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b1) & (st0_qm_r[8]==1'b1) ? st1_cnt_r[7:0]-8'h08+{3'b0,st1_cnt1[3:0],1'b0} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b1) & (st0_qm_r[8]==1'b0) ? st1_cnt_r[7:0]+8'h08-{3'b0,st1_cnt1[3:0],1'b0} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b1) & (st0_qm_r[8]==1'b1) ? st1_cnt_r[7:0]+8'h02+8'h08-{3'b0,st1_cnt1[3:0],1'b0} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b1) & (st0_qm_r[8]==1'b0) ? st1_cnt_r[7:0]+8'h00+8'h08-{3'b0,st1_cnt1[3:0],1'b0} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b0) & (st0_qm_r[8]==1'b0) ? st1_cnt_r[7:0]-8'h02-8'h08+{3'b0,st1_cnt1[3:0],1'b0} :
			(st0_abort_r==1'b0) & (st1_case_cnt_eq==1'b0) & (st1_case_cnt_ne==1'b0) & (st0_qm_r[8]==1'b1) ? st1_cnt_r[7:0]-8'h00-8'h08+{3'b0,st1_cnt1[3:0],1'b0} :
			8'h0;

endmodule


