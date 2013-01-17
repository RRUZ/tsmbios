program PortConnectorInfo;

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

procedure GetPortConnectorInfo;
Var
  SMBios : TSMBios;
  LPort  : TPortConnectorInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Port Connector Information');
      WriteLn('--------------------------');
      if SMBios.HasBaseBoardInfo then
      for LPort in SMBios.PortConnectorInfo do
      begin
        WriteLn('Internal Reference Designator '+LPort.InternalReferenceDesignatorStr);
        WriteLn('Internal Connector Type       '+LPort.GetConnectorType(LPort.InternalConnectorType));
        WriteLn('External Reference Designator '+LPort.ExternalReferenceDesignatorStr);
        WriteLn('External Connector Type       '+LPort.GetConnectorType(LPort.ExternalConnectorType));
        WriteLn('Port Type                     '+LPort.PortTypeStr);
        WriteLn;
      end
      else
      Writeln('No Port Connector Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetPortConnectorInfo;
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
