//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
module avalon_example(
   input  wire        avalon_mm_clk,          // IN STD_LOGIC;
   input  wire        avalon_mm_reset_n,      // IN STD_LOGIC;
   output bit         avalon_mm_waitrequest,  // OUT STD_LOGIC;
   output bit         avalon_mm_readdatavalid,  // OUT STD_LOGIC;
   input  wire  [8:0] avalon_mm_byteenable,    // IN STD_LOGIC_VECTOR (8 DOWNTO 0);
   input  wire  [8:0] avalon_mm_address,      // IN STD_LOGIC_VECTOR (8 DOWNTO 0);
   input  wire        avalon_mm_read,         // IN STD_LOGIC;
   output reg   [31:0]avalon_mm_readdata,     // OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
   input  wire        avalon_mm_write,        // IN STD_LOGIC;
   input  wire  [31:0]avalon_mm_writedata,    // IN STD_LOGIC_VECTOR (31 DOWNTO 0);

   input  wire        clk,
   input  wire [63:0] user_tx_data,         // in std_logic_vector (63 downto 0);
   input  wire        user_tx_data_valid,   // in std_logic;
   input  wire        user_tx_sop,          // in std_logic;
   input  wire        user_tx_eop,          // in std_logic;
   input  wire        user_tx_error,        // in std_logic;
   input  wire [2:0]  user_tx_mty,          // in std_logic_vector (2 downto 0);
   input  wire        user_tx_dav,          // in std_logic;
   output bit         user_tx_read,         // out std_logic

   output reg  [63:0] user_rx_data,         // out std_logic_vector (63 downto 0);
   output bit         user_rx_data_valid,   // out std_logic;
   output bit         user_rx_sop,          // out std_logic;
   output bit         user_rx_eop,          // out std_logic;
   output bit         user_rx_error,        // out std_logic;
   output bit [2:0]   user_rx_mty           // out std_logic_vector (2 downto 0);
    );

   bit        avalon_mm_read_d1;

   bit         user_tx_read_s1;
   bit         user_tx_read_s2;
   bit         user_tx_read_s3;

   reg  [63:0] user_rx_data_d1;
   bit         user_rx_data_valid_d1;
   bit         user_rx_sop_d1;
   bit         user_rx_eop_d1;
   bit         user_rx_error_d1;
   bit [2:0]   user_rx_mty_d1;

   reg  [63:0] user_rx_data_d2;
   bit         user_rx_data_valid_d2;
   bit         user_rx_sop_d2;
   bit         user_rx_eop_d2;
   bit         user_rx_error_d2;
   bit [2:0]   user_rx_mty_d2;


    always @ (negedge clk ) begin
       avalon_mm_read_d1 <= avalon_mm_read;
       avalon_mm_waitrequest <= (!avalon_mm_read_d1 && avalon_mm_read);
       if (avalon_mm_waitrequest || avalon_mm_readdatavalid ) avalon_mm_readdata <= 'hfeedbeef;
       else                                                   avalon_mm_readdata <= 'bx;
       avalon_mm_readdatavalid <= avalon_mm_waitrequest;
    end

    always @ (negedge clk ) begin
       user_tx_read_s1 <= user_tx_dav && !user_tx_eop;
       user_tx_read_s2 <= user_tx_read_s1;
       user_tx_read_s3 <= user_tx_read_s2;
       user_tx_read <= ( user_tx_read_s3 && user_tx_read_s2 && user_tx_read_s1);
    end

    always @ (negedge clk ) begin
       user_rx_data_d1 <= user_tx_data;
       user_rx_data_valid_d1 <= user_tx_data_valid;
       user_rx_sop_d1 <= user_tx_sop;
       user_rx_eop_d1 <= user_tx_eop;
       user_rx_error_d1 <= user_tx_error;
       user_rx_mty_d1 <= user_tx_mty;

       user_rx_data_d2 <= user_rx_data_d1;
       user_rx_data_valid_d2 <= user_rx_data_valid_d1;
       user_rx_sop_d2 <= user_rx_sop_d1;
       user_rx_eop_d2 <= user_rx_eop_d1;
       user_rx_error_d2 <= user_rx_error_d1;
       user_rx_mty_d2 <= user_rx_mty_d1;

       user_rx_data <= user_rx_data_d2;
       user_rx_data_valid <= user_rx_data_valid_d2;
       user_rx_sop <= user_rx_sop_d2;
       user_rx_eop <= user_rx_eop_d2;
       user_rx_error <= user_rx_error_d2;
       user_rx_mty <= user_rx_mty_d2;
    end    

        
endmodule

// ****************************************************************************
// ****************************************************************************
