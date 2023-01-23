from command_helper import *
import os
import sys
from mentor_commands import velanalyze, velcomp

class VeloceHdlBuild(Generator):

  def __init__(self,v={}):
    super(VeloceHdlBuild,self).__init__()
    self.velanalyze_hvl_uvm = velanalyze.Velanalyze(sysv=True,hvl=True,analyze_uvm_pkg=True)
    self.velanalyze_hvl_vlog = velanalyze.Velanalyze(sysv=True,hvl=True)
    self.velanalyze_hdl_vlog = velanalyze.Velanalyze(sysv=True,hvl=False)
    self.velanalyze_hdl_vhdl = velanalyze.Velanalyze(sysv=False,hvl=False)
    self.velcomp = velcomp.Velcomp()
    self.objs = [self.velanalyze_hvl_uvm,self.velanalyze_hvl_vlog,self.velanalyze_hdl_vlog,self.velanalyze_hdl_vhdl,self.velcomp]

  def elaborate(self,v={}):
    vlog_d = {'extra':'','suppress':'','defines':''}
    if v_val(v,'velanalyze_vlog_extra'):
      vlog_d['extra'] = v['velanalyze_vlog_extra']
    if v_val(v,'velanalyze_vlog_suppress'):
      vlog_d['suppress'] = v['velanalyze_vlog_suppress']
    if v_val(v,'velanalyze_vlog_defines'):
      vlog_d['defines'] = v['velanalyze_vlog_defines']
    vhdl_d = {'extra':'','suppress':'','defines':''}
    if v_val(v,'velanalyze_vhdl_extra'):
      vhdl_d['extra'] = v['velanalyze_vhdl_extra']
    if v_val(v,'velanalyze_vhdl_suppress'):
      vlog_d['suppress'] = v['velanalyze_vhdl_suppress']
    if v_val(v,'velanalyze_vhdl_defines'):
      vlog_d['defines'] = v['velanalyze_vhdl_defines']
    extract_d = {'extra':'','suppress':'','defines':''}
    if v_val(v,'velanalyze_extract_suppress'):
      extract_d['suppress'] = v['velanalyze_extract_suppress']
    if v_val(v,'velanalyze_extract_defines'):
      extract_d['defines'] = v['velanalyze_extract_defines']
    if v_val(v,'velanalyze_extract_extra'):
      extract_d['defines'] = v['velanalyze_extract_extra']
    self.velanalyze_hvl_uvm.elaborate(merge_dict(v,extract_d,{'filelists':''}))
    self.velanalyze_hvl_vlog.elaborate(merge_dict(v,extract_d))
    self.velanalyze_hdl_vlog.elaborate(merge_dict(v,vlog_d))
    self.velanalyze_hdl_vhdl.elaborate(merge_dict(v,vhdl_d))
    velcomp_d = {'extra':''}
    if v_val(v,'velcomp_extra'):
      velcomp_d['extra'] = v['velcomp_extra']
    self.velcomp.elaborate(merge_dict(v,velcomp_d))

  def command(self,v={}):
    ret = []
    for o in self.objs:
      ret = ret + o.command(v)
    return ret

  def __repr__(self):
    a = []
    for o in self.objs:
      a.append(repr(o))
    return '\n'.join(a)

def generate_command(v=None):
  obj = VeloceHdlBuild()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)
