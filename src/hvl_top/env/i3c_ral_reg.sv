/*REGISTERS AVAILABEL IN VERSION1 
config_reg
ctrl_reg
*/

class i3c_config_reg extends uvm_reg;
  rand uvm_reg_field config_data;

  function new(string name = "i3c_config_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    config_data = uvm_reg_field::type_id::create("config_data");
    config_data.configure(this, 32, 0, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass

/*CTRL REG
[31]      start
[30:26]   reserved
[25:24]   cmd_type
[23:16]   CCC
[15]      direction
[14:7]    length
[6:0]     address
*/

class i3c_ctrl_reg extends uvm_reg;

  rand uvm_reg_field start;
       uvm_reg_field reserved;
  rand uvm_reg_field cmd_type;
  rand uvm_reg_field ccc;
  rand uvm_reg_field direction;
  rand uvm_reg_field length;
  rand uvm_reg_field address;

  function new(string name = "i3c_ctrl_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    address = uvm_reg_field::type_id::create("address");
    address.configure(this, 7, 0, "RW", 0, 0, 1, 0, 0);

    length = uvm_reg_field::type_id::create("length");
    length.configure(this, 8, 7, "RW", 0, 0, 1, 0, 0);

    direction = uvm_reg_field::type_id::create("direction");
    direction.configure(this, 1, 15, "RW", 0, 0, 1, 0, 0);

    ccc = uvm_reg_field::type_id::create("ccc");
    ccc.configure(this, 8, 16, "RW", 0, 0, 1, 0, 0);

    cmd_type = uvm_reg_field::type_id::create("cmd_type");
    cmd_type.configure(this, 2, 24, "RW", 0, 0, 1, 0, 0);

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(this, 5, 26, "RO", 0, 0, 1, 0, 0);

    start = uvm_reg_field::type_id::create("start");
    start.configure(this, 1, 31, "RW", 0, 0, 1, 0, 0);

  endfunction

endclass


class i3c_status_reg extends uvm_reg;

  uvm_reg_field sdr_done;
  uvm_reg_field daa_done;
  uvm_reg_field sdr_busy;
  uvm_reg_field daa_busy;
  uvm_reg_field sdr_error;
  uvm_reg_field daa_error;
  uvm_reg_field nak;

  function new(string name = "i3c_status_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    
    sdr_done = uvm_reg_field::type_id::create("sdr_done");
    sdr_done.configure(this, 1, 0, "RO", 0, 0, 1, 0, 0);
daa_done = uvm_reg_field::type_id::create("daa_done");
    daa_done.configure(this, 1, 1, "RO", 0, 0, 1, 0, 0);
sdr_busy = uvm_reg_field::type_id::create("sdr_busy");
    sdr_busy.configure(this, 1, 2, "RO", 0, 0, 1, 0, 0);
daa_busy = uvm_reg_field::type_id::create("daa_busy");
    daa_busy.configure(this, 1, 3, "RO", 0, 0, 1, 0, 0);
sdr_error = uvm_reg_field::type_id::create("sdr_error");
    sdr_error.configure(this, 1, 4, "RO", 0, 0, 1, 0, 0);
daa_error = uvm_reg_field::type_id::create("daa_error");
    daa_error.configure(this, 1, 5, "RO", 0, 0, 1, 0, 0);
nak = uvm_reg_field::type_id::create("nak");
    nak.configure(this, 1, 6, "RO", 0, 0, 1, 0, 0);

  endfunction

endclass

class i3c_dynaddr_reg extends uvm_reg;

  uvm_reg_field dyn_addr;

  function new(string name = "i3c_dynaddr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    dyn_addr = uvm_reg_field::type_id::create("dyn_addr");
    dyn_addr.configure(this, 7, 0, "RO", 0, 0, 1, 0, 0);
  endfunction

endclass


class i3c_wdatab_reg extends uvm_reg;

  rand uvm_reg_field tx_data;

  function new(string name = "i3c_wdatab_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    tx_data = uvm_reg_field::type_id::create("tx_data");
    tx_data.configure(this, 8, 0, "WO", 0, 0, 1, 0, 0);
  endfunction

endclass

//rdatab_reg
class i3c_rdatab_reg extends uvm_reg;

  uvm_reg_field rx_data;

  function new(string name = "i3c_rdatab_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    rx_data = uvm_reg_field::type_id::create("rx_data");
    rx_data.configure(this, 8, 0, "RO", 0, 0, 1, 0, 0);
  endfunction

endclass
