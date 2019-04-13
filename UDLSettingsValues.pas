unit UDLSettingsValues;

interface

uses
  Windows, Classes, StreamedObjects, TypedStream, UDLSettings, Contnrs;

type
  TUDLValuesList = class;

  TUDLValue = class(TStreamedObject)
  private
    FUDLSetting: TUDLSetting;
    FUDLSettingsList: TUDLSettingsList;
    FUDLValuesList: TUDLValuesList;
    FValue: Variant;
  protected
    procedure LoadFromTypedStream(const Stream: TTypedStream); override;
    procedure SaveToTypedStream(const Stream: TTypedStream); override;
  public
    function Command: string;
    function Enabled: Boolean;
    function Visible: Boolean;
    procedure SetDefault(const Default: string);
    property UDLSetting: TUDLSetting read FUDLSetting write FUDLSetting;
    property UDLSettingsList: TUDLSettingsList read FUDLSettingsList write FUDLSettingsList;
    property UDLValuesList: TUDLValuesList read FUDLValuesList write FUDLValuesList;
    property Value: Variant read FValue write FValue;
  end;

  TUDLValuesList = class(TStreamedObjectList)
  private
    FUDLSettingsList: TUDLSettingsList;
  protected
    procedure ObjectCreated(const Obj: TObject); override;
  public
    constructor Create(const UDLSettingsList: TUDLSettingsList); reintroduce;
    function Command: string;
    procedure LoadFromStream(const Stream: TTypedStream);
    function ValueBySetting(const Setting: TUDLSetting): TUDLValue;
  end;

implementation

uses
  SysUtils, Variants;

function TUDLValue.Command: string;
begin
  Result := '';
  if not Visible then
    Exit;
  if not Enabled then
    Exit;
  if not FUDLSetting.AlwaysAdd and AnsiSameText(FUDLSetting.NotUseIfEqual, VarToStr(FValue)) then
    Exit;
  case FUDLSetting.SettingType of
    stInteger: Result := FUDLSetting.Param + ' ' + IntToStr(FValue);
    stString: Result := FUDLSetting.Param + ' "' + VarToStr(FValue) + '"';
    stBoolean: if FValue then Result := FUDLSetting.Param else Result := FUDLSetting.FalseParam;
    stFloat: Result := FUDLSetting.Param + ' ' + FloatToStr(FValue);
    stTrackBar: Result := FUDLSetting.Param + ' ' + FloatToStr(FValue);
    stFileName: Result := FUDLSetting.Param + ' "' + VarToStr(FValue) + '"';
    stBitFlags: Result := FUDLSetting.Param + ' ' + IntToStr(FValue);
    stList: Result := FUDLSetting.Param + ' ' + VarToStr(FValue);
    stFolderName: Result := FUDLSetting.Param + ' "' + VarToStr(FValue) + '"';
  end;
end;

function TUDLValue.Enabled: Boolean;
var
  DependValue: string;
  V: Variant;
  i: Integer;
  DependBlock: TUDLDependBlock;
  Val: TUDLValue;
begin
  Result := True;
  if Assigned(FUDLSetting.DependBlocks) then
  begin
    Result := (FUDLSetting.DependMode = dmAND);
    for i := 0 to FUDLSetting.DependBlocks.Count - 1 do
    begin
      DependBlock := TUDLDependBlock(FUDLSetting.DependBlocks[i]);
      if Assigned(DependBlock.DependSetting) then
      begin
        DependValue := DependBlock.DependValue;
        Val := FUDLValuesList.ValueBySetting(DependBlock.DependSetting);
        if not Val.Visible then
          Continue;
        V := Val.Value;
        case DependBlock.DependCondition of
          dcEqual: Result := (V = DependValue);
          dcNotEqual: Result := (V <> DependValue);
          dcHigher: Result := (V > DependValue);
          dcEqualOrHigher: Result := (V >= DependValue);
          dcLower: Result := (V < DependValue);
          dcEqualOrLower: Result := (V <= DependValue);
        end;
      end;
      if (Result and (FUDLSetting.DependMode = dmOR)) or (not Result and (FUDLSetting.DependMode = dmAND)) then
        Break;
    end;
  end;
end;

procedure TUDLValue.LoadFromTypedStream(const Stream: TTypedStream);
var
  s: string;
  SavedType: Integer;
begin
  s := Stream.ReadString;
  FUDLSetting := FUDLSettingsList.SettingByName(s);
  if Assigned(FUDLSetting) then
  begin
    SavedType := Stream.ReadInteger;
    if SavedType = Integer(FUDLSetting.SettingType) then
    begin
      case FUDLSetting.SettingType of
        stInteger: Value := Stream.ReadInteger;
        stString: Value := Stream.ReadString;
        stBoolean: Value := Stream.ReadBoolean;
        stFloat: Value := Stream.ReadExtended;
        stTrackBar: Value := Stream.ReadExtended;
        stFileName: Value := Stream.ReadString;
        stBitFlags: Value := Stream.ReadInteger;
        stList: Value := Stream.ReadString;
        stFolderName: Value := Stream.ReadString;
      end;
    end;
  end;
end;

procedure TUDLValue.SaveToTypedStream(const Stream: TTypedStream);
begin
  Stream.WriteString(FUDLSetting.Name);
  Stream.WriteInteger(Integer(FUDLSetting.SettingType));
  case FUDLSetting.SettingType of
    stInteger: Stream.WriteInteger(Value);
    stString: Stream.WriteString(Value);
    stBoolean: Stream.WriteBoolean(Value);
    stFloat: Stream.WriteExtended(Value);
    stTrackBar: Stream.WriteExtended(Value);
    stFileName: Stream.WriteString(Value);
    stBitFlags: Stream.WriteInteger(Value);
    stList: Stream.WriteString(Value);
    stFolderName: Stream.WriteString(Value);
    else
      raise Exception.Create('Невозможно сохранить значение настройки ' + FUDLSetting.Name + ' с типом ' + IntToStr(Integer(FUDLSetting.SettingType)) + '!');
  end;
end;

procedure TUDLValue.SetDefault(const Default: string);
begin
  if Default = '' then
    Exit;
  case FUDLSetting.SettingType of
    stInteger: FValue := StrToInt(Default);
    stString: FValue := Default;
    stBoolean: FValue := StrToBool(Default);
    stFloat: FValue := StrToFloat(Default);
    stTrackBar: FValue := StrToFloat(Default);
    stFileName: FValue := Default;
    stBitFlags: FValue := StrToInt(Default);
    stList:
      begin
        FValue := Default;
        if (FValue = '' ) and (FUDLSetting.ListValues.Count > 0) then
          FValue := FUDLSetting.ListValues[0];
      end;
    stFolderName: FValue := Default;
    else
      raise Exception.Create('Невозможно установить значение по умолчанию для настройки ' + FUDLSetting.Name + ' с типом ' + IntToStr(Integer(FUDLSetting.SettingType)) + '!');
  end;
end;

function TUDLValue.Visible: Boolean;
begin
  Result := (FUDLSettingsList.DoomPortType in FUDLSetting.Port) and
    not((FUDLSettingsList.GameMode = 1) and FUDLSetting.NotUsedInClientMode) and
    ((FUDLSetting.IWADNames.Count = 0) or (FUDLSetting.IWADNames.IndexOf(FUDLSettingsList.IWAD) >= 0));
end;

constructor TUDLValuesList.Create(const UDLSettingsList: TUDLSettingsList);
begin
  inherited Create;
  FUDLSettingsList := UDLSettingsList;
end;

function TUDLValuesList.Command: string;
var
  i: Integer;
  Value: TUDLValue;
  s: string;
begin
  Result := '';
  for i := 0 to FList.Count - 1 do
  begin
    Value := TUDLValue(FList[i]);
    s := Value.Command;
    if s <> '' then
    begin
      if Result <> '' then
        Result := Result + ' ';
      Result := Result + s;
    end;
  end;
end;

procedure TUDLValuesList.LoadFromStream(const Stream: TTypedStream);
var
  i: Integer;
begin
  inherited LoadFromStream(Stream);
  for i := FList.Count - 1 downto 0 do
    if not Assigned(TUDLValue(FList[i]).UDLSetting) then
      FList.Remove(FList[i]);
end;

procedure TUDLValuesList.ObjectCreated(const Obj: TObject);
begin
  inherited ObjectCreated(Obj);
  TUDLValue(Obj).FUDLSettingsList := FUDLSettingsList;
  TUDLValue(Obj).FUDLValuesList := Self;
end;

function TUDLValuesList.ValueBySetting(const Setting: TUDLSetting): TUDLValue;
var
  i: Integer;
  Value: TUDLValue;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
  begin
    Value := TUDLValue(FList[i]);
    if Value.UDLSetting = Setting then
    begin
      Result := Value;
      Break;
    end;
  end;
  if not Assigned(Result) then
  begin
    Result := TUDLValue.Create;
    FList.Add(Result);
    Result.UDLSettingsList := FUDLSettingsList;
    Result.UDLSetting := Setting;
    Result.UDLValuesList := Self;
    Result.SetDefault(Setting.Default);
  end;
end;

initialization
  RegisterClass(TUDLValue);
  RegisterClass(TUDLValuesList);

end.
