from command_helper import *
import os
import importlib
import sys
from mentor_commands import velhvl, vlog, vopt

class VeloceHvlBuild(Generator):

  def __init__(self,v={}):
    super(VeloceHvlBuild,self).__init__()
    self.velhvl_obj = velhvl.Velhvl()
    self.vlog_obj = vlog.Vlog()
    self.vopt_obj = vopt.Vopt()

  def velhvl_elaborate(self,v={}):
    d = {}
    if v_val(v,'velhvl_extra'):
      d['extra'] = v['velhvl_extra']
    if v_val(v,'velhvl_ldflags'):
      d['ldflags'] = v['velhvl_ldflags']
    if v_val(v,'velhvl_sim'):
      d['sim'] = v['velhvl_sim']
    self.velhvl_obj.elaborate(merge_dict(v,d))

  def vlog_elaborate(self,v={}):
    d = {}
    if v_val(v,'vlog_extra'):
      d['extra'] = v['vlog_extra']
    if v_val(v,'vlog_logfile_name'):
      d['log_filename'] = v['vlog_logfile_name']
    self.vlog_obj.elaborate(merge_dict(v,d))

  def vopt_elaborate(self,v={}):
    d = {}
    if v_val(v,'vopt_extra'):
      d['extra'] = v['vopt_extra']
    if v_val(v,'vopt_logfile_name'):
      d['log_filename'] = v['vopt_logfile_name']
    self.vopt_obj.elaborate(merge_dict(v,d))

  def elaborate(self,v={}):
    self.velhvl_elaborate(v)
    self.vlog_elaborate(v)
    self.vopt_elaborate(v)

  def __repr__(self):
    return '\n'.join([repr(self.velhvl_obj),repr(self.vlog_obj),repr(self.vopt_obj)])

  def command(self,v={}):
    return self.vlog_obj.command(v)+self.velhvl_obj.command(v)+self.vopt_obj.command(v)

def generate_command(v=None):
  obj = VeloceHvlBuild()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)

