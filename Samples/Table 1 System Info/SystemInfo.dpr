program SystemInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetSystemInfo;
  Var
    SMBios : TSMBios;
    LSystem : TSystemInformation;
   {$IFNDEF LINUX}
    UUID : Array [0 .. 31] of AnsiChar;
   {$ENDIF}
  begin
    SMBios := TSMBios.Create;
    try
      //SMBios.LoadFromFile('/home/rruz/PAServer/scratch-dir/RRUZ-Linux Ubuntu/SMBiosTables/SMBIOS.dat', true);
      LSystem := SMBios.SysInfo;
      WriteLn('System Information');
      WriteLn('Manufacter    ' + LSystem.ManufacturerStr);
      WriteLn('Product Name  ' + LSystem.ProductNameStr);
      WriteLn('Version       ' + LSystem.VersionStr);
      WriteLn('Serial Number ' + LSystem.SerialNumberStr);
      {$IFNDEF LINUX}
      BinToHex(@LSystem.RAWSystemInformation.UUID, UUID, SizeOf(LSystem.RAWSystemInformation.UUID));
      WriteLn('UUID          ' + UUID);
      {$ENDIF}
      if SMBios.SmbiosVersion >= '2.4'
      then
      begin
        WriteLn('SKU Number    ' + LSystem.SKUNumberStr);
        WriteLn('Family        ' + LSystem.FamilyStr);
      end;
      WriteLn;
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetSystemInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
