unit KeyHookForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Registry, DBXpress, DB, SqlExpr, ADODB,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, cxButtons,
  dxSkinsCore, dxSkinMcSkin, dxSkinPumpkin, cxControls, cxListBox,
  dxLayoutContainer, dxLayoutControlAdapters, dxSkinscxPCPainter,
  dxLayoutLookAndFeels, dxSkinsForm, dxLayoutControl, cxCustomData,
  cxStyles, cxTL, cxTextEdit, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  DBClient, SimpleDS, ActnList, dxSkinsdxStatusBarPainter, dxStatusBar,
  cxContainer, cxEdit, dxLayoutcxEditAdapters, cxMaskEdit, cxSpinEdit,
  ImgList;

type
  TfrmKeyHook = class(TForm)
    Timer_KeyRec: TTimer;
    Timer_SaveToTxT: TTimer;
    Timer_Thread: TTimer;
    Btn_WriteToDB: TcxButton;
    dxlytgrp_Root: TdxLayoutGroup;
    dxlytcntrl: TdxLayoutControl;
    dxlytm_WriteToDB: TdxLayoutItem;
    dxlytgrp_Btn: TdxLayoutGroup;
    dxlytlkndflst: TdxLayoutLookAndFeelList;
    dxskncntrlr: TdxSkinController;
    dxlytsknlkndfl: TdxLayoutSkinLookAndFeel;
    MainMenu: TMainMenu;
    mniFile: TMenuItem;
    mniWindow: TMenuItem;
    mniSkin: TMenuItem;
    cxTLst_Info: TcxTreeList;
    dxlytm_cxTLst_Info: TdxLayoutItem;
    cxtrlstclmn_ID: TcxTreeListColumn;
    cxtrlstclmn_Info: TcxTreeListColumn;
    popMenu_cxTLst: TPopupMenu;
    DelSelectItem: TMenuItem;
    SysExit: TMenuItem;
    Btn_Start: TcxButton;
    dxlytm_Begin: TdxLayoutItem;
    Btn_Stop: TcxButton;
    dxlytm_Stop: TdxLayoutItem;
    ClearAll: TMenuItem;
    conMySQL: TADOConnection;
    WriteSelectedToDB: TMenuItem;
    qryMySQL: TADOQuery;
    actlst: TActionList;
    actRecordKeys: TAction;
    actRecordNumKeys: TAction;
    dxStatusBar: TdxStatusBar;
    Timer_DelText: TTimer;
    Pumpkin: TMenuItem;
    McSkin: TMenuItem;
    cxSpinEdit: TcxSpinEdit;
    dxlytm_Count: TdxLayoutItem;
    cxImageList: TcxImageList;
    procedure Timer_KeyRecTimer(Sender: TObject);
    procedure Timer_SaveToTxTTimer(Sender: TObject);
    procedure Timer_ThreadTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_StartClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure SysExitClick(Sender: TObject);
    procedure DelSelectItemClick(Sender: TObject);
    procedure cxTLst_InfoFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure ClearAllClick(Sender: TObject);
    procedure WriteSelectedToDBClick(Sender: TObject);
    procedure Btn_WriteToDBClick(Sender: TObject);
    procedure actRecordNumKeysExecute(Sender: TObject);
    procedure actRecordKeysExecute(Sender: TObject);
    procedure Timer_DelTextTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PumpkinClick(Sender: TObject);
    procedure McSkinClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmKeyHook: TfrmKeyHook;

implementation

uses
  Variants, U_Login, KeyHookFunc;

var
  F: Textfile;

{$R *.DFM}

//Detect Key Pressed Action From Any Window

procedure TfrmKeyHook.Timer_KeyRecTimer(Sender: TObject);
begin
  //记录所有按键
  //actRecordKeysExecute(nil);

  //只记录数字按键
  actRecordNumKeysExecute(nil);
end;

procedure TfrmKeyHook.Timer_SaveToTxTTimer(Sender: TObject);
var
  I: Integer;
  TmpStr: string;
begin
  Assignfile(F, 'Save.txt');
  if not FileExists('Save.txt') then
  begin
    Rewrite(F);
    Closefile(F);
  end
  else
    Assignfile(F, 'Save.txt');
{$I-}
  Rewrite(F);
{$I+}
  if IOResult <> 0 then
  begin
    ShowMessage('Cannot Open File');
  end;

  TmpStr := '';
  for I := 0 to cxTLst_Info.Count - 1 do
    TmpStr := TmpStr + cxTLst_Info.Items[I].Texts[1] + #13#10;
  Write(F, TmpStr);
  Closefile(F);
end;

procedure TfrmKeyHook.Timer_ThreadTimer(Sender: TObject);
begin
  {
  if DetecThread('Test.exe') = 'exist' then
    begin
      Timer_KeyRec.Enabled := True;
    end
  else
    begin
      Timer_KeyRec.Enabled := False;
    end;
  }
end;

procedure TfrmKeyHook.FormCreate(Sender: TObject);
//var
  //Registry_Key: TRegistry;
  //ConnADO: TADOConnection;
  //DsADO: TADODataSet;
begin
  inherited;
  Self.Visible := False;
  LoginForm := TLoginForm.Create(nil);
  LoginForm.ShowModal;
  Self.Visible := True;
  (*
  ConnADO := TADOConnection.Create(nil);
  DsADO := TADODataSet.Create(nil);
  ConnADO.LoginPrompt := False;
  with ConnADO do
  begin
    Close;
    ConnectionString := ('DRIVER={MySQL ODBC 5.2 Unicode Driver}; '+
      'SERVER=' + DBConn.DBSvr + '; DATABASE=' + DBConn.DBName +'; USER=' +
      DBConn.DBUserName + '; ' + 'PASSWORD=' + DBConn.DBUserPass + '; PORT=' +
      DBConn.DBPort + '; OPTION=3; ');
    ConnADO.Open;
    DsADO.Connection := ConnADO;
    DsADO.CommandText := 'select * from sysuser where username = "' + SysUser.UserName + '"';
    DsADO.Open;
    DsADO.Active := True;
    DsADO.Refresh;
    TmpStr := dsMySQL.Lookup('username', SysUser.UserName, 'userpass');
    if TmpStr = SysUser.UserPass then
      ShowMessage('登陆成功！');
    try

      Open;
      Application.MessageBox( '连接成功！', '提示 ',MB_ICONINFORMATION);

    except
        Application.MessageBox( '无法连接数据库服务器.请与管理员联系 ', '提示 ',MB_ICONINFORMATION);
    end;

  end;
  *)
  {
  Registry_Key := TRegistry.Create();
  Registry_Key.RootKey := HKEY_LOCAL_MACHINE;
  Registry_Key.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
  Registry_Key.WriteString('KeyboardHook', ExtractFilename(Application.ExeName));
  Registry_Key.Free;
  }
end;

procedure TfrmKeyHook.Btn_StartClick(Sender: TObject);
begin
  Timer_KeyRec.Enabled := True;
  dxStatusBar.Panels[1].Text := '键盘按键记录正在进行...';
end;

procedure TfrmKeyHook.Btn_StopClick(Sender: TObject);
begin
  Timer_KeyRec.Enabled := False;

  dxStatusBar.Panels[1].Text := '键盘按键记录已经停止';
end;

procedure TfrmKeyHook.SysExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmKeyHook.DelSelectItemClick(Sender: TObject);
var
  Node: TcxTreeListNode;
begin
  Node := cxTLst_Info.FocusedNode;
  if not Assigned(Node) then Exit;

  Node.Delete;
end;

procedure TfrmKeyHook.cxTLst_InfoFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode,
  AFocusedNode: TcxTreeListNode);
begin
  //
end;

procedure TfrmKeyHook.ClearAllClick(Sender: TObject);
begin
  cxTLst_Info.Clear;
end;

procedure TfrmKeyHook.WriteSelectedToDBClick(Sender: TObject);
var
  Node: TcxTreeListNode;
  TmpStr: string;
  rCount: Integer;
begin
  Node := cxTLst_Info.FocusedNode;
  if not Assigned(Node) then Exit;

  TmpStr := Node.Values[cxtrlstclmn_Info.ItemIndex];

  try
    conMySQL.Open;
  except
    ShowMessage('数据库连接打开失败！');
    Exit;
  end;

  qryMySQL.SQL.Clear;
  qryMySQL.SQL.Add('insert into scaninfo (barcode) values ("' + TmpStr + '")');
  rCount := qryMySQL.ExecSQL;

  if rCount > 0 then
    dxStatusBar.Panels[1].Text := '写入数据库成功！'
  else
    dxStatusBar.Panels[1].Text := '写入数据库失败！';
end;

procedure TfrmKeyHook.Btn_WriteToDBClick(Sender: TObject);
var
  I: Integer;
  Node: TcxTreeListNode;
  TmpStr: string;
  rCount: Integer;
begin
  try
    conMySQL.Open;
  except
    ShowMessage('数据库连接打开失败！');
    Exit;
  end;

  for I := 0 to cxTLst_Info.Count - 1 do
  begin
    Node := cxTLst_Info.Items[I];
    TmpStr := Node.Values[cxtrlstclmn_Info.ItemIndex];
    qryMySQL.SQL.Clear;
    qryMySQL.SQL.Add('insert into scaninfo (barcode) values ("' + TmpStr + '")');
    rCount := qryMySQL.ExecSQL;

    if rCount > 0 then
      dxStatusBar.Panels[1].Text := '写入数据库成功！'
    else
      dxStatusBar.Panels[1].Text := '写入数据库失败！';
  end;
end;

//只记录数字按键
procedure TfrmKeyHook.actRecordNumKeysExecute(Sender: TObject);
var
  I: Byte;
  TmpStr: string;
  Node: TcxTreeListNode;
begin
  for I := 48 to 105 do
  begin
    if GetAsyncKeyState(I) = -32767 then
    begin
      if (I > 57) and (I < 96) then
        Continue;

      if GetKeyState(VK_SHIFT) < 0 then
        Break;

      if cxTLst_Info.Count > 0 then
      begin
        Node := cxTLst_Info.Items[cxTLst_Info.Count - 1];
        TmpStr := VarToStr(Node.Values[cxtrlstclmn_Info.ItemIndex]);
        if Length(TmpStr) >= cxSpinEdit.Value then
        begin
          TmpStr := '';
          Node := cxTLst_Info.Add;
        end;
      end
      else
      begin
        TmpStr := '';
        Node := cxTLst_Info.Add;
      end;

      Node.Values[cxtrlstclmn_ID.ItemIndex] := cxTLst_Info.Count;

      case I of
        //Number: 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 Symbol: !, @, #, $, %, ^, &, *, (, )
        48:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + ')'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '0';
        49:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '!'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '1';
        50:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '@'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '2';
        51:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '#'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '3';
        52:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '$'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '4';
        53:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '%'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '5';
        54:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '^'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '6';
        55:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '&'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '7';
        56:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '*'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '8';
        57:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '('
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '9';
        //小数字键盘
        96..105:
             Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + IntToStr(I - 96);
      end;
    end;
  end;
end;

procedure TfrmKeyHook.actRecordKeysExecute(Sender: TObject);
var
  I: Byte;
  Node: TcxTreeListNode;
begin
  for I := 8 to 222 do
  begin
    if GetAsyncKeyState(I) = -32767 then
    begin
      Node := cxTLst_Info.Add;
      Node.Values[cxtrlstclmn_ID.ItemIndex] := cxTLst_Info.Count;
      case I of
        8:   Node.Values[cxtrlstclmn_Info.ItemIndex] := '[BackSpace]';
        9:   Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Tab]';
        13:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Enter]';
        17:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Ctrl]';
        27:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Esc]';
        32:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[BlankSpace]';
        //Del, Ins, Home, PageUp, PageDown, End
        33:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Page Up]';
        34:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Page Down]';
        35:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[End]';
        36:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Home]';
        //Arrow Up, Down, Left, Right
        37:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Left]';
        38:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Up]';
        39:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Right]';
        40:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Down]';
        //PrintScreen, Insert, Delete, ScrollLock
        44:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Print Screen]';
        45:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Insert]';
        46:  Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Del]';
        145: Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Scroll Lock]';
        //Number: 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 Symbol: !, @, #, $, %, ^, &, *, (, )
        48:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := ')'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '0';
        49:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '!'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '1';
        50:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '@'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '2';
        51:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '#'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '3';
        52:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '$'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '4';
        53:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '%'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '5';
        54:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '^'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '6';
        55:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '&'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '7';
        56:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '*'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '8';
        57:  if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '('
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '9';
        //a..z, A..Z
        65..90:
             begin
               if ((GetKeyState(VK_CAPITAL)) = 1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                   //a..z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := LowerCase(Chr(I))
                 else
                   //A..Z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := UpperCase(Chr(I))
               else
                 if GetKeyState(VK_SHIFT) < 0 then
                   //A..Z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := UpperCase(Chr(I))
                 else
                   //a..z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := LowerCase(Chr(I));
             end;
        //Win
        //91: Node.Values[cxtrlstclmn_Info.ItemIndex] := '[LWin]';
        //92: Node.Values[cxtrlstclmn_Info.ItemIndex] := '[RWin]';
        //NumberPad
        96..105:
             //Number: 0..9
             Node.Values[cxtrlstclmn_Info.ItemIndex] := IntToStr(I - 96);
        106: Node.Values[cxtrlstclmn_Info.ItemIndex] := '*';
        107: Node.Values[cxtrlstclmn_Info.ItemIndex] := '&';
        109: Node.Values[cxtrlstclmn_Info.ItemIndex] := '-';
        110: Node.Values[cxtrlstclmn_Info.ItemIndex] := '.';
        111: Node.Values[cxtrlstclmn_Info.ItemIndex] := '/';
        144: Node.Values[cxtrlstclmn_Info.ItemIndex] := '[Num Lock]';

        112..123: //F1-F12
             Node.Values[cxtrlstclmn_Info.ItemIndex] := '[F' + IntToStr(I - 111) + ']';

        186: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := ':'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := ';';
        187: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '+'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '=';
        188: if GetKeyState(VK_SHIFT) < 0 then
              Node.Values[cxtrlstclmn_Info.ItemIndex] := '<'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := ',';
        189: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '_'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '-';
        190: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '>'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '.';
        191: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '?'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '/';
        192: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '~'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '`';
        219: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '{'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '[';
        220: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '|'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '\';
        221: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '}'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := ']';
        222: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '"'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := '''';
      end;
    end;
  end;
end;

procedure TfrmKeyHook.Timer_DelTextTimer(Sender: TObject);
begin
  if (dxStatusBar.Panels[1].Text = '写入数据库成功！') or
     (dxStatusBar.Panels[1].Text = '写入数据库失败！') then
    if Timer_KeyRec.Enabled then
      dxStatusBar.Panels[1].Text := '键盘按键记录正在进行...'
    else
      dxStatusBar.Panels[1].Text := '键盘按键记录已经停止';
end;

procedure TfrmKeyHook.FormShow(Sender: TObject);
begin
  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := 'Mcskin';
  dxskncntrlr.NativeStyle := False;
  dxskncntrlr.UseSkins := True;
end;

procedure TfrmKeyHook.PumpkinClick(Sender: TObject);
begin
  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := 'Pumpkin';
  dxskncntrlr.NativeStyle := False;
  dxskncntrlr.UseSkins := True;
end;

procedure TfrmKeyHook.McSkinClick(Sender: TObject);
begin
  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := 'McSkin';
  dxskncntrlr.NativeStyle := False;
  dxskncntrlr.UseSkins := True;
end;

end.

