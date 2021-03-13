#
# taglog_action.tcl - routines dealing with actions for taglog
# Copyright John Lines (john+taglog@paladyn.org) September 2000
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_action 0.1

proc setupActivateAfter { action } {
# If required set up an event to activate an action after some time interval

# Note that we dont worry if we are putting in an action which will happen a
#  very long time in the future

set aa [tag_entryVal $action Active-after]
# puts "setupActivateAfter Active-after = $aa"
if {$aa == "" } return

set st [tag_entryVal $action Status]
 if { ($st != "Blocked") && ($st != "Delegated") } return 

  set timetowait [expr { [clock scan $aa] - [clock seconds] } ]
  set timetowait [expr { $timetowait * 1000 } ]
  set id [tag_entryVal $action Id]
  after $timetowait "activate_timeblocked_action $id"

}



proc actionInputOK { w winnum { idvar ""} } {
global year month day hh mm id_prefix
global actin_f_a
global action_textarea_fields

set thisaction ""
# need to get the text variables from the window
foreach field $action_textarea_fields {
 regsub -all {\.-} $field _ safe_label
 set safe_label [string tolower $safe_label]
set actin_f_a($winnum,$field) [string trim [$w.m.c.f.$safe_label.tagvalue get 1.0 end]]

}


setupAutoId $winnum
 
set thisaction [writeaction $thisaction $winnum]
setactionsmenu

set thisemail $actin_f_a($winnum,Email-status-to)
if { $thisemail != "" } {
 if { ! [ smtp init ] } {
    # put up a dialog box saying that mail is not initialised
   } else {
  set msg "The attached action has just been created"
  smtp send -subject "Action creation notification" -attachtag $thisaction -header action $msg $actin_f_a($winnum,Email-status-to)

  }

}

if { $idvar != "" } {
 set $idvar $actin_f_a($winnum,Id)
}

destroy $w

}

proc actionEditOK { w winnum } {
global year month day hh mm 
global allact allactstate
global actin_f_a
global actedit_fields
global action_textarea_fields

set thisaction ""
# need to get the text variables from the window
foreach field $action_textarea_fields {
 regsub -all {\.-} $field _ safe_label
 set safe_label [string tolower $safe_label]
set actin_f_a($winnum,$field) [string trim [$w.m.c.f.$safe_label.tagvalue get 1.0 end]]

}

 set action [ getact_input_fields $winnum -noend ]

# add the fields from actedit_fields
foreach field [array names actedit_fields] {
 set action [tagappend $action [index2fieldname $field] $actedit_fields($field)]
}

 set endpair [list End ]
 lappend action $endpair


set allactstate modified

foreach item $action {
 if { [lindex $item 0] == "Id" } {
   set thisid [lindex $item 1]
 }
}

set test [ list Id "==" $thisid ]
set idx 0
foreach entry $allact {
 if [ tag matchcond $entry $test ] {
    set allact [lreplace $allact $idx $idx $action] 
 }
 incr idx
}

writeallact


setactionsmenu

setupActivateAfter $action


destroy $w

}

proc actionInputWindow { mode {winnum 0} {idvar ""} {setValues ""} } {
global actin_f_a
global hh mm ss year month day
global validStates
global scrollside
global allcontacts
global currentProject



set actin_filled_fields {}
set actin_empty_fields {}


# Change for 0.2.4 - the variable argument is no longer used - although still present at the moment
# Instead the variable is always taken from the global array, and the winnum and label fields

proc actin_setup_field { window winnum mode label variable label_width var_width var_type help_id var_default args } {
# global $variable
global scrollside
global actin_f_a

set variable actin_f_a($winnum,$label)

upvar actin_filled_fields filled_fields
upvar actin_emtpy_fields empty_fields

upvar setValues setVals 

if { $setVals != "" } {
 # setVals is a list of variable names and values
 foreach zz $setVals {
  if {[lindex $zz 0] == $label } {
     set var_default [lindex $zz 1]
#     puts "setting the default for $label to $var_default"
     }
  }
}



regsub -all {\.-} $label _ safe_label
set safe_label [string tolower $safe_label]

if { $mode == "input" } {
set $variable "$var_default"
set filled 1
} else {
 set filled 0
 }

frame $window.m.c.f.$safe_label
menubutton $window.m.c.f.$safe_label.tagname -text [mc $label] -width $label_width -menu $window.m.c.f.$safe_label.tagname.m
menu $window.m.c.f.$safe_label.tagname.m
if { $var_type == "selection" } {

$window.m.c.f.$safe_label.tagname.m add command -label "--" -command "set $variable \"\""
set labels [lindex $args 0]
set values [lindex $args 1]
for { set i 0 } {$i < [llength $labels]} {incr i} {
 $window.m.c.f.$safe_label.tagname.m add command -label [lindex $labels $i] \
	 -command "set $variable  \"[lindex $values $i]\""
}
$window.m.c.f.$safe_label.tagname.m add separator

} elseif { $var_type == "actid_new"} {

$window.m.c.f.$safe_label.tagname.m add command -label "--" -command "set $variable \"\""
set newwinnum [incr winnum]
 $window.m.c.f.$safe_label.tagname.m add command -label [mc "Add..."] -command " actionInputWindow input $newwinnum $variable"

}
$window.m.c.f.$safe_label.tagname.m add command -label [mc "Help"] -command "taghelp $help_id"
if { $var_type == "date" } {
calUtil_win $window.m.c.f.$safe_label.tagvalue "" $variable $var_width
} elseif { $var_type == "textarea" } {
text $window.m.c.f.$safe_label.tagvalue -rel sunk -wrap word -yscrollcommand "$window.m.c.f.$safe_label.sb set" -width $var_width -height 5
scrollbar $window.m.c.f.$safe_label.sb -rel sunk -command "$window.m.c.f.$safe_label.tagvalue yview"
} else {
entry $window.m.c.f.$safe_label.tagvalue -width $var_width -textvariable $variable
}
if { $var_type == "textarea" } {
pack $window.m.c.f.$safe_label.tagname -side left -in $window.m.c.f.$safe_label
pack $window.m.c.f.$safe_label.tagvalue -side right -in $window.m.c.f.$safe_label
pack $window.m.c.f.$safe_label.sb -side $scrollside -fill y -in $window.m.c.f.$safe_label
if { $mode == "edit" } {
   upvar $variable varval
   $window.m.c.f.$safe_label.tagvalue insert end $varval
}
} else {
pack $window.m.c.f.$safe_label.tagname $window.m.c.f.$safe_label.tagvalue -in $window.m.c.f.$safe_label -side left
}

if { $filled } {
lappend filled_fields $window.m.c.f.$safe_label
 } else {
 lappend empty_fields $window.m.c.f.$safe_label
}
pack $window.m.c.f.$safe_label

}

set w .actinput$winnum
# label width - width of the labels
set lw 24

toplevel $w
if { $mode == "input" } {
wm title $w [mc "Input an action"]
 } else {
wm title $w "[mc {Edit action}] $actin_f_a($winnum,Id)"
}
wm minsize $w 200 200

getallcontacts

frame $w.m -bd 4 -relief sunken
canvas $w.m.c -yscrollcommand "$w.m.scroll set" -scrollregion {0 0 0 650} -relief raised -confine false -yscrollincrement 25
scrollbar $w.m.scroll -command "$w.m.c yview" -relief raised

pack $w.m.scroll -side right -fill y
pack $w.m.c -side left -fill both -expand true

pack $w.m -fill both -expand 1

set f [frame $w.m.c.f -bd 0]
$w.m.c create window 0 0 -anchor nw -window $f


actin_setup_field $w $winnum $mode Id actin_f_a($winnum,Id) $lw 40 string actinput_id "*Auto*"

actin_setup_field $w $winnum $mode Title actin_f_a($winnum,Title) $lw 40 string actinput_title ""

# set the first active project to be the current project
if { $currentProject != "" } {
   lappend activeproj $currentProject
   set activeproj [concat $activeproj [taglog_getList proj]]
   } else {
     set activeproj [taglog_getList proj]
   }
#for { set i 0 } {$i < [llength $projects]} {incr i} {
# if { ! [projclosed [lindex [lindex $projects $i] 0]] } {
# lappend activeproj [lindex [lindex $projects $i] 0]
# }
#}
actin_setup_field $w $winnum $mode Project actin_f_a($winnum,Project) $lw 40 selection actinput_project "" $activeproj $activeproj

actin_setup_field $w $winnum $mode Date actin_f_a($winnum,Date) $lw 40 string actinput_date "$year-$month-$day $hh:$mm"

actin_setup_field $w $winnum $mode Priority actin_f_a($winnum,Priority) $lw 40 selection actinput_priority 50 {10 20 30 40 50 60 70 80 90} {10 20 30 40 50 60 70 80 90}

foreach i $validStates {
  lappend vStates [mc $i]
}
actin_setup_field $w $winnum $mode Status actin_f_a($winnum,Status) $lw 40 selection actinput_status Pending $vStates $validStates

actin_setup_field $w $winnum $mode Period actin_f_a($winnum,Period) $lw 40 string actinput_period ""

actin_setup_field $w $winnum $mode Expected-cost actin_f_a($winnum,Expected-cost) $lw 40 string actinput_expected_cost ""

actin_setup_field $w $winnum $mode Expected-time actin_f_a($winnum,Expected-time) $lw 40 selection actinput_expected_time "" [list "0:05" "0:10" "0:20" "0:30" "1:00" "2:00" "3:00" "4:00" "6:00" "8:00 (1 [mc day])" "12:00 (1.5 [mc days])" "16:00 (2 [mc days])" "24:00 (3 [mc days])" "40:00 (1 [mc week])"]  [list "0:05" "0:10" "0:20" "0:30" "1:00" "2:00" "3:00" "4:00" "6:00" "8:00" "12:00" "16:00" "24:00" "40:00"]

actin_setup_field $w $winnum $mode Expected-start-date actin_f_a($winnum,Expected-start-date) $lw 38 date actinput_expected_start_date ""

actin_setup_field $w $winnum $mode Expected-completed-date actin_f_a($winnum,Expected-completed-date) $lw 38 date actinput_expected_completed_date ""

actin_setup_field $w $winnum $mode Precursor actin_f_a($winnum,Precursor) $lw 40 string actinput_precursor ""

actin_setup_field $w $winnum $mode Active-after actin_f_a($winnum,Active-after) $lw 38 date actinput_active_after ""

actin_setup_field $w $winnum $mode Subtask-of actin_f_a($winnum,Subtask-of) $lw 40 string actinput_subtask_of ""

actin_setup_field $w $winnum $mode Next-action actin_f_a($winnum,Next-action) $lw 40 actid_new actinput_next_action ""

actin_setup_field $w $winnum $mode Abort-action actin_f_a($winnum,Abort-action) $lw 40 actid_new actinput_abort_action ""

actin_setup_field $w $winnum $mode Difficulty actin_f_a($winnum,Difficulty) $lw 40 selection actinput_difficulty "" [list "0 - [mc nobrainer]" "1 - [mc trivial]" "2 - [mc easy]" "3 - [mc tricky]" "4 - [mc hard]" "5 - [mc {very hard}]" ] { 0 1 2 3 4 5 }


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
if { ($thisid != "") && ($thisemail !="") } {
 lappend conids $thisid
 lappend conemails $thisemail
}
}
if { ! [info exists conids ] } { set conids "" }
if { ! [info exists conemails ] } { set conemails "" }


actin_setup_field $w $winnum $mode Email-status-to actin_f_a($winnum,Email-status-to) $lw 40 selection actinput_email_status_to "" $conids $conemails

actin_setup_field $w $winnum $mode Delegated-to actin_f_a($winnum,Delegated-to) $lw 40 selection actinput_delegated_to "" $conids $conids

actin_setup_field $w $winnum $mode Description actin_f_a($winnum,Description) $lw 40 textarea actinput_description ""

actin_setup_field $w $winnum $mode Deliverable actin_f_a($winnum,Deliverable) $lw 40 textarea actinput_deliverable ""

actin_setup_field $w $winnum $mode  Reason actin_f_a($winnum,Reason) $lw 40 textarea actinput_reason ""

actin_setup_field $w $winnum $mode  Summary actin_f_a($winnum,Summary) $lw 40 textarea actinput_summary ""

# Display the filled fields first
# puts "filled fields are $actin_filled_fields"
# puts "empty fields are $actin_empty_fields"

set child [lindex [pack slaves $f] 0]

tkwait visibility $child
set incr [winfo height $child]
  set width [winfo width $f]
  set height [winfo height $f]
  $w.m.c config -scrollregion "0 0 $width $height"
  $w.m.c config -yscrollincrement $incr
  set actinput_maxrows 20
    if {$height > $actinput_maxrows * $incr } {
       set height [expr $actinput_maxrows * $incr]
       }
$w.m.c config -width $width -height $height

frame $w.bot
if { $mode == "input" } {
button $w.bot.ok -text [mc Add] -command "actionInputOK $w $winnum $idvar"
} elseif { $mode == "edit" } {
button $w.bot.ok -text [mc "Edit"] -command "actionEditOK $w 0"
}
button $w.bot.subtask -text [mc "Add Subtask..."] -command "addSubtask $winnum"
button $w.bot.mail -text "Mail..." -command "actionMail $w $winnum"
if { $mode == "edit" } {
 button $w.bot.history -text [mc History] -command "displayHistory $actin_f_a($winnum,Id)"
}
button $w.bot.cancel -text [mc Cancel] -command "doCancel $w"
button $w.bot.help -text [mc Help] -command "taghelp actinput"
pack $w.bot.ok $w.bot.subtask $w.bot.mail -in $w.bot -side left
if { $mode == "edit" } {
 pack $w.bot.history -in $w.bot -side left
}
pack $w.bot.cancel $w.bot.help -in $w.bot -side left

pack $w.bot

tkwait window $w

}

proc setupAutoId { winnum } {
global actin_f_a
global year month day hh mm

if { $actin_f_a($winnum,Id) == "*Auto*" } {
 if { $actin_f_a($winnum,Project) != "" } {
 set projseq [incprojactindex $actin_f_a($winnum,Project)]
 regsub -all " " $actin_f_a($winnum,Project) _ actin_f_a($winnum,Id)
 set actin_f_a($winnum,Id) "$actin_f_a($winnum,Id).$projseq" 

 } else {
 set actin_f_a($winnum,Id) "taglog.$year$month$day$hh$mm"
 }
}

}

proc addSubtask { winnum } {
global actin_f_a

setupAutoId $winnum

set parentProject $actin_f_a($winnum,Project)
set parentActid $actin_f_a($winnum,Id)


set newwinnum [incr winnum]
set setV1 [list Project $parentProject]
lappend setVals $setV1
set setV1 [list Subtask-of $parentActid]
lappend setVals $setV1
actionInputWindow input $newwinnum "" $setVals

}

proc actionMailOK { actin_win winnum } {
global actmail_to
global year month day hh mm
global actin_f_a

set thisaction ""
# need to get the text variables from the window
set actin_f_a($winnum,Description) [string trim [$actin_win.m.c.f.description.tagvalue get 1.0 end]]
set actin_f_a($winnum,Deliverable) [string trim [$actin_win.m.c.f.deliverable.tagvalue get 1.0 end]]
set actin_f_a($winnum,Reason) [string trim [$actin_win.m.c.f.reason.tagvalue get 1.0 end]]
set actin_f_a($winnum,Summary) [string trim [$actin_win.m.c.f.summary.tagvalue get 1.0 end]]

set actmail_message [string trim [.actmail.message.body get 1.0 end]]

setupAutoId $winnum

 set thisaction [getact_input_fields $winnum]

if { $actmail_to != "" } {
 if { ! [ smtp init ] } {
    # put up a dialog box saying that mail is not initialised
   } else {
  smtp send -subject "Action creation notification" -attachtag $thisaction -header action $actmail_message $actmail_to

  }

}
destroy $actin_win
destroy .actmail

}

proc actionMail { actin_win winnum } {
global allcontacts

toplevel .actmail
wm title .actmail [mc "Mail an action"]

getallcontacts

frame .actmail.main
menubutton .actmail.main.l -text [mc "Mail to"] -menu .actmail.main.l.m
menu .actmail.main.l.m
.actmail.main.l.m add command -label "--" -command "set actmail_to \"\""
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
 .actmail.main.l.m add command -label "$thisid" -command "set actmail_to \"$thisemail\""

}
.actmail.main.l.m add separator
.actmail.main.l.m add command -label [mc "Help"] -command "taghelp actmail_to"

entry .actmail.main.v -textvariable actmail_to -width 20
pack .actmail.main.l .actmail.main.v -side left -in .actmail.main

pack .actmail.main

frame .actmail.message
menubutton .actmail.message.l -text [mc Message] -menu .actmail.message.l.m
menu .actmail.message.l.m
.actmail.message.l.m add command -label [mc Help] -command "taghelp actmail_message"
text .actmail.message.body -rel sunk -wrap word -yscrollcommand ".actmail.message.sb set"
scrollbar .actmail.message.sb -rel sunk -command ".actmail.message.body yview"
pack .actmail.message.l -side left -in .actmail.message
pack .actmail.message.body -side right -in .actmail.message
pack .actmail.message.sb -fill y -side right -in .actmail.message
pack .actmail.message


frame .actmail.bot
button .actmail.bot.ok -text Mail -command "actionMailOK $actin_win $winnum"
button .actmail.bot.cancel -text [mc Cancel] -command { doCancel .actmail }
button .actmail.bot.help -text [mc Help] -command "taghelp actmail"
pack .actmail.bot.ok .actmail.bot.cancel .actmail.bot.help -side left -in .actmail.bot
pack .actmail.bot

tkwait window .actmail
}

proc getact_input_fields { winnum args } {
# get the fields from the global variables set by actinput and return them
# as an action

global actin_f_a

if { [llength $args] > 0 } {
 set endflag 0
 } else {
 set endflag 1
 }
 
set action ""

 set action [tagappend $action Id $actin_f_a($winnum,Id)]
 set action [tagappend $action Title $actin_f_a($winnum,Title)]
 set action [tagappend $action Project $actin_f_a($winnum,Project)]
 set action [tagappend $action Date $actin_f_a($winnum,Date)]
 set action [tagappend $action Priority $actin_f_a($winnum,Priority)]
 set action [tagappend $action Status $actin_f_a($winnum,Status)]
 set action [tagappend $action Period $actin_f_a($winnum,Period)]
 set action [tagappend $action Expected-cost $actin_f_a($winnum,Expected-cost)]
 set action [tagappend $action Expected-time $actin_f_a($winnum,Expected-time)]
 set action [tagappend $action Expected-start-date $actin_f_a($winnum,Expected-start-date)]
 set action [tagappend $action Expected-completed-date $actin_f_a($winnum,Expected-completed-date)]
 set action [tagappend $action Precursor $actin_f_a($winnum,Precursor)]
 set action [tagappend $action Active-after $actin_f_a($winnum,Active-after)]
 set action [tagappend $action Subtask-of $actin_f_a($winnum,Subtask-of)]
 set action [tagappend $action Next-action $actin_f_a($winnum,Next-action)]
 set action [tagappend $action Abort-action $actin_f_a($winnum,Abort-action)]
 set action [tagappend $action Email-status-to $actin_f_a($winnum,Email-status-to)]
 set action [tagappend $action Delegated-to $actin_f_a($winnum,Delegated-to)]
 set action [tagappend $action Difficulty $actin_f_a($winnum,Difficulty)]
 set action [tagappend $action Description $actin_f_a($winnum,Description) END_D]
 set action [tagappend $action Deliverable $actin_f_a($winnum,Deliverable) END_D]
 set action [tagappend $action Reason $actin_f_a($winnum,Reason) END_D]
 set action [tagappend $action Summary $actin_f_a($winnum,Summary) END_D]

if { $endflag } {
 set endpair [list End ]

 lappend action $endpair
}

 return $action
}

proc writeaction { action winnum } {
# We dont actually use the action which is our parameter at present,
# just use the global variables set by actionInputWindow

global actin_f_a
global allact allactstate

getallact

 # set the status of actions which are active after some date to blocked unless they are
 # Delegated, in which case they stay Delegated.
 if { $actin_f_a($winnum,Active-after) != "" } {
   if { $actin_f_a($winnum,Status) != "Delegated" } {
      set actin_f_a($winnum,Status) Blocked
     }
   }


 set action [ getact_input_fields $winnum ]

 lappend allact $action
 set allactstate modified

writeallact

setupActivateAfter $action

return $action

}


proc doactviewOK {} {
destroy .actview
}

proc doactviewSaveAs {} {

set fn [tk_getSaveFile -defaultextension ".txt" ]
 if { $fn != "" } {
  set f [open $fn w]
  puts $f [ .actview.main.body get 1.0 end ]
  close $f
 }
}

proc set_actsel_tests {} {
global actsel_project actsel_st_any actsel_st_unclaimed actsel_st_pending actsel_st_active actsel_st_blocked actsel_st_delegated actsel_st_completed actsel_st_aborted actsel_st_periodic actsel_showfields actsel_maxpriority actsel_expected_start actsel_expected_completed actsel_expected_start_test actsel_expected_completed_test actsel_filename actsel_id actsel_title

if {$actsel_project !=""} {
 set test [list Project == $actsel_project]
 lappend tests $test
 }
if {! $actsel_st_any } {
 if { $actsel_st_unclaimed } {
	lappend status_list Unclaimed
	}
 if { $actsel_st_pending } {
	lappend status_list Pending
	}
 if { $actsel_st_active } {
	lappend status_list Active
	}
 if { $actsel_st_delegated } {
	lappend status_list Delegated
	}
 if { $actsel_st_blocked } {
       lappend status_list Blocked
       }
 if { $actsel_st_completed } {
	lappend status_list Completed
	}
 if { $actsel_st_aborted } {
	lappend status_list Aborted
	}
 if { $actsel_st_periodic } {
	lappend status_list Periodic
	}

 set test [list Status "-in" $status_list]
 lappend tests $test

}

if { $actsel_maxpriority != "" } {
 set test [list Priority <= $actsel_maxpriority]
 lappend tests $test
}

if { $actsel_expected_start != "" } {
 set test [list Expected-start-date $actsel_expected_start_test $actsel_expected_start ]
 lappend tests $test
}

if { $actsel_expected_completed != "" } {
 set test [list Expected-completed-date $actsel_expected_completed_test $actsel_expected_completed ]
 lappend tests $test
}

if { $actsel_id !=""} {
 set test [list Id == $actsel_id]
 lappend tests $test
}

if { $actsel_title !=""} {
 set test [list Title == $actsel_title]
 lappend tests $test
}

if { [info exists tests] } {
	return $tests
 } else {
	return {}
}
}

proc editaction { actid {winnum 0} } {
global actin_f_a
global hh mm ss year month day
global validStates
global scrollside
global allcontacts
global allact allactstate
global actedit_fields

getallact

# convert actid to a 'safe' value
#regsub -all {\.} $actid _ actid_safe

#set w ".$actid_safe"

#toplevel $w
#wm title $w "Edit action $actid"

set actin_f_a($winnum,Description) ""
set actin_f_a($winnum,Reason) ""
set actin_f_a($winnum,Deliverable) ""
set actin_f_a($winnum,Summary) ""

if { [info exist actedit_fields] } {
 unset actedit_fields
}

# find the appropriate action.
set actin_f_a($winnum,Id) $actid
set test [list Id "==" $actid]
lappend tests $test
set thisaction [tag extract $allact $tests]

foreach action $thisaction {
 foreach item $action {
 if { [lindex $item 0] == "Title" } {
   set actin_f_a($winnum,Title) [lindex $item 1]
 } elseif { [lindex $item 0] == "Project"} {
   set actin_f_a($winnum,Project) [lindex $item 1]
 } elseif { [lindex $item 0] == "Date"} {
   set actin_f_a($winnum,Date) [lindex $item 1]
 } elseif { [lindex $item 0] == "Priority"} {
   set actin_f_a($winnum,Priority) [lindex $item 1]
 } elseif { [lindex $item 0] == "Status"} {
   set actin_f_a($winnum,Status) [lindex $item 1]
 } elseif { [lindex $item 0] == "Period"} {
   set actin_f_a($winnum,Period) [lindex $item 1]
 } elseif { [lindex $item 0] == "Expected-cost"} {
   set actin_f_a($winnum,Expected-cost) [lindex $item 1]
 } elseif { [lindex $item 0] == "Expected-time"} {
   set actin_f_a($winnum,Expected-time) [lindex $item 1]
 } elseif { [lindex $item 0] == "Expected-start-date"} {
   set actin_f_a($winnum,Expected-start-date) [lindex $item 1]
 } elseif { [lindex $item 0] == "Expected-completed-date"} {
   set actin_f_a($winnum,Expected-completed-date) [lindex $item 1]
 } elseif { [lindex $item 0] == "Precursor"} {
   set actin_f_a($winnum,Precursor) [lindex $item 1]
 } elseif { [lindex $item 0] == "Difficulty"} {
   set actin_f_a($winnum,Difficulty) [lindex $item 1]
 } elseif { [lindex $item 0] == "Active-after"} {
   set actin_f_a($winnum,Active-after) [lindex $item 1]
 } elseif { [lindex $item 0] == "Subtask-of"} {
   set actin_f_a($winnum,Subtask-of) [lindex $item 1]
 } elseif { [lindex $item 0] == "Next-action"} {
   set actin_f_a($winnum,Next-action) [lindex $item 1]
 } elseif { [lindex $item 0] == "Abort-action"} {
   set actin_f_a($winnum,Abort-action) [lindex $item 1]
 } elseif { [lindex $item 0] == "Description"} {
   set actin_f_a($winnum,Description) [lindex $item 1]
 } elseif { [lindex $item 0] == "Deliverable"} {
   set actin_f_a($winnum,Deliverable) [lindex $item 1]
   } elseif { [lindex $item 0] == "Reason" } {
   set actin_f_a($winnum,Reason)  [lindex $item 1]
   } elseif { [lindex $item 0] == "Summary" } {
   set actin_f_a($winnum,Summary)  [lindex $item 1]
 } elseif { [lindex $item 0] == "Email-status-to"} {
   set actin_f_a($winnum,Email-status-to) [lindex $item 1]
 } elseif { [lindex $item 0] == "Delegated-to"} {
   set actin_f_a($winnum,Delegated-to) [lindex $item 1]
 } elseif { [lindex $item 0] == "End" } {
   # special case - dont do anything
 } elseif { [lindex $item 0] == "Id" } {
   # we have already picked this up
 } else {
   set fieldname [fieldname2index [lindex $item 0]]
   set actedit_fields($fieldname) [lindex $item 1]
 }


}
}

set action [actionInputWindow edit]

}


proc showactfield { selector tagname tagvalue } {
if { $tagname == $selector } {
   .actview.main.body insert end "$tagname: "
   .actview.main.body insert end "$tagvalue"
   .actview.main.body insert end "\n"
}
}


proc fillactwindow {} {
global actsel_project actsel_st_any actsel_st_unclaimed actsel_st_pending actsel_st_active actsel_st_blocked actsel_st_delegated actsel_st_completed actsel_st_aborted actsel_st_periodic actsel_showfields actsel_maxpriority actsel_expected_start actsel_expected_completed actsel_expected_start_test actsel_expected_completed_test actsel_filename actsel_sortby

global actionsfilename allact
 .actview.main.body delete 1.0 end

.actview.main.body mark set prvmark 1.0
.actview.main.body mark gravity prvmark left

set numactions 0
set total_expected_time "00:00"

if { $actsel_filename != $actionsfilename } {
 set actions [ tag readfile $actsel_filename]
# get rid of the header
 set actions [lrange $actions 1 end ]
 } else {
 set actions [lrange $allact 1 end ]
}

# possibly get rid of actions which do not match our selection criteria
# set tests {}
set tests [ set_actsel_tests ]

if {[info exists tests]} {
set actions [ tag extract $actions $tests ]
}
 
if { $actsel_sortby != "" } {
 if { $actsel_sortby == "Priority" } {
   set actions [tag sort $actions Priority -integer]
 }
}

foreach entry $actions {

foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]

 if { $tagname == "End" } {
    .actview.main.body insert end "___________________________________\n"
    incr numactions
    .actview.main.body tag add tag_$actid prvmark insert
    .actview.main.body tag bind tag_$actid <Button-3> "editaction $actid"
    .actview.main.body mark set prvmark insert

 } else {
   # special fields handling for stats
   if { $tagname == "Expected-time"} {
	set exptime [timediff "00:00:00" $tagvalue]
	inctime total_expected_time $exptime
	}
   if { $tagname == "Id" } {
	set actid $tagvalue
	}
   if { $actsel_showfields(all) } {
   .actview.main.body insert end "[mc $tagname]: "
   .actview.main.body insert end "$tagvalue"
   .actview.main.body insert end "\n"
   } else {
  if { $actsel_showfields(id) } {
	showactfield Id $tagname $tagvalue
   }
   if { $actsel_showfields(date) } {
        showactfield Date $tagname $tagvalue
   }
   if { $actsel_showfields(title)} {
	showactfield Title $tagname $tagvalue
   }
   if { $actsel_showfields(priority)} {
	showactfield Priority $tagname $tagvalue
   }
   if { $actsel_showfields(project)} {
	showactfield Project $tagname $tagvalue
   }
   if { $actsel_showfields(status)} {
	showactfield Status $tagname $tagvalue
   }
   if { $actsel_showfields(expected_completed)} {
        showactfield Expected-completed-date $tagname $tagvalue
   }
   if { $actsel_showfields(summary)} {
   	showactfield Summary $tagname $tagvalue
   }
  }

 }


}
}

.actview.stats.body insert end "[mc Displayed] $numactions [mc actions]\n"
.actview.stats.body insert end "[mc {Total expected time}] $total_expected_time\n"

}

proc displayActions {} {
global actionsfilename actsel_filename

set actions {}

toplevel .actview
wm title .actview "[mc {Actions view of}] $actsel_filename"

frame .actview.main
text .actview.main.body -rel sunk -wrap word -yscrollcommand ".actview.main.sb set"
scrollbar .actview.main.sb -rel sunk -command ".actview.main.body yview"
pack .actview.main.body -side right -in .actview.main
pack .actview.main.sb -side right -fill y -in .actview.main
pack .actview.main

frame .actview.stats
text .actview.stats.body -rel sunk -wrap word -height 6
pack .actview.stats.body -in .actview.stats
pack .actview.stats

frame .actview.bot
button .actview.bot.ok -text OK -command doactviewOK
button .actview.bot.select -text Select -command fillactwindow
button .actview.bot.saveas -text [mc "Save As..."] -command doactviewSaveAs
pack .actview.bot.ok .actview.bot.saveas -side left
pack .actview.bot


# Now fill the window
fillactwindow

tkwait window .actview
}

proc doHistorySaveAsOK { filename window hvsawin } {

set f [open $filename w]
  puts $f [ $window.act.body get 1.0 end]
  puts $f [ $window.text.body get 1.0 end]
close $f

destroy $hvsawin
}

proc doHistorySaveAs { window } {
global histfile histwindow thiswindow

set histwindow ".$window"
set thiswindow ".hvsa$window"
toplevel .hvsa$window
wm title .hvsa$window [mc "Save Action History As ..."]
frame .hvsa$window.filename
label .hvsa$window.filename.label -text [mc "File name :"]
entry .hvsa$window.filename.name -relief sunken -textvariable histfile
pack .hvsa$window.filename.label .hvsa$window.filename.name -side left -in .hvsa$window.filename
pack .hvsa$window.filename

frame .hvsa$window.bot
button .hvsa$window.bot.ok -text OK -command { doHistorySaveAsOK $histfile $histwindow $thiswindow }
button .hvsa$window.bot.cancel -text [mc Cancel] -command { doCancel $thiswindow }
pack .hvsa$window.bot.ok .hvsa$window.bot.cancel -in .hvsa$window.bot -side left
pack .hvsa$window.bot

tkwait window .hvsa$window
}

proc doReviseAction { action redate retime summary } {
global allact allactstate

set revised 0
if {$redate != ""} {
if { [tag_entryVal $action Original-expected-completed-date] == "" } {
 tag setorreplace action Original-expected-completed-date [tag_entryVal $action Expected-completed-date]
 }
#tag setorreplace action Revised-expected-completed-date $redate
tag setorreplace action Expected-completed-date $redate
set revised 1
}
if {$retime != ""} {
if { [tag_entryVal $action Original-expected-time] == "" } {
 tag setorreplace action Original-expected-time [tag_entryVal $action Expected-time]
 }
tag setorreplace action Expected-time $retime
set revised 1
}
if {$summary !=""} {
 tag setorreplace action Summary $summary
 set revised 1
}

if {$revised} {
tag setorreplace action Revised-date [clock format [clock seconds] -format "%Y-%m-%d"]

set allactstate modified
# tag update $actionsfilename $action Id

foreach item $action {
 if { [lindex $item 0] == "Id" } {
   set thisid [lindex $item 1]
 }
}

set test [ list Id "==" $thisid ]
set idx 0
foreach entry $allact {
 if [ tag matchcond $entry $test ] {
    set allact [lreplace $allact $idx $idx $action]
 }
 incr idx
}

writeallact

}
}


proc doRevise { action i } {
global revisedExpectedDate revisedExpectedTime
global allact allactstate

set redate $revisedExpectedDate($i)
set retime $revisedExpectedTime($i)
set summary [string trim [.acthist$i.summary.body get 1.0 end]]

set revised 0
if {$redate != ""} {
 if {[tag_entryVal $action Original-expected-completed-date] == ""} {
 tag setorreplace action Original-expected-completed-date [tag_entryVal $action Expected-completed-date]
 }

#tag setorreplace action Revised-expected-completed-date $redate
tag setorreplace action Expected-completed-date $redate
set revised 1
}
if {$retime != ""} {
 if {[tag_entryVal $action Original-expected-time] == ""} {
 tag setorreplace action Original-expected-time [tag_entryVal $action Expected-time]
 }
tag setorreplace action Expected-time $retime
set revised 1
}
if {$summary !=""} {
 tag setorreplace action Summary $summary
 set revised 1
}

if {$revised} {
tag setorreplace action Revised-date [clock format [clock seconds] -format "%Y-%m-%d"]

set allactstate modified
# tag update $actionsfilename $action Id

foreach item $action {
 if { [lindex $item 0] == "Id" } {
   set thisid [lindex $item 1]
 }
}

set test [ list Id "==" $thisid ]
set idx 0
foreach entry $allact {
 if [ tag matchcond $entry $test ] {
    set allact [lreplace $allact $idx $idx $action]
 }
 incr idx
}

writeallact

}


}

proc displayHistory { {actid {}} } {
global revisedExpectedDate revisedExpectedTime
global actsel_filename

proc displayAnActionHistory { i action } {

toplevel .acthist$i
wm title .acthist$i "[mc {Action history}] $i"

frame .acthist$i.act
text .acthist$i.act.body -rel sunk -wrap word -yscrollcommand ".acthist$i.act.sb set" -height 5
scrollbar .acthist$i.act.sb -rel sunk -command ".acthist$i.act.body yview"
pack .acthist$i.act.body -in .acthist$i.act -side right
pack .acthist$i.act.sb -in .acthist$i.act -side right -fill y
pack .acthist$i.act

frame .acthist$i.text
text .acthist$i.text.body -rel sunk -wrap word -yscrollcommand ".acthist$i.text.sb set"
scrollbar .acthist$i.text.sb -rel sunk -command ".acthist$i.text.body yview"
pack .acthist$i.text.body -in .acthist$i.text -side right
pack .acthist$i.text.sb -in .acthist$i.text -side right -fill y
pack .acthist$i.text

frame .acthist$i.summary
text .acthist$i.summary.body -rel sunk -wrap word -yscrollcommand ".acthist$i.summary.sb set" -height 5
scrollbar .acthist$i.summary.sb -rel sunk -command ".acthist$i.summary.body yview"
pack .acthist$i.summary.body -in .acthist$i.summary -side right
pack .acthist$i.summary.sb -in .acthist$i.summary -side right -fill y
pack .acthist$i.summary

frame .acthist$i.bot
button .acthist$i.bot.revise -text [mc "Revise"] -command "doRevise \"$action\" $i"
menubutton .acthist$i.bot.expdate -text [mc Expected-Completed-Date] -menu .acthist$i.bot.expdate.m
menu .acthist$i.bot.expdate.m
entry .acthist$i.bot.expdateentry -textvariable revisedExpectedDate($i) -width 12
menubutton .acthist$i.bot.exptime -text [mc Expected-Time] -menu .acthist$i.bot.exptime.m
menu .acthist$i.bot.exptime.m
entry .acthist$i.bot.exptimeentry -textvariable revisedExpectedTime($i) -width 5

button .acthist$i.bot.saveas -text [mc "Save As..."] -command "doHistorySaveAs acthist$i"
button .acthist$i.bot.cancel -text [mc Cancel] -command " doCancel .acthist$i "
pack .acthist$i.bot.revise .acthist$i.bot.expdate .acthist$i.bot.expdateentry .acthist$i.bot.exptime .acthist$i.bot.exptimeentry .acthist$i.bot.saveas .acthist$i.bot.cancel -in .acthist$i.bot -side left
pack .acthist$i.bot

foreach item $action {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
  if { $tagname == "Date" } {
    set actiondate $tagvalue
   } elseif { $tagname == "Title" } {
    set actiontitle $tagvalue
  } elseif { $tagname == "Status" } {
    set actionstatus $tagvalue
  } elseif { $tagname =="Id" } {
    set actionid $tagvalue
  } elseif { $tagname == "Project" } {
    set actionproject $tagvalue
  } elseif { $tagname == "Expected-completed-date" } {
    set actionexpectedcompleteddate $tagvalue
  } elseif { $tagname == "Expected-time" } {
    set actionexpectedtime $tagvalue
  } elseif { $tagname == "Revised-expected-completed-date"} {
    set actionrevisedexpectedcompleteddate $tagvalue
  } elseif { $tagname == "Revised-expected-time" } {
    set actionrevisedexpectedtime $tagvalue
  } elseif { $tagname == "Original-expected-time" } {
    set actionoriginalexpectedtime $tagvalue
  } elseif { $tagname == "Original-expected-completed-date" } {
    set actionoriginalexpectedcompleteddate $tagvalue
  } elseif { $tagname == "Revised-date" } {
    set actionreviseddate $tagvalue
  } elseif { $tagname == "Summary" } {
    set actionsummary $tagvalue
  }
}

.acthist$i.act.body delete 1.0 end

#%%%%%%%%%%%%%% actionid was not set %%%%%%%%%%%%%%%%%%%%%%%%
if {! [info exist actionid ] || ! [info exist actiondate ] || ! [info exist actiontitle ]} return
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.acthist$i.act.body insert end "$actionid\t"
.acthist$i.act.body insert end "$actiontitle\n\n"
if [info exist actionproject ] {
.acthist$i.act.body insert end "[mc Project]: $actionproject\n"
}
if [info exist actionoriginalexpectedcompleteddate ] {
 .acthist$i.act.body insert end "[mc Original-expected-completed-date]: $actionoriginalexpectedcompleteddate\n"
}
if [info exist actionoriginalexpectedtime ] {
 .acthist$i.act.body insert end "[mc Original-expected-time]: $actionoriginalexpectedtime\n"
}
if [info exist actionexpectedcompleteddate ] {
 .acthist$i.act.body insert end "[mc Expected-completed-date]: $actionexpectedcompleteddate\n"
}
if [info exist actionexpectedtime ] {
 .acthist$i.act.body insert end "[mc Expected-time]: $actionexpectedtime\n"
}
if [info exist actionrevisedexpectedcompleteddate] {
 .acthist$i.act.body insert end "[mc Revised-expected-completed-date]: $actionrevisedexpectedcompleteddate\n"
}
if [info exist actionrevisedexpectedtime] {
.acthist$i.act.body insert end "[mc Revised-expected-time]: $actionrevisedexpectedtime\n"
}
if [info exist actionreviseddate] {
.acthist$i.act.body insert end "[mc Revised-date]: $actionreviseddate\n"
}

.acthist$i.text.body delete 1.0 end

set test [ list Action "==" $actionid ]
lappend tests $test
set fileslist [dateRangeToLogfileList $actiondate ""]
foreach filename $fileslist {
  set logs [tag readselected $filename $tests]
  set dateseparator 0

  foreach entry $logs {
    # for now just write them out
     if { ! $dateseparator } {
   set dateseparator 1
   set headerdate [logfilename2date $filename]
   .acthist$i.text.body insert end "\n\n   $headerdate\n\n"
   }
  foreach item $entry {
    set tagname [lindex $item 0]
    set tagvalue [lindex $item 1]
    if { $tagname == "End" } {
      .acthist$i.text.body insert end "_______________________________\n"
     } elseif {  $tagname == "Id" } {
        # dont do anything
     } elseif { $tagname == "Action" } {
        #
     } elseif { $tagname == "ActionTitle" } {
        #
     } elseif { $tagname == "Project" } {
        #
     } elseif { $tagname == "StartTime" } {
	set starttime $tagvalue
     } elseif { $tagname == "EndTime" } {
	# We should always have a start time and an end time - put them out
	# as a single line
	set endtime $tagvalue
	set duration [timediff $starttime $endtime]
	inctime actiontotal $duration
	set dispduration  "00:00"
	inctime dispduration $duration
     .acthist$i.text.body insert end "Start $starttime [mc {End }] $endtime [mc Duration] $dispduration\n"
 } else {
     .acthist$i.text.body insert end "[mc $tagname]: "
     .acthist$i.text.body insert end "$tagvalue "
     .acthist$i.text.body insert end "\n"
 }
}
}

}

# we have read all the logs - show the total duration
if [info exist actiontotal] {
.acthist$i.act.body insert end "[mc {Total duration}]: $actiontotal\n"
}

.acthist$i.summary.body delete 1.0 end
if [info exist actionsummary ] {
.acthist$i.summary.body insert end "$actionsummary"
}

}

if { $actid != "" } {
 set test [list Id "==" $actid]
 lappend tests $test
 } else {
 set tests [ set_actsel_tests ]
 }

set actions [tag readselected $actsel_filename $tests ]

# Display the history of each selected action in its own window.

set i 1
foreach action $actions {
 displayAnActionHistory $i $action
incr i
}



}

proc setup_actsel_menus {} {
global actsel_filename actionsfilename allact

.actsel.oneact.id.m delete 1 end
.actsel.oneact.title.m delete 1 end
set tests [ set_actsel_tests ]
if { $actionsfilename != $actsel_filename } {
set actions [tag readselected $actsel_filename $tests ]
 } else {
 getallact
 set actions [tag extract $allact $tests ]
}


foreach action $actions {

foreach item $action {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
  if { $tagname == "Id" } {
    .actsel.oneact.id.m add command -label $tagvalue -command "set actsel_id $tagvalue"
  } elseif { $tagname == "Title"} {
     .actsel.oneact.title.m add command -label $tagvalue -command "set actsel_title \"$tagvalue\""
 }
}
}
.actsel.oneact.id.m add separator
.actsel.oneact.id.m add command -label [mc Help] -command "taghelp actsel_id"
.actsel.oneact.title.m add separator
.actsel.oneact.title.m add command -label [mc Help] -command "taghelp actsel_title"

}

proc actSelect { okcommand } {
global actsel_project actsel_st_any actsel_st_unclaimed actsel_st_pending actsel_st_active actsel_st_blocked actsel_st_delegated actsel_st_completed actsel_st_aborted actsel_st_periodic actsel_maxpriority actsel_showfields actsel_filename actsel_filenames actsel_expected_start actsel_expected_completed actsel_expected_start_test actsel_expected_completed_test actsel_id actsel_title actsel_projstat actsel_sortby

proc setupActselProjMenu { varname index op } {
global actsel_projstat

setupProjMenu .actsel.tagselect.p.project.m actsel_project $actsel_projstat actsel_project

}

trace variable actsel_projstat w setupActselProjMenu

toplevel .actsel
wm title .actsel [mc "Select Actions ..."]

frame .actsel.fileselect
menubutton .actsel.fileselect.filename -text [mc Filename] -menu .actsel.fileselect.filename.m
menu .actsel.fileselect.filename.m
for { set i 0 } {$i < [llength $actsel_filenames]} {incr i} {
 if { [ file exists [lindex $actsel_filenames $i ]] } {
 .actsel.fileselect.filename.m add command -label [lindex $actsel_filenames $i ] \
	-command "set actsel_filename \"[lindex $actsel_filenames $i]\""
 }
}
.actsel.fileselect.filename.m add separator
.actsel.fileselect.filename.m add command -label [mc Help] -command "taghelp actsel_filename"
entry .actsel.fileselect.fileentry -textvariable actsel_filename -width 30
pack .actsel.fileselect.filename .actsel.fileselect.fileentry -in .actsel.fileselect -side left
pack .actsel.fileselect
 

frame .actsel.tagselect
frame .actsel.tagselect.p
menubutton .actsel.tagselect.p.project -text [mc Project] -menu .actsel.tagselect.p.project.m
menu .actsel.tagselect.p.project.m
setupActselProjMenu 1 2 3

entry .actsel.tagselect.p.projectentry -textvariable actsel_project -width 10

radiobutton .actsel.tagselect.p.all -text [mc "All"] -variable actsel_projstat -value "all"
radiobutton .actsel.tagselect.p.active -text "Active" -variable actsel_projstat -value "active"
pack .actsel.tagselect.p.project .actsel.tagselect.p.projectentry .actsel.tagselect.p.all .actsel.tagselect.p.active -in .actsel.tagselect.p -side left
pack .actsel.tagselect.p

frame .actsel.tagselect.status
menubutton .actsel.tagselect.status.l -text Status -menu .actsel.tagselect.status.l.m
menu .actsel.tagselect.status.l.m
.actsel.tagselect.status.l.m add command -label [mc Help] -command "taghelp actsel_st"
checkbutton .actsel.tagselect.status.any -text [mc Any] -variable actsel_st_any
checkbutton .actsel.tagselect.status.unclaimed -text [mc Unclaimed] -variable actsel_st_unclaimed
checkbutton .actsel.tagselect.status.pending -text [mc Pending] -variable actsel_st_pending
checkbutton .actsel.tagselect.status.active -text [mc Active] -variable actsel_st_active
checkbutton .actsel.tagselect.status.blocked -text [mc Blocked] -variable actsel_st_blocked
checkbutton .actsel.tagselect.status.delegated -text [mc Delegated] -variable actsel_st_delegated
checkbutton .actsel.tagselect.status.completed -text [mc Completed] -variable actsel_st_completed
checkbutton .actsel.tagselect.status.aborted -text [mc Aborted] -variable actsel_st_aborted
checkbutton .actsel.tagselect.status.periodic -text [mc Periodic] -variable actsel_st_periodic
pack .actsel.tagselect.status.l .actsel.tagselect.status.any .actsel.tagselect.status.unclaimed .actsel.tagselect.status.pending .actsel.tagselect.status.active .actsel.tagselect.status.blocked .actsel.tagselect.status.delegated .actsel.tagselect.status.completed .actsel.tagselect.status.aborted .actsel.tagselect.status.periodic -side left -in .actsel.tagselect.status
pack .actsel.tagselect.status

frame .actsel.tagselect.priority
menubutton .actsel.tagselect.priority.l -text "[mc Priority] <=" -menu .actsel.tagselect.priority.l.m
menu .actsel.tagselect.priority.l.m
.actsel.tagselect.priority.l.m add command -label [mc Help] -command "taghelp actsel_maxpriority"
entry .actsel.tagselect.priority.e -textvariable actsel_maxpriority
pack .actsel.tagselect.priority.l .actsel.tagselect.priority.e -in .actsel.tagselect.priority -side left
pack .actsel.tagselect.priority

set actsel_expected_start ""
set actsel_expected_completed ""
set actsel_expected_start_test "-later"
set actsel_expected_start_testlabel "<"
set actsel_expected_completed_test "-later"
set actsel_expected_completed_testlabel ">"
frame .actsel.tagselect.date
label .actsel.tagselect.date.l -text [mc "Date Expected"]
menubutton .actsel.tagselect.date.ls -text Start -menu .actsel.tagselect.date.ls.m
menu .actsel.tagselect.date.ls.m
set todayval [clock format [clock seconds] -format "%Y-%m-%d"]
.actsel.tagselect.date.ls.m add command -label "--" -command "set actsel_expected_start \"\""
.actsel.tagselect.date.ls.m add command -label "[mc Today] ($todayval)" -command "set actsel_expected_start $todayval" 
set tomorrowval [clock format [clock scan tomorrow] -format "%Y-%m-%d"]
.actsel.tagselect.date.ls.m add command -label "[mc Tomorrow] ($tomorrowval)" -command "set actsel_expected_start $tomorrowval" 
calUtil_menu .actsel.tagselect.date.ls.m .actsel.tagselect.date.es
.actsel.tagselect.date.ls.m add separator
.actsel.tagselect.date.ls.m add command -label [mc Help] -command "taghelp actsel_expected_start"
menubutton .actsel.tagselect.date.st -text $actsel_expected_start_testlabel -menu .actsel.tagselect.date.st.m
menu .actsel.tagselect.date.st.m
.actsel.tagselect.date.st.m add command -label "[mc Later] (>)" -command "set actsel_expected_start_test -later ; set actsel_expected_start_testlabel \">\" ; .actsel.tagselect.date.st configure -text \">\""
.actsel.tagselect.date.st.m add command -label "[mc Earlier] (<)" -command "set  actsel_expected_start_test -earlier ; set actsel_expected_start_testlabel \">\" ; .actsel.tagselect.date.st configure -text \"<\""
entry .actsel.tagselect.date.es -textvariable actsel_expected_start -width 16
menubutton .actsel.tagselect.date.lc -text [mc Completed] -menu .actsel.tagselect.date.lc.m
menu .actsel.tagselect.date.lc.m
.actsel.tagselect.date.lc.m add command -label "--" -command "set actsel_expected_completed \"\""
.actsel.tagselect.date.lc.m add command -label "[mc Today] ($todayval)" -command "set actsel_expected_completed $todayval" 
.actsel.tagselect.date.lc.m add command -label "[mc Tomorrow] ($tomorrowval)" -command "set actsel_expected_completed $tomorrowval" 
calUtil_menu .actsel.tagselect.date.lc.m .actsel.tagselect.date.ec
.actsel.tagselect.date.lc.m add separator
.actsel.tagselect.date.lc.m add command -label [mc Help] -command "taghelp actsel_expected_completed"
menubutton .actsel.tagselect.date.ct -text $actsel_expected_completed_testlabel  -menu .actsel.tagselect.date.ct.m
menu .actsel.tagselect.date.ct.m
.actsel.tagselect.date.ct.m add command -label "[mc Later] (>)" -command "set actsel_expected_completed_test -later ; set actsel_expected_completed_testlabel \">\" ; .actsel.tagselect.date.ct configure -text \">\""
.actsel.tagselect.date.ct.m add command -label "[mc Earlier] (<)" -command "set actsel_expected_completed_test -earlier ; set actsel_expected_completed_testlabel \"<\" ; .actsel.tagselect.date.ct configure -text \"<\""
entry .actsel.tagselect.date.ec -textvariable actsel_expected_completed -width 16
pack .actsel.tagselect.date.l .actsel.tagselect.date.ls .actsel.tagselect.date.st .actsel.tagselect.date.es .actsel.tagselect.date.lc .actsel.tagselect.date.ct .actsel.tagselect.date.ec -in .actsel.tagselect.date -side left
pack .actsel.tagselect.date

pack .actsel.tagselect

frame .actsel.fields
menubutton .actsel.fields.l -text [mc "Show Fields"] -menu .actsel.fields.l.m
menu .actsel.fields.l.m
.actsel.fields.l.m add command -label [mc Help] -command "taghelp actsel_showfields"
checkbutton .actsel.fields.all -text [mc All] -variable actsel_showfields(all)
checkbutton .actsel.fields.id -text Id -variable actsel_showfields(id)
checkbutton .actsel.fields.date -text [mc Date] -variable actsel_showfields(date)
checkbutton .actsel.fields.title -text [mc Title] -variable actsel_showfields(title)
checkbutton .actsel.fields.priority -text [mc Priority] -variable actsel_showfields(priority)
checkbutton .actsel.fields.project -text [mc Project] -variable actsel_showfields(project)
checkbutton .actsel.fields.status -text Status -variable actsel_showfields(status)
checkbutton .actsel.fields.completeddate -text [mc "Due Date"] -variable actsel_showfields(expected_completed)
checkbutton .actsel.fields.summary -text [mc Summary] -variable actsel_showfields(summary)

pack .actsel.fields.l .actsel.fields.all .actsel.fields.id .actsel.fields.date .actsel.fields.title .actsel.fields.priority .actsel.fields.project .actsel.fields.status .actsel.fields.completeddate .actsel.fields.summary -in .actsel.fields -side left
pack .actsel.fields

frame .actsel.oneact
button .actsel.oneact.refresh -text [mc "Refresh"] -command setup_actsel_menus
menubutton .actsel.oneact.id -text Id -menu .actsel.oneact.id.m
menu .actsel.oneact.id.m
entry .actsel.oneact.identry -textvariable actsel_id -width 10
menubutton .actsel.oneact.title -text [mc Title] -menu .actsel.oneact.title.m
menu .actsel.oneact.title.m
entry .actsel.oneact.titleentry -textvariable actsel_title -width 20
pack .actsel.oneact.refresh .actsel.oneact.id .actsel.oneact.identry .actsel.oneact.title .actsel.oneact.titleentry -in .actsel.oneact -side left
pack .actsel.oneact

frame .actsel.sortby
menubutton .actsel.sortby.l -text [mc "Sort by"] -menu .actsel.sortby.l.m
menu .actsel.sortby.l.m
.actsel.sortby.l.m add command -label "--" -command "set actsel_sortby \"\""
.actsel.sortby.l.m add command -label [mc "Priority"] -command "set actsel_sortby Priority"
.actsel.sortby.l.m add separator
.actsel.sortby.l.m add command -label [mc "Help"] -command "taghelp actsel_sortby"
entry .actsel.sortby.e -textvariable actsel_sortby -width 10
pack .actsel.sortby.l .actsel.sortby.e -side left -in .actsel.sortby
pack .actsel.sortby


frame .actsel.bot
button .actsel.bot.ok -text OK -command $okcommand 
button .actsel.bot.cancel -text [mc Cancel] -command { doCancel .actsel }
button .actsel.bot.help -text [mc Help] -command "taghelp actsel"
pack .actsel.bot.ok .actsel.bot.cancel .actsel.bot.help -in .actsel.bot -side left
pack .actsel.bot

tkwait window .actsel

trace vdelete actsel_projstat w setupActselProjMenu

}

proc getactiveactions {} {
global activeactions
global allact allactstate

set activeactions ""
# Seems to work - I thought I might have to use unset
set test [list Status "-in" { Active } ]
lappend tests $test
getallact
#set actions [ tag extract $allact $tests ]
set idx 0
while { $idx != -1 } {
set idx [tag find $allact $tests $idx]

if { $idx != -1 } {

# Now to extract the bits of info we need - 
 set entry [lindex $allact $idx]
 set thisproject ""
 set thispriority 50
 foreach item $entry {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
 if { $tagname == "Id" } {
   set thisid $tagvalue
 } elseif { $tagname == "Title"} {
   set thistitle $tagvalue
 } elseif { $tagname == "Project"} {
   set thisproject $tagvalue
 } elseif { $tagname == "Priority"} {
   set thispriority $tagvalue
 }
 }

 set thisentry [ list $thisid $thistitle $thisproject $thispriority $idx]
 incr idx
 lappend activeactions $thisentry
}
}


if { [info tclversion] >=8.0 } {
set activeactions [lsort -integer -index 3 $activeactions]
}

}


proc setactionsmenu {} {
global activeactions num_today_actions allact
getactiveactions
 .actionbar.action.m delete 1 end
.actionbar.action.m add command -label "--" \
	-command "setcurrentAction -1"
for { set i 0 } {$i < [llength $activeactions]} {incr i} {
 # hide subtasks from top level
 if { [tag_entryVal [lindex $allact [lindex [lindex $activeactions $i] 4]] Subtask-of] != "" } {
    continue
   }  
 .actionbar.action.m add command -label [lindex [ lindex $activeactions $i ] 1] \
	-command "setcurrentAction \"[lindex [lindex $activeactions $i ] 0]\""
# if it had subtasks the add them. (note that this bit should really be
# recursive
 if { [tag_entryVal [lindex $allact [lindex [lindex $activeactions $i] 4]] Subtasks] != "" } {
   set submenu .actionbar.action.m.s$i
   .actionbar.action.m add cascade -label "[lindex [ lindex $activeactions $i ] 1]..." -menu $submenu
   if {[winfo exists $submenu]} {
	$submenu delete 1 end
        } else {
	menu $submenu
	}
    set subacts [split [tag_entryVal [lindex $allact [lindex [lindex $activeactions $i] 4]] Subtasks] ","] 
    foreach subact $subacts { 
     # We are only interested in active subactions, which must be in activeactions
      for { set j 0 } {$j < [llength $activeactions]} {incr j} {
       if {[lindex [lindex $activeactions $j ] 0]==$subact } { 
     $submenu add command -label "[lindex [lindex $activeactions $j ] 1]" \
	-command "setcurrentAction \"[lindex [lindex $activeactions $j ] 0]\""
          }
       }
     }
   }
}

for { set i 1 } { $i <= $num_today_actions } { incr i } {
 menu_create .actions.a$i.id [mc Action]$i actreminder 0 actAct menu_setText .actions.a$i.title
 }


}

proc setcurrentAction { id } {
global currentAction currentProject activeactions currentActionTitle


if { $id < 0 } {
  set currentAction ""
  set currentActionTitle ""
  return
}
set currentAction $id
set currentProject ""

foreach entry $activeactions {
 set thisid [lindex $entry 0]
 if { $thisid == $id } {
   set currentProject [lindex $entry 2]
   set currentActionTitle [lindex $entry 1]
 }
}
}

proc setcurrentPeriodicAction { id } {
global currentAction currentProject currentActionTitle allact

# Note that the format of periodicActions as generated here is a full
# subset of allact - rather than just a a list of id project and title
# so need to deal with this when setting up


donext ""

if { $id < 0 } {
  set currentAction ""
  set currentActionTitle ""
  return
}
set currentAction $id
set currentProject ""

foreach action $allact {
 foreach item $action {
#   puts "item is $item"
   if {( [lindex $item 0] == "Status" ) && ([lindex $item 1] == "Periodic" )} {
# need to check if it has already been done - i.e. Completed during this period
# but for now ..
	lappend periodicActions $action
        # 
	}
   }
}

# puts "periodicActions is $periodicActions"

foreach entry $periodicActions {
 set thisid [lindex $entry 0]
#  puts "thisid is $thisid"
 if { [lindex $thisid 1] == $id } {
   foreach item $entry {
        if {[lindex $item 0] == "Project" } {
            set currentProject [lindex $item 1]
        }
        if {[lindex $item 0] == "Title" } {
             set currentActionTitle [lindex $item 1]
        }
        }
 }
}


}

proc actNewState { actid newstate oldstate actnote winname } {
global allact allactstate

# puts "actNewState $actid $newstate $oldstate $actnote"

# work out which action we are talking about

set i 0
foreach entry $allact {
 foreach item $entry {
   if { [lindex $item 0] == "Id" } {
	if { [lindex $item 1 ] == $actid } {
	 set idx $i
	 }
  }
 }
 incr i
}


set entry [lindex $allact $idx]

# puts "entry is $entry"

tag replace entry Status $newstate

set newstate_date [list $newstate-date [clock format [clock seconds] -format "%Y-%m-%d %H:%M"]]

set len [llength $entry]
incr len -1
set entry [linsert $entry $len $newstate_date]

if { $actnote != "" } {
 set newstate_note [ list $newstate-note $actnote "END_D" ]
 set len [llength $entry]
 incr len -1
 set entry [linsert $entry $len $newstate_note]
 }

#puts "$entry"

set email_status_to ""
# Does this entry contain an Email-status-to field ?
foreach item $entry {
 set tagname [lindex $item 0]
 set tagvalue [lindex $item 1]
 if { $tagname == "Email-status-to"} {
   set email_status_to $tagvalue
   }
 }

if {$email_status_to != ""} {
  if { ! [ smtp init ] } {
    # put up a dialog box saying that mail is not initialised
   } else {
  set msg "The attached action has just changed state from $oldstate to $newstate"
  smtp send -subject "Action status change notification" -attachtag $entry -header action $msg $email_status_to
 }
}

if { $newstate == "Completed" } {
set next_action_id ""
foreach item $entry {
 if { [lindex $item 0]  == "Next-action"} {
   set next_action_id [lindex $item 1]
   }
 }
if { $next_action_id != "" } {

 actNewState $next_action_id Active Pending "" ""
 setcurrentAction $next_action_id


}


}

if { $newstate == "Aborted"} {
set abort_action_id ""
foreach item $entry {
 if { [lindex $item 0]  == "Next-action"} {
   set abort_action_id [lindex $item 1]
   }
 }
if { $abort_action_id != "" } {



}


}

set allact [lreplace $allact $idx $idx $entry]
set allactstate modified

setactionsmenu

if { $winname != "" } {
 destroy $winname
}
}

proc doNewState { oldstate newstate } {

proc doNewStateOK { newstate oldstate } {
global allact allactstate
#
# Have to choose between passing the entire array and re-reading the entire
# file
# I think we can pick up the key variables from the outer procedure
#upvar 2 newstate mynewstate
#upvar 2 actions myactions
# - no we cant - despite being nested inside doNewState 
#
set actselection [.docomplete.pick.actions curselection]
# puts "current selection is $actselection" 
set actnote [string trim [.docomplete.note.text get 1.0 end]]

# I should deal with a list - just do one for the moment
foreach actsel $actselection {

set acttitle [.docomplete.pick.actions get $actsel]

# puts "acttitle is $acttitle"
set idx [string range $acttitle 0 [ string first " " $acttitle]]
# puts "idx is $idx"

# find out what the action id is
set entry [lindex $allact $idx]

set actid ""
foreach item $entry {
 if {[lindex $item 0] == "Id" } {
  set actid [lindex $item 1]
 }
}

if { $actid == "" } {
	return
}

actNewState $actid $newstate $oldstate $actnote ""

}
set allactstate modified
writeallact

destroy .docomplete
}

 
global allact allactstate
# I might be able to make this a menu, but I dont want to set it up until it
# is needed, so it will have to be a window for now
toplevel .docomplete
wm title .docomplete "[mc "Pick an action to move from"] [mc $oldstate] [mc to] [mc $newstate]"


frame .docomplete.pick
listbox .docomplete.pick.actions -relief raised -borderwidth 2 -yscrollcommand ".docomplete.pick.scroll set" -width 60 -height 15
scrollbar .docomplete.pick.scroll -command ".docomplete.pick.actions yview"
pack .docomplete.pick.actions -in .docomplete.pick -side left
pack .docomplete.pick.scroll -in .docomplete.pick -side right -fill y


set i 0
foreach entry $allact {
 foreach item $entry {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]
 if { $tagname == "Id" } {
   set thisid $tagvalue
 } elseif { $tagname == "Title"} {
   set thistitle $tagvalue
 } elseif { $tagname == "Project"} {
   set thisproject $tagvalue
 } elseif { $tagname =="Status"} {
   if {$tagvalue == $oldstate} {
     set idxtitle "$i $thistitle"
     .docomplete.pick.actions insert end $idxtitle
   frame .docomplete.a$i
   button .docomplete.a$i.b -text $thistitle -command  "doNewStateOK $i $newstate $oldstate"
   pack .docomplete.a$i.b -in .docomplete.a$i
#   pack .docomplete.a$i

  }
 }


}
incr i
}

pack .docomplete.pick

frame .docomplete.note
text .docomplete.note.text -rel sunk -wrap word -yscrollcommand ".docomplete.note.sb set" -width 50 -height 5
scrollbar .docomplete.note.sb -rel sunk -command ".docomplete.note.text yview"
pack .docomplete.note.text .docomplete.note.sb -side left -fill y -in .docomplete.note
pack .docomplete.note


frame .docomplete.bot
button .docomplete.bot.ok -text OK -command " doNewStateOK $newstate $oldstate"
button .docomplete.bot.cancel -text [mc Cancel] -command { doCancel .docomplete }
pack .docomplete.bot.ok .docomplete.bot.cancel .docomplete.bot -side left
pack .docomplete.bot

tkwait window .docomplete

}



proc activate_timeblocked_action { actid } {
global allact allactstate
# Activate an action which was blocked until a particular time.
# This includes changing the state, and popping up a notification window.

getallact

# get the title and description of the action
set title ""
set description ""

set test [list Id "==" $actid]
lappend tests $test

set actions [tag extract $allact $tests]
foreach action $actions {
 # (Highlander - there shall be only one)
 foreach item $action {
   if { [lindex $item 0] == "Title" } {
	set title [lindex $item 1]
   }
   if { [lindex $item 0] == "Description" } {
	set description [lindex $item 1]
   }
 }
}


regsub -all {\.} "timeblocked_$actid" _ winname
set winname ".$winname"

toplevel $winname
wm title $winname "Activate Time Blocked action $actid"

frame $winname.mesg
message $winname.mesg.m  -width 4i -text \
 "Time blocked action $actid activated\n $title\n$description"
pack $winname.mesg.m $winname.mesg


frame $winname.bot
button $winname.bot.ok -text OK -command "actNewState $actid Active Blocked \"\" $winname"
button $winname.bot.cancel -text [mc Cancel] -command "doCancel $winname "
pack $winname.bot.ok $winname.bot.cancel -side left -in $winname.bot
pack $winname.bot

tkwait window $winname

}

proc activate_timeblocked {} {
global allact allactstate
# Activate, or prepare 'after' commands to activate, all the timeblocked actions# which will become due this day.
#
# This can be called when taglog starts and it will activate any timeblocked
# actios which are due now.
#

getallact

# find all the possible candidates - only interested in actions which have
# the Active-after field and which are blocked.
set test [list Status "-in" { Blocked Delegated }]
lappend tests $test
set tomorrow [clock format [clock scan tomorrow] -format "%Y-%m-%d"]
set test [list Active-after -earlier $tomorrow]
lappend tests $test

set actions [ tag extract $allact $tests ]

# puts "Time blocked actions $actions"

# Find out which of those actions have already passed.
set test [ list Active-after -earlier [clock format [clock seconds] -format "%Y-%m-%d %T"]]
lappend nowtest $test

set pastactions [ tag extract $actions $nowtest]

# We can just activate all the past actions.

foreach action $pastactions {
 foreach item $action {
   if { [lindex $item 0] == "Id" } {
	activate_timeblocked_action [lindex $item 1]
	}
   }
}

set test [ list Active-after -later [clock format [clock seconds] -format "%Y-%m-%d %T"]]
lappend futuretest $test

set futureactions [tag extract $actions $futuretest]
#puts "future actions are $futureactions"

foreach action $futureactions {
 set thisid ""
 foreach item $action {
	set tagname [lindex $item 0]
	set tagvalue [lindex $item 1]
	if { $tagname == "Id" } {
		set thisid $tagvalue
		}
	if { $tagname == "Active-after" } {
		set timetowait [expr { [clock scan $tagvalue] - [clock seconds] } ]
		set timetowait [expr { $timetowait * 1000 } ]
		after $timetowait "activate_timeblocked_action $thisid" 
	}
	}
}


}

proc getallact {} {
global actionsfilename allact allactstate

if { $allactstate == "closed" } {
 set allact [tag readfile $actionsfilename]
 set allactstate open
# If allact is emtpy then we are just getting started -  we want to put a
# header on the start of the file.
 if { [llength $allact] == 0 } {
	set hdr ""
	set header [list Tag-action-version 1.0]
	lappend hdr $header
	set endpair [list End ]
	lappend hdr $endpair
	lappend  allact $hdr
 }
 }
# puts "allact is $allact"
}

proc writeallact {} {
global actionsfilename allact allactstate

if { $allactstate == "modified" } {
  tag writefile $actionsfilename $allact
  set allactstate open
  }
}

proc actCompleteCurrent {} {
global currentAction activeactions
if { $currentAction == "" } {
 return
 }
set a $currentAction
# if the current state of the action is Periodic then do not set its
# state to Completed, just set the Completed-date and refresh
# Period Actions view


set thisact [actionFromActid $a]

foreach item $thisact {
#	puts "item is $item"
	if { [lindex $item 0] == "Status" && [ lindex $item 1] == "Periodic" } {
#		puts "This action is Periodic"
		completePeriodicAction $a
		return
	}
}
#  puts "This action is not periodic"

donext ""
actNewState $a Completed Active "" ""
getactiveactions
}

proc actAbortCurrent {} {
global currentAction activeactions
if { $currentAction == "" } {
 return
 }
set a $currentAction
donext ""
actNewState $a Aborted Active "" ""
getactiveactions
}

proc archiveOldActions {} {
#
# Move all actions completed or aborted more than a month ago to an archive
# file
global allact allactstate

proc oldActionsArchiveName { archdate } {
global rootdir
# return the name of the old actions file - takes in a date which is
# the nomimal archive date..

set yearmon [clock format [clock scan $archdate] -format "%Y%m"]

return "$rootdir/actions-$yearmon.tag"


}

set monthdate [clock format [clock scan "last month"] -format "%Y-%m-01"]

getallact

# extract the actions which are completed or aborted before the date

set headerwritten 0

set test [list Completed-date "-earlier" $monthdate]
lappend tdates $test
set test [list Aborted-date "-earlier" $monthdate]
lappend tdates $test


foreach entry $allact {

if { [tag matchany $entry $tdates] } {

if { ! $headerwritten } {
  set filename [oldActionsArchiveName $monthdate]
  if { ! [ file exists $filename] } { 
  set f [open $filename w]
  puts $f "Tag-action-version: 1.0"
  puts $f "End:"
  } else {
   set f [open $filename a]
  }
  set headerwritten 1
  }
  tag writeentry $f $entry
  } else {
  lappend newacts $entry
}


}
if { $headerwritten } {
 close $f
}
# Now - we update allact to be newacts
# puts "newacts is $newacts"
set allact $newacts
set allactstate modified
writeallact
}

proc Update_subtasks { actionid {subtaskid ""} } {
global allact allactstate
# Update the subtask field for actionid
# - If a subtask Id is specified then only that subtask is added to the
# subtasks for that action - otherwise all actions are checked to see if they
# are subtasks of the action.


if { $actionid == "" } {
  error "Update_subtasks called with null actionid"
  return
  }

if { $subtaskid == "" } {

 set si 0
 while { $si != -1} {
   set si [tag findval $allact Subtask-of $actionid $si ]
   if { $si != -1 } {
     Update_subtasks $actionid [tag_entryVal [lindex $allact $si] Id]
     incr si
     }
  }

} else {
 # check if the subtaskid already appears in the subtasks field for the action
 set idx [tag findval $allact Id $actionid]
 if { $idx == -1 } {
   error "Update_subtasks called for non-existant action $actionid"
   return }

  set entry [lindex $allact $idx]
  set subtasks [tag_entryVal $entry Subtasks ]
  if { [string first $subtaskid $subtasks] != -1 } { return }
  if {$subtasks == "" } {
	set subtasks $subtaskid
	} else {
  	set subtasks "$subtasks,$subtaskid"
	}

  if { $subtasks != "" } {
  tag setorreplace entry Subtasks $subtasks 

  set allact [lreplace $allact $idx $idx $entry]
  set allactstate modified
  }
writeallact
}

}

proc Update_all_subtasks {} {
# Find all actions which have subtasks and call Update_subtasks on them.
# I think I need to work through all actions.

global allact

foreach action $allact {
 set id [tag_entryVal $action Id]
 if { $id != "" } { Update_subtasks [tag_entryVal $action Id] }
} 


}

proc completePeriodicAction { actid } {
global allact allactstate currentAction

# Check to see if actid matches currentAction

 if { $actid != $currentAction } {
   if { [tk_messageBox -message "Not current action, are you sure ?" \
     -icon question -type okcancel ] == "cancel" } { return }
   }

  set now [clock format [clock seconds] -format "%Y-%m-%d %H:%M"]

set idx [tag findval $allact Id $actid]
 if { $idx == -1 } {
   error "Update_subtasks called for non-existant action $actid"
   return }

  set entry [lindex $allact $idx]

  tag setorreplace entry Completed-date $now

  set allact [lreplace $allact $idx $idx $entry]
  set allactstate modified
  writeallact

 donext ""

 displayPeriodicActions

}


proc displayPeriodicActions {} {
# Display all the active periodic actions in their own window
global allact debug

# Find out if we have any to display
foreach action $allact {
 foreach item $action {
   if {( [lindex $item 0] == "Status" ) && ([lindex $item 1] == "Periodic" )} {
# need to check if it has already been done - i.e. Completed during this period
# Note that there will be a Period field, and that Period could be Period: Daily
#  or even Period: Daily 15
#  which will work in a similar way to Active-After
       set iscompleted 0
       set isreached 0
       set period "Daily"
       set periodval 1
# Check for a Period
       foreach i $action {
		   if { [lindex $i 0] == "Period" } {
			   set periodstr [lindex $i 1]
			   set periodlist [split $periodstr]
			   set period [lindex $periodlist 0]
			   if {[ llength $periodlist] > 1 } {
				   set periodval [lindex $periodlist 1]
			   }
			}
	   
	    # Now set the PeriodStart - note that we know by now that the action is period, but it might not have an
	    #  explicity Period tag
			   if { $period == "Daily" } {
                  set PeriodStart "[clock format [clock scan $periodval -format %H] -format %Y-%m-%d] 00:00"
               } elseif { $period == "Weekly" } {
				   set PeriodStart "[clock format [clock scan $periodval -format %u ] -format %Y-%m-%d] 00:00"
			   } elseif { $period == "Monthly" } {
				   set PeriodStart "[clock format [clock scan $periodval -format %d  ] -format %Y-%m-%d] 00:00"
			   } elseif { $period == "Yearly" } {
				   set PeriodStart "[clock format [clock scan $periodval -format %j ] -format %Y-%m-%d] 00:00"
			   } else {
				   puts "Invalid period type - set to Daily"
				   set period = "Daily"
				   set PeriodStart "[clock format [clock seconds] -format %Y-%m-%d] 00:00"
			   }
		   }
		   
#		   puts "Period is $period periodval is $periodval PeriodStart is $PeriodStart"
# Now see if the start date is in this period 	 - due to offsets we might not have reached the start date yet.	  

       if { [clock seconds]  > [clock scan $PeriodStart -format "%Y-%m-%d %H:%M"] } {
                    if { $debug > 1 } { puts "Start date is reached for this period" }
                      set isreached 1
                      }
                      
    # Check for a Completed-date - if there is not one, then it cant be completed
       foreach i $action {
         if { [lindex $i 0] == "Completed-date" } {
             set cdate [lindex $i 1]
             if { [clock scan $cdate -format "%Y-%m-%d %H:%M"] > [clock scan $PeriodStart -format "%Y-%m-%d %H:%M"] } {
                    if { $debug > 1 } { puts "Is already completed for this period" }
                      set iscompleted 1
                      }
             }
        }
		   
        
# but for now ..
        if { $isreached && (! $iscompleted) } {
	    lappend periodicActions $action
            }
	}
   }
}

if {[info exists periodicActions]} {

   # We may be being called when the window already exists
   if { ! [winfo exists .periodicActions ] } {
       toplevel .periodicActions
       wm title .periodicActions "Periodic Actions"

        } else {
        # If the window exists, get rid of the body - it will be recreated

        destroy .periodicActions.body
        }
   frame .periodicActions.body

   set i 1
   foreach action $periodicActions {
     foreach item $action {
           if {( [lindex $item 0] == "Title" ) } {
                set actionTitle [lindex $item 1]
               }
           if {( [lindex $item 0] == "Id" ) } {
                set actionId [lindex $item 1]
               } 
           }
          
     frame .periodicActions.body.i$i

     button .periodicActions.body.i$i.title -text $actionTitle -command "setcurrentPeriodicAction $actionId"
     button .periodicActions.body.i$i.done -text "Done" -command "completePeriodicAction $actionId"
     
     pack .periodicActions.body.i$i.title .periodicActions.body.i$i.done -in .periodicActions.body.i$i -side left

     pack .periodicActions.body.i$i -in .periodicActions.body
     incr i
    }
    pack .periodicActions.body -side top

    if { ! [winfo exists .periodicActions.bot] } {
        frame .periodicActions.bot
        button .periodicActions.bot.ok -text OK -command {doCancel .periodicActions}
        pack .periodicActions.bot.ok -in .periodicActions.bot
        pack .periodicActions.bot -side bottom
    }

    tkwait window .periodicActions

   } else {
 #    puts "There are no actions to display - check to see if the window should be destroyed"

     if { [ winfo exists .periodicActions] } { destroy .periodicActions }

     }
   

}

# Action utility functions

proc actionFromActid { actid } {
	global allact
	
set idx [tag findval $allact Id $actid]
 if { $idx == -1 } {
   error "actionFromActid called for non-existant action $actid"
   return }

  return [lindex $allact $idx]
}
