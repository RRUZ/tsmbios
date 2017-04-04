program ProcessorInformation;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  TypInfo,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

function SetToString(Info : PTypeInfo; const Value) : String;
  var
    LTypeInfo : PTypeInfo;
    LIntegerSet : TIntegerSet;
    I : Integer;

    function GetOrdValue : Integer;
      begin
        Result := 0;
        case GetTypeData(Info)^.OrdType of
          otSByte, otUByte :
            Result := Byte(Value);
          otSWord, otUWord :
            Result := Word(Value);
          otSLong, otULong :
            Result := Integer(Value);
        end;
      end;

  begin
    Result := '';
    Integer(LIntegerSet) := GetOrdValue;
    LTypeInfo := GetTypeData(Info)^.CompType{$IFNDEF FPC}^{$ENDIF};
    for I := 0 to SizeOf(Integer) * 8 - 1 do
      if I in LIntegerSet
      then
      begin
        if Result <> ''
        then
          Result := Result + ',';
        Result := Result + GetEnumName(LTypeInfo, I);
      end;
  end;

procedure GetProcessorInfo;
  Var
    SMBios : TSMBios;
    LProcessorInfo : TProcessorInformation;
    LSRAMTypes : TCacheSRAMTypes;
    I : Integer;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Processor Information');
      if SMBios.HasProcessorInfo
      then
        for I := Low(SMBios.ProcessorInfo) to High(SMBios.ProcessorInfo) do
        begin
          LProcessorInfo := SMBios.ProcessorInfo[I];
          WriteLn('Manufacter         ' + LProcessorInfo.ProcessorManufacturerStr);
          WriteLn('Socket Designation ' + LProcessorInfo.SocketDesignationStr);
          WriteLn('Type               ' + LProcessorInfo.ProcessorTypeStr);
          WriteLn('Familiy            ' + LProcessorInfo.ProcessorFamilyStr);
          WriteLn('Version            ' + LProcessorInfo.ProcessorVersionStr);
          WriteLn(Format('Processor ID       %x', [LProcessorInfo.RAWProcessorInformation^.ProcessorID]));
          WriteLn(Format('Voltaje            %n', [LProcessorInfo.GetProcessorVoltaje]));
          WriteLn(Format('External Clock     %d  Mhz', [LProcessorInfo.RAWProcessorInformation^.ExternalClock]));
          WriteLn(Format('Maximum processor speed %d  Mhz', [LProcessorInfo.RAWProcessorInformation^.MaxSpeed]));
          WriteLn(Format('Current processor speed %d  Mhz', [LProcessorInfo.RAWProcessorInformation^.CurrentSpeed]));
          WriteLn('Processor Upgrade   ' + LProcessorInfo.ProcessorUpgradeStr);
          WriteLn(Format('External Clock     %d  Mhz', [LProcessorInfo.RAWProcessorInformation^.ExternalClock]));

          if SMBios.SmbiosVersion >= '2.3'
          then
          begin
            WriteLn('Serial Number      ' + LProcessorInfo.SerialNumberStr);
            WriteLn('Asset Tag          ' + LProcessorInfo.AssetTagStr);
            WriteLn('Part Number        ' + LProcessorInfo.PartNumberStr);
            if SMBios.SmbiosVersion >= '2.5'
            then
            begin
              WriteLn(Format('Core Count         %d', [LProcessorInfo.RAWProcessorInformation^.CoreCount]));
              WriteLn(Format('Cores Enabled      %d', [LProcessorInfo.RAWProcessorInformation^.CoreEnabled]));
              WriteLn(Format('Threads Count      %d', [LProcessorInfo.RAWProcessorInformation^.ThreadCount]));
              WriteLn(Format('Processor Characteristics %.4x',
                [LProcessorInfo.RAWProcessorInformation^.ProcessorCharacteristics]));
            end;
          end;
          WriteLn;

          if (LProcessorInfo.RAWProcessorInformation^.L1CacheHandle > 0) and (LProcessorInfo.L2Chache <> nil)
          then
          begin
            WriteLn('L1 Cache Handle Info');
            WriteLn('--------------------');
            WriteLn('  Socket Designation    ' + LProcessorInfo.L1Chache.SocketDesignationStr);
            WriteLn(Format('  Cache Configuration   %.4x',
              [LProcessorInfo.L1Chache.RAWCacheInformation^.CacheConfiguration]));
            WriteLn(Format('  Maximum Cache Size    %d Kb', [LProcessorInfo.L1Chache.GetMaximumCacheSize]));
            WriteLn(Format('  Installed Cache Size  %d Kb', [LProcessorInfo.L1Chache.GetInstalledCacheSize]));
            LSRAMTypes := LProcessorInfo.L1Chache.GetSupportedSRAMType;
            WriteLn(Format('  Supported SRAM Type   [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
            LSRAMTypes := LProcessorInfo.L1Chache.GetCurrentSRAMType;
            WriteLn(Format('  Current SRAM Type     [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));

            WriteLn(Format('  Error Correction Type %s',
              [ErrorCorrectionTypeStr[LProcessorInfo.L1Chache.GetErrorCorrectionType]]));
            WriteLn(Format('  System Cache Type     %s',
              [SystemCacheTypeStr[LProcessorInfo.L1Chache.GetSystemCacheType]]));
            WriteLn(Format('  Associativity         %s', [LProcessorInfo.L1Chache.AssociativityStr]));
          end;

          if (LProcessorInfo.RAWProcessorInformation^.L2CacheHandle > 0) and (LProcessorInfo.L2Chache <> nil)
          then
          begin
            WriteLn('L2 Cache Handle Info');
            WriteLn('--------------------');
            WriteLn('  Socket Designation    ' + LProcessorInfo.L2Chache.SocketDesignationStr);
            WriteLn(Format('  Cache Configuration   %.4x',
              [LProcessorInfo.L2Chache.RAWCacheInformation^.CacheConfiguration]));
            WriteLn(Format('  Maximum Cache Size    %d Kb', [LProcessorInfo.L2Chache.GetMaximumCacheSize]));
            WriteLn(Format('  Installed Cache Size  %d Kb', [LProcessorInfo.L2Chache.GetInstalledCacheSize]));
            LSRAMTypes := LProcessorInfo.L2Chache.GetSupportedSRAMType;
            WriteLn(Format('  Supported SRAM Type   [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
            LSRAMTypes := LProcessorInfo.L2Chache.GetCurrentSRAMType;
            WriteLn(Format('  Current SRAM Type     [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));

            WriteLn(Format('  Error Correction Type %s',
              [ErrorCorrectionTypeStr[LProcessorInfo.L2Chache.GetErrorCorrectionType]]));
            WriteLn(Format('  System Cache Type     %s',
              [SystemCacheTypeStr[LProcessorInfo.L2Chache.GetSystemCacheType]]));
            WriteLn(Format('  Associativity         %s', [LProcessorInfo.L2Chache.AssociativityStr]));
          end;

          if (LProcessorInfo.RAWProcessorInformation^.L3CacheHandle > 0) and (LProcessorInfo.L3Chache <> nil)
          then
          begin
            WriteLn('L3 Cache Handle Info');
            WriteLn('--------------------');
            WriteLn('  Socket Designation    ' + LProcessorInfo.L3Chache.SocketDesignationStr);
            WriteLn(Format('  Cache Configuration   %.4x',
              [LProcessorInfo.L3Chache.RAWCacheInformation^.CacheConfiguration]));
            WriteLn(Format('  Maximum Cache Size    %d Kb', [LProcessorInfo.L3Chache.GetMaximumCacheSize]));
            WriteLn(Format('  Installed Cache Size  %d Kb', [LProcessorInfo.L3Chache.GetInstalledCacheSize]));
            LSRAMTypes := LProcessorInfo.L3Chache.GetSupportedSRAMType;
            WriteLn(Format('  Supported SRAM Type   [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
            LSRAMTypes := LProcessorInfo.L3Chache.GetCurrentSRAMType;
            WriteLn(Format('  Current SRAM Type     [%s]', [SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));

            WriteLn(Format('  Error Correction Type %s',
              [ErrorCorrectionTypeStr[LProcessorInfo.L3Chache.GetErrorCorrectionType]]));
            WriteLn(Format('  System Cache Type     %s',
              [SystemCacheTypeStr[LProcessorInfo.L3Chache.GetSystemCacheType]]));
            WriteLn(Format('  Associativity         %s', [LProcessorInfo.L3Chache.AssociativityStr]));
          end;

          Readln;
        end
      else
        WriteLn('No Processor Info was found');
    finally
      SMBios.Free;
    end;
  end;

begin
  try
    GetProcessorInfo;
  except
    on E : Exception do
      WriteLn(E.Classname, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;

end.
