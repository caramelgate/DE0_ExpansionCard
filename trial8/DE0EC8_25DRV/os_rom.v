//-----------------------------------------------------------------------------
//
//  os_rom.v : 25drv genesis_os (onchip startup program) module
//
//  LICENSE : as-is
//  copyright (C) 2013, TakeshiNagashima caramelgate@gmail.com
//------------------------------------------------------------------------------
//  2013/mar/16 release 0.0  connection test
//       dec/23 release 0.1  preview
//
//------------------------------------------------------------------------------

module os_rom #(
	parameter	DEVICE=0	// 0=xilinx , 1=altera , x=generic
) (
	input			clk,
	input	[11:0]	addr,
	output	[15:0]	data
);

generate
	if ((DEVICE!=0) & (DEVICE!=1))
begin

Genesis_OS_ROM rom16x1k(
	.clk(clk),
	.addr(addr[10:1]),
	.data(data[15:0])
);

end
endgenerate

generate
	if (DEVICE==0)
begin

xil_blk_mem_gen_rom16x1k rom16x1k(
	.clka(1'b0),
	.ena(1'b0),
	.wea(2'b0),
	.addra(10'b0),
	.dina(16'b0),
	.clkb(clk),
	.enb(1'b1),
	.addrb(addr[10:1]),
	.doutb(data[15:0])
);

end
endgenerate

generate
	if (DEVICE==1)
begin

alt_altsyncram_rom16x1k rom16x1k(
	.address(addr[10:1]),
	.clock(clk),
	.q(data[15:0])
);

end
endgenerate

endmodule

