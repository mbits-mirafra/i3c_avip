import sys
import os
import time
import re
from uvmf_gen import UserError
from shutil import copytree

def backup(source):
  count = 0
  # Check that source location exists
  if (not os.path.exists(source)):
    raise UserError("Backup: Source directory {0} does not exist".format(source))
  # Create name of destination. Should be "source_bak_<number>"
  # First check to see if any backups already exist by doing a listing
  while True:
    destination = source+'_bak_'+str(count)
    if (os.path.exists(destination)):
      count = count + 1
    else:
      break
  # Copy source to destination
  copytree(source,destination)
  return destination
