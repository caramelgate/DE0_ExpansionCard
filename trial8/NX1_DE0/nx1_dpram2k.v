//------------------------------------------------------------------------------
//
//	nx1_dpram2k.v : ese x1 module
//
//  LICENSE : "as-is"
//  TakeshiNagashima(T.NG) caramelgete@gmail.com
//------------------------------------------------------------------------------
//  2014/jan/10 release 0.1  preview
//
//------------------------------------------------------------------------------

module nx1_dpram2k #(
	parameter def_DEVICE=0		// 0=xilinx sp3 1=altera cyclone
) (
	input			CCLK,
	input	[10:0]	CA,
	input	[7:0]	CDI,
	output	[7:0]	CDO,
	input			CCS,
	input			CWE,
	input			CRD,
	input			VCLK,
	input	[10:0]	VA,
	output	[7:0]	VDO
);

nx1_dpram2k8 #(
	.def_DEVICE(def_DEVICE)		// 0=xilinx sp3 1=altera cyclone
) dpram2k8 (
	.ACLK(CCLK),
	.AA(CA),
	.AI(CDI),
	.AO(CDO),
	.ACS(CCS),
	.AWE(CWE),
	.BCLK(VCLK),
	.BA(VA),
	.BI(8'h00),
	.BO(VDO),
	.BCS(1'b1),
	.BWE(1'b0)
);

endmodule
