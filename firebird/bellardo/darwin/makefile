CLUI_OBJECTS = bin/gbak bin/gdef bin/gds_drop bin/gds_lock_mgr bin/gds_lock_print bin/gds_pipe bin/gfix bin/gpre bin/gsec bin/gsplit bin/gstat bin/isql bin/qli
VAR_FILES= isc_config services.isc macos/inetd.conf.isc macos/license.html macos/license.txt
SERVERTYPE=	CLASSIC
BUILDTYPE=	DEV
ROOT=		../../..

all: firebird

firebird: checkfbinstall dirs typecheck .codes build
	echo "##################  Build Complete  #####################"
	echo "use 'make install' as ROOT to install firebird locally \
	use 'make package' to create an installer package for Firebird"

build: force
	tcsh -ec 'setenv PATH .:$$PATH; cd $(ROOT); chmod a+x build_kit; ./build_kit builds $(SERVERTYPE)'

dirs: .dirs_setup Firebird.framework

.dirs_setup Firebird.framework:
	-rm -rf $(ROOT)/interbase/Firebird.framework
	tcsh -ec 'setenv PATH .:`./binpath`:$$PATH; cd $(ROOT); chmod a+x setup_dirs; ./setup_dirs DARWIN $(BUILDTYPE)'
	cp `./includepath`/iberror.h $(ROOT)/interbase/include
	cp `./binpath`/gpre $(ROOT)/interbase/bin
	cp `./binpath`/gds_lock_mgr $(ROOT)/interbase/bin
	### Darwin doesn't need the shared lib, because the make process
	### has been modified to link against the correct framework.
	touch .dirs_setup

.codes:
	sh -ec "cd $(ROOT)/jrd; make codes; ./codes"
	touch .codes

checkfbinstall: force
	chmod a+x checkinstall.sh
	./checkinstall.sh $(ROOT)

typecheck: force
	chmod a+x checkmakefiles.sh
	./checkmakefiles.sh $(BUILDTYPE) $(ROOT) $(SERVERTYPE)

updatemakefiles: force
	tcsh -ec 'setenv PATH .:`./binpath`:$$PATH; cd $(ROOT); chmod a+x setup_build; ./setup_build $(BUILDTYPE)'
	-rm -f .codes >> /dev/null

install_package: files/addServEnt
	rm -rf firebird_install
	mkdir firebird_install
	-rm -f Firebird.framework/Resources/English.lproj/var/isc_lock* Firebird.framework/Resources/English.lproj/var/isc_init* Firebird.framework/Resources/English.lproj/var/isc_event*
	mv Firebird.framework firebird_install
	cp files/install files/inetd.conf.isc files/addServEnt firebird_install
	tar -zcf DarwinCS.tar.gz firebird_install
	mv DarwinCS.tar.gz ..
	mv firebird_install/Firebird.framework .
	rm -rf firebird_install

install_pkg: Firebird.pkg files/pre_install files/post_install files/pre_delete files/post_delete
	-cp Firebird.framework/Resources/English.lproj/var/license.html Firebird.pkg
	cp files/pre_install Firebird.pkg/pre_install
	cp files/post_install Firebird.pkg/post_install
	cp files/pre_delete Firebird.pkg/pre_delete
	cp files/post_delete Firebird.pkg/post_delete

Firebird.pkg: Firebird.framework files/Firebird.info ../isc_config files/addServEnt
	-rm -rf Firebird.pkg temp
	cp -f ../services.isc Firebird.framework/Resources/English.lproj/var
	cp -f files/inetd.conf.isc Firebird.framework/Resources/English.lproj/var
	cp -f ../isc_config Firebird.framework/Resources/English.lproj/var
	cp -f files/addServEnt Firebird.framework/Resources
	sh -c "export DYLD_FRAMEWORK_PATH=.; Firebird.framework/Resources/bin/gpre -Z | sed 's/gpre version //g' > version"
	echo s/__VERSION__/`cat version`/g > info.sed
	sed 's/\.[0-9\.]*//g;s/[A-Z\-]*//g' version > version.major
	echo s/__MAJOR__/`cat version.major`/g >> info.sed
	sed 's/[A-Z]*\-//g;s/[0-9\.]//g' version | sed 's/T/Test/g;s/I/Internal/g;s/B/Beta/g;s/V/Release/g' > version.type
	echo s/__BUILD_TYPE__/`cat version.type`/g >> info.sed
	sed -f info.sed files/Firebird.info > Firebird.info
	mkdir -p temp
	mv Firebird.framework temp
	package temp Firebird.info
	mv temp/Firebird.framework .
	rm -rf temp

.interbase.pkg: Interbase.framework macos/license.html macos/license.txt services.isc inetd.conf.isc isc_config bin/isc4.gbak macos/Interbase.info macos/addServEnt
	-rm -rf install_tmp
	-rm -fr Interbase.pkg
	-cp -f macos/license.* Interbase.framework/Resources
	-cp -f services.isc Interbase.framework/Resources
	-cp -f inetd.conf.isc Interbase.framework/Resources
	-cp -f isc_conf Interbase.framework/Resources
	-cp -f bin/isc4.gbak Interbase.framework/Resources
	chmod 444 Interbase.framework/Resources/isc4.gbak
	mkdir install_tmp
	mv Interbase.framework install_tmp
	package install_tmp macos/Interbase.info
	mv install_tmp/Interbase.framework .
	rm -rf install_tmp
	#cp macos/license.html Interbase.pkg
	touch .interbase.pkg

.interbaseCLUI.pkg: $(CLUI_OBJECTS) macos/InterbaseCLUI.info macos/license.html macos/clui.post_install
	-rm -rf install_tmp
	-rm -rf InterbaseCLUI.pkg
	mkdir -p install_tmp
	cp $(CLUI_OBJECTS) install_tmp
	package install_tmp macos/InterbaseCLUI.info
	-rm -rf install_tmp
	#cp macos/license.html InterbaseCLUI.pkg
	cp macos/clui.post_install InterbaseCLUI.pkg/InterbaseCLUI.post_install
	touch .interbaseCLUI.pkg

.interbaseVAR.pkg: $(VAR_FILES) macos/InterbaseVAR.info macos/license.html macos/var.post_install macos/var.pre_install
	-rm -rf install_tmp
	-rm -rf InterbaseVAR.pkg
	mkdir -p install_tmp
	cp $(VAR_FILES) install_tmp
	package install_tmp macos/InterbaseVAR.info
	-rm -rf install_tmp
	#cp macos/license.html InterbaseVAR.pkg
	cp macos/var.post_install InterbaseVAR.pkg/InterbaseVAR.post_install
	cp macos/var.pre_install InterbaseVAR.pkg/InterbaseVAR.pre_install
	touch .interbaseVAR.pkg

files/addServEnt: files/addServEnt.c
	cc -o files/addServEnt files/addServEnt.c

clean:
	rm -rf .interbase.pkg .interbaseCLUI.pkg .interbaseVAR.pkg .interbase.mpkg Interbase.mpkg Interbase.pkg InterbaseCLUI.pkg InterbaseVAR.pkg .dirs_setup .codes
	tcsh -ec 'cd $(ROOT); $(MAKE) -f ./make_kit clean'
	rm -rf $(ROOT)/interbase/Firebird.framework

installpath: buildinstall force
	echo "Good"

buildinstall: force
	cc -o binpath installpath.c -I$(ROOT) -framework Firebird > /dev/null
	cc -DINCLUDE_PATH -o includepath installpath.c -I$(ROOT) -framework Firebird > /dev/null

force:
