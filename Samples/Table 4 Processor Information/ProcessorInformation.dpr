program ProcessorInformation;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

procedure GetEnclosureInfo;
Var
  SMBios             : TSMBios;
  LProcessorInfo     : TProcessorInfo;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('Processor Information');
      if SMBios.HasEnclosureInfo then
      for LProcessorInfo in SMBios.ProcessorInfo do
      begin
        WriteLn('Manufacter         '+LProcessorInfo.ProcessorManufacturerStr);
        WriteLn('Socket Designation '+LProcessorInfo.SocketDesignationStr);
        WriteLn('Type               '+LProcessorInfo.ProcessorTypeStr);
        WriteLn('Familiy            '+LProcessorInfo.ProcessorFamilyStr);
        WriteLn('Version            '+LProcessorInfo.ProcessorVersionStr);
        WriteLn(Format('Processor ID       %x',[LProcessorInfo.ProcessorID]));
        WriteLn(Format('Voltaje            %n',[LProcessorInfo.GetProcessorVoltaje]));
        WriteLn(Format('External Clock     %d  Mhz',[LProcessorInfo.ExternalClock]));
        WriteLn(Format('Maximum processor speed %d  Mhz',[LProcessorInfo.MaxSpeed]));
        WriteLn(Format('Current processor speed %d  Mhz',[LProcessorInfo.CurrentSpeed]));
        WriteLn('Processor Upgrade   '+LProcessorInfo.ProcessorUpgradeStr);
        WriteLn(Format('External Clock     %d  Mhz',[LProcessorInfo.ExternalClock]));
        WriteLn(Format('L1 Cache Handle    %x',[LProcessorInfo.L1CacheHandle]));
        WriteLn(Format('L2 Cache Handle    %x',[LProcessorInfo.L2CacheHandle]));
        WriteLn(Format('L3 Cache Handle    %x',[LProcessorInfo.L3CacheHandle]));
        WriteLn('Serial Number      '+LProcessorInfo.SerialNumberStr);
        WriteLn('Asset Tag          '+LProcessorInfo.AssetTagStr);
        WriteLn('Part Number        '+LProcessorInfo.PartNumberStr);
        WriteLn(Format('Core Count         %d',[LProcessorInfo.CoreCount]));
        WriteLn(Format('Cores Enabled      %d',[LProcessorInfo.CoreEnabled]));
        WriteLn(Format('Threads Count      %d',[LProcessorInfo.ThreadCount]));
        WriteLn(Format('Processor Characteristics %.4x',[LProcessorInfo.ProcessorCharacteristics]));

        WriteLn;
      end
      else
      Writeln('No Processor Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetEnclosureInfo;
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
