

proc import_uvmf {} {

    ## Create top level virtual folder for UVM Base Library
	regexp {.*\/(UVMF_\d.\d.)} $::env(UVMF_HOME) matched vers
	set base_lib_name ${vers}_Base_Lib
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name"

    ## Read in the text file that specifies the UVMF folders to import
	set filep [open preferences/uvmf_files.f]
	set file_data [read $filep]
	# split file data into lines for processing
	set f_data [split $file_data "\n"]
	close $filep
	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path ${vers}_Base_Lib
	
	add_folds_and_files $top_virt_folder_path $f_data
}	


proc add_folds_and_files {virt_folder_path data} {

   	set disk_folder_path {}
	set dtype [lindex $virt_folder_path end]
	
	# Loop to process each line in the text file
	set prev_level 0
	foreach line $data {
		set depth_level 0
		##puts "LINE = $line"
		set len [string length $line]
		set first [string index $line 0]
		set last_char [string index $line [expr $len - 1]]

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
			lappend virt_folder_path [lindex $line 0]
		}
		##puts "current folder path = $disk_folder_path \n depth = $depth_level \n folder_len = $folder_len\nvirt folder path = $virt_folder_path"
		# Save current folder depth for next time around
		set prev_level $depth_level
		
		# Create virtual folder in SV-A project
        ::addVirtualFolder $::env(TESTBENCH_NAME) "$virt_folder_path"
		
		switch $dtype {
			"QUESTA_QVIP_HOME" { set dir_path [join "$::env(QUESTA_MVC_HOME) $disk_folder_path" "/"] }
			default            { set dir_path [join "$::env(UVMF_HOME) $disk_folder_path" "/"] }
        }
		
		##puts "disk dir_path = $dir_path"
		
		if {$last_char == "*"} {
		   	listTree $dir_path 0 $virt_folder_path
		} else {
			## Get list of files in current directory
			set currentfiles [glob -nocomplain -directory $dir_path -types f *.sv*]
			## Add the files in current directory to virtual folder
			::addFilesToProjectOp $currentfiles $virt_folder_path 0 1
		}
		set prev_line $line
	}
	
}

 proc listTree {rootdir_ create_dir_ virt_fpath_} {
    # Precondition: rootdir_ is valid path 
	
	## Get list of files in current directory
    set currentfiles [glob -nocomplain -directory $rootdir_ -types f *.sv*]
	## Add the files in current directory to virtual folder
    ::addFilesToProjectOp $currentfiles $virt_fpath_ 0 1	
	
    set currentnodes [glob -nocomplain -directory $rootdir_ -types d *]
	
    if {[llength $currentnodes] <= 0} {
    # Base case: the current dir is a leaf, write out the leaf 
        puts $rootdir_
        return
    } else {
	    if {$create_dir_ == 1} {
            # write out the current node 
            puts $rootdir_
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
			puts "listTree**: virt_fpath_ = $virt_fpath_\nlistTree**: newby = $tmp2\nlistTree**: node = $node"

            ## Add virtual folder for current level
			::addVirtualFolder $::env(TESTBENCH_NAME) "$virt_fpath_"
            ## Recursive call to add virtua lfolders for sub-directories			
            listTree $node 1 $virt_fpath_
        }
    }
}



proc import_qvip {} {

    ## Create top level virtual folder for Questa QVIP
	set base_lib_name QUESTA_QVIP_HOME
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name"

    ## Read in the text file that specifies the UVMF folders to import
	set filep [open preferences/questa_qvip_files.f]
	set file_data [read $filep]
	# split file data into lines for processing
	set i_data [split $file_data "\n"]
	close $filep
	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path $base_lib_name
	add_folds_and_files $top_virt_folder_path $i_data
}	



proc import_gpio_ex {} {

    ## Create top level virtual folder for Questa QVIP
	set base_lib_name zz_GPIO_UVMF_TB
	::addVirtualFolder $::env(TESTBENCH_NAME) "$::env(TESTBENCH_NAME) $base_lib_name"

    ## Read in the text file that specifies the UVMF folders to import
	set filep [open preferences/uvmf_ex1_gpio.f]
	set file_data [read $filep]
	# split file data into lines for processing
	set i_data [split $file_data "\n"]
	close $filep
	
	set top_virt_folder_path $::env(TESTBENCH_NAME)
	lappend top_virt_folder_path $base_lib_name
	add_folds_and_files $top_virt_folder_path $i_data
}