program OnboardSystemInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetOnBoardSystemInfo;
Var
  SMBios : TSMBios;
  LOnBoardSystem  : TOnBoardSystemInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('OnBoard System Information');
      WriteLn('--------------------------');
      if SMBios.HasOnBoardSystemInfo then
      for LOnBoardSystem in SMBios.OnBoardSystemInfo do
      begin
        WriteLn('Device Type           '+IntToStr(LOnBoardSystem.RAWOnBoardSystemInfo.DeviceType));
        WriteLn('Description           '+LOnBoardSystem.GetDescription);
        WriteLn('Enabled               '+BoolToStr(LOnBoardSystem.Enabled, True));
        WriteLn('Device Type Descr.    '+LOnBoardSystem.GetTypeDescription);
        WriteLn;
      end
      else
      Writeln('No OnBoard System Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetOnBoardSystemInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.

