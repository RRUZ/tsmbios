program BIOSInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetBIOSInfo;
  Var
    SMBios : TSMBios;
    LBIOS : TBiosInformation;
    OEMStr : TOEMStringsInformation;
    i : Integer;
  begin
    SMBios := TSMBios.Create;
    try
      //SMBios.LoadFromFile('/home/rruz/PAServer/scratch-dir/RRUZ-Linux Ubuntu/SMBiosTables/SMBIOS.dat', true);
      LBIOS := SMBios.BIOSInfo;
      WriteLn('Bios Information');
      WriteLn('Vendor        ' + LBIOS.VendorStr);
      WriteLn('Version       ' + LBIOS.VersionStr);
      WriteLn('Start Segment ' + IntToHex(LBIOS.RAWBiosInformation.StartingSegment, 4));
      WriteLn('ReleaseDate   ' + LBIOS.ReleaseDateStr);
      WriteLn(Format('Bios Rom Size %d k', [64 * (LBIOS.RAWBiosInformation.BiosRomSize + 1)]));

      if LBIOS.RAWBiosInformation.SystemBIOSMajorRelease <> $FF
      then
        WriteLn(Format('System BIOS Major Release %d', [LBIOS.RAWBiosInformation.SystemBIOSMajorRelease]));
      if LBIOS.RAWBiosInformation.SystemBIOSMinorRelease <> $FF
      then
        WriteLn(Format('System BIOS Minor Release %d', [LBIOS.RAWBiosInformation.SystemBIOSMinorRelease]));

      // If the system does not have field upgradeable embedded controller firmware, the value is 0FFh.
      if LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMajorRelease <> $FF
      then
        WriteLn(Format('Embedded Controller Firmware Major Release %d',
          [LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMajorRelease]));
      if LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMinorRelease <> $FF
      then
        WriteLn(Format('Embedded Controller Firmware Minor Releasee %d',
          [LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMinorRelease]));
      WriteLn;

      if SMBios.HasOEMStringsInfo
      then
      begin
        WriteLn('OEM Strings');
        WriteLn('-----------');
        for OEMStr in SMBios.OEMStringsInfo do
          for i := 1 to OEMStr.RAWOEMStringsInformation.Count do
            WriteLn(OEMStr.GetOEMString(i));
      end;

    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetBIOSInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn;
  WriteLn('Press Enter to exit');
  Readln;

end.
