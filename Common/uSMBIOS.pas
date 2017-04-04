// **************************************************************************************************
//
// Unit uSMBIOS
// unit for the TSMBIOS Project https://github.com/RRUZ/tsmbios
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is uSMBIOS.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2012-2017 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************
unit uSMBIOS;

interface

{$IFDEF FPC}
  {$DEFINE NOGENERICS}
  {$MODE objfpc}
{$ELSE}
  {$IFDEF LINUX}
    {$DEFINE UNIX}
  {$ENDIF}

  {$IFDEF VER130}
    {$DEFINE NOGENERICS}
  {$ELSE}
    {$IF CompilerVersion < 20} {$DEFINE NOGENERICS}  {$IFEND}
  {$ENDIF}
{$ENDIF}

{$IFNDEF FPC}
  {$IFDEF VER130}
    {$DEFINE OLDDELPHI}
    {$DEFINE MSWINDOWS}
  {$ELSE}
    {$IF CompilerVersion < 16}
     {$DEFINE OLDDELPHI}
    {$IFEND}
  {$ENDIF}
{$ENDIF}

uses
 SysUtils,
 {$IFDEF MSWINDOWS}
 Windows,
 {$ENDIF}
 {$IFNDEF NOGENERICS}
 Generics.Collections,
 {$ENDIF}
 {$IFDEF UNIX}
  {$IFDEF FPC}
    BaseUnix,
  {$ELSE}
    Posix.Unistd,
  {$ENDIF}
 {$ENDIF}
 {$IFDEF MACOS}
  System.Types,
 {$ENDIF MACOS}
  Classes;

{$DEFINE USEWMI}

type
  // TODO :
  // Add OSX support
  // Add old Delphi versions support

{$IFDEF VER130}
  DWORD = Cardinal;
{$ENDIF}

{$IFDEF LINUX}
  DWORD = FixedUInt;
  AnsiString = String;
{$ENDIF}
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
    BIOSInformation,
    SystemInformation,
    BaseBoardInformation,
    EnclosureInformation,
    ProcessorInformation,
    MemoryControllerInformation,
    // Obsolete starting with version 2.1
    MemoryModuleInformation, // Obsolete starting with version 2.1
    CacheInformation,
    PortConnectorInformation,
    SystemSlotsInformation,
    OnBoardDevicesInformation, // This structure is obsolete starting with version 2.6
    OEMStrings,
    SystemConfigurationOptions,
    BIOSLanguageInformation,
    GroupAssociations,
    SystemEventLog, PhysicalMemoryArray, MemoryDevice,
    MemoryErrorInformation, MemoryArrayMappedAddress, MemoryDeviceMappedAddress, BuiltinPointingDevice, PortableBattery, SystemReset, HardwareSecurity,
    SystemPowerControls,
    VoltageProbe, CoolingDevice, TemperatureProbe, ElectricalCurrentProbe, OutofBandRemoteAccess, BootIntegrityServicesEntryPoint,
    SystemBootInformation, x64BitMemoryErrorInformation, ManagementDevice, ManagementDeviceComponent, ManagementDeviceThresholdData, MemoryChannel,
    IPMIDeviceInformation, SystemPowerSupply, AdditionalInformation, OnboardDevicesExtendedInformation, ManagementControllerHostInterface, SMBIOSTable43,
    SMBIOSTable44, SMBIOSTable45, SMBIOSTable46, SMBIOSTable47, SMBIOSTable48, SMBIOSTable49, SMBIOSTable50, SMBIOSTable51, SMBIOSTable52, SMBIOSTable53,
    SMBIOSTable54, SMBIOSTable55, SMBIOSTable56, SMBIOSTable57, SMBIOSTable58, SMBIOSTable59, SMBIOSTable60, SMBIOSTable61, SMBIOSTable62, SMBIOSTable63,
    SMBIOSTable64, SMBIOSTable65, SMBIOSTable66, SMBIOSTable67, SMBIOSTable68, SMBIOSTable69, SMBIOSTable70, SMBIOSTable71, SMBIOSTable72, SMBIOSTable73,
    SMBIOSTable74, SMBIOSTable75, SMBIOSTable76, SMBIOSTable77, SMBIOSTable78, SMBIOSTable79, SMBIOSTable80, SMBIOSTable81, SMBIOSTable82, SMBIOSTable83,
    SMBIOSTable84, SMBIOSTable85, SMBIOSTable86, SMBIOSTable87, SMBIOSTable88, SMBIOSTable89, SMBIOSTable90, SMBIOSTable91, SMBIOSTable92, SMBIOSTable93,
    SMBIOSTable94, SMBIOSTable95, SMBIOSTable96, SMBIOSTable97, SMBIOSTable98, SMBIOSTable99, SMBIOSTable100, SMBIOSTable101, SMBIOSTable102, SMBIOSTable103,
    SMBIOSTable104, SMBIOSTable105, SMBIOSTable106, SMBIOSTable107, SMBIOSTable108, SMBIOSTable109, SMBIOSTable110, SMBIOSTable111, SMBIOSTable112,
    SMBIOSTable113, SMBIOSTable114, SMBIOSTable115, SMBIOSTable116, SMBIOSTable117, SMBIOSTable118, SMBIOSTable119, SMBIOSTable120, SMBIOSTable121,
    SMBIOSTable122, SMBIOSTable123, SMBIOSTable124, SMBIOSTable125, Inactive, // 126
    EndofTable);

const
  SMBiosTablesDescr : array [Byte] of AnsiString = ('BIOS Information', 'System Information', 'BaseBoard Information', 'Enclosure Information',
    'Processor Information', 'Memory Controller Information', 'Memory Module Information', 'Cache Information', 'Port Connector Information',
    'System Slots Information', 'OnBoard Devices Information', 'OEM Strings', 'System Configuration Options', 'BIOS Language Information', 'Group Associations',
    'System Event Log', 'Physical Memory Array', 'Memory Device', 'Memory Error Information', 'Memory Array Mapped Address', 'Memory Device Mapped Address',
    'Builtin Pointing Device', 'Portable Battery', 'System Reset', 'Hardware Security', 'System Power Controls', 'Voltage Probe', 'Cooling Device',
    'Temperature Probe', 'Electrical Current Probe', 'Out-of-Band Remote Access', 'Boot Integrity Services (BIS) Entry Point', 'System Boot Information',
    '64-Bit Memory Error Information', 'Management Device', 'Management Device Component', 'Management Device Threshold Data', 'Memory Channel',
    'IPMI Device Information', 'System Power Supply', 'Additional Information', 'Onboard Devices Extended Information', 'Management Controller Host Interface',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Inactive', 'End of Table', // 127
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported', 'Not Supported',
    'Not Supported', 'Not Supported');

type
  TSmBiosTableHeader = packed record
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    TableType : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Length : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Handle : Word;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// BIOS Information structure
  /// </summary>
  { $ENDREGION }
  TBiosInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number of the BIOS Vendors Name.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Vendor : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number of the BIOS Version. This is a freeform string that may
    /// contain Core and OEM version information.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Version : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Segment location of BIOS starting address (for example, 0E800h).
    /// NOTE: The size of the runtime BIOS image can be computed by
    /// subtracting the Starting Address Segment from 10000h and multiplying
    /// the result by 16.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    StartingSegment : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number of the BIOS release date. The date string, if supplied,
    /// is in either mm/dd/yy or mm/dd/yyyy format. If the year portion of
    /// the string is two digits, the year is assumed to be 19yy. NOTE: The
    /// mm/dd/yyyy format is required for SMBIOS version 2.3 and later.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ReleaseDate : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Size (n) where 64K * (n+1) is the size of the physical device
    /// containing the BIOS, in bytes
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    BiosRomSize : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Defines which functions the BIOS supports: PCI, PCMCIA, Flash, etc.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Characteristics : Int64;
    { $REGION 'Documentation' }
    /// <summary>
    /// Optional space reserved for future supported functions. The number of
    /// Extension Bytes that are present is indicated by the Length in offset
    /// 1 minus 12h.For version 2.4 and later implementations, two BIOS
    /// Characteristics Extension Bytes are defined (12-13h) and bytes 14-
    /// 17h are also defined
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ExtensionBytes : array [0 .. 1] of Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the major release of the System BIOS; for example, the
    /// value is 0Ah for revision 10.22 and 02h for revision 2.1. This field
    /// and/or the System BIOS Minor Release field is updated each time a
    /// System BIOS update for a given system is released. If the system does
    /// not support the use of this field, the value is 0FFh for both this
    /// field and the System BIOS Minor Release field.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SystemBIOSMajorRelease : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the minor release of the System BIOS; for example, the
    /// value is 16h for revision 10.22 and 01h for revision 2.1.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SystemBIOSMinorRelease : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the major release of the embedded controller firmware; for
    /// example, the value would be 0Ah for revision 10.22 and 02h for
    /// revision 2.1. This field and/or the Embedded Controller Firmware
    /// Minor Release field is updated each time an embedded controller
    /// firmware update for a given system is released. If the system does
    /// not have field upgradeable embedded controller firmware, the value is
    /// 0FFh.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    EmbeddedControllerFirmwareMajorRelease : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the minor release of the embedded controller firmware; for
    /// example, the value is 16h for revision 10.22 and 01h for revision
    /// 2.1. If the system does not have field upgradeable embedded
    /// controller firmware, the value is 0FFh.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    EmbeddedControllerFirmwareMinorRelease : Byte;
  end;

  TBiosInformation = class
    public
      RAWBiosInformation : ^TBiosInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Vendor field
      /// </summary>
      { $ENDREGION }
      function VendorStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Version field
      /// </summary>
      { $ENDREGION }
      function VersionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ReleaseDate field
      /// </summary>
      { $ENDREGION }
      function ReleaseDateStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines attributes of the overall
  /// system and is intended to be associated with the Component ID group of
  /// the systems MIF. An SMBIOS implementation is associated with a single
  /// system instance and contains one and only one System Information (Type
  /// 1) structure.
  /// </summary>
  { $ENDREGION }
  TSysInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Manufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProductName : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Version : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Universal Unique ID number, A UUID is an identifier that is designed
    /// to be unique across both time and space. It requires no central
    /// registration process. The UUID is 128 bits long. Its format is
    /// described in RFC 4122, but the actual field contents are opaque and
    /// not significant to the SMBIOS specification, which is only concerned
    /// with the byte order.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    UUID : array [0 .. 15] of Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the event that caused the system to power up.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    WakeUpType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string This text string is used to identify
    /// a particular computer configuration for sale. It is sometimes also
    /// called a product ID or purchase order number. This number is
    /// frequently found in existing fields, but there is no standard format.
    /// Typically for a given system board from a given OEM, there are tens
    /// of unique processor, memory, hard drive, and optical drive
    /// configurations.
    /// </summary>
    /// <remarks>
    /// 2.4+
    /// </remarks>
    { $ENDREGION }
    SKUNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string This text string is used to identify
    /// the family a particular computer belongs to. A family refers to a set
    /// of computers that are similar but not identical from a hardware or
    /// software point of view. Typically, a family is composed of different
    /// computer models, which have different configurations and pricing
    /// points. Computers in the same family often have similar branding and
    /// cosmetic features
    /// </summary>
    /// <remarks>
    /// 2.4+
    /// </remarks>
    { $ENDREGION }
    Family : Byte;
  end;

  TSystemInformation = class
    public
      RAWSystemInformation : ^TSysInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Manufacturer field
      /// </summary>
      { $ENDREGION }
      function ManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ProductName field
      /// </summary>
      { $ENDREGION }
      function ProductNameStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Version field
      /// </summary>
      { $ENDREGION }
      function VersionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field
      /// </summary>
      { $ENDREGION }
      function SerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SKUNumber field
      /// </summary>
      { $ENDREGION }
      function SKUNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Family field
      /// </summary>
      { $ENDREGION }
      function FamilyStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// the information in this structure defines attributes of a system
  /// baseboard (for  example, a motherboard, planar, server blade, or other
  /// standard system module). 850 NOTE: If more than one Type 2 structure is
  /// provided by an SMBIOS implementation, each structure shall include the
  /// Number of Contained Object Handles and Contained Object Handles fields
  /// to specify which system elements are  contained on which boards. If a
  /// single Type 2 structure is provided and the contained object
  /// information is not  present1, or if no Type 2 structure is provided,
  /// then all system elements identified by the SMBIOS implementation are
  /// associated with a single motherboard.
  /// </summary>
  { $ENDREGION }
  TBaseBoardInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Manufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Product : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Version : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of a null-terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    AssetTag : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// A collection of flags that identify features of this baseboard.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    FeatureFlags : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Number of a null-terminated string that describes this board's
    /// location within the chassis referenced by the Chassis Handle
    /// </para>
    /// <para>
    ///
    /// <b>NOTE: This field supports a CIM_Container class mapping where:</b>
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// LocationWithinContainer is this field.
    /// </item>
    /// <item>
    /// GroupComponent is the chassis referenced by Chassis Handle.
    /// </item>
    /// <item>
    /// PartComponent is this baseboard.
    /// </item>
    /// </list>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    LocationinChassis : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with the chassis in which
    /// this board resides
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ChassisHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the type of board
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    BoardType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the number (0 to 255) of Contained Object Handles that
    /// follow
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    NumberofContainedObjectHandles : Byte;
    // ContainedObjectHandles :  Array of Word;
  end;

  TBaseBoardInformation = class
    public
      RAWBaseBoardInformation : ^TBaseBoardInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the BoardType field
      /// </summary>
      { $ENDREGION }
      function BoardTypeStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Manufacturer field
      /// </summary>
      { $ENDREGION }
      function ManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Product field
      /// </summary>
      { $ENDREGION }
      function ProductStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Version field
      /// </summary>
      { $ENDREGION }
      function VersionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field
      /// </summary>
      { $ENDREGION }
      function SerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the AssetTag field
      /// </summary>
      { $ENDREGION }
      function AssetTagStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the LocationinChassis field
      /// </summary>
      { $ENDREGION }
      function LocationinChassisStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines attributes of the systems
  /// mechanical enclosure(s). For example, if a system included a separate
  /// enclosure for its peripheral devices, two structures would be returned:
  /// one for the main system enclosure and the second for the peripheral
  /// device enclosure. The additions to this structure in version 2.1 of
  /// this specification support the population of the CIM_Chassis class.
  /// </summary>
  { $ENDREGION }
  TEnclosureInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Manufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Bit 7 Chassis lock is present if 1. Otherwise, either a lock is not
    /// present or it is unknown if the enclosure has a lock. Bits 6:0
    /// Enumeration value.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    _Type : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Version : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of Null terminated string
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    AssetTagNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the state of the enclosure when it was last booted.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    BootUpState : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the state of the enclosures power supply (or supplies)
    /// when last booted.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    PowerSupplyState : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the enclosures thermal state when last booted.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    ThermalState : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the enclosures physical security status when last booted.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    SecurityStatus : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    OEM_Defined : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The height of the enclosure, in 'U's. A U is a standard unit of
    /// measure for the height of a rack or rack-mountable component and is
    /// equal to 1.75 inches or 4.445 cm. A value of 00h indicates that the
    /// enclosure height is unspecified.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    Height : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the number of power cords associated with the enclosure or
    /// chassis. A value of 00h indicates that the number is unspecified.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    NumberofPowerCords : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the number of Contained Element records that follow, in
    /// the range 0 to 255. Each Contained Element group comprises m bytes,
    /// as specified by the Contained Element Record Length field that
    /// follows. If no Contained Elements are included, this field is set to
    /// 0.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    ContainedElementCount : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the byte length of each Contained Element record that
    /// follows, in the range 0 to 255. If no Contained Elements are
    /// included, this field is set to 0. For version 2.3.2 and later of this
    /// specification, this field is set to at least 03h when Contained
    /// Elements are specified.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    ContainedElementRecordLength : Byte;
    // TODO Extension to support complex data representation
    // ContainedElements  n * m BYTEs
    // SKUNumber : Byte;     *******Added in SMBIOS 2.7*********
  end;

  TEnclosureInformation = class
    public
      RAWEnclosureInformation : ^TEnclosureInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Manufacturer field
      /// </summary>
      { $ENDREGION }
      function ManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Version field
      /// </summary>
      { $ENDREGION }
      function VersionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field
      /// </summary>
      { $ENDREGION }
      function SerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the AssetTagNumber field
      /// </summary>
      { $ENDREGION }
      function AssetTagNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Type field
      /// </summary>
      { $ENDREGION }
      function TypeStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the BootUpState field
      /// </summary>
      { $ENDREGION }
      function BootUpStateStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the PowerSupplyState field
      /// </summary>
      { $ENDREGION }
      function PowerSupplyStateStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines the attributes of the
  /// system’s memory controller(s) and the supported attributes of any
  /// memory-modules present in the sockets controlled by this controller.
  /// </summary>
  { $ENDREGION }
  TMemoryControllerInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// ENUM
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ErrorDetectingMethod : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Bit Field
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ErrorCorrectingCapability : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// ENUM
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    SupportedInterleave : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// ENUM
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    CurrentInterleave : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Size of the largest memory module supported (per slot), specified as
    /// n, where 2**n is the maximum size in MB The maximum amount of memory
    /// supported by this controller is that value times the number of slots,
    /// as specified in offset 0Eh of this structure.
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    MaximumMemoryModuleSize : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Bit Field
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SupportedSpeeds : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Bit Field
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SupportedMemoryTypes : Word;

    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Describes the required voltages for each of the memory module
    /// sockets controlled by this controller:
    /// </para>
    /// <para>
    /// Bits 7:3 Reserved, must be zero
    /// </para>
    /// <para>
    /// Bit 2     2.9V
    /// </para>
    /// <para>
    /// Bit 1     3.3V
    /// </para>
    /// <para>
    /// Bit 0     5V
    /// </para>
    /// <para>
    /// NOTE: Setting of multiple bits indicates that the sockets are
    /// configurable.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    MemoryModuleVoltage : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Defines how many of the Memory Module Information blocks are
    /// controlled by this controller
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    NumberofAssociatedMemorySlots : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Lists memory information structure handles controlled by this
    /// controller
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    MemoryModuleConfigurationHandles : Word;

    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the error-correcting capabilities that were enabled when
    /// the structure was built
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    EnabledErrorCorrectingCapabilities : Byte;
  end;

  TMemoryControllerInformation = class
    public
      RAWMemoryControllerInformation : ^TMemoryControllerInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Error Detecting Method field
      /// </summary>
      { $ENDREGION }
      function GetErrorDetectingMethodDescr : string;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Supported Interleave field
      /// </summary>
      { $ENDREGION }
      function GetSupportedInterleaveDescr : string;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Current Interleave field
      /// </summary>
      { $ENDREGION }
      function GetCurrentInterleaveDescr : string;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// One Memory Module Information structure is included for each
  /// memory-module socket in the system. The structure describes the speed,
  /// type, size, and error status of each system memory module. The
  /// supported attributes of each module are described by the “owning”
  /// Memory Controller Information structure.
  /// </summary>
  { $ENDREGION }
  TMemoryModuleInfo = packed record
    Header : TSmBiosTableHeader;

    { $REGION 'Documentation' }
    /// <summary>
    /// String number for reference designation EXAMPLE: ‘J202’,0
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SocketDesignation : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Each nibble indicates a bank (RAS#) connection; 0xF means no
    /// connection.
    /// </para>
    /// <para>
    /// EXAMPLE: If banks 1 &amp; 3 (RAS# 1 &amp; 3) were connected to a
    /// SIMM socket the byte for that socket would be 13h. If only bank 2
    /// (RAS 2) were connected, the byte for that socket would be 2Fh.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    BankConnections : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// Speed of the memory module, in ns (for example, 70d for a 70ns
    /// module) If the speed is unknown, the field is set to 0.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentSpeed : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// This field describes the physical characteristics of the memory
    /// modules that are supported by (and currently installed in) the system
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentMemoryType : Word;

    { $REGION 'Documentation' }
    /// <summary>
    /// The Installed Size fields identify the size of the memory module that
    /// is installed in the socket, as determined by reading and correlating
    /// the module’s presence-detect information. If the system does not
    /// support presence-detect mechanisms, the Installed Size field is set
    /// to 7Dh to indicate that the installed size is not determinable.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    InstalledSize : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// The Enabled Size field identifies the amount of memory currently
    /// enabled for the system’s use from the module. If a module is known to
    /// be installed in a connector, but all memory in the module has been
    /// disabled due to error, the Enabled Size field is set to 7Eh.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    EnabledSize : Byte;

    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bits 7:3 Reserved, set to 0s
    /// </para>
    /// <para>
    /// Bit 2 If set, the Error Status information should be obtained from
    /// the event log; bits 1 and 0 are reserved.
    /// </para>
    /// <para>
    /// Bit 1 Correctable errors received for the module, if set. This bit
    /// is reset only during a system reset.
    /// </para>
    /// <para>
    /// Bit 0 Uncorrectable errors received for the module, if set. All or
    /// a portion of the module has been disabled. This bit is only reset
    /// on power-on.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ErrorStatus : Byte;
  end;

  TMemoryModuleInformation = class
    RAWMemoryModuleInformation : ^TMemoryModuleInfo;
    { $REGION 'Documentation' }
    /// <summary>
    /// Get the string representation of the SocketDesignation field
    /// </summary>
    { $ENDREGION }
    function GetSocketDesignationDescr : AnsiString;
  end;

  TCacheSRAMType = (SROther, SRUnknown, SRNon_Burst, SRBurst, SRPipelineBurst, SRSynchronous, SRAsynchronous);

  TCacheSRAMTypes = set of TCacheSRAMType;

  TErrorCorrectionType = (ECFiller, ECOther, ECUnknown, ECNone, ECParity, ECSingle_bitECC, ECMulti_bitECC);

Const
  ErrorCorrectionTypeStr : Array [TErrorCorrectionType] of String = ('Filler', 'Other', 'Unknown', 'None', 'Parity', 'Single bit ECC', 'Multi bit ECC');

type

  TSystemCacheType = (SCFiller, SCOther, SCUnknown, SCInstruction, SCData, SCUnified);

Const
  SystemCacheTypeStr : Array [TSystemCacheType] of String = ('Filler', 'Other', 'Unknown', 'Instruction', 'Data', 'Unified');

type
  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines the attributes of CPU cache
  /// device in the system. One structure is specified for each such device,
  /// whether the device is internal to or external to the CPU module. Cache
  /// modules can be associated with a processor structure in one or two
  /// ways depending on the SMBIOS version.
  /// </summary>
  { $ENDREGION }
  TCacheInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String Number for Reference Designation EXAMPLE: CACHE1, 0
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SocketDesignation : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bits 15:10 Reserved, must be zero
    /// </para>
    /// <para>
    /// Bits 9:8 Operational Mode
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 00b Write Through
    /// </item>
    /// <item>
    /// 01b Write Back
    /// </item>
    /// <item>
    /// 10b Varies with Memory Address
    /// </item>
    /// <item>
    /// 11b Unknown
    /// </item>
    /// </list>
    /// <para>
    /// Bit 7 Enabled/Disabled (at boot time)
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 1b Enabled
    /// </item>
    /// <item>
    /// 0b Disabled
    /// </item>
    /// </list>
    /// <para>
    /// Bits 6:5 Location, relative to the CPU module:
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 00b Internal
    /// </item>
    /// <item>
    /// 01b External
    /// </item>
    /// <item>
    /// 10b Reserved
    /// </item>
    /// <item>
    /// 11b Unknown
    /// </item>
    /// </list>
    /// <para>
    /// Bit 4 Reserved, must be zero
    /// </para>
    /// <para>
    /// Bit 3 Cache Socketed
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 1b Socketed
    /// </item>
    /// <item>
    /// 0b Not Socketed
    /// </item>
    /// </list>
    /// <para>
    /// Bits 2:0 Cache Level  1 through 8 (For example, an L1 cache would
    /// use value 000b and an L3
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CacheConfiguration : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Maximum size that can be installed
    /// </para>
    /// <para>
    /// Bit 15 Granularity
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 0  1K granularity
    /// </item>
    /// <item>
    /// 1  64K granularity
    /// </item>
    /// </list>
    /// <para>
    /// Bits 14:0 Max size in given granularity
    /// </para>
    /// <para>
    /// For multi-core processors, the cache size for the different levels
    /// of the cache (L1, L2, L3) is the total amount of cache per level
    /// per processor socket. The cache size is independent of the core
    /// count. For example, the cache size is 2 MB for both a dual core
    /// processor with a 2 MB L3 cache shared between the cores and a dual
    /// core processor with 1 MB L3 cache (non-shared) per core.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    MaximumCacheSize : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Same format as Max Cache Size field; set to 0 if no cache is
    /// installed.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    InstalledSize : Word;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SupportedSRAMType : Word;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentSRAMType : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The cache module speed, in nanoseconds. The value is 0 if the speed
    /// is unknown.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    CacheSpeed : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The error-correction scheme supported by this cache component
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    ErrorCorrectionType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The logical type of cache
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    SystemCacheType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The associativity of the cache.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Associativity : Byte;
  end;

  TCacheInformation = class
    public
      RAWCacheInformation : ^TCacheInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the  SocketDesignation field
      /// </summary>
      { $ENDREGION }
      function SocketDesignationStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the calculated value of the MaximumCacheSize field
      /// </summary>
      { $ENDREGION }
      function GetMaximumCacheSize : Integer;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the calculated value of the InstalledSize field
      /// </summary>
      { $ENDREGION }
      function GetInstalledCacheSize : Integer;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the calculated value of the SupportedSRAMType field
      /// </summary>
      { $ENDREGION }
      function GetSupportedSRAMType : TCacheSRAMTypes;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the calculated value of the CurrentSRAMType field
      /// </summary>
      { $ENDREGION }
      function GetCurrentSRAMType : TCacheSRAMTypes;
      function GetErrorCorrectionType : TErrorCorrectionType;
      function GetSystemCacheType : TSystemCacheType;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the  Associativity field
      /// </summary>
      { $ENDREGION }
      function AssociativityStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// <para>
  /// The information in this structure defines the
  /// attributes of a single processor; a separate structure instance is
  /// provided for each system processor socket/slot. For example, a system
  /// with an IntelDX2 processor would have a single structure instance
  /// while a system with an IntelSX2 processor would have a structure to
  /// describe the main CPU and a second structure to describe the 80487
  /// co892 processor.
  /// </para>
  /// <para>
  ///
  /// <b>NOTE: One structure is provided for each processor instance in a system. For example, a system that supports up to two processors includes two Processor Information structures  even if only one processor is currently installed. Software that interprets the SMBIOS information can count the Processor Information structures to determine the maximum possible configuration of the system.</b>
  /// </para>
  /// </summary>
  { $ENDREGION }
  TProcessorInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for Reference Designation EXAMPLE: J202,0
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SocketDesignation : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorType : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorFamily : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number of Processor Manufacturer
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorManufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Raw processor identification data.
    /// </para>
    /// <para>
    /// The Processor ID field contains processor-specific information that
    /// describes the processors features. x86-Class CPUs For x86 class
    /// CPUs, the fields format depends on the processors support of the
    /// CPUID instruction. If the instruction is supported, the Processor
    /// ID field contains two DWORD-formatted values. The first (offsets
    /// 08h-0Bh) is the EAX value returned by a CPUID instruction with
    /// input EAX set to 1; the second (offsets 0Ch-0Fh) is the EDX value
    /// returned by that instruction. Otherwise, only the first two bytes
    /// of the Processor ID field are significant (all others are set to 0)
    /// and contain (in WORD-format) the contents of the DX register at CPU
    /// reset.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorID : Int64; // QWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number describing the Processor
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorVersion : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Two forms of information can be specified by the SMBIOS in this
    /// field, dependent on the value present in bit 7 (the most-significant
    /// bit). If bit 7 is 0 (legacy mode), the remaining bits of the field
    /// represent the specific voltages that the processor socket can accept.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Voltaje : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// External Clock Frequency, in MHz. If the value is unknown, the field
    /// is set to 0.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ExternalClock : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Maximum processor speed (in MHz) supported by the system for this
    /// processor socket. 0E9h for a 233 MHz processor. If the value is
    /// unknown, the field is set to 0.
    /// </para>
    /// <para>
    ///
    /// <b>NOTE: This field identifies a capability for the system, not the processor itself.</b>
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    MaxSpeed : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Same format as Max Speed
    /// </para>
    /// <para>
    ///
    /// <b>NOTE: This field identifies the processor's speed at system boot, and the Processor ID field implies the processor's additional speed characteristics (that is, single speed or multiple speed).</b>
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentSpeed : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bit 7 Reserved, must be zero
    /// </para>
    /// <para>
    /// Bit 6 CPU Socket Populated 1  CPU Socket Populated 0  CPU Socket
    /// Unpopulated
    /// </para>
    /// <para>
    /// Bits 5:3 Reserved, must be zero
    /// </para>
    /// <para>
    /// Bits 2:0 CPU Status
    /// </para>
    /// <list type="bullet">
    /// <item>
    /// 0h  Unknown
    /// </item>
    /// <item>
    /// 1h  CPU Enabled
    /// </item>
    /// <item>
    /// 2h  CPU Disabled by User through BIOS Setup
    /// </item>
    /// <item>
    /// 3h  CPU Disabled By BIOS (POST Error)
    /// </item>
    /// <item>
    /// 4h  CPU is Idle, waiting to be enabled.
    /// </item>
    /// <item>
    /// 5-6h  Reserved
    /// </item>
    /// <item>
    /// 7h  Other
    /// </item>
    /// </list>
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Status : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ProcessorUpgrade : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle of a Cache Information structure that defines the
    /// attributes of the primary (Level 1) cache for this processor. For
    /// version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    /// the processor has no L1 cache. For version 2.3 and later
    /// implementations, the value is 0FFFFh if the Cache Information
    /// structure is not provided.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    L1CacheHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle of a Cache Information structure that defines the
    /// attributes of the secondary (Level 2) cache for this processor. For
    /// version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    /// the processor has no L2 cache. For version 2.3 and later
    /// implementations, the value is 0FFFFh if the Cache Information
    /// structure is not provided.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    L2CacheHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle of a Cache Information structure that defines the
    /// attributes of the tertiary (Level 3) cache for this processor. For
    /// version 2.1 and version 2.2 implementations, the value is 0FFFFh if
    /// the processor has no L3 cache. For version 2.3 and later
    /// implementations, the value is 0FFFFh if the Cache Information
    /// structure is not provided.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    L3CacheHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the serial number of this processor. This value is
    /// set by the manufacturer and normally not changeable.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the asset tag of this processor.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    AssetTag : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the part number of this processor. This value is
    /// set by the manufacturer and normally not changeable.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    PartNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Number of cores per processor socket. If the value is unknown, the
    /// field is set to 0.
    /// </para>
    /// <para>
    /// Co Count is the number of cores detected by the BIOS for this
    /// processor socket. It does not necessarily indicate the full
    /// capability of the processor. For example, platform hardware may
    /// have the capability to limit the number of cores reported by the
    /// processor without BIOS intervention or knowledge. For a dual
    /// processor installed in a platform where the hardware is set to
    /// limit it to one core, the BIOS reports a value of 1 in Core Count.
    /// For a dual-core processor with multi-core support disabled by BIOS,
    /// the BIOS reports a value of 2 in Core Count.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.5+
    /// </remarks>
    { $ENDREGION }
    CoreCount : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Number of enabled cores per processor socket. If the value is
    /// unknown, the field is set 0.
    /// </para>
    /// <para>
    /// Core Enabled is the number of cores that are enabled by the BIOS
    /// and available for Operating System use. For example, if the BIOS
    /// detects a dual-core processor, it would report a value of 2 if it
    /// leaves both cores enabled, and it would report a value of 1 if it
    /// disables multi-core support.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.5+
    /// </remarks>
    { $ENDREGION }
    CoreEnabled : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Number of threads per processor socket. If the value is unknown,
    /// the field is set to 0.
    /// </para>
    /// <para>
    /// Thread Count is the total number of threads detected by the BIOS
    /// for this processor socket. It is a processor-wide count, not a
    /// thread-per-core count. It does not necessarily indicate the full
    /// capability of the processor. For example, platform hardware may
    /// have the capability to limit the number of threads reported by the
    /// processor without BIOS intervention or knowledge. For a dual-thread
    /// processor installed in a platform where the hardware is set to
    /// limit it to one thread, the BIOS reports a value of 1 in Thread
    /// Count. For a dual-thread processor with multi-threading disabled by
    /// BIOS, the BIOS reports a value of 2 in Thread Count. For a
    /// dual-core, dual-thread-per-core processor, the BIOS reports a value
    /// of 4 in Thread Count.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.5+
    /// </remarks>
    { $ENDREGION }
    ThreadCount : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Defines which functions the processor supports.
    /// </summary>
    /// <remarks>
    /// 2.5+
    /// </remarks>
    { $ENDREGION }
    ProcessorCharacteristics : Word;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.6+
    /// </remarks>
    { $ENDREGION }
    ProcessorFamily2 : Word;
  end;

  TProcessorInformation = class
    public
      RAWProcessorInformation : ^TProcessorInfo;
      L1Chache : TCacheInformation;
      L2Chache : TCacheInformation;
      L3Chache : TCacheInformation;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ProcessorManufacturer field
      /// </summary>
      { $ENDREGION }
      function ProcessorManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SocketDesignation field
      /// </summary>
      { $ENDREGION }
      function SocketDesignationStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the ProcessorType field.
      /// </summary>
      { $ENDREGION }
      function ProcessorTypeStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description for the ProcessorFamily and ProcessorFamily2 fields.
      /// </summary>
      { $ENDREGION }
      function ProcessorFamilyStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ProcessorVersion field
      /// </summary>
      { $ENDREGION }
      function ProcessorVersionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the  Voltaje of the Processor
      /// </summary>
      { $ENDREGION }
      function GetProcessorVoltaje : Double;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description  of the ProcessorUpgrade field
      /// </summary>
      { $ENDREGION }
      function ProcessorUpgradeStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field
      /// </summary>
      { $ENDREGION }
      function SerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the AssetTag field
      /// </summary>
      { $ENDREGION }
      function AssetTagStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the PartNumber field
      /// </summary>
      { $ENDREGION }
      function PartNumberStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines the attributes of a system
  /// port connector (for example, parallel, serial, keyboard, or mouse
  /// ports). The ports type and connector information are provided. One
  /// structure is present for each port provided by the system.
  /// </summary>
  { $ENDREGION }
  TPortConnectorInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for Internal Reference Designator, that is, internal to
    /// the system enclosure EXAMPLE: J101, 0
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    InternalReferenceDesignator : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Internal Connector type
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    InternalConnectorType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// String number for the External Reference Designation external to
    /// the system enclosure
    /// </para>
    /// <para>
    /// EXAMPLE: COM A, 0
    /// </para>
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    ExternalReferenceDesignator : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// External Connector type.
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    ExternalConnectorType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Describes the function of the port
    /// </summary>
    /// <remarks>
    /// +2.0
    /// </remarks>
    { $ENDREGION }
    PortType : Byte;
  end;

  TPortConnectorInformation = class
    public
      RAWPortConnectorInformation : ^TPortConnectorInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the InternalReferenceDesignator
      /// field.
      /// </summary>
      /// <remarks>
      /// +2.0
      /// </remarks>
      { $ENDREGION }
      function InternalReferenceDesignatorStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Connector Type Fields
      /// </summary>
      /// <remarks>
      /// +2.0
      /// </remarks>
      { $ENDREGION }
      function GetConnectorType(Connector : Byte) : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ExternalReferenceDesignator
      /// field.
      /// </summary>
      /// <remarks>
      /// +2.0
      /// </remarks>
      { $ENDREGION }
      function ExternalReferenceDesignatorStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the PortType field.
      /// </summary>
      /// <remarks>
      /// +2.0
      /// </remarks>
      { $ENDREGION }
      function PortTypeStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// the information in this structure defines the attributes of a system
  /// slot. One structure is provided for each slot in the system.
  /// </summary>
  { $ENDREGION }
  TSystemSlotInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for reference designation EXAMPLE: PCI-1,0
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SlotDesignation : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SlotType : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SlotDataBusWidth : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentUsage : Byte;
    SlotLength : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The Slot ID field of the System Slot structure provides a mechanism
    /// to correlate the physical attributes of  the slot to its logical
    /// access method (which varies based on the Slot Type field).
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SlotID : Word;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    SlotCharacteristics1 : Byte;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    SlotCharacteristics2 : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// For slots that are not of types PCI, AGP, PCI-X, or PCI-Express that
    /// do not have bus/device/function information, 0FFh should be populated
    /// in the fields of Segment Group Number, Bus Number, Device/Function
    /// Number. Segment Group Number is defined in the PCI Firmware
    /// Specification. The value is 0 for a single-segment topology.
    /// </summary>
    /// <remarks>
    /// 2.6+
    /// </remarks>
    { $ENDREGION }
    SegmentGroupNumber : Word;
    { $REGION 'Documentation' }
    /// <remarks>
    /// 2.6+
    /// </remarks>
    { $ENDREGION }
    BusNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bits 7:3  device number
    /// </para>
    /// <para>
    /// Bits 2:0  function number
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.6+
    /// </remarks>
    { $ENDREGION }
    DeviceFunctionNumber : Byte;
  end;

  TSystemSlotInformation = class
    public
      RAWSystemSlotInformation : ^TSystemSlotInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SlotDesignation field.
      /// </summary>
      { $ENDREGION }
      function SlotDesignationStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description for the SlotType field
      /// </summary>
      { $ENDREGION }
      function GetSlotType : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description for the SlotDataBusWidth field
      /// </summary>
      { $ENDREGION }
      function GetSlotDataBusWidth : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description for the CurrentUsage field
      /// </summary>
      { $ENDREGION }
      function GetCurrentUsage : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description for the SlotLength field
      /// </summary>
      { $ENDREGION }
      function GetSlotLength : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines the attributes of devices
  /// that are onboard (soldered onto) a system element, usually the
  /// baseboard. In general, an entry in this table implies that the BIOS has
  /// some level of control over the enabling of the associated device for
  /// use by the system.
  /// </summary>
  { $ENDREGION }
  TOnBoardSystemInfo = packed record
    Header : TSmBiosTableHeader;
    DeviceType : Byte;
    DescriptionString : Byte;
  end;

  TOnBoardSystemInformation = class
    public
      RAWOnBoardSystemInfo : ^TOnBoardSystemInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the Device description String
      /// </summary>
      { $ENDREGION }
      function GetDescription : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the Device status
      /// </summary>
      { $ENDREGION }
      function Enabled : Boolean;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the Device type description String
      /// </summary>
      { $ENDREGION }
      function GetTypeDescription : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure contains free-form strings defined by the OEM.  Examples
  /// of this are part numbers for system reference documents, contact
  /// information for the manufacturer, etc.
  /// </summary>
  { $ENDREGION }
  TOEMStringsInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of strings
    /// </summary>
    { $ENDREGION }
    Count : Byte;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The Group Associations structure is provided for OEMs who want to
  /// specify the arrangement or hierarchy of certain components (including
  /// other Group Associations) within the system. For example, you can use
  /// the Group Associations structure to indicate that two CPUs share a
  /// common external cache system.
  /// </summary>
  { $ENDREGION }
  TGroupAssociationsInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number of string describing the group
    /// </summary>
    /// <value>
    /// 2.0+
    /// </value>
    { $ENDREGION }
    GroupName : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Item (Structure) Type of this member
    /// </summary>
    /// <value>
    /// 2.0+
    /// </value>
    { $ENDREGION }
    ItemType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Handle corresponding to this structure
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    ItemHandle : Word;
  end;

  TGroupAssociationsInformation = class
    public
      RAWGroupAssociationsInformation : ^TGroupAssociationsInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the string representation of the GroupName field
      /// </summary>
      { $ENDREGION }
      function GetGroupName : AnsiString;
  end;

  TOEMStringsInformation = class
    public
      RAWOEMStringsInformation : ^TOEMStringsInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the OEM String based in the Index
      /// </summary>
      { $ENDREGION }
      function GetOEMString(index : Integer) : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure contains information required to configure the
  /// baseboards Jumpers and Switches.
  /// </summary>
  { $ENDREGION }
  TSystemConfInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of strings
    /// </summary>
    { $ENDREGION }
    Count : Byte;
  end;

  TSystemConfInformation = class
    public
      RAWSystemConfInformation : ^TSystemConfInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the configuration String based in the Index
      /// </summary>
      { $ENDREGION }
      function GetConfString(index : Integer) : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// The information in this structure defines the installable language
  /// attributes of the BIOS.
  /// </summary>
  { $ENDREGION }
  TBIOSLanguageInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// Number of languages available. Each available language has a
    /// description string. This field contains the number of strings that
    /// follow the formatted area of the structure.
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    InstallableLanguages : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bits 7:1 Reserved
    /// </para>
    /// <para>
    /// Bit 0 If set to 1, the Current Language strings use the abbreviated
    /// format. Otherwise, the strings use the long
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Flags : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Reserved for future use
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    Reserved : array [0 .. 14] of Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number (one-based) of the currently installed language
    /// </summary>
    /// <remarks>
    /// 2.0+
    /// </remarks>
    { $ENDREGION }
    CurrentLanguage : Byte;
  end;

  TBIOSLanguageInformation = class
    public
      RAWBIOSLanguageInformation : ^TBIOSLanguageInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the Installed language string based in the Index
      /// </summary>
      { $ENDREGION }
      function GetLanguageString(index : Integer) : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Returns the current language as a string
      /// </summary>
      { $ENDREGION }
      function GetCurrentLanguageStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure describes a collection of memory devices that operate
  /// together to form a memory address space.
  /// </summary>
  { $ENDREGION }
  TPhysicalMemoryArrayInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical location of the Memory Array, whether on the system
    /// board or an add-in board.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Location : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The function for which the array is used.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Use : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The primary hardware error correction or detection method supported
    /// by this memory array.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryErrorCorrection : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum memory capacity, in kilobytes, for this array. If the
    /// capacity is not represented in this field, then this field contains
    /// 8000 0000h and the Extended Maximum Capacity field should be used.
    /// Values 2 TB (8000 0000h) or greater must be represented in the
    /// Extended Maximum Capacity field.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MaximumCapacity : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with any error that was
    /// previously detected for the array. If the system does not provide the
    /// error information structure, the field contains FFFEh; otherwise, the
    /// field contains either FFFFh (if no error was detected) or the handle
    /// of the errorinformation structure.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryErrorInformationHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of slots or sockets available for Memory Devices in this
    /// array. This value represents the number of Memory Device structures
    /// that comprise this Memory Array. Each Memory Device has a reference
    /// to the owning Memory Array.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    NumberofMemoryDevices : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum memory capacity, in bytes, for this array. This field is
    /// only valid when the Maximum Capacity field contains 8000 0000h. When
    /// Maximum Capacity contains a value that is not 8000 0000h, Extended
    /// Maximum Capacity must contain zeros.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedMaximumCapacity : Int64; // QWORD
  end;

  TPhysicalMemoryArrayInformation = class
    public
      RAWPhysicalMemoryArrayInformation : ^TPhysicalMemoryArrayInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Location field.
      /// </summary>
      { $ENDREGION }
      function GetLocationStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Use  field.
      /// </summary>
      { $ENDREGION }
      function GetUseStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the MemoryErrorCorrection field.
      /// </summary>
      { $ENDREGION }
      function GetErrorCorrectionStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure provides the address mapping for a Physical Memory Array.
  /// </summary>
  { $ENDREGION }
  TMemoryArrayMappedAddress = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical address, in kilobytes, of a range of memory mapped to
    /// the specified Physical Memory Array. When the field value is FFFF
    /// FFFFh, the actual address is stored in the Extended Starting Address
    /// field. When this field contains a valid address, Ending Address must
    /// also contain a valid address. When this field contains FFFF FFFFh,
    /// Ending Address must also contain FFFF FFFFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    StartingAddress : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical ending address of the last kilobyte of a range of
    /// addresses mapped to the specified Physical Memory Array. When the
    /// field value is FFFF FFFFh and the Starting Address field also
    /// contains FFFF FFFFh, the actual address is stored in the Extended
    /// Ending Address field. When this field contains a valid address,
    /// Starting Address must also contain a valid address.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    EndingAddress : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with the Physical Memory
    /// Array to which this address range is mapped. Multiple address ranges
    /// can be mapped to a single Physical Memory Array.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryArrayHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the number of Memory Devices that form a single row of
    /// memory for the address partition defined by this structure
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    PartitionWidth : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical address, in bytes, of a range of memory mapped to the
    /// specified Physical Memory Array. This field is valid when Starting
    /// Address contains the value FFFF FFFFh. If Starting Address contains a
    /// value other than FFFF FFFFh, this field contains zeros. When this
    /// field contains a valid address, Extended Ending Address must also
    /// contain a valid address.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedStartingAddress : Int64;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical ending address, in bytes, of the last of a range of
    /// addresses mapped to the specified Physical Memory Array. This field
    /// is valid when both Starting Address and Ending Address contain the
    /// value FFFF FFFFh. If Ending Address contains a value other than FFFF
    /// FFFFh, this field contains zeros. When this field contains a valid
    /// address, Extended Starting Address must also contain a valid address.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedEndingAddress : Int64;
  end;

  TMemoryArrayMappedAddressInformation = class
    public
      RAWMemoryArrayMappedAddressInfo : ^TMemoryArrayMappedAddress;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure maps memory address space usually to a device-level
  /// granularity
  /// </summary>
  { $ENDREGION }
  TMemoryDeviceMappedAddress = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical address, in kilobytes, of a range of memory mapped to
    /// the referenced Memory Device. When the field value is FFFF FFFFh the
    /// actual address is stored in the Extended Starting Address field. When
    /// this field contains a valid address, Ending Address must also contain
    /// a valid address. When this field contains FFFF FFFFh, Ending Address
    /// must also contain FFFF FFFFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    StartingAddress : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical ending address of the last kilobyte of a range of
    /// addresses mapped to the referenced Memory Device. When the field
    /// value is FFFF FFFFh the actual address is stored in the Extended
    /// Ending Address field. When this field contains a valid address,
    /// Starting Address must also contain a valid address.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    EndingAddress : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with the Memory Device
    /// structure to which this address range is mapped. Multiple address
    /// ranges can be mapped to a single Memory Device.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryDeviceHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with the Memory Array
    /// Mapped Address structure to which this device address range is
    /// mapped. Multiple address ranges can be mapped to a single Memory
    /// Array Mapped Address.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryArrayMappedAddressHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the position of the referenced Memory Device in a row of
    /// the address partition. For example, if two 8-bit devices form a
    /// 16-bit row, this fields value is either 1 or 2. The value 0 is
    /// reserved. If the position is unknown, the field contains FFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    PartitionRowPosition : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// The position of the referenced Memory Device in an interleave. The
    /// value 0 indicates noninterleaved, 1 indicates first interleave
    /// position, 2 the second interleave position, and so on. If the
    /// position is unknown, the field contains FFh.
    /// </para>
    /// <para>
    /// EXAMPLES: In a 2:1 interleave, the value 1 indicates the device in
    /// the even position. In a 4:1 interleave, the value 1 indicates the
    /// first of four possible positions.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    InterleavePosition : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// The maximum number of consecutive rows from the referenced Memory
    /// Device that are accessed in a single interleaved transfer. If the
    /// device is not part of an interleave, the field contains 0; if the
    /// interleave configuration is unknown, the value is FFh.
    /// </para>
    /// <para>
    /// EXAMPLES: If a device transfers two rows each time it is read, its
    /// Interleaved Data Depth is set to 2. If that device is 2:1
    /// interleaved and in Interleave Position 1, the rows mapped to that
    /// device are 1, 2, 5, 6, 9, 10, etc.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    InterleavedDataDepth : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical address, in bytes, of a range of memory mapped to the
    /// referenced Memory Device. This field is valid when Starting Address
    /// contains the value FFFF FFFFh. If Starting Address contains a value
    /// other than FFFF FFFFh, this field contains zeros. When this field
    /// contains a valid address, Extended Ending Address must also contain a
    /// valid address.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedStartingAddress : Int64;
    { $REGION 'Documentation' }
    /// <summary>
    /// The physical ending address, in bytes, of the last of a range of
    /// addresses mapped to the referenced Memory Device. This field is valid
    /// when both Starting Address and Ending Address contain the value FFFF
    /// FFFFh. If Ending Address contains a value other than FFFF FFFFh, this
    /// field contains zeros. When this field contains a valid address,
    /// Extended Starting Address must also contain a valid address.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedEndingAddress : Int64;
  end;

  TMemoryDeviceMappedAddressInformation = class
    public
      RAWMemoryDeviceMappedAddressInfo : ^TMemoryDeviceMappedAddress;
  end;

  TMemoryDeviceInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with the Physical Memory
    /// Array to which this device belongs
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    PhysicalMemoryArrayHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, associated with any error that was
    /// previously detected for the device. if the system does not provide
    /// the error information structure, the field contains FFFEh; otherwise,
    /// the field contains either FFFFh (if no error was detected) or the
    /// handle of the errorinformation structure.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryErrorInformationHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The total width, in bits, of this memory device, including any check
    /// or error-correction bits. If there are no error-correction bits, this
    /// value should be equal to Data Width. If the width is unknown, the
    /// field is set to FFFFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    TotalWidth : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The data width, in bits, of this memory device. A Data Width of 0 and
    /// a Total Width of 8 indicates that the device is being used solely to
    /// provide 8 errorcorrection bits. If the width is unknown, the field is
    /// set to FFFFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DataWidth : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// The size of the memory device. If the value is 0, no memory device
    /// is installed in the socket; if the size is unknown, the field value
    /// is FFFFh. If the size is 32 GB-1 MB or greater, the field value is
    /// 7FFFh and the actual size is stored in the Extended Size field.
    /// </para>
    /// <para>
    /// The granularity in which the value is specified depends on the
    /// setting of the most-significant bit (bit 15). If the bit is 0, the
    /// value is specified in megabyte units; if the bit is 1, the value is
    /// specified in kilobyte units. For example, the value 8100h
    /// identifies a 256 KB memory device and
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Size : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The implementation form factor for this memory device.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    FormFactor : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Identifies when the Memory Device is one of a set of Memory Devices
    /// that must be populated with all devices of the same type and size,
    /// and the set to which this device belongs. A value of 0 indicates
    /// that the device is not part of a set; a value of FFh indicates that
    /// the attribute is unknown.
    /// </para>
    /// <para>
    ///
    /// <b>NOTE: A Device Set number must be unique within the context of the Memory Array containing this Memory Device.</b>
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DeviceSet : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The string number of the string that identifies the
    /// physically-labeled socket or board position where the memory device
    /// is located EXAMPLE: SIMM 3
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DeviceLocator : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The string number of the string that identifies the physically
    /// labeled bank where the memory device is located, EXAMPLE: Bank 0 or
    /// A
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    BankLocator : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The type of memory used in this device
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MemoryType : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Additional detail on the memory device type;
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    TypeDetail : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the maximum capable speed of the device, in megahertz
    /// (MHz). If the value is 0, the speed is unknown. NOTE: n MHz = (1000 /
    /// n) nanoseconds (ns)
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    Speed : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the manufacturer of this memory device
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    Manufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the serial number of this memory device. This value
    /// is set by the manufacturer and normally is not changeable.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the asset tag of this memory device
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    AssetTag : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// String number for the part number of this memory device. This value
    /// is set by the manufacturer and normally is not changeable.
    /// </summary>
    /// <remarks>
    /// 2.3+
    /// </remarks>
    { $ENDREGION }
    PartNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Bits 7-4: reserved
    /// </para>
    /// <para>
    /// Bits 3-0: rank
    /// </para>
    /// <para>
    /// Value=0 for unknown rank information
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.6+
    /// </remarks>
    { $ENDREGION }
    Attributes : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The extended size of the memory device (complements the Size field at
    /// offset 0Ch)
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ExtendedSize : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Identifies the configured clock speed to the memory device, in
    /// megahertz (MHz). If the value is 0, the speed is unknown.
    /// </para>
    /// <para>
    /// <b>NOTE: n MHz = (1000 / n) nanoseconds (ns)</b>
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    ConfiguredMemoryClockSpeed : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// Minimum operating voltage for this device, in millivolts If the value
    /// is 0, the voltage is unknown.
    /// </summary>
    /// <remarks>
    /// 2.8+
    /// </remarks>
    { $ENDREGION }
    MinimumVoltage : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Maximum operating voltage for this device, in millivolts If the value
    /// is 0, the voltage is unknown.
    /// </summary>
    /// <remarks>
    /// 2.8+
    /// </remarks>
    { $ENDREGION }
    MaximumVoltage : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Configured voltage for this device, in millivolts If the value is 0,
    /// the voltage is unknown.
    /// </summary>
    /// <remarks>
    /// 2.8+
    /// </remarks>
    { $ENDREGION }
    ConfiguredVoltage : Word;
  end;

  TMemoryDeviceInformation = class
    public
      RAWMemoryDeviceInfo : ^TMemoryDeviceInfo;
      PhysicalMemoryArray : TPhysicalMemoryArrayInformation;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the calculated size in Mb of the memory device
      /// </summary>
      { $ENDREGION }
      function GetSize : DWORD;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the FormFactor field.
      /// </summary>
      { $ENDREGION }
      function GetFormFactor : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the DeviceLocator field.
      /// </summary>
      { $ENDREGION }
      function GetDeviceLocatorStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the BankLocator field.
      /// </summary>
      { $ENDREGION }
      function GetBankLocatorStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the MemoryType field.
      /// </summary>
      { $ENDREGION }
      function GetMemoryTypeStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Manufacturer field
      /// </summary>
      { $ENDREGION }
      function ManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field
      /// </summary>
      { $ENDREGION }
      function SerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the AssetTag field
      /// </summary>
      { $ENDREGION }
      function AssetTagStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the PartNumber field
      /// </summary>
      { $ENDREGION }
      function PartNumberStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// <para>
  /// This structure describes the attributes of the built-in pointing
  /// device for the system.
  /// </para>
  /// <para>
  /// Note : The presence of this structure does not imply that the
  /// built-in pointing device is active for the systems use.
  /// </para>
  /// </summary>
  { $ENDREGION }
  TBuiltInPointingDevice = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The type of pointing device
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    _Type : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The interface type for the pointing device;
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    _Interface : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of buttons on the pointing device. If the device has three
    /// buttons, the field value is 03h.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    NumberofButtons : Byte;
  end;

  TBuiltInPointingDeviceInformation = class
    public
      RAWBuiltInPointingDeviceInfo : ^TBuiltInPointingDevice;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Type field.
      /// </summary>
      { $ENDREGION }
      function GetType : string;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the Interface field.
      /// </summary>
      { $ENDREGION }
      function GetInterface : string;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure describes the attributes of the portable battery or
  /// batteries for the system. The structure contains the static attributes
  /// for the group. Each structure describes a single battery packs
  /// attributes.
  /// </summary>
  { $ENDREGION }
  TBatteryInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that identifies the location of the battery
    /// EXAMPLE: in the back, on the left-hand side
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Location : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that names the company that manufactured the
    /// battery
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    Manufacturer : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that identifies the date on which the
    /// battery was manufactured. Version 2.2+ implementations that use a
    /// Smart Battery set this field to 0 (no string) to indicate that the
    /// SBDS Manufacture Date field contains the information.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    ManufacturerDate : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains the serial number for the
    /// battery. Version 2.2+ implementations that use a Smart Battery set
    /// this field to 0 (no string) to indicate that the SBDS Serial Number
    /// field contains the information.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    SerialNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// The number of the string that names the battery device
    /// </para>
    /// <para>
    /// EXAMPLE: DR-36
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DeviceName : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the battery chemistry; Version 2.2+ implementations that
    /// use a Smart Battery set this field to 02h (Unknown) to indicate that
    /// the SBDS Device Chemistry field contains the information.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DeviceChemistry : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The design capacity of the battery in mWatthours. If the value is
    /// unknown, the field contains 0. For version 2.2+ implementations, this
    /// value is multiplied by the Design Capacity Multiplier to produce the
    /// actual value.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DesignCapacity : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The design voltage of the battery in mVolts. If the value is unknown,
    /// the field contains 0.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    DesignVoltage : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains the Smart Battery Data
    /// Specification version number supported by this battery. If the
    /// battery does not support the function, no string is supplied.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    SBDSVersionNumber : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum error (as a percentage in the range 0 to 100) in the
    /// Watt-hour data reported by the battery, indicating an upper bound on
    /// how much additional energy the battery might have above the energy it
    /// reports having. If the value is unknown, the field contains FFh.
    /// </summary>
    /// <remarks>
    /// 2.1+
    /// </remarks>
    { $ENDREGION }
    MaximumErrorInBatteryData : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The 16-bit value that identifies the batterys serial number. This
    /// value, when combined with the Manufacturer, Device Name, and
    /// Manufacture Date uniquely identifies the battery. The Serial Number
    /// field must be set to 0 (no string) for this field to be valid.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    SBDSSerialNumber : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// The date the cell pack was manufactured, in packed format:
    /// </para>
    /// <para>
    /// Bits 15:9 Year, biased by 1980, in the range 0 to 127
    /// </para>
    /// <para>
    /// Bits 8:5 Month, in the range 1 to 12
    /// </para>
    /// <para>
    /// Bits 4:0 Date, in the range 1 to 31
    /// </para>
    /// <para>
    /// EXAMPLE: 01 February 2000 would be identified as 0010 1000 0100
    /// 0001b (0x2841)
    /// </para>
    /// <para>
    /// The Manufacture Date field must be set to 0 (no string) for this
    /// field to be valid.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    SBDSManufacturerDate : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that identifies the battery chemistry (for
    /// example, PbAc). The Device Chemistry field must be set to 02h
    /// (Unknown) for this field to be valid.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    SBDSDeviceChemistry : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The multiplication factor of the Design Capacity value, which assures
    /// that the mWatt hours value does not overflow for SBDS
    /// implementations. The multiplier default is 1, SBDS implementations
    /// use the value 10 to correspond to the data as returned from the SBDS
    /// Function 18h.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    DesignCapacityMultiplier : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    OEM_Specific : DWORD;
  end;

  TBatteryInformation = class
    public
      RAWBatteryInfo : ^TBatteryInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Location field.
      /// </summary>
      { $ENDREGION }
      function GetLocationStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Manufacturer field.
      /// </summary>
      { $ENDREGION }
      function GetManufacturerStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the ManufacturerDate field.
      /// </summary>
      { $ENDREGION }
      function GetManufacturerDateStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SerialNumber field.
      /// </summary>
      { $ENDREGION }
      function GetSerialNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the DeviceName field.
      /// </summary>
      { $ENDREGION }
      function GetDeviceNameStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the description of the DeviceChemistry field.
      /// </summary>
      { $ENDREGION }
      function GetDeviceChemistry : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SBDSVersionNumber field.
      /// </summary>
      { $ENDREGION }
      function GetSBDSVersionNumberStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SBDSManufacturerDate field.
      /// </summary>
      { $ENDREGION }
      function GetSBDSManufacturerDate : TDateTime;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the SBDSDeviceChemistry field.
      /// </summary>
      { $ENDREGION }
      function GetSBDSDeviceChemistryStr : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This describes the attributes for a voltage probe in the system. Each
  /// structure describes a single voltage probe.
  /// </summary>
  /// <remarks>
  /// NOTE: This structure type was added in version 2.2 of the SMBIOS
  /// specification.
  /// </remarks>
  { $ENDREGION }
  TVoltageProbeInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains additional descriptive
    /// information about the probe or its location
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Description : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Defines the probes physical location and status of the voltage
    /// monitored by this voltage probe.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    LocationandStatus : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum voltage level readable by this probe, in millivolts. If
    /// the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MaximumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The minimum voltage level readable by this probe, in millivolts. If
    /// the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MinimumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The resolution for the probes reading, in tenths of millivolts. If
    /// the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Resolution : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The tolerance for reading from this probe, in plus/minus millivolts.
    /// If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Tolerance : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The accuracy for reading from this probe, in plus/minus 1/100th of a
    /// percent. If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Accuracy : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    OEMdefined : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The nominal value for the probes reading in millivolts. If the value
    /// is unknown, the field is set to 0x8000. This field is present in the
    /// structure only if the structures Length is larger than 14h.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    NominalValue : Word;
  end;

  TVoltageProbeInformation = class
    public
      RAWVoltageProbeInfo : ^TVoltageProbeInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Description field.
      /// </summary>
      { $ENDREGION }
      function GetDescriptionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the Probe Location
      /// </summary>
      { $ENDREGION }
      function GetLocation : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the probe status
      /// </summary>
      { $ENDREGION }
      function GetStatus : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure describes the attributes for a cooling device in the
  /// system. Each structure describes a single cooling device.
  /// </summary>
  { $ENDREGION }
  TCoolingDeviceInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The handle, or instance number, of the temperature probe monitoring
    /// this cooling device. A value of 0xFFFF indicates that no probe is
    /// provided.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    TemperatureProbeHandle : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Identifies the cooling device type and the status of this cooling
    /// device;
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    DeviceTypeandStatus : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// <para>
    /// Identifies the cooling unit group to which this cooling device is
    /// associated. Having multiple cooling devices in the same cooling
    /// unit implies a redundant configuration.
    /// </para>
    /// <para>
    /// The value is 00h if the cooling device is not a member of a
    /// redundant cooling unit. Non-zero values imply redundancy and that
    /// at least one other cooling device will be enumerated with the same
    /// value.
    /// </para>
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    CoolingUnitGroup : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    OEMdefined : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The nominal value for the cooling devices rotational speed, in
    /// revolutions-per-minute (rpm). If the value is unknown or the cooling
    /// device is nonrotating, the field is set to 0x8000. This field is
    /// present in the structure only if the structures Length is larger
    /// than 0Ch.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    NominalSpeed : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains additional descriptive
    /// information about the cooling device or its location This field is
    /// present in the structure only if the structures Length is 0Fh or
    /// larger.
    /// </summary>
    /// <remarks>
    /// 2.7+
    /// </remarks>
    { $ENDREGION }
    Description : Byte;
  end;

  TCoolingDeviceInformation = class
    public
      RAWCoolingDeviceInfo : ^TCoolingDeviceInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Description field.
      /// </summary>
      { $ENDREGION }
      function GetDescriptionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the device type
      /// </summary>
      { $ENDREGION }
      function GetDeviceType : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the device status
      /// </summary>
      { $ENDREGION }
      function GetStatus : AnsiString;
  end;

  TTemperatureProbeInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains additional descriptive
    /// information about the probe or its location
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Description : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Defines the probes physical location and the status of the
    /// temperature monitored by this temperature probe.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    LocationandStatus : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum temperature readable by this probe, in 1/10th degrees C.
    /// If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MaximumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The minimum temperature readable by this probe, in 1/10th degrees C.
    /// If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MinimumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The resolution for the probes reading, in 1/1000th degrees C. If the
    /// value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Resolution : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The tolerance for reading from this probe, in plus/minus 1/10th
    /// degrees C. If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Tolerance : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The accuracy for reading from this probe, in plus/minus 1/100th of a
    /// percent. If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Accuracy : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    OEMdefined : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The nominal value for the probes reading in 1/10th degrees C. If the
    /// value is unknown, the field is set to 0x8000. This field is present
    /// in the structure only if the structures Length is larger than 14h.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    NominalValue : Word;
  end;

  TTemperatureProbeInformation = class
    public
      RAWTemperatureProbeInfo : ^TTemperatureProbeInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Description field.
      /// </summary>
      { $ENDREGION }
      function GetDescriptionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the Probe Location
      /// </summary>
      { $ENDREGION }
      function GetLocation : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the probe status
      /// </summary>
      { $ENDREGION }
      function GetStatus : AnsiString;
  end;

  { $REGION 'Documentation' }
  /// <summary>
  /// This structure describes the attributes for an electrical current probe
  /// in the system. Each structure describes a single electrical current
  /// probe.
  /// </summary>
  { $ENDREGION }
  TElectricalCurrentProbeInfo = packed record
    Header : TSmBiosTableHeader;
    { $REGION 'Documentation' }
    /// <summary>
    /// The number of the string that contains additional descriptive
    /// information about the probe or its location
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Description : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// Defines the probes physical location and the status of the current
    /// monitored by this current probe.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    LocationandStatus : Byte;
    { $REGION 'Documentation' }
    /// <summary>
    /// The maximum current readable by this probe, in milliamps. If the
    /// value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MaximumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The minimum current readable by this probe, in milliamps. If the
    /// value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    MinimumValue : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The resolution for the probes reading, in tenths of milliamps. If
    /// the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Resolution : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The tolerance for reading from this probe, in plus/minus milliamps.
    /// If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Tolerance : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// The accuracy for reading from this probe, in plus/minus 1/100th of a
    /// percent. If the value is unknown, the field is set to 0x8000.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    Accuracy : Word;
    { $REGION 'Documentation' }
    /// <summary>
    /// Contains OEM- or BIOS vendor-specific information.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    OEMdefined : DWORD;
    { $REGION 'Documentation' }
    /// <summary>
    /// The nominal value for the probes reading in milliamps. If the value
    /// is unknown, the field is set to 0x8000. This field is present in the
    /// structure only if the structures Length is larger than 14h.
    /// </summary>
    /// <remarks>
    /// 2.2+
    /// </remarks>
    { $ENDREGION }
    NominalValue : Word;
  end;

  TElectricalCurrentProbeInformation = class
    public
      RAWElectricalCurrentProbeInfo : ^TElectricalCurrentProbeInfo;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the string representation of the Description field.
      /// </summary>
      { $ENDREGION }
      function GetDescriptionStr : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the Probe Location
      /// </summary>
      { $ENDREGION }
      function GetLocation : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Get the probe status
      /// </summary>
      { $ENDREGION }
      function GetStatus : AnsiString;
  end;

  TSMBiosTableEntry = record
    Header : TSmBiosTableHeader;
    index : Integer;
  end;

{$IFDEF NOGENERICS}

  ArrBaseBoardInfo = Array of TBaseBoardInformation;
  ArrEnclosureInfo = Array of TEnclosureInformation;
  ArrProcessorInfo = Array of TProcessorInformation;
  ArrCacheInfo = Array of TCacheInformation;
  ArrPortConnectorInfo = Array of TPortConnectorInformation;
  ArrSystemSlotInfo = Array of TSystemSlotInformation;
  ArrSMBiosTableEntry = Array of TSMBiosTableEntry;
  ArrOEMStringsInfo = Array of TOEMStringsInformation;
  ArrBIOSLanguageInfo = Array of TBIOSLanguageInformation;
  ArrSystemConfInfo = Array of TSystemConfInformation;
  ArrPhysicalMemoryArrayInfo = Array of TPhysicalMemoryArrayInformation;
  ArrMemoryDeviceInfo = Array of TMemoryDeviceInformation;
  ArrBatteryInfo = Array of TBatteryInformation;
  ArrMemoryArrayMappedAddressInfo = Array of TMemoryArrayMappedAddressInformation;
  ArrMemoryDeviceMappedAddressInfo = Array of TMemoryDeviceMappedAddressInformation;
  ArrBuiltInPointingDeviceInfo = Array of TBuiltInPointingDeviceInformation;
  ArrVoltageProbeInfo = Array of TVoltageProbeInformation;
  ArrCoolingDeviceInfo = Array of TCoolingDeviceInformation;
  ArrTemperatureProbeInfo = Array of TTemperatureProbeInformation;
  ArrElectricalCurrentProbeInfo = Array of TElectricalCurrentProbeInformation;
  ArrOnBoardSystemInfo = Array of TOnBoardSystemInformation;
  ArrMemoryControllerInfo = Array of TMemoryControllerInformation;
  ArrMemoryModuleInfo = Array of TMemoryModuleInformation;
  ArrGroupAssociationsInfo = Array of TGroupAssociationsInformation;
{$ENDIF}

  TSMBios = class
    private
      FRawSMBIOSData : TRawSMBIOSData;
      FDataString : AnsiString;
      FBiosInfo : TBiosInformation;
      FSysInfo : TSystemInformation;
      FBaseBoardInfo : {$IFDEF NOGENERICS}ArrBaseBoardInfo; {$ELSE}TArray<TBaseBoardInformation>;{$ENDIF}
      FEnclosureInfo : {$IFDEF NOGENERICS}ArrEnclosureInfo; {$ELSE}TArray<TEnclosureInformation>;{$ENDIF}
      FProcessorInfo : {$IFDEF NOGENERICS}ArrProcessorInfo; {$ELSE}TArray<TProcessorInformation>;{$ENDIF}
      FCacheInfo : {$IFDEF NOGENERICS}ArrCacheInfo; {$ELSE}TArray<TCacheInformation>;{$ENDIF}
      FPortConnectorInfo : {$IFDEF NOGENERICS}ArrPortConnectorInfo; {$ELSE} TArray<TPortConnectorInformation>; {$ENDIF}
      FSystemSlotInfo : {$IFDEF NOGENERICS}ArrSystemSlotInfo; {$ELSE} TArray<TSystemSlotInformation>; {$ENDIF}
      FSMBiosTablesList : {$IFDEF NOGENERICS}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$ENDIF}
      FOEMStringsInfo : {$IFDEF NOGENERICS}ArrOEMStringsInfo; {$ELSE}TArray<TOEMStringsInformation>;{$ENDIF}
      FBIOSLanguageInfo : {$IFDEF NOGENERICS}ArrBIOSLanguageInfo; {$ELSE}TArray<TBIOSLanguageInformation>;{$ENDIF}
      FSystemConfInfo : {$IFDEF NOGENERICS}ArrSystemConfInfo; {$ELSE}TArray<TSystemConfInformation>;{$ENDIF}
      FPhysicalMemoryArrayInfo : {$IFDEF NOGENERICS}ArrPhysicalMemoryArrayInfo; {$ELSE}TArray<TPhysicalMemoryArrayInformation>;{$ENDIF}
      FMemoryDeviceInfo : {$IFDEF NOGENERICS}ArrMemoryDeviceInfo; {$ELSE}TArray<TMemoryDeviceInformation>;{$ENDIF}
      FBatteryInformation : {$IFDEF NOGENERICS}ArrBatteryInfo; {$ELSE}TArray<TBatteryInformation>;{$ENDIF}
      FMemoryArrayMappedAddressInformation : {$IFDEF NOGENERICS}ArrMemoryArrayMappedAddressInfo; {$ELSE}TArray<TMemoryArrayMappedAddressInformation>;{$ENDIF}
      FMemoryDeviceMappedAddressInformation : {$IFDEF NOGENERICS}ArrMemoryDeviceMappedAddressInfo; {$ELSE}TArray<TMemoryDeviceMappedAddressInformation>;{$ENDIF}
      FBuiltInPointingDeviceInformation : {$IFDEF NOGENERICS}ArrBuiltInPointingDeviceInfo; {$ELSE}TArray<TBuiltInPointingDeviceInformation>;{$ENDIF}
      FVoltageProbeInformation : {$IFDEF NOGENERICS}ArrVoltageProbeInfo; {$ELSE}TArray<TVoltageProbeInformation>;{$ENDIF}
      FCoolingDeviceInformation : {$IFDEF NOGENERICS}ArrCoolingDeviceInfo; {$ELSE}TArray<TCoolingDeviceInformation>;{$ENDIF}
      FTemperatureProbeInformation : {$IFDEF NOGENERICS}ArrTemperatureProbeInfo; {$ELSE}TArray<TTemperatureProbeInformation>;{$ENDIF}
      FElectricalCurrentProbeInformation : {$IFDEF NOGENERICS}ArrElectricalCurrentProbeInfo; {$ELSE}TArray<TElectricalCurrentProbeInformation>;{$ENDIF}
      FOnBoardSystemInfo : {$IFDEF NOGENERICS}ArrOnBoardSystemInfo; {$ELSE} TArray<TOnBoardSystemInformation>; {$ENDIF}
      FMemoryControllerInfo : {$IFDEF NOGENERICS}ArrMemoryControllerInfo;{$ELSE} TArray<TMemoryControllerInformation>; {$ENDIF}
      FMemoryModuleInfo : {$IFDEF NOGENERICS}ArrMemoryModuleInfo;{$ELSE} TArray<TMemoryModuleInformation>; {$ENDIF}
      FGroupAssociationsInformation : {$IFDEF NOGENERICS}ArrGroupAssociationsInfo;{$ELSE} TArray<TGroupAssociationsInformation>; {$ENDIF}
{$IFDEF MSWINDOWS}
{$IFDEF USEWMI}
      procedure LoadSMBIOSWMI(const RemoteMachine, UserName, Password : string);
{$ELSE}
      procedure LoadSMBIOSWinAPI;
{$ENDIF}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
      procedure LoadSMBIOSLinux;
{$ENDIF}
{$IFDEF MACOS}
      procedure LoadSMBIOS_OSX;
{$ENDIF MACOS}
      procedure ClearSMBiosTables;
      procedure ReadSMBiosTables;
      procedure Init;
      function GetSMBiosTablesList : {$IFDEF NOGENERICS}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$ENDIF}
      function GetSMBiosTablesCount : Integer;
      function GetHasBaseBoardInfo : Boolean;
      function GetHasEnclosureInfo : Boolean;
      function GetHasProcessorInfo : Boolean;
      function GetHasCacheInfo : Boolean;
      function GetHasPortConnectorInfo : Boolean;
      function GetHasSystemSlotInfo : Boolean;
      function GetSmbiosVersion : string;
      function GetHasOEMStringsInfo : Boolean;
      function GetHasBIOSLanguageInfo : Boolean;
      function GetHasSystemConfInfo : Boolean;
      function GetHasPhysicalMemoryArrayInfo : Boolean;
      function GetHasMemoryDeviceInfo : Boolean;
      function GetHasBatteryInfo : Boolean;
      function GetHasMemoryArrayMappedAddressInfo : Boolean;
      function GetHasMemoryDeviceMappedAddressInfo : Boolean;
      function GetHasBuiltInPointingDeviceInfo : Boolean;
      function GetHasVoltageProbeInfo : Boolean;
      function GetHasCoolingDeviceInfo : Boolean;
      function GetHasTemperatureProbeInfo : Boolean;
      function GetHasElectricalCurrentProbeInfo : Boolean;
      function GetHasOnBoardSystemInfo : Boolean;
      function GetHasMemoryControllerInfo : Boolean;
      function GetHasMemoryModuleInfo : Boolean;
      function GetHasGroupAssociationsInfo : Boolean;

    public
      { $REGION 'Documentation' }
      /// <summary>
      /// Default constructor, used for populate the TSMBIOS class  using the
      /// current mode selected (WMI or WinApi)
      /// </summary>
      { $ENDREGION }
      constructor Create(LoadBiosData : Boolean = true); overload;
      { $REGION 'Documentation' }
      /// <summary>
      /// Use this constructor to load the SMBIOS data from a previously saved
      /// file.
      /// </summary>
      { $ENDREGION }
      constructor Create(const FileName : string); overload;
{$IFDEF MSWINDOWS}
{$IFDEF USEWMI}
      { $REGION 'Documentation' }
      /// <summary>
      /// Use this constructor to read the SMBIOS from a remote machine.
      /// </summary>
      { $ENDREGION }
      constructor Create(const RemoteMachine, UserName, Password : string); overload;
{$ENDIF}
{$ENDIF MSWINDOWS}
      destructor Destroy;override;
      function SearchSMBiosTable(TableType : TSMBiosTablesTypes) : Integer;
      function GetSMBiosTableNextIndex(
        TableType : TSMBiosTablesTypes;
        Offset    : Integer = 0) : Integer;
      function GetSMBiosTableEntries(TableType : TSMBiosTablesTypes) : Integer;
      function GetSMBiosString(Entry, index : Integer) : AnsiString;
      { $REGION 'Documentation' }
      /// <summary>
      /// Save(Dump) the TRawSMBIOSData structure to a file
      /// </summary>
      { $ENDREGION }
      procedure SaveToFile(const FileName : string);
      { $REGION 'Documentation' }
      /// <summary>
      /// Load the TRawSMBIOSData structure from a file
      /// </summary>
      { $ENDREGION }
      procedure LoadFromFile(const FileName : string; LoadSMBIOSTables : Boolean  = false);

      { $REGION 'Documentation' }
      /// <summary>
      /// Find and load the SMBIOS Data from a file
      /// </summary>
      { $ENDREGION }
      procedure FindAndLoadFromFile(const FileName : string);
      property DataString : AnsiString
        read FDataString;
      property RawSMBIOSData : TRawSMBIOSData
        read FRawSMBIOSData;
      property SmbiosVersion : string
        read GetSmbiosVersion;
      property SMBiosTablesList : {$IFDEF NOGENERICS}ArrSMBiosTableEntry {$ELSE}TArray<TSMBiosTableEntry> {$ENDIF} read FSMBiosTablesList;

      property BiosInfo : TBiosInformation
        read FBiosInfo;
      property SysInfo : TSystemInformation
        read FSysInfo;

      property BaseBoardInfo : {$IFDEF NOGENERICS}ArrBaseBoardInfo {$ELSE}TArray<TBaseBoardInformation> {$ENDIF} read FBaseBoardInfo;
      property HasBaseBoardInfo : Boolean
        read GetHasBaseBoardInfo;

      property EnclosureInfo : {$IFDEF NOGENERICS}ArrEnclosureInfo {$ELSE}TArray<TEnclosureInformation> {$ENDIF} read FEnclosureInfo;
      property HasEnclosureInfo : Boolean
        read GetHasEnclosureInfo;

      property CacheInfo : {$IFDEF NOGENERICS}ArrCacheInfo {$ELSE}TArray<TCacheInformation> {$ENDIF} read FCacheInfo;
      property HasCacheInfo : Boolean
        read GetHasCacheInfo;

      property ProcessorInfo : {$IFDEF NOGENERICS}ArrProcessorInfo {$ELSE}TArray<TProcessorInformation> {$ENDIF} read FProcessorInfo;
      property HasProcessorInfo : Boolean
        read GetHasProcessorInfo;

      property MemoryControllerInfo : {$IFDEF NOGENERICS}ArrMemoryControllerInfo {$ELSE} TArray<TMemoryControllerInformation>
{$ENDIF} read FMemoryControllerInfo;
      property HasMemoryControllerInfo : Boolean
        read GetHasMemoryControllerInfo;

      property PortConnectorInfo : {$IFDEF NOGENERICS}ArrPortConnectorInfo {$ELSE} TArray<TPortConnectorInformation> {$ENDIF} read FPortConnectorInfo;
      property HasPortConnectorInfo : Boolean
        read GetHasPortConnectorInfo;

      property SystemSlotInfo : {$IFDEF NOGENERICS}ArrSystemSlotInfo {$ELSE} TArray<TSystemSlotInformation> {$ENDIF} read FSystemSlotInfo;
      property HasSystemSlotInfo : Boolean
        read GetHasSystemSlotInfo;

      property OnBoardSystemInfo : {$IFDEF NOGENERICS}ArrOnBoardSystemInfo {$ELSE} TArray<TOnBoardSystemInformation> {$ENDIF} read FOnBoardSystemInfo;
      property HasOnBoardSystemInfo : Boolean
        read GetHasOnBoardSystemInfo;

      property OEMStringsInfo : {$IFDEF NOGENERICS}ArrOEMStringsInfo {$ELSE} TArray<TOEMStringsInformation> {$ENDIF} read FOEMStringsInfo;
      property HasOEMStringsInfo : Boolean
        read GetHasOEMStringsInfo;

      property BIOSLanguageInfo : {$IFDEF NOGENERICS}ArrBIOSLanguageInfo {$ELSE} TArray<TBIOSLanguageInformation> {$ENDIF} read FBIOSLanguageInfo;
      property HasBIOSLanguageInfo : Boolean
        read GetHasBIOSLanguageInfo;

      property SystemConfInfo : {$IFDEF NOGENERICS}ArrSystemConfInfo {$ELSE} TArray<TSystemConfInformation> {$ENDIF} read FSystemConfInfo;
      property HasSystemConfInfo : Boolean
        read GetHasSystemConfInfo;

      property PhysicalMemoryArrayInfo : {$IFDEF NOGENERICS} ArrPhysicalMemoryArrayInfo {$ELSE} TArray<TPhysicalMemoryArrayInformation>
{$ENDIF} read FPhysicalMemoryArrayInfo;
      property HasPhysicalMemoryArrayInfo : Boolean
        read GetHasPhysicalMemoryArrayInfo;

      property MemoryDeviceInfo : {$IFDEF NOGENERICS} ArrMemoryDeviceInfo {$ELSE} TArray<TMemoryDeviceInformation> {$ENDIF} read FMemoryDeviceInfo;
      property HasMemoryDeviceInfo : Boolean
        read GetHasMemoryDeviceInfo;

      property MemoryModuleInfo : {$IFDEF NOGENERICS} ArrMemoryModuleInfo {$ELSE} TArray<TMemoryModuleInformation> {$ENDIF} read FMemoryModuleInfo;
      property HasMemoryModuleInfo : Boolean
        read GetHasMemoryModuleInfo;

      property BatteryInformation : {$IFDEF NOGENERICS} ArrBatteryInfo {$ELSE} TArray<TBatteryInformation> {$ENDIF} read FBatteryInformation;
      property HasBatteryInfo : Boolean
        read GetHasBatteryInfo;

      property MemoryArrayMappedAddressInformation : {$IFDEF NOGENERICS} ArrMemoryArrayMappedAddressInfo {$ELSE} TArray<TMemoryArrayMappedAddressInformation>
{$ENDIF} read FMemoryArrayMappedAddressInformation;
      property HasMemoryArrayMappedAddressInfo : Boolean
        read GetHasMemoryArrayMappedAddressInfo;

      property MemoryDeviceMappedAddressInformation : {$IFDEF NOGENERICS} ArrMemoryDeviceMappedAddressInfo {$ELSE} TArray<TMemoryDeviceMappedAddressInformation>
{$ENDIF} read FMemoryDeviceMappedAddressInformation;
      property HasMemoryDeviceMappedAddressInfo : Boolean
        read GetHasMemoryDeviceMappedAddressInfo;

      property BuiltInPointingDeviceInformation : {$IFDEF NOGENERICS} ArrBuiltInPointingDeviceInfo {$ELSE} TArray<TBuiltInPointingDeviceInformation>
{$ENDIF} read FBuiltInPointingDeviceInformation;
      property HasBuiltInPointingDeviceInfo : Boolean
        read GetHasBuiltInPointingDeviceInfo;

      property VoltageProbeInformation : {$IFDEF NOGENERICS} ArrVoltageProbeInfo {$ELSE} TArray<TVoltageProbeInformation>
{$ENDIF} read FVoltageProbeInformation;
      property HasVoltageProbeInfo : Boolean
        read GetHasVoltageProbeInfo;

      property CoolingDeviceInformation : {$IFDEF NOGENERICS} ArrCoolingDeviceInfo {$ELSE} TArray<TCoolingDeviceInformation>
{$ENDIF} read FCoolingDeviceInformation;
      property HasCoolingDeviceInfo : Boolean
        read GetHasCoolingDeviceInfo;

      property TemperatureProbeInformation : {$IFDEF NOGENERICS} ArrTemperatureProbeInfo {$ELSE} TArray<TTemperatureProbeInformation>
{$ENDIF} read FTemperatureProbeInformation;
      property HasTemperatureProbeInfo : Boolean
        read GetHasTemperatureProbeInfo;

      property ElectricalCurrentProbeInformation : {$IFDEF NOGENERICS} ArrElectricalCurrentProbeInfo {$ELSE} TArray<TElectricalCurrentProbeInformation>
{$ENDIF} read FElectricalCurrentProbeInformation;
      property HasElectricalCurrentProbeInfo : Boolean
        read GetHasElectricalCurrentProbeInfo;

      property GroupAssociationsInformation : {$IFDEF NOGENERICS} ArrGroupAssociationsInfo {$ELSE} TArray<TGroupAssociationsInformation>
{$ENDIF} read FGroupAssociationsInformation;
      property HasGroupAssociationsInfo : Boolean
        read GetHasGroupAssociationsInfo;

  end;

implementation

{$IFDEF USEWMI}
{$IFDEF MSWINDOWS}

uses ComObj,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  ActiveX;
{$ENDIF}
{$ENDIF}

type
  TSmBiosEntryPoint = packed record
    AnchorString : array [0 .. 3] of Byte; // AnsiChar
    EntryPointChecksum : Byte;
    EntryPointLength : Byte;
    SMBIOSMajorVersion : Byte;
    SMBIOSMinorVersion : Byte;
    MaximumStructureSize : Word;
    EntryPointRevision : Byte;
    FormattedArea : array [0 .. 4] of Byte;
    IntermediateAnchorString : array [0 .. 4] of Byte; // AnsiChar
    IntermediateChecksum : Byte;
    StructureTableLength : Word;
    StructureTableAddress : DWORD;
    NumberSMBIOSStructures : Word;
    SMBIOSBCDRevision : Byte;
  end;

const
  SMBIOS_ANCHOR_STRING_VALUE = $5F4D535F;
  // '_DMI_'
  SMBIOS_INTERMEDIATE_ANCHOR_STRING_VALUE = [$5F, $44, $4D, $49, $5F];

function GetBit(const AValue : DWORD; const Bit : Byte) : Boolean;
begin
  Result := (AValue and (1 shl Bit)) <> 0;
end;

function ClearBit(const AValue : DWORD; const Bit : Byte) : DWORD;
begin
  Result := AValue and not (1 shl Bit);
end;

function SetBit(const AValue : DWORD; const Bit : Byte) : DWORD;
begin
  Result := AValue or (DWORD(1) shl DWORD(Bit));
end;

function EnableBit(const AValue : DWORD; const Bit : Byte; const Enable : Boolean) : DWORD;
begin
  Result := (AValue or (DWORD(1) shl Bit)) xor (DWORD(not Enable) shl Bit);
end;

function GetBitsValue(const AValue : DWORD; const BitI, BitF : Byte) : DWORD;
var
  i, j : Byte;
begin
  Result := 0;
  j := 0;
  for i := BitF to BitI do
  begin
    if GetBit(AValue, i) then
      Result := Result + (DWORD(1) shl j);
    inc(j);
  end;
end;

function ByteToBinStr(AValue : Byte) : string;
const
  Bits : array [1 .. 8] of Byte = (128, 64, 32, 16, 8, 4, 2, 1);
var
  i : Integer;
begin
  Result := '00000000';
  if (AValue <> 0) then
    for i := 1 to 8 do
      if (AValue and Bits[i]) <> 0 then
        Result[i] := '1';
end;

function WordToBinStr(AValue : Word) : string;
const
  Bits : array [1 .. 16] of Word = (32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1);
var
  i : Integer;
begin
  Result := '0000000000000000';
  if (AValue <> 0) then
    for i := 1 to 16 do
      if (AValue and Bits[i]) <> 0 then
        Result[i] := '1';
end;


function BytePosEx(const APattern, ABuffer : array of Byte; Offset : Integer = 0) : Integer;
type
  TByteArray = array of byte;
var
  LMax{$IFNDEF CPUX64}, i, j, MaxBuffer {$ENDIF} : Integer;
  Found : Boolean;
  LPatternAddr : PByte;
  LStart : Byte;
  {$IFDEF CPUX64}i, j, MaxBuffer : NativeUInt; {$ENDIF}
begin
  LMax := High(ABuffer) - High(APattern);
  if (Offset <= LMax) and (High(APattern) >= 0) and (Offset >= 0) then
  begin
    LPatternAddr := @APattern[0];
    LStart := LPatternAddr^;
    i := NativeUInt(@ABuffer[Offset]);
    //Allow to compile on old Delphi versions,  (avoid internal compiler error)
    MaxBuffer := {$IFDEF CPUX64}NativeUInt(@ABuffer[LMax]) {$ELSE} Integer(@ABuffer[LMax]); {$ENDIF};
    while  i <= MaxBuffer  do
    begin
      if (PByte(i)^ = LStart) then
      begin
        Found := true;
        for j := 1 to High(APattern) do
          if (PByte(i + j)^ <> TByteArray(LPatternAddr)[j]) then
          begin
            Found := false;
            Break;
          end;

        if Found then
        begin
          Result  := (i - {$IFDEF CPUX64}NativeUInt(@ABuffer[0]){$ELSE}Integer(@ABuffer[0]){$ENDIF});
          Exit;
        end;
      end;
      inc(i);
    end;
  end;
  Result := - 1;
end;

{ TSMBios }

procedure TSMBios.Init;
begin
  FRawSMBIOSData.SMBIOSTableData := nil;

  FSMBiosTablesList := nil;
  FBaseBoardInfo := nil;
  FEnclosureInfo := nil;
  FProcessorInfo := nil;
end;

constructor TSMBios.Create(LoadBiosData : Boolean = true);
begin
  inherited Create;
  Init;
  if LoadBiosData then
  begin
    {$IFDEF MSWINDOWS}
    {$IFDEF USEWMI}
      LoadSMBIOSWMI('', '', '');
    {$ELSE}
      LoadSMBIOSWinAPI;
    {$ENDIF}
    {$ENDIF MSWINDOWS}
    {$IFDEF UNIX}
      LoadSMBIOSLinux;
    {$ENDIF}
    {$IFDEF MACOS}
      LoadSMBIOS_OSX;
    {$ENDIF MACOS}
      FSMBiosTablesList := GetSMBiosTablesList();
      ReadSMBiosTables;
  end;
end;

constructor TSMBios.Create(const FileName : string);
begin
  inherited Create;
  Init;
  LoadFromFile(FileName);
  FSMBiosTablesList := GetSMBiosTablesList;
  ReadSMBiosTables;
end;

{$IFDEF MSWINDOWS}
{$IFDEF USEWMI}

constructor TSMBios.Create(const RemoteMachine, UserName, Password : string);
begin
  inherited Create;
  Init;
  LoadSMBIOSWMI(RemoteMachine, UserName, Password);
  FSMBiosTablesList := GetSMBiosTablesList;
  ReadSMBiosTables;
end;
{$ENDIF}
{$ENDIF MSWINDOWS}

procedure TSMBios.ClearSMBiosTables;
var
  i : Integer;
begin
  if FBiosInfo <> nil then
  begin
    FBiosInfo.Free;
    FBiosInfo := nil;
  end;

  if FSysInfo <> nil then
  begin
    FSysInfo.Free;
    FSysInfo := nil;
  end;

  for i := 0 to Length(FOEMStringsInfo) - 1 do
    FOEMStringsInfo[i].Free;

  for i := 0 to Length(FEnclosureInfo) - 1 do
    FEnclosureInfo[i].Free;

  for i := 0 to Length(FCacheInfo) - 1 do
    FCacheInfo[i].Free;

  for i := 0 to Length(FProcessorInfo) - 1 do
    FProcessorInfo[i].Free;

  for i := 0 to Length(FPortConnectorInfo) - 1 do
    FPortConnectorInfo[i].Free;

  for i := 0 to Length(FSystemSlotInfo) - 1 do
    FSystemSlotInfo[i].Free;

  for i := 0 to Length(FSystemConfInfo) - 1 do
    FSystemConfInfo[i].Free;

  for i := 0 to Length(FPhysicalMemoryArrayInfo) - 1 do
    FPhysicalMemoryArrayInfo[i].Free;

  for i := 0 to Length(FOnBoardSystemInfo) - 1 do
    FOnBoardSystemInfo[i].Free;

  for i := 0 to Length(FElectricalCurrentProbeInformation) - 1 do
    FElectricalCurrentProbeInformation[i].Free;

  for i := 0 to Length(FTemperatureProbeInformation) - 1 do
    FTemperatureProbeInformation[i].Free;

  for i := 0 to Length(FCoolingDeviceInformation) - 1 do
    FCoolingDeviceInformation[i].Free;

  for i := 0 to Length(FVoltageProbeInformation) - 1 do
    FVoltageProbeInformation[i].Free;

  for i := 0 to Length(FBuiltInPointingDeviceInformation) - 1 do
    FBuiltInPointingDeviceInformation[i].Free;

  for i := 0 to Length(FMemoryDeviceInfo) - 1 do
    FMemoryDeviceInfo[i].Free;

  for i := 0 to Length(FMemoryArrayMappedAddressInformation) - 1 do
    FMemoryArrayMappedAddressInformation[i].Free;

  for i := 0 to Length(FMemoryDeviceMappedAddressInformation) - 1 do
    FMemoryDeviceMappedAddressInformation[i].Free;

  for i := 0 to Length(FBatteryInformation) - 1 do
    FBatteryInformation[i].Free;

  for i := 0 to Length(FBIOSLanguageInfo) - 1 do
    FBIOSLanguageInfo[i].Free;

  for i := 0 to Length(FBaseBoardInfo) - 1 do
    FBaseBoardInfo[i].Free;

  for i := 0 to Length(FMemoryControllerInfo) - 1 do
    FMemoryControllerInfo[i].Free;

  for i := 0 to Length(FMemoryModuleInfo) - 1 do
    FMemoryModuleInfo[i].Free;

  for i := 0 to Length(FGroupAssociationsInformation) - 1 do
    FGroupAssociationsInformation[i].Free;
end;

destructor TSMBios.Destroy;
begin
  ClearSMBiosTables;

  if Assigned(FRawSMBIOSData.SMBIOSTableData) and (FRawSMBIOSData.Length > 0) then
  begin
    FreeMem(FRawSMBIOSData.SMBIOSTableData);
    FRawSMBIOSData.SMBIOSTableData := nil;
  end;

  Inherited;
end;

procedure TSMBios.FindAndLoadFromFile(const FileName : string);
var
  FileStream : TFileStream;
  MagicNumber : DWORD;
  BytesRead : Integer;
  SMBIOSEntryPoint : TSmBiosEntryPoint;
  CheckSum : Byte;
  i : Integer;
  Offset : Integer;
begin
  Offset := - 1;
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    FileStream.Position := 0;
    FillChar(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint), #0);
    repeat
      BytesRead := FileStream.Read(MagicNumber, SizeOf(MagicNumber));
      if (BytesRead > 0) and (MagicNumber = SMBIOS_ANCHOR_STRING_VALUE) then
      begin
        FileStream.Position := FileStream.Position - SizeOf(MagicNumber);
        BytesRead := FileStream.Read(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint));
        // '_DMI_'
        if (BytesRead > 0) and (BytePosEx(SMBIOSEntryPoint.IntermediateAnchorString, [$5F, $44, $4D, $49, $5F]) = 0) then
        begin
          CheckSum := 0;
          for i := 0 to SMBIOSEntryPoint.EntryPointLength - 1 do
            CheckSum := CheckSum + PByteArray(@SMBIOSEntryPoint)^[i];

          if CheckSum <> 0 then
            Continue;

          Offset := FileStream.Position; // SMBIOSEntryPoint.StructureTableAddress {- $000C0000};
          if (Offset >= 0) and (Offset < FileStream.Size) then
          begin
            FileStream.Position := Offset;

            if Assigned(FRawSMBIOSData.SMBIOSTableData) then
              FreeMem(FRawSMBIOSData.SMBIOSTableData);

            FRawSMBIOSData.Length := SMBIOSEntryPoint.StructureTableLength;
            GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
            FRawSMBIOSData.DmiRevision := SMBIOSEntryPoint.EntryPointRevision;
            FRawSMBIOSData.SMBIOSMajorVersion := SMBIOSEntryPoint.SMBIOSMajorVersion;
            FRawSMBIOSData.SMBIOSMinorVersion := SMBIOSEntryPoint.SMBIOSMinorVersion;
            FileStream.Read(FRawSMBIOSData.SMBIOSTableData^, FRawSMBIOSData.Length);
            Break;
          end;
        end;
        FileStream.Position := FileStream.Position + 12;
      end
      else
        FileStream.Position := FileStream.Position + 12;
    until BytesRead = 0;
  finally
    FileStream.Free;
  end;

  if Offset = - 1 then
    raise Exception.Create(Format('SMBIOS information not found in file %s', [FileName]));

  FSMBiosTablesList := GetSMBiosTablesList;
  ReadSMBiosTables;
end;

function TSMBios.GetHasBaseBoardInfo : Boolean;
begin
  Result := Length(FBaseBoardInfo) > 0;
end;

function TSMBios.GetHasBatteryInfo : Boolean;
begin
  Result := Length(FBatteryInformation) > 0;
end;

function TSMBios.GetHasBIOSLanguageInfo : Boolean;
begin
  Result := Length(FBIOSLanguageInfo) > 0;
end;

function TSMBios.GetHasBuiltInPointingDeviceInfo : Boolean;
begin
  Result := Length(FBuiltInPointingDeviceInformation) > 0;
end;

function TSMBios.GetHasCacheInfo : Boolean;
begin
  Result := Length(FCacheInfo) > 0;
end;

function TSMBios.GetHasCoolingDeviceInfo : Boolean;
begin
  Result := Length(FCoolingDeviceInformation) > 0;
end;

function TSMBios.GetHasElectricalCurrentProbeInfo : Boolean;
begin
  Result := Length(FElectricalCurrentProbeInformation) > 0;
end;

function TSMBios.GetHasEnclosureInfo : Boolean;
begin
  Result := Length(FEnclosureInfo) > 0;
end;

function TSMBios.GetHasMemoryArrayMappedAddressInfo : Boolean;
begin
  Result := Length(FMemoryArrayMappedAddressInformation) > 0;
end;

function TSMBios.GetHasMemoryControllerInfo : Boolean;
begin
  Result := Length(FMemoryControllerInfo) > 0;
end;

function TSMBios.GetHasMemoryModuleInfo : Boolean;
begin
  Result := Length(FMemoryModuleInfo) > 0;
end;

function TSMBios.GetHasGroupAssociationsInfo : Boolean;
begin
  Result := Length(FGroupAssociationsInformation) > 0;
end;

function TSMBios.GetHasMemoryDeviceInfo : Boolean;
begin
  Result := Length(FMemoryDeviceInfo) > 0;
end;

function TSMBios.GetHasMemoryDeviceMappedAddressInfo : Boolean;
begin
  Result := Length(FMemoryDeviceMappedAddressInformation) > 0;
end;

function TSMBios.GetHasOEMStringsInfo : Boolean;
begin
  Result := Length(FOEMStringsInfo) > 0;
end;

function TSMBios.GetHasOnBoardSystemInfo : Boolean;
begin
  Result := Length(FOnBoardSystemInfo) > 0;
end;

function TSMBios.GetHasPhysicalMemoryArrayInfo : Boolean;
begin
  Result := Length(FPhysicalMemoryArrayInfo) > 0;
end;

function TSMBios.GetHasPortConnectorInfo : Boolean;
begin
  Result := Length(FPortConnectorInfo) > 0;
end;

function TSMBios.GetHasProcessorInfo : Boolean;
begin
  Result := Length(FProcessorInfo) > 0;
end;

function TSMBios.GetHasSystemConfInfo : Boolean;
begin
  Result := Length(FSystemConfInfo) > 0;
end;

function TSMBios.GetHasSystemSlotInfo : Boolean;
begin
  Result := Length(FSystemSlotInfo) > 0;
end;

function TSMBios.GetHasTemperatureProbeInfo : Boolean;
begin
  Result := Length(FTemperatureProbeInformation) > 0;
end;

function TSMBios.GetHasVoltageProbeInfo : Boolean;
begin
  Result := Length(FVoltageProbeInformation) > 0;
end;

procedure TSMBios.SaveToFile(const FileName : string);
Var
  LStream : TFileStream;
begin
  LStream := TFileStream.Create(FileName, fmCreate);
  try
    LStream.WriteBuffer(FRawSMBIOSData, SizeOf(FRawSMBIOSData) - SizeOf(FRawSMBIOSData.SMBIOSTableData));
    LStream.WriteBuffer(FRawSMBIOSData.SMBIOSTableData^[0], FRawSMBIOSData.Length);
  finally
    LStream.Free;
  end;
end;

procedure TSMBios.LoadFromFile(const FileName : string; LoadSMBIOSTables : Boolean  = false);
Var
  LStream : TFileStream;
begin
  LStream :=  TFileStream.Create(FileName, fmOpenRead);
  try
    LStream.ReadBuffer(FRawSMBIOSData, SizeOf(FRawSMBIOSData) - SizeOf(FRawSMBIOSData.SMBIOSTableData));
    if Assigned(FRawSMBIOSData.SMBIOSTableData) then
      FreeMem(FRawSMBIOSData.SMBIOSTableData);
    GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
    LStream.ReadBuffer(FRawSMBIOSData.SMBIOSTableData^[0], FRawSMBIOSData.Length);

    if LoadSMBIOSTables then
    begin
      FSMBiosTablesList := GetSMBiosTablesList;
      ReadSMBiosTables;
    end;

  finally
    LStream.Free;
  end;
end;

function TSMBios.SearchSMBiosTable(TableType : TSMBiosTablesTypes) : Integer;
Var
  index : DWORD;
  Header : TSmBiosTableHeader;
begin
  Index := 0;
  Result := 0;
  repeat
   {$IFDEF FPC}{$HINTS OFF}{$ENDIF}
    Move(FRawSMBIOSData.SMBIOSTableData^[Index], Header, SizeOf(Header));
   {$IFDEF FPC}{$HINTS ON}{$ENDIF}
    if Header.TableType = Byte(Ord(TableType)) then
      Break
    else
    begin
      inc(Index, Header.Length);
      if Index + 1 > RawSMBIOSData.Length then
      begin
        Result := - 1;
        Break;
      end;

      while not ((RawSMBIOSData.SMBIOSTableData^[Index] = Byte(0)) and (RawSMBIOSData.SMBIOSTableData^[Index + 1] = 0)) do
        if Index + 1 > RawSMBIOSData.Length then
        begin
          Result := - 1;
          Break;
        end
        else
          inc(Index);

      inc(Index, 2);
    end;
  until (Index > RawSMBIOSData.Length);

  if Result <> - 1 then
    Result := Index;
end;

function GetSMBiosString(FBuffer : PByteArray;  Entry, index : Integer) : AnsiString;
 {$IFDEF LINUX}
 var
   i : Integer;
   p : PByte;
 begin
   Result := '';
   p := PByte(@FBuffer^[Entry]);
   for i := 1 to Index do
   begin
      while p[0] <> 0 do
      begin
         Result := Result + Chr(p[0]);
         inc(p);
      end;

     if i = Index then
       Break
     else
     begin
       Result := '';
       inc(p);
     end;
   end;
 end;
 {$ELSE}
  var
    i : Integer;
    p : PAnsiChar;
  begin
    Result := '';
    for i := 1 to Index do
    begin
      p := PAnsiChar(@FBuffer^[Entry]);
      if i = Index then
      begin
        Result := p;
        Break;
      end
      else
        inc(Entry, StrLen(p) + 1);
    end;
  end;
 {$ENDIF}

function TSMBios.GetSMBiosString(Entry, index : Integer) : AnsiString;
begin
  Result := uSMBIOS.GetSMBiosString(@RawSMBIOSData.SMBIOSTableData^, Entry, Index);
end;

function TSMBios.GetSMBiosTableEntries(TableType : TSMBiosTablesTypes) : Integer;
Var
  Entry : TSMBiosTableEntry;
{$IFDEF OLDDELPHI}i : Integer;{$ENDIF}
begin
  Result := 0;

{$IFDEF OLDDELPHI}
  for i := Low(FSMBiosTablesList) to High(FSMBiosTablesList) do
  begin
    Entry := FSMBiosTablesList[i];
    if Entry.Header.TableType = Byte(Ord(TableType)) then
      Result := Result + 1;
  end;
{$ELSE}
  for Entry in FSMBiosTablesList do
    if (Entry.Header.TableType <> 127) and (Entry.Header.TableType = Byte(Ord(TableType))) then
      Result := Result + 1;
{$ENDIF}
end;

function TSMBios.GetSMBiosTableNextIndex(
  TableType : TSMBiosTablesTypes;
  Offset    : Integer = 0) : Integer;
Var
  Entry : TSMBiosTableEntry;
{$IFDEF OLDDELPHI}i : Integer;{$ENDIF}
begin
  Result := - 1;

{$IFDEF OLDDELPHI}
  for i := Low(FSMBiosTablesList) to High(FSMBiosTablesList) do
  begin
    Entry := FSMBiosTablesList[i];
    if (Entry.Header.TableType = Byte(Ord(TableType))) and (Entry.index > Offset) then
    begin
      Result := Entry.index;
      Break;
    end;
  end;
{$ELSE}
  for Entry in FSMBiosTablesList do
    if (Entry.Header.TableType = Byte(Ord(TableType))) and (Entry.index > Offset) then
    begin
      Result := Entry.index;
      Break;
    end;
{$ENDIF}
end;

function TSMBios.GetSMBiosTablesCount : Integer;
Var
  index : DWORD;
  Header : TSmBiosTableHeader;
begin
  Result := 0;
  Index := 0;
  repeat
    {$IFDEF FPC}{$HINTS OFF}{$ENDIF}
    Move(FRawSMBIOSData.SMBIOSTableData^[Index], Header, SizeOf(Header));
    {$IFDEF FPC}{$HINTS ON}{$ENDIF}
    inc(Result);

    if Header.TableType = Byte(Ord(EndofTable)) then
      Break;

    inc(Index, Header.Length); // + 1);
    if Index + 1 > FRawSMBIOSData.Length then
      Break;

    while not ((FRawSMBIOSData.SMBIOSTableData^[Index] = Byte(0)) and (FRawSMBIOSData.SMBIOSTableData^[Index + 1] = Byte(0))) do
      if Index + 1 > RawSMBIOSData.Length then
        Break
      else
        inc(Index);

    inc(Index, 2);
  until (Index > FRawSMBIOSData.Length);
end;

function TSMBios.GetSMBiosTablesList : {$IFDEF NOGENERICS}ArrSMBiosTableEntry; {$ELSE} TArray<TSMBiosTableEntry>;{$ENDIF}

Var
  i, index : DWORD;
  Header : TSmBiosTableHeader;
  Entry : TSMBiosTableEntry;
begin
  i := GetSMBiosTablesCount();
  SetLength(Result, i);
  i := 0;
  Index := 0;
  repeat
    {$IFDEF FPC}{$HINTS OFF}{$ENDIF}
    Move(FRawSMBIOSData.SMBIOSTableData^[Index], Header, SizeOf(Header));
    {$IFDEF FPC}{$HINTS ON}{$ENDIF}
    Entry.Header := Header;
    Entry.index := Index;
    Move(Entry, Result[i], SizeOf(Entry));
    inc(i);

    if Header.TableType = Byte(Ord(EndofTable)) then
      Break;

    inc(Index, Header.Length); // + 1);
    if Index + 1 > RawSMBIOSData.Length then
      Break;

    while not ((RawSMBIOSData.SMBIOSTableData^[Index] = 0) and (RawSMBIOSData.SMBIOSTableData^[Index + 1] = 0)) do
      if Index + 1 > RawSMBIOSData.Length then
        Break
      else
        inc(Index);

    inc(Index, 2);
  until (Index > RawSMBIOSData.Length);
end;

function TSMBios.GetSmbiosVersion : string;
begin
  Result := Format('%d.%d', [RawSMBIOSData.SMBIOSMajorVersion, RawSMBIOSData.SMBIOSMinorVersion]);
end;

{$IFDEF MACOS}

procedure TSMBios.LoadSMBIOS_OSX;
const
  sleepimage = '/private/var/vm/sleepimage';
var
  FileStream : TFileStream;
  MagicNumber : DWORD;
  BytesRead : Integer;
  SMBIOSEntryPoint : TSmBiosEntryPoint;
  CheckSum : Byte;
  i : Integer;
  Offset : Integer;
begin
  if not FileExists(sleepimage) then
    raise Exception.Create(Format('The %s file  doesn''t  exist. run "sudo pmset hibernatemode 1" to enable', [sleepimage]));

  FileStream := TFileStream.Create(sleepimage, fmOpenRead);
  try
    FileStream.Position := 0;
    FillChar(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint), #0);
    repeat
      BytesRead := FileStream.Read(MagicNumber, SizeOf(MagicNumber));
      if (BytesRead > 0) and (MagicNumber = SMBIOS_ANCHOR_STRING_VALUE) then
      begin
        FileStream.Position := FileStream.Position - SizeOf(MagicNumber);
        BytesRead := FileStream.Read(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint));
        if (BytesRead > 0) and (SMBIOSEntryPoint.IntermediateAnchorString = '_DMI_') then
        begin
          CheckSum := 0;
          for i := 0 to SMBIOSEntryPoint.EntryPointLength - 1 do
            CheckSum := CheckSum + PByteArray(@SMBIOSEntryPoint)^[i];
          if CheckSum <> 0 then
            Continue;
          Offset := SMBIOSEntryPoint.StructureTableAddress - $000C0000;
          if (Offset >= 0) and (Offset < FileStream.Size) then
          begin
            FileStream.Position := Offset;
            FRawSMBIOSData.Length := SMBIOSEntryPoint.StructureTableLength;

            if Assigned(FRawSMBIOSData.SMBIOSTableData) then
              FreeMem(FRawSMBIOSData.SMBIOSTableData);

            GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
            FRawSMBIOSData.DmiRevision := SMBIOSEntryPoint.EntryPointRevision;
            FRawSMBIOSData.SMBIOSMajorVersion := SMBIOSEntryPoint.SMBIOSMajorVersion;
            FRawSMBIOSData.SMBIOSMinorVersion := SMBIOSEntryPoint.SMBIOSMinorVersion;
            FileStream.Read(FRawSMBIOSData.SMBIOSTableData^, FRawSMBIOSData.Length);
            Exit;
          end;
        end;
        FileStream.Position := FileStream.Position + 12;
      end
      else
        FileStream.Position := FileStream.Position + 12;
    until BytesRead = 0;
  finally
    FileStream.Free;
  end;
end;

{$ENDIF MACOS}
{$IFDEF UNIX}
  const
    DumpSize = Cardinal($000FFFFF - $000C0000 + 1);

{$IFNDEF FPC}
  const
  {$IFDEF UNDERSCOREIMPORTNAME}
    _PU = '_';
  {$ELSE}
    _PU = '';
  {$ENDIF}
    libc = 'libc.so';

    function mmap(Addr: Pointer; Len: NativeUInt; Prot: Integer; Flags: Integer; FileDes: Integer; Off: LongInt): Pointer; cdecl; external libc name _PU + 'mmap';
    function munmap(Addr: Pointer; Len: NativeUInt): Integer; cdecl;  external libc name _PU + 'munmap';


    function DoLoadSMBIOSData(AStream : TStream) : Boolean;
    const
      PROT_READ     =  $01;
      PROT_WRITE    =  $02;
      PROT_EXEC     =  $04;
      PROT_NONE     =  $00;

      MAP_FAILED    = Pointer(-1);
      MAP_SHARED    =  $01;
      MAP_PRIVATE   =  $02;
      MAP_TYPE      =  $0F;
      MAP_FIXED     = $10;
    var
      Mem : THandle;
      Map : Pointer;
    begin
      Result := false;
      Mem := FileOpen('/dev/mem', fmOpenRead);
      if Mem <= 0 then
        RaiseLastOsError
      else if Mem > 0 then
        try
          Map := Mmap(nil, DumpSize, PROT_READ, MAP_SHARED, Mem, $000C0000);
          if Map <> MAP_FAILED then
            try
              AStream.Write(Map^, DumpSize);
              AStream.Position := 0;
              Result := True;
            finally
              munmap(Map, DumpSize);
            end;
        finally
          FileClose(Mem);
        end;
    end;

{$ELSE}
  function DoLoadSMBIOSData(AStream : TStream) : Boolean;
  var
    Mem : THandle;
    Map : Pointer;
  begin
    Result := false;
    Mem := fpOpen('/dev/mem', O_RDONLY, 0);
    if Mem <= 0 then
      RaiseLastOsError
    else if Mem > 0 then
      try
        Map := FpMmap(nil, DumpSize, PROT_READ, MAP_SHARED, Mem, $000C0000);
        if Map <> MAP_FAILED then
          try
            AStream.Write(Map^, DumpSize);
            AStream.Position := 0;
            Result := true;
          finally
            Fpmunmap(Map, DumpSize);
          end;
      finally
        fpClose(Mem);
      end;
  end;
{$ENDIF}

procedure TSMBios.LoadSMBIOSLinux;
var
  MStream : TMemoryStream;
  MagicNumber : DWORD;
  BytesRead : Integer;
  SMBIOSEntryPoint : TSmBiosEntryPoint;
  CheckSum : Byte;
  i : Integer;
  Offset : Integer;
begin
  MStream := TMemoryStream.Create;
  try
    DoLoadSMBIOSData(MStream);
    FillChar(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint), #0);
    repeat
      BytesRead := MStream.Read(MagicNumber, SizeOf(MagicNumber));
      if (BytesRead > 0) and (MagicNumber = SMBIOS_ANCHOR_STRING_VALUE) then
      begin
        MStream.Position := MStream.Position - SizeOf(MagicNumber);
        BytesRead := MStream.Read(SMBIOSEntryPoint, SizeOf(SMBIOSEntryPoint));
        if (BytesRead > 0) and (BytePosEx(SMBIOSEntryPoint.IntermediateAnchorString, [$5F, $44, $4D, $49, $5F]) = 0) then
        begin
          CheckSum := 0;
          for i := 0 to SMBIOSEntryPoint.EntryPointLength - 1 do
            CheckSum := CheckSum + PByteArray(@SMBIOSEntryPoint)^[i];
          if CheckSum <> 0 then
            Continue;
          Offset := SMBIOSEntryPoint.StructureTableAddress - $000C0000;
          if (Offset >= 0) and (Offset < MStream.Size) then
          begin
            MStream.Position := Offset;
            FRawSMBIOSData.Length := SMBIOSEntryPoint.StructureTableLength;
            if Assigned(FRawSMBIOSData.SMBIOSTableData) then
              FreeMem(FRawSMBIOSData.SMBIOSTableData);
            GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
            FRawSMBIOSData.DmiRevision := SMBIOSEntryPoint.EntryPointRevision;
            FRawSMBIOSData.SMBIOSMajorVersion := SMBIOSEntryPoint.SMBIOSMajorVersion;
            FRawSMBIOSData.SMBIOSMinorVersion := SMBIOSEntryPoint.SMBIOSMinorVersion;
            MStream.Read(FRawSMBIOSData.SMBIOSTableData^, FRawSMBIOSData.Length);
            Exit;
          end;
        end;
        MStream.Position := MStream.Position + 12;
      end
      else
        MStream.Position := MStream.Position + 12;
    until BytesRead = 0;
  finally
    MStream.Free;
  end;
end;

{$ENDIF}  //UNIX


{$IFDEF MSWINDOWS}
{$IFNDEF USEWMI}

procedure TSMBios.LoadSMBIOSWinAPI;
type
  // http://msdn.microsoft.com/en-us/library/MSWINDOWS/desktop/ms724379%28v=vs.85%29.aspx
  TFNGetSystemFirmwareTable = function(
    FirmwareTableProviderSignature : DWORD;
    FirmwareTableID                : DWORD;
    out pFirmwareTableBuffer;
    BufferSize : DWORD) : UINT;stdcall;
const
  FirmwareTableProviderSignature = $52534D42; // 'RSMB'
var
  GetSystemFirmwareTable : TFNGetSystemFirmwareTable;
  hModule : Windows.hModule;
  BufferSize : UINT;
  Buffer : PByteArray;
begin
  ZeroMemory(@FRawSMBIOSData, SizeOf(FRawSMBIOSData));
  hModule := GetModuleHandle(kernel32);
{$IFDEF FPC}
  GetSystemFirmwareTable := TFNGetSystemFirmwareTable(GetProcAddress(hModule, 'GetSystemFirmwareTable'));
{$ELSE}
  GetSystemFirmwareTable := GetProcAddress(hModule, 'GetSystemFirmwareTable');
{$ENDIF}
  if Assigned(GetSystemFirmwareTable) then
  begin
    BufferSize := GetSystemFirmwareTable(FirmwareTableProviderSignature, 0, nil^, BufferSize);
    if BufferSize > 0 then
    begin
      if Assigned(FRawSMBIOSData.SMBIOSTableData) then
        FreeMem(FRawSMBIOSData.SMBIOSTableData);

      GetMem(FRawSMBIOSData.SMBIOSTableData, BufferSize - 8);
      GetMem(Buffer, BufferSize);
      try
        GetSystemFirmwareTable(FirmwareTableProviderSignature, 0, Buffer^, BufferSize);
        Move(Buffer^[0], FRawSMBIOSData, 8);
        Move(Buffer^[8], FRawSMBIOSData.SMBIOSTableData^[0], FRawSMBIOSData.Length);
      finally
        FreeMem(Buffer);
      end;
    end
    else
{$IFDEF VER130} RaiseLastWin32Error; {$ELSE} RaiseLastOsError; {$ENDIF}
  end
  else
    Raise Exception.Create('GetSystemFirmwareTable function not found, try switching to WMI Mode');
end;
{$ENDIF}
{$IFDEF USEWMI}

procedure TSMBios.LoadSMBIOSWMI(const RemoteMachine, UserName, Password : string);
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService : OLEVariant;
  FWbemObjectSet : OLEVariant;
  FWbemObject : OLEVariant;
  oEnum : IEnumvariant;
{$IFDEF FPC}
  pCeltFetched : ULONG;
{$ELSE}
  iValue : LongWord;
{$ENDIF}
  vArray : variant;
  Value : Integer;
  i : Integer;
begin;
  ZeroMemory(@FRawSMBIOSData, SizeOf(FRawSMBIOSData));
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  if (RemoteMachine = '') then
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\WMI', '', '')
  else
    FWMIService := FSWbemLocator.ConnectServer(RemoteMachine, 'root\WMI', UserName, Password);

  FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM MSSmBios_RawSMBiosTables', 'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
  if {$IFDEF FPC} oEnum.Next(1, FWbemObject, pCeltFetched){$ELSE}oEnum.Next(1, FWbemObject, iValue){$ENDIF} = 0 then
  begin
    // FSize := FWbemObject.Size;
    if Assigned(FRawSMBIOSData.SMBIOSTableData) then
      FreeMem(FRawSMBIOSData.SMBIOSTableData);

    FRawSMBIOSData.Length := FWbemObject.Size;
    GetMem(FRawSMBIOSData.SMBIOSTableData, FRawSMBIOSData.Length);
    FRawSMBIOSData.DmiRevision := FWbemObject.DmiRevision;
    FRawSMBIOSData.SMBIOSMajorVersion := FWbemObject.SMBIOSMajorVersion;
    FRawSMBIOSData.SMBIOSMinorVersion := FWbemObject.SMBIOSMinorVersion;

    vArray := FWbemObject.SMBiosData;

{$IFDEF FPC} if VarIsArray(vArray) then {$ENDIF} // if (VarType(vArray) and VarArray) <> 0 then
      for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
      begin
        Value := vArray[i];
        FRawSMBIOSData.SMBIOSTableData^[i] := Value;
        if Value in [$20 .. $7E] then
          FDataString := FDataString + AnsiString(Chr(Value))
        else
          FDataString := FDataString + '.';
      end;
    FWbemObject := Unassigned;
  end;
end;
{$ENDIF}
{$ENDIF MSWINDOWS}

procedure TSMBios.ReadSMBiosTables;
var
  LIndex, i, j : Integer;
  LCacheInfo : TCacheInformation;
  LArrMemory : TPhysicalMemoryArrayInformation;
begin
  ClearSMBiosTables;

  FBiosInfo := TBiosInformation.Create;
  FSysInfo := TSystemInformation.Create;

  LIndex := GetSMBiosTableNextIndex(BIOSInformation, - 1);
  if LIndex >= 0 then
    FBiosInfo.RAWBiosInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];

  LIndex := GetSMBiosTableNextIndex(SystemInformation, - 1);
  if LIndex >= 0 then
    FSysInfo.RAWSystemInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];

  SetLength(FOEMStringsInfo, GetSMBiosTableEntries(OEMStrings));
  i := 0;
  LIndex := - 1;
  if Length(FOEMStringsInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(OEMStrings, LIndex);
      if LIndex >= 0 then
      begin
        FOEMStringsInfo[i] := TOEMStringsInformation.Create;
        FOEMStringsInfo[i].RAWOEMStringsInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FBaseBoardInfo, GetSMBiosTableEntries(BaseBoardInformation));
  i := 0;
  LIndex := - 1;
  if Length(FBaseBoardInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(BaseBoardInformation, LIndex);
      if LIndex >= 0 then
      begin
        FBaseBoardInfo[i] := TBaseBoardInformation.Create;
        FBaseBoardInfo[i].RAWBaseBoardInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FEnclosureInfo, GetSMBiosTableEntries(EnclosureInformation));
  i := 0;
  LIndex := - 1;
  if Length(FEnclosureInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(EnclosureInformation, LIndex);
      if LIndex >= 0 then
      begin
        FEnclosureInfo[i] := TEnclosureInformation.Create;
        FEnclosureInfo[i].RAWEnclosureInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FCacheInfo, GetSMBiosTableEntries(CacheInformation));
  i := 0;
  LIndex := - 1;
  if Length(FCacheInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(CacheInformation, LIndex);
      if LIndex >= 0 then
      begin
        FCacheInfo[i] := TCacheInformation.Create;
        FCacheInfo[i].RAWCacheInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FProcessorInfo, GetSMBiosTableEntries(ProcessorInformation));
  i := 0;
  LIndex := - 1;
  if Length(FProcessorInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(ProcessorInformation, LIndex);
      if LIndex >= 0 then
      begin
        FProcessorInfo[i] := TProcessorInformation.Create;
        FProcessorInfo[i].RAWProcessorInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];

        if FProcessorInfo[i].RAWProcessorInformation^.L1CacheHandle > 0 then
          for j := Low(FCacheInfo) to High(FCacheInfo) do
          begin
            LCacheInfo := FCacheInfo[j];
            if LCacheInfo.RAWCacheInformation^.Header.Handle = FProcessorInfo[i].RAWProcessorInformation^.L1CacheHandle then
            begin
              FProcessorInfo[i].L1Chache := LCacheInfo;
              Break;
            end;
          end;

        if FProcessorInfo[i].RAWProcessorInformation^.L2CacheHandle > 0 then
          for j := Low(FCacheInfo) to High(FCacheInfo) do
          begin
            LCacheInfo := FCacheInfo[j];
            if LCacheInfo.RAWCacheInformation^.Header.Handle = FProcessorInfo[i].RAWProcessorInformation^.L2CacheHandle then
            begin
              FProcessorInfo[i].L2Chache := LCacheInfo;
              Break;
            end;
          end;

        if FProcessorInfo[i].RAWProcessorInformation^.L3CacheHandle > 0 then
          for j := Low(FCacheInfo) to High(FCacheInfo) do
          begin
            LCacheInfo := FCacheInfo[j];
            if LCacheInfo.RAWCacheInformation^.Header.Handle = FProcessorInfo[i].RAWProcessorInformation^.L3CacheHandle then
            begin
              FProcessorInfo[i].L3Chache := LCacheInfo;
              Break;
            end;
          end;

        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FPortConnectorInfo, GetSMBiosTableEntries(PortConnectorInformation));
  i := 0;
  LIndex := - 1;
  if Length(FPortConnectorInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(PortConnectorInformation, LIndex);
      if LIndex >= 0 then
      begin
        FPortConnectorInfo[i] := TPortConnectorInformation.Create;
        FPortConnectorInfo[i].RAWPortConnectorInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FSystemSlotInfo, GetSMBiosTableEntries(SystemSlotsInformation));
  i := 0;
  LIndex := - 1;
  if Length(FSystemSlotInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(SystemSlotsInformation, LIndex);
      if LIndex >= 0 then
      begin
        FSystemSlotInfo[i] := TSystemSlotInformation.Create;
        FSystemSlotInfo[i].RAWSystemSlotInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FBIOSLanguageInfo, GetSMBiosTableEntries(BIOSLanguageInformation));
  i := 0;
  LIndex := - 1;
  if Length(FBIOSLanguageInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(BIOSLanguageInformation, LIndex);
      if LIndex >= 0 then
      begin
        FBIOSLanguageInfo[i] := TBIOSLanguageInformation.Create;
        FBIOSLanguageInfo[i].RAWBIOSLanguageInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FSystemConfInfo, GetSMBiosTableEntries(SystemConfigurationOptions));
  i := 0;
  LIndex := - 1;
  if Length(FSystemConfInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(SystemConfigurationOptions, LIndex);
      if LIndex >= 0 then
      begin
        FSystemConfInfo[i] := TSystemConfInformation.Create;
        FSystemConfInfo[i].RAWSystemConfInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FPhysicalMemoryArrayInfo, GetSMBiosTableEntries(PhysicalMemoryArray));
  i := 0;
  LIndex := - 1;
  if Length(FPhysicalMemoryArrayInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(PhysicalMemoryArray, LIndex);
      if LIndex >= 0 then
      begin
        FPhysicalMemoryArrayInfo[i] := TPhysicalMemoryArrayInformation.Create;
        FPhysicalMemoryArrayInfo[i].RAWPhysicalMemoryArrayInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FMemoryDeviceInfo, GetSMBiosTableEntries(MemoryDevice));
  i := 0;
  LIndex := - 1;
  if Length(FMemoryDeviceInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(MemoryDevice, LIndex);
      if LIndex >= 0 then
      begin
        FMemoryDeviceInfo[i] := TMemoryDeviceInformation.Create;
        FMemoryDeviceInfo[i].RAWMemoryDeviceInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];

        if FMemoryDeviceInfo[i].RAWMemoryDeviceInfo^.PhysicalMemoryArrayHandle > 0 then
          for j := Low(FPhysicalMemoryArrayInfo) to High(FPhysicalMemoryArrayInfo) do
          begin
            LArrMemory := FPhysicalMemoryArrayInfo[j];
            if LArrMemory.RAWPhysicalMemoryArrayInformation^.Header.Handle = FMemoryDeviceInfo[i].RAWMemoryDeviceInfo^.PhysicalMemoryArrayHandle then
            begin
              FMemoryDeviceInfo[i].PhysicalMemoryArray := LArrMemory;
              Break;
            end;
          end;

        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FMemoryModuleInfo, GetSMBiosTableEntries(MemoryModuleInformation));
  i := 0;
  LIndex := - 1;
  if Length(FMemoryModuleInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(MemoryModuleInformation, LIndex);
      if LIndex >= 0 then
      begin
        FMemoryModuleInfo[i] := TMemoryModuleInformation.Create;
        FMemoryModuleInfo[i].RAWMemoryModuleInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FGroupAssociationsInformation, GetSMBiosTableEntries(GroupAssociations));
  i := 0;
  LIndex := - 1;
  if Length(FGroupAssociationsInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(GroupAssociations, LIndex);
      if LIndex >= 0 then
      begin
        FGroupAssociationsInformation[i] := TGroupAssociationsInformation.Create;
        FGroupAssociationsInformation[i].RAWGroupAssociationsInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FBatteryInformation, GetSMBiosTableEntries(PortableBattery));
  i := 0;
  LIndex := - 1;
  if Length(FBatteryInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(PortableBattery, LIndex);
      if LIndex >= 0 then
      begin
        FBatteryInformation[i] := TBatteryInformation.Create;
        FBatteryInformation[i].RAWBatteryInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FMemoryArrayMappedAddressInformation, GetSMBiosTableEntries(MemoryArrayMappedAddress));
  i := 0;
  LIndex := - 1;
  if Length(FMemoryArrayMappedAddressInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(MemoryArrayMappedAddress, LIndex);
      if LIndex >= 0 then
      begin
        FMemoryArrayMappedAddressInformation[i] := TMemoryArrayMappedAddressInformation.Create;
        FMemoryArrayMappedAddressInformation[i].RAWMemoryArrayMappedAddressInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FMemoryDeviceMappedAddressInformation, GetSMBiosTableEntries(MemoryDeviceMappedAddress));
  i := 0;
  LIndex := - 1;
  if Length(FMemoryDeviceMappedAddressInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(MemoryDeviceMappedAddress, LIndex);
      if LIndex >= 0 then
      begin
        FMemoryDeviceMappedAddressInformation[i] := TMemoryDeviceMappedAddressInformation.Create;
        FMemoryDeviceMappedAddressInformation[i].RAWMemoryDeviceMappedAddressInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FBuiltInPointingDeviceInformation, GetSMBiosTableEntries(BuiltinPointingDevice));
  i := 0;
  LIndex := - 1;
  if Length(FBuiltInPointingDeviceInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(BuiltinPointingDevice, LIndex);
      if LIndex >= 0 then
      begin
        FBuiltInPointingDeviceInformation[i] := TBuiltInPointingDeviceInformation.Create;
        FBuiltInPointingDeviceInformation[i].RAWBuiltInPointingDeviceInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FVoltageProbeInformation, GetSMBiosTableEntries(VoltageProbe));
  i := 0;
  LIndex := - 1;
  if Length(FVoltageProbeInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(VoltageProbe, LIndex);
      if LIndex >= 0 then
      begin
        FVoltageProbeInformation[i] := TVoltageProbeInformation.Create;
        FVoltageProbeInformation[i].RAWVoltageProbeInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FCoolingDeviceInformation, GetSMBiosTableEntries(CoolingDevice));
  i := 0;
  LIndex := - 1;
  if Length(FCoolingDeviceInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(CoolingDevice, LIndex);
      if LIndex >= 0 then
      begin
        FCoolingDeviceInformation[i] := TCoolingDeviceInformation.Create;
        FCoolingDeviceInformation[i].RAWCoolingDeviceInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FTemperatureProbeInformation, GetSMBiosTableEntries(TemperatureProbe));
  i := 0;
  LIndex := - 1;
  if Length(FTemperatureProbeInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(TemperatureProbe, LIndex);
      if LIndex >= 0 then
      begin
        FTemperatureProbeInformation[i] := TTemperatureProbeInformation.Create;
        FTemperatureProbeInformation[i].RAWTemperatureProbeInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FElectricalCurrentProbeInformation, GetSMBiosTableEntries(ElectricalCurrentProbe));
  i := 0;
  LIndex := - 1;
  if Length(FElectricalCurrentProbeInformation) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(ElectricalCurrentProbe, LIndex);
      if LIndex >= 0 then
      begin
        FElectricalCurrentProbeInformation[i] := TElectricalCurrentProbeInformation.Create;
        FElectricalCurrentProbeInformation[i].RAWElectricalCurrentProbeInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FOnBoardSystemInfo, GetSMBiosTableEntries(OnBoardDevicesInformation));
  i := 0;
  LIndex := - 1;
  if Length(FOnBoardSystemInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(OnBoardDevicesInformation, LIndex);
      if LIndex >= 0 then
      begin
        FOnBoardSystemInfo[i] := TOnBoardSystemInformation.Create;
        FOnBoardSystemInfo[i].RAWOnBoardSystemInfo := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);

  SetLength(FMemoryControllerInfo, GetSMBiosTableEntries(MemoryControllerInformation));
  i := 0;
  LIndex := - 1;
  if Length(FMemoryControllerInfo) > 0 then
    repeat
      LIndex := GetSMBiosTableNextIndex(MemoryControllerInformation, LIndex);
      if LIndex >= 0 then
      begin
        FMemoryControllerInfo[i] := TMemoryControllerInformation.Create;
        FMemoryControllerInfo[i].RAWMemoryControllerInformation := @RawSMBIOSData.SMBIOSTableData^[LIndex];
        inc(i);
      end;
    until (LIndex = - 1);
end;

{ TEnclosureInformation }

function TEnclosureInformation.AssetTagNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation^.Header.Length, RAWEnclosureInformation^.AssetTagNumber);
end;

function TEnclosureInformation.BootUpStateStr : AnsiString;
begin
  case RAWEnclosureInformation^.BootUpState of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Safe';
    $04 :
      Result := 'Warning';
    $05 :
      Result := 'Critical';
    $06 :
      Result := 'Non-recoverable'
    else
      Result := 'Unknown';
  end;
end;

function TEnclosureInformation.ManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation^.Header.Length, RAWEnclosureInformation^.Manufacturer);
end;

function TEnclosureInformation.PowerSupplyStateStr : AnsiString;
begin
  case RAWEnclosureInformation^.PowerSupplyState of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Safe';
    $04 :
      Result := 'Warning';
    $05 :
      Result := 'Critical';
    $06 :
      Result := 'Non-recoverable'
    else
      Result := 'Unknown';
  end;
end;

function TEnclosureInformation.SerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation^.Header.Length, RAWEnclosureInformation^.SerialNumber);
end;

function TEnclosureInformation.TypeStr : AnsiString;
var
  _Type : Byte;
begin
  _Type := RAWEnclosureInformation^._Type;
  if GetBit(_Type, 7) then
    _Type := EnableBit(RAWEnclosureInformation^._Type, 7, false);

  case _Type of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Desktop';
    $04 :
      Result := 'Low Profile Desktop';
    $05 :
      Result := 'Pizza Box';
    $06 :
      Result := 'Mini Tower';
    $07 :
      Result := 'Tower';
    $08 :
      Result := 'Portable';
    $09 :
      Result := 'LapTop';
    $0A :
      Result := 'Notebook';
    $0B :
      Result := 'Hand Held';
    $0C :
      Result := 'Docking Station';
    $0D :
      Result := 'All in One';
    $0E :
      Result := 'Sub Notebook';
    $0F :
      Result := 'Space-saving';
    $10 :
      Result := 'Lunc Box';
    $11 :
      Result := 'Main Server Chassis';
    $12 :
      Result := 'Expansion Chassis';
    $13 :
      Result := 'SubChassis';
    $14 :
      Result := 'Bus Expansion Chassis';
    $15 :
      Result := 'Peripheral Chassis';
    $16 :
      Result := 'RAID Chassis';
    $17 :
      Result := 'Rack Mount Chassis';
    $18 :
      Result := 'Sealed-case PC';
    $19 :
      Result := 'Multi-system chassis';
    $1A :
      Result := 'Compact PCI';
    $1B :
      Result := 'Advanced TCA';
    $1C :
      Result := 'Blade';
    $1D :
      Result := 'Blade Enclosure'
    else
      Result := 'Unknown';
  end;
end;

function TEnclosureInformation.VersionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWEnclosureInformation^, RAWEnclosureInformation^.Header.Length, RAWEnclosureInformation^.Version);
end;

{ TProcessorInformation }

function TProcessorInformation.AssetTagStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.AssetTag);
end;

function TProcessorInformation.GetProcessorVoltaje : Double;
var
  _Voltaje : Byte;
begin
  Result := 0;
  _Voltaje := RAWProcessorInformation^.Voltaje;
  if GetBit(_Voltaje, 7) then
  begin
    _Voltaje := EnableBit(_Voltaje, 7, false);
    Result := (_Voltaje * 1.0) / 10.0;
  end
  else
  begin
    {
      Bit 0  5V
      Bit 1  3.3V
      Bit 2  2.9V
    }
    if GetBit(_Voltaje, 0) then
      Result := 5
    else if GetBit(_Voltaje, 1) then
      Result := 3.3
    else if GetBit(_Voltaje, 2) then
      Result := 2.9;
  end;
end;

function TProcessorInformation.PartNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.PartNumber);
end;

function TProcessorInformation.ProcessorFamilyStr : AnsiString;
begin
  if RAWProcessorInformation^.ProcessorFamily2 < $FF then
    case RAWProcessorInformation^.ProcessorFamily of
      1 :
        Result := 'Other';
      2 :
        Result := 'Unknown';
      3 :
        Result := '8086';
      4 :
        Result := '80286';
      5 :
        Result := 'Intel386 processor';
      6 :
        Result := 'Intel486 processor';
      7 :
        Result := '8087';
      8 :
        Result := '80287';
      9 :
        Result := '80387';
      10 :
        Result := '80487';
      11 :
        Result := 'Intel® Pentium® processor';
      12 :
        Result := 'Pentium® Pro processor';
      13 :
        Result := 'Pentium® II processor';
      14 :
        Result := 'Pentium® processor with MMX technology';
      15 :
        Result := 'Intel® Celeron® processor';
      16 :
        Result := 'Pentium® II Xeon processor';
      17 :
        Result := 'Pentium® III processor';
      18 :
        Result := 'M1 Family';
      19 :
        Result := 'M2 Family';
      20 :
        Result := 'Intel® Celeron® M processor';
      21 :
        Result := 'Intel® Pentium® 4 HT processor';
      22 .. 23 :
        Result := 'Available for assignment';
      24 :
        Result := 'AMD Duron Processor Family';
      25 :
        Result := 'K5 Family';
      26 :
        Result := 'K6 Family';
      27 :
        Result := 'K6-2';
      28 :
        Result := 'K6-3';
      29 :
        Result := 'AMD Athlon Processor Family';
      30 :
        Result := 'AMD29000 Family';
      31 :
        Result := 'K6-2+';
      32 :
        Result := 'Power PC Family';
      33 :
        Result := 'Power PC 601';
      34 :
        Result := 'Power PC 603';
      35 :
        Result := 'Power PC 603+';
      36 :
        Result := 'Power PC 604';
      37 :
        Result := 'Power PC 620';
      38 :
        Result := 'Power PC x704';
      39 :
        Result := 'Power PC 750';
      40 :
        Result := 'Intel® Core Duo processor';
      41 :
        Result := 'Intel® Core Duo mobile processor';
      42 :
        Result := 'Intel® Core Solo mobile processor';
      43 :
        Result := 'Intel® Atom processor';
      44 .. 47 :
        Result := 'Available for assignment';
      48 :
        Result := 'Alpha Family';
      49 :
        Result := 'Alpha 21064';
      50 :
        Result := 'Alpha 21066';
      51 :
        Result := 'Alpha 21164';
      52 :
        Result := 'Alpha 21164PC';
      53 :
        Result := 'Alpha 21164a';
      54 :
        Result := 'Alpha 21264';
      55 :
        Result := 'Alpha 21364';
      56 :
        Result := 'AMD Turion II Ultra Dual-Core Mobile';
      57 :
        Result := 'AMD Turion II Dual-Core Mobile M Processor';
      58 :
        Result := 'AMD Athlon II Dual-Core M Processor';
      59 :
        Result := 'AMD Opteron 6100 Series Processor';
      60 :
        Result := 'AMD Opteron 4100 Series Processor';
      61 :
        Result := 'AMD Opteron 6200 Series Processor';
      62 :
        Result := 'AMD Opteron 4200 Series Processor';
      63 :
        Result := 'Available for assignment';
      64 :
        Result := 'MIPS Family';
      65 :
        Result := 'MIPS R4000';
      66 :
        Result := 'MIPS R4200';
      67 :
        Result := 'MIPS R4400';
      68 :
        Result := 'MIPS R4600';
      69 :
        Result := 'MIPS R10000';
      70 :
        Result := 'AMD C-Series Processor';
      71 :
        Result := 'AMD E-Series Processor';
      72 :
        Result := 'AMD A-Series Processor';
      73 :
        Result := 'AMD G-Series Processor';
      74 .. 79 :
        Result := 'Available for assignment';
      80 :
        Result := 'SPARC Family';
      81 :
        Result := 'SuperSPARC';
      82 :
        Result := 'microSPARC II';
      83 :
        Result := 'microSPARC IIep';
      84 :
        Result := 'UltraSPARC';
      85 :
        Result := 'UltraSPARC II';
      86 :
        Result := 'UltraSPARC IIi';
      87 :
        Result := 'UltraSPARC III';
      88 :
        Result := 'UltraSPARC IIIi';
      89 .. 95 :
        Result := 'Available for assignment';
      96 :
        Result := '68040 Family';
      97 :
        Result := '68xxx';
      98 :
        Result := '68000';
      99 :
        Result := '68010';
      100 :
        Result := '68020';
      101 :
        Result := '68030';
      102 .. 111 :
        Result := 'Available for assignment';
      112 :
        Result := 'Hobbit Family';
      113 .. 119 :
        Result := 'Available for assignment';
      120 :
        Result := 'Crusoe TM5000 Family';
      121 :
        Result := 'Crusoe TM3000 Family';
      122 :
        Result := 'Efficeon TM8000 Family';
      123 .. 127 :
        Result := 'Available for assignment';
      128 :
        Result := 'Weitek';
      129 :
        Result := 'Available for assignment';
      130 :
        Result := 'Itanium processor';
      131 :
        Result := 'AMD Athlon 64 Processor Family';
      132 :
        Result := 'AMD Opteron Processor Family';
      133 :
        Result := 'AMD Sempron Processor Family';
      134 :
        Result := 'AMD Turion 64 Mobile Technology';
      135 :
        Result := 'Dual-Core AMD Opteron Processor';
      136 :
        Result := 'AMD Athlon 64 X2 Dual-Core Processor';
      137 :
        Result := 'AMD Turion 64 X2 Mobile Technology';
      138 :
        Result := 'Quad-Core AMD Opteron Processor';
      139 :
        Result := 'Third-Generation AMD Opteron';
      140 :
        Result := 'AMD Phenom FX Quad-Core Processor';
      141 :
        Result := 'AMD Phenom X4 Quad-Core Processor';
      142 :
        Result := 'AMD Phenom X2 Dual-Core Processor';
      143 :
        Result := 'AMD Athlon X2 Dual-Core Processor';
      144 :
        Result := 'PA-RISC Family';
      145 :
        Result := 'PA-RISC 8500';
      146 :
        Result := 'PA-RISC 8000';
      147 :
        Result := 'PA-RISC 7300LC';
      148 :
        Result := 'PA-RISC 7200';
      149 :
        Result := 'PA-RISC 7100LC';
      150 :
        Result := 'PA-RISC 7100';
      151 .. 159 :
        Result := 'Available for assignment';
      160 :
        Result := 'V30 Family';
      161 :
        Result := 'Quad-Core Intel® Xeon® processor 3200 Series';
      162 :
        Result := 'Dual-Core Intel® Xeon® processor 3000 Series';
      163 :
        Result := 'Quad-Core Intel® Xeon® processor 5300 Series';
      164 :
        Result := 'Dual-Core Intel® Xeon® processor 5100 Series';
      165 :
        Result := 'Dual-Core Intel® Xeon® processor 5000 Series';
      166 :
        Result := 'Dual-Core Intel® Xeon® processor LV';
      167 :
        Result := 'Dual-Core Intel® Xeon® processor ULV';
      168 :
        Result := 'Dual-Core Intel® Xeon® processor';
      169 :
        Result := 'Quad-Core Intel® Xeon® processor';
      170 :
        Result := 'Quad-Core Intel® Xeon® processor';
      171 :
        Result := 'Dual-Core Intel® Xeon® processor';
      172 :
        Result := 'Dual-Core Intel® Xeon® processor';
      173 :
        Result := 'Quad-Core Intel® Xeon® processor';
      174 :
        Result := 'Quad-Core Intel® Xeon® processor';
      175 :
        Result := 'Multi-Core Intel® Xeon® processor';
      176 :
        Result := 'Pentium® III Xeon processor';
      177 :
        Result := 'Pentium® III Processor with Intel';
      178 :
        Result := 'Pentium® 4 Processor';
      179 :
        Result := 'Intel® Xeon® processor';
      180 :
        Result := 'AS400 Family';
      181 :
        Result := 'Intel® Xeon processor MP';
      182 :
        Result := 'AMD Athlon XP Processor Family';
      183 :
        Result := 'AMD Athlon MP Processor Family';
      184 :
        Result := 'Intel® Itanium® 2 processor';
      185 :
        Result := 'Intel® Pentium® M processor';
      186 :
        Result := 'Intel® Celeron® D processor';
      187 :
        Result := 'Intel® Pentium® D processor';
      188 :
        Result := 'Intel® Pentium® Processor Extreme';
      189 :
        Result := 'Intel® Core Solo Processor';
      190 :
        Result := 'Reserved';
      191 :
        Result := 'Intel® Core 2 Duo Processor';
      192 :
        Result := 'Intel® Core 2 Solo processor';
      193 :
        Result := 'Intel® Core 2 Extreme processor';
      194 :
        Result := 'Intel® Core 2 Quad processor';
      195 :
        Result := 'Intel® Core 2 Extreme mobile';
      196 :
        Result := 'Intel® Core 2 Duo mobile processor';
      197 :
        Result := 'Intel® Core 2 Solo mobile processor';
      198 :
        Result := 'Intel® Core i7 processor';
      199 :
        Result := 'Dual-Core Intel® Celeron® processor';
      200 :
        Result := 'IBM390 Family';
      201 :
        Result := 'G4';
      202 :
        Result := 'G5';
      203 :
        Result := 'ESA/390 G6';
      204 :
        Result := 'z/Architectur base';
      205 :
        Result := 'Intel® Core i5 processor';
      206 :
        Result := 'Intel® Core i3 processor';
      207 .. 209 :
        Result := 'Available for assignment';
      210 :
        Result := 'VIA C7-M Processor Family';
      211 :
        Result := 'VIA C7-D Processor Family';
      212 :
        Result := 'VIA C7 Processor Family';
      213 :
        Result := 'VIA Eden Processor Family';
      214 :
        Result := 'Multi-Core Intel® Xeon® processor';
      215 :
        Result := 'Dual-Core Intel® Xeon® processor 3xxx Series';
      216 :
        Result := 'Quad-Core Intel® Xeon® processor 3xxx Series';
      217 :
        Result := 'VIA Nano Processor Family';
      218 :
        Result := 'Dual-Core Intel® Xeon® processor 5xxx Series';
      219 :
        Result := 'Quad-Core Intel® Xeon® processor 5xxx Series';
      220 :
        Result := 'Available for assignment';
      221 :
        Result := 'Dual-Core Intel® Xeon® processor 7xxx Series';
      222 :
        Result := 'Quad-Core Intel® Xeon® processor 7xxx Series';
      223 :
        Result := 'Multi-Core Intel® Xeon® processor 7xxx Series';
      224 :
        Result := 'Multi-Core Intel® Xeon® processor 3400 Series';
      225 .. 229 :
        Result := 'Available for assignment';
      230 :
        Result := 'Embedded AMD Opteron Quad-Core Processor Family';
      231 :
        Result := 'AMD Phenom Triple-Core Processor Family';
      232 :
        Result := 'AMD Turion Ultra Dual-Core Mobile Processor Family';
      233 :
        Result := 'AMD Turion Dual-Core Mobile Processor Family';
      234 :
        Result := 'AMD Athlon Dual-Core Processor Family';
      235 :
        Result := 'AMD Sempron SI Processor Family';
      236 :
        Result := 'AMD Phenom II Processor Family';
      237 :
        Result := 'AMD Athlon II Processor Family';
      238 :
        Result := 'Six-Core AMD Opteron Processor Family';
      239 :
        Result := 'AMD Sempron M Processor Family';
      240 .. 249 :
        Result := 'Available for assignment';
      250 :
        Result := 'i860';
      251 :
        Result := 'i960';
      252 .. 253 :
        Result := 'Available for assignment';
      254 :
        Result := 'Indicator to obtain the processor family from the Processor';
      255 :
        Result := 'Reserved';
      else
        Result := 'Unknown';
    end
  else
    case RAWProcessorInformation^.ProcessorFamily2 of
      256 .. 259, 262 .. 279, 282 .. 299, 303 .. 319, 321 .. 349, 351 .. 499, 501 .. 511 :
        Result := 'These values are available for assignment';
      260 :
        Result := 'SH-3';
      261 :
        Result := 'SH-4';
      280 :
        Result := 'ARM';
      281 :
        Result := 'StrongARM';
      300 :
        Result := '6x86';
      301 :
        Result := 'MediaGX';
      302 :
        Result := 'MII';
      320 :
        Result := 'WinChip';
      350 :
        Result := 'DSP';
      500 :
        Result := 'Video Processor';
      512 .. 65533 :
        Result := 'Available for assignment';
      65534 .. 65535 :
        Result := 'Reserved'
      else
        Result := 'Unknown';
    end;
end;

function TProcessorInformation.ProcessorManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.ProcessorManufacturer);
end;

function TProcessorInformation.ProcessorTypeStr : AnsiString;
begin
  case RAWProcessorInformation^.ProcessorType of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Central Processor';
    $04 :
      Result := 'Math Processor';
    $05 :
      Result := 'DSP Processor';
    $06 :
      Result := 'Video Processor'
    else
      Result := 'Unknown';
  end;
end;

function TProcessorInformation.ProcessorUpgradeStr : AnsiString;
begin
  case RAWProcessorInformation^.ProcessorUpgrade of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Daughter Board';
    $04 :
      Result := 'ZIF Socket';
    $05 :
      Result := 'Replaceable Piggy Back';
    $06 :
      Result := 'None';
    $07 :
      Result := 'LIF Socket';
    $08 :
      Result := 'Slot 1';
    $09 :
      Result := 'Slot 2';
    $0A :
      Result := '370-pin socket';
    $0B :
      Result := 'Slot A';
    $0C :
      Result := 'Slot M';
    $0D :
      Result := 'Socket 423';
    $0E :
      Result := 'Socket A (Socket 462)';
    $0F :
      Result := 'Socket 478';
    $10 :
      Result := 'Socket 754';
    $11 :
      Result := 'Socket 940';
    $12 :
      Result := 'Socket 939';
    $13 :
      Result := 'Socket mPGA604';
    $14 :
      Result := 'Socket LGA771';
    $15 :
      Result := 'Socket LGA775';
    $16 :
      Result := 'Socket S1';
    $17 :
      Result := 'Socket AM2';
    $18 :
      Result := 'Socket F (1207)';
    $19 :
      Result := 'Socket LGA1366';
    $1A :
      Result := 'Socket G34';
    $1B :
      Result := 'Socket AM3';
    $1C :
      Result := 'Socket C32';
    $1D :
      Result := 'Socket LGA1156';
    $1E :
      Result := 'Socket LGA1567';
    $1F :
      Result := 'Socket PGA988A';
    $20 :
      Result := 'Socket BGA1288';
    $21 :
      Result := 'Socket rPGA988B';
    $22 :
      Result := 'Socket BGA1023';
    $23 :
      Result := 'Socket BGA1224';
    $24 :
      Result := 'Socket BGA1155';
    $25 :
      Result := 'Socket LGA1356';
    $26 :
      Result := 'Socket LGA2011';
    $27 :
      Result := 'Socket FS1';
    $28 :
      Result := 'Socket FS2';
    $29 :
      Result := 'Socket FM1';
    $2A :
      Result := 'Socket FM2'
    else
      Result := 'Unknown';
  end;
end;

function TProcessorInformation.ProcessorVersionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.ProcessorVersion);
end;

function TProcessorInformation.SerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.SerialNumber);
end;

function TProcessorInformation.SocketDesignationStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWProcessorInformation^, RAWProcessorInformation^.Header.Length, RAWProcessorInformation^.SocketDesignation);
end;

{ TCacheInformation }

function TCacheInformation.AssociativityStr : AnsiString;
begin
  case RAWCacheInformation^.Associativity of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Direct Mapped';
    $04 :
      Result := '2-way Set-Associative';
    $05 :
      Result := '4-way Set-Associative';
    $06 :
      Result := 'Fully Associative';
    $07 :
      Result := '8-way Set-Associative';
    $08 :
      Result := '16-way Set-Associative';
    $09 :
      Result := '12-way Set-Associative';
    $0A :
      Result := '24-way Set-Associative';
    $0B :
      Result := '32-way Set-Associative';
    $0C :
      Result := '48-way Set-Associative';
    $0D :
      Result := '64-way Set-Associative';
    $0E :
      Result := '20-way Set-Associative';
    else
      Result := 'Unknown';
  end;
end;

function TCacheInformation.GetCurrentSRAMType : TCacheSRAMTypes;
var
  i : Integer;
begin
  Result := [];
  for i := 0 to 6 do
    if GetBit(RAWCacheInformation^.CurrentSRAMType, i) then
      Include(Result, TCacheSRAMType(i));
end;

function TCacheInformation.GetErrorCorrectionType : TErrorCorrectionType;
begin
  if RAWCacheInformation^.ErrorCorrectionType > 6 then
    Result := ECUnknown
  else
    Result := TErrorCorrectionType(RAWCacheInformation^.ErrorCorrectionType);
end;

function TCacheInformation.GetInstalledCacheSize : Integer;
var
  Granularity : DWORD;
begin
  Granularity := 1;
  if GetBit(RAWCacheInformation^.InstalledSize, 15) then
    Granularity := 64;

  Result := Granularity * EnableBit(RAWCacheInformation^.InstalledSize, 15, false);
end;

function TCacheInformation.GetMaximumCacheSize : Integer;
var
  Granularity : DWORD;
begin
  Granularity := 1;
  if GetBit(RAWCacheInformation^.MaximumCacheSize, 15) then
    Granularity := 64;

  Result := Granularity * EnableBit(RAWCacheInformation^.MaximumCacheSize, 15, false);
end;

function TCacheInformation.GetSupportedSRAMType : TCacheSRAMTypes;
var
  i : Integer;
begin
  Result := [];
  for i := 0 to 6 do
    if GetBit(RAWCacheInformation^.SupportedSRAMType, i) then
      Include(Result, TCacheSRAMType(i));
end;

function TCacheInformation.GetSystemCacheType : TSystemCacheType;
begin
  if RAWCacheInformation^.SystemCacheType > 5 then
    Result := SCUnknown
  else
    Result := TSystemCacheType(RAWCacheInformation^.SystemCacheType);
end;

function TCacheInformation.SocketDesignationStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWCacheInformation^, RAWCacheInformation^.Header.Length, RAWCacheInformation^.SocketDesignation);
end;

{ TPortConnectorInformation }

function TPortConnectorInformation.ExternalReferenceDesignatorStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWPortConnectorInformation^, RAWPortConnectorInformation^.Header.Length,
    RAWPortConnectorInformation^.ExternalReferenceDesignator);
end;

function TPortConnectorInformation.GetConnectorType(Connector : Byte) : AnsiString;
begin
  case Connector of
    $00 :
      Result := 'None';
    $01 :
      Result := 'Centronics';
    $02 :
      Result := 'Mini Centronics';
    $03 :
      Result := 'Proprietary';
    $04 :
      Result := 'DB-25 pin male';
    $05 :
      Result := 'DB-25 pin female';
    $06 :
      Result := 'DB-15 pin male';
    $07 :
      Result := 'DB-15 pin female';
    $08 :
      Result := 'DB-9 pin male';
    $09 :
      Result := 'DB-9 pin female';
    $0A :
      Result := 'RJ-11';
    $0B :
      Result := 'RJ-45';
    $0C :
      Result := '50-pin MiniSCSI';
    $0D :
      Result := 'Mini-DIN';
    $0E :
      Result := 'Micro-DIN';
    $0F :
      Result := 'PS/2';
    $10 :
      Result := 'Infrared';
    $11 :
      Result := 'HP-HIL';
    $12 :
      Result := 'Access Bus (USB)';
    $13 :
      Result := 'SSA SCSI';
    $14 :
      Result := 'Circular DIN-8 male';
    $15 :
      Result := 'Circular DIN-8 female';
    $16 :
      Result := 'On Board IDE';
    $17 :
      Result := 'On Board Floppy';
    $18 :
      Result := '9-pin Dual Inline (pin 10 cut)';
    $19 :
      Result := '25-pin Dual Inline (pin 26 cut)';
    $1A :
      Result := '50-pin Dual Inline';
    $1B :
      Result := '68-pin Dual Inline';
    $1C :
      Result := 'On Board Sound Input from CD-ROM';
    $1D :
      Result := 'Mini-Centronics Type-14';
    $1E :
      Result := 'Mini-Centronics Type-26';
    $1F :
      Result := 'Mini-jack (headphones)';
    $20 :
      Result := 'BNC';
    $21 :
      Result := '1394';
    $22 :
      Result := 'SAS/SATA Plug Receptacle';
    $A0 :
      Result := 'PC-98';
    $A1 :
      Result := 'PC-98Hireso';
    $A2 :
      Result := 'PC-H98';
    $A3 :
      Result := 'PC-98Note';
    $A4 :
      Result := 'PC-98Full';
    $FF :
      Result := 'Other  Use Reference Designator Strings to supply information'
    else
      Result := 'Unknown';
  end;
end;

function TPortConnectorInformation.InternalReferenceDesignatorStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWPortConnectorInformation^, RAWPortConnectorInformation^.Header.Length,
    RAWPortConnectorInformation^.InternalReferenceDesignator);
end;

function TPortConnectorInformation.PortTypeStr : AnsiString;
begin
  case RAWPortConnectorInformation^.PortType of
    $00 :
      Result := 'None';
    $01 :
      Result := 'Parallel Port XT/AT Compatible';
    $02 :
      Result := 'Parallel Port PS/2';
    $03 :
      Result := 'Parallel Port ECP';
    $04 :
      Result := 'Parallel Port EPP';
    $05 :
      Result := 'Parallel Port ECP/EPP';
    $06 :
      Result := 'Serial Port XT/AT Compatible';
    $07 :
      Result := 'Serial Port 16450 Compatible';
    $08 :
      Result := 'Serial Port 16550 Compatible';
    $09 :
      Result := 'Serial Port 16550A Compatible';
    $0A :
      Result := 'SCSI Port';
    $0B :
      Result := 'MIDI Port';
    $0C :
      Result := 'Joy Stick Port';
    $0D :
      Result := 'Keyboard Port';
    $0E :
      Result := 'Mouse Port';
    $0F :
      Result := 'SSA SCSI';
    $10 :
      Result := 'USB';
    $11 :
      Result := 'FireWire (IEEE P1394)';
    $12 :
      Result := 'PCMCIA Type I2';
    $13 :
      Result := 'PCMCIA Type II';
    $14 :
      Result := 'PCMCIA Type III';
    $15 :
      Result := 'Cardbus';
    $16 :
      Result := 'Access Bus Port';
    $17 :
      Result := 'SCSI II';
    $18 :
      Result := 'SCSI Wide';
    $19 :
      Result := 'PC-98';
    $1A :
      Result := 'PC-98-Hireso';
    $1B :
      Result := 'PC-H98';
    $1C :
      Result := 'Video Port';
    $1D :
      Result := 'Audio Port';
    $1E :
      Result := 'Modem Port';
    $1F :
      Result := 'Network Port';
    $20 :
      Result := 'SATA';
    $21 :
      Result := 'SAS';
    $A0 :
      Result := '8251 Compatible';
    $A1 :
      Result := '8251 FIFO Compatible';
    $FF :
      Result := 'Other'
    else
      Result := 'Unknown';
  end;
end;

{ TSystemSlotInformation }

function TSystemSlotInformation.GetCurrentUsage : AnsiString;
begin
  case RAWSystemSlotInformation^.CurrentUsage of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Available';
    $04 :
      Result := 'In use';
    else
      Result := 'Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotDataBusWidth : AnsiString;
begin
  case RAWSystemSlotInformation^.SlotDataBusWidth of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := '8 bit';
    $04 :
      Result := '16 bit';
    $05 :
      Result := '32 bit';
    $06 :
      Result := '64 bit';
    $07 :
      Result := '128 bit';
    $08 :
      Result := '1x or x1';
    $09 :
      Result := '2x or x2';
    $0A :
      Result := '4x or x4';
    $0B :
      Result := '8x or x8';
    $0C :
      Result := '12x or x12';
    $0D :
      Result := '16x or x16';
    $0E :
      Result := '32x or x32'
    else
      Result := 'Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotLength : AnsiString;
begin
  case RAWSystemSlotInformation^.SlotLength of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Short Length';
    $04 :
      Result := 'Long Length'
    else
      Result := 'Unknown';
  end;
end;

function TSystemSlotInformation.GetSlotType : AnsiString;
begin
  case RAWSystemSlotInformation^.SlotType of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'ISA';
    $04 :
      Result := 'MCA';
    $05 :
      Result := 'EISA';
    $06 :
      Result := 'PCI';
    $07 :
      Result := 'PC Card (PCMCIA)';
    $08 :
      Result := 'VL-VESA';
    $09 :
      Result := 'Proprietary';
    $0A :
      Result := 'Processor Card Slot';
    $0B :
      Result := 'Proprietary Memory Card Slot';
    $0C :
      Result := 'I/O Riser Card Slot';
    $0D :
      Result := 'NuBus';
    $0E :
      Result := 'PCI  66MHz Capable';
    $0F :
      Result := 'AGP';
    $10 :
      Result := 'AGP 2X';
    $11 :
      Result := 'AGP 4X';
    $12 :
      Result := 'PCI-X';
    $13 :
      Result := 'AGP 8X';
    $A0 :
      Result := 'PC-98/C20';
    $A1 :
      Result := 'PC-98/C24';
    $A2 :
      Result := 'PC-98/E';
    $A3 :
      Result := 'PC-98/Local Bus';
    $A4 :
      Result := 'PC-98/Card';
    $A5 :
      Result := 'PCI Express';
    $A6 :
      Result := 'PCI Express x1';
    $A7 :
      Result := 'PCI Express x2';
    $A8 :
      Result := 'PCI Express x4';
    $A9 :
      Result := 'PCI Express x8';
    $AA :
      Result := 'PCI Express x16';
    $AB :
      Result := 'PCI Express Gen 2';
    $AC :
      Result := 'PCI Express Gen 2 x1';
    $AD :
      Result := 'PCI Express Gen 2 x2';
    $AE :
      Result := 'PCI Express Gen 2 x4';
    $AF :
      Result := 'PCI Express Gen 2 x8';
    $B0 :
      Result := 'PCI Express Gen 2 x16';
    $B1 :
      Result := 'PCI Express Gen 3';
    $B2 :
      Result := 'PCI Express Gen 3 x1';
    $B3 :
      Result := 'PCI Express Gen 3 x2';
    $B4 :
      Result := 'PCI Express Gen 3 x4';
    $B5 :
      Result := 'PCI Express Gen 3 x8';
    $B6 :
      Result := 'PCI Express Gen 3 x16'
    else
      Result := 'Unknown';
  end;
end;

function TSystemSlotInformation.SlotDesignationStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemSlotInformation^, RAWSystemSlotInformation^.Header.Length, RAWSystemSlotInformation^.SlotDesignation);
end;

{ TBIOSLanguageInformation }

function TBIOSLanguageInformation.GetCurrentLanguageStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBIOSLanguageInformation^, RAWBIOSLanguageInformation^.Header.Length, RAWBIOSLanguageInformation^.CurrentLanguage);
end;

function TBIOSLanguageInformation.GetLanguageString(index : Integer) : AnsiString;
begin
  Result := GetSMBiosString(@RAWBIOSLanguageInformation^, RAWBIOSLanguageInformation^.Header.Length, index);
end;

{ TBiosInformation }

function TBiosInformation.ReleaseDateStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation^.Header.Length, RAWBiosInformation^.ReleaseDate);
end;

function TBiosInformation.VendorStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation^.Header.Length, RAWBiosInformation^.Vendor);
end;

function TBiosInformation.VersionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBiosInformation^, RAWBiosInformation^.Header.Length, RAWBiosInformation^.Version);
end;

{ TSystemInformation }

function TSystemInformation.FamilyStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.Family);
end;

function TSystemInformation.ManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.Manufacturer);
end;

function TSystemInformation.ProductNameStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.ProductName);
end;

function TSystemInformation.SerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.SerialNumber);
end;

function TSystemInformation.SKUNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.SKUNumber);
end;

function TSystemInformation.VersionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemInformation^, RAWSystemInformation^.Header.Length, RAWSystemInformation^.Version);
end;

{ TOEMStringsInformation }

function TOEMStringsInformation.GetOEMString(index : Integer) : AnsiString;
begin
  Result := GetSMBiosString(@RAWOEMStringsInformation^, RAWOEMStringsInformation^.Header.Length, index);
end;

{ TBaseBoardInformation }

function TBaseBoardInformation.AssetTagStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.AssetTag);
end;

function TBaseBoardInformation.BoardTypeStr : AnsiString;
begin
  case RAWBaseBoardInformation^.BoardType of
    $01 :
      Result := 'Unknown';
    $02 :
      Result := 'Other';
    $03 :
      Result := 'Server Blade';
    $04 :
      Result := 'Connectivity Switch';
    $05 :
      Result := 'System Management Module';
    $06 :
      Result := 'Processor Module';
    $07 :
      Result := 'I/O Module';
    $08 :
      Result := 'Memory Module';
    $09 :
      Result := 'Daughter board';
    $0A :
      Result := 'Motherboard (includes processor, memory, and I/O)';
    $0B :
      Result := 'Processor/Memory Module';
    $0C :
      Result := 'Processor/IO Module';
    $0D :
      Result := 'Interconnect Board'
    else
      Result := 'Unknown';
  end;
end;

function TBaseBoardInformation.LocationinChassisStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.LocationinChassis);
end;

function TBaseBoardInformation.ManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.Manufacturer);
end;

function TBaseBoardInformation.ProductStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.Product);
end;

function TBaseBoardInformation.SerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.SerialNumber);
end;

function TBaseBoardInformation.VersionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBaseBoardInformation^, RAWBaseBoardInformation^.Header.Length, RAWBaseBoardInformation^.Version);
end;

{ TSystemConfInformation }

function TSystemConfInformation.GetConfString(index : Integer) : AnsiString;
begin
  Result := GetSMBiosString(@RAWSystemConfInformation^, RAWSystemConfInformation^.Header.Length, index);
end;

{ TPhysicalMemoryArrayInformation }

function TPhysicalMemoryArrayInformation.GetErrorCorrectionStr : AnsiString;
begin
  case RAWPhysicalMemoryArrayInformation^.MemoryErrorCorrection of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'None';
    $04 :
      Result := 'Parity';
    $05 :
      Result := 'Single-bit ECC';
    $06 :
      Result := 'Multi-bit ECC';
    $07 :
      Result := 'CRC'
    else
      Result := 'Unknown';
  end;
end;

function TPhysicalMemoryArrayInformation.GetLocationStr : AnsiString;
begin
  case RAWPhysicalMemoryArrayInformation^.Location of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'System board or motherboard';
    $04 :
      Result := 'ISA add-on card';
    $05 :
      Result := 'EISA add-on card'
    else
      Result := 'Unknown';
  end;
end;

function TPhysicalMemoryArrayInformation.GetUseStr : AnsiString;
begin
  case RAWPhysicalMemoryArrayInformation^.Use of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'System memory';
    $04 :
      Result := 'Video memory';
    $05 :
      Result := 'Flash memory';
    $06 :
      Result := 'Non-volatile RAM';
    $07 :
      Result := 'Cache memory'
    else
      Result := 'Unknown';
  end;
end;

{ TMemoryDeviceInformation }

function TMemoryDeviceInformation.AssetTagStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.AssetTag);
end;

function TMemoryDeviceInformation.GetBankLocatorStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.BankLocator);
end;

function TMemoryDeviceInformation.GetDeviceLocatorStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.DeviceLocator);
end;

function TMemoryDeviceInformation.GetFormFactor : AnsiString;
begin
  case RAWMemoryDeviceInfo^.FormFactor of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'SIMM';
    $04 :
      Result := 'SIP';
    $05 :
      Result := 'Chip';
    $06 :
      Result := 'DIP';
    $07 :
      Result := 'ZIP';
    $08 :
      Result := 'Proprietary Card';
    $09 :
      Result := 'DIMM';
    $0A :
      Result := 'TSOP';
    $0B :
      Result := 'Row of chips';
    $0C :
      Result := 'RIMM';
    $0D :
      Result := 'SODIMM';
    $0E :
      Result := 'SRIMM';
    $0F :
      Result := 'FB-DIMM'
    else
      Result := 'Unknown';
  end;
end;

function TMemoryDeviceInformation.GetMemoryTypeStr : AnsiString;
begin
  case RAWMemoryDeviceInfo^.MemoryType of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'DRAM';
    $04 :
      Result := 'EDRAM';
    $05 :
      Result := 'VRAM';
    $06 :
      Result := 'SRAM';
    $07 :
      Result := 'RAM';
    $08 :
      Result := 'ROM';
    $09 :
      Result := 'FLASH';
    $0A :
      Result := 'EEPROM';
    $0B :
      Result := 'FEPROM';
    $0C :
      Result := 'EPROM';
    $0D :
      Result := 'CDRAM';
    $0E :
      Result := '3DRAM';
    $0F :
      Result := 'SDRAM';
    $10 :
      Result := 'SGRAM';
    $11 :
      Result := 'RDRAM';
    $12 :
      Result := 'DDR';
    $13 :
      Result := 'DDR2';
    $14 :
      Result := 'DDR2 FB-DIMM';
    $15 .. $17 :
      Result := 'Reserved';
    $18 :
      Result := 'DDR3';
    $19 :
      Result := 'FBD2'
    else
      Result := 'Unknown';
  end;
end;

function TMemoryDeviceInformation.GetSize : DWORD;
begin
  if RAWMemoryDeviceInfo^.Size = 0 then
    Result := 0
  else if RAWMemoryDeviceInfo^.Size = $7FFF then
    Result := RAWMemoryDeviceInfo^.ExtendedSize
  else
  begin
    if GetBit(RAWMemoryDeviceInfo^.Size, 15) then
      Result := RAWMemoryDeviceInfo^.Size div 1024
    else
      Result := RAWMemoryDeviceInfo^.Size;
  end;
end;

function TMemoryDeviceInformation.ManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.Manufacturer);
end;

function TMemoryDeviceInformation.PartNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.PartNumber);
end;

function TMemoryDeviceInformation.SerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryDeviceInfo^, RAWMemoryDeviceInfo^.Header.Length, RAWMemoryDeviceInfo^.SerialNumber);
end;

{ TBatteryInformation }

function TBatteryInformation.GetDeviceChemistry : AnsiString;
begin
  case RAWBatteryInfo^.DeviceChemistry of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Lead Acid';
    $04 :
      Result := 'Nickel Cadmium';
    $05 :
      Result := 'Nickel metal hydride';
    $06 :
      Result := 'Lithium-ion';
    $07 :
      Result := 'Zinc air';
    $08 :
      Result := 'Lithium Polymer'
    else
      Result := 'Unknown';
  end;
end;

function TBatteryInformation.GetDeviceNameStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.DeviceName);
end;

function TBatteryInformation.GetLocationStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.Location);
end;

function TBatteryInformation.GetManufacturerDateStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.ManufacturerDate);
end;

function TBatteryInformation.GetManufacturerStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.Manufacturer);
end;

function TBatteryInformation.GetSBDSDeviceChemistryStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.SBDSDeviceChemistry);
end;

function TBatteryInformation.GetSBDSManufacturerDate : TDateTime;
var
  Year, Month, Day : Word;
begin
  // Writeln(WordToBinStr(RAWBatteryInfo^.SBDSManufacturerDate));
  Year := 1980 + GetBitsValue(RAWBatteryInfo^.SBDSManufacturerDate, 15, 9);
  Month := GetBitsValue(RAWBatteryInfo^.SBDSManufacturerDate, 8, 5);
  Day := GetBitsValue(RAWBatteryInfo^.SBDSManufacturerDate, 4, 0);
  Result := EncodeDate(Year, Month, Day);
end;

function TBatteryInformation.GetSBDSVersionNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.SBDSVersionNumber);
end;

function TBatteryInformation.GetSerialNumberStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWBatteryInfo^, RAWBatteryInfo^.Header.Length, RAWBatteryInfo^.SerialNumber);
end;

{ TBuiltInPointingDeviceInformation }

function TBuiltInPointingDeviceInformation.GetInterface : string;
begin
  case RAWBuiltInPointingDeviceInfo^._Interface of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Serial';
    $04 :
      Result := 'PS/2';
    $05 :
      Result := 'Infrared';
    $06 :
      Result := 'HP-HIL';
    $07 :
      Result := 'Bus mouse';
    $08 :
      Result := 'ADB (Apple Desktop Bus)';
    $A0 :
      Result := 'Bus mouse DB-9';
    $A1 :
      Result := 'Bus mouse micro-DIN';
    $A2 :
      Result := 'USB'
    else
      Result := 'Unknown';
  end;
end;

function TBuiltInPointingDeviceInformation.GetType : string;
begin
  case RAWBuiltInPointingDeviceInfo^._Type of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Mouse';
    $04 :
      Result := 'Track Ball';
    $05 :
      Result := 'Track Point';
    $06 :
      Result := 'Glide Point';
    $07 :
      Result := 'Touch Pad';
    $08 :
      Result := 'Touch Screen';
    $09 :
      Result := 'Optical Sensor'
    else
      Result := 'Unknown';
  end;
end;

{ TVoltageProbeInformation }

function TVoltageProbeInformation.GetDescriptionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWVoltageProbeInfo^, RAWVoltageProbeInfo^.Header.Length, RAWVoltageProbeInfo^.Description);
end;

function TVoltageProbeInformation.GetLocation : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWVoltageProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 4, 8);
  if BitStr = '00001' then
    Result := 'Other'
  else if BitStr = '00010' then
    Result := 'Unknown'
  else if BitStr = '00011' then
    Result := 'Processor'
  else if BitStr = '00100' then
    Result := 'Disk'
  else if BitStr = '00101' then
    Result := 'Peripheral Bay'
  else if BitStr = '00110' then
    Result := 'System Management Module'
  else if BitStr = '00111' then
    Result := 'Motherboard'
  else if BitStr = '01000' then
    Result := 'Memory Module'
  else if BitStr = '01001' then
    Result := 'Processor Module'
  else if BitStr = '01010' then
    Result := 'Power Unit'
  else if BitStr = '01011' then
    Result := 'Add-in Card';
end;

function TVoltageProbeInformation.GetStatus : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWVoltageProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 1, 3);
  if BitStr = '001' then
    Result := 'Other'
  else if BitStr = '010' then
    Result := 'Unknown'
  else if BitStr = '011' then
    Result := 'OK'
  else if BitStr = '100' then
    Result := 'Non-critical'
  else if BitStr = '101' then
    Result := 'Critical'
  else if BitStr = '110' then
    Result := 'Non-recoverable';
end;

{ TCoolingDeviceInformation }

function TCoolingDeviceInformation.GetDescriptionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWCoolingDeviceInfo^, RAWCoolingDeviceInfo^.Header.Length, RAWCoolingDeviceInfo^.Description);
end;

function TCoolingDeviceInformation.GetStatus : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWCoolingDeviceInfo^.DeviceTypeandStatus);
  BitStr := Copy(BitStr, 1, 3);
  if BitStr = '001' then
    Result := 'Other'
  else if BitStr = '010' then
    Result := 'Unknown'
  else if BitStr = '011' then
    Result := 'OK'
  else if BitStr = '100' then
    Result := 'Non-critical'
  else if BitStr = '101' then
    Result := 'Critical'
  else if BitStr = '110' then
    Result := 'Non-recoverable';
end;

function TCoolingDeviceInformation.GetDeviceType : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWCoolingDeviceInfo^.DeviceTypeandStatus);
  BitStr := Copy(BitStr, 4, 8);
  if BitStr = '00001' then
    Result := 'Other'
  else if BitStr = '00010' then
    Result := 'Unknown'
  else if BitStr = '00011' then
    Result := 'Fan'
  else if BitStr = '00100' then
    Result := 'Centrifugal Blower'
  else if BitStr = '00101' then
    Result := 'Chip Fan'
  else if BitStr = '00110' then
    Result := 'Cabinet Fan'
  else if BitStr = '00111' then
    Result := 'Power Supply Fan'
  else if BitStr = '01000' then
    Result := 'Heat Pipe'
  else if BitStr = '01001' then
    Result := 'Integrated Refrigeration'
  else if BitStr = '10000' then
    Result := 'Active Cooling'
  else if BitStr = '10001' then
    Result := 'Passive Cooling';
end;

{ TTemperatureProbeInformation }
function TTemperatureProbeInformation.GetDescriptionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWTemperatureProbeInfo^, RAWTemperatureProbeInfo^.Header.Length, RAWTemperatureProbeInfo^.Description);
end;

function TTemperatureProbeInformation.GetLocation : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWTemperatureProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 4, 8);
  if BitStr = '00001' then
    Result := 'Other'
  else if BitStr = '00010' then
    Result := 'Unknown'
  else if BitStr = '00011' then
    Result := 'Processor'
  else if BitStr = '00100' then
    Result := 'Disk'
  else if BitStr = '00101' then
    Result := 'Peripheral Bay'
  else if BitStr = '00110' then
    Result := 'System Management Module'
  else if BitStr = '00111' then
    Result := 'Motherboard'
  else if BitStr = '01000' then
    Result := 'Memory Module'
  else if BitStr = '01001' then
    Result := 'Processor Module'
  else if BitStr = '01010' then
    Result := 'Power Unit'
  else if BitStr = '01011' then
    Result := 'Add-in Card'
  else if BitStr = '01100' then
    Result := 'Front Panel Board'
  else if BitStr = '01101' then
    Result := 'Back Panel Board'
  else if BitStr = '01111' then
    Result := 'Drive Back Plane';
end;

function TTemperatureProbeInformation.GetStatus : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWTemperatureProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 1, 3);
  if BitStr = '001' then
    Result := 'Other'
  else if BitStr = '010' then
    Result := 'Unknown'
  else if BitStr = '011' then
    Result := 'OK'
  else if BitStr = '100' then
    Result := 'Non-critical'
  else if BitStr = '101' then
    Result := 'Critical'
  else if BitStr = '110' then
    Result := 'Non-recoverable';
end;

{ TElectricalCurrentProbeInformation }
function TElectricalCurrentProbeInformation.GetDescriptionStr : AnsiString;
begin
  Result := GetSMBiosString(@RAWElectricalCurrentProbeInfo^, RAWElectricalCurrentProbeInfo^.Header.Length, RAWElectricalCurrentProbeInfo^.Description);
end;

function TElectricalCurrentProbeInformation.GetLocation : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWElectricalCurrentProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 4, 8);
  if BitStr = '00001' then
    Result := 'Other'
  else if BitStr = '00010' then
    Result := 'Unknown'
  else if BitStr = '00011' then
    Result := 'Processor'
  else if BitStr = '00100' then
    Result := 'Disk'
  else if BitStr = '00101' then
    Result := 'Peripheral Bay'
  else if BitStr = '00110' then
    Result := 'System Management Module'
  else if BitStr = '00111' then
    Result := 'Motherboard'
  else if BitStr = '01000' then
    Result := 'Memory Module'
  else if BitStr = '01001' then
    Result := 'Processor Module'
  else if BitStr = '01010' then
    Result := 'Power Unit'
  else if BitStr = '01011' then
    Result := 'Add-in Card';
end;

function TElectricalCurrentProbeInformation.GetStatus : AnsiString;
var
  BitStr : string;
begin
  Result := 'Unknown';
  BitStr := ByteToBinStr(RAWElectricalCurrentProbeInfo^.LocationandStatus);
  BitStr := Copy(BitStr, 1, 3);
  if BitStr = '001' then
    Result := 'Other'
  else if BitStr = '010' then
    Result := 'Unknown'
  else if BitStr = '011' then
    Result := 'OK'
  else if BitStr = '100' then
    Result := 'Non-critical'
  else if BitStr = '101' then
    Result := 'Critical'
  else if BitStr = '110' then
    Result := 'Non-recoverable';
end;

{ TOnBoardSystemInformation }
function TOnBoardSystemInformation.Enabled : Boolean;
begin
  Result := GetBit(RAWOnBoardSystemInfo^.DeviceType, 7);
end;

function TOnBoardSystemInformation.GetDescription : AnsiString;
begin
  Result := GetSMBiosString(@RAWOnBoardSystemInfo^, RAWOnBoardSystemInfo^.Header.Length, RAWOnBoardSystemInfo^.DescriptionString);
end;

function TOnBoardSystemInformation.GetTypeDescription : AnsiString;
var
  _Type : Integer;
begin
  _Type := GetBitsValue(RAWOnBoardSystemInfo^.DeviceType, 6, 0);

  case _Type of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'Video';
    $04 :
      Result := 'SCSI Controller';
    $05 :
      Result := 'Ethernet';
    $06 :
      Result := 'Token Ring';
    $07 :
      Result := 'Sound';
    $08 :
      Result := 'PATA Controller';
    $09 :
      Result := 'SATA Controller';
    $0A :
      Result := 'SAS Controller'
    else
      Result := 'Unknown';
  end;

end;

{ TMemoryControllerInformation }

function TMemoryControllerInformation.GetCurrentInterleaveDescr : string;
begin
  case RAWMemoryControllerInformation^.CurrentInterleave of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'One-Way Interleave';
    $04 :
      Result := 'Two-Way Interleave';
    $05 :
      Result := 'Four-Way Interleave';
    $06 :
      Result := 'Eight-Way Interleave';
    $07 :
      Result := 'Sixteen-Way Interleave'
    else
      Result := 'Unknown';
  end;
end;

function TMemoryControllerInformation.GetSupportedInterleaveDescr : string;
begin
  case RAWMemoryControllerInformation^.SupportedInterleave of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'One-Way Interleave';
    $04 :
      Result := 'Two-Way Interleave';
    $05 :
      Result := 'Four-Way Interleave';
    $06 :
      Result := 'Eight-Way Interleave';
    $07 :
      Result := 'Sixteen-Way Interleave'
    else
      Result := 'Unknown';
  end;
end;

function TMemoryControllerInformation.GetErrorDetectingMethodDescr : string;
begin
  case RAWMemoryControllerInformation^.ErrorDetectingMethod of
    $01 :
      Result := 'Other';
    $02 :
      Result := 'Unknown';
    $03 :
      Result := 'None';
    $04 :
      Result := '8-bit Parity';
    $05 :
      Result := '32-bit ECC';
    $06 :
      Result := '64-bit ECC';
    $07 :
      Result := '128-bit ECC';
    $08 :
      Result := 'CRC'
    else
      Result := 'Unknown';
  end;
end;

function TMemoryModuleInformation.GetSocketDesignationDescr : AnsiString;
begin
  Result := GetSMBiosString(@RAWMemoryModuleInformation^, RAWMemoryModuleInformation^.Header.Length, RAWMemoryModuleInformation^.SocketDesignation);
end;

function TGroupAssociationsInformation.GetGroupName : AnsiString;
begin
  Result := GetSMBiosString(@RAWGroupAssociationsInformation^, RAWGroupAssociationsInformation^.Header.Length, RAWGroupAssociationsInformation^.GroupName);
end;

{$IFDEF MSWINDOWS}
{$IFDEF USEWMI}

initialization

CoInitialize(nil);
{$ENDIF}
{$ENDIF MSWINDOWS}
{$IFDEF MSWINDOWS}
{$IFDEF USEWMI}

finalization

CoUninitialize;
{$ENDIF}
{$ENDIF MSWINDOWS}

end.
