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
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : spi interface agent
// Unit            : Transaction coverage
// File            : spi_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class records spi memory slave transaction information using
//       a covergroup named spi_mem_slave_transaction_cg.  An instance of this 
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//
class spi_mem_slave_transaction_coverage extends uvm_subscriber#(spi_transaction);

  `uvm_component_utils( spi_mem_slave_transaction_coverage )

  spi_op_t op;
  bit [2:0] addr;
  bit [3:0] data;

// ****************************************************************************
  covergroup spi_mem_slave_transaction_cg;
     coverpoint op;
     coverpoint addr;
     coverpoint data;
     addr_x_data: cross addr, data;
     op_x_addr: cross op, addr;
  endgroup

  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    spi_mem_slave_transaction_cg=new;
    spi_mem_slave_transaction_cg.set_inst_name($sformatf("spi_mem_slave_transaction_cg_%s",get_full_name()));
 endfunction

  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_LOW);
    if ( t.dir == MOSI ) begin
       if ( t.mosi_data[7] == 1'b1 ) op = SPI_SLAVE_WRITE;
       else                         op = SPI_SLAVE_READ;
       addr = t.mosi_data[6:4];
       data = t.mosi_data[3:0];
       spi_mem_slave_transaction_cg.sample();
    end

  endfunction

endclass
