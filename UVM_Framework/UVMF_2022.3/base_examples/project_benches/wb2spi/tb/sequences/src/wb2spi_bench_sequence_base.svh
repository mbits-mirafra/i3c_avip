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

class wb2spi_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( wb2spi_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // Instantiate sequences here
  wb_master_access_sequence #(.WB_DATA_WIDTH(8),.WB_ADDR_WIDTH(2)) wb_master_access_s;
  spi_mem_slave_seq  spi_mem_slave_s;




  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef wb_transaction #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb_transaction_t;
  uvm_sequencer #(wb_transaction_t)  wb_sequencer; 
  typedef spi_transaction  spi_transaction_t;
  uvm_sequencer #(spi_transaction_t)  spi_sequencer; 


  // Top level environment configuration handle
  typedef wb2spi_env_configuration #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb2spi_env_configuration_t;
  wb2spi_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  wb_configuration #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb_config;
  spi_configuration  spi_config;
  // Local handle to register model for convenience
  wb2spi_reg_model reg_model;
  uvm_status_e status;

  // pragma uvmf custom class_item_additional begin
  bit [WB_DATA_WIDTH-1:0] wb_read_data;
  bit [3:0]  spi_read_data;

  bit [8:0] temp_data;
  string report_id;

// ****************************************************************************
  virtual task get_responses();
     uvm_sequence_item rsp_txn;
     forever begin 
        get_response(rsp_txn);
        `uvm_info("SEQ", rsp_txn.convert2string, UVM_MEDIUM)
     end
  endtask

// ****************************************************************************
  virtual task spi_read_via_wb(input bit[2:0] addr);

     wb_master_access_s.write(2,{1'b0,addr,4'h0},wb_sequencer);

     // Poll DUT status register until read fifo not empty
     wb_master_access_s = wb_master_access_sequence#(.WB_DATA_WIDTH(8),.WB_ADDR_WIDTH(2))::type_id::create("wb_master_access_s");
     do  wb_master_access_s.read(1,wb_read_data,wb_sequencer);  while (wb_read_data[0] == 1'b1);

     wb_master_access_s.read(2,wb_read_data,wb_sequencer);
     this.spi_read_data = wb_read_data[3:0];

  endtask

// ****************************************************************************
  virtual task spi_write_via_wb(input bit[2:0] addr, input bit [3:0] spi_write_data);

     wb_master_access_s.write(2,{1'b1,addr,spi_write_data},wb_sequencer);

     // Poll DUT status register until read fifo not empty
     wb_master_access_s = wb_master_access_sequence#(.WB_DATA_WIDTH(8),.WB_ADDR_WIDTH(2))::type_id::create("wb_master_access_s");
     do  wb_master_access_s.read(1,wb_read_data,wb_sequencer);  while (wb_read_data[0] == 1'b1);

     wb_master_access_s.read(2,wb_read_data,wb_sequencer);
     this.spi_read_data = wb_read_data[3:0];

  endtask

// ****************************************************************************
  virtual task spi_enable();

     wb_master_access_s = wb_master_access_sequence#(.WB_DATA_WIDTH(8),.WB_ADDR_WIDTH(2))::type_id::create("wb_master_access_s");
     wb_master_access_s.write(0,'h50,wb_sequencer);

   endtask




  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(wb2spi_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(wb2spi_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( wb_configuration#(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::get( null , UVMF_CONFIGURATIONS , wb_BFM , wb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_BFM" )
    if( !uvm_config_db #( spi_configuration )::get( null , UVMF_CONFIGURATIONS , spi_BFM , spi_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( spi_configuration )::get cannot find resource spi_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    wb_sequencer = wb_config.get_sequencer();
    spi_sequencer = spi_config.get_sequencer();

    reg_model = top_configuration.wb2spi_rm;


  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
    // Create transaction to be used with read and write operations
    wb_master_access_s = wb_master_access_sequence#(.WB_DATA_WIDTH(8),.WB_ADDR_WIDTH(2))::type_id::create("wb_master_access_s");
    spi_mem_slave_s = spi_mem_slave_seq::type_id::create("spi_mem_slave_s");

    fork spi_mem_slave_s.start(spi_sequencer); join_none
      
    wb_config.wait_for_reset();

    spi_enable(); 

    spi_write_via_wb(3'h1,4'hc); // Write and read DUT data register to send 0xc to addr 0x1 on SPI slave
    spi_write_via_wb(3'h2,4'h3); // Write and read DUT data register to send 0x3 to addr 0x2 on SPI slave
    spi_read_via_wb(3'h1);       // Write and read DUT data register to read addr 0x1 on SPI slave
    spi_read_via_wb(3'h2);       // Write and read DUT data register to read addr 0x1 on SPI slave
    spi_write_via_wb(3'h3,4'h5); // Write and read DUT data register to send 0x5 to addr 0x2 on SPI slave

    wb_config.wait_for_num_clocks(100);





    // pragma uvmf custom body end
  endtask

endclass

