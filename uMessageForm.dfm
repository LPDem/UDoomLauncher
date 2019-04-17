object fmMessage: TfmMessage
  Left = 0
  Top = 0
  ClientHeight = 293
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 426
    Height = 266
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Pnl_Bottom: TPanel
    Left = 0
    Top = 266
    Width = 426
    Height = 27
    Align = alBottom
    AutoSize = True
    TabOrder = 1
    DesignSize = (
      426
      27)
    object Btn_SaveBat: TButton
      Left = 310
      Top = 1
      Width = 115
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1079#1076#1072#1090#1100' .bat '#1092#1072#1081#1083
      TabOrder = 0
      OnClick = Btn_SaveBatClick
    end
  end
  object SaveBat: TSaveDialog
    DefaultExt = 'bat'
    Filter = #1055#1072#1082#1077#1090#1085#1099#1077' '#1092#1072#1081#1083#1099' (*.bat)|*.bat|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 45
    Top = 25
  end
end
