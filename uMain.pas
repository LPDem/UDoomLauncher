unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, CheckLst, ExtCtrls, ActnList, XPMan,
  Menus, Contnrs, AppEvnts, JclDebug,
  StreamedObjects, TypedStream, ComCtrls, UDLSettings, UDLSettingsVisual,
  UDLSettingsValues, UDLPorts, uMasterServerFrame, System.Actions;

const
  Version = '1.9';
  RegKey = 'Software\UDoomLauncher';

type
  TWheelScrollBox = class(TScrollBox)
  protected
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  end;

type
  TFmMain = class(TForm)
    ActionList: TActionList;
    ai_About: TAction;
    ai_AddIWAD: TAction;
    ai_AddPort: TAction;
    ai_AddPWAD: TAction;
    ai_CheckIWAD: TAction;
    ai_DeleteConfig: TAction;
    ai_DeleteIWAD: TAction;
    ai_DeletePort: TAction;
    ai_DeletePWAD: TAction;
    ai_EditPort: TAction;
    ai_MoveDownIWAD: TAction;
    ai_MoveDownPWAD: TAction;
    ai_MoveUpIWAD: TAction;
    ai_MoveUpPWAD: TAction;
    ai_SaveConfig: TAction;
    ai_ShowCmd: TAction;
    ai_Start: TAction;
    Btn_AddIWAD: TButton;
    Btn_AddPort: TButton;
    Btn_AddPWAD: TButton;
    Btn_DeleteConfig: TButton;
    Btn_DeleteIWAD: TButton;
    Btn_DeletePort: TButton;
    Btn_DeletePWAD: TButton;
    Btn_DownIWAD: TButton;
    Btn_DownPWAD: TButton;
    Btn_EditPort: TButton;
    Btn_SaveConfig: TButton;
    Btn_ShowCmd: TButton;
    Btn_Start: TButton;
    Btn_UpIWAD: TButton;
    Btn_UpPWAD: TButton;
    CB_Config: TComboBox;
    CB_GameMode: TComboBox;
    Edt_DoomPorts: TComboBox;
    Edt_Params: TEdit;
    Lbl_Config: TLabel;
    Lbl_ExeFile: TLabel;
    Lbl_GameType: TLabel;
    Lbl_IWADs: TLabel;
    LB_IWADs: TListBox;
    LB_PWADs: TCheckListBox;
    LB_PWADsForIWAD: TCheckListBox;
    MainMenu: TMainMenu;
    MI_About: TMenuItem;
    MI_AddIWAD: TMenuItem;
    MI_AddPWAD: TMenuItem;
    MI_CheckIWAD: TMenuItem;
    MI_DeleteIWAD: TMenuItem;
    MI_DeletePWAD: TMenuItem;
    MI_Exit: TMenuItem;
    MI_File: TMenuItem;
    MI_Help: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    OpenExe: TOpenDialog;
    OpenIWAD: TOpenDialog;
    OpenPWAD: TOpenDialog;
    PG_Options: TPageControl;
    PG_PWADs: TPageControl;
    Pnl_Config: TPanel;
    Pnl_DoomPorts: TPanel;
    Pnl_GameType: TPanel;
    Pnl_IWADButtons: TPanel;
    Pnl_IWADs: TPanel;
    Pnl_PWADButtons: TPanel;
    Pnl_PWADs: TPanel;
    Pnl_Start: TPanel;
    PopupMenu: TPopupMenu;
    SplitterWADs: TSplitter;
    TS_Common: TTabSheet;
    TS_ForIWAD: TTabSheet;
    TS_Main: TTabSheet;
    TS_Multiplayer_C: TTabSheet;
    TS_Multiplayer_S: TTabSheet;
    TS_SinglePlayer: TTabSheet;
    TS_WADs: TTabSheet;
    TS_MasterServer: TTabSheet;
    MasterServerFrame: TMasterServerFrame;
    ai_Language: TAction;
    MI_Language: TMenuItem;
    Lbl_Params: TLabel;
    procedure ai_AboutExecute(Sender: TObject);
    procedure ai_AddIWADExecute(Sender: TObject);
    procedure ai_AddPortExecute(Sender: TObject);
    procedure ai_AddPWADExecute(Sender: TObject);
    procedure ai_AddPWADUpdate(Sender: TObject);
    procedure ai_CheckIWADExecute(Sender: TObject);
    procedure ai_CheckIWADUpdate(Sender: TObject);
    procedure ai_DeleteConfigExecute(Sender: TObject);
    procedure ai_DeleteConfigUpdate(Sender: TObject);
    procedure ai_DeleteIWADExecute(Sender: TObject);
    procedure ai_DeleteIWADUpdate(Sender: TObject);
    procedure ai_DeletePortExecute(Sender: TObject);
    procedure ai_DeletePortUpdate(Sender: TObject);
    procedure ai_DeletePWADExecute(Sender: TObject);
    procedure ai_DeletePWADUpdate(Sender: TObject);
    procedure ai_EditPortExecute(Sender: TObject);
    procedure ai_EditPortUpdate(Sender: TObject);
    procedure ai_MoveDownIWADExecute(Sender: TObject);
    procedure ai_MoveDownIWADUpdate(Sender: TObject);
    procedure ai_MoveDownPWADExecute(Sender: TObject);
    procedure ai_MoveDownPWADUpdate(Sender: TObject);
    procedure ai_MoveUpIWADExecute(Sender: TObject);
    procedure ai_MoveUpIWADUpdate(Sender: TObject);
    procedure ai_MoveUpPWADExecute(Sender: TObject);
    procedure ai_MoveUpPWADUpdate(Sender: TObject);
    procedure ai_SaveConfigExecute(Sender: TObject);
    procedure ai_SaveConfigUpdate(Sender: TObject);
    procedure ai_ShowCmdExecute(Sender: TObject);
    procedure ai_ShowCmdUpdate(Sender: TObject);
    procedure ai_StartExecute(Sender: TObject);
    procedure ai_StartUpdate(Sender: TObject);
    procedure CB_GameModeSelect(Sender: TObject);
    procedure Edt_DoomPortsSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure LB_IWADsClick(Sender: TObject);
    procedure LB_IWADsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LB_PWADsClickCheck(Sender: TObject);
    procedure LB_PWADsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LB_WADsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure MI_ExitClick(Sender: TObject);
    procedure CB_ConfigSelect(Sender: TObject);
    procedure ai_LanguageExecute(Sender: TObject);
  private
    FLocale: Integer;
    DoomPorts: TStreamedObjectList;
    FIWADLBWndProc: TWndMethod;
    FPWADLB2WndProc: TWndMethod;
    FPWADLBWndProc: TWndMethod;
    Hashes: array of TWADVersion;
    IWADs: TStreamedObjectList;
    KeyCnt: Integer;
    PWADs: TPWADsList;
    SB_Common: TWheelScrollBox;
    SB_Multiplayer_C: TWheelScrollBox;
    SB_Multiplayer_S: TWheelScrollBox;
    SB_Singleplayer: TWheelScrollBox;
    UDLSettingsListC: TUDLSettingsList;
    UDLSettingsListM_C: TUDLSettingsList;
    UDLSettingsListM_S: TUDLSettingsList;
    UDLSettingsListS: TUDLSettingsList;
    UDLValuesListC: TUDLValuesList;
    UDLValuesListM_C: TUDLValuesList;
    UDLValuesListM_S: TUDLValuesList;
    UDLValuesListS: TUDLValuesList;
    UDLVisualListC: TUDLVisualList;
    UDLVisualListM_C: TUDLVisualList;
    UDLVisualListM_S: TUDLVisualList;
    UDLVisualListS: TUDLVisualList;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure AddIWADs(const IWADNames: TStrings);
    procedure AddPWADs(const PWADNames: TStrings);
    function CalcWADHash(const FileName: string): string;
    function CheckIWAD(const FileName, Descr: string): Boolean;
    function CreateDoomPortFromFile(const FileName: string): TDoomPort;
    function DoomPortIndex(const Descr, Ver: string): Integer;
    procedure DropFiles(const hDrop: Integer; const Sender: TObject);
    function ExtractResource(const ResName: string): string;
    function GetActivePortCmdParams: string;
    function GetActivePortExeName: string;
    function GetCmd: string;
    function GetCurrentPWADLB: TCheckListBox;
    function GetCurrentPWADList: TPWADsList;
    function GetTempFolder: string;
    function GetWADDescr(const FileName: string): string;
    function GetWADNameByHash(const Hash: string): string;
    function GetWADNameFromLumps(const FileName: string): string;
    procedure IWADLBWndProc(var Message: TMessage);
    procedure LoadConfig(const ConfigName: string);
    procedure LoadConfigList;
    procedure LoadHashesFromIni;
    procedure LoadOptionsFromConfig;
    procedure LoadSettings;
    procedure MoveIWAD(FromIndex, ToIndex: Integer);
    procedure MovePWAD(FromIndex, ToIndex: Integer);
    procedure OnException(Sender: TObject; E: Exception);
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure PWADLB2WndProc(var Message: TMessage);
    procedure PWADLBWndProc(var Message: TMessage);
    procedure SaveConfig(const ConfigName: string);
    procedure SaveSettings;
    procedure OnWinSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: Longint);
    procedure UpdateListsCaptions;
  public
    procedure MouseWheelHandler(var Message: TMessage); override;
  end;

var
  FmMain: TFmMain;

implementation

uses
  Types, Registry, IniFiles, IdHashMessageDigest, DoomWAD, StrUtils, uMessageForm, Math, FormPlacement, ShellAPI,
  uLanguage, LanguagePacks, uResources;

{$R *.dfm}

{$R UDoomLauncherWAD.res}

function TWheelScrollBox.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  VertScrollBar.Position := VertScrollBar.Position - Sign(WheelDelta) * VertScrollBar.Increment;
end;

procedure TFmMain.AddIWADs(const IWADNames: TStrings);
var
  k: Integer;
  i: Integer;
  IWAD: TIWAD;
  s: string;
begin
  Screen.Cursor := crHourGlass;
  try
    k := LB_IWADs.ItemIndex + 1;
    for i := 0 to IWADNames.Count - 1 do
    begin
      s := GetWADDescr(IWADNames[i]);
      if CheckIWAD(IWADNames[i], s) then
      begin
        IWAD := TIWAD.Create;
        IWAD.FileName := IWADNames[i];
        IWAD.Descr := s;
        IWADs.List.Insert(k, IWAD);
        LB_IWADS.Items.Insert(k, IWAD.Descr);
      end;
    end;
    LB_IWADs.ItemIndex := k;
    LB_IWADs.OnClick(Self);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmMain.AddPWADs(const PWADNames: TStrings);
var
  k: Integer;
  i: Integer;
  LB: TCheckListBox;
  WL: TPWADsList;
begin
  LB := GetCurrentPWADLB;
  WL := GetCurrentPWADList;
  k := LB.ItemIndex + 1;
  for i := 0 to PWADNames.Count - 1 do
  begin
    LB.Items.Insert(k, PWADNames[i]);
    LB.Checked[k] := True;
    WL.InsertPWAD(k, PWADNames[i]);
  end;
  LB.ItemIndex := k;
end;

procedure TFmMain.ai_AboutExecute(Sender: TObject);
var
  AboutStr: string;
begin
  AboutStr := Caption + #13#10 + 'Dem, 2009 - 2019' + #13#10 + SBN('About_1') + #13#10 + SBN('About_2');
  ShowMessage(AboutStr);
end;

procedure TFmMain.ai_AddIWADExecute(Sender: TObject);
begin
  if OpenIWAD.Execute then
    AddIWADs(OpenIWAD.Files);
end;

procedure TFmMain.ai_AddPortExecute(Sender: TObject);
var
  DoomPort: TDoomPort;
begin
  if OpenExe.Execute then
  begin
    DoomPort := CreateDoomPortFromFile(OpenExe.FileName);
    if Assigned(DoomPort) then
    begin
      DoomPorts.List.Add(DoomPort);
      Edt_DoomPorts.ItemIndex := Edt_DoomPorts.Items.Add(DoomPort.PortName);
      Edt_DoomPorts.OnSelect(Self);
      OpenPWAD.InitialDir := ExtractFilePath(OpenExe.FileName);
      OpenIWAD.InitialDir := OpenPWAD.InitialDir;
    end;
  end;
end;

procedure TFmMain.ai_AddPWADExecute(Sender: TObject);
begin
  if OpenPWAD.Execute then
    AddPWADs(OpenPWAD.Files);
end;

procedure TFmMain.ai_AddPWADUpdate(Sender: TObject);
begin
  ai_AddPWAD.Enabled := (GetCurrentPWADList <> nil);
end;

procedure TFmMain.ai_CheckIWADExecute(Sender: TObject);
var
  s: string;
  FileName: string;
begin
  FileName := TIWAD(IWADs.List[LB_IWADs.ItemIndex]).FileName;
  s := GetWADDescr(FileName);
  LB_IWADs.Items[LB_IWADs.ItemIndex] := s;
  TIWAD(IWADs.List[LB_IWADs.ItemIndex]).Descr := s;
  //CheckIWAD(FileName, s);
end;

procedure TFmMain.ai_CheckIWADUpdate(Sender: TObject);
begin
  ai_CheckIWAD.Enabled := (LB_IWADs.ItemIndex > -1);
end;

procedure TFmMain.ai_DeleteConfigExecute(Sender: TObject);
var
  Reg: TRegistry;
begin
  if MessageBox(Application.Handle, PChar(SBN('ProfileDeleteConfirmation')), PChar(SBN('Confirmation')), MB_ICONQUESTION or MB_YESNO) = idYes then
  begin
    Reg := TRegistry.Create(KEY_READ);
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(RegKey + '\Configs', False);
      Reg.DeleteKey(CB_Config.Text);
      CB_Config.Items.Delete(CB_Config.ItemIndex);
      Reg.CloseKey;
    finally
      Reg.Free;
    end;
  end;
end;

procedure TFmMain.ai_DeleteConfigUpdate(Sender: TObject);
begin
  ai_DeleteConfig.Enabled := CB_Config.ItemIndex >= 0;
end;

procedure TFmMain.ai_DeleteIWADExecute(Sender: TObject);
var
  k: Integer;
begin
  k := LB_IWADS.ItemIndex;
  LB_IWADS.Items.Delete(k);
  IWADs.List.Delete(k);
  if LB_IWADS.Count > 0 then
  begin
    LB_IWADS.ItemIndex := k;
    LB_IWADS.OnClick(Self);
  end;
end;

procedure TFmMain.ai_DeleteIWADUpdate(Sender: TObject);
begin
  ai_DeleteIWAD.Enabled := (LB_IWADS.ItemIndex >= 0);
end;

procedure TFmMain.ai_DeletePortExecute(Sender: TObject);
var
  k: Integer;
begin
  if MessageBox(Application.Handle, PChar(SBN('PortDeleteConfirmation')), PChar(SBN('Confirmation')), MB_ICONQUESTION or MB_YESNO) = idYes then
  begin
    k := Edt_DoomPorts.ItemIndex;
    Edt_DoomPorts.Items.Delete(k);
    DoomPorts.List.Delete(k);
    Edt_DoomPorts.ItemIndex := Min(k, Edt_DoomPorts.Items.Count - 1);
    Edt_DoomPorts.Invalidate;
    Edt_DoomPorts.OnSelect(Self);
  end;
end;

procedure TFmMain.ai_DeletePortUpdate(Sender: TObject);
begin
  ai_DeletePort.Enabled := (Edt_DoomPorts.ItemIndex > -1);
end;

procedure TFmMain.ai_DeletePWADExecute(Sender: TObject);
var
  k: Integer;
  LB: TCheckListBox;
  WL: TPWADsList;
begin
  LB := GetCurrentPWADLB;
  WL := GetCurrentPWADList;
  k := LB.ItemIndex;
  LB.Items.Delete(k);
  WL.List.Delete(k);
  if LB.Count > 0 then
    LB.ItemIndex := k;
end;

procedure TFmMain.ai_DeletePWADUpdate(Sender: TObject);
begin
  ai_DeletePWAD.Enabled := (GetCurrentPWADLB.ItemIndex >= 0) and (GetCurrentPWADList <> nil);
end;

procedure TFmMain.ai_EditPortExecute(Sender: TObject);
var
  k: Integer;
  DoomPort: TDoomPort;
begin
  if OpenExe.Execute then
  begin
    k := Edt_DoomPorts.ItemIndex;
    DoomPort := CreateDoomPortFromFile(OpenExe.FileName);
    if Assigned(DoomPort) then
    begin
      DoomPorts.List[k] := DoomPort;
      Edt_DoomPorts.Items[k] := TDoomPort(DoomPorts.List[k]).PortName;
      Edt_DoomPorts.ItemIndex := k;
      Edt_DoomPorts.OnSelect(Self);
    end;
  end;
end;

procedure TFmMain.ai_EditPortUpdate(Sender: TObject);
begin
  ai_EditPort.Enabled := (Edt_DoomPorts.ItemIndex > -1);
end;

procedure TFmMain.ai_LanguageExecute(Sender: TObject);
begin
  if TfmLanguage.EditLocale(FLocale) then
  begin
    LanguagePacksManager.SetActiveLanguagePack(FLocale, True);
    LanguagePacksManager.ApplyToAllForms;
    UpdateListsCaptions;
    Edt_DoomPorts.OnSelect(Self);
  end;
end;

procedure TFmMain.ai_MoveDownIWADExecute(Sender: TObject);
var
  k: Integer;
begin
  k := LB_IWADS.ItemIndex;
  MoveIWAD(k, k + 1);
end;

procedure TFmMain.ai_MoveDownIWADUpdate(Sender: TObject);
begin
  ai_MoveDownIWAD.Enabled := (LB_IWADS.ItemIndex >= 0) and (LB_IWADS.ItemIndex < LB_IWADS.Count - 1);
end;

procedure TFmMain.ai_MoveDownPWADExecute(Sender: TObject);
var
  k: Integer;
  LB: TCheckListBox;
begin
  LB := GetCurrentPWADLB;
  k := LB.ItemIndex;
  MovePWAD(k, k + 1);
end;

procedure TFmMain.ai_MoveDownPWADUpdate(Sender: TObject);
begin
  ai_MoveDownPWAD.Enabled := (GetCurrentPWADLB.ItemIndex >= 0) and (GetCurrentPWADLB.ItemIndex < LB_PWADS.Count - 1) and
    (GetCurrentPWADList <> nil);
end;

procedure TFmMain.ai_MoveUpIWADExecute(Sender: TObject);
var
  k: Integer;
begin
  k := LB_IWADS.ItemIndex;
  MoveIWAD(k, k - 1);
end;

procedure TFmMain.ai_MoveUpIWADUpdate(Sender: TObject);
begin
  ai_MoveUpIWAD.Enabled := (LB_IWADS.ItemIndex > 0);
end;

procedure TFmMain.ai_MoveUpPWADExecute(Sender: TObject);
var
  k: Integer;
  LB: TCheckListBox;
begin
  LB := GetCurrentPWADLB;
  k := LB.ItemIndex;
  MovePWAD(k, k - 1);
end;

procedure TFmMain.ai_MoveUpPWADUpdate(Sender: TObject);
begin
  ai_MoveUpPWAD.Enabled := (GetCurrentPWADLB.ItemIndex > 0) and (GetCurrentPWADList <> nil);
end;

procedure TFmMain.ai_SaveConfigExecute(Sender: TObject);
var
  Reg: TRegistry;
  ConfigName: string;
begin
  ConfigName := 'Configs\' + CB_Config.Text;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(RegKey + '\' + ConfigName) then
      if MessageBox(Application.Handle, PChar(SBN('ProfileAllreadyExists')),
        PChar(SBN('Question')), MB_ICONQUESTION or MB_YESNO) = IDNO then
        Exit;
  finally
    Reg.Free;
  end;
  SaveConfig(ConfigName);
  LoadConfigList;
end;

procedure TFmMain.ai_SaveConfigUpdate(Sender: TObject);
begin
  ai_SaveConfig.Enabled := CB_Config.Text <> '';
end;

procedure TFmMain.ai_ShowCmdExecute(Sender: TObject);
begin
  TfmMessage.ShowText(GetCmd, SBN('CommandLine'));
end;

procedure TFmMain.ai_ShowCmdUpdate(Sender: TObject);
begin
  ai_ShowCmd.Enabled := (Edt_DoomPorts.ItemIndex > -1) and (LB_IWADs.ItemIndex > -1);
end;

procedure TFmMain.ai_StartExecute(Sender: TObject);
var
  Cmd: string;
  STARTUPINFO: _STARTUPINFOW;
  ProcInfo: _PROCESS_INFORMATION;
  HexenFile: string;
begin
  SaveSettings;
  // Check for HexDD
  if AnsiContainsText(TIWAD(IWADs.List[LB_IWADs.ItemIndex]).Descr, 'Deathkings of the Dark Citadel') then
  begin
    HexenFile := ExtractFilePath(GetActivePortExeName) + 'HEXEN.WAD';
    if not FileExists(HexenFile) or (GetWADDescr(HexenFile) = '') then
    begin
      MessageBox(Application.Handle, PChar(SBN('HexDDWarning')), PChar(SBN('Warning')), MB_ICONWARNING or MB_OK);
      Exit;
    end;
  end;
  // Start
  Cmd := GetCmd;
  STARTUPINFO.cb := SizeOf(STARTUPINFO);
  ZeroMemory(@STARTUPINFO, STARTUPINFO.cb);
  if not CreateProcess(nil, PChar(Cmd), nil, nil, False, 0, nil, PChar(ExtractFilePath(GetActivePortExeName)), STARTUPINFO, ProcInfo) then
    MessageBox(Application.Handle, PChar(SBN('CantExecute') + #13#10 + Cmd), 'Ошибка', MB_ICONWARNING or MB_OK);
end;

procedure TFmMain.ai_StartUpdate(Sender: TObject);
begin
  ai_Start.Enabled := (Edt_DoomPorts.ItemIndex > -1) and (LB_IWADs.ItemIndex > -1);
end;

function TFmMain.CalcWADHash(const FileName: string): string;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    with TIdHashMessageDigest5.Create do
    try
      Result := AnsiLowerCase(HashStreamAsHex(Stream));
    finally
      Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TFmMain.CB_ConfigSelect(Sender: TObject);
begin
  if CB_Config.ItemIndex >= 0 then
    LoadConfig('Configs\' + CB_Config.Text);
end;

procedure TFmMain.CB_GameModeSelect(Sender: TObject);
var
  GameMode: Integer;
begin
  GameMode := CB_GameMode.ItemIndex;
  TS_SinglePlayer.TabVisible := (GameMode = 0);
  TS_MultiPlayer_C.TabVisible := (GameMode = 1);
  TS_MultiPlayer_S.TabVisible := (GameMode = 2);
  UDLSettingsListC.GameMode := GameMode;
  UDLVisualListC.SetGameMode(GameMode);
  UDLSettingsListS.GameMode := GameMode;
  UDLVisualListS.SetGameMode(GameMode);
  UDLSettingsListM_C.GameMode := GameMode;
  UDLVisualListM_C.SetGameMode(GameMode);
  UDLSettingsListM_S.GameMode := GameMode;
  UDLVisualListM_S.SetGameMode(GameMode);
end;

function TFmMain.CheckIWAD(const FileName, Descr: string): Boolean;
begin
  Result := (Descr <> '');
  if not Result then
    MessageBox(Application.Handle, PChar(Format(SBN('FileIsNotIWAD'), [ExtractFileName(FileName)])),
      PChar(SBN('Warning')), MB_ICONWARNING or MB_OK)
  else
  begin
    if AnsiContainsText(Descr, 'Strife Voices.wad') then
    begin
      Result := False;
      MessageBox(Application.Handle, PChar(SBN('StrifeVoicesWarning')), PChar(SBN('Warning')), MB_ICONWARNING or MB_OK);
    end else
    if LB_IWADs.Items.IndexOf(Descr) >= 0 then
    begin
      Result := False;
      MessageBox(Application.Handle, PChar(SBN('IWADAllreadyExists')), PChar(SBN('Warning')), MB_ICONWARNING or MB_OK);
    end;
  end;
end;

procedure TFmMain.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Edt_DoomPorts.Items.Count = 0 then
    if MessageBox(Application.Handle, PChar(SBN('NoPorts')), PChar(SBN('Question')), MB_ICONQUESTION or MB_YESNO) = idYes then
      ai_AddPort.Execute;
  Message.Result := 1;
end;

function TFmMain.CreateDoomPortFromFile(const FileName: string): TDoomPort;
var
  k: Integer;
begin
  Result := TDoomPort.Create;
  Result.FileName := FileName;
  k := DoomPortIndex(Result.Descr, Result.Ver);
  if k > -1 then
  begin
    FreeAndNil(Result);
    MessageBox(Application.Handle, PChar(SBN('PortAllreadyExists')), PChar(SBN('Message')), MB_ICONINFORMATION or MB_OK);
    Exit;
  end;
  if Result.PortType = ptUnknown then
  begin
    // FreeAndNil(Result);
    MessageBox(Application.Handle, PChar(SBN('WrongPort')), PChar(SBN('Warning')), MB_ICONWARNING or MB_OK);
    Exit;
  end;
end;

function TFmMain.DoomPortIndex(const Descr, Ver: string): Integer;
var
  i: Integer;
  Port: TDoomPort;
begin
  Result := -1;
  for i := 0 to DoomPorts.List.Count - 1 do
  begin
    Port := TDoomPort(DoomPorts.List[i]);
    if AnsiSameText(Port.Descr, Descr) and AnsiSameText(Port.Ver, Ver) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TFmMain.DropFiles(const hDrop: Integer; const Sender: TObject);
var
  i, Amount, Size: Integer;
  Filename: PChar;
  SL: TStringList;
begin
  inherited;
  BringToFront;
  Filename := nil;
  SL := TStringList.Create;
  try
    Amount := DragQueryFile(hDrop, $FFFFFFFF, Filename, 255);
    for i := 0 to Amount - 1 do
    begin
      Size := DragQueryFile(hDrop, i, nil, 0) + 1;
      Filename := StrAlloc(Size);
      DragQueryFile(hDrop, i, Filename, Size);
      SL.Add(Filename);
      StrDispose(Filename);
    end;
    if Sender = LB_IWADs then
      AddIWADs(SL)
    else
    if (Sender = LB_PWADs) or (Sender = LB_PWADsForIWAD) then
      AddPWADs(SL);
  finally
    DragFinish(hDrop);
    SL.Free;
  end;
end;

procedure TFmMain.Edt_DoomPortsSelect(Sender: TObject);
var
  k: Integer;
  DoomPortType: TDoomPortType;
  CB_GameMode_ItemIndex: Integer;
begin
  DoomPortType := ptUnknown;
  k := Edt_DoomPorts.ItemIndex;
  if k <> -1 then
  begin
    DoomPortType := TDoomPort(DoomPorts.List[k]).PortType;
    UDLSettingsListC.DoomPortType := DoomPortType;
    UDLVisualListC.SetDoomPortType(DoomPortType);
    UDLSettingsListS.DoomPortType := DoomPortType;
    UDLVisualListS.SetDoomPortType(DoomPortType);
    UDLSettingsListM_C.DoomPortType := DoomPortType;
    UDLVisualListM_C.SetDoomPortType(DoomPortType);
    UDLSettingsListM_S.DoomPortType := DoomPortType;
    UDLVisualListM_S.SetDoomPortType(DoomPortType);
  end;
  CB_GameMode_ItemIndex := CB_GameMode.ItemIndex;
  CB_GameMode.Items.Clear;
  CB_GameMode.Items.Add(SBN('SingleplayerMode'));
  if DoomPortType <> ptUnknown then
  begin
    CB_GameMode.Items.Add(SBN('MultiplayerModeClient'));
    CB_GameMode.Items.Add(SBN('MultiplayerModeServer'));
  end;
  CB_GameMode.ItemIndex := CB_GameMode_ItemIndex;
  if CB_GameMode.ItemIndex = -1 then
    CB_GameMode.ItemIndex := 0;
  CB_GameMode.OnSelect(Self);
end;

function TFmMain.ExtractResource(const ResName: string): string;
var
  HResInfo: THandle;
  MemHandle: THandle;
  ResPtr: PByte;
  ResSize: Integer;
  Stream: TMemoryStream;
begin
  Result := '';
  HResInfo := FindResource(HInstance, PChar(ResName), 'WAD');
  if HResInfo <> 0 then
  begin
    MemHandle := LoadResource(HInstance, HResInfo);
    try
      ResPtr := LockResource(MemHandle);
      ResSize := SizeofResource(HInstance, HResInfo);
      Result := GetTempFolder + ResName + '.wad';
      Stream := TMemoryStream.Create;
      try
        Stream.Size := ResSize;
        Stream.Write(ResPtr^, ResSize);
        Stream.Position := 0;
        Stream.SaveToFile(Result);
      finally
        Stream.Free;
      end;
    finally
      FreeResource(MemHandle);
    end;
  end;
end;

procedure TFmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  SaveFormPlacement(Self);
  SaveFormValue(Self, 'Pnl_PWADs_Width', Pnl_PWADs.Width);
end;

procedure TFmMain.FormCreate(Sender: TObject);
var
  s: string;
  t: Integer;
begin
  TS_MasterServer.TabVisible := False;

  FormatSettings.DecimalSeparator := '.';
  Application.OnSettingChange := OnWinSettingChange;
  InitFormPlacement(RegKey);
  Application.Title := Application.Title + ' ' + Version;
  Application.OnShowHint := OnShowHint;
  Application.OnException := OnException;
  Caption := Application.Title;
  SB_Common := TWheelScrollBox.Create(Self);
  SB_Common.Name := 'SB_Common';
  SB_Common.Parent := TS_Main;
  SB_Common.Align := alClient;
  SB_Common.BorderStyle := bsNone;
  SB_Common.VertScrollBar.Tracking := True;
  SB_Common.VertScrollBar.Increment := 32;
  SB_Common.HorzScrollBar.Visible := False;
  SB_Common.Color := clWindow;
  SB_Singleplayer := TWheelScrollBox.Create(Self);
  SB_Singleplayer.Name := 'SB_Singleplayer';
  SB_Singleplayer.Parent := TS_SinglePlayer;
  SB_Singleplayer.Align := alClient;
  SB_Singleplayer.BorderStyle := bsNone;
  SB_Singleplayer.VertScrollBar.Tracking := True;
  SB_Singleplayer.VertScrollBar.Increment := 32;
  SB_Singleplayer.HorzScrollBar.Visible := False;
  SB_Singleplayer.Color := clWindow;
  SB_Multiplayer_C := TWheelScrollBox.Create(Self);
  SB_Multiplayer_C.Name := 'SB_Multiplayer_C';
  SB_Multiplayer_C.Parent := TS_Multiplayer_C;
  SB_Multiplayer_C.Align := alClient;
  SB_Multiplayer_C.BorderStyle := bsNone;
  SB_Multiplayer_C.VertScrollBar.Tracking := True;
  SB_Multiplayer_C.VertScrollBar.Increment := 32;
  SB_Multiplayer_C.HorzScrollBar.Visible := False;
  SB_Multiplayer_C.Color := clWindow;
  SB_Multiplayer_S := TWheelScrollBox.Create(Self);
  SB_Multiplayer_S.Name := 'SB_Multiplayer_S';
  SB_Multiplayer_S.Parent := TS_Multiplayer_S;
  SB_Multiplayer_S.Align := alClient;
  SB_Multiplayer_S.BorderStyle := bsNone;
  SB_Multiplayer_S.VertScrollBar.Tracking := True;
  SB_Multiplayer_S.VertScrollBar.Increment := 32;
  SB_Multiplayer_S.HorzScrollBar.Visible := False;
  SB_Multiplayer_S.Color := clWindow;
  IWADs := TStreamedObjectList.Create;
  PWADs := TPWADsList.Create;
  UDLSettingsListS := TUDLSettingsList.Create;
  UDLVisualListS := TUDLVisualList.Create;
  UDLValuesListS := TUDLValuesList.Create(UDLSettingsListS);
  UDLSettingsListC := TUDLSettingsList.Create;
  UDLVisualListC := TUDLVisualList.Create;
  UDLValuesListC := TUDLValuesList.Create(UDLSettingsListC);
  UDLSettingsListM_C := TUDLSettingsList.Create;
  UDLVisualListM_C := TUDLVisualList.Create;
  UDLValuesListM_C := TUDLValuesList.Create(UDLSettingsListM_C);
  UDLSettingsListM_S := TUDLSettingsList.Create;
  UDLVisualListM_S := TUDLVisualList.Create;
  UDLValuesListM_S := TUDLValuesList.Create(UDLSettingsListM_S);
  DoomPorts := TStreamedObjectList.Create;
  LoadHashesFromIni;
  LoadSettings;
  LoadOptionsFromConfig;
  s := LanguagePacksManager.GenerateLangPack;
  LanguagePacksManager.SetDefaultLanguagePack(1049, 'Русский', s);
  LanguagePacksManager.EnumLanguagePacks;
  LanguagePacksManager.SetActiveLanguagePack(FLocale);
  LoadConfigList;
  LoadConfig('CurrentConfig');
  LanguagePacksManager.ApplyToForm(Self);
  UpdateListsCaptions;
  KeyCnt := 0;
end;

procedure TFmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(IWADs);
  FreeAndNil(PWADs);
  FreeAndNil(DoomPorts);
  FreeAndNil(UDLVisualListC);
  FreeAndNil(UDLValuesListC);
  FreeAndNil(UDLSettingsListC);
  FreeAndNil(UDLVisualListS);
  FreeAndNil(UDLValuesListS);
  FreeAndNil(UDLSettingsListS);
  FreeAndNil(UDLVisualListM_C);
  FreeAndNil(UDLValuesListM_C);
  FreeAndNil(UDLSettingsListM_C);
  FreeAndNil(UDLVisualListM_S);
  FreeAndNil(UDLValuesListM_S);
  FreeAndNil(UDLSettingsListM_S);
end;

procedure TFmMain.FormKeyPress(Sender: TObject; var Key: Char);
var
  Cmd: string;
  STARTUPINFO: _STARTUPINFOW;
  ProcInfo: _PROCESS_INFORMATION;
  WADFile: string;
begin
  if (KeyCnt = 0) and (Key = 'i') then
    Inc(KeyCnt)
  else
  if (KeyCnt = 1) and (Key = 'd') then
    Inc(KeyCnt)
  else
  if (KeyCnt = 2) and (Key = 'd') then
    Inc(KeyCnt)
  else
  if (KeyCnt = 3) and (Key = 'q') then
    Inc(KeyCnt)
  else
  if (KeyCnt = 4) and (Key = 'd') then
  begin
    if LB_IWADs.ItemIndex = -1 then
      Exit;
    WADFile := ExtractResource('IDDQD');
    Color := clMaroon;
    Cmd := '"' + GetActivePortExeName + '"';
    Cmd := Cmd + ' -iwad "' + TIWAD(IWADs.List[LB_IWADs.ItemIndex]).FileName + '"';
    Cmd := Cmd + ' -file ' + '"' + WADFile + '"';
    Cmd := Cmd + ' +map map30 +set DMFlags 32768 +set DMFlags2 131072';
    STARTUPINFO.cb := SizeOf(STARTUPINFO);
    ZeroMemory(@STARTUPINFO, STARTUPINFO.cb);
    if CreateProcess(nil, PChar(Cmd), nil, nil, False, 0, nil, PChar(ExtractFilePath(GetActivePortExeName)), STARTUPINFO, ProcInfo) then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    DeleteFile(WADFile);
  end
  else
    KeyCnt := 0;
end;

procedure TFmMain.FormShow(Sender: TObject);
begin
  LoadFormPlacement(Self);
  Pnl_PWADs.Width := LoadFormValue(Self, 'Pnl_PWADs_Width', Pnl_PWADs.Width);
  Btn_Start.SetFocus;
  FIWADLBWndProc := LB_IWADs.WindowProc;
  LB_IWADs.WindowProc := IWADLBWndProc;
  FPWADLBWndProc := LB_PWADs.WindowProc;
  LB_PWADs.WindowProc := PWADLBWndProc;
  FPWADLB2WndProc := LB_PWADsForIWAD.WindowProc;
  LB_PWADsForIWAD.WindowProc := PWADLB2WndProc;
  DragAcceptFiles(LB_IWADs.Handle, True);
  DragAcceptFiles(LB_PWADs.Handle, True);
  DragAcceptFiles(LB_PWADsForIWAD.Handle, True);
end;

function TFmMain.GetActivePortCmdParams: string;
var
  k: Integer;
  GameType: Integer;
begin
  k := Edt_DoomPorts.ItemIndex;
  GameType := CB_GameMode.ItemIndex;
  Result := TDoomPort(DoomPorts.List[k]).CmdParams(GameType);
end;

function TFmMain.GetActivePortExeName: string;
var
  k: Integer;
begin
  k := Edt_DoomPorts.ItemIndex;
  Result := TDoomPort(DoomPorts.List[k]).FileName;
end;

function TFmMain.GetCmd: string;
var
  s: string;
  i: Integer;
begin
  Result := '"' + GetActivePortExeName + '"';
  s := '';
  s := s + '-iwad "' + TIWAD(IWADs.List[LB_IWADs.ItemIndex]).FileName + '"';
  for i := 0 to LB_PWADS.Count - 1 do
    if LB_PWADS.Checked[i] then
    begin
      if s <> '' then
        s := s + ' ';
      s := s + '-file "' + LB_PWADS.Items[i] + '"';
    end;
  if s <> '' then
    Result := Result + ' ' + s;
  s := '';
  for i := 0 to LB_PWADsForIWAD.Count - 1 do
    if LB_PWADsForIWAD.Checked[i] then
    begin
      if s <> '' then
        s := s + ' ';
      s := s + '-file "' + LB_PWADsForIWAD.Items[i] + '"';
    end;
  if s <> '' then
    Result := Result + ' ' + s;
  s := GetActivePortCmdParams;
  if s <> '' then
    Result := Result + ' ' + s;
  UDLVisualListC.SaveToValuesList(UDLValuesListC);
  s := UDLValuesListC.Command;
  if s <> '' then
    Result := Result + ' ' + s;
  if CB_GameMode.ItemIndex = 0 then
  begin
    UDLVisualListS.SaveToValuesList(UDLValuesListS);
    s := UDLValuesListS.Command;
  end
  else
  if CB_GameMode.ItemIndex = 1 then
  begin
    UDLVisualListM_C.SaveToValuesList(UDLValuesListM_C);
    s := UDLValuesListM_C.Command;
  end else
  begin
    UDLVisualListM_S.SaveToValuesList(UDLValuesListM_S);
    s := UDLValuesListM_S.Command;
  end;
  if s <> '' then
    Result := Result + ' ' + s;
  if Edt_Params.Text <> '' then
    Result := Result + ' ' + Edt_Params.Text;
end;

function TFmMain.GetCurrentPWADLB: TCheckListBox;
begin
  if PG_PWADs.ActivePageIndex = 0 then
    Result := LB_PWADS
  else
    Result := LB_PWADsForIWAD;
end;

function TFmMain.GetCurrentPWADList: TPWADsList;
begin
  if PG_PWADs.ActivePageIndex = 0 then
    Result := PWADs
  else
  if LB_IWADs.ItemIndex >= 0 then
    Result := TIWAD(IWADs.List[LB_IWADs.ItemIndex]).PWADsList
  else
    Result := nil;
end;

function TFmMain.GetTempFolder: string;
var
  k: Integer;
begin
  k := GetTempPath(0, nil);
  SetLength(Result, k);
  GetTempPath(k, @Result[1]);
  SetLength(Result, k - 1);
end;

function TFmMain.GetWADDescr(const FileName: string): string;
begin
  Result := CalcWADHash(FileName);
  Result := GetWADNameByHash(Result);
  if Result = '' then
  begin
    Result := GetWADNameFromLumps(FileName);
    if Result <> '' then
      Result := Result + ' (' + SBN('ModifiedVersion') + ')';
  end;
end;

function TFmMain.GetWADNameByHash(const Hash: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(Hashes) - 1 do
    if AnsiSameText(Hash, Hashes[i].Hash) then
    begin
      Result := Hashes[i].Version;
      Break;
    end;
end;

function TFmMain.GetWADNameFromLumps(const FileName: string): string;
var
  WAD: TDoomWAD;
  VoicesFile, VoicesDesc: string;
begin
  Result := '';
  WAD := TDoomWAD.Create(FileName);
  try
    if not WAD.IsIWAD then
    begin
      // Chex Quest
      if WAD.IsLumpExists('CJLITE01') then
        Result := 'Chex Quest 3'
      else
      if WAD.IsLumpExists('POSSH0M0') then
        Result := 'Chex Quest';
    end else
    if WAD.IsLumpExists('V_START') then
      Result := 'Strife Voices.wad'
    else
    if WAD.IsLumpExists('FREEDOOM') then
      Result := 'Freedoom'
    else
    if WAD.IsLumpExists('E1M1') then
    begin
      // Эпизоды
      if WAD.IsLumpExists('TITLE') then
      begin
        // Heretic
        if WAD.IsLumpExists('EXTENDED') then
          Result := 'Heretic: Shadow of the Serpent Riders'
        else
        if WAD.IsLumpExists('E2M3') then
          Result := 'Heretic'
        else
          Result := 'Heretic Shareware';
      end else
      if WAD.IsLumpExists('E4M2') then
      begin
        // DoomU
        Result := 'Ultimate DOOM';
      end else
      if WAD.IsLumpExists('E2M3') then
      begin
        // DOOM
        Result := 'DOOM Registered';
      end else
        Result := 'DOOM Shareware';
    end else
    if WAD.IsLumpExists('MAP01') then
    begin
      // MAP
      if WAD.IsLumpExists('MAP40') then
      begin
        // Hexen
        Result := 'Hexen: Beyond Heretic';
      end else
      if WAD.IsLumpExists('TINTTAB') then
      begin
        // Hexen1
        Result := 'Hexen Demo';
      end else
      if WAD.IsLumpExists('ENDSTRF') then
      begin
        // Strife
        Result := 'Strife: Quest for the Sigil';
        VoicesFile := ExtractFilePath(FileName) + 'voices.wad';
        if FileExists(VoicesFile) then
        begin
          VoicesDesc := GetWADDescr(VoicesFile);
          Result := Result + '(' + VoicesDesc + ')';
        end;
      end else
      if WAD.IsLumpExists('CAMO1') then
      begin
        // Plutonia
        Result := 'Final Doom: The Plutonia Experiment';
      end else
      if WAD.IsLumpExists('REDTNT2') then
      begin
        // TNT
        Result := 'Final Doom: TNT Evilution';
      end else
        Result := 'Doom II: Hell on Earth';
    end else
    if WAD.IsLumpExists('MAP32') then
      Result := 'Strife Demo'
    else
    if WAD.IsLumpExists('MAP60') then
      Result := 'Hexen: Deathkings of the Dark Citadel';
  finally
    WAD.Free;
  end;
end;

procedure TFmMain.IWADLBWndProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
  begin
    DropFiles(Message.WParam, LB_IWADs);
    Message.Result := 1;
  end else
    FIWADLBWndProc(Message);
end;

procedure TFmMain.LB_IWADsClick(Sender: TObject);
var
  k: Integer;
  IWAD: string;
begin
  k := LB_IWADs.ItemIndex;
  if k < 0 then
    Exit;
  TIWAD(IWADs.List[LB_IWADs.ItemIndex]).PWADsList.ToListBox(LB_PWADsForIWAD);
  // TS_ForIWAD.Caption := 'PWADS для ' + TIWAD(IWADs.List[k]).FileName;
  IWAD := ExtractFileName(TIWAD(IWADs.List[k]).FileName);
  UDLSettingsListC.IWAD := IWAD;
  UDLSettingsListM_C.IWAD := IWAD;
  UDLSettingsListM_S.IWAD := IWAD;
  UDLSettingsListS.IWAD := IWAD;
  UDLVisualListC.SetIWAD(IWAD);
  UDLVisualListM_C.SetIWAD(IWAD);
  UDLVisualListM_S.SetIWAD(IWAD);
  UDLVisualListS.SetIWAD(IWAD);
end;

procedure TFmMain.LB_IWADsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  FromIndex, ToIndex: Integer;
begin
  if Source = Sender then
  begin
    FromIndex := LB_IWADs.ItemIndex;
    ToIndex := LB_IWADs.ItemAtPos(Point(X, Y), False);
    MoveIWAD(FromIndex, ToIndex);
  end;
end;

procedure TFmMain.LB_PWADsClickCheck(Sender: TObject);
var
  k: Integer;
  LB: TCheckListBox;
  WL: TPWADsList;
begin
  LB := GetCurrentPWADLB;
  k := LB.ItemIndex;
  if k < 0 then
    Exit;
  WL := GetCurrentPWADList;
  TPWAD(WL.List[k]).Checked := LB.Checked[k];
end;

procedure TFmMain.LB_PWADsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  FromIndex, ToIndex: Integer;
  LB: TCheckListBox;
begin
  if Source = Sender then
  begin
    LB := GetCurrentPWADLB;
    FromIndex := LB.ItemIndex;
    ToIndex := LB.ItemAtPos(Point(X, Y), False);
    MovePWAD(FromIndex, ToIndex);
  end;
end;

procedure TFmMain.LB_WADsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = Sender);
end;

procedure TFmMain.LoadConfig(const ConfigName: string);
var
  Reg: TRegistry;
  Stream: TTypedStream;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(RegKey + '\' + ConfigName) then
    begin
      Reg.OpenKey(RegKey + '\' + ConfigName, False);
      // Doom Ports
      if Reg.ValueExists('ActivePort') then
        Edt_DoomPorts.ItemIndex := Reg.ReadInteger('ActivePort');
      Edt_DoomPorts.OnSelect(Self);
      // PWADs
      if Reg.ValueExists('PWADs') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('PWADs');
          Reg.ReadBinaryData('PWADs', PByte(Stream.Memory)^, Stream.Size);
          PWADs.LoadFromStream(Stream);
          PWADs.ToListBox(LB_PWADS);
        finally
          Stream.Free;
        end;
      end;
      if Reg.ValueExists('ActivePWAD') then
        LB_PWADs.ItemIndex := Reg.ReadInteger('ActivePWAD');
      // IWads
      if Reg.ValueExists('ActiveIWAD') then
        LB_IWADs.ItemIndex := Reg.ReadInteger('ActiveIWAD');
      if Reg.ValueExists('ActivePWADForIWAD') then
        LB_PWADsForIWAD.ItemIndex := Reg.ReadInteger('ActivePWADForIWAD');
      // Params
      Edt_Params.Text := Reg.ReadString('Params');
      // Game type
      if Reg.ValueExists('GameType') then
        CB_GameMode.ItemIndex := Reg.ReadInteger('GameType')
      else
        CB_GameMode.ItemIndex := 0;
      CB_GameMode.OnSelect(Self);
      // Singleplayer options
      if Reg.ValueExists('SingleplayerOptions') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('SingleplayerOptions');
          Reg.ReadBinaryData('SingleplayerOptions', PByte(Stream.Memory)^, Stream.Size);
          UDLValuesListS.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;
      // Common options
      if Reg.ValueExists('CommonOptions') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('CommonOptions');
          Reg.ReadBinaryData('CommonOptions', PByte(Stream.Memory)^, Stream.Size);
          UDLValuesListC.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;
      // Client Multiplayer options
      if Reg.ValueExists('MultiplayerOptionsClient') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('MultiplayerOptionsClient');
          Reg.ReadBinaryData('MultiplayerOptionsClient', PByte(Stream.Memory)^, Stream.Size);
          UDLValuesListM_C.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;
      // Server Multiplayer options
      if Reg.ValueExists('MultiplayerOptionsServer') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('MultiplayerOptionsServer');
          Reg.ReadBinaryData('MultiplayerOptionsServer', PByte(Stream.Memory)^, Stream.Size);
          UDLValuesListM_S.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;

      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  UDLVisualListS.LoadFromValuesList(UDLValuesListS);
  UDLVisualListC.LoadFromValuesList(UDLValuesListC);
  UDLVisualListM_C.LoadFromValuesList(UDLValuesListM_C);
  UDLVisualListM_S.LoadFromValuesList(UDLValuesListM_S);
  //Edt_DoomPorts.OnSelect(Self);
  LB_IWADS.OnClick(Self);
end;

procedure TFmMain.LoadConfigList;
var
  Reg: TRegistry;
begin
  CB_Config.Items.Clear;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(RegKey + '\Configs') then
    begin
      Reg.OpenKey(RegKey + '\Configs', False);
      Reg.GetKeyNames(CB_Config.Items);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFmMain.LoadHashesFromIni;
var
  Ini: TMemIniFile;
  Sections: TStringList;
  i, j, k: Integer;
begin
  Ini := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + 'WADsHashes.ini', TEncoding.UTF8);
  try
    Sections := TStringList.Create;
    try
      Ini.ReadSections(Sections);
      j := 0;
      for i := 0 to Sections.Count - 1 do
      begin
        k := 0;
        while Ini.ValueExists(Sections[i], 'hash' + IntToStr(k)) do
        begin
          SetLength(Hashes, j + 1);
          Hashes[j].Hash := Ini.ReadString(Sections[i], 'hash' + IntToStr(k), '0');
          Hashes[j].Version := Sections[i] + ' ' + Ini.ReadString(Sections[i], 'ver' + IntToStr(k), '');
          Inc(j);
          Inc(k);
        end;
      end;
    finally
      Sections.Free;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TFmMain.LoadOptionsFromConfig;
var
  Path: string;
begin
  Path := ExtractFilePath(ParamStr(0));
  UDLSettingsListC.LoadFrom(Path + 'Common.config');
  UDLVisualListC.CreateFromSettingsList(UDLSettingsListC);
  UDLVisualListC.Parent := SB_Common;
  UDLSettingsListS.LoadFrom(Path + 'Singleplayer.config');
  UDLVisualListS.CreateFromSettingsList(UDLSettingsListS);
  UDLVisualListS.Parent := SB_Singleplayer;
  UDLSettingsListM_C.LoadFrom(Path + 'MultiplayerClient.config');
  UDLVisualListM_C.CreateFromSettingsList(UDLSettingsListM_C);
  UDLVisualListM_C.Parent := SB_Multiplayer_C;
  UDLSettingsListM_S.LoadFrom(Path + 'MultiplayerServer.config');
  UDLVisualListM_S.CreateFromSettingsList(UDLSettingsListM_S);
  UDLVisualListM_S.Parent := SB_Multiplayer_S;
end;

procedure TFmMain.LoadSettings;
var
  Reg: TRegistry;
  i: Integer;
  Stream: TTypedStream;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(RegKey) then
    begin
      Reg.OpenKey(RegKey, False);
      // Doom Ports
      if Reg.ValueExists('DoomPorts') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('DoomPorts');
          Reg.ReadBinaryData('DoomPorts', PByte(Stream.Memory)^, Stream.Size);
          DoomPorts.LoadFromStream(Stream);
          for i := 0 to DoomPorts.List.Count - 1 do
            Edt_DoomPorts.Items.Add(TDoomPort(DoomPorts.List[i]).PortName);
        finally
          Stream.Free;
        end;
      end;
      // IWADs
      if Reg.ValueExists('IWADs') then
      begin
        Stream := TTypedStream.Create;
        try
          Stream.Size := Reg.GetDataSize('IWADs');
          Reg.ReadBinaryData('IWADs', PByte(Stream.Memory)^, Stream.Size);
          IWADs.LoadFromStream(Stream);
          for i := 0 to IWADs.List.Count - 1 do
            LB_IWADS.Items.Add(TIWAD(IWADs.List[i]).Descr);
        finally
          Stream.Free;
        end;
      end;
      // PWads
      if Reg.ValueExists('ActivePWADPage') then
        PG_PWADs.ActivePageIndex := Reg.ReadInteger('ActivePWADPage');
      // Options
      if Reg.ValueExists('ActiveOptionsPage') then
        PG_Options.ActivePageIndex := Reg.ReadInteger('ActiveOptionsPage');
      // Master Server Frame Settings
      MasterServerFrame.LoadSettings(Reg);
      // Language
      if Reg.ValueExists('LanguagePack') then
        FLocale := Reg.ReadInteger('LanguagePack')
      else
        FLocale := GetThreadLocale;
      //
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFmMain.MI_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFmMain.MouseWheelHandler(var Message: TMessage);
var
  Control: TControl;
begin
  Control := FindVCLWindow(Mouse.CursorPos);
  if Assigned(Control) then
  begin
    Message.Result := Control.Perform(CM_MOUSEWHEEL, Message.WParam, Message.LParam);
    Message.Result := 1;
  end else
  inherited MouseWheelHandler(Message);
end;

procedure TFmMain.MoveIWAD(FromIndex, ToIndex: Integer);
begin
  FromIndex := Min(Max(FromIndex, 0), LB_IWADS.Items.Count - 1);
  ToIndex := Min(Max(ToIndex, 0), LB_IWADS.Items.Count - 1);
  LB_IWADS.Items.Move(FromIndex, ToIndex);
  IWADs.List.Move(FromIndex, ToIndex);
  LB_IWADS.ItemIndex := ToIndex;
  LB_IWADS.OnClick(Self);
end;

procedure TFmMain.MovePWAD(FromIndex, ToIndex: Integer);
var
  LB: TCheckListBox;
  WL: TPWADsList;
begin
  LB := GetCurrentPWADLB;
  WL := GetCurrentPWADList;
  FromIndex := Min(Max(FromIndex, 0), LB.Items.Count - 1);
  ToIndex := Min(Max(ToIndex, 0), LB.Items.Count - 1);
  LB.Items.Move(FromIndex, ToIndex);
  WL.List.Move(FromIndex, ToIndex);
  LB.ItemIndex := ToIndex;
end;

procedure TFmMain.OnException(Sender: TObject; E: Exception);
var
  SL: TStringList;
  FileName: string;
begin
  FileName := Application.ExeName + ' Error.txt';
  SL := TStringList.Create;
  try
    SL.Add(E.Message);
    SL.Add('E.ClassName: ' + E.ClassName);
    SL.Add('E.ClassType.ClassName: ' + E.ClassType.ClassName);
    SL.Add('Стек вызова:');
    JclLastExceptStackListToStrings(SL, False, True, True);
    SL.Add('Конец стека вызова.');
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
  MessageBox(Application.Handle, PChar(E.Message + #13#10 + 'Отчёт сохранён в файл ' + FileName), 'Ошибка', MB_ICONERROR or MB_OK);
end;

procedure TFmMain.OnShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  Pos: TPoint;
  k: Integer;
begin
  if HintInfo.HintControl = LB_IWADs then
  begin
    Pos := Mouse.CursorPos;
    Pos := LB_IWADs.ScreenToClient(Pos);
    k := LB_IWADs.ItemAtPos(Pos, False);
    if (k > -1) and (k < LB_IWADs.Count) then
      HintStr := TIWAD(IWADs.List[k]).FileName
    else
      HintStr := '';
  end;
end;

procedure TFmMain.OnWinSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: Integer);
begin
  FormatSettings.DecimalSeparator := '.';
end;

procedure TFmMain.PWADLB2WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
  begin
    DropFiles(Message.WParam, LB_PWADsForIWAD);
    Message.Result := 1;
  end else
    FPWADLB2WndProc(Message);
end;

procedure TFmMain.PWADLBWndProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
  begin
    DropFiles(Message.WParam, LB_PWADs);
    Message.Result := 1;
  end else
    FPWADLBWndProc(Message);
end;

procedure TFmMain.SaveConfig(const ConfigName: string);
var
  Reg: TRegistry;
  Stream: TTypedStream;
begin
  Reg := TRegistry.Create(KEY_WRITE + KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(RegKey + '\' + ConfigName, True);
    // Doom Ports
    Reg.WriteInteger('ActivePort', Edt_DoomPorts.ItemIndex);
    // PWADs
    Stream := TTypedStream.Create;
    try
      PWADs.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('PWADs', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    Reg.WriteInteger('ActivePWAD', LB_PWADs.ItemIndex);
    Reg.WriteInteger('ActivePWADForIWAD', LB_PWADsForIWAD.ItemIndex);
    // IWADs
    Reg.WriteInteger('ActiveIWAD', LB_IWADs.ItemIndex);
    // Params
    Reg.WriteString('Params', Edt_Params.Text);
    // Options
    Reg.WriteInteger('GameType', CB_GameMode.ItemIndex);
    // Common options
    UDLVisualListC.SaveToValuesList(UDLValuesListC);
    Stream := TTypedStream.Create;
    try
      UDLValuesListC.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('CommonOptions', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    // Single player options
    UDLVisualListS.SaveToValuesList(UDLValuesListS);
    Stream := TTypedStream.Create;
    try
      UDLValuesListS.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('SingleplayerOptions', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    // Client Multiplayer options
    UDLVisualListM_C.SaveToValuesList(UDLValuesListM_C);
    Stream := TTypedStream.Create;
    try
      UDLValuesListM_C.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('MultiplayerOptionsClient', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    // Server Multiplayer options
    UDLVisualListM_S.SaveToValuesList(UDLValuesListM_S);
    Stream := TTypedStream.Create;
    try
      UDLValuesListM_S.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('MultiplayerOptionsServer', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;

    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure TFmMain.SaveSettings;
var
  Reg: TRegistry;
  Stream: TTypedStream;
begin
  Reg := TRegistry.Create(KEY_WRITE + KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(RegKey, True);
    // Doom Ports
    Stream := TTypedStream.Create;
    try
      DoomPorts.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('DoomPorts', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    // IWADs
    Stream := TTypedStream.Create;
    try
      IWADs.SaveToStream(Stream);
      Stream.Position := 0;
      Reg.WriteBinaryData('IWADs', PByte(Stream.Memory)^, Stream.Size);
    finally
      Stream.Free;
    end;
    Reg.WriteInteger('ActivePWADPage', PG_PWADs.ActivePageIndex);
    // Options
    Reg.WriteInteger('ActiveOptionsPage', PG_Options.ActivePageIndex);
    // Master Server Frame Settings
    MasterServerFrame.SaveSettings(Reg);
    // Language
    Reg.WriteInteger('LanguagePack', FLocale);
    //
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
  SaveConfig('CurrentConfig');
end;

procedure TFmMain.UpdateListsCaptions;
begin
  UDLVisualListS.UpdateCaptions;
  UDLVisualListC.UpdateCaptions;
  UDLVisualListM_C.UpdateCaptions;
  UDLVisualListM_S.UpdateCaptions;
end;

initialization
  Include(JclStackTrackingOptions, stRawMode);
  JclStartExceptionTracking;
  LanguagePacksManager.RegisterForm(TFmMain);
  LanguagePacksManager.RegisterForm(TfmLanguage);
  LanguagePacksManager.RegisterForm(TfmMessage);
  RegisterClass(TDoomPort);
  RegisterClass(TIWAD);
  RegisterClass(TPWAD);
  RegisterClass(TPWADsList);

end.




