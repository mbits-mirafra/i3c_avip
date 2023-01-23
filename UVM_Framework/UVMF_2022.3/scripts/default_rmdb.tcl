package require fileutil
package require yaml
variable recursion_check
variable tcdict
variable builddict 
variable file_read
variable root_dir
variable debug
variable ini
variable rerun_count
variable mseed
variable testlist_info
variable current_tb

## Returns the actual master seed used to seed the Tcl random number generator
proc returnMasterSeed {} {
  global mseed
  return $mseed
}


## Variables controllable by user via ini file along with their defaults
#puts [format "DEFAULT code_coverage_enable : %s" $ini(code_coverage_enable)]

## The $builddict dictionary contains the following sub-structure:
##  { <testbench_name> }
##      - { buildcmd } : Extra command-line arguments to use during 'make build' command
##      - { runcmd } : Extra command-line arguments appended to vsim command for this testbench
##      - { builddir } : Directory where this testbench's Makefile lives      
##      - { symlinks } : List of symbolic links to create for each test executed. Only defined by YAML testlist
##  { <repeated for all testbenches> }

## $tcdict organization to allow for per-iteration extra-args
##  { <testbench_name> }
##     { <testcase_name> }
##        { Iteration# } : Incrementing from 0 to N
##          { seed } : Seed to use for this iteration
##          { extra_args } : Extra command-line arguments for this iteration
##          { uvm_testname } : UVM test to invoke. Only defined by YAML testlist

proc initTcl {rd {master_seed 0} {dbg 0}} {
  global file_read
  global root_dir
  global debug
  global ini
  global rerun_count
  global mseed
  set debug $dbg
  set file_read 0
  set root_dir $rd
  if {$master_seed=="random"} {
    puts "NOTE: Using random master seed"
    set ms [clock seconds]
  } else {
    puts "NOTE: Using fixed random seed"
    set ms $master_seed
  }
  set rv [expr {srand($ms)}]
  set mseed $ms
  puts [format "NOTE: Master seed set to %d" $ms]
  vrmSetupDefaults
  vrmSetup
  if {$dbg==1} {
    puts [format "DEBUG: Initialization variable settings:"]
    dumpIniVars
  }
  set rerun_count 0
  return 0
}

## Default proc is empty - expectation is that user points to a separate
## file pointed to by $UVMF_VRM_INI env variable to override this proc
## and fill it with desired overrides to default behavior. That Tcl is 
## sourced early enough that other procs (to define non-standard LSF, for
## example) can be defined as well
proc vrmSetup {} {}

## These are default initialization variables 
proc vrmSetupDefaults {} {
  global root_dir
  setIniVar testlist_name "testlist" 1
  setIniVar top_testlist_file "(%SIM_DIR%)/(%TESTLIST_NAME%)" 1
  setIniVar code_coverage_enable 0 1
  setIniVar code_coverage_types "bsf" 1
  setIniVar code_coverage_target "/hdl_top/DUT." 1
  setIniVar code_coverage_map 0 1
  setIniVar extra_merge_options "" 1
  setIniVar extra_run_options "" 1
  setIniVar tplanfile "" 1
  setIniVar tplanoptions "-format Excel" 1
  setIniVar tplan_merge_options "-testassociated" 1
  setIniVar no_rerun 1 1
  setIniVar rerun_limit 0 1
  setIniVar use_infact 0 1
  setIniVar use_vis 0 1
  setIniVar use_vinfo 0 1
  setIniVar dump_waves 0 1
  setIniVar dump_waves_on_rerun 0 1
  setIniVar vis_dump_options "+signal+report+memory=512" 1
  setIniVar exclusionfile "" 1
  setIniVar pre_run_dofile {""} 1
  setIniVar pre_vsim_dofile {""} 1
  setIniVar run_exec "" 1
  setIniVar use_test_dofile 0 1
  setIniVar use_job_mgmt_run 0 1
  setIniVar use_job_mgmt_build 0 1
  setIniVar use_job_mgmt_covercheck 0 1
  setIniVar use_job_mgmt_exclusion 0 1
  setIniVar use_job_mgmt_report 0 1
  setIniVar gridtype "lsf" 1
# Use of older switches "-source" and "-htmldir" have been replaced with "-annotate" and "-output" respectively.
# May need to use this alternative set of switches if using an older release of Questa
#  setIniVar html_report_args "-details -source -testdetails -showexcluded -htmldir (%VRUNDIR%)/covhtmlreport" 1
  setIniVar html_report_args "-details -annotate -testdetails -showexcluded -output (%VRUNDIR%)/covhtmlreport" 1
  setIniVar gridcommand_run "bsub -J (%INSTANCE%) -oo (%TASKDIR%)/(%SCRIPT%).o%J -eo (%TASKDIR%)/(%SCRIPT%).e%J (%WRAPPER%)" 1
  setIniVar gridcommand_build "bsub -J (%INSTANCE%) -oo (%TASKDIR%)/(%SCRIPT%).o%J -eo (%TASKDIR%)/(%SCRIPT%).e%J (%WRAPPER%)" 1
  setIniVar gridcommand_covercheck "bsub -J (%INSTANCE%) -oo (%TASKDIR%)/(%SCRIPT%).o%J -eo (%TASKDIR%)/(%SCRIPT%).e%J (%WRAPPER%)" 1
  setIniVar gridcommand_exclusion "bsub -J (%INSTANCE%) -oo (%TASKDIR%)/(%SCRIPT%).o%J -eo (%TASKDIR%)/(%SCRIPT%).e%J (%WRAPPER%)" 1
  setIniVar gridcommand_report "bsub -J (%INSTANCE%) -oo (%TASKDIR%)/(%SCRIPT%).o%J -eo (%TASKDIR%)/(%SCRIPT%).e%J (%WRAPPER%)" 1
  setIniVar use_covercheck 0 1
  setIniVar top_du_name "top_du_name" 1
  setIniVar covercheck_build "covercheck_build" 1
  setIniVar extra_covercheck_options "" 1
  setIniVar covercheck_analyze_timeout "15m" 1
  setIniVar covercheck_init_file "" 1
  setIniVar covercheck_ucdb_file "(%DATADIR%)/tracker.ucdb" 1
  setIniVar timeout 3600 1
  setIniVar queue_timeout 60 1
  setIniVar build_timeout -1 1
  setIniVar build_queue_timeout -1 1
  setIniVar run_timeout -1 1
  setIniVar run_queue_timeout -1 1
  setIniVar exclusion_timeout -1 1
  setIniVar exclusion_queue_timeout -1 1
  setIniVar covercheck_timeout -1 1
  setIniVar covercheck_queue_timeout -1 1
  setIniVar report_timeout -1 1
  setIniVar report_queue_timeout -1 1
  setIniVar email_servers {} 1
  setIniVar email_recipients {} 1
  setIniVar email_sections "all" 1
  setIniVar email_subject {} 1
  setIniVar email_message {} 1
  setIniVar email_originator {} 1
  setIniVar usestderr 0 1
  setIniVar trendfile {} 1
  setIniVar trendoptions {} 1
  setIniVar triagefile {} 1
  setIniVar triageoptions {} 1
  setIniVar use_bcr 0 1
  setIniVar bcr_exec_cmd_linux "uvmf_bcr.py" 1
  setIniVar bcr_exec_cmd_windows "python $::env(UVMF_HOME)/scripts/uvmf_bcr.py" 1
  setIniVar bcr_flow "questa" 1
  setIniVar bcr_overlay {} 1
  setIniVar multiuser 1 1
  return 0
}

proc getTimeoutVal {globalTimeout timeout} {
  if { $timeout == -1 } { 
    return $globalTimeout 
  } else { 
    return $timeout
  }
}

proc getIniVar {varname} {
  global ini
  global debug
  set lv [string tolower $varname]
  if {[info exists ini($lv)]} {
    if { $debug } {
      puts [format "DEBUG : ini variable %s returning value '%s'" $varname $ini($lv)]
    }
    return $ini($lv)
  }
  # Don't return an error if var not found, this will happen if vrun is invoked with -status
  return {}
#  puts [format "ERROR : ini variable %s not found" $varname]
#  puts [format "        Available ini variables: %s" [array names ini]]
#  ex 88
}

proc setIniVar {varname value {firsttime 0}} {
  global ini
  global debug
  if { $debug == 1 } {
    puts [format "DEBUG: ini variable \"%s\" getting set to \"%s\"" $varname $value]
  }
  set lv [string tolower $varname]
  if {$firsttime==0} {
    if {![info exists ini($lv)]} {
      puts [format "ERROR: ini variable \"%s\" unrecognized on set attempt. Following list are available:\n\t%s" $varname [array names ini]]
      ex 88
    }
  }
  set ini($lv) $value
}

proc dumpIniVars {} {
  global ini
  parray ini
}

## Returns a path to the inFact SDM .ini file if inFact is enabled.
## Returns "" if inFact is disabled
proc getInfactSdmIni {datadir} {
  if {[getIniVar use_infact]} {
	return [file join "+infact=$datadir" "infactsdm_info.ini"]
  } else {
    return ""
  }
}

## YAML-based testlist reader
proc ReadYAMLTestlistFile { file_name invoc_dir {collapse 0} {debug 0} {init 0}} {
  global testlist_info
  global tcdict
  global builddict
  global root_dir
  global recursion_check
  global current_tb
  set filename [file normalize $file_name]
  puts [format "NOTE: Reading YAML testlist file \"%s\"" $filename]
  if {![file isfile $filename]} {
    puts [format "ERROR: Invalid file - %s" $filename]
    ex 88
  }
  if {[lsearch $recursion_check $filename] >= 0} {
    puts [format "ERROR: Circular recursion detected in YAML testlist file %s, was included earlier" $filename]
    ex 88
  }
  set yaml_data [yaml::yaml2dict -file $filename]
  lappend recursion_check $filename
  if {![dict exists $yaml_data uvmf_testlist]} {
    puts [format "ERROR: testlist YAML file %s formatting error" $filename]
    ex 88
  }
  set dir [file dirname $filename]
  if {[dict exists $yaml_data uvmf_testlist testbenches]} {
    foreach tb [dict get $yaml_data uvmf_testlist testbenches] {
      if {![dict exists $tb name]} {
        puts [format "ERROR: testlist YAML file %s formatting error" $filename]
        ex 88
      }
      if { $debug } {
        puts [format "DEBUG: Adding testbench %s info to list" [dict get $tb name]]
      }
      set tb_name [dict get $tb name]
      if {[dict exists $builddict $tb_name]} {
        puts [format "ERROR: Testbench \"%s\" registered twice" $tb_name]
        ex 88
      }
      if {![dict exists $tb extra_build_options]} {
        dict append tb extra_build_options ""
      }
      if {![dict exists $tb extra_run_options]} {
        dict append tb extra_run_options ""
      }
      if {![dict exists $tb symlinks]} {
        dict append tb symlinks ""
      }
      dict set builddict $tb_name "buildcmd" [dict get $tb "extra_build_options"]
      dict set builddict $tb_name "runcmd" [dict get $tb "extra_run_options"]
      dict set builddict $tb_name "symlinks" [dict get $tb "symlinks"]
      dict set builddict $tb_name "builddir" $dir
      if {$debug==1} {
        puts [format "DEBUG: Registering testbench %s" $tb_name]
        puts [format "DEBUG:   buildcmd: %s" [dict get $tb "extra_build_options"]]
        puts [format "DEBUG:   runcmd: %s" [dict get $tb "extra_run_options"]]
        puts [format "DEBUG:   symlinks: %s" [dict get $tb "symlinks"]]
        puts [format "DEBUG:   builddir: %s" $dir]
      }
      lappend testlist_info $tb
    }
  }
  if {[dict exists $yaml_data uvmf_testlist tests]} {
    foreach test [dict get $yaml_data uvmf_testlist tests] {
      if {![dict exists $test testbench] && ![dict exists $test name]} {
        puts [format "ERROR: YAML test entry is invalid, no testbench or name entry found"]
        ex 88
      }
      if {[dict exists $test testbench]} {
        set current_tb [dict get $test testbench]
      }
      if {[dict exists $test name]} {
        # Encountered a new test entry. It will be associated with the last testbench
        # directive encountered, otherwise an error
        set tname [dict get $test name]
        ## Convert dashes to underscores if found
        set tname [string map { - _ } $tname]
        if {$current_tb == ""} {
          puts [format "ERROR: No testbench specified when encountered test \"%s\"" $tname]
          ex 88
        }
        # Remaining items in entry are optional:
        #  repeat count (default 1)
        #  seed list (default random)
        #  uvm testname (default same as test name)
        #  extra arguments (default empty)
        # It is possible that there are already test entries for this test, meaning that
        #  our iteration count doesn't always start at 0. Search the current test case
        #  dictionary for the current name as a first pass to determine our starting iteration
        #  number for this series of entries
        if {![dict exists $tcdict $current_tb $tname]} {
          set firstiter 0
        } else {
          set firstiter [llength [dict keys [dict get $tcdict $current_tb $tname]]]
        }
        if {![dict exists $test repeat]} {
          set repcount 1
        } else {
          set repcount [dict get $test repeat]
        }
        if {![dict exists $test seeds]} {
          set seedlist ""
        } else {
          set seedlist [dict get $test seeds]
        }
        for {set rep 0} {$rep < [expr $repcount]} {incr rep} {
          if {[llength $seedlist] < [expr $repcount]} {
            lappend seedlist [randInt]
          } elseif {[lindex $seedlist $rep] == "random"} {
            lset seedlist $rep [randInt]
          }
        }
        if {![dict exists $test uvm_testname]} {
          set uvm_testname $tname
        } else {
          set uvm_testname [dict get $test uvm_testname]
        }
        if {![dict exists $test extra_args]} {
          set extra_test_options ""
        } else {
          set extra_test_options [dict get $test extra_args]
        }
        foreach seed $seedlist {
          dict set tcdict $current_tb $tname $firstiter seed $seed
          dict set tcdict $current_tb $tname $firstiter extra_args $extra_test_options
          dict set tcdict $current_tb $tname $firstiter uvm_testname $uvm_testname
          incr firstiter
        }
      }
    }
  }
  if {[dict exists $yaml_data uvmf_testlist include]} {
    foreach inc [dict get $yaml_data uvmf_testlist include] {
      ReadYAMLTestlistFile $inc $invoc_dir $collapse $debug $init
    }
  }
  set recursion_check [lrange $recursion_check 0 end-1]
}

proc randInt {} {
  return [expr {int(rand() * 10000000000000000) % 4294967296}]
}

## Top level test list parser invocation.  Sets up some globals and then
## fires off the internal reader (for purposes of nesting)
proc ReadTestlistFile {file_name invoc_dir {collapse 0} {debug 0} {init 0}} {
  global recursion_check
  global tcdict
  global builddict
  global file_read
  global current_tb
  if {$file_read == 1} {
    return ""
  }
  set recursion_check ""
  set tcdict [dict create]
  set builddict [dict create]
  set testlist_info [dict create]
  set current_tb ""
  if {[file extension $file_name] == ".yaml"} {
    ReadYAMLTestlistFile $file_name $invoc_dir $collapse $debug
  } else {
    ReadTestlistFile_int $file_name $invoc_dir $collapse $debug
  }
  if {$debug == 1} {
    print_tcdict
  }
  set file_read 1
  return ""
}

proc print_tcdict {} {
  global tcdict
  puts "DEBUG: tcdict contents:"
  dict for {top testnames} $tcdict {
    puts [format "Testbench : \"%s\"" $top]
    dict for {test iter} $testnames {
      puts [format "\t- Test : \"%s\"" $test]
      foreach i [dict keys $iter] {
        if {[dict get $iter $i extra_args] != ""} {
          set ea_str [format "- Extra Args : \"%s\"" [dict get $iter $i extra_args]]
        } else {
          set ea_str ""
        }
        puts [format "\t\t- %d - UVM Test: %s - Seed : %s %s" $i [dict get $iter $i uvm_testname] [dict get $iter $i seed] $ea_str]
      }
    }
  }
}

proc print_builddict {} {
  global builddict
  if {![info exists builddict]} {
    return
  }
  dict for {buildname entry} $builddict {
    puts [format "%s - %s" $buildname $entry]
  }
}

proc GetMapInfo { build_name key } {
  global builddict
  if {![dict exists $builddict $build_name]} {
    puts [format "ERROR getMapInfo - build %s invalid" $build_name]
    exit
  }
  if {![dict exists $builddict $build_name "mapinfo"]} {
    return ""
  }
  return [dict get $builddict $build_name "mapinfo" $key]
}

# proc process_yaml_test_entry {entry {debug 1}} {
#   global builddict
#   global tcdict
#   global current_tb
#   if {[dict exits $entry testbench]} {
#     set current_tb [dict get $entry testbench]
#     if {$debug} {
#       puts [format "DEBUG: Setting current testbench to %s" $current_tb]
#     }
#   } elseif {$current_tb == ""} {
#     puts [format "ERROR: No testbench setting found before encountering test entries"]
#     ex 88
#   }


# }

proc ex {code} {
  exit $code
}
 
## Actual test list file reader.  See embedded comments for more detail
proc ReadTestlistFile_int {file_name invoc_dir collapse {debug 1} {init 0}} {
  global recursion_check
  global tcdict
  global builddict
  global root_dir
  set tops ""
  ## Elaborate "^" at beginning of $file_name and expand with $root_dir
  regsub -- {^\^} $file_name $root_dir file_name
  ## Derive full path for filename
  set file_name [file normalize $file_name]
  ## Recursion is checked for, i.e. if a test list includes itself
  if {[lsearch $recursion_check $file_name] >= 0} {
    puts [format "ERROR RECURSION : %s" $file_name]
    ex 88
  }
  puts [format "NOTE: Reading testlist file \"%s\"" $file_name]
  lappend recursion_check $file_name
  if {![file isfile $file_name]} {
    puts [format "ERROR INVALID FILE : %s" $file_name]
    ex 88
  }  
  set dir [file dirname $file_name]
  set tfile [open $file_name r]
  while {![eof $tfile]} {
    gets $tfile line
    ## Skip comment lines in testlist file - first column a # sign
    if {[string range $line 0 0] != "#"} {
      ## Skip whitespace
      if {[llength $line] != 0} {
        ##
        ## Process TB_INFO lines, which has information regarding how to
        ## build a particular testbench
        ##
        if {[string match "TB_INFO" [lindex $line 0]]} {
          if {[llength $line] != 4} {
            puts [format "ERROR TB_INFO ARGS : %s" $line]
            ex 88
          }
          dict set builddict [lindex $line 1] "buildcmd" [lindex $line 2]
          dict set builddict [lindex $line 1] "runcmd" [lindex $line 3]
          dict set builddict [lindex $line 1] "symlinks" ""
          dict set builddict [lindex $line 1] "builddir" $dir
          if {$debug==1} {
            puts [format "DEBUG: Registering testbench %s" [lindex $line 1]]
            puts [format "DEBUG:   buildcmd: %s" [lindex $line 2]]
            puts [format "DEBUG:   runcmd: %s" [lindex $line 3]]
            puts [format "DEBUG:   builddir: %s" $dir]
          }
        } elseif {[string match "TB_LOCATION" [lindex $line 0]]} {
          ## Process TB_LOCATION lines which can override the default builddir entry for this bench.
          ## This allows some flexibility into where the test list lives vs. where the bench's ./sim directory
          ## exists, and should be specified when the test list exists outside of the ./sim directory
          if {[llength $line] != 3} {
            puts [format "ERROR TB_LOCATION ARGS : %s" $line]
            ex 88
          }
          if {![info exists builddict] || ![dict exists $builddict [lindex $line 1]]} {
            puts [format "ERROR TB_LOCATION - No TB_INFO entry for %s" [lindex $line 1]]
            print_builddict
            ex 88
          }
          dict set builddict [lindex $line 1] "builddir" [lindex $line 2]
          if {$debug==1} {
            puts [format "DEBUG: Setting builddir for %s as %s" [lindex $line 1] [lindex $line 2]]
          }
        ##
        ## Process TB_MAP lines, which must contain three arguments after the keyword
        ##   The three arguments should be the testbench name, followed by the source hierarchy, then the destination hierarchy
        ##
        } elseif {[string match "TB_MAP" [lindex $line 0]]} {
          if {[llength $line] != 4} {
            puts [format "ERROR TB_MAP ARGS : %s" $line]
          }
          if {![info exists builddict] || ![dict exists $builddict [lindex $line 1]]} {
            puts [format "ERROR TB_MAP - No TB_INFO entry for %s" [lindex $line 1]]
            print_builddict
            ex 88
          }
          set source_hier [split [string trim [lindex $line 2]] "/"]
          set dest_hier [split [string trim [lindex $line 3]] "/" ]
          dict set builddict [lindex $line 1] "mapinfo" "blockpath" [join [lrange $source_hier 0 end-1] "/"]
          dict set builddict [lindex $line 1] "mapinfo" "blockleaf" [lindex $source_hier end]
          dict set builddict [lindex $line 1] "mapinfo" "syspath" [join [lrange $dest_hier 0 end-1] "/"]
          dict set builddict [lindex $line 1] "mapinfo" "sysleaf" [lindex $dest_hier end]
        ##
        ## Process TB lines, which should contain a unique build label
        ##
        } elseif {[string match "TB" [lindex $line 0]]} {
          if {[llength $line] != 2} {
            puts [format "ERROR TB ARGS : %s" $line]
            ex 88
          }
          if {![info exists builddict] || ![dict exists $builddict [lindex $line 1]]} {
            puts [format "ERROR TB - No TB_INFO entry for %s" [lindex $line 1]]
            print_builddict
            ex 88
          }
          set tops [lindex $line 1]
          if {$debug == 1} {
            puts [format "DEBUG: Current top \"%s\"" $tops]
          }
        ##
        ## Process TEST lines, which will be stored according to the last TB seen
        ## Each TEST line contains a test name, a repeat count, and some number of
        ## seeds. Optional last item on a TEST line is a string of additional vsim 
        ## args to be used for just that test.
        ## If the test name contains DASHES those are converted to UNDERSCORES because
        ## the system uses dashes internally
        ##
        } elseif {[string match "TEST" [lindex $line 0]]} {
          if {[llength $tops] == 0} {
            puts [format "ERROR TEST NO TOP SPECIFIED : %s" $line]
            ex 88
          }
          if {[llength $line] == 1} {
            puts [format "ERROR TEST NOT ENOUGH ARGS : %s" $line]
            ex 88
          }
          ## Pull off final extra vsim args if possibly present
          if {[llength $line] > 2} {
            set extra_test_vsim_args [lindex $line end]
            if {![string is integer -strict $extra_test_vsim_args]} {
              ## Last item on the line wasn't a random seed, therefore it is vsim args
              ## Remove item from the list before further processing
              set line [lreplace $line end end]
              if {$debug == 1} {
                puts [format "DEBUG: Detected additional plusarg \"%s\" for test \"%s\"" $extra_test_vsim_args [lindex $line 1]]
              }
            } else {
              set extra_test_vsim_args ""
            }
          } else {
            set extra_test_vsim_args ""
          }
          ## Extract test name from line
          set tname [lindex $line 1]
          ## Convert dashes to underscores if found
          set tname [string map { - _ } $tname]
          ## Store UVM test name as the test name (forward compat)
          set uvm_tname $tname
          ## Extract repeat count from line. If unspecified default to 1
          if {[llength $line] == 2} {
            set repcount 1
          } else {
            set repcount [lindex $line 2]
          }
          ## Extract seeds from line. May contain between 0 and $repcount seeds
          ## If any are unspecified default to internally generated random unless
          ## $collapse is specified in which we ignore the repeat count and fix 
          ## the seed to zero.
          set seedlist ""
          set iterlist ""
          if {$collapse == 0} {
            for {set repeat 0 } {$repeat < [expr $repcount]} {incr repeat } {
              if {[lindex $line [expr $repeat + 3]] == ""} {
                lappend seedlist "[expr {int(rand() * 10000000000000000) % 4294967296}]"
              } else {
                lappend seedlist [lindex $line [expr $repeat + 3]]
              }
              lappend iterlist $repeat
            }
          } else {
            lappend seedlist "0"
            lappend iterlist "0"
          }
          ## Now build up the $tcdict entries for this line
          if {![dict exists $tcdict $tops $tname]} {
            ## First time we've seen this test so create a new entry
            if {$debug == 1} {
              puts [format "DEBUG: Creating initial entry for test \"%s\"" $tname]
            } 
            set firstiter 0
          } else {
            ## Not the first time we've seen this test, figure out where to start
            ## appending more iterations
            set firstiter [llength [dict keys [dict get $tcdict $tops $tname]]]
            if {$debug == 1} {
              puts [format "DEBUG: Adding extra entries starting at %d for test \"%s\"" $firstiter $tname]
            }
          }
          foreach seed $seedlist {
            dict set tcdict $tops $tname $firstiter seed $seed
            dict set tcdict $tops $tname $firstiter extra_args $extra_test_vsim_args
            dict set tcdict $tops $tname $firstiter uvm_testname $uvm_tname
            incr firstiter
          }
          if {$debug == 1} {
            puts [format "DEBUG: Added %d test \"%s\" for build \"%s\"" [llength $seedlist] $tname $tops]
          }
        ##
        ## Process INCLUDE lines, which is another file to parse.  
        ##
        } elseif {[string match "INCLUDE" [lindex $line 0]]} {
          if {$debug == 1} {
            puts [format "DEBUG: Including file %s" [lindex $line 1]]
          }
          ReadTestlistFile_int [lindex $line 1] $invoc_dir $collapse $debug
        }
        ## No check for invalid commands for potential forward-compatibility
      }
    }
  }
  set recursion_check [lrange $recursion_check 0 end-1]
  if {$debug==1} {
    puts [format "DEBUG: Finished with file \"%s\"" $file_name]
    print_builddict
  }
}

## Called by the runnables, returns a list of testbenches to
## build, produces the top-level of runnable hierarchy  
proc GetBuilds {args} {
  global tcdict
  return [dict keys $tcdict]
}
## Called by the runnables, returns the build command unique to
## this particular build.
proc GetBuildCmd {build} {
  global builddict
  return [dict get $builddict $build "buildcmd"]
}

## Called by the runnables, returns the run command for this particular build.
proc GetRunCmd {build} {
  global builddict
  return [dict get $builddict $build "runcmd"]
}

proc GetBuildDir {build} {
  global builddict
  return [dict get $builddict $build "builddir"]
}

## Returns extra arguments for a given test.  The full testname
## is expected to be passed in as per standard format 
## <benchname>-<tesname>-<iter>-<seed> so that'll need to be split
## out in order to extract info from the test case dictionary
proc GetExtraArgs {testname} {
  global tcdict
  set rv [split $testname -]
  return [dict get $tcdict [lindex $rv 0] [lindex $rv 1] [lindex $rv 2] "extra_args"]
}

proc GetUVMTestname {testname} {
  global tcdict
  set rv [split $testname -]
  set ret [dict get $tcdict [lindex $rv 0] [lindex $rv 1] [lindex $rv 2] "uvm_testname"]
  return $ret
}

## Called by the runnables, returns a list of tests to run for
## a specified build.  Format is expected to be as follows:
## <testbench_name>-<testcase_name>-<iteration>-<seed>
proc GetTestcases {build collapse} {
  global tcdict
  set ret ""
  dict for {test test_info} [dict get $tcdict $build] {
    foreach i [dict keys $test_info] {
      lappend ret [format "%s-%s-%s-%s" $build $test $i [dict get $test_info $i seed]]
    }
  }
  return $ret
}
proc FindMVCHome { Makefile_name } {
  if {![file exists $Makefile_name]} {
    return 0
  }
  set matchcnt [llength [fileutil::grep "mvchome" $Makefile_name]]
  return $matchcnt
}

## This will cause all UCDBs to be merged regardless of test status.  Default is to not merge in failing tests.
## If a test does not pass, strip all coverage information except for assertions but include it in the merge.  The
## intent is to ensure that test pass/fail information is maintained but bad tests do not contribute towards
## coverage
proc OkToMerge {userdata} {
  upvar $userdata data
  set passfail $data(passfail)
  set ucdbfile $data(ucdbfile)
  if {![file exists $ucdbfile]} {
    return 0
  }
  if { ![ string match "passed" $passfail ] } {
    exec vsim -c -viewcov $ucdbfile -do "coverage edit -keeponly -assert; coverage save $ucdbfile; quit"
  }
  return 1
}

## This is basically a copy of the stock OkToRerun proc, but it tracks one more thing. If a test has failed
## but the overall number of failed & rerun tests are beyond a user-definable limit ($rerun_limit)
proc OkToRerun {userdata} {
  global rerun_count
  variable rerun_limit
  variable RunOptns
  upvar $userdata data
  # Get the latest reason for failure from the history list
  set reason [lindex $data(HISTORY) end]
  # Queue timeouts, launch failures, and retry requests are
  #   always re-run as-is until they exceed the global limit...
  set alwaysRerun [list \
    [list failed  launch] \
    [list failed  retry]  \
    [list timeout queued] \
  ]
  if {0 <= [lsearch -exact $alwaysRerun $reason]} {
    return 1
  }
  # ...unless disabled, mergeScripts and triageScripts are
  #      always re-run as-is until they exceed the global limit...
  if {[mergeRerun] && (0 <= [lsearch -exact {mergeScript triageScript} $data(ROLE)])} {
    return 1
  }
  # ...other execScript failures are re-run until they've occured twice overall
  #      (a debug message is squawked only if the re-run is suppressed)
  if {[string equal $data(ROLE) execScript]} {
    set action $data(ACTION)
    # Re-run only 1st failure of any given type (to pick up the debug-mode run)
    set samefails [lsearch -all -glob $data(HISTORY) $reason]
    if {[llength $samefails] > 1} {
      if {[isDebug]} {
        logDebug "OkToRerun: Multiple failures, rerun supressed"
      }
      return 0
    }
    # Don't re-run if the DEBUGMODE parameter is undefined or blank
    set debugmode [ExpandRmdbParameters $action "(%DEBUGMODE:%)"]
    if {[string equal $debugmode {}]} {
      if {[isDebug]} {
        logDebug "OkToRerun: No DEBUGMODE parameter, rerun supressed"
      }
      return 0
    }
    # Don't re-run if the DEBUGMODE parameter is already enabled
    if {0 <= [lsearch {yes true 1} $debugmode]} {
      if {[isDebug]} {
        logDebug "OkToRerun: DEBUGMODE parameter already enabled, rerun supressed"
      }
      return 0
    }
    # UVMF - If the current rerun count is equal to the rerun_limit (and rerun_limit)
    # is > 0, don't rerun
    set rerun_limit [getIniVar rerun_limit]
    if {($rerun_limit > 0) && ($rerun_count >= $rerun_limit)} {
      if {[isDebug]} {
        logDebug "OkToRerun: Rerun count reached limit, rerun suppressed"
      }
      return 0
    }
    # Override the DEBUGMODE parameter to indicate an error re-run...
    switch -- $debugmode {
      no {
        OverrideRmdbParameter $action DEBUGMODE yes
      }
      false {
        OverrideRmdbParameter $action DEBUGMODE true
      }
      default {
        OverrideRmdbParameter $action DEBUGMODE 1
      }
    }
    # UVMF - increment the global $rerun_count variable
    incr rerun_count
    # ...then, flag the Action for another run
    return 1
  }
  if {[isDebug]} {
    logDebug "OkToRerun: Not timeout and not execScript, rerun supressed"
  }
  return 0 ;# just in case -- shouldn't reach here
}

proc GetCodeCovBuildString {bcr enable types target} {
  if { $enable } {
    if { $bcr } {
      set str "code_cov_enable:True"
      if { $types != "" } {
        set str [concat $str " code_cov_types:$types"]
      }
      if { $target != "" } {
        set str [concat $str " code_cov_target:$target"]
      }
    } else {
      set str "CODE_COVERAGE_ENABLE=1"
      if { $types != "" } {
        set str [concat $str " CODE_COVERAGE_TYPES=$types"]
      }
      if { $target != "" } {
        set str [concat $str " CODE_COVERAGE_TARGET=$target"]
      }
    }
  } else {
    set str ""
  }
  return $str
}

proc GetCodeCovRunString {bcr enable} {
  if { $enable } {
    if { $bcr } {
      set str "code_cov_enable:True"
    } else {
      set str "-coverage"
    }
  } else {
    set str ""
  }
  return $str
}

# Wave file is only generated if Visualizer is enabled. Furthermore, dump_waves must be set OR we're automatically
# re-running a failed test.  The latter requires that no_rerun is 0 and we're rerunning something (debugmode = 1)
proc GetVisArgs {bcr use_vis dump_waves debugmode no_rerun dump_waves_on_rerun vis_dump_options} {
  if { $use_vis && ( $dump_waves || ( $debugmode && !$no_rerun && $dump_waves_on_rerun ) ) } {
    if { $bcr } {
      return "use_vis:True vis_wave:$vis_dump_options"
    } else {
      return "-qwavedb=$vis_dump_options"  
    }
  } else {
    return ""
  }
}

## This will run at the start of the regression and will bail out IMMEDIATELY if any of the "use_job_mgmt" INI
## variables are set and the "gridtype" variable is not explicitly cleared. This is a workaround for VM-12996
proc RegressionStarting {userdata} {
  upvar $userdata data
  set usingGrid [expr { [getIniVar use_job_mgmt_run] || 
                        [getIniVar use_job_mgmt_build] || 
                        [getIniVar use_job_mgmt_covercheck] || 
                        [getIniVar use_job_mgmt_exclusion] || 
                        [getIniVar use_job_mgmt_report] }]
  set gridtypeIniVar [getIniVar gridtype]
  if {[info exists ::env(UVMF_VRM_INI)]} {
    set iniFile $::env(UVMF_VRM_INI)
  } else {
    set iniFile "./uvmf_vrm_ini.tcl"
  }
  if {$gridtypeIniVar != "" && $usingGrid} {
    puts ""
    puts ""
    puts "**********************************************************************************************************"
    puts "ERROR: Stopping regression at [RightNow] due to setting one of the 'use_job_mgmt' variables in"
    puts "'$iniFile'"
    puts " Please set the 'gridtype' variable the INI file to an empty string and set the gridtype in the RMDB"
    puts " method directly:"
    puts ""
    puts "e.g. change this:"
    puts {  <method if="(%USE_JOB_MGMT_BUILD%)" gridtype="(%GRIDTYPE%)" mintimeout="(%BUILD_QUEUE_TIMEOUT%)">}
    puts "to this:"
    puts {  <method if="(%USE_JOB_MGMT_BUILD%)" gridtype="lsf" mintimeout="(%BUILD_QUEUE_TIMEOUT%)"> <!-- or sge, rtda, etc..-->}
    puts "**********************************************************************************************************"
    puts ""
    puts ""
    ex 88
    #exec $data(VSIMDIR)/vrun -exit -rmdb $data(RMDBFILE) -vrmdata $data(DATADIR)
  }
  puts "Regression started at [RightNow]..."
}

proc GenSymlinks {vrundir taskdir build debug} {
  global builddict
  foreach link [dict get $builddict $build "symlinks"] {
    set target [file normalize [lindex $link 0]]
    set dest [file normalize [format "%s/%s" $taskdir [lindex $link 1]]]
    if {$debug} {
      puts [format "DEBUG: Creating symbolic link %s -> %s" $target $dest]
    }
    file link -symbolic $dest $target
  }
  return "# Generating symbolic links from testlist file"
}