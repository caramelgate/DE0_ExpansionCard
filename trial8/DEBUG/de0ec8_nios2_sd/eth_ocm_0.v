// eth_ocm_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module eth_ocm_0 (
		input  wire [9:0]  av_address,          //     control_port.address
		input  wire        av_chipselect,       //                 .chipselect
		input  wire        av_write,            //                 .write
		input  wire        av_read,             //                 .read
		input  wire [31:0] av_writedata,        //                 .writedata
		output wire [31:0] av_readdata,         //                 .readdata
		output wire        av_waitrequest_n,    //                 .waitrequest_n
		input  wire        av_clk,              //            clock.clk
		input  wire        av_reset,            //                 .reset
		input  wire [31:0] av_tx_readdata,      //        tx_master.readdata
		input  wire        av_tx_waitrequest,   //                 .waitrequest
		input  wire        av_tx_readdatavalid, //                 .readdatavalid
		output wire [31:0] av_tx_address,       //                 .address
		output wire        av_tx_read,          //                 .read
		input  wire        av_rx_waitrequest,   //        rx_master.waitrequest
		output wire [31:0] av_rx_address,       //                 .address
		output wire        av_rx_write,         //                 .write
		output wire [31:0] av_rx_writedata,     //                 .writedata
		output wire [3:0]  av_rx_byteenable,    //                 .byteenable
		input  wire        mtx_clk_pad_i,       //           global.export
		output wire [3:0]  mtxd_pad_o,          //                 .export
		output wire        mtxen_pad_o,         //                 .export
		output wire        mtxerr_pad_o,        //                 .export
		input  wire        mrx_clk_pad_i,       //                 .export
		input  wire [3:0]  mrxd_pad_i,          //                 .export
		input  wire        mrxdv_pad_i,         //                 .export
		input  wire        mrxerr_pad_i,        //                 .export
		input  wire        mcoll_pad_i,         //                 .export
		input  wire        mcrs_pad_i,          //                 .export
		output wire        mdc_pad_o,           //                 .export
		input  wire        md_pad_i,            //                 .export
		output wire        md_pad_o,            //                 .export
		output wire        md_padoe_o,          //                 .export
		output wire        av_irq               // control_port_irq.irq
	);

	eth_ocm #(
		.TOTAL_DESCRIPTORS     (128),
		.TX_FIFO_SIZE_IN_BYTES (128),
		.RX_FIFO_SIZE_IN_BYTES (4096)
	) eth_ocm_0 (
		.av_address          (av_address),          //     control_port.address
		.av_chipselect       (av_chipselect),       //                 .chipselect
		.av_write            (av_write),            //                 .write
		.av_read             (av_read),             //                 .read
		.av_writedata        (av_writedata),        //                 .writedata
		.av_readdata         (av_readdata),         //                 .readdata
		.av_waitrequest_n    (av_waitrequest_n),    //                 .waitrequest_n
		.av_clk              (av_clk),              //            clock.clk
		.av_reset            (av_reset),            //                 .reset
		.av_tx_readdata      (av_tx_readdata),      //        tx_master.readdata
		.av_tx_waitrequest   (av_tx_waitrequest),   //                 .waitrequest
		.av_tx_readdatavalid (av_tx_readdatavalid), //                 .readdatavalid
		.av_tx_address       (av_tx_address),       //                 .address
		.av_tx_read          (av_tx_read),          //                 .read
		.av_rx_waitrequest   (av_rx_waitrequest),   //        rx_master.waitrequest
		.av_rx_address       (av_rx_address),       //                 .address
		.av_rx_write         (av_rx_write),         //                 .write
		.av_rx_writedata     (av_rx_writedata),     //                 .writedata
		.av_rx_byteenable    (av_rx_byteenable),    //                 .byteenable
		.mtx_clk_pad_i       (mtx_clk_pad_i),       //           global.export
		.mtxd_pad_o          (mtxd_pad_o),          //                 .export
		.mtxen_pad_o         (mtxen_pad_o),         //                 .export
		.mtxerr_pad_o        (mtxerr_pad_o),        //                 .export
		.mrx_clk_pad_i       (mrx_clk_pad_i),       //                 .export
		.mrxd_pad_i          (mrxd_pad_i),          //                 .export
		.mrxdv_pad_i         (mrxdv_pad_i),         //                 .export
		.mrxerr_pad_i        (mrxerr_pad_i),        //                 .export
		.mcoll_pad_i         (mcoll_pad_i),         //                 .export
		.mcrs_pad_i          (mcrs_pad_i),          //                 .export
		.mdc_pad_o           (mdc_pad_o),           //                 .export
		.md_pad_i            (md_pad_i),            //                 .export
		.md_pad_o            (md_pad_o),            //                 .export
		.md_padoe_o          (md_padoe_o),          //                 .export
		.av_irq              (av_irq)               // control_port_irq.irq
	);

endmodule
