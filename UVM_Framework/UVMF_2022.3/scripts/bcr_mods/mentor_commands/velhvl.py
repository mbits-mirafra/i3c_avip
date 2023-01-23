from command_helper import *
import os
import sys

class Velhvl(Generator):
  def __init__(self,v={}):
    super(Velhvl,self).__init__
    self.keys = '''
                 cmd        sim     ldflags    extra
                '''.split()

  def set_cmd(self,v={}):
    return 'velhvl'

  def set_sim(self,v={}):
    if v_val(v,'sim'):
      return '-sim '+v['sim']
    return ''

  def set_ldflags(self,v={}):
    if v_val(v,'ldflags'):
      return v['ldflags']
    return ''

  def set_extra(self,v={}):
    if v_val(v,'extra'):
      return v['extra']
    return ''

  def elaborate(self,v={}):
    self.cmd                     = self.set_cmd(v)      
    self.sim                     = self.set_sim(v)      
    self.ldflags                 = self.set_ldflags(v)  
    self.extra                   = self.set_extra(v)    
