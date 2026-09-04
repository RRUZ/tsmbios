const fs = require('node:fs');
const path = require('node:path');
const repo = path.resolve(__dirname, '../..');
const out = path.resolve(__dirname, '../assets');
const source = fs.readFileSync(repo + '/source/uSMBIOS.pas', 'utf8');
const readme = fs.readFileSync(repo + '/README.md', 'utf8');
const properties = ['BiosInfo','SysInfo','BaseBoardInfo','EnclosureInfo','ProcessorInfo','MemoryControllerInfo','MemoryModuleInfo','CacheInfo','PortConnectorInfo','SystemSlotInfo','OnBoardSystemInfo','OEMStringsInfo','SystemConfInfo','BIOSLanguageInfo','GroupAssociationsInformation','SystemEventLogInfo','PhysicalMemoryArrayInfo','MemoryDeviceInfo','MemoryErrorInfo','MemoryArrayMappedAddressInformation','MemoryDeviceMappedAddressInformation','BuiltInPointingDeviceInformation','BatteryInformation','SystemResetInformation','HardwareSecurityInformation','SystemPowerControlsInformation','VoltageProbeInformation','CoolingDeviceInformation','TemperatureProbeInformation','ElectricalCurrentProbeInformation','OutOfBandRemoteAccessInformation','BootIntegrityServicesEntryPointInformation','SystemBootInfo','x64BitMemoryErrorInfo','ManagementDeviceInfo','ManagementDeviceComponentInfo','ManagementDeviceThresholdDataInfo','MemoryChannelInfo','IPMIDeviceInfo','SystemPowerSupplyInfo','AdditionalInformationInfo','OnboardDevicesExtendedInfo','ManagementControllerHostInterfaceInfo','TPMDeviceInfo','ProcessorAdditionalInfo','FirmwareInventoryInfo','StringPropertyInfo'];
const briefs = [
 'BIOS vendor, release, capabilities and ROM size.',
 'System manufacturer, product, UUID and identifying strings.',
 'Baseboard identity, features and the containing chassis.',
 'Chassis type, manufacturer, asset identity and reported state.',
 'Processor sockets, families, core counts and linked caches.',
 'Legacy memory-controller capabilities and supported configurations.',
 'Legacy module size, speed and error status.',
 'Cache level, installed capacity, associativity and error correction.',
 'Internal and external port designators and connector types.',
 'Expansion slot type, usage, width and bus information.',
 'Legacy onboard-device descriptions and enabled state.',
 'Manufacturer-supplied strings stored in the SMBIOS table.',
 'System configuration strings supplied by the manufacturer.',
 'Installed BIOS languages and the current language.',
 'Named groups of related structures, referenced by handle.',
 'Event-log layout, access method and supported descriptors.',
 'Memory-array location, purpose, capacity and error correction.',
 'Individual memory modules, locators, capacity, technology and speed.',
 '32-bit memory error details and reported error addresses.',
 'Address ranges mapped to physical memory arrays.',
 'Address ranges mapped to individual memory devices.',
 'Built-in pointing-device type, interface and button count.',
 'Battery identity, chemistry, design capacity and voltage.',
 'Reset capabilities, counts, limits and watchdog settings.',
 'Firmware-reported password and hardware-security settings.',
 'Scheduled power-on values reported by the firmware.',
 'Voltage-probe description, limits and nominal value when present.',
 'Cooling-device type, location and nominal speed when reported.',
 'Temperature-probe description, limits and nominal value.',
 'Current-probe description, limits and nominal value.',
 'Remote-access connection description and enabled directions.',
 'Boot-integrity entry-point information reported by firmware.',
 'Firmware-reported status of the last system boot.',
 '64-bit memory error details and reported error addresses.',
 'Management-device type, address and addressing scheme.',
 'Links between management devices, components and thresholds.',
 'Threshold values associated with management components.',
 'Memory-channel information and device references.',
 'IPMI interface type, specification revision and address.',
 'Power-supply identity, capacity and linked probe information.',
 'Additional entries referring to fields in other structures.',
 'Onboard-device descriptions and bus addressing information.',
 'Management-controller host interfaces and protocol records.',
 'TPM vendor, specification version and device description.',
 'Processor architecture and the associated processor handle.',
 'Firmware components, versions, state and associated handles.',
 'String properties attached to a parent structure.'
];
const groups = {system:[0,1,2,3,11,12,13,14,31,32,40,45,46],processor:[4,7,44],memory:[5,6,16,17,18,19,20,33,37],expansion:[8,9,10,21,41],management:[15,26,27,28,29,30,34,35,36,38,42],security:[22,23,24,25,39,43]};
const relations = {2:[[3,'Containing chassis']],4:[[7,'L1 / L2 / L3 cache handles'],[44,'Additional processor information']],7:[[4,'Referenced by processors']],14:[[14,'Members are referenced by type and handle']],16:[[17,'Memory devices'],[19,'Mapped address ranges']],17:[[16,'PhysicalMemoryArray object'],[20,'Device address ranges']],19:[[16,'Physical memory array']],20:[[17,'Memory device'],[19,'Array mapped address']],27:[[28,'Temperature-probe handle']],35:[[34,'Management-device handle'],[36,'Threshold-data handle']],37:[[17,'Memory-device handles']],39:[[26,'Voltage-probe handle'],[27,'Cooling-device handle'],[29,'Current-probe handle']],44:[[4,'Referenced processor handle']],45:[[46,'String properties may reference this structure']],46:[[45,'ParentHandle can reference a firmware component']]};
const enumBody = source.match(/TSMBiosTablesTypes\s*=\s*\(([\s\S]*?)\);/)[1].replace(/\/\/[^\n]*/g,'');
const enums = enumBody.split(',').map(s=>s.trim());
const clean = s=>s.replace(/<[^>]*>/g,'').replace(/\s+/g,' ').trim();
const catalog = properties.map((property,id)=>{
 const row = readme.split('\n').find(line=>line.startsWith('| ') && line.includes(`(Type ${id})`));
 if (!row) throw Error('Missing README row '+id);
 const name = row.split('|')[1].trim().replace(/\s*\(Type \d+\)/,'');
 const links = [...row.matchAll(/\[([^\]]+)\]\(([^)]+)\)/g)].map(m=>({label:m[1],url:m[2]}));
 const declaration = source.match(new RegExp('property '+property+': ([^\\r\\n]+)'))[1];
 const cls = declaration.match(/TArray<(\w+)>/)?.[1] || declaration.match(/^(\w+)/)[1];
 const block = source.match(new RegExp('  '+cls+' = class\\s+([\\s\\S]*?)\\n  end;'))?.[1];
 if (!block) throw Error('Missing class '+cls);
 const rawType = block.match(/RAW\w+: \^(\w+)/)?.[1];
 const rawBlock = rawType && source.match(new RegExp('  '+rawType+' = (?:packed )?record\\s+([\\s\\S]*?)\\n  end;'))?.[1];
 let docs=[];
 const fields=[];
 for(const line of (rawBlock || '').split('\n')) {
  if(line.trim().startsWith('///')) docs.push(line.replace(/^\s*\/\/\/\s?/,''));
  const field=line.match(/^\s*(\w+)\s*:\s*([^;]+);/);
  if(field){
   if(field[1]!=='Header') fields.push({name:field[1],type:field[2].trim(),description:clean(docs.join(' ').match(/<summary>([\s\S]*?)<\/summary>/)?.[1]||''),version:clean(docs.join(' ').match(/<(?:remarks|value)>([\s\S]*?)<\/(?:remarks|value)>/)?.[1]||'')});
   docs=[];
  }
 }
 const methods=[...block.matchAll(/function\s+(\w+)([^;]*);/g)].map(m=>m[1]+m[2]);
 const line=source.slice(0,source.indexOf('  '+cls+' = class')).split('\n').length;
 return {id,name,group:Object.keys(groups).find(k=>groups[k].includes(id)),brief:briefs[id],property,className:cls,enumName:enums[id],fields,methods,relations:relations[id]||[],samples:links,source:`https://github.com/RRUZ/tsmbios/blob/master/source/uSMBIOS.pas#L${line}`,legacy:[5,6,10].includes(id)};
});
fs.writeFileSync(out+'/catalog.json',JSON.stringify(catalog,null,2)+'\n');
console.log(`Catalog: ${catalog.length} structures, ${catalog.reduce((s,c)=>s+c.fields.length,0)} declared fields, ${catalog.reduce((s,c)=>s+c.methods.length,0)} helpers.`);
