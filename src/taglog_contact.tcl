#
# taglog_contact.tcl - contact management routines for taglog
# Copyright John Lines (john@paladin.demon.co.uk) December 2000
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_contact 0.1

proc get_contact_input_fields { args } {
global contactsfilename allcontacts allcontactsstate
global addcontact_id addcontact_forename addcontact_surname addcontact_email addcontact_phone addcontact_mobilephone addcontact_fax addcontact_organisation addcontact_type addcontact_note addcontact_title addcontact_address addcontact_short_id addcontact_postcode addcontact_country addcontact_web addcontact_ldap addcontact_default_as

if { [llength $args] > 0 } {
 set endflag 0
 } else {
 set endflag 1
 }

set thiscontact ""

set thiscontact [tagappend $thiscontact Id $addcontact_id]
set thiscontact [tagappend $thiscontact Forename $addcontact_forename]
set thiscontact [tagappend $thiscontact Surname $addcontact_surname]
set thiscontact [tagappend $thiscontact Title $addcontact_title]
set thiscontact [tagappend $thiscontact Default-as $addcontact_default_as]
set thiscontact [tagappend $thiscontact Email $addcontact_email]
set thiscontact [tagappend $thiscontact Web $addcontact_web]
set thiscontact [tagappend $thiscontact Ldap $addcontact_ldap]
set thiscontact [tagappend $thiscontact Phone $addcontact_phone]
set thiscontact [tagappend $thiscontact MobilePhone $addcontact_mobilephone]
set thiscontact [tagappend $thiscontact Fax $addcontact_fax]
set thiscontact [tagappend $thiscontact Address $addcontact_address END_D]
set thiscontact [tagappend $thiscontact Postcode $addcontact_postcode]
set thiscontact [tagappend $thiscontact Country $addcontact_country]
set thiscontact [tagappend $thiscontact Organisation $addcontact_organisation]
set thiscontact [tagappend $thiscontact Type $addcontact_type]
set thiscontact [tagappend $thiscontact Note $addcontact_note END_D]
set thiscontact [tagappend $thiscontact Short-id $addcontact_short_id]

if { $endflag } {
 set endpair [list End ]

 lappend thiscontact $endpair
}
return $thiscontact
}

proc addcontactOK {} {
global contactsfilename allcontacts allcontactsstate
global addcontact_id addcontact_forename addcontact_surname addcontact_email addcontact_phone addcontact_mobilephone addcontact_fax addcontact_organisation addcontact_type addcontact_note addcontact_title addcontact_address addcontact_short_id addcontact_postcode addcontact_country addcontact_web addcontact_ldap addcontact_default_as

getallcontacts

set addcontact_note [string trim [.addcontact.note.e get 1.0 end]]
set addcontact_address [string trim [.addcontact.address.e get 1.0 end]]

set thiscontact [get_contact_input_fields ]

lappend allcontacts $thiscontact
set allcontactsstate modified

writeallcontacts

setcontactsmenu

destroy .addcontact
}

proc editcontactOK {} {
global addcontact_note addcontact_address
global allcontacts allcontactsstate

set thiscontact ""
set addcontact_note [string trim [.addcontact.note.e get 1.0 end]]
set addcontact_address [string trim [.addcontact.address.e get 1.0 end]]

set thiscontact [get_contact_input_fields -noend]

foreach field [array names editcontact_fields] {
 set thiscontact [tagappend $thiscontact [index2fieldname $field] $editcontact_fields($field)]]
}
 set endpair [list End ]
 lappend thiscontact $endpair

set allcontactststate modified

foreach item $thiscontact {
 if { [lindex $item 0] == "Id" } {
   set thisid [lindex $item 1]
 }
}

set test [ list Id "==" $thisid ]
set idx 0

foreach entry $allcontacts {
 if [ tag matchcond $entry $test] {
	set allcontacts [lreplace $allcontacts $idx $idx $thiscontact]
 }
 incr idx
}
set allcontactsstate modified
writeallcontacts

setcontactsmenu

destroy .addcontact
}

proc addContact { mode } {
global contactsfilename contacttypes
global addcontact_id addcontact_forename addcontact_surname addcontact_email addcontact_phone addcontact_mobilephone addcontact_fax addcontact_organisation addcontact_type addcontact_note addcontact_title addcontact_address addcontact_short_id addcontact_postcode addcontact_country addcontact_web addcontact_ldap addcontact_default_as

proc addcontactfield { name label width mode } {
global addcontact_$name
if { $mode == "input" } {
set addcontact_$name ""
}
frame .addcontact.$name
menubutton .addcontact.$name.l -text "$label" -menu .addcontact.$name.l.m
menu .addcontact.$name.l.m
.addcontact.$name.l.m add command -label [mc "Help"] -command "taghelp addcontact_$name"
entry .addcontact.$name.v -textvariable addcontact_$name -width $width
pack .addcontact.$name.l .addcontact.$name.v -side left -in .addcontact.$name
pack .addcontact.$name
}


toplevel .addcontact
if { $mode == "input" } {
wm title .addcontact [mc "Input a contact"]
} else {
wm title .addcontact "[mc {Edit contact}] $addcontact_id"
}

addcontactfield id Id 20 $mode
addcontactfield forename [mc Forename] 20 $mode
addcontactfield surname [mc Surname] 20 $mode

if { $mode == "input" } {
set addcontact_title ""
}
frame .addcontact.title
menubutton .addcontact.title.l -text [mc Title] -menu .addcontact.title.l.m
menu .addcontact.title.l.m
.addcontact.title.l.m add command -label "--" -command "set addcontact_title \"\""
.addcontact.title.l.m add command -label [mc "Mr"] -command "set addcontact_title Mr"
.addcontact.title.l.m add command -label [mc "Mrs"] -command "set addcontact_title Mrs"
.addcontact.title.l.m add command -label [mc "Ms"] -command "set addcontact_title Ms"
.addcontact.title.l.m add command -label "Dr" -command "set addcontact_title Dr"
.addcontact.title.l.m add separator
.addcontact.title.l.m add command -label [mc "Help"] -command "taghelp addcontact_title"
entry .addcontact.title.v -textvariable addcontact_title -width 10
pack .addcontact.title.l .addcontact.title.v -side left -in .addcontact.title
pack .addcontact.title

addcontactfield default_as [mc "Default-as"] 20 $mode
addcontactfield email Email 35 $mode
addcontactfield web Web 30 $mode
addcontactfield ldap Ldap 30 $mode
addcontactfield phone [mc Phone] 20 $mode
addcontactfield mobilephone [mc "Mobile Phone"] 20 $mode
addcontactfield fax Fax 20 $mode

if { $mode == "input"} {
set addcontact_address ""
}
frame .addcontact.address
menubutton .addcontact.address.l -text [mc Address] -menu .addcontact.address.l.m
menu .addcontact.address.l.m
.addcontact.address.l.m add command -label [mc "Help"] -command "taghelp addcontact_address"
text .addcontact.address.e -rel sunk -wrap word -yscrollcommand ".addcontact.address.s set" -width 40 -height 5
scrollbar .addcontact.address.s -rel sunk -command ".addcontact.address.e yview"
pack .addcontact.address.l -side left -in .addcontact.address
pack .addcontact.address.e -side right -in .addcontact.address
pack .addcontact.address.s -side right -fill y -in .addcontact.address
pack .addcontact.address
if { $mode == "edit" } {
 .addcontact.address.e insert end $addcontact_address
}

addcontactfield postcode [mc Postcode] 10 $mode
addcontactfield country [mc Country] 20 $mode
addcontactfield organisation Organisation 30 $mode

if { $mode == "input" } {
set addcontact_type ""
}
frame .addcontact.type
menubutton .addcontact.type.l -text [mc "Type"] -menu .addcontact.type.l.m
menu .addcontact.type.l.m
.addcontact.type.l.m add command -label "--" -command "set addcontact_type \"\""

foreach type $contacttypes {
 .addcontact.type.l.m add command -label [mc "$type"] -command "set addcontact_type \"[mc $type]\""
}
.addcontact.type.l.m add separator
.addcontact.type.l.m add command -label [mc "Help"] -command "taghelp addcontact_type"
entry .addcontact.type.v -textvariable addcontact_type -width 12
pack .addcontact.type.l .addcontact.type.v -side left -in .addcontact.type
pack .addcontact.type

addcontactfield short_id [mc "Short-id"] 3 $mode

if { $mode == "input" } {
set addcontact_note ""
}
frame .addcontact.note
menubutton .addcontact.note.l -text [mc Note] -menu .addcontact.note.l.m
menu .addcontact.note.l.m
.addcontact.note.l.m add command -label [mc "Help"] -command "taghelp addcontact_note"
text .addcontact.note.e -rel sunk -wrap word -yscrollcommand ".addcontact.note.s set" -width 40 -height 5
scrollbar .addcontact.note.s -rel sunk -command ".addcontact.note.e yview"
pack .addcontact.note.l -side left -in .addcontact.note
pack .addcontact.note.e -side right -in .addcontact.note
pack .addcontact.note.s -side right -fill y -in .addcontact.note
pack .addcontact.note
if { $mode == "edit" } {
 .addcontact.note.e insert end $addcontact_note
}


frame .addcontact.bot
if {$mode == "input" } {
button .addcontact.bot.ok -text [mc "Add"] -command addcontactOK
} elseif { $mode == "edit" } {
button .addcontact.bot.ok -text [mc "Edit"] -command editcontactOK
}
button .addcontact.bot.cancel -text [mc Cancel] -command { doCancel .addcontact }
button .addcontact.bot.help -text [mc Help] -command "taghelp addcontact"
pack .addcontact.bot.ok .addcontact.bot.cancel .addcontact.bot.help -side left -in .addcontact.bot
pack .addcontact.bot


tkwait window .addcontact

}

proc editcontact { contactid } {
global allcontacts
global contactsfilename
global addcontact_id addcontact_forename addcontact_surname addcontact_email addcontact_phone addcontact_mobilephone addcontact_fax addcontact_organisation addcontact_type addcontact_note addcontact_title addcontact_address addcontact_short_id addcontact_postcode addcontact_country addcontact_web addcontact_ldap addcontact_default_as
global editcontact_fields

getallcontacts

set addcontact_note ""
set addcontact_address ""

if { [info exist editcontact_fields] } {
 unset editcontact_fields
}

set addcontact_id $contactid
set test [list Id "==" $contactid]
lappend tests $test
set thiscontact [tag extract $allcontacts $tests]

foreach contact $thiscontact {
 foreach item $contact {
  if { [lindex $item 0] == "Forename" } {
	set addcontact_forename [lindex $item 1]
} elseif { [lindex $item 0] == "Surname" } {
	set addcontact_surname [lindex $item 1]
} elseif { [lindex $item 0] == "Title" } {
	set addcontact_title [lindex $item 1]
} elseif { [lindex $item 0] == "Default-as" } { set addcontact_default_as [lindex $item 1]
} elseif { [lindex $item 0] == "Email"} {
	set addcontact_email [lindex $item 1]
} elseif { [lindex $item 0] == "Phone" } {
	set addcontact_phone [lindex $item 1]
} elseif { [lindex $item 0] == "Web" } {
        set addcontact_web [lindex $item 1]
} elseif { [lindex $item 0] == "Ldap" } {
        set addcontact_ldap [lindex $item 1]
} elseif { [lindex $item 0] == "MobilePhone" } {
	set addcontact_mobilephone [lindex $item 1]
} elseif { [lindex $item 0] == "Fax" } {
	set addcontact_fax [lindex $item 1]
} elseif { [lindex $item 0] == "Note" } {
	set addcontact_note [lindex $item 1]
} elseif { [lindex $item 0] == "Organisation"} {
	set addcontact_organisation [lindex $item 1]
} elseif { [lindex $item 0] == "Type"} {
	set addcontact_type [lindex $item 1]
} elseif { [lindex $item 0] == "Address"} {
	set addcontact_address [lindex $item 1]
} elseif { [lindex $item 0] == "Short-id"} {
	set addcontact_short_id [lindex $item 1]
} elseif { [lindex $item 0] == "Postcode"} {
	set addcontact_postcode [lindex $item 1]
} elseif { [lindex $item 0] == "Country"} {
	set addcontact_country [lindex $item 1]
} elseif { [lindex $item 0] == "Id" } {
	# dont do anything
} else {
	set fieldname [fieldname2index [lindex $item 0]]
	set editcontact_fields($fieldname) [lindex $item 1]
}
}
}

set contact [ addContact edit]

}

proc getallcontacts {} {
global contactsfilename allcontacts allcontactsstate

if { $allcontactsstate == "closed" } {
 set allcontacts [tag readfile $contactsfilename]
 set allcontactsstate open
 if { [llength $allcontacts] == 0 } {
  set hdr ""
  set header [ list Tag-contact-version 1.0 ] 
  lappend hdr $header
  set  endpair [list End ]
  lappend hdr $endpair
  lappend allcontacts $hdr
  }
}
}

proc writeallcontacts {} {
global contactsfilename allcontacts allcontactsstate

if { $allcontactsstate == "modified" } {
 tag writefile $contactsfilename $allcontacts
 set allcontactsstate open
 }
}

proc setcontactsmenu {} {
global allcontacts

getallcontacts

.currentbar.endbutton.m.contact delete 1 end
.currentbar.endbutton.m.contact add command -label "--" -command "set currentContact \"\""

foreach contact $allcontacts {

 foreach item $contact {
   if { [lindex $item 0] == "Id" } {
	.currentbar.endbutton.m.contact add command -label [lindex $item 1] -command "set currentContact \"[lindex $item 1]\"" 
   }
 }


}

}

proc viewContactsOK {} {
global allcontacts
global cview_phone cview_organisation cview_type cview_forename cview_surname

toplevel .viewc
wm title .viewc [mc "Contacts Display"]

getallcontacts

frame .viewc.main
text .viewc.main.body -rel sunk -wrap word -yscrollcommand ".viewc.main.sb set"
scrollbar .viewc.main.sb -rel sunk -command ".viewc.main.body yview"
pack .viewc.main.body -side right -in .viewc.main
pack .viewc.main.sb -side right -fill y -in .viewc.main
pack .viewc.main


frame .viewc.bot
button .viewc.bot.ok -text [mc "Close"] -command { doCancel .viewc }
button .viewc.bot.help -text [mc "Help"] -command "taghelp viewc"
pack .viewc.bot.ok .viewc.bot.help -in .viewc.bot -side left
pack .viewc.bot

.viewc.main.body delete 1.0 end

set tests ""
if { $cview_phone != "" } {
 set test [list Phone -contains $cview_phone ]
 lappend tests $test
 }

if { $cview_organisation != "" } {
 set test [list Organisation -contains $cview_organisation ]
 lappend tests $test
}
if { $cview_type != ""} {
 set test [list Type == $cview_type]
 lappend tests $test
}
if {$cview_forename != ""} {
 set test [list Forename -contains $cview_forename]
 lappend tests $test
}
if {$cview_surname != ""} {
 set test [list Surname -contains $cview_surname]
 lappend tests $test
}

set contacts [lrange $allcontacts 1 end]
set contacts [tag extract $contacts $tests ]
set entrynum 0
.viewc.main.body mark set prevmark 1.0
.viewc.main.body mark gravity prevmark left

foreach entry $contacts {
 incr entrynum
 foreach item $entry {
  set tagname [lindex $item 0]
  set tagvalue [lindex $item 1]

  if { $tagname == "End" } {
    .viewc.main.body insert end "_______________________________________\n"
    .viewc.main.body tag add tag_$entryid prevmark insert
    .viewc.main.body tag bind tag_$entryid <Button-3> "editcontact \"$entryid\""
    .viewc.main.body mark set prevmark insert
  } elseif { $tagname == "Id" } {
    set entryid $tagvalue
  } else {
  .viewc.main.body insert end "[mc $tagname]: "
  .viewc.main.body insert end "$tagvalue"
  .viewc.main.body insert end "\n"
  }
  }
 }
tkwait window .viewc
}



proc viewContacts {} {
global cview_phone cview_organisation cview_type cview_forename cview_surname
global contacttypes

toplevel .cview
wm title .cview [mc "Select Contacts to view"]

frame .cview.main

frame .cview.main.forename
menubutton .cview.main.forename.l -text [mc Forename] -menu .cview.main.forename.l.m
menu .cview.main.forename.l.m
.cview.main.forename.l.m add command -label [mc Help] -command "taghelp cview_forename"
entry .cview.main.forename.e -textvariable cview_forename -width 20
pack .cview.main.forename.l .cview.main.forename.e -side left -in .cview.main.forename
pack .cview.main.forename

frame .cview.main.surname
menubutton .cview.main.surname.l -text [mc Surname] -menu .cview.main.surname.l.m
menu .cview.main.surname.l.m
.cview.main.surname.l.m add command -label [mc Help] -command "taghelp cview_surname"
entry .cview.main.surname.e -textvariable cview_surname -width 20
pack  .cview.main.surname.l .cview.main.surname.e -side left -in .cview.main.surname
pack .cview.main.surname

frame .cview.main.phone
menubutton .cview.main.phone.l -text [mc Phone] -menu .cview.main.phone.l.m
menu .cview.main.phone.l.m
.cview.main.phone.l.m add command -label [mc Help] -command "taghelp cview_phone"
entry .cview.main.phone.e -textvariable cview_phone -width 12
pack .cview.main.phone.l .cview.main.phone.e -side left -in .cview.main.phone
pack .cview.main.phone

frame .cview.main.organisation
menubutton .cview.main.organisation.l  -text Organisation -menu .cview.main.organisation.l.m
menu .cview.main.organisation.l.m
.cview.main.organisation.l.m add command -label [mc Help] -command "taghelp cview_organisation"
entry .cview.main.organisation.e -textvariable cview_organisation -width 20
pack .cview.main.organisation.l .cview.main.organisation.e -side left -in .cview.main.organisation
pack .cview.main.organisation

frame .cview.main.type
menubutton .cview.main.type.l -text [mc Type] -menu .cview.main.type.l.m
menu .cview.main.type.l.m
.cview.main.type.l.m add command -label "--" -command "set cview_type \"\""
foreach type $contacttypes {
 .cview.main.type.l.m add command -label [mc "$type"] -command "set cview_type \"[mc $type]\""
}
.cview.main.type.l.m add separator
.cview.main.type.l.m add command -label [mc "Help"] -command "taghelp cview_type"
entry .cview.main.type.e -textvariable cview_type -width 10
pack .cview.main.type.l .cview.main.type.e -side left -in .cview.main.type
pack .cview.main.type

pack .cview.main



frame .cview.bot
button .cview.bot.ok -text [mc "View"] -command viewContactsOK
button .cview.bot.cancel -text [mc "Cancel"] -command { doCancel .cview }
button .cview.bot.help -text [mc "Help"] -command "taghelp contactview"
pack .cview.bot.ok .cview.bot.cancel .cview.bot.help -in .cview.bot -side left
pack .cview.bot

tkwait window .cview

}

proc importContacts {} {


set types  [list "[list [mc "vCard Files"]] .vcf"]
 set filename [tk_getOpenFile -filetypes $types -title [mc " vCard files to Import"]]

 if {$filename !=""} {
   set imported_contacts [read_vcard $filename]
 }

}

proc read_vcard { filename } {
#
# Read one or more contacts from the given file and return them as a list of
# contacts
#

set result ""

set f [open $filename]

while { [gets $f line] >= 0 } {

# Lines should consist of a label and a value
set ll [split $line :]
if { [llength $ll] ==2 } {
  set label [lindex $ll 0]
  set value [lindex $ll 1]

  puts "label is $label - value is $value"

if { $label == "END"} [
  set thiscontact ""
  if { $imp_id==""} {
    set imp_id Import.$now
  }
  set thiscontact [tagappend $thiscontact Id $imp_id]
  set thiscontact [tagappend $thiscontact Email $imp_email]
  set thiscontact [tagappend $thiscontact Web $imp_web]
  set thiscontact [tagappend $thiscontact Phone $imp_phone]
  set thiscontact [tagappend $thiscontact MobilePhone $imp_mobilephone]
  set thiscontact [tagappend $thiscontact Fax $imp_fax]
  set thiscontact [tagappend $thiscontact Organisation $imp_org]


  set endpair [list End ]
  lappend thiscontact $endpair

  lappend result $thiscontact 
  } elseif { $label == "BEGIN" } {
  set imp_id ""
  set imp_email ""
  set imp_web ""
  set imp_phone ""
  set imp_mobilephone ""
  set imp_fax ""
  set imp_org ""

  } elseif { $label == "ORG" } {
    set imp_org $value
  } elseif { $label == "URL"} {
    set imp_web $value
  } elseif { $label == "TEL;WORK;VOICE" } {
   set imp_phone $value
  } elseif { $label == "TEL;WORK;FAX" } {
   set imp_fax $value

  } else {
  puts "llength of $ll is not 2"
}


}
close $f
return $result

}
