#
# taglog_init.tcl - initialisation routines for taglog
# Copyright John Lines (john@paladin.demon.co.uk) July 2000, January 2003
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_init 0.1


proc initialise {} {
global tcl_platform env
global hh mm ss year month day currentStart currentEnd currentProject currentActivity logfilename \
 actionsfilename state projectsfilename activities rootdir currentAction
global currentContact
global contactsfilename
global contacttypes
global currentActionTitle
global actinput_project
global actinput_f_a0
global projTimes projTimesTotal projTimesTotalNonBreaks
global logentries
global validStates
global libsdir prefsfile display_prevday
global actsel_project actsel_st_any actsel_st_unclaimed actsel_st_pending actsel_st_active actsel_st_blocked actsel_st_completed actsel_st_aborted actsel_filename actsel_filenames actsel_projstat actsel_sortby
global showtime_format showtime_spreadoverheads showtime_bookbycode showtime_hours_per_day
global timebook_startlastweek
global actsel_maxpriority actsel_showfields
global docdir
global helpdir
global scrollside
global allactstate
global language
global allcontactsstate
global rate
global dateformat_view dateformat_tcl
global num_today_actions history_win_depth current_win_depth
global html_public_dir html_private_dir
global lvsa_dirname
global id_prefix
global action_textarea_fields
global GL_tableFont
global GL_autoComCase
global GL_autoComMsec
global argv
global start_procs exit_procs
global stackdepth stack_info
global projects_url
global log_summary
global activitiesfilename
global debug

global currentTimeFormat
set currentTimeFormat "%d:%02d:%02d"

# Initialise common variables


set hh 0
set mm 0
set ss 0
gettime 
set year 0
set month 0
set day 0
getdate
set currentStart [format $currentTimeFormat $hh $mm $ss]
set currentEnd [format $currentTimeFormat $hh $mm $ss]
set currentProject ""
set currentContact ""
set currentAction ""
set currentActionTitle ""
set currentActivity ""
set logfilename ""
set prevdayfilename ""
set state "running"
set logentries {}
set projTimes(unknown) "00:00"
set projTimesTotal "00:00"
set projTimesTotalNonBreaks "00:00"
set validStates { Unclaimed Pending Active Blocked Delegated Completed Aborted }
set prefsfile ""
set actsel_st_any 1
set actsel_st_unclaimed 1
set actsel_st_pending 1
set actsel_st_active 1
set actsel_st_blocked 0
set actsel_st_completed 0
set actsel_st_aborted 0
set actsel_maxpriority ""
set actsel_showfields(all) 1
set actsel_showfields(id) 0
set actsel_showfields(title) 1
set actsel_showfields(priority) 0
set actsel_showfields(project) 1
set actsel_showfields(status) 1
set actsel_showfields(summary) 1
set actsel_projstat all
set actsel_sortby ""
set stackdepth 0
set stack_info ""
set log_summary ""
# parameters for auto completion of entry widgets
# case ignore case? 0=no, 1=yes
set GL_autoComCase 1
# delay in milliseconds, 0 means autocompletion only with <ESC> key
set GL_autoComMsec 300

set allactstate closed
set allcontactsstate closed

set id_prefix ""
set GL_tableFont "-*-courier-medium-r-normal--*-120-*"

set action_textarea_fields { Description Deliverable Reason Summary}

# The following items are likely to be customised by the user

set dateformat_view "YYYY-MM-DD"
set dateformat_tcl "%Y-%m-%d"

set debug 0

set rootdir "~/diary"
if { $tcl_platform(platform) == "windows" } {
 if [ info exists env(USERPROFILE)] {
 set df [file join $env(USERPROFILE) diary]
 if { [file isdirectory $env(USERPROFILE)] } {
      set rootdir $df
       }
 }
 }


set start_procs {}
set exit_procs {}

set projects_url ""

# delay setting the following until after the preferences file has been read
 set actionsfilename ""
 set projectsfilename ""
 set html_public_dir ""
 set html_private_dir ""
 set lvsa_dirname ""
 set activitiesfilename ""   
 set contactsfilename ""

set contacttypes { colleague customer supplier contact friend }

set rate ""

set activities { phone-in phone-out meeting meeting-preparation meeting-review email reading programming writing thinking service-break informal-discussion }


set showtime_format 1
set showtime_spreadoverheads byweek
set showtime_bookbycode 0
set showtime_hours_per_day 7.58
set timebook_startlastweek 1


# which side the scroll bars are, in windows with scroll bars
set scrollside left

set history_win_depth 15
set current_win_depth 15
set num_today_actions 3

# How often (in minutes) do we want to be reminded to take a break - 0 disables
set breakRemindInterval 0

# do we display the previous day window
set display_prevday 0

# where do we find our preferences
# this is now set in sourcelibs
# set libsdir ""

# where do we keep the help files - default to the same place as the
# taglog main script

set scriptdir [file dirname [info script]] 
set helpdir $scriptdir
if { [ file readable $scriptdir/taglog_help_en.tag] } {
  set helpdir $scriptdir
  } elseif { [file readable ~/lib/taglog/taglog_help_en.tag] } {
  set helpdir ~/lib/taglog
  } elseif { [file readable /usr/lib/taglog/taglog_help_en.tag] } {
  set helpdir /usr/lib/taglog
  } elseif { [file readable /usr/local/lib/taglog/taglog_help_en.tag] } {
  set helpdir /usr/local/lib/taglog
  } elseif { [file readable /usr/share/taglog/taglog_help_en.tag] } {
  set helpdir /usr/share/taglog
  } elseif {  [ file readable /usr/share/doc/taglog/taglog_help_en.tag] } {
  set helpdir /usr/share/doc/taglog
  } elseif { [ file readable /usr/local/doc/taglog_help_en.tag] } {
  set helpdir /usr/local/doc
  }

  set docdir $helpdir

# preferred language

set language en


if { [llength $argv] >0} {

while {[string match -* [lindex $argv 0]]} {
   switch -exact -- [lindex $argv 0] {
     -c {
      set prefsfile [lindex $argv 1]
      set argv {}
      
	}


  }
  }


}


# Having set the defaults we will source /etc/taglog.conf if it exists

if {[file readable "/etc/taglog.conf"] } {
	source /etc/taglog.conf
	}


if { $prefsfile == "" } {

# This is for Unix
if {[file readable "~/.taglog"] } {
	source "~/.taglog"
	set prefsfile "~/.taglog"
	}
# If c:\Documents and Settings\username\taglog.cfg exists then use that.
if { $tcl_platform(platform) == "windows" } {
 if [ info exists env(USERPROFILE)] {
 set tf [file join $env(USERPROFILE) taglog.cfg]
 if { [file readable $tf] } {
       source $tf
       set prefsfile $tf
       }
 }
}

# This is a Windows fallback
if { [file readable "~/taglog.cfg"] } {
	source "~/taglog.cfg"
	set prefsfile "~/taglog.cfg"
	}

} else {
 # prefs must have been set from command line
 if { [file readable $prefsfile] } {
    source $prefsfile
    }

}


# If the preferences were not found then we should initialise then

if { $prefsfile == "" } {
	initprefs
}
# The following are automatically set, but depend on things from the user
# preferences

if { $actionsfilename == "" } { set actionsfilename "$rootdir/actions.tag" }
if { $projectsfilename == "" } { set projectsfilename "$rootdir/projects.tag" }
if { $html_public_dir == "" } { set html_public_dir "~/public_html" }
if { $html_private_dir == "" } { set html_private_dir "$rootdir/html" }
if { $contactsfilename == "" } { set contactsfilename "$rootdir/contacts.tag" }
if { $activitiesfilename == ""} { set activitiesfilename "$rootdir/activities" }

lappend actsel_filenames $actionsfilename
lappend actsel_filenames "$docdir/taglog_todo.tag"
set actsel_filename $actionsfilename

if { $dateformat_view=="DD/MM/YYYY" } {
 set dateformat_tcl "%d/%m/%Y" 
  } elseif { $dateformat_view=="MM/DD/YYYY" } {
 set dateformat_tcl "%m/%d/%Y"
 } else { set dateformat_tcl "%Y-%m-%d" }

# Reset current start and end using time format from preferences,
# so they appear correctly on boot
set currentStart [format $currentTimeFormat $hh $mm $ss]
set currentEnd [format $currentTimeFormat $hh $mm $ss]

# Post initialisation procedures
FindDefaultPrevday

#fill up the activities list from file
#
if {[file readable $activitiesfilename] } {
set fileid [open $activitiesfilename  r+]
seek $fileid 0 start
set buffer [read $fileid];
close $fileid
set activities [split $buffer "\n"];
}


# read the projects file
readprojects
}

proc initprefs {} {
global tcl_platform rootdir env prefsfile
# initialise the preferences file
# We should be able to just display the prefs dialog to let the user confirm

# Since we are in the first time we dont really know what the users language
# should be - default to the minimal mc so it exists when we call editPrefs

 proc mc { msg } {
   return $msg
    }

 wm iconify .

 if {$tcl_platform(platform) == "unix"} {
 set prefsfile "~/.taglog"
 } 
 if { $tcl_platform(platform) == "windows" } {
 if [ info exists env(USERPROFILE)] {
 set tf [file join $env(USERPROFILE) taglog.cfg]
 if { [file isdirectory $env(USERPROFILE)] } {
       set prefsfile $tf
       }
 }
 if { $prefsfile == "" } { set prefsfile "~/taglog.cfg"}
 }

# Create a blank preferences file
set header "# Preferences for taglog"
set marker "# above this line is automatically saved - put your changes below here"
set f [open $prefsfile w]
 puts $f "$header"
 puts $f "$marker"
 close $f

 editPrefs

 wm deiconify .

}

proc editprefsOK {} {
global docdir language editprefs_docdir editprefs_language
global editprefs_showtime_hours_per_day showtime_hours_per_day
global editprefs_showtime_spreadoverheads showtime_overheads
global editprefs_timebook_startlastweek timebook_startlastweek
global smtpv editprefs_smtp_thishost editprefs_smtp_mailhost editprefs_smtp_myemail editprefs_smtp_port editprefs_smtp_prefsfile
global editprefs_dateformat dateformat_view dateformat_tcl
global editprefs_rootdir rootdir
global editprefs_history_win_depth editprefs_current_win_depth editprefs_num_today_actions
global history_win_depth current_win_depth num_today_actions
global id_prefix editprefs_id_prefix
global helpdir editprefs_helpdir
global start_procs editprefs_start_procs exit_procs editprefs_exit_procs
global projects_url editprefs_projects_url
global editprefs_activitiesFile
global activities
global activitiesfilename
global libsdir editprefs_libsdir

global editprefs_timeformat currentTimeFormat

set activitiesfilename $editprefs_activitiesFile
set docdir $editprefs_docdir
set rootdir $editprefs_rootdir
set libsdir $editprefs_libsdir
# set helpdir $editprefs_helpdir
set language $editprefs_language
if { ( $showtime_hours_per_day < 24 ) && ( $editprefs_showtime_hours_per_day > 0) } {
 set showtime_hours_per_day $editprefs_showtime_hours_per_day
}
set showtime_spreadoverheads $editprefs_showtime_spreadoverheads
set timebook_startlastweek $editprefs_timebook_startlastweek
set dateformat_view $editprefs_dateformat
if { $dateformat_view=="DD/MM/YYYY" } {
 set dateformat_tcl "%d/%m/%Y"
 }  elseif { $dateformat_view=="MM/DD/YYYY" } {
  set dateformat_tcl "%m/%d/%Y" 
 } else { set dateformat_tcl "%Y-%m-%d" }

set currentTimeFormat $editprefs_timeformat
 
if { ($history_win_depth > 1) && ( $history_win_depth <80) } {
 set history_win_depth $editprefs_history_win_depth
}
if { ($current_win_depth >1) && ( $current_win_depth <80) } {
set current_win_depth $editprefs_current_win_depth
}
if { ($editprefs_num_today_actions >=0) && ($editprefs_num_today_actions <21) } {
 set num_today_actions $editprefs_num_today_actions
}
set id_prefix $editprefs_id_prefix
set start_procs [split [string trim $editprefs_start_procs]]
set projects_url $editprefs_projects_url
if {  [can_get_httprojects] } {
 catch {.mBar.projects.m entryconfigure 3 -state normal}
}

#fill up the activity list

if {[file readable $activitiesfilename]} {
set fileid [open $activitiesfilename  r+]
seek $fileid 0 start
set buffer [read $fileid];
close $fileid
set activities [split $buffer "\n"];
}

savePrefs

# save smtp preferences

if { $editprefs_smtp_prefsfile != "" } {

 set f [open $editprefs_smtp_prefsfile w]
 puts $f "# Preferences for smtp.tcl - created by taglog"
 puts $f "set smtpv(thishost) $editprefs_smtp_thishost"
 puts $f "set smtpv(mailhost) $editprefs_smtp_mailhost"
 puts $f "set smtpv(myemail) \"$editprefs_smtp_myemail\""
 puts $f "set smtpv(port) $editprefs_smtp_port"
 puts $f "set smtpv(initialised) 1"

 close $f
}

destroy .editprefs
}



proc editPrefs {} {
global tcl_platform env
global docdir language editprefs_docdir editprefs_language
global rootdir editprefs_rootdir libsdir editprefs_libsdir
global editprefs_showtime_hours_per_day showtime_hours_per_day
global editprefs_showtime_spreadoverheads showtime_spreadoverheads
global editprefs_timebook_startlastweek timebook_startlastweek
global smtpv editprefs_smtp_thishost editprefs_smtp_mailhost editprefs_smtp_myemail editprefs_smtp_port editprefs_smtp_prefsfile
global editprefs_dateformat dateformat_view dateformat_tcl
global editprefs_rootdir rootdir
global prefsfile
global editprefs_history_win_depth editprefs_current_win_depth editprefs_num_today_actions
global history_win_depth current_win_depth num_today_actions
global id_prefix editprefs_id_prefix
global helpdir editprefs_helpdir
global start_procs editprefs_start_procs exit_procs editprefs_exit_procs
global projects_url editprefs_projects_url
global activitiesfilename
global editprefs_activitiesFile

global editprefs_timeformat currentTimeFormat

set realprefs [file nativename $prefsfile]

toplevel .editprefs
wm title .editprefs "[mc {Edit Preferences}] in $realprefs"

# Files
set editprefs_docdir $docdir
frame .editprefs.docdir
menubutton .editprefs.docdir.l -text [mc "Documentation Directory"] -menu .editprefs.docdir.l.m
menu .editprefs.docdir.l.m
.editprefs.docdir.l.m add command -label [mc Help] -command "taghelp prefs_docdir"
entry .editprefs.docdir.v -textvariable editprefs_docdir -width 30
pack .editprefs.docdir.l .editprefs.docdir.v -side left -in .editprefs.docdir
pack .editprefs.docdir

set editprefs_libsdir $libsdir
frame .editprefs.libsdir
menubutton .editprefs.libsdir.l -text [mc "Library Directory"] -menu .editprefs.libsdir.l.m
menu .editprefs.libsdir.l.m
.editprefs.libsdir.l.m add command -label [mc Help] -command "taghelp prefs_libsdir"
entry .editprefs.libsdir.v -textvariable editprefs_libsdir -width 30
pack .editprefs.libsdir.l .editprefs.libsdir.v -side left -in .editprefs.libsdir
pack .editprefs.libsdir

set editprefs_rootdir $rootdir
frame .editprefs.rootdir
menubutton .editprefs.rootdir.l -text [mc "Data directory root"] -menu .editprefs.rootdir.l.m
menu .editprefs.rootdir.l.m
if { $tcl_platform(platform) == "windows" } {
 if [ info exists env(USERPROFILE)] {
 set df [file join $env(USERPROFILE) diary]
 if { [file isdirectory $env(USERPROFILE)] } {
       .editprefs.rootdir.l.m add command -label $df -command "set editprefs_rootdir \"$df\""
       }
 }
 }
.editprefs.rootdir.l.m add command -label "~/diary" -command "set editprefs_rootdir \"~/diary\""
.editprefs.rootdir.l.m add command -label "~/.taglog-diary" -command "set editprefs_rootdir \"~/.taglog-diary\""
.editprefs.rootdir.l.m add separator
.editprefs.rootdir.l.m add command -label [mc "Help"] -command "taghelp prefs_rootdir"
entry .editprefs.rootdir.v -textvariable  editprefs_rootdir -width 40

if { [info tclversion] >= 8.3 } {

button .editprefs.rootdir.pick -text [mc "Pick"] -command { set editprefs_rootdir [tk_chooseDirectory -title [mc "Data directory root"] -mustexist 0 -initialdir $editprefs_rootdir -parent .editprefs] }
  }
pack .editprefs.rootdir.l .editprefs.rootdir.v -side left -in .editprefs.rootdir
if { [info tclversion] >= 8.3 } { pack .editprefs.rootdir.pick -side left -in .editprefs.rootdir }
pack .editprefs.rootdir

# Activities file

set editprefs_activitiesFile "$activitiesfilename"
frame .editprefs.activitiesFile
menubutton .editprefs.activitiesFile.l -text [mc "Activities File"] -menu .editprefs.activitiesFile.l.m
menu .editprefs.activitiesFile.l.m
if { $tcl_platform(platform) == "windows" } {
    if [ info exists env(USERPROFILE)] {
	set df [file join $env(USERPROFILE) diary]
	if { [file isdirectory $env(USERPROFILE)] } {
	    .editprefs.activitiesFile.l.m add command -label $df -command "set editprefs_activitiesFile \"$df\""
	}
    }
}
.editprefs.activitiesFile.l.m add command -label "~/diary/activities" -command "set editprefs_activitiesFile \"~/diary/activities\""
.editprefs.activitiesFile.l.m add command -label "~/.taglog_actvities" -command "set editprefs_activitiesFile \"~/.taglog_activities\""
.editprefs.activitiesFile.l.m add separator
.editprefs.activitiesFile.l.m add command -label [mc "Help"] -command "taghelp prefs_activitiesfile"
entry .editprefs.activitiesFile.v -textvariable  editprefs_activitiesFile -width 40

if { [info tclversion] >= 8.3 } {
    
    button .editprefs.activitiesFile.pick -text [mc "Pick"] -command { set editprefs_activitiesFile [tk_getOpenFile -title [mc "Activities File"]  -initialdir $editprefs_rootdir -parent .editprefs] }
}


pack .editprefs.activitiesFile.l .editprefs.activitiesFile.v -side left -in .editprefs.activitiesFile
if { [info tclversion] >= 8.3 } { pack .editprefs.activitiesFile.pick -side left -in .editprefs.activitiesFile }
pack .editprefs.activitiesFile


# Language
set editprefs_language $language
frame .editprefs.language
menubutton .editprefs.language.l -text [mc Language] -menu .editprefs.language.l.m
menu .editprefs.language.l.m
.editprefs.language.l.m add command -label "English (en)" -command "set editprefs_language en"
.editprefs.language.l.m add command -label "Deutsch (de)" -command "set editprefs_language de"
.editprefs.language.l.m add command -label "Español (es) (minimal)" -command "set editprefs_language es"
.editprefs.language.l.m add command -label "Francais (fr) (minimal)" -command "set editprefs_language fr"
.editprefs.language.l.m add command -label "Ελληνικά (el) (minimal)" -command "set editprefs_language el"
.editprefs.language.l.m add command -label "Italiano (it) (minimal)" -command "set editprefs_language it"
.editprefs.language.l.m add command -label "Nederlands (nl) (minimal)" -command "set editprefs_language nl"
.editprefs.language.l.m add separator
.editprefs.language.l.m add command -label [mc Help] -command "taghelp prefs_language"
entry .editprefs.language.v -textvariable editprefs_language
pack .editprefs.language.l .editprefs.language.v -side left -in .editprefs.language
pack .editprefs.language

set editprefs_showtime_spreadoverheads $showtime_spreadoverheads
frame .editprefs.spreadoverheads
menubutton .editprefs.spreadoverheads.l -text [mc "Spread Overheads"] -menu .editprefs.spreadoverheads.l.m
menu .editprefs.spreadoverheads.l.m
.editprefs.spreadoverheads.l.m add command -label [mc Help] -command "taghelp prefs_showtime_spreadoverheads"
radiobutton .editprefs.spreadoverheads.off -relief flat -variable showtime_spreadoverheads -value off -text [mc Off]
radiobutton .editprefs.spreadoverheads.byday -relief flat -variable showtime_spreadoverheads -value byday -text [mc Day]
radiobutton .editprefs.spreadoverheads.byweek -relief flat -variable showtime_spreadoverheads -value byweek -text [mc Week]

# Put the Default time bookings report starts last week flag here too
set editprefs_timebook_startlastweek $timebook_startlastweek
menubutton .editprefs.spreadoverheads.l2 -text [mc "Time Bookings starts"] -menu .editprefs.spreadoverheads.l2.m
menu .editprefs.spreadoverheads.l2.m
.editprefs.spreadoverheads.l2.m add command -label [mc Help] -command "taghelp prefs_timebook_startlastweek"
radiobutton .editprefs.spreadoverheads.r1 -text [mc "last week"] -variable editprefs_timebook_startlastweek -value 1
radiobutton .editprefs.spreadoverheads.r2 -text [mc "this week"] -variable editprefs_timebook_startlastweek -value 0

pack .editprefs.spreadoverheads.l .editprefs.spreadoverheads.off .editprefs.spreadoverheads.byday .editprefs.spreadoverheads.byweek .editprefs.spreadoverheads.l2 .editprefs.spreadoverheads.r1 .editprefs.spreadoverheads.l2 .editprefs.spreadoverheads.r1 .editprefs.spreadoverheads.r2 -in .editprefs.spreadoverheads -side left
pack .editprefs.spreadoverheads



set editprefs_showtime_hours_per_day $showtime_hours_per_day
frame .editprefs.hours
menubutton .editprefs.hours.l -text [mc "Hours Worked per Day (decimal)"] -menu .editprefs.hours.l.m
menu .editprefs.hours.l.m
.editprefs.hours.l.m add command -label [mc Help] -command "taghelp prefs_showtime_hours_per_day"
entry .editprefs.hours.e -textvariable editprefs_showtime_hours_per_day -width 6
pack .editprefs.hours.l .editprefs.hours.e -side left -in .editprefs.hours
pack .editprefs.hours

set editprefs_dateformat $dateformat_view
frame .editprefs.dateformat
menubutton .editprefs.dateformat.l -text [mc "Date Format"] -menu .editprefs.dateformat.l.m
menu .editprefs.dateformat.l.m
.editprefs.dateformat.l.m add command -label "ISO (YYYY-MM-DD)" -command "set editprefs_dateformat \"YYYY-MM-DD\""
.editprefs.dateformat.l.m add command -label [mc "European (DD/MM/YYYY)"] -command "set editprefs_dateformat \"DD/MM/YYYY\""
.editprefs.dateformat.l.m add command -label [mc "American (MM/DD/YYYY)"] -command "set editprefs_dateformat \"MM/DD/YYYY\""
.editprefs.dateformat.l.m add separator
.editprefs.dateformat.l.m add command -label [mc "Help"] -command "taghelp prefs_dateformat"
entry .editprefs.dateformat.e -textvariable editprefs_dateformat
pack .editprefs.dateformat.l .editprefs.dateformat.e -side left -in .editprefs.dateformat
pack .editprefs.dateformat

set editprefs_timeformat $currentTimeFormat
frame .editprefs.timeformat
menubutton .editprefs.timeformat.l -text [mc "Time Format"] -menu .editprefs.timeformat.l.m
menu .editprefs.timeformat.l.m
.editprefs.timeformat.l.m add command -label [mc "Default (HH:MM:SS)"] -command "set editprefs_timeformat \"%d:%02d:%02d\""
.editprefs.timeformat.l.m add command -label [mc "No seconds (HH:MM)"] -command "set editprefs_timeformat \"%d:%02d\""
.editprefs.timeformat.l.m add separator
.editprefs.timeformat.l.m add command -label [mc "Help"] -command "taghelp prefs_timeformat"
entry .editprefs.timeformat.e -textvariable editprefs_timeformat
pack .editprefs.timeformat.l .editprefs.timeformat.e -side left -in .editprefs.timeformat
pack .editprefs.timeformat

set editprefs_history_win_depth $history_win_depth
frame .editprefs.history_win_depth
menubutton .editprefs.history_win_depth.l -text [mc "History Window Depth"] -menu .editprefs.history_win_depth.l.m
menu .editprefs.history_win_depth.l.m
.editprefs.history_win_depth.l.m add command -label [mc "Help"] -command "taghelp editprefs_history_win_depth"
entry .editprefs.history_win_depth.e -textvariable editprefs_history_win_depth
pack .editprefs.history_win_depth.l .editprefs.history_win_depth.e -side left -in .editprefs.history_win_depth
pack .editprefs.history_win_depth

set editprefs_current_win_depth $current_win_depth
frame .editprefs.current_win_depth
menubutton .editprefs.current_win_depth.l -text [mc "Current Window Depth"] -menu .editprefs.current_win_depth.l.m
menu .editprefs.current_win_depth.l.m
.editprefs.current_win_depth.l.m add command -label [mc "Help"] -command "taghelp editprefs_current_win_depth"
entry .editprefs.current_win_depth.e -textvariable editprefs_current_win_depth
pack .editprefs.current_win_depth.l .editprefs.current_win_depth.e -side left -in .editprefs.current_win_depth
pack .editprefs.current_win_depth

set editprefs_num_today_actions $num_today_actions
frame .editprefs.num_today_actions
menubutton .editprefs.num_today_actions.l -text [mc "Number of 'Today' actions"] -menu .editprefs.num_today_actions.l.m
menu .editprefs.num_today_actions.l.m
.editprefs.num_today_actions.l.m add command -label "0" -command "set editprefs_num_today_actions 0"
.editprefs.num_today_actions.l.m add command -label "1" -command "set editprefs_num_today_actions 1"
.editprefs.num_today_actions.l.m add command -label "2" -command "set editprefs_num_today_actions 2"
.editprefs.num_today_actions.l.m add command -label "3" -command "set editprefs_num_today_actions 3"
.editprefs.num_today_actions.l.m add separator
.editprefs.num_today_actions.l.m add command -label [mc "Help"] -command "taghelp editprefs_num_today_actions"
entry .editprefs.num_today_actions.e -textvariable editprefs_num_today_actions
pack .editprefs.num_today_actions.l .editprefs.num_today_actions.e -side left -in .editprefs.num_today_actions
pack .editprefs.num_today_actions

set editprefs_id_prefix $id_prefix
frame .editprefs.id_prefix
menubutton .editprefs.id_prefix.l -text "Id [mc Prefix]" -menu .editprefs.id_prefix.l.m
menu .editprefs.id_prefix.l.m
.editprefs.id_prefix.l.m add command -label [mc "Help"] -command "taghelp editprefs_id_prefix"
entry .editprefs.id_prefix.e -textvariable editprefs_id_prefix
pack .editprefs.id_prefix.l .editprefs.id_prefix.e -side left -in .editprefs.id_prefix
pack .editprefs.id_prefix

set editprefs_start_procs $start_procs
frame .editprefs.start_procs
menubutton .editprefs.start_procs.l -text [mc "Start Procs"] -menu .editprefs.start_procs.l.m
menu .editprefs.start_procs.l.m
.editprefs.start_procs.l.m add command -label "--" -command "set editprefs_start_procs \"\""
.editprefs.start_procs.l.m add command -label "iconify_mainwin doShowProjects" -command "set editprefs_start_procs \"iconify_mainwin doShowProjects\""
.editprefs.start_procs.l.m add separator
.editprefs.start_procs.l.m add command -label [mc "Help"] -command "taghelp editprefs_start_procs"
entry .editprefs.start_procs.e -textvariable editprefs_start_procs
pack .editprefs.start_procs.l .editprefs.start_procs.e -side left -in .editprefs.start_procs
pack .editprefs.start_procs

set editprefs_projects_url $projects_url
frame .editprefs.projects_url
menubutton .editprefs.projects_url.l -text [mc "Projects URL"] -menu .editprefs.projects_url.l.m
menu .editprefs.projects_url.l.m
.editprefs.projects_url.l.m add command -label [mc "Help"] -command "taghelp editprefs_projects_url"
entry .editprefs.projects_url.e -textvariable editprefs_projects_url -width 40
pack .editprefs.projects_url.l .editprefs.projects_url.e -side left -in .editprefs.projects_url
pack .editprefs.projects_url

smtp init

set editprefs_smtp_prefsfile $smtpv(prefsfile)
frame .editprefs.smtp_prefsfile
menubutton .editprefs.smtp_prefsfile.l -text [mc "SMTP Preferences filename"] -menu .editprefs.smtp_prefsfile.l.m
menu .editprefs.smtp_prefsfile.l.m
.editprefs.smtp_prefsfile.l.m add command -label "~/.smtp" -command "set editprefs_smtp_prefsfile \"~/.smtp\""
.editprefs.smtp_prefsfile.l.m add command -label "~/smtp.cfg" -command "set editprefs_smtp_prefsfile \"~/smtp.cfg\""
.editprefs.smtp_prefsfile.l.m add separator
.editprefs.smtp_prefsfile.l.m add command -label [mc Help] -command "taghelp smtp_prefsfile"
entry .editprefs.smtp_prefsfile.v -textvariable editprefs_smtp_prefsfile -width 15
pack .editprefs.smtp_prefsfile.l .editprefs.smtp_prefsfile.v -side left -in .editprefs.smtp_prefsfile
pack .editprefs.smtp_prefsfile

set editprefs_smtp_thishost $smtpv(thishost)
frame .editprefs.smtp_thishost
menubutton .editprefs.smtp_thishost.l -text "SMTP thishost" -menu .editprefs.smtp_thishost.l.m
menu .editprefs.smtp_thishost.l.m
.editprefs.smtp_thishost.l.m add command -label [mc Help] -command "taghelp smtp_thishost"
entry .editprefs.smtp_thishost.v -textvariable editprefs_smtp_thishost
pack .editprefs.smtp_thishost.l .editprefs.smtp_thishost.v -in .editprefs.smtp_thishost -side left
pack .editprefs.smtp_thishost

set editprefs_smtp_mailhost $smtpv(mailhost)
frame .editprefs.smtp_mailhost
menubutton .editprefs.smtp_mailhost.l -text "SMTP mailhost" -menu .editprefs.smtp_mailhost.l.m
menu .editprefs.smtp_mailhost.l.m
.editprefs.smtp_mailhost.l.m add command -label [mc Help] -command "taghelp smtp_mailhost"
entry .editprefs.smtp_mailhost.v -textvariable editprefs_smtp_mailhost -width 15
pack .editprefs.smtp_mailhost.l .editprefs.smtp_mailhost.v -side left -in .editprefs.smtp_mailhost
pack .editprefs.smtp_mailhost

set editprefs_smtp_myemail $smtpv(myemail)
frame .editprefs.smtp_myemail
menubutton .editprefs.smtp_myemail.l -text "SMTP [mc {email address}]" -menu .editprefs.smtp_myemail.l.m
menu .editprefs.smtp_myemail.l.m
.editprefs.smtp_myemail.l.m add command -label [mc Help] -command "taghelp smtp_myemail"
entry .editprefs.smtp_myemail.v -textvariable editprefs_smtp_myemail -width 20
pack .editprefs.smtp_myemail.l .editprefs.smtp_myemail.v -side left -in .editprefs.smtp_myemail
pack .editprefs.smtp_myemail

set editprefs_smtp_port $smtpv(port)
frame .editprefs.smtp_port
menubutton .editprefs.smtp_port.l -text "SMTP port" -menu .editprefs.smtp_port.l.m
menu .editprefs.smtp_port.l.m
.editprefs.smtp_port.l.m add command -label "25 ([mc traditional] SMTP)" -command "set editprefs_smtp_port 25"
.editprefs.smtp_port.l.m add command -label "587 ([mc {local mail submission port}])" -command "set editprefs_smtp_port 587"
.editprefs.smtp_port.l.m add separator
.editprefs.smtp_port.l.m add command -label [mc Help] -command "taghelp smtp_port"

entry .editprefs.smtp_port.v -textvariable editprefs_smtp_port -width 5
pack .editprefs.smtp_port.l .editprefs.smtp_port.v -side left -in .editprefs.smtp_port
pack .editprefs.smtp_port

frame .editprefs.bot
button .editprefs.bot.ok -text Ok -command editprefsOK
button .editprefs.bot.cancel -text [mc Cancel] -command { doCancel .editprefs }
button .editprefs.bot.help -text [mc Help] -command "taghelp editprefs"
pack .editprefs.bot.ok .editprefs.bot.cancel .editprefs.bot.help -side left -in .editprefs.bot
pack .editprefs.bot

tkwait window .editprefs


}

proc savePrefs {} {
global prefsfile tcl_platform
global docdir
global language
global showtime_hours_per_day
global dateformat_view dateformat_tcl
global rootdir libsdir
global num_today_actions history_win_depth current_win_depth
global id_prefix
global start_procs exit_procs
global projects_url
global showtime_spreadoverheads
global timebook_startlastweek
global activities
global activitiesfilename

global currentTimeFormat


set header "# Preferences for taglog"
set marker "# above this line is automatically saved - put your changes below here -"
if { $prefsfile !="" } {
 set f [open $prefsfile]
 set prev_prefs [read $f]

 close $f
# mangle previous preferences
 set autoend [string last $marker $prev_prefs]
 if { $autoend != -1 } {
   incr autoend [string length $marker]
   set prev_prefs [string trim [string range $prev_prefs $autoend end]]
   }


 set f [open $prefsfile w]
 puts $f "$header"
 puts $f "set language $language"
 puts $f "set showtime_hours_per_day $showtime_hours_per_day"
 puts $f "set docdir \"$docdir\""
 puts $f "set libsdir \"$libsdir\""
 puts $f "set rootdir \"$rootdir\""
 puts $f "set showtime_spreadoverheads $showtime_spreadoverheads"
 puts $f "set timebook_startlastweek $timebook_startlastweek"
 puts $f "set dateformat_view $dateformat_view"
 puts $f "set dateformat_tcl $dateformat_tcl"
 puts $f "set currentTimeFormat $currentTimeFormat"
 puts $f "set num_today_actions $num_today_actions"
 puts $f "set history_win_depth $history_win_depth"
 puts $f "set current_win_depth $current_win_depth"
 puts $f "set id_prefix \"$id_prefix\""
 puts $f "set start_procs \{ $start_procs \}"
 puts $f "set exit_procs $exit_procs"
 puts $f "set projects_url \"$projects_url\""
 puts $f "set activitiesfilename \"$activitiesfilename\""
 puts $f "$marker" 
 puts $f "$prev_prefs"

 close $f


} else {
 set prev_prefs ""
 # deal with new prefs file
 if {$tcl_platform(platform) == "unix"} {
 set prefsfile "~/.taglog"
 } elseif {$tcl_platform(platform) == "windows"} {
 set prefsfile "~/taglog.cfg"
 } else {
    puts "Unknown platform $tcl_platform(platform) - please report to john+taglog@paladin.demon.co.uk"
    exit
  }
 set f [open $prefsfile w]
 puts $f "$header"
 puts $f "$marker"
 puts $f "$prev_prefs"

 close $f



}

}


