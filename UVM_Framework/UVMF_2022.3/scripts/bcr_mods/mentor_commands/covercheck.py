from command_helper import *
import os
import sys

class CoverCheck(Generator):

  def __init__(self,v={}):
    super(CoverCheck,self).__init__()
    self.keys = '''
                  cmd  mode output_dir full_do
                 '''.split()

  def set_cmd(self,v={}):
    return 'qverify'

  def set_output_dir(self,v={}):
    if v_val(v,'output_dir'):
      return '-od '+v['output_dir']
    else:
      return '-od covercheck_results'

  def set_ucdb_load_cmd(self,v={}):
    if v_val(v,'ucdb_filename'):
      return 'covercheck load ucdb '+v['ucdb_filename']
    else:
      return ''

  def set_verify_cmd(self,v={}):
    verify_cmd = 'covercheck verify'
    if v_val(v,'timeout'):
      verify_cmd = verify_cmd+' -timeout '+v['timeout']
    if v_val(v,'init_file'):
      set_verify_cmd = verify_cmd+' -init '+v['init_file']
    if v_val(v,'verify_extra'):
      verify_cmd = verify_cmd+' '+v['verify_extra']
    return verify_cmd

  def set_compile_cmd(self,v={}):
    compile_cmd = 'covercheck compile'
    if v_val(v,'lib'):
      compile_cmd = compile_cmd+' -work '+v['lib']
    if v_val(v,'modelsimini'):
      compile_cmd = compile_cmd+' -modelsimini '+v['modelsimini']
    if v_val(v,'top'):
      compile_cmd = compile_cmd+' -d '+v['top']
    if v_val(v,'compile_extra'):
      compile_cmd = compile_cmd+' '+v['compile_extra']
    return compile_cmd

  def set_mode(self,v={}):
    return '-c'

  def set_directives_cmd(self,v={}):
    if v_val(v,'directives_file'):
      return 'do '+v['directives_file']
    return ''

  def set_generate_exclude_cmd(self,v={}):
    return 'covercheck generate exclude covercheck_exclude.do'

  def set_exit_cmd(self,v={}):
    return 'exit'

  def set_do(self,v={}):
    return ';'.join([self.set_directives_cmd(v),self.set_compile_cmd(v),self.set_ucdb_load_cmd(v),self.set_verify_cmd(v),self.set_generate_exclude_cmd(v),self.set_exit_cmd(v)])


  def elaborate(self,v={}):
    self.cmd          = self.set_cmd(v)
    self.mode         = self.set_mode(v)
    self.output_dir   = self.set_output_dir(v)
    self.full_do      = self.set_full_do(v)

def generate_command(v={}):
  obj = CoverCheck()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)


