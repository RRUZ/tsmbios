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
  LEnclosure  : TEnclosureInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Enclosure Information');
      if SMBios.HasEnclosureInfo then
      for LEnclosure in SMBios.EnclosureInfo do
      begin
        //WriteLn('Manufacter    '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.Manufacturer));
        WriteLn('Manufacter         '+LEnclosure.ManufacturerStr);
        WriteLn('Version            '+LEnclosure.VersionStr);
        WriteLn('Serial Number      '+LEnclosure.SerialNumberStr);
        WriteLn('Asset Tag Number   '+LEnclosure.AssetTagNumberStr);
        WriteLn('Type               '+LEnclosure.TypeStr);
        WriteLn('Power Supply State '+LEnclosure.PowerSupplyStateStr);
        WriteLn('BootUp State       '+LEnclosure.BootUpStateStr);
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
