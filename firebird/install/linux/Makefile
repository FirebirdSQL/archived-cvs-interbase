.PHONY: all CSrpmscript SSrpmscript ssinstall runclassicinstall \
        classicpackages


# Some of these targets are run from the root tree of the build.
# those need to know where the install subdirectory is kept.
# Others are run locally these need to know the path back to the
# root of the build tree.

BuildRoot=../../..

InstallRoot=firebird/install/linux
InstallImageRoot=buildroot


# Determine where the packages are built.  Each distribution builds them in
# their own spot.
RedhatPackageDir=/usr/src/redhat/RPMS/i386
MandrakePackageDir=/usr/src/RPM/RPMS/i386
SuSEPackageDir=/usr/src/packages/RPMS/i386

PackageDir:=$(shell if [ -d $(RedhatPackageDir) ]; then echo $(RedhatPackageDir); \
		           elif [ -d $(MandrakePackageDir) ]; then echo $(MandrakePackageDir); \
		           elif [ -d $(SuSEPackageDir) ]; then echo $(SuSEPackageDir); \
				   fi)


# Get the current build number for this build
BuildNum=$(shell cat this_build)
64IO=$(shell cat jrd/64bitio.h)
64IOTAG=$(shell if [ -z "$(64IO)" ]; then echo ""; else echo ".64IO"; fi )
BuildVersion=1.0.0.$(BuildNum)
PackageVersion=0.RC2$(64IOTAG)
Version=$(BuildVersion)-$(PackageVersion)

ClassicTarDir=FirebirdCS-$(Version)
SuperTarDir=FirebirdSS-$(Version)

ClassicTarFile=FirebirdCS-$(Version).tar.gz
SuperTarFile=FirebirdSS-$(Version).tar.gz

ClassicRPMFile=FirebirdCS-$(Version).i386.rpm
SuperRPMFile=FirebirdSS-$(Version).i386.rpm

ClassicSrcDir=$(InstallRoot)/classic
SuperSrcDir=$(InstallRoot)/super

LastClassicInstallFlg=.classicinstallflg
LastSuperInstallFlg=.superinstallflg

test:
	@echo "$(PackageVersion)"

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


classicpackages: buildclassicimage classictarfile classicrpmfile

classictarfile: buildclassicimage $(ClassicTarFile)

classicrpmfile: buildclassicimage $(ClassicRPMFile)


buildclassicimage: 
	sh $(ClassicSrcDir)/makeInstallImage.sh


$(ClassicTarFile) : buildClassicTarDir
	tar -czf $(ClassicTarFile) $(ClassicTarDir)


$(ClassicRPMFile): CSrpmscript
	rpm -bb --buildroot `pwd`/buildroot CSrpmscript
	cp $(PackageDir)/$(ClassicRPMFile) .


superpackages: buildsuperimage supertarfile superrpmfile

supertarfile: buildsuperimage $(SuperTarFile)

superrpmfile: buildsuperimage $(SuperRPMFile)

buildsuperimage: 
	sh $(SuperSrcDir)/makeInstallImage.sh


$(SuperTarFile) : buildSuperTarDir
	tar -czf $(SuperTarFile) $(SuperTarDir)


$(SuperRPMFile): SSrpmscript
	rpm -bb --buildroot `pwd`/buildroot SSrpmscript
	cp $(PackageDir)/$(SuperRPMFile) .


test1:

	cat $(ClassicSrcDir)/rpmheader.txt | sed 's/^Version:.*/Version: $(BuildVersion)/' \
	     | sed 's/Release:.*/Release: $(PackageVersion)/' 
CSrpmscript: 
	echo $@
	cat $(ClassicSrcDir)/rpmheader.txt | sed 's/^Version:.*/Version: $(BuildVersion)/' \
	     | sed 's/Release:.*/Release: $(PackageVersion)/' > $@
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
	cat $(ClassicSrcDir)/rpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(ClassicSrcDir)/preinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(ClassicSrcDir)/postinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(ClassicSrcDir)/preuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(ClassicSrcDir)/postuninstall.sh >> $@

SSrpmscript: 
	echo $@
	cat $(SuperSrcDir)/rpmheader.txt | sed 's/^Version:.*/Version: $(BuildVersion)/' \
	     | sed 's/Release:.*/Release: $(PackageVersion)/' > $@
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
	cat $(SuperSrcDir)/rpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(SuperSrcDir)/preinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(SuperSrcDir)/postinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(SuperSrcDir)/preuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(SuperSrcDir)/postuninstall.sh >> $@


ClassicScriptsDir=$(ClassicTarDir)/scripts

buildClassicTarDir:
	mkdir -p $(ClassicScriptsDir)
	cp $(ClassicSrcDir)/*install*.sh $(ClassicScriptsDir)
	cat $(ClassicSrcDir)/tarMainInstall.sh | sed 's/XXXVERSIONXXX/$(Version)/' > $(ClassicTarDir)/install.sh
	chmod a+x $(ClassicTarDir)/install.sh
	tar -C buildroot -czf $(ClassicTarDir)/buildroot.tar.gz .

SuperScriptsDir=$(SuperTarDir)/scripts

buildSuperTarDir:
	mkdir -p $(SuperScriptsDir)
	cp $(SuperSrcDir)/*install*.sh $(SuperScriptsDir)
	cat $(SuperSrcDir)/tarMainInstall.sh | sed 's/XXXVERSIONXXX/$(Version)/' > $(SuperTarDir)/install.sh
	chmod a+x $(SuperTarDir)/install.sh
	tar -C buildroot -czf $(SuperTarDir)/buildroot.tar.gz .

SSTarInstallDir=ssinstall

ssinstall:
	mkdir -p $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSpreinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSpostinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)/SSTarInstall.sh $(SSTarInstallDir)/install.sh
	tar -czf $(SSTarInstallDir)/interbase.tar.gz interbase
