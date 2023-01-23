from command_helper import *
import os
import sys

class Qrun(Generator):

  def __init__(self,v={}):
    super(Qrun,self).__init__
    self.keys = '''
           cmd              arch            flow_control   mode         debug       outdir                 permit_unmatched_virt_intf   vrm_in_use
           logfile          filelists       pdu            seed         msglimit    full_do                timescale                    uvm_switches
           coverage_run     coverage_build  test           verbosity    extra       mvc_switch             visibility                   overlay_extra
           vis_wave         trlog           lib            gen_script   tops        suppress               modelsimini                  vis_designfile
           time_resolution  multiuser
                 '''.split()
    pass
    
  def set_uvm_switches(self,v={}):
    if v_val(v,'uvm_precompiled'):
      if v_val(v,'uvm_version') and v['uvm_version'] != 'uvm-1.1d':
        return "-uvmhome "+v['uvm_version']
      else:
        return ""
    else:
      s = "-uvmhome "+v['uvm_path']
      if v_val(v,'uvm_debug_pkg'):
        s = s+" -uvmexthome "+v['uvm_debug_pkg_location']
      return s

  def set_cmd(self,v={}):
    return 'qrun'

  def set_overlay_extra(self,v={}):
    if (v_val(v,'overlay_extra')):
      return v['overlay_extra']
    else:
      return ""

  def set_filelists(self,v={}):
    if 'sim_only' in v and v['sim_only']:
      return ''
    if 'filelists' not in v:
      return ''
    # File list is just a string, return it
    fl = filelists(v['filelists'])
    if isinstance(fl,str):
      return fl
    # Otherwise assume it is a dict which means we have file type associations. Qrun handles this internally
    # so don't worry about it, though
    filelist_str = ''
    # Could be some library ordering requirements conveyed via a 'liborder' key. Use that
    if 'liborder' in v:
      for l in v['liborder']:
        filelist_str = filelist_str + ' -makelib ' + l + ' ' + fl[l] + ' -endlib ' + ' -L ' + l
    if '__default__' in fl:
      filelist_str = filelist_str + fl['__default__']
    return filelist_str

  def set_pdu(self,v={}):
    pdu_str = ''
    if 'pdu' in v and v['pdu']:
      for p in v['pdu'].split(' '):
        pdu_str = pdu_str + ' -makepdu ' + p.replace('.','_') + "_pdu" + ' ' + p + ' -end'      
    return pdu_str

  def set_outdir(self,v={}):
    if 'outdir' in v and v['outdir'] != '':
      return '-outdir '+v['outdir']
    else:
      return ''

  def set_flow_control(self,v={}):
    if 'build_only' in v and v['build_only']:
      flow_control = '-optimize'
    elif 'compile_only' in v and v['compile_only']:
      flow_control = '-compile'
    elif 'sim_only' in v and v['sim_only']:
      flow_control = '-simulate'
    else:
      flow_control = ''
    return flow_control

  def set_gen_script(self,v={}):
    if 'gen_script' in v and v['gen_script']:
      return '-script qrun_script'
    else:
      return ''

  def set_tops(self,v={}):
    top_str = ''
    if 'tops' in v and v['tops']:
      for t in v['tops'].split():
        top_str = top_str + ' -top '+t
    return top_str

  def elaborate(self,v={}):
    self.mvc_switch                                   = self.set_mvc_switch(v)
    self.msglimit                                     = self.set_msglimit(v)
    self.coverage_run                                 = self.set_coverage_run(v)
    self.coverage_build                               = self.set_coverage_build(v)
    self.verbosity                                    = self.set_verbosity(v)
    self.lib                                          = self.set_lib(v)
    self.arch                                         = self.set_arch(v)
    self.vis_wave                                     = self.set_vis_wave(v)
    self.trlog                                        = self.set_trlog(v)
    self.full_do                                      = self.set_full_do(v)
    self.suppress                                     = self.set_suppress(v)
    self.modelsimini                                  = self.set_modelsimini(v)
    self.extra                                        = self.set_extra(v)
    self.test                                         = self.set_test(v)
    self.logfile                                      = self.set_logfile(v)
    self.seed                                         = self.set_seed(v)
    self.cmd                                          = self.set_cmd(v)
    self.filelists                                    = self.set_filelists(v)
    self.pdu                                          = self.set_pdu(v)
    self.outdir                                       = self.set_outdir(v)
    self.flow_control                                 = self.set_flow_control(v)
    self.access                                       = self.set_access(v)
    self.visibility                                   = self.set_visibility(v)
    self.gen_script                                   = self.set_gen_script(v)
    self.tops                                         = self.set_tops(v)
    self.mode,self.run,self.debug                     = self.set_mode_run_debug(v)
    self.permit_unmatched_virt_intf                   = self.set_permit_unmatched_virt_intf(v)
    self.timescale                                    = self.set_timescale(v)
    self.vis_designfile                               = self.set_vis_designfile(v)
    self.vrm_in_use                                   = self.set_vrm_in_use(v)
    self.uvm_switches                                 = self.set_uvm_switches(v)
    self.overlay_extra                                = self.set_overlay_extra(v)
    self.time_resolution                              = self.set_time_resolution(v)
    self.multiuser                                    = self.set_multiuser(v)

  def command(self,v):
    base_command = super(Qrun,self).command(v)
    return self.set_vmap_commands(v)+base_command

# Command to run a simulation using qrun
def generate_command(v={}):
  obj = Qrun()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)