
#
# taglog_stack.tcl - action and project stack for taglog
# Copyright John Lines (john+taglog@paladyn.org) June 2002
#
# This program is released under the terms of the GNU Public Licence
#

package provide taglog_stack 0.1

proc stack_push { type } {
global stackdepth stack_project stack_action_title stack_action_id stack_log_id
global currentProject currentActionTitle currentAction
global stack_info

incr stackdepth
set stack_project($stackdepth) $currentProject
set stack_action_title($stackdepth) $currentActionTitle
set stack_action_id($stackdepth) $currentAction
set stack_log_id($stackdepth) [donext ""]

.actionbar.stack.pop configure -state normal

set stack_info "$type $stack_log_id($stackdepth)"

}

proc stack_pop {} {
global stackdepth stack_project stack_action_title stack_action_id stack_log_id
global currentProject currentActionTitle currentAction
global stack_info

donext ""
set currentProject $stack_project($stackdepth)
set currentActionTitle $stack_action_title($stackdepth)
set currentAction $stack_action_id($stackdepth)

set stack_info "- $stack_log_id($stackdepth)"

incr stackdepth -1

if { $stackdepth == 0 } {
  .actionbar.stack.pop configure -state disabled
  set stack_info ""
  }

}


