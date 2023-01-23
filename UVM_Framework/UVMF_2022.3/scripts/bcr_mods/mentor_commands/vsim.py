from command_helper import *
import os
import sys

class Vsim(Generator):
  def __init__(self,v={}):
    super(Vsim,self).__init__
    self.keys = '''
                 cmd         arch    mode         tops    logfile      seed     msglimit    coverage_run    lib           test                        vrm_in_use
                 verbosity   vsim_extra  vsim_overlay_extra mvc_switch   vis_wave     trlog    full_do     suppress        modelsimini   permit_unmatched_virt_intf          lint
                '''.split()

  def set_cmd(self,v={}):
    return 'vsim'

  def set_lib(self,v={}):
    if 'lib' in v and v['lib']:
      return '-lib '+v['lib']
    return ''

  def set_lint(self,v={}):
    if 'lint' in v and v['lint']:
      return '-tbxhvllint'
    else:
      return ''

  def set_mode_run_debug(self,v={}):
    if 'live' in v and v['live']:
      run_cmd = 'run 0'
      debug_str = '-onfinish stop -classdebug'
      if ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
        mode_str = '-visualizer'
      else:
        debug_str = debug_str + ' -uvmcontrol=all -msgmode both'
        mode_str = '-gui'
      if 'enable_trlog' not in v or v['enable_trlog']=='':
        v['enable_trlog'] = True
    else:
      if 'mode' not in v:
        logger.error("No mode specified in variables dict")
        sys.exit(1)
      mode_str = v['mode']
      run_cmd = 'run -all'
      debug_str = ''
    return (mode_str, run_cmd, debug_str)

  def set_vsim_extra(self,v={}):
    if 'vsim_extra' in v and v['vsim_extra']:
      return v['vsim_extra']
    else:
      return ''

  def set_vsim_overlay_extra(self,v={}):
    if 'vsim_overlay_extra' in v and v['vsim_overlay_extra']:
      return v['vsim_overlay_extra']
    else:
      return ''

  def elaborate(self,v={}):
    self.cmd                         = self.set_cmd(v)
    self.arch                        = self.set_arch(v)
    self.tops                        = self.set_tops(v)
    self.logfile                     = self.set_logfile(v)
    self.seed                        = self.set_seed(v)
    self.msglimit                    = self.set_msglimit(v)
    self.coverage_run                = self.set_coverage_run(v)
    self.lib                         = self.set_lib(v)
    self.test                        = self.set_test(v)
    self.verbosity                   = self.set_verbosity(v)
    self.vsim_extra                  = self.set_vsim_extra(v)
    self.vsim_overlay_extra          = self.set_vsim_overlay_extra(v)
    self.mvc_switch                  = self.set_mvc_switch(v)
    self.mode,self.run,self.debug    = self.set_mode_run_debug(v)
    self.vis_wave                    = self.set_vis_wave(v)
    self.trlog                       = self.set_trlog(v)
    self.full_do                     = self.set_full_do(v)
    self.suppress                    = self.set_suppress(v)
    self.modelsimini                 = self.set_modelsimini(v)
    self.permit_unmatched_virt_intf  = self.set_permit_unmatched_virt_intf(v)
    self.vrm_in_use                  = self.set_vrm_in_use(v)
    self.lint                        = self.set_lint(v)

def generate_command(v={}):
  obj = Vsim()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)
