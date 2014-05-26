object LoginForm: TLoginForm
  Left = 443
  Top = 241
  Width = 259
  Height = 180
  BorderIcons = []
  Caption = #30331#38470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxlytcntrl: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 251
    Height = 146
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxlytsknlkndfl
    object Btn_Cancel: TcxButton
      Left = 149
      Top = 244
      Width = 75
      Height = 25
      Caption = #21462#28040'(&C)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = Btn_CancelClick
      Align = alClient
    end
    object Btn_Login: TcxButton
      Left = 68
      Top = 244
      Width = 75
      Height = 25
      Caption = #30331#24405'(&L)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = Btn_LoginClick
      Align = alClient
    end
    object cxtxtdt_UserName: TcxTextEdit
      Left = 85
      Top = 23
      Hint = #35831#36755#20837#29992#25143#21517
      Align = alClient
      AutoSize = False
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 0
      Height = 21
      Width = 121
    end
    object cxtxtdt_UserPass: TcxTextEdit
      Left = 85
      Top = 49
      Hint = #35831#36755#20837#29992#25143#23494#30721
      Align = alClient
      AutoSize = False
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 121
    end
    object cxchckbx_ConfigDB: TcxCheckBox
      Left = 20
      Top = 75
      Hint = #22635#20889#36830#25509'MySQL'#25968#25454#24211#25152#38656#30340#20449#24687
      Align = alClient
      AutoSize = False
      Caption = #37197#32622#25968#25454#24211#36830#25509
      ParentShowHint = False
      Properties.Alignment = taLeftJustify
      Properties.OnChange = cxchckbx_ConfigDBPropertiesChange
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 2
      Transparent = True
      Height = 20
      Width = 105
    end
    object cxtxtdt_DBName: TcxTextEdit
      Left = 85
      Top = 101
      Hint = #20351#29992#30340#25968#25454#24211#21517#31216#40664#35748#20026'testdb'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 3
      Width = 121
    end
    object cxtxtdt_DBSvr: TcxTextEdit
      Left = 85
      Top = 127
      Hint = 'MySQL'#25968#25454#24211#26381#21153#22120'IP'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 4
      Width = 121
    end
    object cxtxtdt_DBPort: TcxTextEdit
      Left = 85
      Top = 153
      Hint = 'MySQL'#25968#25454#24211#26381#21153#22120#31471#21475
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 5
      Width = 121
    end
    object cxtxtdt_DBUserName: TcxTextEdit
      Left = 85
      Top = 179
      Hint = #36830#25509#25968#25454#24211#25152#29992#30340#36134#25143#21517#40664#35748#20026'root'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 6
      Width = 121
    end
    object cxtxtdt_DBUserPass: TcxTextEdit
      Left = 85
      Top = 205
      Hint = #36830#25509#25968#25454#24211#25152#29992#30340#36134#25143#23494#30721#40664#35748#20026#31354
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 7
      Width = 121
    end
    object dxlytgrp_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxlytm_No: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Btn
      Control = Btn_Cancel
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxlytm_Yes: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Btn
      Control = Btn_Login
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxlytmItem_UserName: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #29992#25143#21517'    '#65306
      Parent = dxlytgrp_Top
      Control = cxtxtdt_UserName
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxlytmItem_UserPass: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #29992#25143#23494#30721#65306
      Parent = dxlytgrp_Top
      Control = cxtxtdt_UserPass
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxlytgrp_Btn: TdxLayoutGroup
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      Parent = dxlytgrp_Root
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxlytgrp_Login: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Parent = dxlytgrp_Root
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object dxlytm_Checkbox: TdxLayoutItem
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Config
      Control = cxchckbx_ConfigDB
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxlytm_DBName: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #25968#25454#24211#65306
      Parent = dxlytgrp_DB
      Control = cxtxtdt_DBName
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxlytm_Svr: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #26381#21153#22120#65306
      Parent = dxlytgrp_DB
      Control = cxtxtdt_DBSvr
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxlytm_Port: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #31471#21475#65306
      Parent = dxlytgrp_DB
      Control = cxtxtdt_DBPort
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxlytm_DBUserName: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #36134#25143#21517#65306
      Parent = dxlytgrp_DB
      Control = cxtxtdt_DBUserName
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxlytm_DBUserPass: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #36134#25143#23494#30721#65306
      Parent = dxlytgrp_DB
      Control = cxtxtdt_DBUserPass
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxlytgrp_DB: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      Parent = dxlytgrp_Login
      Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxlytgrp_Top: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      Parent = dxlytgrp_Login
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object dxlytgrp_Config: TdxLayoutGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      Parent = dxlytgrp_Top
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
  end
  object dxskncntrlr: TdxSkinController
    Kind = lfOffice11
    NativeStyle = False
    SkinName = 'UserSkin'
    Left = 144
    Top = 65
  end
  object dxlytlkndflst: TdxLayoutLookAndFeelList
    Left = 112
    Top = 65
    object dxlytsknlkndfl: TdxLayoutSkinLookAndFeel
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = 'UserSkin'
    end
  end
  object con_ADO: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data' +
      ' Source=MySQLODBC;Initial Catalog=testdb'
    DefaultDatabase = 'testdb'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 48
    Top = 65
  end
  object ds_ADO: TADODataSet
    Connection = con_ADO
    Parameters = <>
    Left = 80
    Top = 65
  end
  object actlst: TActionList
    Left = 16
    Top = 65
    object actValidateUser: TAction
      Caption = 'actValidateUser'
      OnExecute = actValidateUserExecute
    end
  end
end
