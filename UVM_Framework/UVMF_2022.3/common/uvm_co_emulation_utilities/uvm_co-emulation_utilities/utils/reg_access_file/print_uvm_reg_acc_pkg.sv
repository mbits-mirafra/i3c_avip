package print_uvm_reg_acc_pkg;
  import uvm_pkg::*;
  import mti_fli::*;

`include "uvm_macros.svh"

  typedef enum { QUESTA, VELOCE, VISUALIZER } file_mode_e;
  
  function string send2vsim(string cmd = "" );
    string result;
    chandle interp;
    
    interp = mti_Interp();
    assert (! mti_Cmd(cmd));
    result = Tcl_GetStringResult(interp);
    Tcl_ResetResult(interp);      
    return result;
  endfunction
  
  function automatic void create_acc_file(uvm_reg_block reg_model,
                                          file_mode_e mode = VELOCE);
    uvm_reg regs[$];
    uvm_hdl_path_concat  paths[$];
    uvm_hdl_path_concat  path;
    static int total = 0;
    static integer acc_file;

    if (mode == QUESTA) begin
      acc_file = $fopen("reg_acc.temp.f", "w");
    end else if (mode == VISUALIZER) begin
      acc_file = $fopen("vis_regs.tcl");
    end else begin
      acc_file = $fopen("forcesetget_nets.sigs", "w");
    end
    
    //Get the queue of registers
    reg_model.get_registers(regs);
    
    foreach (regs[ii]) begin
      if (regs[ii].has_hdl_path()) begin
        regs[ii].get_full_hdl_path(paths);
        do begin
          path = paths.pop_front();
          foreach (path.slices[jj]) begin
            if (mode == QUESTA) begin
              $fdisplay(acc_file, $sformatf("+acc=rn+/%s", path.slices[jj].path));
            end else if (mode == VISUALIZER) begin
              string color = (total%2) ? "Black" : "DarkGrey";
              $fdisplay(acc_file, $sformatf("add regview -viewer \"UVM Registers\" -radix Hex -row %0d -column 0 -name \"%s\" -foreground %s -alignment Right", total, path.slices[jj].path, color));
              $fdisplay(acc_file, $sformatf("add regview -viewer \"UVM Registers\" -radix Hex -row %0d -column 1 -var %s -foreground %s -alignment Right", total, path.slices[jj].path, color));
            end else begin
              $fdisplay(acc_file, path.slices[jj].path);
            end
            total++;
          end
        end while (paths.size() > 0);
      end
    end

    if (mode == VISUALIZER) begin
      $fdisplay(acc_file, $sformatf("echo \"%0d Registers Added\nGo to View -> Register Viewer -> UVM Registers to view them.\"", total));
    end

    $fclose(acc_file);
    if (mode == QUESTA) begin
      void'(send2vsim("exec /bin/sh -c {cat reg_acc.temp.f | sed 'y/./\\\//' > reg_acc.f;rm reg_acc.temp.f}"));
      `uvm_info("CREATE_ACC_FILE", $sformatf("Backdoor register access file \"reg_acc.f\" was created with %0d entries.", total), UVM_NONE)
    end else if (mode == VISUALIZER) begin
      `uvm_info("CREATE_ACC_FILE", $sformatf("Visualizer register access file \"vis_regs.tcl\" was created with %0d entries.", total), UVM_NONE)
      `uvm_info("CREATE_ACC_FILE", $sformatf("After opening Visualizer, execute \"do vis_regs.tcl\" at the Visulizer prompt"), UVM_NONE)
    end else begin //Veloce
      `uvm_info("CREATE_ACC_FILE", $sformatf("Backdoor register access file \"forcesetget_nets.sigs\" was created with %0d entries.", total), UVM_NONE)
      `uvm_info("CREATE_ACC_FILE", $sformatf("Add \"rtlc -forceset_nets_file forcesetget_nets.sigs\" and \"rtlc -get_nets_file forcesetget_nets.sigs\" to your veloce.config"), UVM_NONE)
    end

    total = 0;
  endfunction : create_acc_file

  

endpackage: print_uvm_reg_acc_pkg
