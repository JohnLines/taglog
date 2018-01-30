proc dateRangeToLogfileList { startdate enddate } {
global rootdir
# return a list of all the log files which can be found on disk between the
# start and end dates. Either date as null string means first or last available
# (which will include today)

if { $startdate == "" } {
 set startdate "2000-01-01"
 }

if { $enddate == "" } {
 set enddate [clock format [clock seconds] -format "%Y-%m-%d"]
 }

set result {}

for { set thisdate $startdate } { [clock scan "$thisdate"] <= [clock scan "$enddate"] } { set thisdate [clock format [ clock scan "$thisdate 1 day" ] -format "%Y-%m-%d"] } {

# turn the date into a filename

scan $thisdate "%d-%d-%d" thisyear thismonth thisday
set thismonth [format "%02d" $thismonth]
set thisday [format "%02d" $thisday]

set filename "$rootdir/log$thisyear/$thismonth$thisday.tag"
if [file exists $filename] {
  lappend result $filename
 }
}
return $result
}


