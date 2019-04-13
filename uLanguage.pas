unit uLanguage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmLanguage = class(TForm)
    Lbl_Language: TLabel;
    Cb_Language: TComboBox;
    Btn_GenerateLangPack: TButton;
    SaveDialog: TSaveDialog;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    procedure Btn_GenerateLangPackClick(Sender: TObject);
    procedure Cb_LanguageSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FLocale: Integer;
  public
    { Public declarations }
    class function EditLocale(var ALocale: Integer): Boolean;
  end;

implementation

uses
  LanguagePacks;

{$R *.dfm}

procedure TfmLanguage.Btn_GenerateLangPackClick(Sender: TObject);
var
  Stream: TFileStream;
  s: string;
begin
  if SaveDialog.Execute then
  begin
    s := LanguagePacksManager.GenerateLangPack;
    Stream := TFileStream.Create(SaveDialog.FileName, fmCreate);
    try
      Stream.WriteBuffer(s[1], Length(s));
    finally
      Stream.Free;
    end;
  end;
end;

procedure TfmLanguage.Cb_LanguageSelect(Sender: TObject);
var
  k: Integer;
begin
  k := Cb_Language.ItemIndex;
  if k <> - 1 then
  begin
    FLocale := LanguagePacksManager.LanguagePack[k].Locale;
    //LanguagePacksManager.SetActiveLanguagePack(FLocale, True);
    //LanguagePacksManager.ApplyToAllForms;
  end;
end;

class function TfmLanguage.EditLocale(var ALocale: Integer): Boolean;
var
  Form: TfmLanguage;
begin
  Form := TfmLanguage.Create(Application);
  try
    Form.FLocale := ALocale;
    Result := (Form.ShowModal = mrOk);
    if Result then
      ALocale := Form.FLocale;
  finally
    Form.Free;
  end;
end;

procedure TfmLanguage.FormCreate(Sender: TObject);
begin
  LanguagePacksManager.ApplyToForm(Self);
end;

procedure TfmLanguage.FormShow(Sender: TObject);
var
  i: Integer;
  s: string;
  k: Integer;
begin
  k := -1;
  LanguagePacksManager.EnumLanguagePacks;
  Cb_Language.Items.Clear;
  for i := 0 to LanguagePacksManager.LanguagePacksCount - 1 do
  begin
    s := LanguagePacksManager.LanguagePack[i].Name + ' (' + IntToStr(LanguagePacksManager.LanguagePack[i].Locale) + ')';
    Cb_Language.Items.AddObject(s, TObject(LanguagePacksManager.LanguagePack[i].Locale));
    if LanguagePacksManager.LanguagePack[i].Locale = FLocale then
      k := i;
  end;
  Cb_Language.ItemIndex := k;
end;

end.
