program SystemSlotsInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

function ByteToBinStr(AValue : Byte) : string;
  const
    Bits : array [1 .. 8] of Byte = (128, 64, 32, 16, 8, 4, 2, 1);
  var
    i : integer;
  begin
    Result := '00000000';
    if (AValue <> 0)
    then
      for i := 1 to 8 do
        if (AValue and Bits[i]) <> 0
        then
          Result[i] := '1';
  end;

procedure GetSystemSlotInfo;
  Var
    SMBios : TSMBios;
    LSlot : TSystemSlotInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('System Slot Information');
      WriteLn('--------------------------');
      if SMBios.HasSystemSlotInfo
      then
        for LSlot in SMBios.SystemSlotInfo do
        begin
          WriteLn('Slot Designation    ' + LSlot.SlotDesignationStr);
          WriteLn('Slot Type           ' + LSlot.GetSlotType);
          WriteLn('Slot Data Bus Width ' + LSlot.GetSlotDataBusWidth);
          WriteLn('Current Usage       ' + LSlot.GetCurrentUsage);
          WriteLn('Slot Length         ' + LSlot.GetSlotLength);
          WriteLn(Format('Slot ID             %.4x', [LSlot.RAWSystemSlotInformation.SlotID]));
          WriteLn('Characteristics 1   ' + ByteToBinStr(LSlot.RAWSystemSlotInformation.SlotCharacteristics1));
          WriteLn('Characteristics 2   ' + ByteToBinStr(LSlot.RAWSystemSlotInformation.SlotCharacteristics2));
          if SMBios.SmbiosVersion >= '2.6'
          then
          begin
            WriteLn(Format('Segment Group Number %.4x', [LSlot.RAWSystemSlotInformation.SegmentGroupNumber]));
            WriteLn(Format('Bus Number           %d', [LSlot.RAWSystemSlotInformation.BusNumber]));
          end;
          WriteLn;
        end
      else
        WriteLn('No System Slot  Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetSystemSlotInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
