from command_helper import *
import os
import sys
from mentor_commands import vlog, vcom

class QuestaCompile(Generator):

  def __init__(self,v={}):
    super(QuestaCompile,self).__init__
    self.vlog_obj = vlog.Vlog()
    self.vcom_obj = vcom.Vcom()

  def vlog_elaborate(self,v={}):
    d = {}
    if v_val(v,'vlog_extra'):
      d['extra'] = v['vlog_extra']
    if v_val(v,'vlog_log_filename'):
      d['log_filename'] = v['vlog_log_filename']
    self.vlog_obj.elaborate(merge_dict(v,d))

  def vcom_elaborate(self,v={}):
    d = {}
    if v_val(v,'vcom_extra'):
      d['extra'] = v['vcom_extra']
    if v_val(v,'vcom_log_filename'):
      d['log_filename'] = v['vcom_log_filename']
    self.vcom_obj.elaborate(merge_dict(v,d))

  def __repr__(self):
    return '\n'.join([repr(self.vlog_obj),repr(self.vcom_obj)])

  def elaborate(self,v={}):
    self.vlog_elaborate(v)
    self.vcom_elaborate(v)

  def command(self,v):
    # This needs to return any vmap commands, then vlog command, then vcom
    return self.set_vmap_commands(v)+self.vlog_obj.command(v)+self.vcom_obj.command(v)  

# Invoke compile operations for Questa. Verilog (vlog) first, then VHDL (vcom)
def generate_command(v=None):
  obj = QuestaCompile()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)


