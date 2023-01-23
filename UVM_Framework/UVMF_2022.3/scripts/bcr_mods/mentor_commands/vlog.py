from command_helper import *
import os
import sys

class Vlog(Generator):
  def __init__(self,v={}):
    super(Vlog,self).__init__
    self.keys = '''
                 cmd        arch      filelists      modelsimini   vlog_extra    vlog_overlay_extra 
                 timescale  suppress  logfile        msglimit      lint    multiuser
                '''.split()

  def set_cmd(self,v={}):
    return 'vlog'

  def set_filelists(self,v={}):
    if 'filelists' not in v:
      logger.error("No filelists variable specified for vlog operation")
      sys.exit(1)
    return filelists(val=v['filelists'],assoc='vlog')+" "+filelists(v['filelists'],assoc='c')

  def set_lint(self,v={}):
    if 'lint' in v and v['lint']:
      return '-tbxhvllint+ignorepkgs=uvm_pkg'
    else:
      return ''

  def set_vlog_extra(self,v={}):
    if 'vlog_extra' in v and v['vlog_extra']:
      return v['vlog_extra']
    else:
      return ''

  def set_vlog_overlay_extra(self,v={}):
    if 'vlog_overlay_extra' in v and v['vlog_overlay_extra']:
      return v['vlog_overlay_extra']
    else:
      return ''

  def elaborate(self,v={}):
    self.cmd                     = self.set_cmd(v)         
    self.arch                    = self.set_arch(v)  
    self.filelists               = self.set_filelists(v)     
    self.modelsimini             = self.set_modelsimini(v)   
    self.vlog_extra              = self.set_vlog_extra(v)         
    self.vlog_overlay_extra      = self.set_vlog_overlay_extra(v)         
    self.timescale               = self.set_timescale(v)     
    self.suppress                = self.set_suppress(v)      
    self.logfile                 = self.set_logfile(v)       
    self.msglimit                = self.set_msglimit(v)     
    self.lint                    = self.set_lint(v) 
    self.multiuser               = self.set_multiuser(v)

  def __repr__(self):
    if not self.filelists:
      return ''
    return super(Vlog,self).__repr__()

  def command(self,v):
    if not self.filelists:
      return []
    return super(Vlog,self).command(v)      
