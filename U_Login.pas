unit U_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Menus, dxLayoutControlAdapters, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutContainer, StdCtrls, cxButtons, ActnList,
  dxLayoutControl, cxCheckBox, dxLayoutLookAndFeels, dxSkinsForm, DB, ADODB,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinMcSkin,
  dxSkinPumpkin, cxRadioGroup, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

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
    dxskncntrlr: TdxSkinController;
    dxlytlkndflst: TdxLayoutLookAndFeelList;
    dxlytsknlkndfl: TdxLayoutSkinLookAndFeel;
    con_ADO: TADOConnection;
    ds_ADO: TADODataSet;
    actlst: TActionList;
    actValidateUser: TAction;
    dxlytgrp_Config: TdxLayoutGroup;
    rbConnSQLite: TcxRadioButton;
    dxlytm_ConnSQLite: TdxLayoutItem;
    rbConnMySQL: TcxRadioButton;
    dxlytm_ConnMySQL: TdxLayoutItem;
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
  rCount: Integer;
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

    dbMySQl:
    begin
      ds_ADO.CommandText := 'select * from sysuser where username = "' +
        SysUser.UserName + '"';
      try
        ds_ADO.Open;
        TmpStr := VarToStr(ds_ADO.Lookup('username', SysUser.UserName, 'userpass'));
        ds_ADO.Close;
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
    if Count =3 then
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

  Result := True;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := 'McSkin';
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
