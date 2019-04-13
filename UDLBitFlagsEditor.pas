unit UDLBitFlagsEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDLSettings, StdCtrls, ExtCtrls, CheckLst;

type
  TfmUDLBitFlagsEditor = class(TForm)
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    CheckListBox: TCheckListBox;
    Lbl_Desc: TLabel;
    Pnl_Buttons: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckListBoxClick(Sender: TObject);
  private
    FSetting: TUDLSetting;
  public
    class function EditBitFlags(const Setting: TUDLSetting; var BitFlags: Integer): Boolean;
  end;

implementation

uses
  FormPlacement;

{$R *.dfm}

procedure TfmUDLBitFlagsEditor.CheckListBoxClick(Sender: TObject);
var
  k: Integer;
  FlagGroup: string;
  i: Integer;
begin
  k := CheckListBox.ItemIndex;
  if k = -1 then
    Exit;
  if not CheckListBox.Checked[k] then
    Exit;
  FlagGroup := FSetting.FlagGroups[k];
  if FlagGroup = '' then
    Exit;
  for i := 0 to FSetting.FlagGroups.Count - 1 do
    if (i <> k) and AnsiSameText(FSetting.FlagGroups[i], FlagGroup) then
      CheckListBox.Checked[i] := False;
end;

class function TfmUDLBitFlagsEditor.EditBitFlags(const Setting: TUDLSetting; var BitFlags: Integer): Boolean;
var
  Form: TfmUDLBitFlagsEditor;
  i, k: Integer;
  BitNum: Integer;
begin
  Form := TfmUDLBitFlagsEditor.Create(Application);
  try
    Form.FSetting := Setting;
    Form.Caption := Setting.TranslatedName;
    Form.Lbl_Desc.Caption := Setting.TranslatedDescription;
    for i := 0 to Setting.BitFlags.Count - 1 do
    begin
      k := Form.CheckListBox.Items.Add(Setting.TranslatedBitFlag(i));
      BitNum := Integer(Setting.BitFlags.Objects[i]);
      Form.CheckListBox.Checked[k] := (BitFlags and (1 shl BitNum)) <> 0;
    end;
    Result := Form.ShowModal = mrOk;
    if Result then
    begin
      BitFlags := 0;
      for i := 0 to Setting.BitFlags.Count - 1 do
      begin
        if Form.CheckListBox.Checked[i] then
        begin
          BitNum := Integer(Setting.BitFlags.Objects[i]);
          BitFlags := BitFlags or (1 shl BitNum);
        end;
      end;
    end;
  finally
    Form.Free;
  end;
end;

procedure TfmUDLBitFlagsEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormPlacement(Self);
end;

procedure TfmUDLBitFlagsEditor.FormShow(Sender: TObject);
begin
  LoadFormPlacement(Self);
end;

end.
