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
  SI     : TSysInfo;
  UUID   : Array[0..31] of AnsiChar;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('System Information');
      if SMBios.HasSysInfo then
      for SI in SMBios.SysInfo do
      begin
        WriteLn('Manufacter    '+SMBios.GetSMBiosString(SI.LocalIndex + SI.Header.Length, SI.Manufacturer));
        WriteLn('Product Name  '+SMBios.GetSMBiosString(SI.LocalIndex + SI.Header.Length, SI.ProductName));
        WriteLn('Version       '+SMBios.GetSMBiosString(SI.LocalIndex + SI.Header.Length, SI.Version));
        WriteLn('Serial Number '+SMBios.GetSMBiosString(SI.LocalIndex + SI.Header.Length, SI.SerialNumber));
        BinToHex(@SI.UUID,UUID,SizeOf(SI.UUID));
        WriteLn('UUID          '+UUID);
        WriteLn;
      end
      else
      Writeln('No System Info was found');
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
