import logging
import pprint
import re
import os
import sys

__all__ = ['logger','generate_command','vars_string','clean_whitespace','filelists','library_mappings','merge_dict','Generator','v_val']

logger = logging.getLogger("logger")
pprinter = pprint.PrettyPrinter(indent=2)

## Base command generator class. All generators should extend from this in order to maximize
## reuse
class Generator(object):
  
  ## An inheriting class should always initialize the 'keys' array to reflect the self.<keys> entries
  ## to build up to produce the desired command.
  def __init__(self):
    self.keys = []
  
  ## repr(obj) will return multi-line string outlining the value associated with the name and value of 
  ##all keys that could contribute to a given object's command-line
  def __repr__(self):
    fmt = " {:>26}: {}"
    lines = [ "{}(".format(type(self).__name__) ]
    for k in self.keys:
      lines.append(fmt.format(k,getattr(self,k,'unknown')))
    return '\n'.join(lines) + '\n)\n'
  
  ## Return a full command string. By default, this will iterate through all of the items in the
  ## "keys" array, resolve each one's value (i.e. self.<key>) and concatenate these in order
  ## to produce the final returned result.
  def command(self,v):
    try:
      args = [ getattr(self,k) for k in self.keys ]
    except AttributeError as error:
      logger.error("Unable to find command attribute \"{}\" in command class".format(k))
      sys.exit(1)
    return [clean_whitespace(' '.join(args+[self.process_compile_file_options(self.set_cmd(v),v)]))]

  def set_arch(self,v={}):
    if 'use_64_bit' in v and v['use_64_bit']:
      return '-64'
    else:
      return '-32'

  def set_multiuser(self,v={}):
    if 'multiuser' in v and v['multiuser']:
      return '-covermultiuserenv'
    else:
      return ''

  def set_vrm_in_use(self,v={}):
    if v_val(v,'vrm_in_use'):
      return '+vrm_in_use'
    return ''

  def set_mvc_switch(self,v={}):
    if 'using_qvip' in v and v['using_qvip']:
      if 'QUESTA_MVC_HOME' not in os.environ:
        logger.error("using_qvip set True but $$QUESTA_MVC_HOME not set")
        sys.exit(1)
      return '-mvchome '+os.environ['QUESTA_MVC_HOME']
    else:
      return ''

  def set_timescale(self,v={}):
    if 'timescale' in v and v['timescale']:
      return '-timescale '+v['timescale']
    elif 'using_qvip' in v and v['using_qvip']:
      return '-timescale 1ps/1ps'
    else:
      return ''

  def set_time_resolution(self,v={}):
    if 'time_resolution' in v and v['time_resolution']:
      return "-t "+v['time_resolution']
    elif 'using_qvip' in v and v['using_qvip']:
      return '-t 1ps'
    else:
      return ''

  def set_msglimit(self,v={}):
    if 'error_limit' in v and v['error_limit'] > 0:
      return '-msglimit error -msglimitcount '+str(v['error_limit'])
    else:
      return ''

  def set_coverage_run(self,v={}):
    if 'code_cov_enable' in v and v['code_cov_enable']:
      if ('build_only' in v and v['build_only']) or ('compile_only' in v and v['compile_only']):
        return ''
      else:
        return '-coverage'
    else:
      return ''

  def set_coverage_build(self,v={}):
    if ('compile_only' in v and v['compile_only']) or ('sim_only' in v and v['sim_only']):
      return ''
    if 'code_cov_enable' in v and v['code_cov_enable']:
      try:
        coverage_build_str = '+cover='+v['code_cov_types']+'+'+v['code_cov_target']
      except KeyError:
        logger.error("Unable to enable code coverage, types and/or target are undefined")
        sys.exit(1)
      return coverage_build_str
    else:
      return ''

  def set_verbosity(self,v={}):
    if 'verbosity' in v and v['verbosity'] != '':
      return '+UVM_VERBOSITY='+v['verbosity']
    else:
      return ''

  def set_access(self,v={}):
    access_str = ''
    if ('compile_only' in v and v['compile_only']) or ('sim_only' in v and v['sim_only']):
      return ''
    if 'access' in v and v['access']:
      return v['access']

  def set_lib(self,v={}):
    lib_str = ''
    if 'lib' in v and v['lib']:
      for l in v['lib'].split():
        lib_str = lib_str+' -L '+l
      return lib_str
    else:
      return ''

  def set_work(self,v={}):
    if 'work' in v and v['work']:
      return '-work '+v['work']
    else:
      return ''

  def set_visibility(self,v={}):
    if ('compile_only' in v and v['compile_only']) or ('sim_only' in v and v['sim_only']):
      return ''
    if ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
      vis_str = ''
      if 'live' in v and v['live']:
        vis_str = vis_str + " -debug,livesim"
      else:
        vis_str = vis_str + " -debug"
      if v_val(v,'access'):
        vis_str = vis_str + ' ' + v['access']
      return vis_str
    else:
      if 'acc' in v and v['acc']:
        return v['acc']
      else:
        if 'live' in v and v['live']:
          return "+acc"
        else:
          return ''

  def set_mode_run_debug(self,v={}):
    if ('compile_only' in v and v['compile_only']) or ('build_only' in v and v['build_only']):
      return ('','','')
    if 'live' in v and v['live']:
      run_cmd = 'run 0'
      debug_str = '-onfinish stop -classdebug'
      if ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
        mode_str = '-gui -visualizer'
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
      if v_val(v,'use_vis') or v_val(v,'use_vis_uvm'):
        mode_str = mode_str + ' -visualizer'
      run_cmd = 'run -all'
      if ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
        debug_str = ' -debug'
      else:
        debug_str = ''
    return (mode_str, run_cmd, debug_str)

  def set_vis_designfile(self,v={}):
    if (v_val(v,'use_vis') or v_val(v,'use_vis_uvm')) and v_val(v,'vis_design_filename'):
      return '-designfile '+v['vis_design_filename']
    return ''

  def set_vis_wave(self,v={}):
    if ('no_vis_wave' in v and v['no_vis_wave']):
      return ''
    if ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
      if 'vis_wave' in v and v['vis_wave']:
        vis_wave_str = '-qwavedb='+v['vis_wave']
      elif 'use_vis_uvm' in v and v['use_vis_uvm']:
        if 'vis_wave_tb' not in v or not v['vis_wave_tb']:
          logger.error("No vis_wave_tb specified in variables dict")
          sys.exit(1)
        vis_wave_str = '-qwavedb='+v['vis_wave_tb']
      else:
        if 'vis_wave_rtl' not in v or not v['vis_wave_rtl']:
          logger.error("No vis_wave_rtl specified in variables dict")
          sys.exit(1)
        vis_wave_str = '-qwavedb='+v['vis_wave_rtl']
      if 'enable_trlog' in v and v['enable_trlog']:
        vis_wave_str = vis_wave_str+"+transaction"
      if 'vis_wave_filename' in v and v['vis_wave_filename']:
        vis_wave_str = vis_wave_str+"+wavefile="+v['vis_wave_filename']
    else:
      vis_wave_str = ''
    return vis_wave_str

  def set_trlog(self,v={}):
    if 'enable_trlog' in v and v['enable_trlog']:
      return '+uvm_set_config_int=*,enable_transaction_viewing,1'
    else:
      return ''

  def set_tops(self,v={}):
    if 'tops' in v and v['tops']:
      return v['tops']
    return ''

  def set_run_quit(self,v={}):
    if 'run_command' in v and v['run_command']:
      run_command = v['run_command']
    else:
      if 'live' in v and v['live']:
        run_command = 'run 0'
        if 'wave_file' in v and v['wave_file']:
          run_command = run_command+"; do "+v['wave_file']
        elif ('use_vis' in v and v['use_vis']) or ('use_vis_uvm' in v and v['use_vis_uvm']):
          if (not 'no_vis_wave' in v) or (not v['no_vis_wave']):
            run_command = run_command+"; do "+v['sim_dir']+"/viswave.do"
        else:
          run_command = run_command+"; do "+v['sim_dir']+"/wave.do"
        quit_command = ''
      else:
        run_command = "run -all"
        if 'quit_command' in v and v['quit_command']:
          quit_command = v['quit_command']
        else:
          quit_command = "quit"
    return (run_command,quit_command)

  def set_do(self,v={}):
    run_command,quit_command = self.set_run_quit(v)
    do_cmds = []
    if 'extra_pre_do' in v and v['extra_pre_do']:
      do_cmds.append(v['extra_pre_do'])
    if 'pre_do' in v and v['pre_do']:
      do_cmds.append(v['pre_do'])
    if 'extra_do' in v and v['extra_do']:
      do_cmds.append(v['extra_do'])
    if run_command:
      do_cmds.append(run_command)
    if 'post_do' in v and v['post_do']:
      do_cmds.append(v['post_do'])
    if quit_command:
      do_cmds.append(quit_command)
    return ';'.join(do_cmds)

  def set_permit_unmatched_virt_intf(self,v={}):
    if ('permit_unmatched_virt_intf' in v and v['permit_unmatched_virt_intf']):
      return "-permit_unmatched_virtual_intf"
    else:
      return ''

  def set_full_do(self,v={}):
    if ('build_only' in v and v['build_only']) or ('compile_only' in v and v['compile_only']):
      return ''
    if 'do_override' in v and v['do_override'] != False:
      return v['do_override']
    do_str = self.set_do(v)
    if do_str:
      return '-do \"'+do_str+'\"'
    else:
      return ''

  def set_suppress(self,v={}):
    if 'suppress' in v and v['suppress']:
      return "-suppress "+v['suppress']
    else:
      return ''

  def set_modelsimini(self,v={}):
    if 'modelsimini' in v and v['modelsimini']:
      return '-modelsimini '+v['modelsimini']
    else:
      return ''

  # Set up vmap commands based on the content of the 'mappings' and 'modelsimini' variables.
  # If 'mappings' is present then this will produce 'vmap' commands for each entry
  # Furthermore, if 'modelsimini' variable is present this will also be incorporated on
  # all vmap command lines.
  def set_vmap_commands(self,v={}):
    cmds = []
    if 'mappings' in v and v['mappings']:
      if 'modelsimini' in v and v['modelsimini']:
        modelsimini_str = '-modelsimini '+v['modelsimini']
      else:
        modelsimini_str = ''
      for m in library_mappings(v['mappings']):
        cmds.append(clean_whitespace('vmap {} {} {}'.format(m[0],m[1],modelsimini_str)))
    return cmds

  def set_seed(self,v={}):
    if 'seed' in v:
      return '-sv_seed {}'.format(v['seed'])
    else:
      return ''

  def set_logfile(self,v={}):
    if 'log_filename' in v:
      return '-l '+v['log_filename']
    else:
      return ''

  def set_extra(self,v={}):
    if 'extra' in v:
      return v['extra']
    else:
      return ''

  def set_test(self,v={}):
    if 'test' in v:
      return '+UVM_TESTNAME='+v['test']
    else:
      return ''

  def process_compile_file_options(self,name,v):
    ret = ''
    if 'compile_file_options' in v:
      cfo = v['compile_file_options']
      if '__all__' in cfo:
        ret = ret + ' '+cfo['__all__']
      if name in cfo:
        ret = ret + ' ' + cfo[name]
    return ret

# Convenience function, returns true if a variable exists and is non-empty, True, etc
def v_val(v,var):
  if var in v and v[var]:
    return True
  return False

def generate_command(vars=None):
  logger.error("generate_command was left undefined")
  sys.exit(1)

def vars_string(vars=None):
  ret = ""
  for name,value in vars.items():
    ret = ret + "\n  {}:{}".format(name,value)
  return ret

def clean_whitespace(val):
  return re.sub(r"\s+"," ",val).strip()

def filelists(val,assoc=None,patt=None):
  ret = {}
  if patt:
    r = re.compile(patt)
  else:
    r = None
  if isinstance(val,list):
    # File list input is a simple list. Means that no library associations are present
    d = {'__default__':val}
  elif isinstance(val,dict):
    # File list input is a dictionary. Means library associations are present. Will return a dictionary of strings
    # keyed off each library association instead of a simple string
    d = val
  else:
    self.logger.error("filelists input must be list or dict")
    sys.exit(1)
  for n,v in d.items():
    s = ''
    for e in v:
      # Check for a syntax association (vlog,vhdl,etc) and only include in output if 
      # no association was requested or the association matches the first entry in the tuple
      if not assoc or e[0]==assoc:
        # Second entry of the tuple is expected to be a string containing a space separated list of file paths
        # Split those into an actual list and iterate across each one
        for f in e[1].split(' '):
          # If a regex pattern wasn't provided or if there's a match, the entry can go into the output
          if not r or r.match(f):
            s = s + ' -f '+f
    ret[n] = s
  # Return type is based on input type.  If input was a simple list, return the one string that was placed in '_default_'
  # Otherwise, return a full dict of strings (one for each libassoc plus the default)
  if isinstance(val,list):
    return ret['__default__']
  else:
    return ret

# Union of two dictionaries (supporting Python 2.x)
# result will be a union all inputs. If there is overlap,
# the last value seen wins
def merge_dict(*args):
  r = {}
  for d in args:
    r.update(d)
  return r

def library_mappings(self,val):
  mapping_re = re.compile(r'(?P<logical>\S+):(?P<physical>\S+)')
  map_list = val.split(' ')
  map_tuples = []
  for m in map_list:
    s = mapping_re.search(m)
    if not s:
      self.logger.error("Invalid format for library mapping, \"{}\" must be in '<logical>:<physical>' format".format(m))
      sys.exit(1)
    map_tuples.append((s.group('logical'),s.group('physical')))
  return map_tuples


