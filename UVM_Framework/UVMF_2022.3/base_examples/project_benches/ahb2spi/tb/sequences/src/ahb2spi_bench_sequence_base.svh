//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

class ahb2spi_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( ahb2spi_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // Instantiate sequences here
  ahb_master_access_sequence ahb_master_access_s;
  spi_mem_slave_seq  spi_mem_slave_s;



  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef ahb_transaction  ahb2wb_ahb_transaction_t;
  uvm_sequencer #(ahb2wb_ahb_transaction_t)  ahb2wb_ahb_sequencer; 
  typedef spi_transaction  wb2spi_spi_transaction_t;
  uvm_sequencer #(wb2spi_spi_transaction_t)  wb2spi_spi_sequencer; 


  // Top level environment configuration handle
  typedef ahb2spi_env_configuration #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) ahb2spi_env_configuration_t;
  ahb2spi_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  wb_configuration #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) ahb2wb_wb_config;
  ahb_configuration  ahb2wb_ahb_config;
  wb_configuration #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb2spi_wb_config;
  spi_configuration  wb2spi_spi_config;
  // Local handle to register model for convenience
  ahb2spi_reg_model reg_model;
  uvm_status_e status;

  // pragma uvmf custom class_item_additional begin
  bit [7:0]  ahb_read_data;

// ****************************************************************************
  task get_responses();
     uvm_sequence_item rsp_txn;
     forever begin 
        get_response(rsp_txn);
        `uvm_info("SEQ", rsp_txn.convert2string, UVM_MEDIUM)
     end
  endtask

// ****************************************************************************
  virtual task spi_read_via_ahb(input bit[2:0] addr);

     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     ahb_master_access_s.write(2,{1'b0,addr,4'h0},ahb2wb_ahb_sequencer);

     // Poll DUT status register until read fifo not empty
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     do  ahb_master_access_s.read(1,ahb_read_data,ahb2wb_ahb_sequencer);  while (ahb_read_data[0] == 1'b1);

     ahb_master_access_s.read(2,ahb_read_data,ahb2wb_ahb_sequencer);

  endtask

// ****************************************************************************
  virtual task spi_write_via_ahb(input bit[2:0] addr, input bit [3:0] spi_write_data);
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     ahb_master_access_s.write(2,{1'b1,addr,spi_write_data},ahb2wb_ahb_sequencer);

     // Poll DUT status register until read fifo not empty
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     do  ahb_master_access_s.read(1,ahb_read_data,ahb2wb_ahb_sequencer);  while (ahb_read_data[0] == 1'b1);

     ahb_master_access_s.read(2,ahb_read_data,ahb2wb_ahb_sequencer);

  endtask



  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(ahb2spi_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(ahb2spi_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( wb_configuration#(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::get( null , UVMF_CONFIGURATIONS , ahb2wb_wb_BFM , ahb2wb_wb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( wb_configuration )::get cannot find resource ahb2wb_wb_BFM" )
    if( !uvm_config_db #( ahb_configuration )::get( null , UVMF_CONFIGURATIONS , ahb2wb_ahb_BFM , ahb2wb_ahb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( ahb_configuration )::get cannot find resource ahb2wb_ahb_BFM" )
    if( !uvm_config_db #( wb_configuration#(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::get( null , UVMF_CONFIGURATIONS , wb2spi_wb_BFM , wb2spi_wb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( wb_configuration )::get cannot find resource wb2spi_wb_BFM" )
    if( !uvm_config_db #( spi_configuration )::get( null , UVMF_CONFIGURATIONS , wb2spi_spi_BFM , wb2spi_spi_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( spi_configuration )::get cannot find resource wb2spi_spi_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    ahb2wb_ahb_sequencer = ahb2wb_ahb_config.get_sequencer();
    wb2spi_spi_sequencer = wb2spi_spi_config.get_sequencer();

    reg_model = top_configuration.ahb2spi_rm;


  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");

     spi_mem_slave_s = spi_mem_slave_seq::type_id::create("spi_mem_slave_s");

    ahb2wb_wb_config.wait_for_num_clocks(5);

     fork spi_mem_slave_s.start(wb2spi_spi_sequencer); join_none


     // Read the wb2spi status register
     ahb_master_access_s.read (0,ahb_read_data, ahb2wb_ahb_sequencer);

     // Enable wb2spi device
     ahb_master_access_s.read (0,ahb_read_data, ahb2wb_ahb_sequencer);
     ahb_master_access_s.write(0, 8'h50,ahb2wb_ahb_sequencer);
     ahb_master_access_s.read (0,ahb_read_data, ahb2wb_ahb_sequencer);

     spi_write_via_ahb(3'h1,4'hc); // Write and read DUT data register to send 0xc to addr 0x1 on SPI slave
     spi_write_via_ahb(3'h2,4'h3); // Write and read DUT data register to send 0x3 to addr 0x2 on SPI slave
     spi_read_via_ahb(3'h1);       // Write and read DUT data register to read addr 0x1 on SPI slave
     spi_read_via_ahb(3'h2);       // Write and read DUT data register to read addr 0x1 on SPI slave
     spi_write_via_ahb(3'h3,4'h5); // Write and read DUT data register to send 0x5 to addr 0x2 on SPI slave

    ahb2wb_wb_config.wait_for_num_clocks(100);




    // pragma uvmf custom body end
  endtask

endclass

