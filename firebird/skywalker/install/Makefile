.PHONY: all CSrpmscript SSrpmscript ssinstall runclassicinstall \
        classicpackages


# Some of these targets are run from the root tree of the build.
# those need to know where the install subdirectory is kept.
# Others are run locally these need to know the path back to the
# root of the build tree.

BuildRoot=../../..

InstallRoot=firebird/skywalker/install
RedhatPackageDir=/usr/src/redhat/RPMS/i386
RedhatPackageDir=/usr/src/RPM/RPMS/i386

Version=1.0.0-0a.Beta2


ClassicTarFile=FirebirdCS-$(Version).tar.gz
SuperTarFile=FirebirdSS-$(Version).tar.gz

ClassicRPMFile=FirebirdCS-$(Version).i386.rpm
SuperRPMFile=FirebirdSS-$(Version).i386.rpm

ClassicSrcDir=$(InstallRoot)/classic
SuperSrcDir=$(InstallRoot)/super

LastClassicInstallFlg=.classicinstallflg
LastSuperInstallFlg=.superinstallflg

install: 
	@echo "you need to make a choice here "
	@echo "make target"
	@echo ""
	@echo "Firebird classic targets:"
	@echo "runclassicinstall - install classic from build tree"
	@echo "classicpackages   - build tar and rpm install files"
	@echo "classictarfile    - build tar install file"
	@echo "classicrpmfile    - build redhat rpm install file"
	@echo ""
	@echo "Firebird super targets:"
	@echo "runsuperinstall   - install super from build tree"
	@echo "superpackages     - build tar and rpm install files"
	@echo "supertarfile      - build tar install file"
	@echo "superrpmfile      - build redhat rpm install file"
	@echo ""

all2: CSrpmscript SSrpmscript csinstall ssinstall


classicpackages: classictarfile classicrpmfile

runclassicinstall: $(LastClassicInstallFlg)


classictarfile: runclassicinstall $(ClassicTarFile)

classicrpmfile: runclassicinstall $(ClassicRPMFile)


$(LastClassicInstallFlg) : interbase/bin/gsec
	sh $(InstallRoot)/classic/CSTarInstall.sh
	touch $(LastClassicInstallFlg)

$(ClassicTarFile) : csinstall runclassicinstall
	mv csinstall install
	tar -czf $(ClassicTarFile) install
	mv install csinstall


$(ClassicRPMFile): CSrpmscript
	rpm -bb CSrpmscript
	cp $(RedhatPackageDir)/$(ClassicRPMFile) .


superpackages: supertarfile superrpmfile

runsuperinstall: $(LastSuperInstallFlg)


supertarfile: runsuperinstall $(SuperTarFile)

superrpmfile: runsuperinstall $(SuperRPMFile)


$(LastSuperInstallFlg) : interbase/bin/gsec
	sh $(InstallRoot)/super/SSTarInstall.sh
	touch $(LastSuperInstallFlg)

$(SuperTarFile) : ssinstall runsuperinstall
	mv ssinstall install
	tar -czf $(SuperTarFile) install
	mv install ssinstall


$(SuperRPMFile): SSrpmscript
	rpm -bb SSrpmscript
	cp $(RedhatPackageDir)/$(SuperRPMFile) .


CSrpmscript: 
	echo $@
	cat $(ClassicSrcDir)/CSrpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(ClassicSrcDir)/CSprepinstall.sh >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(ClassicSrcDir)/CSbuildinstall.sh >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(ClassicSrcDir)/CSinstall.sh >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(ClassicSrcDir)/CSrpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(ClassicSrcDir)/CSpreinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(ClassicSrcDir)/CSpostinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(ClassicSrcDir)/CSpreuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(ClassicSrcDir)/CSpostuninstall.sh >> $@

SSrpmscript: 
	echo $@
	cat $(SuperSrcDir)/SSrpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(SuperSrcDir)/SSprepinstall.sh >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(SuperSrcDir)/SSbuildinstall.sh >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(SuperSrcDir)/SSinstall.sh >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(SuperSrcDir)/SSrpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(SuperSrcDir)/SSpreinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(SuperSrcDir)/SSpostinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(SuperSrcDir)/SSpreuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(SuperSrcDir)/SSpostuninstall.sh >> $@


CSTarInstallDir=csinstall

csinstall:
	mkdir -p $(CSTarInstallDir)/scripts
#	(cd $(BuildRoot); tar -czf - interbase ) | cat > $(CSTarInstallDir)/interbase.tar.gz
	cp $(ClassicSrcDir)/CSpreinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)/CSinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)/CSpostinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)/CSTarInstall.sh $(CSTarInstallDir)/install.sh
	tar -czf $(CSTarInstallDir)/interbase.tar.gz interbase

SSTarInstallDir=ssinstall

ssinstall:
	mkdir -p $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSpreinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSpostinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSTarInstall.sh $(SSTarInstallDir)/install.sh
	tar -czf $(SSTarInstallDir)/interbase.tar.gz interbase
