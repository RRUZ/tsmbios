program BaseBoardInformation;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';


function ByteToStr(AValue:Byte):string;
const
  Bits : array[1..8] of byte = (128,64,32,16,8,4,2,1);
  var i: integer;
begin
  Result:='00000000';
  if (AValue<>0) then
  for i:=1 to 8 do
    if (AValue and Bits[i])<>0 then Result[i]:='1';
end;

procedure GetBaseBoardInfo;
Var
  SMBios : TSMBios;
  BBI    : TBaseBoardInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Base Board Information');
      if SMBios.HasBaseBoardInfo then
      for BBI in SMBios.BaseBoardInfo do
      begin
        //WriteLn('Manufacter          '+SMBios.GetSMBiosString(BBI.LocalIndex  + BBI.Header.Length, BBI.Manufacturer));
        WriteLn('Manufacter          '+BBI.ManufacturerStr);
        WriteLn('Product             '+BBI.ProductStr);
        WriteLn('Version             '+BBI.VersionStr);
        WriteLn('Serial Number       '+BBI.SerialNumberStr);
        WriteLn('Asset Tag           '+BBI.AssetTagStr);
        WriteLn('Feature Flags       '+ByteToStr(BBI.FeatureFlags));
        WriteLn('Location in Chassis '+BBI.LocationinChassisStr);
        WriteLn(Format('Chassis Handle      %0.4x',[BBI.ChassisHandle]));
        WriteLn(Format('Board Type          %0.2x %s',[BBI.BoardType, BBI.BoardTypeStr]));
        WriteLn('Number of Contained Object Handles '+IntToStr(BBI.NumberofContainedObjectHandles));
        WriteLn;
      end
      else
      Writeln('No Base Board Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetBaseBoardInfo;
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
