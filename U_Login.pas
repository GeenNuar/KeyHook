unit U_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Menus, dxLayoutControlAdapters, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutContainer, StdCtrls, cxButtons, ActnList,
  dxLayoutControl, cxCheckBox, dxLayoutLookAndFeels, dxSkinsForm, DB, ADODB,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinMcSkin,
  dxSkinPumpkin, cxRadioGroup, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxClasses, IniFiles;

type
  TLoginForm = class(TForm)
    dxlytgrp_Root: TdxLayoutGroup;
    dxlytcntrl: TdxLayoutControl;
    Btn_Cancel: TcxButton;
    dxlytm_No: TdxLayoutItem;
    Btn_Login: TcxButton;
    dxlytm_Yes: TdxLayoutItem;
    cxtxtdt_UserName: TcxTextEdit;
    dxlytmItem_UserName: TdxLayoutItem;
    cxtxtdt_UserPass: TcxTextEdit;
    dxlytmItem_UserPass: TdxLayoutItem;
    dxlytgrp_Btn: TdxLayoutGroup;
    dxlytgrp_Login: TdxLayoutGroup;
    cxtxtdt_DBName: TcxTextEdit;
    dxlytm_DBName: TdxLayoutItem;
    cxtxtdt_DBSvr: TcxTextEdit;
    dxlytm_Svr: TdxLayoutItem;
    cxtxtdt_DBPort: TcxTextEdit;
    dxlytm_Port: TdxLayoutItem;
    cxtxtdt_DBUserName: TcxTextEdit;
    dxlytm_DBUserName: TdxLayoutItem;
    cxtxtdt_DBUserPass: TcxTextEdit;
    dxlytm_DBUserPass: TdxLayoutItem;
    dxlytgrp_DB: TdxLayoutGroup;
    dxlytgrp_Top: TdxLayoutGroup;
    dxlytlkndflst: TdxLayoutLookAndFeelList;
    dxlytsknlkndfl: TdxLayoutSkinLookAndFeel;
    actlst: TActionList;
    actValidateUser: TAction;
    dxlytgrp_Config: TdxLayoutGroup;
    rbConnSQLite: TcxRadioButton;
    dxlytm_ConnSQLite: TdxLayoutItem;
    rbConnMySQL: TcxRadioButton;
    dxlytm_ConnMySQL: TdxLayoutItem;
    ZConn: TZConnection;
    ZQry: TZQuery;
    dxskncntrlr: TdxSkinController;
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_LoginClick(Sender: TObject);
    procedure actValidateUserExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbConnSQLiteClick(Sender: TObject);
    procedure rbConnMySQLClick(Sender: TObject);
  private
    { Private declarations }

    function CheckInputData: Boolean;
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses
  KeyHookFunc, SQLite3, SQLite3Wrap, SQLite3Utils;

var
  Count: Integer;

{$R *.dfm}

procedure TLoginForm.Btn_CancelClick(Sender: TObject);
begin
  Close;
  Application.Terminate;
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLoginForm.Btn_LoginClick(Sender: TObject);
begin
  //登录次数
  Inc(Count);

  //获取用户信息
  with SysUser do
  begin
    UserName := Trim(cxtxtdt_UserName.Text);
    UserPass := Trim(cxtxtdt_UserPass.Text);
  end;

  //获取配置数据库连接所需的信息
  with DBConn do
  begin
    DBName := Trim(cxtxtdt_DBName.Text);
    DBSvr := Trim(cxtxtdt_DBSvr.Text);
    DBPort := Trim(cxtxtdt_DBPort.Text);
    DBUserName := Trim(cxtxtdt_DBUserName.Text);
    DBUserPass := Trim(cxtxtdt_DBUserPass.Text);
  end;

  //验证登录用户合法性
  actValidateUserExecute(nil);
end;

procedure TLoginForm.actValidateUserExecute(Sender: TObject);
var
  TmpStr: string;
  DBPath: string;
  SQLiteDB: TSQLite3DataBase;
  SQLiteStmt: TSQLite3Statement;
begin
  if not CheckInputData then Exit;

  TmpStr := '';

  case DBFlag of
    dbSQLite:
    begin
      DBPath := ExtractFilePath(ParamStr(0)) + 'Data.db';

      SQLiteDB := TSQLite3Database.Create;
      try
        if not FileExists(DBPath) then
        begin
          SQLiteDB.Open(DBPath);
          SQLiteDB.Execute('CREATE TABLE SYSUSER(USERNAME TEXT, USERPASS TEXT)');
          SQLiteDB.Execute('CREATE TABLE SCANINFO(BARCODE TEXT)');

          SQLiteStmt := SQLiteDB.Prepare('INSERT INTO SYSUSER (USERNAME, USERPASS) VALUES ("admin", "admin")');
          try
            SQLiteStmt.StepAndReset;
          finally
            SQLiteStmt.Free;
          end;

          SQLiteDB.Close;
        end;

        SQLiteDB.Open(DBPath);

        SQLiteStmt := SQLiteDB.Prepare('SELECT * FROM SYSUSER WHERE USERNAME = ?');
        try
          SQLiteStmt.BindText(1, SysUser.UserName);
          if SQLiteStmt.Step = SQLITE_ROW then
          begin
            TmpStr := SQLiteStmt.ColumnText(1);
          end;
        finally
          SQLiteStmt.Free;
        end;

      finally
        SQLiteDB.Free;
      end;
    end;

    dbMYSQL:
    begin
      try
        with ZConn do
        begin
          HostName := DBConn.DBSvr;
          Port := StrToInt(DBConn.DBPort);
          Database := DBConn.DBName;
          User := DBConn.DBUserName;
          Password := DBConn.DBUserPass;
          Protocol := 'mysql';
          LibraryLocation := ExtractFilePath(Application.ExeName) + 'libmysql.dll';
          Connect;
        end;
        ZQry.Connection := ZConn;

        ZQry.SQL.Clear;
        ZQry.SQL.Add('SELECT * FROM SYSUSER WHERE USERNAME = "' +
          SysUser.UserName + '"');
        ZQry.Open;
        TmpStr := VarToStr(ZQry.Lookup('USERNAME', SysUser.UserName, 'USERPASS'));
        ZQry.Close;
      except
        ShowMessage('无法连接MySQL数据库！');
        Exit;
      end;
    end;
  end;

  if TmpStr = SysUser.UserPass then
    Close
  else
  begin
    ShowMessage('用户名或密码错误！请重新登录！');
    if Count = 3 then
    begin
      ShowMessage('登陆次数已达到3次！程序关闭！');
      Close;
      Application.Terminate;
    end;
  end;

end;

function TLoginForm.CheckInputData: Boolean;
begin
  Result := False;

  if Trim(cxtxtdt_UserName.Text) = '' then
  begin
    ShowMessage('用户名不能为空！');
    Exit;
  end;

  if Trim(cxtxtdt_UserPass.Text) = '' then
  begin
    ShowMessage('用户密码不能为空！');
    Exit;
  end;

  case DBFlag of
    dbMYSQL:
    begin
      if Trim(cxtxtdt_DBName.Text) = '' then
      begin
        ShowMessage('请输入所使用的数据库名称！');
        Exit;
      end;

      if Trim(cxtxtdt_DBSvr.Text) = '' then
      begin
        ShowMessage('请输入MySQL服务器IP地址！');
        Exit;
      end;

      if Trim(cxtxtdt_DBPort.Text) = '' then
      begin
        ShowMessage('请输入MySQL服务器端口号！');
        Exit;
      end;

      if Trim(cxtxtdt_DBUserName.Text) = '' then
      begin
        ShowMessage('请输入MySQL服务器账户名！');
        Exit;
      end;

      if Trim(cxtxtdt_DBUserPass.Text) = '' then
      begin
        ShowMessage('请输入MySQL服务器账户密码！');
        Exit;
      end;
    end;
  end;

  Result := True;
end;

procedure TLoginForm.FormShow(Sender: TObject);
var
  CfgFile: TIniFile;
  CfgFileName: string;
  Skin: string;
begin
  CfgFileName := ExtractFilePath(Application.ExeName) + 'Config.ini';

  CfgFile := TIniFile.Create(CfgFileName);
  Skin := CfgFile.ReadString('SkinCfg', 'Skin', 'McSkin');
  CfgFile.Free;

  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := Skin;
  dxskncntrlr.NativeStyle := False;
  dxskncntrlr.UseSkins := True;
end;

procedure TLoginForm.rbConnSQLiteClick(Sender: TObject);
begin
  rbConnMySQL.Checked := not rbConnSQLite.Checked;

  if rbConnSQLite.Checked then
    Self.Height := 180
  else
    Self.Height := 315;

  dxlytgrp_DB.Visible := not rbConnSQLite.Checked;

  if rbConnSQLite.Checked then
    DBFlag := dbSQLite
  else
    DBFlag := dbMYSQL;
end;

procedure TLoginForm.rbConnMySQLClick(Sender: TObject);
begin
  rbConnSQLite.Checked := not rbConnMySQL.Checked;

  if rbConnMySQL.Checked then
    Self.Height := 315
  else
    Self.Height := 180;

  dxlytgrp_DB.Visible := rbConnMySQL.Checked;

  if rbConnMySQL.Checked then
    DBFlag := dbMYSQL
  else
    DBFlag := dbSQLite;
end;

end.
