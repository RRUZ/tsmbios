program BIOSInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetBIOSInfo;
Var
  SMBios  : TSMBios;
  LBIOS   : TBiosInformation;
  OEMStr  : TOEMStringsInformation;
  i : Integer;
begin
  SMBios:=TSMBios.Create;
  try
    LBIOS:=SMBios.BiosInfo;
    WriteLn('Bios Information');
    WriteLn('Vendor        '+LBIOS.VendorStr);
    WriteLn('Version       '+LBIOS.VersionStr);
    WriteLn('Start Segment '+IntToHex(LBIOS.RAWBiosInformation.StartingSegment,4));
    WriteLn('ReleaseDate   '+LBIOS.ReleaseDateStr);
    WriteLn(Format('Bios Rom Size %d k',[64*(LBIOS.RAWBiosInformation.BiosRomSize+1)]));

    if LBIOS.RAWBiosInformation.SystemBIOSMajorRelease<>$ff then
    WriteLn(Format('System BIOS Major Release %d',[LBIOS.RAWBiosInformation.SystemBIOSMajorRelease]));
    if LBIOS.RAWBiosInformation.SystemBIOSMinorRelease<>$ff then
    WriteLn(Format('System BIOS Minor Release %d',[LBIOS.RAWBiosInformation.SystemBIOSMinorRelease]));

    //If the system does not have field upgradeable embedded controller firmware, the value is 0FFh.
    if LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMajorRelease<>$ff then
    WriteLn(Format('Embedded Controller Firmware Major Release %d',[LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMajorRelease]));
    if LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMinorRelease<>$ff then
    WriteLn(Format('Embedded Controller Firmware Minor Releasee %d',[LBIOS.RAWBiosInformation.EmbeddedControllerFirmwareMinorRelease]));
    WriteLn;

    if SMBios.HasOEMStringsInfo then
    begin
     Writeln('OEM Strings');
     Writeln('-----------');
     for OEMStr in SMBios.OEMStringsInfo do
      for i:=1 to OEMStr.RAWOEMStringsInformation.Count do
       Writeln(OEMStr.GetOEMString(i));
    end;
        
  finally
   SMBios.Free;
  end;
end;


begin
 try
   GetBIOSInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln;
 Writeln('Press Enter to exit');
 Readln;
end.
