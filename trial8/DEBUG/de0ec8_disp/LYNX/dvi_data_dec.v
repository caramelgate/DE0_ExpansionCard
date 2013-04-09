//------------------------------------------------------------------------------
//
//  dvi_data_dec.v : data decode module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) candylogic@gmail.com
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

module dvi_data_dec(
	input	[9:0]	ch_in,					// in    [DEC] [9:0]
	output	[9:0]	ch_out,					// out   [DEC] [9:0]
	output			ch_de,					// out   [DEC] 

	input			rst_n,					// in    [DEC] 
	input			clk						// in    [DEC] 
);

//--------------------------------------------------------------
//	signal

	reg		st0_de_r;
	reg		[1:0] st0_cx_r;
	reg		[9:0] st0_qm_r;
	wire	st0_de_w;
	wire	[1:0] st0_cx_w;
	wire	[9:0] st0_qm_w;

	reg		st1_de_r;
	reg		[1:0] st1_cx_r;
	reg		[8:0] st1_qm_r;

	wire	st1_de_w;
	wire	[1:0] st1_cx_w;
	wire	[7:0] st1_qm_w;

//--------------------------------------------------------------
//	design

	assign ch_out[9:0]=(st1_de_r==1'b1) ? {st1_cx_r[1:0],st1_qm_r[7:0]} : {st1_cx_r[1:0],8'h00};
	assign ch_de=st1_de_r;

	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n==1'b0)
			begin
				st0_de_r <= 1'b0;
				st0_cx_r <= 2'b0;
				st0_qm_r <= 10'b0;
				st1_de_r <= 1'b0;
				st1_cx_r <= 2'b0;
				st1_qm_r <= 8'b0;
			end
		else
			begin
				st0_de_r <= st0_de_w;
				st0_cx_r <= st0_cx_w;
				st0_qm_r <= st0_qm_w;
				st1_de_r <= st1_de_w;
				st1_cx_r <= st1_cx_w;
				st1_qm_r <= st1_qm_w;
			end
	end

	// -- stage 0 --

	assign {st0_de_w,st0_cx_w[1:0]}=
			(ch_in[9:0]==10'b1101010100) ? 3'b000 :
			(ch_in[9:0]==10'b0010101011) ? 3'b001 :
			(ch_in[9:0]==10'b0101010100) ? 3'b010 :
			(ch_in[9:0]==10'b1010101011) ? 3'b011 :
			{1'b1,1'b0,1'b0};

	assign st0_qm_w[9:0]=(ch_in[9]==1'b1) ? {ch_in[9:8],~ch_in[7:0]} : {ch_in[9:8],ch_in[7:0]};

	// -- stage 1 --

	wire	[9:0] st1_qm_xor;
	wire	[9:0] st1_qm_xnor;

	assign st1_qm_xor[0]=st0_qm_r[0];
	assign st1_qm_xor[1]=st0_qm_r[1] ^ st0_qm_r[0];
	assign st1_qm_xor[2]=st0_qm_r[2] ^ st0_qm_r[1];
	assign st1_qm_xor[3]=st0_qm_r[3] ^ st0_qm_r[2];
	assign st1_qm_xor[4]=st0_qm_r[4] ^ st0_qm_r[3];
	assign st1_qm_xor[5]=st0_qm_r[5] ^ st0_qm_r[4];
	assign st1_qm_xor[6]=st0_qm_r[6] ^ st0_qm_r[5];
	assign st1_qm_xor[7]=st0_qm_r[7] ^ st0_qm_r[6];
	assign st1_qm_xor[8]=1'b0;
	assign st1_qm_xor[9]=1'b0;

	assign st1_qm_xnor[0]=st0_qm_r[0];
	assign st1_qm_xnor[1]=st0_qm_r[1] ~^ st0_qm_r[0];
	assign st1_qm_xnor[2]=st0_qm_r[2] ~^ st0_qm_r[1];
	assign st1_qm_xnor[3]=st0_qm_r[3] ~^ st0_qm_r[2];
	assign st1_qm_xnor[4]=st0_qm_r[4] ~^ st0_qm_r[3];
	assign st1_qm_xnor[5]=st0_qm_r[5] ~^ st0_qm_r[4];
	assign st1_qm_xnor[6]=st0_qm_r[6] ~^ st0_qm_r[5];
	assign st1_qm_xnor[7]=st0_qm_r[7] ~^ st0_qm_r[6];
	assign st1_qm_xnor[8]=1'b0;
	assign st1_qm_xnor[9]=1'b0;

	assign st1_qm_w[7:0]=(st0_qm_r[8]==1'h1) ? st1_qm_xor[7:0] : st1_qm_xnor[7:0];
	assign st1_de_w=st0_de_r;
	assign st1_cx_w[1:0]=(st0_de_r==1'b0) ? st0_cx_r[1:0] : st1_cx_r[1:0];

endmodule


