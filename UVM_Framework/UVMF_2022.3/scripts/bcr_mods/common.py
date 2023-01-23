__all__ = ['version','parent_parser','resolve_path','ordered_load']

import sys
import os
import re
import argparse
import logging

try:
  import yaml
  from collections import OrderedDict
except ImportError as ie:
  print("ERROR:Missing library: %s" % str(ie))
  sys.exit(1)

from uvmf_version import version
__version__ = version

class MyFormatter(logging.Formatter):
  wrn_fmt = "WARNING: %(msg)s"
  err_fmt = "ERROR: %(msg)s"
  dbg_fmt = "DEBUG: %(module)s: %(lineno)d: %(msg)s"
  inf_fmt = "%(msg)s"

  def __init__(self,fmt="%(levelno)s: %(msg)s"):
    logging.Formatter.__init__(self,fmt)

  def format(self,record):
    if sys.version_info[0] > 2:
      format_orig = self._style._fmt
      if record.levelno == logging.DEBUG:
        self._style._fmt = MyFormatter.dbg_fmt
      elif record.levelno == logging.INFO:
        self._style._fmt = MyFormatter.inf_fmt
      elif record.levelno == logging.ERROR:
        self._style._fmt = MyFormatter.err_fmt
      elif record.levelno == logging.WARNING:
        self._style._fmt = MyFormatter.wrn_fmt
      result = logging.Formatter.format(self,record)
      self._style._fmt = format_orig
    else:
      format_orig = self._fmt
      if record.levelno == logging.DEBUG:
        self._fmt = MyFormatter.dbg_fmt
      elif record.levelno == logging.INFO:
        self._fmt = MyFormatter.inf_fmt
      elif record.levelno == logging.ERROR:
        self._fmt = MyFormatter.err_fmt
      elif record.levelno == logging.WARNING:
        self._fmt = MyFormatter.wrn_fmt
      result = logging.Formatter.format(self,record)
      self._fmt = format_orig
    return result

# Direct all logger output to STDOUT (default is STDERR)
fmt = MyFormatter()
hdlr = logging.StreamHandler(sys.stdout)
hdlr.setFormatter(fmt)
if sys.version_info[0] > 2:
  if not logging.root.hasHandlers():
    logging.root.addHandler(hdlr)
else:
  logging.root.addHandler(hdlr)
# Default verbosity level is INFO
logging.root.setLevel(logging.INFO)

class VerbosityAction(argparse.Action):
  def __init__(self,nargs=0,**kwargs):
    if nargs != 0:
      raise ValueError("nargs must be 0 for this action")
    super(VerbosityAction,self).__init__(nargs=nargs,**kwargs)

  def __call__(self,parser_obj,namespace,values,option_string=None):
    log = logging.getLogger("logger")
    if option_string == "--quiet" or option_string == "-q":
      level = logging.WARNING
    elif option_string == "--debug":
      level = logging.DEBUG
    else:
      import traceback
      log.critical("Unknown switch \"%s\" passed to VerbosityAction" % option_string)
      traceback.print_stack()
      sys.exit(1)
    log.setLevel(level)

parent_parser = argparse.ArgumentParser(add_help=False)
parent_parser.add_argument("--version",action='version',version='%(prog)s version '+__version__)
parent_parser.add_argument("--debug",action=VerbosityAction,nargs=0,help=argparse.SUPPRESS)
parent_parser.add_argument("--quiet","-q",action=VerbosityAction,nargs=0,help="Force quiet operation, only produce warning & error messages")
parent_parser.add_argument("--pdb",action='store_true',help=argparse.SUPPRESS)

def resolve_path(input_path,root,input_file=None,vars=None):
  """ Take input string and treat as a directory or file path. Goal is to return an absolute path.
  Do this by resolving references to $HOME (~) and any other environment variables, then attempting
  to normalize the path if needed (if it is still a relative path, it is relative to the 'root' input)
  """
  if vars:
    # Variables dict passed in, try to resolve any embedded variables first, then
    # resort to environment variables
    matched = False
    while True:
      m = re.match(r'\$\{(?P<var_name>\w+)\}',input_path)
      if m:
        var_name = m.group('var_name')
        if var_name in vars:
          matched = True
          input_path = re.sub(r'\$\{'+var_name+r'\}',vars[var_name],input_path)
      if not matched:
        break
      matched = False    
  p = os.path.expanduser(input_path)
  p = os.path.expandvars(p)
  r = os.path.expanduser(root)
  r = os.path.expandvars(r)
  if re.match(r'\$',p):
    logging.error("Unresolved variables in provided path: {}".format(p))
    if input_file:
      logging.error("Reference seen in \"{}\"".format(input_file))
    sys.exit(1)
  if not os.path.isabs(p):
    p = os.path.abspath(os.path.normpath(r+os.path.sep+p))
  return p

def ordered_load(self, stream, Loader=yaml.SafeLoader, object_pairs_hook=OrderedDict):
  class OrderedLoader(Loader):
    pass
  def construct_mapping(loader, node):
    loader.flatten_mapping(node)
    return object_pairs_hook(loader.construct_pairs(node))
  OrderedLoader.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
    construct_mapping)
  return yaml.load(stream, OrderedLoader)

  