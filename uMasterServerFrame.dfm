object MasterServerFrame: TMasterServerFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 478
  TabOrder = 0
  object Lbl_Count: TLabel
    Tag = 666
    AlignWithMargins = True
    Left = 1
    Top = 464
    Width = 598
    Height = 13
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Align = alBottom
    Caption = #1042#1089#1077#1075#1086': 0'
    Layout = tlCenter
    ExplicitWidth = 41
  end
  object Pnl_Top: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 66
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Tag = 666
      Left = 25
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object LV_Servers: TListView
    Tag = 666
    Left = 0
    Top = 66
    Width = 600
    Height = 397
    Align = alClient
    Columns = <>
    FullDrag = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = LV_ServersColumnClick
    OnColumnRightClick = LV_ServersColumnRightClick
    OnData = LV_ServersData
  end
  object ColsPopupMenu: TPopupMenu
    Left = 40
    Top = 115
  end
end
