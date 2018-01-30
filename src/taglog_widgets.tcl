package provide taglog_widgets 0.1
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# This file contains composed widgets and some utilities for the manipulation
# of these widgets
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++ the menu widget +++++++++++++++++++++++++++
# ---------------------- menu_create ------------------------------------
# creates or re-builds a menu button with a pull down menu, the menu 
# contains command buttons which call a user defined function and/or
# a help button and/or a menu entry "--" usually used to clear data

# mButton	name of the menu button
# mLabel	label for the menu button
# help		the help-id or "" if no help button is required
# blankSw	switch to allow the menu entry "--"
#		0 no menu entry "--"
#		1 menu entry "--"
#		"--" has to be handled by "cmd"
# lType		type of the list for button labels
#		see lType in "taglog_getList"
# cmd		name of the procedure that is called when a button in the menu
#		is pressed, if cmd == "menu_setText" the autocompletion
#		function for the entry widget "cmdData" is registered
#		the procedure has two parameters:
#			lab	the label text of the button
#			cmdData	user defined data (see next parameter)
# cmdData	user defined data expected for procedure "cmd"
proc menu_create {mButton mLabel help {blankSw 0} {lType ""} \
				{cmd ""} {cmdData ""}} {

   if {![winfo exists $mButton]} {
      # create the menu button
      menubutton $mButton -text $mLabel -menu $mButton.menu
   }
   if {[winfo exists $mButton.menu]} {
      # menu already exists, delete the menu entries
      $mButton.menu delete 0 end
   } else {
      menu $mButton.menu
   }


   set labCount 0
   if {$blankSw == 1} {
      # create a menu entry "--"
      if {$cmd != ""} {
        $mButton.menu add command -label "--" -command [list $cmd "--" $cmdData]
      } else {
        $mButton.menu add command -label "--"
      }
   }
   foreach memb [taglog_getList $lType] {
   # create the command buttons within the menu
      
      if {$memb != ""} {
	 incr labCount
         if {$cmd != ""} {
           $mButton.menu add command -label $memb \
	   		-command [list $cmd $memb $cmdData]
         } else {
           $mButton.menu add command -label $memb
         }
      }
   }
   if {$help != ""} {
   # help button requested
      if {$labCount > 0} {
	 # create separator widget if additional command buttons are available
         $mButton.menu add separator
      }
      $mButton.menu add command -label [mc Help] -command "taghelp $help"
   }
   if {$cmd == "menu_setText" && $cmdData != ""} {
   # because the entry widget is not jet registered we wait a few millisecs
      after 200 "autoCom_register $cmdData taglog_getList $lType"
   }
   return $mButton.menu
}

# ---------------------- menu_setText -----------------------------------
# sets the text in an entry widget with the label text of a menu command
# button
#
# label	text to be set
# win	entry widget

proc menu_setText {label win} {
   if {$win != ""} {
      if {[winfo exists $win]} {
         $win delete 0 end
	 if {$label != "--"} {
	    $win insert 0 $label
	 }
      }
   }
}

# +++++++++++++++++++++++++++ the calendar widget +++++++++++++++++++++++
# The global variable "LGL_calInfo" is only used in this file and only for
# the functions of the calendar widget


# ---------------------- tkCal_create -----------------------------------
# creates an calendar within a toplevel widget
#
# win		name of the toplevel widget
#		"auto" means that the function creates an unique widget name
# selCmd	command which will be executed when a day was selected
#		the command has the following parameters:
#		win	name of the toplevel calendar widget
#		date	list containing the selected date {year month day}
#		selData	additional information required by "selCmd"
# selData 	additional information required by "selCmd"
# day		the default day in the calendar, "this" means the current day
# month		the default month in the calendar,"this" means the current month
# year		the default year in the calendar, "this" means the current year
# colCmd	command which will be executed when creating a calendar button
#		if "colCmd" returns a color name the background is set to
#		this color
#		the command has the following parameters:
#		year	the year (four digits)
#		month	the month number 01, 02, ..., 11, 12
#		day	the day number 01, 02, ..., 30, 31
#		colData	additional information required by "colCmd"
#		return: name of a color or ""
# colData 	additional information required by "colCmd"
# helpId	if set, a HELP-button is created which calls "taghelp helpId"
#
# return:	the name of the toplevel widget
proc tkCal_create {{win "auto"} \
		   {selCmd ""} {selData ""} \
		   {day "this"} {month "this"} {year "this"} \
		   {colCmd ""} {colData ""} \
		   {helpId ""} } {
  global LGL_calInfo
  if {$win == "auto"} {
  # automatic naming of widget (e.g. .cal4)
      set count 0
      set win ".cal[incr count]"
      while {[winfo exists $win]} {
          set win ".cal[incr count]"
      }
  }
  toplevel $win -class "calendar"
  wm title $win [mc "calendar"]
  wm group $win .

  # calculate/set current date
  set secs [clock seconds]
  if {$year == "this"}  {set year [clock format $secs -format %Y]}
  if {$month == "this"} {set month [clock format $secs -format %m]}
  if {$day == "this"}   {set day [clock format $secs -format %d]}
  set secs [clock scan "$month/$day/$year"]
  set LGL_calInfo($win-defY)    $year
  set LGL_calInfo($win-defM)    [string trimleft $month 0]
  set LGL_calInfo($win-defD)    [string trimleft $day 0]
  set LGL_calInfo($win-actY)    $year
  set LGL_calInfo($win-actM)    [string trimleft $month 0]
  set LGL_calInfo($win-selCmd)     [string trim $selCmd]
  set LGL_calInfo($win-selData) $selData
  set LGL_calInfo($win-colCmd)     [string trim $colCmd]
  set LGL_calInfo($win-colData) $colData

  # header line with year, month and buttons to change th month
  set ymName "[mc [clock format $secs -format %B]] $year"

  frame $win.month -borderwidth 2 -relief raised
  pack  $win.month -side top -fill both -expand 1
  button $win.month.left  -text "<<" -pady 0 -command "tkCal_shift $win -1"
  label $win.month.month -text $ymName
  button $win.month.right -text ">>" -pady 0 -command "tkCal_shift $win 1"
  pack $win.month.left -side left
  pack $win.month.month -side left -expand 1 -fill both
  pack $win.month.right -side right

  # create the body
  tkCal_redraw $win

  # (HELP and) cancel button
  frame $win.buttons -borderwidth 2 -relief raised
  button $win.buttons.cancel -text [mc "Cancel"] \
  				-command "destroy $win" -width 6
  pack $win.buttons.cancel -side left -expand 1
  if {$helpId != ""} {
     button $win.buttons.help -text [mc "Help"] -command "taghelp $helpId" -width 6
     pack $win.buttons.help -side left -expand 1
  }
  pack  $win.buttons -side top -fill both -expand 1

  return $win
}

# ---------------------- tkCal_redraw -----------------------------------
# INTERNAL USE ONLY
# (re-)builds the body of the calendar, tht buttond with the days of a month
#
# win	name of the toplevel widget

proc tkCal_redraw {win} {
  global LGL_calInfo

  if {[winfo exists $win.cal]} {
  # delete existing buttons
     for {set i 6} {$i > 0} {incr i -1} {
       foreach j [grid slaves $win.cal -row $i] {
  	   destroy $j
       }
     }
  } else {
  # top row with abbreviations of the das names
     frame $win.cal -borderwidth 2 -relief sunken
     pack  $win.cal -side top -fill both -expand 1

     label $win.cal.so -text [mc Su]
     label $win.cal.mo -text [mc Mo]
     label $win.cal.di -text [mc Tu]
     label $win.cal.mi -text [mc We]
     label $win.cal.do -text [mc Th]
     label $win.cal.fr -text [mc Fr]
     label $win.cal.sa -text [mc Sa]
     grid $win.cal.so $win.cal.mo $win.cal.di $win.cal.mi \
          $win.cal.do $win.cal.fr $win.cal.sa -row 0 -sticky nsew
  }

  set actM $LGL_calInfo($win-actM)
  set actY $LGL_calInfo($win-actY)
  # get the highest day of the month
  foreach maxDays {31 30 29 28} {
    if {[catch {
             clock scan "$actM/$maxDays/$actY"
	       }] == 0} break
  }

  # get the starting position of the first day
  set secs [clock scan "$actM/1/$actY"]
  set icol [clock format $secs -format %w]

  # loop through days and build the buttons
  set irow 1
  for {set i 1} {$i <= $maxDays} {incr i} {
    button $win.cal.b$i -text $i -command "puts $i" \
    		    -borderwidth 1 -highlightthickness 1 -highlightcolor red
    grid configure $win.cal.b$i -column $icol -row $irow -sticky nsew
    if {$LGL_calInfo($win-selCmd) != ""} {
    # set the selection command
       $win.cal.b$i configure -command [list $LGL_calInfo($win-selCmd) $win \
       		[list $actY $actM $i] \
		$LGL_calInfo($win-selData)]
    }
    if {$LGL_calInfo($win-colCmd) != ""} {
    # set the background color of the button
       set color [$LGL_calInfo($win-colCmd) $actY $actM $i $LGL_calInfo($win-colData)]
       if {$color != ""} {
          $win.cal.b$i configure -background $color -activebackground $color
       }
    }
    if {$icol == 6} {
       set icol 0
       incr irow
    } else {
       incr icol
    }
  }
  if {$LGL_calInfo($win-actY) == $LGL_calInfo($win-defY) && \
      $LGL_calInfo($win-actM) == $LGL_calInfo($win-defM)} {
    # set the focus to the default day
    focus $win.cal.b$LGL_calInfo($win-defD)
  }
  return
}

# ---------------------- tkCal_shift ------------------------------------
proc tkCal_shift {win mShift} {
# INTERNAL USE ONLY
# callback function to increase or de-crease the month
#
# win	name of the toplevel widget
# mShift	number of month to be shifted, a negative number means
#		to de-crease
  global LGL_calInfo

  if {$mShift == 0} return

  set yy  $LGL_calInfo($win-actY)
  set mm  [expr $LGL_calInfo($win-actM) + $mShift]
  if {$mm > 12} {
     set mm 1
     incr yy
  } elseif {$mm < 1} {
     set mm 12
     incr yy -1
  }

  set LGL_calInfo($win-actY) $yy
  set LGL_calInfo($win-actM) $mm

  # update the month (and year) in the header
  set secs [clock scan "$LGL_calInfo($win-actM)/1/$LGL_calInfo($win-actY)"]
  set ymName "[mc [clock format $secs -format %B]] $LGL_calInfo($win-actY)"
  $win.month.month configure -text $ymName
  tkCal_redraw $win
}
# ---------------------- calUtil_menu --------------------------------------
# creates a menu entry for date selection using a calendar
#
# menuW	name of the pull down menu
# dateFormat	format of the date string in the entry widget
#		three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24) DEFAULT
# colCmd	command which will be executed when creating a calendar button
#		if "colCmd" returns a color name the background is set to
#		this color
#		the command has the following parameters:
#		year	the year (four digits)
#		month	the month number 01, 02, ..., 11, 12
#		day	the day number 01, 02, ..., 30, 31
#		colData	additional information required by "colCmd"
#		return: name of a color or ""
# colData 	additional information required by "colCmd"
# helpId	if set, a HELP-button is created which calls "taghelp helpId"
proc calUtil_menu {menuW entryW {dateFormat "YYYY-MM-DD"} \
		   {colCmd ""} {colData ""} \
		   {helpId ""} } {
   $menuW add command -label [mc "Calendar"] -command \
	"calUtil_open $entryW $dateFormat $colCmd [list $colData] $helpId"

}
# ---------------------- calUtil_win ---------------------------------------
# creates a combined widget for date selection consisting of an entry widget
# (containing the date string), a button which allows to open a calendar and
# a container for the two widgets
#
# win		name of the container widget
# dateFormat	format of the date string in the entry widget
#		three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24) DEFAULT
# tVar		name of a global text variable for the entry widget,
#		MDOIFIED
# width		the width of the entry widget in no. of characters
# colCmd	command which will be executed when creating a calendar button
#		if "colCmd" returns a color name the background is set to
#		this color
#		the command has the following parameters:
#		year	the year (four digits)
#		month	the month number 01, 02, ..., 11, 12
#		day	the day number 01, 02, ..., 30, 31
#		colData	additional information required by "colCmd"
#		return: name of a color or ""
# colData 	additional information required by "colCmd"
# helpId	if set, a HELP-button is created which calls "taghelp helpId"
#
# return:	name of the entry widget
proc calUtil_win {win {dateFormat "YYYY-MM-DD"} {tVar ""} {width 10} \
		   {colCmd ""} {colData ""} \
		   {helpId ""} } {
global CALIMAGE
   frame $win
   pack  $win

   entry $win.date -textvariable $tVar -width $width
   button $win.doit -bitmap @$CALIMAGE \
   	-command "calUtil_open $win.date $colCmd [list colData] $helpId"
   pack $win.date $win.doit -side left -fill both -expand 1

   return  $win.date
}

# ---------------------- calUtil_open --------------------------------------
# opens a calendar widget
#
# entryWin	entry widget which is going to be update by the calendar
# dateFormat	format of the date string in the entry widget
#		three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24) DEFAULT
# colCmd	command which will be executed when creating a calendar button
#		if "colCmd" returns a color name the background is set to
#		this color
#		the command has the following parameters:
#		year	the year (four digits)
#		month	the month number 01, 02, ..., 11, 12
#		day	the day number 01, 02, ..., 30, 31
#		colData	additional information required by "colCmd"
#		return: name of a color or ""
# colData 	additional information required by "colCmd"
# helpId	if set, a HELP-button is created which calls "taghelp helpId"
proc calUtil_open {entryWin {dateFormat "YYYY-MM-DD"} \
		   {colCmd ""} {colData ""} \
		   {helpId ""} } {
   set dateStr [calUtil_parse $dateFormat [$entryWin get]]
   if {$dateStr == ""} {
      set yy "this"
      set mm "this"
      set dd "this"
   } else {
      set yy [lindex $dateStr 0]
      set mm [lindex $dateStr 1]
      set dd [lindex $dateStr 2]
   }
   tkCal_create "auto" "calUtil_set" \
   	[list $entryWin $dateFormat] $dd $mm $yy $colCmd $colData $helpId
}

# ---------------------- calUtil_parse -------------------------------------
# parses a date string
#
# dateFormat	expected format of the date string, three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24)
# date		the date string to be parsed
#
# return:	a list of three numbers: {YYYY MM DD}      (e.g. {2001 01 24})
#		or empty string if failed
proc calUtil_parse {dateFormat date} {
   set date [string trim $date]
   if {[string length $date] < 6 || [string length $date] > 10 || \
     [catch {
      if {$dateFormat == "DD/MM/YYYY"} {
         regsub -all -- "/" $date " " dateStr
   	 set yy [lindex $dateStr 2]
   	 set mm [lindex $dateStr 1]
   	 set dd [lindex $dateStr 0]
      } elseif {$dateFormat == "MM/DD/YYYY"} {
         regsub -all -- "/" $date " " dateStr
   	 set yy [lindex $dateStr 2]
   	 set mm [lindex $dateStr 0]
   	 set dd [lindex $dateStr 1]
      } else {
         regsub -all -- "-" $date " " dateStr
   	 set yy [lindex $dateStr 0]
   	 set mm [lindex $dateStr 1]
   	 set dd [lindex $dateStr 2]
      }
      # re-calculate the date string to check for a correct date
      set date [clock format [clock scan "$mm/$dd/$yy"] -format "%Y-%m-%d"]
      scan $date "%4d-%2d-%2d" yy mm dd
   }]} {
   # parsing failed
      return ""
   }

   return [format "%4d %02d %02d" $yy $mm $dd]
}

# ---------------------- calUtil_set ---------------------------------------
# callback function for the calendar window, fills an entry widget with a
# date string and closes the calender
# INTERNAL USE ONLY
#
# calWin	the toplevel widget of the calendar
# date		list containing the date {year month day}
# cmdInfo	additional information used for this function,
#		list with 2 elements: target window (entry widget) and
#				      date format
proc calUtil_set {calWin date cmdInfo} {
   set tgWin [lindex $cmdInfo 0]
   set dateFormat [lindex $cmdInfo 1]
   if {[winfo exists $tgWin]} {
      # erase the old string
      $tgWin delete 0 end
      set year  [lindex $date 0]
      set month [lindex $date 1]
      set day   [lindex $date 2]
      # insert the new string
      if {$dateFormat == "DD/MM/YYYY"} {
         $tgWin insert 0 [format "%02d/%02d/%4d" $day $month $year]
      } elseif {$dateFormat == "MM/DD/YYYY"} {
         $tgWin insert 0 [format "%02d/%02d/%4d" $month $day $year]
      } else {
         $tgWin insert 0 [format "%4d-%02d-%02d" $year $month $day]
      }
   }

   # colse the calendar
   destroy $calWin
}
# +++++++++++++++++++++++++++ automatic completion of text ++++++++++++++
# The global variable "LGL_autoC" is only used in this file and only for
# the automatic completion of text
# ---------------------- autoCom_register -------------------------------
# registers an key-event driven procedure to complete text in an entry widget
# the list of text strings used for the completion are provided by an
# application defined function
#
# entW		name of the entry widget
# cmd		application defined function which provides a list of
#		strings. "cmd" has one parameter "cmdArgs". If "cmd" 
#		is "" then the parameter "cmdArgs" is used as the list. 
# cmdArgs	list of arguments for function "cmd" or in case of an
#		empty "cmd" it is the list used for the completion
#
# required global variables:
# GL_autoComCase 	switch to ignore the case: 0=no, 1=yes
# GL_autoComMsec	"GL_autoComMsec" milliseconds after a keyboard input
#			the completion is performed
#			0 means: compleation after <ESC> key only
proc autoCom_register {entW cmd cmdArgs} {
   global LGL_autoC
   global GL_autoComCase
   global GL_autoComMsec

   set idx 0
   # get a free identification number for "LGL_autoC"
   while {[info exists LGL_autoC($idx-entW)]} {incr idx}

   set LGL_autoC($idx-entW)    $entW
   set LGL_autoC($idx-cmd)     $cmd
   set LGL_autoC($idx-cmdArgs) $cmdArgs
   set LGL_autoC($idx-mSecs)   $GL_autoComMsec
   set LGL_autoC($idx-caseSw)  $GL_autoComCase
   set LGL_autoC($idx-string)  [$entW get]
   if {$GL_autoComMsec > 0} {
      # for all KeyRelease events
      set kEvent <KeyRelease>
   } else {
      # for <Esc>-KeyPress event
      set kEvent <Escape>
   }
   bind $entW $kEvent "autoCom_keyEvent $idx %K"

   # free entries in global variable when the widget gets destroyed
   bind $entW Destroy "autoCom_unset $idx"
   return idx
}
# ---------------------- autoCom_keyEvent -------------------------------
# INTERNAL USE ONLY
# function called by the key binding defined in autoCom_register
#
# idx		unique identification used for "LGL_autoC"
# key		keysymbol
proc autoCom_keyEvent {idx key} {
   global LGL_autoC
   # global information available?
   if {![info exists LGL_autoC($idx-entW)]} return
   if {![winfo exists $LGL_autoC($idx-entW)]} return
   set LGL_autoC($idx-string) [$LGL_autoC($idx-entW) get]

   if {[info exists LGL_autoC($idx-afterId)]} {
      # cancel older completion requests
      after cancel $LGL_autoC($idx-afterId)
   }
   # the following keys have no automatic completion
   if {$key == "BackSpace" || \
       $key == "Left" || \
       $key == "Right" || \
       $key == "Delete"} return

   if {$LGL_autoC($idx-mSecs) > 0 && $key != "Escape"} {
      # start completion after "LGL_autoC($idx-mSecs)" milliseconds
      set LGL_autoC($idx-afterId) \
   		[after $LGL_autoC($idx-mSecs) "autoCom_doIt $idx"]
   } else {
      # start completion now
      autoCom_doIt $idx
   }
}
# ---------------------- autoCom_doIt -----------------------------------
# INTERNAL USE ONLY
# completion function
#
# idx		unique identification used for "LGL_autoC"
proc autoCom_doIt idx {
   global LGL_autoC

   if {[info exists LGL_autoC($idx-afterId)]} {
      # unset the timer-Id
      unset LGL_autoC($idx-afterId)
   }
   # global information available?
   if {![info exists LGL_autoC($idx-entW)]} return
   if {![winfo exists $LGL_autoC($idx-entW)]} return

   set str [$LGL_autoC($idx-entW) get]
   # a completion is done only if the input string hasn't changed during the
   # waiting period
   if {$LGL_autoC($idx-string) != $str} return
   
   set LGL_autoC($idx-string) $str
   if {$str == ""} return

   if {$LGL_autoC($idx-cmd) == ""} {
     # cmdArgs contains the list for completion
     set xList $LGL_autoC($idx-cmdArgs)
   } else {
     # cmd provides the list for completion
     set xList [$LGL_autoC($idx-cmd) $LGL_autoC($idx-cmdArgs)]
   }
   # build a list of all members in the list which start with the string
   # input in the entry widget
   if {$LGL_autoC($idx-caseSw)} {
      set strC [string tolower $str]
      foreach i $xList {
         if {[string match ${strC}* [string tolower $i]]} {lappend iList $i}
      }
   } else {
      foreach i $xList {
         if {[string match ${str}* $i]} {lappend iList $i}
      }
   }
   if {[info exists iList]} {
      set nStr [autoCom_check [string length $str] $iList $LGL_autoC($idx-caseSw)]
      $LGL_autoC($idx-entW) delete 0 end
      $LGL_autoC($idx-entW) insert 0 [lindex $nStr 1]
      if {![lindex $nStr 0]} bell
   }
}

# ---------------------- autoCom_check ----------------------------------
# INTERNAL USE ONLY
# provides the maximum text string all members of a list start with
#
# iLen		the number of characters which are identical in all members
#		of the list
# iList		list with text strings, at least the first "iLen" characters
#		of each string are identical
# caseSw	switch to ignore the case of the letters
#		0 do NOT ignore the case
#		1 ignore the case
#
# return:	list of two parameters {iSw maxStr}
#		iSw:	switch
#			0 input string extended, more than one list member
#			  starts with this string
#			1 input string not extended or the extension matches
#			  exactly one member
#		maxStr:	text string all members of the list "iList" start with
proc autoCom_check {iLen iList caseSw} {
   if {$iLen < 1 || [llength $iList] < 1} {return {"1" ""}}

   set m1 [lindex $iList 0]
   # only one member in the list?
   if {[llength $iList] == 1} {return "1 [list $m1]"}

   set l1 [string length $m1]
   set retVal [string range $m1 0 [expr $iLen -1]]
   set iSw 1
   for {set i $iLen} {$i < $l1} {incr i} {
      set cTst [string index $m1 $i]
      if {$caseSw} {set cTst [string tolower $cTst]}
      foreach m [lrange $iList 1 end] {
         if {[string length $m] <= $i} {return "$iSw [list $retVal]"}
	 if {$caseSw} {
	    if {[string tolower [string index $m $i]] != $cTst} {
	       return "$iSw [list $retVal]"
	    }
	 } else {
	    if {[string index $m $i] != $cTst} {return "$iSw [list $retVal]"}
	 }
      }
      set retVal [string range $m1 0 $i]
      set iSw 0
   }
   foreach m [lrange $iList 1 end] {
      if {[string length $m] > $i} {return "0 [list $m1]"}
   }
   return "1 [list $m1]"
}
# ---------------------- autoCom_unset ----------------------------------
# INTERNAL USE ONLY
# unsets all entries of the global array LGL_autoC associated with "idx"
#
# idx		unique identification used for "LGL_autoC"
proc autoCom_unset idx {
   global LGL_autoC

   foreach i [array names "$idx-*"] {
      unset LGL_autoC($i)
   }
   # only for higher tcl version
   #array unset LGL_autoC "$idx-*"
}
