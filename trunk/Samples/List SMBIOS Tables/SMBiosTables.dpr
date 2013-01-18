program SMBiosTables;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure ListSMBiosTables;
Var
  SMBios : TSMBios;
  UUID   : Array[0..31] of Char;
  Entry  : TSMBiosTableEntry;
begin
  SMBios:=TSMBios.Create;
  try
    Writeln(Format('SMBIOS Version %s',[SMBios.SmbiosVersion]));
    Writeln(Format('%d SMBios tables found',[Length(SMBios.SMBiosTablesList)]));
    Writeln;
    Writeln('Type Handle Length Index Description');
    for Entry in SMBios.SMBiosTablesList do
      Writeln(Format('%3d  %4x   %3d    %4d    %s',[Entry.Header.TableType, Entry.Header.Handle, Entry.Header.Length, Entry.Index, SMBiosTablesDescr[Entry.Header.TableType]]));
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      ListSMBiosTables;
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
