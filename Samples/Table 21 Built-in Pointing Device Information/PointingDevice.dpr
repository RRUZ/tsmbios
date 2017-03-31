program PointingDevice;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetPointingDeviceInfo;
  Var
    SMBios : TSMBios;
    LPointDevice : TBuiltInPointingDeviceInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Built-in Pointing Device Information');
      WriteLn('------------------------------------');
      if SMBios.HasBuiltInPointingDeviceInfo
      then
        for LPointDevice in SMBios.BuiltInPointingDeviceInformation do
        begin
          WriteLn(Format('Type              %s', [LPointDevice.GetType]));
          WriteLn(Format('Interface         %s', [LPointDevice.GetInterface]));
          WriteLn(Format('Number of Buttons %d', [LPointDevice.RAWBuiltInPointingDeviceInfo.NumberofButtons]));
          WriteLn;
        end
      else
        WriteLn('No Built-in Pointing Device Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetPointingDeviceInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
