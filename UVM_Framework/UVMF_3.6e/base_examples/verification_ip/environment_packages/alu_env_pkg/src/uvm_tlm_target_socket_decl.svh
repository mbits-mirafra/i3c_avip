//-------------------------------------------------------------------------------------
//
// Macro to create a tlm target socket with a user-defined b_transport(), nb_transport_fw callback name
//
//  ------    History  -----
//  Mike Bradley July, 2013  Initial Release
//  Mike Bradley June, 2015  Added nb_transport_fw
//-------------------------------------------------------------------------------------


////////////////////////////////////////////
/// b_transport_XXX IMP
////////////////////////////////////////////

`define UVM_TLM_B_TRANSPORT_IMP_DECL(SFX,imp, T, t, delay)     \
  task b_transport(T t, uvm_tlm_time delay);                   \
    if (delay == null) begin                                   \
       `uvm_error("UVM/TLM/NULLDELAY",                         \
                  {get_full_name(),                            \
                   ".b_transport() called with 'null' delay"}) \
       return;                                                 \
    end                                                        \
    imp.b_transport``SFX(t, delay);                            \
  endtask


`define uvm_tlm_b_target_socket_decl(SFX)                               \
class uvm_tlm_b_target_socket``SFX #(type IMP=int,                      \
                                     type T=uvm_tlm_generic_payload)    \
  extends uvm_tlm_b_target_socket_base #(T);                            \
                                                                        \
  local IMP m_imp;                                                      \
                                                                        \
  function new (string name, uvm_component parent, IMP imp = null);     \
    super.new (name, parent);                                           \
    if (imp == null) $cast(m_imp, parent);                              \
    else m_imp = imp;                                                   \
    if (m_imp == null)                                                  \
       `uvm_error("UVM/TLM2/NOIMP", {"b_target socket ", name,          \
                                     " has no implementation"});        \
  endfunction                                                           \
                                                                        \
  function void connect(this_type provider);                            \
                                                                        \
    uvm_component c;                                                    \
                                                                        \
    super.connect(provider);                                            \
                                                                        \
    c = get_comp();                                                     \
    `uvm_error_context(get_type_name(),                                 \
       "You cannot call connect() on a target termination socket", c)   \
  endfunction                                                           \
                                                                        \
  `UVM_TLM_B_TRANSPORT_IMP_DECL(SFX,m_imp, T, t, delay)                 \
endclass


////////////////////////////////////////////
/// nb_transport_fw_XXX IMP
////////////////////////////////////////////

`define UVM_TLM_NB_TRANSPORT_FW_IMP_DECL(SFX,imp, T, P, t, p, delay)                \
  function uvm_tlm_sync_e nb_transport_fw(T t, ref P p, input uvm_tlm_time delay);  \
    if (delay == null) begin                                                        \
       `uvm_error("UVM/TLM/NULLDELAY",                                              \
                  {get_full_name(),                                                 \
                   ".nb_transport_fw() called with 'null' delay"})                  \
       return UVM_TLM_COMPLETED;                                                    \
    end                                                                             \
    return imp.nb_transport_fw``SFX(t, p, delay);                                   \
  endfunction


`define uvm_tlm_nb_target_socket_decl(SFX)                              \
class uvm_tlm_nb_target_socket``SFX #(type IMP=int                      \
                                     ,type T=uvm_tlm_generic_payload    \
                                     ,type P=uvm_tlm_phase_e)           \
  extends uvm_tlm_nb_target_socket_base #(T,P);                         \
                                                                        \
  local IMP m_imp;                                                      \
                                                                        \
  function new (string name, uvm_component parent, IMP imp = null);     \
    super.new (name, parent);                                           \
    if (imp == null) $cast(m_imp, parent);                              \
    else m_imp = imp;                                                   \
    bw_port = new("bw_port", get_comp());                               \
    if (m_imp == null)                                                  \
       `uvm_error("UVM/TLM2/NOIMP", {"nb_target socket ", name,         \
                                     " has no implementation"});        \
  endfunction                                                           \
                                                                        \
  function void connect(this_type provider);                            \
                                                                        \
    uvm_component c;                                                    \
                                                                        \
    super.connect(provider);                                            \
                                                                        \
    c = get_comp();                                                     \
    `uvm_error_context(get_type_name(),                                 \
       "You cannot call connect() on a target termination socket", c)   \
  endfunction                                                           \
                                                                        \
  `UVM_TLM_NB_TRANSPORT_FW_IMP_DECL(SFX,m_imp, T, P, t, p, delay)       \
endclass


