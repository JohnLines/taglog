#!/usr/bin/tclsh
source tag.tcl

proc urltest { tagname tagvalue } {

if { $tagname == "URL"} {
 return 1
} else {
 return 0
}
}



set test [tag readfile test.tag]

puts "test is $test"

set newtest [ tag extract $test { { Id == nextthing } } ]

puts "newtest is $newtest"

set newtest [ tag extract $test { { Description -contains "second line"} } ]

puts "newtest is $newtest"

set newtest [ tag extract $test { { Description -exists } } ]
puts "newtest is $newtest"

set testentry [ lindex $test 1]
puts "testentry is $testentry"

tag replace testentry Tag "New value"

puts "testentry is now $testentry"


tag writefile "test-out.tag" $test

set f [open tagtest.html w]
tag writehtml dlist $f $test -isurlcall urltest
close $f

set sortlist [tag sort $test Priority -integer]

puts "sortlist is $sortlist"


set header [tag readheader test.tag]
puts "header is $header"

# performance test

for { set i 1 } { $i<=100 } { incr i } {
   tag writefile "largetest.tag" $test a
}

set time1 [time {set t1 [tag readfile largetest.tag] } ]

set time2 [time {set t2 [tag readfile0 largetest.tag] } ]

puts "time1 is $time1 time2 is $time2"


