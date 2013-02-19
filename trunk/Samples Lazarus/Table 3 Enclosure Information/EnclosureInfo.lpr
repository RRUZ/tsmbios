program EnclosureInfo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, uSMBIOS
  { you can add units after this };

procedure GetEnclosureInfo;
Var
  SMBios : TSMBios;
  LEnclosure  : TEnclosureInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Enclosure Information');
      if SMBios.HasEnclosureInfo then
      for LEnclosure in SMBios.EnclosureInfo do
      begin
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
   GetEnclosureInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
