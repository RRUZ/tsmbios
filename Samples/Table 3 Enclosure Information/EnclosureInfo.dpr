program EnclosureInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetEnclosureInfo;
  Var
    SMBios : TSMBios;
    LEnclosure : TEnclosureInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Enclosure Information');
      if SMBios.HasEnclosureInfo
      then
        for LEnclosure in SMBios.EnclosureInfo do
        begin
          WriteLn('Manufacter         ' + LEnclosure.ManufacturerStr);
          WriteLn('Version            ' + LEnclosure.VersionStr);
          WriteLn('Serial Number      ' + LEnclosure.SerialNumberStr);
          WriteLn('Asset Tag Number   ' + LEnclosure.AssetTagNumberStr);
          WriteLn('Type               ' + LEnclosure.TypeStr);
          WriteLn('Power Supply State ' + LEnclosure.PowerSupplyStateStr);
          WriteLn('BootUp State       ' + LEnclosure.BootUpStateStr);
          WriteLn;
        end
      else
        WriteLn('No Enclosure Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetEnclosureInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
