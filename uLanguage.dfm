object fmLanguage: TfmLanguage
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1071#1079#1099#1082
  ClientHeight = 89
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    275
    89)
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_Language: TLabel
    Left = 45
    Top = 7
    Width = 26
    Height = 13
    Alignment = taRightJustify
    Caption = #1071#1079#1099#1082
  end
  object Cb_Language: TComboBox
    Tag = 666
    Left = 74
    Top = 4
    Width = 198
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnSelect = Cb_LanguageSelect
  end
  object Btn_GenerateLangPack: TButton
    Left = 3
    Top = 28
    Width = 269
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1103#1079#1099#1082#1086#1074#1086#1081' '#1087#1072#1082#1077#1090
    TabOrder = 1
    OnClick = Btn_GenerateLangPackClick
  end
  object Btn_OK: TButton
    Left = 48
    Top = 59
    Width = 85
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Btn_Cancel: TButton
    Left = 139
    Top = 59
    Width = 85
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'lng'
    Filter = #1071#1079#1099#1082#1086#1074#1099#1077' '#1087#1072#1082#1077#1090#1099' (*.lng)|*.lng|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 10
    Top = 5
  end
end
