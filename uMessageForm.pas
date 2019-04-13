unit uMessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmMessage = class(TForm)
    Memo: TMemo;
    Pnl_Bottom: TPanel;
    Btn_SaveBat: TButton;
    SaveBat: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Btn_SaveBatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    class procedure ShowText(const AText, ACaption: string);
  end;

implementation

uses
  Registry, uMain, FormPlacement, LanguagePacks;

{$R *.dfm}

{ TfmMessage }

class procedure TfmMessage.ShowText(const AText, ACaption: string);
var
  Form: TfmMessage;
begin
  Form := TfmMessage.Create(Application);
  try
    Form.Caption := ACaption;
    Form.Memo.Text := AText;
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

procedure TfmMessage.Btn_SaveBatClick(Sender: TObject);
var
  SL: TStringList;
begin
  if SaveBat.Execute then
  begin
    SL := TStringList.Create;
    try
      SL.Add('@start "Doom" ' + Memo.Text);
      SL.SaveToFile(SaveBat.FileName);
    finally
      SL.Free;
    end;
  end;
end;

procedure TfmMessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormPlacement(Self);
end;

procedure TfmMessage.FormCreate(Sender: TObject);
begin
  LanguagePacksManager.ApplyToForm(Self);
end;

procedure TfmMessage.FormShow(Sender: TObject);
begin
  LoadFormPlacement(Self);
end;

end.
