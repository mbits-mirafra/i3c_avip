
import uvm_pkg::*;
import uvmc_pkg::*;

class alu_in_vista_transaction extends alu_in_transaction;
    `uvm_object_utils( alu_in_vista_transaction )
    int unsigned cmd;
endclass


// Create Socket classes with specific b_transport names (an "imp" construct)
`include "uvm_tlm_target_socket_decl.svh"
`uvm_tlm_b_target_socket_decl(_req)
`uvm_tlm_nb_target_socket_decl(_req)

class uvmc_vista_stimulus_bridge extends uvm_component;
   `uvm_component_utils(uvmc_vista_stimulus_bridge)

    uvm_tlm_b_target_socket_req   #(uvmc_vista_stimulus_bridge, uvm_tlm_generic_payload)  req_skt;
    uvm_tlm_nb_target_socket_req  #(uvmc_vista_stimulus_bridge, uvm_tlm_generic_payload)  config_skt;

    // variables
    alu_in_vista_transaction req;

    mailbox #(alu_in_vista_transaction) stimMbx;
    //mailbox #(unsigned int)       cmdMbx;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        req_skt      = new("req_skt",    this);
        config_skt   = new("config_skt", this);
        stimMbx    = new(0);
    endfunction


    function void build_phase(uvm_phase phase);
        // Bind local socket to UVM-Connect
        // Default data conversion SC <-> SV
        //uvmc_tlm #(uvm_tlm_generic_payload)::connect(req_skt,    ":uvmc_alu_stimulus");
        //uvmc_tlm #(uvm_tlm_generic_payload)::connect(config_skt, ":uvmc_dbg_alu_stimulus");
        // "Fast Packer" data conversion 
        uvmc_tlm #(uvm_tlm_generic_payload, uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect(req_skt,    ":uvmc_alu_stimulus");
        uvmc_tlm #(uvm_tlm_generic_payload, uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect(config_skt, ":uvmc_dbg_alu_stimulus");
    endfunction: build_phase

    function void connect();
    endfunction: connect

    task run_phase (uvm_phase phase);
        // disable UVM warning about time exceeding max
        uvm_top.set_timeout(0);
    endtask: run_phase

    
    // code to get transactions from SystemC
    //
    // b_transport_regs() was bound to this class via the macro:
    //    `uvm_tlm_b_target_socket_decl(_regs)
    // and socket declaration:
    //    uvm_tlm_b_target_socket_regs #(...) regs_skt
    //
    virtual task b_transport_req(uvm_tlm_generic_payload tlm_gp, uvm_tlm_time delay);
        bit  [63:0]      addr     = tlm_gp.get_address(); 
        int  unsigned    size     = tlm_gp.get_data_length;
        byte unsigned    gpData[] = new[size];
            

        if (size > 4) begin
            `uvm_error("UVMC", $sformatf(" b_transport_req:  unsupported UVMC write size (%d) truncated to 4 bytes.",size))
            size = 4;
        end

        req = alu_in_vista_transaction::type_id::create("req_vista_stimulus");

        // drive TLM write/read transaction into RTL
        // This is the TLM to pin-level transactor
        if(tlm_gp.is_write()) 
        begin
            tlm_gp.get_data(gpData);
            req.a   =  gpData[0];
            req.b   =  gpData[1];
            req.op  =  alu_in_op_t'(gpData[2]);
            req.cmd = 0; // no out-of-band command

            // Send transaction to the sequence (send write data)
            $display("Debug: uvmc_vista_stimulus_bridge::b_transport_req():  %t socket WRITE start addr= %x op=%d a=%d b=%d size= %d"
                    ,$time, addr, req.op, req.a, req.b, size);
            stimMbx.put(req);

        end 
        else begin
          
            `uvm_error("UVMC", " b_transport_req:  READ of this socket is not allowed");
            /*
            // read DUT register

            // Send transaction to the sequence (get read data)
            //$display("Debug: RTL b_transport_regs():  %t start read transaction", $time);
            m_alu_vista_in_sequence.vista_stimulus(req);
            // Todo:  make sure time spent in above is >= the delay from the SC TLM call

            for (int i=0; i<size; i++)
            begin
                gpData[i] = req.XXXX;
            end
            tlm_gp.set_data(gpData);
            //$display("Debug: uvmc_bridge::b_transport_regs():  %t hw_rtl_regs socket READ complete addr= %x data= %x size= %d", $time, addr, gpData, size);
            */
        end

    endtask: b_transport_req

    // non-blocking call from UVM Connect using SystemC TLM "dbg" transport call
    virtual function uvm_tlm_sync_e  nb_transport_fw_req( uvm_tlm_gp tlm_gp, ref uvm_tlm_phase_e tlm_phase, input uvm_tlm_time delay );
        bit  [63:0]      addr     = tlm_gp.get_address(); 
        int  unsigned    size     = tlm_gp.get_data_length;
        byte unsigned    gpData[] = new[size];
        int  unsigned    status;

        tlm_gp.get_data(gpData);
        //$display("uvmc_vista_stimulus_bridge: Received Vista Debug/Command= \"%s%s%s%s\"",gpData[0],gpData[1],gpData[2],gpData[3]);

        tlm_phase = END_RESP;
        tlm_gp.set_response_status( UVM_TLM_OK_RESPONSE );

        req = alu_in_vista_transaction::type_id::create("req_vista_vista_stimulus");
        req.a   =  0; req.b   =  0; req.op  =  alu_in_op_t'(0);
        req.cmd = 1; // out-of-band command: End of Stimulus

        if (gpData[0] == "S" && gpData[1] == "T" && gpData[2] == "O" && gpData[3] == "P" ) 
        begin
            // can only use non-blocking call to stimMbx inside a function.  Should not be an issue, since mailbox is infinite size
            status = stimMbx.try_put(req);
            if (status == 0) begin
                `uvm_fatal("UVMC", "uvmc_vista_stimulus_bridge::nb_transport_fw_req() ERROR could not try_put() to stimMbx (debug call from Vista)");
            end
            else begin
                $display("uvmc_vista_stimulus_bridge: Received non-blocking 'stop simulation' command at %t (debug call from Vista)", $time);
            end
        end 
        else begin
            $display("uvmc_vista_stimulus_bridge: ERROR: Unhandled message from Vista (debug call from Vista)", $time);
        end

        return UVM_TLM_COMPLETED;  
    endfunction



endclass


