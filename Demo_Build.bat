@SET ORGPATH=%PATH%

IF %1% LEQ 13 GOTO RADSTUDIO
GOTO STUDIO

:RADSTUDIO
IF EXIST "c:\Program Files (x86)\Embarcadero\RAD Studio\%1.0\bin\rsvars.bat" GOTO INITRADSTUDIO 
ECHO ...\Embarcadero\RAD Studio\%1.0\bin\rsvars.bat was not found.
GOTO DONE
  
:STUDIO  
IF EXIST "c:\Program Files (x86)\Embarcadero\Studio\%1.0\bin\rsvars.bat" GOTO INITSTUDIO 
ECHO ...\Embarcadero\Studio\%1.0\bin\rsvars.bat was not found.
GOTO DONE

:INITRADSTUDIO
call "%c:\Program Files (x86)\Embarcadero\RAD Studio\%1.0\bin\rsvars.bat" 	
GOTO INIT

:INITSTUDIO
call "c:\Program Files (x86)\Embarcadero\Studio\%1.0\bin\rsvars.bat" 	
GOTO INIT


:INIT
msbuild.exe "Samples\List SMBIOS Tables\SMBiosTables.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 1
pause
EXIT

:1
msbuild.exe "Samples\Table 0 Bios Info\BIOSInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 2
pause
EXIT

:2
msbuild.exe "Samples\Table 1 System Info\SystemInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 3
pause
EXIT

:3
msbuild.exe "Samples\Table 2 Base Board Information\BaseBoardInformation.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 4
pause
EXIT

:4
msbuild.exe "Samples\Table 3 Enclosure Information\EnclosureInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 5
pause
EXIT

:5
msbuild.exe "Samples\Table 4 Processor Information\ProcessorInformation.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 6
pause
EXIT

:6
msbuild.exe "Samples\Table 5 Memory Controller Information\MemoryControllerInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 7
pause
EXIT

:7
msbuild.exe "Samples\Table 6 Memory Module Information\MemoryModuleInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 8
pause
EXIT

:8
msbuild.exe "Samples\Table 8 Port Connector Information\PortConnectorInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 9
pause
EXIT

:9
msbuild.exe "Samples\Table 9 System Slots Information\SystemSlotsInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 10
pause
EXIT

:10
msbuild.exe "Samples\Table 10 Onboard System Information\OnboardSystemInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 11
pause
EXIT

:11
msbuild.exe "Samples\Table 12 System Configuration Options\SystemConfInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 12
pause
EXIT

:12
msbuild.exe "Samples\Table 13 BIOS Language Information\BIOSLanguageInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 13
pause
EXIT

:13
msbuild.exe "Samples\Table 14 Group Associations\GroupAssociations.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 14
pause
EXIT


:14
msbuild.exe "Samples\Table 16 Physical Memory Array\PhysicalMemArrayInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 15
pause
EXIT

:15
msbuild.exe "Samples\Table 17 Memory Device\MemoryDeviceInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 16
pause
EXIT

:16
msbuild.exe "Samples\Table 19 Memory Array Mapped Address\MemArrayMappedInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 17
pause
EXIT

:17
msbuild.exe "Samples\Table 20 Memory Device Mapped Address\MemDeviceMappedInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 18
pause
EXIT

:18
msbuild.exe "Samples\Table 21 Built-in Pointing Device Information\PointingDevice.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 19
pause
EXIT

:19
msbuild.exe "Samples\Table 22 Battery Information\BatteryInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 20
pause
EXIT

:20
msbuild.exe "Samples\Table 26 Voltage Probe Information\VoltageProbeInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 21
pause
EXIT

:21
msbuild.exe "Samples\Table 27 Cooling Device Information\CoolingDeviceInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 22
pause
EXIT


:22
msbuild.exe "Samples\Table 28 Temperature Probe Information\TemperatureProbeInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO 23
pause
EXIT


:23
msbuild.exe "Samples\Table 29 Electrical Current Probe Information\ElectricalProbeInfo.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=debug
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO DONE
pause
EXIT


:DONE
@SET PATH=%ORGPATH%

REM pause