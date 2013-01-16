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
    Vendor: Byte;
    Version: Byte;
    StartingSegment: Word;
    ReleaseDate: Byte;
    BiosRomSize: Byte;
    Characteristics: Int64;
    ExtensionBytes : array [0..1] of Byte;//For version 2.4 and later implementations, two BIOS Characteristics Extension Bytes are defined
    SystemBIOSMajorRelease : Byte;
    SystemBIOSMinorRelease : Byte;
    EmbeddedControllerFirmwareMajorRelease : Byte;
    EmbeddedControllerFirmwareMinorRelease : Byte;

    //helper fields and methods, not part opf the SMBIOS spec.
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
    Manufacturer: Byte;
    ProductName: Byte;
    Version: Byte;
    SerialNumber: Byte;
    UUID: array [0 .. 15] of Byte;
    WakeUpType: Byte;
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
    Manufacturer: Byte;
    Product: Byte;
    Version: Byte;
    SerialNumber: Byte;
    AssetTag  : Byte;
    FeatureFlags : Byte;
    LocationinChassis : Byte;
    ChassisHandle : Word;
    BoardType :  Byte;
    NumberofContainedObjectHandles : Byte;
    //ContainedObjectHandles :  Array of Word;
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
    Manufacturer: Byte;
    &Type: Byte;
    Version: Byte;
    SerialNumber: Byte;
    AssetTagNumber: Byte;
    BootUpState: Byte;
    PowerSupplyState: Byte;
    ThermalState: Byte;
    SecurityStatus: Byte;
    OEM_Defined: DWORD;
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
