program SMBiosTables;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, uSMBIOS
  { you can add units after this };

procedure ListSMBiosTables;
Var
  SMBios: TSMBios;
  Entry: TSMBiosTableEntry;
begin
  SMBios := TSMBios.Create;
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
    ListSMBiosTables;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
