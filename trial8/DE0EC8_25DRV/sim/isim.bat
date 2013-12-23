REM compile all of the files

vlogcomp -work work "./220model.v"
vlogcomp -work work "./altera_mf.v"

vlogcomp -work work "../alt_altpll_50x54x135.v"
vlogcomp -work work "../alt_altsyncram_8x8k.v"
vlogcomp -work work "../alt_altsyncram_16x4k.v"
vlogcomp -work work "../alt_altsyncram_dp128x32.v"
vlogcomp -work work "../alt_altsyncram_dp512x9.v"
vlogcomp -work work "../alt_altsyncram_dp512x18.v"
vlogcomp -work work "../alt_altsyncram_rom16x1k.v"
vlogcomp -work work "../alt_altsyncram_rom16x8k.v"
vlogcomp -work work "../alt_altddio_bidir.v"
vlogcomp -work work "../alt_altddio_out.v"

vlogcomp -work work "../alt_dvi.v"
vlogcomp -work work "../dvi_data_enc.v"
vlogcomp -work work "../alt_dvi_out_x4_raw.v"
vlogcomp -work work "../sdoenc.v"

vlogcomp -work work %XILINX%\verilog\src\glbl.v
vlogcomp -work work %XILINX%\verilog\src\XilinxCoreLib\BLK_MEM_GEN_V7_1.v
rem vlogcomp -work work %XILINX%\verilog\src\unisims\RAMB16_S36_S36.v

vhpcomp -work work "../sn76489/sn76489_comp_pack-p.vhd"
vhpcomp -work work "../sn76489/sn76489_attenuator.vhd"
vhpcomp -work work "../sn76489/sn76489_tone.vhd"
vhpcomp -work work "../sn76489/sn76489_noise.vhd"
vhpcomp -work work "../sn76489/sn76489_latch_ctrl.vhd"
vhpcomp -work work "../sn76489/sn76489_clock_div.vhd"
vhpcomp -work work "../sn76489/sn76489_top.vhd"

vlogcomp -work work "./xil_blk_mem_gen_v7_1_dp128x32.v"
vlogcomp -work work "./xil_blk_mem_gen_v7_1_dp512x9.v"
vlogcomp -work work "./xil_blk_mem_gen_v7_1_dp512x18.v"
vlogcomp -work work "./xil_blk_mem_gen_rom16x1k.v"
vlogcomp -work work "./xil_clk_wiz_v3_6_100x54.v"
vlogcomp -work work "./xil_blk_mem_gen_16x4k.v"

vhpcomp -work work "../src/TG68_fast.vhd"
vhpcomp -work work "../src/TG68.vhd"
vhpcomp -work work "../src/T80/T80_Pack.vhd"
vhpcomp -work work "../src/T80/T80_RegX.vhd"
vhpcomp -work work "../src/T80/T80_MCode.vhd"
vhpcomp -work work "../src/T80/T80_ALU.vhd"
vhpcomp -work work "../src/T80/T80.vhd"
vhpcomp -work work "../src/T80/T80se.vhd"

vlogcomp -work work "../Genesis_OS_ROM.v"
vlogcomp -work work "../gen_arb.v"
vlogcomp -work work "../os_rom.v"
vlogcomp -work work "../gen_vdp.v"
vlogcomp -work work "../gen_io.v"
vlogcomp -work work "../gen_fm8.v"
vlogcomp -work work "../mg_sdr.v"
vlogcomp -work work "../mg_arb8.v"
vlogcomp -work work "../gen_top8.v"
vlogcomp -work work "../dac9f.v"
vlogcomp -work work "../de0ec8_25drv.v"
vlogcomp -work work "../sp3a_xy32.v"

vlogcomp -work work "./sim_tb_top.v"

vlogcomp -work work "./xil_blk_mem_gen_16x16k.v"

REM compile and link source files
rem fuse work.sim_tb_top work.glbl -L unisims_ver -L secureip -o gen_top.exe
fuse work.sim_tb_top work.glbl -L unisims_ver -L secureip -o gen_top.exe

REM set BATCH_MODE=0 to run simulation in GUI mode
set /a BATCH_MODE=0

if %BATCH_MODE% == 1 (goto :batchmode)

REM run the simulation in GUI mode
rem demo_tb.exe -gui -view wave.wcfg -wdb wave_isim -tclbatch isim_cmd.tcl
gen_top.exe -gui -view wave.wcfg -wdb wave_isim 
goto :eof

:batchmode

REM run the simulation in batch mode
gen_top.exe -wdb wave_isim -tclbatch isim_cmd.tcl

