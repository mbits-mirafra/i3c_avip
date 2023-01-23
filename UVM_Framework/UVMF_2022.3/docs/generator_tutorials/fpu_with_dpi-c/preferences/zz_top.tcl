proc CheckForFiles { basedir } {

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
	if {[llength $currentfiles] > 0} {
		set filefound 1
		puts "XXXX   Files found at top level\n\t curentfiles = $currentfiles"
		return $filefound
	} else {

		puts "XXXX   Searching for lower level dirs"

		# Now look for any sub direcories in the current directory
		foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
			# Recusively call the routine on the sub directory and append any
			# new files to the results
			
			puts "XXXX   current directory = $dirName"

			set tmp [CheckForFiles $dirName]
			
			puts "XXXX Results of file check in directory $dirName = $tmp"
			if { [llength $tmp] > 0 } {
				set filefound 1
				return $filefound
			}
		}
		return $filefound
	}
 }
