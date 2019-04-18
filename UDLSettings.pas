unit UDLSettings;

interface

uses
  SysUtils, Windows, Classes, Contnrs, UDLPorts;

type
  TUDLSettingType = (stInteger, stString, stBoolean, stFloat, stTrackBar, stFileName, stBitFlags, stList, stFolderName);
  TUDLDependCond = (dcEqual, dcNotEqual, dcHigher, dcEqualOrHigher, dcLower, dcEqualOrLower);
  TUDLDependMode = (dmOR, dmAND);

type
  TUDLSetting = class;

  TUDLDependBlock = class(TObject)
  public
    DependCondition: TUDLDependCond;
    DependSetting: TUDLSetting;
    DependsOn: string;
    DependValue: string;
    constructor Create;
  end;

  TUDLSetting = class(TObject)
  protected
    function GetStringFromList(const SL: TStringList; const s: string; const IsRequered: Boolean): string;
  public
    AddEmptyItem: Boolean;
    AlwaysAdd: Boolean;
    BitFlags: TStringList;
    Default: string;
    DependBlocks: TObjectList;
    DependMode: TUDLDependMode;
    FalseParam: string;
    FlagGroups: TStringList;
    Frequency: Extended;
    HasDefault: Boolean;
    IWADNames: TStringList;
    ListItems: TStringList;
    ListValues: TStringList;
    MaxValue: Extended;
    MinValue: Extended;
    Name: string;
    NotUsedInClientMode: Boolean;
    NotUseIfEqual: string;
    Param: string;
    Port: TDoomPortTypeSet;
    SettingDescription: string;
    SettingName: string;
    SettingType: TUDLSettingType;
    constructor Create(const FName: string); reintroduce;
    destructor Destroy; override;
    procedure LoadFrom(const SL: TStringList);
    procedure RegisterResources; virtual;
    function TranslatedBitFlag(const Index: Integer): string;
    function TranslatedDescription: string;
    function TranslatedListItem(const Index: Integer): string;
    function TranslatedName: string;
  end;

  TUDLSettingsList = class(TObject)
  private
    FDoomPortType: TDoomPortType;
    FGameMode: Integer;
    FIWAD: string;
    FList: TObjectList;
    function GetSetting(const Index: Integer): TUDLSetting;
  protected
    procedure RegisterResources;
    procedure UpdateRefs;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure LoadFrom(const ConfigFile: string);
    function SettingByName(const SettingName: string): TUDLSetting;
    property DoomPortType: TDoomPortType read FDoomPortType write FDoomPortType;
    property GameMode: Integer read FGameMode write FGameMode;
    property IWAD: string read FIWAD write FIWAD;
    property Setting[const Index: Integer]: TUDLSetting read GetSetting;
  end;


implementation

uses
  Forms, LanguagePacks, uResources;

constructor TUDLSetting.Create(const FName: string);
begin
  inherited Create;
  Name := FName;
  IWADNames := TStringList.Create;
  IWADNames.Delimiter := ',';
  MinValue := Integer.MinValue;
  MaxValue := Integer.MaxValue;
end;

destructor TUDLSetting.Destroy;
begin
  FreeAndNil(DependBlocks);
  FreeAndNil(IWADNames);
  FreeAndNil(FlagGroups);
  FreeAndNil(BitFlags);
  FreeAndNil(ListItems);
  FreeAndNil(ListValues);
  inherited Destroy;
end;

function TUDLSetting.GetStringFromList(const SL: TStringList; const s: string; const IsRequered: Boolean): string;
begin
  Result := Trim(SL.Values[s]);
  if IsRequered and (Result = '') then
    raise Exception.Create(Format(SBN('NoParamValue'), [s, Name]));
end;

procedure TUDLSetting.LoadFrom(const SL: TStringList);
var
  s: string;
  i, k: Integer;
  FlagName, BitName, FlagGroup: string;
  BitValue: Integer;
  ItemName, ValueName: string;
  UDLDependBlock: TUDLDependBlock;
  t: TStringList;
begin
  SettingName := GetStringFromList(SL, 'SettingName', True);
  SettingDescription := GetStringFromList(SL, 'SettingDescription', True);
  s := GetStringFromList(SL, 'SettingType', True);
  if AnsiSameText(s, 'Integer') then
    SettingType := stInteger
  else
  if AnsiSameText(s, 'String') then
    SettingType := stString
  else
  if AnsiSameText(s, 'Boolean') then
    SettingType := stBoolean
  else
  if AnsiSameText(s, 'Float') then
    SettingType := stFloat
  else
  if AnsiSameText(s, 'TrackBar') then
    SettingType := stTrackBar
  else
  if AnsiSameText(s, 'FileName') then
    SettingType := stFileName
  else
  if AnsiSameText(s, 'BitFlags') then
    SettingType := stBitFlags
  else
  if AnsiSameText(s, 'List') then
    SettingType := stList
  else
  if AnsiSameText(s, 'FolderName') then
    SettingType := stFolderName
  else
    raise Exception.Create(Format(SBN('WrongType'), [s, Name]));
  s := GetStringFromList(SL, 'MinValue', False);
  if s <> '' then
    if not TryStrToFloat(s, MinValue) then
      raise Exception.Create(Format(SBN('WrongParamValue'), ['MinValue ' + s, Name]));
  s := GetStringFromList(SL, 'MaxValue', False);
  if s <> '' then
    if not TryStrToFloat(s, MaxValue) then
      raise Exception.Create(Format(SBN('WrongParamValue'), ['MaxValue ' + s, Name]));
  if SettingType = stBitFlags then
  begin
    BitFlags := TStringList.Create;
    FlagGroups := TStringList.Create;
    i := 0;
    FlagName := 'Flag' + IntToStr(i);
    k := SL.IndexOfName(FlagName);
    while (k <> -1) do
    begin
      BitName := 'Bit' + IntToStr(i);
      s := Trim(SL.Values[BitName]);
      if s = '' then
        raise Exception.Create(Format(SBN('NoParam'), [BitName, Name]));
      if not TryStrToInt(s, BitValue) then
        raise Exception.Create(Format(SBN('WrongParamValue'), [BitName + ' ' + s, Name]));
      BitFlags.AddObject(Trim(SL.Values[FlagName]), TObject(BitValue));
      FlagGroup := 'FlagGroup' + IntToStr(i);
      s := Trim(SL.Values[FlagGroup]);
      FlagGroups.Add(s);
      Inc(i);
      FlagName := 'Flag' + IntToStr(i);
      k := SL.IndexOfName(FlagName);
    end;
  end;
  if SettingType = stList then
  begin
    ListItems := TStringList.Create;
    ListValues := TStringList.Create;
    AddEmptyItem := StrToBoolDef(GetStringFromList(SL, 'AddEmptyItem', False), False);
    if AddEmptyItem then
    begin
      ListItems.Add('');
      ListValues.Add('');
    end;
    i := 0;
    ItemName := 'Item' + IntToStr(i);
    k := SL.IndexOfName(ItemName);
    while (k <> -1) do
    begin
      ValueName := 'Value' + IntToStr(i);
      s := Trim(SL.Values[ValueName]);
      if s = '' then
        raise Exception.Create(Format(SBN('NoParam'), [ValueName, Name]));
      ListItems.Add(Trim(SL.Values[ItemName]));
      ListValues.Add(Trim(SL.Values[ValueName]));
      Inc(i);
      ItemName := 'Item' + IntToStr(i);
      k := SL.IndexOfName(ItemName);
    end;
  end;
  Param := GetStringFromList(SL, 'Param', False);
  s := GetStringFromList(SL, 'Port', False);
  if s = '' then
    Port := [ptUnknown, ptGZDoom]
  else
  begin
    t := TStringList.Create;
    try
      t.Delimiter := ',';
      t.QuoteChar := #0;
      t.DelimitedText := s;
      for i := 0 to t.Count - 1 do
        if AnsiSameText(Trim(t[i]), 'GZDoom') then
          Port := Port + [ptGZDoom]
        else
          Port := Port + [ptUnknown];
    finally
      t.Free;
    end;
  end;
  AlwaysAdd := (SL.IndexOfName('NotUseIfEqual') = -1);
  if not AlwaysAdd then
  begin
    NotUseIfEqual := GetStringFromList(SL, 'NotUseIfEqual', False);
    if (NotUseIfEqual = '') and (SettingType = stBoolean) then
      NotUseIfEqual := '0';
  end;
  if SettingType = stBoolean then
    FalseParam := GetStringFromList(SL, 'FalseParam', False);
  if SettingType = stTrackBar then
  begin
    s := GetStringFromList(SL, 'Frequency', True);
    if s <> '' then
      if not TryStrToFloat(s, Frequency) then
        raise Exception.Create(Format(SBN('WrongParamValue'), ['Frequency ' + s, Name]));
  end;
  Default := GetStringFromList(SL, 'Default', False);
  HasDefault := SL.IndexOfName('Default') <> -1;
  s := GetStringFromList(SL, 'NotUsedInClientMode', False);
  NotUsedInClientMode := (s = '1');
  // Зависимости
  i := 0;
  ItemName := 'DependsOn' + IntToStr(i);
  k := SL.IndexOfName(ItemName);
  while (k <> -1) do
  begin
    if not Assigned(DependBlocks) then
      DependBlocks := TObjectList.Create;
    UDLDependBlock := TUDLDependBlock.Create;
    DependBlocks.Add(UDLDependBlock);
    UDLDependBlock.DependsOn := GetStringFromList(SL, ItemName, True);
    ValueName := 'DependCondition' + IntToStr(i);
    s := GetStringFromList(SL, ValueName, True);
    if AnsiSameText(s, 'Equal') then
      UDLDependBlock.DependCondition := dcEqual
    else
    if AnsiSameText(s, 'NotEqual') then
      UDLDependBlock.DependCondition := dcNotEqual
    else
    if AnsiSameText(s, 'Higher') then
      UDLDependBlock.DependCondition := dcHigher
    else
    if AnsiSameText(s, 'EqualOrHigher') then
      UDLDependBlock.DependCondition := dcEqualOrHigher
    else
    if AnsiSameText(s, 'Lower') then
      UDLDependBlock.DependCondition := dcLower
    else
    if AnsiSameText(s, 'EqualOrLower') then
      UDLDependBlock.DependCondition := dcEqualOrLower
    else
      raise Exception.Create(Format(SBN('WrongParamValue'), [ValueName + ' ' + s, Name]));
    UDLDependBlock.DependValue := GetStringFromList(SL, 'DependValue' + IntToStr(i), False);
    Inc(i);
    ItemName := 'DependsOn' + IntToStr(i);
    k := SL.IndexOfName(ItemName);
  end;
  s := GetStringFromList(SL, 'DependMode', False);
  if AnsiSameText(s, 'AND') then
    DependMode := dmAND
  else
    DependMode := dmOR;
  s := GetStringFromList(SL, 'IWADNames', False);
  IWADNames.DelimitedText := s;
end;

procedure TUDLSetting.RegisterResources;
var
  s: string;
  i: Integer;
begin
  s := 'Setting_' + Name + '_Name';
  LanguagePacksManager.AddResourceString(s, SettingName);
  s := 'Setting_' + Name + '_Desc';
  LanguagePacksManager.AddResourceString(s, SettingDescription);
  if SettingType = stBitFlags then
    for i := 0 to BitFlags.Count - 1 do
    begin
      s := 'Setting_' + Name + '_Flag_' + IntToStr(i);
      LanguagePacksManager.AddResourceString(s, BitFlags[i]);
    end;
  if SettingType = stList then
    for i := 0 to ListItems.Count - 1 do
    begin
      s := 'Setting_' + Name + '_Item_' + IntToStr(i);
      LanguagePacksManager.AddResourceString(s, ListItems[i]);
    end;
end;

function TUDLSetting.TranslatedBitFlag(const Index: Integer): string;
begin
  Result := SBN('Setting_' + Name + '_Flag_' + IntToStr(Index));
end;

function TUDLSetting.TranslatedDescription: string;
begin
  Result := SBN('Setting_' + Name + '_Desc');
end;

function TUDLSetting.TranslatedListItem(const Index: Integer): string;
begin
  Result := SBN('Setting_' + Name + '_Item_' + IntToStr(Index));
end;

function TUDLSetting.TranslatedName: string;
begin
  Result := SBN('Setting_' + Name + '_Name');
end;

constructor TUDLSettingsList.Create;
begin
  inherited Create;
  FList := TObjectList.Create(True);
end;

destructor TUDLSettingsList.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TUDLSettingsList.Count: Integer;
begin
  Result := FList.Count;
end;

function TUDLSettingsList.GetSetting(const Index: Integer): TUDLSetting;
begin
  Result := TUDLSetting(FList.Items[Index]);
end;

procedure TUDLSettingsList.LoadFrom(const ConfigFile: string);

    function FindNextSection(const SL: TStringList; Index: Integer): Integer;
    var
      s: string;
    begin
      Result := -1;
      while Index < SL.Count do
      begin
        s := Trim(SL[Index]);
        if (Length(s) >= 2) and (s[1] = '<') and (s[Length(s)] = '>') then
        begin
          Result := Index;
          Break;
        end;
        Inc(Index);
      end;
    end;

    function FindSectionEnd(const SL: TStringList; Index: Integer; const Section: string): Integer;
    begin
      Result := -1;
      while Index < SL.Count do
      begin
        if AnsiSameText(Trim(SL[Index]), '</' + Section + '>') then
        begin
          Result := Index;
          Break;
        end;
        Inc(Index);
      end;
      if Result = -1 then
        raise Exception.Create(Format(SBN('NoEndOfSection'), [Section]));
    end;

  var
    SL: TStringList;
    Index, IndexEnd: Integer;
    s: string;
    UDLSetting: TUDLSetting;
    SectionL: TStringList;
    i: Integer;

begin
  try
    SL := TStringList.Create;
    try
      SL.LoadFromFile(ConfigFile, TEncoding.UTF8);
      Index := FindNextSection(SL, 0);
      while (Index >= 0) do
      begin
        s := Trim(SL[Index]);
        s := Copy(s, 2, Length(s) - 2);
        IndexEnd := FindSectionEnd(SL, Index, s);
        UDLSetting := TUDLSetting.Create(s);
        FList.Add(UDLSetting);
        SectionL := TStringList.Create;
        try
          for i := Index + 1 to IndexEnd - 1 do
            SectionL.Add(SL[i]);
          try
            UDLSetting.LoadFrom(SectionL);
          except
            on E: Exception do
              MessageBox(Application.Handle, PChar(SBN('ProcessFileError') + ' ' + ConfigFile +
                #13#10 + E.Message), PChar(SBN('Error')), MB_OK + MB_ICONEXCLAMATION);
          end;
        finally
          SectionL.Free;
        end;
        Index := FindNextSection(SL, IndexEnd + 1);
      end;
    finally
      SL.Free;
    end;
    UpdateRefs;
    RegisterResources;
  except
    on E: Exception do
      MessageBox(Application.Handle, PChar(SBN('ProcessFileError') + ' ' + ConfigFile +
        #13#10 + E.Message), PChar(SBN('Error')), MB_OK + MB_ICONEXCLAMATION);
  end;
end;

procedure TUDLSettingsList.RegisterResources;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    Setting[i].RegisterResources;
end;

function TUDLSettingsList.SettingByName(const SettingName: string): TUDLSetting;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
    if AnsiSameText(TUDLSetting(FList[i]).Name, SettingName) then
    begin
      Result := TUDLSetting(FList[i]);
      Break;
    end;
end;

procedure TUDLSettingsList.UpdateRefs;
var
  i, j: Integer;
  UDLSetting: TUDLSetting;
  DependBlock: TUDLDependBlock;
  DependSetting: TUDLSetting;
begin
  for i := 0 to FList.Count - 1 do
  begin
    UDLSetting := TUDLSetting(FList[i]);
    if Assigned(UDLSetting.DependBlocks) then
      for j := 0 to UDLSetting.DependBlocks.Count - 1 do
      begin
        DependBlock := TUDLDependBlock(UDLSetting.DependBlocks[j]);
        if DependBlock.DependsOn <> '' then
        begin
          DependSetting := SettingByName(DependBlock.DependsOn);
          if not Assigned(DependSetting) then
            raise Exception.Create(Format(SBN('DependParamNotExists'), [DependBlock.DependsOn, UDLSetting.Name]));
          DependBlock.DependSetting := DependSetting;
        end;
      end;
  end;
end;

{ TUDLDependBlock }

constructor TUDLDependBlock.Create;
begin
  inherited Create;
  DependSetting := nil;
end;

end.
