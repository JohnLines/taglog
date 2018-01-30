# hand make package index

package ifneeded tag 0.1 [list source [file join $dir tag.tcl]]
package ifneeded smtpclient 0.1 [list source [file join $dir smtp.tcl]]

# The following are internal taglog routines
package ifneeded taglog_help 0.1 [list source [file join $dir taglog_help.tcl]]
package ifneeded taglog_report 0.1 [list source [file join $dir taglog_report.tcl]]
package ifneeded taglog_init 0.1 [list source [file join $dir taglog_init.tcl]]
package ifneeded taglog_util 0.1 [list source [file join $dir taglog_util.tcl]]
package ifneeded taglog_project 0.1 [list source [file join $dir taglog_project.tcl]]
package ifneeded taglog_action 0.1 [list source [file join $dir taglog_action.tcl]]
package ifneeded taglog_contact 0.1 [list source [file join $dir taglog_contact.tcl]]
package ifneeded taglog_widgets 0.1 [list source [file join $dir taglog_widgets.tcl]]
package ifneeded logEdit 0.1 [list source [file join $dir logEdit.tcl]]
package ifneeded mainwin 0.1 [list source [file join $dir mainwin.tcl]]
package ifneeded taglog_stack 0.1 [list source [file join $dir taglog_stack.tcl]]
