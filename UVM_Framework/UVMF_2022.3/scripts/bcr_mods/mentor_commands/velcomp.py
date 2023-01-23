from command_helper import *
import os
import sys

class Velcomp(Generator):

  def __init__(self,v={}):
    super(Velcomp,self).__init__()
    self.keys = '''
                   cmd   top  extra  
                '''.split()

  def set_cmd(self,v={}):
    return 'velcomp'

  def set_top(self,v={}):
    if v_val(v,'hdl_top'):
      return '-top '+v['hdl_top']
    return ''

  def set_extra(self,v={}):
    if v_val(v,'extra'):
      return v['extra']
    return ''

  def elaborate(self,v={}):
    self.cmd                     = self.set_cmd(v)  
    self.top                     = self.set_top(v)  
    self.extra                   = self.set_extra(v)

