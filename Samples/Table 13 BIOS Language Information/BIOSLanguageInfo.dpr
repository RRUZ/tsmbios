program BIOSLanguageInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  uSMBIOS in '..\..\Common\uSMBIOS.pas';

function ByteToBinStr(AValue:Byte):string;
const
  Bits : array[1..8] of byte = (128,64,32,16,8,4,2,1);
  var i: integer;
begin
  Result:='00000000';
  if (AValue<>0) then
  for i:=1 to 8 do
    if (AValue and Bits[i])<>0 then Result[i]:='1';
end;

procedure GetBIOSLanguageInfo;
Var
  SMBios : TSMBios;
  LBIOSLng  : TBIOSLanguageInformation;
  i: integer;
begin
  SMBios:=TSMBios.Create;
  try
      WriteLn('BIOS Language Information');
      if SMBios.HasBIOSLanguageInfo then
      for LBIOSLng in SMBios.BIOSLanguageInfo do
      begin
        WriteLn('Installable Languages  '+IntToStr( LBIOSLng.InstallableLanguages));
        WriteLn('Flags                  '+ByteToBinStr(LBIOSLng.Flags));
        WriteLn('Current Language       '+LBIOSLng.GetCurrentLanguageStr);

        if LBIOSLng.InstallableLanguages>1 then
        begin
          WriteLn('BIOS Languages');
          WriteLn('--------------');
          for i:=1 to LBIOSLng.InstallableLanguages do
            WriteLn('  '+LBIOSLng.GetLanguageString(i));
        end;

        WriteLn;
      end
      else
      Writeln('No BIOS Language Info was found');
  finally
   SMBios.Free;
  end;
end;


begin
 try
    CoInitialize(nil);
    try
      GetBIOSLanguageInfo;
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
