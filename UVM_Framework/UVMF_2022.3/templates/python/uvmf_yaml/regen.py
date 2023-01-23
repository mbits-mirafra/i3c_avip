import sys
import os
import time
import re
from uvmf_gen import UserError
import yaml
import pprint
from uvmf_yaml import dumper, RegenValidator

from voluptuous import Invalid,MultipleInvalid
from voluptuous.humanize import humanize_error

from shutil import copyfile

class Base:
  
  # Replace the base directory structure with something new, maintaining the top-most path
  def replace_basedir(self, p, old_basedir, new_basedir):
    # Unfortunately we can't use a nice simple regex here safely due to OS differences (windows os.sep backslashes cause problems)
    # r = re.sub(r"^"+old_basedir+os.sep+r"(.*)",r"{0}{1}\1".format(new_basedir,os.sep),p)
    # Instead, we iteratively pull stuff off the end of the full path variable 'p' until we reveal
    # the 'old_basedir'.  Then prepend 'new_basedir' in its place
    p_begin = p
    p_end = ''
    while True:
      # Jump out once we've extracted all of the special stuff at the end of path 'p'
      if p_begin == old_basedir:
        break
      # Break out last item on p_begin
      p_split = os.path.split(p_begin)
      # And move it over to p_end
      p_end = os.path.join(p_split[1],p_end)
      # And save what is left as p_begin
      p_begin = p_split[0]
     # At this point we can concatenate new_basedir and p_end to produce the new full path
    return os.path.normpath(os.path.join(new_basedir,p_end))

class Merge(Base):

  def __init__(self,outdir,skip_missing_blocks,new_root,old_root,quiet=False):
    self.regen = Regen()
    self.copied_files = []
    self.new_root = new_root
    self.old_root = old_root
    self.copied_old_files = []
    self.found_blocks = {}
    self.new_blocks = {}
    self.outdir = os.path.abspath(os.path.normpath(outdir))
    self.missing_blocks = {}
    self.skip_missing_blocks = skip_missing_blocks
    self.quiet = quiet
    self.new_directories = []
    self.yaml_imported = False

  def load_yaml(self,fname):
    self.yaml_imported = True
    try:
      fs = open(fname)
    except IOError:
      raise UserError("Unable to open config file {0}".format(fname))
    d = yaml.safe_load(fs)
    fs.close()
    try:
      self.load_data(d['uvmf']['regen_data'])
    except:
      raise UserError("Contents of {0} does not contain valid UVMF regeneration information".format(fname))

  def load_data(self,data):
    try:
      RegenValidator().schema(data)
    except MultipleInvalid as e:
      resp = humanize_error(rd,e).split('\n')
      raise UserError("Validation of regeneration YAML failed:\n{0}".format(pprint.pformat(resp,indent=2)))
    self.rd = {}
    for f in data:
      abs_f = os.path.abspath(os.path.normpath(f))
      self.rd[abs_f] = data[f]

  def file_begin(self,fname,ignore_unmatched=False):
    ## For clarity, use variable "new_fname" to differentiate it from old_fname
    new_fname = fname
    ## Figure out path of this new file in the 'old' directory structure (may not exist in 'old')
    self.old_fname = self.replace_basedir(new_fname,self.new_root,self.old_root)
    ## Check if old file doesn't exist in the new. If it doesn't, we need to copy from new to old
    if not os.path.exists(self.old_fname):
      if not os.path.exists(os.path.dirname(self.old_fname)):
        ## Path to this file doesn't exist, need to create it
        try:
          os.makedirs(os.path.dirname(self.old_fname))
        except:
          raise UserError("Unable to create new path {0} during merge. Permissions issue?".format(os.path.dirname(self.old_fname)))
      try:
        copyfile(new_fname,self.old_fname)
      except:
        raise UserError("Unable to copy {0} over to {1} during merge. Permissions issue?".format(new_fname,self.old_fname))
      ## Make note of this file we copied over for later reporting
      self.copied_files.append(self.old_fname)
      ## Function returns False if we do not need to process this file any further
      return False
    elif not (self.old_fname in self.rd):
      ## File was found to exist in original source but was not parsed. This is a fatal error (shouldn't happen) unless we're doing a YAML import in which case we can ignore.
      if not self.yaml_imported:
        raise UserError("Internal error - Source file {0} was not properly parsed for named blocks".format(self.old_fname))
      return False
    else:
      ## Matched old_fname up with something in the data structure, which means we have a match between old and new.
      ## In this case we will be overwriting this file with a newly merged version
      ## First step is to delete the old file
      try:
        os.remove(self.old_fname)
      except:
        raise UserError("Unable to overwrite source file {0} with merged data. Permissions issue?".format(self.old_fname))
      # Now re-open the same file for recreation
      try:
        self.ofs = open(self.old_fname, 'w')
      except IOError:
        raise UserError("Unable to create output file {0}".format(outfile))
      ## Function returns true if we are now processing the file contents
      return True

  def block_begin(self,fname,line,label_name,begin_line):
    ## For clarity, use "new_fname" instead of fname
    new_fname = fname
    ## Write the incoming line regardless of next steps
    self.ofs.write(line)
    if not label_name in self.rd[self.old_fname]:
      # This labeled block was not in the data structure. Note this and move on (it's ok, it just means the label is new)
      if (self.old_fname not in self.new_blocks):
        self.new_blocks[self.old_fname] = []
      self.new_blocks[self.old_fname].append(label_name)
    else:
      # This labeled block was found in the data structure, write the block contents out and make note of the
      # activity
      if (self.old_fname not in self.found_blocks):
        self.found_blocks[self.old_fname] = []
      self.found_blocks[self.old_fname].append({'name':label_name})
      try:
        self.found_blocks[self.old_fname][-1]['begin'] = self.rd[self.old_fname][label_name]['begin_line']
        self.found_blocks[self.old_fname][-1]['end'] = self.rd[self.old_fname][label_name]['end_line']
      except KeyError:
        self.found_blocks[self.old_fname][-1]['begin'] = 0
        self.found_blocks[self.old_fname][-1]['end'] = 0
        pass
      self.ofs.write(self.rd[self.old_fname][label_name]['content'])
      self.block_copied = True
      # Also update the data structure to note that the label was used (we track this later on)
      self.rd[self.old_fname][label_name]['block_used'] = True

  def block_end(self,fname,line,label_name,end_line):
    # At the end of each block, clear the block_copied flag and write the line out
    self.block_copied = False
    self.ofs.write(line)

  def block_inside(self,fname,label_name,content,lnum):
    # Only write out the contents of the block if we didn't copy it from the data structure earlier.
    # This happens only if the block is new and we didn't find it in the old source
    if self.block_copied == False:
      self.ofs.write(content)

  def block_outside(self,fname,line,lnum):
    # Outside of any block, just copy the line over
    self.ofs.write(line)

  def file_end(self,fname):
    self.ofs.close()
    # At the end of each file, check to see if any blocks from the data structure went unused.
    # Error if option skip_missing_blocks is FALSE, otherwise produce a warning and move on.
    # Do this by looping through all of the labels in the data structue for the given file
    # and look for the 'block_used' entry.  If that is there, all is good. Otherwise, problem.
    for l in self.rd[self.old_fname]:
      try:
        used = self.rd[self.old_fname][l]['block_used']
      except KeyError:
        if self.skip_missing_blocks == True:
          if self.old_fname not in self.missing_blocks:
            self.missing_blocks[self.old_fname] = [ l ]
          else:
            self.missing_blocks[self.old_fname].append(l)
        else:
          raise UserError('Potential loss of hand edits:\n  File: {0}\n  Label: "{1}"\nUse --merge_skip_missing_blocks to proceed and produce list of labels at end'.format(self.old_fname,l))

  def parse_file(self,fname):
    self.regen.parse_file(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside,block_outside_fn=self.block_outside,post_open_fn=self.file_end)

  def traverse_dir(self,fname):
    self.regen.traverse_dir(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside,block_outside_fn=self.block_outside,post_open_fn=self.file_end)

class Parse(Base):

  def __init__(self,root,quiet=False,cleanup=False):
    self.data = {}
    self.root = root
    self.block_count = 0
    self.quiet = quiet
    self.regen = Regen()
    self.cleanup = cleanup
    self.new_dirs = []
    self.old_dirs = []

  def str_presenter(self, dumper, data):
    if len(data.splitlines()) > 1:
      return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)

  def dump(self,fname):
    # Clean up data so it'll represent in YAML properly. Remove whitespace at end of lines
    # and all but the final newline. Only do this if we're dumping YAML (cleanup==True)
    for f,labels in self.data.items():
      for label,ldata in labels.items():
        c = ldata['content']
        if (self.cleanup):
          c = re.sub(r"\s+$", "", c)
          c = re.sub(r"\s+\n", "\n", c)
          c = re.sub(r"\n$","", c)
        self.data[f][label]['content'] = c
    d = {'uvmf': {'regen_data': self.data}}
    yaml.add_representer(str, self.str_presenter)
    dumper.YAMLGenerator(d, fname)

  def parse_file(self,fname):
    self.regen.parse_file(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside)

  def traverse_dir(self,dname):
    self.regen.traverse_dir(dname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside,filter_dirs=self.old_dirs)

  def file_begin(self,fname):
    self.data[fname] = {}

  def block_begin(self,fname,line,label_name,begin_line):
    self.data[fname][label_name] = {'content':'', 'begin_line':begin_line}
    self.block_count += 1

  def block_end(self,fname,line,label_name,end_line):
    self.data[fname][label_name]['end_line'] = end_line

  def block_inside(self,fname,label_name,content,lnum):
    self.data[fname][label_name]['content'] += content

  def collect_directories(self,new_root_dir,old_root_dir):
    nrd = os.path.abspath(os.path.normpath(new_root_dir))
    ord = os.path.abspath(os.path.normpath(old_root_dir))
    for root,dirs,files in os.walk(nrd):
      for dir in dirs:
        self.new_dirs.append(root+os.sep+dir)
        self.old_dirs.append(self.replace_basedir(p=root+os.sep+dir,old_basedir=nrd,new_basedir=ord))
    pass

class Regen:

  # This class is designed to traverse a given starting directory and walk through all underlying hierarchy, parsing
  # each file along the way. For each file that is parsed there are hooks defined at different points:
  # - Just prior to opening a given file
  # - When a new label in the file has been found
  # - When the end of a labeled block has been found
  # - For each line of the file whle inside of a labeled block
  # - For each line of the file while outside of a labeled block
  # - When finished parsing the given file

  def traverse_dir(self,dname,pre_open_fn=None,block_begin_fn=None,block_end_fn=None,block_inside_fn=None,post_open_fn=None,block_outside_fn=None,filter_dirs=None):
    dname = os.path.normpath(dname)
    if not os.path.exists(dname):
      raise UserError("Input directory {0} does not exist".format(dname))
    for root,dirs,files in os.walk(dname):
      for file in files:
        if (not filter_dirs) or (os.path.abspath(root) in filter_dirs):
          self.parse_file(os.path.abspath(root+os.sep+file),pre_open_fn,block_begin_fn,block_end_fn,block_inside_fn,block_outside_fn,post_open_fn)

  def parse_file(self,fname,pre_open_fn=None,block_begin_fn=None,block_end_fn=None,block_inside_fn=None,block_outside_fn=None,post_open_fn=None):
    fname = os.path.normpath(fname)
    in_block = False
    label_name = ""
    if (pre_open_fn != None):
      if pre_open_fn(fname)==False:
        return
    try:
      with open(fname,'r') as fs:
        for lnum,line in enumerate(fs):
          match = re.search(r"^\s*(\/{2}|#+) pragma uvmf custom (\w+) (begin|end)",line)
          if match:
            # Found a pragma
            label_type = match.group(3)
            # Determine if label type + current state is valid or not
            if (label_type == 'begin') & (in_block == True):
              raise UserError("Detected beginning of nested custom block:\n  File: {0}\n  Line number: {1}\n  Previous label: {2}\n  New label: {3}".format(fname,lnum+1,label_name,match.group(2)))
            elif (label_type == 'end') & (in_block == False):
              raise UserError("Detected end of custom block with no begin:\n  File: {0}\n  Line number: {1}\n  Label: {2}".format(fname,lnum+1,match.group(2)))
            elif label_type == 'begin':
              # Beginning of new label. Log it and move on to next line
              label_name = match.group(2)
              in_block = True
              begin_line = lnum+1
              # Call function for beginning of label
              if (block_begin_fn != None):
                block_begin_fn(fname,line,label_name,begin_line)
            else:
              # End of label
              in_block = False
              # Check that the name of the end label matches the begin
              if match.group(2) != label_name:
                raise UserError("Detected end of custom block with incorrect label:\n  File: {0}\n  Line number: {1}\n  Previous begin label: {2}\n  Incorrect end label: {3}".format(fname,lnum+1,label_name,match.group(2)))
              if (block_end_fn != None):
                if block_end_fn(fname,line,label_name,lnum+1)==False:
                  continue
          elif in_block == True:
            if (block_inside_fn != None):
              block_inside_fn(fname,label_name,line,lnum+1)
          else:
            if (block_outside_fn != None):
              block_outside_fn(fname,line,lnum+1)
    except UnicodeDecodeError:
      # This can occur if reading a binary file with Python3. It's OK, just give up and move
      # to the next file.
      return
    # If we finish parsing the file and we still think we're in a pragma block, flag it as an error
    if (in_block==True):
      raise UserError("Reached end of file while still in custom block:\n  File: {0}\n  Label: {1}\n  Label start line:{2}".format(fname,label_name,begin_line))
    if (post_open_fn != None):
      post_open_fn(fname)
