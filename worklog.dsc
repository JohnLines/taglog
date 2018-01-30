Tag-dsc-version: 1.0
Describes: worklog
Introduction:: END_I

Describes the worklog record format


END_I
End:

Tagname: Id
Type: Primary
Description:: END_D
provides an identifier for that action.
Often based on the current time when the record was created - but can be
anything which will make that record unique
END_D
End: Id

Tagname: StartTime
Description: The time the activity starts
End:

Tagname: EndTime
Description: The time the activity ends
End:

Tagname: Project
Description: The project field indicates the project being worked on
End:

Tagname: Description
Description:: END_D
What actually happened during the period between the StartTime and
the EndTime
END_D
End:

