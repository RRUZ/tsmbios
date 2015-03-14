The  SMBIOS (System Management BIOS) is a standard developed by  <a href='http://www.dmtf.org/standards/smbios'>DMTF</a>. The information stored in the SMBIOS typically includes system manufacturer, model name, serial number, BIOS version, asset tag, processors, ports and device memory installed.


The TSMBIOS project allows access the System Management BIOS (SMBIOS) using the Object Pascal language (Delphi or Free Pascal).
[![](https://dl.dropboxusercontent.com/u/12733424/Images/followrruz.png)](https://twitter.com/RRUZ)

### Downloads ###

[Last revision direct download](https://dl.dropboxusercontent.com/u/12733424/Blog/tsmbios/tsmbios.zip)

[Using subversion client](https://code.google.com/p/tsmbios/source/checkout)

### Features ###
Some features of this project are

> <li>Source Full documented compatible with the help insight feature, available since Delphi 2005.</li>
> <li>Supports SMBIOS Version from 2.1 to 2.8</li>
> <li>Supports Delphi 5, 6, 7, 2005, BDS/Turbo 2006 and RAD Studio 2007, 2009, 2010, XE, XE2, XE3, XE4, XE5, XE6, XE7.</li>
> <li>Compatible with FPC 2.4.0+</li>
> <li>Supports Windows, Linux (only using FPC)</li>
> <li>SMBIOS Data can be obtained using WinAPI (Only Windows), WMI (Only Windows) or loading a saved SMBIOS dump</li>
> <li>SMBIOS Data can be saved and load to a file</li>
> <li>SMBIOS Data can be obtained from remote machines</li>


### SMBIOS Tables supported ###
> <li><a href='http://code.google.com/p/tsmbios/wiki/BIOSInformation'> BIOS Information (Type 0)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/SystemInformation'>System Information (Type 1)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/Baseboard'>Baseboard (or Module) Information (Type 2)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/SystemEnclosure'>System Enclosure or Chassis (Type 3)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/ProcessorInformation'>Processor Information (Type 4)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/MemoryController'>Memory Controller Information (Type 5)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/MemoryModule'>Memory Module Information (Type 6)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/CacheInformation'>Cache Information (Type 7)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/PortConnector'>Port Connector Information (Type 8)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/SystemSlots'>System Slots (Type 9)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/OnBoardDevices'>On Board Devices Information (Type 10)</a></li>
> <li>OEM Strings (Type 11)</li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/SystemConfiguration'>System Configuration Options (Type 12)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/BIOSLanguage'>BIOS Language Information (Type 13)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/GroupAssociations'>Group Associations (Type 14)</a></li>
> <li>System Event Log (Type 15) - Not Implemented</li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/PhysicalMemoryArray'>Physical Memory Array (Type 16)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/MemoryDevice'>Memory Device (Type 17) </a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/MemoryArrayMappedAddress'>Memory Array Mapped Address (Type 19)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/MemoryDeviceMappedAddress'>Memory Device Mapped Address (Type 20)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/BuiltInPointingDevice'>Built-in Pointing Device (Type 21)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/PortableBattery'>Portable Battery (Type 22)</a></li>
> <li>System Reset (Type 23) - Not Implemented</li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/VoltageProbe'>Voltage Probe (Type 26)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/CoolingDevice'>Cooling Device (Type 27)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/TemperatureProbe'>Temperature Probe (Type 28)</a></li>
> <li><a href='http://code.google.com/p/tsmbios/wiki/ElectricalCurrentProbe'>Electrical Current Probe (Type 29)</a></li>
> <li>Out-of-Band Remote Access (Type 30) - Not Implemented</li>
> <li>64-Bit Memory Error Information (Type 33) - Not Implemented</li>
> <li>Management Device (Type 34) - Not Implemented</li>
> <li>Management Device Component (Type 35) - Not Implemented</li>
> <li>Management Device Threshold Data (Type 36) - Not Implemented</li>
> <li>Memory Channel (Type 37) - Not Implemented</li>
> <li>System Power Supply (Type 39) - Not Implemented</li>
> <li>Additional Information (Type 40) - Not Implemented</li>
> <li>Onboard Devices Extended Information (Type 41) - Not Implemented</li>
> <li>Management Controller Host Interface (Type 42) - Not Implemented</li>

### Sample source code ###
This code shows how you can retrieve the information related to the memory device installed on the system.

```
{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetMemoryDeviceInfo;
Var
  SMBios : TSMBios;
  LMemoryDevice  : TMemoryDeviceInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Memory Device Information');
      WriteLn('-------------------------');

      if SMBios.HasPhysicalMemoryArrayInfo then
      for LMemoryDevice in SMBios.MemoryDeviceInformation do
      begin
        WriteLn(Format('Total Width    %d bits',[LMemoryDevice.RAWMemoryDeviceInfo.TotalWidth]));
        WriteLn(Format('Data Width     %d bits',[LMemoryDevice.RAWMemoryDeviceInfo.DataWidth]));
        WriteLn(Format('Size           %d Mbytes',[LMemoryDevice.GetSize]));
        WriteLn(Format('Form Factor    %s',[LMemoryDevice.GetFormFactor]));
        WriteLn(Format('Device Locator %s',[LMemoryDevice.GetDeviceLocatorStr]));
        WriteLn(Format('Bank Locator   %s',[LMemoryDevice.GetBankLocatorStr]));
        WriteLn(Format('Memory Type    %s',[LMemoryDevice.GetMemoryTypeStr]));
        WriteLn(Format('Speed          %d MHz',[LMemoryDevice.RAWMemoryDeviceInfo.Speed]));
        WriteLn(Format('Manufacturer   %s',[LMemoryDevice.ManufacturerStr]));
        WriteLn(Format('Serial Number  %s',[LMemoryDevice.SerialNumberStr]));
        WriteLn(Format('Asset Tag      %s',[LMemoryDevice.AssetTagStr]));
        WriteLn(Format('Part Number    %s',[LMemoryDevice.PartNumberStr]));

        WriteLn;

        if LMemoryDevice.RAWMemoryDeviceInfo.PhysicalMemoryArrayHandle>0 then
        begin
          WriteLn('  Physical Memory Array');
          WriteLn('  ---------------------');
          WriteLn('  Location         '+LMemoryDevice.PhysicalMemoryArray.GetLocationStr);
          WriteLn('  Use              '+LMemoryDevice.PhysicalMemoryArray.GetUseStr);
          WriteLn('  Error Correction '+LMemoryDevice.PhysicalMemoryArray.GetErrorCorrectionStr);
          if LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.MaximumCapacity<>$80000000 then
            WriteLn(Format('  Maximum Capacity %d Kb',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.MaximumCapacity]))
          else
            WriteLn(Format('  Maximum Capacity %d bytes',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.ExtendedMaximumCapacity]));

          WriteLn(Format('  Memory devices   %d',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.NumberofMemoryDevices]));
        end;
        WriteLn;
      end
      else
      Writeln('No Memory Device Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetMemoryDeviceInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
```

### Help Insight ###
![https://dl.dropbox.com/u/12733424/Blog/tsmbios/HelpIns.png](https://dl.dropbox.com/u/12733424/Blog/tsmbios/HelpIns.png)