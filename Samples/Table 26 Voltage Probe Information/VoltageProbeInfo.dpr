program VoltageProbeInfo;

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

procedure GetVoltageProbeInfo;
  Var
    SMBios : TSMBios;
    LVoltageProbeInfo : TVoltageProbeInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Voltage Probe Information');
      WriteLn('-------------------------');
      if SMBios.HasVoltageProbeInfo
      then
        for LVoltageProbeInfo in SMBios.VoltageProbeInformation do
        begin
          WriteLn(Format('Description    %s', [LVoltageProbeInfo.GetDescriptionStr]));
          WriteLn(Format('Location and Status %s',
            [ByteToBinStr(LVoltageProbeInfo.RAWVoltageProbeInfo.LocationandStatus)]));
          WriteLn(Format('Location       %s', [LVoltageProbeInfo.GetLocation]));
          WriteLn(Format('Status         %s', [LVoltageProbeInfo.GetStatus]));

          if LVoltageProbeInfo.RAWVoltageProbeInfo.MaximumValue = $8000
          then
            WriteLn(Format('Maximum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Maximum Value  %d', [LVoltageProbeInfo.RAWVoltageProbeInfo.MaximumValue]));
          if LVoltageProbeInfo.RAWVoltageProbeInfo.MinimumValue = $8000
          then
            WriteLn(Format('Minimum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Minimum Value  %d', [LVoltageProbeInfo.RAWVoltageProbeInfo.MinimumValue]));

          if LVoltageProbeInfo.RAWVoltageProbeInfo.Resolution = $8000
          then
            WriteLn(Format('Resolution     %s', ['Unknown']))
          else
            WriteLn(Format('Resolution     %d', [LVoltageProbeInfo.RAWVoltageProbeInfo.Resolution]));

          if LVoltageProbeInfo.RAWVoltageProbeInfo.Tolerance = $8000
          then
            WriteLn(Format('Tolerance      %s', ['Unknown']))
          else
            WriteLn(Format('Tolerance      %d', [LVoltageProbeInfo.RAWVoltageProbeInfo.Tolerance]));
          WriteLn(Format('OEM Specific   %.8x', [LVoltageProbeInfo.RAWVoltageProbeInfo.OEMdefined]));

          if LVoltageProbeInfo.RAWVoltageProbeInfo.Header.Length > $14
          then
            if LVoltageProbeInfo.RAWVoltageProbeInfo.NominalValue = $8000
            then
              WriteLn(Format('Nominal Value  %s', ['Unknown']))
            else
              WriteLn(Format('Nominal Value  %d', [LVoltageProbeInfo.RAWVoltageProbeInfo.NominalValue]));
          WriteLn;
        end
      else
        WriteLn('No Voltage Probe Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetVoltageProbeInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
