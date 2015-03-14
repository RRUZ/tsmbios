The SMBIOS (System Management BIOS) is a standard developed by DMTF. The information stored in the SMBIOS typically includes system manufacturer, model name, serial number, BIOS version, asset tag, processors, ports and device memory installed.

The TSMBIOS project allows access the System Management BIOS (SMBIOS) using the Object Pascal language (Delphi or Free Pascal). 

## Features
Some features of this project are

* Source Full documented compatible with the help insight feature, available since Delphi 2005.
* Supports SMBIOS Version from 2.1 to 2.8
* Supports Delphi 5, 6, 7, 2005, BDS/Turbo 2006 and RAD Studio 2007, 2009, 2010, XE, XE2, XE3, XE4, XE5, XE6, XE7.
* Compatible with FPC 2.4.0+
* Supports Windows, Linux (only using FPC)
* SMBIOS Data can be obtained using WinAPI (Only Windows), WMI (Only Windows) or loading a saved SMBIOS dump
* SMBIOS Data can be saved and load to a file
* SMBIOS Data can be obtained from remote machines
 

## SMBIOS Tables supported

* BIOS Information (Type 0)
* System Information (Type 1)
* Baseboard (or Module) Information (Type 2)
* System Enclosure or Chassis (Type 3)
* Processor Information (Type 4)
* Memory Controller Information (Type 5)
* Memory Module Information (Type 6)
* Cache Information (Type 7)
* Port Connector Information (Type 8)
* System Slots (Type 9)
* On Board Devices Information (Type 10)
* OEM Strings (Type 11)
* System Configuration Options (Type 12)
* BIOS Language Information (Type 13)
* Group Associations (Type 14)
* System Event Log (Type 15) - Not Implemented
* Physical Memory Array (Type 16)
* Memory Device (Type 17)
* Memory Array Mapped Address (Type 19)
* Memory Device Mapped Address (Type 20)
* Built-in Pointing Device (Type 21)
* Portable Battery (Type 22)
* System Reset (Type 23) - Not Implemented
* Voltage Probe (Type 26)
* Cooling Device (Type 27)
* Temperature Probe (Type 28)
* Electrical Current Probe (Type 29)
* Out-of-Band Remote Access (Type 30) - Not Implemented
* 64-Bit Memory Error Information (Type 33) - Not Implemented
* Management Device (Type 34) - Not Implemented
* Management Device Component (Type 35) - Not Implemented
* Management Device Threshold Data (Type 36) - Not Implemented
* Memory Channel (Type 37) - Not Implemented
* System Power Supply (Type 39) - Not Implemented
* Additional Information (Type 40) - Not Implemented
* Onboard Devices Extended Information (Type 41) - Not Implemented
* Management Controller Host Interface (Type 42) - Not Implemented

## Sample source code
This code shows how you can retrieve the information related to the memory device installed on the system.

```delphi
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

## Help Insight
![Help Insight](https://dl.dropboxusercontent.com/u/12733424/Blog/tsmbios/HelpIns.png)
