program ExportMemorySample;
{$APPTYPE CONSOLE}
uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils,
  uSMBIOS in '..\..\source\uSMBIOS.pas';
var
  Bios: TSMBios;
  Root, Item: TJSONObject;
  Memories: TJSONArray;
  Memory: TMemoryDeviceInformation;
begin
  Bios := TSMBios.Create(False);
  Root := TJSONObject.Create;
  try
    Bios.FindAndLoadFromFile(ParamStr(1));
    Root.AddPair('version', Bios.SmbiosVersion);
    Root.AddPair('provenance', 'Repository demonstration fixture: SMBIOS_Sample_3_2_Base64 in testing/LoadSMBIOSDump.dpr. Decoded by TSMBIOS; these are sample values, not this visitor''s hardware.');
    Memories := TJSONArray.Create;
    Root.AddPair('memory', Memories);
    for Memory in Bios.MemoryDeviceInfo do
    begin
      Item := TJSONObject.Create;
      Memories.AddElement(Item);
      Item.AddPair('locator', string(Memory.GetDeviceLocatorStr));
      Item.AddPair('bank', string(Memory.GetBankLocatorStr));
      Item.AddPair('handle', IntToHex(Memory.RAWMemoryDeviceInfo.Header.Handle, 4));
      Item.AddPair('sizeMB', TJSONNumber.Create(Memory.GetSize));
      Item.AddPair('type', string(Memory.GetMemoryTypeStr));
      Item.AddPair('formFactor', string(Memory.GetFormFactor));
      Item.AddPair('speed', TJSONNumber.Create(Memory.GetSpeed));
      Item.AddPair('manufacturer', string(Memory.ManufacturerStr));
      Item.AddPair('partNumber', string(Memory.PartNumberStr));
      if Memory.HasConfiguredMemorySpeed then
        Item.AddPair('configuredSpeed', TJSONNumber.Create(Memory.GetConfiguredMemorySpeed));
      if Assigned(Memory.PhysicalMemoryArray) then
      begin
        Item.AddPair('arrayHandle', IntToHex(Memory.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.Header.Handle, 4));
        Item.AddPair('arrayLocation', string(Memory.PhysicalMemoryArray.GetLocationStr));
        Item.AddPair('arrayUse', string(Memory.PhysicalMemoryArray.GetUseStr));
        Item.AddPair('errorCorrection', string(Memory.PhysicalMemoryArray.GetErrorCorrectionStr));
        Item.AddPair('arrayDevices', TJSONNumber.Create(Memory.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.NumberofMemoryDevices));
      end;
    end;
    TFile.WriteAllText(ParamStr(2), Root.Format(2), TEncoding.UTF8);
    Writeln('Exported ', Memories.Count, ' memory devices. SMBIOS ', Bios.SmbiosVersion);
  finally
    Root.Free;
    Bios.Free;
  end;
end.
