# Make file for the taglog program

version: taglog
	grep 'set version' taglog | cut -d' ' -f 3 > version

maketar: version
	./sort_taghelp taglog_help_en.tag
	./sort_taghelp taglog_help_de.tag
	./sort_taghelp taglog_help_fr.tag
	./sort_taghelp taglog_help_nl.tag
#	tagextract -m Project -eq taglog <~/diary/actions.tag | tagextract -m Status -eq Pending > doc/taglog_todo.tag
	cp -a ../taglog ../taglog-$(shell cat version)
	tar -czv --dereference -f ../taglog-$(shell cat version).tar.gz -C .. taglog-$(shell cat version)
	rm -rf ../taglog-$(shell cat version)

pkgindex: taglog
	pkg_mkIndex . *.tcl

taglog.exe: taglog.vfs
	cp taglog taglog.tcl
	sdx wrap taglog -runtime /usr/local/lib/tclkit/tclkit-win32.upx.exe
	mv taglog taglog.exe
	mv taglog.tcl taglog
	rm -r taglog.vfs

taglog.vfs:	taglog
	tclsh install.tcl -vfs

clean:
# Nothing to do for clean
