program MemoryDeviceInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetMemoryDeviceInfo;
Var
  SMBios : TSMBios;
  LMemoryDevice  : TMemoryDeviceInformation;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Memory Device Information');
      WriteLn('-------------------------');

      if SMBios.HasPhysicalMemoryArrayInfo then
      for LMemoryDevice in SMBios.MemoryDeviceInformation do
      begin
        WriteLn(Format('Total Width %d bits',[LMemoryDevice.RAWMemoryDeviceInfo.TotalWidth]));
        WriteLn(Format('Data Width  %d bits',[LMemoryDevice.RAWMemoryDeviceInfo.DataWidth]));
        WriteLn(Format('Size        %d Mbytes',[LMemoryDevice.GetSize]));

        WriteLn;

        if LMemoryDevice.RAWMemoryDeviceInfo.PhysicalMemoryArrayHandle>0 then
        begin
          WriteLn('  Physical Memory Array');
          WriteLn('  ---------------------');
          WriteLn('  Location         '+LMemoryDevice.PhysicalMemoryArray.GetLocationStr);
          WriteLn('  Use              '+LMemoryDevice.PhysicalMemoryArray.GetUseStr);
          WriteLn('  Error Correction '+LMemoryDevice.PhysicalMemoryArray.GetErrorCorrectionStr);
          if LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.MaximumCapacity<>$80000000 then
            WriteLn(Format('  Maximum Capacity %d Kb',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.MaximumCapacity]))
          else
            WriteLn(Format('  Maximum Capacity %d bytes',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.ExtendedMaximumCapacity]));

          WriteLn(Format('  Memory devices   %d',[LMemoryDevice.PhysicalMemoryArray.RAWPhysicalMemoryArrayInformation.NumberofMemoryDevices]));
        end;
        WriteLn;
      end
      else
      Writeln('No Memory Device Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    GetMemoryDeviceInfo;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.
