#
# taglog_report.tcl - report procedures for taglog
# Copyright John Lines (john+taglog@paladyn.org) July 2000, October 2005
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_report 0.1

proc doTotalTimeForProjectOK {} {
    #changed by gbarisan@ieee.org to show activities breakdown
global totalprojtimessel_project totalprojtimessel_startdate totalprojtimessel_enddate showtime_format GL_tableFont

toplevel .totalprojtimesres
wm title .totalprojtimesres "[mc {Total Times for}] $totalprojtimessel_project"

frame .totalprojtimesres.main
#text .totalprojtimesres.main.body -height 5
#pack .totalprojtimesres.main.body

set projtotal "00:00"
set firstdate ""
set lastdate ""
set numprojdays 0

set fileslist [dateRangeToLogfileList $totalprojtimessel_startdate $totalprojtimessel_enddate]
set numfileschecked [llength $fileslist]

foreach filename $fileslist {
 set logs [ tag readfile $filename ]
  set logs [ lrange $logs 1 end ]
  set thisproject unknown
  set foundinthisfile 0

 foreach entry $logs {
  set starttime 0
  set endtime 0
  foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if { $tagname == "End" } {
  # Because this is the end tag we should have all the values we are going
  # to get
  if { $thisproject == $totalprojtimessel_project } {
  set duration [timediff $starttime $endtime]
  inctime projtotal $duration
  if {$firstdate==""} {
	set firstdate $filename
  } 
  set lastdate $filename
  if {! $foundinthisfile } {
	set foundinthisfile 1
	incr numprojdays
	} 
   }
  set duration "00:00"
  set thisproject ""
    } elseif { $tagname == "StartTime" } {
   set starttime $tagvalue
  } elseif { $tagname == "EndTime" } {
   set endtime $tagvalue
  } elseif { $tagname == "Project" } {
    set thisproject $tagvalue
  } else {
 }
 }

}

}


########### Calculating the activities breakdown
#added by gbarisan@ieee.org on 2003-11-07
#

set activities {}
set acttotal "00:00"
set actProj ""

foreach filename $fileslist {
    set logs [tag readfile $filename]
    
    foreach entry $logs {
        set starttime 0
        set endtime 0
        set activity unknown
        foreach item $entry {
            
            set tagname [lindex $item 0]
            set tagvalue [lindex $item 1]
            if { $tagname == "End" } then {
                if { $actProj == $totalprojtimessel_project} {
                    set duration [timediff $starttime $endtime]
                    # more to do here
                    inctime acttotal $duration
                    if { [lsearch -exact $activities $activity] == -1 } {
                        lappend activities $activity
                        set acttime($activity) "00:00"
                    }
                    inctime acttime($activity) $duration}
            } elseif { $tagname == "StartTime" } {
                set starttime $tagvalue
            } elseif { $tagname == "EndTime" } {
                set endtime $tagvalue
            } elseif { $tagname == "Activity" } {
                set activity $tagvalue
            } elseif { $tagname == "Project"} {
                set actProj $tagvalue
            } else  {
            }
        }
    }
    
}

set resultheight [expr {[array size acttime] + 12} ]


if { $resultheight > 20 } {
    text .totalprojtimesres.main.body -rel sunk -yscrollcommand ".totalprojtimesres.main.sb set" -height $resultheight \
            -font $GL_tableFont -tabs { 5c left 2c 2c left }
    pack .totalprojtimesres.main.body -in .totalprojtimesres.main -side left -fill y
    scrollbar .totalprojtimesres.main.sb -rel sunk -command ".totalprojtimesres.main.body yview"
    pack .totalprojtimesres.main.sb -in .totalprojtimesres.main -side left -fill y
} else {
    text .totalprojtimesres.main.body -rel sunk -height $resultheight \
            -font $GL_tableFont -tabs { 5c left 2c 2c left }
    pack .totalprojtimesres.main.body -in .totalprojtimesres.main -side left -fill y
}
pack .totalprojtimesres.main

.totalprojtimesres.main.body insert end "[mc {Total time for Project}] '$totalprojtimessel_project' [mc is] "
set saved_format $showtime_format
set showtime_format 2
DisplayTime .totalprojtimesres.main.body projtotal
.totalprojtimesres.main.body insert end " [mc {decimal days}] = "
set showtime_format 0
DisplayTime .totalprojtimesres.main.body projtotal
.totalprojtimesres.main.body insert end " hh:mm\n"
.totalprojtimesres.main.body insert end "[mc Examined] $numfileschecked [mc {files and found entries for}] '$totalprojtimessel_project' in $numprojdays [mc {of them}]\n"

set firstdate [logfilename2date $firstdate]
set lastdate [logfilename2date $lastdate]
.totalprojtimesres.main.body insert end "[mc {First date was}] $firstdate - [mc {last date was}] $lastdate\n\n"

.totalprojtimesres.main.body insert end "[mc Activity]\t[mc {Total time}]\n\n"
foreach act [array names acttime] {
    .totalprojtimesres.main.body insert end "$act\t$acttime($act)\n"
}
.totalprojtimesres.main.body insert end "\t--------\n"
.totalprojtimesres.main.body insert end "\n[mc Total]\t$projtotal\n"


############ end of gbarisan changes

set proj_ExpectedTime [proj_getExpectedTime  $totalprojtimessel_project ]

.totalprojtimesres.main.body insert end "[mc {Total Expected}]\t$proj_ExpectedTime\n"


pack .totalprojtimesres.main
frame .totalprojtimesres.bot
button .totalprojtimesres.bot.ok -text OK -command {doCancel .totalprojtimesres }
pack .totalprojtimesres.bot.ok -in .totalprojtimesres.bot
pack .totalprojtimesres.bot


tkwait window .totalprojtimesres

}

proc TotalTimeForProjectProjSel { project } {
global totalprojtimessel_project totalprojtimessel_startdate totalprojtimessel_enddate
  set totalprojtimessel_project $project
  set totalprojtimessel_startdate [getprojstart $project]
  set totalprojtimessel_enddate [getprojend $project] 
}

proc doTotalTimeForProject { } {
global allproj totalprojtimessel_project

toplevel .totalprojtimes
wm title .totalprojtimes [mc "Enter Project details"]
frame .totalprojtimes.selproj
frame .totalprojtimes.selproj.p
menubutton .totalprojtimes.selproj.p.project -text [mc Project] -menu .totalprojtimes.selproj.p.project.m
menu .totalprojtimes.selproj.p.project.m
.totalprojtimes.selproj.p.project.m add command -label "--" -command "set totalprojtimessel_project \"\""
foreach proj $allproj {
   set pname [tag_entryVal $proj Name] 
  .totalprojtimes.selproj.p.project.m add command -label $pname \
  -command "TotalTimeForProjectProjSel \"$pname\""
} 
entry .totalprojtimes.selproj.p.projectentry -textvariable totalprojtimessel_project -width 20
pack .totalprojtimes.selproj.p.project .totalprojtimes.selproj.p.projectentry -in .totalprojtimes.selproj.p -side left
pack .totalprojtimes.selproj.p

frame .totalprojtimes.selproj.s
menubutton .totalprojtimes.selproj.s.start -text [mc "Start Date"] -menu .totalprojtimes.selproj.s.start.m
menu .totalprojtimes.selproj.s.start.m
# .totalprojtimes.selproj.s.start.m add command -label "--" -command "set totalprojtimessel_startdate xxx"
# .totalprojtimes.selproj.s.start.m add command -label "--" -command "set totalprojtimessel_startdate \"[getprojstart $totalprojtimessel_project\""

#entry .totalprojtimes.selproj.s.startentry -textvariable totalprojtimessel_startdate -width 10
calUtil_win .totalprojtimes.selproj.s.startentry "" totalprojtimessel_startdate
pack .totalprojtimes.selproj.s.start .totalprojtimes.selproj.s.startentry -in .totalprojtimes.selproj.s -side left
pack .totalprojtimes.selproj.s

frame .totalprojtimes.selproj.e
menubutton .totalprojtimes.selproj.e.end -text [mc "End Date"] -menu .totalprojtimes.selproj.e.end.m
menu .totalprojtimes.selproj.e.end.m
calUtil_win .totalprojtimes.selproj.e.endentry "" totalprojtimessel_enddate
pack .totalprojtimes.selproj.e.end .totalprojtimes.selproj.e.endentry -in .totalprojtimes.selproj.e -side left
pack .totalprojtimes.selproj.e

pack .totalprojtimes.selproj

frame .totalprojtimes.bot
button .totalprojtimes.bot.ok -text OK -command doTotalTimeForProjectOK
button .totalprojtimes.bot.cancel -text [mc Cancel] -command { doCancel .totalprojtimes }
pack .totalprojtimes.bot.ok .totalprojtimes.bot.cancel -in .totalprojtimes.bot -side left
pack .totalprojtimes.bot

tkwait window .totalprojtimes

}

proc DisplayTime { window timevar args } {
global showtime_format showtime_hours_per_day
 global tcl_platform
 set mm 0
 set hh 0
 set ss 0

 upvar $timevar time
 if { ! [ info exist time ] } {
  $window insert end "     "
  return
  }

 scan $time "%d:%d:%d" hh mm ss
if { $showtime_format==0 } {
   if { $ss > 30 } { incr mm }
   set showtime [format "%02d:%02d" $hh $mm]
  } elseif { $showtime_format == 1 } {
# set mins [expr { $mm*100/60 } ]
 set mins [expr {round( $mm*100.0/60.0) } ]
   if { $ss > 30 } { incr mm }
 set showtime [format "%02d.%02d" $hh $mins]
 } elseif { $showtime_format == 2 } {
  # show time in decimal days
 set mins [expr { $hh*60 + $mm } ]
 set days [ expr { $mins / ( $showtime_hours_per_day * 60) } ]
 set showtime [ format "%5.2f" $days ] 

 }

if {$args == "bold"} {
 if {$tcl_platform(platform) == "windows"} {
    $window tag configure boldtag -foreground blue
 } else {
    $window tag configure boldtag -font {-weight bold}
 }
 $window insert end "$showtime" boldtag
 } elseif { $args == "bodydata" } {
   $window insert end "$showtime" bodydata
 } else {
$window insert end "$showtime"
}

}

proc displayProject {} {
global showtime_bookbycode


}

proc mailTimeBookingsOK { } {
global mailtb_to


set mailtb_message [string trim [.mailtb.message.body get 1.0 end]]

set timebook_body [string trim [.timebook.main.body get 1.0 end]]

set mailtb_message "$mailtb_message\n\n$timebook_body"

if { $mailtb_to != "" } {
 if { ! [ smtp init ] } {
   # put up a dialog box saying that mail is not initialised
  } else {
  smtp send -subject "Time Bookings report" $mailtb_message $mailtb_to
  }
}  

destroy .mailtb

}


proc mailTimeBookings {} {
global allcontacts

set w .mailtb

toplevel $w
wm title .mailtb [mc "Mail Time Bookings"]

getallcontacts

frame .mailtb.main
menubutton .mailtb.main.l -text [mc "Mail to"] -menu .mailtb.main.l.m
menu .mailtb.main.l.m
.mailtb.main.l.m add command -label "--" -command "set mailtb_to \"\""
foreach contact $allcontacts {
 set thisid ""
 set thisemail ""
  foreach item $contact {
   if { [lindex $item 0] == "Id" } {
     set thisid [lindex $item 1]
    } elseif { [lindex $item 0] == "Email" } {
      set thisemail [lindex $item 1]
    }
 }   
.mailtb.main.l.m add command -label "$thisid" -command "set mailtb_to \"$thisemail\""
}

.mailtb.main.l.m add separator
.mailtb.main.l.m add command -label  [mc "Help"] -command "taghelp mailtb_to"

entry .mailtb.main.v -textvariable mailtb_to -width 20
pack .mailtb.main.l .mailtb.main.v -side left -in .mailtb.main
pack .mailtb.main

frame .mailtb.message
menubutton .mailtb.message.l -text [mc Message] -menu .mailtb.message.l.m
menu .mailtb.message.l.m
$w.message.l.m add command -label [mc Help] -command "taghelp mailtb_message"
text $w.message.body -rel sunk -wrap word -yscrollcommand "$w.message.sb set"
scrollbar .mailtb.message.sb -rel sunk -command ".mailtb.message.body yview"
pack $w.message.l -side left -in $w.message
pack $w.message.body -side right -in $w.message
pack $w.message.sb -fill y -side right -in $w.message
pack $w.message

frame $w.bot
button $w.bot.ok -text Mail -command "mailTimeBookingsOK "
button $w.bot.cancel -text [mc Cancel] -command " doCancel $w "
button $w.bot.help -text [mc Help] -command "taghelp mailtb"
pack $w.bot.ok $w.bot.cancel $w.bot.help -side left -in $w.bot
pack $w.bot

tkwait window $w

}

proc saveTimeBookings {} {
global html_public_dir default_save_timebookings_file timebookings_file_format

set saveas_dir $html_public_dir
set saveas_file ""

if {[info exists default_save_timebookings_file ]} {
   set saveas_dir [file dirname $default_save_timebookings_file]
   set saveas_file [file tail $default_save_timebookings_file]  
}


set tbfile [tk_getSaveFile -title [mc "Save Time Bookings File"] -defaultextension ".csv" -initialdir $saveas_dir -initialfile $saveas_file -filetypes {{{CSV files} {.csv}} { {All files} {*}}}]

if { $tbfile == "" } { return }

set f [ open $tbfile "w"]

if { [info exists timebookings_file_format ] } {
	fconfigure $f -translation $timebookings_file_format
}

# Get the contents of the .timebook.main frame


# set timebook_body [string trim [.timebook.main.body get bodydata.first bodydata.last]]

set i 1.0
set done 0
set timebook_body ""

while { ! $done } {
 set r [ .timebook.main.body tag nextrange bodydata $i]
 if { $r == "" } {
    set done 1
  } else {
  set timebook_this [ .timebook.main.body get [lindex $r 0] [lindex $r 1]]
  set timebook_body "$timebook_body$timebook_this"
  set i [lindex $r 1]
 }
}

# Change tabs to commas
regsub -all \t $timebook_body , timebook_body2

# Change ,, to , 0.0 ,
regsub -all ",," $timebook_body2 ,0.0, timebook_body

# Repeat to catch the ones we miss with only one pass
regsub -all ",," $timebook_body ,0.0, timebook_body2

# Now deal with a trailing comma

regsub -all ,\n $timebook_body2 ,0.0\n timebook_body

# Trim white space

set timebook_body [string trim $timebook_body]
set timebook_body [string trimright $timebook_body \n]

puts $f $timebook_body


close $f

}

proc firstDayOfWeek { weekno year } {
# returns the day number of the first day of week weekno for a particular year

set firstday [clock format [clock scan "1 jan $year"] -format "%w"]
if { $firstday <= 4 } { incr firstday 7 }
set offset [expr { 1- $firstday } ]

return [expr { $weekno*7 + $offset }]
}


proc showTimeBookings {} {
global timebook_year timebook_weekno rootdir showtime_format showtime_spreadoverheads showtime_bookbycode timebook_numweeks
global GL_tableFont

proc getProjectTimes { filename timearray booked_proj } {
# return an array with the project times used during that day.
# Note that timearray is the name of the array.
# The array indices are the real projects used,

upvar $timearray daytimes
upvar $booked_proj booked_projects

  set logs [ tag readfile $filename ]
  set logs [ lrange $logs 1 end ]
  set thisproject unknown

 foreach entry $logs {
  set starttime 0
  set endtime 0
  foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if { $tagname == "End" } {
  # Because this is the end tag we should have all the values we are going
  # to get
  set duration [timediff $starttime $endtime]

  # add the project to booked_projects if we have not seen it before
  if { [lsearch -exact $booked_projects $thisproject ] == -1 } {
	lappend booked_projects $thisproject
##	set projtotals($displayname) "00:00"
    }

 inctime daytimes($thisproject) $duration

 set thisproject unknown
  } elseif { $tagname == "StartTime" } {
   set starttime $tagvalue
  } elseif { $tagname == "EndTime" } {
   set endtime $tagvalue
  } elseif { $tagname == "Project" } {
    set thisproject $tagvalue
  } else {
 }
}  

}

}



toplevel .timebook
wm title .timebook [mc "Time Bookings"]

#######
set newway 0
if { $showtime_spreadoverheads == "byday" } { set newway 1 }

# We wont display errors unless we have to
set display_errors 0
frame .timebook.errors
text .timebook.errors.body -rel sunk -wrap word -yscrollcommand ".timebook.errors.sb set" -height 8
scrollbar .timebook.errors.sb -rel sunk -command ".timebook.errors.body yview"
pack .timebook.errors.body -in .timebook.errors -side right
pack .timebook.errors.sb -in .timebook.errors -side right -fill y


frame .timebook.main
text .timebook.main.body -rel sunk -wrap word -yscrollcommand ".timebook.main.sb set" \
 -font $GL_tableFont \
 -tabs {4.7c left 2c 2c 2c 2c 2c 2c left } \
 -height 20
scrollbar .timebook.main.sb -rel sunk -command ".timebook.main.body yview"
pack .timebook.main.body -in .timebook.main -side right -fill both -expand 1
pack .timebook.main.sb -in .timebook.main -side right -fill y -expand 1

pack .timebook.main -fill both -expand 1

# puts [.timebook.main.body configure]

frame .timebook.bot
button .timebook.bot.ok -text OK -command { doCancel .timebook }
button .timebook.bot.mail -text "Mail..." -command { mailTimeBookings } 
button .timebook.bot.saveas -text [mc "Save As..."] -command { saveTimeBookings }
pack .timebook.bot.ok .timebook.bot.mail .timebook.bot.saveas -side left -in .timebook.bot
pack .timebook.bot

for { set weekinc 0 } { $weekinc < $timebook_numweeks } { incr weekinc } {

# work out which files we need - how do we convert a week number into
# a set of days ?

set thisweek [expr $timebook_weekno + $weekinc]
set startday [firstDayOfWeek $thisweek $timebook_year]


.timebook.main.body insert end "\t\t[mc {Time Bookings for week}] $thisweek [mc of] $timebook_year\n\n"

# initialize totals variables used for this loop

set booked_projects {}
set total_overheads "00:00:00"
set nonbreakstotal "00:00:00"
set breakstotal "00:00:00"
set immutabletotal "00:00:00"


# Clear all the arrays used for totals
if [ info exists projtotals ] {
unset projtotals
}
if [ info exists dayoverheads ] {
unset dayoverheads
}

if [ info exists daytotal ] {
 unset daytotal
}

if [ info exists dayimmutable] {
 unset dayimmutable
}


# Work out the times for all the projects in all the files
set projtotals(empty) "00:00"

for { set day $startday } {$day < [expr { $startday+7}] } { incr day } {
if [ info exists projtimes${day} ] {
unset projtimes${day}
}
# FRINK: nocheck
 set projtimes${day}(empty) "00:00"

 set daytotal($day) "00:00"

# Open the file for this day (if possible)
 set filename1  [ clock format [clock scan "1 jan $timebook_year $day days"] -format "%m%d"]
 set filename "$rootdir/log$timebook_year/$filename1.tag"
 if [file exists $filename] {

 if { $newway } {
###
# for testing
# Clear the thisnames array
  set thisday(empty) "00:00"
  foreach el [array names thisday] { unset thisday($el) }
  getProjectTimes $filename thisday booked_projects
 
  puts "thisday is $day"
  foreach el [array names thisday] {
    puts "thisday($el) = $thisday($el)"
  }
 
# Process thisday array to roll discovered totals into the week totals, also
# spread overheads by day if required.

 foreach el [array names thisday] {

   set duration [timediff "00:00:00" $thisday($el)]
   if { [isbreak $el ]} {
       inctime breakstotal $duration
     } else {
	inctime nonbreakstotal $duration
	inctime daytotal($day) $duration
     }
   if { [isimmutable $el] } {
      inctime immutabletotal $duration
      inctime dayimmutable($day) $duration
      }
   if { [isoverhead $el] } {
      inctime dayoverheads($day) $duration
      inctime totaloverheads $duration
      }
   

 }

# Having been through the whole day - spread overheads by day if required.

if { $showtime_spreadoverheads == "byday" } {
 if { [info exist dayoverheads($day) ] } {
 if { $dayoverheads($day) != "00:00:00" } {
  set secstospread [timediff "00:00:00" $dayoverheads($day)]
  puts "we have overheads on $day of $dayoverheads($day) = $secstospread secs"
  set totalsecs [timediff "00:00" $daytotal($day)]
  set immutablesecs [timediff "00:00" dayimmutable($day)]
  set totalsecs [expr { $totalsecs - $immutablesecs - $secstospread } ]
  puts "we have $totalsecs seconds of todays projects"
  puts "which are [array names thisday]"  

  foreach pr [array names thisday] {
#   puts "looking at project $pr"
   if { [isoverhead $pr] || [isimmutable $pr] || [isbreak $pr ] } {
#     puts "ignore $pr"
   } else {
    set projsecs [timediff "00:00:00" $thisday($pr)]
    set projfraction [expr ($projsecs * 1.0) / $totalsecs]
    puts "Time for $pr was $thisday($pr) - $projsecs - fraction is $projfraction"
    set extratime [ expr { round($projfraction * $secstospread)} ]
    inctime thisday($pr) $extratime
    puts "Add $extratime seconds to $pr - now $thisday($pr)"

# Now convert projects to displayed names, or codes - note that this might
# compress several projects with the same code into one entry

# Deal with different ways to set up the project
 if { $showtime_bookbycode == 0 } {
 set displayname [getprojcode $pr]
 } elseif { $showtime_bookbycode == 1 } {
 set displayname $pr
 } elseif { $showtime_bookbycode == 2 } {
 set displayname [getprojcode $pr]
 set displayname "$displayname ($pr)"
 } else {
    error "showtime_bookbycode has invalid value $showtime_bookbycode"
 }

  # add the project to booked_projects if we have not seen it before
  if { [lsearch -exact $booked_projects $displayname ] == -1 } {
	lappend booked_projects $pr
	set projtotals($displayname) "00:00"
    }

 inctime projtimes${day}($displayname) $duration
 inctime projtotals($displayname) $duration
   }
  }
 # end of foreach pr


  }

}

}
  # End of if showtime_spreadoverheads == byday






 } else {
# Oldway


  set logs [ tag readfile $filename ]
  set logs [ lrange $logs 1 end ]
  set thisproject unknown

 foreach entry $logs {
  set starttime 0
  set endtime 0
  foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if { $tagname == "End" } {
  # Because this is the end tag we should have all the values we are going
  # to get
  set duration [timediff $starttime $endtime]

# Deal with different ways to set up the project
 if { $showtime_bookbycode == 0 } {
 set displayname [getprojcode $thisproject]
 } elseif { $showtime_bookbycode == 1 } {
 set displayname $thisproject
 } elseif { $showtime_bookbycode == 2 } {
 set displayname [getprojcode $thisproject]
 set displayname "$displayname ($thisproject)"
 } else {
    error "showtime_bookbycode has invalid value $showtime_bookbycode"
 }

#  puts "duration is $duration - project is $thisproject day is $day"
# Is is a breaks project ?
  if { [isbreak $thisproject ] } { 
   inctime breakstotal $duration
  } elseif { ( $showtime_spreadoverheads != "off") && ( [isoverhead $thisproject]) } {

 inctime daytotal($day) $duration
 inctime nonbreakstotal $duration
 inctime total_overheads $duration
 inctime dayoverheads($day) $duration
 
  } else { 
  # add the project to booked_projects if we have not seen it before
  if { [lsearch -exact $booked_projects $displayname ] == -1 } {
	lappend booked_projects $displayname
	set projtotals($displayname) "00:00"
    }

 inctime projtimes${day}($displayname) $duration
 inctime projtotals($displayname) $duration
 inctime daytotal($day) $duration
 inctime nonbreakstotal $duration

 if { [isimmutable $thisproject] } {
   inctime immutabletotal $duration
   inctime dayimmutable($day) $duration
   }
  }

 set thisproject unknown
  } elseif { $tagname == "StartTime" } {
   set starttime $tagvalue
  } elseif { $tagname == "EndTime" } {
   set endtime $tagvalue
  } elseif { $tagname == "Project" } {
    set thisproject $tagvalue
  } else {
 }
}  

}


}
# end of oldway



 } else {
   # want to warn if we cant open the file (unless it is Sat or Sun)
 if {[ clock format [clock scan "1 jan $timebook_year $day days"] -format "%u"] <6 } {
 .timebook.errors.body insert end "[mc {Warning - cant open}] $filename\n"
 if { ! $display_errors } {
	pack .timebook.errors -side top
	set display_errors 1
	}
  }
 }

}

if { $showtime_spreadoverheads == "byweek" } {
#puts "Total of overheads is $total_overheads"
# Work through the days, adjusting the times for the non-overheads projects,
# so as to keep the total constant,
# First work out the percentage of the time spent on each non-overheads project.

set totalmins [ timediff "00:00" $nonbreakstotal ]
set overheadmins [ timediff "00:00" $total_overheads ]
set immutablemins [ timediff "00:00" $immutabletotal ]
set totalmins [ expr { $totalmins - $overheadmins - $immutablemins } ]
# puts "Total mins is $totalmins"

foreach thisproject $booked_projects {
 if { ! [isimmutable $thisproject ] } {
# puts "project is $thisproject Total time is $projtotals($thisproject)"
 set projmins [ timediff "00:00" $projtotals($thisproject) ]
# puts "Projmins is $projmins"
 set projfraction($thisproject) [expr { ( $projmins * 1.0)  / $totalmins } ] 
# puts "Fraction of the time spent on this project is $projfraction($thisproject)"
 }

}


 }


# print headers for the different days
.timebook.main.body insert end "[mc Project]\t[mc Total]\t"
for { set day $startday } {$day < [expr {$startday+7} ]} { incr day } {
.timebook.main.body insert end [mc [clock format [clock scan "1 jan $timebook_year $day days"] -format "%a"]]
.timebook.main.body insert end "   \t"
}
.timebook.main.body insert end "\n"
.timebook.main.body insert end "[mc Day]\t "
.timebook.main.body insert end "\t" bodydata
.timebook.main.body insert end "    "
for { set day $startday } {$day < [expr {$startday+7} ]} { incr day } {
.timebook.main.body insert end [clock format [clock scan "1 jan $timebook_year $day days"] -format "%d/%m"] bodydata
if { $day < [expr {$startday+6}]} {
.timebook.main.body insert end " "
.timebook.main.body insert end "\t" bodydata
}
}
.timebook.main.body insert end "\n\n" bodydata



# work through the booked projects
foreach thisproject $booked_projects {
# puts "project is $thisproject Total time is $projtotals($thisproject)"

# write out the projects as constant width
set displayproj [string range $thisproject 0 18]
.timebook.main.body insert end "$displayproj\t" bodydata

for { set day $startday } {$day < [expr {$startday+7}]} { incr day } {
if { ($showtime_spreadoverheads == "byweek") && [ info exists dayoverheads($day)]  } {
 if { ! [isimmutable $thisproject]} {
# redistribute the spare minutes (or seconds now that we work in them)
 set secstospread [timediff "00:00"  $dayoverheads($day)]

 set secsthisproj [ expr { round( $secstospread * $projfraction($thisproject))}]
# puts "We have  $dayoverheads($day) = $minstospread minutes to spread _ $minsthisproj"
 inctime projtimes${day}($thisproject) $secsthisproj
 inctime projtotals($thisproject) $secsthisproj
}

}
}


DisplayTime .timebook.main.body projtotals($thisproject) bold
.timebook.main.body insert end "\t"

for { set day $startday } {$day < [expr {$startday+7}]} { incr day } {
DisplayTime .timebook.main.body projtimes${day}($thisproject) bodydata
if { $day < [expr {$startday+6}]} {
.timebook.main.body insert end " " 
.timebook.main.body insert end "\t" bodydata
}
}

.timebook.main.body insert end "\n" bodydata
}

.timebook.main.body insert end "\n" bodydata
# write the totals for all days
.timebook.main.body insert end "\t"
DisplayTime .timebook.main.body nonbreakstotal bold
.timebook.main.body insert end "\t"
for { set day $startday } {$day < [expr {$startday+7}]} { incr day } {
DisplayTime .timebook.main.body daytotal($day) bold
.timebook.main.body insert end " \t"
}

.timebook.main.body insert end "\n"
.timebook.main.body insert end "[mc {Breaks total}]\t"
DisplayTime .timebook.main.body breakstotal bold
.timebook.main.body insert end "\n"

}


tkwait window .timebook

}


proc doWeeklyTimeBookingsByProject {} {
global year timebook_year timebook_weekno showtime_format showtime_spreadoverheads showtime_bookbycode timebook_numweeks
global timebook_startlastweek
toplevel .timebooksel
wm title .timebooksel [mc "Select Time Period"]

frame .timebooksel.top
menubutton .timebooksel.top.label -text [mc "Time Format"] -menu .timebooksel.top.label.m
menu .timebooksel.top.label.m
.timebooksel.top.label.m add command -label [mc Help] -command "taghelp timebooksel_timeformat"
radiobutton .timebooksel.top.hhmm -text "hh:mm" -relief flat -variable showtime_format -value 0
radiobutton .timebooksel.top.decimalhours -text [mc "Decimal hours"] -relief flat -variable showtime_format -value 1
radiobutton .timebooksel.top.decimaldays -text [mc "Decimal days"] -relief flat -variable showtime_format -value 2

pack .timebooksel.top.label .timebooksel.top.hhmm .timebooksel.top.decimalhours .timebooksel.top.decimaldays -side left -in .timebooksel.top
pack .timebooksel.top

if { $showtime_spreadoverheads == 0 } { set showtime_spreadoverheads off }
if { $showtime_spreadoverheads == 1 } { set showtime_spreadoverheads byweek }


frame .timebooksel.spread_overheads
menubutton .timebooksel.spread_overheads.l -text [mc "Spread overhead projects"] -menu .timebooksel.spread_overheads.l.m
menu .timebooksel.spread_overheads.l.m
.timebooksel.spread_overheads.l.m add command -label [mc Help] -command "taghelp timebooksel_spreadoverheads"
radiobutton .timebooksel.spread_overheads.off -variable showtime_spreadoverheads -value off -text [mc Off]
radiobutton .timebooksel.spread_overheads.byday -variable showtime_spreadoverheads -value byday -text [mc Day] -state disabled
radiobutton .timebooksel.spread_overheads.byweek -variable showtime_spreadoverheads -value byweek -text [mc Week]
pack .timebooksel.spread_overheads.l .timebooksel.spread_overheads.off .timebooksel.spread_overheads.byday .timebooksel.spread_overheads.byweek -in .timebooksel.spread_overheads -side left
pack .timebooksel.spread_overheads
frame .timebooksel.t2
label .timebooksel.t2.bookas -text [mc "Book by Project"]
radiobutton .timebooksel.t2.bookcode -text "Code" -relief flat -variable showtime_bookbycode -value 0
radiobutton .timebooksel.t2.bookname -text "Name" -relief flat -variable showtime_bookbycode -value 1
radiobutton .timebooksel.t2.bookcodename -text "Code+Name" -relief flat -variable showtime_bookbycode -value 2

pack .timebooksel.t2.bookas .timebooksel.t2.bookcode .timebooksel.t2.bookname .timebooksel.t2.bookcodename -in .timebooksel.t2 -side left
pack .timebooksel.t2

set timebook_year $year
frame .timebooksel.m
frame .timebooksel.m.year
menubutton .timebooksel.m.year.l -text [mc Year] -menu .timebooksel.m.year.l.m
menu .timebooksel.m.year.l.m
.timebooksel.m.year.l.m add command -label [mc Help] -command "taghelp timebook_year"
entry .timebooksel.m.year.e -textvariable timebook_year -width 4
pack .timebooksel.m.year.l .timebooksel.m.year.e -in .timebooksel.m.year -side left
bind .timebooksel.m.year.e <KeyRelease> "setWeekRange .timebooksel.wrange"

set timebook_numweeks 1
frame .timebooksel.m.numweeks
entry .timebooksel.m.numweeks.e -textvariable timebook_numweeks -width 1
menubutton .timebooksel.m.numweeks.l -text [mc "weeks"] -menu .timebooksel.m.numweeks.l.m
menu .timebooksel.m.numweeks.l.m
.timebooksel.m.numweeks.l.m add command -label [mc Help] -command "taghelp timebook_numweeks"
pack .timebooksel.m.numweeks.e .timebooksel.m.numweeks.l -in .timebooksel.m.numweeks -side left
bind .timebooksel.m.numweeks.e <KeyRelease> "setWeekRange .timebooksel.wrange"

# we need to trimleft to deal with the week 8 problem (08 is not a valid number)
set timebook_weekno [ string trimleft [ clock format [clock seconds] -format "%W"] 0]
# This will give us null string for week 0 - pick that up as well
if {$timebook_weekno == ""} {set timebook_weekno 0}
# incr timebook_weekno -1
if { ! $timebook_startlastweek } { incr timebook_weekno }
frame .timebooksel.m.week
menubutton .timebooksel.m.week.l -text [mc "starting at number"] -menu .timebooksel.m.week.l.m
menu .timebooksel.m.week.l.m
.timebooksel.m.week.l.m add command -label [mc Help] -command "taghelp timebook_weekno"
button .timebooksel.m.week.minus -text "-"  -command { incr  timebook_weekno -1; setWeekRange .timebooksel.wrange}
entry .timebooksel.m.week.e -textvariable timebook_weekno -width 3
bind .timebooksel.m.week.e <KeyRelease> "setWeekRange .timebooksel.wrange"
button .timebooksel.m.week.plus -text "+" -command { incr timebook_weekno; setWeekRange .timebooksel.wrange}
pack .timebooksel.m.week.l .timebooksel.m.week.minus .timebooksel.m.week.e .timebooksel.m.week.plus -in .timebooksel.m.week -side left


pack .timebooksel.m.year .timebooksel.m.numweeks .timebooksel.m.week -side left -in .timebooksel.m
pack .timebooksel.m

# widget to display the range of days
entry .timebooksel.wrange -width 32 -state disabled -relief groove
pack .timebooksel.wrange -side top
# fill the widget .timebooksel.wrange
setWeekRange .timebooksel.wrange


frame .timebooksel.bot
button .timebooksel.bot.ok -text OK -command showTimeBookings
button .timebooksel.bot.cancel -text [mc Cancel] -command {doCancel .timebooksel}
button .timebooksel.bot.help -text [mc Help] -command "taghelp timebooksel"
pack .timebooksel.bot.ok .timebooksel.bot.cancel .timebooksel.bot.help -in .timebooksel.bot -side left 
pack .timebooksel.bot -side bottom

tkwait window .timebooksel

}

proc doTimeByActivityOK {} {
global timebyact_start timebyact_end
global GL_tableFont

toplevel .tba
wm title .tba [mc "Time by Activity"]

set activities {}
set acttotal "00:00"

set fileslist [dateRangeToLogfileList $timebyact_start $timebyact_end]
foreach filename $fileslist {
 set logs [tag readfile $filename]

 foreach entry $logs {
 set starttime 0
 set endtime 0
 set activity unknown
  foreach item $entry {
   set tagname [lindex $item 0]
   set tagvalue [lindex $item 1]
   if { $tagname == "End" } {
    set duration [timediff $starttime $endtime]
    # more to do here
   inctime acttotal $duration 
   if { [lsearch -exact $activities $activity] == -1 } {
	lappend activities $activity
	set acttime($activity) "00:00"
	}
	inctime acttime($activity) $duration
    } elseif { $tagname == "StartTime" } {
   set starttime $tagvalue
  } elseif { $tagname == "EndTime" } {
   set endtime $tagvalue
  } elseif { $tagname == "Activity" } {
   set activity $tagvalue
  } else {
   } 

}
}

}

set resultheight [expr {[array size acttime] + 3} ]

frame .tba.results

if { $resultheight > 20 } {
 text .tba.results.body -rel sunk -yscrollcommand ".tba.results.sb set" -height $resultheight \
 -font $GL_tableFont -tabs { 5c left 2c 2c left }
 pack .tba.results.body -in .tba.results -side right -fill y
 scrollbar .tba.results.sb -rel sunk -command ".tba.results.body yview"
 pack .tba.results.sb -in .tba.results -side right -fill y
} else {
 text .tba.results.body -rel sunk -height $resultheight \
 -font $GL_tableFont -tabs { 5c left 2c 2c left }
 pack .tba.results.body -in .tba.results -side right -fill y
 }
pack .tba.results

.tba.results.body insert end "[mc Activity]\t[mc {Total time}]\n\n"
foreach act [array names acttime] {
 .tba.results.body insert end "$act\t$acttime($act)\n"
}


frame .tba.bot
button .tba.bot.ok -text OK -command {doCancel .tba }
#button .tba.graph -text Graph -command graphTimeByActivity
pack .tba.bot.ok -in .tba.bot
pack .tba.bot
tkwait window .tba
}



proc doTimeByActivity {} {
global timebyact_start timebyact_end

toplevel .timebyact
wm title .timebyact [mc "Select date range"]
frame .timebyact.start
menubutton .timebyact.start.b -text [mc "Start Date"] -menu .timebyact.start.b.m
menu .timebyact.start.b.m
calUtil_win .timebyact.start.e "" timebyact_start
pack .timebyact.start.b .timebyact.start.e -in .timebyact.start -side left
pack .timebyact.start

frame .timebyact.end
menubutton .timebyact.end.b -text [mc "End Date"] -menu .timebyact.end.b.m
menu .timebyact.end.b.m
calUtil_win .timebyact.end.e "" timebyact_end
pack .timebyact.end.b .timebyact.end.e -in .timebyact.end -side left
pack .timebyact.end

frame .timebyact.bot
button .timebyact.bot.ok -text OK -command doTimeByActivityOK
button .timebyact.bot.cancel -text [mc Cancel] -command { doCancel .timebyact }
pack .timebyact.bot.ok .timebyact.bot.cancel -in .timebyact.bot -side left
pack .timebyact.bot

tkwait window .timebyact

}

proc doProjectProgressReport {} {
global projrepinfosel_project projrepinfosel_start projrepinfosel_end 

toplevel .projrepinfo
wm title .projrepinfo [mc "Enter information for Project Progress Report"]


frame .projrepinfo.selproj
frame .projrepinfo.selproj.p
menubutton .projrepinfo.selproj.p.project -text [mc Project] -menu .projrepinfo.selproj.p.project.m
menu .projrepinfo.selproj.p.project.m
setupProjMenu .projrepinfo.selproj.p.project.m projrepinfosel_project "all" "" 
entry .projrepinfo.selproj.p.projectentry -textvariable projrepinfosel_project -width 20
pack .projrepinfo.selproj.p.project .projrepinfo.selproj.p.projectentry -in .projrepinfo.selproj.p -side left
pack .projrepinfo.selproj.p


pack .projrepinfo.selproj

frame .projrepinfo.start
menubutton .projrepinfo.start.l -text [mc "Start Date"] -menu .projrepinfo.start.l.m
menu .projrepinfo.start.l.m
 set md [clock format [clock scan "last month"] -format "%Y-%m-01"]
.projrepinfo.start.l.m add command -label "$md [mc {Start of last month}]" -command "set projrepinfosel_start $md"


calUtil_win .projrepinfo.start.e "" projrepinfosel_start
pack .projrepinfo.start.l .projrepinfo.start.e -in .projrepinfo.start -side left
pack .projrepinfo.start

frame .projrepinfo.end
menubutton .projrepinfo.end.l -text [mc "End Date"] -menu .projrepinfo.end.l.m
menu .projrepinfo.end.l.m
 set md [clock format [clock seconds] -format "%Y-%m-01"]
.projrepinfo.end.l.m add command -label "$md [mc {Start of this month}]" -command "set projrepinfosel_end $md"

calUtil_win .projrepinfo.end.e "" projrepinfosel_end
pack .projrepinfo.end.l .projrepinfo.end.e -in .projrepinfo.end -side left
pack .projrepinfo.end


frame .projrepinfo.bot
button .projrepinfo.bot.ok -text OK -command { doProjectReportOK $projrepinfosel_project $projrepinfosel_start $projrepinfosel_end }
button .projrepinfo.bot.cancel -text [mc Cancel] -command { doCancel .projrepinfo }
pack .projrepinfo.bot.ok .projrepinfo.bot.cancel -in .projrepinfo.bot -side left
pack .projrepinfo.bot

tkwait window .projrepinfo

}

proc doProjectReportOK { proj start end { mode screen } } {
global allact allactstate
global scrollside
global GL_tableFont
global html_public_dir


if { $mode == "screen" } {
toplevel .projrep
wm title .projrep "[mc {Project Progress Report for}] $proj"
} else {
 set fn [tk_getSaveFile -defaultextension ".html" -initialdir $html_public_dir]
 if { $fn != "" } {
  set f [open $fn w]
  puts $f "<head>"
  puts $f "<title>[mc {Project Progress Report for}] $proj</title>"
 } else {
   return
 }

}

getallact


if { $mode == "screen" } {
frame .projrep.main
text .projrep.main.body -rel sunk -wrap word -yscrollcommand ".projrep.main.sb set" \
 -font $GL_tableFont -tabs { 12c left 3c 3c }
scrollbar .projrep.main.sb -rel sunk -command ".projrep.main.body yview"
pack .projrep.main.body -side $scrollside -in .projrep.main -fill both -expand 1
pack .projrep.main.sb -side $scrollside -fill y -in .projrep.main
pack .projrep.main -fill both -expand 1



frame .projrep.bot
button .projrep.bot.ok -text OK -command { doCancel .projrep }
button .projrep.bot.save -text "[mc {SaveAs Html}]" -command "doProjectReportOK \"$proj\" \"$start\" \"$end\" html"

pack .projrep.bot.ok -side left
pack .projrep.bot.save -side left
pack .projrep.bot

# Now fill the window

.projrep.main.body insert end [mc "Project Progress Report"]\n
.projrep.main.body insert end [mc "Project"]\t$proj\n
.projrep.main.body insert end "[mc {Progress from}] $start[mc { to }]$end\n\n"

.projrep.main.body insert end [mc Achievements]\n
.projrep.main.body insert end [mc "Tasks completed since last report"]\n
.projrep.main.body insert end "[mc Title]\t[mc Expected]\t[mc Actual]\t\n\t[mc Date]\t[mc Date]\n"
} else {
 puts $f "</head><body><h1>[mc "Project Progress Report"]</h1>"
 puts $f "<h2>[mc "Project"]\t$proj</h2>"
 puts $f "[mc {Progress from}] $start[mc { to }]$end <p>"
 puts $f "<h3>[mc Achievements]</h3>"
 puts $f "[mc "Tasks completed since last report"]"
 puts $f "<table><tr><th>[mc Title]</th><th>[mc Expected] [mc Date]</th><th>[mc Actual] [mc Date]</th></tr>"
 }



if { $proj != "" } {
 set test [list Project == $proj]
 lappend tests $test
 set actions [ tag extract $allact $tests ]
 } else {
 set actions $allact
 }


# looking for tasks completed since the last report

foreach entry $actions {

 set test [list Completed-date -later $start]
if [ tag matchcond $entry $test ] {
 set title ""
 set expected_completed_date ""
 set completed_date ""
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $tagname == "Title" } {
	set title $tagvalue
 } elseif { $tagname == "Expected-completed-date" } {
	set expected_completed_date $tagvalue
 } elseif { $tagname == "Completed-date" } {
	set completed_date $tagvalue
 } 

}

 if { $mode == "screen" } {
.projrep.main.body insert end "$title\t$expected_completed_date\t$completed_date\n"
 } else {
 puts $f "<tr><td>$title</td><td>$expected_completed_date</td><td>$completed_date</td></tr>"
 }
}

}

# looking for tasks started since the last report
if { $mode =="screen" } {
.projrep.main.body insert end "\n\n[mc {Tasks started since last report}]\n"
.projrep.main.body insert end "[mc Title]\t[mc Expected]\t[mc Actual]\t\n\t[mc Date]\t[mc Date]\n"
 } else {
 puts $f "</table><h3>[mc {Tasks started since last report}]</h3>"
 puts $f "<table>"
 puts $f "<tr><th>[mc Title]</th><th>[mc Expected] [mc Date]</th><th>[mc Actual] [mc Date]</th></tr>"
}

foreach entry $actions {

 set test [list Active-date -later $start]
if [ tag matchcond $entry $test ] {
 set title ""
 set expected_started_date ""
 set started_date ""
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $tagname == "Title" } {
        set title $tagvalue
 } elseif { $tagname == "Expected-start-date" } {
        set expected_started_date $tagvalue
 } elseif { $tagname == "Active-date" } {
        set started_date $tagvalue
 } 
}

if { $mode == "screen"} {
.projrep.main.body insert end "$title\t$expected_started_date\t$started_date\n"
 } else {
 puts $f "<tr><td>$title</td><td>$expected_started_date</td><td>$started_date</td></tr>"
}

}
}

# looking for tasks slipped since the last report
# - slipped tasks will have a Revised-expected-start-date or a revised-expected-completed-date
# also tasks which are still pending, even though they have reached their
#  expected start date must have slipped.
# Not quite sure how to do this

if { $mode == "screen" } {
.projrep.main.body insert end "\n\n[mc {Tasks slipped since last report}]\n"
.projrep.main.body insert end "[mc Title]\t[mc Expected]\t[mc Actual]\t\n\t[mc Date]\t[mc Date]\n"
} else {
 puts $f "</table>"
 puts $f "<h3>[mc {Tasks slipped since last report}]</h3>"
 puts $f "<table>"
 puts $f "<tr><th>[mc Title]</th><th>[mc Expected] [mc Date]</th><th>[mc Actual] [mc Date]</th></tr>"
}

foreach entry $actions {

 set test [list Active-date -later $start]
if [ tag matchcond $entry $test ] {
 set title ""
 set expected_started_date ""
 set started_date ""
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $tagname == "Title" } {
        set title $tagvalue
 } elseif { $tagname == "Expected-start-date" } {
        set expected_started_date $tagvalue
 } elseif { $tagname == "Active-date" } {
        set started_date $tagvalue
 } 
}

if { $mode == "screen" } {
.projrep.main.body insert end "$title\t$expected_started_date\t$started_date\n"
 } else {
 puts $f "<tr><td>$title</td><td>$expected_started_date</td><td>$started_date</td></tr>"
 }

}
}

# looking for active tasks
if { $mode == "screen" } {
.projrep.main.body insert end "\n\n[mc {Active tasks}]\n"
.projrep.main.body insert end "[mc Title]\t[mc Scheduled]\t[mc Forecast]\t\n\t[mc Completion]\t[mc Completion]\n"
} else {
 puts $f "</table>"
 puts $f "<h3>[mc {Active tasks}]</h3>"
 puts $f "<table>"
 puts $f "<tr><th>[mc Title]</th><th>[mc Scheduled] [mc Completion]</th><th>[mc Forecast] [mc Completion]</th></tr>"

}

foreach entry $actions {

 set test [list Status == Active]
if [ tag matchcond $entry $test ] {
 set title ""
 set expected_completed_date ""
 set started_date ""
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $tagname == "Title" } {
        set title $tagvalue
 } elseif { $tagname == "Expected-completed-date" } {
        set expected_completed_date $tagvalue
 } elseif { $tagname == "Active-date" } {
        set started_date $tagvalue
 } 
}

if { $mode == "screen" } {
.projrep.main.body insert end "$title\t$expected_completed_date\t$started_date\n"
 } else {
 puts $f "<tr><td>$title</td><td>$expected_completed_date</td><td>$started_date</td></tr>"
 }

}
}


if { $mode == "screen" } {
tkwait window .projrep
 } else {

 puts $f "</table>"
 puts $f "</body>"
 close $f

}
 
}
# fills the range of days into the widget $wRange
proc setWeekRange {wRange} {
   global timebook_year timebook_numweeks timebook_weekno
   global dateformat_view


   if {[winfo exists $wRange]} {
      if {![catch {
	 # check year, execute illegal command if year is out of range
	 if {$timebook_year < 1970 || $timebook_year > 2100} {$xxxx}
	 if {$dateformat_view == "DD/MM/YYYY" } {
	    set dForm "%d/%m/%Y"
	    set dLen 30
	 } elseif {$dateformat_view == "MM/DD/YYYY" } {
	    set dForm "%m/%d/%Y"
	    set dLen 30
	 } else {
	    set dForm "%Y-%m-%d"
	    set dLen 32
	 }
	 set startday [firstDayOfWeek $timebook_weekno $timebook_year]
	 set startStr [ clock format \
	  [clock scan "1 jan $timebook_year $startday days"] -format $dForm]
	 set endday [expr {$startday + $timebook_numweeks * 7 - 1}]
	 set endStr [ clock format \
	  [clock scan "1 jan $timebook_year $endday days"] -format $dForm]
	}
      ]} {
      # insert the text
         $wRange configure -state normal -width $dLen
         $wRange delete 0 end
         $wRange insert 0 "[mc Mon] $startStr  ...  [mc Sun] $endStr"
         $wRange configure -state disabled
      }
   }
   return True
}

proc doInterruptionsReport {} {
global intrepask_start intrepask_end

toplevel .intrepask
wm title .intrepask [mc "Interruptions Report setup"]

frame .intrepask.start
menubutton .intrepask.start.b -text [mc "Start Date"] -menu .intrepask.start.b.m
menu .intrepask.start.b.m
calUtil_win .intrepask.start.e "" intrepask_start
pack .intrepask.start.b .intrepask.start.e -in .intrepask.start -side left
pack .intrepask.start

frame .intrepask.end
menubutton .intrepask.end.b -text [mc "End Date"] -menu .intrepask.end.b.m
menu .intrepask.end.b.m
calUtil_win .intrepask.end.e "" intrepask_end
pack .intrepask.end.b .intrepask.end.e -in .intrepask.end -side left
pack .intrepask.end

frame .intrepask.bot
button .intrepask.bot.ok -text OK -command doInterruptionsReportOK
button .intrepask.bot.cancel -text [mc Cancel] -command { doCancel .intrepask }
pack .intrepask.bot.ok .intrepask.bot.cancel -in .intrepask.bot -side left
pack .intrepask.bot

tkwait window .intrepask


}

proc doInterruptionsReportOK {} {
global intrepask_start intrepask_end
global GL_tableFont

toplevel .intrep
wm title .intrep [mc "Interruptions Report"]

set totalInterrupts 0
set numdays 0
set peakipd 0
set fileslist [dateRangeToLogfileList $intrepask_start $intrepask_end]
foreach filename $fileslist {
 set dayInterrupts 0
 incr numdays
 set logs [tag readfile $filename]

 foreach entry $logs {
    foreach item $entry {
     set tagname [lindex $item 0]
     set tagvalue [lindex $item 1]
      if { $tagname == "Stack-info" } {
       if { [string range $tagvalue 0 0] == "!" } {
         incr dayInterrupts
         incr totalInterrupts
         }
       }
   }

}
if { $dayInterrupts > $peakipd } {
  set peakipd $dayInterrupts
  }

}

frame .intrep.results
text .intrep.results.body -rel sunk -height 10 -font $GL_tableFont -tabs { 5c left 2c 2c left }

pack .intrep.results.body -in .intrep.results -side right -fill y
pack .intrep.results


.intrep.results.body insert end "[mc {There were a total of}] $totalInterrupts [mc {interruptions in}] $numdays [mc days.]\n"

set avg [expr $totalInterrupts/$numdays]

.intrep.results.body insert end "[mc {The average number of interruptions in a day was}] $avg\n"
.intrep.results.body insert end "[mc {The peak number of interruptions per day was}] $peakipd\n"

frame .intrep.bot
button .intrep.bot.ok -text OK -command {doCancel .intrep }
pack .intrep.bot.ok -in .intrep.bot
pack .intrep.bot

tkwait window .intrep

}

proc doActiveAndPendingReport {} {
# Report on active and pending actions.
global actsel_project actsel_st_any actsel_st_unclaimed actsel_st_pending actsel_st_active actsel_st_blocked actsel_st_delegated actsel_st_completed actsel_st_aborted actsel_showfields actsel_maxpriority actsel_expected_start actsel_expected_completed actsel_expected_start_test actsel_expected_completed_test actsel_filename actsel_sortby
global actsel_id actsel_title
global actsel_filename actionsfilename

set actsel_project ""
set actsel_st_any 0
set actsel_st_unclaimed 0
set actsel_st_pending 1
set actsel_st_active 1
set actsel_st_blocked 1
set actsel_st_delegated 0
set actsel_st_compeleted 0
set actsel_st_aborted 0
set actsel_showfields(all) 1
set actsel_maxpriority ""
set actsel_expected_start ""
set actsel_expected_completed ""
set actsel_sortby "Priority"
set actsel_id ""
set actsel_title ""
set actsel_filename $actionsfilename

displayActions 

}

proc doActiveActionsReview {} {
global allact activeactions 
global GL_tableFont
global CALIMAGE
global expectedTime expectedCompleted

set w .actrev
toplevel $w
wm title $w [mc "Active Actions Review"]

frame $w.main
text $w.main.body -rel sunk -wrap word -yscrollcommand "$w.main.sb set" -font $GL_tableFont
scrollbar $w.main.sb -rel sunk -command "$w.main.body yview"
pack $w.main.body -side right -in $w.main -fill both -expand 1
pack $w.main.sb -fill y -side right -in $w.main
pack $w.main -expand 1 -fill both

set titlewidth 40

$w.main.body insert end "Title\tTime\tExpected\n\n"

# Note that we need to work with allact as it has all fields
set test [list Status "-in" { Active } ]
lappend tests $test
set sortactiveactions [ tag extract $allact $tests ]

# If an action was added directly as active then it may not have an Active-date
# Set all the field for such actions to the date they were entered.
#
set idx -1
foreach act $sortactiveactions {
 incr idx
if {[tag_entryVal $act Active-date] == "" } {
  set cdate [tag_entryVal $act Date]
  tag setorreplace act Active-date $cdate
  set sortactiveactions [lreplace $sortactiveactions $idx $idx $act]

}

}

for {set i 0} {$i < [llength $activeactions]} {incr i} {
 set actionTime($i) "00:00:00"
}

set sortactiveactions [tag sort $sortactiveactions Active-date -ascii]

set earliestDate [tag_entryVal [lindex $sortactiveactions 0] Active-date]

set fileslist [dateRangeToLogfileList $earliestDate ""]

foreach filename $fileslist {
  set logs [tag readfile $filename]

  foreach entry $logs {
    set entryaction [tag_entryVal $entry Action]
    if {$entryaction != ""} {
       for {set i 0} {$i < [llength $activeactions]} {incr i} {
	if { [lindex [lindex $activeactions $i] 0] == $entryaction } {
           set duration [timediff [tag_entryVal $entry StartTime] [tag_entryVal $entry  EndTime]]
#	  puts "Duration is $duration"
	  inctime actionTime($i) $duration
	  # and set other things for this entry

         }


      }


    }

    }
}

set i 0
foreach action $activeactions {

 set title [format "%*s" $titlewidth [string range [lindex $action 1] 0 $titlewidth]]
 button $w.main.body.title$i -text $title -command "editaction [lindex $action 0]" -width $titlewidth
 $w.main.body window create end -window $w.main.body.title$i
 $w.main.body insert end "$actionTime($i)\t"

 set expectedTime($i) [tag_entryVal [lindex $allact [lindex $action 4]] Expected-time]

 entry $w.main.body.eTime$i -textvariable expectedTime($i) -width 5
  $w.main.body window create end -window $w.main.body.eTime$i

if { $expectedTime($i) != "" } {
if {[expr [timediff $actionTime($i) $expectedTime($i)] < 0] } {
 $w.main.body.eTime$i configure -background coral1 
 }
}

 set expectedCompleted($i) [tag_entryVal [lindex $allact [lindex $action 4]] Expected-completed-date]

 entry $w.main.body.ecDate$i -textvariable expectedCompleted($i) -width 16
 
 button $w.main.body.ecCal$i -bitmap @$CALIMAGE \
   -command "calUtil_open $w.main.body.ecDate$i"

 $w.main.body window create end -window $w.main.body.ecDate$i
 $w.main.body window create end -window $w.main.body.ecCal$i

if { $expectedCompleted($i) != "" } {
 if { [clock scan $expectedCompleted($i)] < [clock seconds] } {
   $w.main.body.ecDate$i configure -background coral1
 }
}


 $w.main.body insert end "\n"
 incr i

}


frame $w.bot
button $w.bot.ok -text OK -command "doActiveActionsReviewOK $w"
button $w.bot.cancel -text [mc Cancel] -command "doCancel $w"
button $w.bot.help -text [mc Help] -command "taghelp activeActionsReview"


pack $w.bot.ok $w.bot.cancel $w.bot.help -in $w.bot -side left
pack $w.bot

tkwait window $w

}

proc doActiveActionsReviewOK { w } {
global allact activeactions 
global expectedTime expectedCompleted


set i 0
foreach action $activeactions {
 set revised 0


if { $expectedTime($i) != [tag_entryVal [lindex $allact [lindex $action 4]] Expected-time]} {
  set revised 1
 }

if { $expectedCompleted($i) != [tag_entryVal [lindex $allact [lindex $action 4]] Expected-completed-date] } {
 set revised 1
 }

if { $revised } {
 doReviseAction [lindex $allact [lindex $action 4]] $expectedCompleted($i) $expectedTime($i) ""

}

incr i
}


doCancel $w
}
