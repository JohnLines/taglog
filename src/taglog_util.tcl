
#
# taglog_util.tcl - utility routines for taglog
# Copyright John Lines (john@paladin.demon.co.uk) August 2001
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_util 0.1
 
proc inctime { var duration } {
# increment a time in hh:mm (or just mm) by some time in seconds
upvar $var vtime
global currentTimeFormat
if { ! [ info exist vtime] } {
   set vtime "00:00:00"
   }
 set ss 0
 set hh 0
 set mm 0
 scan $vtime "%d:%d:%d" hh mm ss
 set mins [expr {$hh*60 + $mm} ]
 set secs [expr {$hh*3600 + $mm*60 + $ss}]
 incr mins $duration
 incr secs $duration
 set hh [expr { $secs/3600} ]
 incr secs [ expr {- $hh * 3600} ]
 set mm [ expr { $secs/60} ]
 set ss [ expr { $secs%60} ]
 set vtime [format $currentTimeFormat $hh $mm $ss ]

}

proc timediff { start end } {
# return the time difference in seconds between 2 times specified in hh:mm
 set starth 0
 set startm 0
 set starts 0
 set endh 0
 set endm 0
 set ends 0
 scan $start "%d:%d:%d" starth startm starts
 scan $end "%d:%d:%d" endh endm ends
 set startmins [expr {$starth*60 + $startm}]
 set startsecs [expr {$starth*3600 + $startm*60 + $starts}]
 set endmins [expr { $endh*60 + $endm} ]
 set endsecs [expr {$endh*3600 + $endm*60 + $ends}]
# return [expr $endmins - $startmins]
 return [expr {$endsecs - $startsecs} ]

}

######## dateiso2disp
#  convert an ISO date into the current display format
#
# Arguments:
#   date - the date, in internal format, to be displayed
#
# Results:
#   returns a string containing the date in the format specified
#    by the global variable dateformat_view
#

proc dateiso2disp { date } {
global dateformat_view

scan $date "%d-%d-%d" year mm dd
set mm [format "%02d" $mm]
set dd [format "%02d" $dd]

if { $dateformat_view == "DD/MM/YYYY" } {
 return "$mm/$dd/$year"
 } elseif { $dateformat_view== "MM/DD/YYYY" } {
 return "$dd/$mm/$year"
 } else {
# default to ISO format
  return $date
 }

}


# datedisp2iso


proc datedisp2iso { date }  {
global dateformat_view



}


proc tagappend { taglist tagname tagvalue args } {
# take a list of tagname and value pairs and append the new name and
# value pair if the value part is not empty

 set result $taglist

if { $tagvalue != "" } {
 if { $args != ""} {
   set newpair [list $tagname $tagvalue $args]
   } else {
   set newpair [list $tagname $tagvalue]
  }
 lappend result $newpair


}

return $result

}
# ---------------------- taglog_getList ---------------------------------
# provides a simple list extracted from a complex list stored in a global
# variable
#
# lType	switch for the list to create
#	projAll	provide all project names from list in global variable allproj
#	proj	provide project names from list in global variable allproj,
#		which are not closed
#	actAct	provide actions from the list in global variable activeactions
#	acties	provide activities from the list in global variable activities
#	cont	provide contacts from the list in global variable allcontacts
#
#
# return:	output list or ""
proc taglog_getList {lType} {
   global activeactions
   global activities
   global allcontacts
   global allproj

   switch $lType {
      projAll {
      # all projects
#         foreach i $projects {
#            lappend iList [lindex $i 0]
#         }
          foreach proj $allproj {
	     lappend iList [tag_entryVal $proj Name]
	  }
      }
      proj {
      # projects which are not closed

      # now we return the active projects first by making two passes
      # through the projects list
         foreach proj $allproj {
	    set pname [tag_entryVal $proj Name]
            if { (![projclosed $pname]) && ( [isactive $pname])} {
               lappend iList $pname
               }    
         }
         foreach proj $allproj {
            set pname [tag_entryVal $proj Name]
	    if { (![projclosed $pname]) && ( ![isactive $pname])} {
               lappend iList $pname 
	    }
         }
      }
      cont {
      # contacts
         foreach i $allcontacts {
            set val [tag_entryVal $i Id]
	    if {$val != ""} {
               lappend iList $val
	    }
         }
      }
      actAct {
      # actions
         foreach i $activeactions {
            lappend iList [lindex $i 1]
         }
      }
      # activities
      acties {
         set iList $activities
      }
   }
   if {[info exists iList]} {return $iList}
   return ""
}
# ---------------------- taglog_getMaxMembLen ---------------------------
# provides the maximum string length of members of a global list
#
# lType		type of the global list (see "taglog_getList" for the types)
# minLen	if the max. length is less than minLen, minLen is returned
# limit		If this is not zero then it is the maximum length to return
#
# return:	the maximum string length of members of "minLen"
proc taglog_getMaxMembLen {lType minLen { limit 0 }} {
   set maxLen $minLen
   set lst [taglog_getList $lType]
   foreach i $lst {
      set strLen [string length $i]
      if {$strLen > $maxLen} {set maxLen $strLen}
   }
   if { $limit != 0 } {
     if { $maxLen > $limit} { set maxLen $limit}
   }

   return $maxLen
}


proc dateRangeToLogfileList { startdate enddate } {
global rootdir
# return a list of all the log files which can be found on disk between the
# start and end dates. Either date as null string means first or last available
# (which will include today)

if { $startdate == "" } {
 set startdate "2000-01-01"
 }

if { $enddate == "" } {
 set enddate [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
 }

set result {}

for { set thisdate $startdate } { [clock scan "$thisdate"] <= [clock scan "$enddate"] } { set thisdate [clock format [ clock scan "$thisdate 1 day" ] -format "%Y-%m-%d"] } {

# turn the date into a filename

scan $thisdate "%d-%d-%d" thisyear thismonth thisday
set thismonth [format "%02d" $thismonth]
set thisday [format "%02d" $thisday]

set filename "$rootdir/log$thisyear/$thismonth$thisday.tag"
if [file exists $filename] {
  lappend result $filename
 }
}
return $result
}


