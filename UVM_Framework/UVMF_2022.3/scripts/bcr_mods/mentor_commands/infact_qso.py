from command_helper import *
import os
import sys

# Invoke qso
def generate_command(v=None):
  cmds = []
  created = {}
  if 'bfms' not in v:
    logger.error("No \"bfms\" structure found in variables input to qso::generate_command() function")
    sys.exit(1)
  arch_str = ''
  if 'use_64_bit' in v and v['use_64_bit']:
    arch_str = '-64'
  for bfm in v['bfms']:
    if 'name' not in bfm:
      logger.error("One of the entries im v['bfms'] is missing a 'name' entry")
      sys.exit(1)
    for var in ('class','extra','cov_strategy','output'):
      if var not in bfm:
        logger.error("Variable \"{}\" is missing from the \"{}\" v['bfms'] entry".format(var,bfm['name']))
        sys.exit(1)
    work_str = ''
    if 'work' in v:
      work_str = "-work "+v['work']
    outdir = os.path.dirname(bfm['output'])
    if not os.path.exists(outdir) and outdir not in created:
      cmds.append("mkdir -p {}".format(outdir))
      created[outdir] = True
    cmds.append(clean_whitespace("infactcx {} synth {} {} {} -coverage_strategy {} -o {}".format(arch_str,bfm['class'],work_str,bfm['extra'],bfm['cov_strategy'],bfm['output'])))
  return cmds



