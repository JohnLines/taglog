package provide smtpclient 0.1
# SMTP mailer support for tcl
#
# This defines a new command smtp
#
# smtp send message recipient [filename]
#
#	sends a file (read from filename) to the recpient(s) specified in
#	recipient, which is a list of email addresses
#
#	send takes parameters
#		-attachtag tagfilelist
#		attach the given list (which must be a tagged file) to the
#		message
#
#		-attachname name
#		associate a name with the attachment
#
#		-header typename
#		Add a tag header tag-typename-version 
#
#
# smtp reads from a file called ~/.smtp (for unix) or ~/smtp.cfg (for Windows)
# to initialise its variables.
# It needs to know
#	thishost - what it should put in the HELO part of the SMTP dialogue
#	mailhost - what system to connect to
#	myemail - the current user's email address (for MAIL FROM)
#


proc smtp { action args } {
global smtpv tcl_platform

if {$action == "init" } {
global env
# initialise
 
 if { [file readable "~/.smtp"]} {
	source "~/.smtp"
	set smtpv(prefsfile) "~/.smtp"
 } elseif { [ file readable "~/smtp.cfg"]} {
	source "~/smtp.cfg"
	set smtpv(prefsfile) "~/smtp.cfg"
 } else {
 set smtpv(thishost) [info hostname] 
 set smtpv(mailhost) "localhost"
 if { ($tcl_platform(platform) == "unix") && ([info exists env(USER)])} {
 set smtpv(myemail) "$env(USER)@$smtpv(thishost)"
  } else {
 set smtpv(myemail) "someuser@$smtpv(thishost)"
  }
 set smtpv(port) 25
	# could be 587 if we are a Mail Submission Agent
 set smtpv(prefsfile) ""
 set smtpv(initialised) 1
 }
 return 1

} elseif {$action == "send" } {

if { ! [info exists smtpv(initialised) ] } {
	smtp init
 }
 set subject ""
 set numattach 0

 # look for switches 
 while { [ string index [lindex $args 0] 0] == "-" } {
   set flag [lindex $args 0]
   set args [lrange $args 1 end]
   if { $flag == "-subject"} {
	set subject [lindex $args 0]
	set args [lrange $args 1 end]
  } elseif { $flag == "-attachtag"} {
	incr numattach
	set attachment($numattach) [lindex $args 0]
        set attachmentname($numattach) "noname.tag"
	set attachmentheader($numattach) ""
	set args [lrange $args 1 end]
  } elseif { $flag == "-attachname"} {
        set attachmentname($numattach) [lindex $args 0]
 	set args [lrange $args 1 end]
  } elseif { $flag == "-header" } {
	set attachmentheader($numattach) [lindex $args 0]
        set args [lrange $args 1 end]
   } else {
	error "smtp send - unknown switch $flag"
   }
			
 } 
 set message [lindex $args 0]
 set recipient [lindex $args 1]
 if {[llength $args ] > 2 } {
	set filename [lindex $args 2]
  }

# Open a connection
 set mc [socket $smtpv(mailhost) $smtpv(port) ]
 set reply [gets $mc ] 
 # puts "reply is $reply"
 puts $mc "HELO $smtpv(thishost)"
 flush $mc
 set reply [gets $mc ] 
 # puts "reply is $reply"

 puts $mc "Mail From: $smtpv(myemail)"
 flush $mc
 set reply [gets $mc ] 
 # puts "reply is $reply"
 
 puts $mc "Rcpt to: $recipient"
 flush $mc
 set reply [gets $mc]
# puts "reply (rcpt to) is $reply" 

 puts $mc "DATA"
 flush $mc
 set reply [gets $mc]
# puts "reply (data) is $reply" 


puts $mc "To: $recipient"

if {$subject != ""} {
 puts $mc "Subject: $subject"
}

 puts $mc "Mime-version: 1.0"
if { $numattach > 0 } {
 set boundary "----=zzz12345split"
 puts $mc "Content-type: Multipart/mixed; boundary=\"$boundary\""
}
 
 puts $mc ""
 flush $mc 
# set reply [gets $mc]
# puts "reply is $reply" 

if { $numattach > 0 } {
 puts $mc "This is a MIME message"
 puts $mc ""
 puts $mc "--$boundary"
 puts $mc "Content-type: text/plain"
 puts $mc ""
}

 puts $mc $message
 puts $mc ""
 puts $mc ""
 flush $mc
# set reply [gets $mc]
# puts "reply (message) is $reply" 

for {set a 1} {$a <= $numattach} { incr a} {
 puts $mc "--$boundary"
if { $attachmentname($numattach) != "" } {
  set nf "; name=\"$attachmentname($numattach)\""
  } else {
  set nf ""
  }
 puts $mc "Content-type: text/prs.lines.tag $nf"
if { $attachmentname($numattach) != "" } {
 puts $mc "Content-disposition: attachment; filename=\"$attachmentname($numattach)\""
 }
 puts $mc ""
# puts $mc $attachment($a)
if { $attachmentheader($numattach) != ""} {
 puts $mc "Tag-$attachmentheader($numattach)-version; 1.0"
 puts $mc "End:"
 puts $mc ""
 }
 tag writeentry $mc $attachment($a)
 puts $mc ""
} 

if { $numattach > 0 } {
# put on the final boundary
 puts $mc "--$boundary--"
}

 
 puts $mc "."
 flush $mc
 set reply [gets $mc]
# puts "reply (dot) is $reply" 

 puts $mc "QUIT"
 flush $mc
 set reply [gets $mc]
# puts "reply is $reply" 


}

return 0
}
