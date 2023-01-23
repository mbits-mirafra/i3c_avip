from command_helper import *
import os
import sys
import shutil
import glob

class Clean(Generator):

  def __init__(self,v=None):
    super(Clean,self).__init__
    self.keys = '''
                  rmfiles_str
                  extra_rmfiles_str
                '''.split()

  def rmfiles(self,v):
    glob_str = '''
                *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml
                 *.wlf transcript covhtmlreport VRMDATA design.bin *.so *.dll qwave.db *.dbg dpiheader.h visualizer*.ses
                 vrmhtmlreport veloce.med veloce.wave tbxbindings.h edsenv sv_connect.*
                 *.o *.so covercheck_results qrun.out *.qf *.vf infact_genfiles
               '''
    if 'realclean' in v and v['realclean']:
      glob_str = glob_str + ' modelsim.ini'
    return glob_str

  def extra_rmfiles(self,v):
    if 'extra_clean' in v and v['extra_clean']:
      return v['extra_clean']
    else:
      return ''

  def elaborate(self,v):
    self.rmfiles_str = self.rmfiles(v)
    self.extra_rmfiles_str = self.extra_rmfiles(v)

  def command(self,v):
    try:
      globs = clean_whitespace(' '.join([ getattr(self,k) for k in self.keys ]))
    except AttributeError:
      logger.error("clean command looking for variable \"{}\"".format(k))
      sys.exit(1)
    logger.info("Cleaning up directory...")
    try:
      for gl in globs.split():
        for fp in glob.glob(gl):
          if 'verbose' in v and v['verbose']:
            logger.info("  rm {}".format(fp))
          if os.path.isfile(fp):
            os.remove(fp)
          else:
            shutil.rmtree(fp)
    except OSError as error:
      logger.error("Error detected during cleanup: {}".format(error))
      sys.exit(1)
    return []

def generate_command(v=None):
  obj = Clean()
  obj.elaborate(v)
  return obj.command(v)

