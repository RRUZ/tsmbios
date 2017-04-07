 The [SMBIOS](http://www.dmtf.org/standards/smbios) (System Management BIOS) is a standard developed by the  [DMTF](http://www.dmtf.org/). The information stored in the SMBIOS includes devices manufacturer, model name, serial number, BIOS version, asset tag, processors, ports and device memory installed.

![logo](https://github.com/RRUZ/tsmbios/blob/master/images/logo.png)The TSMBIOS libary allows access the System Management BIOS (SMBIOS) using the Object Pascal language (Delphi or Free Pascal). 

## Features
Some features of this project are

* Source Full documented compatible with the help insight feature, available since Delphi 2005.
* Supports SMBIOS Version from 2.1 to 2.8
* Supports Delphi 5, 6, 7. 
* Supports RAD Studio 2005-2010 
* Supports RAD Studio XE-XE8 
* Supports RAD Studio 10 Seattle, RAD Studio 10.1 Berlin, RAD Studio 10.2 Tokyo
* Compatible with FPC 2.4.0+
* Supports Windows, Linux.
* SMBIOS Data can be saved and/or load to a file.
* SMBIOS Data can be obtained from remote machines (via WMI).
 

## SMBIOS Tables supported

* [BIOS Information](https://github.com/RRUZ/tsmbios/blob/wiki/BIOSInformation.md) (Type 0)
* [System Information](https://github.com/RRUZ/tsmbios/blob/wiki/BIOSLanguage.md) (Type 1)
* [Baseboard (or Module) Information](https://github.com/RRUZ/tsmbios/blob/wiki/Baseboard.md) (Type 2)
* [System Enclosure or Chassis](https://github.com/RRUZ/tsmbios/blob/wiki/SystemEnclosure.md) (Type 3)
* [Processor Information](https://github.com/RRUZ/tsmbios/blob/wiki/ProcessorInformation.md) (Type 4)
* [Memory Controller Information](https://github.com/RRUZ/tsmbios/blob/wiki/MemoryController.md) (Type 5)
* [Memory Module Information](https://github.com/RRUZ/tsmbios/blob/wiki/MemoryModule.md) (Type 6)
* [Cache Information](https://github.com/RRUZ/tsmbios/blob/wiki/CacheInformation.md) (Type 7)
* [Port Connector Information](https://github.com/RRUZ/tsmbios/blob/wiki/PortConnector.md) (Type 8)
* [System Slots](https://github.com/RRUZ/tsmbios/blob/wiki/SystemSlots.md) (Type 9)
* [On Board Devices Information](https://github.com/RRUZ/tsmbios/blob/wiki/OnBoardDevices.md) (Type 10)
* OEM Strings (Type 11)
* [System Configuration Options](https://github.com/RRUZ/tsmbios/blob/wiki/SystemConfiguration.md) (Type 12)
* [BIOS Language Information](https://github.com/RRUZ/tsmbios/blob/wiki/BIOSLanguage.md) (Type 13)
* [Group Associations](https://github.com/RRUZ/tsmbios/blob/wiki/GroupAssociations.md) (Type 14)
* System Event Log (Type 15) - Not Implemented
* [Physical Memory Array](https://github.com/RRUZ/tsmbios/blob/wiki/PhysicalMemoryArray.md) (Type 16)
* [Memory Device](https://github.com/RRUZ/tsmbios/blob/wiki/MemoryDevice.md) (Type 17)
* [Memory Array Mapped Address](https://github.com/RRUZ/tsmbios/blob/wiki/MemoryArrayMappedAddress.md) (Type 19)
* [Memory Device Mapped Address](https://github.com/RRUZ/tsmbios/blob/wiki/MemoryDeviceMappedAddress.md) (Type 20)
* [Built-in Pointing Device](https://github.com/RRUZ/tsmbios/blob/wiki/BuiltInPointingDevice.md) (Type 21)
* [Portable Battery](https://github.com/RRUZ/tsmbios/blob/wiki/PortableBattery.md) (Type 22)
* System Reset (Type 23) - Not Implemented
* [Voltage Probe](https://github.com/RRUZ/tsmbios/blob/wiki/VoltageProbe.md) (Type 26)
* [Cooling Device](https://github.com/RRUZ/tsmbios/blob/wiki/CoolingDevice.md) (Type 27)
* [Temperature Probe](https://github.com/RRUZ/tsmbios/blob/wiki/TemperatureProbe.md) (Type 28)
* [Electrical Current Probe](https://github.com/RRUZ/tsmbios/blob/wiki/ElectricalCurrentProbe.md) (Type 29)
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
![Help Insight](https://github.com/RRUZ/tsmbios/blob/master/images/preview.png)
