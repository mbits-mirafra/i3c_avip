module create_access_file ();
  function automatic bit auto_gen(); 
    dut_registers_pkg::reg_block user_block = new();
    user_block.build();
    print_uvm_reg_acc_pkg::create_acc_file(user_block, print_uvm_reg_acc_pkg::QUESTA);
    print_uvm_reg_acc_pkg::create_acc_file(user_block, print_uvm_reg_acc_pkg::VELOCE);
    print_uvm_reg_acc_pkg::create_acc_file(user_block, print_uvm_reg_acc_pkg::VISUALIZER);
    return 1;
  endfunction : auto_gen

  bit auto_generate = auto_gen();

endmodule :  create_access_file