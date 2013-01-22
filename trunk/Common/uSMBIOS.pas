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
{**************************************************************************************************}
unit uSMBIOS;

interface

uses
  SysUtils,
  Windows,
  {$IF CompilerVersion >= 20}Generics.Collections,{$IFEND}
  Classes;

{.$DEFINE USEWMI}

type
  // TODO :
  // Add OSX support http://www.opensource.apple.com/source/AppleSMBIOS/AppleSMBIOS-38/SMBIOS.h
  // Add remote support
  // Add FPC support
  // Add old Delphi versions support


  PRawSMBIOSData = ^TRawSMBIOSData;
  TRawSMBIOSData = record
    Used20CallingMethod : Byte;
    SMBIOSMajorVersion : Byte;
    SMBIOSMinorVersion : Byte;
    DmiRevision : Byte;
    Length : DWORD;
    SMBIOSTableData : PByteArray;
  end;

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
    OnBoardDevicesInformation = 10,  //This structure is obsolete starting with version 2.6
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
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    TableType: Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Length: Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Vendor: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of the BIOS Version. This is a freeform string that may
    ///	  contain Core and OEM version information.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Segment location of BIOS starting address (for example, 0E800h).
    ///	  NOTE: The size of the runtime BIOS image can be computed by
    ///	  subtracting the Starting Address Segment from 10000h and multiplying
    ///	  the result by 16.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    StartingSegment: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of the BIOS release date. The date string, if supplied,
    ///	  is in either mm/dd/yy or mm/dd/yyyy format. If the year portion of
    ///	  the string is two digits, the year is assumed to be 19yy. NOTE: The
    ///	  mm/dd/yyyy format is required for SMBIOS version 2.3 and later.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ReleaseDate: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Size (n) where 64K * (n+1) is the size of the physical device
    ///	  containing the BIOS, in bytes
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    BiosRomSize: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Defines which functions the BIOS supports: PCI, PCMCIA, Flash, etc.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SystemBIOSMajorRelease : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the minor release of the System BIOS; for example, the
    ///	  value is 16h for revision 10.22 and 01h for revision 2.1.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    EmbeddedControllerFirmwareMajorRelease : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the minor release of the embedded controller firmware; for
    ///	  example, the value is 16h for revision 10.22 and 01h for revision
    ///	  2.1. If the system does not have field upgradeable embedded
    ///	  controller firmware, the value is 0FFh.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    EmbeddedControllerFirmwareMinorRelease : Byte;
  end;

  TBiosInformation = class
  public
    RAWBiosInformation : ^TBiosInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Vendor field
    ///	</summary>
    {$ENDREGION}
    function  VendorStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ReleaseDate field
    ///	</summary>
    {$ENDREGION}
    function  ReleaseDateStr: AnsiString;
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ProductName: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    UUID: array [0 .. 15] of Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the event that caused the system to power up.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.4+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.4+
    ///	</remarks>
    {$ENDREGION}
    Family : Byte;
  end;

  TSystemInformation = class
  public
    RAWSystemInformation : ^TSysInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Manufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ManufacturerStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProductName field
    ///	</summary>
    {$ENDREGION}
    function  ProductNameStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SKUNumber field
    ///	</summary>
    {$ENDREGION}
    function  SKUNumberStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Family field
    ///	</summary>
    {$ENDREGION}
    function  FamilyStr: AnsiString;
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Product: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Version: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of a null-terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    AssetTag  : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  A collection of flags that identify features of this baseboard.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    LocationinChassis : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The handle, or instance number, associated with the chassis in which
    ///	  this board resides
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ChassisHandle : Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the type of board
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    BoardType :  Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the number (0 to 255) of Contained Object Handles that
    ///	  follow
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    NumberofContainedObjectHandles : Byte;
    //ContainedObjectHandles :  Array of Word;
  end;


  TBaseBoardInformation = class
  public
    RAWBaseBoardInformation : ^TBaseBoardInfo;
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
    function  ManufacturerStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Product field
    ///	</summary>
    {$ENDREGION}
    function  ProductStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTag field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the LocationinChassis field
    ///	</summary>
    {$ENDREGION}
    function  LocationinChassisStr: AnsiString;
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Manufacturer: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Bit 7 Chassis lock is present if 1. Otherwise, either a lock is not
    ///	  present or it is unknown if the enclosure has a lock. Bits 6:0
    ///	  Enumeration value.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    &Type: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of Null terminated string
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    AssetTagNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the state of the enclosure when it was last booted.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    BootUpState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the state of the enclosure’s power supply (or supplies)
    ///	  when last booted.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    PowerSupplyState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the enclosure’s thermal state when last booted.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    ThermalState: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the enclosure’s physical security status when last booted.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    SecurityStatus: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Contains OEM- or BIOS vendor-specific information.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
    {$ENDREGION}
    OEM_Defined: DWORD;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The height of the enclosure, in 'U's. A U is a standard unit of
    ///	  measure for the height of a rack or rack-mountable component and is
    ///	  equal to 1.75 inches or 4.445 cm. A value of 00h indicates that the
    ///	  enclosure height is unspecified.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
    {$ENDREGION}
    Height : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Identifies the number of power cords associated with the enclosure or
    ///	  chassis. A value of 00h indicates that the number is unspecified.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
    {$ENDREGION}
    ContainedElementRecordLength : Byte;
    //TODO Extension to support complex data representation
    //ContainedElements  n * m BYTEs
    //SKUNumber : Byte;     *******Added in SMBIOS 2.7*********
  end;

  TEnclosureInformation = class
  public
    RAWEnclosureInformation : ^TEnclosureInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Manufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ManufacturerStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the Version field
    ///	</summary>
    {$ENDREGION}
    function  VersionStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTagNumber field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagNumberStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the Type field
    ///	</summary>
    {$ENDREGION}
    function  TypeStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the BootUpState field
    ///	</summary>
    {$ENDREGION}
    function  BootUpStateStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the PowerSupplyState field
    ///	</summary>
    {$ENDREGION}
    function  PowerSupplyStateStr : AnsiString;
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    MaximumCacheSize: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Same format as Max Cache Size field; set to 0 if no cache is
    ///	  installed.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    InstalledSize: Word;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SupportedSRAMType: Word;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    CurrentSRAMType: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The cache module speed, in nanoseconds. The value is 0 if the speed
    ///	  is unknown.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    CacheSpeed: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The error-correction scheme supported by this cache component
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    ErrorCorrectionType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The logical type of cache
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    SystemCacheType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The associativity of the cache.
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    Associativity: Byte;
  end;

  TCacheInformation=class
  public
    RAWCacheInformation : ^TCacheInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the  SocketDesignation field
    ///	</summary>
    {$ENDREGION}
    function SocketDesignationStr: AnsiString;
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
    function AssociativityStr: AnsiString;
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SocketDesignation: Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ProcessorType: Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ProcessorFamily: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number of Processor Manufacturer
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ProcessorID : Int64; // QWORD;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number describing the Processor
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    ProcessorVersion: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Two forms of information can be specified by the SMBIOS in this
    ///	  field, dependent on the value present in bit 7 (the most-significant
    ///	  bit). If bit 7 is 0 (legacy mode), the remaining bits of the field
    ///	  represent the specific voltages that the processor socket can accept.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Voltaje: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  External Clock Frequency, in MHz. If the value is unknown, the field
    ///	  is set to 0.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Status: Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
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
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    L3CacheHandle: Word;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the serial number of this processor. This value is
    ///	  set by the manufacturer and normally not changeable.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
    {$ENDREGION}
    SerialNumber: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the asset tag of this processor.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
    {$ENDREGION}
    AssetTag: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for the part number of this processor. This value is
    ///	  set by the manufacturer and normally not changeable.
    ///	</summary>
    ///	<remarks>
    ///	  2.3+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.5+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.5+
    ///	</remarks>
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
    ///	<remarks>
    ///	  2.5+
    ///	</remarks>
    {$ENDREGION}
    ThreadCount : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Defines which functions the processor supports.
    ///	</summary>
    ///	<remarks>
    ///	  2.5+
    ///	</remarks>
    {$ENDREGION}
    ProcessorCharacteristics : Word;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.6+
    ///	</remarks>
    {$ENDREGION}
    ProcessorFamily2 : Word;
  end;

  TProcessorInformation=class
  public
    RAWProcessorInformation : ^TProcessorInfo;
    L1Chache : TCacheInformation;
    L2Chache : TCacheInformation;
    L3Chache : TCacheInformation;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProcessorManufacturer field
    ///	</summary>
    {$ENDREGION}
    function  ProcessorManufacturerStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SocketDesignation field
    ///	</summary>
    {$ENDREGION}
    function  SocketDesignationStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the ProcessorType field.
    ///	</summary>
    {$ENDREGION}
    function  ProcessorTypeStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the ProcessorFamily and ProcessorFamily2 fields.
    ///	</summary>
    {$ENDREGION}
    function  ProcessorFamilyStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ProcessorVersion field
    ///	</summary>
    {$ENDREGION}
    function  ProcessorVersionStr: AnsiString;
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
    function  ProcessorUpgradeStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SerialNumber field
    ///	</summary>
    {$ENDREGION}
    function  SerialNumberStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the AssetTag field
    ///	</summary>
    {$ENDREGION}
    function  AssetTagStr: AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the PartNumber field
    ///	</summary>
    {$ENDREGION}
    function  PartNumberStr: AnsiString;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  The information in this structure defines the attributes of a system
  ///	  port connector (for example, parallel, serial, keyboard, or mouse
  ///	  ports). The port’s type and connector information are provided. One
  ///	  structure is present for each port provided by the system.
  ///	</summary>
  {$ENDREGION}
  TPortConnectorInfo=packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for Internal Reference Designator, that is, internal to
    ///	  the system enclosure EXAMPLE: ‘J101’, 0
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    InternalReferenceDesignator : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Internal Connector type
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    InternalConnectorType  : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    String number for the External Reference Designation external to
    ///	    the system enclosure
    ///	  </para>
    ///	  <para>
    ///	    EXAMPLE: ‘COM A’, 0
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    ExternalReferenceDesignator : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  External Connector type.
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    ExternalConnectorType: Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Describes the function of the port
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    PortType : Byte;
  end;

  TPortConnectorInformation=class
  public
    RAWPortConnectorInformation : ^TPortConnectorInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the InternalReferenceDesignator
    ///	  field.
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    function InternalReferenceDesignatorStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the Connector Type Fields
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    function GetConnectorType(Connector:Byte) : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the ExternalReferenceDesignator
    ///	  field.
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    function ExternalReferenceDesignatorStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description of the PortType field.
    ///	</summary>
    ///	<remarks>
    ///	  +2.0
    ///	</remarks>
    {$ENDREGION}
    function PortTypeStr : AnsiString;
  end;


  {$REGION 'Documentation'}
  ///	<summary>
  ///	  the information in this structure defines the attributes of a system
  ///	  slot. One structure is provided for each slot in the system.
  ///	</summary>
  {$ENDREGION}
  TSystemSlotInfo=packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number for reference designation EXAMPLE: ‘PCI-1’,0
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SlotDesignation : Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SlotType : Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SlotDataBusWidth : Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    CurrentUsage : Byte;
    SlotLength : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  The Slot ID field of the System Slot structure provides a mechanism
    ///	  to correlate the physical attributes of  the slot to its logical
    ///	  access method (which varies based on the Slot Type field).
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SlotID : Word;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SlotCharacteristics1 :  Byte;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    SlotCharacteristics2 :  Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  For slots that are not of types PCI, AGP, PCI-X, or PCI-Express that
    ///	  do not have bus/device/function information, 0FFh should be populated
    ///	  in the fields of Segment Group Number, Bus Number, Device/Function
    ///	  Number. Segment Group Number is defined in the PCI Firmware
    ///	  Specification. The value is 0 for a single-segment topology.
    ///	</summary>
    ///	<remarks>
    ///	  2.6+
    ///	</remarks>
    {$ENDREGION}
    SegmentGroupNumber :Word;
    {$REGION 'Documentation'}
    ///	<remarks>
    ///	  2.6+
    ///	</remarks>
    {$ENDREGION}
    BusNumber : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Bits 7:3 – device number
    ///	  </para>
    ///	  <para>
    ///	    Bits 2:0 – function number
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  2.6+
    ///	</remarks>
    {$ENDREGION}
    DeviceFunctionNumber : Byte;

  end;

  TSystemSlotInformation=class
  public
    RAWSystemSlotInformation : ^TSystemSlotInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the string representation of the SlotDesignation field.
    ///	</summary>
    {$ENDREGION}
    function SlotDesignationStr : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the SlotType field
    ///	</summary>
    {$ENDREGION}
    function GetSlotType : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the SlotDataBusWidth field
    ///	</summary>
    {$ENDREGION}
    function GetSlotDataBusWidth : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the CurrentUsage field
    ///	</summary>
    {$ENDREGION}
    function GetCurrentUsage : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Get the description for the SlotLength field
    ///	</summary>
    {$ENDREGION}
    function GetSlotLength : AnsiString;
  end;


  {$REGION 'Documentation'}
  ///	<summary>
  ///	  This structure contains free-form strings defined by the OEM.  Examples
  ///	  of this are part numbers for system reference documents, contact
  ///	  information for the manufacturer, etc.
  ///	</summary>
  {$ENDREGION}
  TOEMStringsInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of strings
    ///	</summary>
    {$ENDREGION}
    Count : Byte;
  end;

  TOEMStringsInformation = class
  public
    RAWOEMStringsInformation : ^TOEMStringsInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Returns the OEM String based in the Index 
    ///	</summary>
    {$ENDREGION}
    function GetOEMString(index : Integer) : AnsiString;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  This structure contains information required to configure the
  ///	  baseboard’s Jumpers and Switches.
  ///	</summary>
  {$ENDREGION}
  TSystemConfInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of strings
    ///	</summary>
    {$ENDREGION}
    Count : Byte;
  end;

  TSystemConfInformation = class
  public
    RAWSystemConfInformation : ^TSystemConfInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Returns the configuration String based in the Index 
    ///	</summary>
    {$ENDREGION}
    function GetConfString(index : Integer) : AnsiString;
  end;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  The information in this structure defines the installable language
  ///	  attributes of the BIOS.
  ///	</summary>
  {$ENDREGION}
  TBIOSLanguageInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Number of languages available. Each available language has a
    ///	  description string. This field contains the number of strings that
    ///	  follow the formatted area of the structure.
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    InstallableLanguages : Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Bits 7:1 Reserved
    ///	  </para>
    ///	  <para>
    ///	    Bit 0 If set to 1, the Current Language strings use the abbreviated
    ///	    format. Otherwise, the strings use the long
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  2.1+
    ///	</remarks>
    {$ENDREGION}
    Flags:Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Reserved for future use
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    Reserved: array[0..14] of Byte;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String number (one-based) of the currently installed language
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    CurrentLanguage : Byte;
  end;

  TBIOSLanguageInformation=class
  public
    RAWBIOSLanguageInformation : ^TBIOSLanguageInfo;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Returns the Installed language string based in the Index 
    ///	</summary>
    {$ENDREGION}
    function GetLanguageString(index : Integer) : AnsiString;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Returns the current language as a string
    ///	</summary>
    {$ENDREGION}
    function GetCurrentLanguageStr : AnsiString;
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

  {$IF CompilerVersion < 20}
  ArrBaseBoardInfo    = Array of TBaseBoardInformation;
  ArrEnclosureInfo    = Array of TEnclosureInformation;
  ArrProcessorInfo    = Array of TProcessorInformation;
  ArrCacheInfo        = Array of TCacheInformation;
  ArrPortConnectorInfo= Array of TPortConnectorInformation;
  ArrSystemSlotInfo   = Array of TSystemSlotInformation;
  ArrSMBiosTableEntry = Array of TSMBiosTableEntry;
  ArrOEMStringsInfo   = Array of TOEMStringsInformation;
  ArrBIOSLanguageInfo = Array of TBIOSLanguageInformation;
  ArrSystemConfInfo   = Array of TSystemConfInformation;
  {$IFEND}

  TSMBios = class
  private
    FRawSMBIOSData : TRawSMBIOSData;
    FDataString: AnsiString;
    FBiosInfo: TBiosInformation;
    FSysInfo: TSystemInformation;
    FBaseBoardInfo: {$IF CompilerVersion < 20}ArrBaseBoardInfo; {$ELSE}TArray<TBaseBoardInformation>;{$IFEND}
    FEnclosureInfo: {$IF CompilerVersion < 20}ArrEnclosureInfo; {$ELSE}TArray<TEnclosureInformation>;{$IFEND}
    FProcessorInfo: {$IF CompilerVersion < 20}ArrProcessorInfo; {$ELSE}TArray<TProcessorInformation>;{$IFEND}
    FCacheInfo: {$IF CompilerVersion < 20}ArrCacheInfo; {$ELSE}TArray<TCacheInformation>;{$IFEND}
    FPortConnectorInfo : {$IF CompilerVersion < 20}ArrPortConnectorInfo; {$ELSE} TArray<TPortConnectorInformation>; {$IFEND}
    FSystemSlotInfo : {$IF CompilerVersion < 20}ArrSystemSlotInfo; {$ELSE} TArray<TSystemSlotInformation>; {$IFEND}
    FSMBiosTablesList: {$IF CompilerVersion < 20}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$IFEND}
    FOEMStringsInfo: {$IF CompilerVersion < 20}ArrOEMStringsInfo; {$ELSE}TArray<TOEMStringsInformation>;{$IFEND}
    FBIOSLanguageInfo: {$IF CompilerVersion < 20}ArrBIOSLanguageInfo; {$ELSE}TArray<TBIOSLanguageInformation>;{$IFEND}
    FSystemConfInfo: {$IF CompilerVersion < 20}ArrSystemConfInfo; {$ELSE}TArray<TSystemConfInformation>;{$IFEND}
    {$IFDEF USEWMI}
    procedure LoadSMBIOSWMI;
    {$ELSE}
    procedure LoadSMBIOSWinAPI;
    {$ENDIF}
    procedure ReadSMBiosTables;
    function GetSMBiosTablesList:{$IF CompilerVersion < 20}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$IFEND}
    function GetSMBiosTablesCount: Integer;
    function GetHasBaseBoardInfo: Boolean;
    function GetHasEnclosureInfo: Boolean;
    function GetHasProcessorInfo: Boolean;
    function GetHasCacheInfo: Boolean;
    function GetHasPortConnectorInfo: Boolean;
    function GetHasSystemSlotInfo: Boolean;
    function GetSmbiosVersion: string;
    function GetHasOEMStringsInfo: Boolean;
    function GetHasBIOSLanguageInfo: Boolean;
    function GetHasSystemConfInfo : Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function SearchSMBiosTable(TableType: TSMBiosTablesTypes): integer;
    function GetSMBiosTableNextIndex(TableType: TSMBiosTablesTypes;Offset:Integer=0): integer;
    function GetSMBiosTableEntries(TableType: TSMBiosTablesTypes): integer;

    function GetSMBiosString(Entry, Index: integer): AnsiString;

    property DataString: AnsiString read FDataString;
    property RawSMBIOSData : TRawSMBIOSData read FRawSMBIOSData;
    property SmbiosVersion : string  read GetSmbiosVersion;
    property SMBiosTablesList : {$IF CompilerVersion < 20}ArrSMBiosTableEntry {$ELSE}TArray<TSMBiosTableEntry> {$IFEND} read FSMBiosTablesList;

    property BiosInfo: TBiosInformation read FBiosInfo;
    property SysInfo: TSystemInformation read FSysInfo Write FSysInfo;

    property BaseBoardInfo: {$IF CompilerVersion < 20}ArrBaseBoardInfo {$ELSE}TArray<TBaseBoardInformation> {$IFEND} read FBaseBoardInfo write FBaseBoardInfo;
    property HasBaseBoardInfo : Boolean read GetHasBaseBoardInfo;

    property EnclosureInfo: {$IF CompilerVersion < 20}ArrEnclosureInfo {$ELSE}TArray<TEnclosureInformation> {$IFEND} read FEnclosureInfo write FEnclosureInfo;
    property HasEnclosureInfo : Boolean read GetHasEnclosureInfo;

    property CacheInfo: {$IF CompilerVersion < 20}ArrCacheInfo {$ELSE}TArray<TCacheInformation> {$IFEND} read FCacheInfo write FCacheInfo;
    property HasCacheInfo : Boolean read GetHasCacheInfo;

    property ProcessorInfo: {$IF CompilerVersion < 20}ArrProcessorInfo {$ELSE}TArray<TProcessorInformation> {$IFEND} read FProcessorInfo write FProcessorInfo;
    property HasProcessorInfo : Boolean read GetHasProcessorInfo;

    property PortConnectorInfo: {$IF CompilerVersion < 20}ArrPortConnectorInfo {$ELSE} TArray<TPortConnectorInformation> {$IFEND} read FPortConnectorInfo write FPortConnectorInfo;
    property HasPortConnectorInfo : Boolean read GetHasPortConnectorInfo;

    property SystemSlotInfo: {$IF CompilerVersion < 20}ArrSystemSlotInfo {$ELSE} TArray<TSystemSlotInformation> {$IFEND} read FSystemSlotInfo write FSystemSlotInfo;
    property HasSystemSlotInfo : Boolean read GetHasSystemSlotInfo;

    property OEMStringsInfo: {$IF CompilerVersion < 20}ArrOEMStringsInfo {$ELSE} TArray<TOEMStringsInformation> {$IFEND} read FOEMStringsInfo write FOEMStringsInfo;
    property HasOEMStringsInfo : Boolean read GetHasOEMStringsInfo;

    property BIOSLanguageInfo: {$IF CompilerVersion < 20}ArrBIOSLanguageInfo {$ELSE} TArray<TBIOSLanguageInformation> {$IFEND} read FBIOSLanguageInfo write FBIOSLanguageInfo;
    property HasBIOSLanguageInfo : Boolean read GetHasBIOSLanguageInfo;

    property SystemConfInfo: {$IF CompilerVersion < 20}ArrSystemConfInfo {$ELSE} TArray<TSystemConfInformation> {$IFEND} read FSystemConfInfo write FSystemConfInfo;
    property HasSystemConfInfo : Boolean read GetHasSystemConfInfo;
  end;

implementation

{$IFDEF USEWMI}
uses
  ComObj,
  ActiveX,
  Variants;
{$ENDIF}

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
  FBiosInfo:=TBiosInformation.Create;
  FSysInfo:=TSystemInformation.Create;


  FSMBiosTablesList:=nil;
  FBaseBoardInfo:=nil;
  FEnclosureInfo:=nil;
  FProcessorInfo:=nil;
  {$IFDEF USEWMI}
  LoadSMBIOSWMI;
  {$ELSE}
  LoadSMBIOSWinAPI;
  {$ENDIF}
  FSMBiosTablesList:=GetSMBiosTablesList;
  ReadSMBiosTables;
end;

destructor TSMBios.Destroy;
var
  i : Integer;
begin
  if Assigned(RawSMBIOSData.SMBIOSTableData) and (RawSMBIOSData.Length > 0) then
    FreeMem(RawSMBIOSData.SMBIOSTableData);

  FBiosInfo.Free;
  FSysInfo.Free;

  for i:=0 to Length(FOEMStringsInfo)-1 do
   FOEMStringsInfo[i].Free;

  for i:=0 to Length(FEnclosureInfo)-1 do
   FEnclosureInfo[i].Free;

  for i:=0 to Length(FCacheInfo)-1 do
   FCacheInfo[i].Free;

  for i:=0 to Length(FProcessorInfo)-1 do
   FProcessorInfo[i].Free;

  for i:=0 to Length(FPortConnectorInfo)-1 do
   FPortConnectorInfo[i].Free;

  for i:=0 to Length(FSystemSlotInfo)-1 do
   FSystemSlotInfo[i].Free;

  for i:=0 to Length(FSystemConfInfo)-1 do
   FSystemConfInfo[i].Free;

  SetLength(FSMBiosTablesList, 0);
  SetLength(FBaseBoardInfo, 0);
  SetLength(FEnclosureInfo, 0);
  SetLength(FProcessorInfo, 0);
  SetLength(FCacheInfo, 0);
  SetLength(FPortConnectorInfo, 0);
  Inherited;
end;

function TSMBios.GetHasBaseBoardInfo: Boolean;
begin
  Result:=Length(FBaseBoardInfo)>0;
end;

function TSMBios.GetHasBIOSLanguageInfo: Boolean;
begin
  Result:=Length(FBIOSLanguageInfo)>0;
end;

function TSMBios.GetHasCacheInfo: Boolean;
begin
  Result:=Length(FCacheInfo)>0;
end;

function TSMBios.GetHasEnclosureInfo: Boolean;
begin
  Result:=Length(FEnclosureInfo)>0;
end;

function TSMBios.GetHasOEMStringsInfo: Boolean;
begin
  Result:=Length(FOEMStringsInfo)>0;
end;

function TSMBios.GetHasPortConnectorInfo: Boolean;
begin
  Result:=Length(FPortConnectorInfo)>0;
end;

function TSMBios.GetHasProcessorInfo: Boolean;
begin
  Result:=Length(FProcessorInfo)>0;
end;

function TSMBios.GetHasSystemConfInfo: Boolean;
begin
  Result:=Length(FSystemConfInfo)>0;
end;

function TSMBios.GetHasSystemSlotInfo: Boolean;
begin
  Result:=Length(FSystemSlotInfo)>0;
end;

function TSMBios.SearchSMBiosTable(TableType: TSMBiosTablesTypes): integer;
Var
  Index  : DWORD;
  Header : TSmBiosTableHeader;
begin
  Index     := 0;
  Result    := 0;
  repeat
    Move(RawSMBIOSData.SMBIOSTableData[Index], Header, SizeOf(Header));

    if Header.TableType = Byte(Ord(TableType)) then
      break
    else
    begin
       inc(Index, Header.Length);
       if Index+1>RawSMBIOSData.Length then
       begin
         Result:=-1;
         Break;
       end;

      while not((RawSMBIOSData.SMBIOSTableData[Index] = 0) and (RawSMBIOSData.SMBIOSTableData[Index + 1] = 0)) do
       if Index+1>RawSMBIOSData.Length then
       begin
         Result:=-1;
         Break;
       end
       else
       inc(Index);

       inc(Index, 2);
    end;
  until (Index>RawSMBIOSData.Length);

  if Result<>-1 then
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
    p := PAnsiChar(@RawSMBIOSData.SMBIOSTableData[Entry]);
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
    if Entry.Header.TableType=Byte(Ord(TableType))  then
      Result:=Result+1;
end;

function TSMBios.GetSMBiosTableNextIndex(TableType: TSMBiosTablesTypes;Offset:Integer=0): integer;
Var
 Entry : TSMBiosTableEntry;
begin
 Result:=-1;
  for Entry in FSMBiosTablesList do
    if (Entry.Header.TableType=Byte(Ord(TableType))) and (Entry.Index>Offset)  then
    begin
      Result:=Entry.Index;
      Break;
    end;
end;

function TSMBios.GetSMBiosTablesCount: Integer;
Var
  Index : DWORD;
  Header: TSmBiosTableHeader;
begin
  Result    := 0;
  Index     := 0;
  repeat
    Move(RawSMBIOSData.SMBIOSTableData[Index], Header, SizeOf(Header));
    Inc(Result);

    if Header.TableType=Byte(Ord(EndofTable)) then break;

    inc(Index, Header.Length);// + 1);
    if Index+1>RawSMBIOSData.Length then
      Break;

    while not((RawSMBIOSData.SMBIOSTableData[Index] = 0) and (RawSMBIOSData.SMBIOSTableData[Index + 1] = 0)) do
    if Index+1>RawSMBIOSData.Length then
     Break
    else
     inc(Index);

    inc(Index, 2);
  until (Index>RawSMBIOSData.Length);
end;

function TSMBios.GetSMBiosTablesList: {$IF CompilerVersion < 20}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$IFEND}
Var
  I,Index : DWORD;
  Header: TSmBiosTableHeader;
  Entry    : TSMBiosTableEntry;
begin
  SetLength(Result, GetSMBiosTablesCount);
  I:=0;
  Index     := 0;
  repeat
    Move(RawSMBIOSData.SMBIOSTableData[Index], Header, SizeOf(Header));
    Entry.Header:=Header;
    Entry.Index:=Index;
    Move(Entry, Result[I], SizeOf(Entry));
    Inc(I);

    if Header.TableType=Byte(Ord(EndofTable)) then break;

    inc(Index, Header.Length);// + 1);
    if Index+1>RawSMBIOSData.Length then
      Break;

    while not((RawSMBIOSData.SMBIOSTableData[Index] = 0) and (RawSMBIOSData.SMBIOSTableData[Index + 1] = 0)) do
    if Index+1>RawSMBIOSData.Length then
     Break
    else
     inc(Index);

    inc(Index, 2);
  until (Index>RawSMBIOSData.Length);
end;


function TSMBios.GetSmbiosVersion: string;
begin
   Result := Format('%d.%d',[RawSMBIOSData.SMBIOSMajorVersion, RawSMBIOSData.SMBIOSMinorVersion]);
end;

{$IFNDEF USEWMI}
procedure TSMBios.LoadSMBIOSWinAPI;
type
  //http://msdn.microsoft.com/en-us/library/windows/desktop/ms724379%28v=vs.85%29.aspx
  TFNGetSystemFirmwareTable = function(FirmwareTableProviderSignature: DWORD;
    FirmwareTableID: DWORD; out pFirmwareTableBuffer; BufferSize: DWORD): UINT; stdcall;
const
  FirmwareTableProviderSignature = $52534D42;  // 'RSMB'
var
  GetSystemFirmwareTable: TFNGetSystemFirmwareTable;
  hModule: Windows.HMODULE;
  BufferSize: UINT;
  Buffer : PByteArray;
begin
  ZeroMemory(@RawSMBIOSData, SizeOf(RawSMBIOSData));
  hModule := GetModuleHandle(kernel32);
  GetSystemFirmwareTable := GetProcAddress(hModule, 'GetSystemFirmwareTable');
  if Assigned(GetSystemFirmwareTable) then
  begin
     BufferSize:=GetSystemFirmwareTable(FirmwareTableProviderSignature, 0, nil^, BufferSize);
     if BufferSize>0 then
     begin
       GetMem(FRawSMBIOSData.SMBIOSTableData, BufferSize-8);
       GetMem(Buffer, BufferSize);
       try
         GetSystemFirmwareTable(FirmwareTableProviderSignature, 0, Buffer^, BufferSize);
         Move(Buffer[0], FRawSMBIOSData, 8);
         Move(Buffer[8], FRawSMBIOSData.SMBIOSTableData^[0], FRawSMBIOSData.Length);
       finally
         FreeMem(Buffer);
       end;
     end
     else
     RaiseLastOSError;
  end
  else
  Raise Exception.Create('GetSystemFirmwareTable function not found');
end;
{$ENDIF}

{$IFDEF USEWMI}
procedure TSMBios.LoadSMBIOSWMI;
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
  ZeroMemory(@RawSMBIOSData, SizeOf(RawSMBIOSData));
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\WMI', '', '');
  FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM MSSmBios_RawSMBiosTables', 'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
  if oEnum.Next(1, FWbemObject, iValue) = 0 then
  begin
    //FSize := FWbemObject.Size;
    FRawSMBIOSData.Length             :=FWbemObject.Size;
    GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
    FRawSMBIOSData.DmiRevision:= FWbemObject.DmiRevision;
    FRawSMBIOSData.SMBIOSMajorVersion :=FWbemObject.SmbiosMajorVersion;
    FRawSMBIOSData.SMBIOSMinorVersion :=FWbemObject.SmbiosMinorVersion;

    if SmbiosVersion<'2.4' then
     raise Exception.Create(Format('Sorry, SMBIOS Version not supported %s',[SmbiosVersion]));

    vArray := FWbemObject.SMBiosData;

    if (VarType(vArray) and VarArray) <> 0 then
      for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
      begin
        Value := vArray[i];
        FRawSMBIOSData.SMBIOSTableData[i] := Value;
        if Value in [$20..$7E] then
          FDataString := FDataString + AnsiString(Chr(Value))
        else
          FDataString := FDataString + '.';
      end;
    FWbemObject := Unassigned;
  end;
end;
{$ENDIF}
procedure TSMBios.ReadSMBiosTables;
var
 LIndex, i :  Integer;
 LCacheInfo : TCacheInformation;
begin

  LIndex := GetSMBiosTableNextIndex(BIOSInformation, 0);
  if LIndex >= 0 then
    FBiosInfo.RAWBiosInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];

  LIndex := GetSMBiosTableNextIndex(SystemInformation, 0);
  if LIndex >= 0 then
    FSysInfo.RAWSystemInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];

  SetLength(FOEMStringsInfo, GetSMBiosTableEntries(OEMStrings));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(OEMStrings, LIndex);
    if LIndex >= 0 then
    begin
      FOEMStringsInfo[i]:=TOEMStringsInformation.Create;
      FOEMStringsInfo[i].RAWOEMStringsInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
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
      FBaseBoardInfo[i]:=TBaseBoardInformation.Create;
      FBaseBoardInfo[i].RAWBaseBoardInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
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
      FEnclosureInfo[i]:=TEnclosureInformation.Create;
      FEnclosureInfo[i].RAWEnclosureInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
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
      FCacheInfo[i]:=TCacheInformation.Create;
      FCacheInfo[i].RAWCacheInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
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
      FProcessorInfo[i]:=TProcessorInformation.Create;
      FProcessorInfo[i].RAWProcessorInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];

      {
      ZeroMemory(@FProcessorInfo[i].L1Chache, SizeOf(FProcessorInfo[i].L1Chache));
      ZeroMemory(@FProcessorInfo[i].L2Chache, SizeOf(FProcessorInfo[i].L2Chache));
      ZeroMemory(@FProcessorInfo[i].L3Chache, SizeOf(FProcessorInfo[i].L3Chache));
      }

      if FProcessorInfo[i].RAWProcessorInformation.L1CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.RAWCacheInformation.Header.Handle=FProcessorInfo[i].RAWProcessorInformation.L1CacheHandle then
            FProcessorInfo[i].L1Chache:=LCacheInfo;

      if FProcessorInfo[i].RAWProcessorInformation.L2CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.RAWCacheInformation.Header.Handle=FProcessorInfo[i].RAWProcessorInformation.L2CacheHandle then
            FProcessorInfo[i].L2Chache:=LCacheInfo;

      if FProcessorInfo[i].RAWProcessorInformation.L3CacheHandle>0 then
        for LCacheInfo in FCacheInfo do
          if LCacheInfo.RAWCacheInformation.Header.Handle=FProcessorInfo[i].RAWProcessorInformation.L3CacheHandle then
            FProcessorInfo[i].L3Chache:=LCacheInfo;

      Inc(i);
    end;
  until (LIndex=-1);


  SetLength(FPortConnectorInfo, GetSMBiosTableEntries(PortConnectorInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(PortConnectorInformation, LIndex);
    if LIndex >= 0 then
    begin
      FPortConnectorInfo[i]:=TPortConnectorInformation.Create;
      FPortConnectorInfo[i].RAWPortConnectorInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FSystemSlotInfo, GetSMBiosTableEntries(SystemSlotsInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(SystemSlotsInformation, LIndex);
    if LIndex >= 0 then
    begin
      FSystemSlotInfo[i]:=TSystemSlotInformation.Create;
      FSystemSlotInfo[i].RAWSystemSlotInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
      Inc(i);
    end;
  until (LIndex=-1);

  SetLength(FBIOSLanguageInfo, GetSMBiosTableEntries(BIOSLanguageInformation));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(BIOSLanguageInformation, LIndex);
    if LIndex >= 0 then
    begin
      FBIOSLanguageInfo[i]:=TBIOSLanguageInformation.Create;
      FBIOSLanguageInfo[i].RAWBIOSLanguageInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
      Inc(i);
    end;
  until (LIndex=-1);


  SetLength(FSystemConfInfo, GetSMBiosTableEntries(SystemConfigurationOptions));
  i:=0;
  LIndex:=0;
  repeat
    LIndex := GetSMBiosTableNextIndex(SystemConfigurationOptions, LIndex);
    if LIndex >= 0 then
    begin
      FSystemConfInfo[i]:=TSystemConfInformation.Create;
      FSystemConfInfo[i].RAWSystemConfInformation:=@RawSMBIOSData.SMBIOSTableData[LIndex];
      Inc(i);
    end;
  until (LIndex=-1);
end;


{ TEnclosureInformation }

function TEnclosureInformation.AssetTagNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation.Header.Length, RAWEnclosureInformation.AssetTagNumber);
end;

function TEnclosureInformation.BootUpStateStr: AnsiString;
begin
 case RAWEnclosureInformation.BootUpState of
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

function TEnclosureInformation.ManufacturerStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation.Header.Length, RAWEnclosureInformation.Manufacturer);
end;

function TEnclosureInformation.PowerSupplyStateStr: AnsiString;
begin
 case RAWEnclosureInformation.PowerSupplyState of
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

function TEnclosureInformation.SerialNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation.Header.Length, RAWEnclosureInformation.SerialNumber);
end;

function TEnclosureInformation.TypeStr: AnsiString;
var
  _Type : Byte;
begin
   _Type:=RAWEnclosureInformation.&Type;
  if GetBit(_Type, 7) then  _Type:=EnableBit(RAWEnclosureInformation.&Type,7, False);

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

function TEnclosureInformation.VersionStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation.Header.Length, RAWEnclosureInformation.Version);
end;

{ TProcessorInformation }

function TProcessorInformation.AssetTagStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.AssetTag);
end;

function TProcessorInformation.GetProcessorVoltaje: Double;
var
  _Voltaje : Byte;
begin
  Result:=0;
   _Voltaje:=RAWProcessorInformation.Voltaje;
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

function TProcessorInformation.PartNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.PartNumber);
end;

function TProcessorInformation.ProcessorFamilyStr: AnsiString;
begin
   if RAWProcessorInformation.ProcessorFamily2<$FF then
   case RAWProcessorInformation.ProcessorFamily of
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
   case RAWProcessorInformation.ProcessorFamily2 of
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

function TProcessorInformation.ProcessorManufacturerStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.ProcessorManufacturer);
end;

function TProcessorInformation.ProcessorTypeStr: AnsiString;
begin
   case RAWProcessorInformation.ProcessorType of
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

function TProcessorInformation.ProcessorUpgradeStr: AnsiString;
begin
  case RAWProcessorInformation.ProcessorUpgrade of
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

function TProcessorInformation.ProcessorVersionStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.ProcessorVersion);
end;

function TProcessorInformation.SerialNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.SerialNumber);
end;

function TProcessorInformation.SocketDesignationStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation.Header.Length, RAWProcessorInformation.SocketDesignation);
end;

{ TCacheInformation }

function TCacheInformation.AssociativityStr: AnsiString;
begin
  case RAWCacheInformation.Associativity of
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

function TCacheInformation.GetCurrentSRAMType: TCacheSRAMTypes;
var
  i: integer;
begin
   Result:=[];
   for i := 0 to 6 do
    if GetBit(RAWCacheInformation.CurrentSRAMType, i) then
       Include(Result,  TCacheSRAMType(i));
end;

function TCacheInformation.GetErrorCorrectionType: TErrorCorrectionType;
begin
  if RAWCacheInformation.ErrorCorrectionType>6 then
   Result:=ECUnknown
  else
   Result:=TErrorCorrectionType(RAWCacheInformation.ErrorCorrectionType);
end;

function TCacheInformation.GetInstalledCacheSize: Integer;
var
  Granularity : DWORD;
begin
   Granularity:=1;
   if GetBit(RAWCacheInformation.InstalledSize, 15) then
     Granularity:=64;

  Result:=Granularity*EnableBit(RAWCacheInformation.InstalledSize, 15, false);
end;

function TCacheInformation.GetMaximumCacheSize: Integer;
var
  Granularity : DWORD;
begin
   Granularity:=1;
   if GetBit(RAWCacheInformation.MaximumCacheSize, 15) then
     Granularity:=64;

  Result:=Granularity*EnableBit(RAWCacheInformation.MaximumCacheSize, 15, false);
end;

function TCacheInformation.GetSupportedSRAMType: TCacheSRAMTypes;
var
  i: integer;
begin
   Result:=[];
   for i := 0 to 6 do
    if GetBit(RAWCacheInformation.SupportedSRAMType, i) then
       Include(Result,  TCacheSRAMType(i));
end;

function TCacheInformation.GetSystemCacheType: TSystemCacheType;
begin
  if RAWCacheInformation.SystemCacheType>5 then
   Result:=SCUnknown
  else
   Result:=TSystemCacheType(RAWCacheInformation.SystemCacheType);
end;

function TCacheInformation.SocketDesignationStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWCacheInformation^, RAWCacheInformation.Header.Length, RAWCacheInformation.SocketDesignation);
end;

{ TPortConnectorInformation }

function TPortConnectorInformation.ExternalReferenceDesignatorStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWPortConnectorInformation^, RAWPortConnectorInformation.Header.Length, RAWPortConnectorInformation.ExternalReferenceDesignator);
end;

function TPortConnectorInformation.GetConnectorType(Connector: Byte): AnsiString;
begin
  case Connector of
    $00 : Result:='None';
    $01 : Result:='Centronics';
    $02 : Result:='Mini Centronics';
    $03 : Result:='Proprietary';
    $04 : Result:='DB-25 pin male';
    $05 : Result:='DB-25 pin female';
    $06 : Result:='DB-15 pin male';
    $07 : Result:='DB-15 pin female';
    $08 : Result:='DB-9 pin male';
    $09 : Result:='DB-9 pin female';
    $0A : Result:='RJ-11';
    $0B : Result:='RJ-45';
    $0C : Result:='50-pin MiniSCSI';
    $0D : Result:='Mini-DIN';
    $0E : Result:='Micro-DIN';
    $0F : Result:='PS/2';
    $10 : Result:='Infrared';
    $11 : Result:='HP-HIL';
    $12 : Result:='Access Bus (USB)';
    $13 : Result:='SSA SCSI';
    $14 : Result:='Circular DIN-8 male';
    $15 : Result:='Circular DIN-8 female';
    $16 : Result:='On Board IDE';
    $17 : Result:='On Board Floppy';
    $18 : Result:='9-pin Dual Inline (pin 10 cut)';
    $19 : Result:='25-pin Dual Inline (pin 26 cut)';
    $1A : Result:='50-pin Dual Inline';
    $1B : Result:='68-pin Dual Inline';
    $1C : Result:='On Board Sound Input from CD-ROM';
    $1D : Result:='Mini-Centronics Type-14';
    $1E : Result:='Mini-Centronics Type-26';
    $1F : Result:='Mini-jack (headphones)';
    $20 : Result:='BNC';
    $21 : Result:='1394';
    $22 : Result:='SAS/SATA Plug Receptacle';
    $A0 : Result:='PC-98';
    $A1 : Result:='PC-98Hireso';
    $A2 : Result:='PC-H98';
    $A3 : Result:='PC-98Note';
    $A4 : Result:='PC-98Full';
    $FF : Result:='Other – Use Reference Designator Strings to supply information'
    else
    Result:='Unknown';
  end;
end;

function TPortConnectorInformation.InternalReferenceDesignatorStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWPortConnectorInformation^, RAWPortConnectorInformation.Header.Length, RAWPortConnectorInformation.InternalReferenceDesignator);
end;

function TPortConnectorInformation.PortTypeStr: AnsiString;
begin
  case RAWPortConnectorInformation.PortType of
    $00 :Result:='None';
    $01 :Result:='Parallel Port XT/AT Compatible';
    $02 :Result:='Parallel Port PS/2';
    $03 :Result:='Parallel Port ECP';
    $04 :Result:='Parallel Port EPP';
    $05 :Result:='Parallel Port ECP/EPP';
    $06 :Result:='Serial Port XT/AT Compatible';
    $07 :Result:='Serial Port 16450 Compatible';
    $08 :Result:='Serial Port 16550 Compatible';
    $09 :Result:='Serial Port 16550A Compatible';
    $0A :Result:='SCSI Port';
    $0B :Result:='MIDI Port';
    $0C :Result:='Joy Stick Port';
    $0D :Result:='Keyboard Port';
    $0E :Result:='Mouse Port';
    $0F :Result:='SSA SCSI';
    $10 :Result:='USB';
    $11 :Result:='FireWire (IEEE P1394)';
    $12 :Result:='PCMCIA Type I2';
    $13 :Result:='PCMCIA Type II';
    $14 :Result:='PCMCIA Type III';
    $15 :Result:='Cardbus';
    $16 :Result:='Access Bus Port';
    $17 :Result:='SCSI II';
    $18 :Result:='SCSI Wide';
    $19 :Result:='PC-98';
    $1A :Result:='PC-98-Hireso';
    $1B :Result:='PC-H98';
    $1C :Result:='Video Port';
    $1D :Result:='Audio Port';
    $1E :Result:='Modem Port';
    $1F :Result:='Network Port';
    $20 :Result:='SATA';
    $21 :Result:='SAS';
    $A0 :Result:='8251 Compatible';
    $A1 :Result:='8251 FIFO Compatible';
    $FF :Result:='Other'
    else
    Result:='Unknown';
  end;
end;

{ TSystemSlotInformation }

function TSystemSlotInformation.GetCurrentUsage: AnsiString;
begin
  case RAWSystemSlotInformation.CurrentUsage of
    $01 :Result:='Other';
    $02 :Result:='Unknown';
    $03 :Result:='Available';
    $04 :Result:='In use';
  else
    Result:='Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotDataBusWidth: AnsiString;
begin
  case RAWSystemSlotInformation.SlotDataBusWidth of
    $01 :Result:='Other';
    $02 :Result:='Unknown';
    $03 :Result:='8 bit';
    $04 :Result:='16 bit';
    $05 :Result:='32 bit';
    $06 :Result:='64 bit';
    $07 :Result:='128 bit';
    $08 :Result:='1x or x1';
    $09 :Result:='2x or x2';
    $0A :Result:='4x or x4';
    $0B :Result:='8x or x8';
    $0C :Result:='12x or x12';
    $0D :Result:='16x or x16';
    $0E :Result:='32x or x32'
  else
    Result:='Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotLength: AnsiString;
begin
  case RAWSystemSlotInformation.SlotLength of
    $01 :Result:='Other';
    $02 :Result:='Unknown';
    $03 :Result:='Short Length';
    $04 :Result:='Long Length'
  else
    Result:='Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotType: AnsiString;
begin
  case RAWSystemSlotInformation.SlotType of
    $01 :Result:='Other';
    $02 :Result:='Unknown';
    $03 :Result:='ISA';
    $04 :Result:='MCA';
    $05 :Result:='EISA';
    $06 :Result:='PCI';
    $07 :Result:='PC Card (PCMCIA)';
    $08 :Result:='VL-VESA';
    $09 :Result:='Proprietary';
    $0A :Result:='Processor Card Slot';
    $0B :Result:='Proprietary Memory Card Slot';
    $0C :Result:='I/O Riser Card Slot';
    $0D :Result:='NuBus';
    $0E :Result:='PCI – 66MHz Capable';
    $0F :Result:='AGP';
    $10 :Result:='AGP 2X';
    $11 :Result:='AGP 4X';
    $12 :Result:='PCI-X';
    $13 :Result:='AGP 8X';
    $A0 :Result:='PC-98/C20';
    $A1 :Result:='PC-98/C24';
    $A2 :Result:='PC-98/E';
    $A3 :Result:='PC-98/Local Bus';
    $A4 :Result:='PC-98/Card';
    $A5 :Result:='PCI Express';
    $A6 :Result:='PCI Express x1';
    $A7 :Result:='PCI Express x2';
    $A8 :Result:='PCI Express x4';
    $A9 :Result:='PCI Express x8';
    $AA :Result:='PCI Express x16';
    $AB :Result:='PCI Express Gen 2';
    $AC :Result:='PCI Express Gen 2 x1';
    $AD :Result:='PCI Express Gen 2 x2';
    $AE :Result:='PCI Express Gen 2 x4';
    $AF :Result:='PCI Express Gen 2 x8';
    $B0 :Result:='PCI Express Gen 2 x16';
    $B1 :Result:='PCI Express Gen 3';
    $B2 :Result:='PCI Express Gen 3 x1';
    $B3 :Result:='PCI Express Gen 3 x2';
    $B4 :Result:='PCI Express Gen 3 x4';
    $B5 :Result:='PCI Express Gen 3 x8';
    $B6 :Result:='PCI Express Gen 3 x16'
  else
    Result:='Unknown';
  end;
end;

function TSystemSlotInformation.SlotDesignationStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemSlotInformation^, RAWSystemSlotInformation.Header.Length, RAWSystemSlotInformation.SlotDesignation);
end;


{ TBIOSLanguageInformation }

function TBIOSLanguageInformation.GetCurrentLanguageStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBIOSLanguageInformation^, RAWBIOSLanguageInformation.Header.Length, RAWBIOSLanguageInformation.CurrentLanguage);
end;

function TBIOSLanguageInformation.GetLanguageString(index: Integer): AnsiString;
begin
  Result:= GetSMBiosString(@RAWBIOSLanguageInformation^, RAWBIOSLanguageInformation.Header.Length, index);
end;

{ TBiosInformation }

function TBiosInformation.ReleaseDateStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation.Header.Length, RAWBiosInformation.ReleaseDate);
end;

function TBiosInformation.VendorStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation.Header.Length, RAWBiosInformation.Vendor);
end;

function TBiosInformation.VersionStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation.Header.Length, RAWBiosInformation.Version);
end;

{ TSystemInformation }

function TSystemInformation.FamilyStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.Family);
end;

function TSystemInformation.ManufacturerStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.Manufacturer);
end;

function TSystemInformation.ProductNameStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.ProductName);
end;

function TSystemInformation.SerialNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.SerialNumber);
end;

function TSystemInformation.SKUNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.SKUNumber);
end;

function TSystemInformation.VersionStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation.Header.Length, RAWSystemInformation.Version);
end;

{ TOEMStringsInformation }

function TOEMStringsInformation.GetOEMString(index: Integer): AnsiString;
begin
  Result:= GetSMBiosString(@RAWOEMStringsInformation^, RAWOEMStringsInformation.Header.Length, index);
end;

{ TBaseBoardInformation }

function TBaseBoardInformation.AssetTagStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.AssetTag);
end;

function TBaseBoardInformation.BoardTypeStr: AnsiString;
begin
   case RAWBaseBoardInformation.BoardType of
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


function TBaseBoardInformation.LocationinChassisStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.LocationinChassis);
end;

function TBaseBoardInformation.ManufacturerStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.Manufacturer);
end;

function TBaseBoardInformation.ProductStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.Product);
end;

function TBaseBoardInformation.SerialNumberStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.SerialNumber);
end;

function TBaseBoardInformation.VersionStr: AnsiString;
begin
  Result:= GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation.Header.Length, RAWBaseBoardInformation.Version);
end;

{ TSystemConfInformation }

function TSystemConfInformation.GetConfString(index: Integer): AnsiString;
begin
  Result:= GetSMBiosString(@RAWSystemConfInformation^, RAWSystemConfInformation.Header.Length,index);

end;

{$IFDEF USEWMI}
initialization
  CoInitialize(nil);
{$ENDIF}


{$IFDEF USEWMI}
finalization
  CoUninitialize;
{$ENDIF}

end.
