program BaseBoardInformation;

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

procedure GetBaseBoardInfo;
  Var
    SMBios : TSMBios;
    LBaseBoard : TBaseBoardInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Base Board Information');
      if SMBios.HasBaseBoardInfo
      then
        for LBaseBoard in SMBios.BaseBoardInfo do
        begin
          // WriteLn('Manufacter          '+SMBios.GetSMBiosString(BBI.LocalIndex  + BBI.Header.Length, BBI.Manufacturer));
          WriteLn('Manufacter          ' + LBaseBoard.ManufacturerStr);
          WriteLn('Product             ' + LBaseBoard.ProductStr);
          WriteLn('Version             ' + LBaseBoard.VersionStr);
          WriteLn('Serial Number       ' + LBaseBoard.SerialNumberStr);
          WriteLn('Asset Tag           ' + LBaseBoard.AssetTagStr);
          WriteLn('Feature Flags       ' + ByteToBinStr(LBaseBoard.RAWBaseBoardInformation.FeatureFlags));
          WriteLn('Location in Chassis ' + LBaseBoard.LocationinChassisStr);
          WriteLn(Format('Chassis Handle      %0.4x', [LBaseBoard.RAWBaseBoardInformation.ChassisHandle]));
          WriteLn(Format('Board Type          %0.2x %s', [LBaseBoard.RAWBaseBoardInformation.BoardType,
            LBaseBoard.BoardTypeStr]));
          WriteLn('Number of Contained Object Handles ' +
            IntToStr(LBaseBoard.RAWBaseBoardInformation.NumberofContainedObjectHandles));
          WriteLn;
        end
      else
        WriteLn('No Base Board Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetBaseBoardInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
