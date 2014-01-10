//------------------------------------------------------------------------------
//
//	nx1_cg8.v : ese x1 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

/****************************************************************************
  CG ROM from X Millennium
  http://www.turboz.to/
***************************************************************************/

module nx1_cg8 #(
	parameter	def_DEVICE=0	// 0=xilinx , 1=altera
) (
	input			CLK1,
	input	[10:0]	ADDR1,
	output	[7:0]	DATA1,
	input			CLK2,
	input	[10:0]	ADDR2,
	output	[7:0]	DATA2
);

generate
	if (def_DEVICE==0)
begin

xil_blk_mem_gen_v7_2_dprom8x2k cg8(
	.clka(CLK1),
	.ena(1'b1),
	.addra(ADDR1[10:0]),
	.douta(DATA1[7:0]),
	.clkb(CLK2),
	.enb(1'b1),
	.addrb(ADDR2[10:0]),
	.doutb(DATA1[7:0])
);

end
endgenerate

generate
	if (def_DEVICE==1)
begin

alt_altsyncram_c3dprom8x2k cg8(
	.address_a(ADDR1[10:0]),
	.address_b(ADDR2[10:0]),
	.clock_a(CLK1),
	.clock_b(CLK2),
	.q_a(DATA1[7:0]),
	.q_b(DATA2[7:0])
);

end
endgenerate

endmodule

