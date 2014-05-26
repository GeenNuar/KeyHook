unit U_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Menus, dxLayoutControlAdapters, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutContainer, StdCtrls, cxButtons, ActnList,
  dxLayoutControl, cxCheckBox, dxLayoutLookAndFeels, dxSkinsForm, DB, ADODB,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinMcSkin,
  dxSkinPumpkin;

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
    cxchckbx_ConfigDB: TcxCheckBox;
    dxlytm_Checkbox: TdxLayoutItem;
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
    procedure cxchckbx_ConfigDBPropertiesChange(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_LoginClick(Sender: TObject);
    procedure actValidateUserExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  KeyHookFunc;

var
  Count: Integer;

{$R *.dfm}

procedure TLoginForm.cxchckbx_ConfigDBPropertiesChange(Sender: TObject);
begin
  if cxchckbx_ConfigDB.Checked then
    Self.Height := 315
  else
    Self.Height := 180;
  dxlytgrp_DB.Visible := cxchckbx_ConfigDB.Checked;
end;

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
  //actValidateUserExecute(nil);
  Close;
end;

procedure TLoginForm.actValidateUserExecute(Sender: TObject);
var
  TmpStr: string;
begin
  if not CheckInputData then Exit;

  ds_ADO.CommandText := 'select * from sysuser where username = "' +
    SysUser.UserName + '"';
  ds_ADO.Open;
  TmpStr := VarToStr(ds_ADO.Lookup('username', SysUser.UserName, 'userpass'));
  ds_ADO.Close;

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

end.
