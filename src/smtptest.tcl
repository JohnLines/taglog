#!/usr/bin/tclsh

source smtp.tcl
source tag.tcl

set testtag { { Id test.1 } { tag1 value1 } { test2 value2 } { End } }
smtp send -subject "Test subject" -attachtag $testtag -attachname "testname.tag" "Test message\nthis is a two line message" john@localhost




