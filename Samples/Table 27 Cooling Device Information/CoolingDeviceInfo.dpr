program CoolingDeviceInfo;

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

procedure GetCoolingDeviceInfo;
  Var
    SMBios : TSMBios;
    LCoolingDevice : TCoolingDeviceInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Cooling Device Information');
      WriteLn('--------------------------');
      if SMBios.HasCoolingDeviceInfo
      then
        for LCoolingDevice in SMBios.CoolingDeviceInformation do
        begin
          if LCoolingDevice.RAWCoolingDeviceInfo.TemperatureProbeHandle <> $FFFF
          then
            WriteLn(Format('Temperature Probe Handle %.4x',
              [LCoolingDevice.RAWCoolingDeviceInfo.TemperatureProbeHandle]));

          WriteLn(Format('Device Type and Status   %s',
            [ByteToBinStr(LCoolingDevice.RAWCoolingDeviceInfo.DeviceTypeandStatus)]));
          WriteLn(Format('Type                     %s', [LCoolingDevice.GetDeviceType]));
          WriteLn(Format('Status                   %s', [LCoolingDevice.GetStatus]));

          WriteLn(Format('Cooling Unit Group       %d', [LCoolingDevice.RAWCoolingDeviceInfo.CoolingUnitGroup]));
          WriteLn(Format('OEM Specific             %.8x', [LCoolingDevice.RAWCoolingDeviceInfo.OEMdefined]));
          if LCoolingDevice.RAWCoolingDeviceInfo.NominalSpeed = $8000
          then
            WriteLn(Format('Nominal Speed            %s', ['Unknown']))
          else
            WriteLn(Format('Nominal Speed            %d rpm', [LCoolingDevice.RAWCoolingDeviceInfo.NominalSpeed]));
          if SMBios.SmbiosVersion >= '2.7'
          then
            WriteLn(Format('Description    %s', [LCoolingDevice.GetDescriptionStr]));

          WriteLn;
        end
      else
        WriteLn('No Cooling Device Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetCoolingDeviceInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
