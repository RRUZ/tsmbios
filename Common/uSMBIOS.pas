{**************************************************************************************************}
{                                                                                                  }
{ Unit uSMBIOS                                                                                     }
{ unit for the TSMBIOS                                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uSMBIOS.pas.                                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2012-2013 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
unit uSMBIOS;

interface

uses
  SysUtils,
  Windows,
  Generics.Collections,
  Classes;

type
  // TODO :
  // Add OSX support http://www.opensource.apple.com/source/AppleSMBIOS/AppleSMBIOS-38/SMBIOS.h
  // Add WINAPI Read support  EnumSystemFirmwareTables() and GetSystemFirmwareTable()
  // Add remote support
  // Add FPC support
  // Add old Delphi versions support


  // Reference
  // http://www.dmtf.org/standards/smbios
  TSMBiosTablesTypes = (
    BIOSInformation = 0,
    SystemInformation = 1,
    BaseBoardInformation = 2,
    EnclosureInformation = 3,
    ProcessorInformation = 4,
    MemoryControllerInformation = 5,
    MemoryModuleInformation = 6,
    CacheInformation = 7,
    PortConnectorInformation = 8,
    SystemSlotsInformation = 9,
    OnBoardDevicesInformation = 10,
    OEMStrings = 11,
    SystemConfigurationOptions = 12,
    BIOSLanguageInformation = 13,
    GroupAssociations = 14,
    SystemEventLog = 15,
    PhysicalMemoryArray = 16,
    MemoryDevice = 17,
    MemoryErrorInformation = 18,
    MemoryArrayMappedAddress = 19,
    MemoryDeviceMappedAddress = 20,
    BuiltinPointingDevice = 21,
    PortableBattery= 22,
    SystemReset= 23,
    HardwareSecurity=24,
    SystemPowerControls=25,
    VoltageProbe=26,
    CoolingDevice=27,
    TemperatureProbe=28,
    ElectricalCurrentProbe=29,
    OutofBandRemoteAccess=30,
    BootIntegrityServicesEntryPoint=31,
    SystemBootInformation=32,
    x64BitMemoryErrorInformation=33,
    ManagementDevice=34,
    ManagementDeviceComponent=35,
    ManagementDeviceThresholdData=36,
    MemoryChannel=37,
    IPMIDeviceInformation=38,
    SystemPowerSupply=39,
    AdditionalInformation=40,
    OnboardDevicesExtendedInformation=41,
    ManagementControllerHostInterface=42,
    Inactive=126,
    EndofTable = 127);

const
   SMBiosTablesDescr : array [Byte] of AnsiString =(
   'BIOS Information',
   'System Information',
   'BaseBoard Information',
   'Enclosure Information',
   'Processor Information',
   'Memory Controller Information',
   'Memory Module Information',
   'Cache Information',
   'Port Connector Information',
   'System Slots Information',
   'OnBoard Devices Information',
   'OEM Strings',
   'System Configuration Options',
   'BIOS Language Information',
   'Group Associations',
   'System Event Log',
   'Physical Memory Array',
   'Memory Device',
   'Memory Error Information',
   'Memory Array Mapped Address',
   'Memory Device Mapped Address',
   'Builtin Pointing Device',
   'Portable Battery',
   'System Reset',
   'Hardware Security',
   'System Power Controls',
   'Voltage Probe',
   'Cooling Device',
   'Temperature Probe',
   'Electrical Current Probe',
   'Out-of-Band Remote Access',
   'Boot Integrity Services (BIS) Entry Point',
   'System Boot Information',
   '64-Bit Memory Error Information',
   'Management Device',
   'Management Device Component',
   'Management Device Threshold Data',
   'Memory Channel',
   'IPMI Device Information',
   'System Power Supply',
   'Additional Information',
   'Onboard Devices Extended Information',
   'Management Controller Host Interface',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Inactive',
   'End of Table', //127
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported',
   'Not Supported'
   );

type
  TSmBiosTableHeader = packed record
    TableType: Byte;
    Length: Byte;
    Handle: Word;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  BIOS Information structure
  ///	</summary>
  {$ENDREGION}
  TBiosInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of the BIOS Vendor’s Name.
    ///	</summary>
    {$ENDREGION}
    Vendor: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of the BIOS Version. This is a freeform string that may
    ///	  contain Core and OEM version information.
    ///	</summary>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Segment location of BIOS starting address (for example, 0E800h).
    ///	  NOTE: The size of the runtime BIOS image can be computed by
    ///	  subtracting the Starting Address Segment from 10000h and multiplying
    ///	  the result by 16.
    ///	</summary>
    {$ENDREGION}
    StartingSegment: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of the BIOS release date. The date string, if supplied,
    ///	  is in either mm/dd/yy or mm/dd/yyyy format. If the year portion of
    ///	  the string is two digits, the year is assumed to be 19yy. NOTE: The
    ///	  mm/dd/yyyy format is required for SMBIOS version 2.3 and later.
    ///	</summary>
    {$ENDREGION}
    ReleaseDate: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Size (n) where 64K * (n+1) is the size of the physical device
    ///	  containing the BIOS, in bytes
    ///	</summary>
    {$ENDREGION}
    BiosRomSize: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Defines which functions the BIOS supports: PCI, PCMCIA, Flash, etc.
    ///	</summary>
    {$ENDREGION}
    Characteristics: Int64;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Optional space reserved for future supported functions. The number of
    ///	  Extension Bytes that are present is indicated by the Length in offset
    ///	  1 minus 12h.For version 2.4 and later implementations, two BIOS
    ///	  Characteristics Extension Bytes are defined (12-13h) and bytes 14-
    ///	  17h are also defined
    ///	</summary>
    {$ENDREGION}
    ExtensionBytes : array [0..1] of Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the major release of the System BIOS; for example, the
    ///	  value is 0Ah for revision 10.22 and 02h for revision 2.1. This field
    ///	  and/or the System BIOS Minor Release field is updated each time a
    ///	  System BIOS update for a given system is released. If the system does
    ///	  not support the use of this field, the value is 0FFh for both this
    ///	  field and the System BIOS Minor Release field.
    ///	</summary>
    {$ENDREGION}
    SystemBIOSMajorRelease : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the minor release of the System BIOS; for example, the
    ///	  value is 16h for revision 10.22 and 01h for revision 2.1.
    ///	</summary>
    {$ENDREGION}
    SystemBIOSMinorRelease : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the major release of the embedded controller firmware; for
    ///	  example, the value would be 0Ah for revision 10.22 and 02h for
    ///	  revision 2.1. This field and/or the Embedded Controller Firmware
    ///	  Minor Release field is updated each time an embedded controller
    ///	  firmware update for a given system is released. If the system does
    ///	  not have field upgradeable embedded controller firmware, the value is
    ///	  0FFh.
    ///	</summary>
    {$ENDREGION}
    EmbeddedControllerFirmwareMajorRelease : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the minor release of the embedded controller firmware; for
    ///	  example, the value is 16h for revision 10.22 and 01h for revision
    ///	  2.1. If the system does not have field upgradeable embedded
    ///	  controller firmware, the value is 0FFh.
    ///	</summary>
    {$ENDREGION}
    EmbeddedControllerFirmwareMinorRelease : Byte;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
    FBuffer: PByteArray;
    function  VendorStr: string;
    function  VersionStr: string;
    function  ReleaseDateStr: string;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  The information in this structure defines attributes of the overall
  ///	  system and is intended to be associated with the Component ID group of
  ///	  the system’s MIF. An SMBIOS implementation is associated with a single
  ///	  system instance and contains one and only one System Information (Type
  ///	  1) structure.
  ///	</summary>
  {$ENDREGION}
  TSysInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    ProductName: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Universal Unique ID number,
    ///	</summary>
    {$ENDREGION}
    UUID: array [0 .. 15] of Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the event that caused the system to power up.
    ///	</summary>
    {$ENDREGION}
    WakeUpType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string This text string is used to identify
    ///	  a particular computer configuration for sale. It is sometimes also
    ///	  called a product ID or purchase order number. This number is
    ///	  frequently found in existing fields, but there is no standard format.
    ///	  Typically for a given system board from a given OEM, there are tens
    ///	  of unique processor, memory, hard drive, and optical drive
    ///	  configurations.
    ///	</summary>
    {$ENDREGION}
    SKUNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string This text string is used to identify
    ///	  the family a particular computer belongs to. A family refers to a set
    ///	  of computers that are similar but not identical from a hardware or
    ///	  software point of view. Typically, a family is composed of different
    ///	  computer models, which have different configurations and pricing
    ///	  points. Computers in the same family often have similar branding and
    ///	  cosmetic features
    ///	</summary>
    {$ENDREGION}
    Family : Byte;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  the information in this structure defines attributes of a system
  ///	  baseboard (for  example, a motherboard, planar, server blade, or other
  ///	  standard system module). 850 NOTE: If more than one Type 2 structure is
  ///	  provided by an SMBIOS implementation, each structure shall include the 
  ///	  Number of Contained Object Handles and Contained Object Handles fields
  ///	  to specify which system elements are  contained on which boards. If a
  ///	  single Type 2 structure is provided and the contained object
  ///	  information is not  present1, or if no Type 2 structure is provided,
  ///	  then all system elements identified by the SMBIOS implementation are 
  ///	  associated with a single motherboard.
  ///	</summary>
  {$ENDREGION}
  TBaseBoardInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Product: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of a null-terminated string
    ///	</summary>
    {$ENDREGION}
    AssetTag  : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  A collection of flags that identify features of this baseboard.
    ///	</summary>
    {$ENDREGION}
    FeatureFlags : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Number of a null-terminated string that describes this board's
    ///	    location within the chassis referenced by the Chassis Handle
    ///	  </para>
    ///	  <para>
    ///
    ///	    <b>NOTE: This field supports a CIM_Container class mapping where:</b>
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      LocationWithinContainer is this field.
    ///	    </item>
    ///	    <item>
    ///	      GroupComponent is the chassis referenced by Chassis Handle.
    ///	    </item>
    ///	    <item>
    ///	      PartComponent is this baseboard.
    ///	    </item>
    ///	  </list>
    ///	</summary>
    {$ENDREGION}
    LocationinChassis : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The handle, or instance number, associated with the chassis in which
    ///	  this board resides
    ///	</summary>
    {$ENDREGION}
    ChassisHandle : Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the type of board
    ///	</summary>
    {$ENDREGION}
    BoardType :  Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the number (0 to 255) of Contained Object Handles that
    ///	  follow
    ///	</summary>
    {$ENDREGION}
    NumberofContainedObjectHandles : Byte;
    //ContainedObjectHandles :  Array of Word;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
    function BoardTypeStr : AnsiString;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  The information in this structure defines attributes of the system’s
  ///	  mechanical enclosure(s). For example, if a system included a separate
  ///	  enclosure for its peripheral devices, two structures would be returned:
  ///	  one for the main system enclosure and the second for the peripheral
  ///	  device enclosure. The additions to this structure in version 2.1 of
  ///	  this specification support the population of the CIM_Chassis class.
  ///	</summary>
  {$ENDREGION}
  TEnclosureInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Bit 7 Chassis lock is present if 1. Otherwise, either a lock is not
    ///	  present or it is unknown if the enclosure has a lock. Bits 6:0
    ///	  Enumeration value.
    ///	</summary>
    {$ENDREGION}
    &Type: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    {$ENDREGION}
    AssetTagNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the state of the enclosure when it was last booted.
    ///	</summary>
    {$ENDREGION}
    BootUpState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the state of the enclosure’s power supply (or supplies)
    ///	  when last booted.
    ///	</summary>
    {$ENDREGION}
    PowerSupplyState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the enclosure’s thermal state when last booted.
    ///	</summary>
    {$ENDREGION}
    ThermalState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the enclosure’s physical security status when last booted.
    ///	</summary>
    {$ENDREGION}
    SecurityStatus: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Contains OEM- or BIOS vendor-specific information.
    ///	</summary>
    {$ENDREGION}
    OEM_Defined: DWORD;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The height of the enclosure, in 'U's. A U is a standard unit of
    ///	  measure for the height of a rack or rack-mountable component and is
    ///	  equal to 1.75 inches or 4.445 cm. A value of 00h indicates that the
    ///	  enclosure height is unspecified.
    ///	</summary>
    {$ENDREGION}
    Height : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the number of power cords associated with the enclosure or
    ///	  chassis. A value of 00h indicates that the number is unspecified.
    ///	</summary>
    {$ENDREGION}
    NumberofPowerCords : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the number of Contained Element records that follow, in
    ///	  the range 0 to 255. Each Contained Element group comprises m bytes,
    ///	  as specified by the Contained Element Record Length field that
    ///	  follows. If no Contained Elements are included, this field is set to
    ///	  0.
    ///	</summary>
    {$ENDREGION}
    ContainedElementCount : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the byte length of each Contained Element record that
    ///	  follows, in the range 0 to 255. If no Contained Elements are
    ///	  included, this field is set to 0. For version 2.3.2 and later of this
    ///	  specification, this field is set to at least 03h when Contained
    ///	  Elements are specified.
    ///	</summary>
    {$ENDREGION}
    ContainedElementRecordLength : Byte;
    //ContainedElements  n * m BYTEs
    //SKUNumber : Byte;

    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
  end;

  TProcessorInfo = packed record
    Header: TSmBiosTableHeader;
    SocketDesignation: Byte;
    ProcessorType: Byte;
    ProcessorFamily: Byte;
    ProcessorManufacturer: Byte;
    ProcessorID: Int64; // QWORD;
    ProcessorVersion: Byte;
    Voltaje: Byte;
    ExternalClock: Word;
    MaxSpeed: Word;
    CurrentSpeed: Word;
    Status: Byte;
    ProcessorUpgrade: Byte;
    L1CacheHandler: Word;
    L2CacheHandler: Word;
    L3CacheHandler: Word;
    SerialNumber: Byte;
    AssetTag: Byte;
    PartNumber: Byte;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
  end;

  TBatteryInfo = packed record
    Header: TSmBiosTableHeader;
    Location : Byte;
    Manufacturer : Byte;
    ManufacturerDate  : Byte;
    SerialNumber : Byte;
    DeviceName : Byte;
    DeviceChemistry : Byte;
    DesignCapacity : Word;
    DesignVoltage : Word;
    SBDSVersionNumber : Byte;
    MaximumErrorInBatteryData : Byte;
    SBDSSerialNumber : Word;
    SBDSManufacturerDate : Word;
    SBDSDeviceChemistry : Byte;
    DesignCapacityMultiplier : Byte;
    OEM_Specific: DWORD;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
  end;

  TCacheInfo = packed record
    Header: TSmBiosTableHeader;
    SocketDesignation: Byte;
    CacheConfiguration: DWORD;
    MaximumCacheSize: Word;
    InstalledSize: Word;
    SupportedSRAMType: Word;
    CurrentSRAMType: Word;
    CacheSpeed: Byte;
    ErrorCorrectionType: Byte;
    SystemCacheType: Byte;
    Associativity: Byte;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
  end;

  //Incomplete
  TMemoryDevice   = packed record
    Header: TSmBiosTableHeader;
    PhysicalMemoryArrayHandle : Word;
    MemoryErrorInformationHandle : Word;
    TotalWidth : Word;
    DataWidth      : Word;
    Size        : Word;
    FormFactor   : Byte;
    DeviceSet    : Byte;
    DeviceLocator : Byte;
    BankLocator  : Byte;
    MemoryType   : Byte;
  end;

  TSMBiosTableEntry = record
    Header: TSmBiosTableHeader;
    Index : Integer;
  end;

  TSMBios = class
  private
    FSize: integer;
    FBuffer: PByteArray;
    FDataString: AnsiString;
    FBiosInfo: TArray<TBiosInfo>;
    FSysInfo: TArray<TSysInfo>;
    FBaseBoardInfo: TArray<TBaseBoardInfo>;
    FEnclosureInfo: TArray<TEnclosureInfo>;
    FProcessorInfo: TProcessorInfo;
    FProcessorInfoIndex: Integer;
    FDmiRevision: Integer;
    FSmbiosMajorVersion: Integer;
    FSmbiosMinorVersion: Integer;
    FSMBiosTablesList: TList<TSMBiosTableEntry>;
    FBatteryInfoIndex: Integer;
    FBatteryInfo: TBatteryInfo;
    FMemoryDeviceIndex: Integer;
    FMemoryDevice: TMemoryDevice;
    procedure LoadSMBIOS;
    procedure ReadSMBiosTables;
    function GetHasBiosInfo: Boolean;
    function GetHasSysInfo: Boolean;
    function GetHasBaseBoardInfo: Boolean;
    function GetHasEnclosureInfo: Boolean;
    function GetHasProcessorInfo: Boolean;
    function GetSMBiosTablesList:TList<TSMBiosTableEntry>;
    function GetHasBatteryInfo: Boolean;
    function GetHasMemoryDeviceInfo: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function SearchSMBiosTable(TableType: TSMBiosTablesTypes): integer;
    function GetSMBiosTableNextIndex(TableType: TSMBiosTablesTypes;Offset:Integer=0): integer;
    function GetSMBiosTableEntries(TableType: TSMBiosTablesTypes): integer;

    function GetSMBiosString(Entry, Index: integer): AnsiString;

    property Size: integer read FSize;
    property Buffer: PByteArray read FBuffer;
    property DataString: AnsiString read FDataString;
    property DmiRevision: Integer read FDmiRevision;
    property SmbiosMajorVersion : Integer read FSmbiosMajorVersion;
    property SmbiosMinorVersion : Integer read FSmbiosMinorVersion;
    property SMBiosTablesList : TList<TSMBiosTableEntry> read FSMBiosTablesList;

    property BiosInfo: TArray<TBiosInfo> read FBiosInfo;
    property HasBiosInfo : Boolean read GetHasBiosInfo;

    property SysInfo: TArray<TSysInfo> read FSysInfo Write FSysInfo;
    property HasSysInfo : Boolean read GetHasSysInfo;

    property BaseBoardInfo: TArray<TBaseBoardInfo> read FBaseBoardInfo write FBaseBoardInfo;
    property HasBaseBoardInfo : Boolean read GetHasBaseBoardInfo;

    property EnclosureInfo: TArray<TEnclosureInfo> read FEnclosureInfo write FEnclosureInfo;
    property HasEnclosureInfo : Boolean read GetHasEnclosureInfo;

    property ProcessorInfo: TProcessorInfo read FProcessorInfo write FProcessorInfo;
    property ProcessorInfoIndex: Integer read FProcessorInfoIndex Write FProcessorInfoIndex;
    property HasProcessorInfo : Boolean read GetHasProcessorInfo;

    property BatteryInfo: TBatteryInfo read FBatteryInfo write FBatteryInfo;
    property BatteryInfoIndex: Integer read FBatteryInfoIndex Write FBatteryInfoIndex;
    property HasBatteryInfo : Boolean read GetHasBatteryInfo;

    property MemoryDeviceInfo: TMemoryDevice read FMemoryDevice write FMemoryDevice;
    property MemoryDeviceInfoIndex: Integer read FMemoryDeviceIndex Write FMemoryDeviceIndex;
    property HasMemoryDeviceInfo : Boolean read GetHasMemoryDeviceInfo;


  end;

implementation

uses
  ComObj,
  ActiveX,
  Variants;

{ TSMBios }
constructor TSMBios.Create;
begin
  Inherited;
  FBuffer := nil;
  FSMBiosTablesList:=nil;
  FBiosInfo:=nil;
  LoadSMBIOS;
  ReadSMBiosTables;
end;

destructor TSMBios.Destroy;
begin
  if Assigned(FBuffer) and (FSize > 0) then
    FreeMem(FBuffer);

  if Assigned(FSMBiosTablesList) then
    FSMBiosTablesList.Free;

  SetLength(FBiosInfo, 0);
  Inherited;
end;

function TSMBios.GetHasBaseBoardInfo: Boolean;
begin
  Result:=Length(FBaseBoardInfo)>0;
end;

function TSMBios.GetHasBatteryInfo: Boolean;
begin
  Result:=FBatteryInfoIndex>=0;
end;

function TSMBios.GetHasBiosInfo: Boolean;
begin
  Result:=Length(FBiosInfo)>0;
end;

function TSMBios.GetHasEnclosureInfo: Boolean;
begin
  Result:=Length(FEnclosureInfo)>0;
end;

function TSMBios.GetHasMemoryDeviceInfo: Boolean;
begin
   Result:=FMemoryDeviceIndex>=0;
end;

function TSMBios.GetHasProcessorInfo: Boolean;
begin
  Result:=FProcessorInfoIndex>=0;
end;

function TSMBios.GetHasSysInfo: Boolean;
begin
  Result:=Length(FSysInfo)>0;
end;

function TSMBios.SearchSMBiosTable(TableType: TSMBiosTablesTypes): integer;
Var
  Index  : integer;
  Header : TSmBiosTableHeader;
begin
  Index     := 0;
  repeat
    Move(Buffer[Index], Header, SizeOf(Header));

    if Header.TableType = Ord(TableType) then
      break
    else
    begin
       inc(Index, Header.Length);
       if Index+1>FSize then
       begin
         Index:=-1;
         Break;
       end;

      while not((Buffer[Index] = 0) and (Buffer[Index + 1] = 0)) do
       if Index+1>FSize then
       begin
         Index:=-1;
         Break;
       end
       else
       inc(Index);

       inc(Index, 2);
    end;
  until (Index>FSize);
  Result := Index;
end;

function GetSMBiosString(FBuffer: PByteArray;Entry, Index: integer): AnsiString;
var
  i: integer;
  p: PAnsiChar;
begin
  Result := '';
  for i := 1 to Index do
  begin
    p := PAnsiChar(@FBuffer[Entry]);
    if i = Index then
    begin
      Result := p;
      break;
    end
    else
      inc(Entry, StrLen(p) + 1);
  end;
end;

function TSMBios.GetSMBiosString(Entry, Index: integer): AnsiString;
var
  i: integer;
  p: PAnsiChar;
begin
  Result := '';
  for i := 1 to Index do
  begin
    p := PAnsiChar(@FBuffer[Entry]);
    if i = Index then
    begin
      Result := p;
      break;
    end
    else
      inc(Entry, StrLen(p) + 1);
  end;
end;

function TSMBios.GetSMBiosTableEntries(TableType: TSMBiosTablesTypes): integer;
Var
 Entry : TSMBiosTableEntry;
begin
 Result:=0;
  for Entry in FSMBiosTablesList do
    if Entry.Header.TableType=Ord(TableType)  then
      Result:=Result+1;
end;

function TSMBios.GetSMBiosTableNextIndex(TableType: TSMBiosTablesTypes;Offset:Integer=0): integer;
Var
 Entry : TSMBiosTableEntry;
begin
 Result:=-1;
  for Entry in FSMBiosTablesList do
    if (Entry.Header.TableType=Ord(TableType)) and (Entry.Index>Offset)  then
    begin
      Result:=Entry.Index;
      Break;
    end;
end;

function TSMBios.GetSMBiosTablesList: TList<TSMBiosTableEntry>;
Var
  Index : integer;
  Header: TSmBiosTableHeader;
  Entry    : TSMBiosTableEntry;
begin
  Result    := TList<TSMBiosTableEntry>.Create;
  Index     := 0;
  repeat
    Move(Buffer[Index], Header, SizeOf(Header));
    Entry.Header:=Header;
    Entry.Index:=Index;
    Result.Add(Entry);

    if Header.TableType=Ord(TSMBiosTablesTypes.EndofTable) then break;

    inc(Index, Header.Length);// + 1);
    if Index+1>FSize then
      Break;

    while not((Buffer[Index] = 0) and (Buffer[Index + 1] = 0)) do
    if Index+1>FSize then
     Break
    else
     inc(Index);

    inc(Index, 2);
  until (Index>FSize);
end;


procedure TSMBios.LoadSMBIOS;
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
  vArray: variant;
  Value: integer;
  i: integer;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\WMI', '', '');
  FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM MSSmBios_RawSMBiosTables', 'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
  if oEnum.Next(1, FWbemObject, iValue) = 0 then
  begin
    FSize := FWbemObject.Size;
    GetMem(FBuffer, FSize);

    FDmiRevision:= FWbemObject.DmiRevision;
    FSmbiosMajorVersion :=FWbemObject.SmbiosMajorVersion;
    FSmbiosMinorVersion :=FWbemObject.SmbiosMinorVersion;

    vArray := FWbemObject.SMBiosData;

    if (VarType(vArray) and VarArray) <> 0 then
      for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
      begin
        Value := vArray[i];
        Buffer[i] := Value;
        if Value in [$20..$7E] then
          FDataString := FDataString + AnsiString(Chr(Value))
        else
          FDataString := FDataString + '.';
      end;

    FSMBiosTablesList:=GetSMBiosTablesList;
    FWbemObject := Unassigned;
  end;
end;

procedure TSMBios.ReadSMBiosTables;
var
 LIndex, i :  Integer;
begin
  SetLength(FBiosInfo, GetSMBiosTableEntries(BIOSInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(BIOSInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FBiosInfo[i], SizeOf(TBiosInfo)- SizeOf(FBiosInfo[i].LocalIndex) - SizeOf(FBiosInfo[i].FBuffer));
      FBiosInfo[i].LocalIndex := LIndex;
      FBiosInfo[i].FBuffer    := FBuffer;
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FSysInfo, GetSMBiosTableEntries(SystemInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(SystemInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FSysInfo[i], SizeOf(TSysInfo)- SizeOf(FSysInfo[i].LocalIndex));
      FSysInfo[i].LocalIndex:=LIndex;
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FBaseBoardInfo, GetSMBiosTableEntries(BaseBoardInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(BaseBoardInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FBaseBoardInfo[i], SizeOf(TBaseBoardInfo)- SizeOf(FBaseBoardInfo[i].LocalIndex));
      FBaseBoardInfo[i].LocalIndex:=LIndex;
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FEnclosureInfo, GetSMBiosTableEntries(EnclosureInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(EnclosureInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FEnclosureInfo[i], SizeOf(TEnclosureInfo)- SizeOf(FEnclosureInfo[i].LocalIndex));
      FEnclosureInfo[i].LocalIndex:=LIndex;
      Inc(i);
    end;
  until (LIndex=-1);


  FProcessorInfoIndex := GetSMBiosTableNextIndex(ProcessorInformation);
  if FProcessorInfoIndex >= 0 then
    Move(Buffer[FProcessorInfoIndex], FProcessorInfo, SizeOf(FProcessorInfo));


  FBatteryInfoIndex := GetSMBiosTableNextIndex(PortableBattery);
  if FBatteryInfoIndex >= 0 then
    Move(Buffer[FBatteryInfoIndex], FBatteryInfo, SizeOf(FBatteryInfo));

  FMemoryDeviceIndex := GetSMBiosTableNextIndex(MemoryDevice);
  if FMemoryDeviceIndex >= 0 then
    Move(Buffer[FMemoryDeviceIndex], FMemoryDevice, SizeOf(FMemoryDevice));
end;

{ TBaseBoardInfo }

function TBaseBoardInfo.BoardTypeStr: AnsiString;
begin
   case Self.BoardType of
    $01 : result:='Unknown';
    $02 : result:='Other';
    $03 : result:='Server Blade';
    $04 : result:='Connectivity Switch';
    $05 : result:='System Management Module';
    $06 : result:='Processor Module';
    $07 : result:='I/O Module';
    $08 : result:='Memory Module';
    $09 : result:='Daughter board';
    $0A : result:='Motherboard (includes processor, memory, and I/O)';
    $0B : result:='Processor/Memory Module';
    $0C : result:='Processor/IO Module';
    $0D : result:='Interconnect Board'
    else
    result:='Unknown';
   end;
end;

{ TBiosInfo }

function TBiosInfo.ReleaseDateStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.ReleaseDate);
end;

function TBiosInfo.VendorStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Vendor);
end;

function TBiosInfo.VersionStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Version);
end;

end.
