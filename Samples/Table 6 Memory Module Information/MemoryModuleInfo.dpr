program MemoryModuleInfo;

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

function WordToBinStr(AValue : Word) : string;
  const
    Bits : array [1 .. 16] of Word = (32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1);
  var
    i : integer;
  begin
    Result := '0000000000000000';
    if (AValue <> 0)
    then
      for i := 1 to 16 do
        if (AValue and Bits[i]) <> 0
        then
          Result[i] := '1';
  end;

procedure GetMemoryModuleInfo;
  Var
    SMBios : TSMBios;
    LMemoryModule : TMemoryModuleInformation;
  begin
    SMBios := TSMBios.Create;
    try
      // SMBios.FindAndLoadFromFile('C:\Users\Foo\Desktop\RAD Studio Projects\google-code\SMBIOS Delphi\Docs\DELL_system_dumps\PE8450\SMBIOS.dat');
      WriteLn('Memory Module Information');
      WriteLn('-----------------------------');
      if SMBios.HasMemoryModuleInfo
      then
        for LMemoryModule in SMBios.MemoryModuleInfo do
        begin
          WriteLn(Format('Socket Designation  %s', [LMemoryModule.GetSocketDesignationDescr]));
          WriteLn(Format('Bank Connections    %s',
            [ByteToBinStr(LMemoryModule.RAWMemoryModuleInformation.BankConnections)]));
          WriteLn(Format('CurrentSpeed        %d ns', [LMemoryModule.RAWMemoryModuleInformation.CurrentSpeed]));
          // If the speed is unknown, the field is set to 0.
          WriteLn(Format('Current Memory Type %s',
            [WordToBinStr(LMemoryModule.RAWMemoryModuleInformation.CurrentMemoryType)]));
          WriteLn(Format('Installed Size      %s',
            [ByteToBinStr(LMemoryModule.RAWMemoryModuleInformation.InstalledSize)]));
          WriteLn(Format('Enabled Size        %s',
            [ByteToBinStr(LMemoryModule.RAWMemoryModuleInformation.EnabledSize)]));
          WriteLn(Format('Error Status        %s',
            [ByteToBinStr(LMemoryModule.RAWMemoryModuleInformation.ErrorStatus)]));
          WriteLn;
        end
      else
        WriteLn('No Memory Module Information was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetMemoryModuleInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
