object FmMain: TFmMain
  Left = 0
  Top = 0
  BorderWidth = 1
  Caption = 'FmMain'
  ClientHeight = 525
  ClientWidth = 633
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 576
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    633
    525)
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_ExeFile: TLabel
    Left = 0
    Top = 34
    Width = 633
    Height = 13
    Align = alTop
    Caption = #1055#1086#1088#1090' Doom'#39#1072
    ExplicitWidth = 64
  end
  object Lbl_Config: TLabel
    Left = 0
    Top = 0
    Width = 633
    Height = 13
    Align = alTop
    Caption = #1055#1088#1086#1092#1080#1083#1100
    ExplicitWidth = 46
  end
  object Lbl_Params: TLabel
    Left = 0
    Top = 463
    Width = 148
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
    ExplicitTop = 462
  end
  object Edt_Params: TEdit
    AlignWithMargins = True
    Left = 0
    Top = 477
    Width = 633
    Height = 21
    Margins.Left = 0
    Margins.Top = 16
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    TabOrder = 1
  end
  object Pnl_Start: TPanel
    Left = 0
    Top = 498
    Width = 633
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      633
      27)
    object Btn_Start: TButton
      Left = 215
      Top = 2
      Width = 203
      Height = 25
      Action = ai_Start
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object Btn_ShowCmd: TButton
      Left = 527
      Top = 2
      Width = 106
      Height = 25
      Action = ai_ShowCmd
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Pnl_DoomPorts: TPanel
    Left = 0
    Top = 47
    Width = 633
    Height = 21
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object Edt_DoomPorts: TComboBox
      Tag = 666
      Left = 0
      Top = 0
      Width = 570
      Height = 21
      Align = alClient
      Style = csDropDownList
      TabOrder = 0
      OnSelect = Edt_DoomPortsSelect
    end
    object Btn_DeletePort: TButton
      Left = 591
      Top = 0
      Width = 21
      Height = 21
      Action = ai_DeletePort
      Align = alRight
      TabOrder = 2
    end
    object Btn_EditPort: TButton
      Left = 612
      Top = 0
      Width = 21
      Height = 21
      Action = ai_EditPort
      Align = alRight
      TabOrder = 3
    end
    object Btn_AddPort: TButton
      Left = 570
      Top = 0
      Width = 21
      Height = 21
      Action = ai_AddPort
      Align = alRight
      TabOrder = 1
    end
  end
  object PG_Options: TPageControl
    Left = 0
    Top = 93
    Width = 633
    Height = 368
    ActivePage = TS_WADs
    Align = alClient
    TabOrder = 3
    object TS_WADs: TTabSheet
      Caption = #1060#1072#1081#1083#1099
      object SplitterWADs: TSplitter
        Left = 310
        Top = 0
        Width = 5
        Height = 340
        Align = alRight
        AutoSnap = False
        Beveled = True
        ExplicitHeight = 337
      end
      object Pnl_PWADs: TPanel
        Left = 315
        Top = 0
        Width = 310
        Height = 340
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Pnl_PWADButtons: TPanel
          Left = 0
          Top = 313
          Width = 310
          Height = 27
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            310
            27)
          object Btn_DeletePWAD: TButton
            Left = 93
            Top = 1
            Width = 88
            Height = 25
            Action = ai_DeletePWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 1
          end
          object Btn_AddPWAD: TButton
            Left = 1
            Top = 1
            Width = 93
            Height = 25
            Action = ai_AddPWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 0
          end
          object Btn_UpPWAD: TButton
            Left = 180
            Top = 1
            Width = 50
            Height = 25
            Action = ai_MoveUpPWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 2
          end
          object Btn_DownPWAD: TButton
            Left = 229
            Top = 1
            Width = 50
            Height = 25
            Action = ai_MoveDownPWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 3
          end
        end
        object PG_PWADs: TPageControl
          Left = 0
          Top = 0
          Width = 310
          Height = 313
          ActivePage = TS_Common
          Align = alClient
          MultiLine = True
          TabOrder = 1
          object TS_Common: TTabSheet
            Caption = #1054#1073#1097#1080#1077' PWAD'
            object LB_PWADs: TCheckListBox
              Tag = 666
              Left = 0
              Top = 0
              Width = 302
              Height = 285
              OnClickCheck = LB_PWADsClickCheck
              Align = alClient
              DragMode = dmAutomatic
              ItemHeight = 13
              TabOrder = 0
              OnDragDrop = LB_PWADsDragDrop
              OnDragOver = LB_WADsDragOver
            end
          end
          object TS_ForIWAD: TTabSheet
            Caption = 'PWAD '#1076#1083#1103' IWAD'
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object LB_PWADsForIWAD: TCheckListBox
              Tag = 666
              Left = 0
              Top = 0
              Width = 302
              Height = 285
              OnClickCheck = LB_PWADsClickCheck
              Align = alClient
              DragMode = dmAutomatic
              ItemHeight = 13
              TabOrder = 0
              OnDragDrop = LB_PWADsDragDrop
              OnDragOver = LB_WADsDragOver
            end
          end
        end
      end
      object Pnl_IWADs: TPanel
        Left = 0
        Top = 0
        Width = 310
        Height = 340
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Lbl_IWADs: TLabel
          Left = 0
          Top = 0
          Width = 310
          Height = 24
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          AutoSize = False
          Caption = 'IWAD'
          Layout = tlCenter
        end
        object LB_IWADs: TListBox
          Tag = 666
          Left = 0
          Top = 24
          Width = 310
          Height = 289
          Hint = '12345'
          Align = alClient
          DragMode = dmAutomatic
          ItemHeight = 13
          PopupMenu = PopupMenu
          TabOrder = 0
          OnClick = LB_IWADsClick
          OnDragDrop = LB_IWADsDragDrop
          OnDragOver = LB_WADsDragOver
        end
        object Pnl_IWADButtons: TPanel
          Left = 0
          Top = 313
          Width = 310
          Height = 27
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            310
            27)
          object Btn_DeleteIWAD: TButton
            Left = 93
            Top = 1
            Width = 88
            Height = 25
            Action = ai_DeleteIWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 1
          end
          object Btn_AddIWAD: TButton
            Left = 0
            Top = 1
            Width = 93
            Height = 25
            Action = ai_AddIWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 0
          end
          object Btn_UpIWAD: TButton
            Left = 180
            Top = 1
            Width = 50
            Height = 25
            Action = ai_MoveUpIWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 2
          end
          object Btn_DownIWAD: TButton
            Left = 229
            Top = 1
            Width = 50
            Height = 25
            Action = ai_MoveDownIWAD
            Anchors = [akLeft, akBottom]
            TabOrder = 3
          end
        end
      end
    end
    object TS_Main: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TS_SinglePlayer: TTabSheet
      Caption = 'Single player'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TS_Multiplayer_C: TTabSheet
      Caption = #1050#1083#1080#1077#1085#1090' - Multiplayer'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TS_Multiplayer_S: TTabSheet
      Caption = #1057#1077#1088#1074#1077#1088' - Multiplayer'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TS_MasterServer: TTabSheet
      Caption = #1052#1072#1089#1090#1077#1088'-'#1089#1077#1088#1074#1077#1088
      ImageIndex = 5
      inline MasterServerFrame: TMasterServerFrame
        Left = 0
        Top = 0
        Width = 625
        Height = 340
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 625
        ExplicitHeight = 340
        inherited Lbl_Count: TLabel
          Top = 326
          Width = 623
          ExplicitTop = 326
          ExplicitWidth = 42
        end
        inherited Pnl_Top: TPanel
          Width = 625
          ExplicitWidth = 625
        end
        inherited LV_Servers: TListView
          Width = 625
          Height = 259
          ExplicitWidth = 625
          ExplicitHeight = 259
        end
      end
    end
  end
  object Pnl_GameType: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 70
    Width = 633
    Height = 21
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 2
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 4
    object Lbl_GameType: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 63
      Height = 18
      Margins.Left = 0
      Margins.Top = 0
      Align = alLeft
      Caption = #1056#1077#1078#1080#1084' '#1080#1075#1088#1099
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object CB_GameMode: TComboBox
      Left = 66
      Top = 0
      Width = 567
      Height = 21
      Align = alClient
      Style = csDropDownList
      TabOrder = 0
      OnSelect = CB_GameModeSelect
      Items.Strings = (
        #1054#1076#1080#1085#1086#1095#1085#1072#1103' '#1080#1075#1088#1072' (Single Player)'
        #1050#1083#1080#1077#1085#1090' - '#1057#1077#1090#1077#1074#1072#1103' '#1080#1075#1088#1072' (Multiplayer)'
        #1057#1077#1088#1074#1077#1088' - '#1057#1077#1090#1077#1074#1072#1103' '#1080#1075#1088#1072' (Multiplayer)')
    end
  end
  object Pnl_Config: TPanel
    Left = 0
    Top = 13
    Width = 633
    Height = 21
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 5
    object CB_Config: TComboBox
      Tag = 666
      Left = 0
      Top = 0
      Width = 591
      Height = 21
      Align = alClient
      AutoComplete = False
      TabOrder = 0
      OnSelect = CB_ConfigSelect
    end
    object Btn_SaveConfig: TButton
      Left = 591
      Top = 0
      Width = 21
      Height = 21
      Action = ai_SaveConfig
      Align = alRight
      TabOrder = 1
    end
    object Btn_DeleteConfig: TButton
      Left = 612
      Top = 0
      Width = 21
      Height = 21
      Action = ai_DeleteConfig
      Align = alRight
      TabOrder = 2
    end
  end
  object OpenPWAD: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|'#1056#1077#1089#1091#1088#1089#1099' Doom (*.PK3; *.WAD)|*.PK3;*.WAD'
    FilterIndex = 2
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 105
    Top = 220
  end
  object ActionList: TActionList
    Left = 105
    Top = 275
    object ai_AddPWAD: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' PWAD'
      OnExecute = ai_AddPWADExecute
      OnUpdate = ai_AddPWADUpdate
    end
    object ai_DeletePWAD: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' PWAD'
      OnExecute = ai_DeletePWADExecute
      OnUpdate = ai_DeletePWADUpdate
    end
    object ai_Start: TAction
      Caption = #1047#1072#1087#1091#1089#1082'!'
      OnExecute = ai_StartExecute
      OnUpdate = ai_StartUpdate
    end
    object ai_MoveUpPWAD: TAction
      Caption = #1042#1074#1077#1088#1093
      OnExecute = ai_MoveUpPWADExecute
      OnUpdate = ai_MoveUpPWADUpdate
    end
    object ai_MoveDownPWAD: TAction
      Caption = #1042#1085#1080#1079
      OnExecute = ai_MoveDownPWADExecute
      OnUpdate = ai_MoveDownPWADUpdate
    end
    object ai_About: TAction
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnExecute = ai_AboutExecute
    end
    object ai_MoveUpIWAD: TAction
      Caption = #1042#1074#1077#1088#1093
      OnExecute = ai_MoveUpIWADExecute
      OnUpdate = ai_MoveUpIWADUpdate
    end
    object ai_MoveDownIWAD: TAction
      Caption = #1042#1085#1080#1079
      OnExecute = ai_MoveDownIWADExecute
      OnUpdate = ai_MoveDownIWADUpdate
    end
    object ai_DeleteIWAD: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' IWAD'
      OnExecute = ai_DeleteIWADExecute
      OnUpdate = ai_DeleteIWADUpdate
    end
    object ai_AddIWAD: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' IWAD'
      OnExecute = ai_AddIWADExecute
    end
    object ai_CheckIWAD: TAction
      Caption = #1055#1086#1074#1090#1086#1088#1085#1086#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077
      OnExecute = ai_CheckIWADExecute
      OnUpdate = ai_CheckIWADUpdate
    end
    object ai_ShowCmd: TAction
      Caption = #1057#1090#1088#1086#1082#1072' '#1079#1072#1087#1091#1089#1082#1072'...'
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1090#1088#1086#1082#1091' '#1079#1072#1087#1091#1089#1082#1072
      OnExecute = ai_ShowCmdExecute
      OnUpdate = ai_ShowCmdUpdate
    end
    object ai_AddPort: TAction
      Caption = '+'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1088#1090
      OnExecute = ai_AddPortExecute
    end
    object ai_DeletePort: TAction
      Caption = '-'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1086#1088#1090
      OnExecute = ai_DeletePortExecute
      OnUpdate = ai_DeletePortUpdate
    end
    object ai_EditPort: TAction
      Caption = '...'
      Hint = #1042#1099#1073#1088#1072#1090#1100' exe '#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1086#1088#1090#1072
      OnExecute = ai_EditPortExecute
      OnUpdate = ai_EditPortUpdate
    end
    object ai_SaveConfig: TAction
      Caption = '+'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
      OnExecute = ai_SaveConfigExecute
      OnUpdate = ai_SaveConfigUpdate
    end
    object ai_DeleteConfig: TAction
      Caption = '-'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
      OnExecute = ai_DeleteConfigExecute
      OnUpdate = ai_DeleteConfigUpdate
    end
    object ai_Language: TAction
      Caption = #1071#1079#1099#1082
      OnExecute = ai_LanguageExecute
    end
  end
  object MainMenu: TMainMenu
    Left = 40
    Top = 275
    object MI_File: TMenuItem
      Caption = #1060#1072#1081#1083
      object MI_AddIWAD: TMenuItem
        Action = ai_AddIWAD
      end
      object MI_DeleteIWAD: TMenuItem
        Action = ai_DeleteIWAD
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MI_AddPWAD: TMenuItem
        Action = ai_AddPWAD
      end
      object MI_DeletePWAD: TMenuItem
        Action = ai_DeletePWAD
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MI_Exit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = MI_ExitClick
      end
    end
    object MI_Language: TMenuItem
      Action = ai_Language
    end
    object MI_Help: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object MI_About: TMenuItem
        Action = ai_About
      end
    end
  end
  object OpenIWAD: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|'#1056#1077#1089#1091#1088#1089#1099' Doom (*.WAD)|*.WAD'
    FilterIndex = 2
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 40
    Top = 220
  end
  object PopupMenu: TPopupMenu
    Left = 105
    Top = 330
    object MI_CheckIWAD: TMenuItem
      Action = ai_CheckIWAD
    end
  end
  object OpenExe: TOpenDialog
    Filter = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1103' (*.exe)|*.exe|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 40
    Top = 330
  end
end
