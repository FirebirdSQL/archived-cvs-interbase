.PHONY: all CSrpmscript SSrpmscript ssinstall runclassicinstall \
        classicpackages

# Some of these targets are run from the root tree of the build.
# those need to know where the install subdirectory is kept.
# Others are run locally these need to know the path back to the
# root of the build tree.

BuildRoot=../../..

InstallRoot=firebird/pcisar/install
InstallImageRoot=buildroot
#RedhatPackageDir=/usr/src/redhat/RPMS/i386
RedhatPackageDir=/usr/src/packages/RPMS/i386

Version=1.0.0-RC1


ClassicTarFile=FirebirdCS-$(Version).tar.gz
SuperTarFile=FirebirdSS-$(Version).tar.gz

ClassicRPMFile=FirebirdCS-$(Version).i386.rpm
SuperRPMFile=FirebirdSS-$(Version).i386.rpm

ClassicSrcDir=$(InstallRoot)/classic
SuperSrcDir=$(InstallRoot)/super

install: 
	@echo "you need to make a choice here "
	@echo "make target"
	@echo ""
	@echo "Firebird classic targets:"
#	@echo "runclassicinstall - install classic from build tree"
	@echo "classicpackages   - build tar and rpm install files"
	@echo "classictarfile    - build tar install file"
	@echo "classicrpmfile    - build redhat rpm install file"
	@echo ""
	@echo "Firebird super targets:"
#	@echo "runsuperinstall   - install super from build tree"
	@echo "superpackages     - build tar and rpm install files"
	@echo "supertarfile      - build tar install file"
	@echo "superrpmfile      - build redhat rpm install file"
	@echo ""

classicpackages: classictarfile classicrpmfile

classictarfile: csinstall
	tar -C$(InstallImageRoot) -czf $(ClassicTarFile) .

classicrpmfile: CSrpmscript
	sh $(ClassicSrcDir)/makerpmimage.sh
	sh $(ClassicSrcDir)/buildrpm.sh
	cp $(RedhatPackageDir)/$(ClassicRPMFile) .

superpackages: supertarfile superrpmfile

supertarfile: ssinstall
	tar -C$(InstallImageRoot) -czf $(SuperTarFile) .

superrpmfile: SSrpmscript
	sh $(SuperSrcDir)/makerpmimage.sh
	sh $(SuperSrcDir)/buildrpm.sh
	cp $(RedhatPackageDir)/$(SuperRPMFile) .

CSrpmscript: 
	echo $@
	cat $(ClassicSrcDir)/rpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(ClassicSrcDir)/prepinstall.txt >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(ClassicSrcDir)/buildinstall.txt >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(ClassicSrcDir)/install.txt >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(ClassicSrcDir)/rpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(ClassicSrcDir)/preinstall.txt >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(ClassicSrcDir)/postinstall.txt >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(ClassicSrcDir)/preuninstall.txt >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(ClassicSrcDir)/postuninstall.txt >> $@

SSrpmscript: 
	echo $@
	cat $(SuperSrcDir)/rpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(SuperSrcDir)/prepinstall.txt >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(SuperSrcDir)/buildinstall.txt >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(SuperSrcDir)/install.txt >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(SuperSrcDir)/rpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(SuperSrcDir)/preinstall.txt >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(SuperSrcDir)/postinstall.txt >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(SuperSrcDir)/preuninstall.txt >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(SuperSrcDir)/postuninstall.txt >> $@

csinstall:
	sh $(ClassicSrcDir)/maketarimage.sh
	tar -C$(InstallImageRoot) -czf $(InstallImageRoot)/firebird.tar.gz interbase
	rm -r $(InstallImageRoot)/interbase

ssinstall:
	sh $(SuperSrcDir)/maketarimage.sh
	tar -C$(InstallImageRoot) -czf $(InstallImageRoot)/firebird.tar.gz interbase
	rm -r $(InstallImageRoot)/interbase

