program SystemSlotsInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
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
  LSlot  : TSystemSlotInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('System Slot Information');
      WriteLn('--------------------------');
      if SMBios.HasSystemSlotInfo then
      for LSlot in SMBios.SystemSlotInfo do
      begin
        WriteLn('Slot Designation    '+LSlot.SlotDesignationStr);
        WriteLn('Slot Type           '+LSlot.GetSlotType);
        WriteLn('Slot Data Bus Width '+LSlot.GetSlotDataBusWidth);
        WriteLn('Current Usage       '+LSlot.GetCurrentUsage);
        WriteLn('Slot Length         '+LSlot.GetSlotLength);
        WriteLn(Format('Slot ID             %.4x',[LSlot.SlotID]));
        WriteLn('Characteristics 1   '+ByteToBinStr(LSlot.SlotCharacteristics1));
        WriteLn('Characteristics 2   '+ByteToBinStr(LSlot.SlotCharacteristics2));
        WriteLn(Format('Segment Group Number %.4x',[LSlot.SegmentGroupNumber]));
        WriteLn(Format('Bus Number           %d',[LSlot.BusNumber]));

        WriteLn;
      end
      else
      Writeln('No System Slot  Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetSystemSlotInfo;
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

