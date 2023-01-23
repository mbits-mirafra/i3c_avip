#!/usr/bin/env python
# ---------------------------------------------------------------------------
# Copyright 2014 Mentor Graphics Corporation 
#    All Rights Reserved 
# 
# THIS WORK CONTAINS TRADE SECRET 
# AND PROPRIETARY INFORMATION WHICH IS THE 
# PROPERTY OF MENTOR GRAPHICS 
# CORPORATION OR ITS LICENSORS AND IS 
# SUBJECT TO LICENSE TERMS. 
# 
# ---------------------------------------------------------------------------
#   WARRANTY:
#   Use all material in this file at your own risk.  Mentor Graphics, Corp.
#   makes no claims about any material contained in this file.
# ---------------------------------------------------------------------------
# $Date: 2017-07-26 09:28:28 -0400 (Wed, 26 Jul 2017) $
# $Revision: 8126 $
# ---------------------------------------------------------------------------

# $Date: 2017-07-26 09:28:28 -0400 (Wed, 26 Jul 2017) $  $Rev: 8126 $  $Author: rsalemi $


import sys
import os
import subprocess
import re
import optparse

# Gets the filename from a path /a/b/c returns c
def get_file(filename):
    path = filename.split("/")
    return path[-1]

# Given a path this function returns the full path to it.
# Cding to the path resolves all issues of relative paths or environment variables.
# also tests that the path exists
def resolve_path(path):
    cur_path = os.getcwd()
    try:
        os.chdir(path)
    except:
        print "Could not cd to {0}".format(path)
        sys.exit(1)
    resolved_path = os.getcwd()
    os.chdir(cur_path)
    return "{0}/".format(resolved_path)

# Returns true if this path is relative to the current directory.
def relative_path(path):
    path = path.lstrip()
    if (path[0] != "$" and path[0] != "/"):
        return 1
    else:
        return 0

def not_blank(line_str):
    return len(line_str.strip()) != 0

# Returns true if this line does not start //
def not_comment(line_str):
    return not re.search("\A\/\/", line_str)

# All vinfo files get stored in Vinfo objects.  When you create a Vinfo object
# you also create Vinfo objects for all the referenced Vinfo files.  
# This continues to the leaf Vinfo files. 

# The Vinfo class is intended to be treated as a set of 
# singletons. You use the get() method to get a new Vinfo object.  The get
# method checks to see whether there is already a Vinfo object for the given
# path and returns a handle to that object if it exists.  Otherwise it creates
# a new object and stores it in the dictionary.

class Vinfo:
    """Holds data for a vinfo file and dependencies"""
    dictionary = {}

# Check to see if a Vinfo object exists in the dictionary and return it.
# If the object does not exists in the dictionary then create it, store it,
# and return it.

    @staticmethod
    def get(filepath):
        if relative_path(filepath):
            print "Relative paths not allowed to get Vinfo object.  You passed {0}".format(filepath)
            sys.exit(1)
        filepath = os.path.expandvars(filepath)
        if not filepath in Vinfo.dictionary:
            if (options.debug):
                print "Creating Vinfo: {0}".format(filepath)
            Vinfo.dictionary[filepath] = Vinfo(filepath)

        return Vinfo.dictionary[filepath]




    def __init__(self,filepath):
        """Init needs full path to file name"""

        # Store data about the filepath to this Vinfo file. 
        if relative_path(filepath):
            print "Relative paths not allowed to create Vinfo object.  You passed {0}".format(filepath)
            sys.exit(1)
        self.filepath = os.path.expandvars(filepath)
        self.filename = get_file(self.filepath)
        path_list = self.filepath.split("/")
        del path_list[-1] # get rid of filename
        self.dirpath = "/".join(path_list)

        # Now that we have the path to the vinfo we can start working on it
        # First handle the macros

        # Assumes there is a perl script named expand_ifdef_stdout 
        # in the same dir as this script and that we have 
        # execute permissions on it.

        if (options.defines):
            define_list = options.defines
        else:
            define_list = ""

        # The config file is a set of defined macros. It replaces
        # --define=+define1+define2+define3 with a file
        # define1
        # define2
        # define3

        if (options.config_file):
            config_f = open(options.config_file, "r")
            for line in config_f:
                line = line.strip()
                define_list = define_list + "+" + line

        script_dir = os.path.dirname(os.path.realpath(__file__))
        expand_ifdef = "{0}/expand_ifdef_stdout".format(script_dir)

        # run the perl script that processes macros.
        proc = subprocess.Popen([expand_ifdef, "+define+" + define_list, self.filepath], stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE)
        (vinfo_lines_str,err_str) = proc.communicate()
        if (proc.returncode):
            print "Error in expand_ifdef_stdout: {0}".format(err_str)
            sys.exit(1)

        vinfo_lines_str = vinfo_lines_str.strip("\n")

        # store the lines from the vinfo file in the vinfo_lines list.
        # Remove all empty lines and all comments.
        # expand all environment variables.
        # process the @vinfodir token and replace it with the current dir.

        self.vinfo_lines = vinfo_lines_str.split("\n")
        self.vinfo_lines = filter(None, self.vinfo_lines)
        self.vinfo_lines = filter(not_blank, self.vinfo_lines)
        self.vinfo_lines = filter(not_comment, self.vinfo_lines)
        self.vinfo_lines = [os.path.expandvars(line) for line in self.vinfo_lines]
        self.vinfo_lines = [line.replace("@vinfodir",self.dirpath) for line in self.vinfo_lines]

        # We now have vinfo_lines with no comments. Now process them.

        # Lines go into the vf_lines list for this Vinfo file unless they
        # have a @use token.  We use those lines to create additional Vinfo
        # objects and store them in our dependency list.  We use the get()
        # method so that we don't create Vinfo objects for objects that we've
        # already made. 

        # Print the vinfo file name for clarity in the .vf file.
        self.vf_lines = ["\n\n// ------- {0} --------".format(self.filename)]


        use_re_search = "\A.*\@use\s+(.*)$"  # looks for @use
        self.dependencies=[]
        for line in self.vinfo_lines:
            line = line.strip()
            line_re = re.search(use_re_search, line)

            if (line_re == None):  
                # Not a @use line. Put it in the final vf file list.
                comment_re = re.search("\A.*[\+\-]", line)
                # ignore options
                if (comment_re == None) and relative_path(line):
                    line = "{0}/{1}".format(self.dirpath,line)
                self.vf_lines.append(line)
            else:
                # Is a @use line. Get a Vinfo for that line.
                dep_vinfo_file = os.path.expandvars(line_re.group(1))
                if relative_path(dep_vinfo_file):
                    dep_vinfo_file = "{0}/{1}".format(self.dirpath,dep_vinfo_file)
                abs_vinfo_file = os.path.abspath(dep_vinfo_file)
                if (not os.path.exists(abs_vinfo_file)):
                    print "Error parsing {0}".format(self.filepath)
                    print "Unable to find @use file {0}".format(abs_vinfo_file)
                    sys.exit(1)

                dep_vinfo = Vinfo.get(abs_vinfo_file)
                self.dependencies.append(dep_vinfo)


# Returns the dependency list for this Vinfo and all that this one depends upon

# The format for dependencies works like this:

# Given that a car depends on an engine and an engine depends upon pistons 
# Also that a scooter depends on an engine we get the following:

# engine car
# piston engine
# engine scooter

# tsort returns the order of compilation:
# piston
# engine
# car
# scooter

# This function returns our input into tsort.
    def get_dependencies(self):
        dependency_str = ""
        for vinfo_i_need in self.dependencies:
            dependency_str = "{0}\n{1} {2}\n{3}".format(dependency_str,
                                                        vinfo_i_need.filepath,
                                                        self.filepath,
                                                        vinfo_i_need.get_dependencies())
        dependency_str += "\n"
        return dependency_str

# Returns the vf lines for this Vinfo object as a string that can be written
# into a file.  This method walks all dependencies, uses tsort, and creates one
# string that will compile everything from this Vinfo down.

    def get_vf_file_str(self):
        vf_filestr = ""

        dependency_str = self.get_dependencies()

        if (dependency_str == '\n'):
            # There are no dependencies in this top-level vinfo file
            vf_lines = self.vf_lines
            vf_filestr += "\n".join(vf_lines)
            vf_filestr += "\n"
            return vf_filestr
        else:
            # use tsort to sort dependencies (not to be confused with a file sort)
            proc = subprocess.Popen(["tsort"], stdout=subprocess.PIPE,
                                    stdin=subprocess.PIPE, stderr=subprocess.PIPE)
            (vf_filelist_str, err) = proc.communicate(input=dependency_str)
            assert not proc.returncode, "Error calling tsort to sort files: {0}".format(err)

        # vf_filelist_string is a list of Vinfo paths sorted by tsort.  
        # The Vinfo.dictionary uses these Vinfo paths as keys.  We use this
        # list to get all the Vinfo files in the correct order and print out
        # their vf_lines list.

            vf_filelist_str = vf_filelist_str.strip()
            vf_filelist = vf_filelist_str.split("\n")
            if (options.debug):
                print "The Vinfo File Order:\n{0}".format(vf_filelist_str)
                # Given the list of vinfo paths, make a vf_file
            for vinfo_file in vf_filelist:
                vf_lines = Vinfo.dictionary[vinfo_file].vf_lines
                vf_filestr += "\n".join(vf_lines)
                vf_filestr += "\n"
            return vf_filestr


# ////////////////////// Program Starts //////////////////////////////////

parser = optparse.OptionParser(usage="usage: %prog <file>.vinfo [options]")

parser.add_option("--define", dest="defines",
                  help="Defines to support ifdefs in the vinfo file --defines=define1+define2+define3")
parser.add_option("--debug", action="store_true", dest="debug",
                  help="Leaves intermediate files around for debug and prints messages you wouldn't see otherwise.")
parser.add_option("-c", "--config", dest="config_file", help="Path to a file name that contains defines one per line")
parser.add_option("-o", "--output", dest="output_file",
                  help="Optional filename for the .vf file.  You control the extention and must provide the .vf if you want a .vf extension")

(options, args) = parser.parse_args()

# Check that our invocation was correct.

if (len(args) != 1):
    parser.print_help()
    sys.exit(1)

vinfo_filename = args[0]

arg_re = re.search("(\A.*\/)(.*$)", vinfo_filename)

if arg_re:
    base_path = resolve_path(arg_re.group(1))
    filename = arg_re.group(2)
else:
    base_path = resolve_path(".")
    filename = vinfo_filename

fileparts = filename.split('.')

base = fileparts[-2]
extension = fileparts[-1]

if (len(fileparts) != 2):
    print "Error: vinfo file must only have one extension.  You suppled '" + vinfo_filename + "'"
    sys.exit(1)

if (extension != "vinfo"):
    print "Error: vinfo file must have the extension 'vinfo'.  You suppled '" + vinfo_filename + "'"
    sys.exit(1)

if (options.output_file):
    final_vf_filename = options.output_file;
else:
    final_vf_filename = base_path + base + ".vf"

if (relative_path(vinfo_filename)):
    vinfo_filename = os.getcwd() + "/" + vinfo_filename

if not os.path.exists(vinfo_filename):
    print "Error: " + vinfo_filename + " does not exist"
    sys.exit(1)


# We have a correct Vinfo file to start. Create the Vinfo object for it
# then print out the vf_file for that object.

base_vinfo = Vinfo.get(vinfo_filename)

print "writing ", final_vf_filename
vf_filestr = base_vinfo.get_vf_file_str()
vf_f = open(final_vf_filename, 'w')
vf_f.write(vf_filestr)
vf_f.close()
