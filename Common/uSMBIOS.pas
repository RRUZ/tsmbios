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
    MemoryControllerInformation = 5, //Obsolete starting with version 2.1
    MemoryModuleInformation = 6,     //Obsolete starting with version 2.1
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
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Vendor field
    ///	</summary>
    {$ENDREGION}
    function  VendorStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ReleaseDate field
    ///	</summary>
    {$ENDREGION}
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
    ///	  Universal Unique ID number, A UUID is an identifier that is designed
    ///	  to be unique across both time and space. It requires no central
    ///	  registration process. The UUID is 128 bits long. Its format is
    ///	  described in RFC 4122, but the actual field contents are opaque and
    ///	  not significant to the SMBIOS specification, which is only concerned
    ///	  with the byte order.
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
    FBuffer: PByteArray;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Manufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ManufacturerStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProductName field
    ///	</summary>
    {$ENDREGION}
    function  ProductNameStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SKUNumber field
    ///	</summary>
    {$ENDREGION}
    function  SKUNumberStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Family field
    ///	</summary>
    {$ENDREGION}
    function  FamilyStr: string;
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
    FBuffer: PByteArray;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the BoardType field
    ///	</summary>
    {$ENDREGION}
    function BoardTypeStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Manufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ManufacturerStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Product field
    ///	</summary>
    {$ENDREGION}
    function  ProductStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTag field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the LocationinChassis field
    ///	</summary>
    {$ENDREGION}
    function  LocationinChassisStr: string;
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

    //TODO Extension to support complex data representation
    //ContainedElements  n * m BYTEs
    //SKUNumber : Byte;

    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
    FBuffer: PByteArray;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Manufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ManufacturerStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTagNumber field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagNumberStr : string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the Type field
    ///	</summary>
    {$ENDREGION}
    function  TypeStr : string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the BootUpState field
    ///	</summary>
    {$ENDREGION}
    function  BootUpStateStr : string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the PowerSupplyState field
    ///	</summary>
    {$ENDREGION}
    function  PowerSupplyStateStr : string;
  end;

   TCacheSRAMType =
   (
    SROther,
    SRUnknown,
    SRNon_Burst,
    SRBurst,
    SRPipelineBurst,
    SRSynchronous,
    SRAsynchronous
   );

   TCacheSRAMTypes = set of TCacheSRAMType;

   TErrorCorrectionType=
   (
    ECFiller,
    ECOther,
    ECUnknown,
    ECNone,
    ECParity,
    ECSingle_bitECC,
    ECMulti_bitECC
    );

   Const
   ErrorCorrectionTypeStr : Array [TErrorCorrectionType] of String  =(
    'Filler',
    'Other',
    'Unknown',
    'None',
    'Parity',
    'Single bit ECC',
    'Multi bit ECC'
   );

   type

   TSystemCacheType=
   (
    SCFiller,
    SCOther,
    SCUnknown,
    SCInstruction,
    SCData,
    SCUnified
    );

   Const
   SystemCacheTypeStr : Array [TSystemCacheType] of String  =(
    'Filler',
    'Other',
    'Unknown',
    'Instruction',
    'Data',
    'Unified'
   );


   type
   {$REGION 'Documentation'}
   ///	<summary>
   ///	  The information in this structure defines the attributes of CPU cache
   ///	  device in the system. One structure is specified for each such device,
   ///	  whether the device is internal to or external to the CPU module. Cache
   ///	  modules can be associated with a processor structure in one or two
   ///	  ways depending on the SMBIOS version.
   ///	</summary>
   {$ENDREGION}
   TCacheInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String Number for Reference Designation EXAMPLE: “CACHE1”, 0
    ///	</summary>
    {$ENDREGION}
    SocketDesignation: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Bits 15:10 Reserved, must be zero
    ///	  </para>
    ///	  <para>
    ///	    Bits 9:8 Operational Mode
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      00b Write Through
    ///	    </item>
    ///	    <item>
    ///	      01b Write Back
    ///	    </item>
    ///	    <item>
    ///	      10b Varies with Memory Address
    ///	    </item>
    ///	    <item>
    ///	      11b Unknown
    ///	    </item>
    ///	  </list>
    ///	  <para>
    ///	    Bit 7 Enabled/Disabled (at boot time)
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      1b Enabled
    ///	    </item>
    ///	    <item>
    ///	      0b Disabled
    ///	    </item>
    ///	  </list>
    ///	  <para>
    ///	    Bits 6:5 Location, relative to the CPU module:
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      00b Internal
    ///	    </item>
    ///	    <item>
    ///	      01b External
    ///	    </item>
    ///	    <item>
    ///	      10b Reserved
    ///	    </item>
    ///	    <item>
    ///	      11b Unknown
    ///	    </item>
    ///	  </list>
    ///	  <para>
    ///	    Bit 4 Reserved, must be zero
    ///	  </para>
    ///	  <para>
    ///	    Bit 3 Cache Socketed
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      1b Socketed
    ///	    </item>
    ///	    <item>
    ///	      0b Not Socketed
    ///	    </item>
    ///	  </list>
    ///	  <para>
    ///	    Bits 2:0 Cache Level – 1 through 8 (For example, an L1 cache would
    ///	    use value 000b and an L3
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    CacheConfiguration: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Maximum size that can be installed
    ///	  </para>
    ///	  <para>
    ///	    Bit 15 Granularity
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      0 – 1K granularity
    ///	    </item>
    ///	    <item>
    ///	      1 – 64K granularity
    ///	    </item>
    ///	  </list>
    ///	  <para>
    ///	    Bits 14:0 Max size in given granularity
    ///	  </para>
    ///	  <para>
    ///	    For multi-core processors, the cache size for the different levels
    ///	    of the cache (L1, L2, L3) is the total amount of cache per level
    ///	    per processor socket. The cache size is independent of the core
    ///	    count. For example, the cache size is 2 MB for both a dual core
    ///	    processor with a 2 MB L3 cache shared between the cores and a dual
    ///	    core processor with 1 MB L3 cache (non-shared) per core.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    MaximumCacheSize: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Same format as Max Cache Size field; set to 0 if no cache is
    ///	  installed.
    ///	</summary>
    {$ENDREGION}
    InstalledSize: Word;
    SupportedSRAMType: Word;
    CurrentSRAMType: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The cache module speed, in nanoseconds. The value is 0 if the speed
    ///	  is unknown.
    ///	</summary>
    {$ENDREGION}
    CacheSpeed: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The error-correction scheme supported by this cache component
    ///	</summary>
    {$ENDREGION}
    ErrorCorrectionType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The logical type of cache
    ///	</summary>
    {$ENDREGION}
    SystemCacheType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The associativity of the cache.
    ///	</summary>
    {$ENDREGION}
    Associativity: Byte;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
    FBuffer: PByteArray;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the  SocketDesignation field
    ///	</summary>
    {$ENDREGION}
    function SocketDesignationStr: String;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the calculated value of the MaximumCacheSize field
    ///	</summary>
    {$ENDREGION}
    function GetMaximumCacheSize: Integer;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the calculated value of the InstalledSize field
    ///	</summary>
    {$ENDREGION}
    function GetInstalledCacheSize: Integer;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the calculated value of the SupportedSRAMType field
    ///	</summary>
    {$ENDREGION}
    function GetSupportedSRAMType  : TCacheSRAMTypes;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the calculated value of the CurrentSRAMType field
    ///	</summary>
    {$ENDREGION}
    function GetCurrentSRAMType  : TCacheSRAMTypes;
    function GetErrorCorrectionType : TErrorCorrectionType;
    function GetSystemCacheType : TSystemCacheType;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the  Associativity field
    ///	</summary>
    {$ENDREGION}
    function AssociativityStr: String;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    The information in this structure (see Table 20) defines the
  ///	    attributes of a single processor; a separate structure instance is
  ///	    provided for each system processor socket/slot. For example, a system
  ///	    with an IntelDX2™ processor would have a single structure instance
  ///	    while a system with an IntelSX2™ processor would have a structure to
  ///	    describe the main CPU and a second structure to describe the 80487
  ///	    co892 processor.
  ///	  </para>
  ///	  <para>
  ///
  ///	    <b>NOTE: One structure is provided for each processor instance in a system. For example, a system that supports up to two processors includes two Processor Information structures — even if only one processor is currently installed. Software that interprets the SMBIOS information can count the Processor Information structures to determine the maximum possible configuration of the system.</b>
  ///	  </para>
  ///	</summary>
  {$ENDREGION}
  TProcessorInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for Reference Designation EXAMPLE: ‘J202’,0
    ///	</summary>
    {$ENDREGION}
    SocketDesignation: Byte;
    ProcessorType: Byte;
    ProcessorFamily: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of Processor Manufacturer
    ///	</summary>
    {$ENDREGION}
    ProcessorManufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Raw processor identification data.
    ///	  </para>
    ///	  <para>
    ///	    The Processor ID field contains processor-specific information that
    ///	    describes the processor’s features. x86-Class CPUs For x86 class
    ///	    CPUs, the field’s format depends on the processor’s support of the
    ///	    CPUID instruction. If the instruction is supported, the Processor
    ///	    ID field contains two DWORD-formatted values. The first (offsets
    ///	    08h-0Bh) is the EAX value returned by a CPUID instruction with
    ///	    input EAX set to 1; the second (offsets 0Ch-0Fh) is the EDX value
    ///	    returned by that instruction. Otherwise, only the first two bytes
    ///	    of the Processor ID field are significant (all others are set to 0)
    ///	    and contain (in WORD-format) the contents of the DX register at CPU
    ///	    reset.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    ProcessorID : Int64; // QWORD;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number describing the Processor
    ///	</summary>
    {$ENDREGION}
    ProcessorVersion: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Two forms of information can be specified by the SMBIOS in this
    ///	  field, dependent on the value present in bit 7 (the most-significant
    ///	  bit). If bit 7 is 0 (legacy mode), the remaining bits of the field
    ///	  represent the specific voltages that the processor socket can accept.
    ///	</summary>
    {$ENDREGION}
    Voltaje: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  External Clock Frequency, in MHz. If the value is unknown, the field
    ///	  is set to 0.
    ///	</summary>
    {$ENDREGION}
    ExternalClock: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Maximum processor speed (in MHz) supported by the system for this
    ///	    processor socket. 0E9h for a 233 MHz processor. If the value is
    ///	    unknown, the field is set to 0.
    ///	  </para>
    ///	  <para>
    ///
    ///	    <b>NOTE: This field identifies a capability for the system, not the processor itself.</b>
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    MaxSpeed: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Same format as Max Speed
    ///	  </para>
    ///	  <para>
    ///
    ///	    <b>NOTE: This field identifies the processor's speed at system boot, and the Processor ID field implies the processor's additional speed characteristics (that is, single speed or multiple speed).</b>
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    CurrentSpeed: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Bit 7 Reserved, must be zero
    ///	  </para>
    ///	  <para>
    ///	    Bit 6 CPU Socket Populated 1 – CPU Socket Populated 0 – CPU Socket
    ///	    Unpopulated
    ///	  </para>
    ///	  <para>
    ///	    Bits 5:3 Reserved, must be zero
    ///	  </para>
    ///	  <para>
    ///	    Bits 2:0 CPU Status
    ///	  </para>
    ///	  <list type="bullet">
    ///	    <item>
    ///	      0h – Unknown
    ///	    </item>
    ///	    <item>
    ///	      1h – CPU Enabled
    ///	    </item>
    ///	    <item>
    ///	      2h – CPU Disabled by User through BIOS Setup
    ///	    </item>
    ///	    <item>
    ///	      3h – CPU Disabled By BIOS (POST Error)
    ///	    </item>
    ///	    <item>
    ///	      4h – CPU is Idle, waiting to be enabled.
    ///	    </item>
    ///	    <item>
    ///	      5-6h – Reserved
    ///	    </item>
    ///	    <item>
    ///	      7h – Other
    ///	    </item>
    ///	  </list>
    ///	</summary>
    {$ENDREGION}
    Status: Byte;
    ProcessorUpgrade: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The handle of a Cache Information structure that defines the
    ///	  attributes of the primary (Level 1) cache for this processor. For
    ///	  version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    ///	  the processor has no L1 cache. For version 2.3 and later
    ///	  implementations, the value is 0FFFFh if the Cache Information
    ///	  structure is not provided.
    ///	</summary>
    {$ENDREGION}
    L1CacheHandle: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The handle of a Cache Information structure that defines the
    ///	  attributes of the secondary (Level 2) cache for this processor. For
    ///	  version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    ///	  the processor has no L2 cache. For version 2.3 and later
    ///	  implementations, the value is 0FFFFh if the Cache Information
    ///	  structure is not provided.
    ///	</summary>
    {$ENDREGION}
    L2CacheHandle: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The handle of a Cache Information structure that defines the
    ///	  attributes of the tertiary (Level 3) cache for this processor. For
    ///	  version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    ///	  the processor has no L3 cache. For version 2.3 and later
    ///	  implementations, the value is 0FFFFh if the Cache Information
    ///	  structure is not provided.
    ///	</summary>
    {$ENDREGION}
    L3CacheHandle: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the serial number of this processor. This value is
    ///	  set by the manufacturer and normally not changeable.
    ///	</summary>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the asset tag of this processor.
    ///	</summary>
    {$ENDREGION}
    AssetTag: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the part number of this processor. This value is
    ///	  set by the manufacturer and normally not changeable.
    ///	</summary>
    {$ENDREGION}
    PartNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Number of cores per processor socket. If the value is unknown, the
    ///	    field is set to 0.
    ///	  </para>
    ///	  <para>
    ///	    Core Count is the number of cores detected by the BIOS for this
    ///	    processor socket. It does not necessarily indicate the full
    ///	    capability of the processor. For example, platform hardware may
    ///	    have the capability to limit the number of cores reported by the
    ///	    processor without BIOS intervention or knowledge. For a dual940
    ///	    processor installed in a platform where the hardware is set to
    ///	    limit it to one core, the BIOS reports a value of 1 in Core Count.
    ///	    For a dual-core processor with multi-core support disabled by BIOS,
    ///	    the BIOS reports a value of 2 in Core Count.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    CoreCount : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Number of enabled cores per processor socket. If the value is
    ///	    unknown, the field is set 0.
    ///	  </para>
    ///	  <para>
    ///	    Core Enabled is the number of cores that are enabled by the BIOS
    ///	    and available for Operating System use. For example, if the BIOS
    ///	    detects a dual-core processor, it would report a value of 2 if it
    ///	    leaves both cores enabled, and it would report a value of 1 if it
    ///	    disables multi-core support.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    CoreEnabled : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Number of threads per processor socket. If the value is unknown,
    ///	    the field is set to 0.
    ///	  </para>
    ///	  <para>
    ///	    Thread Count is the total number of threads detected by the BIOS
    ///	    for this processor socket. It is a processor-wide count, not a
    ///	    thread-per-core count. It does not necessarily indicate the full
    ///	    capability of the processor. For example, platform hardware may
    ///	    have the capability to limit the number of threads reported by the
    ///	    processor without BIOS intervention or knowledge. For a dual-thread
    ///	    processor installed in a platform where the hardware is set to
    ///	    limit it to one thread, the BIOS reports a value of 1 in Thread
    ///	    Count. For a dual-thread processor with multi-threading disabled by
    ///	    BIOS, the BIOS reports a value of 2 in Thread Count. For a
    ///	    dual-core, dual-thread-per-core processor, the BIOS reports a value
    ///	    of 4 in Thread Count.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    ThreadCount : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Defines which functions the processor supports.
    ///	</summary>
    {$ENDREGION}
    ProcessorCharacteristics : Word;
    ProcessorFamily2 : Word;
    //helper fields and methods, not part of the SMBIOS spec.
    LocalIndex : Word;
    FBuffer: PByteArray;
    L1Chache : TCacheInfo;
    L2Chache : TCacheInfo;
    L3Chache : TCacheInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProcessorManufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ProcessorManufacturerStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SocketDesignation field
    ///	</summary>
    {$ENDREGION}
    function  SocketDesignationStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the ProcessorType field.
    ///	</summary>
    {$ENDREGION}
    function  ProcessorTypeStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the ProcessorFamily and ProcessorFamily2 fields.
    ///	</summary>
    {$ENDREGION}
    function  ProcessorFamilyStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProcessorVersion field
    ///	</summary>
    {$ENDREGION}
    function  ProcessorVersionStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the  Voltaje of the Processor
    ///	</summary>
    {$ENDREGION}
    function  GetProcessorVoltaje : Double;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description  of the ProcessorUpgrade field
    ///	</summary>
    {$ENDREGION}
    function  ProcessorUpgradeStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTag field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagStr: string;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the PartNumber field
    ///	</summary>
    {$ENDREGION}
    function  PartNumberStr: string;
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
    FProcessorInfo: TArray<TProcessorInfo>;
    FCacheInfo: TArray<TCacheInfo>;
    FDmiRevision: Integer;
    FSmbiosMajorVersion: Integer;
    FSmbiosMinorVersion: Integer;
    FSMBiosTablesList: TList<TSMBiosTableEntry>;
    procedure LoadSMBIOS;
    procedure ReadSMBiosTables;
    function GetSMBiosTablesList:TList<TSMBiosTableEntry>;
    function GetHasBiosInfo: Boolean;
    function GetHasSysInfo: Boolean;
    function GetHasBaseBoardInfo: Boolean;
    function GetHasEnclosureInfo: Boolean;
    function GetHasProcessorInfo: Boolean;
    function GetHasCacheInfo: Boolean;
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

    property CacheInfo: TArray<TCacheInfo> read FCacheInfo write FCacheInfo;
    property HasCacheInfo : Boolean read GetHasCacheInfo;

    property ProcessorInfo: TArray<TProcessorInfo> read FProcessorInfo write FProcessorInfo;
    property HasProcessorInfo : Boolean read GetHasProcessorInfo;
  end;

implementation

uses
  ComObj,
  ActiveX,
  Variants;


function GetBit(const AValue: DWORD; const Bit: Byte): Boolean;
begin
  Result := (AValue and (1 shl Bit)) <> 0;
end;

function ClearBit(const AValue: DWORD; const Bit: Byte): DWORD;
begin
  Result := AValue and not (1 shl Bit);
end;

function SetBit(const AValue: DWORD; const Bit: Byte): DWORD;
begin
  Result := AValue or (1 shl Bit);
end;

function EnableBit(const AValue: DWORD; const Bit: Byte;
  const Enable: Boolean): DWORD;
begin
  Result := (AValue or (1 shl Bit)) xor (DWord(not Enable) shl Bit);
end;

{ TSMBios }
constructor TSMBios.Create;
begin
  Inherited;
  FBuffer := nil;
  FSMBiosTablesList:=nil;
  FBiosInfo:=nil;
  FSysInfo:=nil;
  FBaseBoardInfo:=nil;
  FEnclosureInfo:=nil;
  FProcessorInfo:=nil;
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
  SetLength(FSysInfo, 0);
  SetLength(FBaseBoardInfo, 0);
  SetLength(FEnclosureInfo, 0);
  SetLength(FProcessorInfo, 0);
  Inherited;
end;

function TSMBios.GetHasBaseBoardInfo: Boolean;
begin
  Result:=Length(FBaseBoardInfo)>0;
end;

function TSMBios.GetHasBiosInfo: Boolean;
begin
  Result:=Length(FBiosInfo)>0;
end;

function TSMBios.GetHasCacheInfo: Boolean;
begin
  Result:=Length(FCacheInfo)>0;
end;

function TSMBios.GetHasEnclosureInfo: Boolean;
begin
  Result:=Length(FEnclosureInfo)>0;
end;

function TSMBios.GetHasProcessorInfo: Boolean;
begin
  Result:=Length(FProcessorInfo)>0;
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
 LCacheInfo : TCacheInfo;
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
      Move(Buffer[LIndex], FSysInfo[i], SizeOf(TSysInfo)- SizeOf(FSysInfo[i].LocalIndex) - SizeOf(FSysInfo[i].FBuffer));
      FSysInfo[i].LocalIndex:=LIndex;
      FSysInfo[i].FBuffer   :=FBuffer;
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
      Move(Buffer[LIndex], FBaseBoardInfo[i], SizeOf(TBaseBoardInfo)- SizeOf(FBaseBoardInfo[i].LocalIndex) - SizeOf(FBaseBoardInfo[i].FBuffer));
      FBaseBoardInfo[i].LocalIndex:=LIndex;
      FBaseBoardInfo[i].FBuffer   :=FBuffer;
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
      Move(Buffer[LIndex], FEnclosureInfo[i], SizeOf(TEnclosureInfo)- SizeOf(FEnclosureInfo[i].LocalIndex)- SizeOf(FEnclosureInfo[i].FBuffer));
      FEnclosureInfo[i].LocalIndex:=LIndex;
      FEnclosureInfo[i].FBuffer   :=FBuffer;
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FCacheInfo, GetSMBiosTableEntries(CacheInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(CacheInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FCacheInfo[i], SizeOf(TCacheInfo)- SizeOf(FCacheInfo[i].LocalIndex)- SizeOf(FCacheInfo[i].FBuffer));
      FCacheInfo[i].LocalIndex:=LIndex;
      FCacheInfo[i].FBuffer   :=FBuffer;
      Inc(i);
    end;
  until (LIndex=-1);


  SetLength(FProcessorInfo, GetSMBiosTableEntries(ProcessorInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(ProcessorInformation, LIndex);
    if LIndex >= 0 then
    begin
      Move(Buffer[LIndex], FProcessorInfo[i], SizeOf(TProcessorInfo)- SizeOf(FProcessorInfo[i].LocalIndex)- SizeOf(FProcessorInfo[i].FBuffer) - (SizeOf(TCacheInfo)*3));
      FProcessorInfo[i].LocalIndex:=LIndex;
      FProcessorInfo[i].FBuffer   :=FBuffer;

      ZeroMemory(@FProcessorInfo[i].L1Chache, SizeOf(FProcessorInfo[i].L1Chache));
      ZeroMemory(@FProcessorInfo[i].L2Chache, SizeOf(FProcessorInfo[i].L2Chache));
      ZeroMemory(@FProcessorInfo[i].L3Chache, SizeOf(FProcessorInfo[i].L3Chache));

      if FProcessorInfo[i].L1CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.Header.Handle=FProcessorInfo[i].L1CacheHandle then
          begin
            Move(LCacheInfo, FProcessorInfo[i].L1Chache, SizeOf(LCacheInfo));
            Break;
          end;

      if FProcessorInfo[i].L2CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.Header.Handle=FProcessorInfo[i].L2CacheHandle then
          begin
            Move(LCacheInfo, FProcessorInfo[i].L2Chache, SizeOf(LCacheInfo));
            Break;
          end;

      if FProcessorInfo[i].L3CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.Header.Handle=FProcessorInfo[i].L3CacheHandle then
          begin
            Move(LCacheInfo, FProcessorInfo[i].L3Chache, SizeOf(LCacheInfo));
            Break;
          end;

      Inc(i);
    end;
  until (LIndex=-1);

  {
  FBatteryInfoIndex := GetSMBiosTableNextIndex(PortableBattery);
  if FBatteryInfoIndex >= 0 then
    Move(Buffer[FBatteryInfoIndex], FBatteryInfo, SizeOf(FBatteryInfo));

  FMemoryDeviceIndex := GetSMBiosTableNextIndex(MemoryDevice);
  if FMemoryDeviceIndex >= 0 then
    Move(Buffer[FMemoryDeviceIndex], FMemoryDevice, SizeOf(FMemoryDevice));
  }
end;

{ TBaseBoardInfo }

function TBaseBoardInfo.AssetTagStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.BoardType);
end;

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

function TBaseBoardInfo.LocationinChassisStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.LocationinChassis);
end;

function TBaseBoardInfo.ManufacturerStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Manufacturer);
end;

function TBaseBoardInfo.ProductStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Product);
end;

function TBaseBoardInfo.SerialNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SerialNumber);
end;

function TBaseBoardInfo.VersionStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Version);
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

{ TSysInfo }

function TSysInfo.FamilyStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Family);
end;

function TSysInfo.ManufacturerStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Manufacturer);
end;

function TSysInfo.ProductNameStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.ProductName);
end;

function TSysInfo.SerialNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SerialNumber);
end;

function TSysInfo.SKUNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SKUNumber);
end;

function TSysInfo.VersionStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Version);
end;

{ TEnclosureInfo }

function TEnclosureInfo.AssetTagNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.AssetTagNumber);
end;

function TEnclosureInfo.BootUpStateStr: string;
begin
 case Self.BootUpState of
  $01 : Result:='Other';
  $02 : Result:='Unknown';
  $03 : Result:='Safe';
  $04 : Result:='Warning';
  $05 : Result:='Critical';
  $06 : Result:='Non-recoverable'
 else
  Result:='Unknown';
 end;
end;

function TEnclosureInfo.ManufacturerStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Manufacturer);
end;

function TEnclosureInfo.PowerSupplyStateStr: string;
begin
 case Self.PowerSupplyState of
  $01 : Result:='Other';
  $02 : Result:='Unknown';
  $03 : Result:='Safe';
  $04 : Result:='Warning';
  $05 : Result:='Critical';
  $06 : Result:='Non-recoverable'
 else
  Result:='Unknown';
 end;
end;

function TEnclosureInfo.SerialNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SerialNumber);
end;

function TEnclosureInfo.TypeStr: string;
var
  _Type : Byte;
begin
   _Type:=Self.&Type;
  if GetBit(_Type, 7) then  _Type:=EnableBit(Self.&Type,7, False);

  case _Type of
   $01 : Result:='Other';
   $02 : Result:='Unknown';
   $03 : Result:='Desktop';
   $04 : Result:='Low Profile Desktop';
   $05 : Result:='Pizza Box';
   $06 : Result:='Mini Tower';
   $07 : Result:='Tower';
   $08 : Result:='Portable';
   $09 : Result:='LapTop';
   $0A : Result:='Notebook';
   $0B : Result:='Hand Held';
   $0C : Result:='Docking Station';
   $0D : Result:='All in One';
   $0E : Result:='Sub Notebook';
   $0F : Result:='Space-saving';
   $10 : Result:='Lunc Box';
   $11 : Result:='Main Server Chassis';
   $12 : Result:='Expansion Chassis';
   $13 : Result:='SubChassis';
   $14 : Result:='Bus Expansion Chassis';
   $15 : Result:='Peripheral Chassis';
   $16 : Result:='RAID Chassis';
   $17 : Result:='Rack Mount Chassis';
   $18 : Result:='Sealed-case PC';
   $19 : Result:='Multi-system chassis';
   $1A : Result:='Compact PCI';
   $1B : Result:='Advanced TCA';
   $1C : Result:='Blade';
   $1D : Result:='Blade Enclosure'
   else
    Result:='Unknown';
  end;
end;

function TEnclosureInfo.VersionStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.Version);
end;

{ TProcessorInfo }

function TProcessorInfo.AssetTagStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.AssetTag);
end;

function TProcessorInfo.GetProcessorVoltaje: Double;
var
  _Voltaje : Byte;
begin
  Result:=0;
   _Voltaje:=Self.Voltaje;
  if GetBit(_Voltaje, 7) then
  begin
    _Voltaje:=EnableBit(_Voltaje,7, False);
    Result:=(_Voltaje*1.0)/10.0;
  end
  else
  begin
   {
   Bit 0 – 5V
   Bit 1 – 3.3V
   Bit 2 – 2.9V
   }
   if GetBit(_Voltaje, 0) then
    Result:=5
   else
   if GetBit(_Voltaje, 1) then
    Result:=3.3
   else
   if GetBit(_Voltaje, 2) then
    Result:=2.9;
  end;
end;

function TProcessorInfo.PartNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.PartNumber);
end;

function TProcessorInfo.ProcessorFamilyStr: string;
begin
   if Self.ProcessorFamily2<$FF then
   case Self.ProcessorFamily of
      1 : Result:='Other';
      2 : Result:='Unknown';
      3 : Result:='8086';
      4 : Result:='80286';
      5 : Result:='Intel386™ processor';
      6 : Result:='Intel486™ processor';
      7 : Result:='8087';
      8 : Result:='80287';
      9 : Result:='80387';
      10 : Result:='80487';
      11 : Result:='Intel® Pentium® processor';
      12 : Result:='Pentium® Pro processor';
      13 : Result:='Pentium® II processor';
      14 : Result:='Pentium® processor with MMX™ technology';
      15 : Result:='Intel® Celeron® processor';
      16 : Result:='Pentium® II Xeon™ processor';
      17 : Result:='Pentium® III processor';
      18 : Result:='M1 Family';
      19 : Result:='M2 Family';
      20 : Result:='Intel® Celeron® M processor';
      21 : Result:='Intel® Pentium® 4 HT processor';
      22..23 : Result:='Available for assignment';
      24 : Result:='AMD Duron™ Processor Family';
      25 : Result:='K5 Family';
      26 : Result:='K6 Family';
      27 : Result:='K6-2';
      28 : Result:='K6-3';
      29 : Result:='AMD Athlon™ Processor Family';
      30 : Result:='AMD29000 Family';
      31 : Result:='K6-2+';
      32 : Result:='Power PC Family';
      33 : Result:='Power PC 601';
      34 : Result:='Power PC 603';
      35 : Result:='Power PC 603+';
      36 : Result:='Power PC 604';
      37 : Result:='Power PC 620';
      38 : Result:='Power PC x704';
      39 : Result:='Power PC 750';
      40 : Result:='Intel® Core™ Duo processor';
      41 : Result:='Intel® Core™ Duo mobile processor';
      42 : Result:='Intel® Core™ Solo mobile processor';
      43 : Result:='Intel® Atom™ processor';
      44..47 : Result:='Available for assignment';
      48 : Result:='Alpha Family';
      49 : Result:='Alpha 21064';
      50 : Result:='Alpha 21066';
      51 : Result:='Alpha 21164';
      52 : Result:='Alpha 21164PC';
      53 : Result:='Alpha 21164a';
      54 : Result:='Alpha 21264';
      55 : Result:='Alpha 21364';
      56 : Result:='AMD Turion™ II Ultra Dual-Core Mobile';
      57 : Result:='AMD Turion™ II Dual-Core Mobile M Processor';
      58 : Result:='AMD Athlon™ II Dual-Core M Processor';
      59 : Result:='AMD Opteron™ 6100 Series Processor';
      60 : Result:='AMD Opteron™ 4100 Series Processor';
      61 : Result:='AMD Opteron™ 6200 Series Processor';
      62 : Result:='AMD Opteron™ 4200 Series Processor';
      63 : Result:='Available for assignment';
      64 : Result:='MIPS Family';
      65 : Result:='MIPS R4000';
      66 : Result:='MIPS R4200';
      67 : Result:='MIPS R4400';
      68 : Result:='MIPS R4600';
      69 : Result:='MIPS R10000';
      70 : Result:='AMD C-Series Processor';
      71 : Result:='AMD E-Series Processor';
      72 : Result:='AMD S-Series Processor';
      73 : Result:='AMD G-Series Processor';
      74..79 : Result:='Available for assignment';
      80 : Result:='SPARC Family';
      81 : Result:='SuperSPARC';
      82 : Result:='microSPARC II';
      83 : Result:='microSPARC IIep';
      84 : Result:='UltraSPARC';
      85 : Result:='UltraSPARC II';
      86 : Result:='UltraSPARC IIi';
      87 : Result:='UltraSPARC III';
      88 : Result:='UltraSPARC IIIi';
      89..95 : Result:='Available for assignment';
      96 : Result:='68040 Family';
      97 : Result:='68xxx';
      98 : Result:='68000';
      99 : Result:='68010';
      100 : Result:='68020';
      101 : Result:='68030';
      102..111 : Result:='Available for assignment';
      112 : Result:='Hobbit Family';
      113..119 : Result:='Available for assignment';
      120 : Result:='Crusoe™ TM5000 Family';
      121 : Result:='Crusoe™ TM3000 Family';
      122 : Result:='Efficeon™ TM8000 Family';
      123..127 : Result:='Available for assignment';
      128 : Result:='Weitek';
      129 : Result:='Available for assignment';
      130 : Result:='Itanium™ processor';
      131 : Result:='AMD Athlon™ 64 Processor Family';
      132 : Result:='AMD Opteron™ Processor Family';
      133 : Result:='AMD Sempron™ Processor Family';
      134 : Result:='AMD Turion™ 64 Mobile Technology';
      135 : Result:='Dual-Core AMD Opteron™ Processor';
      136 : Result:='AMD Athlon™ 64 X2 Dual-Core Processor';
      137 : Result:='AMD Turion™ 64 X2 Mobile Technology';
      138 : Result:='Quad-Core AMD Opteron™ Processor';
      139 : Result:='Third-Generation AMD Opteron™';
      140 : Result:='AMD Phenom™ FX Quad-Core Processor';
      141 : Result:='AMD Phenom™ X4 Quad-Core Processor';
      142 : Result:='AMD Phenom™ X2 Dual-Core Processor';
      143 : Result:='AMD Athlon™ X2 Dual-Core Processor';
      144 : Result:='PA-RISC Family';
      145 : Result:='PA-RISC 8500';
      146 : Result:='PA-RISC 8000';
      147 : Result:='PA-RISC 7300LC';
      148 : Result:='PA-RISC 7200';
      149 : Result:='PA-RISC 7100LC';
      150 : Result:='PA-RISC 7100';
      151..159 : Result:='Available for assignment';
      160 : Result:='V30 Family';
      161 : Result:='Quad-Core Intel® Xeon® processor 3200 Series';
      162 : Result:='Dual-Core Intel® Xeon® processor 3000 Series';
      163 : Result:='Quad-Core Intel® Xeon® processor 5300 Series';
      164 : Result:='Dual-Core Intel® Xeon® processor 5100 Series';
      165 : Result:='Dual-Core Intel® Xeon® processor 5000 Series';
      166 : Result:='Dual-Core Intel® Xeon® processor LV';
      167 : Result:='Dual-Core Intel® Xeon® processor ULV';
      168 : Result:='Dual-Core Intel® Xeon® processor';
      169 : Result:='Quad-Core Intel® Xeon® processor';
      170 : Result:='Quad-Core Intel® Xeon® processor';
      171 : Result:='Dual-Core Intel® Xeon® processor';
      172 : Result:='Dual-Core Intel® Xeon® processor';
      173 : Result:='Quad-Core Intel® Xeon® processor';
      174 : Result:='Quad-Core Intel® Xeon® processor';
      175 : Result:='Multi-Core Intel® Xeon® processor';
      176 : Result:='Pentium® III Xeon™ processor';
      177 : Result:='Pentium® III Processor with Intel';
      178 : Result:='Pentium® 4 Processor';
      179 : Result:='Intel® Xeon® processor';
      180 : Result:='AS400 Family';
      181 : Result:='Intel® Xeon™ processor MP';
      182 : Result:='AMD Athlon™ XP Processor Family';
      183 : Result:='AMD Athlon™ MP Processor Family';
      184 : Result:='Intel® Itanium® 2 processor';
      185 : Result:='Intel® Pentium® M processor';
      186 : Result:='Intel® Celeron® D processor';
      187 : Result:='Intel® Pentium® D processor';
      188 : Result:='Intel® Pentium® Processor Extreme';
      189 : Result:='Intel® Core™ Solo Processor';
      190 : Result:='Reserved';
      191 : Result:='Intel® Core™ 2 Duo Processor';
      192 : Result:='Intel® Core™ 2 Solo processor';
      193 : Result:='Intel® Core™ 2 Extreme processor';
      194 : Result:='Intel® Core™ 2 Quad processor';
      195 : Result:='Intel® Core™ 2 Extreme mobile';
      196 : Result:='Intel® Core™ 2 Duo mobile processor';
      197 : Result:='Intel® Core™ 2 Solo mobile processor';
      198 : Result:='Intel® Core™ i7 processor';
      199 : Result:='Dual-Core Intel® Celeron® processor';
      200 : Result:='IBM390 Family';
      201 : Result:='G4';
      202 : Result:='G5';
      203 : Result:='ESA/390 G6';
      204 : Result:='z/Architectur base';
      205 : Result:='Intel® Core™ i5 processor';
      206 : Result:='Intel® Core™ i3 processor';
      207..209 : Result:='Available for assignment';
      210 : Result:='VIA C7™-M Processor Family';
      211 : Result:='VIA C7™-D Processor Family';
      212 : Result:='VIA C7™ Processor Family';
      213 : Result:='VIA Eden™ Processor Family';
      214 : Result:='Multi-Core Intel® Xeon® processor';
      215 : Result:='Dual-Core Intel® Xeon® processor 3xxx Series';
      216 : Result:='Quad-Core Intel® Xeon® processor 3xxx Series';
      217 : Result:='VIA Nano™ Processor Family';
      218 : Result:='Dual-Core Intel® Xeon® processor 5xxx Series';
      219 : Result:='Quad-Core Intel® Xeon® processor 5xxx Series';
      220 : Result:='Available for assignment';
      221 : Result:='Dual-Core Intel® Xeon® processor 7xxx Series';
      222 : Result:='Quad-Core Intel® Xeon® processor 7xxx Series';
      223 : Result:='Multi-Core Intel® Xeon® processor 7xxx Series';
      224 : Result:='Multi-Core Intel® Xeon® processor 3400 Series';
      225..229 : Result:='Available for assignment';
      230 : Result:='Embedded AMD Opteron™ Quad-Core Processor Family';
      231 : Result:='AMD Phenom™ Triple-Core Processor Family';
      232 : Result:='AMD Turion™ Ultra Dual-Core Mobile Processor Family';
      233 : Result:='AMD Turion™ Dual-Core Mobile Processor Family';
      234 : Result:='AMD Athlon™ Dual-Core Processor Family';
      235 : Result:='AMD Sempron™ SI Processor Family';
      236 : Result:='AMD Phenom™ II Processor Family';
      237 : Result:='AMD Athlon™ II Processor Family';
      238 : Result:='Six-Core AMD Opteron™ Processor Family';
      239 : Result:='AMD Sempron™ M Processor Family';
      240..249 : Result:='Available for assignment';
      250 : Result:='i860';
      251 : Result:='i960';
      252..253 : Result:='Available for assignment';
      254 : Result:='Indicator to obtain the processor family from the Processor';
      255 : Result:='Reserved';
   else
     result:='Unknown';
   end
   else
   case Self.ProcessorFamily2 of
      256..259,
      262..279,
      282..299,
      303..319,
      321..349,
      351..499,
      501..511 : Result:='These values are available for assignment';
      260 : Result:='SH-3';
      261 : Result:='SH-4';
      280 : Result:='ARM';
      281 : Result:='StrongARM';
      300 : Result:='6x86';
      301 : Result:='MediaGX';
      302 : Result:='MII';
      320 : Result:='WinChip';
      350 : Result:='DSP';
      500 : Result:='Video Processor';
      512..65533 : Result:='Available for assignment';
      65534..65535 : Result:='Reserved'
   else
     result:='Unknown';
   end;
end;

function TProcessorInfo.ProcessorManufacturerStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.ProcessorManufacturer);
end;

function TProcessorInfo.ProcessorTypeStr: string;
begin
   case Self.ProcessorType of
      $01 : Result:='Other';
      $02 : Result:='Unknown';
      $03 : Result:='Central Processor';
      $04 : Result:='Math Processor';
      $05 : Result:='DSP Processor';
      $06 : Result:='Video Processor'
      else
      Result:='Unknown';
   end;
end;

function TProcessorInfo.ProcessorUpgradeStr: string;
begin
  case Self.ProcessorUpgrade of
    $01 : Result:='Other';
    $02 : Result:='Unknown';
    $03 : Result:='Daughter Board';
    $04 : Result:='ZIF Socket';
    $05 : Result:='Replaceable Piggy Back';
    $06 : Result:='None';
    $07 : Result:='LIF Socket';
    $08 : Result:='Slot 1';
    $09 : Result:='Slot 2';
    $0A : Result:='370-pin socket';
    $0B : Result:='Slot A';
    $0C : Result:='Slot M';
    $0D : Result:='Socket 423';
    $0E : Result:='Socket A (Socket 462)';
    $0F : Result:='Socket 478';
    $10 : Result:='Socket 754';
    $11 : Result:='Socket 940';
    $12 : Result:='Socket 939';
    $13 : Result:='Socket mPGA604';
    $14 : Result:='Socket LGA771';
    $15 : Result:='Socket LGA775';
    $16 : Result:='Socket S1';
    $17 : Result:='Socket AM2';
    $18 : Result:='Socket F (1207)';
    $19 : Result:='Socket LGA1366';
    $1A : Result:='Socket G34';
    $1B : Result:='Socket AM3';
    $1C : Result:='Socket C32';
    $1D : Result:='Socket LGA1156';
    $1E : Result:='Socket LGA1567';
    $1F : Result:='Socket PGA988A';
    $20 : Result:='Socket BGA1288';
    $21 : Result:='Socket rPGA988B';
    $22 : Result:='Socket BGA1023';
    $23 : Result:='Socket BGA1224';
    $24 : Result:='Socket BGA1155';
    $25 : Result:='Socket LGA1356';
    $26 : Result:='Socket LGA2011';
    $27 : Result:='Socket FS1';
    $28 : Result:='Socket FS2';
    $29 : Result:='Socket FM1';
    $2A : Result:='Socket FM2'
  else
    Result:='Unknown';
  end;
end;

function TProcessorInfo.ProcessorVersionStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.ProcessorVersion);
end;

function TProcessorInfo.SerialNumberStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SerialNumber);
end;

function TProcessorInfo.SocketDesignationStr: string;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SocketDesignation);
end;

{ TCacheInfo }

function TCacheInfo.AssociativityStr: String;
begin
  case Self.Associativity of
    $01 : Result:='Other';
    $02 : Result:='Unknown';
    $03 : Result:='Direct Mapped';
    $04 : Result:='2-way Set-Associative';
    $05 : Result:='4-way Set-Associative';
    $06 : Result:='Fully Associative';
    $07 : Result:='8-way Set-Associative';
    $08 : Result:='16-way Set-Associative';
    $09 : Result:='12-way Set-Associative';
    $0A : Result:='24-way Set-Associative';
    $0B : Result:='32-way Set-Associative';
    $0C : Result:='48-way Set-Associative';
    $0D : Result:='64-way Set-Associative';
    $0E : Result:='20-way Set-Associative';
  else
    Result:='Unknown';
  end;
end;

function TCacheInfo.GetCurrentSRAMType: TCacheSRAMTypes;
var
  i: integer;
begin
   Result:=[];
   for i := 0 to 6 do
    if GetBit(Self.CurrentSRAMType, i) then
       Include(Result,  TCacheSRAMType(i));
end;

function TCacheInfo.GetErrorCorrectionType: TErrorCorrectionType;
begin
  if Self.ErrorCorrectionType>6 then
   Result:=ECUnknown
  else
   Result:=TErrorCorrectionType(Self.ErrorCorrectionType);
end;

function TCacheInfo.GetInstalledCacheSize: Integer;
var
  Granularity : Integer;
begin
   Granularity:=1;
   if GetBit(Self.InstalledSize, 15) then
     Granularity:=64;

  Result:=Granularity*EnableBit(Self.InstalledSize, 15, false);
end;

function TCacheInfo.GetMaximumCacheSize: Integer;
var
  Granularity : Integer;
begin
   Granularity:=1;
   if GetBit(Self.MaximumCacheSize, 15) then
     Granularity:=64;

  Result:=Granularity*EnableBit(Self.MaximumCacheSize, 15, false);
end;

function TCacheInfo.GetSupportedSRAMType: TCacheSRAMTypes;
var
  i: integer;
begin
   Result:=[];
   for i := 0 to 6 do
    if GetBit(Self.SupportedSRAMType, i) then
       Include(Result,  TCacheSRAMType(i));
end;

function TCacheInfo.GetSystemCacheType: TSystemCacheType;
begin
  if Self.SystemCacheType>5 then
   Result:=SCUnknown
  else
   Result:=TSystemCacheType(Self.SystemCacheType);
end;

function TCacheInfo.SocketDesignationStr: String;
begin
  Result:= GetSMBiosString(FBuffer, Self.LocalIndex + Self.Header.Length, Self.SocketDesignation);
end;

end.
