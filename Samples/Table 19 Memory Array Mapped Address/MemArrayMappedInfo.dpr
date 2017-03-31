program MemArrayMappedInfo;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetMemArrayMappedInfo;
  Var
    SMBios : TSMBios;
    LMemArrMappedAddress : TMemoryArrayMappedAddressInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Memory Array Mapped Address Information');
      WriteLn('---------------------------------------');
      if SMBios.HasMemoryArrayMappedAddressInfo
      then
        for LMemArrMappedAddress in SMBios.MemoryArrayMappedAddressInformation do
        begin
          WriteLn(Format('Starting Address    %.8x ',
            [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.StartingAddress]));
          WriteLn(Format('Ending   Address    %.8x ',
            [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.EndingAddress]));
          WriteLn(Format('Memory Array Handle %.4x ',
            [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.MemoryArrayHandle]));
          WriteLn(Format('Partition Width     %d ',
            [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.PartitionWidth]));
          if SMBios.SmbiosVersion >= '2.7'
          then
          begin
            WriteLn(Format('Extended Starting Address  %x',
              [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.ExtendedStartingAddress]));
            WriteLn(Format('Extended Ending   Address  %x',
              [LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo.ExtendedEndingAddress]));
          end;

          WriteLn;
        end
      else

        WriteLn('No Memory Array Mapped Address Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetMemArrayMappedInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
