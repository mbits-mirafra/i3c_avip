class wb_master_access_sequence #(int WB_ADDR_WIDTH = 32, int WB_DATA_WIDTH = 16 ) 
  extends wb_sequence_base #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH));

  `uvm_object_param_utils(wb_master_access_sequence#(WB_ADDR_WIDTH, WB_DATA_WIDTH ))

  typedef wb_transaction #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb_trans_t;

  bit [WB_ADDR_WIDTH-1:0] req_addr;
  bit [WB_DATA_WIDTH-1:0] req_data;
  wb_op_t req_op;

  function new(string name = "wb_master_access_sequence");
    super.new(name);
  endfunction

  task read(input bit [WB_ADDR_WIDTH-1:0] addr, output bit [WB_DATA_WIDTH-1:0] read_data,
            input uvm_sequencer #(wb_trans_t) seqr,
         // input uvm_sequencer #(wb_transaction #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))) seqr,
            input uvm_sequence_base parent = null);
    this.req_addr = addr;
    this.req_op = WB_READ;
    this.start(seqr,parent);
    read_data = req.data;
  endtask

  task write(input bit [WB_ADDR_WIDTH-1:0] addr, input bit [WB_DATA_WIDTH-1:0] write_data,
             input uvm_sequencer #(wb_trans_t) seqr,
         //  input uvm_sequencer #(wb_transaction #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))) seqr,
             input uvm_sequence_base parent = null);
    this.req_addr = addr;
    this.req_op = WB_WRITE;
    this.req_data = write_data;
    this.start(seqr,parent);
  endtask

  task body();
    req = wb_trans_t::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
      op == req_op;
      addr == req_addr;
      data == req_data;
      byte_select == {WB_DATA_WIDTH/8{1'b1}};
      })
      `uvm_fatal("SEQ","Randomization failed");
    finish_item(req);
    `uvm_info("SEQ",{"Transaction finished: ",req.convert2string()},UVM_MEDIUM)
  endtask

endclass
