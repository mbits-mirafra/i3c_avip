from command_helper import *
import os
import sys

class Vcom(Generator):
  def __init__(self,v={}):
    super(Vcom,self).__init__
    self.keys = '''
                 cmd       filelists     modelsimini    vcom_extra   vcom_overlay_extra suppress  logfile    msglimit multiuser
                '''.split()

  def set_cmd(self,v={}):
    return 'vcom'

  def set_filelists(self,v={}):
    if 'filelists' not in v:
      logger.error("No filelists variable specified for vcom operation")
      sys.exit(1)
    return filelists(val=v['filelists'],assoc='vhdl')

  def elaborate(self,v={}): 
    self.cmd                  = self.set_cmd(v)          
    self.filelists            = self.set_filelists(v)    
    self.modelsimini          = self.set_modelsimini(v)  
    self.vcom_extra           = self.set_vcom_extra(v)        
    self.vcom_overlay_extra   = self.set_vcom_overlay_extra(v)
    self.suppress             = self.set_suppress(v)     
    self.logfile              = self.set_logfile(v)      
    self.msglimit             = self.set_msglimit(v)     
    self.multiuser            = self.set_multiuser(v)

  def set_vcom_extra(self,v={}):
    if 'vcom_extra' in v and v['vcom_extra']:
      return v['vcom_extra']
    else:
      return ''

  def set_vcom_overlay_extra(self,v={}):
    if 'vcom_overlay_extra' in v and v['vcom_overlay_extra']:
      return v['vcom_overlay_extra']
    else:
      return ''

  def __repr__(self):
    if not self.filelists:
      return ''
    return super(Vcom,self).__repr__()

  def command(self,v):
    if not self.filelists:
      return []
    return super(Vcom,self).command(v)   