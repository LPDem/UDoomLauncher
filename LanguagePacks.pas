unit LanguagePacks;

interface

uses
  Windows, Classes, Contnrs, Forms, StdCtrls, ExtCtrls, SysUtils;

type
  TLanguagePack = record
    Locale: Integer;
    Name: string;
    FileName: string;
  end;

  TLanguagePacksManager = class(TObject)
  private
    FResourceStrings: TStringList;
    function GetLanguagePack(Index: Integer): TLanguagePack;
  protected
    FActiveLocale: Integer;
    FActiveName: string;
    FActivePackText: string;
    FDefaultLocale: Integer;
    FDefaultName: string;
    FDefaultPackText: string;
    FForms: array of TFormClass;
    FLanguagePacks: array of TLanguagePack;
    function FormByClass(const FormClass: TFormClass): TForm;
    function GenerateLangPack(const Form: TForm): string; overload;
    procedure GenerateLangPackForComponent(const Component: TComponent; var SL: TStringList; AddString: string = '');
    procedure GenerateLangPackForFrame(const Frame: TFrame; var SL: TStringList);
    function GenerateLangPackForResources: string;
    procedure LoadResources(const PackText: string; const Allways: Boolean = False);
    function OnSearchEvent(const SearchRec: TSearchRec; const FullName: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddResourceString(const Name, Value: string);
    procedure ApplyToAllForms;
    procedure ApplyToForm(const Form: TForm; const Allways: Boolean = False);
    procedure EnumLanguagePacks;
    function GenerateLangPack: string; overload;
    function LanguagePacksCount: Integer;
    function PackIndexByLocale(const Locale: Integer): Integer;
    procedure RegisterForm(const FormClass: TFormClass);
    procedure SetActiveLanguagePack(var Locale: Integer; const Allways: Boolean = False);
    procedure SetDefaultLanguagePack(const Locale: Integer; Name: string; const PackText: string);
    function StringByName(const Name: string): string;
    property LanguagePack[Index: Integer]: TLanguagePack read GetLanguagePack;
  end;

function LanguagePacksManager: TLanguagePacksManager;

implementation

uses
  TypInfo, UFileSearch, IniFiles, StrUtils;

var
  FLanguagePacksManager: TLanguagePacksManager = nil;

function LanguagePacksManager: TLanguagePacksManager;
begin
  if not Assigned(FLanguagePacksManager) then
    FLanguagePacksManager := TLanguagePacksManager.Create;
  Result := FLanguagePacksManager;
end;

{ TLanguagePacksManager }

constructor TLanguagePacksManager.Create;
begin
  inherited Create;
  FResourceStrings := TStringList.Create;
end;

destructor TLanguagePacksManager.Destroy;
begin
  FResourceStrings.Free;
  inherited Destroy;
end;

procedure TLanguagePacksManager.AddResourceString(const Name, Value: string);
begin
  if FResourceStrings.IndexOfName(Name) = -1 then
    FResourceStrings.Add(Name + '=' + Value)
  else
    FResourceStrings.Values[Name] := Value;
end;

procedure TLanguagePacksManager.ApplyToAllForms;
var
  i: Integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    ApplyToForm(Screen.Forms[i], True);
end;

procedure TLanguagePacksManager.ApplyToForm(const Form: TForm; const Allways: Boolean = False);
var
  StartPos, EndPos: Integer;
  s: string;
  SL, SL2: TStringList;
  i, j, k: Integer;
  Obj: TObject;
  Items: TStrings;
begin
  if (FActiveLocale = FDefaultLocale) and not Allways then
    Exit;
  s := '[' + Form.ClassName + ']';
  StartPos := Pos(s, FActivePackText);
  if StartPos = 0 then
    Exit;
  StartPos := StartPos + Length(s);
  EndPos := PosEx(#13#10 + '[', FActivePackText, StartPos);
  if EndPos = 0 then
    EndPos := Length(FActivePackText);

  SL := TStringList.Create;
  SL2 := TStringList.Create;
  SL2.Delimiter := '.';
  try
    SL.Text := Copy(FActivePackText, StartPos, EndPos - StartPos + 1);
    for i := 0 to SL.Count - 1 do
    begin
      SL2.DelimitedText := SL.Names[i];
      Obj := Form;
      for j := 0 to SL2.Count - 1 do
      begin
        if j = SL2.Count - 1 then
        begin
          if not AnsiSameText(SL2[j], 'Items') then
            SetStrProp(Obj, SL2[j], Trim(SL.Values[SL.Names[i]]))
          else
          begin
            if Obj is TComboBox then
            begin
              Items := GetObjectProp(Obj, SL2[j]) as TStrings;
              k := TComboBox(Obj).ItemIndex;
              Items.Text := AnsiReplaceText(Trim(SL.Values[SL.Names[i]]), '|', #13#10);
              TComboBox(Obj).ItemIndex := k;
            end;
          end;
        end
        else
        if j = 0 then
          Obj := Form.FindComponent(SL2[j])
        else
        if Obj is TFrame then
          Obj := (Obj as TFrame).FindComponent(SL2[j])
        else
          Obj := GetObjectProp(Obj, SL2[j]);
      end;
    end;
  finally
    SL.Free;
    SL2.Free;
  end;
end;

procedure TLanguagePacksManager.EnumLanguagePacks;
var
  FSearch: TFileSearch;
  k: Integer;
begin
  SetLength(FLanguagePacks, 0);
  if FDefaultName <> '' then
  begin
    k := Length(FLanguagePacks);
    SetLength(FLanguagePacks, k + 1);
    FLanguagePacks[k].Locale := FDefaultLocale;
    FLanguagePacks[k].Name := FDefaultName;
    FLanguagePacks[k].FileName := '';
  end;
  FSearch := TFileSearch.Create;
  try
   FSearch.Folder := ExtractFilePath(ParamStr(0));
   FSearch.Mask := '*.lng';
   FSearch.Recursive := False;
   FSearch.OnSearch := OnSearchEvent;
   FSearch.SearchAll;
  finally
    FSearch.Free;
  end;
end;

function TLanguagePacksManager.FormByClass(const FormClass: TFormClass): TForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = FormClass then
    begin
      Result := Screen.Forms[i];
      Break;
    end;
end;

function TLanguagePacksManager.GenerateLangPack: string;
var
  i: Integer;
  Form: TForm;
begin
  Result := '[LanguagePack]' + #13#10 + #13#10 +
    'Locale = ' + IntToStr(FActiveLocale) + #13#10 +
    'Name = ' + FActiveName + #13#10 + #13#10;
  for i := 0 to Length(FForms) - 1 do
  begin
    Form := FormByClass(FForms[i]);
    if Assigned(Form) then
      Result := Result + GenerateLangPack(Form) + #13#10
    else
    begin
      Form := FForms[i].Create(Application);
      try
        Result := Result + GenerateLangPack(Form) + #13#10;
      finally
        Form.Free;
      end;
    end;
  end;
  Result := Result + '[Resources]' + #13#10 + #13#10 + GenerateLangPackForResources;
end;

function TLanguagePacksManager.GenerateLangPack(const Form: TForm): string;
var
  SL: TStringList;
  i: Integer;
  Component: TComponent;
begin
  SL := TStringList.Create;
  SL.Add('[' + Form.ClassName + ']');
  SL.Add('');
  try
    if Form.Caption <> '' then
      SL.Add('Caption = ' + Form.Caption);
    if Form.Hint <> '' then
      SL.Add('Hint = ' + Form.Hint);
    for i := 0 to Form.ComponentCount - 1 do
    begin
      Component := Form.Components[i];
      if IsPublishedProp(Component, 'Action') and Assigned(GetObjectProp(Component, 'Action')) then
        Continue;
      if Component.Tag = 666 then
        Continue;
      GenerateLangPackForComponent(Component, SL);
    end;
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure TLanguagePacksManager.GenerateLangPackForComponent(const Component: TComponent; var SL: TStringList; AddString: string = '');
var
  s: string;
  Lbl: TObject;
  Items: TStrings;
begin
  if IsPublishedProp(Component, 'Caption') then
  begin
    s := GetStrProp(Component, 'Caption');
    if s <> '' then
      SL.Add(AddString + Component.Name + '.Caption = ' + s);
  end;
  if IsPublishedProp(Component, 'Text') then
  begin
    s := GetStrProp(Component, 'Text');
    if s <> '' then
      SL.Add(AddString + Component.Name + '.Text = ' + s);
  end;
  if IsPublishedProp(Component, 'Hint') then
  begin
    s := GetStrProp(Component, 'Hint');
    if s <> '' then
      SL.Add(AddString + Component.Name + '.Hint = ' + s);
  end;
  if IsPublishedProp(Component, 'Filter') then
  begin
    s := GetStrProp(Component, 'Filter');
    if s <> '' then
      SL.Add(AddString + Component.Name + '.Filter = ' + s);
  end;
  if IsPublishedProp(Component, 'Items') and (Component is TComboBox) then
  begin
    Items := GetObjectProp(Component, 'Items') as TStrings;
    if Assigned(Items) then
    begin
      s := Items.Text;
      if s <> '' then
      begin
        s := AnsiReplaceText(s, #13#10, '|');
        SL.Add(AddString + Component.Name + '.Items = ' + s);
      end;
    end;
  end;

  if Component is TLabeledEdit then
  begin
    Lbl := GetObjectProp(Component, 'EditLabel');
    if IsPublishedProp(Lbl, 'Caption') then
    begin
      s := GetStrProp(Lbl, 'Caption');
      if s <> '' then
        SL.Add(AddString + Component.Name + '.EditLabel.Caption = ' + s);
    end;
  end;

  if Component is TFrame then
    GenerateLangPackForFrame(Component as TFrame, SL);
end;

procedure TLanguagePacksManager.GenerateLangPackForFrame(const Frame: TFrame; var SL: TStringList);
var
  i: Integer;
  Component: TComponent;
begin
  for i := 0 to Frame.ComponentCount - 1 do
  begin
    Component := Frame.Components[i];
    if IsPublishedProp(Component, 'Action') and Assigned(GetObjectProp(Component, 'Action')) then
      Continue;
    if Component.Tag = 666 then
      Continue;
    GenerateLangPackForComponent(Component, SL, Frame.Name + '.');
  end;
end;

function TLanguagePacksManager.GenerateLangPackForResources: string;
begin
  Result := FResourceStrings.Text;
end;

function TLanguagePacksManager.GetLanguagePack(Index: Integer): TLanguagePack;
begin
  Result := FLanguagePacks[Index];
end;

function TLanguagePacksManager.LanguagePacksCount: Integer;
begin
  Result := Length(FLanguagePacks);
end;

procedure TLanguagePacksManager.LoadResources(const PackText: string; const Allways: Boolean = False);
var
  StartPos, EndPos: Integer;
  s: string;
  SL: TStringList;
  i: Integer;
begin
  if (FActiveLocale = FDefaultLocale) and not Allways then
    Exit;
  s := '[Resources]';
  StartPos := Pos(s, PackText);
  if StartPos = 0 then
    Exit;
  StartPos := StartPos + Length(s);
  EndPos := PosEx(#13#10 + '[', PackText, StartPos);
  if EndPos = 0 then
    EndPos := Length(PackText);
  s := Copy(PackText, StartPos, EndPos - StartPos + 1);
  SL := TStringList.Create;
  try
    SL.Text := s;
    for i := 0 to SL.Count - 1 do
    begin
      if Trim(SL[i]) = '' then
        Continue;
      FResourceStrings.Values[SL.Names[i]] := SL.ValueFromIndex[i]; 
    end;
  finally
    SL.Free;
  end;
end;

function TLanguagePacksManager.OnSearchEvent(const SearchRec: TSearchRec; const FullName: string): Boolean;
var
  k: Integer;
  IniFile: TMemIniFile;
begin
  Result := False;
  k := Length(FLanguagePacks);
  SetLength(FLanguagePacks, k + 1);
  FLanguagePacks[k].FileName := FullName;
  IniFile := TMemIniFile.Create(FullName);
  try
    FLanguagePacks[k].Locale := IniFile.ReadInteger('LanguagePack', 'Locale', GetThreadLocale);
    FLanguagePacks[k].Name := IniFile.ReadString('LanguagePack', 'Name', 'Unknown');
  finally
    IniFile.Free;
  end;
end;

function TLanguagePacksManager.PackIndexByLocale(const Locale: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(FLanguagePacks) - 1 do
    if FLanguagePacks[i].Locale = Locale then
    begin
      Result := i;
      Break;
    end;
end;

procedure TLanguagePacksManager.RegisterForm(const FormClass: TFormClass);
begin
  SetLength(FForms, Length(FForms) + 1);
  FForms[Length(FForms) - 1] := FormClass;
end;

procedure TLanguagePacksManager.SetActiveLanguagePack(var Locale: Integer; const Allways: Boolean = False);
var
  k: Integer;
  s: string;
  Stream: TFileStream;
begin
  k := PackIndexByLocale(Locale);
  if k = -1 then
  begin
    if GetThreadLocale <> 1049 then
      Locale := 1033 // ENG
    else
      Locale := 1049; // RUS
    k := PackIndexByLocale(Locale);
    if k = -1 then
    begin
      Locale := 1049; //RUS
      k := PackIndexByLocale(Locale);
    end;
  end;
  FActiveLocale := Locale;
  FActiveName := FLanguagePacks[k].Name;
  if FLanguagePacks[k].FileName = '' then
    FActivePackText := FDefaultPackText
  else
  begin
    Stream := TFileStream.Create(FLanguagePacks[k].FileName, fmOpenRead + fmShareDenyNone);
    try
      SetLength(s, Stream.Size);
      Stream.ReadBuffer(s[1], Stream.Size);
    finally
      Stream.Free;
    end;
    FActivePackText := s;
  end;
  LoadResources(FActivePackText, Allways);
end;

procedure TLanguagePacksManager.SetDefaultLanguagePack(const Locale: Integer; Name: string; const PackText: string);
begin
  FDefaultLocale := Locale;
  FDefaultName := Name;
  FDefaultPackText := PackText;
end;

function TLanguagePacksManager.StringByName(const Name: string): string;
begin
  Result := FResourceStrings.Values[Name];
end;

initialization;

finalization
  if Assigned(FLanguagePacksManager) then
    FLanguagePacksManager.Free;

end.
