//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_jtag_debug_module_arbitrator (
                                            // inputs:
                                             clk,
                                             cpu_0_data_master_address_to_slave,
                                             cpu_0_data_master_byteenable,
                                             cpu_0_data_master_debugaccess,
                                             cpu_0_data_master_read,
                                             cpu_0_data_master_waitrequest,
                                             cpu_0_data_master_write,
                                             cpu_0_data_master_writedata,
                                             cpu_0_instruction_master_address_to_slave,
                                             cpu_0_instruction_master_latency_counter,
                                             cpu_0_instruction_master_read,
                                             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                             cpu_0_jtag_debug_module_readdata,
                                             cpu_0_jtag_debug_module_resetrequest,
                                             reset_n,

                                            // outputs:
                                             cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_jtag_debug_module_address,
                                             cpu_0_jtag_debug_module_begintransfer,
                                             cpu_0_jtag_debug_module_byteenable,
                                             cpu_0_jtag_debug_module_chipselect,
                                             cpu_0_jtag_debug_module_debugaccess,
                                             cpu_0_jtag_debug_module_readdata_from_sa,
                                             cpu_0_jtag_debug_module_reset_n,
                                             cpu_0_jtag_debug_module_resetrequest_from_sa,
                                             cpu_0_jtag_debug_module_write,
                                             cpu_0_jtag_debug_module_writedata,
                                             d1_cpu_0_jtag_debug_module_end_xfer
                                          )
;

  output           cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  output  [  8: 0] cpu_0_jtag_debug_module_address;
  output           cpu_0_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_0_jtag_debug_module_byteenable;
  output           cpu_0_jtag_debug_module_chipselect;
  output           cpu_0_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  output           cpu_0_jtag_debug_module_reset_n;
  output           cpu_0_jtag_debug_module_resetrequest_from_sa;
  output           cpu_0_jtag_debug_module_write;
  output  [ 31: 0] cpu_0_jtag_debug_module_writedata;
  output           d1_cpu_0_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_debugaccess;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 27: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata;
  input            cpu_0_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_allgrants;
  wire             cpu_0_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_0_jtag_debug_module_any_bursting_master_saved_grant;
  wire             cpu_0_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_0_jtag_debug_module_arb_addend;
  wire             cpu_0_jtag_debug_module_arb_counter_enable;
  reg     [  2: 0] cpu_0_jtag_debug_module_arb_share_counter;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_counter_next_value;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_winner;
  wire             cpu_0_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_0_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_0_jtag_debug_module_begins_xfer;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_0_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_0_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire             cpu_0_jtag_debug_module_end_xfer;
  wire             cpu_0_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_0_jtag_debug_module_grant_vector;
  wire             cpu_0_jtag_debug_module_in_a_read_cycle;
  wire             cpu_0_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_0_jtag_debug_module_master_qreq_vector;
  wire             cpu_0_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  reg              cpu_0_jtag_debug_module_reg_firsttransfer;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_0_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_0_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_0_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_0_jtag_debug_module_unreg_firsttransfer;
  wire             cpu_0_jtag_debug_module_waits_for_read;
  wire             cpu_0_jtag_debug_module_waits_for_write;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  reg              d1_cpu_0_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
  wire    [ 27: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master;
  wire    [ 27: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master;
  wire             wait_for_cpu_0_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cpu_0_jtag_debug_module_end_xfer;
    end


  assign cpu_0_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  //assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata;

  assign cpu_0_data_master_requests_cpu_0_jtag_debug_module = ({cpu_0_data_master_address_to_slave[27 : 11] , 11'b0} == 28'h4000000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_0_jtag_debug_module_arb_share_set_values = 1;

  //cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_0_jtag_debug_module_non_bursting_master_requests = cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module |
    cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign cpu_0_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_share_counter_next_value = cpu_0_jtag_debug_module_firsttransfer ? (cpu_0_jtag_debug_module_arb_share_set_values - 1) : |cpu_0_jtag_debug_module_arb_share_counter ? (cpu_0_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_0_jtag_debug_module_allgrants = (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector) |
    (|cpu_0_jtag_debug_module_grant_vector);

  //cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_end_xfer = ~(cpu_0_jtag_debug_module_waits_for_read | cpu_0_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_end_xfer & (~cpu_0_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & cpu_0_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests);

  //cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_0_jtag_debug_module_arb_counter_enable)
          cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_0_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests))
          cpu_0_jtag_debug_module_slavearbiterlockenable <= |cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_0_jtag_debug_module_slavearbiterlockenable2 = |cpu_0_jtag_debug_module_arb_share_counter_next_value;

  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_0_jtag_debug_module_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_data_master_requests_cpu_0_jtag_debug_module & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_0_jtag_debug_module_writedata = cpu_0_data_master_writedata;

  assign cpu_0_instruction_master_requests_cpu_0_jtag_debug_module = (({cpu_0_instruction_master_address_to_slave[27 : 11] , 11'b0} == 28'h4000000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  assign cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_instruction_master_requests_cpu_0_jtag_debug_module & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read & ~cpu_0_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[0];

  //cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[0] && cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[1];

  //cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[1] && cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_double_vector = {cpu_0_jtag_debug_module_master_qreq_vector, cpu_0_jtag_debug_module_master_qreq_vector} & ({~cpu_0_jtag_debug_module_master_qreq_vector, ~cpu_0_jtag_debug_module_master_qreq_vector} + cpu_0_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_0_jtag_debug_module_arb_winner = (cpu_0_jtag_debug_module_allow_new_arb_cycle & | cpu_0_jtag_debug_module_grant_vector) ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_0_jtag_debug_module_allow_new_arb_cycle)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= |cpu_0_jtag_debug_module_grant_vector ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_0_jtag_debug_module_grant_vector = {(cpu_0_jtag_debug_module_chosen_master_double_vector[1] | cpu_0_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_0_jtag_debug_module_chosen_master_double_vector[0] | cpu_0_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_rot_left = (cpu_0_jtag_debug_module_arb_winner << 1) ? (cpu_0_jtag_debug_module_arb_winner << 1) : 1;

  //cpu_0/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_0_jtag_debug_module_grant_vector)
          cpu_0_jtag_debug_module_arb_addend <= cpu_0_jtag_debug_module_end_xfer? cpu_0_jtag_debug_module_chosen_master_rot_left : cpu_0_jtag_debug_module_grant_vector;
    end


  assign cpu_0_jtag_debug_module_begintransfer = cpu_0_jtag_debug_module_begins_xfer;
  //cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_reset_n = reset_n;

  //assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest;

  assign cpu_0_jtag_debug_module_chipselect = cpu_0_data_master_granted_cpu_0_jtag_debug_module | cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  //cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_firsttransfer = cpu_0_jtag_debug_module_begins_xfer ? cpu_0_jtag_debug_module_unreg_firsttransfer : cpu_0_jtag_debug_module_reg_firsttransfer;

  //cpu_0_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_unreg_firsttransfer = ~(cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_jtag_debug_module_any_continuerequest);

  //cpu_0_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (cpu_0_jtag_debug_module_begins_xfer)
          cpu_0_jtag_debug_module_reg_firsttransfer <= cpu_0_jtag_debug_module_unreg_firsttransfer;
    end


  //cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_0_jtag_debug_module_beginbursttransfer_internal = cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_0_jtag_debug_module_arbitration_holdoff_internal = cpu_0_jtag_debug_module_begins_xfer & cpu_0_jtag_debug_module_firsttransfer;

  //cpu_0_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_0_jtag_debug_module_write = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //cpu_0_jtag_debug_module_address mux, which is an e_mux
  assign cpu_0_jtag_debug_module_address = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master >> 2) :
    (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master >> 2);

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master = cpu_0_instruction_master_address_to_slave;
  //d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_0_jtag_debug_module_end_xfer <= 1;
      else 
        d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end


  //cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_read = cpu_0_jtag_debug_module_in_a_read_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_read_cycle = (cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_0_jtag_debug_module_in_a_read_cycle;

  //cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_write = cpu_0_jtag_debug_module_in_a_write_cycle & 0;

  //cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_write_cycle = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_0_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_0_jtag_debug_module_counter = 0;
  //cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_0_jtag_debug_module_byteenable = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign cpu_0_jtag_debug_module_debugaccess = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cpu_0_jtag_debug_module + cpu_0_instruction_master_granted_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module + cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_data_master_arbitrator (
                                      // inputs:
                                       cfi_flash_0_s1_wait_counter_eq_0,
                                       cfi_flash_0_s1_wait_counter_eq_1,
                                       clk,
                                       cpu_0_data_master_address,
                                       cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                       cpu_0_data_master_byteenable_sdram_0_s1,
                                       cpu_0_data_master_granted_cfi_flash_0_s1,
                                       cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_granted_igor_mac_control_port,
                                       cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_granted_sdram_0_s1,
                                       cpu_0_data_master_granted_spi_0_spi_control_port,
                                       cpu_0_data_master_granted_timer_0_s1,
                                       cpu_0_data_master_granted_timer_1_s1,
                                       cpu_0_data_master_granted_uart_0_s1,
                                       cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                       cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_qualified_request_igor_mac_control_port,
                                       cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_qualified_request_sdram_0_s1,
                                       cpu_0_data_master_qualified_request_spi_0_spi_control_port,
                                       cpu_0_data_master_qualified_request_timer_0_s1,
                                       cpu_0_data_master_qualified_request_timer_1_s1,
                                       cpu_0_data_master_qualified_request_uart_0_s1,
                                       cpu_0_data_master_read,
                                       cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                       cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_read_data_valid_igor_mac_control_port,
                                       cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                       cpu_0_data_master_read_data_valid_spi_0_spi_control_port,
                                       cpu_0_data_master_read_data_valid_timer_0_s1,
                                       cpu_0_data_master_read_data_valid_timer_1_s1,
                                       cpu_0_data_master_read_data_valid_uart_0_s1,
                                       cpu_0_data_master_requests_cfi_flash_0_s1,
                                       cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_requests_igor_mac_control_port,
                                       cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_requests_sdram_0_s1,
                                       cpu_0_data_master_requests_spi_0_spi_control_port,
                                       cpu_0_data_master_requests_timer_0_s1,
                                       cpu_0_data_master_requests_timer_1_s1,
                                       cpu_0_data_master_requests_uart_0_s1,
                                       cpu_0_data_master_write,
                                       cpu_0_data_master_writedata,
                                       cpu_0_jtag_debug_module_readdata_from_sa,
                                       d1_cpu_0_jtag_debug_module_end_xfer,
                                       d1_igor_mac_control_port_end_xfer,
                                       d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                       d1_sdram_0_s1_end_xfer,
                                       d1_spi_0_spi_control_port_end_xfer,
                                       d1_timer_0_s1_end_xfer,
                                       d1_timer_1_s1_end_xfer,
                                       d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                       d1_uart_0_s1_end_xfer,
                                       igor_mac_control_port_irq_from_sa,
                                       igor_mac_control_port_readdata_from_sa,
                                       igor_mac_control_port_waitrequest_n_from_sa,
                                       incoming_tri_state_bridge_0_data_with_Xs_converted_to_0,
                                       jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                       registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                       reset_n,
                                       sdram_0_s1_readdata_from_sa,
                                       sdram_0_s1_waitrequest_from_sa,
                                       spi_0_spi_control_port_irq_from_sa,
                                       spi_0_spi_control_port_readdata_from_sa,
                                       timer_0_s1_irq_from_sa,
                                       timer_0_s1_readdata_from_sa,
                                       timer_1_s1_irq_from_sa,
                                       timer_1_s1_readdata_from_sa,
                                       uart_0_s1_irq_from_sa,
                                       uart_0_s1_readdata_from_sa,

                                      // outputs:
                                       cpu_0_data_master_address_to_slave,
                                       cpu_0_data_master_dbs_address,
                                       cpu_0_data_master_dbs_write_16,
                                       cpu_0_data_master_dbs_write_8,
                                       cpu_0_data_master_irq,
                                       cpu_0_data_master_no_byte_enables_and_last_term,
                                       cpu_0_data_master_readdata,
                                       cpu_0_data_master_waitrequest
                                    )
;

  output  [ 27: 0] cpu_0_data_master_address_to_slave;
  output  [  1: 0] cpu_0_data_master_dbs_address;
  output  [ 15: 0] cpu_0_data_master_dbs_write_16;
  output  [  7: 0] cpu_0_data_master_dbs_write_8;
  output  [ 31: 0] cpu_0_data_master_irq;
  output           cpu_0_data_master_no_byte_enables_and_last_term;
  output  [ 31: 0] cpu_0_data_master_readdata;
  output           cpu_0_data_master_waitrequest;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input            cfi_flash_0_s1_wait_counter_eq_1;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address;
  input            cpu_0_data_master_byteenable_cfi_flash_0_s1;
  input   [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  input            cpu_0_data_master_granted_cfi_flash_0_s1;
  input            cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_granted_igor_mac_control_port;
  input            cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_granted_sdram_0_s1;
  input            cpu_0_data_master_granted_spi_0_spi_control_port;
  input            cpu_0_data_master_granted_timer_0_s1;
  input            cpu_0_data_master_granted_timer_1_s1;
  input            cpu_0_data_master_granted_uart_0_s1;
  input            cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_qualified_request_igor_mac_control_port;
  input            cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_qualified_request_sdram_0_s1;
  input            cpu_0_data_master_qualified_request_spi_0_spi_control_port;
  input            cpu_0_data_master_qualified_request_timer_0_s1;
  input            cpu_0_data_master_qualified_request_timer_1_s1;
  input            cpu_0_data_master_qualified_request_uart_0_s1;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_read_data_valid_igor_mac_control_port;
  input            cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_read_data_valid_spi_0_spi_control_port;
  input            cpu_0_data_master_read_data_valid_timer_0_s1;
  input            cpu_0_data_master_read_data_valid_timer_1_s1;
  input            cpu_0_data_master_read_data_valid_uart_0_s1;
  input            cpu_0_data_master_requests_cfi_flash_0_s1;
  input            cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_requests_igor_mac_control_port;
  input            cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_requests_sdram_0_s1;
  input            cpu_0_data_master_requests_spi_0_spi_control_port;
  input            cpu_0_data_master_requests_timer_0_s1;
  input            cpu_0_data_master_requests_timer_1_s1;
  input            cpu_0_data_master_requests_uart_0_s1;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_igor_mac_control_port_end_xfer;
  input            d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_spi_0_spi_control_port_end_xfer;
  input            d1_timer_0_s1_end_xfer;
  input            d1_timer_1_s1_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input            d1_uart_0_s1_end_xfer;
  input            igor_mac_control_port_irq_from_sa;
  input   [ 31: 0] igor_mac_control_port_readdata_from_sa;
  input            igor_mac_control_port_waitrequest_n_from_sa;
  input   [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  input            jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  input            registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;
  input            spi_0_spi_control_port_irq_from_sa;
  input   [ 15: 0] spi_0_spi_control_port_readdata_from_sa;
  input            timer_0_s1_irq_from_sa;
  input   [ 15: 0] timer_0_s1_readdata_from_sa;
  input            timer_1_s1_irq_from_sa;
  input   [ 15: 0] timer_1_s1_readdata_from_sa;
  input            uart_0_s1_irq_from_sa;
  input   [ 15: 0] uart_0_s1_readdata_from_sa;

  wire    [ 27: 0] cpu_0_data_master_address_to_slave;
  reg     [  1: 0] cpu_0_data_master_dbs_address;
  wire    [  1: 0] cpu_0_data_master_dbs_increment;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire    [ 31: 0] cpu_0_data_master_irq;
  reg              cpu_0_data_master_no_byte_enables_and_last_term;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_run;
  reg              cpu_0_data_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  reg     [  7: 0] dbs_8_reg_segment_0;
  reg     [  7: 0] dbs_8_reg_segment_1;
  reg     [  7: 0] dbs_8_reg_segment_2;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             last_dbs_term_and_run;
  wire    [  1: 0] next_dbs_address;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_8_reg_segment_2;
  wire    [ 31: 0] p1_registered_cpu_0_data_master_readdata;
  wire             pre_dbs_count_enable;
  wire             r_0;
  wire             r_1;
  reg     [ 31: 0] registered_cpu_0_data_master_readdata;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) & (cpu_0_data_master_granted_cpu_0_jtag_debug_module | ~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_igor_mac_control_port | ~cpu_0_data_master_requests_igor_mac_control_port) & ((~cpu_0_data_master_qualified_request_igor_mac_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & igor_mac_control_port_waitrequest_n_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_igor_mac_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & igor_mac_control_port_waitrequest_n_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave) & ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_sdram_0_s1 | (cpu_0_data_master_read_data_valid_sdram_0_s1 & cpu_0_data_master_dbs_address[1]) | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1 & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_sdram_0_s1) & (cpu_0_data_master_granted_sdram_0_s1 | ~cpu_0_data_master_qualified_request_sdram_0_s1) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_read | (cpu_0_data_master_read_data_valid_sdram_0_s1 & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_write | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1 & ((~cpu_0_data_master_qualified_request_spi_0_spi_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write))));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_data_master_run = r_0 & r_1;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~cpu_0_data_master_qualified_request_spi_0_spi_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_requests_timer_0_s1) & ((~cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_timer_1_s1 | ~cpu_0_data_master_requests_timer_1_s1) & ((~cpu_0_data_master_qualified_request_timer_1_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_timer_1_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) | ((cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1 & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0])) | ~cpu_0_data_master_requests_cfi_flash_0_s1)) & (cpu_0_data_master_granted_cfi_flash_0_s1 | ~cpu_0_data_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_read | (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_write | (1 & cfi_flash_0_s1_wait_counter_eq_1 & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_write))) & 1 & ((~cpu_0_data_master_qualified_request_uart_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_uart_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write))));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_data_master_address_to_slave = {cpu_0_data_master_address[27 : 24],
    1'b0,
    cpu_0_data_master_address[22 : 0]};

  //cpu_0/data_master readdata mux, which is an e_mux
  assign cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_requests_cpu_0_jtag_debug_module}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_igor_mac_control_port}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_sdram_0_s1}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_spi_0_spi_control_port}} | spi_0_spi_control_port_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_timer_0_s1}} | timer_0_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_timer_1_s1}} | timer_1_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_cfi_flash_0_s1}} | {incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7 : 0],
    dbs_8_reg_segment_2,
    dbs_8_reg_segment_1,
    dbs_8_reg_segment_0}) &
    ({32 {~cpu_0_data_master_requests_uart_0_s1}} | uart_0_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_waitrequest <= ~0;
      else 
        cpu_0_data_master_waitrequest <= ~((~(cpu_0_data_master_read | cpu_0_data_master_write))? 0: (cpu_0_data_master_run & cpu_0_data_master_waitrequest));
    end


  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_cpu_0_data_master_readdata <= 0;
      else 
        registered_cpu_0_data_master_readdata <= p1_registered_cpu_0_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_requests_igor_mac_control_port}} | igor_mac_control_port_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave}} | jtag_uart_0_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //irq assign, which is an e_assign
  assign cpu_0_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    igor_mac_control_port_irq_from_sa,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    spi_0_spi_control_port_irq_from_sa,
    1'b0,
    timer_1_s1_irq_from_sa,
    timer_0_s1_irq_from_sa,
    uart_0_s1_irq_from_sa,
    jtag_uart_0_avalon_jtag_slave_irq_from_sa,
    1'b0};

  //no_byte_enables_and_last_term, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_no_byte_enables_and_last_term <= 0;
      else 
        cpu_0_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end


  //compute the last dbs term, which is an e_mux
  assign last_dbs_term_and_run = (cpu_0_data_master_requests_sdram_0_s1)? (((cpu_0_data_master_dbs_address == 2'b10) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1)) :
    (((cpu_0_data_master_dbs_address == 2'b11) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1));

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_sdram_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1)) |
    cpu_0_data_master_read_data_valid_sdram_0_s1 |
    (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_cfi_flash_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1)) |
    cpu_0_data_master_read_data_valid_cfi_flash_0_s1 |
    ((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sdram_0_s1_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_0_data_master_dbs_write_16 = (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    cpu_0_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign cpu_0_data_master_dbs_increment = (cpu_0_data_master_requests_sdram_0_s1)? 2 :
    (cpu_0_data_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_data_master_dbs_address + cpu_0_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable &
    (~(cpu_0_data_master_requests_sdram_0_s1 & ~cpu_0_data_master_waitrequest));

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_data_master_dbs_address <= next_dbs_address;
    end


  //input to dbs-8 stored 0, which is an e_mux
  assign p1_dbs_8_reg_segment_0 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 0))
          dbs_8_reg_segment_0 <= p1_dbs_8_reg_segment_0;
    end


  //input to dbs-8 stored 1, which is an e_mux
  assign p1_dbs_8_reg_segment_1 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_1 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 1))
          dbs_8_reg_segment_1 <= p1_dbs_8_reg_segment_1;
    end


  //input to dbs-8 stored 2, which is an e_mux
  assign p1_dbs_8_reg_segment_2 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_2 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 2))
          dbs_8_reg_segment_2 <= p1_dbs_8_reg_segment_2;
    end


  //mux write dbs 2, which is an e_mux
  assign cpu_0_data_master_dbs_write_8 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_writedata[7 : 0] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_writedata[15 : 8] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_writedata[23 : 16] :
    cpu_0_data_master_writedata[31 : 24];


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_instruction_master_arbitrator (
                                             // inputs:
                                              cfi_flash_0_s1_wait_counter_eq_0,
                                              cfi_flash_0_s1_wait_counter_eq_1,
                                              clk,
                                              cpu_0_instruction_master_address,
                                              cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                              cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_granted_sdram_0_s1,
                                              cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                              cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                              cpu_0_instruction_master_read,
                                              cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                              cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                              cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                              cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_requests_sdram_0_s1,
                                              cpu_0_jtag_debug_module_readdata_from_sa,
                                              d1_cpu_0_jtag_debug_module_end_xfer,
                                              d1_sdram_0_s1_end_xfer,
                                              d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                              incoming_tri_state_bridge_0_data,
                                              reset_n,
                                              sdram_0_s1_readdata_from_sa,
                                              sdram_0_s1_waitrequest_from_sa,

                                             // outputs:
                                              cpu_0_instruction_master_address_to_slave,
                                              cpu_0_instruction_master_dbs_address,
                                              cpu_0_instruction_master_latency_counter,
                                              cpu_0_instruction_master_readdata,
                                              cpu_0_instruction_master_readdatavalid,
                                              cpu_0_instruction_master_waitrequest
                                           )
;

  output  [ 27: 0] cpu_0_instruction_master_address_to_slave;
  output  [  1: 0] cpu_0_instruction_master_dbs_address;
  output  [  1: 0] cpu_0_instruction_master_latency_counter;
  output  [ 31: 0] cpu_0_instruction_master_readdata;
  output           cpu_0_instruction_master_readdatavalid;
  output           cpu_0_instruction_master_waitrequest;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input            cfi_flash_0_s1_wait_counter_eq_1;
  input            clk;
  input   [ 27: 0] cpu_0_instruction_master_address;
  input            cpu_0_instruction_master_granted_cfi_flash_0_s1;
  input            cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_granted_sdram_0_s1;
  input            cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_qualified_request_sdram_0_s1;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_instruction_master_requests_cfi_flash_0_s1;
  input            cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_requests_sdram_0_s1;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input   [  7: 0] incoming_tri_state_bridge_0_data;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 27: 0] cpu_0_instruction_master_address_last_time;
  wire    [ 27: 0] cpu_0_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_0_instruction_master_dbs_address;
  wire    [  1: 0] cpu_0_instruction_master_dbs_increment;
  reg     [  1: 0] cpu_0_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_0_instruction_master_dbs_rdv_counter_inc;
  wire             cpu_0_instruction_master_is_granted_some_slave;
  reg     [  1: 0] cpu_0_instruction_master_latency_counter;
  wire    [  1: 0] cpu_0_instruction_master_next_dbs_rdv_counter;
  reg              cpu_0_instruction_master_read_but_no_slave_selected;
  reg              cpu_0_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_run;
  wire             cpu_0_instruction_master_waitrequest;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_0_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_0_instruction_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) & (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_read | (1 & ~d1_cpu_0_jtag_debug_module_end_xfer & cpu_0_instruction_master_read))) & 1 & (cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_requests_sdram_0_s1) & (cpu_0_instruction_master_granted_sdram_0_s1 | ~cpu_0_instruction_master_qualified_request_sdram_0_s1) & ((~cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_read | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_instruction_master_dbs_address[1]) & cpu_0_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_instruction_master_run = r_0 & r_1;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) & (cpu_0_instruction_master_granted_cfi_flash_0_s1 | ~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_read | (1 & ((cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer)) & (cpu_0_instruction_master_dbs_address[1] & cpu_0_instruction_master_dbs_address[0]) & cpu_0_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_instruction_master_address_to_slave = {cpu_0_instruction_master_address[27 : 26],
    3'b0,
    cpu_0_instruction_master_address[22 : 0]};

  //cpu_0_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_but_no_slave_selected <= 0;
      else 
        cpu_0_instruction_master_read_but_no_slave_selected <= cpu_0_instruction_master_read & cpu_0_instruction_master_run & ~cpu_0_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_0_instruction_master_is_granted_some_slave = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_granted_sdram_0_s1 |
    cpu_0_instruction_master_granted_cfi_flash_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_0_instruction_master_readdatavalid = (cpu_0_instruction_master_read_data_valid_sdram_0_s1 & dbs_rdv_counter_overflow) |
    (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_0_instruction_master_readdatavalid = cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid;

  //cpu_0/instruction_master readdata mux, which is an e_mux
  assign cpu_0_instruction_master_readdata = ({32 {~(cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module & cpu_0_instruction_master_read)}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_instruction_master_read_data_valid_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1}} | {incoming_tri_state_bridge_0_data[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_0_instruction_master_waitrequest = ~cpu_0_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_latency_counter <= 0;
      else 
        cpu_0_instruction_master_latency_counter <= p1_cpu_0_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_0_instruction_master_latency_counter = ((cpu_0_instruction_master_run & cpu_0_instruction_master_read))? latency_load_value :
    (cpu_0_instruction_master_latency_counter)? cpu_0_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {2 {cpu_0_instruction_master_requests_cfi_flash_0_s1}} & 2;

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = sdram_0_s1_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_0_instruction_master_dbs_increment = (cpu_0_instruction_master_requests_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_instruction_master_dbs_address + cpu_0_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_instruction_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_0_instruction_master_next_dbs_rdv_counter = cpu_0_instruction_master_dbs_rdv_counter + cpu_0_instruction_master_dbs_rdv_counter_inc;

  //cpu_0_instruction_master_rdv_inc_mux, which is an e_mux
  assign cpu_0_instruction_master_dbs_rdv_counter_inc = (cpu_0_instruction_master_read_data_valid_sdram_0_s1)? 2 :
    1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_0_instruction_master_read_data_valid_sdram_0_s1 |
    cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_0_instruction_master_dbs_rdv_counter <= cpu_0_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_0_instruction_master_dbs_rdv_counter[1] & ~cpu_0_instruction_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    ((cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end



//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_address_last_time <= 0;
      else 
        cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
    end


  //cpu_0/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_0_instruction_master_waitrequest & (cpu_0_instruction_master_read);
    end


  //cpu_0_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_address != cpu_0_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_last_time <= 0;
      else 
        cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
    end


  //cpu_0_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_read != cpu_0_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module igor_mac_control_port_arbitrator (
                                          // inputs:
                                           clk,
                                           cpu_0_data_master_address_to_slave,
                                           cpu_0_data_master_read,
                                           cpu_0_data_master_waitrequest,
                                           cpu_0_data_master_write,
                                           cpu_0_data_master_writedata,
                                           igor_mac_control_port_irq,
                                           igor_mac_control_port_readdata,
                                           igor_mac_control_port_waitrequest_n,
                                           reset_n,

                                          // outputs:
                                           cpu_0_data_master_granted_igor_mac_control_port,
                                           cpu_0_data_master_qualified_request_igor_mac_control_port,
                                           cpu_0_data_master_read_data_valid_igor_mac_control_port,
                                           cpu_0_data_master_requests_igor_mac_control_port,
                                           d1_igor_mac_control_port_end_xfer,
                                           igor_mac_control_port_address,
                                           igor_mac_control_port_chipselect,
                                           igor_mac_control_port_irq_from_sa,
                                           igor_mac_control_port_read,
                                           igor_mac_control_port_readdata_from_sa,
                                           igor_mac_control_port_reset,
                                           igor_mac_control_port_waitrequest_n_from_sa,
                                           igor_mac_control_port_write,
                                           igor_mac_control_port_writedata
                                        )
;

  output           cpu_0_data_master_granted_igor_mac_control_port;
  output           cpu_0_data_master_qualified_request_igor_mac_control_port;
  output           cpu_0_data_master_read_data_valid_igor_mac_control_port;
  output           cpu_0_data_master_requests_igor_mac_control_port;
  output           d1_igor_mac_control_port_end_xfer;
  output  [  9: 0] igor_mac_control_port_address;
  output           igor_mac_control_port_chipselect;
  output           igor_mac_control_port_irq_from_sa;
  output           igor_mac_control_port_read;
  output  [ 31: 0] igor_mac_control_port_readdata_from_sa;
  output           igor_mac_control_port_reset;
  output           igor_mac_control_port_waitrequest_n_from_sa;
  output           igor_mac_control_port_write;
  output  [ 31: 0] igor_mac_control_port_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            igor_mac_control_port_irq;
  input   [ 31: 0] igor_mac_control_port_readdata;
  input            igor_mac_control_port_waitrequest_n;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_igor_mac_control_port;
  wire             cpu_0_data_master_qualified_request_igor_mac_control_port;
  wire             cpu_0_data_master_read_data_valid_igor_mac_control_port;
  wire             cpu_0_data_master_requests_igor_mac_control_port;
  wire             cpu_0_data_master_saved_grant_igor_mac_control_port;
  reg              d1_igor_mac_control_port_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_igor_mac_control_port;
  wire    [  9: 0] igor_mac_control_port_address;
  wire             igor_mac_control_port_allgrants;
  wire             igor_mac_control_port_allow_new_arb_cycle;
  wire             igor_mac_control_port_any_bursting_master_saved_grant;
  wire             igor_mac_control_port_any_continuerequest;
  wire             igor_mac_control_port_arb_counter_enable;
  reg     [  2: 0] igor_mac_control_port_arb_share_counter;
  wire    [  2: 0] igor_mac_control_port_arb_share_counter_next_value;
  wire    [  2: 0] igor_mac_control_port_arb_share_set_values;
  wire             igor_mac_control_port_beginbursttransfer_internal;
  wire             igor_mac_control_port_begins_xfer;
  wire             igor_mac_control_port_chipselect;
  wire             igor_mac_control_port_end_xfer;
  wire             igor_mac_control_port_firsttransfer;
  wire             igor_mac_control_port_grant_vector;
  wire             igor_mac_control_port_in_a_read_cycle;
  wire             igor_mac_control_port_in_a_write_cycle;
  wire             igor_mac_control_port_irq_from_sa;
  wire             igor_mac_control_port_master_qreq_vector;
  wire             igor_mac_control_port_non_bursting_master_requests;
  wire             igor_mac_control_port_read;
  wire    [ 31: 0] igor_mac_control_port_readdata_from_sa;
  reg              igor_mac_control_port_reg_firsttransfer;
  wire             igor_mac_control_port_reset;
  reg              igor_mac_control_port_slavearbiterlockenable;
  wire             igor_mac_control_port_slavearbiterlockenable2;
  wire             igor_mac_control_port_unreg_firsttransfer;
  wire             igor_mac_control_port_waitrequest_n_from_sa;
  wire             igor_mac_control_port_waits_for_read;
  wire             igor_mac_control_port_waits_for_write;
  wire             igor_mac_control_port_write;
  wire    [ 31: 0] igor_mac_control_port_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 27: 0] shifted_address_to_igor_mac_control_port_from_cpu_0_data_master;
  wire             wait_for_igor_mac_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~igor_mac_control_port_end_xfer;
    end


  assign igor_mac_control_port_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_igor_mac_control_port));
  //assign igor_mac_control_port_readdata_from_sa = igor_mac_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign igor_mac_control_port_readdata_from_sa = igor_mac_control_port_readdata;

  assign cpu_0_data_master_requests_igor_mac_control_port = ({cpu_0_data_master_address_to_slave[27 : 12] , 12'b0} == 28'h7004000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign igor_mac_control_port_waitrequest_n_from_sa = igor_mac_control_port_waitrequest_n so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign igor_mac_control_port_waitrequest_n_from_sa = igor_mac_control_port_waitrequest_n;

  //igor_mac_control_port_arb_share_counter set values, which is an e_mux
  assign igor_mac_control_port_arb_share_set_values = 1;

  //igor_mac_control_port_non_bursting_master_requests mux, which is an e_mux
  assign igor_mac_control_port_non_bursting_master_requests = cpu_0_data_master_requests_igor_mac_control_port;

  //igor_mac_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign igor_mac_control_port_any_bursting_master_saved_grant = 0;

  //igor_mac_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign igor_mac_control_port_arb_share_counter_next_value = igor_mac_control_port_firsttransfer ? (igor_mac_control_port_arb_share_set_values - 1) : |igor_mac_control_port_arb_share_counter ? (igor_mac_control_port_arb_share_counter - 1) : 0;

  //igor_mac_control_port_allgrants all slave grants, which is an e_mux
  assign igor_mac_control_port_allgrants = |igor_mac_control_port_grant_vector;

  //igor_mac_control_port_end_xfer assignment, which is an e_assign
  assign igor_mac_control_port_end_xfer = ~(igor_mac_control_port_waits_for_read | igor_mac_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_igor_mac_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_igor_mac_control_port = igor_mac_control_port_end_xfer & (~igor_mac_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //igor_mac_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign igor_mac_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_igor_mac_control_port & igor_mac_control_port_allgrants) | (end_xfer_arb_share_counter_term_igor_mac_control_port & ~igor_mac_control_port_non_bursting_master_requests);

  //igor_mac_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_control_port_arb_share_counter <= 0;
      else if (igor_mac_control_port_arb_counter_enable)
          igor_mac_control_port_arb_share_counter <= igor_mac_control_port_arb_share_counter_next_value;
    end


  //igor_mac_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_control_port_slavearbiterlockenable <= 0;
      else if ((|igor_mac_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_igor_mac_control_port) | (end_xfer_arb_share_counter_term_igor_mac_control_port & ~igor_mac_control_port_non_bursting_master_requests))
          igor_mac_control_port_slavearbiterlockenable <= |igor_mac_control_port_arb_share_counter_next_value;
    end


  //cpu_0/data_master igor_mac/control_port arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = igor_mac_control_port_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //igor_mac_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign igor_mac_control_port_slavearbiterlockenable2 = |igor_mac_control_port_arb_share_counter_next_value;

  //cpu_0/data_master igor_mac/control_port arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = igor_mac_control_port_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //igor_mac_control_port_any_continuerequest at least one master continues requesting, which is an e_assign
  assign igor_mac_control_port_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_igor_mac_control_port = cpu_0_data_master_requests_igor_mac_control_port & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest)) | ((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //igor_mac_control_port_writedata mux, which is an e_mux
  assign igor_mac_control_port_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_igor_mac_control_port = cpu_0_data_master_qualified_request_igor_mac_control_port;

  //cpu_0/data_master saved-grant igor_mac/control_port, which is an e_assign
  assign cpu_0_data_master_saved_grant_igor_mac_control_port = cpu_0_data_master_requests_igor_mac_control_port;

  //allow new arb cycle for igor_mac/control_port, which is an e_assign
  assign igor_mac_control_port_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign igor_mac_control_port_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign igor_mac_control_port_master_qreq_vector = 1;

  //~igor_mac_control_port_reset assignment, which is an e_assign
  assign igor_mac_control_port_reset = ~reset_n;

  assign igor_mac_control_port_chipselect = cpu_0_data_master_granted_igor_mac_control_port;
  //igor_mac_control_port_firsttransfer first transaction, which is an e_assign
  assign igor_mac_control_port_firsttransfer = igor_mac_control_port_begins_xfer ? igor_mac_control_port_unreg_firsttransfer : igor_mac_control_port_reg_firsttransfer;

  //igor_mac_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign igor_mac_control_port_unreg_firsttransfer = ~(igor_mac_control_port_slavearbiterlockenable & igor_mac_control_port_any_continuerequest);

  //igor_mac_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_control_port_reg_firsttransfer <= 1'b1;
      else if (igor_mac_control_port_begins_xfer)
          igor_mac_control_port_reg_firsttransfer <= igor_mac_control_port_unreg_firsttransfer;
    end


  //igor_mac_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign igor_mac_control_port_beginbursttransfer_internal = igor_mac_control_port_begins_xfer;

  //igor_mac_control_port_read assignment, which is an e_mux
  assign igor_mac_control_port_read = cpu_0_data_master_granted_igor_mac_control_port & cpu_0_data_master_read;

  //igor_mac_control_port_write assignment, which is an e_mux
  assign igor_mac_control_port_write = cpu_0_data_master_granted_igor_mac_control_port & cpu_0_data_master_write;

  assign shifted_address_to_igor_mac_control_port_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //igor_mac_control_port_address mux, which is an e_mux
  assign igor_mac_control_port_address = shifted_address_to_igor_mac_control_port_from_cpu_0_data_master >> 2;

  //d1_igor_mac_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_igor_mac_control_port_end_xfer <= 1;
      else 
        d1_igor_mac_control_port_end_xfer <= igor_mac_control_port_end_xfer;
    end


  //igor_mac_control_port_waits_for_read in a cycle, which is an e_mux
  assign igor_mac_control_port_waits_for_read = igor_mac_control_port_in_a_read_cycle & ~igor_mac_control_port_waitrequest_n_from_sa;

  //igor_mac_control_port_in_a_read_cycle assignment, which is an e_assign
  assign igor_mac_control_port_in_a_read_cycle = cpu_0_data_master_granted_igor_mac_control_port & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = igor_mac_control_port_in_a_read_cycle;

  //igor_mac_control_port_waits_for_write in a cycle, which is an e_mux
  assign igor_mac_control_port_waits_for_write = igor_mac_control_port_in_a_write_cycle & ~igor_mac_control_port_waitrequest_n_from_sa;

  //igor_mac_control_port_in_a_write_cycle assignment, which is an e_assign
  assign igor_mac_control_port_in_a_write_cycle = cpu_0_data_master_granted_igor_mac_control_port & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = igor_mac_control_port_in_a_write_cycle;

  assign wait_for_igor_mac_control_port_counter = 0;
  //assign igor_mac_control_port_irq_from_sa = igor_mac_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign igor_mac_control_port_irq_from_sa = igor_mac_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //igor_mac/control_port enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module igor_mac_rx_master_arbitrator (
                                       // inputs:
                                        clk,
                                        d1_nios2_burst_0_upstream_end_xfer,
                                        igor_mac_rx_master_address,
                                        igor_mac_rx_master_burstcount,
                                        igor_mac_rx_master_byteenable,
                                        igor_mac_rx_master_byteenable_nios2_burst_0_upstream,
                                        igor_mac_rx_master_granted_nios2_burst_0_upstream,
                                        igor_mac_rx_master_qualified_request_nios2_burst_0_upstream,
                                        igor_mac_rx_master_requests_nios2_burst_0_upstream,
                                        igor_mac_rx_master_write,
                                        igor_mac_rx_master_writedata,
                                        nios2_burst_0_upstream_waitrequest_from_sa,
                                        reset_n,

                                       // outputs:
                                        igor_mac_rx_master_address_to_slave,
                                        igor_mac_rx_master_dbs_address,
                                        igor_mac_rx_master_dbs_write_16,
                                        igor_mac_rx_master_waitrequest
                                     )
;

  output  [ 31: 0] igor_mac_rx_master_address_to_slave;
  output  [  1: 0] igor_mac_rx_master_dbs_address;
  output  [ 15: 0] igor_mac_rx_master_dbs_write_16;
  output           igor_mac_rx_master_waitrequest;
  input            clk;
  input            d1_nios2_burst_0_upstream_end_xfer;
  input   [ 31: 0] igor_mac_rx_master_address;
  input   [  3: 0] igor_mac_rx_master_burstcount;
  input   [  3: 0] igor_mac_rx_master_byteenable;
  input   [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream;
  input            igor_mac_rx_master_granted_nios2_burst_0_upstream;
  input            igor_mac_rx_master_qualified_request_nios2_burst_0_upstream;
  input            igor_mac_rx_master_requests_nios2_burst_0_upstream;
  input            igor_mac_rx_master_write;
  input   [ 31: 0] igor_mac_rx_master_writedata;
  input            nios2_burst_0_upstream_waitrequest_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 31: 0] igor_mac_rx_master_address_last_time;
  wire    [ 31: 0] igor_mac_rx_master_address_to_slave;
  reg     [  3: 0] igor_mac_rx_master_burstcount_last_time;
  reg     [  3: 0] igor_mac_rx_master_byteenable_last_time;
  reg     [  1: 0] igor_mac_rx_master_dbs_address;
  wire    [  1: 0] igor_mac_rx_master_dbs_increment;
  wire    [ 15: 0] igor_mac_rx_master_dbs_write_16;
  wire             igor_mac_rx_master_run;
  wire             igor_mac_rx_master_waitrequest;
  reg              igor_mac_rx_master_write_last_time;
  reg     [ 31: 0] igor_mac_rx_master_writedata_last_time;
  wire    [  1: 0] next_dbs_address;
  wire             pre_dbs_count_enable;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~igor_mac_rx_master_qualified_request_nios2_burst_0_upstream | ~igor_mac_rx_master_write | (1 & ~nios2_burst_0_upstream_waitrequest_from_sa & (igor_mac_rx_master_dbs_address[1]) & igor_mac_rx_master_write)));

  //cascaded wait assignment, which is an e_assign
  assign igor_mac_rx_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign igor_mac_rx_master_address_to_slave = {9'b10000,
    igor_mac_rx_master_address[22 : 0]};

  //mux write dbs 1, which is an e_mux
  assign igor_mac_rx_master_dbs_write_16 = (igor_mac_rx_master_dbs_address[1])? igor_mac_rx_master_writedata[31 : 16] :
    igor_mac_rx_master_writedata[15 : 0];

  //actual waitrequest port, which is an e_assign
  assign igor_mac_rx_master_waitrequest = ~igor_mac_rx_master_run;

  //dbs count increment, which is an e_mux
  assign igor_mac_rx_master_dbs_increment = (igor_mac_rx_master_requests_nios2_burst_0_upstream)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = igor_mac_rx_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = igor_mac_rx_master_dbs_address + igor_mac_rx_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_dbs_address <= 0;
      else if (dbs_count_enable)
          igor_mac_rx_master_dbs_address <= next_dbs_address;
    end


  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = igor_mac_rx_master_granted_nios2_burst_0_upstream & igor_mac_rx_master_write & 1 & 1 & ~nios2_burst_0_upstream_waitrequest_from_sa;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //igor_mac_rx_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_address_last_time <= 0;
      else 
        igor_mac_rx_master_address_last_time <= igor_mac_rx_master_address;
    end


  //igor_mac/rx_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= igor_mac_rx_master_waitrequest & (igor_mac_rx_master_write);
    end


  //igor_mac_rx_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_rx_master_address != igor_mac_rx_master_address_last_time))
        begin
          $write("%0d ns: igor_mac_rx_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_rx_master_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_burstcount_last_time <= 0;
      else 
        igor_mac_rx_master_burstcount_last_time <= igor_mac_rx_master_burstcount;
    end


  //igor_mac_rx_master_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_rx_master_burstcount != igor_mac_rx_master_burstcount_last_time))
        begin
          $write("%0d ns: igor_mac_rx_master_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_rx_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_byteenable_last_time <= 0;
      else 
        igor_mac_rx_master_byteenable_last_time <= igor_mac_rx_master_byteenable;
    end


  //igor_mac_rx_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_rx_master_byteenable != igor_mac_rx_master_byteenable_last_time))
        begin
          $write("%0d ns: igor_mac_rx_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_rx_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_write_last_time <= 0;
      else 
        igor_mac_rx_master_write_last_time <= igor_mac_rx_master_write;
    end


  //igor_mac_rx_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_rx_master_write != igor_mac_rx_master_write_last_time))
        begin
          $write("%0d ns: igor_mac_rx_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_rx_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_rx_master_writedata_last_time <= 0;
      else 
        igor_mac_rx_master_writedata_last_time <= igor_mac_rx_master_writedata;
    end


  //igor_mac_rx_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_rx_master_writedata != igor_mac_rx_master_writedata_last_time) & igor_mac_rx_master_write)
        begin
          $write("%0d ns: igor_mac_rx_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module igor_mac_tx_master_arbitrator (
                                       // inputs:
                                        clk,
                                        d1_nios2_burst_1_upstream_end_xfer,
                                        igor_mac_tx_master_address,
                                        igor_mac_tx_master_burstcount,
                                        igor_mac_tx_master_granted_nios2_burst_1_upstream,
                                        igor_mac_tx_master_qualified_request_nios2_burst_1_upstream,
                                        igor_mac_tx_master_read,
                                        igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream,
                                        igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register,
                                        igor_mac_tx_master_requests_nios2_burst_1_upstream,
                                        nios2_burst_1_upstream_readdata_from_sa,
                                        nios2_burst_1_upstream_waitrequest_from_sa,
                                        reset_n,

                                       // outputs:
                                        igor_mac_tx_master_address_to_slave,
                                        igor_mac_tx_master_dbs_address,
                                        igor_mac_tx_master_latency_counter,
                                        igor_mac_tx_master_readdata,
                                        igor_mac_tx_master_readdatavalid,
                                        igor_mac_tx_master_waitrequest
                                     )
;

  output  [ 31: 0] igor_mac_tx_master_address_to_slave;
  output  [  1: 0] igor_mac_tx_master_dbs_address;
  output           igor_mac_tx_master_latency_counter;
  output  [ 31: 0] igor_mac_tx_master_readdata;
  output           igor_mac_tx_master_readdatavalid;
  output           igor_mac_tx_master_waitrequest;
  input            clk;
  input            d1_nios2_burst_1_upstream_end_xfer;
  input   [ 31: 0] igor_mac_tx_master_address;
  input   [  3: 0] igor_mac_tx_master_burstcount;
  input            igor_mac_tx_master_granted_nios2_burst_1_upstream;
  input            igor_mac_tx_master_qualified_request_nios2_burst_1_upstream;
  input            igor_mac_tx_master_read;
  input            igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream;
  input            igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register;
  input            igor_mac_tx_master_requests_nios2_burst_1_upstream;
  input   [ 15: 0] nios2_burst_1_upstream_readdata_from_sa;
  input            nios2_burst_1_upstream_waitrequest_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  reg     [ 31: 0] igor_mac_tx_master_address_last_time;
  wire    [ 31: 0] igor_mac_tx_master_address_to_slave;
  reg     [  3: 0] igor_mac_tx_master_burstcount_last_time;
  reg     [  1: 0] igor_mac_tx_master_dbs_address;
  wire    [  1: 0] igor_mac_tx_master_dbs_increment;
  reg     [  1: 0] igor_mac_tx_master_dbs_rdv_counter;
  wire    [  1: 0] igor_mac_tx_master_dbs_rdv_counter_inc;
  wire             igor_mac_tx_master_latency_counter;
  wire    [  1: 0] igor_mac_tx_master_next_dbs_rdv_counter;
  reg              igor_mac_tx_master_read_last_time;
  wire    [ 31: 0] igor_mac_tx_master_readdata;
  wire             igor_mac_tx_master_readdatavalid;
  wire             igor_mac_tx_master_run;
  wire             igor_mac_tx_master_waitrequest;
  wire    [  1: 0] next_dbs_address;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire             pre_dbs_count_enable;
  wire             pre_flush_igor_mac_tx_master_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (igor_mac_tx_master_qualified_request_nios2_burst_1_upstream | ~igor_mac_tx_master_requests_nios2_burst_1_upstream) & ((~igor_mac_tx_master_qualified_request_nios2_burst_1_upstream | ~igor_mac_tx_master_read | (1 & ~nios2_burst_1_upstream_waitrequest_from_sa & igor_mac_tx_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign igor_mac_tx_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign igor_mac_tx_master_address_to_slave = {9'b10000,
    igor_mac_tx_master_address[22 : 0]};

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_igor_mac_tx_master_readdatavalid = igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream & dbs_rdv_counter_overflow;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign igor_mac_tx_master_readdatavalid = 0 |
    pre_flush_igor_mac_tx_master_readdatavalid;

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = nios2_burst_1_upstream_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((igor_mac_tx_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //igor_mac/tx_master readdata mux, which is an e_mux
  assign igor_mac_tx_master_readdata = {nios2_burst_1_upstream_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0};

  //actual waitrequest port, which is an e_assign
  assign igor_mac_tx_master_waitrequest = ~igor_mac_tx_master_run;

  //latent max counter, which is an e_assign
  assign igor_mac_tx_master_latency_counter = 0;

  //dbs count increment, which is an e_mux
  assign igor_mac_tx_master_dbs_increment = (igor_mac_tx_master_requests_nios2_burst_1_upstream)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = igor_mac_tx_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = igor_mac_tx_master_dbs_address + igor_mac_tx_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_tx_master_dbs_address <= 0;
      else if (dbs_count_enable)
          igor_mac_tx_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign igor_mac_tx_master_next_dbs_rdv_counter = igor_mac_tx_master_dbs_rdv_counter + igor_mac_tx_master_dbs_rdv_counter_inc;

  //igor_mac_tx_master_rdv_inc_mux, which is an e_mux
  assign igor_mac_tx_master_dbs_rdv_counter_inc = 2;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_tx_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          igor_mac_tx_master_dbs_rdv_counter <= igor_mac_tx_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = igor_mac_tx_master_dbs_rdv_counter[1] & ~igor_mac_tx_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = igor_mac_tx_master_granted_nios2_burst_1_upstream & igor_mac_tx_master_read & 0 & 1 & ~nios2_burst_1_upstream_waitrequest_from_sa;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //igor_mac_tx_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_tx_master_address_last_time <= 0;
      else 
        igor_mac_tx_master_address_last_time <= igor_mac_tx_master_address;
    end


  //igor_mac/tx_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= igor_mac_tx_master_waitrequest & (igor_mac_tx_master_read);
    end


  //igor_mac_tx_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_tx_master_address != igor_mac_tx_master_address_last_time))
        begin
          $write("%0d ns: igor_mac_tx_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_tx_master_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_tx_master_burstcount_last_time <= 0;
      else 
        igor_mac_tx_master_burstcount_last_time <= igor_mac_tx_master_burstcount;
    end


  //igor_mac_tx_master_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_tx_master_burstcount != igor_mac_tx_master_burstcount_last_time))
        begin
          $write("%0d ns: igor_mac_tx_master_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //igor_mac_tx_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          igor_mac_tx_master_read_last_time <= 0;
      else 
        igor_mac_tx_master_read_last_time <= igor_mac_tx_master_read;
    end


  //igor_mac_tx_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (igor_mac_tx_master_read != igor_mac_tx_master_read_last_time))
        begin
          $write("%0d ns: igor_mac_tx_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_0_avalon_jtag_slave_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cpu_0_data_master_address_to_slave,
                                                   cpu_0_data_master_read,
                                                   cpu_0_data_master_waitrequest,
                                                   cpu_0_data_master_write,
                                                   cpu_0_data_master_writedata,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable,
                                                   jtag_uart_0_avalon_jtag_slave_irq,
                                                   jtag_uart_0_avalon_jtag_slave_readdata,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest,
                                                   reset_n,

                                                  // outputs:
                                                   cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                                   d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                                   jtag_uart_0_avalon_jtag_slave_address,
                                                   jtag_uart_0_avalon_jtag_slave_chipselect,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_read_n,
                                                   jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_reset_n,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_write_n,
                                                   jtag_uart_0_avalon_jtag_slave_writedata
                                                )
;

  output           cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  output           d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  output           jtag_uart_0_avalon_jtag_slave_address;
  output           jtag_uart_0_avalon_jtag_slave_chipselect;
  output           jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_reset_n;
  output           jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            jtag_uart_0_avalon_jtag_slave_dataavailable;
  input            jtag_uart_0_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  input            jtag_uart_0_avalon_jtag_slave_readyfordata;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave;
  reg              d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_allgrants;
  wire             jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_0_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_0_avalon_jtag_slave_arb_counter_enable;
  reg     [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_0_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_0_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  reg              jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire    [ 27: 0] shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master;
  wire             wait_for_jtag_uart_0_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_0_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave));
  //assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata;

  assign cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave = ({cpu_0_data_master_address_to_slave[27 : 3] , 3'b0} == 28'h7001000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_0_avalon_jtag_slave_firsttransfer ? (jtag_uart_0_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_0_avalon_jtag_slave_arb_share_counter ? (jtag_uart_0_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_allgrants = |jtag_uart_0_avalon_jtag_slave_grant_vector;

  //jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_end_xfer = ~(jtag_uart_0_avalon_jtag_slave_waits_for_read | jtag_uart_0_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave = jtag_uart_0_avalon_jtag_slave_end_xfer & (~jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & jtag_uart_0_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_0_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_0_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;

  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest)) | ((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;

  //cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_0_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_0_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_0_avalon_jtag_slave_chipselect = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  //jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_firsttransfer = jtag_uart_0_avalon_jtag_slave_begins_xfer ? jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_0_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_0_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_0_avalon_jtag_slave_begins_xfer)
          jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_0_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_read_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read);

  //~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_write_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write);

  assign shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_address = shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master >> 2;

  //d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_read = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_read_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_write = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_write_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_0_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_burst_0_upstream_arbitrator (
                                           // inputs:
                                            clk,
                                            igor_mac_rx_master_address_to_slave,
                                            igor_mac_rx_master_burstcount,
                                            igor_mac_rx_master_byteenable,
                                            igor_mac_rx_master_dbs_address,
                                            igor_mac_rx_master_dbs_write_16,
                                            igor_mac_rx_master_write,
                                            nios2_burst_0_upstream_readdata,
                                            nios2_burst_0_upstream_readdatavalid,
                                            nios2_burst_0_upstream_waitrequest,
                                            reset_n,

                                           // outputs:
                                            d1_nios2_burst_0_upstream_end_xfer,
                                            igor_mac_rx_master_byteenable_nios2_burst_0_upstream,
                                            igor_mac_rx_master_granted_nios2_burst_0_upstream,
                                            igor_mac_rx_master_qualified_request_nios2_burst_0_upstream,
                                            igor_mac_rx_master_requests_nios2_burst_0_upstream,
                                            nios2_burst_0_upstream_address,
                                            nios2_burst_0_upstream_burstcount,
                                            nios2_burst_0_upstream_byteaddress,
                                            nios2_burst_0_upstream_byteenable,
                                            nios2_burst_0_upstream_debugaccess,
                                            nios2_burst_0_upstream_read,
                                            nios2_burst_0_upstream_readdata_from_sa,
                                            nios2_burst_0_upstream_readdatavalid_from_sa,
                                            nios2_burst_0_upstream_waitrequest_from_sa,
                                            nios2_burst_0_upstream_write,
                                            nios2_burst_0_upstream_writedata
                                         )
;

  output           d1_nios2_burst_0_upstream_end_xfer;
  output  [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream;
  output           igor_mac_rx_master_granted_nios2_burst_0_upstream;
  output           igor_mac_rx_master_qualified_request_nios2_burst_0_upstream;
  output           igor_mac_rx_master_requests_nios2_burst_0_upstream;
  output  [ 22: 0] nios2_burst_0_upstream_address;
  output  [  3: 0] nios2_burst_0_upstream_burstcount;
  output  [ 23: 0] nios2_burst_0_upstream_byteaddress;
  output  [  1: 0] nios2_burst_0_upstream_byteenable;
  output           nios2_burst_0_upstream_debugaccess;
  output           nios2_burst_0_upstream_read;
  output  [ 15: 0] nios2_burst_0_upstream_readdata_from_sa;
  output           nios2_burst_0_upstream_readdatavalid_from_sa;
  output           nios2_burst_0_upstream_waitrequest_from_sa;
  output           nios2_burst_0_upstream_write;
  output  [ 15: 0] nios2_burst_0_upstream_writedata;
  input            clk;
  input   [ 31: 0] igor_mac_rx_master_address_to_slave;
  input   [  3: 0] igor_mac_rx_master_burstcount;
  input   [  3: 0] igor_mac_rx_master_byteenable;
  input   [  1: 0] igor_mac_rx_master_dbs_address;
  input   [ 15: 0] igor_mac_rx_master_dbs_write_16;
  input            igor_mac_rx_master_write;
  input   [ 15: 0] nios2_burst_0_upstream_readdata;
  input            nios2_burst_0_upstream_readdatavalid;
  input            nios2_burst_0_upstream_waitrequest;
  input            reset_n;

  reg              d1_nios2_burst_0_upstream_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_arbiterlock;
  wire             igor_mac_rx_master_arbiterlock2;
  wire    [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream;
  wire    [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_0;
  wire    [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_1;
  wire             igor_mac_rx_master_continuerequest;
  wire             igor_mac_rx_master_granted_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_qualified_request_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_requests_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_saved_grant_nios2_burst_0_upstream;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 22: 0] nios2_burst_0_upstream_address;
  wire             nios2_burst_0_upstream_allgrants;
  wire             nios2_burst_0_upstream_allow_new_arb_cycle;
  wire             nios2_burst_0_upstream_any_bursting_master_saved_grant;
  wire             nios2_burst_0_upstream_any_continuerequest;
  wire             nios2_burst_0_upstream_arb_counter_enable;
  reg     [  5: 0] nios2_burst_0_upstream_arb_share_counter;
  wire    [  5: 0] nios2_burst_0_upstream_arb_share_counter_next_value;
  wire    [  5: 0] nios2_burst_0_upstream_arb_share_set_values;
  reg     [  2: 0] nios2_burst_0_upstream_bbt_burstcounter;
  wire             nios2_burst_0_upstream_beginbursttransfer_internal;
  wire             nios2_burst_0_upstream_begins_xfer;
  wire    [  3: 0] nios2_burst_0_upstream_burstcount;
  wire    [ 23: 0] nios2_burst_0_upstream_byteaddress;
  wire    [  1: 0] nios2_burst_0_upstream_byteenable;
  wire             nios2_burst_0_upstream_debugaccess;
  wire             nios2_burst_0_upstream_end_xfer;
  wire             nios2_burst_0_upstream_firsttransfer;
  wire             nios2_burst_0_upstream_grant_vector;
  wire             nios2_burst_0_upstream_in_a_read_cycle;
  wire             nios2_burst_0_upstream_in_a_write_cycle;
  wire             nios2_burst_0_upstream_master_qreq_vector;
  wire    [  2: 0] nios2_burst_0_upstream_next_bbt_burstcount;
  wire             nios2_burst_0_upstream_non_bursting_master_requests;
  wire             nios2_burst_0_upstream_read;
  wire    [ 15: 0] nios2_burst_0_upstream_readdata_from_sa;
  wire             nios2_burst_0_upstream_readdatavalid_from_sa;
  reg              nios2_burst_0_upstream_reg_firsttransfer;
  reg              nios2_burst_0_upstream_slavearbiterlockenable;
  wire             nios2_burst_0_upstream_slavearbiterlockenable2;
  wire             nios2_burst_0_upstream_unreg_firsttransfer;
  wire             nios2_burst_0_upstream_waitrequest_from_sa;
  wire             nios2_burst_0_upstream_waits_for_read;
  wire             nios2_burst_0_upstream_waits_for_write;
  wire             nios2_burst_0_upstream_write;
  wire    [ 15: 0] nios2_burst_0_upstream_writedata;
  wire             wait_for_nios2_burst_0_upstream_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~nios2_burst_0_upstream_end_xfer;
    end


  assign nios2_burst_0_upstream_begins_xfer = ~d1_reasons_to_wait & ((igor_mac_rx_master_qualified_request_nios2_burst_0_upstream));
  //assign nios2_burst_0_upstream_readdata_from_sa = nios2_burst_0_upstream_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_0_upstream_readdata_from_sa = nios2_burst_0_upstream_readdata;

  assign igor_mac_rx_master_requests_nios2_burst_0_upstream = (({igor_mac_rx_master_address_to_slave[31 : 23] , 23'b0} == 32'h8000000) & (igor_mac_rx_master_write)) & igor_mac_rx_master_write;
  //assign nios2_burst_0_upstream_waitrequest_from_sa = nios2_burst_0_upstream_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_0_upstream_waitrequest_from_sa = nios2_burst_0_upstream_waitrequest;

  //nios2_burst_0_upstream_arb_share_counter set values, which is an e_mux
  assign nios2_burst_0_upstream_arb_share_set_values = (igor_mac_rx_master_granted_nios2_burst_0_upstream)? (igor_mac_rx_master_burstcount<< 1) :
    1;

  //nios2_burst_0_upstream_non_bursting_master_requests mux, which is an e_mux
  assign nios2_burst_0_upstream_non_bursting_master_requests = 0;

  //nios2_burst_0_upstream_any_bursting_master_saved_grant mux, which is an e_mux
  assign nios2_burst_0_upstream_any_bursting_master_saved_grant = igor_mac_rx_master_saved_grant_nios2_burst_0_upstream;

  //nios2_burst_0_upstream_arb_share_counter_next_value assignment, which is an e_assign
  assign nios2_burst_0_upstream_arb_share_counter_next_value = nios2_burst_0_upstream_firsttransfer ? (nios2_burst_0_upstream_arb_share_set_values - 1) : |nios2_burst_0_upstream_arb_share_counter ? (nios2_burst_0_upstream_arb_share_counter - 1) : 0;

  //nios2_burst_0_upstream_allgrants all slave grants, which is an e_mux
  assign nios2_burst_0_upstream_allgrants = |nios2_burst_0_upstream_grant_vector;

  //nios2_burst_0_upstream_end_xfer assignment, which is an e_assign
  assign nios2_burst_0_upstream_end_xfer = ~(nios2_burst_0_upstream_waits_for_read | nios2_burst_0_upstream_waits_for_write);

  //end_xfer_arb_share_counter_term_nios2_burst_0_upstream arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_nios2_burst_0_upstream = nios2_burst_0_upstream_end_xfer & (~nios2_burst_0_upstream_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //nios2_burst_0_upstream_arb_share_counter arbitration counter enable, which is an e_assign
  assign nios2_burst_0_upstream_arb_counter_enable = (end_xfer_arb_share_counter_term_nios2_burst_0_upstream & nios2_burst_0_upstream_allgrants) | (end_xfer_arb_share_counter_term_nios2_burst_0_upstream & ~nios2_burst_0_upstream_non_bursting_master_requests);

  //nios2_burst_0_upstream_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_upstream_arb_share_counter <= 0;
      else if (nios2_burst_0_upstream_arb_counter_enable)
          nios2_burst_0_upstream_arb_share_counter <= nios2_burst_0_upstream_arb_share_counter_next_value;
    end


  //nios2_burst_0_upstream_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_upstream_slavearbiterlockenable <= 0;
      else if ((|nios2_burst_0_upstream_master_qreq_vector & end_xfer_arb_share_counter_term_nios2_burst_0_upstream) | (end_xfer_arb_share_counter_term_nios2_burst_0_upstream & ~nios2_burst_0_upstream_non_bursting_master_requests))
          nios2_burst_0_upstream_slavearbiterlockenable <= |nios2_burst_0_upstream_arb_share_counter_next_value;
    end


  //igor_mac/rx_master nios2_burst_0/upstream arbiterlock, which is an e_assign
  assign igor_mac_rx_master_arbiterlock = nios2_burst_0_upstream_slavearbiterlockenable & igor_mac_rx_master_continuerequest;

  //nios2_burst_0_upstream_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign nios2_burst_0_upstream_slavearbiterlockenable2 = |nios2_burst_0_upstream_arb_share_counter_next_value;

  //igor_mac/rx_master nios2_burst_0/upstream arbiterlock2, which is an e_assign
  assign igor_mac_rx_master_arbiterlock2 = nios2_burst_0_upstream_slavearbiterlockenable2 & igor_mac_rx_master_continuerequest;

  //nios2_burst_0_upstream_any_continuerequest at least one master continues requesting, which is an e_assign
  assign nios2_burst_0_upstream_any_continuerequest = 1;

  //igor_mac_rx_master_continuerequest continued request, which is an e_assign
  assign igor_mac_rx_master_continuerequest = 1;

  assign igor_mac_rx_master_qualified_request_nios2_burst_0_upstream = igor_mac_rx_master_requests_nios2_burst_0_upstream;
  //nios2_burst_0_upstream_writedata mux, which is an e_mux
  assign nios2_burst_0_upstream_writedata = igor_mac_rx_master_dbs_write_16;

  //byteaddress mux for nios2_burst_0/upstream, which is an e_mux
  assign nios2_burst_0_upstream_byteaddress = igor_mac_rx_master_address_to_slave;

  //master is always granted when requested
  assign igor_mac_rx_master_granted_nios2_burst_0_upstream = igor_mac_rx_master_qualified_request_nios2_burst_0_upstream;

  //igor_mac/rx_master saved-grant nios2_burst_0/upstream, which is an e_assign
  assign igor_mac_rx_master_saved_grant_nios2_burst_0_upstream = igor_mac_rx_master_requests_nios2_burst_0_upstream;

  //allow new arb cycle for nios2_burst_0/upstream, which is an e_assign
  assign nios2_burst_0_upstream_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign nios2_burst_0_upstream_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign nios2_burst_0_upstream_master_qreq_vector = 1;

  //nios2_burst_0_upstream_firsttransfer first transaction, which is an e_assign
  assign nios2_burst_0_upstream_firsttransfer = nios2_burst_0_upstream_begins_xfer ? nios2_burst_0_upstream_unreg_firsttransfer : nios2_burst_0_upstream_reg_firsttransfer;

  //nios2_burst_0_upstream_unreg_firsttransfer first transaction, which is an e_assign
  assign nios2_burst_0_upstream_unreg_firsttransfer = ~(nios2_burst_0_upstream_slavearbiterlockenable & nios2_burst_0_upstream_any_continuerequest);

  //nios2_burst_0_upstream_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_upstream_reg_firsttransfer <= 1'b1;
      else if (nios2_burst_0_upstream_begins_xfer)
          nios2_burst_0_upstream_reg_firsttransfer <= nios2_burst_0_upstream_unreg_firsttransfer;
    end


  //nios2_burst_0_upstream_next_bbt_burstcount next_bbt_burstcount, which is an e_mux
  assign nios2_burst_0_upstream_next_bbt_burstcount = ((((nios2_burst_0_upstream_write) && (nios2_burst_0_upstream_bbt_burstcounter == 0))))? (nios2_burst_0_upstream_burstcount - 1) :
    ((((nios2_burst_0_upstream_read) && (nios2_burst_0_upstream_bbt_burstcounter == 0))))? 0 :
    (nios2_burst_0_upstream_bbt_burstcounter - 1);

  //nios2_burst_0_upstream_bbt_burstcounter bbt_burstcounter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_upstream_bbt_burstcounter <= 0;
      else if (nios2_burst_0_upstream_begins_xfer)
          nios2_burst_0_upstream_bbt_burstcounter <= nios2_burst_0_upstream_next_bbt_burstcount;
    end


  //nios2_burst_0_upstream_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign nios2_burst_0_upstream_beginbursttransfer_internal = nios2_burst_0_upstream_begins_xfer & (nios2_burst_0_upstream_bbt_burstcounter == 0);

  //nios2_burst_0_upstream_read assignment, which is an e_mux
  assign nios2_burst_0_upstream_read = 0;

  //nios2_burst_0_upstream_write assignment, which is an e_mux
  assign nios2_burst_0_upstream_write = igor_mac_rx_master_granted_nios2_burst_0_upstream & igor_mac_rx_master_write;

  //assign nios2_burst_0_upstream_readdatavalid_from_sa = nios2_burst_0_upstream_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_0_upstream_readdatavalid_from_sa = nios2_burst_0_upstream_readdatavalid;

  //nios2_burst_0_upstream_address mux, which is an e_mux
  assign nios2_burst_0_upstream_address = {igor_mac_rx_master_address_to_slave >> 2,
    igor_mac_rx_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_nios2_burst_0_upstream_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_nios2_burst_0_upstream_end_xfer <= 1;
      else 
        d1_nios2_burst_0_upstream_end_xfer <= nios2_burst_0_upstream_end_xfer;
    end


  //nios2_burst_0_upstream_waits_for_read in a cycle, which is an e_mux
  assign nios2_burst_0_upstream_waits_for_read = nios2_burst_0_upstream_in_a_read_cycle & nios2_burst_0_upstream_waitrequest_from_sa;

  //nios2_burst_0_upstream_in_a_read_cycle assignment, which is an e_assign
  assign nios2_burst_0_upstream_in_a_read_cycle = 0;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = nios2_burst_0_upstream_in_a_read_cycle;

  //nios2_burst_0_upstream_waits_for_write in a cycle, which is an e_mux
  assign nios2_burst_0_upstream_waits_for_write = nios2_burst_0_upstream_in_a_write_cycle & nios2_burst_0_upstream_waitrequest_from_sa;

  //nios2_burst_0_upstream_in_a_write_cycle assignment, which is an e_assign
  assign nios2_burst_0_upstream_in_a_write_cycle = igor_mac_rx_master_granted_nios2_burst_0_upstream & igor_mac_rx_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = nios2_burst_0_upstream_in_a_write_cycle;

  assign wait_for_nios2_burst_0_upstream_counter = 0;
  //nios2_burst_0_upstream_byteenable byte enable port mux, which is an e_mux
  assign nios2_burst_0_upstream_byteenable = (igor_mac_rx_master_granted_nios2_burst_0_upstream)? igor_mac_rx_master_byteenable_nios2_burst_0_upstream :
    -1;

  assign {igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_1,
igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_0} = igor_mac_rx_master_byteenable;
  assign igor_mac_rx_master_byteenable_nios2_burst_0_upstream = ((igor_mac_rx_master_dbs_address[1] == 0))? igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_0 :
    igor_mac_rx_master_byteenable_nios2_burst_0_upstream_segment_1;

  //burstcount mux, which is an e_mux
  assign nios2_burst_0_upstream_burstcount = (igor_mac_rx_master_granted_nios2_burst_0_upstream)? igor_mac_rx_master_burstcount :
    1;

  //debugaccess mux, which is an e_mux
  assign nios2_burst_0_upstream_debugaccess = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2_burst_0/upstream enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //igor_mac/rx_master non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (igor_mac_rx_master_requests_nios2_burst_0_upstream && (igor_mac_rx_master_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: igor_mac/rx_master drove 0 on its 'burstcount' port while accessing slave nios2_burst_0/upstream", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_burst_0_downstream_arbitrator (
                                             // inputs:
                                              clk,
                                              d1_sdram_0_s1_end_xfer,
                                              nios2_burst_0_downstream_address,
                                              nios2_burst_0_downstream_burstcount,
                                              nios2_burst_0_downstream_byteenable,
                                              nios2_burst_0_downstream_granted_sdram_0_s1,
                                              nios2_burst_0_downstream_qualified_request_sdram_0_s1,
                                              nios2_burst_0_downstream_read,
                                              nios2_burst_0_downstream_read_data_valid_sdram_0_s1,
                                              nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register,
                                              nios2_burst_0_downstream_requests_sdram_0_s1,
                                              nios2_burst_0_downstream_write,
                                              nios2_burst_0_downstream_writedata,
                                              reset_n,
                                              sdram_0_s1_readdata_from_sa,
                                              sdram_0_s1_waitrequest_from_sa,

                                             // outputs:
                                              nios2_burst_0_downstream_address_to_slave,
                                              nios2_burst_0_downstream_latency_counter,
                                              nios2_burst_0_downstream_readdata,
                                              nios2_burst_0_downstream_readdatavalid,
                                              nios2_burst_0_downstream_reset_n,
                                              nios2_burst_0_downstream_waitrequest
                                           )
;

  output  [ 22: 0] nios2_burst_0_downstream_address_to_slave;
  output           nios2_burst_0_downstream_latency_counter;
  output  [ 15: 0] nios2_burst_0_downstream_readdata;
  output           nios2_burst_0_downstream_readdatavalid;
  output           nios2_burst_0_downstream_reset_n;
  output           nios2_burst_0_downstream_waitrequest;
  input            clk;
  input            d1_sdram_0_s1_end_xfer;
  input   [ 22: 0] nios2_burst_0_downstream_address;
  input            nios2_burst_0_downstream_burstcount;
  input   [  1: 0] nios2_burst_0_downstream_byteenable;
  input            nios2_burst_0_downstream_granted_sdram_0_s1;
  input            nios2_burst_0_downstream_qualified_request_sdram_0_s1;
  input            nios2_burst_0_downstream_read;
  input            nios2_burst_0_downstream_read_data_valid_sdram_0_s1;
  input            nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register;
  input            nios2_burst_0_downstream_requests_sdram_0_s1;
  input            nios2_burst_0_downstream_write;
  input   [ 15: 0] nios2_burst_0_downstream_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  reg     [ 22: 0] nios2_burst_0_downstream_address_last_time;
  wire    [ 22: 0] nios2_burst_0_downstream_address_to_slave;
  reg              nios2_burst_0_downstream_burstcount_last_time;
  reg     [  1: 0] nios2_burst_0_downstream_byteenable_last_time;
  wire             nios2_burst_0_downstream_is_granted_some_slave;
  reg              nios2_burst_0_downstream_latency_counter;
  reg              nios2_burst_0_downstream_read_but_no_slave_selected;
  reg              nios2_burst_0_downstream_read_last_time;
  wire    [ 15: 0] nios2_burst_0_downstream_readdata;
  wire             nios2_burst_0_downstream_readdatavalid;
  wire             nios2_burst_0_downstream_reset_n;
  wire             nios2_burst_0_downstream_run;
  wire             nios2_burst_0_downstream_waitrequest;
  reg              nios2_burst_0_downstream_write_last_time;
  reg     [ 15: 0] nios2_burst_0_downstream_writedata_last_time;
  wire             p1_nios2_burst_0_downstream_latency_counter;
  wire             pre_flush_nios2_burst_0_downstream_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (nios2_burst_0_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_0_downstream_requests_sdram_0_s1) & (nios2_burst_0_downstream_granted_sdram_0_s1 | ~nios2_burst_0_downstream_qualified_request_sdram_0_s1) & ((~nios2_burst_0_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_0_downstream_read | (1 & ~sdram_0_s1_waitrequest_from_sa & nios2_burst_0_downstream_read))) & ((~nios2_burst_0_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_0_downstream_write | (1 & ~sdram_0_s1_waitrequest_from_sa & nios2_burst_0_downstream_write)));

  //cascaded wait assignment, which is an e_assign
  assign nios2_burst_0_downstream_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_burst_0_downstream_address_to_slave = nios2_burst_0_downstream_address;

  //nios2_burst_0_downstream_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_read_but_no_slave_selected <= 0;
      else 
        nios2_burst_0_downstream_read_but_no_slave_selected <= nios2_burst_0_downstream_read & nios2_burst_0_downstream_run & ~nios2_burst_0_downstream_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign nios2_burst_0_downstream_is_granted_some_slave = nios2_burst_0_downstream_granted_sdram_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_nios2_burst_0_downstream_readdatavalid = nios2_burst_0_downstream_read_data_valid_sdram_0_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign nios2_burst_0_downstream_readdatavalid = nios2_burst_0_downstream_read_but_no_slave_selected |
    pre_flush_nios2_burst_0_downstream_readdatavalid;

  //nios2_burst_0/downstream readdata mux, which is an e_mux
  assign nios2_burst_0_downstream_readdata = sdram_0_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign nios2_burst_0_downstream_waitrequest = ~nios2_burst_0_downstream_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_latency_counter <= 0;
      else 
        nios2_burst_0_downstream_latency_counter <= p1_nios2_burst_0_downstream_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_nios2_burst_0_downstream_latency_counter = ((nios2_burst_0_downstream_run & nios2_burst_0_downstream_read))? latency_load_value :
    (nios2_burst_0_downstream_latency_counter)? nios2_burst_0_downstream_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //nios2_burst_0_downstream_reset_n assignment, which is an e_assign
  assign nios2_burst_0_downstream_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2_burst_0_downstream_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_address_last_time <= 0;
      else 
        nios2_burst_0_downstream_address_last_time <= nios2_burst_0_downstream_address;
    end


  //nios2_burst_0/downstream waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= nios2_burst_0_downstream_waitrequest & (nios2_burst_0_downstream_read | nios2_burst_0_downstream_write);
    end


  //nios2_burst_0_downstream_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_address != nios2_burst_0_downstream_address_last_time))
        begin
          $write("%0d ns: nios2_burst_0_downstream_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_0_downstream_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_burstcount_last_time <= 0;
      else 
        nios2_burst_0_downstream_burstcount_last_time <= nios2_burst_0_downstream_burstcount;
    end


  //nios2_burst_0_downstream_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_burstcount != nios2_burst_0_downstream_burstcount_last_time))
        begin
          $write("%0d ns: nios2_burst_0_downstream_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_0_downstream_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_byteenable_last_time <= 0;
      else 
        nios2_burst_0_downstream_byteenable_last_time <= nios2_burst_0_downstream_byteenable;
    end


  //nios2_burst_0_downstream_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_byteenable != nios2_burst_0_downstream_byteenable_last_time))
        begin
          $write("%0d ns: nios2_burst_0_downstream_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_0_downstream_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_read_last_time <= 0;
      else 
        nios2_burst_0_downstream_read_last_time <= nios2_burst_0_downstream_read;
    end


  //nios2_burst_0_downstream_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_read != nios2_burst_0_downstream_read_last_time))
        begin
          $write("%0d ns: nios2_burst_0_downstream_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_0_downstream_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_write_last_time <= 0;
      else 
        nios2_burst_0_downstream_write_last_time <= nios2_burst_0_downstream_write;
    end


  //nios2_burst_0_downstream_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_write != nios2_burst_0_downstream_write_last_time))
        begin
          $write("%0d ns: nios2_burst_0_downstream_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_0_downstream_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_0_downstream_writedata_last_time <= 0;
      else 
        nios2_burst_0_downstream_writedata_last_time <= nios2_burst_0_downstream_writedata;
    end


  //nios2_burst_0_downstream_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_0_downstream_writedata != nios2_burst_0_downstream_writedata_last_time) & nios2_burst_0_downstream_write)
        begin
          $write("%0d ns: nios2_burst_0_downstream_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module burstcount_fifo_for_nios2_burst_1_upstream_module (
                                                           // inputs:
                                                            clear_fifo,
                                                            clk,
                                                            data_in,
                                                            read,
                                                            reset_n,
                                                            sync_reset,
                                                            write,

                                                           // outputs:
                                                            data_out,
                                                            empty,
                                                            fifo_contains_ones_n,
                                                            full
                                                         )
;

  output  [  4: 0] data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input   [  4: 0] data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire    [  4: 0] data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  reg              full_7;
  reg              full_8;
  wire             full_9;
  reg     [  4: 0] how_many_ones;
  wire    [  4: 0] one_count_minus_one;
  wire    [  4: 0] one_count_plus_one;
  wire             p0_full_0;
  wire    [  4: 0] p0_stage_0;
  wire             p1_full_1;
  wire    [  4: 0] p1_stage_1;
  wire             p2_full_2;
  wire    [  4: 0] p2_stage_2;
  wire             p3_full_3;
  wire    [  4: 0] p3_stage_3;
  wire             p4_full_4;
  wire    [  4: 0] p4_stage_4;
  wire             p5_full_5;
  wire    [  4: 0] p5_stage_5;
  wire             p6_full_6;
  wire    [  4: 0] p6_stage_6;
  wire             p7_full_7;
  wire    [  4: 0] p7_stage_7;
  wire             p8_full_8;
  wire    [  4: 0] p8_stage_8;
  reg     [  4: 0] stage_0;
  reg     [  4: 0] stage_1;
  reg     [  4: 0] stage_2;
  reg     [  4: 0] stage_3;
  reg     [  4: 0] stage_4;
  reg     [  4: 0] stage_5;
  reg     [  4: 0] stage_6;
  reg     [  4: 0] stage_7;
  reg     [  4: 0] stage_8;
  wire    [  4: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_8;
  assign empty = !full_0;
  assign full_9 = 0;
  //data_8, which is an e_mux
  assign p8_stage_8 = ((full_9 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_8 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_8))
          if (sync_reset & full_8 & !((full_9 == 0) & read & write))
              stage_8 <= 0;
          else 
            stage_8 <= p8_stage_8;
    end


  //control_8, which is an e_mux
  assign p8_full_8 = ((read & !write) == 0)? full_7 :
    0;

  //control_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_8 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_8 <= 0;
          else 
            full_8 <= p8_full_8;
    end


  //data_7, which is an e_mux
  assign p7_stage_7 = ((full_8 & ~clear_fifo) == 0)? data_in :
    stage_8;

  //data_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_7 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_7))
          if (sync_reset & full_7 & !((full_8 == 0) & read & write))
              stage_7 <= 0;
          else 
            stage_7 <= p7_stage_7;
    end


  //control_7, which is an e_mux
  assign p7_full_7 = ((read & !write) == 0)? full_6 :
    full_8;

  //control_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_7 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_7 <= 0;
          else 
            full_7 <= p7_full_7;
    end


  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    stage_7;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    full_7;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_igor_mac_tx_master_to_nios2_burst_1_upstream_module (
                                                                          // inputs:
                                                                           clear_fifo,
                                                                           clk,
                                                                           data_in,
                                                                           read,
                                                                           reset_n,
                                                                           sync_reset,
                                                                           write,

                                                                          // outputs:
                                                                           data_out,
                                                                           empty,
                                                                           fifo_contains_ones_n,
                                                                           full
                                                                        )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  reg              full_7;
  reg              full_8;
  wire             full_9;
  reg     [  4: 0] how_many_ones;
  wire    [  4: 0] one_count_minus_one;
  wire    [  4: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  wire             p7_full_7;
  wire             p7_stage_7;
  wire             p8_full_8;
  wire             p8_stage_8;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  reg              stage_7;
  reg              stage_8;
  wire    [  4: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_8;
  assign empty = !full_0;
  assign full_9 = 0;
  //data_8, which is an e_mux
  assign p8_stage_8 = ((full_9 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_8 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_8))
          if (sync_reset & full_8 & !((full_9 == 0) & read & write))
              stage_8 <= 0;
          else 
            stage_8 <= p8_stage_8;
    end


  //control_8, which is an e_mux
  assign p8_full_8 = ((read & !write) == 0)? full_7 :
    0;

  //control_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_8 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_8 <= 0;
          else 
            full_8 <= p8_full_8;
    end


  //data_7, which is an e_mux
  assign p7_stage_7 = ((full_8 & ~clear_fifo) == 0)? data_in :
    stage_8;

  //data_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_7 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_7))
          if (sync_reset & full_7 & !((full_8 == 0) & read & write))
              stage_7 <= 0;
          else 
            stage_7 <= p7_stage_7;
    end


  //control_7, which is an e_mux
  assign p7_full_7 = ((read & !write) == 0)? full_6 :
    full_8;

  //control_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_7 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_7 <= 0;
          else 
            full_7 <= p7_full_7;
    end


  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    stage_7;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    full_7;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_burst_1_upstream_arbitrator (
                                           // inputs:
                                            clk,
                                            igor_mac_tx_master_address_to_slave,
                                            igor_mac_tx_master_burstcount,
                                            igor_mac_tx_master_dbs_address,
                                            igor_mac_tx_master_latency_counter,
                                            igor_mac_tx_master_read,
                                            nios2_burst_1_upstream_readdata,
                                            nios2_burst_1_upstream_readdatavalid,
                                            nios2_burst_1_upstream_waitrequest,
                                            reset_n,

                                           // outputs:
                                            d1_nios2_burst_1_upstream_end_xfer,
                                            igor_mac_tx_master_granted_nios2_burst_1_upstream,
                                            igor_mac_tx_master_qualified_request_nios2_burst_1_upstream,
                                            igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream,
                                            igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register,
                                            igor_mac_tx_master_requests_nios2_burst_1_upstream,
                                            nios2_burst_1_upstream_address,
                                            nios2_burst_1_upstream_burstcount,
                                            nios2_burst_1_upstream_byteaddress,
                                            nios2_burst_1_upstream_byteenable,
                                            nios2_burst_1_upstream_debugaccess,
                                            nios2_burst_1_upstream_read,
                                            nios2_burst_1_upstream_readdata_from_sa,
                                            nios2_burst_1_upstream_waitrequest_from_sa,
                                            nios2_burst_1_upstream_write
                                         )
;

  output           d1_nios2_burst_1_upstream_end_xfer;
  output           igor_mac_tx_master_granted_nios2_burst_1_upstream;
  output           igor_mac_tx_master_qualified_request_nios2_burst_1_upstream;
  output           igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream;
  output           igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register;
  output           igor_mac_tx_master_requests_nios2_burst_1_upstream;
  output  [ 22: 0] nios2_burst_1_upstream_address;
  output  [  3: 0] nios2_burst_1_upstream_burstcount;
  output  [ 23: 0] nios2_burst_1_upstream_byteaddress;
  output  [  1: 0] nios2_burst_1_upstream_byteenable;
  output           nios2_burst_1_upstream_debugaccess;
  output           nios2_burst_1_upstream_read;
  output  [ 15: 0] nios2_burst_1_upstream_readdata_from_sa;
  output           nios2_burst_1_upstream_waitrequest_from_sa;
  output           nios2_burst_1_upstream_write;
  input            clk;
  input   [ 31: 0] igor_mac_tx_master_address_to_slave;
  input   [  3: 0] igor_mac_tx_master_burstcount;
  input   [  1: 0] igor_mac_tx_master_dbs_address;
  input            igor_mac_tx_master_latency_counter;
  input            igor_mac_tx_master_read;
  input   [ 15: 0] nios2_burst_1_upstream_readdata;
  input            nios2_burst_1_upstream_readdatavalid;
  input            nios2_burst_1_upstream_waitrequest;
  input            reset_n;

  reg              d1_nios2_burst_1_upstream_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_arbiterlock;
  wire             igor_mac_tx_master_arbiterlock2;
  wire             igor_mac_tx_master_continuerequest;
  wire             igor_mac_tx_master_granted_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_qualified_request_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_rdv_fifo_empty_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_rdv_fifo_output_from_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register;
  wire             igor_mac_tx_master_requests_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_saved_grant_nios2_burst_1_upstream;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 22: 0] nios2_burst_1_upstream_address;
  wire             nios2_burst_1_upstream_allgrants;
  wire             nios2_burst_1_upstream_allow_new_arb_cycle;
  wire             nios2_burst_1_upstream_any_bursting_master_saved_grant;
  wire             nios2_burst_1_upstream_any_continuerequest;
  wire             nios2_burst_1_upstream_arb_counter_enable;
  reg     [  5: 0] nios2_burst_1_upstream_arb_share_counter;
  wire    [  5: 0] nios2_burst_1_upstream_arb_share_counter_next_value;
  wire    [  5: 0] nios2_burst_1_upstream_arb_share_set_values;
  reg     [  2: 0] nios2_burst_1_upstream_bbt_burstcounter;
  wire             nios2_burst_1_upstream_beginbursttransfer_internal;
  wire             nios2_burst_1_upstream_begins_xfer;
  wire    [  3: 0] nios2_burst_1_upstream_burstcount;
  wire             nios2_burst_1_upstream_burstcount_fifo_empty;
  wire    [ 23: 0] nios2_burst_1_upstream_byteaddress;
  wire    [  1: 0] nios2_burst_1_upstream_byteenable;
  reg     [  4: 0] nios2_burst_1_upstream_current_burst;
  wire    [  4: 0] nios2_burst_1_upstream_current_burst_minus_one;
  wire             nios2_burst_1_upstream_debugaccess;
  wire             nios2_burst_1_upstream_end_xfer;
  wire             nios2_burst_1_upstream_firsttransfer;
  wire             nios2_burst_1_upstream_grant_vector;
  wire             nios2_burst_1_upstream_in_a_read_cycle;
  wire             nios2_burst_1_upstream_in_a_write_cycle;
  reg              nios2_burst_1_upstream_load_fifo;
  wire             nios2_burst_1_upstream_master_qreq_vector;
  wire             nios2_burst_1_upstream_move_on_to_next_transaction;
  wire    [  2: 0] nios2_burst_1_upstream_next_bbt_burstcount;
  wire    [  4: 0] nios2_burst_1_upstream_next_burst_count;
  wire             nios2_burst_1_upstream_non_bursting_master_requests;
  wire             nios2_burst_1_upstream_read;
  wire    [ 15: 0] nios2_burst_1_upstream_readdata_from_sa;
  wire             nios2_burst_1_upstream_readdatavalid_from_sa;
  reg              nios2_burst_1_upstream_reg_firsttransfer;
  wire    [  4: 0] nios2_burst_1_upstream_selected_burstcount;
  reg              nios2_burst_1_upstream_slavearbiterlockenable;
  wire             nios2_burst_1_upstream_slavearbiterlockenable2;
  wire             nios2_burst_1_upstream_this_cycle_is_the_last_burst;
  wire    [  4: 0] nios2_burst_1_upstream_transaction_burst_count;
  wire             nios2_burst_1_upstream_unreg_firsttransfer;
  wire             nios2_burst_1_upstream_waitrequest_from_sa;
  wire             nios2_burst_1_upstream_waits_for_read;
  wire             nios2_burst_1_upstream_waits_for_write;
  wire             nios2_burst_1_upstream_write;
  wire             p0_nios2_burst_1_upstream_load_fifo;
  wire             wait_for_nios2_burst_1_upstream_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~nios2_burst_1_upstream_end_xfer;
    end


  assign nios2_burst_1_upstream_begins_xfer = ~d1_reasons_to_wait & ((igor_mac_tx_master_qualified_request_nios2_burst_1_upstream));
  //assign nios2_burst_1_upstream_readdata_from_sa = nios2_burst_1_upstream_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_1_upstream_readdata_from_sa = nios2_burst_1_upstream_readdata;

  assign igor_mac_tx_master_requests_nios2_burst_1_upstream = (({igor_mac_tx_master_address_to_slave[31 : 23] , 23'b0} == 32'h8000000) & (igor_mac_tx_master_read)) & igor_mac_tx_master_read;
  //assign nios2_burst_1_upstream_waitrequest_from_sa = nios2_burst_1_upstream_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_1_upstream_waitrequest_from_sa = nios2_burst_1_upstream_waitrequest;

  //assign nios2_burst_1_upstream_readdatavalid_from_sa = nios2_burst_1_upstream_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_burst_1_upstream_readdatavalid_from_sa = nios2_burst_1_upstream_readdatavalid;

  //nios2_burst_1_upstream_arb_share_counter set values, which is an e_mux
  assign nios2_burst_1_upstream_arb_share_set_values = 1;

  //nios2_burst_1_upstream_non_bursting_master_requests mux, which is an e_mux
  assign nios2_burst_1_upstream_non_bursting_master_requests = 0;

  //nios2_burst_1_upstream_any_bursting_master_saved_grant mux, which is an e_mux
  assign nios2_burst_1_upstream_any_bursting_master_saved_grant = igor_mac_tx_master_saved_grant_nios2_burst_1_upstream;

  //nios2_burst_1_upstream_arb_share_counter_next_value assignment, which is an e_assign
  assign nios2_burst_1_upstream_arb_share_counter_next_value = nios2_burst_1_upstream_firsttransfer ? (nios2_burst_1_upstream_arb_share_set_values - 1) : |nios2_burst_1_upstream_arb_share_counter ? (nios2_burst_1_upstream_arb_share_counter - 1) : 0;

  //nios2_burst_1_upstream_allgrants all slave grants, which is an e_mux
  assign nios2_burst_1_upstream_allgrants = |nios2_burst_1_upstream_grant_vector;

  //nios2_burst_1_upstream_end_xfer assignment, which is an e_assign
  assign nios2_burst_1_upstream_end_xfer = ~(nios2_burst_1_upstream_waits_for_read | nios2_burst_1_upstream_waits_for_write);

  //end_xfer_arb_share_counter_term_nios2_burst_1_upstream arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_nios2_burst_1_upstream = nios2_burst_1_upstream_end_xfer & (~nios2_burst_1_upstream_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //nios2_burst_1_upstream_arb_share_counter arbitration counter enable, which is an e_assign
  assign nios2_burst_1_upstream_arb_counter_enable = (end_xfer_arb_share_counter_term_nios2_burst_1_upstream & nios2_burst_1_upstream_allgrants) | (end_xfer_arb_share_counter_term_nios2_burst_1_upstream & ~nios2_burst_1_upstream_non_bursting_master_requests);

  //nios2_burst_1_upstream_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_arb_share_counter <= 0;
      else if (nios2_burst_1_upstream_arb_counter_enable)
          nios2_burst_1_upstream_arb_share_counter <= nios2_burst_1_upstream_arb_share_counter_next_value;
    end


  //nios2_burst_1_upstream_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_slavearbiterlockenable <= 0;
      else if ((|nios2_burst_1_upstream_master_qreq_vector & end_xfer_arb_share_counter_term_nios2_burst_1_upstream) | (end_xfer_arb_share_counter_term_nios2_burst_1_upstream & ~nios2_burst_1_upstream_non_bursting_master_requests))
          nios2_burst_1_upstream_slavearbiterlockenable <= |nios2_burst_1_upstream_arb_share_counter_next_value;
    end


  //igor_mac/tx_master nios2_burst_1/upstream arbiterlock, which is an e_assign
  assign igor_mac_tx_master_arbiterlock = nios2_burst_1_upstream_slavearbiterlockenable & igor_mac_tx_master_continuerequest;

  //nios2_burst_1_upstream_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign nios2_burst_1_upstream_slavearbiterlockenable2 = |nios2_burst_1_upstream_arb_share_counter_next_value;

  //igor_mac/tx_master nios2_burst_1/upstream arbiterlock2, which is an e_assign
  assign igor_mac_tx_master_arbiterlock2 = nios2_burst_1_upstream_slavearbiterlockenable2 & igor_mac_tx_master_continuerequest;

  //nios2_burst_1_upstream_any_continuerequest at least one master continues requesting, which is an e_assign
  assign nios2_burst_1_upstream_any_continuerequest = 1;

  //igor_mac_tx_master_continuerequest continued request, which is an e_assign
  assign igor_mac_tx_master_continuerequest = 1;

  assign igor_mac_tx_master_qualified_request_nios2_burst_1_upstream = igor_mac_tx_master_requests_nios2_burst_1_upstream & ~((igor_mac_tx_master_read & ((igor_mac_tx_master_latency_counter != 0) | (1 < igor_mac_tx_master_latency_counter))));
  //unique name for nios2_burst_1_upstream_move_on_to_next_transaction, which is an e_assign
  assign nios2_burst_1_upstream_move_on_to_next_transaction = nios2_burst_1_upstream_this_cycle_is_the_last_burst & nios2_burst_1_upstream_load_fifo;

  //the currently selected burstcount for nios2_burst_1_upstream, which is an e_mux
  assign nios2_burst_1_upstream_selected_burstcount = (igor_mac_tx_master_granted_nios2_burst_1_upstream)? igor_mac_tx_master_burstcount :
    1;

  //burstcount_fifo_for_nios2_burst_1_upstream, which is an e_fifo_with_registered_outputs
  burstcount_fifo_for_nios2_burst_1_upstream_module burstcount_fifo_for_nios2_burst_1_upstream
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios2_burst_1_upstream_selected_burstcount),
      .data_out             (nios2_burst_1_upstream_transaction_burst_count),
      .empty                (nios2_burst_1_upstream_burstcount_fifo_empty),
      .fifo_contains_ones_n (),
      .full                 (),
      .read                 (nios2_burst_1_upstream_this_cycle_is_the_last_burst),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read & nios2_burst_1_upstream_load_fifo & ~(nios2_burst_1_upstream_this_cycle_is_the_last_burst & nios2_burst_1_upstream_burstcount_fifo_empty))
    );

  //nios2_burst_1_upstream current burst minus one, which is an e_assign
  assign nios2_burst_1_upstream_current_burst_minus_one = nios2_burst_1_upstream_current_burst - 1;

  //what to load in current_burst, for nios2_burst_1_upstream, which is an e_mux
  assign nios2_burst_1_upstream_next_burst_count = (((in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read) & ~nios2_burst_1_upstream_load_fifo))? {nios2_burst_1_upstream_selected_burstcount, 1'b0} :
    ((in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read & nios2_burst_1_upstream_this_cycle_is_the_last_burst & nios2_burst_1_upstream_burstcount_fifo_empty))? {nios2_burst_1_upstream_selected_burstcount, 1'b0} :
    (nios2_burst_1_upstream_this_cycle_is_the_last_burst)? {nios2_burst_1_upstream_transaction_burst_count,  1'b0} :
    nios2_burst_1_upstream_current_burst_minus_one;

  //the current burst count for nios2_burst_1_upstream, to be decremented, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_current_burst <= 0;
      else if (nios2_burst_1_upstream_readdatavalid_from_sa | (~nios2_burst_1_upstream_load_fifo & (in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read)))
          nios2_burst_1_upstream_current_burst <= nios2_burst_1_upstream_next_burst_count;
    end


  //a 1 or burstcount fifo empty, to initialize the counter, which is an e_mux
  assign p0_nios2_burst_1_upstream_load_fifo = (~nios2_burst_1_upstream_load_fifo)? 1 :
    (((in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read) & nios2_burst_1_upstream_load_fifo))? 1 :
    ~nios2_burst_1_upstream_burstcount_fifo_empty;

  //whether to load directly to the counter or to the fifo, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_load_fifo <= 0;
      else if ((in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read) & ~nios2_burst_1_upstream_load_fifo | nios2_burst_1_upstream_this_cycle_is_the_last_burst)
          nios2_burst_1_upstream_load_fifo <= p0_nios2_burst_1_upstream_load_fifo;
    end


  //the last cycle in the burst for nios2_burst_1_upstream, which is an e_assign
  assign nios2_burst_1_upstream_this_cycle_is_the_last_burst = ~(|nios2_burst_1_upstream_current_burst_minus_one) & nios2_burst_1_upstream_readdatavalid_from_sa;

  //rdv_fifo_for_igor_mac_tx_master_to_nios2_burst_1_upstream, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_igor_mac_tx_master_to_nios2_burst_1_upstream_module rdv_fifo_for_igor_mac_tx_master_to_nios2_burst_1_upstream
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (igor_mac_tx_master_granted_nios2_burst_1_upstream),
      .data_out             (igor_mac_tx_master_rdv_fifo_output_from_nios2_burst_1_upstream),
      .empty                (),
      .fifo_contains_ones_n (igor_mac_tx_master_rdv_fifo_empty_nios2_burst_1_upstream),
      .full                 (),
      .read                 (nios2_burst_1_upstream_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~nios2_burst_1_upstream_waits_for_read)
    );

  assign igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register = ~igor_mac_tx_master_rdv_fifo_empty_nios2_burst_1_upstream;
  //local readdatavalid igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream, which is an e_mux
  assign igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream = nios2_burst_1_upstream_readdatavalid_from_sa;

  //byteaddress mux for nios2_burst_1/upstream, which is an e_mux
  assign nios2_burst_1_upstream_byteaddress = igor_mac_tx_master_address_to_slave;

  //master is always granted when requested
  assign igor_mac_tx_master_granted_nios2_burst_1_upstream = igor_mac_tx_master_qualified_request_nios2_burst_1_upstream;

  //igor_mac/tx_master saved-grant nios2_burst_1/upstream, which is an e_assign
  assign igor_mac_tx_master_saved_grant_nios2_burst_1_upstream = igor_mac_tx_master_requests_nios2_burst_1_upstream;

  //allow new arb cycle for nios2_burst_1/upstream, which is an e_assign
  assign nios2_burst_1_upstream_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign nios2_burst_1_upstream_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign nios2_burst_1_upstream_master_qreq_vector = 1;

  //nios2_burst_1_upstream_firsttransfer first transaction, which is an e_assign
  assign nios2_burst_1_upstream_firsttransfer = nios2_burst_1_upstream_begins_xfer ? nios2_burst_1_upstream_unreg_firsttransfer : nios2_burst_1_upstream_reg_firsttransfer;

  //nios2_burst_1_upstream_unreg_firsttransfer first transaction, which is an e_assign
  assign nios2_burst_1_upstream_unreg_firsttransfer = ~(nios2_burst_1_upstream_slavearbiterlockenable & nios2_burst_1_upstream_any_continuerequest);

  //nios2_burst_1_upstream_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_reg_firsttransfer <= 1'b1;
      else if (nios2_burst_1_upstream_begins_xfer)
          nios2_burst_1_upstream_reg_firsttransfer <= nios2_burst_1_upstream_unreg_firsttransfer;
    end


  //nios2_burst_1_upstream_next_bbt_burstcount next_bbt_burstcount, which is an e_mux
  assign nios2_burst_1_upstream_next_bbt_burstcount = ((((nios2_burst_1_upstream_write) && (nios2_burst_1_upstream_bbt_burstcounter == 0))))? (nios2_burst_1_upstream_burstcount - 1) :
    ((((nios2_burst_1_upstream_read) && (nios2_burst_1_upstream_bbt_burstcounter == 0))))? 0 :
    (nios2_burst_1_upstream_bbt_burstcounter - 1);

  //nios2_burst_1_upstream_bbt_burstcounter bbt_burstcounter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_upstream_bbt_burstcounter <= 0;
      else if (nios2_burst_1_upstream_begins_xfer)
          nios2_burst_1_upstream_bbt_burstcounter <= nios2_burst_1_upstream_next_bbt_burstcount;
    end


  //nios2_burst_1_upstream_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign nios2_burst_1_upstream_beginbursttransfer_internal = nios2_burst_1_upstream_begins_xfer & (nios2_burst_1_upstream_bbt_burstcounter == 0);

  //nios2_burst_1_upstream_read assignment, which is an e_mux
  assign nios2_burst_1_upstream_read = igor_mac_tx_master_granted_nios2_burst_1_upstream & igor_mac_tx_master_read;

  //nios2_burst_1_upstream_write assignment, which is an e_mux
  assign nios2_burst_1_upstream_write = 0;

  //nios2_burst_1_upstream_address mux, which is an e_mux
  assign nios2_burst_1_upstream_address = {igor_mac_tx_master_address_to_slave >> 2,
    igor_mac_tx_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_nios2_burst_1_upstream_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_nios2_burst_1_upstream_end_xfer <= 1;
      else 
        d1_nios2_burst_1_upstream_end_xfer <= nios2_burst_1_upstream_end_xfer;
    end


  //nios2_burst_1_upstream_waits_for_read in a cycle, which is an e_mux
  assign nios2_burst_1_upstream_waits_for_read = nios2_burst_1_upstream_in_a_read_cycle & nios2_burst_1_upstream_waitrequest_from_sa;

  //nios2_burst_1_upstream_in_a_read_cycle assignment, which is an e_assign
  assign nios2_burst_1_upstream_in_a_read_cycle = igor_mac_tx_master_granted_nios2_burst_1_upstream & igor_mac_tx_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = nios2_burst_1_upstream_in_a_read_cycle;

  //nios2_burst_1_upstream_waits_for_write in a cycle, which is an e_mux
  assign nios2_burst_1_upstream_waits_for_write = nios2_burst_1_upstream_in_a_write_cycle & nios2_burst_1_upstream_waitrequest_from_sa;

  //nios2_burst_1_upstream_in_a_write_cycle assignment, which is an e_assign
  assign nios2_burst_1_upstream_in_a_write_cycle = 0;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = nios2_burst_1_upstream_in_a_write_cycle;

  assign wait_for_nios2_burst_1_upstream_counter = 0;
  //nios2_burst_1_upstream_byteenable byte enable port mux, which is an e_mux
  assign nios2_burst_1_upstream_byteenable = -1;

  //burstcount mux, which is an e_mux
  assign nios2_burst_1_upstream_burstcount = (igor_mac_tx_master_granted_nios2_burst_1_upstream)? igor_mac_tx_master_burstcount :
    1;

  //debugaccess mux, which is an e_mux
  assign nios2_burst_1_upstream_debugaccess = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2_burst_1/upstream enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //igor_mac/tx_master non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (igor_mac_tx_master_requests_nios2_burst_1_upstream && (igor_mac_tx_master_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: igor_mac/tx_master drove 0 on its 'burstcount' port while accessing slave nios2_burst_1/upstream", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_burst_1_downstream_arbitrator (
                                             // inputs:
                                              clk,
                                              d1_sdram_0_s1_end_xfer,
                                              nios2_burst_1_downstream_address,
                                              nios2_burst_1_downstream_burstcount,
                                              nios2_burst_1_downstream_byteenable,
                                              nios2_burst_1_downstream_granted_sdram_0_s1,
                                              nios2_burst_1_downstream_qualified_request_sdram_0_s1,
                                              nios2_burst_1_downstream_read,
                                              nios2_burst_1_downstream_read_data_valid_sdram_0_s1,
                                              nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register,
                                              nios2_burst_1_downstream_requests_sdram_0_s1,
                                              nios2_burst_1_downstream_write,
                                              nios2_burst_1_downstream_writedata,
                                              reset_n,
                                              sdram_0_s1_readdata_from_sa,
                                              sdram_0_s1_waitrequest_from_sa,

                                             // outputs:
                                              nios2_burst_1_downstream_address_to_slave,
                                              nios2_burst_1_downstream_latency_counter,
                                              nios2_burst_1_downstream_readdata,
                                              nios2_burst_1_downstream_readdatavalid,
                                              nios2_burst_1_downstream_reset_n,
                                              nios2_burst_1_downstream_waitrequest
                                           )
;

  output  [ 22: 0] nios2_burst_1_downstream_address_to_slave;
  output           nios2_burst_1_downstream_latency_counter;
  output  [ 15: 0] nios2_burst_1_downstream_readdata;
  output           nios2_burst_1_downstream_readdatavalid;
  output           nios2_burst_1_downstream_reset_n;
  output           nios2_burst_1_downstream_waitrequest;
  input            clk;
  input            d1_sdram_0_s1_end_xfer;
  input   [ 22: 0] nios2_burst_1_downstream_address;
  input            nios2_burst_1_downstream_burstcount;
  input   [  1: 0] nios2_burst_1_downstream_byteenable;
  input            nios2_burst_1_downstream_granted_sdram_0_s1;
  input            nios2_burst_1_downstream_qualified_request_sdram_0_s1;
  input            nios2_burst_1_downstream_read;
  input            nios2_burst_1_downstream_read_data_valid_sdram_0_s1;
  input            nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register;
  input            nios2_burst_1_downstream_requests_sdram_0_s1;
  input            nios2_burst_1_downstream_write;
  input   [ 15: 0] nios2_burst_1_downstream_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  reg     [ 22: 0] nios2_burst_1_downstream_address_last_time;
  wire    [ 22: 0] nios2_burst_1_downstream_address_to_slave;
  reg              nios2_burst_1_downstream_burstcount_last_time;
  reg     [  1: 0] nios2_burst_1_downstream_byteenable_last_time;
  wire             nios2_burst_1_downstream_is_granted_some_slave;
  reg              nios2_burst_1_downstream_latency_counter;
  reg              nios2_burst_1_downstream_read_but_no_slave_selected;
  reg              nios2_burst_1_downstream_read_last_time;
  wire    [ 15: 0] nios2_burst_1_downstream_readdata;
  wire             nios2_burst_1_downstream_readdatavalid;
  wire             nios2_burst_1_downstream_reset_n;
  wire             nios2_burst_1_downstream_run;
  wire             nios2_burst_1_downstream_waitrequest;
  reg              nios2_burst_1_downstream_write_last_time;
  reg     [ 15: 0] nios2_burst_1_downstream_writedata_last_time;
  wire             p1_nios2_burst_1_downstream_latency_counter;
  wire             pre_flush_nios2_burst_1_downstream_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (nios2_burst_1_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_1_downstream_requests_sdram_0_s1) & (nios2_burst_1_downstream_granted_sdram_0_s1 | ~nios2_burst_1_downstream_qualified_request_sdram_0_s1) & ((~nios2_burst_1_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_1_downstream_read | (1 & ~sdram_0_s1_waitrequest_from_sa & nios2_burst_1_downstream_read))) & ((~nios2_burst_1_downstream_qualified_request_sdram_0_s1 | ~nios2_burst_1_downstream_write | (1 & ~sdram_0_s1_waitrequest_from_sa & nios2_burst_1_downstream_write)));

  //cascaded wait assignment, which is an e_assign
  assign nios2_burst_1_downstream_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_burst_1_downstream_address_to_slave = nios2_burst_1_downstream_address;

  //nios2_burst_1_downstream_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_read_but_no_slave_selected <= 0;
      else 
        nios2_burst_1_downstream_read_but_no_slave_selected <= nios2_burst_1_downstream_read & nios2_burst_1_downstream_run & ~nios2_burst_1_downstream_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign nios2_burst_1_downstream_is_granted_some_slave = nios2_burst_1_downstream_granted_sdram_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_nios2_burst_1_downstream_readdatavalid = nios2_burst_1_downstream_read_data_valid_sdram_0_s1;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign nios2_burst_1_downstream_readdatavalid = nios2_burst_1_downstream_read_but_no_slave_selected |
    pre_flush_nios2_burst_1_downstream_readdatavalid;

  //nios2_burst_1/downstream readdata mux, which is an e_mux
  assign nios2_burst_1_downstream_readdata = sdram_0_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign nios2_burst_1_downstream_waitrequest = ~nios2_burst_1_downstream_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_latency_counter <= 0;
      else 
        nios2_burst_1_downstream_latency_counter <= p1_nios2_burst_1_downstream_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_nios2_burst_1_downstream_latency_counter = ((nios2_burst_1_downstream_run & nios2_burst_1_downstream_read))? latency_load_value :
    (nios2_burst_1_downstream_latency_counter)? nios2_burst_1_downstream_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //nios2_burst_1_downstream_reset_n assignment, which is an e_assign
  assign nios2_burst_1_downstream_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2_burst_1_downstream_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_address_last_time <= 0;
      else 
        nios2_burst_1_downstream_address_last_time <= nios2_burst_1_downstream_address;
    end


  //nios2_burst_1/downstream waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= nios2_burst_1_downstream_waitrequest & (nios2_burst_1_downstream_read | nios2_burst_1_downstream_write);
    end


  //nios2_burst_1_downstream_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_address != nios2_burst_1_downstream_address_last_time))
        begin
          $write("%0d ns: nios2_burst_1_downstream_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_1_downstream_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_burstcount_last_time <= 0;
      else 
        nios2_burst_1_downstream_burstcount_last_time <= nios2_burst_1_downstream_burstcount;
    end


  //nios2_burst_1_downstream_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_burstcount != nios2_burst_1_downstream_burstcount_last_time))
        begin
          $write("%0d ns: nios2_burst_1_downstream_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_1_downstream_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_byteenable_last_time <= 0;
      else 
        nios2_burst_1_downstream_byteenable_last_time <= nios2_burst_1_downstream_byteenable;
    end


  //nios2_burst_1_downstream_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_byteenable != nios2_burst_1_downstream_byteenable_last_time))
        begin
          $write("%0d ns: nios2_burst_1_downstream_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_1_downstream_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_read_last_time <= 0;
      else 
        nios2_burst_1_downstream_read_last_time <= nios2_burst_1_downstream_read;
    end


  //nios2_burst_1_downstream_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_read != nios2_burst_1_downstream_read_last_time))
        begin
          $write("%0d ns: nios2_burst_1_downstream_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_1_downstream_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_write_last_time <= 0;
      else 
        nios2_burst_1_downstream_write_last_time <= nios2_burst_1_downstream_write;
    end


  //nios2_burst_1_downstream_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_write != nios2_burst_1_downstream_write_last_time))
        begin
          $write("%0d ns: nios2_burst_1_downstream_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_burst_1_downstream_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_burst_1_downstream_writedata_last_time <= 0;
      else 
        nios2_burst_1_downstream_writedata_last_time <= nios2_burst_1_downstream_writedata;
    end


  //nios2_burst_1_downstream_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_burst_1_downstream_writedata != nios2_burst_1_downstream_writedata_last_time) & nios2_burst_1_downstream_write)
        begin
          $write("%0d ns: nios2_burst_1_downstream_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module (
                                                             // inputs:
                                                              clear_fifo,
                                                              clk,
                                                              data_in,
                                                              read,
                                                              reset_n,
                                                              sync_reset,
                                                              write,

                                                             // outputs:
                                                              data_out,
                                                              empty,
                                                              fifo_contains_ones_n,
                                                              full
                                                           )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module (
                                                                    // inputs:
                                                                     clear_fifo,
                                                                     clk,
                                                                     data_in,
                                                                     read,
                                                                     reset_n,
                                                                     sync_reset,
                                                                     write,

                                                                    // outputs:
                                                                     data_out,
                                                                     empty,
                                                                     fifo_contains_ones_n,
                                                                     full
                                                                  )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios2_burst_0_downstream_to_sdram_0_s1_module (
                                                                    // inputs:
                                                                     clear_fifo,
                                                                     clk,
                                                                     data_in,
                                                                     read,
                                                                     reset_n,
                                                                     sync_reset,
                                                                     write,

                                                                    // outputs:
                                                                     data_out,
                                                                     empty,
                                                                     fifo_contains_ones_n,
                                                                     full
                                                                  )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios2_burst_1_downstream_to_sdram_0_s1_module (
                                                                    // inputs:
                                                                     clear_fifo,
                                                                     clk,
                                                                     data_in,
                                                                     read,
                                                                     reset_n,
                                                                     sync_reset,
                                                                     write,

                                                                    // outputs:
                                                                     data_out,
                                                                     empty,
                                                                     fifo_contains_ones_n,
                                                                     full
                                                                  )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_0_s1_arbitrator (
                               // inputs:
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_byteenable,
                                cpu_0_data_master_dbs_address,
                                cpu_0_data_master_dbs_write_16,
                                cpu_0_data_master_no_byte_enables_and_last_term,
                                cpu_0_data_master_read,
                                cpu_0_data_master_waitrequest,
                                cpu_0_data_master_write,
                                cpu_0_instruction_master_address_to_slave,
                                cpu_0_instruction_master_dbs_address,
                                cpu_0_instruction_master_latency_counter,
                                cpu_0_instruction_master_read,
                                nios2_burst_0_downstream_address_to_slave,
                                nios2_burst_0_downstream_arbitrationshare,
                                nios2_burst_0_downstream_burstcount,
                                nios2_burst_0_downstream_byteenable,
                                nios2_burst_0_downstream_latency_counter,
                                nios2_burst_0_downstream_read,
                                nios2_burst_0_downstream_write,
                                nios2_burst_0_downstream_writedata,
                                nios2_burst_1_downstream_address_to_slave,
                                nios2_burst_1_downstream_arbitrationshare,
                                nios2_burst_1_downstream_burstcount,
                                nios2_burst_1_downstream_byteenable,
                                nios2_burst_1_downstream_latency_counter,
                                nios2_burst_1_downstream_read,
                                nios2_burst_1_downstream_write,
                                nios2_burst_1_downstream_writedata,
                                reset_n,
                                sdram_0_s1_readdata,
                                sdram_0_s1_readdatavalid,
                                sdram_0_s1_waitrequest,

                               // outputs:
                                cpu_0_data_master_byteenable_sdram_0_s1,
                                cpu_0_data_master_granted_sdram_0_s1,
                                cpu_0_data_master_qualified_request_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_data_master_requests_sdram_0_s1,
                                cpu_0_instruction_master_granted_sdram_0_s1,
                                cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_instruction_master_requests_sdram_0_s1,
                                d1_sdram_0_s1_end_xfer,
                                nios2_burst_0_downstream_granted_sdram_0_s1,
                                nios2_burst_0_downstream_qualified_request_sdram_0_s1,
                                nios2_burst_0_downstream_read_data_valid_sdram_0_s1,
                                nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register,
                                nios2_burst_0_downstream_requests_sdram_0_s1,
                                nios2_burst_1_downstream_granted_sdram_0_s1,
                                nios2_burst_1_downstream_qualified_request_sdram_0_s1,
                                nios2_burst_1_downstream_read_data_valid_sdram_0_s1,
                                nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register,
                                nios2_burst_1_downstream_requests_sdram_0_s1,
                                sdram_0_s1_address,
                                sdram_0_s1_byteenable_n,
                                sdram_0_s1_chipselect,
                                sdram_0_s1_read_n,
                                sdram_0_s1_readdata_from_sa,
                                sdram_0_s1_reset_n,
                                sdram_0_s1_waitrequest_from_sa,
                                sdram_0_s1_write_n,
                                sdram_0_s1_writedata
                             )
;

  output  [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  output           cpu_0_data_master_granted_sdram_0_s1;
  output           cpu_0_data_master_qualified_request_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_data_master_requests_sdram_0_s1;
  output           cpu_0_instruction_master_granted_sdram_0_s1;
  output           cpu_0_instruction_master_qualified_request_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_instruction_master_requests_sdram_0_s1;
  output           d1_sdram_0_s1_end_xfer;
  output           nios2_burst_0_downstream_granted_sdram_0_s1;
  output           nios2_burst_0_downstream_qualified_request_sdram_0_s1;
  output           nios2_burst_0_downstream_read_data_valid_sdram_0_s1;
  output           nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register;
  output           nios2_burst_0_downstream_requests_sdram_0_s1;
  output           nios2_burst_1_downstream_granted_sdram_0_s1;
  output           nios2_burst_1_downstream_qualified_request_sdram_0_s1;
  output           nios2_burst_1_downstream_read_data_valid_sdram_0_s1;
  output           nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register;
  output           nios2_burst_1_downstream_requests_sdram_0_s1;
  output  [ 21: 0] sdram_0_s1_address;
  output  [  1: 0] sdram_0_s1_byteenable_n;
  output           sdram_0_s1_chipselect;
  output           sdram_0_s1_read_n;
  output  [ 15: 0] sdram_0_s1_readdata_from_sa;
  output           sdram_0_s1_reset_n;
  output           sdram_0_s1_waitrequest_from_sa;
  output           sdram_0_s1_write_n;
  output  [ 15: 0] sdram_0_s1_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 27: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input   [ 22: 0] nios2_burst_0_downstream_address_to_slave;
  input   [  4: 0] nios2_burst_0_downstream_arbitrationshare;
  input            nios2_burst_0_downstream_burstcount;
  input   [  1: 0] nios2_burst_0_downstream_byteenable;
  input            nios2_burst_0_downstream_latency_counter;
  input            nios2_burst_0_downstream_read;
  input            nios2_burst_0_downstream_write;
  input   [ 15: 0] nios2_burst_0_downstream_writedata;
  input   [ 22: 0] nios2_burst_1_downstream_address_to_slave;
  input   [  4: 0] nios2_burst_1_downstream_arbitrationshare;
  input            nios2_burst_1_downstream_burstcount;
  input   [  1: 0] nios2_burst_1_downstream_byteenable;
  input            nios2_burst_1_downstream_latency_counter;
  input            nios2_burst_1_downstream_read;
  input            nios2_burst_1_downstream_write;
  input   [ 15: 0] nios2_burst_1_downstream_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata;
  input            sdram_0_s1_readdatavalid;
  input            sdram_0_s1_waitrequest;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_saved_grant_sdram_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_saved_grant_sdram_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sdram_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sdram_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
  reg              last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1;
  reg              last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1;
  wire             nios2_burst_0_downstream_arbiterlock;
  wire             nios2_burst_0_downstream_arbiterlock2;
  wire             nios2_burst_0_downstream_continuerequest;
  wire             nios2_burst_0_downstream_granted_sdram_0_s1;
  wire             nios2_burst_0_downstream_qualified_request_sdram_0_s1;
  wire             nios2_burst_0_downstream_rdv_fifo_empty_sdram_0_s1;
  wire             nios2_burst_0_downstream_rdv_fifo_output_from_sdram_0_s1;
  wire             nios2_burst_0_downstream_read_data_valid_sdram_0_s1;
  wire             nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register;
  wire             nios2_burst_0_downstream_requests_sdram_0_s1;
  wire             nios2_burst_0_downstream_saved_grant_sdram_0_s1;
  wire             nios2_burst_1_downstream_arbiterlock;
  wire             nios2_burst_1_downstream_arbiterlock2;
  wire             nios2_burst_1_downstream_continuerequest;
  wire             nios2_burst_1_downstream_granted_sdram_0_s1;
  wire             nios2_burst_1_downstream_qualified_request_sdram_0_s1;
  wire             nios2_burst_1_downstream_rdv_fifo_empty_sdram_0_s1;
  wire             nios2_burst_1_downstream_rdv_fifo_output_from_sdram_0_s1;
  wire             nios2_burst_1_downstream_read_data_valid_sdram_0_s1;
  wire             nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register;
  wire             nios2_burst_1_downstream_requests_sdram_0_s1;
  wire             nios2_burst_1_downstream_saved_grant_sdram_0_s1;
  wire    [ 21: 0] sdram_0_s1_address;
  wire             sdram_0_s1_allgrants;
  wire             sdram_0_s1_allow_new_arb_cycle;
  wire             sdram_0_s1_any_bursting_master_saved_grant;
  wire             sdram_0_s1_any_continuerequest;
  reg     [  3: 0] sdram_0_s1_arb_addend;
  wire             sdram_0_s1_arb_counter_enable;
  reg     [  4: 0] sdram_0_s1_arb_share_counter;
  wire    [  4: 0] sdram_0_s1_arb_share_counter_next_value;
  wire    [  4: 0] sdram_0_s1_arb_share_set_values;
  wire    [  3: 0] sdram_0_s1_arb_winner;
  wire             sdram_0_s1_arbitration_holdoff_internal;
  wire             sdram_0_s1_beginbursttransfer_internal;
  wire             sdram_0_s1_begins_xfer;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire    [  7: 0] sdram_0_s1_chosen_master_double_vector;
  wire    [  3: 0] sdram_0_s1_chosen_master_rot_left;
  wire             sdram_0_s1_end_xfer;
  wire             sdram_0_s1_firsttransfer;
  wire    [  3: 0] sdram_0_s1_grant_vector;
  wire             sdram_0_s1_in_a_read_cycle;
  wire             sdram_0_s1_in_a_write_cycle;
  wire    [  3: 0] sdram_0_s1_master_qreq_vector;
  wire             sdram_0_s1_move_on_to_next_transaction;
  wire             sdram_0_s1_non_bursting_master_requests;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid_from_sa;
  reg              sdram_0_s1_reg_firsttransfer;
  wire             sdram_0_s1_reset_n;
  reg     [  3: 0] sdram_0_s1_saved_chosen_master_vector;
  reg              sdram_0_s1_slavearbiterlockenable;
  wire             sdram_0_s1_slavearbiterlockenable2;
  wire             sdram_0_s1_unreg_firsttransfer;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_waits_for_read;
  wire             sdram_0_s1_waits_for_write;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire    [ 27: 0] shifted_address_to_sdram_0_s1_from_cpu_0_data_master;
  wire    [ 27: 0] shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master;
  wire    [ 22: 0] shifted_address_to_sdram_0_s1_from_nios2_burst_0_downstream;
  wire    [ 22: 0] shifted_address_to_sdram_0_s1_from_nios2_burst_1_downstream;
  wire             wait_for_sdram_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sdram_0_s1_end_xfer;
    end


  assign sdram_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sdram_0_s1 | cpu_0_instruction_master_qualified_request_sdram_0_s1 | nios2_burst_0_downstream_qualified_request_sdram_0_s1 | nios2_burst_1_downstream_qualified_request_sdram_0_s1));
  //assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid;

  //assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata;

  assign cpu_0_data_master_requests_sdram_0_s1 = ({cpu_0_data_master_address_to_slave[27 : 23] , 23'b0} == 28'h8000000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest;

  //sdram_0_s1_arb_share_counter set values, which is an e_mux
  assign sdram_0_s1_arb_share_set_values = (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_arbitrationshare :
    (nios2_burst_1_downstream_granted_sdram_0_s1)? nios2_burst_1_downstream_arbitrationshare :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_arbitrationshare :
    (nios2_burst_1_downstream_granted_sdram_0_s1)? nios2_burst_1_downstream_arbitrationshare :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_arbitrationshare :
    (nios2_burst_1_downstream_granted_sdram_0_s1)? nios2_burst_1_downstream_arbitrationshare :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_arbitrationshare :
    (nios2_burst_1_downstream_granted_sdram_0_s1)? nios2_burst_1_downstream_arbitrationshare :
    1;

  //sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1;

  //sdram_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sdram_0_s1_any_bursting_master_saved_grant = 0 |
    nios2_burst_0_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_1_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_0_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_1_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_0_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_1_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_0_downstream_saved_grant_sdram_0_s1 |
    nios2_burst_1_downstream_saved_grant_sdram_0_s1;

  //sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_0_s1_arb_share_counter_next_value = sdram_0_s1_firsttransfer ? (sdram_0_s1_arb_share_set_values - 1) : |sdram_0_s1_arb_share_counter ? (sdram_0_s1_arb_share_counter - 1) : 0;

  //sdram_0_s1_allgrants all slave grants, which is an e_mux
  assign sdram_0_s1_allgrants = (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector) |
    (|sdram_0_s1_grant_vector);

  //sdram_0_s1_end_xfer assignment, which is an e_assign
  assign sdram_0_s1_end_xfer = ~(sdram_0_s1_waits_for_read | sdram_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sdram_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sdram_0_s1 = sdram_0_s1_end_xfer & (~sdram_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sdram_0_s1 & sdram_0_s1_allgrants) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests);

  //sdram_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_share_counter <= 0;
      else if (sdram_0_s1_arb_counter_enable)
          sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
    end


  //sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sdram_0_s1) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests))
          sdram_0_s1_slavearbiterlockenable <= |sdram_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_0_s1_slavearbiterlockenable2 = |sdram_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= cpu_0_instruction_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1);

  //sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sdram_0_s1_any_continuerequest = cpu_0_instruction_master_continuerequest |
    nios2_burst_0_downstream_continuerequest |
    nios2_burst_1_downstream_continuerequest |
    cpu_0_data_master_continuerequest |
    nios2_burst_0_downstream_continuerequest |
    nios2_burst_1_downstream_continuerequest |
    cpu_0_data_master_continuerequest |
    cpu_0_instruction_master_continuerequest |
    nios2_burst_1_downstream_continuerequest |
    cpu_0_data_master_continuerequest |
    cpu_0_instruction_master_continuerequest |
    nios2_burst_0_downstream_continuerequest;

  //nios2_burst_0/downstream sdram_0/s1 arbiterlock, which is an e_assign
  assign nios2_burst_0_downstream_arbiterlock = sdram_0_s1_slavearbiterlockenable & nios2_burst_0_downstream_continuerequest;

  //nios2_burst_0/downstream sdram_0/s1 arbiterlock2, which is an e_assign
  assign nios2_burst_0_downstream_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & nios2_burst_0_downstream_continuerequest;

  //nios2_burst_0/downstream granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1 <= nios2_burst_0_downstream_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~nios2_burst_0_downstream_requests_sdram_0_s1) ? 0 : last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1;
    end


  //nios2_burst_0_downstream_continuerequest continued request, which is an e_mux
  assign nios2_burst_0_downstream_continuerequest = (last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1 & 1) |
    (last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1 & 1) |
    (last_cycle_nios2_burst_0_downstream_granted_slave_sdram_0_s1 & 1);

  //nios2_burst_1/downstream sdram_0/s1 arbiterlock, which is an e_assign
  assign nios2_burst_1_downstream_arbiterlock = sdram_0_s1_slavearbiterlockenable & nios2_burst_1_downstream_continuerequest;

  //nios2_burst_1/downstream sdram_0/s1 arbiterlock2, which is an e_assign
  assign nios2_burst_1_downstream_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & nios2_burst_1_downstream_continuerequest;

  //nios2_burst_1/downstream granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1 <= nios2_burst_1_downstream_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~nios2_burst_1_downstream_requests_sdram_0_s1) ? 0 : last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1;
    end


  //nios2_burst_1_downstream_continuerequest continued request, which is an e_mux
  assign nios2_burst_1_downstream_continuerequest = (last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1 & 1) |
    (last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1 & 1) |
    (last_cycle_nios2_burst_1_downstream_granted_slave_sdram_0_s1 & 1);

  assign cpu_0_data_master_qualified_request_sdram_0_s1 = cpu_0_data_master_requests_sdram_0_s1 & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((~cpu_0_data_master_waitrequest | cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_sdram_0_s1) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock | nios2_burst_0_downstream_arbiterlock | nios2_burst_1_downstream_arbiterlock);
  //unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_0_s1_move_on_to_next_transaction = sdram_0_s1_readdatavalid_from_sa;

  //rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_data_master_granted_sdram_0_s1),
      .data_out             (cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_data_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_data_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;

  //sdram_0_s1_writedata mux, which is an e_mux
  assign sdram_0_s1_writedata = (cpu_0_data_master_granted_sdram_0_s1)? cpu_0_data_master_dbs_write_16 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_writedata :
    nios2_burst_1_downstream_writedata;

  assign cpu_0_instruction_master_requests_sdram_0_s1 = (({cpu_0_instruction_master_address_to_slave[27 : 23] , 23'b0} == 28'h8000000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= cpu_0_data_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_data_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1) |
    (last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1);

  assign cpu_0_instruction_master_qualified_request_sdram_0_s1 = cpu_0_instruction_master_requests_sdram_0_s1 & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (1 < cpu_0_instruction_master_latency_counter))) | cpu_0_data_master_arbiterlock | nios2_burst_0_downstream_arbiterlock | nios2_burst_1_downstream_arbiterlock);
  //rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_instruction_master_granted_sdram_0_s1),
      .data_out             (cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_instruction_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;

  assign nios2_burst_0_downstream_requests_sdram_0_s1 = (1) & (nios2_burst_0_downstream_read | nios2_burst_0_downstream_write);
  assign nios2_burst_0_downstream_qualified_request_sdram_0_s1 = nios2_burst_0_downstream_requests_sdram_0_s1 & ~((nios2_burst_0_downstream_read & ((nios2_burst_0_downstream_latency_counter != 0) | (1 < nios2_burst_0_downstream_latency_counter))) | cpu_0_data_master_arbiterlock | cpu_0_instruction_master_arbiterlock | nios2_burst_1_downstream_arbiterlock);
  //rdv_fifo_for_nios2_burst_0_downstream_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios2_burst_0_downstream_to_sdram_0_s1_module rdv_fifo_for_nios2_burst_0_downstream_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios2_burst_0_downstream_granted_sdram_0_s1),
      .data_out             (nios2_burst_0_downstream_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (nios2_burst_0_downstream_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register = ~nios2_burst_0_downstream_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid nios2_burst_0_downstream_read_data_valid_sdram_0_s1, which is an e_mux
  assign nios2_burst_0_downstream_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & nios2_burst_0_downstream_rdv_fifo_output_from_sdram_0_s1) & ~ nios2_burst_0_downstream_rdv_fifo_empty_sdram_0_s1;

  assign nios2_burst_1_downstream_requests_sdram_0_s1 = (1) & (nios2_burst_1_downstream_read | nios2_burst_1_downstream_write);
  assign nios2_burst_1_downstream_qualified_request_sdram_0_s1 = nios2_burst_1_downstream_requests_sdram_0_s1 & ~((nios2_burst_1_downstream_read & ((nios2_burst_1_downstream_latency_counter != 0) | (1 < nios2_burst_1_downstream_latency_counter))) | cpu_0_data_master_arbiterlock | cpu_0_instruction_master_arbiterlock | nios2_burst_0_downstream_arbiterlock);
  //rdv_fifo_for_nios2_burst_1_downstream_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios2_burst_1_downstream_to_sdram_0_s1_module rdv_fifo_for_nios2_burst_1_downstream_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios2_burst_1_downstream_granted_sdram_0_s1),
      .data_out             (nios2_burst_1_downstream_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (nios2_burst_1_downstream_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register = ~nios2_burst_1_downstream_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid nios2_burst_1_downstream_read_data_valid_sdram_0_s1, which is an e_mux
  assign nios2_burst_1_downstream_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & nios2_burst_1_downstream_rdv_fifo_output_from_sdram_0_s1) & ~ nios2_burst_1_downstream_rdv_fifo_empty_sdram_0_s1;

  //allow new arb cycle for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock & ~nios2_burst_0_downstream_arbiterlock & ~nios2_burst_1_downstream_arbiterlock;

  //nios2_burst_1/downstream assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[0] = nios2_burst_1_downstream_qualified_request_sdram_0_s1;

  //nios2_burst_1/downstream grant sdram_0/s1, which is an e_assign
  assign nios2_burst_1_downstream_granted_sdram_0_s1 = sdram_0_s1_grant_vector[0];

  //nios2_burst_1/downstream saved-grant sdram_0/s1, which is an e_assign
  assign nios2_burst_1_downstream_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[0];

  //nios2_burst_0/downstream assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[1] = nios2_burst_0_downstream_qualified_request_sdram_0_s1;

  //nios2_burst_0/downstream grant sdram_0/s1, which is an e_assign
  assign nios2_burst_0_downstream_granted_sdram_0_s1 = sdram_0_s1_grant_vector[1];

  //nios2_burst_0/downstream saved-grant sdram_0/s1, which is an e_assign
  assign nios2_burst_0_downstream_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[1];

  //cpu_0/instruction_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[2] = cpu_0_instruction_master_qualified_request_sdram_0_s1;

  //cpu_0/instruction_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[2];

  //cpu_0/instruction_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[2] && cpu_0_instruction_master_requests_sdram_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[3] = cpu_0_data_master_qualified_request_sdram_0_s1;

  //cpu_0/data_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[3];

  //cpu_0/data_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[3] && cpu_0_data_master_requests_sdram_0_s1;

  //sdram_0/s1 chosen-master double-vector, which is an e_assign
  assign sdram_0_s1_chosen_master_double_vector = {sdram_0_s1_master_qreq_vector, sdram_0_s1_master_qreq_vector} & ({~sdram_0_s1_master_qreq_vector, ~sdram_0_s1_master_qreq_vector} + sdram_0_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sdram_0_s1_arb_winner = (sdram_0_s1_allow_new_arb_cycle & | sdram_0_s1_grant_vector) ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;

  //saved sdram_0_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_saved_chosen_master_vector <= 0;
      else if (sdram_0_s1_allow_new_arb_cycle)
          sdram_0_s1_saved_chosen_master_vector <= |sdram_0_s1_grant_vector ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sdram_0_s1_grant_vector = {(sdram_0_s1_chosen_master_double_vector[3] | sdram_0_s1_chosen_master_double_vector[7]),
    (sdram_0_s1_chosen_master_double_vector[2] | sdram_0_s1_chosen_master_double_vector[6]),
    (sdram_0_s1_chosen_master_double_vector[1] | sdram_0_s1_chosen_master_double_vector[5]),
    (sdram_0_s1_chosen_master_double_vector[0] | sdram_0_s1_chosen_master_double_vector[4])};

  //sdram_0/s1 chosen master rotated left, which is an e_assign
  assign sdram_0_s1_chosen_master_rot_left = (sdram_0_s1_arb_winner << 1) ? (sdram_0_s1_arb_winner << 1) : 1;

  //sdram_0/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_addend <= 1;
      else if (|sdram_0_s1_grant_vector)
          sdram_0_s1_arb_addend <= sdram_0_s1_end_xfer? sdram_0_s1_chosen_master_rot_left : sdram_0_s1_grant_vector;
    end


  //sdram_0_s1_reset_n assignment, which is an e_assign
  assign sdram_0_s1_reset_n = reset_n;

  assign sdram_0_s1_chipselect = cpu_0_data_master_granted_sdram_0_s1 | cpu_0_instruction_master_granted_sdram_0_s1 | nios2_burst_0_downstream_granted_sdram_0_s1 | nios2_burst_1_downstream_granted_sdram_0_s1;
  //sdram_0_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_firsttransfer = sdram_0_s1_begins_xfer ? sdram_0_s1_unreg_firsttransfer : sdram_0_s1_reg_firsttransfer;

  //sdram_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_unreg_firsttransfer = ~(sdram_0_s1_slavearbiterlockenable & sdram_0_s1_any_continuerequest);

  //sdram_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_reg_firsttransfer <= 1'b1;
      else if (sdram_0_s1_begins_xfer)
          sdram_0_s1_reg_firsttransfer <= sdram_0_s1_unreg_firsttransfer;
    end


  //sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_0_s1_beginbursttransfer_internal = sdram_0_s1_begins_xfer;

  //sdram_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sdram_0_s1_arbitration_holdoff_internal = sdram_0_s1_begins_xfer & sdram_0_s1_firsttransfer;

  //~sdram_0_s1_read_n assignment, which is an e_mux
  assign sdram_0_s1_read_n = ~((cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read) | (nios2_burst_0_downstream_granted_sdram_0_s1 & nios2_burst_0_downstream_read) | (nios2_burst_1_downstream_granted_sdram_0_s1 & nios2_burst_1_downstream_read));

  //~sdram_0_s1_write_n assignment, which is an e_mux
  assign sdram_0_s1_write_n = ~((cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write) | (nios2_burst_0_downstream_granted_sdram_0_s1 & nios2_burst_0_downstream_write) | (nios2_burst_1_downstream_granted_sdram_0_s1 & nios2_burst_1_downstream_write));

  assign shifted_address_to_sdram_0_s1_from_cpu_0_data_master = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1],
    {1 {1'b0}}};

  //sdram_0_s1_address mux, which is an e_mux
  assign sdram_0_s1_address = (cpu_0_data_master_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_cpu_0_data_master >> 1) :
    (cpu_0_instruction_master_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master >> 1) :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? (shifted_address_to_sdram_0_s1_from_nios2_burst_0_downstream >> 1) :
    (shifted_address_to_sdram_0_s1_from_nios2_burst_1_downstream >> 1);

  assign shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master = {cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  assign shifted_address_to_sdram_0_s1_from_nios2_burst_0_downstream = nios2_burst_0_downstream_address_to_slave;
  assign shifted_address_to_sdram_0_s1_from_nios2_burst_1_downstream = nios2_burst_1_downstream_address_to_slave;
  //d1_sdram_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_0_s1_end_xfer <= 1;
      else 
        d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end


  //sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_read = sdram_0_s1_in_a_read_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read) | (nios2_burst_0_downstream_granted_sdram_0_s1 & nios2_burst_0_downstream_read) | (nios2_burst_1_downstream_granted_sdram_0_s1 & nios2_burst_1_downstream_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_0_s1_in_a_read_cycle;

  //sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_write = sdram_0_s1_in_a_write_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_write_cycle = (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write) | (nios2_burst_0_downstream_granted_sdram_0_s1 & nios2_burst_0_downstream_write) | (nios2_burst_1_downstream_granted_sdram_0_s1 & nios2_burst_1_downstream_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_0_s1_in_a_write_cycle;

  assign wait_for_sdram_0_s1_counter = 0;
  //~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_0_s1_byteenable_n = ~((cpu_0_data_master_granted_sdram_0_s1)? cpu_0_data_master_byteenable_sdram_0_s1 :
    (nios2_burst_0_downstream_granted_sdram_0_s1)? nios2_burst_0_downstream_byteenable :
    (nios2_burst_1_downstream_granted_sdram_0_s1)? nios2_burst_1_downstream_byteenable :
    -1);

  assign {cpu_0_data_master_byteenable_sdram_0_s1_segment_1,
cpu_0_data_master_byteenable_sdram_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_sdram_0_s1 = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_sdram_0_s1_segment_0 :
    cpu_0_data_master_byteenable_sdram_0_s1_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sdram_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //nios2_burst_0/downstream non-zero arbitrationshare assertion, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_burst_0_downstream_requests_sdram_0_s1 && (nios2_burst_0_downstream_arbitrationshare == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: nios2_burst_0/downstream drove 0 on its 'arbitrationshare' port while accessing slave sdram_0/s1", $time);
          $stop;
        end
    end


  //nios2_burst_0/downstream non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_burst_0_downstream_requests_sdram_0_s1 && (nios2_burst_0_downstream_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: nios2_burst_0/downstream drove 0 on its 'burstcount' port while accessing slave sdram_0/s1", $time);
          $stop;
        end
    end


  //nios2_burst_1/downstream non-zero arbitrationshare assertion, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_burst_1_downstream_requests_sdram_0_s1 && (nios2_burst_1_downstream_arbitrationshare == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: nios2_burst_1/downstream drove 0 on its 'arbitrationshare' port while accessing slave sdram_0/s1", $time);
          $stop;
        end
    end


  //nios2_burst_1/downstream non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_burst_1_downstream_requests_sdram_0_s1 && (nios2_burst_1_downstream_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: nios2_burst_1/downstream drove 0 on its 'burstcount' port while accessing slave sdram_0/s1", $time);
          $stop;
        end
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_sdram_0_s1 + cpu_0_instruction_master_granted_sdram_0_s1 + nios2_burst_0_downstream_granted_sdram_0_s1 + nios2_burst_1_downstream_granted_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_sdram_0_s1 + cpu_0_instruction_master_saved_grant_sdram_0_s1 + nios2_burst_0_downstream_saved_grant_sdram_0_s1 + nios2_burst_1_downstream_saved_grant_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module spi_0_spi_control_port_arbitrator (
                                           // inputs:
                                            clk,
                                            cpu_0_data_master_address_to_slave,
                                            cpu_0_data_master_read,
                                            cpu_0_data_master_write,
                                            cpu_0_data_master_writedata,
                                            reset_n,
                                            spi_0_spi_control_port_dataavailable,
                                            spi_0_spi_control_port_endofpacket,
                                            spi_0_spi_control_port_irq,
                                            spi_0_spi_control_port_readdata,
                                            spi_0_spi_control_port_readyfordata,

                                           // outputs:
                                            cpu_0_data_master_granted_spi_0_spi_control_port,
                                            cpu_0_data_master_qualified_request_spi_0_spi_control_port,
                                            cpu_0_data_master_read_data_valid_spi_0_spi_control_port,
                                            cpu_0_data_master_requests_spi_0_spi_control_port,
                                            d1_spi_0_spi_control_port_end_xfer,
                                            spi_0_spi_control_port_address,
                                            spi_0_spi_control_port_chipselect,
                                            spi_0_spi_control_port_dataavailable_from_sa,
                                            spi_0_spi_control_port_endofpacket_from_sa,
                                            spi_0_spi_control_port_irq_from_sa,
                                            spi_0_spi_control_port_read_n,
                                            spi_0_spi_control_port_readdata_from_sa,
                                            spi_0_spi_control_port_readyfordata_from_sa,
                                            spi_0_spi_control_port_reset_n,
                                            spi_0_spi_control_port_write_n,
                                            spi_0_spi_control_port_writedata
                                         )
;

  output           cpu_0_data_master_granted_spi_0_spi_control_port;
  output           cpu_0_data_master_qualified_request_spi_0_spi_control_port;
  output           cpu_0_data_master_read_data_valid_spi_0_spi_control_port;
  output           cpu_0_data_master_requests_spi_0_spi_control_port;
  output           d1_spi_0_spi_control_port_end_xfer;
  output  [  2: 0] spi_0_spi_control_port_address;
  output           spi_0_spi_control_port_chipselect;
  output           spi_0_spi_control_port_dataavailable_from_sa;
  output           spi_0_spi_control_port_endofpacket_from_sa;
  output           spi_0_spi_control_port_irq_from_sa;
  output           spi_0_spi_control_port_read_n;
  output  [ 15: 0] spi_0_spi_control_port_readdata_from_sa;
  output           spi_0_spi_control_port_readyfordata_from_sa;
  output           spi_0_spi_control_port_reset_n;
  output           spi_0_spi_control_port_write_n;
  output  [ 15: 0] spi_0_spi_control_port_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            spi_0_spi_control_port_dataavailable;
  input            spi_0_spi_control_port_endofpacket;
  input            spi_0_spi_control_port_irq;
  input   [ 15: 0] spi_0_spi_control_port_readdata;
  input            spi_0_spi_control_port_readyfordata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_spi_0_spi_control_port;
  wire             cpu_0_data_master_qualified_request_spi_0_spi_control_port;
  wire             cpu_0_data_master_read_data_valid_spi_0_spi_control_port;
  wire             cpu_0_data_master_requests_spi_0_spi_control_port;
  wire             cpu_0_data_master_saved_grant_spi_0_spi_control_port;
  reg              d1_reasons_to_wait;
  reg              d1_spi_0_spi_control_port_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_spi_0_spi_control_port;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 27: 0] shifted_address_to_spi_0_spi_control_port_from_cpu_0_data_master;
  wire    [  2: 0] spi_0_spi_control_port_address;
  wire             spi_0_spi_control_port_allgrants;
  wire             spi_0_spi_control_port_allow_new_arb_cycle;
  wire             spi_0_spi_control_port_any_bursting_master_saved_grant;
  wire             spi_0_spi_control_port_any_continuerequest;
  wire             spi_0_spi_control_port_arb_counter_enable;
  reg     [  2: 0] spi_0_spi_control_port_arb_share_counter;
  wire    [  2: 0] spi_0_spi_control_port_arb_share_counter_next_value;
  wire    [  2: 0] spi_0_spi_control_port_arb_share_set_values;
  wire             spi_0_spi_control_port_beginbursttransfer_internal;
  wire             spi_0_spi_control_port_begins_xfer;
  wire             spi_0_spi_control_port_chipselect;
  wire             spi_0_spi_control_port_dataavailable_from_sa;
  wire             spi_0_spi_control_port_end_xfer;
  wire             spi_0_spi_control_port_endofpacket_from_sa;
  wire             spi_0_spi_control_port_firsttransfer;
  wire             spi_0_spi_control_port_grant_vector;
  wire             spi_0_spi_control_port_in_a_read_cycle;
  wire             spi_0_spi_control_port_in_a_write_cycle;
  wire             spi_0_spi_control_port_irq_from_sa;
  wire             spi_0_spi_control_port_master_qreq_vector;
  wire             spi_0_spi_control_port_non_bursting_master_requests;
  wire             spi_0_spi_control_port_read_n;
  wire    [ 15: 0] spi_0_spi_control_port_readdata_from_sa;
  wire             spi_0_spi_control_port_readyfordata_from_sa;
  reg              spi_0_spi_control_port_reg_firsttransfer;
  wire             spi_0_spi_control_port_reset_n;
  reg              spi_0_spi_control_port_slavearbiterlockenable;
  wire             spi_0_spi_control_port_slavearbiterlockenable2;
  wire             spi_0_spi_control_port_unreg_firsttransfer;
  wire             spi_0_spi_control_port_waits_for_read;
  wire             spi_0_spi_control_port_waits_for_write;
  wire             spi_0_spi_control_port_write_n;
  wire    [ 15: 0] spi_0_spi_control_port_writedata;
  wire             wait_for_spi_0_spi_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~spi_0_spi_control_port_end_xfer;
    end


  assign spi_0_spi_control_port_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_spi_0_spi_control_port));
  //assign spi_0_spi_control_port_readdata_from_sa = spi_0_spi_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign spi_0_spi_control_port_readdata_from_sa = spi_0_spi_control_port_readdata;

  assign cpu_0_data_master_requests_spi_0_spi_control_port = ({cpu_0_data_master_address_to_slave[27 : 5] , 5'b0} == 28'h70010e0) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign spi_0_spi_control_port_dataavailable_from_sa = spi_0_spi_control_port_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign spi_0_spi_control_port_dataavailable_from_sa = spi_0_spi_control_port_dataavailable;

  //assign spi_0_spi_control_port_readyfordata_from_sa = spi_0_spi_control_port_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign spi_0_spi_control_port_readyfordata_from_sa = spi_0_spi_control_port_readyfordata;

  //spi_0_spi_control_port_arb_share_counter set values, which is an e_mux
  assign spi_0_spi_control_port_arb_share_set_values = 1;

  //spi_0_spi_control_port_non_bursting_master_requests mux, which is an e_mux
  assign spi_0_spi_control_port_non_bursting_master_requests = cpu_0_data_master_requests_spi_0_spi_control_port;

  //spi_0_spi_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign spi_0_spi_control_port_any_bursting_master_saved_grant = 0;

  //spi_0_spi_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign spi_0_spi_control_port_arb_share_counter_next_value = spi_0_spi_control_port_firsttransfer ? (spi_0_spi_control_port_arb_share_set_values - 1) : |spi_0_spi_control_port_arb_share_counter ? (spi_0_spi_control_port_arb_share_counter - 1) : 0;

  //spi_0_spi_control_port_allgrants all slave grants, which is an e_mux
  assign spi_0_spi_control_port_allgrants = |spi_0_spi_control_port_grant_vector;

  //spi_0_spi_control_port_end_xfer assignment, which is an e_assign
  assign spi_0_spi_control_port_end_xfer = ~(spi_0_spi_control_port_waits_for_read | spi_0_spi_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_spi_0_spi_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_spi_0_spi_control_port = spi_0_spi_control_port_end_xfer & (~spi_0_spi_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //spi_0_spi_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign spi_0_spi_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_spi_0_spi_control_port & spi_0_spi_control_port_allgrants) | (end_xfer_arb_share_counter_term_spi_0_spi_control_port & ~spi_0_spi_control_port_non_bursting_master_requests);

  //spi_0_spi_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          spi_0_spi_control_port_arb_share_counter <= 0;
      else if (spi_0_spi_control_port_arb_counter_enable)
          spi_0_spi_control_port_arb_share_counter <= spi_0_spi_control_port_arb_share_counter_next_value;
    end


  //spi_0_spi_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          spi_0_spi_control_port_slavearbiterlockenable <= 0;
      else if ((|spi_0_spi_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_spi_0_spi_control_port) | (end_xfer_arb_share_counter_term_spi_0_spi_control_port & ~spi_0_spi_control_port_non_bursting_master_requests))
          spi_0_spi_control_port_slavearbiterlockenable <= |spi_0_spi_control_port_arb_share_counter_next_value;
    end


  //cpu_0/data_master spi_0/spi_control_port arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = spi_0_spi_control_port_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //spi_0_spi_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign spi_0_spi_control_port_slavearbiterlockenable2 = |spi_0_spi_control_port_arb_share_counter_next_value;

  //cpu_0/data_master spi_0/spi_control_port arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = spi_0_spi_control_port_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //spi_0_spi_control_port_any_continuerequest at least one master continues requesting, which is an e_assign
  assign spi_0_spi_control_port_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_spi_0_spi_control_port = cpu_0_data_master_requests_spi_0_spi_control_port;
  //spi_0_spi_control_port_writedata mux, which is an e_mux
  assign spi_0_spi_control_port_writedata = cpu_0_data_master_writedata;

  //assign spi_0_spi_control_port_endofpacket_from_sa = spi_0_spi_control_port_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign spi_0_spi_control_port_endofpacket_from_sa = spi_0_spi_control_port_endofpacket;

  //master is always granted when requested
  assign cpu_0_data_master_granted_spi_0_spi_control_port = cpu_0_data_master_qualified_request_spi_0_spi_control_port;

  //cpu_0/data_master saved-grant spi_0/spi_control_port, which is an e_assign
  assign cpu_0_data_master_saved_grant_spi_0_spi_control_port = cpu_0_data_master_requests_spi_0_spi_control_port;

  //allow new arb cycle for spi_0/spi_control_port, which is an e_assign
  assign spi_0_spi_control_port_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign spi_0_spi_control_port_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign spi_0_spi_control_port_master_qreq_vector = 1;

  //spi_0_spi_control_port_reset_n assignment, which is an e_assign
  assign spi_0_spi_control_port_reset_n = reset_n;

  assign spi_0_spi_control_port_chipselect = cpu_0_data_master_granted_spi_0_spi_control_port;
  //spi_0_spi_control_port_firsttransfer first transaction, which is an e_assign
  assign spi_0_spi_control_port_firsttransfer = spi_0_spi_control_port_begins_xfer ? spi_0_spi_control_port_unreg_firsttransfer : spi_0_spi_control_port_reg_firsttransfer;

  //spi_0_spi_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign spi_0_spi_control_port_unreg_firsttransfer = ~(spi_0_spi_control_port_slavearbiterlockenable & spi_0_spi_control_port_any_continuerequest);

  //spi_0_spi_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          spi_0_spi_control_port_reg_firsttransfer <= 1'b1;
      else if (spi_0_spi_control_port_begins_xfer)
          spi_0_spi_control_port_reg_firsttransfer <= spi_0_spi_control_port_unreg_firsttransfer;
    end


  //spi_0_spi_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign spi_0_spi_control_port_beginbursttransfer_internal = spi_0_spi_control_port_begins_xfer;

  //~spi_0_spi_control_port_read_n assignment, which is an e_mux
  assign spi_0_spi_control_port_read_n = ~(cpu_0_data_master_granted_spi_0_spi_control_port & cpu_0_data_master_read);

  //~spi_0_spi_control_port_write_n assignment, which is an e_mux
  assign spi_0_spi_control_port_write_n = ~(cpu_0_data_master_granted_spi_0_spi_control_port & cpu_0_data_master_write);

  assign shifted_address_to_spi_0_spi_control_port_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //spi_0_spi_control_port_address mux, which is an e_mux
  assign spi_0_spi_control_port_address = shifted_address_to_spi_0_spi_control_port_from_cpu_0_data_master >> 2;

  //d1_spi_0_spi_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_spi_0_spi_control_port_end_xfer <= 1;
      else 
        d1_spi_0_spi_control_port_end_xfer <= spi_0_spi_control_port_end_xfer;
    end


  //spi_0_spi_control_port_waits_for_read in a cycle, which is an e_mux
  assign spi_0_spi_control_port_waits_for_read = spi_0_spi_control_port_in_a_read_cycle & spi_0_spi_control_port_begins_xfer;

  //spi_0_spi_control_port_in_a_read_cycle assignment, which is an e_assign
  assign spi_0_spi_control_port_in_a_read_cycle = cpu_0_data_master_granted_spi_0_spi_control_port & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = spi_0_spi_control_port_in_a_read_cycle;

  //spi_0_spi_control_port_waits_for_write in a cycle, which is an e_mux
  assign spi_0_spi_control_port_waits_for_write = spi_0_spi_control_port_in_a_write_cycle & spi_0_spi_control_port_begins_xfer;

  //spi_0_spi_control_port_in_a_write_cycle assignment, which is an e_assign
  assign spi_0_spi_control_port_in_a_write_cycle = cpu_0_data_master_granted_spi_0_spi_control_port & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = spi_0_spi_control_port_in_a_write_cycle;

  assign wait_for_spi_0_spi_control_port_counter = 0;
  //assign spi_0_spi_control_port_irq_from_sa = spi_0_spi_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign spi_0_spi_control_port_irq_from_sa = spi_0_spi_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //spi_0/spi_control_port enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_0_s1_arbitrator (
                               // inputs:
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_read,
                                cpu_0_data_master_waitrequest,
                                cpu_0_data_master_write,
                                cpu_0_data_master_writedata,
                                reset_n,
                                timer_0_s1_irq,
                                timer_0_s1_readdata,

                               // outputs:
                                cpu_0_data_master_granted_timer_0_s1,
                                cpu_0_data_master_qualified_request_timer_0_s1,
                                cpu_0_data_master_read_data_valid_timer_0_s1,
                                cpu_0_data_master_requests_timer_0_s1,
                                d1_timer_0_s1_end_xfer,
                                timer_0_s1_address,
                                timer_0_s1_chipselect,
                                timer_0_s1_irq_from_sa,
                                timer_0_s1_readdata_from_sa,
                                timer_0_s1_reset_n,
                                timer_0_s1_write_n,
                                timer_0_s1_writedata
                             )
;

  output           cpu_0_data_master_granted_timer_0_s1;
  output           cpu_0_data_master_qualified_request_timer_0_s1;
  output           cpu_0_data_master_read_data_valid_timer_0_s1;
  output           cpu_0_data_master_requests_timer_0_s1;
  output           d1_timer_0_s1_end_xfer;
  output  [  2: 0] timer_0_s1_address;
  output           timer_0_s1_chipselect;
  output           timer_0_s1_irq_from_sa;
  output  [ 15: 0] timer_0_s1_readdata_from_sa;
  output           timer_0_s1_reset_n;
  output           timer_0_s1_write_n;
  output  [ 15: 0] timer_0_s1_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            timer_0_s1_irq;
  input   [ 15: 0] timer_0_s1_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_timer_0_s1;
  wire             cpu_0_data_master_qualified_request_timer_0_s1;
  wire             cpu_0_data_master_read_data_valid_timer_0_s1;
  wire             cpu_0_data_master_requests_timer_0_s1;
  wire             cpu_0_data_master_saved_grant_timer_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_timer_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_timer_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 27: 0] shifted_address_to_timer_0_s1_from_cpu_0_data_master;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_allgrants;
  wire             timer_0_s1_allow_new_arb_cycle;
  wire             timer_0_s1_any_bursting_master_saved_grant;
  wire             timer_0_s1_any_continuerequest;
  wire             timer_0_s1_arb_counter_enable;
  reg     [  2: 0] timer_0_s1_arb_share_counter;
  wire    [  2: 0] timer_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] timer_0_s1_arb_share_set_values;
  wire             timer_0_s1_beginbursttransfer_internal;
  wire             timer_0_s1_begins_xfer;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_end_xfer;
  wire             timer_0_s1_firsttransfer;
  wire             timer_0_s1_grant_vector;
  wire             timer_0_s1_in_a_read_cycle;
  wire             timer_0_s1_in_a_write_cycle;
  wire             timer_0_s1_irq_from_sa;
  wire             timer_0_s1_master_qreq_vector;
  wire             timer_0_s1_non_bursting_master_requests;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  reg              timer_0_s1_reg_firsttransfer;
  wire             timer_0_s1_reset_n;
  reg              timer_0_s1_slavearbiterlockenable;
  wire             timer_0_s1_slavearbiterlockenable2;
  wire             timer_0_s1_unreg_firsttransfer;
  wire             timer_0_s1_waits_for_read;
  wire             timer_0_s1_waits_for_write;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  wire             wait_for_timer_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~timer_0_s1_end_xfer;
    end


  assign timer_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_timer_0_s1));
  //assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata;

  assign cpu_0_data_master_requests_timer_0_s1 = ({cpu_0_data_master_address_to_slave[27 : 5] , 5'b0} == 28'h7001040) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //timer_0_s1_arb_share_counter set values, which is an e_mux
  assign timer_0_s1_arb_share_set_values = 1;

  //timer_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign timer_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_timer_0_s1;

  //timer_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign timer_0_s1_any_bursting_master_saved_grant = 0;

  //timer_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign timer_0_s1_arb_share_counter_next_value = timer_0_s1_firsttransfer ? (timer_0_s1_arb_share_set_values - 1) : |timer_0_s1_arb_share_counter ? (timer_0_s1_arb_share_counter - 1) : 0;

  //timer_0_s1_allgrants all slave grants, which is an e_mux
  assign timer_0_s1_allgrants = |timer_0_s1_grant_vector;

  //timer_0_s1_end_xfer assignment, which is an e_assign
  assign timer_0_s1_end_xfer = ~(timer_0_s1_waits_for_read | timer_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_timer_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_timer_0_s1 = timer_0_s1_end_xfer & (~timer_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //timer_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign timer_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_timer_0_s1 & timer_0_s1_allgrants) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests);

  //timer_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_arb_share_counter <= 0;
      else if (timer_0_s1_arb_counter_enable)
          timer_0_s1_arb_share_counter <= timer_0_s1_arb_share_counter_next_value;
    end


  //timer_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_slavearbiterlockenable <= 0;
      else if ((|timer_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_timer_0_s1) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests))
          timer_0_s1_slavearbiterlockenable <= |timer_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master timer_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = timer_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //timer_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign timer_0_s1_slavearbiterlockenable2 = |timer_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master timer_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = timer_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //timer_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign timer_0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_timer_0_s1 = cpu_0_data_master_requests_timer_0_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //timer_0_s1_writedata mux, which is an e_mux
  assign timer_0_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_timer_0_s1 = cpu_0_data_master_qualified_request_timer_0_s1;

  //cpu_0/data_master saved-grant timer_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_timer_0_s1 = cpu_0_data_master_requests_timer_0_s1;

  //allow new arb cycle for timer_0/s1, which is an e_assign
  assign timer_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign timer_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign timer_0_s1_master_qreq_vector = 1;

  //timer_0_s1_reset_n assignment, which is an e_assign
  assign timer_0_s1_reset_n = reset_n;

  assign timer_0_s1_chipselect = cpu_0_data_master_granted_timer_0_s1;
  //timer_0_s1_firsttransfer first transaction, which is an e_assign
  assign timer_0_s1_firsttransfer = timer_0_s1_begins_xfer ? timer_0_s1_unreg_firsttransfer : timer_0_s1_reg_firsttransfer;

  //timer_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign timer_0_s1_unreg_firsttransfer = ~(timer_0_s1_slavearbiterlockenable & timer_0_s1_any_continuerequest);

  //timer_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_reg_firsttransfer <= 1'b1;
      else if (timer_0_s1_begins_xfer)
          timer_0_s1_reg_firsttransfer <= timer_0_s1_unreg_firsttransfer;
    end


  //timer_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign timer_0_s1_beginbursttransfer_internal = timer_0_s1_begins_xfer;

  //~timer_0_s1_write_n assignment, which is an e_mux
  assign timer_0_s1_write_n = ~(cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_write);

  assign shifted_address_to_timer_0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //timer_0_s1_address mux, which is an e_mux
  assign timer_0_s1_address = shifted_address_to_timer_0_s1_from_cpu_0_data_master >> 2;

  //d1_timer_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_timer_0_s1_end_xfer <= 1;
      else 
        d1_timer_0_s1_end_xfer <= timer_0_s1_end_xfer;
    end


  //timer_0_s1_waits_for_read in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_read = timer_0_s1_in_a_read_cycle & timer_0_s1_begins_xfer;

  //timer_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_read_cycle = cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = timer_0_s1_in_a_read_cycle;

  //timer_0_s1_waits_for_write in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_write = timer_0_s1_in_a_write_cycle & 0;

  //timer_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_write_cycle = cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = timer_0_s1_in_a_write_cycle;

  assign wait_for_timer_0_s1_counter = 0;
  //assign timer_0_s1_irq_from_sa = timer_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_irq_from_sa = timer_0_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //timer_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_1_s1_arbitrator (
                               // inputs:
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_read,
                                cpu_0_data_master_waitrequest,
                                cpu_0_data_master_write,
                                cpu_0_data_master_writedata,
                                reset_n,
                                timer_1_s1_irq,
                                timer_1_s1_readdata,

                               // outputs:
                                cpu_0_data_master_granted_timer_1_s1,
                                cpu_0_data_master_qualified_request_timer_1_s1,
                                cpu_0_data_master_read_data_valid_timer_1_s1,
                                cpu_0_data_master_requests_timer_1_s1,
                                d1_timer_1_s1_end_xfer,
                                timer_1_s1_address,
                                timer_1_s1_chipselect,
                                timer_1_s1_irq_from_sa,
                                timer_1_s1_readdata_from_sa,
                                timer_1_s1_reset_n,
                                timer_1_s1_write_n,
                                timer_1_s1_writedata
                             )
;

  output           cpu_0_data_master_granted_timer_1_s1;
  output           cpu_0_data_master_qualified_request_timer_1_s1;
  output           cpu_0_data_master_read_data_valid_timer_1_s1;
  output           cpu_0_data_master_requests_timer_1_s1;
  output           d1_timer_1_s1_end_xfer;
  output  [  2: 0] timer_1_s1_address;
  output           timer_1_s1_chipselect;
  output           timer_1_s1_irq_from_sa;
  output  [ 15: 0] timer_1_s1_readdata_from_sa;
  output           timer_1_s1_reset_n;
  output           timer_1_s1_write_n;
  output  [ 15: 0] timer_1_s1_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            timer_1_s1_irq;
  input   [ 15: 0] timer_1_s1_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_timer_1_s1;
  wire             cpu_0_data_master_qualified_request_timer_1_s1;
  wire             cpu_0_data_master_read_data_valid_timer_1_s1;
  wire             cpu_0_data_master_requests_timer_1_s1;
  wire             cpu_0_data_master_saved_grant_timer_1_s1;
  reg              d1_reasons_to_wait;
  reg              d1_timer_1_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_timer_1_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 27: 0] shifted_address_to_timer_1_s1_from_cpu_0_data_master;
  wire    [  2: 0] timer_1_s1_address;
  wire             timer_1_s1_allgrants;
  wire             timer_1_s1_allow_new_arb_cycle;
  wire             timer_1_s1_any_bursting_master_saved_grant;
  wire             timer_1_s1_any_continuerequest;
  wire             timer_1_s1_arb_counter_enable;
  reg     [  2: 0] timer_1_s1_arb_share_counter;
  wire    [  2: 0] timer_1_s1_arb_share_counter_next_value;
  wire    [  2: 0] timer_1_s1_arb_share_set_values;
  wire             timer_1_s1_beginbursttransfer_internal;
  wire             timer_1_s1_begins_xfer;
  wire             timer_1_s1_chipselect;
  wire             timer_1_s1_end_xfer;
  wire             timer_1_s1_firsttransfer;
  wire             timer_1_s1_grant_vector;
  wire             timer_1_s1_in_a_read_cycle;
  wire             timer_1_s1_in_a_write_cycle;
  wire             timer_1_s1_irq_from_sa;
  wire             timer_1_s1_master_qreq_vector;
  wire             timer_1_s1_non_bursting_master_requests;
  wire    [ 15: 0] timer_1_s1_readdata_from_sa;
  reg              timer_1_s1_reg_firsttransfer;
  wire             timer_1_s1_reset_n;
  reg              timer_1_s1_slavearbiterlockenable;
  wire             timer_1_s1_slavearbiterlockenable2;
  wire             timer_1_s1_unreg_firsttransfer;
  wire             timer_1_s1_waits_for_read;
  wire             timer_1_s1_waits_for_write;
  wire             timer_1_s1_write_n;
  wire    [ 15: 0] timer_1_s1_writedata;
  wire             wait_for_timer_1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~timer_1_s1_end_xfer;
    end


  assign timer_1_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_timer_1_s1));
  //assign timer_1_s1_readdata_from_sa = timer_1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_1_s1_readdata_from_sa = timer_1_s1_readdata;

  assign cpu_0_data_master_requests_timer_1_s1 = ({cpu_0_data_master_address_to_slave[27 : 5] , 5'b0} == 28'h7001060) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //timer_1_s1_arb_share_counter set values, which is an e_mux
  assign timer_1_s1_arb_share_set_values = 1;

  //timer_1_s1_non_bursting_master_requests mux, which is an e_mux
  assign timer_1_s1_non_bursting_master_requests = cpu_0_data_master_requests_timer_1_s1;

  //timer_1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign timer_1_s1_any_bursting_master_saved_grant = 0;

  //timer_1_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign timer_1_s1_arb_share_counter_next_value = timer_1_s1_firsttransfer ? (timer_1_s1_arb_share_set_values - 1) : |timer_1_s1_arb_share_counter ? (timer_1_s1_arb_share_counter - 1) : 0;

  //timer_1_s1_allgrants all slave grants, which is an e_mux
  assign timer_1_s1_allgrants = |timer_1_s1_grant_vector;

  //timer_1_s1_end_xfer assignment, which is an e_assign
  assign timer_1_s1_end_xfer = ~(timer_1_s1_waits_for_read | timer_1_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_timer_1_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_timer_1_s1 = timer_1_s1_end_xfer & (~timer_1_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //timer_1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign timer_1_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_timer_1_s1 & timer_1_s1_allgrants) | (end_xfer_arb_share_counter_term_timer_1_s1 & ~timer_1_s1_non_bursting_master_requests);

  //timer_1_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_1_s1_arb_share_counter <= 0;
      else if (timer_1_s1_arb_counter_enable)
          timer_1_s1_arb_share_counter <= timer_1_s1_arb_share_counter_next_value;
    end


  //timer_1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_1_s1_slavearbiterlockenable <= 0;
      else if ((|timer_1_s1_master_qreq_vector & end_xfer_arb_share_counter_term_timer_1_s1) | (end_xfer_arb_share_counter_term_timer_1_s1 & ~timer_1_s1_non_bursting_master_requests))
          timer_1_s1_slavearbiterlockenable <= |timer_1_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master timer_1/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = timer_1_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //timer_1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign timer_1_s1_slavearbiterlockenable2 = |timer_1_s1_arb_share_counter_next_value;

  //cpu_0/data_master timer_1/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = timer_1_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //timer_1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign timer_1_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_timer_1_s1 = cpu_0_data_master_requests_timer_1_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //timer_1_s1_writedata mux, which is an e_mux
  assign timer_1_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_timer_1_s1 = cpu_0_data_master_qualified_request_timer_1_s1;

  //cpu_0/data_master saved-grant timer_1/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_timer_1_s1 = cpu_0_data_master_requests_timer_1_s1;

  //allow new arb cycle for timer_1/s1, which is an e_assign
  assign timer_1_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign timer_1_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign timer_1_s1_master_qreq_vector = 1;

  //timer_1_s1_reset_n assignment, which is an e_assign
  assign timer_1_s1_reset_n = reset_n;

  assign timer_1_s1_chipselect = cpu_0_data_master_granted_timer_1_s1;
  //timer_1_s1_firsttransfer first transaction, which is an e_assign
  assign timer_1_s1_firsttransfer = timer_1_s1_begins_xfer ? timer_1_s1_unreg_firsttransfer : timer_1_s1_reg_firsttransfer;

  //timer_1_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign timer_1_s1_unreg_firsttransfer = ~(timer_1_s1_slavearbiterlockenable & timer_1_s1_any_continuerequest);

  //timer_1_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_1_s1_reg_firsttransfer <= 1'b1;
      else if (timer_1_s1_begins_xfer)
          timer_1_s1_reg_firsttransfer <= timer_1_s1_unreg_firsttransfer;
    end


  //timer_1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign timer_1_s1_beginbursttransfer_internal = timer_1_s1_begins_xfer;

  //~timer_1_s1_write_n assignment, which is an e_mux
  assign timer_1_s1_write_n = ~(cpu_0_data_master_granted_timer_1_s1 & cpu_0_data_master_write);

  assign shifted_address_to_timer_1_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //timer_1_s1_address mux, which is an e_mux
  assign timer_1_s1_address = shifted_address_to_timer_1_s1_from_cpu_0_data_master >> 2;

  //d1_timer_1_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_timer_1_s1_end_xfer <= 1;
      else 
        d1_timer_1_s1_end_xfer <= timer_1_s1_end_xfer;
    end


  //timer_1_s1_waits_for_read in a cycle, which is an e_mux
  assign timer_1_s1_waits_for_read = timer_1_s1_in_a_read_cycle & timer_1_s1_begins_xfer;

  //timer_1_s1_in_a_read_cycle assignment, which is an e_assign
  assign timer_1_s1_in_a_read_cycle = cpu_0_data_master_granted_timer_1_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = timer_1_s1_in_a_read_cycle;

  //timer_1_s1_waits_for_write in a cycle, which is an e_mux
  assign timer_1_s1_waits_for_write = timer_1_s1_in_a_write_cycle & 0;

  //timer_1_s1_in_a_write_cycle assignment, which is an e_assign
  assign timer_1_s1_in_a_write_cycle = cpu_0_data_master_granted_timer_1_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = timer_1_s1_in_a_write_cycle;

  assign wait_for_timer_1_s1_counter = 0;
  //assign timer_1_s1_irq_from_sa = timer_1_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_1_s1_irq_from_sa = timer_1_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //timer_1/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_avalon_slave_arbitrator (
                                                    // inputs:
                                                     clk,
                                                     cpu_0_data_master_address_to_slave,
                                                     cpu_0_data_master_byteenable,
                                                     cpu_0_data_master_dbs_address,
                                                     cpu_0_data_master_dbs_write_8,
                                                     cpu_0_data_master_no_byte_enables_and_last_term,
                                                     cpu_0_data_master_read,
                                                     cpu_0_data_master_write,
                                                     cpu_0_instruction_master_address_to_slave,
                                                     cpu_0_instruction_master_dbs_address,
                                                     cpu_0_instruction_master_latency_counter,
                                                     cpu_0_instruction_master_read,
                                                     cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                                     reset_n,

                                                    // outputs:
                                                     cfi_flash_0_s1_wait_counter_eq_0,
                                                     cfi_flash_0_s1_wait_counter_eq_1,
                                                     cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                                     cpu_0_data_master_granted_cfi_flash_0_s1,
                                                     cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_data_master_requests_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                                     d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                                     incoming_tri_state_bridge_0_data,
                                                     incoming_tri_state_bridge_0_data_with_Xs_converted_to_0,
                                                     registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                                     select_n_to_the_cfi_flash_0,
                                                     tri_state_bridge_0_address,
                                                     tri_state_bridge_0_data,
                                                     tri_state_bridge_0_readn,
                                                     write_n_to_the_cfi_flash_0
                                                  )
;

  output           cfi_flash_0_s1_wait_counter_eq_0;
  output           cfi_flash_0_s1_wait_counter_eq_1;
  output           cpu_0_data_master_byteenable_cfi_flash_0_s1;
  output           cpu_0_data_master_granted_cfi_flash_0_s1;
  output           cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_data_master_requests_cfi_flash_0_s1;
  output           cpu_0_instruction_master_granted_cfi_flash_0_s1;
  output           cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_instruction_master_requests_cfi_flash_0_s1;
  output           d1_tri_state_bridge_0_avalon_slave_end_xfer;
  output  [  7: 0] incoming_tri_state_bridge_0_data;
  output  [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  output           registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  output           select_n_to_the_cfi_flash_0;
  output  [ 21: 0] tri_state_bridge_0_address;
  inout   [  7: 0] tri_state_bridge_0_data;
  output           tri_state_bridge_0_readn;
  output           write_n_to_the_cfi_flash_0;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [  7: 0] cpu_0_data_master_dbs_write_8;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 27: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            reset_n;

  wire    [  4: 0] cfi_flash_0_s1_counter_load_value;
  wire             cfi_flash_0_s1_in_a_read_cycle;
  wire             cfi_flash_0_s1_in_a_write_cycle;
  wire             cfi_flash_0_s1_pretend_byte_enable;
  reg     [  4: 0] cfi_flash_0_s1_wait_counter;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             cfi_flash_0_s1_wait_counter_eq_1;
  wire             cfi_flash_0_s1_waits_for_read;
  wire             cfi_flash_0_s1_waits_for_write;
  wire             cfi_flash_0_s1_with_write_latency;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_saved_grant_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_saved_grant_cfi_flash_0_s1;
  reg              d1_in_a_write_cycle /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
  reg     [  7: 0] d1_outgoing_tri_state_bridge_0_data /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              d1_reasons_to_wait;
  reg              d1_tri_state_bridge_0_avalon_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg     [  7: 0] incoming_tri_state_bridge_0_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
  wire             incoming_tri_state_bridge_0_data_bit_0_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_1_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_2_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_3_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_4_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_5_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_6_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_7_is_x;
  wire    [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  reg              last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
  wire    [  7: 0] outgoing_tri_state_bridge_0_data;
  wire    [  1: 0] p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire    [  1: 0] p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             p1_select_n_to_the_cfi_flash_0;
  wire    [ 21: 0] p1_tri_state_bridge_0_address;
  wire             p1_tri_state_bridge_0_readn;
  wire             p1_write_n_to_the_cfi_flash_0;
  wire             registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  reg              select_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             time_to_write;
  reg     [ 21: 0] tri_state_bridge_0_address /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             tri_state_bridge_0_avalon_slave_allgrants;
  wire             tri_state_bridge_0_avalon_slave_allow_new_arb_cycle;
  wire             tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant;
  wire             tri_state_bridge_0_avalon_slave_any_continuerequest;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_arb_addend;
  wire             tri_state_bridge_0_avalon_slave_arb_counter_enable;
  reg     [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_set_values;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_arb_winner;
  wire             tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal;
  wire             tri_state_bridge_0_avalon_slave_beginbursttransfer_internal;
  wire             tri_state_bridge_0_avalon_slave_begins_xfer;
  wire    [  3: 0] tri_state_bridge_0_avalon_slave_chosen_master_double_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_chosen_master_rot_left;
  wire             tri_state_bridge_0_avalon_slave_end_xfer;
  wire             tri_state_bridge_0_avalon_slave_firsttransfer;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_grant_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_master_qreq_vector;
  wire             tri_state_bridge_0_avalon_slave_non_bursting_master_requests;
  wire             tri_state_bridge_0_avalon_slave_read_pending;
  reg              tri_state_bridge_0_avalon_slave_reg_firsttransfer;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
  reg              tri_state_bridge_0_avalon_slave_slavearbiterlockenable;
  wire             tri_state_bridge_0_avalon_slave_slavearbiterlockenable2;
  wire             tri_state_bridge_0_avalon_slave_unreg_firsttransfer;
  wire             tri_state_bridge_0_avalon_slave_write_pending;
  wire    [  7: 0] tri_state_bridge_0_data;
  reg              tri_state_bridge_0_readn /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             wait_for_cfi_flash_0_s1_counter;
  reg              write_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tri_state_bridge_0_avalon_slave_end_xfer;
    end


  assign tri_state_bridge_0_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1));
  assign cpu_0_data_master_requests_cfi_flash_0_s1 = ({cpu_0_data_master_address_to_slave[27 : 22] , 22'b0} == 28'h0) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //~select_n_to_the_cfi_flash_0 of type chipselect to ~p1_select_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          select_n_to_the_cfi_flash_0 <= ~0;
      else 
        select_n_to_the_cfi_flash_0 <= p1_select_n_to_the_cfi_flash_0;
    end


  assign tri_state_bridge_0_avalon_slave_write_pending = 0;
  //tri_state_bridge_0/avalon_slave read pending calc, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_read_pending = 0;

  //registered rdv signal_name registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 assignment, which is an e_assign
  assign registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 = cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register[0];

  //tri_state_bridge_0_avalon_slave_arb_share_counter set values, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_arb_share_set_values = (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    1;

  //tri_state_bridge_0_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_non_bursting_master_requests = cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1 |
    cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant = 0;

  //tri_state_bridge_0_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_share_counter_next_value = tri_state_bridge_0_avalon_slave_firsttransfer ? (tri_state_bridge_0_avalon_slave_arb_share_set_values - 1) : |tri_state_bridge_0_avalon_slave_arb_share_counter ? (tri_state_bridge_0_avalon_slave_arb_share_counter - 1) : 0;

  //tri_state_bridge_0_avalon_slave_allgrants all slave grants, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_allgrants = (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector) |
    (|tri_state_bridge_0_avalon_slave_grant_vector);

  //tri_state_bridge_0_avalon_slave_end_xfer assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_end_xfer = ~(cfi_flash_0_s1_waits_for_read | cfi_flash_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave = tri_state_bridge_0_avalon_slave_end_xfer & (~tri_state_bridge_0_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tri_state_bridge_0_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & tri_state_bridge_0_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests);

  //tri_state_bridge_0_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= 0;
      else if (tri_state_bridge_0_avalon_slave_arb_counter_enable)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|tri_state_bridge_0_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave) | (end_xfer_arb_share_counter_term_tri_state_bridge_0_avalon_slave & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests))
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 = |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;

  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= 0;
      else 
        last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 & cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cfi_flash_0_s1 = cpu_0_data_master_requests_cfi_flash_0_s1 & ~((cpu_0_data_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (|cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register))) | ((tri_state_bridge_0_avalon_slave_read_pending | cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_cfi_flash_0_s1) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read & ~cfi_flash_0_s1_waits_for_read & ~(|cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register);

  //shift register p1 cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else 
        cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1 = cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //tri_state_bridge_0_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          incoming_tri_state_bridge_0_data <= 0;
      else 
        incoming_tri_state_bridge_0_data <= tri_state_bridge_0_data;
    end


  //cfi_flash_0_s1_with_write_latency assignment, which is an e_assign
  assign cfi_flash_0_s1_with_write_latency = in_a_write_cycle & (cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1);

  //time to write the data, which is an e_mux
  assign time_to_write = (cfi_flash_0_s1_with_write_latency)? 1 :
    0;

  //d1_outgoing_tri_state_bridge_0_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_outgoing_tri_state_bridge_0_data <= 0;
      else 
        d1_outgoing_tri_state_bridge_0_data <= outgoing_tri_state_bridge_0_data;
    end


  //write cycle delayed by 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_in_a_write_cycle <= 0;
      else 
        d1_in_a_write_cycle <= time_to_write;
    end


  //d1_outgoing_tri_state_bridge_0_data tristate driver, which is an e_assign
  assign tri_state_bridge_0_data = (d1_in_a_write_cycle)? d1_outgoing_tri_state_bridge_0_data:{8{1'bz}};

  //outgoing_tri_state_bridge_0_data mux, which is an e_mux
  assign outgoing_tri_state_bridge_0_data = cpu_0_data_master_dbs_write_8;

  assign cpu_0_instruction_master_requests_cfi_flash_0_s1 = (({cpu_0_instruction_master_address_to_slave[27 : 22] , 22'b0} == 28'h0) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= 0;
      else 
        last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= cpu_0_data_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 & cpu_0_data_master_requests_cfi_flash_0_s1;

  assign cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 = cpu_0_instruction_master_requests_cfi_flash_0_s1 & ~((cpu_0_instruction_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (2 < cpu_0_instruction_master_latency_counter) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & ~cfi_flash_0_s1_waits_for_read;

  //shift register p1 cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else 
        cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 = cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //allow new arb cycle for tri_state_bridge_0/avalon_slave, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/instruction_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[0];

  //cpu_0/instruction_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[0] && cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/data_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[1];

  //cpu_0/data_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[1] && cpu_0_data_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0/avalon_slave chosen-master double-vector, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_double_vector = {tri_state_bridge_0_avalon_slave_master_qreq_vector, tri_state_bridge_0_avalon_slave_master_qreq_vector} & ({~tri_state_bridge_0_avalon_slave_master_qreq_vector, ~tri_state_bridge_0_avalon_slave_master_qreq_vector} + tri_state_bridge_0_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign tri_state_bridge_0_avalon_slave_arb_winner = (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle & | tri_state_bridge_0_avalon_slave_grant_vector) ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;

  //saved tri_state_bridge_0_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= 0;
      else if (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= |tri_state_bridge_0_avalon_slave_grant_vector ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign tri_state_bridge_0_avalon_slave_grant_vector = {(tri_state_bridge_0_avalon_slave_chosen_master_double_vector[1] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[3]),
    (tri_state_bridge_0_avalon_slave_chosen_master_double_vector[0] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[2])};

  //tri_state_bridge_0/avalon_slave chosen master rotated left, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_rot_left = (tri_state_bridge_0_avalon_slave_arb_winner << 1) ? (tri_state_bridge_0_avalon_slave_arb_winner << 1) : 1;

  //tri_state_bridge_0/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_addend <= 1;
      else if (|tri_state_bridge_0_avalon_slave_grant_vector)
          tri_state_bridge_0_avalon_slave_arb_addend <= tri_state_bridge_0_avalon_slave_end_xfer? tri_state_bridge_0_avalon_slave_chosen_master_rot_left : tri_state_bridge_0_avalon_slave_grant_vector;
    end


  assign p1_select_n_to_the_cfi_flash_0 = ~(cpu_0_data_master_granted_cfi_flash_0_s1 | cpu_0_instruction_master_granted_cfi_flash_0_s1);
  //tri_state_bridge_0_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_firsttransfer = tri_state_bridge_0_avalon_slave_begins_xfer ? tri_state_bridge_0_avalon_slave_unreg_firsttransfer : tri_state_bridge_0_avalon_slave_reg_firsttransfer;

  //tri_state_bridge_0_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_unreg_firsttransfer = ~(tri_state_bridge_0_avalon_slave_slavearbiterlockenable & tri_state_bridge_0_avalon_slave_any_continuerequest);

  //tri_state_bridge_0_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (tri_state_bridge_0_avalon_slave_begins_xfer)
          tri_state_bridge_0_avalon_slave_reg_firsttransfer <= tri_state_bridge_0_avalon_slave_unreg_firsttransfer;
    end


  //tri_state_bridge_0_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_beginbursttransfer_internal = tri_state_bridge_0_avalon_slave_begins_xfer;

  //tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal = tri_state_bridge_0_avalon_slave_begins_xfer & tri_state_bridge_0_avalon_slave_firsttransfer;

  //~tri_state_bridge_0_readn of type read to ~p1_tri_state_bridge_0_readn, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_readn <= ~0;
      else 
        tri_state_bridge_0_readn <= p1_tri_state_bridge_0_readn;
    end


  //~p1_tri_state_bridge_0_readn assignment, which is an e_mux
  assign p1_tri_state_bridge_0_readn = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read))& ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter < 16));

  //~write_n_to_the_cfi_flash_0 of type write to ~p1_write_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_n_to_the_cfi_flash_0 <= ~0;
      else 
        write_n_to_the_cfi_flash_0 <= p1_write_n_to_the_cfi_flash_0;
    end


  //~p1_write_n_to_the_cfi_flash_0 assignment, which is an e_mux
  assign p1_write_n_to_the_cfi_flash_0 = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write)) & ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter >= 4) & (cfi_flash_0_s1_wait_counter < 20) & cfi_flash_0_s1_pretend_byte_enable);

  //tri_state_bridge_0_address of type address to p1_tri_state_bridge_0_address, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_address <= 0;
      else 
        tri_state_bridge_0_address <= p1_tri_state_bridge_0_address;
    end


  //p1_tri_state_bridge_0_address mux, which is an e_mux
  assign p1_tri_state_bridge_0_address = (cpu_0_data_master_granted_cfi_flash_0_s1)? ({cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1 : 0]}) :
    ({cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1 : 0]});

  //d1_tri_state_bridge_0_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tri_state_bridge_0_avalon_slave_end_xfer <= 1;
      else 
        d1_tri_state_bridge_0_avalon_slave_end_xfer <= tri_state_bridge_0_avalon_slave_end_xfer;
    end


  //cfi_flash_0_s1_wait_counter_eq_1 assignment, which is an e_assign
  assign cfi_flash_0_s1_wait_counter_eq_1 = cfi_flash_0_s1_wait_counter == 1;

  //cfi_flash_0_s1_waits_for_read in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_read = cfi_flash_0_s1_in_a_read_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cfi_flash_0_s1_in_a_read_cycle;

  //cfi_flash_0_s1_waits_for_write in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_write = cfi_flash_0_s1_in_a_write_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_write_cycle = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cfi_flash_0_s1_in_a_write_cycle;

  assign cfi_flash_0_s1_wait_counter_eq_0 = cfi_flash_0_s1_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cfi_flash_0_s1_wait_counter <= 0;
      else 
        cfi_flash_0_s1_wait_counter <= cfi_flash_0_s1_counter_load_value;
    end


  assign cfi_flash_0_s1_counter_load_value = ((cfi_flash_0_s1_in_a_write_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 22 :
    ((cfi_flash_0_s1_in_a_read_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 18 :
    (~cfi_flash_0_s1_wait_counter_eq_0)? cfi_flash_0_s1_wait_counter - 1 :
    0;

  assign wait_for_cfi_flash_0_s1_counter = tri_state_bridge_0_avalon_slave_begins_xfer | ~cfi_flash_0_s1_wait_counter_eq_0;
  //cfi_flash_0_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign cfi_flash_0_s1_pretend_byte_enable = (cpu_0_data_master_granted_cfi_flash_0_s1)? cpu_0_data_master_byteenable_cfi_flash_0_s1 :
    -1;

  assign {cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_cfi_flash_0_s1 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2 :
    cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //incoming_tri_state_bridge_0_data_bit_0_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_0_is_x = ^(incoming_tri_state_bridge_0_data[0]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[0] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[0] = incoming_tri_state_bridge_0_data_bit_0_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[0];

  //incoming_tri_state_bridge_0_data_bit_1_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_1_is_x = ^(incoming_tri_state_bridge_0_data[1]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[1] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[1] = incoming_tri_state_bridge_0_data_bit_1_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[1];

  //incoming_tri_state_bridge_0_data_bit_2_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_2_is_x = ^(incoming_tri_state_bridge_0_data[2]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[2] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[2] = incoming_tri_state_bridge_0_data_bit_2_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[2];

  //incoming_tri_state_bridge_0_data_bit_3_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_3_is_x = ^(incoming_tri_state_bridge_0_data[3]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[3] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[3] = incoming_tri_state_bridge_0_data_bit_3_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[3];

  //incoming_tri_state_bridge_0_data_bit_4_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_4_is_x = ^(incoming_tri_state_bridge_0_data[4]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[4] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[4] = incoming_tri_state_bridge_0_data_bit_4_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[4];

  //incoming_tri_state_bridge_0_data_bit_5_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_5_is_x = ^(incoming_tri_state_bridge_0_data[5]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[5] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[5] = incoming_tri_state_bridge_0_data_bit_5_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[5];

  //incoming_tri_state_bridge_0_data_bit_6_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_6_is_x = ^(incoming_tri_state_bridge_0_data[6]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[6] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[6] = incoming_tri_state_bridge_0_data_bit_6_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[6];

  //incoming_tri_state_bridge_0_data_bit_7_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_7_is_x = ^(incoming_tri_state_bridge_0_data[7]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7] = incoming_tri_state_bridge_0_data_bit_7_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[7];

  //cfi_flash_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cfi_flash_0_s1 + cpu_0_instruction_master_granted_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cfi_flash_0_s1 + cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0 = incoming_tri_state_bridge_0_data;
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_bridge_arbitrator 
;



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module uart_0_s1_arbitrator (
                              // inputs:
                               clk,
                               cpu_0_data_master_address_to_slave,
                               cpu_0_data_master_read,
                               cpu_0_data_master_write,
                               cpu_0_data_master_writedata,
                               reset_n,
                               uart_0_s1_dataavailable,
                               uart_0_s1_irq,
                               uart_0_s1_readdata,
                               uart_0_s1_readyfordata,

                              // outputs:
                               cpu_0_data_master_granted_uart_0_s1,
                               cpu_0_data_master_qualified_request_uart_0_s1,
                               cpu_0_data_master_read_data_valid_uart_0_s1,
                               cpu_0_data_master_requests_uart_0_s1,
                               d1_uart_0_s1_end_xfer,
                               uart_0_s1_address,
                               uart_0_s1_begintransfer,
                               uart_0_s1_chipselect,
                               uart_0_s1_dataavailable_from_sa,
                               uart_0_s1_irq_from_sa,
                               uart_0_s1_read_n,
                               uart_0_s1_readdata_from_sa,
                               uart_0_s1_readyfordata_from_sa,
                               uart_0_s1_reset_n,
                               uart_0_s1_write_n,
                               uart_0_s1_writedata
                            )
;

  output           cpu_0_data_master_granted_uart_0_s1;
  output           cpu_0_data_master_qualified_request_uart_0_s1;
  output           cpu_0_data_master_read_data_valid_uart_0_s1;
  output           cpu_0_data_master_requests_uart_0_s1;
  output           d1_uart_0_s1_end_xfer;
  output  [  2: 0] uart_0_s1_address;
  output           uart_0_s1_begintransfer;
  output           uart_0_s1_chipselect;
  output           uart_0_s1_dataavailable_from_sa;
  output           uart_0_s1_irq_from_sa;
  output           uart_0_s1_read_n;
  output  [ 15: 0] uart_0_s1_readdata_from_sa;
  output           uart_0_s1_readyfordata_from_sa;
  output           uart_0_s1_reset_n;
  output           uart_0_s1_write_n;
  output  [ 15: 0] uart_0_s1_writedata;
  input            clk;
  input   [ 27: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            uart_0_s1_dataavailable;
  input            uart_0_s1_irq;
  input   [ 15: 0] uart_0_s1_readdata;
  input            uart_0_s1_readyfordata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_uart_0_s1;
  wire             cpu_0_data_master_qualified_request_uart_0_s1;
  wire             cpu_0_data_master_read_data_valid_uart_0_s1;
  wire             cpu_0_data_master_requests_uart_0_s1;
  wire             cpu_0_data_master_saved_grant_uart_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_uart_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_uart_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 27: 0] shifted_address_to_uart_0_s1_from_cpu_0_data_master;
  wire    [  2: 0] uart_0_s1_address;
  wire             uart_0_s1_allgrants;
  wire             uart_0_s1_allow_new_arb_cycle;
  wire             uart_0_s1_any_bursting_master_saved_grant;
  wire             uart_0_s1_any_continuerequest;
  wire             uart_0_s1_arb_counter_enable;
  reg     [  2: 0] uart_0_s1_arb_share_counter;
  wire    [  2: 0] uart_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] uart_0_s1_arb_share_set_values;
  wire             uart_0_s1_beginbursttransfer_internal;
  wire             uart_0_s1_begins_xfer;
  wire             uart_0_s1_begintransfer;
  wire             uart_0_s1_chipselect;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_end_xfer;
  wire             uart_0_s1_firsttransfer;
  wire             uart_0_s1_grant_vector;
  wire             uart_0_s1_in_a_read_cycle;
  wire             uart_0_s1_in_a_write_cycle;
  wire             uart_0_s1_irq_from_sa;
  wire             uart_0_s1_master_qreq_vector;
  wire             uart_0_s1_non_bursting_master_requests;
  wire             uart_0_s1_read_n;
  wire    [ 15: 0] uart_0_s1_readdata_from_sa;
  wire             uart_0_s1_readyfordata_from_sa;
  reg              uart_0_s1_reg_firsttransfer;
  wire             uart_0_s1_reset_n;
  reg              uart_0_s1_slavearbiterlockenable;
  wire             uart_0_s1_slavearbiterlockenable2;
  wire             uart_0_s1_unreg_firsttransfer;
  wire             uart_0_s1_waits_for_read;
  wire             uart_0_s1_waits_for_write;
  wire             uart_0_s1_write_n;
  wire    [ 15: 0] uart_0_s1_writedata;
  wire             wait_for_uart_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~uart_0_s1_end_xfer;
    end


  assign uart_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_uart_0_s1));
  //assign uart_0_s1_readdata_from_sa = uart_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_readdata_from_sa = uart_0_s1_readdata;

  assign cpu_0_data_master_requests_uart_0_s1 = ({cpu_0_data_master_address_to_slave[27 : 5] , 5'b0} == 28'h7001020) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign uart_0_s1_dataavailable_from_sa = uart_0_s1_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_dataavailable_from_sa = uart_0_s1_dataavailable;

  //assign uart_0_s1_readyfordata_from_sa = uart_0_s1_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_readyfordata_from_sa = uart_0_s1_readyfordata;

  //uart_0_s1_arb_share_counter set values, which is an e_mux
  assign uart_0_s1_arb_share_set_values = 1;

  //uart_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign uart_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_uart_0_s1;

  //uart_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign uart_0_s1_any_bursting_master_saved_grant = 0;

  //uart_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign uart_0_s1_arb_share_counter_next_value = uart_0_s1_firsttransfer ? (uart_0_s1_arb_share_set_values - 1) : |uart_0_s1_arb_share_counter ? (uart_0_s1_arb_share_counter - 1) : 0;

  //uart_0_s1_allgrants all slave grants, which is an e_mux
  assign uart_0_s1_allgrants = |uart_0_s1_grant_vector;

  //uart_0_s1_end_xfer assignment, which is an e_assign
  assign uart_0_s1_end_xfer = ~(uart_0_s1_waits_for_read | uart_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_uart_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_uart_0_s1 = uart_0_s1_end_xfer & (~uart_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //uart_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign uart_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_uart_0_s1 & uart_0_s1_allgrants) | (end_xfer_arb_share_counter_term_uart_0_s1 & ~uart_0_s1_non_bursting_master_requests);

  //uart_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          uart_0_s1_arb_share_counter <= 0;
      else if (uart_0_s1_arb_counter_enable)
          uart_0_s1_arb_share_counter <= uart_0_s1_arb_share_counter_next_value;
    end


  //uart_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          uart_0_s1_slavearbiterlockenable <= 0;
      else if ((|uart_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_uart_0_s1) | (end_xfer_arb_share_counter_term_uart_0_s1 & ~uart_0_s1_non_bursting_master_requests))
          uart_0_s1_slavearbiterlockenable <= |uart_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master uart_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = uart_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //uart_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign uart_0_s1_slavearbiterlockenable2 = |uart_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master uart_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = uart_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //uart_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign uart_0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_uart_0_s1 = cpu_0_data_master_requests_uart_0_s1;
  //uart_0_s1_writedata mux, which is an e_mux
  assign uart_0_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_uart_0_s1 = cpu_0_data_master_qualified_request_uart_0_s1;

  //cpu_0/data_master saved-grant uart_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_uart_0_s1 = cpu_0_data_master_requests_uart_0_s1;

  //allow new arb cycle for uart_0/s1, which is an e_assign
  assign uart_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign uart_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign uart_0_s1_master_qreq_vector = 1;

  assign uart_0_s1_begintransfer = uart_0_s1_begins_xfer;
  //uart_0_s1_reset_n assignment, which is an e_assign
  assign uart_0_s1_reset_n = reset_n;

  assign uart_0_s1_chipselect = cpu_0_data_master_granted_uart_0_s1;
  //uart_0_s1_firsttransfer first transaction, which is an e_assign
  assign uart_0_s1_firsttransfer = uart_0_s1_begins_xfer ? uart_0_s1_unreg_firsttransfer : uart_0_s1_reg_firsttransfer;

  //uart_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign uart_0_s1_unreg_firsttransfer = ~(uart_0_s1_slavearbiterlockenable & uart_0_s1_any_continuerequest);

  //uart_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          uart_0_s1_reg_firsttransfer <= 1'b1;
      else if (uart_0_s1_begins_xfer)
          uart_0_s1_reg_firsttransfer <= uart_0_s1_unreg_firsttransfer;
    end


  //uart_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign uart_0_s1_beginbursttransfer_internal = uart_0_s1_begins_xfer;

  //~uart_0_s1_read_n assignment, which is an e_mux
  assign uart_0_s1_read_n = ~(cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_read);

  //~uart_0_s1_write_n assignment, which is an e_mux
  assign uart_0_s1_write_n = ~(cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_write);

  assign shifted_address_to_uart_0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //uart_0_s1_address mux, which is an e_mux
  assign uart_0_s1_address = shifted_address_to_uart_0_s1_from_cpu_0_data_master >> 2;

  //d1_uart_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_uart_0_s1_end_xfer <= 1;
      else 
        d1_uart_0_s1_end_xfer <= uart_0_s1_end_xfer;
    end


  //uart_0_s1_waits_for_read in a cycle, which is an e_mux
  assign uart_0_s1_waits_for_read = uart_0_s1_in_a_read_cycle & uart_0_s1_begins_xfer;

  //uart_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign uart_0_s1_in_a_read_cycle = cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = uart_0_s1_in_a_read_cycle;

  //uart_0_s1_waits_for_write in a cycle, which is an e_mux
  assign uart_0_s1_waits_for_write = uart_0_s1_in_a_write_cycle & uart_0_s1_begins_xfer;

  //uart_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign uart_0_s1_in_a_write_cycle = cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = uart_0_s1_in_a_write_cycle;

  assign wait_for_uart_0_s1_counter = 0;
  //assign uart_0_s1_irq_from_sa = uart_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_irq_from_sa = uart_0_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //uart_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_reset_clk_domain_synch_module (
                                             // inputs:
                                              clk,
                                              data_in,
                                              reset_n,

                                             // outputs:
                                              data_out
                                           )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2 (
               // 1) global signals:
                clk,
                reset_n,

               // the_igor_mac
                mcoll_pad_i_to_the_igor_mac,
                mcrs_pad_i_to_the_igor_mac,
                md_pad_i_to_the_igor_mac,
                md_pad_o_from_the_igor_mac,
                md_padoe_o_from_the_igor_mac,
                mdc_pad_o_from_the_igor_mac,
                mrx_clk_pad_i_to_the_igor_mac,
                mrxd_pad_i_to_the_igor_mac,
                mrxdv_pad_i_to_the_igor_mac,
                mrxerr_pad_i_to_the_igor_mac,
                mtx_clk_pad_i_to_the_igor_mac,
                mtxd_pad_o_from_the_igor_mac,
                mtxen_pad_o_from_the_igor_mac,
                mtxerr_pad_o_from_the_igor_mac,

               // the_sdram_0
                zs_addr_from_the_sdram_0,
                zs_ba_from_the_sdram_0,
                zs_cas_n_from_the_sdram_0,
                zs_cke_from_the_sdram_0,
                zs_cs_n_from_the_sdram_0,
                zs_dq_to_and_from_the_sdram_0,
                zs_dqm_from_the_sdram_0,
                zs_ras_n_from_the_sdram_0,
                zs_we_n_from_the_sdram_0,

               // the_spi_0
                MISO_to_the_spi_0,
                MOSI_from_the_spi_0,
                SCLK_from_the_spi_0,
                SS_n_from_the_spi_0,

               // the_tri_state_bridge_0_avalon_slave
                select_n_to_the_cfi_flash_0,
                tri_state_bridge_0_address,
                tri_state_bridge_0_data,
                tri_state_bridge_0_readn,
                write_n_to_the_cfi_flash_0,

               // the_uart_0
                cts_n_to_the_uart_0,
                rts_n_from_the_uart_0,
                rxd_to_the_uart_0,
                txd_from_the_uart_0
             )
;

  output           MOSI_from_the_spi_0;
  output           SCLK_from_the_spi_0;
  output           SS_n_from_the_spi_0;
  output           md_pad_o_from_the_igor_mac;
  output           md_padoe_o_from_the_igor_mac;
  output           mdc_pad_o_from_the_igor_mac;
  output  [  3: 0] mtxd_pad_o_from_the_igor_mac;
  output           mtxen_pad_o_from_the_igor_mac;
  output           mtxerr_pad_o_from_the_igor_mac;
  output           rts_n_from_the_uart_0;
  output           select_n_to_the_cfi_flash_0;
  output  [ 21: 0] tri_state_bridge_0_address;
  inout   [  7: 0] tri_state_bridge_0_data;
  output           tri_state_bridge_0_readn;
  output           txd_from_the_uart_0;
  output           write_n_to_the_cfi_flash_0;
  output  [ 11: 0] zs_addr_from_the_sdram_0;
  output  [  1: 0] zs_ba_from_the_sdram_0;
  output           zs_cas_n_from_the_sdram_0;
  output           zs_cke_from_the_sdram_0;
  output           zs_cs_n_from_the_sdram_0;
  inout   [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  output  [  1: 0] zs_dqm_from_the_sdram_0;
  output           zs_ras_n_from_the_sdram_0;
  output           zs_we_n_from_the_sdram_0;
  input            MISO_to_the_spi_0;
  input            clk;
  input            cts_n_to_the_uart_0;
  input            mcoll_pad_i_to_the_igor_mac;
  input            mcrs_pad_i_to_the_igor_mac;
  input            md_pad_i_to_the_igor_mac;
  input            mrx_clk_pad_i_to_the_igor_mac;
  input   [  3: 0] mrxd_pad_i_to_the_igor_mac;
  input            mrxdv_pad_i_to_the_igor_mac;
  input            mrxerr_pad_i_to_the_igor_mac;
  input            mtx_clk_pad_i_to_the_igor_mac;
  input            reset_n;
  input            rxd_to_the_uart_0;

  wire             MOSI_from_the_spi_0;
  wire             SCLK_from_the_spi_0;
  wire             SS_n_from_the_spi_0;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             cfi_flash_0_s1_wait_counter_eq_1;
  wire             clk_reset_n;
  wire    [ 27: 0] cpu_0_data_master_address;
  wire    [ 27: 0] cpu_0_data_master_address_to_slave;
  wire    [  3: 0] cpu_0_data_master_byteenable;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_dbs_address;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire             cpu_0_data_master_debugaccess;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_granted_igor_mac_control_port;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_granted_spi_0_spi_control_port;
  wire             cpu_0_data_master_granted_timer_0_s1;
  wire             cpu_0_data_master_granted_timer_1_s1;
  wire             cpu_0_data_master_granted_uart_0_s1;
  wire    [ 31: 0] cpu_0_data_master_irq;
  wire             cpu_0_data_master_no_byte_enables_and_last_term;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_igor_mac_control_port;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_spi_0_spi_control_port;
  wire             cpu_0_data_master_qualified_request_timer_0_s1;
  wire             cpu_0_data_master_qualified_request_timer_1_s1;
  wire             cpu_0_data_master_qualified_request_uart_0_s1;
  wire             cpu_0_data_master_read;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_igor_mac_control_port;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_spi_0_spi_control_port;
  wire             cpu_0_data_master_read_data_valid_timer_0_s1;
  wire             cpu_0_data_master_read_data_valid_timer_1_s1;
  wire             cpu_0_data_master_read_data_valid_uart_0_s1;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_igor_mac_control_port;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_requests_spi_0_spi_control_port;
  wire             cpu_0_data_master_requests_timer_0_s1;
  wire             cpu_0_data_master_requests_timer_1_s1;
  wire             cpu_0_data_master_requests_uart_0_s1;
  wire             cpu_0_data_master_waitrequest;
  wire             cpu_0_data_master_write;
  wire    [ 31: 0] cpu_0_data_master_writedata;
  wire    [ 27: 0] cpu_0_instruction_master_address;
  wire    [ 27: 0] cpu_0_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_0_instruction_master_dbs_address;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire    [  1: 0] cpu_0_instruction_master_latency_counter;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_read;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_waitrequest;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  wire             d1_cpu_0_jtag_debug_module_end_xfer;
  wire             d1_igor_mac_control_port_end_xfer;
  wire             d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             d1_nios2_burst_0_upstream_end_xfer;
  wire             d1_nios2_burst_1_upstream_end_xfer;
  wire             d1_sdram_0_s1_end_xfer;
  wire             d1_spi_0_spi_control_port_end_xfer;
  wire             d1_timer_0_s1_end_xfer;
  wire             d1_timer_1_s1_end_xfer;
  wire             d1_tri_state_bridge_0_avalon_slave_end_xfer;
  wire             d1_uart_0_s1_end_xfer;
  wire    [  9: 0] igor_mac_control_port_address;
  wire             igor_mac_control_port_chipselect;
  wire             igor_mac_control_port_irq;
  wire             igor_mac_control_port_irq_from_sa;
  wire             igor_mac_control_port_read;
  wire    [ 31: 0] igor_mac_control_port_readdata;
  wire    [ 31: 0] igor_mac_control_port_readdata_from_sa;
  wire             igor_mac_control_port_reset;
  wire             igor_mac_control_port_waitrequest_n;
  wire             igor_mac_control_port_waitrequest_n_from_sa;
  wire             igor_mac_control_port_write;
  wire    [ 31: 0] igor_mac_control_port_writedata;
  wire    [ 31: 0] igor_mac_rx_master_address;
  wire    [ 31: 0] igor_mac_rx_master_address_to_slave;
  wire    [  3: 0] igor_mac_rx_master_burstcount;
  wire    [  3: 0] igor_mac_rx_master_byteenable;
  wire    [  1: 0] igor_mac_rx_master_byteenable_nios2_burst_0_upstream;
  wire    [  1: 0] igor_mac_rx_master_dbs_address;
  wire    [ 15: 0] igor_mac_rx_master_dbs_write_16;
  wire             igor_mac_rx_master_granted_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_qualified_request_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_requests_nios2_burst_0_upstream;
  wire             igor_mac_rx_master_waitrequest;
  wire             igor_mac_rx_master_write;
  wire    [ 31: 0] igor_mac_rx_master_writedata;
  wire    [ 31: 0] igor_mac_tx_master_address;
  wire    [ 31: 0] igor_mac_tx_master_address_to_slave;
  wire    [  3: 0] igor_mac_tx_master_burstcount;
  wire    [  1: 0] igor_mac_tx_master_dbs_address;
  wire             igor_mac_tx_master_granted_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_latency_counter;
  wire             igor_mac_tx_master_qualified_request_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_read;
  wire             igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register;
  wire    [ 31: 0] igor_mac_tx_master_readdata;
  wire             igor_mac_tx_master_readdatavalid;
  wire             igor_mac_tx_master_requests_nios2_burst_1_upstream;
  wire             igor_mac_tx_master_waitrequest;
  wire    [  7: 0] incoming_tri_state_bridge_0_data;
  wire    [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_irq;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire             md_pad_o_from_the_igor_mac;
  wire             md_padoe_o_from_the_igor_mac;
  wire             mdc_pad_o_from_the_igor_mac;
  wire    [  3: 0] mtxd_pad_o_from_the_igor_mac;
  wire             mtxen_pad_o_from_the_igor_mac;
  wire             mtxerr_pad_o_from_the_igor_mac;
  wire    [ 22: 0] nios2_burst_0_downstream_address;
  wire    [ 22: 0] nios2_burst_0_downstream_address_to_slave;
  wire    [  4: 0] nios2_burst_0_downstream_arbitrationshare;
  wire             nios2_burst_0_downstream_burstcount;
  wire    [  1: 0] nios2_burst_0_downstream_byteenable;
  wire             nios2_burst_0_downstream_debugaccess;
  wire             nios2_burst_0_downstream_granted_sdram_0_s1;
  wire             nios2_burst_0_downstream_latency_counter;
  wire    [ 22: 0] nios2_burst_0_downstream_nativeaddress;
  wire             nios2_burst_0_downstream_qualified_request_sdram_0_s1;
  wire             nios2_burst_0_downstream_read;
  wire             nios2_burst_0_downstream_read_data_valid_sdram_0_s1;
  wire             nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register;
  wire    [ 15: 0] nios2_burst_0_downstream_readdata;
  wire             nios2_burst_0_downstream_readdatavalid;
  wire             nios2_burst_0_downstream_requests_sdram_0_s1;
  wire             nios2_burst_0_downstream_reset_n;
  wire             nios2_burst_0_downstream_waitrequest;
  wire             nios2_burst_0_downstream_write;
  wire    [ 15: 0] nios2_burst_0_downstream_writedata;
  wire    [ 22: 0] nios2_burst_0_upstream_address;
  wire    [  3: 0] nios2_burst_0_upstream_burstcount;
  wire    [ 23: 0] nios2_burst_0_upstream_byteaddress;
  wire    [  1: 0] nios2_burst_0_upstream_byteenable;
  wire             nios2_burst_0_upstream_debugaccess;
  wire             nios2_burst_0_upstream_read;
  wire    [ 15: 0] nios2_burst_0_upstream_readdata;
  wire    [ 15: 0] nios2_burst_0_upstream_readdata_from_sa;
  wire             nios2_burst_0_upstream_readdatavalid;
  wire             nios2_burst_0_upstream_readdatavalid_from_sa;
  wire             nios2_burst_0_upstream_waitrequest;
  wire             nios2_burst_0_upstream_waitrequest_from_sa;
  wire             nios2_burst_0_upstream_write;
  wire    [ 15: 0] nios2_burst_0_upstream_writedata;
  wire    [ 22: 0] nios2_burst_1_downstream_address;
  wire    [ 22: 0] nios2_burst_1_downstream_address_to_slave;
  wire    [  4: 0] nios2_burst_1_downstream_arbitrationshare;
  wire             nios2_burst_1_downstream_burstcount;
  wire    [  1: 0] nios2_burst_1_downstream_byteenable;
  wire             nios2_burst_1_downstream_debugaccess;
  wire             nios2_burst_1_downstream_granted_sdram_0_s1;
  wire             nios2_burst_1_downstream_latency_counter;
  wire    [ 22: 0] nios2_burst_1_downstream_nativeaddress;
  wire             nios2_burst_1_downstream_qualified_request_sdram_0_s1;
  wire             nios2_burst_1_downstream_read;
  wire             nios2_burst_1_downstream_read_data_valid_sdram_0_s1;
  wire             nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register;
  wire    [ 15: 0] nios2_burst_1_downstream_readdata;
  wire             nios2_burst_1_downstream_readdatavalid;
  wire             nios2_burst_1_downstream_requests_sdram_0_s1;
  wire             nios2_burst_1_downstream_reset_n;
  wire             nios2_burst_1_downstream_waitrequest;
  wire             nios2_burst_1_downstream_write;
  wire    [ 15: 0] nios2_burst_1_downstream_writedata;
  wire    [ 22: 0] nios2_burst_1_upstream_address;
  wire    [  3: 0] nios2_burst_1_upstream_burstcount;
  wire    [ 23: 0] nios2_burst_1_upstream_byteaddress;
  wire    [  1: 0] nios2_burst_1_upstream_byteenable;
  wire             nios2_burst_1_upstream_debugaccess;
  wire             nios2_burst_1_upstream_read;
  wire    [ 15: 0] nios2_burst_1_upstream_readdata;
  wire    [ 15: 0] nios2_burst_1_upstream_readdata_from_sa;
  wire             nios2_burst_1_upstream_readdatavalid;
  wire             nios2_burst_1_upstream_waitrequest;
  wire             nios2_burst_1_upstream_waitrequest_from_sa;
  wire             nios2_burst_1_upstream_write;
  wire    [ 15: 0] nios2_burst_1_upstream_writedata;
  wire             registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  wire             reset_n_sources;
  wire             rts_n_from_the_uart_0;
  wire    [ 21: 0] sdram_0_s1_address;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid;
  wire             sdram_0_s1_reset_n;
  wire             sdram_0_s1_waitrequest;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire             select_n_to_the_cfi_flash_0;
  wire    [  2: 0] spi_0_spi_control_port_address;
  wire             spi_0_spi_control_port_chipselect;
  wire             spi_0_spi_control_port_dataavailable;
  wire             spi_0_spi_control_port_dataavailable_from_sa;
  wire             spi_0_spi_control_port_endofpacket;
  wire             spi_0_spi_control_port_endofpacket_from_sa;
  wire             spi_0_spi_control_port_irq;
  wire             spi_0_spi_control_port_irq_from_sa;
  wire             spi_0_spi_control_port_read_n;
  wire    [ 15: 0] spi_0_spi_control_port_readdata;
  wire    [ 15: 0] spi_0_spi_control_port_readdata_from_sa;
  wire             spi_0_spi_control_port_readyfordata;
  wire             spi_0_spi_control_port_readyfordata_from_sa;
  wire             spi_0_spi_control_port_reset_n;
  wire             spi_0_spi_control_port_write_n;
  wire    [ 15: 0] spi_0_spi_control_port_writedata;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_irq;
  wire             timer_0_s1_irq_from_sa;
  wire    [ 15: 0] timer_0_s1_readdata;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  wire             timer_0_s1_reset_n;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  wire    [  2: 0] timer_1_s1_address;
  wire             timer_1_s1_chipselect;
  wire             timer_1_s1_irq;
  wire             timer_1_s1_irq_from_sa;
  wire    [ 15: 0] timer_1_s1_readdata;
  wire    [ 15: 0] timer_1_s1_readdata_from_sa;
  wire             timer_1_s1_reset_n;
  wire             timer_1_s1_write_n;
  wire    [ 15: 0] timer_1_s1_writedata;
  wire    [ 21: 0] tri_state_bridge_0_address;
  wire    [  7: 0] tri_state_bridge_0_data;
  wire             tri_state_bridge_0_readn;
  wire             txd_from_the_uart_0;
  wire    [  2: 0] uart_0_s1_address;
  wire             uart_0_s1_begintransfer;
  wire             uart_0_s1_chipselect;
  wire             uart_0_s1_dataavailable;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_irq;
  wire             uart_0_s1_irq_from_sa;
  wire             uart_0_s1_read_n;
  wire    [ 15: 0] uart_0_s1_readdata;
  wire    [ 15: 0] uart_0_s1_readdata_from_sa;
  wire             uart_0_s1_readyfordata;
  wire             uart_0_s1_readyfordata_from_sa;
  wire             uart_0_s1_reset_n;
  wire             uart_0_s1_write_n;
  wire    [ 15: 0] uart_0_s1_writedata;
  wire             write_n_to_the_cfi_flash_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;
  cpu_0_jtag_debug_module_arbitrator the_cpu_0_jtag_debug_module
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_debugaccess                                      (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                  (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module        (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module          (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                 (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_waitrequest                                      (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                        (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_jtag_debug_module_address                                    (cpu_0_jtag_debug_module_address),
      .cpu_0_jtag_debug_module_begintransfer                              (cpu_0_jtag_debug_module_begintransfer),
      .cpu_0_jtag_debug_module_byteenable                                 (cpu_0_jtag_debug_module_byteenable),
      .cpu_0_jtag_debug_module_chipselect                                 (cpu_0_jtag_debug_module_chipselect),
      .cpu_0_jtag_debug_module_debugaccess                                (cpu_0_jtag_debug_module_debugaccess),
      .cpu_0_jtag_debug_module_readdata                                   (cpu_0_jtag_debug_module_readdata),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .cpu_0_jtag_debug_module_reset_n                                    (cpu_0_jtag_debug_module_reset_n),
      .cpu_0_jtag_debug_module_resetrequest                               (cpu_0_jtag_debug_module_resetrequest),
      .cpu_0_jtag_debug_module_resetrequest_from_sa                       (cpu_0_jtag_debug_module_resetrequest_from_sa),
      .cpu_0_jtag_debug_module_write                                      (cpu_0_jtag_debug_module_write),
      .cpu_0_jtag_debug_module_writedata                                  (cpu_0_jtag_debug_module_writedata),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .reset_n                                                            (clk_reset_n)
    );

  cpu_0_data_master_arbitrator the_cpu_0_data_master
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                  (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                  (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                               (clk),
      .cpu_0_data_master_address                                         (cpu_0_data_master_address),
      .cpu_0_data_master_address_to_slave                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                       (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_byteenable_sdram_0_s1                           (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_dbs_address                                     (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                    (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_dbs_write_8                                     (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_cfi_flash_0_s1                          (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                 (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_granted_igor_mac_control_port                   (cpu_0_data_master_granted_igor_mac_control_port),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave           (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_granted_sdram_0_s1                              (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_granted_spi_0_spi_control_port                  (cpu_0_data_master_granted_spi_0_spi_control_port),
      .cpu_0_data_master_granted_timer_0_s1                              (cpu_0_data_master_granted_timer_0_s1),
      .cpu_0_data_master_granted_timer_1_s1                              (cpu_0_data_master_granted_timer_1_s1),
      .cpu_0_data_master_granted_uart_0_s1                               (cpu_0_data_master_granted_uart_0_s1),
      .cpu_0_data_master_irq                                             (cpu_0_data_master_irq),
      .cpu_0_data_master_no_byte_enables_and_last_term                   (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module       (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_igor_mac_control_port         (cpu_0_data_master_qualified_request_igor_mac_control_port),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_sdram_0_s1                    (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_qualified_request_spi_0_spi_control_port        (cpu_0_data_master_qualified_request_spi_0_spi_control_port),
      .cpu_0_data_master_qualified_request_timer_0_s1                    (cpu_0_data_master_qualified_request_timer_0_s1),
      .cpu_0_data_master_qualified_request_timer_1_s1                    (cpu_0_data_master_qualified_request_timer_1_s1),
      .cpu_0_data_master_qualified_request_uart_0_s1                     (cpu_0_data_master_qualified_request_uart_0_s1),
      .cpu_0_data_master_read                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                  (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module         (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read_data_valid_igor_mac_control_port           (cpu_0_data_master_read_data_valid_igor_mac_control_port),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave   (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                      (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register       (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_spi_0_spi_control_port          (cpu_0_data_master_read_data_valid_spi_0_spi_control_port),
      .cpu_0_data_master_read_data_valid_timer_0_s1                      (cpu_0_data_master_read_data_valid_timer_0_s1),
      .cpu_0_data_master_read_data_valid_timer_1_s1                      (cpu_0_data_master_read_data_valid_timer_1_s1),
      .cpu_0_data_master_read_data_valid_uart_0_s1                       (cpu_0_data_master_read_data_valid_uart_0_s1),
      .cpu_0_data_master_readdata                                        (cpu_0_data_master_readdata),
      .cpu_0_data_master_requests_cfi_flash_0_s1                         (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_igor_mac_control_port                  (cpu_0_data_master_requests_igor_mac_control_port),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave          (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_requests_sdram_0_s1                             (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_requests_spi_0_spi_control_port                 (cpu_0_data_master_requests_spi_0_spi_control_port),
      .cpu_0_data_master_requests_timer_0_s1                             (cpu_0_data_master_requests_timer_0_s1),
      .cpu_0_data_master_requests_timer_1_s1                             (cpu_0_data_master_requests_timer_1_s1),
      .cpu_0_data_master_requests_uart_0_s1                              (cpu_0_data_master_requests_uart_0_s1),
      .cpu_0_data_master_waitrequest                                     (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                       (cpu_0_data_master_writedata),
      .cpu_0_jtag_debug_module_readdata_from_sa                          (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_cpu_0_jtag_debug_module_end_xfer                               (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_igor_mac_control_port_end_xfer                                 (d1_igor_mac_control_port_end_xfer),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .d1_sdram_0_s1_end_xfer                                            (d1_sdram_0_s1_end_xfer),
      .d1_spi_0_spi_control_port_end_xfer                                (d1_spi_0_spi_control_port_end_xfer),
      .d1_timer_0_s1_end_xfer                                            (d1_timer_0_s1_end_xfer),
      .d1_timer_1_s1_end_xfer                                            (d1_timer_1_s1_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                       (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .d1_uart_0_s1_end_xfer                                             (d1_uart_0_s1_end_xfer),
      .igor_mac_control_port_irq_from_sa                                 (igor_mac_control_port_irq_from_sa),
      .igor_mac_control_port_readdata_from_sa                            (igor_mac_control_port_readdata_from_sa),
      .igor_mac_control_port_waitrequest_n_from_sa                       (igor_mac_control_port_waitrequest_n_from_sa),
      .incoming_tri_state_bridge_0_data_with_Xs_converted_to_0           (incoming_tri_state_bridge_0_data_with_Xs_converted_to_0),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                         (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1       (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .reset_n                                                           (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                       (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                    (sdram_0_s1_waitrequest_from_sa),
      .spi_0_spi_control_port_irq_from_sa                                (spi_0_spi_control_port_irq_from_sa),
      .spi_0_spi_control_port_readdata_from_sa                           (spi_0_spi_control_port_readdata_from_sa),
      .timer_0_s1_irq_from_sa                                            (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata_from_sa                                       (timer_0_s1_readdata_from_sa),
      .timer_1_s1_irq_from_sa                                            (timer_1_s1_irq_from_sa),
      .timer_1_s1_readdata_from_sa                                       (timer_1_s1_readdata_from_sa),
      .uart_0_s1_irq_from_sa                                             (uart_0_s1_irq_from_sa),
      .uart_0_s1_readdata_from_sa                                        (uart_0_s1_readdata_from_sa)
    );

  cpu_0_instruction_master_arbitrator the_cpu_0_instruction_master
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                   (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                   (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                                (clk),
      .cpu_0_instruction_master_address                                   (cpu_0_instruction_master_address),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                    (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_granted_sdram_0_s1                        (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1          (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1              (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1            (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_readdata                                  (cpu_0_instruction_master_readdata),
      .cpu_0_instruction_master_readdatavalid                             (cpu_0_instruction_master_readdatavalid),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                   (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_requests_sdram_0_s1                       (cpu_0_instruction_master_requests_sdram_0_s1),
      .cpu_0_instruction_master_waitrequest                               (cpu_0_instruction_master_waitrequest),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                        (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .incoming_tri_state_bridge_0_data                                   (incoming_tri_state_bridge_0_data),
      .reset_n                                                            (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa)
    );

  cpu_0 the_cpu_0
    (
      .clk                                   (clk),
      .d_address                             (cpu_0_data_master_address),
      .d_byteenable                          (cpu_0_data_master_byteenable),
      .d_irq                                 (cpu_0_data_master_irq),
      .d_read                                (cpu_0_data_master_read),
      .d_readdata                            (cpu_0_data_master_readdata),
      .d_waitrequest                         (cpu_0_data_master_waitrequest),
      .d_write                               (cpu_0_data_master_write),
      .d_writedata                           (cpu_0_data_master_writedata),
      .i_address                             (cpu_0_instruction_master_address),
      .i_read                                (cpu_0_instruction_master_read),
      .i_readdata                            (cpu_0_instruction_master_readdata),
      .i_readdatavalid                       (cpu_0_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_0_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_0_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_0_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_0_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (cpu_0_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_0_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_0_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (cpu_0_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_0_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_0_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_0_jtag_debug_module_writedata),
      .reset_n                               (cpu_0_jtag_debug_module_reset_n)
    );

  igor_mac_control_port_arbitrator the_igor_mac_control_port
    (
      .clk                                                       (clk),
      .cpu_0_data_master_address_to_slave                        (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_igor_mac_control_port           (cpu_0_data_master_granted_igor_mac_control_port),
      .cpu_0_data_master_qualified_request_igor_mac_control_port (cpu_0_data_master_qualified_request_igor_mac_control_port),
      .cpu_0_data_master_read                                    (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_igor_mac_control_port   (cpu_0_data_master_read_data_valid_igor_mac_control_port),
      .cpu_0_data_master_requests_igor_mac_control_port          (cpu_0_data_master_requests_igor_mac_control_port),
      .cpu_0_data_master_waitrequest                             (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                   (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                               (cpu_0_data_master_writedata),
      .d1_igor_mac_control_port_end_xfer                         (d1_igor_mac_control_port_end_xfer),
      .igor_mac_control_port_address                             (igor_mac_control_port_address),
      .igor_mac_control_port_chipselect                          (igor_mac_control_port_chipselect),
      .igor_mac_control_port_irq                                 (igor_mac_control_port_irq),
      .igor_mac_control_port_irq_from_sa                         (igor_mac_control_port_irq_from_sa),
      .igor_mac_control_port_read                                (igor_mac_control_port_read),
      .igor_mac_control_port_readdata                            (igor_mac_control_port_readdata),
      .igor_mac_control_port_readdata_from_sa                    (igor_mac_control_port_readdata_from_sa),
      .igor_mac_control_port_reset                               (igor_mac_control_port_reset),
      .igor_mac_control_port_waitrequest_n                       (igor_mac_control_port_waitrequest_n),
      .igor_mac_control_port_waitrequest_n_from_sa               (igor_mac_control_port_waitrequest_n_from_sa),
      .igor_mac_control_port_write                               (igor_mac_control_port_write),
      .igor_mac_control_port_writedata                           (igor_mac_control_port_writedata),
      .reset_n                                                   (clk_reset_n)
    );

  igor_mac_rx_master_arbitrator the_igor_mac_rx_master
    (
      .clk                                                         (clk),
      .d1_nios2_burst_0_upstream_end_xfer                          (d1_nios2_burst_0_upstream_end_xfer),
      .igor_mac_rx_master_address                                  (igor_mac_rx_master_address),
      .igor_mac_rx_master_address_to_slave                         (igor_mac_rx_master_address_to_slave),
      .igor_mac_rx_master_burstcount                               (igor_mac_rx_master_burstcount),
      .igor_mac_rx_master_byteenable                               (igor_mac_rx_master_byteenable),
      .igor_mac_rx_master_byteenable_nios2_burst_0_upstream        (igor_mac_rx_master_byteenable_nios2_burst_0_upstream),
      .igor_mac_rx_master_dbs_address                              (igor_mac_rx_master_dbs_address),
      .igor_mac_rx_master_dbs_write_16                             (igor_mac_rx_master_dbs_write_16),
      .igor_mac_rx_master_granted_nios2_burst_0_upstream           (igor_mac_rx_master_granted_nios2_burst_0_upstream),
      .igor_mac_rx_master_qualified_request_nios2_burst_0_upstream (igor_mac_rx_master_qualified_request_nios2_burst_0_upstream),
      .igor_mac_rx_master_requests_nios2_burst_0_upstream          (igor_mac_rx_master_requests_nios2_burst_0_upstream),
      .igor_mac_rx_master_waitrequest                              (igor_mac_rx_master_waitrequest),
      .igor_mac_rx_master_write                                    (igor_mac_rx_master_write),
      .igor_mac_rx_master_writedata                                (igor_mac_rx_master_writedata),
      .nios2_burst_0_upstream_waitrequest_from_sa                  (nios2_burst_0_upstream_waitrequest_from_sa),
      .reset_n                                                     (clk_reset_n)
    );

  igor_mac_tx_master_arbitrator the_igor_mac_tx_master
    (
      .clk                                                                      (clk),
      .d1_nios2_burst_1_upstream_end_xfer                                       (d1_nios2_burst_1_upstream_end_xfer),
      .igor_mac_tx_master_address                                               (igor_mac_tx_master_address),
      .igor_mac_tx_master_address_to_slave                                      (igor_mac_tx_master_address_to_slave),
      .igor_mac_tx_master_burstcount                                            (igor_mac_tx_master_burstcount),
      .igor_mac_tx_master_dbs_address                                           (igor_mac_tx_master_dbs_address),
      .igor_mac_tx_master_granted_nios2_burst_1_upstream                        (igor_mac_tx_master_granted_nios2_burst_1_upstream),
      .igor_mac_tx_master_latency_counter                                       (igor_mac_tx_master_latency_counter),
      .igor_mac_tx_master_qualified_request_nios2_burst_1_upstream              (igor_mac_tx_master_qualified_request_nios2_burst_1_upstream),
      .igor_mac_tx_master_read                                                  (igor_mac_tx_master_read),
      .igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream                (igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream),
      .igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register (igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register),
      .igor_mac_tx_master_readdata                                              (igor_mac_tx_master_readdata),
      .igor_mac_tx_master_readdatavalid                                         (igor_mac_tx_master_readdatavalid),
      .igor_mac_tx_master_requests_nios2_burst_1_upstream                       (igor_mac_tx_master_requests_nios2_burst_1_upstream),
      .igor_mac_tx_master_waitrequest                                           (igor_mac_tx_master_waitrequest),
      .nios2_burst_1_upstream_readdata_from_sa                                  (nios2_burst_1_upstream_readdata_from_sa),
      .nios2_burst_1_upstream_waitrequest_from_sa                               (nios2_burst_1_upstream_waitrequest_from_sa),
      .reset_n                                                                  (clk_reset_n)
    );

  igor_mac the_igor_mac
    (
      .av_address          (igor_mac_control_port_address),
      .av_chipselect       (igor_mac_control_port_chipselect),
      .av_clk              (clk),
      .av_irq              (igor_mac_control_port_irq),
      .av_read             (igor_mac_control_port_read),
      .av_readdata         (igor_mac_control_port_readdata),
      .av_reset            (igor_mac_control_port_reset),
      .av_rx_address       (igor_mac_rx_master_address),
      .av_rx_burstcount    (igor_mac_rx_master_burstcount),
      .av_rx_byteenable    (igor_mac_rx_master_byteenable),
      .av_rx_waitrequest   (igor_mac_rx_master_waitrequest),
      .av_rx_write         (igor_mac_rx_master_write),
      .av_rx_writedata     (igor_mac_rx_master_writedata),
      .av_tx_address       (igor_mac_tx_master_address),
      .av_tx_burstcount    (igor_mac_tx_master_burstcount),
      .av_tx_read          (igor_mac_tx_master_read),
      .av_tx_readdata      (igor_mac_tx_master_readdata),
      .av_tx_readdatavalid (igor_mac_tx_master_readdatavalid),
      .av_tx_waitrequest   (igor_mac_tx_master_waitrequest),
      .av_waitrequest_n    (igor_mac_control_port_waitrequest_n),
      .av_write            (igor_mac_control_port_write),
      .av_writedata        (igor_mac_control_port_writedata),
      .mcoll_pad_i         (mcoll_pad_i_to_the_igor_mac),
      .mcrs_pad_i          (mcrs_pad_i_to_the_igor_mac),
      .md_pad_i            (md_pad_i_to_the_igor_mac),
      .md_pad_o            (md_pad_o_from_the_igor_mac),
      .md_padoe_o          (md_padoe_o_from_the_igor_mac),
      .mdc_pad_o           (mdc_pad_o_from_the_igor_mac),
      .mrx_clk_pad_i       (mrx_clk_pad_i_to_the_igor_mac),
      .mrxd_pad_i          (mrxd_pad_i_to_the_igor_mac),
      .mrxdv_pad_i         (mrxdv_pad_i_to_the_igor_mac),
      .mrxerr_pad_i        (mrxerr_pad_i_to_the_igor_mac),
      .mtx_clk_pad_i       (mtx_clk_pad_i_to_the_igor_mac),
      .mtxd_pad_o          (mtxd_pad_o_from_the_igor_mac),
      .mtxen_pad_o         (mtxen_pad_o_from_the_igor_mac),
      .mtxerr_pad_o        (mtxerr_pad_o_from_the_igor_mac)
    );

  jtag_uart_0_avalon_jtag_slave_arbitrator the_jtag_uart_0_avalon_jtag_slave
    (
      .clk                                                               (clk),
      .cpu_0_data_master_address_to_slave                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave           (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave   (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave          (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_waitrequest                                     (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                       (cpu_0_data_master_writedata),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .jtag_uart_0_avalon_jtag_slave_address                             (jtag_uart_0_avalon_jtag_slave_address),
      .jtag_uart_0_avalon_jtag_slave_chipselect                          (jtag_uart_0_avalon_jtag_slave_chipselect),
      .jtag_uart_0_avalon_jtag_slave_dataavailable                       (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa               (jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_0_avalon_jtag_slave_irq                                 (jtag_uart_0_avalon_jtag_slave_irq),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                         (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_read_n                              (jtag_uart_0_avalon_jtag_slave_read_n),
      .jtag_uart_0_avalon_jtag_slave_readdata                            (jtag_uart_0_avalon_jtag_slave_readdata),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readyfordata                        (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa                (jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_reset_n                             (jtag_uart_0_avalon_jtag_slave_reset_n),
      .jtag_uart_0_avalon_jtag_slave_waitrequest                         (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_0_avalon_jtag_slave_write_n                             (jtag_uart_0_avalon_jtag_slave_write_n),
      .jtag_uart_0_avalon_jtag_slave_writedata                           (jtag_uart_0_avalon_jtag_slave_writedata),
      .reset_n                                                           (clk_reset_n)
    );

  jtag_uart_0 the_jtag_uart_0
    (
      .av_address     (jtag_uart_0_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_0_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_0_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_0_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_0_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_0_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_0_avalon_jtag_slave_writedata),
      .clk            (clk),
      .dataavailable  (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_0_avalon_jtag_slave_reset_n)
    );

  nios2_burst_0_upstream_arbitrator the_nios2_burst_0_upstream
    (
      .clk                                                         (clk),
      .d1_nios2_burst_0_upstream_end_xfer                          (d1_nios2_burst_0_upstream_end_xfer),
      .igor_mac_rx_master_address_to_slave                         (igor_mac_rx_master_address_to_slave),
      .igor_mac_rx_master_burstcount                               (igor_mac_rx_master_burstcount),
      .igor_mac_rx_master_byteenable                               (igor_mac_rx_master_byteenable),
      .igor_mac_rx_master_byteenable_nios2_burst_0_upstream        (igor_mac_rx_master_byteenable_nios2_burst_0_upstream),
      .igor_mac_rx_master_dbs_address                              (igor_mac_rx_master_dbs_address),
      .igor_mac_rx_master_dbs_write_16                             (igor_mac_rx_master_dbs_write_16),
      .igor_mac_rx_master_granted_nios2_burst_0_upstream           (igor_mac_rx_master_granted_nios2_burst_0_upstream),
      .igor_mac_rx_master_qualified_request_nios2_burst_0_upstream (igor_mac_rx_master_qualified_request_nios2_burst_0_upstream),
      .igor_mac_rx_master_requests_nios2_burst_0_upstream          (igor_mac_rx_master_requests_nios2_burst_0_upstream),
      .igor_mac_rx_master_write                                    (igor_mac_rx_master_write),
      .nios2_burst_0_upstream_address                              (nios2_burst_0_upstream_address),
      .nios2_burst_0_upstream_burstcount                           (nios2_burst_0_upstream_burstcount),
      .nios2_burst_0_upstream_byteaddress                          (nios2_burst_0_upstream_byteaddress),
      .nios2_burst_0_upstream_byteenable                           (nios2_burst_0_upstream_byteenable),
      .nios2_burst_0_upstream_debugaccess                          (nios2_burst_0_upstream_debugaccess),
      .nios2_burst_0_upstream_read                                 (nios2_burst_0_upstream_read),
      .nios2_burst_0_upstream_readdata                             (nios2_burst_0_upstream_readdata),
      .nios2_burst_0_upstream_readdata_from_sa                     (nios2_burst_0_upstream_readdata_from_sa),
      .nios2_burst_0_upstream_readdatavalid                        (nios2_burst_0_upstream_readdatavalid),
      .nios2_burst_0_upstream_readdatavalid_from_sa                (nios2_burst_0_upstream_readdatavalid_from_sa),
      .nios2_burst_0_upstream_waitrequest                          (nios2_burst_0_upstream_waitrequest),
      .nios2_burst_0_upstream_waitrequest_from_sa                  (nios2_burst_0_upstream_waitrequest_from_sa),
      .nios2_burst_0_upstream_write                                (nios2_burst_0_upstream_write),
      .nios2_burst_0_upstream_writedata                            (nios2_burst_0_upstream_writedata),
      .reset_n                                                     (clk_reset_n)
    );

  nios2_burst_0_downstream_arbitrator the_nios2_burst_0_downstream
    (
      .clk                                                                (clk),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .nios2_burst_0_downstream_address                                   (nios2_burst_0_downstream_address),
      .nios2_burst_0_downstream_address_to_slave                          (nios2_burst_0_downstream_address_to_slave),
      .nios2_burst_0_downstream_burstcount                                (nios2_burst_0_downstream_burstcount),
      .nios2_burst_0_downstream_byteenable                                (nios2_burst_0_downstream_byteenable),
      .nios2_burst_0_downstream_granted_sdram_0_s1                        (nios2_burst_0_downstream_granted_sdram_0_s1),
      .nios2_burst_0_downstream_latency_counter                           (nios2_burst_0_downstream_latency_counter),
      .nios2_burst_0_downstream_qualified_request_sdram_0_s1              (nios2_burst_0_downstream_qualified_request_sdram_0_s1),
      .nios2_burst_0_downstream_read                                      (nios2_burst_0_downstream_read),
      .nios2_burst_0_downstream_read_data_valid_sdram_0_s1                (nios2_burst_0_downstream_read_data_valid_sdram_0_s1),
      .nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register (nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register),
      .nios2_burst_0_downstream_readdata                                  (nios2_burst_0_downstream_readdata),
      .nios2_burst_0_downstream_readdatavalid                             (nios2_burst_0_downstream_readdatavalid),
      .nios2_burst_0_downstream_requests_sdram_0_s1                       (nios2_burst_0_downstream_requests_sdram_0_s1),
      .nios2_burst_0_downstream_reset_n                                   (nios2_burst_0_downstream_reset_n),
      .nios2_burst_0_downstream_waitrequest                               (nios2_burst_0_downstream_waitrequest),
      .nios2_burst_0_downstream_write                                     (nios2_burst_0_downstream_write),
      .nios2_burst_0_downstream_writedata                                 (nios2_burst_0_downstream_writedata),
      .reset_n                                                            (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa)
    );

  nios2_burst_0 the_nios2_burst_0
    (
      .clk                         (clk),
      .downstream_address          (nios2_burst_0_downstream_address),
      .downstream_arbitrationshare (nios2_burst_0_downstream_arbitrationshare),
      .downstream_burstcount       (nios2_burst_0_downstream_burstcount),
      .downstream_byteenable       (nios2_burst_0_downstream_byteenable),
      .downstream_debugaccess      (nios2_burst_0_downstream_debugaccess),
      .downstream_nativeaddress    (nios2_burst_0_downstream_nativeaddress),
      .downstream_read             (nios2_burst_0_downstream_read),
      .downstream_readdata         (nios2_burst_0_downstream_readdata),
      .downstream_readdatavalid    (nios2_burst_0_downstream_readdatavalid),
      .downstream_waitrequest      (nios2_burst_0_downstream_waitrequest),
      .downstream_write            (nios2_burst_0_downstream_write),
      .downstream_writedata        (nios2_burst_0_downstream_writedata),
      .reset_n                     (nios2_burst_0_downstream_reset_n),
      .upstream_address            (nios2_burst_0_upstream_byteaddress),
      .upstream_burstcount         (nios2_burst_0_upstream_burstcount),
      .upstream_byteenable         (nios2_burst_0_upstream_byteenable),
      .upstream_debugaccess        (nios2_burst_0_upstream_debugaccess),
      .upstream_nativeaddress      (nios2_burst_0_upstream_address),
      .upstream_read               (nios2_burst_0_upstream_read),
      .upstream_readdata           (nios2_burst_0_upstream_readdata),
      .upstream_readdatavalid      (nios2_burst_0_upstream_readdatavalid),
      .upstream_waitrequest        (nios2_burst_0_upstream_waitrequest),
      .upstream_write              (nios2_burst_0_upstream_write),
      .upstream_writedata          (nios2_burst_0_upstream_writedata)
    );

  nios2_burst_1_upstream_arbitrator the_nios2_burst_1_upstream
    (
      .clk                                                                      (clk),
      .d1_nios2_burst_1_upstream_end_xfer                                       (d1_nios2_burst_1_upstream_end_xfer),
      .igor_mac_tx_master_address_to_slave                                      (igor_mac_tx_master_address_to_slave),
      .igor_mac_tx_master_burstcount                                            (igor_mac_tx_master_burstcount),
      .igor_mac_tx_master_dbs_address                                           (igor_mac_tx_master_dbs_address),
      .igor_mac_tx_master_granted_nios2_burst_1_upstream                        (igor_mac_tx_master_granted_nios2_burst_1_upstream),
      .igor_mac_tx_master_latency_counter                                       (igor_mac_tx_master_latency_counter),
      .igor_mac_tx_master_qualified_request_nios2_burst_1_upstream              (igor_mac_tx_master_qualified_request_nios2_burst_1_upstream),
      .igor_mac_tx_master_read                                                  (igor_mac_tx_master_read),
      .igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream                (igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream),
      .igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register (igor_mac_tx_master_read_data_valid_nios2_burst_1_upstream_shift_register),
      .igor_mac_tx_master_requests_nios2_burst_1_upstream                       (igor_mac_tx_master_requests_nios2_burst_1_upstream),
      .nios2_burst_1_upstream_address                                           (nios2_burst_1_upstream_address),
      .nios2_burst_1_upstream_burstcount                                        (nios2_burst_1_upstream_burstcount),
      .nios2_burst_1_upstream_byteaddress                                       (nios2_burst_1_upstream_byteaddress),
      .nios2_burst_1_upstream_byteenable                                        (nios2_burst_1_upstream_byteenable),
      .nios2_burst_1_upstream_debugaccess                                       (nios2_burst_1_upstream_debugaccess),
      .nios2_burst_1_upstream_read                                              (nios2_burst_1_upstream_read),
      .nios2_burst_1_upstream_readdata                                          (nios2_burst_1_upstream_readdata),
      .nios2_burst_1_upstream_readdata_from_sa                                  (nios2_burst_1_upstream_readdata_from_sa),
      .nios2_burst_1_upstream_readdatavalid                                     (nios2_burst_1_upstream_readdatavalid),
      .nios2_burst_1_upstream_waitrequest                                       (nios2_burst_1_upstream_waitrequest),
      .nios2_burst_1_upstream_waitrequest_from_sa                               (nios2_burst_1_upstream_waitrequest_from_sa),
      .nios2_burst_1_upstream_write                                             (nios2_burst_1_upstream_write),
      .reset_n                                                                  (clk_reset_n)
    );

  nios2_burst_1_downstream_arbitrator the_nios2_burst_1_downstream
    (
      .clk                                                                (clk),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .nios2_burst_1_downstream_address                                   (nios2_burst_1_downstream_address),
      .nios2_burst_1_downstream_address_to_slave                          (nios2_burst_1_downstream_address_to_slave),
      .nios2_burst_1_downstream_burstcount                                (nios2_burst_1_downstream_burstcount),
      .nios2_burst_1_downstream_byteenable                                (nios2_burst_1_downstream_byteenable),
      .nios2_burst_1_downstream_granted_sdram_0_s1                        (nios2_burst_1_downstream_granted_sdram_0_s1),
      .nios2_burst_1_downstream_latency_counter                           (nios2_burst_1_downstream_latency_counter),
      .nios2_burst_1_downstream_qualified_request_sdram_0_s1              (nios2_burst_1_downstream_qualified_request_sdram_0_s1),
      .nios2_burst_1_downstream_read                                      (nios2_burst_1_downstream_read),
      .nios2_burst_1_downstream_read_data_valid_sdram_0_s1                (nios2_burst_1_downstream_read_data_valid_sdram_0_s1),
      .nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register (nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register),
      .nios2_burst_1_downstream_readdata                                  (nios2_burst_1_downstream_readdata),
      .nios2_burst_1_downstream_readdatavalid                             (nios2_burst_1_downstream_readdatavalid),
      .nios2_burst_1_downstream_requests_sdram_0_s1                       (nios2_burst_1_downstream_requests_sdram_0_s1),
      .nios2_burst_1_downstream_reset_n                                   (nios2_burst_1_downstream_reset_n),
      .nios2_burst_1_downstream_waitrequest                               (nios2_burst_1_downstream_waitrequest),
      .nios2_burst_1_downstream_write                                     (nios2_burst_1_downstream_write),
      .nios2_burst_1_downstream_writedata                                 (nios2_burst_1_downstream_writedata),
      .reset_n                                                            (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa)
    );

  nios2_burst_1 the_nios2_burst_1
    (
      .clk                         (clk),
      .downstream_address          (nios2_burst_1_downstream_address),
      .downstream_arbitrationshare (nios2_burst_1_downstream_arbitrationshare),
      .downstream_burstcount       (nios2_burst_1_downstream_burstcount),
      .downstream_byteenable       (nios2_burst_1_downstream_byteenable),
      .downstream_debugaccess      (nios2_burst_1_downstream_debugaccess),
      .downstream_nativeaddress    (nios2_burst_1_downstream_nativeaddress),
      .downstream_read             (nios2_burst_1_downstream_read),
      .downstream_readdata         (nios2_burst_1_downstream_readdata),
      .downstream_readdatavalid    (nios2_burst_1_downstream_readdatavalid),
      .downstream_waitrequest      (nios2_burst_1_downstream_waitrequest),
      .downstream_write            (nios2_burst_1_downstream_write),
      .downstream_writedata        (nios2_burst_1_downstream_writedata),
      .reset_n                     (nios2_burst_1_downstream_reset_n),
      .upstream_address            (nios2_burst_1_upstream_byteaddress),
      .upstream_burstcount         (nios2_burst_1_upstream_burstcount),
      .upstream_byteenable         (nios2_burst_1_upstream_byteenable),
      .upstream_debugaccess        (nios2_burst_1_upstream_debugaccess),
      .upstream_nativeaddress      (nios2_burst_1_upstream_address),
      .upstream_read               (nios2_burst_1_upstream_read),
      .upstream_readdata           (nios2_burst_1_upstream_readdata),
      .upstream_readdatavalid      (nios2_burst_1_upstream_readdatavalid),
      .upstream_waitrequest        (nios2_burst_1_upstream_waitrequest),
      .upstream_write              (nios2_burst_1_upstream_write),
      .upstream_writedata          (nios2_burst_1_upstream_writedata)
    );

  sdram_0_s1_arbitrator the_sdram_0_s1
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_sdram_0_s1                            (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                     (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_sdram_0_s1                               (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_no_byte_enables_and_last_term                    (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_sdram_0_s1                     (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                       (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register        (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_sdram_0_s1                              (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_waitrequest                                      (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_sdram_0_s1                        (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1              (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_sdram_0_s1                       (cpu_0_instruction_master_requests_sdram_0_s1),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .nios2_burst_0_downstream_address_to_slave                          (nios2_burst_0_downstream_address_to_slave),
      .nios2_burst_0_downstream_arbitrationshare                          (nios2_burst_0_downstream_arbitrationshare),
      .nios2_burst_0_downstream_burstcount                                (nios2_burst_0_downstream_burstcount),
      .nios2_burst_0_downstream_byteenable                                (nios2_burst_0_downstream_byteenable),
      .nios2_burst_0_downstream_granted_sdram_0_s1                        (nios2_burst_0_downstream_granted_sdram_0_s1),
      .nios2_burst_0_downstream_latency_counter                           (nios2_burst_0_downstream_latency_counter),
      .nios2_burst_0_downstream_qualified_request_sdram_0_s1              (nios2_burst_0_downstream_qualified_request_sdram_0_s1),
      .nios2_burst_0_downstream_read                                      (nios2_burst_0_downstream_read),
      .nios2_burst_0_downstream_read_data_valid_sdram_0_s1                (nios2_burst_0_downstream_read_data_valid_sdram_0_s1),
      .nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register (nios2_burst_0_downstream_read_data_valid_sdram_0_s1_shift_register),
      .nios2_burst_0_downstream_requests_sdram_0_s1                       (nios2_burst_0_downstream_requests_sdram_0_s1),
      .nios2_burst_0_downstream_write                                     (nios2_burst_0_downstream_write),
      .nios2_burst_0_downstream_writedata                                 (nios2_burst_0_downstream_writedata),
      .nios2_burst_1_downstream_address_to_slave                          (nios2_burst_1_downstream_address_to_slave),
      .nios2_burst_1_downstream_arbitrationshare                          (nios2_burst_1_downstream_arbitrationshare),
      .nios2_burst_1_downstream_burstcount                                (nios2_burst_1_downstream_burstcount),
      .nios2_burst_1_downstream_byteenable                                (nios2_burst_1_downstream_byteenable),
      .nios2_burst_1_downstream_granted_sdram_0_s1                        (nios2_burst_1_downstream_granted_sdram_0_s1),
      .nios2_burst_1_downstream_latency_counter                           (nios2_burst_1_downstream_latency_counter),
      .nios2_burst_1_downstream_qualified_request_sdram_0_s1              (nios2_burst_1_downstream_qualified_request_sdram_0_s1),
      .nios2_burst_1_downstream_read                                      (nios2_burst_1_downstream_read),
      .nios2_burst_1_downstream_read_data_valid_sdram_0_s1                (nios2_burst_1_downstream_read_data_valid_sdram_0_s1),
      .nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register (nios2_burst_1_downstream_read_data_valid_sdram_0_s1_shift_register),
      .nios2_burst_1_downstream_requests_sdram_0_s1                       (nios2_burst_1_downstream_requests_sdram_0_s1),
      .nios2_burst_1_downstream_write                                     (nios2_burst_1_downstream_write),
      .nios2_burst_1_downstream_writedata                                 (nios2_burst_1_downstream_writedata),
      .reset_n                                                            (clk_reset_n),
      .sdram_0_s1_address                                                 (sdram_0_s1_address),
      .sdram_0_s1_byteenable_n                                            (sdram_0_s1_byteenable_n),
      .sdram_0_s1_chipselect                                              (sdram_0_s1_chipselect),
      .sdram_0_s1_read_n                                                  (sdram_0_s1_read_n),
      .sdram_0_s1_readdata                                                (sdram_0_s1_readdata),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_readdatavalid                                           (sdram_0_s1_readdatavalid),
      .sdram_0_s1_reset_n                                                 (sdram_0_s1_reset_n),
      .sdram_0_s1_waitrequest                                             (sdram_0_s1_waitrequest),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa),
      .sdram_0_s1_write_n                                                 (sdram_0_s1_write_n),
      .sdram_0_s1_writedata                                               (sdram_0_s1_writedata)
    );

  sdram_0 the_sdram_0
    (
      .az_addr        (sdram_0_s1_address),
      .az_be_n        (sdram_0_s1_byteenable_n),
      .az_cs          (sdram_0_s1_chipselect),
      .az_data        (sdram_0_s1_writedata),
      .az_rd_n        (sdram_0_s1_read_n),
      .az_wr_n        (sdram_0_s1_write_n),
      .clk            (clk),
      .reset_n        (sdram_0_s1_reset_n),
      .za_data        (sdram_0_s1_readdata),
      .za_valid       (sdram_0_s1_readdatavalid),
      .za_waitrequest (sdram_0_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram_0),
      .zs_ba          (zs_ba_from_the_sdram_0),
      .zs_cas_n       (zs_cas_n_from_the_sdram_0),
      .zs_cke         (zs_cke_from_the_sdram_0),
      .zs_cs_n        (zs_cs_n_from_the_sdram_0),
      .zs_dq          (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm         (zs_dqm_from_the_sdram_0),
      .zs_ras_n       (zs_ras_n_from_the_sdram_0),
      .zs_we_n        (zs_we_n_from_the_sdram_0)
    );

  spi_0_spi_control_port_arbitrator the_spi_0_spi_control_port
    (
      .clk                                                        (clk),
      .cpu_0_data_master_address_to_slave                         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_spi_0_spi_control_port           (cpu_0_data_master_granted_spi_0_spi_control_port),
      .cpu_0_data_master_qualified_request_spi_0_spi_control_port (cpu_0_data_master_qualified_request_spi_0_spi_control_port),
      .cpu_0_data_master_read                                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_spi_0_spi_control_port   (cpu_0_data_master_read_data_valid_spi_0_spi_control_port),
      .cpu_0_data_master_requests_spi_0_spi_control_port          (cpu_0_data_master_requests_spi_0_spi_control_port),
      .cpu_0_data_master_write                                    (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                (cpu_0_data_master_writedata),
      .d1_spi_0_spi_control_port_end_xfer                         (d1_spi_0_spi_control_port_end_xfer),
      .reset_n                                                    (clk_reset_n),
      .spi_0_spi_control_port_address                             (spi_0_spi_control_port_address),
      .spi_0_spi_control_port_chipselect                          (spi_0_spi_control_port_chipselect),
      .spi_0_spi_control_port_dataavailable                       (spi_0_spi_control_port_dataavailable),
      .spi_0_spi_control_port_dataavailable_from_sa               (spi_0_spi_control_port_dataavailable_from_sa),
      .spi_0_spi_control_port_endofpacket                         (spi_0_spi_control_port_endofpacket),
      .spi_0_spi_control_port_endofpacket_from_sa                 (spi_0_spi_control_port_endofpacket_from_sa),
      .spi_0_spi_control_port_irq                                 (spi_0_spi_control_port_irq),
      .spi_0_spi_control_port_irq_from_sa                         (spi_0_spi_control_port_irq_from_sa),
      .spi_0_spi_control_port_read_n                              (spi_0_spi_control_port_read_n),
      .spi_0_spi_control_port_readdata                            (spi_0_spi_control_port_readdata),
      .spi_0_spi_control_port_readdata_from_sa                    (spi_0_spi_control_port_readdata_from_sa),
      .spi_0_spi_control_port_readyfordata                        (spi_0_spi_control_port_readyfordata),
      .spi_0_spi_control_port_readyfordata_from_sa                (spi_0_spi_control_port_readyfordata_from_sa),
      .spi_0_spi_control_port_reset_n                             (spi_0_spi_control_port_reset_n),
      .spi_0_spi_control_port_write_n                             (spi_0_spi_control_port_write_n),
      .spi_0_spi_control_port_writedata                           (spi_0_spi_control_port_writedata)
    );

  spi_0 the_spi_0
    (
      .MISO          (MISO_to_the_spi_0),
      .MOSI          (MOSI_from_the_spi_0),
      .SCLK          (SCLK_from_the_spi_0),
      .SS_n          (SS_n_from_the_spi_0),
      .clk           (clk),
      .data_from_cpu (spi_0_spi_control_port_writedata),
      .data_to_cpu   (spi_0_spi_control_port_readdata),
      .dataavailable (spi_0_spi_control_port_dataavailable),
      .endofpacket   (spi_0_spi_control_port_endofpacket),
      .irq           (spi_0_spi_control_port_irq),
      .mem_addr      (spi_0_spi_control_port_address),
      .read_n        (spi_0_spi_control_port_read_n),
      .readyfordata  (spi_0_spi_control_port_readyfordata),
      .reset_n       (spi_0_spi_control_port_reset_n),
      .spi_select    (spi_0_spi_control_port_chipselect),
      .write_n       (spi_0_spi_control_port_write_n)
    );

  timer_0_s1_arbitrator the_timer_0_s1
    (
      .clk                                            (clk),
      .cpu_0_data_master_address_to_slave             (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_timer_0_s1           (cpu_0_data_master_granted_timer_0_s1),
      .cpu_0_data_master_qualified_request_timer_0_s1 (cpu_0_data_master_qualified_request_timer_0_s1),
      .cpu_0_data_master_read                         (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_timer_0_s1   (cpu_0_data_master_read_data_valid_timer_0_s1),
      .cpu_0_data_master_requests_timer_0_s1          (cpu_0_data_master_requests_timer_0_s1),
      .cpu_0_data_master_waitrequest                  (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                        (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                    (cpu_0_data_master_writedata),
      .d1_timer_0_s1_end_xfer                         (d1_timer_0_s1_end_xfer),
      .reset_n                                        (clk_reset_n),
      .timer_0_s1_address                             (timer_0_s1_address),
      .timer_0_s1_chipselect                          (timer_0_s1_chipselect),
      .timer_0_s1_irq                                 (timer_0_s1_irq),
      .timer_0_s1_irq_from_sa                         (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata                            (timer_0_s1_readdata),
      .timer_0_s1_readdata_from_sa                    (timer_0_s1_readdata_from_sa),
      .timer_0_s1_reset_n                             (timer_0_s1_reset_n),
      .timer_0_s1_write_n                             (timer_0_s1_write_n),
      .timer_0_s1_writedata                           (timer_0_s1_writedata)
    );

  timer_0 the_timer_0
    (
      .address    (timer_0_s1_address),
      .chipselect (timer_0_s1_chipselect),
      .clk        (clk),
      .irq        (timer_0_s1_irq),
      .readdata   (timer_0_s1_readdata),
      .reset_n    (timer_0_s1_reset_n),
      .write_n    (timer_0_s1_write_n),
      .writedata  (timer_0_s1_writedata)
    );

  timer_1_s1_arbitrator the_timer_1_s1
    (
      .clk                                            (clk),
      .cpu_0_data_master_address_to_slave             (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_timer_1_s1           (cpu_0_data_master_granted_timer_1_s1),
      .cpu_0_data_master_qualified_request_timer_1_s1 (cpu_0_data_master_qualified_request_timer_1_s1),
      .cpu_0_data_master_read                         (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_timer_1_s1   (cpu_0_data_master_read_data_valid_timer_1_s1),
      .cpu_0_data_master_requests_timer_1_s1          (cpu_0_data_master_requests_timer_1_s1),
      .cpu_0_data_master_waitrequest                  (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                        (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                    (cpu_0_data_master_writedata),
      .d1_timer_1_s1_end_xfer                         (d1_timer_1_s1_end_xfer),
      .reset_n                                        (clk_reset_n),
      .timer_1_s1_address                             (timer_1_s1_address),
      .timer_1_s1_chipselect                          (timer_1_s1_chipselect),
      .timer_1_s1_irq                                 (timer_1_s1_irq),
      .timer_1_s1_irq_from_sa                         (timer_1_s1_irq_from_sa),
      .timer_1_s1_readdata                            (timer_1_s1_readdata),
      .timer_1_s1_readdata_from_sa                    (timer_1_s1_readdata_from_sa),
      .timer_1_s1_reset_n                             (timer_1_s1_reset_n),
      .timer_1_s1_write_n                             (timer_1_s1_write_n),
      .timer_1_s1_writedata                           (timer_1_s1_writedata)
    );

  timer_1 the_timer_1
    (
      .address    (timer_1_s1_address),
      .chipselect (timer_1_s1_chipselect),
      .clk        (clk),
      .irq        (timer_1_s1_irq),
      .readdata   (timer_1_s1_readdata),
      .reset_n    (timer_1_s1_reset_n),
      .write_n    (timer_1_s1_write_n),
      .writedata  (timer_1_s1_writedata)
    );

  tri_state_bridge_0_avalon_slave_arbitrator the_tri_state_bridge_0_avalon_slave
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                   (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                   (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                        (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_8                                      (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_cfi_flash_0_s1                           (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_no_byte_enables_and_last_term                    (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                 (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                   (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_requests_cfi_flash_0_s1                          (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                    (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1          (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1            (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                   (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                        (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .incoming_tri_state_bridge_0_data                                   (incoming_tri_state_bridge_0_data),
      .incoming_tri_state_bridge_0_data_with_Xs_converted_to_0            (incoming_tri_state_bridge_0_data_with_Xs_converted_to_0),
      .registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1        (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .reset_n                                                            (clk_reset_n),
      .select_n_to_the_cfi_flash_0                                        (select_n_to_the_cfi_flash_0),
      .tri_state_bridge_0_address                                         (tri_state_bridge_0_address),
      .tri_state_bridge_0_data                                            (tri_state_bridge_0_data),
      .tri_state_bridge_0_readn                                           (tri_state_bridge_0_readn),
      .write_n_to_the_cfi_flash_0                                         (write_n_to_the_cfi_flash_0)
    );

  uart_0_s1_arbitrator the_uart_0_s1
    (
      .clk                                           (clk),
      .cpu_0_data_master_address_to_slave            (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_uart_0_s1           (cpu_0_data_master_granted_uart_0_s1),
      .cpu_0_data_master_qualified_request_uart_0_s1 (cpu_0_data_master_qualified_request_uart_0_s1),
      .cpu_0_data_master_read                        (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_uart_0_s1   (cpu_0_data_master_read_data_valid_uart_0_s1),
      .cpu_0_data_master_requests_uart_0_s1          (cpu_0_data_master_requests_uart_0_s1),
      .cpu_0_data_master_write                       (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                   (cpu_0_data_master_writedata),
      .d1_uart_0_s1_end_xfer                         (d1_uart_0_s1_end_xfer),
      .reset_n                                       (clk_reset_n),
      .uart_0_s1_address                             (uart_0_s1_address),
      .uart_0_s1_begintransfer                       (uart_0_s1_begintransfer),
      .uart_0_s1_chipselect                          (uart_0_s1_chipselect),
      .uart_0_s1_dataavailable                       (uart_0_s1_dataavailable),
      .uart_0_s1_dataavailable_from_sa               (uart_0_s1_dataavailable_from_sa),
      .uart_0_s1_irq                                 (uart_0_s1_irq),
      .uart_0_s1_irq_from_sa                         (uart_0_s1_irq_from_sa),
      .uart_0_s1_read_n                              (uart_0_s1_read_n),
      .uart_0_s1_readdata                            (uart_0_s1_readdata),
      .uart_0_s1_readdata_from_sa                    (uart_0_s1_readdata_from_sa),
      .uart_0_s1_readyfordata                        (uart_0_s1_readyfordata),
      .uart_0_s1_readyfordata_from_sa                (uart_0_s1_readyfordata_from_sa),
      .uart_0_s1_reset_n                             (uart_0_s1_reset_n),
      .uart_0_s1_write_n                             (uart_0_s1_write_n),
      .uart_0_s1_writedata                           (uart_0_s1_writedata)
    );

  uart_0 the_uart_0
    (
      .address       (uart_0_s1_address),
      .begintransfer (uart_0_s1_begintransfer),
      .chipselect    (uart_0_s1_chipselect),
      .clk           (clk),
      .cts_n         (cts_n_to_the_uart_0),
      .dataavailable (uart_0_s1_dataavailable),
      .irq           (uart_0_s1_irq),
      .read_n        (uart_0_s1_read_n),
      .readdata      (uart_0_s1_readdata),
      .readyfordata  (uart_0_s1_readyfordata),
      .reset_n       (uart_0_s1_reset_n),
      .rts_n         (rts_n_from_the_uart_0),
      .rxd           (rxd_to_the_uart_0),
      .txd           (txd_from_the_uart_0),
      .write_n       (uart_0_s1_write_n),
      .writedata     (uart_0_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  nios2_reset_clk_domain_synch_module nios2_reset_clk_domain_synch
    (
      .clk      (clk),
      .data_in  (1'b1),
      .data_out (clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    cpu_0_jtag_debug_module_resetrequest_from_sa |
    cpu_0_jtag_debug_module_resetrequest_from_sa);

  //nios2_burst_1_upstream_writedata of type writedata does not connect to anything so wire it to default (0)
  assign nios2_burst_1_upstream_writedata = 0;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0_lane0_module (
                                  // inputs:
                                   data,
                                   rdaddress,
                                   rdclken,
                                   wraddress,
                                   wrclock,
                                   wren,

                                  // outputs:
                                   q
                                )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 21: 0] rdaddress;
  input            rdclken;
  input   [ 21: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [4194303: 0];
  wire    [  7: 0] q;
  reg     [ 21: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("cfi_flash_0.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "cfi_flash_0.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 22,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0 (
                     // inputs:
                      address,
                      read_n,
                      select_n,
                      write_n,

                     // outputs:
                      data
                   )
;

  inout   [  7: 0] data;
  input   [ 21: 0] address;
  input            read_n;
  input            select_n;
  input            write_n;

  wire    [  7: 0] data;
  wire    [  7: 0] data_0;
  wire    [  7: 0] logic_vector_gasket;
  wire    [  7: 0] q_0;
  //s1, which is an e_ptf_slave

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign logic_vector_gasket = data;
  assign data_0 = logic_vector_gasket[7 : 0];
  //cfi_flash_0_lane0, which is an e_ram
  cfi_flash_0_lane0_module cfi_flash_0_lane0
    (
      .data      (data_0),
      .q         (q_0),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data = (~select_n & ~read_n)? q_0: {8{1'bz}};

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/91sp2/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/91sp2/quartus/eda/sim_lib/220model.v"
`include "c:/altera/91sp2/quartus/eda/sim_lib/sgate.v"
`include "eth_ocm/eth_ocm.v"
`include "igor_mac.v"
`include "sdram_0.v"
`include "sdram_0_test_component.v"
`include "timer_0.v"
`include "cpu_0_test_bench.v"
`include "cpu_0_mult_cell.v"
`include "cpu_0_oci_test_bench.v"
`include "cpu_0_jtag_debug_module_tck.v"
`include "cpu_0_jtag_debug_module_sysclk.v"
`include "cpu_0_jtag_debug_module_wrapper.v"
`include "cpu_0.v"
`include "timer_1.v"
`include "uart_0.v"
`include "nios2_burst_1.v"
`include "jtag_uart_0.v"
`include "spi_0.v"
`include "nios2_burst_0.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             MISO_to_the_spi_0;
  wire             MOSI_from_the_spi_0;
  wire             SCLK_from_the_spi_0;
  wire             SS_n_from_the_spi_0;
  reg              clk;
  wire             cts_n_to_the_uart_0;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             mcoll_pad_i_to_the_igor_mac;
  wire             mcrs_pad_i_to_the_igor_mac;
  wire             md_pad_i_to_the_igor_mac;
  wire             md_pad_o_from_the_igor_mac;
  wire             md_padoe_o_from_the_igor_mac;
  wire             mdc_pad_o_from_the_igor_mac;
  wire             mrx_clk_pad_i_to_the_igor_mac;
  wire    [  3: 0] mrxd_pad_i_to_the_igor_mac;
  wire             mrxdv_pad_i_to_the_igor_mac;
  wire             mrxerr_pad_i_to_the_igor_mac;
  wire             mtx_clk_pad_i_to_the_igor_mac;
  wire    [  3: 0] mtxd_pad_o_from_the_igor_mac;
  wire             mtxen_pad_o_from_the_igor_mac;
  wire             mtxerr_pad_o_from_the_igor_mac;
  wire             nios2_burst_0_downstream_debugaccess;
  wire    [ 22: 0] nios2_burst_0_downstream_nativeaddress;
  wire    [ 15: 0] nios2_burst_0_upstream_readdata_from_sa;
  wire             nios2_burst_0_upstream_readdatavalid_from_sa;
  wire             nios2_burst_1_downstream_debugaccess;
  wire    [ 22: 0] nios2_burst_1_downstream_nativeaddress;
  wire    [ 15: 0] nios2_burst_1_upstream_writedata;
  reg              reset_n;
  wire             rts_n_from_the_uart_0;
  wire             rxd_to_the_uart_0;
  wire             select_n_to_the_cfi_flash_0;
  wire             spi_0_spi_control_port_dataavailable_from_sa;
  wire             spi_0_spi_control_port_endofpacket_from_sa;
  wire             spi_0_spi_control_port_readyfordata_from_sa;
  wire    [ 21: 0] tri_state_bridge_0_address;
  wire    [  7: 0] tri_state_bridge_0_data;
  wire             tri_state_bridge_0_readn;
  wire             txd_from_the_uart_0;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_readyfordata_from_sa;
  wire             write_n_to_the_cfi_flash_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  nios2 DUT
    (
      .MISO_to_the_spi_0              (MISO_to_the_spi_0),
      .MOSI_from_the_spi_0            (MOSI_from_the_spi_0),
      .SCLK_from_the_spi_0            (SCLK_from_the_spi_0),
      .SS_n_from_the_spi_0            (SS_n_from_the_spi_0),
      .clk                            (clk),
      .cts_n_to_the_uart_0            (cts_n_to_the_uart_0),
      .mcoll_pad_i_to_the_igor_mac    (mcoll_pad_i_to_the_igor_mac),
      .mcrs_pad_i_to_the_igor_mac     (mcrs_pad_i_to_the_igor_mac),
      .md_pad_i_to_the_igor_mac       (md_pad_i_to_the_igor_mac),
      .md_pad_o_from_the_igor_mac     (md_pad_o_from_the_igor_mac),
      .md_padoe_o_from_the_igor_mac   (md_padoe_o_from_the_igor_mac),
      .mdc_pad_o_from_the_igor_mac    (mdc_pad_o_from_the_igor_mac),
      .mrx_clk_pad_i_to_the_igor_mac  (mrx_clk_pad_i_to_the_igor_mac),
      .mrxd_pad_i_to_the_igor_mac     (mrxd_pad_i_to_the_igor_mac),
      .mrxdv_pad_i_to_the_igor_mac    (mrxdv_pad_i_to_the_igor_mac),
      .mrxerr_pad_i_to_the_igor_mac   (mrxerr_pad_i_to_the_igor_mac),
      .mtx_clk_pad_i_to_the_igor_mac  (mtx_clk_pad_i_to_the_igor_mac),
      .mtxd_pad_o_from_the_igor_mac   (mtxd_pad_o_from_the_igor_mac),
      .mtxen_pad_o_from_the_igor_mac  (mtxen_pad_o_from_the_igor_mac),
      .mtxerr_pad_o_from_the_igor_mac (mtxerr_pad_o_from_the_igor_mac),
      .reset_n                        (reset_n),
      .rts_n_from_the_uart_0          (rts_n_from_the_uart_0),
      .rxd_to_the_uart_0              (rxd_to_the_uart_0),
      .select_n_to_the_cfi_flash_0    (select_n_to_the_cfi_flash_0),
      .tri_state_bridge_0_address     (tri_state_bridge_0_address),
      .tri_state_bridge_0_data        (tri_state_bridge_0_data),
      .tri_state_bridge_0_readn       (tri_state_bridge_0_readn),
      .txd_from_the_uart_0            (txd_from_the_uart_0),
      .write_n_to_the_cfi_flash_0     (write_n_to_the_cfi_flash_0),
      .zs_addr_from_the_sdram_0       (zs_addr_from_the_sdram_0),
      .zs_ba_from_the_sdram_0         (zs_ba_from_the_sdram_0),
      .zs_cas_n_from_the_sdram_0      (zs_cas_n_from_the_sdram_0),
      .zs_cke_from_the_sdram_0        (zs_cke_from_the_sdram_0),
      .zs_cs_n_from_the_sdram_0       (zs_cs_n_from_the_sdram_0),
      .zs_dq_to_and_from_the_sdram_0  (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm_from_the_sdram_0        (zs_dqm_from_the_sdram_0),
      .zs_ras_n_from_the_sdram_0      (zs_ras_n_from_the_sdram_0),
      .zs_we_n_from_the_sdram_0       (zs_we_n_from_the_sdram_0)
    );

  cfi_flash_0 the_cfi_flash_0
    (
      .address  (tri_state_bridge_0_address),
      .data     (tri_state_bridge_0_data),
      .read_n   (tri_state_bridge_0_readn),
      .select_n (select_n_to_the_cfi_flash_0),
      .write_n  (write_n_to_the_cfi_flash_0)
    );

  sdram_0_test_component the_sdram_0_test_component
    (
      .clk      (clk),
      .zs_addr  (zs_addr_from_the_sdram_0),
      .zs_ba    (zs_ba_from_the_sdram_0),
      .zs_cas_n (zs_cas_n_from_the_sdram_0),
      .zs_cke   (zs_cke_from_the_sdram_0),
      .zs_cs_n  (zs_cs_n_from_the_sdram_0),
      .zs_dq    (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm   (zs_dqm_from_the_sdram_0),
      .zs_ras_n (zs_ras_n_from_the_sdram_0),
      .zs_we_n  (zs_we_n_from_the_sdram_0)
    );

  initial
    clk = 1'b0;
  always
    #5 clk <= ~clk;
  
  initial 
    begin
      reset_n <= 0;
      #100 reset_n <= 1;
    end

endmodule


//synthesis translate_on