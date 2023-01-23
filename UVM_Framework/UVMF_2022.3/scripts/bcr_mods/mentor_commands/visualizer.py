from command_helper import *
import os

# Invoke visualizer
def generate_command(v=None):
  if 'wavefile' in v and v['wavefile'] != 'None':
    wavefile_str = "-wavefile "+v['wavefile']
  else:
    wavefile_str = ""
  if 'formatfile' in v and v['formatfile'] != 'None':
    dofile_str = "-do "+v['formatfile']
  else:
    dofile_str = ""
  if 'designfile' not in v or v['designfile'] == 'None':
    return [ clean_whitespace('viswave {} {} {}'.format(
      wavefile_str,
      dofile_str,
      v['extra']))]
  return [ clean_whitespace('vis -designfile {} {} {} {}'.format(
    v['designfile'],
    wavefile_str,
    dofile_str,
    v['extra'],
  )) ]
