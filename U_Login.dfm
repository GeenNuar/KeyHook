object LoginForm: TLoginForm
  Left = 414
  Top = 415
  Width = 251
  Height = 180
  BorderIcons = []
  Caption = 'KeysRecorder'
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
    Width = 235
    Height = 141
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxlytsknlkndfl
    DesignSize = (
      235
      141)
    object Btn_Cancel: TcxButton
      Left = 133
      Top = 185
      Width = 75
      Height = 25
      Cancel = True
      Caption = #21462#28040'(&C)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = Btn_CancelClick
    end
    object Btn_Login: TcxButton
      Left = 52
      Top = 185
      Width = 75
      Height = 25
      Caption = #30331#24405'(&L)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = Btn_LoginClick
    end
    object cxtxtdt_UserName: TcxTextEdit
      Left = 85
      Top = -36
      Hint = #35831#36755#20837#29992#25143#21517
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
      Top = -10
      Hint = #35831#36755#20837#29992#25143#23494#30721
      AutoSize = False
      ParentShowHint = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 121
    end
    object cxtxtdt_DBName: TcxTextEdit
      Left = 85
      Top = 42
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 5
      Width = 113
    end
    object cxtxtdt_DBSvr: TcxTextEdit
      Left = 85
      Top = 68
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 6
      Width = 113
    end
    object cxtxtdt_DBUserName: TcxTextEdit
      Left = 85
      Top = 120
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 8
      Width = 113
    end
    object cxtxtdt_DBUserPass: TcxTextEdit
      Left = 85
      Top = 146
      ParentShowHint = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      ShowHint = True
      Style.HotTrack = False
      TabOrder = 9
      Width = 113
    end
    object rbConnSQLite: TcxRadioButton
      Left = 20
      Top = 16
      Width = 90
      Height = 20
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'SQLite'
      Checked = True
      Color = 16053234
      ParentColor = False
      TabOrder = 2
      TabStop = True
      OnClick = rbConnSQLiteClick
      Transparent = True
    end
    object rbConnMySQL: TcxRadioButton
      Left = 77
      Top = 16
      Width = 90
      Height = 20
      Caption = 'MySQL'
      Color = 16053234
      ParentColor = False
      TabOrder = 3
      OnClick = rbConnMySQLClick
      Transparent = True
    end
    object rbConnOracle: TcxRadioButton
      Left = 134
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Oracle'
      Color = 16053234
      ParentColor = False
      TabOrder = 4
      OnClick = rbConnOracleClick
      Transparent = True
    end
    object cxspndt_DBPort: TcxSpinEdit
      Left = 85
      Top = 94
      Align = alClient
      ParentShowHint = False
      Properties.AssignedValues.MinValue = True
      Properties.MaxValue = 65535.000000000000000000
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
    object dxlytm_ConnSQLite: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Config
      Control = rbConnSQLite
      ControlOptions.AutoColor = True
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxlytm_ConnMySQL: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Config
      Control = rbConnMySQL
      ControlOptions.AutoColor = True
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxlytm_ConnOracle: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Parent = dxlytgrp_Config
      Control = rbConnOracle
      ControlOptions.AutoColor = True
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxlytm_DBPort: TdxLayoutItem
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #31471#21475#65306
      Parent = dxlytgrp_DB
      Control = cxspndt_DBPort
      ControlOptions.ShowBorder = False
      Index = 2
    end
  end
  object dxlytlkndflst: TdxLayoutLookAndFeelList
    Left = 75
    Top = 34
    object dxlytsknlkndfl: TdxLayoutSkinLookAndFeel
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = 'UserSkin'
    end
  end
  object actlst: TActionList
    Left = 43
    Top = 34
    object actValidateUser: TAction
      Caption = 'actValidateUser'
      OnExecute = actValidateUserExecute
    end
  end
  object ZConn: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = False
    Port = 0
    Left = 139
    Top = 34
  end
  object ZQry: TZQuery
    Params = <>
    Left = 171
    Top = 34
  end
  object dxskncntrlr: TdxSkinController
    Kind = lfOffice11
    NativeStyle = False
    SkinName = 'UserSkin'
    Left = 107
    Top = 34
  end
end
