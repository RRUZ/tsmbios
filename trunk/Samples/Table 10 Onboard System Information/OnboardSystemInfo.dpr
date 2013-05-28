program OnboardSystemInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

function ByteToBinStr(AValue:Byte):string;
const
  Bits : array[1..8] of byte = (128,64,32,16,8,4,2,1);
  var i: integer;
begin
  Result:='00000000';
  if (AValue<>0) then
  for i:=1 to 8 do
    if (AValue and Bits[i])<>0 then Result[i]:='1';
end;

procedure GetSystemSlotInfo;
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
    GetSystemSlotInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.

