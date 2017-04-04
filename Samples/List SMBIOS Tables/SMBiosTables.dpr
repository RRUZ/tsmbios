program SMBiosTables;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure ListSMBiosTables;
  Var
    SMBios : TSMBios;
    Entry : TSMBiosTableEntry;
  begin
    SMBios := TSMBios.Create; // ('C:\Users\Dexter\Dropbox\SMBIOS.dat');
    try
      // SMBios.SaveToFile('SMBIOS.dat');
      // SMBios.LoadFromFile('C:\Users\Dexter\Dropbox\SMBIOS.dat');
      // SMBios.FindAndLoadFromFile('C:\Delphi\github\tsmbios\Docs\DELL_system_dumps\PE0400\SMBIOS.dat');
      Writeln(Format('SMBIOS Version %s', [SMBios.SmbiosVersion]));
      Writeln(Format('%d SMBios tables found', [Length(SMBios.SMBiosTablesList)]));
      Writeln;
      Writeln('Type Handle Length Index Description');
      for Entry in SMBios.SMBiosTablesList do
        Writeln(Format('%3d  %4x   %3d    %4d    %s', [Entry.Header.TableType, Entry.Header.Handle, Entry.Header.Length,
          Entry.Index, SMBiosTablesDescr[Entry.Header.TableType]]));
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    ReportMemoryLeaksOnShutdown := True;
    ListSMBiosTables;
  except
    on E : Exception do
      Writeln(E.Classname, ':', E.Message);
  end;
  Writeln('Press Enter to exit');
  Readln;

end.
