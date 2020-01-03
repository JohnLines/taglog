Tag-help-version: 1.0
Translated-by: John Lines <john+taglog@paladyn.org>
Sorted-date: 2019-10-10 15:13:45
Sort-key: Id
End: 
Id: About
Description:: END_D
This is version $1 Copyright 2000 John Lines <john+taglog@paladyn.org>
Taglog is Free Software, released under the terms of the GNU Public License.
See  https://github.com/JohnLines/taglog/wiki for the taglog home page
END_D
End: 
Id: actinput
Description:: END_D
An action should be a clearly definable piece of work which you (or someone
else) intend to do. You can use the fields in the action input menu to
set key attributes of the action. Each of those fields has its own help.

Before entering an action you should consider if it should be done at all.
Remember Stephen R Coveys Circle of Concern and Circle of Influence from
the 7 Habits of Highly Effective People.
If an action does not fall within your Circle of Influence then you are best
to abandon it and move on to something where you can have an effect.
END_D
End: 
Id: actinput_abort_action
Description:: END_D
This field contains the Id of an action which will be started if the action
being entered is aborted.
END_D
End: 
Id: actinput_active_after
Description:: END_D
If you set a date, and optionally a time, then the action will be entered as
being Blocked, and will automatically become Active at the given time, or
the next time that taglog is started if the Active-after time occurred while
taglog was not running.

A window will pop up when the action is activated, telling you its Title and
Description. This allows you to use the system for timed reminders.
END_D
End: 
Id: actinput_date
Description:: END_D
The Date field contains the date the action was added. It is filled in
automatically by the program.
END_D
End: 
Id: actinput_delegated_to
Description:: END_D
This contains the Contact Id (or just the name if you are not using the
Contacts) of the person that the action has been deleted to. At present
taglog does not notify the person that the action has been delegated, so
you will have to do that yourself.
END_D
End: 
Id: actinput_deliverable
Description:: END_D
The Deliverable field exists so you can define exactly how you will know
when the action has been completed.

If you find that actions are accumulating which are not Completed it may be
that you need more precision in setting the deliverables. If the goalposts
move and the action can no longer be Completed it should probably be Aborted,
and a new action started with the new deliverable.
END_D
End: 
Id: actinput_description
Description:: END_D
Here you can enter a long description of what you are supposed to do.
If you were asked to do something via an email you could cut and paste the
key bits of that mail message into the description.
END_D
End: 
Id: actinput_difficulty
Description:: END_D
If you set a difficulty for an action you can use it later to select only
actions which are easier than some level. For example you may wish to pick
off a few easy actions towards the end of the day, but not want to start on
something which you know will be tricky.
END_D
End: 
Id: actinput_email_status_to
Description:: END_D
If you set this field, and your email preferences have been set up, then a
mail message will be sent to the given address every time the status of the
action changes. This includes it first being created.

The mail message contains all the fields in the action.
Using this will let you keep someone updated on the progress of the action
without you having to do any extra work.
END_D
End: 
Id: actinput_expected_completed_date
Description:: END_D
Enter the date by which you expect the action to be completed. The date
should be entered in ISO format i.e. yyy-mm-dd

You can also enter the date by clicking on the calendar widget to the right
of the input field and using the displayed calendar to select the date.

By recording the date when you expect to complete the action you will be
able to check which actions should have completed by some date.
END_D
End: 
Id: actinput_expected_cost
Description:: END_D
Enter the amount (in whatever currency units are convenient to you) which you
expect the action to cost (apart from the cost of the time).
The cost should be spedified as a real number
END_D
End: 
Id: actinput_expected_start_date
Description:: END_D
Enter the date on which you expect to be able to start this action, i.e.
the date you expect it to move from Pending to Active.
The date should be entered in ISO format, i.e. yyyy-mm-dd

You can also enter the date by clicking on the calendar widget to the right
of the input field and using the displayed calendar to select the date.
END_D
End: 
Id: actinput_expected_time
Description:: END_D
Enter the amount of time you expect this job to take, in hours and minutes of
actual work, not the elapsed time.

You can select one of the values from the menu, or enter your own value in
the text field, for example 3:15 for 3 hours and 15 minutes
END_D
End: 
Id: actinput_id
Description:: END_D
Every action is given a unique identifier. If you leave the Id field as
*Auto* then an Id will be generated automatically. If you have specified
an id prefix in your preferences then this forms the first part of the Id.

If the action is associated with a project then the Id is generated from the
name of the project, followed by a serial number which increments with each
action for that project - for example jlines.test_project.57

If the action is not associated with a project then the identifier which is
generated is of the for taglog.yyyymmddhhmm - taken from the current date and
time - for example jlines.taglog.200011190945

Note that the prefix part goes with the originator of the action, not
nescessarily with who is going to do it - it is there to make sure that the
actions are unique - so that there is no confusion if someone ask - 'Have
you finished jlines.test_project.57 ?'
END_D
End: 
Id: actinput_next_action
Description:: END_D
This field contains the Id of an action which will be started as soon as
the action being entered is completed.
END_D
End: 
Id: actinput_period
Description:: END_D
For an action with a status of Period, the frequency or Period this action
becomes active again. It is in the format

Period: Daily|Weekly|Monthly|Yearly [when]

where when is an optional number for the hour of day, or day of week or month
when the action becomes due again. For a Daily action this defaults to 0, for
Weekly, Monthly or Yearly it defaults to 1. If the field is absent or empty
it defaults to Daily
END_D
End: 
Id: actinput_precursor
Description:: END_D
The precursor field allows an action to be blocked until another action has
completed.

The precursor attribute is not used yet.
END_D
End: 
Id: actinput_priority
Description:: END_D
Taglog uses priorities in a range from 0 to 100, where priority 0 is the most
urgent, and priority 100 is behind everything else.
The default priority is 50.
END_D
End: 
Id: actinput_project
Description:: END_D
Taglog uses the term project to refer to a way of dividing up your time for
accounting purposes. If you associate an action with a project then whenever
you tell taglog that you are working on that action your time will be booked
to its associated project.
If you do not have any projects defined yet then you can add them using the
Projects/Add option of the main menu bar.
END_D
End: 
Id: actinput_reason
Description:: END_D
Sometimes it is difficult to remember why you are doing this in the first
place. You may find that having access to the reason why you are working on
this action will help motivate you. If it wont - for example if the reason
is 'My boss told me to' then dont bother with this field
END_D
End: 
Id: actinput_status
Description:: END_D
Actions normally start with a status of Pending - which means that they are
waiting to be worked on.
Active actions are the ones you are currently working on, until they are
Completed.
Actions may be Aborted if you decide not to finish them.
Actions which would be Active but for some reason which is preventing you
from working on them are Blocked.
Actions may also be Delegated to someone else. If you have no further
responsibility for the action they you could just Complete it instead.
The Unclaimed status is intended for use by a pool of people looking at
a common set of actions - an action can be labeled as Unclaimed and then
people can change the status to Pending, or Active and label the action as
being assigned to themselves.
Periodic Actions have an associated Period, which defaults to Daily. At that
start of that Period the action is active, but when it is Completed it stays
as a Periodic Action and is displayed again in the next Period
END_D
End: 
Id: actinput_subtask_of
Description:: END_D
The Subtask-of indicates that a task is a subtask of another task.
It is not yet implemented.
END_D
End: 
Id: actinput_title
Description:: END_D
Choose a short title for this action. There are several places where you
will want to identify the action from its title, without seeing the rest of
the information about the task, such as the description, or the project - so
try to make the title stand on its own.
END_D
End: 
Id: actions
Description:: END_D
The actions facility helps you to organise your 'todo' list. Once you have
entered some actions you can indicate that you are working on an action by
clicking on the Action button in the middle menu bar and selecting from
the actions which are currently active.

Add... creates a new action.
View allows you to select actions to display and to edit them by right clicking
 on a displayed action.
History finds all the log entries associated with a particular action and
 displays them. It also sums up all the time spent on the action and allows
 you to revise your estimate of the time it will take, and when it will be
 complete.
Complete selects and active action and marks it complete. The date the
 action was completed is recorded and you can add a note about the completion.
Activate selects a pending action and marks it as active.
Abort Active marks an active action as aborted
Abort Pending marks a pending action as aborted
Reactivate marks an action which you thought was completed as active again.
Extra... has internal facilities for manipulating the actions data which
 should not be required in normal use.
END_D
End: 
Id: actmail_message
Description:: END_D
Enter the body of the message you wish to send as a covering note to go with
this action
END_D
End: 
Id: actmail_to
Description:: END_D
Enter the email address of the person the mail message should be sent to, or
select their contact Id from the list, and their email address will be inserted
automatically
END_D
End: 
Id: actreminder
Description:: END_D
Use this field to give you a reminder of the actions you plan to do today.
At the moment this is just an ordinary text field and is not tied in to
the main actions data.
When you exit the program the contents of the action fields are saved so
you can look back and remind yourself what you were working on yesterday.
(only by looking at the raw file at present)
END_D
End: 
Id: actsel
Description:: END_D
There are several ways to select a set of actions. This window allows you
to set the attributes of the actions you wish to select.

The attributes are cumulative, so actions must match all the criteria to be
selected.

The Refresh button refreshes the set of actions in the drop down menus for
Id and Title according to all the other criteria.
END_D
End: 
Id: actsel_expected_completed
Description:: END_D
You can select actions by the date you expected them to be completed.
END_D
End: 
Id: actsel_expected_start
Description:: END_D
You can select actions by the date you expected them to start.
END_D
End: 
Id: actsel_filename
Description:: END_D
Select the filename from which you are selecting actions. The default is the
current active actions file
END_D
End: 
Id: actsel_id
Description:: END_D
If you press the Refresh button to the left of the Id field then the Id menu
will be filled with the action Ids of all the actions which match the other
fields. You can then use the Id field to select one particular action.
END_D
End: 
Id: actsel_maxpriority
Description:: END_D
Here you can choose the maximum priority for the actions which are selected.
Priorities are normally on a scale from 100, as the least important to 1 as
the most important. The default priority is 50.
This allows you to pick actions which are more important than some level.
END_D
End: 
Id: actsel_project
Description:: END_D
Choose the project for which you are selecting actions.
Only actions associated with that project will then be selected.
END_D
End: 
Id: actsel_showfields
Description:: END_D
You can select the fields which are shown when you list actions. If the
All checkbox is selected then all fields are shown, otherwise only the
fields selected from the other checkboxes are shown
END_D
End: 
Id: actsel_sortby
Description:: END_D
The actions list returned by the display can be sorted by certain fields.
Select a value here to sort the selected actions by the given field value
before they are displayed.
END_D
End: 
Id: actsel_st
Description:: END_D
If the Any checkbutton is selected then all actions are selected, regardless
of status.
If the Any checkbutton is not selected then only actions with a status which
matches the other checkbuttons will be selected.
END_D
End: 
Id: actsel_title
Description:: END_D
If you press the Refresh button to the left of the Id field then the Title menu
will be filled with the action titles of all the actions which match the other
fields. You can then use the Title field to select one particular action.
END_D
End: 
Id: add_old_log
Description:: END_D
Using this panel you can add an old log entry. The entry is always appended
to the log file, even if it already exists and you are adding a time range
which is earlier than any of the times in that file, or which overlaps.
This will confuse the reporting tools if you use them on such a file.

The main use for this facility is so you can fill in an entry if ypu spent
a whole day away from your computer - on leave, or on a course.
END_D
End: 
Id: addcontact
Description:: END_D
Fill in the fields to add a new contact. You can then use these contacts to
simplify mailing of reports, and to keep track of phone calls you are due
to make, or a history of contact with a particular person.
END_D
End: 
Id: addcontact_address
Description:: END_D
Enter the parts of the address for this contact which can not be supplied in
any other field.
END_D
End: 
Id: addcontact_country
Description:: END_D
Enter the country where this contact resides. I suggest using the ISO country
code, so as to be consistent, but the program does not enforce this.
END_D
End: 
Id: addcontact_default_as
Description:: END_D
This is an experimental facility in which - in a future release, you will be
able to add the Id of another contact here, and all the fields for this
contact, except those specified more fully in this contact, will be filled
in from the values in the contact pointed to by Default-as.

In this release this is just a place holder for this field - which does not
do anything.
END_D
End: 
Id: addcontact_email
Description:: END_D
Enter the electronic mail address of the contact.
END_D
End: 
Id: addcontact_fax
Description:: END_D
Enter the fax number for this contact.
END_D
End: 
Id: addcontact_forename
Description:: END_D
Enter the forename of this contact.
END_D
End: 
Id: addcontact_id
Description:: END_D
Enter an identifier to use for this contact. This should be something short
but memorable as it you may be selecting it from a menu of contacts.
Depending on how many contacts you expect to have you could use peoples
initials, or there full name.
END_D
End: 
Id: addcontact_ldap
Description:: END_D
Enter an LDAP URL for this contact, as described in RFC 2255
e.g. ldap://ldap.example.com/cn=smith,dc=example,dc=com

Potentially this could be used to get or verify this contact's details
against the LDAP server.
END_D
End: 
Id: addcontact_mobilephone
Description:: END_D
Enter the mobile phone number for this contact.
END_D
End: 
Id: addcontact_organisation
Description:: END_D
Enter the organisation associated with this contact, for example the
company they work for.
END_D
End: 
Id: addcontact_phone
Description:: END_D
Enter the land line phone number for this contact
END_D
End: 
Id: addcontact_postcode
Description:: END_D
Enter the postcode, or zip code, for this contact
END_D
End: 
Id: addcontact_short_id
Description:: END_D
Give a short (2 or 3 character) identifier for this contact. This is used
for action reports where an action is assigned to one or more people, in
order to take up a small amount of space in the report.
This field is only meaningful (at present) for co-workers.
If it is not supplied then the normal Id is displayed instead.
END_D
End: 
Id: addcontact_surname
Description:: END_D
Enter the surname of this contact.
END_D
End: 
Id: addcontact_title
Description:: END_D
Enter the title of this contact, or select from the drop down list.
Note that there are so many possible titles that the list does not
even attempt to cover Professor, Lady etc.
END_D
End: 
Id: addcontact_type
Description:: END_D
Select the type of contact from the drop down list. You can override the
contact types from your preferences file.
END_D
End: 
Id: addcontact_web
Description:: END_D
Enter an HTTP URL for the home page of this contact.
END_D
End: 
Id: addproject
Description:: END_D
Taglog uses Project in the sense of something to which you book time.
The project name should be a memorable name for the project.
The booking code is the way the project is identified in your billing system,
which may not use memorable names for billing items.
You can have a project (or more than one project) which are flagged as breaks,
i.e. they are not billable time.

You can also have one or more proejcts which are costed as overheads.
When you generate time bookings reports you can have the time spent on your
overheads proejcts spread across your real billable projects.

The main projects which you are currently working on should be marked as
Active. They will always appear in the Projects/View display, even if
you have not booked any time on them yet today.

The system automatically fills in the date that you created the project,
and you can fill in the date you expect it to end, or you can fill it in
later using the Projects/Edit menu entry.
The system uses the dates to make the scan for total time spent on a project
more effective because it only has to look at logs after the project was
created.
After the end date has passed you will no longer be offered the project as
an option to book new time to.

The Expected-time is the time - in hours and minutes you expect to book to
the project over its lifetime.
END_D
End: 
Id: adjstart
Description:: END_D
The ability to adjust the start time of a log entry may be useful if, for
example, you were away from your desk, logging time to one project, and
someone diverts you to have a brief word, which turns into an extended
discussion, about some other project.

You can adjust the start time of the current action (the one whose description
you type into the lower large window) by clicking on the Start button.
You can either type the revised start time in to the box next to the label
'New Start Time' or adjust the time with the slider to subtract some number
of minutes.

If you are not adjusting the start time of the first entry of the day then
you are offered the chance to change the end time of the previous entry to
match the new start time. This is the default.
If you do not adjust the end time of the previous action then you will double
account for the time by which you adjusted the start.
END_D
End: 
Id: alwin_project
Description:: END_D
Enter or select from the drop down list the name of the project which is
associated with the old log entry.
All project names, even those which are now past their end date, are
available for selection.
END_D
End: 
Id: archiveproject
Description:: END_D
From here you can move projects which have been closed to a seperate file.
This will reduce the number of old projects which you are offered in the
some of the drop down menus, and will save memory as all projects in the
main projects file are kept in memory, even if they are closed.
END_D
End: 
Id: contacts
Description:: END_D
Managing contacts is not a primary function for taglog, but it has a contacts
facility so you can associate a log entry with a person and search for
records which relate to that person. You can also store email addresses and
use them in conjunction with taglogs email facility.
END_D
End: 
Id: contactview
Description:: END_D
Use the fields to select the contact(s) you wish to view and click on View.
If a field is blank then it matches every contact, so leaving all fields blank
will return all your contacts.
END_D
End: 
Id: cview_forename
Description:: END_D
Enter the forename, or part of the forename, of the contact you are
searching for.
END_D
End: 
Id: cview_organisation
Description:: END_D
Enter the name of the organisation, or part of the organisation name you wish
to search for.
END_D
End: 
Id: cview_phone
Description:: END_D
Enter the phone number, or part of the phone number you wish to search for.
END_D
End: 
Id: cview_surname
Description:: END_D
Enter the surname, or part of the surname, of the contact you are searching
for.
END_D
End: 
Id: cview_type
Description:: END_D
Select a type of contact to limit matches to that type.
END_D
End: 
Id: editprefs
Description:: END_D
Taglog stores its user preferences in the file named in the title of the
Edit Preferences window.
Here you can change several things which affect the way to the program works.
Each has its own description as a Help entry in the label button.
Select OK to save the preferences to this file.
END_D
End: 
Id: editprefs_current_win_depth
Description:: END_D
You can set the depth of the current log entry frame here, though this
window will resize if you resize the whole window.
END_D
End: 
Id: editprefs_history_win_depth
Description:: END_D
You can reduce the depth of the History window (the one which shows log
entries from earlier in the day) by reducing this value. This allows
taglog to take up less screen space on a small display.
END_D
End: 
Id: editprefs_id_prefix
Description:: END_D
The ID prefix is used to make actions which you create unique (within a
workgroup). If this is set then the Id of any actions you create will be
prefixed with this prefix
END_D
End: 
Id: editprefs_num_today_actions
Description:: END_D
You can keep a reminder of your top 'n' actions for the day above the
previous entries frame. Setting this to 0 will remove the top actions
frame completely.
END_D
End: 
Id: editprefs_projects_url
Description:: END_D
Specify the URL to a web page which will supply the list of projects to which
you can book. For example http://projects.example.com/projects-list.php?jl
END_D
End: 
Id: editprefs_start_procs
Description:: END_D
Any procedures listed here will be executed when taglog starts.
If you want to start with the main window iconified and just a window
showing the currently active project names and the amount of time booked
to them today then select 'iconify_mainwin doShowProjects'
END_D
End: 
Id: editproject
Description:: END_D
Taglog uses Project in the sense of something to which you book time.

Each project has a name, some flags related to how time for that project is
booked, a booking code and a start and end date.

The flags are:
 Breaks - this project is not normal work time. Time recorded here is treated
  differently when reporting and Overheads projects time is not spread into it.
 Overheads - time spent on this project can be spread across the real billable
  projects for reporting purposes.
 Active - This project is being actively worked on (as opposed to just being
  open). This causes it to always appear in the Projects/View menu even if
  you have not spent any time on it today yet.
 Immutable - Overheads are not to be spread into this project.

You can prevent a project from showing up in the main selection panel by
giving it an end date earlier than today.

END_D
End: 
Id: endbutton
Description:: END_D
The menus which come from the End button control miscellaneous features of
the log entry.
You can Complete the current action.
You can Abort the current action.
You can associate a contact with the current log entry - this is reset on
moving to the next log entry.
You can associate a rate with the current log entry. This is 'sticky', so if
you indicate that you are now on Overtime rate you will stay on it until you
exit the program or clear the rate.
END_D
End: 
Id: ep_enddate
Description:: END_D
Enter the date on which this project ended.
END_D
End: 
Id: file
Description:: END_D
Open... allows you to look at entries from previous days. You can find entries
 which match particular criteria, such as project or type of activity.
Exit should be used to terminate the program at the end of the day.
Quit terminates the program without saving the last entry.
Add/Edit Log allows entries from previous days to be created or edited. To edit
 previous entries in todays log you should right click the entry in the upper
 window.
Pause and Resume allow the bookings clock to be stopped and started. You may
 wish to create a Breaks project and switch to that instead. (see Projects/Add)
Preferences allows you to customise several features of the program
END_D
End: 
Id: hint_activity_pre_meeting
Description:: END_D
Meetings can be a great waste of time, or they can be extremely productive.
The key is preparation. Think about the following before the meeting.

Why are you going to be there ?
 Are you running the meeting ?
  If so do you have an agenda with your personal guidelines for how long
  the items should take ?
 Are you to provide technical input ?
  If so have you done your background research ?
  What questions might you be asked ?
 Are you there to find information ?

What are your objectives ?
 If you know what you want out of the meeting, and nobody else is prepared
 then you will probably get your objectives.

END_D
End: 
Id: hint_help
Description:: END_D
This section contains background information time management. Some of it
gives suggestions for solving time management problems with taglog, but
it also contains more general time management help.

Additions to the hints are welcomed. If you have a great time management tip
please send it to the taglog author.
END_D
End: 
Id: hint_problem_actions_overrun
Description:: END_D
If you find that actions are taking longer than you originally expected then
you are probably being too optomistic at the outset. If you are not already
doing so, try to start entering initial estimates of expected elapsed time
when you enter actions. Review your active actions regularly, by using the
Actions/History menu item - and update the Expected Time and Completed
Date entries.

The Actions/History summary will show you how your latest estimates compare
with the original estimates. Use this information to help you give better
original estimates in future.
END_D
End: 
Id: hint_problem_interruptions
Description:: END_D
If you find that interruptions are a problem you should try to set aside some
time when people know you should not be interrupted. Put a notice on your
door, or at your desk in an open plan office. Set up an answering machine or
voicemail message telling people when you prefer to receive calls.
END_D
End: 
Id: introduction
Description:: END_D
Taglog provides a way to measure how you spend your time, and to assist
with planning actions (tasks). You can book time to projects, which is the
term taglog uses for the way you divide your time for booking purposes.

If you want to book time to projects then you should create some projects
entries as your next step.

The main function of taglog is to make notes about how you spend your time.
You enter these notes into the large lower window below.
When you switch to a different activity click on the Next button and the
time you started and finished that activity will be recorded.

Many of the text labels have on line help, and also allow you to select
values for the associated field from a list. Click on the label to see the
values and help.

To exit the program use the File/Exit menu item.
END_D
End: 
Id: led_calendar
Description:: END_D
Press one of the buttons in the calendar to select the day for which you want
to input or edit the log entries. The buttons ">>" and "<<" allow to change to
the next of previous month. If there is a log file available for a day, the
background colour of the corresponding button is yellow.
END_D
End: 
Id: led_ediEnt
Description:: END_D
This window allows to edit the parameters of a log entry.
END_D
End: 
Id: led_entList
This window displays the List of all log entries of a selected day. Entries
with start times greater than the end time of the previous entry are marked
with ">". If the start time of an entry is greater than its end time this
entry is marked with "!". Marked entries are highlighted if it is supported
by your TCL/TK version.
The following editing options are available: 
Edit...
  This option is only active if entries are selected from the list. For each
  selected entry an editing window will be opened which displays all the
  parameters of an log entry.
Add...
  An input window is opened to add a new log entry.
Delete
  The selected items will be deleted.
Import...
  This option allows to load log entries from a file.

In addition you can adjust the start an end time of a log entry to the end
or start time of the previous or next log entry. These operations are available
iy you select an entry in the list with the right mouse button. A menu will
where you can select the adjustment option.
Description:: END_D

END_D
End: 
Id: led_impList
This list contains the log entries of the selected file. Entries with start
times greater than the end time of the previous entry are marked with ">".
If the start time of an entry is greater than its end time this entry is
marked with "!". Marked entries are highlighted if it is supported by your
TCL/TK version.

With "Import" one can transfer selected entries to the target list.
"Import all" allows to import the entire list.
Description:: END_D

END_D
End: 
Id: led_newEnt
Description:: END_D
Here you can enter the parameters for a new log entry.
END_D
End: 
Id: logedit
Description:: END_D
According to The Rubaiyat of Omar Khayyam (translated by Edward Fitzgerald)

 The Moving Finger writes; and, having writ,
 Moves on; nor all thy Piety nor Wit
 Shall lure it back to cancel half a Line,
 Nor all thy Tears wash out a Word of it.

The taglog program, however, gives you the chance to right click on an
item in the previous entries window and edit that entry.
END_D
End: 
Id: logedit_action
Description:: END_D
You can change the action associated with this entry. At presnet you can not
select this from a list of actions, and the action Id is not verified, so
take care.
You should also adjust the ActionTitle field if you change this.
END_D
End: 
Id: logedit_actiontitle
Description:: END_D
You can change the action title associated with this entry. At presnet you
can not select this from a list - also note that you should keep this
in step with the Action field - which you will have to do manually at
present
END_D
End: 
Id: logedit_activity
Description:: END_D
You can change the activity associated with this entry.
END_D
End: 
Id: logedit_contact
Description:: END_D
You can change the contact associated with this entry.
END_D
End: 
Id: logedit_description
Description:: END_D
You can change the description associated with this entry.
END_D
End: 
Id: logedit_end
Description:: END_D
You can change the end time of this entry - though note that at present     
there is no attempt to adjust the start time of the following entry.

You will have to do this yourself if you want to keep your logs consistent
END_D
End: 
Id: logedit_id
Description:: END_D
This field shows the identifier associated with this log entry. It is not
sensible to change it.
END_D
End: 
Id: logedit_project
Description:: END_D
Change the project associated with this entry.
END_D
End: 
Id: logedit_rate
Description:: END_D
You can change the rate associated with this entry. For example you could
indicate that this entry is to be charged at Overtime rate.
END_D
End: 
Id: logedit_start
Description:: END_D
You can change the start time of this entry - though note that at present
there is no attempt to adjust the end time of the preceding entry.

You will have to do this yourself if you want to keep your logs consistent
END_D
End: 
Id: logsel
Description:: END_D
Use the date fields in the top section to select which files should be opened.
You can use the fields below to restrict which entries in those files are
displayed.
END_D
End: 
Id: logsel_activity
Description:: END_D
If you select a type of activity here then only entries which match that type
of activity will be shown in the resulting display
END_D
End: 
Id: logsel_contact
Description:: END_D
If you select a contact here then only entries which are associated with that
contact name are displayed. You could use this to review all the things you
have discussed with a particular person over the last month, for example
END_D
End: 
Id: lvsa_dirname
Description:: END_D
Enter or select the name of the directory where the file to be saved will
be stored
END_D
End: 
Id: prefs_activitiesfile
Description:: END_D
The activities file holds the names of the types of activity which you wish
to record.
The file contains one activity type per line.
You need to restart taglog after making a change to this file before you can
use the new activities
END_D
End: 
Id: prefs_dateformat
Description:: END_D
Enter your preferred format for entry and display of dates (selecting one from
the options given). The taglog program always works internally in ISO 8601
format but some parts will take input dates, and output them, in your preferred
format.

Note that support for other date formats is currently incomplete.
END_D
End: 
Id: prefs_docdir
Description:: END_D
Taglog keeps its on line documentation in this directory. If you are reading
this message then the docdir value is presumably already correct.
If the value is not correct then you will not see this message.
Thus if you can read this, do not change the value unless you really know
what you are doing.
END_D
End: 
Id: prefs_language
Description:: END_D
This field indicates your preferred language, as an ISO 639 language code.
At present only the help information is available is available in more than
one language.
Help with better translations and more languages is always appreciated
END_D
End: 
Id: prefs_libsdir
Description:: END_D
This is the directory where the main taglog program finds its libraries.
Unless you really know what you are doing you should not change this.
END_D
End: 
Id: prefs_rootdir
Description:: END_D
The data files for taglog are all stored in this directory, or its
subdirectories.

Note that if you change it you may already have log files under the old
directory, which you will have to move.
END_D
End: 
Id: prefs_showtime_hours_per_day
Description:: END_D
Enter the nominal length of your working day, in decimal hours. This is used
by the Weekly Time Bookings report if you ask for times to be reported as
decimal days.
END_D
End: 
Id: prefs_showtime_spreadoverheads
Description:: END_D
Select this if you want the time booked against overheads projects to be
spread across all the bookable projects by default.
END_D
End: 
Id: prefs_timebook_startlastweek
Description:: END_D
If you usually run the time bookings report for the previous week then set
this to last week. If you usually run the time bookings report for the current
week then set this variable to this week.
END_D
End: 
Id: prefs_timeformat
Description:: END_D
Enter your preferred format for display of times. The taglog program will
format three numbers, representing HH, MM and SS, using your preferred
format. The format string is the same as used by TCL's format function or
printf. For example, to alway have leading zeros in hours but no leading
zeros in minutes, try "%02d:%d".
END_D
End: 
Id: project_expectedtime
Description:: END_D
Enter the total time (in hours) you expect to spend on this project.
END_D
End: 
Id: projects
Description:: END_D
Within taglog a project is a way you divide your time for booking purposes.
For the ability to schedule and control activites you should look at Actions.

Add creates a new project
Edit allows the projects to be edited or deleted.
Update allows you to fetch projects information from the URL specified in
 preferences.
View shows the way time has been spread across projects in the current day,
 and allows you to switch between projects with a minimised main window.
END_D
End: 
Id: reports
Description:: END_D
Taglog can produce a number of reports on the information it has collected.

'Weekly Time Bookings by project' provides the information you need to feed
into your company time booking system, with the time spent on each project,
per day, and totaled for the week.

'Time by Activity' tells you where your time has been going in terms of
meetings, phone calls etc.

'Total time for a project' goes through all the log entries for a project
since it started and adds up the total time spend.

'Project Progress Report' shows the actions for a project have been completed
in some time frame, and the ones which should have started or completed, but
have not.

'Interruptions Report' summarizes the information gathered from using the
action stack to change activity on an interruption by telling you how often
this happens over some time period.

'Active and Pending actions' is a shortcut to doing Actions/View and selecting
Active and Pending.

'Active Actions Review' is a more comprehensive review of all active actions,
finding how much time has been spent on each one so far and offering a chance
to review the amount of time you expect to spend working on them, and the
time they are expected to be completed.


END_D
End: 
Id: smtp_mailhost
Description:: END_D
Enter the name of a computer which can be used as your mailhost, that is,
a computer which will accept mail from you for delivery to other people.
For Unix users the default is localhost
END_D
End: 
Id: smtp_myemail
Description:: END_D
Enter your email address here - the address which you wish the mail to be
labeled as coming from.
END_D
End: 
Id: smtp_port
Description:: END_D
SMTP to another host normally uses port 25, but some systems use port 587
for local mail submission.
END_D
End: 
Id: smtp_prefsfile
Description:: END_D
The preferences for the mail configuration are stored in their own file.
For Unix the file is ~/.smtp
For Windows the file is ~/smtp.cfg
If neither file is found then the smtp parameters are initialised to a
set of internal defaults.
END_D
End: 
Id: smtp_thishost
Description:: END_D
Enter the name of this computer, which will be used in the HELO part of the
SMTP dialog.
END_D
End: 
Id: summarybox
Description:: END_D
Enter a summary of the days events here.
Note that if you hit Cancel here the program will still Exit - but without
writing a summary.
END_D
End: 
Id: timebook_numweeks
Description:: END_D
Enter the number of weeks for which you want a report. This allows you to
catch up on time bookings reporting by doing several weeks at a time.
END_D
End: 
Id: timebook_weekno
Description:: END_D
Enter the week number - it defaults to the current week and can be adjusted
with the - and + buttons.
END_D
End: 
Id: timebook_year
Description:: END_D
Select which year the week of the time bookings starts in.
Note that time booking reports which straddle years will probably not work
END_D
End: 
Id: timebooksel
Description:: END_D
Here you can control the generation of the time bookings report.
You can display the times in the report as hours and minutes, or as
decimal fractions of hours, or as decimal fractions of days.

The preferences setting Hours per Day controls the conversion for decimal
fractions of days.

If you select to Spread overhead projects then the time booked to projects
which are flagged as overheads is distributed across all the other projects
(apart from those flagged as breaks. The overheads time for each day is
spread according to the distribution of time across all bookable projects
for that week.

The facility to spread overhead projects by day is not yet enabled.

You can choose how the projects are displayed, by booking code, or by name
or both together. If you have more than one project with the same booking
code and you select the 'Book by Code' option then the totals for those
projects will be amalgamated.

You should type in the year if you are not looking at the current year.
You can change the week of the year you generate the report for, by
entering the week number, or moving forwards and back with the + and -
buttons.
END_D
End: 
Id: timebooksel_spreadoverheads
Description:: END_D
The time booked to projects which are flagged as Overheads can be
redistributed across other projects.
If this is set to Off then no redistribution occurs and Overheads projects
are shown in the output.
If this is set to Week then the total times for every normal project
for the week are summed, and this is redistributed proportionally amongst
the non overheads projects.
If this is set to Day then the redistribution only takes place within a day.
Redistribution by Day is experimental at present.

Projects which are labeled as Immutable or Breaks do not participate in the
redistribution process.
END_D
End: 
Id: timebooksel_timeformat
Description:: END_D
Time can be reported as hours and minutes, decimal hours or decimal days.
The preferences setting Hours per Day controls the conversion for decimal
fractions of days.
END_D
End: 
Id: UNKNOWN
Description:: END_D
There is no help for this item in English. I would be very grateful if you
could supply a translation to john+taglog@paladyn.org
END_D
End: 
Id: viewc
Description:: END_D
Right clicking on a contact will bring up a menu which will allow you to
edit its details
END_D
End: 
Id: viewproject
Description:: END_D
The 'View Project Times' display shows the cumulative time for each project
you have booked to in the current day.
It also shows the total time for all projects and the total time for all
projects which are not labeled as 'breaks'

Projects which have not been booked on the current day at the time the window
is opened will not be displayed, but will show up if you click OK and then
select Projects/View again

You can switch to a different project by clicking on one of the project
labels.
END_D
End: 
