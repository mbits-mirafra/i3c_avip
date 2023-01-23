###############################################################
##
##  Created By : Graeme Jessiman
##  Date :       Dec 12th 2016
##  Version :    1.0   (Initial Version)
##
###############################################################

  ##  set DEBUG=1 to print out some debug information
set DEBUG 1


###########################################################
## Procedure : import_uvmf
##
##  Relies on the following environment variables being set
##    $UVMF_HOME      : Points at root directory for UVM Framework
##    $TESTBENCH_NAME : Defines SV-A project name
##
##  The above env variables are set in the invoke_sva.bat script
##  Will create a virtual folder named 'UVMF_3.6e_Base_Lib'
##
###########################################################
proc import_uvmf {} {

    if {$::DEBUG == 1} {
		puts "\tProcedure import_uvmf:: Starting import...."
	}
    ## Create top level virtual folder for UVM Base Library
	regexp {.*\/(UVMF_\d.\d.)} $::env(UVMF_HOME) matched vers
	set base_lib_name ${vers}_Base_Lib
	set root_dir [file normalize $::env(UVMF_HOME)]
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name"

    ## Read in the text file that specifies the UVMF folders to import
	set filep [open preferences/uvmf_files.f]
	set file_data [read $filep]
	# split file data into lines for processing
	set f_data [split $file_data "\n"]
	close $filep
	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path ${vers}_Base_Lib
	
	add_folds_and_files $top_virt_folder_path $f_data $root_dir 1
    if {$::DEBUG == 1} {
		puts "\tProcedure import_uvmf:: Import complete."
	}

}	

###########################################################
## Procedure : add_folds_and_files
##
##  Parameters
##    virt_folder_path      : The SV-A virtual folder path where the files are to be imported
##    data                  : A list of folders where is data to be imported from
##    root_dir_             : The root directory where folder/file import should start
##    file_flag             : 1-Denotes files to import specified by a text file; 0=Denotes import all files under root directory
##
###########################################################
proc add_folds_and_files {virt_folder_path data root_dir_ file_flag} {

   	set disk_folder_path {}

	 # Check to see if there are any files to import at this level
	set currentfiles [glob -nocomplain -directory $root_dir_ -types f *.sv*]
	append currentfiles [glob -nocomplain -directory $root_dir_ -types f *.v]
	append currentfiles [glob -nocomplain -directory $root_dir_ -types f *.vhd]
	if {[llength $currentfiles] > 0} {			
		## Add the files in current directory to virtual folder
		::addFilesToProjectOp $currentfiles $virt_folder_path 1 1
	}
	
	# Loop to process each line in the text file
	set prev_level 0
	foreach line $data {
	    ##check for blank lines or comment lines and ignore them
		if {([llength $line] > 0) && ([string index $line 0] != "#")} {

			set depth_level 0
			if {$::DEBUG == 1} {
				puts "\tProcedure add_folds_and_files: DATA = $data :\t\tLINE = $line"
			}
			set len [string length $line]
			set first [string index $line 0]
			set last_char [string index $line [expr $len - 1]]
			if {$::DEBUG == 1} {
				puts "\tProcedure add_folds_and_files: len = $len :\t\tfirst = $first : \t\tlast_char = $last_char"
			}
			## Count number of tabs at start of line to indicate depth level		
			set line_copy $line
			while {$first == "\t"} {
				incr depth_level
				set first [string index $line_copy $depth_level]
			}

			set folder_len [llength $virt_folder_path]
		
			# If current folder depth greater then previous, then append current folder name to path list  
			if [expr $depth_level > $prev_level] {
				lappend virt_folder_path [lindex $line 0]
				lappend disk_folder_path [lindex $line 0]
			# if current folder depth is less than previous, then remove appropriate number of folder names from path list	
			} elseif [expr $depth_level < $prev_level] {
				for { set i 0} {$i < [expr $prev_level - $depth_level]} {incr i} {
					set disk_folder_path [lreplace $disk_folder_path end end]			 
					set virt_folder_path [lreplace $virt_folder_path end end]
				}
				set disk_folder_path [lreplace $disk_folder_path end end]	
				set virt_folder_path [lreplace $virt_folder_path end end]	
				lappend disk_folder_path [lindex $line 0]
				lappend virt_folder_path [lindex $line 0]
			} else {
				# depth level must be same as previous iteration
				if {[expr $folder_len > 2]} {
					set disk_folder_path [lreplace $disk_folder_path end end]
					set virt_folder_path [lreplace $virt_folder_path end end]
				}
				lappend disk_folder_path [lindex $line 0]
				if {$file_flag == 1} {
					lappend virt_folder_path [lindex $line 0]
				}	
			}
			##puts "current folder path = $disk_folder_path \n depth = $depth_level \n folder_len = $folder_len\nvirt folder path = $virt_folder_path"
			# Save current folder depth for next time around
			set prev_level $depth_level
		
		    if {$file_flag == 1} {
				# Create virtual folder in SV-A project
				::addVirtualFolder $::env(TESTBENCH_NAME) "$virt_folder_path"
			}
		
		    # Check to see if import is being specified by text file
		    if {$file_flag == 1} {
			     # Import by file. Join root directory with current folder name
				set dir_path [join "$root_dir_ $disk_folder_path" "/"]
			} else {
			     # Import everything under the root directory.
				set dir_path $root_dir_
			}
			##puts "disk dir_path = $dir_path"
		
		    # Check for wildcard which indicates that all subfolders/files to be imported
			if {$last_char == "*"} {
				if {$::DEBUG == 1} {
					puts "\tProcedure add_folds_and_files: calling listTree : dir_path = $dir_path;\tvirt folder path = $virt_folder_path"
				}
				listTree $dir_path $virt_folder_path
			} else {
				## Get list of files in current directory
				set currentfiles [glob -nocomplain -directory $dir_path -types f *.sv*]
				append currentfiles [glob -nocomplain -directory $dir_path -types f *.v]
				append currentfiles [glob -nocomplain -directory $dir_path -types f *.vhd]
				if {[llength $currentfiles] > 0} {			
					## Add the files in current directory to virtual folder
					::addFilesToProjectOp $currentfiles $virt_folder_path 1 1
				}
			}
			set prev_line $line		
		}

	}
	
}

###########################################################
## Procedure : listTree
##
##  Parameters
##    root_dir_        : The root directory where folder/file import should start
##    virt_fpath_      : The SV-A virtual folder path where the files are to be imported
##
###########################################################
 proc listTree {rootdir_ virt_fpath_} {
    # Precondition: rootdir_ is valid path 
	
	## Get list of SystemVerilog, Verilog & VHDL files in current directory
    set currentfiles [glob -nocomplain -directory $rootdir_ -types f *.sv*]
    append currentfiles [glob -nocomplain -directory $rootdir_ -types f *.v]
    append currentfiles [glob -nocomplain -directory $rootdir_ -types f *.vhd]

	if {$::DEBUG == 1} {
		puts "\tProc listTree: currentfiles = $currentfiles\n\tProc listTree: rootdir = $rootdir_\n\tProc listTree: virtual folder path = $virt_fpath_"
	}
	 # If some files were found in current directory, then import them
	if {[llength $currentfiles] > 0} {
		## Add the files in current directory to virtual folder
		::addFilesToProjectOp $currentfiles $virt_fpath_ 1 1
	}

	 # Check to see if current directory contains UVMF module 'hvl_top.sv
	 # For running UVMF simulations from SV-A we need to set this as a top module
	set hvltop_file [glob -nocomplain -directory $rootdir_ -types f hvl_top.sv]
	if {[llength $hvltop_file] > 0} {
		if {$::DEBUG == 1} {
			puts "\tProc listTree:  HVL_TOP_FILE = ZZZ $hvltop_file \n\tProc listTree:  HVL_TOP_PATH = $virt_fpath_\n"
		}
		# Turn off prompts to update the project
	   ::setAutoUpdateMakefileWithoutPrompt 1
         # Use grep to find line number for module declaration of hvl_top	   
	   package require fileutil
	   set result [fileutil::grep "module hvl_top" $hvltop_file]
	     # Extract line number from grep result
	   regexp {hvl_top.sv:(\d*):} $result match num
	    # Mark hvl_top as a top module
	   ::markModuleAsTopOp {Design_Objects} [list "hvl_top.sv $num" $::env(TESTBENCH_NAME) Modules hvl_top] 1
	    # Restore prompts to update project
	   ::setAutoUpdateMakefileWithoutPrompt 0	
	}

	 # Check for further directories under the current folder
    set currentnodes [glob -nocomplain -directory $rootdir_ -types d *]
	if {$::DEBUG == 1} {
		puts "\tProcedure listTree: currentnodes = $currentnodes"
	}
	
	 # Check to see if current folder has any sub-directories
    if {[llength $currentnodes] <= 0} {
         # Base case: the current dir is a leaf, write out the leaf 
		if {$::DEBUG == 1} {
			puts "\tProcedure listTree: No Further Subdirs in $rootdir_"
		}
        return
    } else {
	     # The are sub-directories
		if {$::DEBUG == 1} {
			puts "\tProcedure listTree: Subdirs Detected in $rootdir_"
		}
 		 #add dummy entry to virtual folder list
		lappend virt_fpath_ dummy
         # Recurse over all dirs at this level
        foreach node $currentnodes {
		    # replace previous list entry with current code
			# Very first loop iteration replaces dummy entry
			set virt_fpath_ [lreplace $virt_fpath_ end end]
			set tmp [split $node "/"]
			lappend virt_fpath_ [lindex $tmp end]
			set tmp2 [lindex $tmp end]
			if {$::DEBUG == 1} {
				puts "\tProc listTree: virt_fpath_ = $virt_fpath_\n\tProc listTree: newby = $tmp2\n\tProc listTree: node = $node"
			}
			 # Use procedure to recursively check if there are files with extension .v, .sv or .vhd below current folder
			 # checkForFiles : returns 1 if files to import detected. returns 0 if no files to import detected
			if {[CheckForFiles $node] == 1} {
				 # Add virtual folder for current level
				::addVirtualFolder $::env(TESTBENCH_NAME) "$virt_fpath_"
				 # Recursive call to add virtual folders for sub-directories			
				listTree $node $virt_fpath_
			}
        }
    }
}



###########################################################
## Procedure : import_qvip
##
##  Relies on the following environment variables being set
##    $QUESTA_MVC_HOME  : Points at root directory for the QVIP install
##
##  The above env variable is set in the invoke_sva.bat script
##  Will create a virtual folder named 'QUESTA_QVIP_HOME'
##
###########################################################
proc import_qvip {} {

    if {$::DEBUG == 1} {
		puts "\tProcedure import_qvip:: Starting import...."
	}
    ## Create top level virtual folder for Questa QVIP
	set base_lib_name QUESTA_QVIP_HOME
	set root_dir [file normalize $::env(QUESTA_MVC_HOME)]
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name"

	if {$::DEBUG == 1} {
		puts "\tProcedure import_qvip:: Reading folder spec file : preferences/questa_qvip_files.f"
	}
    ## Read in the text file that specifies the UVMF folders to import
	set filep2 [open preferences/questa_qvip_files.f]
	set file_data2 [read $filep2]
	# split file data into lines for processing
	set i_data [split $file_data2 "\n"]
	close $filep2
	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path $base_lib_name
	add_folds_and_files $top_virt_folder_path $i_data $root_dir 1

	if {$::DEBUG == 1} {
		puts "\tProcedure import_qvip:: Excluding NCSIM/VCS specific QVIP files"
	}	
	## Exclude VCS & NCSIM specific files from QVIP import
    ::removeFileFromProjectOp "$::env(TESTBENCH_NAME) QUESTA_QVIP_HOME include questa_mvc_svapi_IUS.svh"
    ::removeFileFromProjectOp "$::env(TESTBENCH_NAME) QUESTA_QVIP_HOME include questa_mvc_svapi_VCS.svh"

    if {$::DEBUG == 1} {
		puts "\tProcedure import_qvip:: import complete"
	}	
}


###########################################################
## Procedure : import_design
##
##  Parameters
##    base_lib_name_   : SV-A virtual folder name to import design into
##    design_rootdir   : The root directory where folder/file import should start importing from
##    design_filelist  : Can be path to a text file that specifies which sub-folders to import
##                       or if '*' specified then all subfolders/files will be imported
##
###########################################################
proc import_design {base_lib_name_ design_rootdir design_filelist} {

    if {$::DEBUG == 1} {
		puts "\tProcedure import_design:: Starting import...."
	}

      ## Create top level virtual folder for User Design
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name_"
	
	  ## Check to see if all folders to be imported or if they are specifed via user file
	  ## Parameter should be either "*" to import all folders to te name of text file that specifes the fodlers to import
	if {$design_filelist == "*"} {
		if {$::DEBUG == 1} {
			puts "\tProcedure import_design:: wildcard specified ...importing all folders below $design_rootdir"
		}
	     ## Wildcard found so set $j_data to the root directory 
		## set currentnodes [glob -nocomplain -directory $design_rootdir -types d *]
		set dirname [lindex [split $design_rootdir "/"] end]
		set j_data [list [concat $dirname " *"]]
		set read_from_file 0
	} else {
		if {$::DEBUG == 1} {
			puts "\tProcedure import_design:: Reading folder spec file : $design_filelist"
		}
		## Check to see if specified import file exists or else trap error.
		if { ! [file exists $design_filelist] } {
			puts stderr "\n\timport_design:: ERROR : File $design_filelist not found on system\n"
			break
		}
		## Read in the text file that specifies the UVMF folders to import
		set filep1 [open $design_filelist]
		set file_data1 [read $filep1]
		# split file data into lines for processing
		set j_data [split $file_data1 "\n"]
		close $filep1
		set read_from_file 1
	}

     # Append current folder to virtual folder path	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path $base_lib_name_
	 # Call proc to import folders and files
	add_folds_and_files $top_virt_folder_path $j_data $design_rootdir $read_from_file

    if {$::DEBUG == 1} {
		puts "\tProcedure import_design:: import complete"
	}
}


###########################################################
## Procedure : CheckForFiles
##
##  Parameters
##    basedir   : The top directory to check if it contains 
##                files to import
##
##  Returns 1 if files with extension .sv, .sv or .vhd found 
##            under the specifed basedir
##  Returns 0 if no files found
##
###########################################################
proc CheckForFiles { basedir } {

    if {$::DEBUG == 1} {
		puts "\tProcedure CheckForFiles:: checking top directory $basedir"
	}
    # Fix the directory name, this ensures the directory name is in the
    # native format for the platform and contains a final directory seperator
    set basedir [string trimright [file join [file normalize $basedir] { }]]
    set filefound 0

    # Look in the current directory for matching files, -type {f r}
    # means ony readable normal files are looked at, -nocomplain stops
    # an error being thrown if the returned list is empty
    set currentfiles [glob -nocomplain -directory $basedir -types f *.sv*]
    append currentfiles [glob -nocomplain -directory $basedir -types f *.v]
    append currentfiles [glob -nocomplain -directory $basedir -types f *.vhd]
	
	 # Test to see if files found in current folder
	if {[llength $currentfiles] > 0} {
	     # set flag and return value of 1 from procedure
		set filefound 1
		if {$::DEBUG == 1} {
			puts "\t\tCheckForFiles : Files found at top level\n\t\tCheckForFiles : currentfiles = $currentfiles"
		}
		return $filefound
	} else {

	     # No files found in current folder
		 
		if {$::DEBUG == 1} {
			puts "\t\tCheckForFiles : Searching for lower level dirs in $basedir"
		}

		# Now check all sub directories found below the current directory
		foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
			# Recusively call the routine on the sub directory and append any
			# new files to the results

			if {$::DEBUG == 1} {
				puts "\t\tCheckForFiles : current traversed directory = $dirName"
			}

			set tmp [CheckForFiles $dirName]
			
			if {$::DEBUG == 1} {
				puts "\t\tCheckForFiles : Results of file check in directory $dirName = $tmp"
			}
			if { [llength $tmp] > 0 } {
				set filefound 1
				return $filefound
			}
		}
		return $filefound
	}
 }
