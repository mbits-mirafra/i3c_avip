`include "param.v"
module I3C_TOP(
  input   wire          clk,
  input   wire          rst_n,
  
  // CPU interface
  input   wire          wr_en,
  input   wire          rd_en,
  input   wire  [6:0]   addrs,
  input   wire  [31:0]  w_reg_data,
  input   wire  [7:0]   w_data,
  
  output  wire  [31:0]  rd_data,
  output  wire  [7:0]   r_data,
  output  wire          scl_i,
  output  wire          scl_o,
  input   wire          sda_i,
  output  wire          sda_o,
  output  wire          sda_oe
);

wire        scl_oe;

///// FIFO wires////////////////////
wire        tx_wr_en;
wire [7:0]  tx_wdata;
wire        tx_valid;
wire        tx_ready;
wire [7:0]  tx_rdata;

wire        rx_rd_en;
wire [7:0]  rx_wdata;
wire        rx_valid;
wire [7:0]  rx_rdata;

////// CMD wires/////////////////
wire        cmd_start;
wire [1:0]  cmd_type;
wire [6:0]  cmd_addr;
wire [7:0]  cmd_ccc;
wire [7:0]  cmd_len;
wire        cmd_dir;

/////// From FSM signals//////////////
wire        sdr_done;
wire        sdr_busy;
wire        be_nack;

wire [7:0]  sdr_ccc_code;


////////SDR FSM/////////////////
wire        sdr_error;
wire        push_pull;

wire        start_sdr;
wire        start_daa;
wire        sdr_dir1;
wire [6:0]  sdr_addr;
wire [7:0]  sdr_len;
wire        cmd_busy;

////////DAA wires/////////////////
wire        daa_start;  
wire        daa_error;
wire [6:0]  dyn_addr;
wire        daa_busy;
wire        daa_done;
wire [6:0]  daa_dyn_addr;
wire [47:0]  pid;
wire [7:0]   bcr;
wire [7:0]   dcr;

wire        be_done1;
wire        arb_mode1;
wire        start_r1;
wire        sdr_active = ((cmd_type == 2'b11) || (sdr_ccc_code == 8'h07))?1'b0:1'b1;
wire [7:0]  be_tx_data1;
wire [7:0]  be_rx_data;

wire [7:0]  sdr_be_tx_data;
wire [7:0]  daa_be_tx_data;
wire        be_start;
wire        be_rw;
wire        be_valid;

wire        sdr_be_rw;
wire        daa_be_rw;
wire        sdr_valid;
wire        daa_valid;
wire        sdr_push_pull;
wire        daa_push_pull;

wire        start;
wire        stop;
wire        is_i3c1;
wire [6:0]  sdr_addr1;

assign be_rw       = sdr_active    ? sdr_be_rw      : daa_be_rw;
assign be_tx_data1 = sdr_active    ? sdr_be_tx_data : daa_be_tx_data;
assign be_valid    = sdr_active    ? sdr_valid      : daa_valid;
assign push_pull   = sdr_active    ? sdr_push_pull  : daa_push_pull;

// Tri state (pulled up)
assign scl_i       = scl_oe        ? scl_o          : 1'bz;
assign sda_i       = sda_oe        ? sda_o          : 1'bz; 
parameter integer CLK_FREQ_HZ = 100_000_000;

// Instantiate REG block
i3c_reg_interface x1(
  .clk            (clk),
  .rst_n          (rst_n),  
  .wr_en          (wr_en),
  .rd_en          (rd_en),
  .addrs          (addrs),
  .w_reg_data     (w_reg_data),
  .w_data         (w_data), 
  .rd_data        (rd_data),
  .r_data         (r_data), 
  .Tx_wr_en       (tx_wr_en),
  .Tx_wdata       (tx_wdata),//Write to Tx_fifo
  .Rx_rd_en       (rx_rd_en),
  .Rx_rdata       (rx_rdata),//Read from Rx_fifo ...slave
  .SDR_DONE       (sdr_done),
  .DAA_DONE       (daa_done),
  .SDR_BUSY       (sdr_busy),
  .DAA_BUSY       (daa_busy),
  .SDR_ERROR      (sdr_error),
  .DAA_ERROR      (daa_error),
  .daa_dyn_addr   (dyn_addr),
  .cmd_start      (cmd_start), 
  .cmd_type       (cmd_type),
  .cmd_addr       (cmd_addr),
  .cmd_ccc        (cmd_ccc),
  .cmd_len        (cmd_len),
  .cmd_dir        (cmd_dir) 
);

// Instantiate CMD block
i3c_cmd_ctrl x2(
  .clk            (clk),
  .rst_n          (rst_n), 
  .cmd_start      (cmd_start),
  .cmd_type       (cmd_type),
  .cmd_addr       (cmd_addr),
  .cmd_ccc        (cmd_ccc),
  .cmd_len        (cmd_len),
  .cmd_dir        (cmd_dir),  
  .start_sdr      (start_sdr),
  .sdr_addr       (sdr_addr),
  .sdr_len        (sdr_len),
  .sdr_dir        (sdr_dir1),
  .sdr_ccc_code   (sdr_ccc_code),
  .start_daa      (start_daa),
  .sdr_done       (sdr_done),
  .daa_done       (daa_done),
  .cmd_busy       (cmd_busy)
);

// Instantiate FIFOs
i3c_Tx_FIFO x3(
  .clk            (clk),
  .rst_n          (rst_n),
  .wr_en          (tx_wr_en),
  .din            (tx_wdata),   
  .rd_en          (tx_ready),
  .dout           (tx_rdata),
  .valid          (tx_valid),
  .full           (tx_full),
  .empty          (tx_empty)
);

i3c_Rx_FIFO x4 ( 
  .clk            (clk),
  .rst_n          (rst_n),        
  .wr_en          (rx_valid),
  .din            (rx_wdata),  
  .rd_en          (rx_rd_en),
  .dout           (rx_rdata),
  .valid          (rx_ready),  
  .full           (rx_full),
  .empty          (rx_empty) 
);

//SDR_FSM//////////////////
i3c_sdr_fsm x5 (
  .clk            (clk),
  .rst_n          (rst_n),
  // Command
  .start          (start_sdr),
  .addr           (sdr_addr),
  .dir            (sdr_dir1),
  .len            (sdr_len),
  // TX FIFO
  .tx_data        (tx_rdata),
  .tx_valid       (tx_valid),
  .tx_ready       (tx_ready),
  // RX FIFO
  .rx_data        (rx_wdata),
  .rx_valid       (rx_valid),
  .rx_ready       (rx_ready),
  // Bit engine interface
  .be_valid       (sdr_valid),
  .be_rd_wr       (sdr_be_rw),
  .be_tx_data     (sdr_be_tx_data),
  .be_rx_data     (be_rx_data),
  .be_busy        (be_busy),
  .be_nack        (be_nack),
  // Status
  .busy           (sdr_busy),
  .done           (sdr_done),
  .error          (sdr_error),
  .be_done        (be_done1), 
  .stop_done      (stop),
  .push_pull      (sdr_push_pull),
  .sdr_addr       (sdr_addr1),
  .is_i3c         (is_i3c1)
);

//DAA_FSM/////////////////
i3c_daa_fsm x6 (
  .clk            (clk),
  .rst_n          (rst_n),
  // Control from command FSM / host
  .start_daa      (start_daa),
  .daa_done       (daa_done),
  .start_r        (start_r1),
  .push_pull      (daa_push_pull),
  .valid          (daa_valid),
  .rd_wr          (daa_be_rw),
  .tx_data        (daa_be_tx_data),
  .arb_mode       (arb_mode1),
  .sda_i          (sda_i),
  .scl_i          (scl_i),
  .busy           (be_busy),
  .nack           (be_nack),
  .be_done        (be_done1),
  .pid            (pid),
  .bcr            (bcr),
  .dcr            (dcr),
  .dyn_addr       (dyn_addr),
  .dt_en          (dt_en)
  );

//BIT ENGINE + START?STOP GENERATOR
i3c_device_table x7(
  .clk           (clk),
  .rst_n         (rst_n),
  .rd_en         (),      // read enable (for host - future use)
  .wr_en         (dt_en), // write enable
  .rd_idx        (),
  .wr_data       ({pid,bcr,dcr,dyn_addr}),
  .rd_data       (),      // (for host - future use)
  .rd_valid      (),      // pulses one cycle after rd_en (for host - future use)
  .sdr_addr      (sdr_addr1),
  .is_i3c        (is_i3c1)
);
         
i3c_bit_engine x8 (
  .clk          (clk),
  .rst_n        (rst_n),
  .valid        (be_valid),
  .rd_wr        (be_rw),
  .tx_data      (be_tx_data1),
  .rx_data      (be_rx_data),
  .arb_mode     (arb_mode1),
  .s_r          (start_r1), 
  .scl_i        (scl_i),     // sampled SCL
  .sda_i        (sda_i),
  .sda_o        (sda_o),
  .sda_oe       (sda_oe),
  .busy         (be_busy),
  .nack         (be_nack),
  .push_pull    (push_pull),
  .txn_done     (be_done1),
  .start_done   (start),
  .stop_done    (stop)
);

//SCL GENERATOR/////////////////
i3c_scl_gen x9 (
  .clk        (clk),
  .rst_n      (rst_n),
  .scl_start  (start),
  .scl_stop   (stop), 
  .push_pull  (push_pull), 
  .scl_hz_cfg (12500000),
  .scl_o      (scl_o),   
  .scl_oe     (scl_oe) 
);

endmodule