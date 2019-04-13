// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
// JCL_DEBUG_EXPERT_DELETEMAPFILE ON
program UDoomLauncher;

uses
  Forms,
  uMain in 'uMain.pas' {FmMain},
  MD5 in 'MD5.pas',
  DoomWAD in 'DoomWAD.pas',
  uMessageForm in 'uMessageForm.pas' {fmMessage},
  StreamedObjects in 'StreamedObjects.pas',
  TypedStream in 'TypedStream.pas',
  UDLSettings in 'UDLSettings.pas',
  UDLSettingsVisual in 'UDLSettingsVisual.pas',
  UDLSettingsValues in 'UDLSettingsValues.pas',
  UDLPorts in 'UDLPorts.pas',
  FormPlacement in 'FormPlacement.pas',
  WheelScrollOptimize in 'WheelScrollOptimize.pas',
  uMasterServerFrame in 'uMasterServerFrame.pas' {MasterServerFrame: TFrame},
  MasterServerThread in 'MasterServerThread.pas',
  uLanguage in 'uLanguage.pas' {fmLanguage},
  LanguagePacks in 'LanguagePacks.pas',
  UFileSearch in 'UFileSearch.pas',
  uResources in 'uResources.pas',
  EditWithButton in 'EditWithButton.pas',
  NumericEdit in 'NumericEdit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Universal Doom Launcher';
  Application.CreateForm(TFmMain, FmMain);
  Application.Run;
end.
