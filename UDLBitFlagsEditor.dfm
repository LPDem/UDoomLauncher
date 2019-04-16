object fmUDLBitFlagsEditor: TfmUDLBitFlagsEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'fmUDLBitFlagsEditor'
  ClientHeight = 311
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_Desc: TLabel
    AlignWithMargins = True
    Left = 0
    Top = 2
    Width = 434
    Height = 13
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 2
    Align = alTop
    Alignment = taCenter
    Caption = 'Lbl_Desc'
    ExplicitWidth = 42
  end
  object Pnl_Buttons: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 285
    Width = 434
    Height = 25
    Margins.Left = 0
    Margins.Top = 1
    Margins.Right = 0
    Margins.Bottom = 1
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      434
      25)
    object Btn_OK: TButton
      Left = 263
      Top = 0
      Width = 85
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Btn_Cancel: TButton
      Left = 348
      Top = 0
      Width = 85
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object CheckListBox: TCheckListBox
    Left = 0
    Top = 17
    Width = 434
    Height = 267
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = CheckListBoxClick
    ExplicitHeight = 264
  end
end
