program MemArrayMappedInfo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, uSMBIOS
  { you can add units after this };

procedure GetMemArrayMappedInfo;
Var
  SMBios : TSMBios;
  LMemArrMappedAddress  : TMemoryArrayMappedAddressInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Memory Array Mapped Address Information');
      WriteLn('---------------------------------------');
      if SMBios.HasMemoryArrayMappedAddressInfo then
      for LMemArrMappedAddress in SMBios.MemoryArrayMappedAddressInformation do
      begin
        WriteLn(Format('Starting Address    %.8x ',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.StartingAddress]));
        WriteLn(Format('Ending   Address    %.8x ',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.EndingAddress]));
        WriteLn(Format('Memory Array Handle %.4x ',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.MemoryArrayHandle]));
        WriteLn(Format('Partition Width     %d ',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.PartitionWidth]));
        if SMBios.SmbiosVersion>='2.7' then
        begin
          WriteLn(Format('Extended Starting Address  %x',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.ExtendedStartingAddress]));
          WriteLn(Format('Extended Ending   Address  %x',[LMemArrMappedAddress.RAWMemoryArrayMappedAddressInfo^.ExtendedEndingAddress]));
        end;

        WriteLn;
      end
      else


      Writeln('No Memory Array Mapped Address Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetMemArrayMappedInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
