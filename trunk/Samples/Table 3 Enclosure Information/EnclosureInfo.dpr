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
        //WriteLn('Manufacter    '+SMBios.GetSMBiosString(EI.LocalIndex + EI.Header.Length, EI.Manufacturer));
        WriteLn('Manufacter         '+EI.ManufacturerStr);
        WriteLn('Version            '+EI.VersionStr);
        WriteLn('Serial Number      '+EI.SerialNumberStr);
        WriteLn('Asset Tag Number   '+EI.AssetTagNumberStr);
        WriteLn('Type               '+EI.TypeStr);
        WriteLn('Power Supply State '+EI.PowerSupplyStateStr);
        WriteLn('BootUp State       '+EI.BootUpStateStr);
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
