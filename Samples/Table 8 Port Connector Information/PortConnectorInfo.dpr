program PortConnectorInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetPortConnectorInfo;
  Var
    SMBios : TSMBios;
    LPort : TPortConnectorInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Port Connector Information');
      WriteLn('--------------------------');
      if SMBios.HasPortConnectorInfo
      then
        for LPort in SMBios.PortConnectorInfo do
        begin
          WriteLn('Internal Reference Designator ' + LPort.InternalReferenceDesignatorStr);
          WriteLn('Internal Connector Type       ' + LPort.GetConnectorType
            (LPort.RAWPortConnectorInformation.InternalConnectorType));
          WriteLn('External Reference Designator ' + LPort.ExternalReferenceDesignatorStr);
          WriteLn('External Connector Type       ' + LPort.GetConnectorType
            (LPort.RAWPortConnectorInformation.ExternalConnectorType));
          WriteLn('Port Type                     ' + LPort.PortTypeStr);
          WriteLn;
        end
      else
        WriteLn('No Port Connector Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetPortConnectorInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
