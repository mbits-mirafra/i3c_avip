#! /usr/bin/env python

##############################################################################
## Copyright 2020 Mentor A Siemens Company
## All Rights Reserved Worldwide
##
##   Licensed under the Apache License, Version 2.0 (the "License"); you may
##   not use this file except in compliance with the License.  You may obtain
##   a copy of the License at
##
##    http://www.apache.org/license/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in
##   writing, software distributed under the License is
##   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##   CONDITIONS OF ANY KIND, either express or implied.  See
##   the License for the specific language governing
##   permissions and limitations under the License.
##
##############################################################################
##
##   Mentor Graphics A Siemens Company
##
##############################################################################
##
##   Created by :    Jon Craft 
##   Creation date : May 2020
##
##############################################################################
##
##   This script parses a UVM simulation log file to help trace the source
##   of any UVM phasing objections and isolate the reason for any objection-
##   based simulation hang conditions.
##
##   The simulation should be executed with the +UVM_OBJECTION_TRACE plusarg
##   in order to produce the necessary messages.
##
##   Run uvm_objection_trace.py --help for more information
##
##########################################################################

import sys
import os
import re
try:
  import argparse
  import logging
except ImportError as ie:
  print("ERROR: Missing library: %s" % str(ie))
  sys.exit(1)

version = '1.0'
__version__ = version

logger = logging.getLogger("logger")
logging.basicConfig(format='%(levelname)s:%(message)s',level=logging.INFO)

class VerbosityAction(argparse.Action):
  def __init__(self,nargs=0,**kwargs):
    if nargs != 0:
      raise ValueError("nargs must be 0 for this action")
    super(VerbosityAction,self).__init__(nargs=nargs,**kwargs)

  def __call__(self,parser_obj,namespace,values,option_string=None):
    log = logging.getLogger("logger")
    if option_string == "--quiet":
      level = logging.ERROR
    elif option_string == "--debug":
      level = logging.DEBUG
    else:
      log.critical("Unknown switch \"%s\" passed to VerbosityAction" % option_string)
      traceback.print_stack()
      sys.exit(1)
    log.setLevel(level)

def record_trace(line,time,phase,obj,action,num,mess,count,total):
  if obj not in data:
    data[obj] = {}
  if phase not in data[obj]:
    data[obj][phase] = {'activity': [], 'outstanding':0}
  data[obj][phase]['activity'].append({'line': line, 'time': time, 'count': num, 'mess': mess, 'action': action})
  if action == 'raised':
    inc = int(num)
  else:
    inc = -int(num)
  data[obj][phase]['outstanding'] = data[obj][phase]['outstanding'] + inc

def report():
  for o_name,o_value in data.items():
    for p_name,p_value in o_value.items():
      if p_value['outstanding'] != 0:
        logger.info("Object %s has non-zero objections (%d) remaining in phase %s:" % (o_name,p_value['outstanding'],p_name))
        logger.info("  Phase objection history:")
        for action in p_value['activity']:
          logger.info("    - %s %s objections at %s: %s" % (action['action'], action['count'], action['time'], action['mess']))


if __name__ == '__main__':
  parser = argparse.ArgumentParser(epilog="Version "+version,description="Debug UVM objection raises & drops")
  parser.add_argument("logfile",help="Specify the simulation log file to parse")
  parser.add_argument("--version",action='version',version='%(prog)s version '+__version__)
  parser.add_argument("--debug",action=VerbosityAction,nargs=0,help=argparse.SUPPRESS)
  parser.add_argument("--quiet","-q",action=VerbosityAction,nargs=0,help="Force quiet operation")
  args = parser.parse_args()
  lc = 1
  data = {}
  logger.info("uvm_objection_trace.py version %s" % version)
  objection_re = re.compile(r"UVM_INFO @ (?P<time>[^:]+): (?P<phase>\w+) \[OBJTN_TRC\] Object (?P<obj>\S+) (?P<action>raised|dropped) (?P<num>\d+) objection\(s\) \((?P<mess>.*)\):\s+count=(?P<count>\d+)\s+total=(?P<total>\d+)")
  with open(args.logfile,'r') as logfile:
    for line in logfile:
      result = re.search(objection_re,line)
      if result:
        args = (lc,)+result.groups()
        logger.debug("Saw objection trace message on line %d: time=%s, phase=%s, object=%s, action=%s, num=%s, mess=%s" % args[:-2])
        record_trace(line=lc,**result.groupdict())
      lc = lc + 1
  report()

