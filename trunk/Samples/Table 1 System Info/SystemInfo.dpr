program SystemInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetSystemInfo;
Var
  SMBios : TSMBios;
  LSystem: TSysInfo;
  UUID   : Array[0..31] of AnsiChar;
begin
  SMBios:=TSMBios.Create;
  try
    LSystem:=SMBios.SysInfo;
    WriteLn('System Information');
    //WriteLn('Manufacter    '+SMBios.GetSMBiosString(LSystem.LocalIndex + LSystem.Header.Length, LSystem.Manufacturer));
    WriteLn('Manufacter    '+LSystem.ManufacturerStr);
    WriteLn('Product Name  '+LSystem.ProductNameStr);
    WriteLn('Version       '+LSystem.VersionStr);
    WriteLn('Serial Number '+LSystem.SerialNumberStr);
    BinToHex(@LSystem.UUID,UUID,SizeOf(LSystem.UUID));
    WriteLn('UUID          '+UUID);
    if SMBios.SmbiosVersion>='2.4' then
    begin
      WriteLn('SKU Number    '+LSystem.SKUNumberStr);
      WriteLn('Family        '+LSystem.FamilyStr);
    end;
    WriteLn;
  finally
   SMBios.Free;
  end;
end;

begin
 try
    CoInitialize(nil);
    try
      GetSystemInfo;
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
