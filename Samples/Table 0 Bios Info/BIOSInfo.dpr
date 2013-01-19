program BIOSInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetBIOSInfo;
Var
  SMBios  : TSMBios;
  LBIOS   : TBiosInfo;
  OEMStr  : TOEMStringsInfo;
  i : Integer;
begin
  SMBios:=TSMBios.Create;
  try
    LBIOS:=SMBios.BiosInfo;
    WriteLn('Bios Information');
    //WriteLn('Vendor        '+SMBios.GetSMBiosString(LBIOS.LocalIndex + LBIOS.Header.Length, LBIOS.Vendor));
    WriteLn('Vendor        '+LBIOS.VendorStr);
    WriteLn('Version       '+LBIOS.VersionStr);
    WriteLn('Start Segment '+IntToHex(LBIOS.StartingSegment,4));
    WriteLn('ReleaseDate   '+LBIOS.ReleaseDateStr);
    WriteLn(Format('Bios Rom Size %d k',[64*(LBIOS.BiosRomSize+1)]));

    if LBIOS.SystemBIOSMajorRelease<>$ff then
    WriteLn(Format('System BIOS Major Release %d',[LBIOS.SystemBIOSMajorRelease]));
    if LBIOS.SystemBIOSMinorRelease<>$ff then
    WriteLn(Format('System BIOS Minor Release %d',[LBIOS.SystemBIOSMinorRelease]));

    //If the system does not have field upgradeable embedded controller firmware, the value is 0FFh.
    if LBIOS.EmbeddedControllerFirmwareMajorRelease<>$ff then
    WriteLn(Format('Embedded Controller Firmware Major Release %d',[LBIOS.EmbeddedControllerFirmwareMajorRelease]));
    if LBIOS.EmbeddedControllerFirmwareMinorRelease<>$ff then
    WriteLn(Format('Embedded Controller Firmware Minor Releasee %d',[LBIOS.EmbeddedControllerFirmwareMinorRelease]));
    WriteLn;


    if SMBios.HasOEMStringsInfo then
    begin
     Writeln('OEM Strings');
     Writeln('-----------');
     for OEMStr in SMBios.OEMStringsInfo do
      for i:=1 to OEMStr.Count do
       Writeln(OEMStr.GetOEMString(i));

    end;

  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetBIOSInfo;
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln;
 Writeln('Press Enter to exit');
 Readln;
end.
