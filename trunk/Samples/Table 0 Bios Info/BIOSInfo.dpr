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
  SMBios : TSMBios;
  BI     : TBiosInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Bios Information');
      if SMBios.HasBiosInfo then
      for BI in SMBios.BiosInfo do
      begin
        //WriteLn('Vendor        '+SMBios.GetSMBiosString(BI.LocalIndex + BI.Header.Length, BI.Vendor));
        WriteLn('Vendor        '+BI.VendorStr);
        WriteLn('Version       '+BI.VersionStr);
        WriteLn('Start Segment '+IntToHex(BI.StartingSegment,4));
        WriteLn('ReleaseDate   '+BI.ReleaseDateStr);
        WriteLn(Format('Bios Rom Size %d k',[64*(BI.BiosRomSize+1)]));

        if BI.SystemBIOSMajorRelease<>$ff then
        WriteLn(Format('System BIOS Major Release %d',[BI.SystemBIOSMajorRelease]));
        if BI.SystemBIOSMinorRelease<>$ff then
        WriteLn(Format('System BIOS Minor Release %d',[BI.SystemBIOSMinorRelease]));

        //If the system does not have field upgradeable embedded controller firmware, the value is 0FFh.
        if BI.EmbeddedControllerFirmwareMajorRelease<>$ff then
        WriteLn(Format('Embedded Controller Firmware Major Release %d',[BI.EmbeddedControllerFirmwareMajorRelease]));
        if BI.EmbeddedControllerFirmwareMinorRelease<>$ff then
        WriteLn(Format('Embedded Controller Firmware Minor Releasee %d',[BI.EmbeddedControllerFirmwareMinorRelease]));
        WriteLn;
      end
      else
      Writeln('No BIOS Info was found');
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
 Writeln('Press Enter to exit');
 Readln;
end.
