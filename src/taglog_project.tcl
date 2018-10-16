#
# This program gives a combined electronic diary and time clock.
# This module deals with projects - which for taglog purposes are entities
#  to which you book time.
# Copyright John Lines (john+taglog@paladyn.org) January 2003
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_project 0.1

proc proj_testflag { projname flagname } {
# Test if a particular flag is set for a particular project
global allproj 

set test [list Flags "-contains" $flagname]
foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
  if { [tag matchcond $proj $test]} {
	return 1
	} else {
	return 0
	}
  }
}
return 0
}


proc isbreak { projname } {
# return true if the given project is a break project
return [proj_testflag $projname Breaks]
}

proc isoverhead { projname } {
# return true if the give project is an overhead project
return [proj_testflag $projname Overheads] 
}

proc isactive { projname } {
# return true if the give project is an active project
return [proj_testflag $projname Active]
}

proc isimmutable { projname } {
# return true if the given project is immutable
return [proj_testflag $projname Immutable]
}


proc getprojcode { projname } {
# returns the project code asociated with the given project
global allproj

foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
  return [tag_entryVal $proj Code]
  }
}
return ""
}

proc getprojstart { projname } {
global allproj 
foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
   return [tag_entryVal $proj StartDate]
  }
}
return ""
}

proc getprojend { projname } {
global allproj 
foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
   return [tag_entryVal $proj EndDate]
   }
}
return ""
}

proc proj_getExpectedTime { projname } {
global allproj 
foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
   return [tag_entryVal $proj ExpectedTime]
   }
}
return ""
}



proc projclosed { projname } {
 set enddate [getprojend $projname]
if { $enddate != "" } {
 # check the date - there is probably some clever way of doing this with the
 # tcl clock command but they should just compare as strings
 set now [clock format [clock seconds] -format "%Y-%m-%d"]
 if { [string compare $enddate $now] <=0 } {
   return 1
   }
  }
  return 0
} 

proc incprojactindex { projname } {
global allproj 
# increment the current actions index for a project and return the new value 
set n 0
foreach proj $allproj {
if { [tag_entryVal $proj Name] == $projname } {
   set t [tag_entryVal $proj NextActionId]
   if { $t == "" } {
	set t 0
	}
   incr t
   tag setorreplace proj NextActionId $t
   set allproj [lreplace $allproj $n $n $proj]
   writeprojects
   return $t
   }
 incr n
}
return ""
}

proc proj_getDescription { projname } {
global allproj

}

proc proj_setDescription { projname description } {
global allproj


}

proc proj_isImmutable { proj } {
global allproj


return 0
}

proc getProjTimes { files } {
# Read the given files and return a list of  arrays giving the project times for# all the projects, with an extra array (first element ?) with the totals.

set a(unknown) "00:00"
set tot(unknown) "00:00"
set results {}

set index 0
foreach filename $files {
incr index
# FRINK: nocheck
set a$index(unknown) "00:00"

if [file exists $filename] {
# FRINK: nocheck
set tot$index "00:00"
set entries [tag readfile $filename]

foreach entry $entries {
 set starttime 0
 set endtime 0
 set thisproject "unknown"
# The entry should be a list of tag-value pairs
  foreach item $entry {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
  if { $tagname == "End" } {
  # Because this is the end tag we should have all the values we are going
  # to get
  set duration [timediff $starttime $endtime]
  if { [info exists a($thisproject)] } {
      inctime a($thisproject) $duration
     } else {
      set a($thisproject) "00:00"
      inctime a($thisproject) $duration
     }
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
} else {
 # we cant read the file
#FRINK: nocheck
 set tot$index "-"


}

}

return $results
}


proc addProjectOK {} {
global addproject_name addproject_breaks addproject_overheads addproject_bookas addproject_active addproject_immutable addproject_startdate addproject_enddate addproject_expectedtime
global allproj

set endflag 1

set thisproj ""
set thisproj [tagappend $thisproj Name $addproject_name]
set thisproj [tagappend $thisproj NextActionId 1]
set thisproj [tagappend $thisproj Code $addproject_bookas]
set thisproj [tagappend $thisproj StartDate $addproject_startdate]
set thisproj [tagappend $thisproj EndDate $addproject_enddate]
set thisproj [tagappend $thisproj ExpectedTime $addproject_expectedtime]
if { $addproject_overheads } {
  set thisproj [tagappend $thisproj Flags Overheads]
  }
if { $addproject_breaks } {
  set thisproj [tagappend $thisproj Flags Breaks]
  }
if { $addproject_active } {
  set thisproj [tagappend $thisproj Flags Active]
  }
if { $addproject_immutable } {
  set thisproj [tagappend $thisproj Flags Immutable]
 }

if { $endflag } {
 set endpair [list End ]

 lappend thisproj $endpair
}


lappend allproj $thisproj
# Also need to manually add a new projects menu entry
 .currentbar.project.menu add command -label $addproject_name \
	-command "set currentProject \"$addproject_name\""

 writeprojects
destroy .addProject
}

proc inputProjectOK { w mode winnum pindex } {
global projin_f_a allproj

set proj [lindex $allproj $pindex]

 tag setorreplaceflags proj Flags Breaks $projin_f_a($winnum,Breaks)
 tag setorreplaceflags proj Flags Overheads $projin_f_a($winnum,Overheads)
 tag setorreplace proj Code $projin_f_a($winnum,Code)
 tag setorreplace proj StartDate $projin_f_a($winnum,StartDate)
 tag setorreplace proj EndDate $projin_f_a($winnum,EndDate)
 tag setorreplaceflags proj Flags Active $projin_f_a($winnum,Active)
 tag setorreplaceflags proj Flags Immutable $projin_f_a($winnum,Immutable)
 tag setorreplace proj ExpectedTime $projin_f_a($winnum,ExpectedTime)

set allproj [lreplace $allproj $pindex $pindex $proj]

destroy $w

}

proc projInputWindow { mode {winnum 0} {pindex -1} } {
# At present only used to edit a project, but will merge doAddProject
global projin_f_a

set w .inpProj$winnum
toplevel $w
if { $mode == "input" } {
wm title $w [mc "Add Project"]
 } else {
wm title $w "[mc {Edit project}] $projin_f_a($winnum,Name)"
}
wm minsize $w 200 200
 
frame $w.entry
label $w.entry.l -text [mc "Project name"]
entry $w.entry.e -width 20 -textvariable projin_f_a($winnum,Name)
pack $w.entry.l $w.entry.e -side left -in $w.entry
pack $w.entry



frame $w.flags
set addproject_breaks 0
checkbutton $w.flags.breaks -text [mc "Book as breaks"] -variable projin_f_a($winnum,Breaks)
set addproject_overheads 0
checkbutton $w.flags.overheads -text [mc "Book as overheads"] -variable projin_f_a($winnum,Overheads)
set addproject_active 1
checkbutton $w.flags.active -text [mc "Project is active"] -variable projin_f_a($winnum,Active)
set addproject_immutable 0
checkbutton $w.flags.immutable -text [mc "Project is immutable"] -variable projin_f_a($winnum,Immutable)
pack $w.flags.breaks $w.flags.overheads $w.flags.active $w.flags.immutable -in $w.flags
pack $w.flags


frame $w.projcode
label $w.projcode.project -text [mc "Booking Code"]
entry $w.projcode.projentry -width 20 -textvariable projin_f_a($winnum,Code)
pack $w.projcode.project $w.projcode.projentry -in $w.projcode -side left
pack $w.projcode

#set addproject_startdate [clock format [clock seconds] -format "%Y-%m-%d"]
frame $w.start
label $w.start.label -text [mc "Start Date"]
calUtil_win $w.start.e "" projin_f_a($winnum,StartDate)
pack $w.start.label $w.start.e -in $w.start -side left
pack $w.start

frame $w.end
button $w.end.label -text [mc "End Date"] -command "taghelp project_enddate"
calUtil_win $w.end.e "" projin_f_a($winnum,EndDate)
pack $w.end.label $w.end.e -in $w.end -side left
pack $w.end

frame $w.expectedTime
button $w.expectedTime.label -text [mc "Expected-time"] -command "taghelp project_expectedtime"
entry $w.expectedTime.e -width 10 -textvariable projin_f_a($winnum,ExpectedTime)
pack $w.expectedTime.label $w.expectedTime.e -in $w.expectedTime -side left
pack $w.expectedTime


frame $w.bot
button $w.bot.ok -text OK -command "inputProjectOK $w edit $winnum $pindex"
button $w.bot.cancel -text [mc Cancel] -command "doCancel $w"
button $w.bot.help -text [mc Help] -command "taghelp addproject"
pack $w.bot.ok $w.bot.cancel $w.bot.help -in $w.bot -side left
pack $w.bot

tkwait window $w
}


proc doAddProject {} {
global addproject_overheads addproject_breaks addproject_bookas addproject_startdate addproject_enddate addproject_active addproject_immutable addproject_expectedtime

toplevel .addProject
wm title .addProject [mc "Add a new project"]

frame .addProject.entry
label .addProject.entry.l -text [mc "Project name"]
entry .addProject.entry.e -width 20 -textvariable addproject_name
pack .addProject.entry.l .addProject.entry.e -side left -in .addProject.entry
pack .addProject.entry

frame .addProject.flags
set addproject_breaks 0
checkbutton .addProject.flags.breaks -text [mc "Book as breaks"] -variable addproject_breaks
set addproject_overheads 0
checkbutton .addProject.flags.overheads -text [mc "Book as overheads"] -variable addproject_overheads
set addproject_active 1
checkbutton .addProject.flags.active -text [mc "Project is active"] -variable addproject_active
set addproject_immutable 0
checkbutton .addProject.flags.immutable -text [mc "Project is immutable"] -variable addproject_immutable
pack .addProject.flags.breaks .addProject.flags.overheads .addProject.flags.active .addProject.flags.immutable -in .addProject.flags
pack .addProject.flags

frame .addProject.projcode
label .addProject.projcode.project -text [mc "Booking Code"]
entry .addProject.projcode.projentry -width 20 -textvariable addproject_bookas
pack .addProject.projcode.project .addProject.projcode.projentry -in .addProject.projcode -side left
pack .addProject.projcode

set addproject_startdate [clock format [clock seconds] -format "%Y-%m-%d"]
frame .addProject.start
label .addProject.start.label -text [mc "Start Date"]
calUtil_win .addProject.start.e "" addproject_startdate
pack .addProject.start.label .addProject.start.e -in .addProject.start -side left
pack .addProject.start

frame .addProject.end
label .addProject.end.label -text [mc "End Date"]
calUtil_win .addProject.end.e "" addproject_enddate
pack .addProject.end.label .addProject.end.e -in .addProject.end -side left
pack .addProject.end

frame .addProject.expectedTime
button .addProject.expectedTime.label -text [mc "Expected-time"] -command "taghelp project_expectedtime"
entry .addProject.expectedTime.e -width 10 -textvariable addproject_expectedtime
pack .addProject.expectedTime.label .addProject.expectedTime.e -in .addProject.expectedTime -side left
pack .addProject.expectedTime


frame .addProject.bot
button .addProject.bot.ok -text OK -command addProjectOK
button .addProject.bot.cancel -text [mc Cancel] -command {doCancel .addProject }
button .addProject.bot.help -text [mc Help] -command "taghelp addproject"
pack .addProject.bot.ok .addProject.bot.cancel .addProject.bot.help -in .addProject.bot -side left
pack .addProject.bot

tkwait window .addProject
}

proc doEditProjectsOK {} {

global allproj
global epbreaks epoverheads epbookas epdelete epstart epend epactive epimmutable


set n 0
set projindex 0
foreach proj $allproj {

if {$epdelete($n)} {
 set allproj [lreplace $allproj $projindex $projindex]
 incr n
} else {
 
#  The tricky part about the flags is that we do not want to keep
#   adding to them, and we want to be able to unset them too
#

 tag setorreplaceflags proj Flags Breaks $epbreaks($n)
 tag setorreplaceflags proj Flags Overheads $epoverheads($n)
 tag setorreplace proj Code $epbookas($n)
 tag setorreplace proj StartDate $epstart($n)
 tag setorreplace proj EndDate $epend($n)
 tag setorreplaceflags proj Flags Active $epactive($n)
 tag setorreplaceflags proj Flags Immutable $epimmutable($n)
 set allproj [lreplace $allproj $projindex $projindex $proj]

incr n
incr projindex
}
}

#writeprojects_old
writeprojects
destroy .ep
}

proc doEditProj { pname } {
global projin_f_a
global allproj

set winnum 0

set projin_f_a($winnum,Name) $pname
set projin_f_a($winnum,Breaks) [isbreak $pname]
set projin_f_a($winnum,Overheads) [isoverhead $pname]
set projin_f_a($winnum,Active) [isactive $pname]
set projin_f_a($winnum,Immutable) [isimmutable $pname]
set projin_f_a($winnum,Code) [getprojcode $pname]
set projin_f_a($winnum,StartDate) [getprojstart $pname]
set projin_f_a($winnum,EndDate) [getprojend $pname]

set pindex -1
foreach proj $allproj {
 incr pindex
if { [tag_entryVal $proj Name] == $pname } {
   set projin_f_a($winnum,ExpectedTime) [tag_entryVal $proj ExpectedTime]
   break
  }
}


projInputWindow edit $winnum $pindex


}

proc doEditProjects {} {
global allproj
global epbreaks epoverheads epbookas epdelete epstart epend epactive epimmutable

toplevel .ep
wm title .ep [mc "Edit Projects"]
wm minsize .ep 200 200

frame .ep.top
label .ep.top.title -width 20 -text [mc Title]

frame .ep.top.flags
label .ep.top.flags.breaks -text [mc Breaks]
label .ep.top.flags.overheads -text [mc Overheads]
label .ep.top.flags.active -text [mc Active]
label .ep.top.flags.immutable -text [mc Immutable]
pack .ep.top.flags.breaks  -in .ep.top.flags -anchor w
pack .ep.top.flags.overheads -in .ep.top.flags 
pack .ep.top.flags.active -in .ep.top.flags -anchor e
pack .ep.top.flags.immutable -in .ep.top.flags -anchor e

label .ep.top.code -text [mc Code]
label .ep.top.dates -text [mc Dates] -width 45
label .ep.top.delete -text [mc Delete]

pack .ep.top.title .ep.top.flags .ep.top.code .ep.top.dates .ep.top.delete -in .ep.top -side left
pack .ep.top


frame .ep.m -bd 4 -relief sunken
canvas .ep.m.c -yscrollcommand ".ep.m.scroll set" -scrollregion {0 0 0 650} -relief raised -confine false -yscrollincrement 25
scrollbar .ep.m.scroll -command ".ep.m.c yview" -relief raised

pack .ep.m.scroll -side right -fill y
pack .ep.m.c -side left -fill both -expand true

pack .ep.m -fill both -expand 1

set f [frame .ep.m.c.f -bd 0]
.ep.m.c create window 0 0 -anchor nw -window $f



set n 0
foreach proj $allproj {
 set pname [tag_entryVal $proj Name]

frame .ep.m.c.f.p$n
button .ep.m.c.f.p$n.p -text $pname -width 20 -command "doEditProj \"$pname\""  
set epbreaks($n) 0
if { [isbreak $pname] } {
        set epbreaks($n) 1
        }
checkbutton .ep.m.c.f.p$n.breaks -variable epbreaks($n) 

pack .ep.m.c.f.p$n.p -side left
pack .ep.m.c.f.p$n.breaks -side left -fill x

set epoverheads($n) 0
if { [isoverhead $pname] } {
	set epoverheads($n) 1
}
checkbutton .ep.m.c.f.p$n.overheads -variable epoverheads($n)
pack .ep.m.c.f.p$n.overheads -side left -fill x

set epactive($n) 0
if {[isactive $pname] } {
  set epactive($n) 1
}
checkbutton .ep.m.c.f.p$n.active -variable epactive($n)
pack .ep.m.c.f.p$n.active -side left -fill x

set epimmutable($n) 0
if {[isimmutable $pname] } {
  set epimmutable($n) 1
}
checkbutton .ep.m.c.f.p$n.immutable -variable epimmutable($n)
pack .ep.m.c.f.p$n.immutable -side left -fill x

set epbookas($n) [getprojcode $pname]
label .ep.m.c.f.p$n.bookasmenu -text "Code"
pack .ep.m.c.f.p$n.bookasmenu -side left -fill x
entry .ep.m.c.f.p$n.bookas -width 10 -textvariable epbookas($n)
pack .ep.m.c.f.p$n.bookas -side left -fill x


set epstart($n) [getprojstart $pname]
menubutton .ep.m.c.f.p$n.startlab -text [mc "Start"] -menu .ep.m.c.f.p$n.startlab.m
menu .ep.m.c.f.p$n.startlab.m
calUtil_menu .ep.m.c.f.p$n.startlab.m .ep.m.c.f.p$n.starten
pack .ep.m.c.f.p$n.startlab -side left -fill x
entry .ep.m.c.f.p$n.starten -width 10 -textvariable epstart($n)
pack .ep.m.c.f.p$n.starten -side left -fill x

set epend($n) [getprojend $pname]
menubutton .ep.m.c.f.p$n.endlab -text [mc "End "] -menu .ep.m.c.f.p$n.endlab.m
menu .ep.m.c.f.p$n.endlab.m
set todayiso [clock format [clock seconds] -format "%Y-%m-%d"]
set todaydisp [dateiso2disp $todayiso]
.ep.m.c.f.p$n.endlab.m add command -label "[mc Today] ($todaydisp)" -command "set epend($n) $todayiso"
calUtil_menu .ep.m.c.f.p$n.endlab.m .ep.m.c.f.p$n.enden
.ep.m.c.f.p$n.endlab.m add separator
.ep.m.c.f.p$n.endlab.m add command -label [mc Help] -command "taghelp ep_enddate"
pack .ep.m.c.f.p$n.endlab -side left -fill x
entry .ep.m.c.f.p$n.enden -width 10 -textvariable epend($n)
pack .ep.m.c.f.p$n.enden -side left -fill x


set epdelete($n) 0
checkbutton .ep.m.c.f.p$n.delete -text [mc "Delete"] -variable epdelete($n)
pack .ep.m.c.f.p$n.delete -side left -fill x
pack .ep.m.c.f.p$n -side top -fill x

incr n
}

set child [lindex [pack slaves $f] 0]

if { $child != ""} {
tkwait visibility $child
set incr [winfo height $child] 
    set width [winfo width $f]
    set height [winfo height $f]
 .ep.m.c config -scrollregion "0 0 $width $height"
 .ep.m.c config -yscrollincrement $incr
  set epmaxrows 12
    if { $height > $epmaxrows * $incr } {
        set height [expr $epmaxrows * $incr]
} 
.ep.m.c config -width $width -height $height
}


frame .ep.bot
button .ep.bot.ok -text OK -command {doEditProjectsOK}
button .ep.bot.cancel -text [mc Cancel] -command {doCancel .ep}
button .ep.bot.help -text [mc Help] -command "taghelp editproject"
pack .ep.bot.ok .ep.bot.cancel .ep.bot.help -in .ep.bot -side left
pack .ep.bot

tkwait window .ep

}

proc initProjTimes {} {
global projTimes projTimesTotal projTimesTotalNonBreaks
global allproj

set projTimesTotal "00:00"
set projTimesTotalNonBreaks "00:00"


# initialise the projTimes array
foreach proj $allproj {
 set projname [tag_entryVal $proj Name]
 if {[isactive $projname] } {
   if { ![info exists projTimes($projname)] } {
     set projTimes($projname) "00:00"
     }
   }
}

}

proc highlightActiveProjButton { varname index op } {
global projTimes currentProject

for { set i 1 } { $i <= [array size projTimes] } { incr i } {
 if { [winfo exists .projwin.$i.b] } {
 set bn [.projwin.$i.b cget -text]
# puts "bn $i is $bn"
 if { $bn == $currentProject } {
   .projwin.$i.b configure -background yellow
   } else {
   .projwin.$i.b configure -background grey
   }
 }
 }


}

proc doShowProjects {} {
global projTimes projTimesTotal projTimesTotalNonBreaks currentProject

toplevel .projwin
wm title .projwin [mc "Project Times"]

initProjTimes

set projlabelwidth 20
set totallabelwidth [expr $projlabelwidth + 2 ]


 set i 1
# work through projTimes in sorted order
foreach project [lsort [array names projTimes]] {
 frame .projwin.$i
 set projTxt $project
 if {$projTxt == "unknown"} {set projTxt [mc unknown]}
button .projwin.$i.b -text "$projTxt" -width $projlabelwidth -command "donext \"\" \"$project\""
 entry .projwin.$i.e -width 10 -textvariable projTimes($project) -state disabled
 pack .projwin.$i.b .projwin.$i.e -in .projwin.$i -side left
 pack .projwin.$i
 set duration [timediff "00:00:00" $projTimes($project)]
 inctime projTimesTotal $duration
 if { ! [isbreak $project ]} {
     inctime projTimesTotalNonBreaks $duration
     }
 incr i
}

frame .projwin.projtimestotal
label .projwin.projtimestotal.b -text [mc "Total"] -width $totallabelwidth
entry .projwin.projtimestotal.e -textvariable projTimesTotal -state disabled -width 10
pack .projwin.projtimestotal.b .projwin.projtimestotal.e -in .projwin.projtimestotal -side left
pack .projwin.projtimestotal

frame .projwin.projtimestotalnonbreaks
label .projwin.projtimestotalnonbreaks.b -text [mc "Total (non breaks)"] -width $totallabelwidth
entry .projwin.projtimestotalnonbreaks.e -textvariable projTimesTotalNonBreaks -state disabled -width 10
pack .projwin.projtimestotalnonbreaks.b .projwin.projtimestotalnonbreaks.e -in .projwin.projtimestotalnonbreaks -side left
pack .projwin.projtimestotalnonbreaks


frame .projwin.bot
button .projwin.bot.ok -text OK -command {doCancel .projwin}
button .projwin.bot.help -text [mc Help] -command "taghelp viewproject"
pack .projwin.bot.ok .projwin.bot.help -in .projwin.bot -side left
pack .projwin.bot

highlightActiveProjButton currentProject index w

trace variable currentProject w highlightActiveProjButton

tkwait window .projwin

trace vdelete currentProject w highlightActiveProjButton


}

# -- setupProjMenu
#
# Set up a tk menu, which will present a set of projects and allow a variable
#  to be set according to the project which is selected.
#
# Arguments
#   menuname: the name of the menu (e.g. .winname.select.proj
#   varname:  the name of the variable receive the project name
#   projstat: "all" if all projects are to be returned, otherwise "" for
#               active projects only.
#   helpdest: Id of the help entry or "" for no help entry.
#

proc setupProjMenu { menuname varname projstat helpdest } {
global allproj 

$menuname delete 1 end

$menuname add command -label "--" -command "set $varname  \"\""
foreach proj $allproj {
 set pname [tag_entryVal $proj Name]
 if {$pname != ""} {
 if { $projstat == "all" ||  ! [projclosed $pname] } {
 $menuname add command -label $pname \
	-command "set $varname \"$pname\""
}
}
}

if { $helpdest != "" } {
$menuname add separator
$menuname add command -label [mc Help] -command "taghelp $helpdest"
}
}

proc writeprojects {} {
global allproj projectsfilename

 tag writefile $projectsfilename $allproj
}

proc writeprojects_old {} {
global projects projectsfilename
# for now this is more complex than writeactions because we have the projects
# in a tcl list which is not in tagged format.

set f [open $projectsfilename w]

puts $f "Tag-accountproj-version: 1.0"
puts $f "End:"
puts $f ""

foreach proj $projects {
set projname [lindex $proj 0]
puts $f "Name: $projname"
set projnextact [lindex $proj 1]
puts $f "NextActionId: $projnextact"
set projcode [lindex $proj 2]
puts $f "Code: $projcode"
if {[lindex $proj 3] == 1} {
 puts $f "Flags: Overheads"
}
if {[lindex $proj 4] == 1} {
 puts $f "Flags: Breaks"
}
if {[lindex $proj 7]== 1} {
 puts $f "Flags: Active"
}
set projstart [lindex $proj 5]
puts $f "StartDate: $projstart"
set projend [lindex $proj 6]
if { $projend != ""} {
puts $f "EndDate: $projend"
}

puts $f "End:"
}

close $f
}

proc allproj2projects {} {
# transitional routine - set the projects global from the allproj global
global projects allproj

if {[info exists projects] } {
 unset projects
}

# set projects to match allproj for transition
foreach entry $allproj {
 set thisproj_name ""
 set thisproj_actidx 0
 set thisproj_code ""
 set thisproj_isoverhead 0
 set thisproj_isbreak 0
 set thisproj_isactive 0
 set thisproj_start ""
 set thisproj_end ""
 foreach item $entry {
 if {[lindex $item 0 ] == "Name" } { set thisproj_name [lindex $item 1]}
 if {[lindex $item 0 ] == "NextActionId" } { set thisproj_actidx [lindex $item 1]}
 if {[lindex $item 0 ] == "Code" } { set thisproj_code [lindex $item 1]}
 if {[lindex $item 0 ] == "Flags" } {
   if { [string match Overheads [lindex $item 1]]} { set thisproj_isoverhead 1}
   if { [string match Breaks [lindex $item 1]]} { set thisproj_isbreak 1}
   if { [string match Active [lindex $item 1]]} { set thisproj_isactive 1}
   }
 if {[lindex $item 0 ] == "StartDate" } { set thisproj_start [lindex $item 1]}
 if {[lindex $item 0 ] == "EndDate" } { set thisproj_end [lindex $item 1]}
 }

 if { $thisproj_name != ""} {
 set thisproj [list $thisproj_name $thisproj_actidx $thisproj_code $thisproj_isoverhead $thisproj_isbreak $thisproj_start $thisproj_end $thisproj_isactive]
 lappend projects $thisproj
 }
 
 }

# puts "projects is $projects"
# If we have no projects yet we will create an empty list
if { ![info exists projects] } { set projects {} }


}

proc readprojects {} {

global projects projectsfilename allproj
# Note that projects is not in tagged list format, but allproj is.

set allproj [tag readfile $projectsfilename]
if { [ llength $allproj] == 0 } {
  set hdr ""
  set header [list Tag-accountproj-version 1.0]
  lappend hdr $header
  set endpair [list End ]
  lappend hdr $endpair
  lappend  allproj $hdr
  }
# puts "allproj is $allproj"

# projects may have been read in from preferences
# if they have then exit for now
if {[info exists projects] } {
# puts "projects is $projects"
 if { [llength $projects] != 0 } {
 writeprojects_old
 savePrefs
 return
 }
 unset projects
 }

# set projects to match allproj for transition
allproj2projects

}

proc can_get_httprojects {} {
global projects_url
# return true if we can get projects information by http

if { [info tclversion] >= 8.0 } {
 package require http

 if { $projects_url == "" } { return 0 }

 return 1
 }

return 0
}

proc update_projects_ok {} {
global allproj update_projects_allproj

set allproj $update_projects_allproj
allproj2projects
destroy .update_info
}

proc doUpdateProjects {} {
global projects_url allproj update_projects_allproj

toplevel .update_info
wm title .update_info "Projects HTTP update report"
text .update_info.text -width 60 -height 20

frame .update_info.bot
button .update_info.bot.ok -text "OK" -command update_projects_ok
button .update_info.bot.cancel -text "Cancel" -command "destroy .update_info"
button .update_info.bot.help -text "Help" -command "taghelp project_update"
pack .update_info.text
pack .update_info.bot.ok .update_info.bot.cancel .update_info.bot.help -side left -in .update_info.bot
pack .update_info.bot

set p [::http::geturl $projects_url]

set body [::http::data $p]

# 
set newproj [tag readbuf body]

#.update_info.text insert end $newproj

set today [clock format [clock seconds] -format "%Y-%m-%d"]

# Go through allproj and compare to newproj to find projects which
# have been closed - write the info to a global array called update_projects_allproj

foreach proj $allproj {
 set thisproj_name [logEdit_tagVal $proj Name]
 set found 0
 foreach newp $newproj {
   if { [logEdit_tagVal $newp Name] == $thisproj_name } {
    # This project still exists - just copy it across
    lappend update_projects_allproj $proj
    set found 1
    break
    }
  }
 if { !$found } {
  # This project is now closed - set the enddate to today
  # unless the project was already closed
  if { ! [ projclosed $thisproj_name ] } {
  tag setorreplace proj EndDate $today 
  .update_info.text insert end "Closed $thisproj_name\n"
  lappend update_projects_allproj $proj
  }
 }

}

# Go through newproj and find all the projects which are not already in update_projects_allproj
# and add them

foreach newp $newproj {
 set thisproj_name [logEdit_tagVal $newp Name]
 set found 0
   foreach proj $update_projects_allproj {
     if { [logEdit_tagVal $proj Name] == $thisproj_name } {
    # This project has already been found
    set found 1
    break
    }
  }
  if { !$found } {
  # We have a new project - append its details to update_projects_allpoj
     .update_info.text insert end "Added $thisproj_name\n"
    lappend update_projects_allproj $newp
  }
}



tkwait window .update_info
unset update_projects_allproj

}

proc doArchiveProjects {} {
global archiveProjectCloseDate archiveProjectCheckActions archiveProjectFile
global rootdir

toplevel .archiveProject
wm title .archiveProject [mc "Archive old projects"]

frame .archiveProject.closedate
menubutton .archiveProject.closedate.l -text [mc "Archive projects closed before"] -menu .archiveProject.closedate.l.m
menu .archiveProject.closedate.l.m
set todayiso [clock format [clock seconds ] -format "%Y-%m-%d"]
set todaydisp [dateiso2disp $todayiso]
.archiveProject.closedate.l.m add command -label "[mc Today] ($todaydisp)" -command "set archiveProjectCloseDate $todayiso"
pack .archiveProject.closedate.l -side left -fill x
calUtil_win .archiveProject.closedate.d "" archiveProjectCloseDate
pack .archiveProject.closedate.d
.archiveProject.closedate.l.m add separator
.archiveProject.closedate.l.m add command -label [mc Help] -command "taghelp archproj_closedate"
entry .archiveProject.closedate.v -width 10 -textvariable archiveProjectCloseDate
pack .archiveProject.closedate.l -side left -fill x
pack .archiveProject.closedate

set archiveProjectFile "$rootdir/projects-archive-$todayiso.tag"
frame .archiveProject.filename
menubutton .archiveProject.filename.l -text [mc "Archive projects to filename"] -menu .archiveProject.filename.l.m
menu .archiveProject.filename.l.m

entry .archiveProject.filename.v -width 20 -textvariable archiveProjectFile
pack .archiveProject.filename.l .archiveProject.filename.v -side left -fill x
pack .archiveProject.filename


set archiveProjectCheckActions 1
frame .archiveProject.checkActions
checkbutton .archiveProject.checkActions.c -text [mc "Do not archive projects with active or pending actions"] -variable archiveProjectCheckActions
pack .archiveProject.checkActions.c
pack .archiveProject.checkActions


frame .archiveProject.file
# set up the archive file name here - with a widget ?

frame .archiveProject.bot
button .archiveProject.bot.ok -text OK -command {doArchiveProjectsOK}
button .archiveProject.bot.cancel -text [mc Cancel] -command {destroy .archiveProject}
button .archiveProject.bot.help -text [mc Help] -command "taghelp archiveproject"
pack .archiveProject.bot.ok .archiveProject.bot.cancel .archiveProject.bot.help -side left -in .archiveProject.bot
pack .archiveProject.bot

tkwait window .archiveProject

}


proc doArchiveProjectsOK {} {
global archiveProjectCloseDate archiveProjectCheckActions archiveProjectFile
global allproj allact

set needMessageBox 0

# Find all the projects which closed before the close date

set tests ""
set test [list EndDate -earlier $archiveProjectCloseDate]
lappend tests $test

set archiveProjects [lrange $allproj 1 end]
set archiveProjects [tag extract $archiveProjects $tests]

if { $archiveProjectCheckActions } {

foreach action $allact {
# check to see if if is active or pending, then check to see if the project
# is in the archiveProjects. If it is then remove it.

 set st [tag_entryVal $action Status]

 if { $st == "Pending"  ||  $st == "Active" } {
   set prj [tag_entryVal $action Project]

  # Find out if that project is in our list of Projects to archive.

  set i -1
  foreach tproj $archiveProjects {
  incr i
    if { [tag_entryVal $tproj Name] == $prj } {
      if { ! $needMessageBox } {
        set needMessageBox 1
        set messages ""
        }
      set messages "$messages Project $prj removed from archive list as it has Pending or Active actions\n"
      set archiveProjects [lreplace $archiveProjects $i $i]
      break
    }
  }
   }
}
}

if { $needMessageBox } {

tk_messageBox -title [mc "Archive projects notifications"] -message $messages
}


tag writefile $archiveProjectFile $archiveProjects

# remove all the projects which were in archiveProjects from allproj

set i -1
foreach proj $allproj {
 incr i
 set pn [tag_entryVal $proj Name]

  foreach tproj $archiveProjects {
     if { [tag_entryVal $tproj Name] == $pn } {
       set allproj [lreplace $allproj $i $i]
       incr i -1
       break
       }

 }

}
  
writeprojects

}

