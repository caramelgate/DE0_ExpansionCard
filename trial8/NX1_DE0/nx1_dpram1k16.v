//------------------------------------------------------------------------------
//
//	nx1_dpram1k16.v : ese x1 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

module nx1_dpram1k16 #(
	parameter def_DEVICE=0		// 0=xilinx sp3 1=altera cyclone
) (
	input			ACLK,
	input	[9:0]	AA,
	input	[15:0]	AI,
	output	[15:0]	AO,
	input			ACS,
	input			AWE,
	input			BCLK,
	input	[9:0]	BA,
	input	[15:0]	BI,
	output	[15:0]	BO,
	input	BCS,
	input	BWE
);

generate
	if (def_DEVICE==0)
begin

sp3_dpram1k16 dpram1k16(
	.ACLK(ACLK),
	.AA(AA),
	.AI(AI),
	.AO(AO),
	.ACS(ACS),
	.AWE(AWE),
	.BCLK(BCLK),
	.BA(BA),
	.BI(BI),
	.BO(BO),
	.BCS(BCS),
	.BWE(BWE)
);

end
	else
begin
end
endgenerate

generate
	if (def_DEVICE==1)
begin

	wire	wren_a;
	wire	wren_b;

	assign wren_a=({ACS,AWE}==2'b11) ? 1'b1 : 1'b0;
	assign wren_b=({BCS,BWE}==2'b11) ? 1'b1 : 1'b0;

alt_altsyncram_c3dp1kx16 dpram1k16 (
	.address_a(AA),
	.address_b(BA),
	.byteena_a(2'b11),
//	.clock(ACLK),
	.clock_a(ACLK),
	.clock_b(BCLK),
	.data_a(AI),
	.data_b(BI),
	.wren_a(wren_a),
	.wren_b(wren_b),
	.q_a(AO),
	.q_b(BO)
);

end
	else
begin
end
endgenerate

endmodule
