
#
# This program gives a combined electronic diary and time clock.
# Copyright John Lines (john+taglog@paladyn.org) October 2001
#
# This program is released under the terms of the GNU Public Licence
#

package provide mainwin 0.1


proc donext { activity { proj ""} } {
global hh mm ss currentStart currentEnd currentActivity currentProject
global currentAction currentActionTitle currentContact stack_info
global currentTimeFormat
gettime
set currentEnd [format $currentTimeFormat $hh $mm $ss]
set lastId [writelog]
.description.body delete 1.0 end
 # Cleanup variable which should be cleaned at the end
 # always set currentAction to null after write as we are almost certainly
# changing what we do
set currentAction ""
 set currentActionTitle ""
 set currentContact ""
 # If the stack_info was an interupt make it into a normal push after it
# has been written
  if { [string index $stack_info 0] == "!" } {
    set stack_info "+[string range $stack_info 1 end]"
  }

# readlogentries
fillpreventries .preventries.body
gettime
set currentStart [format $currentTimeFormat $hh $mm $ss]
set currentEnd [format $currentTimeFormat $hh $mm $ss]
set currentActivity $activity
if { $proj != "" } { set currentProject $proj }

return $lastId

}

proc dopause {} {
global hh mm ss currentStart currentEnd state
writelog
.description.body delete 1.0 end

set currentStart "pause"
set currentEnd "pause"
set state "paused"
}

proc doresume {} {
global hh mm ss currentStart currentEnd state day month year
global currentTimeFormat

# We need to check on a resume to see if we are now in a different day
# actually we may not need to - I think we can just always close and open
# the log file - it will handle being a new day.
#set prevday $day
#set prevmonth $month
#set prevyear $year
#getdate

# if { ( $prevday == $day ) && ( $prevmonth == $month ) && ( $prevyear == $year ) ) } {
# we are just resuming on the same day - probably dont need to do much

#} else {
# 
closelogfile
openlogfile

#}
set state "running"
gettime
set currentStart [format $currentTimeFormat $hh $mm $ss]
set currentEnd [format $currentTimeFormat $hh $mm $ss]

}


proc doabout {} {
global version

toplevel .aboutBox -class Dialog
wm title .aboutBox "About taglog"
wm iconname .aboutBox Dialog
frame .aboutBox.top -relief raised -bd 1
pack .aboutBox.top -side top -fill both
frame .aboutBox.bot -relief raised -bd 1
pack .aboutBox.bot -side bottom -fill both

message .aboutBox.top.msg -width 4i -text \
 "About Taglog: This is version $version Copyright 2000 John Lines <john+taglog@paladyn.org>\nTaglog is Free Software, released under the terms of the GNU Public License.\nSee https://github.com/JohnLines/taglog/wiki for the taglog home page"

pack .aboutBox.top.msg -side right -expand 1 -fill both -padx 3m -pady 3m

set oldFocus [focus]
button .aboutBox.bot.button -text OK -command "destroy .aboutBox"

pack .aboutBox.bot.button 
grab set .aboutBox
focus .aboutBox

}

proc display_today_actions {} {
global num_today_actions
frame .actions
getactiveactions

for { set i 1 } { $i <= $num_today_actions } { incr i } {
frame .actions.a$i
menu_create .actions.a$i.id [mc Action]$i actreminder 0 actAct menu_setText .actions.a$i.title
entry .actions.a$i.title -width 40 -textvariable actionTitle($i)
pack .actions.a$i.id .actions.a$i.title -in .actions.a$i -side left
pack .actions.a$i -in .actions
}

pack .actions


}

proc setupdisplay {} {
global activities display_prevday activeactions
global allcontacts
global num_today_actions history_win_depth current_win_depth
global version
global month year
global debug
#
# Set up basic display structure
#

frame .mBar -relief raised -bd 2
pack .mBar -side top -fill x

# Create menu buttons and menus

menubutton .mBar.file -text [mc File] -underline 0 -menu .mBar.file.m
menu .mBar.file.m
.mBar.file.m add command -label [mc "Open..."] -underline 0 -command logSelect
.mBar.file.m add command -label [mc "Exit"] -underline 0 -command doexit
.mBar.file.m add command -label [mc "Quit"] -underline 0 -command doquit
.mBar.file.m add command -label [mc "Add/Edit Log"] -underline 0 \
					-command "logEdit_selDay .lgedit"
.mBar.file.m add command -label [mc "Today's Summary"] -underline 0 -command dosummary
.mBar.file.m add command -label [mc "This month's Summary"]  -command "doMonthSummary $month $year"
.mBar.file.m add command -label [mc "This year's Summary"] -command "doYearSummary \"\""
.mBar.file.m add command -label [mc "Other month's Summary"]  -command "pickMonth doMonthSummary"
.mBar.file.m add command -label [mc "Other year's Summary..."] -command "pickYear doYearSummary"
.mBar.file.m add command -label [mc "Pause"] -command dopause
.mBar.file.m add command -label [mc "Resume"] -command doresume
# .mBar.file.m add cascade -label "Refresh" -menu .mBar.file.m.r
#menu .mBar.file.m.r
#.mBar.file.m.r add command -label "Log" -command refreshLog
#.mBar.file.m.r add command -label "Actions" -command refreshActions
.mBar.file.m add command -label [mc Preferences] -command editPrefs
if { $debug } { .mBar.file.m add command -label [mc "Debug"] -command debugWindow }
.mBar.file.m add separator
.mBar.file.m add command -label [mc "Help"] -command "taghelp file"

menubutton .mBar.actions -text [mc Actions] -underline 0 -menu .mBar.actions.m
menu .mBar.actions.m
.mBar.actions.m add command -label [mc "Add..."] -underline 0 -command "actionInputWindow input"
.mBar.actions.m add command -label [mc "View"] -underline 0 -command { actSelect displayActions }
.mBar.actions.m add command -label [mc "History"] -underline 0 -command { actSelect displayHistory }
.mBar.actions.m add command -label [mc "Complete"] -command { doNewState Active Completed }
.mBar.actions.m add command -label [mc "Activate"] -command { doNewState Pending Active }
.mBar.actions.m add command -label [mc "Abort Active"] -command { doNewState Active Aborted }
.mBar.actions.m add command -label [mc "Abort Pending"] -command { doNewState Pending Aborted }
.mBar.actions.m add command -label [mc "Reactivate"] -command { doNewState Completed Active }
.mBar.actions.m add cascade -label [mc "Extra..."] -menu .mBar.actions.m.e
menu .mBar.actions.m.e
.mBar.actions.m.e add command -label [mc "Refresh Active"] -command setactionsmenu
.mBar.actions.m.e add command -label [mc "Active Time Blocked"] -command activate_timeblocked
.mBar.actions.m.e add command -label [mc "Archive Old Actions"] -command archiveOldActions
.mBar.actions.m.e add command -label [mc "Update All Subtasks"] -command Update_all_subtasks

.mBar.actions.m add separator
.mBar.actions.m add command -label [mc "Help"] -command "taghelp actions"


menubutton .mBar.projects -text [mc Projects] -underline 0 -menu .mBar.projects.m
menu .mBar.projects.m
.mBar.projects.m add command -label [mc Add] -underline 0 -command doAddProject
.mBar.projects.m add command -label [mc Edit] -underline 0 -command doEditProjects
.mBar.projects.m add command -label [mc "Update"] -underline 0 -command doUpdateProjects -state disabled
if { [can_get_httprojects] } {
.mBar.projects.m entryconfigure 3 -state normal
}
.mBar.projects.m add command -label [mc "View"] -underline 0 -command doShowProjects
.mBar.projects.m add command -label [mc "Archive"] -underline 0 -command doArchiveProjects
.mBar.projects.m add separator
.mBar.projects.m add command -label [mc "Help"] -command "taghelp projects"

menubutton .mBar.reports -text [mc Reports] -underline 0 -menu .mBar.reports.m
menu .mBar.reports.m
.mBar.reports.m add command -label [mc "Weekly time bookings by project"] -underline 0 -command doWeeklyTimeBookingsByProject
.mBar.reports.m add command -label [mc "Time by activity"] -command doTimeByActivity
.mBar.reports.m add command -label [mc "Total time for a project"] -command doTotalTimeForProject
.mBar.reports.m add command -label [mc "Project Progress Report"] -command doProjectProgressReport
.mBar.reports.m add command -label [mc "Interruptions Report"] -command doInterruptionsReport
.mBar.reports.m add command -label [mc "Active and Pending Actions"] -command doActiveAndPendingReport
.mBar.reports.m add command -label [mc "Active Actions Review"] -command doActiveActionsReview
.mBar.reports.m add separator
.mBar.reports.m add command -label [mc "Help"] -command "taghelp reports"

menubutton .mBar.contacts -text [mc Contacts] -underline 0 -menu .mBar.contacts.m
menu .mBar.contacts.m
.mBar.contacts.m add command -label [mc Add] -underline 0 -command "addContact input"
.mBar.contacts.m add command -label [mc View] -underline 0 -command viewContacts
.mBar.contacts.m add command -label [mc Import] -underline 0 -command importContacts
.mBar.contacts.m add separator
.mBar.contacts.m add command -label [mc "Help"] -command "taghelp contacts"

menubutton .mBar.help -text [mc "Help"] -menu .mBar.help.m
menu .mBar.help.m
.mBar.help.m add command -label [mc "About"] -command "taghelp About $version"
.mBar.help.m add command -label [mc "Introduction"] -command "taghelp introduction"
.mBar.help.m add cascade -label [mc "Hints"] -menu .mBar.help.m.h
menu .mBar.help.m.h
.mBar.help.m.h add cascade -label [mc Activity] -menu .mBar.help.m.h.a
menu .mBar.help.m.h.a
.mBar.help.m.h.a add command -label [mc "meeting-preparation"] -command "taghelp hint_activity_pre_meeting"
.mBar.help.m.h.a add command -label [mc "meeting"] -command "taghelp hint_activity_meeting"
.mBar.help.m.h.a add command -label [mc "email"] -command "taghelp hint_activity_email"
.mBar.help.m.h add cascade -label [mc "Problem"] -menu .mBar.help.m.h.p
menu .mBar.help.m.h.p
.mBar.help.m.h.p add command -label [mc "Actions overrun"] -command "taghelp hint_problem_actions_overrun"
.mBar.help.m.h.p add command -label [mc "Actions not completed"] -command "taghelp hint_problem_actions_not_completed"
.mBar.help.m.h.p add command -label [mc "Interruptions"] -command "taghelp hint_problem_interruptions"
.mBar.help.m.h add separator
.mBar.help.m.h add command -label [mc "Help"] -command "taghelp hint_help"



pack .mBar.file .mBar.actions .mBar.projects .mBar.reports .mBar.contacts -side left
pack .mBar.help -side right
tk_menuBar .mBar .mBar.file


if { $num_today_actions != 0 } {
 display_today_actions
}

if { $display_prevday } {
frame .prevday
text .prevday.body -rel sunk -width 60 -height 15 -wrap word -yscrollcommand ".prevday.sb set"
scrollbar .prevday.sb -rel sunk -command ".prevday.body yview"
pack .prevday.body -side right -in .prevday -fill both -expand 1
pack .prevday.sb -side right -fill y -in .prevday
pack .prevday -fill both -expand 1
}

frame .preventries
text .preventries.body -rel sunk -width 60 -height $history_win_depth -wrap word -yscrollcommand ".preventries.sb set" -state disabled
scrollbar .preventries.sb -rel sunk -command ".preventries.body yview"
pack .preventries.body -side right -in .preventries -fill both -expand 1
pack .preventries.sb -side right -fill y -in .preventries
pack .preventries -fill x


frame .currentbar
button .currentbar.nextbutton -text [mc "Next"] -command { donext "" }
bind .currentbar.nextbutton <ButtonPress-3> {.currentbar.nextbutton.m post [winfo pointerx .currentbar] [winfo pointery .currentbar]}
menu .currentbar.nextbutton.m
.currentbar.nextbutton.m add command -label "--" -command "set currentActivity \"\""
for { set i 0 } {$i < [llength $activities]} { incr i} {

	.currentbar.nextbutton.m add command -label [lindex $activities $i ] \
		-command "donext [lindex $activities $i]"
}

button .currentbar.startbutton -text [mc "Start"] -command adjustStart
entry .currentbar.starttime -textvariable currentStart -width 6
menubutton .currentbar.endbutton -text [mc "End "] -menu .currentbar.endbutton.m -relief raised
menu .currentbar.endbutton.m
.currentbar.endbutton.m add command -label [mc Complete] -command actCompleteCurrent
.currentbar.endbutton.m add command -label [mc Abort] -command actAbortCurrent
# .currentbar.endbutton.m add command -label "Complete and NextSequence"
.currentbar.endbutton.m add cascade -label [mc Contact] -menu .currentbar.endbutton.m.contact
menu .currentbar.endbutton.m.contact
setcontactsmenu

.currentbar.endbutton.m add cascade -label Rate -menu .currentbar.endbutton.m.rate
menu .currentbar.endbutton.m.rate
.currentbar.endbutton.m.rate add command -label "--" -command "set rate \"\""
.currentbar.endbutton.m.rate add command -label Overtime -command "set rate Overtime"
.currentbar.endbutton.m add command -label [mc Help] -command "taghelp endbutton"


entry .currentbar.endtime -textvariable currentEnd -width 6
set mWid [menu_create .currentbar.project [mc "Project"] "" 1 proj menu_setText .currentbar.projectentry]
$mWid add cascade -label [mc Activity] -menu $mWid.menu

menu_create $mWid [mc "Activity"] "" 1 acties menu_setText .currentbar.activityentry

entry .currentbar.projectentry -textvariable currentProject \
				-width [taglog_getMaxMembLen proj 10 18]
entry .currentbar.activityentry -textvariable currentActivity  \
				-width [taglog_getMaxMembLen acties 10 18]

pack .currentbar.nextbutton .currentbar.startbutton .currentbar.starttime .currentbar.endbutton .currentbar.endtime .currentbar.project .currentbar.projectentry .currentbar.activityentry -side left
pack .currentbar

frame .actionbar
frame .actionbar.stack
button .actionbar.stack.interrupt -text "!" -command "stack_push \"!\""
button .actionbar.stack.push -text "+" -command "stack_push \"+\""
button .actionbar.stack.pop -text "-" -command stack_pop -state disabled
pack .actionbar.stack.interrupt .actionbar.stack.push .actionbar.stack.pop -side left -in .actionbar.stack
pack .actionbar.stack -side left -anchor w

menubutton .actionbar.action -text [mc "Action"] -menu .actionbar.action.m
bind .actionbar.action <ButtonPress-3> {editaction $currentAction}
menu .actionbar.action.m
# Add the active actions to the actions menubar.
# activeactions is a list of triples of actionID,action title and project, set up
# by getactiveactions

setactionsmenu

entry .actionbar.actionentry -textvariable currentActionTitle -width 40
pack .actionbar.action .actionbar.actionentry -side left
pack .actionbar

frame .description
frame .description.textf
text .description.body -rel sunk -width 60 -height $current_win_depth \
  -wrap word -yscrollcommand ".description.sb set"
scrollbar .description.sb -rel sunk -command ".description.body yview"
pack .description.body -side right -in .description.textf -expand 1 -fill both
pack .description.sb -side right -fill y -in .description.textf

pack .description.textf -fill both -expand 1
pack .description -fill both -expand 1


}

proc iconify_mainwin {} {
# Make main window an icon

wm iconify .

}


# Update the displayed end time every minute for the current record

proc minuteTimer {} {
  # This is run once a minute to update the screen
 # Set the displayed end time to the current time
global hh mm ss currentEnd state currentProject projTimes projTimesTotal projTimesTotalNonBreaks 
global currentTimeFormat

if { $state == "running" } {
 set oldmm $mm
 gettime
 set currentEnd [format $currentTimeFormat $hh $mm $ss]
 if {$oldmm != $mm } {
   if { $currentProject == "" } {
	set cproj  "unknown"
        } else {
	set cproj $currentProject
	}
   inctime projTimes($cproj) 60
   inctime projTimesTotal 60
    if { ! [isbreak $cproj ] } {
	inctime projTimesTotalNonBreaks 60
	}
  }
}
after 30000 { minuteTimer }
}

proc handleMidnight {} {
global logentries currentStart
# Called at midnight to switch to a new log file

#puts "handleMidnight called"
donext ""
writelog -writeactions
writeallact
closelogfile
set logentries ""
fillpreventries .preventries.body
after 2000


openlogfile
set currentStart "00:00:00"

}

proc setupHandleMidnight {} {
 set timeToMidnight [expr { [clock scan "23:59:59" ] - [clock seconds]} ]
 set timeToMidnight [ expr {$timeToMidnight * 1000 }]
 after $timeToMidnight { handleMidnight }
}

proc debugWindow {} {

toplevel .debugwin
wm title .debugwin "Enter tcl commands"

frame .debugwin.main
entry .debugwin.main.c -textvariable debugCommand -width 60
button .debugwin.main.go -text Exec -command doDebugCommand
pack .debugwin.main.c .debugwin.main.go -in .debugwin.main -side left
pack .debugwin.main

}

proc doDebugCommand {} {
global debugCommand

eval $debugCommand

}

