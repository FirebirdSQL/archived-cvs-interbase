FB_BUILD=	source/interbase
FB_FW=		$(FB_BUILD)/Firebird.framework
CP=		cp
RM=		rm
SH=		/bin/sh

framework:
	mkdir -p $(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/include $(FB_FW)/Versions/A/Headers
	-$(RM) -fr $(FB_FW)/Versions/A/Headers/CVS
	$(CP) -r $(FB_BUILD)/bin $(FB_FW)/Versions/A/Resources/bin
	$(CP) $(FB_BUILD)/interbase.msg \
		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/intl \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/UDF \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/help \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	-$(RM) -fr $(FB_FW)/Versions/A/Resources/bin/CVS
	$(CP) -r $(FB_BUILD)/examples $(FB_FW)/Versions/A/Resources
	$(CP) $(FB_BUILD)/lib/gds.dylib $(FB_FW)/Versions/A/Firebird
	-$(RM) -rf $(FB_FW)/Versions/A/Resources/examples/CVS
	-$(RM) -rf $(FB_FW)/Versions/A/Resources/English.lproj/var/isc4.gdb
	ln -s ../../bin $(FB_FW)/Versions/A/Resources/English.lproj/var/bin; \
	ln -s Versions/Current/Headers $(FB_FW)/Headers
	ln -s Versions/Current/Resources $(FB_FW)/Resources
	ln -s Versions/Current/Firebird $(FB_FW)/Firebird
	ln -s A $(FB_FW)/Versions/Current
	echo "DarwinCS.tar.gz" > $(FB_FW)/Resources/.installer_name
	$(CP) $(FB_BUILD)/isc_config $(FB_BUILD)/inetd.conf.isc \
		$(FB_BUILD)/services.isc $(FB_BUILD)/isc4.gdb \
		source/firebird/bellardo/darwin/license.html \
		source/firebird/bellardo/darwin/license.txt \
		$(FB_FW)/Resources/English.lproj/var
	$(SH) -c 'unset INTERBASE; export DYLD_FRAMEWORK_PATH=$(FB_BUILD); sed "s/__VERSION__/`firebird/bellardo/darwin/fb_version.pl \"$(FB_BUILD)/bin/gpre -Z\"`/g" source/firebird/bellardo/darwin/FrameworkInfo.plist > $(FB_FW)/Resources/Info.plist'

super_framework:
	mkdir -p $(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/include $(FB_FW)/Versions/A/Headers
	-$(RM) -fr $(FB_FW)/Versions/A/Headers/CVS
	$(CP) -r $(FB_BUILD)/bin $(FB_FW)/Versions/A/Resources/bin
	$(CP) $(FB_BUILD)/interbase.msg \
		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/intl \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/UDF \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	$(CP) -r $(FB_BUILD)/help \
 		$(FB_FW)/Versions/A/Resources/English.lproj/var
	-$(RM) -fr $(FB_FW)/Versions/A/Resources/bin/CVS
	$(CP) -r $(FB_BUILD)/examples $(FB_FW)/Versions/A/Resources
	$(CP) $(FB_BUILD)/lib/gds.dylib.1 $(FB_FW)/Versions/A/Firebird
	-$(RM) -rf $(FB_FW)/Versions/A/Resources/examples/CVS
	-$(RM) -rf $(FB_FW)/Versions/A/Resources/English.lproj/var/isc4.gdb
	ln -s ../../bin $(FB_FW)/Versions/A/Resources/English.lproj/var/bin; \
	ln -s Versions/Current/Headers $(FB_FW)/Headers
	ln -s Versions/Current/Resources $(FB_FW)/Resources
	ln -s Versions/Current/Firebird $(FB_FW)/Firebird
	ln -s A $(FB_FW)/Versions/Current
	touch $(FB_FW)/Resources/.SuperServer
	echo "DarwinSS.tar.gz" > $(FB_FW)/Resources/.installer_name
	$(CP) $(FB_BUILD)/isc_config $(FB_BUILD)/inetd.conf.isc \
		$(FB_BUILD)/services.isc $(FB_BUILD)/isc4.gdb \
		source/firebird/bellardo/darwin/license.html \
		source/firebird/bellardo/darwin/license.txt \
		$(FB_FW)/Resources/English.lproj/var
	$(SH) -c 'unset INTERBASE; export DYLD_FRAMEWORK_PATH=$(FB_BUILD); sed "s/__VERSION__/`firebird/bellardo/darwin/fb_version.pl \"$(FB_BUILD)/bin/gpre -Z\"`/g" source/firebird/bellardo/darwin/FrameworkInfo.plist > $(FB_FW)/Resources/Info.plist'


force:
