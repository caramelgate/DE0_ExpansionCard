module spdif_interface(
	wb_clk_i      , // : in  std_logic;   -- wishbone clock
	rxen          , // : in  std_logic;   -- phase detector enable
	spdif         , // : in  std_logic;   -- SPDIF input signal

	spdif_o        , // : out std_logic;   -- SPDIF input signal

	lock          , // : out std_logic;   -- true if locked to spdif input
	lock_evt      , // : out std_logic;   -- lock status change event
	rx_data       , // : out std_logic;   -- recevied data
	rx_data_en    , // : out std_logic;   -- received data enable
	rx_block_start, // : out std_logic;   -- start-of-block pulse
	rx_frame_start, // : out std_logic;   -- start-of-frame pulse
	rx_channel_a  , // : out std_logic;   -- 1 if channel A frame is recevied
	rx_error      , // : out std_logic;   -- signal error was detected
	ud_a_en       , // : out std_logic;   -- user data ch. A enable
	ud_b_en       , // : out std_logic;   -- user data ch. B enable
	cs_a_en       , // : out std_logic;   -- channel status ch. A enable
	cs_b_en       , // : out std_logic;   -- channel status ch. B enable

	wr_en,          // : out 
	wr_addr ,       // : out 
	wr_data_lch ,   // : out 
	wr_data_rch ,   // : out 
	stat_paritya,   // : out 
	stat_parityb,   // : out 
	stat_lsbf,      // : out 
	stat_hsbf       // : out 

);

parameter  [31:0]  data_width =16;
parameter  [31:0]  addr_width =3;
    
	input	wb_clk_i;
	input	rxen;
	input	spdif;

	output	spdif_o;

	output	lock;
	output	lock_evt;
	output	rx_data;
	output	rx_data_en;
	output	rx_block_start;
	output	rx_frame_start;
	output	rx_channel_a  ;
	output	rx_error      ;
	output	ud_a_en       ;
	output	ud_b_en       ;
	output	cs_a_en       ;
	output	cs_b_en       ;

	output	wr_en;
	output	[(addr_width - 2):0]  wr_addr ;
	output	[(data_width - 1):0]  wr_data_lch ;
	output	[(data_width - 1):0]  wr_data_rch ;
	output	stat_paritya;
	output	stat_parityb;
	output	stat_lsbf;
	output	stat_hsbf;

	wire	det_lock;
	wire	det_lock_evt;
	wire	det_rx_data;
	wire	det_rx_data_en;
	wire	det_rx_block_start;
	wire	det_rx_frame_start;
	wire	det_rx_channel_a;
	wire	det_rx_error;
	wire	det_ud_a_en;
	wire	det_ud_b_en;
	wire	det_cs_a_en;
	wire	det_cs_b_en;

	wire	det_wr_en;
	wire	[(addr_width - 2):0]  det_wr_addr ;
	wire	[(data_width - 1):0]  det_wr_data ;
	wire	[(data_width - 1):0]  det_wr_data_lch ;
	wire	[(data_width - 1):0]  det_wr_data_rch ;
	wire	det_stat_paritya;
	wire	det_stat_parityb;
	wire	det_stat_lsbf;
	wire	det_stat_hsbf;


	reg		[8:0] spdif_r;

	reg		rx_data_en_r;
	reg		rx_block_start_r;
	reg		rx_frame_start_r;

	reg		det_wr_en_r;
	reg		[(data_width - 1):0]  det_wr_data_lch_r ;
	reg		[(data_width - 1):0]  det_wr_data_rch_r ;

	assign spdif_o=spdif_r[8];

	assign lock=det_lock;
	assign lock_evt=det_lock_evt;
	assign rx_data=det_rx_data;
	assign rx_data_en=rx_data_en_r;
	assign rx_block_start=rx_block_start_r;
	assign rx_frame_start=rx_frame_start_r;
	assign rx_channel_a=det_rx_channel_a;
	assign rx_error=det_rx_error;
	assign ud_a_en=det_ud_a_en;
	assign ud_b_en=det_ud_b_en;
	assign cs_a_en=det_cs_a_en;
	assign cs_b_en=det_cs_b_en;


	assign wr_en=det_wr_en_r;
	assign wr_addr=det_wr_addr;
	assign wr_data_lch=det_wr_data_lch_r;
	assign wr_data_rch=det_wr_data_rch_r;
	assign stat_paritya=det_stat_paritya;
	assign stat_parityb=det_stat_parityb;
	assign stat_lsbf=det_stat_lsbf;
	assign stat_hsbf=det_stat_hsbf;


	always @(posedge wb_clk_i or negedge rxen)
	begin
		if (rxen==1'b0)
			begin
				spdif_r <= 9'b0;
				rx_data_en_r <= 1'b0;
				rx_block_start_r <= 1'b0;
				rx_frame_start_r <= 1'b0;
				det_wr_en_r <= 1'b0;
				det_wr_data_lch_r <= 0;
				det_wr_data_rch_r <= 0;
			end
		else
			begin
				spdif_r[3:0] <= {spdif_r[2:0],spdif};
				spdif_r[7:4] <=
						({spdif_r[8],spdif_r[3]}==2'b00) ? 4'b0 :
						({spdif_r[8],spdif_r[3]}==2'b01) ? spdif_r[7:4]+4'b01 :
						({spdif_r[8],spdif_r[3]}==2'b10) ? spdif_r[7:4]+4'b01 :
						({spdif_r[8],spdif_r[3]}==2'b11) ? 4'b0 :
						4'b0;
				spdif_r[8] <=
						(spdif_r[8]==1'b0) & (spdif_r[5:4]==2'b11) ? 1'b1 :
						(spdif_r[8]==1'b0) & (spdif_r[5:4]!=2'b11) ? 1'b0 :
						(spdif_r[8]==1'b1) & (spdif_r[5:4]==2'b11) ? 1'b0 :
						(spdif_r[8]==1'b1) & (spdif_r[5:4]!=2'b11) ? 1'b1 :
						spdif_r[8];
				rx_data_en_r <= (det_rx_data_en==1'b1) ? !rx_data_en_r : rx_data_en_r;
				rx_block_start_r <= (det_rx_block_start==1'b1) ? !rx_block_start_r : rx_block_start_r;
				rx_frame_start_r <= (det_rx_frame_start==1'b1) ? !rx_frame_start_r : rx_frame_start_r;
				det_wr_en_r <= (det_wr_en==1'b1) & (det_wr_addr[0]==1'b1) ? !det_wr_en_r : det_wr_en_r;
				det_wr_data_lch_r <= (det_wr_en==1'b1) & (det_wr_addr[0]==1'b0) ? det_wr_data : det_wr_data_lch_r;
				det_wr_data_rch_r <= (det_wr_en==1'b1) & (det_wr_addr[0]==1'b1) ? det_wr_data : det_wr_data_rch_r;
			end
	end

rx_phase_det rx_phase_det(
	.wb_clk_i       (wb_clk_i       ),
	.rxen           (rxen          ),
	.spdif          (spdif_r[8]    ),
	.lock           (det_lock          ),
	.lock_evt       (det_lock_evt      ),
	.rx_data        (det_rx_data       ),
	.rx_data_en     (det_rx_data_en    ),
	.rx_block_start (det_rx_block_start),
	.rx_frame_start (det_rx_frame_start),
	.rx_channel_a   (det_rx_channel_a  ),
	.rx_error       (det_rx_error      ),
	.ud_a_en        (det_ud_a_en       ),
	.ud_b_en        (det_ud_b_en       ),
	.cs_a_en        (det_cs_a_en       ),
	.cs_b_en        (det_cs_b_en       )
);


rx_decode rx_decode(
	.wb_clk_i(wb_clk_i),
	.conf_rxen(rxen),
	.conf_sample(1'b1),
	.conf_valid(1'b1),
	.conf_mode(4'b0),
	.conf_blken(1'b1),
	.conf_valen(1'b1),
	.conf_useren(1'b1),
	.conf_staten(1'b1),
	.conf_paren(1'b1),
	.lock(det_lock),
	.rx_data(det_rx_data),
	.rx_data_en(det_rx_data_en),
	.rx_block_start(det_rx_block_start),
	.rx_frame_start(det_rx_frame_start),
	.rx_channel_a(det_rx_channel_a),
	.wr_en(det_wr_en),
	.wr_addr(det_wr_addr),
	.wr_data(det_wr_data),
	.stat_paritya(det_stat_paritya),
	.stat_parityb(det_stat_parityb),
	.stat_lsbf(det_stat_lsbf),
	.stat_hsbf(det_stat_hsbf)
);

endmodule