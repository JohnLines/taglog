package provide logEdit 0.1
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# This file contains functions for editing of log entries
#
# The global variable "LGL_Shell" is only used in this file
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ---------------------- logEdit_selDay ---------------------------------
# creates shell to select the date of the log file to be input/edited
# if the shell already exists it will be raised
#
# win	name of the shell to be created
proc logEdit_selDay {win} {
global CALIMAGE
global dateformat_view

   if {[winfo exists $win]} {
   # popup the shell if it exists
      raise $win
      return
   }

   toplevel $win -class "logEdit"
   wm title $win [mc "Log edit"]

   label $win.lab1 -text "[mc {Input and editing of log entries}]\n"
   label $win.lab2 -text "[mc {Please select the date of log}]\n[mc {entries to be input or edited}]\n"
   pack  $win.lab1 $win.lab2 -side top

   frame $win.date -borderwidth 10
   entry $win.date.e -width 10
   focus $win.date.e
   button $win.date.b -bitmap @$CALIMAGE -command \
	"calUtil_open $win.date.e $dateformat_view logEdit_setCalCol {} led_calendar"
   pack $win.date.e $win.date.b -side left
   pack $win.date -side top

   frame $win.frm -relief sunken -borderwidth 2
   button $win.frm.ok -text OK -width 7 \
   		-command "logEdit_selOk $win $win.date.e $dateformat_view"
   button $win.frm.cancel -text [mc Cancel] -width 7 -command "destroy $win"
   pack $win.frm.ok $win.frm.cancel -side left -fill x 
   pack $win.frm -side top -expand 1 -fill x
}
# ---------------------- logEdit_selOk ----------------------------------
# INTERNAL USE ONLY
# OK callback for the date selection, destroys the selection shell after
# creation of the shell containing the log entries for one day
#
# win		the date selection shell
# eWin		the entry widget containing the date string
# dateFormat	format of the date string in the entry widget
#		three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24) DEFAULT
proc logEdit_selOk {win eWin dateFormat} {
   set date [string trim [$eWin get]]

   # check parameterinput
   if {$date == ""} {
      tk_messageBox -icon error -title [mc "Date selection"] -type ok \
      		-message [mc "No date selected"]
      return
   }
   if {[calUtil_parse $dateFormat $date] == ""} {
      tk_messageBox -icon error -title [mc "Date selection"] -type ok \
      		-message [mc "Invalid date format"]
      return
   }
   # create the shell containing the log entries for the selected day
   logEdit_dayShell $date $dateFormat

   # destroy the date selection shell
   destroy $win
}
# ---------------------- logEdit_dayShell -------------------------------
# creates an editing shell containing the log entries for one day
#
# date		the shell will contain log entries for this day
#		default: the current day
# dateFormat	format of the date string in the entry widget
#		three formats are available:
#		DD/MM/YYYY	(e.g. 24/01/2001 or 24/1/01)
#		MM/DD/YYYY	(e.g. 01/24/2001 or 1/24/01)
#		YYYY-MM-DD	(e.g. 2001-01-24 or 01-1-24) DEFAULT
proc logEdit_dayShell {{date ""} {dateFormat "YYYY-MM-DD"}} {
   global LGL_Shell
   global rootdir
   
   if {$date == ""} {
   # set default date
      set date [clock format [clock seconds] -format "%Y-%m-%d"]
   }
   # parse/check the date string
   set dateStr [calUtil_parse $dateFormat $date]
   if {$dateStr == ""} return

   set mmddStr [lindex $dateStr 1][lindex $dateStr 2]
   set yyyyStr [lindex $dateStr 0]
   # this is an unique ID for the global array "LGL_Shell"
   set idx "$yyyyStr$mmddStr"

   # shell already opened?
   if {[array get LGL_Shell $idx-shell] != ""} {
      if {[winfo exists $LGL_Shell($idx-shell)]} {
         raise $idx-shell
	 return
      }
      logEdit_unset $idx
   }
   set LGL_Shell($idx-file) $rootdir/log$yyyyStr/$mmddStr.tag
   set LGL_Shell($idx-shell) ".log$idx"
   set LGL_Shell($idx-date) "$date"
   # load the log entries into "LGL_Shell($idx-entries)"
   logEdit_loadFile $idx
   # build the shell
   logEdit_shell date $idx [mc "Editing of log file"] "[mc Day]:    $date" \
   						"led_entList"
}
# ---------------------- logEdit_fileShell ------------------------------
# creates a shell containing a list of all log entries of a log file
#
# filenam	full path name of the log file
# pIdx		index for "LGL_Shell" of the parent shell
proc logEdit_fileShell {filename pIdx} {
   global LGL_Shell
   
   if {! [file exists $filename]} return

   # get a new name for the shell
   set i 0
   while {[array get LGL_Shell F$i-shell] != ""} {incr i}
   set idx F$i
   set LGL_Shell($idx-sensWid) ""
   set LGL_Shell($idx-file) $filename
   set LGL_Shell($idx-shell) "$LGL_Shell($pIdx-shell).file$idx"
   set LGL_Shell($idx-pIdx) $pIdx

   # load entries off the file
   if {[logEdit_loadFile $idx] > 0} {
      # create the shell
      logEdit_shell file $idx [mc "Import of log entries"] \
      				"[mc File]:    $filename" "led_impList"
   } else {
      logEdit_unset $idx
      tk_messageBox -icon warning -title "Import" -type ok \
      		-message "[mc {No entries found in file}] [file tail $filename]"
   }
}
# ---------------------- logEdit_shell ----------------------------------
# INTERNAL USE ONLY
# creates a shell widget containing a list with log entries for
# input, editing or import
#
# type		the shell type:
#		file	for import of log entries from a file
#		date	for input and editing of log entries
# idx		unique identification used for "LGL_Shell"
# title		the shell title
# header	the top label in the shell
# helpid	a HELP-button is created which calls "taghelp helpid"
proc logEdit_shell {type idx title header helpid} {
   global LGL_Shell
   global GL_tableFont

   # create a new shell
   set win $LGL_Shell($idx-shell)
   toplevel $win -class "logEdit"
   wm title $win $title
   wm protocol $win WM_DELETE_WINDOW "logEdit_unset $idx"

   label $win.date -text $header -relief groove -padx 5 -pady 3
   pack $win.date -side top

   # list with log entries
   frame $win.body -relief sunken -borderwidth 2
   frame $win.body.frm
   label $win.body.frm.lab -text "    Start     [mc {End }]      [mc Project]" \
   		-font $GL_tableFont -anchor w -padx 2
   listbox $win.body.frm.listw -height 20 -width 40 -selectmode extended \
   		-font $GL_tableFont -yscroll "$win.body.vscr set" -setgrid 1
   bind $win.body.frm.listw <<ListboxSelect>> "logEdit_setSens $idx"
   bind $win.body.frm.listw <Double-Button-1> "logEdit_edit $idx"
   scrollbar $win.body.vscr -orient vertical   -command "$win.body.frm.listw yview"
   pack $win.body.frm.lab -side top -fill x -expand 1
   pack $win.body.frm.listw -side top -fill both -expand 1
   set LGL_Shell($idx-listw) $win.body.frm.listw
   pack $win.body.frm -side left -fill both -expand 1
   pack $win.body.vscr -side left -fill y

   if {$type == "date"} {
      # build popup menu for adjustment of time ranges
      logEdit_menu $win.body.frm.listw $idx
      # action buttons for editing of log entries
      set aButton [logEdit_eButtons $win.body $idx]
      pack $aButton -side left -fill y
   }
   pack $win.body -side top -fill both -expand 1
   logEdit_fill $idx

   # control buttons
   frame $win.control -relief sunken -borderwidth 2
   if {$type == "date"} {
      button $win.control.ok -text OK -width 10 \
      				-command "logEdit_shellOK $idx"
      pack $win.control.ok -side left -fill y -expand 1
   } else {
      # import buttons
      logEdit_iButtons $win.control $idx
   }
   button $win.control.cancel -text [mc Cancel] -width 10 \
   				-command "logEdit_destroy $idx"
   button $win.control.help -text [mc Help] -width 10 \
   				-command "taghelp $helpid"
   pack $win.control.cancel $win.control.help \
   				-side left -fill y -expand 1
   pack $win.control -side top -fill y -expand 1
}
# ---------------------- logEdit_iButtons -------------------------------
# INTERNAL USE ONLY
# creates additional buttons for the import
#
# parent	the name of the parent widget of the buttons
# idx		unique identification used for "LGL_Shell"
proc logEdit_iButtons {parent idx} {
   global LGL_Shell

   button $parent.impall -text [mc "Import all"] -width 10 \
      				-command "logEdit_impAll $idx"
   button $parent.impsel -text [mc "Import"] -width 10 \
      				-command "logEdit_impSel $idx" \
      				-state disabled
   pack $parent.impall $parent.impsel -side left -fill y -expand 1
   set LGL_Shell($idx-sensWid) "$parent.impsel"
}
# ---------------------- logEdit_eButtons -------------------------------
# INTERNAL USE ONLY
# creates additional buttons for the input and editing
#
# parent	the name of the parent widget of the buttons
# idx		unique identification used for "LGL_Shell"
proc logEdit_eButtons {parent idx} {
   global LGL_Shell
   # action buttons
   frame $parent.action
   button $parent.action.edit   -text "[mc Edit]..." \
   				-command "logEdit_edit $idx" \
   				-state disabled
   button $parent.action.add    -text [mc Add...] \
   				-command "logEdit_edShell $idx -1"
   button $parent.action.delete -text [mc Delete] \
   				-command "logEdit_delete $idx" \
   				-state disabled
   button $parent.action.import -text "[mc Import]..." \
   				-command "logEdit_impFile $idx"
   set LGL_Shell($idx-sensWid) "$parent.action.edit $parent.action.delete"
   pack $parent.action.edit \
        $parent.action.add \
	$parent.action.delete \
	$parent.action.import \
   	-side top -fill x
   return $parent.action
}
# ---------------------- logEdit_setSens --------------------------------
# INTERNAL USE ONLY
# changes the sensitivity of buttons which are only active if item(s) are
# selected in the list of log entries
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_setSens {idx} {
   global LGL_Shell

   if {[llength [$LGL_Shell($idx-listw) curselection]] > 0} {
      # item(s) selected, activate the button
      set status normal
   } else {
      # NO item selected, disable the button
      set status disabled
   }

   # loop over button widgets
   foreach wid $LGL_Shell($idx-sensWid) {
      if {[winfo exists $wid]} {
         $wid configure -state $status
      }
   }
}
# ---------------------- logEdit_edit -----------------------------------
# INTERNAL USE ONLY
# callback function to start the editing of selected log entries
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_edit idx {
   global LGL_Shell

   set sel [$LGL_Shell($idx-listw) curselection]
   # entries selected?
   if {$sel == ""} return

   # loop over selected items and create an edit shell for each item
   foreach ipos $sel {
      logEdit_edShell $idx $ipos
   }
}
# ---------------------- logEdit_delete ---------------------------------
# INTERNAL USE ONLY
# callback function to delete selected log entries
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_delete idx {
   global LGL_Shell

   set sel [$LGL_Shell($idx-listw) curselection]
   # entries selected?
   if {$sel == ""} return
   set sel [lsort -integer -decreasing $sel]

   # loop over selected items and delete them
   foreach i $sel {
      set LGL_Shell($idx-entries) [lreplace $LGL_Shell($idx-entries) $i $i]
   }
   # update the display of the list
   logEdit_fill $idx

   # disable editing buttons
   logEdit_setSens $idx
}
# ---------------------- logEdit_impFile --------------------------------
# INTERNAL USE ONLY
# callback function to select a file for import and to open the import shell
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_impFile idx {

   # file types for the file selection
   set types {
      {"Tag Files"   .tag}
      {"Text Files"  .txt}
      {"All Files"   *}
   }

   # file selection shell
   set filename [tk_getOpenFile -filetypes $types -title "Import of log file"]
   if {$filename != ""} {
      # file selected, open the import shell
      logEdit_fileShell $filename $idx
   }
}
# ---------------------- logEdit_impSel ---------------------------------
# INTERNAL USE ONLY
# callback function to add the selected entries to the parent list
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_impSel idx {
   global LGL_Shell

   set sel [$LGL_Shell($idx-listw) curselection]
   # entries selected?
   if {$sel == ""} return
   set pIdx $LGL_Shell($idx-pIdx)
   # loop over selected items and add them to the parent list
   foreach i $sel {
      lappend LGL_Shell($pIdx-entries) [lindex $LGL_Shell($idx-entries) $i]
   }
   # sort the parent list
   set LGL_Shell($pIdx-entries) \
       [lsort -command logEdit_sTimeSort $LGL_Shell($pIdx-entries)]
   # update the display of the list
   logEdit_fill $pIdx
   # destroy the selection shell
   logEdit_destroy $idx
}
# ---------------------- logEdit_impAll ---------------------------------
# INTERNAL USE ONLY
# callback function to add all entries to the parent list
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_impAll idx {
   global LGL_Shell

   set pIdx $LGL_Shell($idx-pIdx)
   if {[info exists LGL_Shell($pIdx-entries)]} {
      append LGL_Shell($pIdx-entries) " " $LGL_Shell($idx-entries)
   } else {
      set LGL_Shell($pIdx-entries) $LGL_Shell($idx-entries)
   }
   # sort the parent list
   set LGL_Shell($pIdx-entries) \
       [lsort -command logEdit_sTimeSort $LGL_Shell($pIdx-entries)]
   # update the display of the list
   logEdit_fill $pIdx
   # destroy the selection shell
   logEdit_destroy $idx
}
# ---------------------- logEdit_sTimeSort ------------------------------
# compare function used in "lsort" to sort log entries according to their
# StartTime
#
# tagList1	first taglist
# tagList2	second taglist
#
# return:	 1 first StartTime greater than second StartTime
#		-1 first StartTime less than second StartTime
#		 0 first StartTime equal to second StartTime
proc logEdit_sTimeSort {tagList1 tagList2} {
   set t1 [logEdit_tagVal $tagList1 StartTime]
   set t2 [logEdit_tagVal $tagList2 StartTime]
   if {[catch {set s1 [clock scan $t1]}]} {set s1 -99999}
   if {[catch {set s2 [clock scan $t2]}]} {set s2 -99999}
   if {$s1 > $s2} {return 1}
   if {$s1 < $s2} {return -1}
   return -1
}
# ---------------------- logEdit_tagVal ---------------------------------
# provides the value for a given tag out of a tag list
#
# tagList	the tag list
# tagName	the name of the tag
#
# return:	the value associated with the tag "tagName"
#		or "" if there is no tag with that name
proc logEdit_tagVal {tagList tagName} {
   foreach i $tagList {
      if {[lindex $i 0] == $tagName} {
         return [lindex $i 1]
      }
   }
   return ""
}
# ---------------------- logEdit_tagSet ---------------------------------
# sets/deletes the value for a given tag in a tag list, if the tag doesn't
# exist, it will be appended to the list, an empty tag value will cause
# the deletion of this tag
#
# tagList	the tag list (MDOIFIED)
# tagName	the name of the tag
# tagVal	value to be set
# endFlag	termination flag for a multy line tag
proc logEdit_tagSet {tagList tagName tagVal {endFlag ""}} {
   upvar $tagList tList
   set ipos [logEdit_tagPos $tList $tagName]
   if {$ipos < 0} {
   # new tag
      if {$tagVal != ""} {
	 if {$endFlag == ""} {
	 # normal tag
            lappend tList "$tagName [list $tagVal]"
	 } else {
	 # multy line tag
            lappend tList "$tagName [list $tagVal] $endFlag"
	 }
      }
   } else {
   # modify existing tag
    if {$tagVal != ""} {
    # replace entry
      if {$endFlag == ""} {
      # normal tag
         set tList [lreplace $tList $ipos $ipos "$tagName [list $tagVal]"]
      } else {
      # multy line tag
         set tList \
	 	[lreplace $tList $ipos $ipos "$tagName [list $tagVal] $endFlag"]
      }
    } else {
      # delete entry
      set tList [lreplace $tList $ipos $ipos]
    }
   }
}
# ---------------------- logEdit_tagPos ---------------------------------
# provides the position of a tag in a tag list
#
# tagList	the tag list
# tagName	the name of the tag
#
# return: the position of the tag in the list
#	  or -1 if not found
proc logEdit_tagPos {tagList tagName} {
   set j 0
   foreach i $tagList {
      if {[lindex $i 0] == $tagName} {
         return $j
      }
      incr j
   }
   return "-1"
}
# ---------------------- logEdit_loadFile -------------------------------
# INTERNAL USE ONLY
# reads a log file and fills "LGL_Shell($idx-entries)" (the list of taglists)
#
# idx		unique identification used for "LGL_Shell"
#
# return:	number of tag lists in "LGL_Shell($idx-entries)"
proc logEdit_loadFile idx {
   global LGL_Shell

   # read the tag file
   set entries [tag readfile $LGL_Shell($idx-file)]
   # Seperate out the header record
   set hdr [lindex $entries 0]
     # Check that it is a header
     if { [lindex [lindex $hdr 0] 0] == "Tag-worklog-version" } {
       # preserve the header
       set LGL_Shell($idx-header) $hdr
       } 
   set count 0
   if {$entries != ""} {
      set defSec [clock scan "00:00:00"]
      # loop over tag lists and select only tag lists which contain the
      # tag "Id"
      foreach tagList $entries {
         if {[string compare [logEdit_tagVal $tagList Id] ""]} {
            foreach i "StartTime EndTime" {
	       # replace invalid times by "00:00:00"
               set xTime [logEdit_tagVal $tagList $i]
               if {$xTime == ""} {set xTime "00:00:00"}
               if {[catch {set sec [clock scan $xTime]}]} {set sec $defSec}
	       set xTime [clock format $sec -format "%H:%M:%S"]
	       logEdit_tagSet tagList $i $xTime
	    }
	    lappend entr $tagList
	    incr count
	 }
      }
      if {$count > 0} {
	 # sort the list according to the StartTime
         set LGL_Shell($idx-entries) [lsort -command logEdit_sTimeSort $entr]
      }
   }
   return $count
}
# ---------------------- logEdit_fill -----------------------------------
# INTERNAL USE ONLY
# fills a list widget with log entries (StartTime, EndTime and project name)
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_fill idx {
   global LGL_Shell

   if {[info tclversion] >= 8.3} {
   # colors for list entries possible
      set colAllow 1
   } else {
      set colAllow 0
   }
   set listW $LGL_Shell($idx-listw)
   # unset error flags
   catch "unset LGL_Shell($idx-errOv)"
   catch "unset LGL_Shell($idx-errIn)"

   # delete old list
   $listW delete 0 end
   logEdit_setSens $idx
   if {! [info exists LGL_Shell($idx-entries)]} return
   set lastEnd "00:00:00"
   # loop over entries and create a list item
   foreach tagList $LGL_Shell($idx-entries) {
      set sTime [logEdit_tagVal $tagList StartTime]
      set eTime [logEdit_tagVal $tagList EndTime]
      set proj [logEdit_tagVal $tagList Project]
      if {$proj == ""} {set proj  [mc "unknown"]}
      set errFlg ""
      if {$sTime < $lastEnd} {
         # overlapping time range
         set errFlg ">"
	 set color orange
	 set LGL_Shell($idx-errOv) 1
      }
      if {$sTime > $eTime}   {
         # StartTime is greater than the EndTime
         set errFlg "!"
         set lastEnd $sTime
	 set color red
	 set LGL_Shell($idx-errIn) 1
      } else {
         set lastEnd $eTime
      }
      # add to the list widget
      $listW insert end \
      	[format "%-2.2s  %8.8s  %8.8s  %s" $errFlg $sTime $eTime $proj]
      if {$errFlg != "" && $colAllow} {
         $listW itemconfigure end -background $color
      }
   }
}
# ---------------------- logEdit_destroy --------------------------------
# INTERNAL USE ONLY
# un-sets the members of the array "LGL_Shell" associated with a list shell
# and destroys it
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_destroy idx {
   global LGL_Shell

   set win $LGL_Shell($idx-shell)

   logEdit_unset $idx

   destroy $win
}
# ---------------------- logEdit_unset ----------------------------------
# INTERNAL USE ONLY
# un-sets the members of the array "LGL_Shell" associated with a list shell
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_unset idx {
   global LGL_Shell

   foreach i [array names "$idx-*"] {
      unset LGL_Shell($i)
   }
   # only for higher tcl version
   #array unset LGL_Shell "$idx-*"
}
# ---------------------- logEdit_edShell --------------------------------
# INTERNAL USE ONLY
# creates a shell for input or editing of one log entry
#
# idx	unique identification used for "LGL_Shell"
# ipos	the position of the entry in the list of olog entries
proc logEdit_edShell {idx ipos} {
   global LGL_Shell
   set win $LGL_Shell($idx-shell).ed$ipos

   if {[winfo exists $win]} {
      raise $win
      return
   }
   toplevel $win -class "logEdit"

   if {$ipos > -1} {
   # edit existing entry
      wm title $win [mc "Edit log entry"]
      set helpid "led_ediEnt"
      set tagList [lindex $LGL_Shell($idx-entries) $ipos]
   } else {
   # add a new entry
      wm title $win [mc "Add a new entry"]
      set helpid "led_newEnt"
      if {[info exists LGL_Shell($idx-entries)]} {
         set tagList [lindex $LGL_Shell($idx-entries) $ipos]
      } else {
         set tagList ""
      }
   }
   label $win.lab -text "\n$LGL_Shell($idx-date)\n"
   pack $win.lab -side top
   
   frame $win.body -relief sunken -borderwidth 2
   set irow 0
   # loop over the items of a log entry and create the widgets
   # one member of the following list has the following members:
   # button label, tag name, menu list, switch for menu list, helpId
   foreach lst \
   	"{Id Id 0 logedit_id}
   	 {\"[mc {Start Time}]\" StartTime 0 logedit_start}
	 {\"[mc {End Time}]\" EndTime 0 logedit_end}
	 {[mc Project] Project projAll logedit_project}
	 {Rate Rate 0 logedit_rate}
	 {[mc Action] Action 0 logedit_action}
	 {[list [mc {ActionTitle}]] ActionTitle 0 logedit_actiontitle}
	 {[mc Activity] Activity acties logedit_activity}
	 {[mc Contact] Contact cont logedit_contact}" {
      set lab    [lindex $lst 0]
      set i      [lindex $lst 1]
      set ind    [lindex $lst 2]
      set helpId [lindex $lst 3]
      set blankSw 0
      if {"$ind" != "0"} {set blankSw 1}
      menu_create $win.body.l$i $lab $helpId $blankSw $ind \
      				menu_setText $win.body.e$i
      grid $win.body.l$i -row $irow -column 0 -sticky e
      entry $win.body.e$i -width 15
      lappend winList "$i $win.body.e$i"
      grid $win.body.e$i -row $irow -column 1 -sticky w
      if {$ipos > -1} {
         $win.body.e$i insert 0 [logEdit_tagVal $tagList $i]
      }
      incr irow
   }
   menu_create $win.body.lDescription [mc Description] logedit_description
   frame $win.body.frm
   text $win.body.frm.txt -height 5 -width 40 \
   				-yscroll "$win.body.frm.vscr set"
   lappend winList "Description $win.body.frm.txt"
   scrollbar $win.body.frm.vscr -orient vertical  \
   				-command "$win.body.frm.txt yview"
   pack $win.body.frm.txt -side left -fill both -expand 1
   if {$ipos > -1} {
      $win.body.frm.txt insert 1.0 [logEdit_tagVal $tagList Description]
   } else {
   # create a new Id
         $win.body.eId insert 0 \
	 		[clock format [clock seconds] -format %Y%m%d%H%M%S]
   }
   grid $win.body.lDescription -row $irow -column 0 -sticky ensw
   pack $win.body.frm.vscr -side left -fill y -expand 1
   grid $win.body.frm -row $irow -column 1 -sticky nsew
   pack $win.body -side top -fill both -expand 1

   frame $win.control -relief sunken -borderwidth 2
   button $win.control.ok -text OK -width 10 \
   	-command "logEdit_editOK $idx $win [list $tagList] [list $winList]"
   button $win.control.cancel -text [mc Cancel] -width 10 \
   	-command "destroy $win"
   button $win.control.help -text [mc Help] -width 10 \
   	-command "taghelp $helpid"
   pack $win.control.ok $win.control.cancel $win.control.help \
   				-side left -fill x 
   pack $win.control -side top
}
# ---------------------- logEdit_menu -----------------------------------
# INTERNAL USE ONLY
# creates a menu with buttons to adjust times
#
# parent	the parent widget of the menu
# idx		unique identification used for "LGL_Shell"
proc logEdit_menu {parent idx} {
   set menuW $parent.menu

   menu $menuW -tearoff False

   $menuW add command -label "Adjust to previous EndTime"  \
   				-command "logEdit_adjust -1 $idx"
   $menuW add command -label "Adjust to following Startime"  \
   				-command "logEdit_adjust 1 $idx"

   #...popup the menu with mouse button 3
   #bind $parent <Button-3> "tk_popup $menuW %X %Y"
   bind $parent <Button-3> "logEdit_popup $parent $menuW %X %Y $idx"
}
# ---------------------- logEdit_popup ----------------------------------
# INTERNAL USE ONLY
# pops up the menu for time adjustment
#
# listW	list widget, it is used to check which entry is selected
# menuW	the menu widget
# X	x-coordinate of the cursor position
# Y	x-coordinate of the cursor position
# idx	unique identification used for "LGL_Shell"
proc logEdit_popup {listW menuW X Y idx} {
   global LGL_Shell

   if {[array get LGL_Shell $idx-entries] == ""} return
   # last index in the list
   set maxPos [expr [llength $LGL_Shell($idx-entries)] - 1]
   if {$maxPos < 0} return
   # get list entry which is closest to the y-position of the cursor
   set listPos [$listW nearest [expr $Y - [winfo rooty $listW]]]
   # de-select all entries in the list
   $listW selection clear 0 end
   # select entry at opsition"listPos"
   $listW selection set $listPos
   logEdit_setSens $idx
   if {$listPos == 0} {
      # selected entry is the first in the list,
      # adjustment to prev. EndTime not possible
      $menuW entryconfigure 0 -state disabled
   } else {
      $menuW entryconfigure 0 -state normal
   }
   if {$listPos == $maxPos} {
      # selected entry is the last in the list,
      # adjustment to next StartTime not possible
      $menuW entryconfigure 1 -state disabled
   } else {
      $menuW entryconfigure 1 -state normal
   }

   #popup the menu
   tk_popup $menuW $X $Y
}
# ---------------------- logEdit_adjust ---------------------------------
# INTERNAL USE ONLY
# does the adjustment of times
#
# adjSw	offset from the selected position, the time will be adjusted
#	to the time of the entry with that offset
# idx	unique identification used for "LGL_Shell"
proc logEdit_adjust {adjSw idx} {
   global LGL_Shell

   set iAct [$LGL_Shell($idx-listw) curselection]
   set entries $LGL_Shell($idx-entries)

   if {[llength $iAct] != 1} return
   set actEnt [lindex $entries $iAct]
   set ipos [expr $iAct + $adjSw]
   if {$ipos < 0 || $ipos >= [llength $entries]} return

   set setEnt [lindex $entries $ipos]
   if {$adjSw == -1} {
   # source entry = previous entry
      set tgTag StartTime
      set srTag EndTime
   } else {
   # source entry = following entry
      set tgTag EndTime
      set srTag StartTime
   }
   set ipos [logEdit_tagPos $actEnt $tgTag]
   if {$ipos > -1} {
      # get the time from the source entry
      set time [logEdit_tagVal $setEnt $srTag]
      # replace in target tag
      set actEnt [lreplace $actEnt $ipos $ipos "$tgTag $time"]
      # replace in target entry
      set LGL_Shell($idx-entries) [lreplace $entries $iAct $iAct $actEnt]
      logEdit_fill $idx
   }
}
# ---------------------- logEdit_editOK ---------------------------------
# INTERNAL USE ONLY
#  OK callback for the input/editing of a log entry
#
# idx		unique identification used for "LGL_Shell"
# shell		name of the editing shell
# tagList	the tag list of the log entry
# winList	list of pairs {tagName widget}, the "widget"s contain
#		the edited values
proc logEdit_editOK {idx shell tagList winList} {
   global LGL_Shell

   # get the Id of the edited log entry
   set tagVal [logEdit_tagVal $tagList Id]
   set ipos -1
   set j 0
   # find the position of the log entry in the list of entries
   if {[info exists LGL_Shell($idx-entries)]} {
      foreach i $LGL_Shell($idx-entries) {
         if {$tagVal == [logEdit_tagVal $i Id]} {
            set ipos $j
	    break
         }
         incr j
      }
   }

   set j [logEdit_tagPos $tagList "End"]
   if {$j > 0} {
   # remove "End" tag
      set tagList [lreplace $tagList $j $j]
   }
   foreach i $winList {
      set tagName [lindex $i 0]
      set win     [lindex $i 1]
      if {[winfo class $win] == "Entry"} {
      # for entry widgets
         set tagVal [$win get]
      } else {
      # for text widgets
         set tagVal [$win get 1.0 end]
	 # remove trailing "newlines"
	 while {[string index $tagVal end] == "\n"} {
	    set iEnd [expr [string length $tagVal] - 2]
	    if {$iEnd >= 0} {
	       set tagVal [string range $tagVal 0 $iEnd]
	    } else {
	       set tagVal ""
	    }
	 }
      }
      if {$tagName == "StartTime" || $tagName == "EndTime"} {
      # in case of times, check the format
         if {[logEdit_chkSetTime tagVal $tagName]} return
         if {$tagName == "StartTime"} {
	    set sTime $tagVal
	 } else {
	    set eTime $tagVal
	 }
      }
      if {$tagName == "Description"} {
         # update the tag value
         logEdit_tagSet tagList $tagName $tagVal "END_D"
      } else {
         # update the tag value
         logEdit_tagSet tagList $tagName $tagVal
      }
   }
   lappend tagList "End {}"


   # check time range
   if {$sTime > $eTime} {
      tk_messageBox -icon error -title [mc "Invalid date range"] -type ok \
      		-message [mc "The StartTime is greater\nthan the EndTime"]
      return
   }
   if {$ipos < 0} {
   # new entry, append it
      lappend LGL_Shell($idx-entries) $tagList
   } else {
   # replace the existing entry
      set LGL_Shell($idx-entries) \
      		[lreplace $LGL_Shell($idx-entries) $ipos $ipos $tagList]
   }
   # sort the entries according to the StartTime
   set LGL_Shell($idx-entries) \
       [lsort -command logEdit_sTimeSort $LGL_Shell($idx-entries)]
   logEdit_fill $idx
   destroy $shell
}
# ---------------------- logEdit_chkSetTime -----------------------------
# checks a string containing a time value and re-formats it
#
# tStr		time string (MODIFIED)
# tagName	name of the tag to be checked
#
# return:	0 OK
#		1 invalid time
proc logEdit_chkSetTime {tStr tagName} {
   upvar $tStr timeStr

   if {$timeStr == "" } {
      tk_messageBox -icon error -title [mc "Invalid date"] -type ok \
      		-message "[mc {Please enter a value for}] $tagName"
      return 1
   }
   if {[catch {set sec [clock scan $timeStr]}]} {
      tk_messageBox -icon error -title [mc "Invalid date"] -type ok \
      		-message "'$timeStr' [{is not a valid\ntime value for}] $tagName"
      return 1
   }
   set timeStr [clock format $sec -format "%H:%M:%S"]

   return 0
}
# ---------------------- logEdit_shellOK --------------------------------
# INTERNAL USE ONLY
# OK callbak for the editing of log entries of one day
#
# idx		unique identification used for "LGL_Shell"
proc logEdit_shellOK {idx} {
   global LGL_Shell
   global rootdir
   global logfilename
   global prevdayfilename display_prevday

   set msg ""
   if {[info exists LGL_Shell($idx-errOv)]} {
      if {[info exists LGL_Shell($idx-errIn)]} {
         set msg [mc "There are overlapping (marked with '>')\nand inconsistent (marked with '!') time ranges."]
      } else {
         set msg [mc "There are overlapping time ranges (marked with '>')."]
      }
   } elseif {[info exists LGL_Shell($idx-errIn)]} {
      set msg [mc "There are inconsistent time ranges (marked with '!')."]
   }
   if {$msg != "" && \
   	[tk_messageBox -icon error -title "Log edit" -type yesno -default no \
       			-message "$msg\n\n[mc {Do you want to save?}]"] == "no"} {
      return
   }

   # get the date
   set yy [string range $idx 0 3]
   set mm [string range $idx 4 5]
   set dd [string range $idx 6 7]
   set weekday [clock format [clock scan "$mm/$dd/$yy"] -format "%A"]
   # build the file name from the date information
   set fName "$mm$dd.tag"
   set dName "$rootdir/log$yy"
   set fullName $dName/$fName
   if {$logfilename == $fullName} {
      # close the log file of the actual day
      closelogfile
   }
   # open the log file and write the header
   set logfile [openNewLogFile $fullName]
   close $logfile
   if {[info exists LGL_Shell($idx-entries)]} {
      # output the entries to the log file
      if {[info exists LGL_Shell($idx-header)]} {
         set entries ""
         lappend entries $LGL_Shell($idx-header)
         tag writefile $fullName $entries
         }
      tag writefile $fullName $LGL_Shell($idx-entries) "a"
   }
   if {$logfilename == $fullName} {
      if {[winfo exists .preventries.body]} {
         # update the display of previous entries
	 readlogentries
         fillpreventries .preventries.body
      }
      # open the log file of the actual day
      openlogfile
   }
   if { $display_prevday && $prevdayfilename == $fullName} {
      # update the display of entries of the previous day
      fillprevday
   }
   
   logEdit_destroy $idx
}
# ---------------------- logEdit_setCalCol ------------------------------
# checks wether a log file exists for a given date
# this function is used as argument in "calUtil_open"
#
# year	the year, four digits
# month the month, 1,2,...,11,12
# day	the day, 1,2,...30,31
# data	unused
#
# return:	"yellow" if the file exists, otherwise ""
proc logEdit_setCalCol {year month day data} {
   global rootdir
   set fName [format "%s/log%s/%02d%02d.tag" $rootdir $year $month $day]
   if {[file exists $fName]} {return yellow}
   return ""
}
