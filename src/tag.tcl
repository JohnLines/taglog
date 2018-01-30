package provide tag 0.1
#
# This defines a set of operations on tag type data files, all accessed
# through one master tag procedure.
#
# This will probably be rewritten as a loadable set of extensions.
#

#	tag open <filename>

#	tag getheader

#	tag getnext
#		returns a list, where each list item is a pair of values,
#		of the form {tagname value}
#		(or for multiline values the items are a triplet of the
#		form {tagname value endlabel}

#
#	tag readfile <filename>
#		returns a list, where each list item is a tag record as
#		above
#
#	tag readselected <filename> <list of tests>
#		reads a file and returns all those entries which match the
#		<list of tests> in a similar maner to doing a
#		'tag readfile' followed by a 'tag extract'
#
#	tag writehtml dlist <filehandle> <taglist> [options]
#		write the taglist to the specified file (appending to it)
#		a list of html elements as a definition list
#
#	tag writehtml tlist <filenhandle> <taglist> [options]
#		write the taglist to the file as two column tables, the
#		first column being the values, and the second being the
#		valuse
#
#	tag writehtml table <filehandle> <taglist> [options]
#		write the taglist to the spedified file (appending to it)
#		as a table. The columns of the table are given by the
#		-fields <fieldslist>  option
#
#	tag sort <list of tagrecords> <fieldname> [options]
#		return a list of tagrecords, sorted in order of the value
#		of fieldname. It tekes the same options as the lsort command
#

proc tag_entryVal { entry attribName } {
# return the value of a given item out of a tag entry
#
#  entry - an entry in a tag file as a TCL list
#  attribName - the name of the attribute to be returned
#
# Based on logEdit_tagVal by Alexander Spanke
   foreach i $entry {
       if {[lindex $i 0] == $attribName} {
        return [lindex $i 1]
      }
   }
   return ""
}
 

proc tag { action args } {

   proc tag__readitem { buffervar indexvar } {
   # Read an item from a buffer which contains a tagged file
   #   buffervar - the name of the buffer to read from
   #    indexvar - the name of the variable containing the index into that
   #            buffer - will be incremented
   # The result is a TCL list of either a label and a value, or a label,
   #   value and endlabel
   #
   upvar $buffervar tagbuf
   upvar $indexvar i

   set l [string length $tagbuf]
  set tagendlabel ""
  set tagname ""
  set tagvalue ""

#   puts "tag__readitem (start) i is $i"
  # Skip leading white space (note requires TCL 8.1.1)
   while { $i < $l && [string is space [string index $tagbuf $i]]} {
      incr i
#       puts "in loop i is $i, tagbuf i is [string index $tagbuf $i]"
 }
#  puts "tag__readline (afterspaces) i is $i"
  # Pick up characters into the label
   set start $i
   while { $i < $l && [ string index $tagbuf $i ] != ":" } { incr i }
   set tagname [string range $tagbuf $start [ expr $i-1]]
   incr i
    
  # We need to know if this was a multiline tag or not
   if {[ string index $tagbuf $i] == ":" } {
#     puts "Multiline tag"
     incr i
     set start $i
       while { $i < $l && [string index $tagbuf $i] != "\n" } { incr i}
       set tagendlabel [string trim [string range $tagbuf $start [expr $i-1]]]
#       puts "Endlabel is $tagendlabel"
       incr start [expr [string length $tagendlabel]+2]
# Now we have the harder task to find the end of this block, by finding the
# endlabel,

    set e [string first "$tagendlabel\n" [string range $tagbuf $i end]]
#     puts "Endlabel found at $e"
     incr i $e
     set tagvalue [string range $tagbuf $start [expr $i-2]]
#     puts "tagvalue is $tagvalue"
     incr i [string length $tagendlabel]
#     puts "buffer pointer is now [string index $tagbuf $i]"
       

   } else {
#     puts "Single line tag"
     if { [string index $tagbuf $i ] == " " } { incr i }
     set start $i
       while { $i < $l && [string index $tagbuf $i] != "\n" } { incr i}
       set tagvalue [string range $tagbuf $start [expr $i-1]]
}
   
# We now have a tagname and value pair - append them to thisentry
  set thispair [list $tagname $tagvalue]
# if there is an endlabel then we ought to append it to thispair
  if { $tagendlabel != "" } {
     lappend thispair $tagendlabel
  }
# puts "thispair is $thispair"

   if { $tagname == "" && $tagvalue == "" } { return "" }

   return $thispair

   }
   
    
    proc tag__readentry { buffervar indexvar } {
#  Read an entry from a buffer which contains a tagged file
#    buffervar - the name of the buffer to read from
#    indexvar - the name of the variable containing the index into that
#               buffer - will be incremented
#  The result is a TCL list of items, as returned by tag__readitem
#
    upvar $buffervar tagbuf
    upvar $indexvar i


set thisentry ""
set endseen 0
 while { !$endseen } {
     set thisitem [tag__readitem tagbuf i]
#     puts "tag__readentry - thisitem is $thisitem, i is $i"
     if { $thisitem == "" } { break }

    if {[llength $thisentry] == 0 } {
    set thisentry [list $thisitem]
  } else {
#  set thisentry [list  $thisentry $thispair]
   lappend thisentry $thisitem
  }
#  puts "thisentry is $thisentry"
 # if the tagname is End then we should append thisentry to the result and
 # clear it
     if {[lindex $thisitem 0] == "End"} {
   set endseen 1
 }
     
  }

 return $thisentry
}

 proc tag__skip2end { buffervar indexvar} {
# Call as tag_skip2end buf index
#  Moves the index variable forward until it is pointing just beyond an End:
#
    upvar $buffervar tagbuf
    upvar $indexvar i

    set e [string first "End:" [string range $tagbuf $i end]]
    incr i $e
    set l [string length $tagbuf]
       while { $i < $l && [string index $tagbuf $i] != "\n" } { incr i}
#    puts "Rest of buffer is [string range $tagbuf $i end]"

}

proc tag__findsorted { filename searchval } {

set h [tag readheader $filename]

set sortkey ""
foreach item $h {
 if {[lindex $item 0] == "Sort-key" } {
    set sortkey [lindex $item 1]
    break
    }
}

set minptr 0
set maxptr [file size $filename]
# bufsize must be large enough to hold the largest record
set bufsize 1000

set f [open $filename]

set lc 0

while { $lc < 10 } {
 set ptr [expr int(($maxptr - $minptr)/2) + $minptr]
 set searchspace [expr $maxptr - $ptr]
 seek $f $ptr
 set buf [read $f $bufsize]

 set i 0
# puts "buf is $buf"
 tag__skip2end buf i
 set start $i
 # Really want a repeat until here - in case the index variable is not the
 # next in the record.
 set thisitem [tag__readitem buf i]
 set thisval [lindex $thisitem 1]
 set t [string compare -nocase $thisval $searchval]
  if { $t== -1 } {
  # too early
      set minptr $ptr
#      puts "Too early - $searchval $thisval look now between $minptr $maxptr ($searchspace)"
#      break
    } elseif { $t == 1 } {
  # Too late
#      puts "ptr is now $ptr"
      set maxptr $ptr
      # set minptr [expr $ptr - $bufsize]
#      if { $minptr <0 } { set minptr 0 }
#      puts "too late - $searchval $thisval look now between $minptr $maxptr ($searchspace)"
   } elseif { $t == 0 } {
  # Found it !
#      puts "Found it !"
      seek $f [expr $ptr + $start]
      set buf [read $f $bufsize]
#      puts "found buf is $buf"
      set i 0
      close $f
      return [tag__readentry buf i]
   } else {
     error "Error - t is $t !!!"
    exit
   }

incr lc
}

 close $f
 return ""

}

proc tag_find { taglist test {startindex 0}} {
# taglist is a list of tag entries
# test is a list of tests
# startindex is the first place to start in the taglist
# - returns the index to where the next matching entry or -1 if not found
#

for {set i $startindex } {$i <= [llength $taglist]} {incr i} {
 set item [lindex $taglist $i]
 if {[tag matchall $item $test ]} {
    return $i
    }
  }
return -1

}

proc tag_findval { taglist field value {startindex 0}} {
# like tag_find, but takes a field and value as a common operation

for {set i $startindex } {$i <= [llength $taglist]} {incr i} {
  set item [lindex $taglist $i]
  if { [tag_entryVal $item $field] == $value } {
	return $i
	}
  }
return -1
}



if { $action == "readfile0" } {
 set result {}
 if { ! [file readable [lindex $args 0]]} {
	return $result
	}
 set f [open [lindex $args 0]]
 # ought to check that it opened OK - if not then return an empty list

# This is not the most efficient way to do it - read the whole file into
# a single variable - then split up that variable - but will work on
# reading it in chunks later
while { ![eof $f]} {
 set tagbuf [read $f]

}
 close $f
set finished 0

set thisentry {}
while { [string length $tagbuf] >0 } {
  set tagendlabel ""
  set tagindex [ string first : $tagbuf ]
#  puts "tagindex is $tagindex"
  incr tagindex -1
  set tagname [ string range $tagbuf 0 $tagindex ]
#  puts "tagname is $tagname"
  incr tagindex 2
  set tagbuf [string range $tagbuf $tagindex end ]
#  puts "tagbuf is now $tagbuf"
  if { [string index $tagbuf 0] == ":" } {
    set tagindex [string first \n $tagbuf ]
    incr tagindex -1
    set tagendlabel [string trimleft [ string range $tagbuf 1 $tagindex ]]
#   puts "tagendlabel is $tagendlabel"
    incr tagindex 2
    set tagbuf [string range $tagbuf $tagindex end]
#    puts "Tagbuf (ML) is $tagbuf"
    set tagindex [string first "$tagendlabel\n" $tagbuf]
#    puts "tagindex is $tagindex"
    incr tagindex -2
    set tagvalue [string range $tagbuf 0 $tagindex]
#    puts "tagvalue is $tagvalue"
    incr tagindex 2
    incr tagindex [string length $tagendlabel]
    set tagbuf [string range $tagbuf $tagindex end ]
  set tagbuf [string trimleft $tagbuf]
#  puts "tagbuf is now $tagbuf"

    } else {
  set tagindex [ string first \n  $tagbuf ]
  incr tagindex -1
#  puts "tagindex is $tagindex"
  set tagvalue [string range $tagbuf 0 $tagindex ]
  set tagvalue [string trimleft $tagvalue]
#  puts "tagvalue is $tagvalue"
  incr tagindex 2
  set tagbuf [string range $tagbuf $tagindex end ]
  set tagbuf [string trimleft $tagbuf]
#  puts "tagbuf is now $tagbuf"
  }

# We now have a tagname and value pair - append them to thisentry
  set thispair [list $tagname $tagvalue]
# if there is an endlabel then we ought to append it to thispair
  if { $tagendlabel != "" } {
     lappend thispair $tagendlabel
  }
# puts "thispair is $thispair"
 if {[llength $thisentry] == 0 } {
  set thisentry [list $thispair]
  } else {
#  set thisentry [list  $thisentry $thispair]
   lappend thisentry $thispair
  }
#  puts "thisentry is $thisentry"
 # if the tagname is End then we should append thisentry to the result and
 # clear it
 if {$tagname == "End"} {
   if {[llength $result] == 0 } {
	set result [list $thisentry]
	} else {
	lappend result $thisentry
	}
#   puts "result is $result"
   set thisentry "" 
  }

}

return $result

} elseif { $action == "readfile" } {
 if { [info tclversion] < 8.2 } {
   return [tag readfile0 [lindex $args 0]]
   }
 set result {}
 if { ! [file readable [lindex $args 0]]} {
	return $result
	}
 set f [open [lindex $args 0]]
 # ought to check that it opened OK - if not then return an empty list

# This is not the most efficient way to do it - read the whole file into
# a single variable - then split up that variable - but will work on
# reading it in chunks later
while { ![eof $f]} {
 set tagbuf [read $f]

}
 close $f

 set tagindex 0
 while { $tagindex < [string length $tagbuf] } {
  set thisentry [tag__readentry tagbuf tagindex]
#  puts "thisentry is $thisentry"
   if {[llength $result] == 0 } {
	set result [list $thisentry]
	} else {
#	puts "Length of thisentry is [llength $thisentry]"
	if {[llength $thisentry] !=0} { lappend result $thisentry }
	}
#   puts "result is $result"
  }
#   puts "result is $result"

  return $result

} elseif { $action == "readheader" } {
 set result {}
 if { ! [file readable [lindex $args 0]]} {
	return $result
	}
 set f [open [lindex $args 0]]
 # ought to check that it opened OK - if not then return an empty list

# Note that we assume the header will be contained in 1000 bytes.

 set headbuf [read $f 1000]

 close $f
set finished 0

set tagindex 0
    return [ tag__readentry headbuf tagindex]

} elseif { $action == "readbuf" } {
# Return a tagged list in internal format from a buffer which contains
# tagged data.

 set result {}
 
# This is not the most efficient way to do it - read the whole file into
# a single variable - then split up that variable - but will work on
# reading it in chunks later
 set inbuf [lindex $args 0]
 upvar $inbuf tagbuf

set finished 0

set thisentry {}
while { [string length $tagbuf] >0 } {
  set tagendlabel ""
  set tagindex [ string first : $tagbuf ]
#  puts "tagindex is $tagindex"
  incr tagindex -1
  set tagname [ string range $tagbuf 0 $tagindex ]
#  puts "tagname is $tagname"
  incr tagindex 2
  set tagbuf [string range $tagbuf $tagindex end ]
#  puts "tagbuf is now $tagbuf"
  if { [string index $tagbuf 0] == ":" } {
    set tagindex [string first \n $tagbuf ]
    incr tagindex -1
    set tagendlabel [string trimleft [ string range $tagbuf 1 $tagindex ]]
#   puts "tagendlabel is $tagendlabel"
    incr tagindex 2
    set tagbuf [string range $tagbuf $tagindex end]
#    puts "Tagbuf (ML) is $tagbuf"
    set tagindex [string first "$tagendlabel\n" $tagbuf]
#    puts "tagindex is $tagindex"
    incr tagindex -2
    set tagvalue [string range $tagbuf 0 $tagindex]
#    puts "tagvalue is $tagvalue"
    incr tagindex 2
    incr tagindex [string length $tagendlabel]
    set tagbuf [string range $tagbuf $tagindex end ]
  set tagbuf [string trimleft $tagbuf]
#  puts "tagbuf is now $tagbuf"

    } else {
  set tagindex [ string first \n  $tagbuf ]
  incr tagindex -1
#  puts "tagindex is $tagindex"
  set tagvalue [string range $tagbuf 0 $tagindex ]
  set tagvalue [string trimleft $tagvalue]
#  puts "tagvalue is $tagvalue"
  incr tagindex 2
  set tagbuf [string range $tagbuf $tagindex end ]
  set tagbuf [string trimleft $tagbuf]
#  puts "tagbuf is now $tagbuf"
  }

# We now have a tagname and value pair - append them to thisentry
  set thispair [list $tagname $tagvalue]
# if there is an endlabel then we ought to append it to thispair
  if { $tagendlabel != "" } {
     lappend thispair $tagendlabel
  }
# puts "thispair is $thispair"
 if {[llength $thisentry] == 0 } {
  set thisentry [list $thispair]
  } else {
#  set thisentry [list  $thisentry $thispair]
   lappend thisentry $thispair
  }
#  puts "thisentry is $thisentry"
 # if the tagname is End then we should append thisentry to the result and
 # clear it
 if {$tagname == "End"} {
   if {[llength $result] == 0 } {
	set result [list $thisentry]
	} else {
	lappend result $thisentry
	}
#   puts "result is $result"
   set thisentry {}
  }

}

return $result

} elseif { $action == "findsorted" } {
#
# tag findsorted tagfile value
#

 return [tag__findsorted [lindex $args 0] [lindex $args 1]]

 


} elseif { $action == "writefile" } {
#
# Write out a whole file 'tag writefile filename list [mode]'
#
set filename [lindex $args 0]
set tlist [lindex $args 1]

set mode [lindex $args 2]
if {$mode == ""} {set mode w}

# puts "tag writefile $filename $tlist"

set f [open $filename $mode]

foreach entry $tlist {
 # the entry should be a list of tag-value pairs (except multiline which have
 # a third element, which is the delimiter
 foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if {[llength $item] == 3 } {
      set delimiter [lindex $item 2]
	puts $f "${tagname}:: $delimiter"
	puts $f $tagvalue
	puts $f $delimiter
	} else {
      puts $f "$tagname: $tagvalue"
	}
   }
 }
close $f

} elseif { $action == "writeentry" } {
# tag writeentry filechannel entry
#
set f [lindex $args 0]
set entry [lindex $args 1]
 foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if {[llength $item] == 3 } {
      set delimiter [lindex $item 2]
	puts $f "${tagname}:: $delimiter"
	puts $f $tagvalue
	puts $f $delimiter
	} else {
      puts $f "$tagname: $tagvalue"
	}
 }

} elseif { $action == "matchcond" } {
# Take a single tag entry and return 1 if it matches the criteria or 0 if not
#

set entry [lindex $args 0 ]
set test [lindex $args 1]

foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]

  set testlabel [lindex $test 0]
  set testop [lindex $test 1]

  if { $testop == "=="} {
    set testvalue [lindex $test 2]
    if { (($testlabel == $tagname) && ($tagvalue == $testvalue ))} {
	return 1
    }
   } elseif { $testop == "!="} {
     set testvalue [lindex $test 2]
    if { (($testlabel == $tagname) && ($tagvalue != $testvalue ))} {
	return 1
	}
   } elseif { $testop == "<="} {
     set testvalue [lindex $test 2]
    if { (($testlabel == $tagname) && ($tagvalue <= $testvalue ))} {
	return 1
	}
   } elseif { $testop == "-in"} {
   # return true if the tagvalue is a member of the list given as the testvalue
      if { $testlabel == $tagname } {
      set testvalue [lindex $test 2]
        foreach listval $testvalue {
		if { $tagvalue == $listval } {
			return 1
		}
	}
	}
   } elseif { $testop == "-contains"} {
   # return true if the tagvalue contains the string given as a testvalue
   # Note - Do not optimise this by an early return if the label is found
   #  but the value does not match, as it could be that the label occurs
   #  more than once (is used that way in taglog_project
   #  for the flags
	if { $testlabel == $tagname } {
	set testvalue [lindex $test 2]
	if { [string match -nocase  *$testvalue* $tagvalue] } {
		return 1
		}
	}
   } elseif { $testop == "-later" } {
	if { $testlabel == $tagname } {
	set testvalue [lindex $test 2]
	if { [clock scan $tagvalue] > [clock scan $testvalue] } {
		return 1
		}
	}
   } elseif {  $testop == "-earlier" } {
	if { $testlabel == $tagname } {
        set testvalue [lindex $test 2]
	if  { [clock scan $tagvalue] < [clock scan $testvalue] } {
                return 1
                }
        }
   } elseif { $testop == "-datebetween"} {
   # return true if the tagvalue (which must be a date) is between the *two*
   #  dates given as testvalues
	if { $testlabel == $tagname } {
	set startdate [lindex $test 2]
	set enddate [lindex $test 3]
	error "Not yet implemented"	


	}
   } elseif { $testop == "-exists"} {
   # return true if the testlabel is found in the current record
#   puts "Exists - checking to see if testlabel $testlabel = tagname $tagname"
   if { $testlabel == $tagname } {
     return 1
   }

   } else {
     error "Invalid operator $testop in tag matchcond"
   }

 }
# We never found what we were looking for
return 0

} elseif { $action == "matchall" } {
# does a tag item match *all* the criteria in a list

set entry [lindex $args 0 ]
set criteria [lindex $args 1]

foreach test $criteria {
   if { ! [ tag matchcond $entry $test ]} {
#       puts "matchall found that $entry did not match $test - returning 0"
	return 0
	}
}
# puts "matchall found that all the criteria matched - returning 1"
   return 1

} elseif { $action == "matchany" } {
# does a tag item match *any* of the creteria in a list of conditions

set entry [lindex $args 0 ]
set criteria [lindex $args 1]

foreach test $criteria {
   if { [ tag matchcond $entry $test ]} {
        return 1
	}
}
return 0


} elseif { $action == "extract" } {
# Takes a list of tag items and returns those which match the criteria in
# the selection list
# i.e. tag extract list list-of-criteria
# where list of criteria is a list of lists of the form { label op [value] }
#

set tlist [lindex $args 0]
set criteria [lindex $args 1]

foreach entry $tlist {

 
 if { [ tag matchall $entry $criteria ] } {
	lappend result $entry
	}
}
if { [info exists result] } {
return $result	
} else {
  return {}
}

} elseif { $action == "replace" } {
# Returns a new value for the entry - call as
#  tag replace entryvar name newvalue
set entryvar [lindex $args 0 ]
set name [lindex $args 1 ]
set newvalue [lindex $args 2 ]

upvar $entryvar entry

set i 0
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $name == $tagname } {
	set newitem [list $tagname $newvalue]
	set entry [ lreplace $entry $i $i $newitem ]
	return 0
     }
 incr i
}
 error "No tag named $name in $entry to replace" 

} elseif {$action == "setorreplace" } {
# tag setorreplace entryvar name newvalue
set entryvar [lindex $args 0 ]
set name [lindex $args 1 ]
set newvalue [lindex $args 2 ]
set endlabel ""
if {[llength $args] == 4 } { set endlabel [lindex $args 3] }

upvar $entryvar entry

if {$endlabel == "" } {
 set newitem [list $name $newvalue]
 } else {
 set newitem [list $name $newvalue $endlabel]
 }

set i 0
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $name == $tagname } {
        set entry [ lreplace $entry $i $i $newitem ]
        return 0
     }
 incr i
}
# we got here and we did not find the tag we wanted - add it to the end
 
 set len [llength $entry]
 incr len -1
 set entry [linsert $entry $len $newitem]
 return 0

} elseif {$action == "setorreplaceflags" } {
# Similar to  setorreplace, but the entryvar points to a set of flags
#  tag setorreplaceflags entryvar name flag value
#  e.g. tag setorrplaceflags proj Flags Active 0
#
#  If value is set to 1 then works like addorreplace and will add a Flags
#   entry set to Active (or not if not needed)
#  If value is set to 0 then remove any Flags entries which only contain
#   the Active value (and later will remove it from comma seperated list)
#
set entryvar [lindex $args 0 ]
set name [lindex $args 1 ]
set flag [lindex $args 2]
set newvalue [lindex $args 3 ]

upvar $entryvar entry

set i 0
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { (( $name == $tagname) && ( $tagvalue == $flag)) } {
     if { $newvalue } {
        # We want the value to exist
           # It already exists - return
           return 0
        } else {
        # We want to take it out if it matches this entry
         set entry [lreplace $entry $i $i]
         return 0
        }
     }
 incr i
}


# we got here and we did not find the tag we wanted - add it to the end
# but only if newvalue is true
if { $newvalue } {
 set newitem [list $name $flag]
 set len [llength $entry]
 incr len -1
 set entry [linsert $entry $len $newitem]
 }
 return 0

} elseif { $action == "update" } {
#
#  tag update filename replacement_entry id_field
#
#  Read a tagged file until we come across one where the id_field in the
#  replacement_entry matches that in the file, replace that entry with
# the replacement - if no match then the file is unchanged. It always
# copies to a file named after the input file with a .tmp suffix, which is
# renamed to the original if the replacemnt succeeds
#
# For now use readfile to read in the whole lot - and not use a temp file

 set filename [lindex $args 0]
 set replacementEntry [lindex $args 1]
 set idField [lindex $args 2]

 foreach item $replacementEntry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if { $tagname == $idField } {
     set idvalue $tagvalue
     }
   }
  
 set tmplist [tag readfile $filename]
 set test [list $idField "==" $idvalue]

set f [open $filename w]
 foreach entry $tmplist {
   if [tag matchcond $entry $test] {
     tag writeentry $f $replacementEntry
   } else {
    tag writeentry $f $entry
  } 
 }
 close $f

} elseif { $action == "readselected" } {

#	tag readselected <filename> <list of tests>
#		reads a file and returns all those entries which match the
#		<list of tests> in a similar maner to doing a
#		'tag readfile' followed by a 'tag extract'
#
# For now we can implement it exactly like that
 set tmplist [tag readfile [lindex $args 0]]
 return [tag extract $tmplist [lindex $args 1]]

} elseif { $action == "writehtml" } {
 set isurlcall ""
 set fieldslist ""
 set hformat [lindex $args 0]
 set f [lindex $args 1]
 set taglist [lindex $args 2]
 
 set n 3
 while { $n < [llength $args] } {
# for now should only be one optional argument - really ned to do this better
  if { [lindex $args $n] == "-isurlcall"} {
	incr n
	set isurlcall [lindex $args $n]
	incr n
     } elseif { [lindex $args $n] == "-fields" } {
       incr n
       set fieldslist [lindex $args $n]
	incr n

  } else {
    error "unknown option [lindex $args $n]"
  }

  }

 if { $hformat == "dlist" } {

 foreach entry $taglist {
  puts $f "<dl id=\"taglist\">"
  foreach item $entry {
  set delimiter ""
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
  if { $tagname != "End" } {
    puts $f "<dt id=\"tagname\">$tagname<dd id=\"tagvalue\">"
    if { [llength $item] == 3 } {
     puts $f "<pre>$tagvalue\n</pre>" 
    } else {
     # only worry about URLs on single lines
     if { $isurlcall != "" } {
	set isurl [$isurlcall $tagname $tagvalue]
	if { $isurl } {
		puts $f "<a href=$tagvalue>$tagvalue</a>"
	} else {
		puts $f "$tagvalue"
		}
	} else {
     puts $f "$tagvalue"
	}
    }
  }
  }
 puts $f "</dl>"
 puts $f "<hr>"
}

} elseif { $hformat == "table" } {




 } else {
  error "bad argument to'tag writehtml' expected dlist or table"
 }

} elseif { $action == "sort" } {
set tags [lindex $args 0]
set indexfield [lindex $args 1]

set listops [lrange $args 2 end] 

# create a temporary list consisting of the values of the sort elements

for { set i 0 } { $i < [llength $tags] } { incr i} {

set entry [lindex $tags $i]

set l [list $i {}]
if { [lsearch $listops "-integer"] >=0 } {
 # Need to make the default value an integer if we do an integer sort
 set l [list $i 0]
}

foreach item $entry {
  if { [lindex $item 0] == $indexfield } {
	set l [list $i [lindex $item 1]]
	break
	}

}
lappend sortlist $l

}

set listcmd [list lsort -index 1 $listops $sortlist]
set sortlist [eval $listcmd]
# work through the sortlist - appending values to the result

for { set i 0 } { $i < [llength $sortlist] } { incr i} {
 set te [lindex $tags [lindex [lindex $sortlist $i] 0 ]]
 lappend result $te

}
return $result

} elseif { $action == "findval" } {
 
 set startindex 0
 if { [llength $args] > 3 } { set startindex [lindex $args 3] }
 
 return [tag_findval [lindex $args 0] [lindex $args 1] [lindex $args 2] $startindex]

} elseif { $action == "find" } {
  set startindex 0
 if { [llength $args] > 2 } { set startindex [lindex $args 2] }
 return [tag_find [lindex $args 0] [lindex $args 1] $startindex] 

} else {
 error "Unknown first argument to tag - must be 'readfile' or 'writefile'"
}


}

