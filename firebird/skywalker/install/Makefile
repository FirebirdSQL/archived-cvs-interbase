.PHONY: all CSrpmscript SSrpmscript csinstall ssinstall



ClassicSrcDir=classic/
SuperSrcDir=super/


all: CSrpmscript SSrpmscript csinstall ssinstall

CSrpmscript: 
	echo $@
	cat $(ClassicSrcDir)CSrpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(ClassicSrcDir)CSprepinstall.sh >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(ClassicSrcDir)CSbuildinstall.sh >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(ClassicSrcDir)CSinstall.sh >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(ClassicSrcDir)CSrpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(ClassicSrcDir)CSpreinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(ClassicSrcDir)CSpostinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(ClassicSrcDir)CSpreuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(ClassicSrcDir)CSpostuninstall.sh >> $@

SSrpmscript: 
	echo $@
	cat $(SuperSrcDir)SSrpmheader.txt > $@
	echo "" >> $@
	echo "%prep" >> $@
#	cat $(SuperSrcDir)SSprepinstall.sh >> $@
	echo "" >> $@
	echo "%build" >> $@
#	cat $(SuperSrcDir)SSbuildinstall.sh >> $@
	echo "" >> $@
	echo "%install" >> $@
#	cat $(SuperSrcDir)SSinstall.sh >> $@
	echo "" >> $@
	echo "%files" >> $@
	cat $(SuperSrcDir)SSrpmfiles.txt >> $@
	echo "" >> $@
	echo "%pre" >> $@
	cat $(SuperSrcDir)SSpreinstall.sh >> $@
	echo "" >> $@
	echo "%post" >> $@
	cat $(SuperSrcDir)SSpostinstall.sh >> $@
	echo "" >> $@
	echo "%preun" >> $@
	cat $(SuperSrcDir)SSpreuninstall.sh >> $@
	echo "" >> $@
	echo "%postun" >> $@
	cat $(SuperSrcDir)SSpostuninstall.sh >> $@


CSTarInstallDir=csinstall

csinstall:
	mkdir -p $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)CSpreinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)CSinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)CSpostinstall.sh $(CSTarInstallDir)/scripts
	cp $(ClassicSrcDir)CSTarInstall.sh $(CSTarInstallDir)/install.sh

SSTarInstallDir=ssinstall

ssinstall:
	mkdir -p $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)SSpreinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)SSinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)SSpostinstall.sh $(SSTarInstallDir)/scripts
	cp $(SuperSrcDir)SSTarInstall.sh $(SSTarInstallDir)/install.sh
