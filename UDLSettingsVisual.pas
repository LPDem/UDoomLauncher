unit UDLSettingsVisual;

interface

uses
  Windows, Classes, Controls, ExtCtrls, UDLSettings, StdCtrls, Contnrs, ComCtrls,
  UDLSettingsValues, UDLPorts, NumericEdit, EditWithButton;

const
  LeftMargin = 150;
  LabelSpace = 3;

type
  TUDLVisualList = class;

  TUDLSettingVisual = class abstract(TCustomPanel)
  private
    FButton: TButton;
    FDoomPortType: TDoomPortType;
    FGameMode: Integer;
    FIWAD: string;
    FUDLVisualList: TUDLVisualList;
  protected
    FRightMargin: Integer;
    FUDLSetting: TUDLSetting;
    procedure AdjustHeight;
    procedure CreateEditor; virtual;
    procedure FreeEditor; virtual; abstract;
    function GetValue: Variant; virtual; abstract;
    procedure OnChange(Sender: TObject);
    procedure OnDefaultButtonClick(Sender: TObject);
    procedure SetDefault;
    procedure SetUDLSetting(const Value: TUDLSetting);
    procedure SetValue(const Value: Variant); virtual; abstract;
    procedure UpdateEnable;
    procedure UpdateVisible;
    procedure ValueChanged;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetDoomPortType(const DoomPortType: TDoomPortType);
    procedure SetGameMode(const GameMode: Integer);
    procedure SetIWAD(const IWAD: string);
    procedure UpdateCaptions; virtual;
    property UDLSetting: TUDLSetting read FUDLSetting write SetUDLSetting;
    property UDLVisualList: TUDLVisualList read FUDLVisualList write FUDLVisualList;
    property Value: Variant read GetValue write SetValue;
  end;

  TUDLStringVisual = class(TUDLSettingVisual)
  private
    FEdit: TLabeledEdit;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLIntegerVisual = class(TUDLSettingVisual)
  private
    FEdit: TNumericEdit;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLBooleanVisual = class(TUDLSettingVisual)
  private
    FEdit: TCheckBox;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLFloatVisual = class(TUDLSettingVisual)
  private
    FEdit: TNumericEdit;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLTrackBarVisual = class(TUDLSettingVisual)
  private
    FEdit: TNumericEdit;
    FLabel: TLabel;
    FTrack: TTrackBar;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure OnEditChange(Sender: TObject);
    procedure OnTrackChange(Sender: TObject);
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLFileNameVisual = class(TUDLSettingVisual)
  private
    FEdit: TEditWithButton;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure OnButtonClick(Sender: TObject);
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLBitFlagsVisual = class(TUDLSettingVisual)
  private
    FEdit: TNumericEdit;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure OnButtonClick(Sender: TObject);
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLListVisual = class(TUDLSettingVisual)
  private
    FEdit: TComboBox;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLFolderNameVisual = class(TUDLSettingVisual)
  private
    FEdit: TEditWithButton;
    FLabel: TLabel;
  protected
    procedure CreateEditor; override;
    procedure FreeEditor; override;
    function GetValue: Variant; override;
    procedure OnButtonClick(Sender: TObject);
    function SelectFolder(const Caption: string; const Root: WideString; var Directory: string): Boolean;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetValue(const Value: Variant); override;
  public
    procedure UpdateCaptions; override;
  end;

  TUDLVisualList = class(TObject)
  private
    FButton: TButton;
    FList: TObjectList;
    FParent: TWinControl;
    FPnl_Default: TPanel;
    procedure SetParent(const Value: TWinControl);
  protected
    procedure CreateDefaultPanel;
    procedure OnDefaultButtonClick(Sender: TObject);
    procedure RealignVisuals;
    procedure SetDefault;
    procedure UpdateEnable;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateFromSettingsList(const SettingsList: TUDLSettingsList);
    procedure LoadFromValuesList(const ValuesList: TUDLValuesList);
    procedure SaveToValuesList(const ValuesList: TUDLValuesList);
    procedure SetDoomPortType(const DoomPortType: TDoomPortType);
    procedure SetGameMode(const GameMode: Integer);
    procedure SetIWAD(const IWAD: string);
    procedure UpdateCaptions;
    function VisualBySetting(const FUDLSetting: TUDLSetting): TUDLSettingVisual;
    property Parent: TWinControl read FParent write SetParent;
  end;


implementation

uses
  SysUtils, UDLBitFlagsEditor, Math, Dialogs, ShlObj, ActiveX, Forms, Variants, uResources;

function SelectDirCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  Result := 0;
end;

constructor TUDLSettingVisual.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alTop;
  Width := 200;
  FRightMargin := Width;
end;

procedure TUDLSettingVisual.AdjustHeight;
begin
  FButton.Left := Width - FButton.Width - 1;
  FButton.Height := Min(23, Height - 1);
end;

procedure TUDLSettingVisual.CreateEditor;
begin
  FButton := TButton.Create(Self);
  FButton.Width := 24;
  FButton.Caption := 'C';
  FButton.Anchors := [akTop, akRight];
  FButton.Top := 0;
  FButton.Left := Width - FButton.Width - 1;
  FButton.TabStop := False;
  FButton.OnClick := OnDefaultButtonClick;
  FButton.Parent := Self;
  FRightMargin := FButton.Left;
end;

procedure TUDLSettingVisual.OnChange(Sender: TObject);
begin
  ValueChanged;
end;

procedure TUDLSettingVisual.OnDefaultButtonClick(Sender: TObject);
begin
  SetDefault;
end;

procedure TUDLSettingVisual.SetDefault;
begin
  if FUDLSetting.HasDefault then
    Value := FUDLSetting.Default;
end;

procedure TUDLSettingVisual.SetDoomPortType(const DoomPortType: TDoomPortType);
begin
  FDoomPortType := DoomPortType;
  UpdateVisible;
end;

procedure TUDLSettingVisual.SetGameMode(const GameMode: Integer);
begin
  FGameMode := GameMode;
  UpdateVisible;
end;

procedure TUDLSettingVisual.SetIWAD(const IWAD: string);
begin
  FIWAD := IWAD;
  UpdateVisible;
end;

procedure TUDLSettingVisual.SetUDLSetting(const Value: TUDLSetting);
begin
  FUDLSetting := Value;
  FreeEditor;
  CreateEditor;
  Name := 'Setting_' + Value.Name;
  Caption := '';
end;

procedure TUDLSettingVisual.UpdateCaptions;
begin
  FButton.Hint := SBN('SetDefaultValue');
  Hint := FUDLSetting.TranslatedDescription;
end;

procedure TUDLSettingVisual.UpdateEnable;
var
  DependValue: string;
  F: Boolean;
  V: Variant;
  i: Integer;
  OldEnabled: Boolean;
  DependBlock: TUDLDependBlock;
  Vis: TUDLSettingVisual;
begin
  F := True;
  if Assigned(FUDLSetting.DependBlocks) then
  begin
    F := (FUDLSetting.DependMode = dmAND);
    for i := 0 to FUDLSetting.DependBlocks.Count - 1 do
    begin
      DependBlock := TUDLDependBlock(FUDLSetting.DependBlocks[i]);
      DependValue := DependBlock.DependValue;
      Vis := FUDLVisualList.VisualBySetting(DependBlock.DependSetting);
      if not Vis.Visible then
        Continue;
      V := Vis.Value;
      case DependBlock.DependCondition of
        dcEqual: F := (V = DependValue);
        dcNotEqual: F := (V <> DependValue);
        dcHigher: F := (V > DependValue);
        dcEqualOrHigher: F := (V >= DependValue);
        dcLower: F := (V < DependValue);
        dcEqualOrLower: F := (V <= DependValue);
      end;
      if (F and (FUDLSetting.DependMode = dmOR)) or (not F and (FUDLSetting.DependMode = dmAND)) then
        Break;
    end;
  end;
  OldEnabled := Enabled;
  Enabled := F;
  if OldEnabled <> F then
    for i := 0 to ControlCount - 1 do
      Controls[i].Enabled := F;
  FButton.Enabled := Enabled and FUDLSetting.HasDefault and (Value <> FUDLSetting.Default);
end;

procedure TUDLSettingVisual.UpdateVisible;
var
  F: Boolean;
begin
  F := (FDoomPortType in FUDLSetting.Port) and not (FUDLSetting.NotUsedInClientMode and (FGameMode = 1));
  F := F and ((FUDLSetting.IWADNames.Count = 0) or (FUDLSetting.IWADNames.IndexOf(FIWAD) >= 0));
  if Visible <> F then
  begin
    Visible := F;
    FUDLVisualList.UpdateEnable;
  end;
end;

procedure TUDLSettingVisual.ValueChanged;
begin
  FUDLVisualList.UpdateEnable;
end;

procedure TUDLStringVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TLabeledEdit.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.LabelPosition := lpLeft;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
end;

procedure TUDLStringVisual.FreeEditor;
begin
  FEdit.Free;
end;

function TUDLStringVisual.GetValue: Variant;
begin
  Result := FEdit.Text;
end;

procedure TUDLStringVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLStringVisual.SetValue(const Value: Variant);
begin
  FEdit.Text := Value;
end;

procedure TUDLStringVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FEdit.EditLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLIntegerVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TNumericEdit.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.Format := '0';
  FEdit.MinValue := FUDLSetting.MinValue;
  if FUDLSetting.MaxValue = 0 then
    FEdit.MaxValue := MaxInt
  else
    FEdit.MaxValue := FUDLSetting.MaxValue;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLIntegerVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLIntegerVisual.GetValue: Variant;
begin
  if not VarIsNull(FEdit.Value) then
    Result := Round(FEdit.Value)
  else
    Result := 0;
end;

procedure TUDLIntegerVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLIntegerVisual.SetValue(const Value: Variant);
begin
  FEdit.Value := Value;
end;

procedure TUDLIntegerVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLBooleanVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TCheckBox.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.OnClick := OnChange;
  FEdit.Parent := Self;
end;

procedure TUDLBooleanVisual.FreeEditor;
begin
  FEdit.Free;
end;

function TUDLBooleanVisual.GetValue: Variant;
begin
  Result := FEdit.Checked;
end;

procedure TUDLBooleanVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLBooleanVisual.SetValue(const Value: Variant);
begin
  FEdit.Checked := Value;
end;

procedure TUDLBooleanVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FEdit.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLFloatVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TNumericEdit.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.Format := '';
  FEdit.MinValue := FUDLSetting.MinValue;
  if FUDLSetting.MaxValue = 0 then
    FEdit.MaxValue := MaxInt
  else
    FEdit.MaxValue := FUDLSetting.MaxValue;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLFloatVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLFloatVisual.GetValue: Variant;
begin
  Result := FEdit.Value;
end;

procedure TUDLFloatVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLFloatVisual.SetValue(const Value: Variant);
begin
  FEdit.Value := Value;
end;

procedure TUDLFloatVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLTrackBarVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TNumericEdit.Create(Self);
  FEdit.Top := 3;
  FEdit.Left := LeftMargin;
  FEdit.Width := 100;
  FEdit.Anchors := [akLeft, akTop];
  FEdit.Format := '';
  FEdit.MinValue := Round(FUDLSetting.MinValue);
  FEdit.MaxValue := Round(FUDLSetting.MaxValue);
  FEdit.OnChange := OnEditChange;
  FEdit.Parent := Self;
  FTrack := TTrackBar.Create(Self);
  FTrack.Top := 1;
  FTrack.Left := FEdit.Left + FEdit.Width + 1;
  FTrack.Width := FRightMargin - FTrack.Left - 1;
  FTrack.Height := 30;
  FTrack.Anchors := [akLeft, akRight, akTop];
  FTrack.Min := 0;
  FTrack.Max := Round((FUDLSetting.MaxValue - FUDLSetting.MinValue) / FUDLSetting.Frequency);
  FTrack.OnChange := OnTrackChange;
  FTrack.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FTrack.Top + 5;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLTrackBarVisual.FreeEditor;
begin
  FEdit.Free;
  FTrack.Free;
  FLabel.Free;
end;

function TUDLTrackBarVisual.GetValue: Variant;
begin
  Result := FEdit.Value;
end;

procedure TUDLTrackBarVisual.OnEditChange(Sender: TObject);
var
  V: Real;
begin
  FTrack.OnChange := nil;
  if not VarISNull(FEdit.Value) then
    V := FEdit.Value
  else
    V := 0;
  FTrack.Position := Round((V - FUDLSetting.MinValue) / FUDLSetting.Frequency);
  FTrack.OnChange := OnTrackChange;
  OnChange(Sender);
end;

procedure TUDLTrackBarVisual.OnTrackChange(Sender: TObject);
begin
  FEdit.Value := FTrack.Position * FUDLSetting.Frequency + FUDLSetting.MinValue;
end;

procedure TUDLTrackBarVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FTrack.HandleNeeded;
  Height := FTrack.Top + FTrack.Height + 1;
  AdjustHeight;
end;

procedure TUDLTrackBarVisual.SetValue(const Value: Variant);
begin
  FEdit.Value := Value;
end;

procedure TUDLTrackBarVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLFileNameVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TEditWithButton.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.OnButtonClick := OnButtonClick;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLFileNameVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLFileNameVisual.GetValue: Variant;
begin
  Result := FEdit.Text;
end;

procedure TUDLFileNameVisual.OnButtonClick(Sender: TObject);
var
  D: TOpenDialog;
begin
  D := TOpenDialog.Create(Self);
  try
    D.FileName := FEdit.Text;
    D.Options := D.Options + [ofFileMustExist];
    D.Filter := SBN('FilePropFilter');
    D.FilterIndex := 1;
    if D.Execute then
      FEdit.Text := D.FileName;
  finally
    D.Free;
  end;
end;

procedure TUDLFileNameVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLFileNameVisual.SetValue(const Value: Variant);
begin
  FEdit.Text := Value;
end;

procedure TUDLFileNameVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLBitFlagsVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TNumericEdit.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.Format := '0';
  FEdit.OnButtonClick := OnButtonClick;
  FEdit.ButtonVisible := True;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLBitFlagsVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLBitFlagsVisual.GetValue: Variant;
begin
  if not VarIsNull(FEdit.Value) then
    Result := Round(FEdit.Value)
  else
    Result := 0;
end;

procedure TUDLBitFlagsVisual.OnButtonClick(Sender: TObject);
var
  ABitFlags: Integer;
begin
  ABitFlags := Round(FEdit.Value);
  if TfmUDLBitFlagsEditor.EditBitFlags(FUDLSetting, ABitFlags) then
    FEdit.Value := ABitFlags;
end;

procedure TUDLBitFlagsVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLBitFlagsVisual.SetValue(const Value: Variant);
begin
  FEdit.Value := Value;
end;

procedure TUDLBitFlagsVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
end;

procedure TUDLListVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TComboBox.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  //FEdit.Height := 30;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.Style := csDropDownList;
  FEdit.OnSelect := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLListVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLListVisual.GetValue: Variant;
var
  k: Integer;
begin
  k := FEdit.ItemIndex;
  if k <> -1 then
    Result := FUDLSetting.ListValues[k]
  else
    Result := '';
end;

procedure TUDLListVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
  begin
    FEdit.HandleNeeded;
    UpdateCaptions;
  end;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLListVisual.SetValue(const Value: Variant);
var
  k: Integer;
begin
  k := FUDLSetting.ListValues.IndexOf(Value);
  FEdit.ItemIndex := k;
  OnChange(FEdit);
end;

procedure TUDLListVisual.UpdateCaptions;
var
  i, k: Integer;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;
  if Assigned(Parent) then
  begin
    k := FEdit.ItemIndex;
    FEdit.Items.Clear;
    for i := 0 to FUDLSetting.ListItems.Count - 1 do
      FEdit.Items.Add(FUDLSetting.TranslatedListItem(i));
    FEdit.DropDownCount := Min(FEdit.Items.Count, 14);
    FEdit.ItemIndex := k;
  end;
end;

procedure TUDLFolderNameVisual.CreateEditor;
begin
  inherited CreateEditor;
  FEdit := TEditWithButton.Create(Self);
  FEdit.Top := 1;
  FEdit.Left := LeftMargin;
  FEdit.Width := FRightMargin - FEdit.Left - 1;
  FEdit.Anchors := [akLeft, akRight, akTop];
  FEdit.OnButtonClick := OnButtonClick;
  FEdit.OnChange := OnChange;
  FEdit.Parent := Self;
  FLabel := TLabel.Create(Self);
  FLabel.Top := FEdit.Top + 3;
  FLabel.Left := 1;
  FLabel.Width := FEdit.Left - FLabel.Left - LabelSpace;
  FLabel.Alignment := taRightJustify;
  FLabel.Parent := Self;
end;

procedure TUDLFolderNameVisual.FreeEditor;
begin
  FEdit.Free;
  FLabel.Free;
end;

function TUDLFolderNameVisual.GetValue: Variant;
begin
  Result := FEdit.Text;
end;

procedure TUDLFolderNameVisual.OnButtonClick(Sender: TObject);
var
  s: string;
begin
  s := FEdit.Text;
  if SelectFolder(SBN('SelectFolder'), '', s) then
    FEdit.Text := s;
end;

function TUDLFolderNameVisual.SelectFolder(const Caption: string; const Root: WideString; var Directory: string): Boolean;
var
  BrInfo: TBrowseInfo;
  ShellMalloc: IMalloc;
  Buffer: PChar;
  RootItemIDList: PItemIDList;
  IDesktopFolder: IShellFolder;
  Eaten: LongWord;
  Flags: LongWord;
  WindowList: Pointer;
  OldErrorMode: Cardinal;
  IDList: PItemIDList;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrInfo, SizeOf(BrInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrInfo do
      begin
        hwndOwner := Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE or BIF_VALIDATE;
        if Directory <> '' then
        begin
          lpfn := SelectDirCallBack;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        IDList := ShBrowseForFolder(BrInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result := IDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(IDList, Buffer);
        ShellMalloc.Free(IDList);
        Directory := Buffer + '\';
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

procedure TUDLFolderNameVisual.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(Parent) then
    FEdit.HandleNeeded;
  Height := FEdit.Top + FEdit.Height + 2;
  AdjustHeight;
end;

procedure TUDLFolderNameVisual.SetValue(const Value: Variant);
begin
  FEdit.Text := Value;
end;

procedure TUDLFolderNameVisual.UpdateCaptions;
begin
  inherited UpdateCaptions;
  FLabel.Caption := FUDLSetting.TranslatedName;  
end;

constructor TUDLVisualList.Create;
begin
  inherited Create;
  FList := TObjectList.Create(True);
end;

destructor TUDLVisualList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TUDLVisualList.CreateDefaultPanel;
begin
  if not Assigned(FPnl_Default) then
  begin
    FPnl_Default := TPanel.Create(FParent);
    FPnl_Default.Align := alTop;
    FPnl_Default.Height := 22;
    FPnl_Default.Caption := '';
    FButton := TButton.Create(FParent);
    FButton.Width := 100;
    FButton.Height := 20;
    FButton.Top := 1;
    FButton.Left := FPnl_Default.Width - FButton.Width - 1;
    FButton.Anchors := [akTop, akRight];
    FButton.OnClick := OnDefaultButtonClick;
    FButton.Parent := FPnl_Default;
  end;
  FPnl_Default.Parent := FParent;
  UpdateCaptions;
end;

procedure TUDLVisualList.CreateFromSettingsList(const SettingsList: TUDLSettingsList);
var
  i: Integer;
  SVisual: TUDLSettingVisual;
  Setting: TUDLSetting;
begin
  for i := 0 to SettingsList.Count - 1 do
  begin
    Setting := SettingsList.Setting[i];
    case Setting.SettingType of
      stInteger: SVisual := TUDLIntegerVisual.Create(nil);
      stString: SVisual := TUDLStringVisual.Create(nil);
      stBoolean: SVisual := TUDLBooleanVisual.Create(nil);
      stFloat: SVisual := TUDLFloatVisual.Create(nil);
      stTrackBar: SVisual := TUDLTrackBarVisual.Create(nil);
      stFileName: SVisual := TUDLFileNameVisual.Create(nil);
      stBitFlags: SVisual := TUDLBitFlagsVisual.Create(nil);
      stList: SVisual := TUDLListVisual.Create(nil);
      stFolderName: SVisual := TUDLFolderNameVisual.Create(nil);
      else
        raise Exception.Create(SBN('NoEditorForType') + IntToStr(Integer(Setting.SettingType)) + '!');
    end;
    SVisual.UDLSetting := Setting;
    SVisual.UDLVisualList := Self;
    FList.Add(SVisual);
  end;
end;

procedure TUDLVisualList.LoadFromValuesList(const ValuesList: TUDLValuesList);
var
  i: Integer;
  SVisual: TUDLSettingVisual;
  UDLValue: TUDLValue;
begin
  for i := 0 to FList.Count - 1 do
  begin
    SVisual := TUDLSettingVisual(FList[i]);
    UDLValue := ValuesList.ValueBySetting(SVisual.UDLSetting);
    SVisual.Value := UDLValue.Value;
    SVisual.ValueChanged;
  end;
end;

procedure TUDLVisualList.OnDefaultButtonClick(Sender: TObject);
begin
  SetDefault;
end;

procedure TUDLVisualList.RealignVisuals;
var
  i: Integer;
  Y: Integer;
  SVisual: TUDLSettingVisual;
begin
  Y := FPnl_Default.Top + FPnl_Default.Height;
  for i := 0 to FList.Count - 1 do
  begin
    SVisual := TUDLSettingVisual(FList[i]);
    if SVisual.Visible then
    begin
      SVisual.Top := Y;
      Y := Y + SVisual.Height;
    end;
  end;
end;

procedure TUDLVisualList.SaveToValuesList(const ValuesList: TUDLValuesList);
var
  i: Integer;
  SVisual: TUDLSettingVisual;
  UDLValue: TUDLValue;
begin
  for i := 0 to FList.Count - 1 do
  begin
    SVisual := TUDLSettingVisual(FList[i]);
    UDLValue := ValuesList.ValueBySetting(SVisual.UDLSetting);
    UDLValue.Value := SVisual.Value;
  end;
end;

procedure TUDLVisualList.SetDefault;
var
  i: Integer;
begin
  if MessageBox(Application.Handle, PChar(SBN('DefaultConfirmation')),
   PChar(SBN('Question')), MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDNO then
    Exit;
  for i := 0 to FList.Count - 1 do
    TUDLSettingVisual(FList.Items[i]).SetDefault;
end;

procedure TUDLVisualList.SetDoomPortType(const DoomPortType: TDoomPortType);
var
  i: Integer;
begin
  Parent.DisableAlign;
  for i := FList.Count - 1 downto 0 do
    TUDLSettingVisual(FList.Items[i]).SetDoomPortType(DoomPortType);
  RealignVisuals;
  Parent.EnableAlign;
end;

procedure TUDLVisualList.SetGameMode(const GameMode: Integer);
var
  i: Integer;
begin
  Parent.DisableAlign;
  for i := FList.Count - 1 downto 0 do
    TUDLSettingVisual(FList.Items[i]).SetGameMode(GameMode);
  RealignVisuals;
  Parent.EnableAlign;
end;

procedure TUDLVisualList.SetIWAD(const IWAD: string);
var
  i: Integer;
begin
  Parent.DisableAlign;
  for i := FList.Count - 1 downto 0 do
    TUDLSettingVisual(FList.Items[i]).SetIWAD(IWAD);
  RealignVisuals;
  Parent.EnableAlign;
end;

procedure TUDLVisualList.SetParent(const Value: TWinControl);
var
  i: Integer;
begin
  FParent := Value;
  CreateDefaultPanel;
  for i := 0 to FList.Count - 1 do
    TUDLSettingVisual(FList.Items[i]).Parent := Value;
  RealignVisuals;
end;

procedure TUDLVisualList.UpdateCaptions;
var
  i: Integer;
begin
  FButton.Caption := SBN('Default');
  FButton.Hint := SBN('DefaultHint');
  for i := 0 to FList.Count - 1 do
    TUDLSettingVisual(FList.Items[i]).UpdateCaptions;
end;

procedure TUDLVisualList.UpdateEnable;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
  try
    TUDLSettingVisual(FList.Items[i]).UpdateEnable;
  except
    on E: Exception do
    begin
      E.Message := 'Ошибка при обновлении доступности редактора настройки ' +
        TUDLSettingVisual(FList.Items[i]).UDLSetting.Name + #13#10 + E.Message;
      raise;
    end;
  end;
end;

function TUDLVisualList.VisualBySetting(const FUDLSetting: TUDLSetting): TUDLSettingVisual;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
    if TUDLSettingVisual(FList.Items[i]).UDLSetting = FUDLSetting then
    begin
      Result := TUDLSettingVisual(FList.Items[i]);
      Break;
    end;
end;

end.
