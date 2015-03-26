//**************************************************************************************************
//
// uSMBIOS.hpp
// C++ header for the TSMBIOS Project https://github.com/RRUZ/tsmbios
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
// Portions created by Rodrigo Ruz V. are Copyright (C) 2012-2015 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************

#ifndef UsmbiosHPP
#define UsmbiosHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.Generics.Collections.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Usmbios
{
//-- type declarations -------------------------------------------------------
struct TRawSMBIOSData;
typedef TRawSMBIOSData *PRawSMBIOSData;

struct DECLSPEC_DRECORD TRawSMBIOSData
{
	
public:
	System::Byte Used20CallingMethod;
	System::Byte SMBIOSMajorVersion;
	System::Byte SMBIOSMinorVersion;
	System::Byte DmiRevision;
	unsigned Length;
	System::Sysutils::TByteArray *SMBIOSTableData;
};


#pragma option push -b-
enum TSMBiosTablesTypes : unsigned char { BIOSInformation, SystemInformation, BaseBoardInformation, EnclosureInformation, ProcessorInformation, MemoryControllerInformation, MemoryModuleInformation, CacheInformation, PortConnectorInformation, SystemSlotsInformation, OnBoardDevicesInformation, OEMStrings, SystemConfigurationOptions, BIOSLanguageInformation, GroupAssociations, SystemEventLog, PhysicalMemoryArray, MemoryDevice, MemoryErrorInformation, MemoryArrayMappedAddress, MemoryDeviceMappedAddress, BuiltinPointingDevice, PortableBattery, SystemReset, HardwareSecurity, SystemPowerControls, VoltageProbe, CoolingDevice, TemperatureProbe, ElectricalCurrentProbe, OutofBandRemoteAccess, BootIntegrityServicesEntryPoint, SystemBootInformation, 
	x64BitMemoryErrorInformation, ManagementDevice, ManagementDeviceComponent, ManagementDeviceThresholdData, MemoryChannel, IPMIDeviceInformation, SystemPowerSupply, AdditionalInformation, OnboardDevicesExtendedInformation, ManagementControllerHostInterface, Inactive = 126, EndofTable };
#pragma option pop

typedef System::StaticArray<System::AnsiString, 256> Usmbios__1;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSmBiosTableHeader
{
	
public:
	System::Byte TableType;
	System::Byte Length;
	System::Word Handle;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TBiosInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Vendor;
	System::Byte Version;
	System::Word StartingSegment;
	System::Byte ReleaseDate;
	System::Byte BiosRomSize;
	__int64 Characteristics;
	System::StaticArray<System::Byte, 2> ExtensionBytes;
	System::Byte SystemBIOSMajorRelease;
	System::Byte SystemBIOSMinorRelease;
	System::Byte EmbeddedControllerFirmwareMajorRelease;
	System::Byte EmbeddedControllerFirmwareMinorRelease;
};
#pragma pack(pop)


class DELPHICLASS TBiosInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiosInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBiosInfo *RAWBiosInformation;
	System::AnsiString __fastcall VendorStr(void);
	System::AnsiString __fastcall VersionStr(void);
	System::AnsiString __fastcall ReleaseDateStr(void);
public:
	/* TObject.Create */ inline __fastcall TBiosInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiosInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSysInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Manufacturer;
	System::Byte ProductName;
	System::Byte Version;
	System::Byte SerialNumber;
	System::StaticArray<System::Byte, 16> UUID;
	System::Byte WakeUpType;
	System::Byte SKUNumber;
	System::Byte Family;
};
#pragma pack(pop)


class DELPHICLASS TSystemInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSystemInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TSysInfo *RAWSystemInformation;
	System::AnsiString __fastcall ManufacturerStr(void);
	System::AnsiString __fastcall ProductNameStr(void);
	System::AnsiString __fastcall VersionStr(void);
	System::AnsiString __fastcall SerialNumberStr(void);
	System::AnsiString __fastcall SKUNumberStr(void);
	System::AnsiString __fastcall FamilyStr(void);
public:
	/* TObject.Create */ inline __fastcall TSystemInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSystemInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TBaseBoardInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Manufacturer;
	System::Byte Product;
	System::Byte Version;
	System::Byte SerialNumber;
	System::Byte AssetTag;
	System::Byte FeatureFlags;
	System::Byte LocationinChassis;
	System::Word ChassisHandle;
	System::Byte BoardType;
	System::Byte NumberofContainedObjectHandles;
};
#pragma pack(pop)


class DELPHICLASS TBaseBoardInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TBaseBoardInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBaseBoardInfo *RAWBaseBoardInformation;
	System::AnsiString __fastcall BoardTypeStr(void);
	System::AnsiString __fastcall ManufacturerStr(void);
	System::AnsiString __fastcall ProductStr(void);
	System::AnsiString __fastcall VersionStr(void);
	System::AnsiString __fastcall SerialNumberStr(void);
	System::AnsiString __fastcall AssetTagStr(void);
	System::AnsiString __fastcall LocationinChassisStr(void);
public:
	/* TObject.Create */ inline __fastcall TBaseBoardInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBaseBoardInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TEnclosureInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Manufacturer;
	System::Byte Type;
	System::Byte Version;
	System::Byte SerialNumber;
	System::Byte AssetTagNumber;
	System::Byte BootUpState;
	System::Byte PowerSupplyState;
	System::Byte ThermalState;
	System::Byte SecurityStatus;
	unsigned OEM_Defined;
	System::Byte Height;
	System::Byte NumberofPowerCords;
	System::Byte ContainedElementCount;
	System::Byte ContainedElementRecordLength;
};
#pragma pack(pop)


class DELPHICLASS TEnclosureInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TEnclosureInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TEnclosureInfo *RAWEnclosureInformation;
	System::AnsiString __fastcall ManufacturerStr(void);
	System::AnsiString __fastcall VersionStr(void);
	System::AnsiString __fastcall SerialNumberStr(void);
	System::AnsiString __fastcall AssetTagNumberStr(void);
	System::AnsiString __fastcall TypeStr(void);
	System::AnsiString __fastcall BootUpStateStr(void);
	System::AnsiString __fastcall PowerSupplyStateStr(void);
public:
	/* TObject.Create */ inline __fastcall TEnclosureInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TEnclosureInformation(void) { }
	
};

#pragma pack(pop)

#pragma option push -b-
enum TCacheSRAMType : unsigned char { SROther, SRUnknown, SRNon_Burst, SRBurst, SRPipelineBurst, SRSynchronous, SRAsynchronous };
#pragma option pop

typedef System::Set<TCacheSRAMType, TCacheSRAMType::SROther, TCacheSRAMType::SRAsynchronous>  TCacheSRAMTypes;

#pragma option push -b-
enum TErrorCorrectionType : unsigned char { ECFiller, ECOther, ECUnknown, ECNone, ECParity, ECSingle_bitECC, ECMulti_bitECC };
#pragma option pop

typedef System::StaticArray<System::UnicodeString, 7> Usmbios__6;

#pragma option push -b-
enum TSystemCacheType : unsigned char { SCFiller, SCOther, SCUnknown, SCInstruction, SCData, SCUnified };
#pragma option pop

typedef System::StaticArray<System::UnicodeString, 6> Usmbios__7;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCacheInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte SocketDesignation;
	System::Word CacheConfiguration;
	System::Word MaximumCacheSize;
	System::Word InstalledSize;
	System::Word SupportedSRAMType;
	System::Word CurrentSRAMType;
	System::Byte CacheSpeed;
	System::Byte ErrorCorrectionType;
	System::Byte SystemCacheType;
	System::Byte Associativity;
};
#pragma pack(pop)


class DELPHICLASS TCacheInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCacheInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TCacheInfo *RAWCacheInformation;
	System::AnsiString __fastcall SocketDesignationStr(void);
	int __fastcall GetMaximumCacheSize(void);
	int __fastcall GetInstalledCacheSize(void);
	TCacheSRAMTypes __fastcall GetSupportedSRAMType(void);
	TCacheSRAMTypes __fastcall GetCurrentSRAMType(void);
	TErrorCorrectionType __fastcall GetErrorCorrectionType(void);
	TSystemCacheType __fastcall GetSystemCacheType(void);
	System::AnsiString __fastcall AssociativityStr(void);
public:
	/* TObject.Create */ inline __fastcall TCacheInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TCacheInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TProcessorInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte SocketDesignation;
	System::Byte ProcessorType;
	System::Byte ProcessorFamily;
	System::Byte ProcessorManufacturer;
	__int64 ProcessorID;
	System::Byte ProcessorVersion;
	System::Byte Voltaje;
	System::Word ExternalClock;
	System::Word MaxSpeed;
	System::Word CurrentSpeed;
	System::Byte Status;
	System::Byte ProcessorUpgrade;
	System::Word L1CacheHandle;
	System::Word L2CacheHandle;
	System::Word L3CacheHandle;
	System::Byte SerialNumber;
	System::Byte AssetTag;
	System::Byte PartNumber;
	System::Byte CoreCount;
	System::Byte CoreEnabled;
	System::Byte ThreadCount;
	System::Word ProcessorCharacteristics;
	System::Word ProcessorFamily2;
};
#pragma pack(pop)


class DELPHICLASS TProcessorInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TProcessorInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TProcessorInfo *RAWProcessorInformation;
	TCacheInformation* L1Chache;
	TCacheInformation* L2Chache;
	TCacheInformation* L3Chache;
	System::AnsiString __fastcall ProcessorManufacturerStr(void);
	System::AnsiString __fastcall SocketDesignationStr(void);
	System::AnsiString __fastcall ProcessorTypeStr(void);
	System::AnsiString __fastcall ProcessorFamilyStr(void);
	System::AnsiString __fastcall ProcessorVersionStr(void);
	double __fastcall GetProcessorVoltaje(void);
	System::AnsiString __fastcall ProcessorUpgradeStr(void);
	System::AnsiString __fastcall SerialNumberStr(void);
	System::AnsiString __fastcall AssetTagStr(void);
	System::AnsiString __fastcall PartNumberStr(void);
public:
	/* TObject.Create */ inline __fastcall TProcessorInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TProcessorInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPortConnectorInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte InternalReferenceDesignator;
	System::Byte InternalConnectorType;
	System::Byte ExternalReferenceDesignator;
	System::Byte ExternalConnectorType;
	System::Byte PortType;
};
#pragma pack(pop)


class DELPHICLASS TPortConnectorInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TPortConnectorInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TPortConnectorInfo *RAWPortConnectorInformation;
	System::AnsiString __fastcall InternalReferenceDesignatorStr(void);
	System::AnsiString __fastcall GetConnectorType(System::Byte Connector);
	System::AnsiString __fastcall ExternalReferenceDesignatorStr(void);
	System::AnsiString __fastcall PortTypeStr(void);
public:
	/* TObject.Create */ inline __fastcall TPortConnectorInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TPortConnectorInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSystemSlotInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte SlotDesignation;
	System::Byte SlotType;
	System::Byte SlotDataBusWidth;
	System::Byte CurrentUsage;
	System::Byte SlotLength;
	System::Word SlotID;
	System::Byte SlotCharacteristics1;
	System::Byte SlotCharacteristics2;
	System::Word SegmentGroupNumber;
	System::Byte BusNumber;
	System::Byte DeviceFunctionNumber;
};
#pragma pack(pop)


class DELPHICLASS TSystemSlotInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSystemSlotInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TSystemSlotInfo *RAWSystemSlotInformation;
	System::AnsiString __fastcall SlotDesignationStr(void);
	System::AnsiString __fastcall GetSlotType(void);
	System::AnsiString __fastcall GetSlotDataBusWidth(void);
	System::AnsiString __fastcall GetCurrentUsage(void);
	System::AnsiString __fastcall GetSlotLength(void);
public:
	/* TObject.Create */ inline __fastcall TSystemSlotInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSystemSlotInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOEMStringsInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Count;
};
#pragma pack(pop)


class DELPHICLASS TOEMStringsInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOEMStringsInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TOEMStringsInfo *RAWOEMStringsInformation;
	System::AnsiString __fastcall GetOEMString(int index);
public:
	/* TObject.Create */ inline __fastcall TOEMStringsInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TOEMStringsInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSystemConfInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Count;
};
#pragma pack(pop)


class DELPHICLASS TSystemConfInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSystemConfInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TSystemConfInfo *RAWSystemConfInformation;
	System::AnsiString __fastcall GetConfString(int index);
public:
	/* TObject.Create */ inline __fastcall TSystemConfInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSystemConfInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TBIOSLanguageInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte InstallableLanguages;
	System::Byte Flags;
	System::StaticArray<System::Byte, 15> Reserved;
	System::Byte CurrentLanguage;
};
#pragma pack(pop)


class DELPHICLASS TBIOSLanguageInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TBIOSLanguageInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBIOSLanguageInfo *RAWBIOSLanguageInformation;
	System::AnsiString __fastcall GetLanguageString(int index);
	System::AnsiString __fastcall GetCurrentLanguageStr(void);
public:
	/* TObject.Create */ inline __fastcall TBIOSLanguageInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBIOSLanguageInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPhysicalMemoryArrayInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Location;
	System::Byte Use;
	System::Byte MemoryErrorCorrection;
	unsigned MaximumCapacity;
	System::Word MemoryErrorInformationHandle;
	System::Word NumberofMemoryDevices;
	__int64 ExtendedMaximumCapacity;
};
#pragma pack(pop)


class DELPHICLASS TPhysicalMemoryArrayInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TPhysicalMemoryArrayInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TPhysicalMemoryArrayInfo *RAWPhysicalMemoryArrayInformation;
	System::AnsiString __fastcall GetLocationStr(void);
	System::AnsiString __fastcall GetUseStr(void);
	System::AnsiString __fastcall GetErrorCorrectionStr(void);
public:
	/* TObject.Create */ inline __fastcall TPhysicalMemoryArrayInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TPhysicalMemoryArrayInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TMemoryArrayMappedAddress
{
	
public:
	TSmBiosTableHeader Header;
	unsigned StartingAddress;
	unsigned EndingAddress;
	System::Word MemoryArrayHandle;
	System::Byte PartitionWidth;
	__int64 ExtendedStartingAddress;
	__int64 ExtendedEndingAddress;
};
#pragma pack(pop)


class DELPHICLASS TMemoryArrayMappedAddressInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TMemoryArrayMappedAddressInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMemoryArrayMappedAddress *RAWMemoryArrayMappedAddressInfo;
public:
	/* TObject.Create */ inline __fastcall TMemoryArrayMappedAddressInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TMemoryArrayMappedAddressInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TMemoryDeviceMappedAddress
{
	
public:
	TSmBiosTableHeader Header;
	unsigned StartingAddress;
	unsigned EndingAddress;
	System::Word MemoryDeviceHandle;
	System::Word MemoryArrayMappedAddressHandle;
	System::Byte PartitionRowPosition;
	System::Byte InterleavePosition;
	System::Byte InterleavedDataDepth;
	__int64 ExtendedStartingAddress;
	__int64 ExtendedEndingAddress;
};
#pragma pack(pop)


class DELPHICLASS TMemoryDeviceMappedAddressInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TMemoryDeviceMappedAddressInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMemoryDeviceMappedAddress *RAWMemoryDeviceMappedAddressInfo;
public:
	/* TObject.Create */ inline __fastcall TMemoryDeviceMappedAddressInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TMemoryDeviceMappedAddressInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TMemoryDeviceInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Word PhysicalMemoryArrayHandle;
	System::Word MemoryErrorInformationHandle;
	System::Word TotalWidth;
	System::Word DataWidth;
	System::Word Size;
	System::Byte FormFactor;
	System::Byte DeviceSet;
	System::Byte DeviceLocator;
	System::Byte BankLocator;
	System::Byte MemoryType;
	System::Word TypeDetail;
	System::Word Speed;
	System::Byte Manufacturer;
	System::Byte SerialNumber;
	System::Byte AssetTag;
	System::Byte PartNumber;
	System::Byte Attributes;
	unsigned ExtendedSize;
	unsigned ConfiguredMemoryClockSpeed;
};
#pragma pack(pop)


class DELPHICLASS TMemoryDeviceInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TMemoryDeviceInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TMemoryDeviceInfo *RAWMemoryDeviceInfo;
	TPhysicalMemoryArrayInformation* PhysicalMemoryArray;
	unsigned __fastcall GetSize(void);
	System::AnsiString __fastcall GetFormFactor(void);
	System::AnsiString __fastcall GetDeviceLocatorStr(void);
	System::AnsiString __fastcall GetBankLocatorStr(void);
	System::AnsiString __fastcall GetMemoryTypeStr(void);
	System::AnsiString __fastcall ManufacturerStr(void);
	System::AnsiString __fastcall SerialNumberStr(void);
	System::AnsiString __fastcall AssetTagStr(void);
	System::AnsiString __fastcall PartNumberStr(void);
public:
	/* TObject.Create */ inline __fastcall TMemoryDeviceInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TMemoryDeviceInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TBuiltInPointingDevice
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte _Type;
	System::Byte _Interface;
	System::Byte NumberofButtons;
};
#pragma pack(pop)


class DELPHICLASS TBuiltInPointingDeviceInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TBuiltInPointingDeviceInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBuiltInPointingDevice *RAWBuiltInPointingDeviceInfo;
	System::UnicodeString __fastcall GetType(void);
	HIDESBASE System::UnicodeString __fastcall GetInterface(void);
public:
	/* TObject.Create */ inline __fastcall TBuiltInPointingDeviceInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBuiltInPointingDeviceInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TBatteryInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Location;
	System::Byte Manufacturer;
	System::Byte ManufacturerDate;
	System::Byte SerialNumber;
	System::Byte DeviceName;
	System::Byte DeviceChemistry;
	System::Word DesignCapacity;
	System::Word DesignVoltage;
	System::Byte SBDSVersionNumber;
	System::Byte MaximumErrorInBatteryData;
	System::Word SBDSSerialNumber;
	System::Word SBDSManufacturerDate;
	System::Byte SBDSDeviceChemistry;
	System::Byte DesignCapacityMultiplier;
	unsigned OEM_Specific;
};
#pragma pack(pop)


class DELPHICLASS TBatteryInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TBatteryInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBatteryInfo *RAWBatteryInfo;
	System::AnsiString __fastcall GetLocationStr(void);
	System::AnsiString __fastcall GetManufacturerStr(void);
	System::AnsiString __fastcall GetManufacturerDateStr(void);
	System::AnsiString __fastcall GetSerialNumberStr(void);
	System::AnsiString __fastcall GetDeviceNameStr(void);
	System::AnsiString __fastcall GetDeviceChemistry(void);
	System::AnsiString __fastcall GetSBDSVersionNumberStr(void);
	System::TDateTime __fastcall GetSBDSManufacturerDate(void);
	System::AnsiString __fastcall GetSBDSDeviceChemistryStr(void);
public:
	/* TObject.Create */ inline __fastcall TBatteryInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBatteryInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TVoltageProbeInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Description;
	System::Byte LocationandStatus;
	System::Word MaximumValue;
	System::Word MinimumValue;
	System::Word Resolution;
	System::Word Tolerance;
	System::Word Accuracy;
	unsigned OEMdefined;
	System::Word NominalValue;
};
#pragma pack(pop)


class DELPHICLASS TVoltageProbeInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TVoltageProbeInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TVoltageProbeInfo *RAWVoltageProbeInfo;
	System::AnsiString __fastcall GetDescriptionStr(void);
	System::AnsiString __fastcall GetLocation(void);
	System::AnsiString __fastcall GetStatus(void);
public:
	/* TObject.Create */ inline __fastcall TVoltageProbeInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TVoltageProbeInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCoolingDeviceInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Word TemperatureProbeHandle;
	System::Byte DeviceTypeandStatus;
	System::Byte CoolingUnitGroup;
	unsigned OEMdefined;
	System::Word NominalSpeed;
	System::Byte Description;
};
#pragma pack(pop)


class DELPHICLASS TCoolingDeviceInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCoolingDeviceInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TCoolingDeviceInfo *RAWCoolingDeviceInfo;
	System::AnsiString __fastcall GetDescriptionStr(void);
	System::AnsiString __fastcall GetDeviceType(void);
	System::AnsiString __fastcall GetStatus(void);
public:
	/* TObject.Create */ inline __fastcall TCoolingDeviceInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TCoolingDeviceInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTemperatureProbeInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Description;
	System::Byte LocationandStatus;
	System::Word MaximumValue;
	System::Word MinimumValue;
	System::Word Resolution;
	System::Word Tolerance;
	System::Word Accuracy;
	unsigned OEMdefined;
	System::Word NominalValue;
};
#pragma pack(pop)


class DELPHICLASS TTemperatureProbeInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TTemperatureProbeInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TTemperatureProbeInfo *RAWTemperatureProbeInfo;
	System::AnsiString __fastcall GetDescriptionStr(void);
	System::AnsiString __fastcall GetLocation(void);
	System::AnsiString __fastcall GetStatus(void);
public:
	/* TObject.Create */ inline __fastcall TTemperatureProbeInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TTemperatureProbeInformation(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TElectricalCurrentProbeInfo
{
	
public:
	TSmBiosTableHeader Header;
	System::Byte Description;
	System::Byte LocationandStatus;
	System::Word MaximumValue;
	System::Word MinimumValue;
	System::Word Resolution;
	System::Word Tolerance;
	System::Word Accuracy;
	unsigned OEMdefined;
	System::Word NominalValue;
};
#pragma pack(pop)


class DELPHICLASS TElectricalCurrentProbeInformation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TElectricalCurrentProbeInformation : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TElectricalCurrentProbeInfo *RAWElectricalCurrentProbeInfo;
	System::AnsiString __fastcall GetDescriptionStr(void);
	System::AnsiString __fastcall GetLocation(void);
	System::AnsiString __fastcall GetStatus(void);
public:
	/* TObject.Create */ inline __fastcall TElectricalCurrentProbeInformation(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TElectricalCurrentProbeInformation(void) { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TSMBiosTableEntry
{
	
public:
	TSmBiosTableHeader Header;
	int Index;
};


class DELPHICLASS TSMBios;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSMBios : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TRawSMBIOSData FRawSMBIOSData;
	System::AnsiString FDataString;
	TBiosInformation* FBiosInfo;
	TSystemInformation* FSysInfo;
	System::DynamicArray<TBaseBoardInformation*> FBaseBoardInfo;
	// System::TArray__1<TBaseBoardInformation*>  FBaseBoardInfo;
	System::DynamicArray<TEnclosureInformation*> FEnclosureInfo;
	// System::TArray__1<TEnclosureInformation*>  FEnclosureInfo;
	System::DynamicArray<TProcessorInformation*> FProcessorInfo;
	// System::TArray__1<TProcessorInformation*>  FProcessorInfo;
	System::DynamicArray<TCacheInformation*> FCacheInfo;
	// System::TArray__1<TCacheInformation*>  FCacheInfo;
	System::DynamicArray<TPortConnectorInformation*> FPortConnectorInfo;
	// System::TArray__1<TPortConnectorInformation*>  FPortConnectorInfo;
	System::DynamicArray<TSystemSlotInformation*> FSystemSlotInfo;
	// System::TArray__1<TSystemSlotInformation*>  FSystemSlotInfo;
	System::DynamicArray<TSMBiosTableEntry> FSMBiosTablesList;
	// System::TArray__1<TSMBiosTableEntry>  FSMBiosTablesList;
	System::DynamicArray<TOEMStringsInformation*> FOEMStringsInfo;
	// System::TArray__1<TOEMStringsInformation*>  FOEMStringsInfo;
	System::DynamicArray<TBIOSLanguageInformation*> FBIOSLanguageInfo;
	// System::TArray__1<TBIOSLanguageInformation*>  FBIOSLanguageInfo;
	System::DynamicArray<TSystemConfInformation*> FSystemConfInfo;
	// System::TArray__1<TSystemConfInformation*>  FSystemConfInfo;
	System::DynamicArray<TPhysicalMemoryArrayInformation*> FPhysicalMemoryArrayInfo;
	// System::TArray__1<TPhysicalMemoryArrayInformation*>  FPhysicalMemoryArrayInfo;
	System::DynamicArray<TMemoryDeviceInformation*> FMemoryDeviceInformation;
	// System::TArray__1<TMemoryDeviceInformation*>  FMemoryDeviceInformation;
	System::DynamicArray<TBatteryInformation*> FBatteryInformation;
	// System::TArray__1<TBatteryInformation*>  FBatteryInformation;
	System::DynamicArray<TMemoryArrayMappedAddressInformation*> FMemoryArrayMappedAddressInformation;
	// System::TArray__1<TMemoryArrayMappedAddressInformation*>  FMemoryArrayMappedAddressInformation;
	System::DynamicArray<TMemoryDeviceMappedAddressInformation*> FMemoryDeviceMappedAddressInformation;
	// System::TArray__1<TMemoryDeviceMappedAddressInformation*>  FMemoryDeviceMappedAddressInformation;
	System::DynamicArray<TBuiltInPointingDeviceInformation*> FBuiltInPointingDeviceInformation;
	// System::TArray__1<TBuiltInPointingDeviceInformation*>  FBuiltInPointingDeviceInformation;
	System::DynamicArray<TVoltageProbeInformation*> FVoltageProbeInformation;
	// System::TArray__1<TVoltageProbeInformation*>  FVoltageProbeInformation;
	System::DynamicArray<TCoolingDeviceInformation*> FCoolingDeviceInformation;
	// System::TArray__1<TCoolingDeviceInformation*>  FCoolingDeviceInformation;
	System::DynamicArray<TTemperatureProbeInformation*> FTemperatureProbeInformation;
	// System::TArray__1<TTemperatureProbeInformation*>  FTemperatureProbeInformation;
	System::DynamicArray<TElectricalCurrentProbeInformation*> FElectricalCurrentProbeInformation;
	// System::TArray__1<TElectricalCurrentProbeInformation*>  FElectricalCurrentProbeInformation;
	void __fastcall LoadSMBIOSWMI(const System::UnicodeString RemoteMachine, const System::UnicodeString UserName, const System::UnicodeString Password);
	void __fastcall ReadSMBiosTables(void);
	void __fastcall Init(void);
	System::DynamicArray<TSMBiosTableEntry> __fastcall GetSMBiosTablesList(void);
	int __fastcall GetSMBiosTablesCount(void);
	bool __fastcall GetHasBaseBoardInfo(void);
	bool __fastcall GetHasEnclosureInfo(void);
	bool __fastcall GetHasProcessorInfo(void);
	bool __fastcall GetHasCacheInfo(void);
	bool __fastcall GetHasPortConnectorInfo(void);
	bool __fastcall GetHasSystemSlotInfo(void);
	System::UnicodeString __fastcall GetSmbiosVersion(void);
	bool __fastcall GetHasOEMStringsInfo(void);
	bool __fastcall GetHasBIOSLanguageInfo(void);
	bool __fastcall GetHasSystemConfInfo(void);
	bool __fastcall GetHasPhysicalMemoryArrayInfo(void);
	bool __fastcall GetHasMemoryDeviceInfo(void);
	bool __fastcall GetHasBatteryInfo(void);
	bool __fastcall GetHasMemoryArrayMappedAddressInfo(void);
	bool __fastcall GetHasMemoryDeviceMappedAddressInfo(void);
	bool __fastcall GetHasBuiltInPointingDeviceInfo(void);
	bool __fastcall GetHasVoltageProbeInfo(void);
	bool __fastcall GetHasCoolingDeviceInfo(void);
	bool __fastcall GetHasTemperatureProbeInfo(void);
	bool __fastcall GetHasElectricalCurrentProbeInfo(void);
	
public:
	__fastcall TSMBios(void)/* overload */;
	__fastcall TSMBios(const System::UnicodeString FileName)/* overload */;
	__fastcall TSMBios(const System::UnicodeString RemoteMachine, const System::UnicodeString UserName, const System::UnicodeString Password)/* overload */;
	__fastcall virtual ~TSMBios(void);
	int __fastcall SearchSMBiosTable(TSMBiosTablesTypes TableType);
	int __fastcall GetSMBiosTableNextIndex(TSMBiosTablesTypes TableType, int Offset = 0x0);
	int __fastcall GetSMBiosTableEntries(TSMBiosTablesTypes TableType);
	System::AnsiString __fastcall GetSMBiosString(int Entry, int Index);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	__property System::AnsiString DataString = {read=FDataString};
	__property TRawSMBIOSData RawSMBIOSData = {read=FRawSMBIOSData};
	__property System::UnicodeString SmbiosVersion = {read=GetSmbiosVersion};
	__property System::DynamicArray<TSMBiosTableEntry> SMBiosTablesList = {read=FSMBiosTablesList};
	// __property System::TArray__1<TSMBiosTableEntry>  SMBiosTablesList = ...;
	__property TBiosInformation* BiosInfo = {read=FBiosInfo};
	__property TSystemInformation* SysInfo = {read=FSysInfo};
	__property System::DynamicArray<TBaseBoardInformation*> BaseBoardInfo = {read=FBaseBoardInfo};
	// __property System::TArray__1<TBaseBoardInformation*>  BaseBoardInfo = ...;
	__property bool HasBaseBoardInfo = {read=GetHasBaseBoardInfo, nodefault};
	__property System::DynamicArray<TEnclosureInformation*> EnclosureInfo = {read=FEnclosureInfo};
	// __property System::TArray__1<TEnclosureInformation*>  EnclosureInfo = ...;
	__property bool HasEnclosureInfo = {read=GetHasEnclosureInfo, nodefault};
	__property System::DynamicArray<TCacheInformation*> CacheInfo = {read=FCacheInfo};
	// __property System::TArray__1<TCacheInformation*>  CacheInfo = ...;
	__property bool HasCacheInfo = {read=GetHasCacheInfo, nodefault};
	__property System::DynamicArray<TProcessorInformation*> ProcessorInfo = {read=FProcessorInfo};
	// __property System::TArray__1<TProcessorInformation*>  ProcessorInfo = ...;
	__property bool HasProcessorInfo = {read=GetHasProcessorInfo, nodefault};
	__property System::DynamicArray<TPortConnectorInformation*> PortConnectorInfo = {read=FPortConnectorInfo};
	// __property System::TArray__1<TPortConnectorInformation*>  PortConnectorInfo = ...;
	__property bool HasPortConnectorInfo = {read=GetHasPortConnectorInfo, nodefault};
	__property System::DynamicArray<TSystemSlotInformation*> SystemSlotInfo = {read=FSystemSlotInfo};
	// __property System::TArray__1<TSystemSlotInformation*>  SystemSlotInfo = ...;
	__property bool HasSystemSlotInfo = {read=GetHasSystemSlotInfo, nodefault};
	__property System::DynamicArray<TOEMStringsInformation*> OEMStringsInfo = {read=FOEMStringsInfo};
	// __property System::TArray__1<TOEMStringsInformation*>  OEMStringsInfo = ...;
	__property bool HasOEMStringsInfo = {read=GetHasOEMStringsInfo, nodefault};
	__property System::DynamicArray<TBIOSLanguageInformation*> BIOSLanguageInfo = {read=FBIOSLanguageInfo};
	// __property System::TArray__1<TBIOSLanguageInformation*>  BIOSLanguageInfo = ...;
	__property bool HasBIOSLanguageInfo = {read=GetHasBIOSLanguageInfo, nodefault};
	__property System::DynamicArray<TSystemConfInformation*> SystemConfInfo = {read=FSystemConfInfo};
	// __property System::TArray__1<TSystemConfInformation*>  SystemConfInfo = ...;
	__property bool HasSystemConfInfo = {read=GetHasSystemConfInfo, nodefault};
	__property System::DynamicArray<TPhysicalMemoryArrayInformation*> PhysicalMemoryArrayInfo = {read=FPhysicalMemoryArrayInfo};
	// __property System::TArray__1<TPhysicalMemoryArrayInformation*>  PhysicalMemoryArrayInfo = ...;
	__property bool HasPhysicalMemoryArrayInfo = {read=GetHasPhysicalMemoryArrayInfo, nodefault};
	__property System::DynamicArray<TMemoryDeviceInformation*> MemoryDeviceInformation = {read=FMemoryDeviceInformation};
	// __property System::TArray__1<TMemoryDeviceInformation*>  MemoryDeviceInformation = ...;
	__property bool HasMemoryDeviceInfo = {read=GetHasMemoryDeviceInfo, nodefault};
	__property System::DynamicArray<TBatteryInformation*> BatteryInformation = {read=FBatteryInformation};
	// __property System::TArray__1<TBatteryInformation*>  BatteryInformation = ...;
	__property bool HasBatteryInfo = {read=GetHasBatteryInfo, nodefault};
	__property System::DynamicArray<TMemoryArrayMappedAddressInformation*> MemoryArrayMappedAddressInformation = {read=FMemoryArrayMappedAddressInformation};
	// __property System::TArray__1<TMemoryArrayMappedAddressInformation*>  MemoryArrayMappedAddressInformation = ...;
	__property bool HasMemoryArrayMappedAddressInfo = {read=GetHasMemoryArrayMappedAddressInfo, nodefault};
	__property System::DynamicArray<TMemoryDeviceMappedAddressInformation*> MemoryDeviceMappedAddressInformation = {read=FMemoryDeviceMappedAddressInformation};
	// __property System::TArray__1<TMemoryDeviceMappedAddressInformation*>  MemoryDeviceMappedAddressInformation = ...;
	__property bool HasMemoryDeviceMappedAddressInfo = {read=GetHasMemoryDeviceMappedAddressInfo, nodefault};
	__property System::DynamicArray<TBuiltInPointingDeviceInformation*> BuiltInPointingDeviceInformation = {read=FBuiltInPointingDeviceInformation};
	// __property System::TArray__1<TBuiltInPointingDeviceInformation*>  BuiltInPointingDeviceInformation = ...;
	__property bool HasBuiltInPointingDeviceInfo = {read=GetHasBuiltInPointingDeviceInfo, nodefault};
	__property System::DynamicArray<TVoltageProbeInformation*> VoltageProbeInformation = {read=FVoltageProbeInformation};
	// __property System::TArray__1<TVoltageProbeInformation*>  VoltageProbeInformation = ...;
	__property bool HasVoltageProbeInfo = {read=GetHasVoltageProbeInfo, nodefault};
	__property System::DynamicArray<TCoolingDeviceInformation*> CoolingDeviceInformation = {read=FCoolingDeviceInformation};
	// __property System::TArray__1<TCoolingDeviceInformation*>  CoolingDeviceInformation = ...;
	__property bool HasCoolingDeviceInfo = {read=GetHasCoolingDeviceInfo, nodefault};
	__property System::DynamicArray<TTemperatureProbeInformation*> TemperatureProbeInformation = {read=FTemperatureProbeInformation};
	// __property System::TArray__1<TTemperatureProbeInformation*>  TemperatureProbeInformation = ...;
	__property bool HasTemperatureProbeInfo = {read=GetHasTemperatureProbeInfo, nodefault};
	__property System::DynamicArray<TElectricalCurrentProbeInformation*> ElectricalCurrentProbeInformation = {read=FElectricalCurrentProbeInformation};
	// __property System::TArray__1<TElectricalCurrentProbeInformation*>  ElectricalCurrentProbeInformation = ...;
	__property bool HasElectricalCurrentProbeInfo = {read=GetHasElectricalCurrentProbeInfo, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE Usmbios__1 SMBiosTablesDescr;
extern PACKAGE Usmbios__6 ErrorCorrectionTypeStr;
extern PACKAGE Usmbios__7 SystemCacheTypeStr;

}	/* namespace Usmbios */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_USMBIOS)
using namespace Usmbios;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UsmbiosHPP
