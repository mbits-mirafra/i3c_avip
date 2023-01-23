from command_helper import *
import os
import sys

class Velanalyze(Generator):

  def __init__(self,v={},sysv=True,hvl=True,analyze_uvm_pkg=False):
    super(Velanalyze,self).__init__()
    self.sysv = sysv
    self.hvl = hvl
    self.analyze_uvm_pkg = analyze_uvm_pkg
    self.keys = '''
                   cmd   extract_sv_vhdl   filelists   src_string  suppress  defines  extra  
                '''.split()

  def set_cmd(self,v={}):
    return 'velanalyze'

  def set_patt(self,v={}):
    if self.sysv:
      if self.hvl:
        return r'.*hvl_vlog.*'
      else:
        return r'.*hdl_vlog.*'
    else:
      if self.hvl:
        return r'.*hvl_vhdl.*'
      else:
        return r'.*hdl_vhdl.*'

  def set_filelists(self,v={}):
    if not v_val(v,'filelists'):
      return ''
    if self.sysv:
      return filelists(val=v['filelists'],assoc='vlog',patt=self.set_patt(v))
    else:
      return filelists(val=v['filelists'],assoc='vhdl',patt=self.set_patt(v))

  def set_extract_sv_vhdl(self,v={}):
    if self.hvl:
      return '-extract_hvl_info'
    else:
      if self.sysv:
        return '-hdl verilog'
      else:
        return '-hdl vhdl'

  def set_defines(self,v={}):
    r = ''
    if v_val(v,'defines'):
      for d in v['defines'].split():
        r = r + " +define+"+d
    return r 

  def set_extra(self,v={}):
    if v_val(v,'extra'):
      return v['extra']
    return ''

  def set_src_string(self,v={}):
    if self.analyze_uvm_pkg and v_val(v,'uvm_path'):
      return '+incdir+'+v['uvm_path']+' '+v['uvm_path']+'/src/uvm_pkg.sv +define+QUESTA'
    else:
      return ''

  def set_suppress(self,v={}):
    if v_val(v,'suppress'):
      return v['suppress']
    return ''

  def elaborate(self,v={}):
    self.cmd              = self.set_cmd(v)              
    self.extract_sv_vhdl  = self.set_extract_sv_vhdl(v)          
    self.filelists        = self.set_filelists(v)        
    self.src_string       = self.set_src_string(v)       
    self.suppress         = self.set_suppress(v)
    self.defines          = self.set_defines(v)
    self.extra            = self.set_extra(v)            

  def command(self,v={}):
    if self.filelists or self.src_string:
      return super(Velanalyze,self).command(v)
    return []

  def __repr__(self):
    if self.filelists or self.src_string:
      return super(Velanalyze,self).__repr__()
    return ''      



