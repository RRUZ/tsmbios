program ProcessorInformation;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  TypInfo,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

//http://tondrej.blogspot.com/2007/10/settostring-stringtoset.html
function GetOrdValue(Info: PTypeInfo; const SetParam): Integer;
begin
  Result := 0;

  case GetTypeData(Info)^.OrdType of
    otSByte, otUByte:
      Result := Byte(SetParam);
    otSWord, otUWord:
      Result := Word(SetParam);
    otSLong, otULong:
      Result := Integer(SetParam);
  end;
end;


function SetToString(Info: PTypeInfo; const SetParam; Brackets: Boolean): AnsiString;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  Result := '';

  Integer(S) := GetOrdValue(Info, SetParam);
  TypeInfo := GetTypeData(Info)^.CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;

procedure GetEnclosureInfo;
Var
  SMBios             : TSMBios;
  LProcessorInfo     : TProcessorInfo;
  LSRAMTypes         : TCacheSRAMTypes;
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
        WriteLn('Serial Number      '+LProcessorInfo.SerialNumberStr);
        WriteLn('Asset Tag          '+LProcessorInfo.AssetTagStr);
        WriteLn('Part Number        '+LProcessorInfo.PartNumberStr);
        WriteLn(Format('Core Count         %d',[LProcessorInfo.CoreCount]));
        WriteLn(Format('Cores Enabled      %d',[LProcessorInfo.CoreEnabled]));
        WriteLn(Format('Threads Count      %d',[LProcessorInfo.ThreadCount]));
        WriteLn(Format('Processor Characteristics %.4x',[LProcessorInfo.ProcessorCharacteristics]));
        Writeln;

        if LProcessorInfo.L1CacheHandle>0 then
        begin
          WriteLn('L1 Cache Handle Info');
          WriteLn('--------------------');
          WriteLn('  Socket Designation    '+LProcessorInfo.L1Chache.SocketDesignationStr);
          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L1Chache.CacheConfiguration]));
          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L1Chache.GetMaximumCacheSize]));
          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L1Chache.GetInstalledCacheSize]));
          LSRAMTypes:=LProcessorInfo.L1Chache.GetSupportedSRAMType;
          WriteLn(Format('  Supported SRAM Type   %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));
          LSRAMTypes:=LProcessorInfo.L1Chache.GetCurrentSRAMType;
          WriteLn(Format('  Current SRAM Type     %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));

          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L1Chache.GetErrorCorrectionType]]));
          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L1Chache.GetSystemCacheType]]));
          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L1Chache.AssociativityStr]));
        end;

        if LProcessorInfo.L2CacheHandle>0 then
        begin
          WriteLn('L2 Cache Handle Info');
          WriteLn('--------------------');
          WriteLn('  Socket Designation    '+LProcessorInfo.L2Chache.SocketDesignationStr);
          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L2Chache.CacheConfiguration]));
          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L2Chache.GetMaximumCacheSize]));
          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L2Chache.GetInstalledCacheSize]));
          LSRAMTypes:=LProcessorInfo.L2Chache.GetSupportedSRAMType;
          WriteLn(Format('  Supported SRAM Type   %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));
          LSRAMTypes:=LProcessorInfo.L2Chache.GetCurrentSRAMType;
          WriteLn(Format('  Current SRAM Type     %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));

          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L2Chache.GetErrorCorrectionType]]));
          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L2Chache.GetSystemCacheType]]));
          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L2Chache.AssociativityStr]));
        end;

        if LProcessorInfo.L3CacheHandle>0 then
        begin
          WriteLn('L3 Cache Handle Info');
          WriteLn('--------------------');
          WriteLn('  Socket Designation    '+LProcessorInfo.L3Chache.SocketDesignationStr);
          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L3Chache.CacheConfiguration]));
          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L3Chache.GetMaximumCacheSize]));
          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L3Chache.GetInstalledCacheSize]));
          LSRAMTypes:=LProcessorInfo.L3Chache.GetSupportedSRAMType;
          WriteLn(Format('  Supported SRAM Type   %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));
          LSRAMTypes:=LProcessorInfo.L3Chache.GetCurrentSRAMType;
          WriteLn(Format('  Current SRAM Type     %s',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes, True)]));

          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L3Chache.GetErrorCorrectionType]]));
          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L3Chache.GetSystemCacheType]]));
          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L3Chache.AssociativityStr]));
        end;
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
