program SystemConfInfo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, uSMBIOS
  { you can add units after this };

procedure GetBIOSInfo;
Var
  SMBios  : TSMBios;
  i : Integer;
  LSystemConf : TSystemConfInformation;
begin
  SMBios:=TSMBios.Create;
  try

    if SMBios.HasSystemConfInfo then
    begin
     Writeln('System Config Strings');
     Writeln('---------------------');
     for LSystemConf in SMBios.SystemConfInfo do
      for i:=1 to LSystemConf.RAWSystemConfInformation^.Count do
       Writeln(LSystemConf.GetConfString(i));
    end;

  finally
   SMBios.Free;
  end;
end;


begin
 try
   GetBIOSInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln;
 Writeln('Press Enter to exit');
 Readln;
end.
