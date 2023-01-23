/*****************************************************************************
 *
 * Copyright 2007-2019 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/

// Class: dma_util_seq
//
// The body of this sequences executes various-width writes and reads.
//
class dma_util_seq extends uvm_sequence;

  `uvm_object_utils(dma_util_seq)

  bit [1:0] util_cmd;       // default value is 0, thus preload
  bit [1:0] preload_mode;    // default value is 0, thus preload with 0's
  int unsigned image_source_address  = 32'h0000_1000;
  int unsigned image_target_address  = 32'h0000_1000;
  int unsigned image_total_len       = 32'h0000_0200;

  // QVIP Configuration handles to access slave and scoreboard memories
  mgc_axi4_s0_cfg_t axi4_s0_cfg;

  function new(string name="");
    super.new(name);
  endfunction

  // Task: body
  //
  // This is standard UVM body task.
  // This calls the task to choose the transaction to be started on the
  // address channel.
  //
  // (begin inline source)
  
  virtual task body();
  
    if (axi4_s0_cfg == null) begin
       `uvm_fatal("SEQ/UTILITY", $sformatf("axi4_s0_cfg handle is null. It must be set prior to calling this sequence.") );
    end

    /////////////
    // PRELOAD //
    /////////////
    if (util_cmd == 2'b0) begin //{
      bit [7:0] wr_data;
      `uvm_info("SEQ/UTILITY","Starting backdoor preload" , UVM_MEDIUM)
      // Programming the slave memory and scoreboard memory through backdoor write
      for(int unsigned i = image_source_address; i < image_source_address + image_total_len; i++) begin //{
        // preload_mode determines fill pattern
        case (preload_mode) 
          2'b00: wr_data = 8'b0;
          2'b01: wr_data = $random;
          2'b10: begin //{
                   case (i[7:0]%8)
                     3'b000: wr_data = i[ 7: 0];
                     3'b001: wr_data = i[15: 8];
                     3'b010: wr_data = i[23:16];
                     3'b011: wr_data = i[31:24];
                     3'b100: wr_data = 8'b0; /* i[39:32]; only have 32-bit address */ 
                     3'b101: wr_data = 8'b0; /* i[47:40]; .. */
                     3'b110: wr_data = 8'b0; /* i[55:48]; .. */
                     3'b111: wr_data = 8'b0; /* i[63:54]; .. */
                   endcase
                 end //}
          default: wr_data = 8'b0;
        endcase
        axi4_s0_cfg.slv_mem.backdoor_write(i,wr_data);
        axi4_s0_cfg.scoreboard_mem.backdoor_write(i, wr_data);
      end //}
      `uvm_info("SEQ/UTILITY","Backdoor preload done" , UVM_MEDIUM)
    end //}

    /////////////
    // COMPARE //
    /////////////
    else if (util_cmd == 2'b01) begin //{
      `uvm_info("SEQ/UTILITY","Starting comparison" , UVM_MEDIUM)
      for (int unsigned i = 0; i < image_total_len; i++) begin //{
        if (axi4_s0_cfg.slv_mem.backdoor_read(image_source_address + i) !=
            axi4_s0_cfg.slv_mem.backdoor_read(image_target_address + i) )
           `uvm_error( "SEQ/UTILITY",
                 $psprintf( {"Error in data comparison: Expected = %h : Actual = %h : ref_address = %h"},
                             axi4_s0_cfg.slv_mem.backdoor_read(image_source_address + i),
                             axi4_s0_cfg.slv_mem.backdoor_read(image_target_address + i),
                             image_source_address + i))
      end //}
      `uvm_info("SEQ/UTILITY","comparison done" , UVM_MEDIUM)
    end //}

  endtask
  // (end inline source)
  
endclass
