program TemperatureProbeInfo;

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

procedure GetTempProbeInfo;
  Var
    SMBios : TSMBios;
    LTempProbeInfo : TTemperatureProbeInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Temperature Probe Information');
      WriteLn('-----------------------------');
      if SMBios.HasTemperatureProbeInfo
      then
        for LTempProbeInfo in SMBios.TemperatureProbeInformation do
        begin
          WriteLn(Format('Description    %s', [LTempProbeInfo.GetDescriptionStr]));
          WriteLn(Format('Location and Status %s',
            [ByteToBinStr(LTempProbeInfo.RAWTemperatureProbeInfo.LocationandStatus)]));
          WriteLn(Format('Location       %s', [LTempProbeInfo.GetLocation]));
          WriteLn(Format('Status         %s', [LTempProbeInfo.GetStatus]));

          if LTempProbeInfo.RAWTemperatureProbeInfo.MaximumValue = $8000
          then
            WriteLn(Format('Maximum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Maximum Value  %d C°', [LTempProbeInfo.RAWTemperatureProbeInfo.MaximumValue div 10]));
          if LTempProbeInfo.RAWTemperatureProbeInfo.MinimumValue = $8000
          then
            WriteLn(Format('Minimum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Minimum Value  %d C°', [LTempProbeInfo.RAWTemperatureProbeInfo.MinimumValue div 10]));

          if LTempProbeInfo.RAWTemperatureProbeInfo.Resolution = $8000
          then
            WriteLn(Format('Resolution     %s', ['Unknown']))
          else
            WriteLn(Format('Resolution     %d C°', [LTempProbeInfo.RAWTemperatureProbeInfo.Resolution div 1000]));

          if LTempProbeInfo.RAWTemperatureProbeInfo.Tolerance = $8000
          then
            WriteLn(Format('Tolerance      %s', ['Unknown']))
          else
            WriteLn(Format('Tolerance      %n C°', [LTempProbeInfo.RAWTemperatureProbeInfo.Tolerance / 10]));
          WriteLn(Format('OEM Specific   %.8x', [LTempProbeInfo.RAWTemperatureProbeInfo.OEMdefined]));

          if LTempProbeInfo.RAWTemperatureProbeInfo.Header.Length > $14
          then
            if LTempProbeInfo.RAWTemperatureProbeInfo.NominalValue = $8000
            then
              WriteLn(Format('Nominal Value  %s', ['Unknown']))
            else
              WriteLn(Format('Nominal Value  %d C°', [LTempProbeInfo.RAWTemperatureProbeInfo.NominalValue div 10]));
          WriteLn;
        end
      else
        WriteLn('No Temperature Probe Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetTempProbeInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
