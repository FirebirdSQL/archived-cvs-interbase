
::After a debug build, this will take all the .sbr files and
:: create a browse database.

@echo off
dir /s /b *.sbr > bscmake.input
bscmake /n /o ib_debug\bin\ibserver.bsc @bscmake.input
del /q bscmake.input
@echo Completed building MSVC browse database


