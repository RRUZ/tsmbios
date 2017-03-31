program MemoryControllerInfo;

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

procedure GetMemoryControllerInfo;
  Var
    SMBios : TSMBios;
    LMemoryController : TMemoryControllerInformation;
  begin
    SMBios := TSMBios.Create;
    try
      // SMBios.FindAndLoadFromFile('C:\Users\Dexter\Desktop\RAD Studio Projects\2010\SMBIOS Delphi\Docs\DELL_system_dumps\PE8450\SMBIOS.dat');
      WriteLn('Memory Controller Information');
      WriteLn('-----------------------------');
      if SMBios.HasMemoryControllerInfo
      then
        for LMemoryController in SMBios.MemoryControllerInfo do
        begin
          WriteLn(Format('Error Detecting Method %d - %s',
            [LMemoryController.RAWMemoryControllerInformation.ErrorDetectingMethod,
            LMemoryController.GetErrorDetectingMethodDescr]));
          WriteLn(Format('Error Correcting Capability %s',
            [ByteToBinStr(LMemoryController.RAWMemoryControllerInformation.ErrorCorrectingCapability)]));
          WriteLn(Format('Supported Interleave   %d - %s',
            [LMemoryController.RAWMemoryControllerInformation.SupportedInterleave,
            LMemoryController.GetSupportedInterleaveDescr]));
          WriteLn(Format('Current Interleave     %d - %s',
            [LMemoryController.RAWMemoryControllerInformation.CurrentInterleave,
            LMemoryController.GetCurrentInterleaveDescr]));
          WriteLn(Format('Maximum Memory Module Size  %d',
            [LMemoryController.RAWMemoryControllerInformation.MaximumMemoryModuleSize]));
          WriteLn(Format('Supported Speeds       %s',
            [WordToBinStr(LMemoryController.RAWMemoryControllerInformation.SupportedSpeeds)]));
          WriteLn(Format('Supported Memory Types %s',
            [WordToBinStr(LMemoryController.RAWMemoryControllerInformation.SupportedMemoryTypes)]));
          WriteLn(Format('Memory Module Voltage  %s',
            [ByteToBinStr(LMemoryController.RAWMemoryControllerInformation.MemoryModuleVoltage)]));
          WriteLn(Format('Number of Associated Memory Slots    %d',
            [LMemoryController.RAWMemoryControllerInformation.NumberofAssociatedMemorySlots]));
          WriteLn(Format('Memory Module Configuration Handles  %d',
            [LMemoryController.RAWMemoryControllerInformation.MemoryModuleConfigurationHandles]));
          WriteLn(Format('Error Correcting Capability %s',
            [ByteToBinStr(LMemoryController.RAWMemoryControllerInformation.ErrorCorrectingCapability)]));

          WriteLn;
        end
      else
        WriteLn('No Memory Controller Information was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetMemoryControllerInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
