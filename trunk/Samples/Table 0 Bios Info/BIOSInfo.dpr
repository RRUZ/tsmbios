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
        WriteLn('Vendor        '+SMBios.GetSMBiosString(BI.LocalIndex + BI.Header.Length, BI.Vendor));
        WriteLn('Version       '+SMBios.GetSMBiosString(BI.LocalIndex + BI.Header.Length, BI.Version));
        WriteLn('Start Segment '+IntToHex(BI.StartingSegment,4));
        WriteLn('ReleaseDate   '+SMBios.GetSMBiosString(BI.LocalIndex + BI.Header.Length, BI.ReleaseDate));
        WriteLn(Format('Bios Rom Size %d k',[64*(BI.BiosRomSize+1)]));
        WriteLn('');
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
