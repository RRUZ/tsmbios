program BatteryInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetBatteryInfo;
Var
  SMBios : TSMBios;
  LBatteryInfo  : TBatteryInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Battery Information');
      WriteLn('-------------------');
      if SMBios.HasBatteryInfo then
      for LBatteryInfo in SMBios.BatteryInformation do
      begin
        WriteLn('Location           '+LBatteryInfo.GetLocationStr);
        WriteLn('Manufacturer       '+LBatteryInfo.GetManufacturerStr);
        WriteLn('Manufacturer Date  '+LBatteryInfo.GetManufacturerDateStr);
        WriteLn('Serial Number      '+LBatteryInfo.GetSerialNumberStr);
        WriteLn('Device Name        '+LBatteryInfo.GetDeviceNameStr);
        WriteLn('Device Chemistry   '+LBatteryInfo.GetDeviceChemistry);
        WriteLn(Format('Design Capacity    %d mWatt/hours',[LBatteryInfo.RAWBatteryInfo.DesignCapacity*LBatteryInfo.RAWBatteryInfo.DesignCapacityMultiplier]));
        WriteLn(Format('Design Voltage     %d mVolts',[LBatteryInfo.RAWBatteryInfo.DesignVoltage]));
        WriteLn('SBDS Version Number  '+LBatteryInfo.GetSBDSVersionNumberStr);
        WriteLn(Format('Maximum Error in Battery Data %d%%',[LBatteryInfo.RAWBatteryInfo.MaximumErrorInBatteryData]));
        WriteLn(Format('SBDS Version Number           %.4x',[LBatteryInfo.RAWBatteryInfo.SBDSSerialNumber]));
        WriteLn('SBDS Manufacture Date  '+LBatteryInfo.GetSBDSManufactureDateStr);
        WriteLn('SBDS Device Chemistry  '+LBatteryInfo.GetSBDSDeviceChemistryStr);
        WriteLn(Format('OEM Specific                  %.8x',[LBatteryInfo.RAWBatteryInfo.OEM_Specific]));
        WriteLn;
      end
      else
      Writeln('No Battery Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetBatteryInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
