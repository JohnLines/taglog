#
# taglog_help.tcl - routines providing the help system for taglog
# Copyright John Lines (john@paladin.demon.co.uk) November 2000
#
# This program is released under the terms of the GNU Public Licence
#

# Note that only one argument will be substituted at present.

package provide taglog_help 0.1

proc taghelp { subject args } {
global language helpdir helpsorted

proc gethelp_for { helpfile subject } {
global helpsorted

set description ""
if { ! $helpsorted } {
set test [list Id "==" $subject]
lappend tests $test
set helpentries [tag readselected $helpfile $tests]

foreach entry $helpentries {
 foreach item $entry {
  if { [lindex $item 0] == "Description" } {
	set description [lindex $item 1]
	}
  }
}

} else {
# puts "Sorted help file"
 set description ""
 set entry [ tag findsorted $helpfile $subject ]

 foreach item $entry {
  if { [lindex $item 0] == "Description" } {
	set description [lindex $item 1]
	}
  }
  

}

return $description

}

set description ""
set helpfile "$helpdir/taglog_help_$language.tag"
if { ! [file exists $helpfile] } {
 set description "Help text not found for item $subject in language $language - please check that $helpfile exists"
}

# From now on we can only work with sorted helpfiles - they will have to
# be sorted before installation.

if { [info tclversion] < 8.2 } {
 set helpsorted 0
 } else {
set helpsorted 1

if {! [info exists helpsorted] } {
 set helpsorted 0
 set h [tag readheader $helpfile]

 foreach item $h {
  if { [lindex $item 0] == "Sorted-date" } {
   set sd [lindex $item 1]
   set fd [clock format [file mtime $helpfile] -format "%Y-%m-%d %H:%M:%S"]
   # compare as strings 
#   puts " sd is $sd - fd is $fd"
   if { [string compare $sd $fd] >= 0 } {
    set helpsorted 1
    }
   }

}

# puts "helpsorted is $helpsorted"

}
}

set description [gethelp_for $helpfile $subject]


if { $description == "" } {
 set description [gethelp_for $helpfile UNKNOWN]
}

# if args is non empty then perform argument substitution

set i 1
for { set i 1 } { $i <= [ llength $args] } { incr i } {
 set thisarg [lindex $args [expr $i - 1]]

regsub {\$1} $description $thisarg description

}

toplevel .taghelp_$subject
wm title .taghelp_$subject "Help on $subject"

frame .taghelp_$subject.body
message .taghelp_$subject.body.msg -text $description -width 7i
pack .taghelp_$subject.body.msg
pack .taghelp_$subject.body

frame .taghelp_$subject.bot
button .taghelp_$subject.bot.ok -text OK -command "doCancel .taghelp_$subject"
pack .taghelp_$subject.bot.ok
pack .taghelp_$subject.bot

tkwait window .taghelp_$subject
}

