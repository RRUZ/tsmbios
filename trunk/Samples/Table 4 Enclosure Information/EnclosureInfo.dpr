program EnclosureInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetEnclosureInfo;
Var
  SMBios : TSMBios;
  EI     : TEnclosureInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Enclosure Information');
      if SMBios.HasEnclosureInfo then
      for EI in SMBios.EnclosureInfo do
      begin
        WriteLn('Manufacter    '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.Manufacturer));
        WriteLn('Version       '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.Version));
        WriteLn('Serial Number '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.SerialNumber));
        WriteLn('Asset Tag Number '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.AssetTagNumber));
        WriteLn;
      end
      else
      Writeln('No Enclosure Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetEnclosureInfo;
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
