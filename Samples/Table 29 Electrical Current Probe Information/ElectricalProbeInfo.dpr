program ElectricalProbeInfo;

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

procedure GetElectricalCurrProbeInfo;
  Var
    SMBios : TSMBios;
    LElectCurrProbeInfo : TElectricalCurrentProbeInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Electrical Current Probe Information');
      WriteLn('-----------------------------------');
      if SMBios.HasElectricalCurrentProbeInfo
      then
        for LElectCurrProbeInfo in SMBios.ElectricalCurrentProbeInformation do
        begin
          WriteLn(Format('Description    %s', [LElectCurrProbeInfo.GetDescriptionStr]));
          WriteLn(Format('Location and Status %s',
            [ByteToBinStr(LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.LocationandStatus)]));
          WriteLn(Format('Location       %s', [LElectCurrProbeInfo.GetLocation]));
          WriteLn(Format('Status         %s', [LElectCurrProbeInfo.GetStatus]));

          if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.MaximumValue = $8000
          then
            WriteLn(Format('Maximum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Maximum Value  %d milliamps.°',
              [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.MaximumValue]));
          if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.MinimumValue = $8000
          then
            WriteLn(Format('Minimum Value  %s', ['Unknown']))
          else
            WriteLn(Format('Minimum Value  %d milliamps.',
              [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.MinimumValue]));

          if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.Resolution = $8000
          then
            WriteLn(Format('Resolution     %s', ['Unknown']))
          else
            WriteLn(Format('Resolution     %d milliamps.',
              [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.Resolution div 10]));

          if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.Tolerance = $8000
          then
            WriteLn(Format('Tolerance      %s', ['Unknown']))
          else
            WriteLn(Format('Tolerance      %n milliamps.',
              [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.Tolerance]));
          WriteLn(Format('OEM Specific   %.8x', [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.OEMdefined]));

          if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.Header.Length > $14
          then
            if LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.NominalValue = $8000
            then
              WriteLn(Format('Nominal Value  %s', ['Unknown']))
            else
              WriteLn(Format('Nominal Value  %d milliamps.',
                [LElectCurrProbeInfo.RAWElectricalCurrentProbeInfo.NominalValue]));
          WriteLn;
        end
      else
        WriteLn('No Electrical Current Probe Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetElectricalCurrProbeInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
