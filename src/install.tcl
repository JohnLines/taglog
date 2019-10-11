#!/usr/bin/env tclsh

# Script to install taglog - this is under development.
# Inoke as wish install.tcl (for Unix) or by clicking on the install icon
#  (for Windows)


proc do_install {} {
global bindir taglogbin libfiles libdir docdir helpfiles msgfiles mandir man1files man3files removeold activitiesfile
global rootdir tcl_platform
global activitiesdir
global userinstall
global system
global srcdir
global srcdocdir
global isAndroid


# srcdir should be the same as the directory we are currently in
 set srcdir [file dirname [info script]]

# srcdocdir should be $srcdir/../doc/

 set srcdocdir "$srcdir/../doc/"


# Make the directories follow the libdir in windows if they were changed
# by the user.

if {$tcl_platform(platform) == "windows" } {
 set bindir $libdir
 set docdir $libdir
 set mandir $libdir
 set rootdir $libdir
 set activitiesdir $libdir
}

#
if { ! [ file isdirectory $bindir ] } {
  file mkdir $bindir
}

file copy -force $srcdir/taglog $taglogbin
 puts "Installed taglog into $taglogbin"
if { $tcl_platform(platform) == "unix" } {
    # make it executable by user and group
	file attributes $taglogbin -permissions ug+rx
}

if { ! [ file isdirectory $libdir ] } {
  file mkdir $libdir
}

foreach libfile $libfiles {
 file copy -force $srcdir/$libfile $libdir
 if {$system} {
   file attributes $libfile -permissions +r
   }

}
#puts "Installed library files into $libdir"

# set up package index
file copy -force $srcdir/pkgIndex.tcl $libdir

if { $removeold } {
 file delete $bindir/taglog_help.tcl
 # we might want to delete other old library files
 }

foreach helpfile $helpfiles {
 file copy -force $srcdir/$helpfile $libdir
}

foreach msgfile $msgfiles {
 file copy -force $srcdir/$msgfile $libdir
 }

if { $mandir != "" } {
 foreach man1file $man1files {
 file copy -force $srcdir/$man1file $mandir/man1
 }
 foreach man3file $man3files {
 file copy -force $srcdir/$man3file $mandir/man3
 }
}

# Copy the documentation files (everything in the doc directory)

if { $docdir !="" } {
if { ! [ file isdirectory $docdir ] } {
  file mkdir $docdir
}

foreach docfile [ glob $srcdocdir/* ] {
 if { $docfile != "INSTALL" } {
file copy -force $docfile $docdir
 }
}

if { ! [file isdirectory $activitiesdir]} {
  file mkdir $activitiesdir
  }
file copy -force $srcdir/$activitiesfile  $activitiesdir/$activitiesfile

}


exit
}

proc choose_dir {var label} {
    upvar #0 $var dir
    set dir [tk_chooseDirectory -title $label -parent .]
}

proc directory_chooser {path label var} {
    frame $path
    label $path.l -text $label -width 30 -anchor w
    entry $path.e -textvariable $var -width 30
    button $path.c -text "..." -command [list choose_dir $var $label]
    grid $path.l $path.e $path.c -sticky w
    grid columnconfigure $path 1 -weight 1
    return $path
}

proc choose_file {var label} {
    upvar #0 $var file
    set file [tk_getOpenFile -title $label -parent .]
}

proc file_chooser {path label var} {
    frame $path
    label $path.l -text $label -anchor w -width 30
    entry $path.e -textvariable $var -width 30
    button $path.c -text "..." -command [list choose_file $var $label]
    grid $path.l $path.e $path.c -sticky w
    grid columnconfigure $path 1 -weight 1
    return $path
}

proc setup_display {} {
global bindir taglogbin libfiles libdir docdir removeold userinstall
global isAndroid

package require Tk

wm title . "Install Taglog"

set bin [directory_chooser .bindir "Binary Directory" ::bindir]
set tagbin [file_chooser .taglogbin "Taglog executable" ::taglogbin]
set lib [directory_chooser .libdir "Library Directory" ::libdir]
set man [directory_chooser .mandir "Manpage dir" ::mandir]
set doc [directory_chooser .docdir "Documentation Directory" ::docdir]
set root [directory_chooser .datadir "Data Directory" ::rootdir]

grid $bin -sticky w
grid $tagbin -sticky w
grid $lib -sticky w
grid $man -sticky w
grid $doc -sticky w
grid $root -sticky w

# For the case where the library files have moved we want to issue a
# warning (and remove the old files
set removeold 0
if { $bindir != $libdir } {
  if { [file readable $bindir/taglog_help.tcl] } {

if {[tk_messageBox -icon warning -title "Library has moved" -message \
 "The library files are now in $libdir - the old taglog_help.tcl has been removed - you may wish to tidy up the other files in $bindir" \
 -type yesno] == "yes"} {
 set removeold 1
 } else {
 exit
 }

}
}

frame .bot
button .bot.ok -text OK -command do_install
button .bot.cancel -text Cancel -command exit
grid .bot.ok .bot.cancel -sticky w -padx 3
grid .bot -sticky w

if { $isAndroid } {
	# wm attributes . -fullscreen 1 
	# It looks as if the size is pixels rather than characters.
	wm geometry . 200x300
	focus .
	}

tkwait window .
}


global bindir taglogbin libfiles libdir argv docdir helpfiles destdir mandir removeold system
global activitiesdir isAndroid

set quiet 0
set debian 0
set system 0
set destdir ""
set mandir ""
set vfs 0
set userinstall 1

set isAndroid 0
	if { [info commands sdltk] ne "" } {
		set isAndroid [sdltk android]
		puts "running on Android - $isAndroid"
    }

set usage "install.tcl ?-quiet? ?-debian path|-system|-vfs?"
set skipnext 0
set nextispath 0
foreach arg $argv {
 if {$skipnext} {set skipnext 0 
 				 continue
				}
 if {$nextispath} { set destdir $arg
		continue
		} 
 switch -- $arg {
 	"-quiet" {
		set quiet 1
		}
	"-debian" {
	    set debian 1
    	set quiet 1
	set userinstall 0
	set nextispath 1
		}
    "-system"  {
    	set system 1
	set userinstall 0
    	set quiet 1
		}
    "-vfs" {
        set vfs 1
        set quiet 1
	set userinstall 0
	}
	default {
		return -code error "Unknown option \"$arg\"\n $usage"
	}
 }   
}


# It only deals with the install as normal user under Unix at present.
# amd possibly under Windows.

set removeold 0

if { $tcl_platform(platform) == "unix" } {
# Work out where the wish executable is.

set wishexec [info nameofexecutable]
# if { $tcl_platform(user) == "root" } 
 if { $system } {

 # Install into /usr/local by default
 set instroot "/usr/local"
 set libdir "$instroot/lib/taglog"
 set bindir "$instroot/bin"
 set docdir "$instroot/doc/taglog"
 set mandir "$instroot/man"
 set rootdir "~/diary"
 set activitiesdir "$libdir"
 set taglogbin $bindir/taglog
  } elseif { $debian } {
  set libdir "$destdir/usr/share/taglog"
  set bindir "$destdir/usr/bin"
  set docdir "$destdir/usr/share/doc/taglog"
  set mandir "$destdir/usr/share/man"
  set taglogbin $destdir/usr/bin/taglog
  set rootdir "~/diary"
  set activitiesdir "$libdir"
  } elseif { $vfs } {
  set destdir taglog.vfs
  set libdir "$destdir"
  set bindir "$destdir"
  set docdir ""
  set mandir ""
  set activitiesdir "$libdir"
  set taglogbin "$destdir/main.tcl" 

  } else {
# Unix non-root install

set libdir "~/lib/taglog"
set bindir "~/bin"
set docdir "~/bin"

set mandir "~/bin"
set taglogbin $bindir/taglog
if { $isAndroid } { set taglogbin $bindir/taglog.tag }
set rootdir "~/diary"
set activitiesdir "$rootdir"
}

} elseif { $tcl_platform(platform) == "windows" } {

set libdir "C:/Program Files/taglog"
set bindir $libdir
set docdir $libdir
set mandir $libdir
set rootdir $libdir
set activitiesdir $rootdir
set taglogbin $bindir/taglog.tcl

} else {
 error "Unknown platform $tcl_platform(platform) - cant automatically install"
}

# Languages, other than English, supported
#  Each must have a taglog_help_xx.tag and an xx.msg file
set languages { de fr nl }

set libfiles { tag.tcl taglog_action.tcl taglog_report.tcl taglog_init.tcl smtp.tcl taglog_help.tcl taglog_contact.tcl taglog_util.tcl taglog_project.tcl cal2.xbm logEdit.tcl taglog_widgets.tcl mainwin.tcl taglog_stack.tcl }
set binfiles { taglog }
set helpfiles { taglog_help_en.tag taglog_help_de.tag taglog_help_fr.tag taglog_help_nl.tag }
set msgfiles { de.msg fr.msg nl.msg }
set man1files { taglog.1 }
set man3files { tag.3 }
set activitiesfile {activities}

if { $quiet } {
 do_install
 } else {
 setup_display
 }

exit
