program PointingDevice;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, uSMBIOS
  { you can add units after this };

procedure GetPointingDeviceInfo;
Var
  SMBios: TSMBios;
  LPointDevice: TBuiltInPointingDeviceInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Built-in Pointing Device Information');
      WriteLn('------------------------------------');
      if SMBios.HasBuiltInPointingDeviceInfo then
      for LPointDevice in SMBios.BuiltInPointingDeviceInformation do
      begin
        WriteLn(Format('Type              %s',[LPointDevice.GetType]));
        WriteLn(Format('Interface         %s',[LPointDevice.GetInterface]));
        WriteLn(Format('Number of Buttons %d',[LPointDevice.RAWBuiltInPointingDeviceInfo^.NumberofButtons]));
        WriteLn;
      end
      else
      Writeln('No Built-in Pointing Device Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetPointingDeviceInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
