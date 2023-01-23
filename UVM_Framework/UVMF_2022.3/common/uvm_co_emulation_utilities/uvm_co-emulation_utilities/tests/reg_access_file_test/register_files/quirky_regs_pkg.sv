package quirky_regs_pkg;
`include "uvm_macros.svh"  

  import uvm_pkg::*;

//
// The slave_reg has two fields: The upper 8-bits and the lower 8-bits
//
// It is used with the mirror_reg below
//
class slave_reg extends uvm_reg;
  `uvm_object_utils(slave_reg)
  
  rand uvm_reg_field upper; 
  rand uvm_reg_field lower; 
  
  
  // Function: new
  // 
  function new(string name = "slave_reg",
               int has_coverage = UVM_NO_COVERAGE);
    super.new(name, 16, has_coverage);
  endfunction
  
  
  // Function: build
  // 
  virtual function void build();
    upper = uvm_reg_field::type_id::create("upper");
    lower = uvm_reg_field::type_id::create("lower");
    
    upper.configure(this, 8, 8, "RW", 0, 8'h00, 1, 1, 1);
    lower.configure(this, 8, 0, "RW", 0, 8'h00, 1, 1, 1);
  endfunction : build
endclass : slave_reg

  
//
// The mirror_reg has a user-defined behavior
//
// It updates the lower 8-bits of another register with the upper 8-bits from
// itself whenever it is written
//
typedef class mirror_reg;
class mirror_reg_cbs extends uvm_reg_cbs;
  mirror_reg  parent;

  virtual function void post_predict(input uvm_reg_field  fld,
                                     input uvm_reg_data_t previous,
                                     inout uvm_reg_data_t value,
                                     input uvm_predict_e kind,
                                     input uvm_path_e path,
                                     input uvm_reg_map map);
    if (parent == null)
      if ( !$cast(parent, fld.get_parent()) )
        `uvm_fatal("mirror_reg_cbs", "parent cast failed")
    
    if (kind != UVM_PREDICT_WRITE) return;
    if (!(path == UVM_FRONTDOOR || path == UVM_PREDICT)) return;

    if (!parent.slave.get_field_by_name("lower").predict(.value(value),
                                                         .kind (kind),
                                                         .path(path),
                                                         .map (map)) )
      `uvm_error("mirror_reg_cbs", "slave register prediction failed")

  endfunction : post_predict
endclass :mirror_reg_cbs

  
class mirror_reg extends uvm_reg;
  `uvm_object_utils(mirror_reg)
  
  rand uvm_reg_field upper; 
  rand uvm_reg_field lower;

  slave_reg          slave;

  // Function: new
  // 
  function new(string name = "mirror_reg",
               int has_coverage = UVM_NO_COVERAGE);
    super.new(name, 16, has_coverage);
  endfunction : new

  virtual function void build(slave_reg slave_h);
    upper = uvm_reg_field::type_id::create("upper");
    lower = uvm_reg_field::type_id::create("lower");

    upper.configure(this, 8, 8, "RW", 0, 8'h00, 1, 1, 1);
    lower.configure(this, 8, 0, "RW", 0, 8'h00, 1, 1, 1);

    slave = slave_h;

    begin
      mirror_reg_cbs cb = new;
      cb.set_name("mirror_reg callback"); //makes messages prettier
      uvm_reg_field_cb::add(upper, cb);
      
      uvm_reg_field_cb::display();
      
    end
    
  endfunction : build
endclass : mirror_reg
  

//
// The apply_holding_reg has a user-defined behavior
//
// It moves the data from holding_reg to data_reg when a '1' is written
//
typedef class apply_holding_reg;
class apply_holding_reg_cbs extends uvm_reg_cbs;
  apply_holding_reg  parent;
  
  virtual function void post_predict(input uvm_reg_field  fld,
                                     input uvm_reg_data_t previous,
                                     inout uvm_reg_data_t value,
                                     input uvm_predict_e kind,
                                     input uvm_path_e path,
                                     input uvm_reg_map map);
    uvm_reg_data_t temp;
    
    if (parent == null)
      if ( !$cast(parent, fld.get_parent()) )
        `uvm_error("apply_holding_reg_cbs", "parent cast failed")
    
    if (kind != UVM_PREDICT_WRITE) return;
    if (!(path == UVM_FRONTDOOR || path == UVM_PREDICT)) return;

    //Copy the value to the data reg from the holding reg
    //Since data reg RO, it will only be updated on a read so we are forcing a
    // read
    temp = parent.holding.get();
    if (!parent.data.predict(.value(temp),
                             .kind (UVM_PREDICT_READ),
                             .path(path),
                             .map (map)) )
      `uvm_error("apply_holding_reg_cbs", "data reg prediction failed")
    //Clear the apply_holding_reg field
    value = 0;
  endfunction : post_predict
endclass :apply_holding_reg_cbs

  
class apply_holding_reg extends uvm_reg;
  `uvm_object_utils(apply_holding_reg)

  uvm_reg_field reserved; 
  rand uvm_reg_field apply_holding_reg;

  uvm_reg          holding;
  uvm_reg          data;

  // Function: new
  // 
  function new(string name = "apply_holding_reg",
               int has_coverage = UVM_NO_COVERAGE);
    super.new(name, 16, has_coverage);
  endfunction : new

  // Function: build
  // 
  virtual          function void build(uvm_reg holding_reg, uvm_reg data_reg);
    reserved = uvm_reg_field::type_id::create("reserved");
    apply_holding_reg = uvm_reg_field::type_id::create("apply_holding_reg");
    
    reserved.configure(this, 15, 1, "RO", 0, 15'b000000000000000, 1, 0, 0);
    apply_holding_reg.configure(this, 1, 0, "RW", 0, 1'b0, 1, 1, 0);

    holding = holding_reg;
    data = data_reg;

    begin
      apply_holding_reg_cbs cb = new;
      cb.set_name("apply_holding_reg callback"); //makes messages prettier
      uvm_reg_field_cb::add(apply_holding_reg, cb);
      
      uvm_reg_field_cb::display();
      
    end
  endfunction : build
endclass : apply_holding_reg




//
// The go_bit_reg has a user-defined behavior
//
// In actual hardware, a process is initialized when this bit is set which
// then clears the bit.  Here the bit is just simply cleared automatically.
//
typedef class go_bit_reg;
class go_bit_reg_cbs extends uvm_reg_cbs;
  
  virtual function void post_predict(input uvm_reg_field  fld,
                                     input uvm_reg_data_t previous,
                                     inout uvm_reg_data_t value,
                                     input uvm_predict_e kind,
                                     input uvm_path_e path,
                                     input uvm_reg_map map);
    
    if (kind != UVM_PREDICT_WRITE) return;
    if (!(path == UVM_FRONTDOOR || path == UVM_PREDICT)) return;
    
    //Clear the field
    value = 0;
  endfunction : post_predict
endclass :go_bit_reg_cbs

  
class go_bit_reg extends uvm_reg;
  `uvm_object_utils(go_bit_reg)

  //Only adding go_bit register field.  Other fields need to be added in class extension
  rand uvm_reg_field go_bit;

  // Function: new
  // 
  function new(string name = "go_bit_reg",
               int unsigned n_bits = 32,
               int has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  // Function: build
  //
  // Build will build the go_bit field in the position specified with the reset value specified.
  //  Other regiser fields need to be built in the build() function defined in the extended class
  virtual          function void go_bit_build(int unsigned   go_bit_lsb_pos,
                                       uvm_reg_data_t go_bit_reset_val);
    go_bit = uvm_reg_field::type_id::create("go_bit");
    
    go_bit.configure(this, 1, go_bit_lsb_pos, "RW", 1, go_bit_reset_val, 1, 1, 0);

    begin
      //Register the callback defined above only for the go_bit.  The rest of the register fields
      // will not be effected by this callback.
      go_bit_reg_cbs cb = new;
      cb.set_name("go_bit_reg callback"); //makes messages prettier
      uvm_reg_field_cb::add(go_bit, cb);
      
      uvm_reg_field_cb::display();
      
    end
  endfunction : go_bit_build
endclass : go_bit_reg


endpackage : quirky_regs_pkg
