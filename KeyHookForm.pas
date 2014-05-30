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
  ImgList, dxSkinsdxBarPainter, dxBar, cxClasses, cxDropDownEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp,
  dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

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
    cxTLst_Info: TcxTreeList;
    dxlytm_cxTLst_Info: TdxLayoutItem;
    cxtrlstclmn_ID: TcxTreeListColumn;
    cxtrlstclmn_Info: TcxTreeListColumn;
    popMenu_cxTLst: TPopupMenu;
    DelSelectItem: TMenuItem;
    Btn_Start: TcxButton;
    dxlytm_Begin: TdxLayoutItem;
    Btn_Stop: TcxButton;
    dxlytm_Stop: TdxLayoutItem;
    ClearAll: TMenuItem;
    conMySQL: TADOConnection;
    mniWriteSelToDB: TMenuItem;
    qryMySQL: TADOQuery;
    actlst: TActionList;
    actRecordKeys: TAction;
    actRecordNumKeys: TAction;
    dxStatusBar: TdxStatusBar;
    Timer_DelText: TTimer;
    cxSpinEdit: TcxSpinEdit;
    dxlytm_Count: TdxLayoutItem;
    cxImageList: TcxImageList;
    acWriteToDB: TAction;
    acWriteSelToDB: TAction;
    dxbrmngr: TdxBarManager;
    dxbrmngrBar: TdxBar;
    dxbrsbtmFile: TdxBarSubItem;
    dxbrsbtmWin: TdxBarSubItem;
    dxbrsbtm_Skin: TdxBarSubItem;
    dxbrbtn_Exit: TdxBarButton;
    dxbrbtn_McSkin: TdxBarButton;
    dxbrbtn_Pumpkin: TdxBarButton;
    acRecordKeysWithHookDLL: TAction;
    cxcmbx: TcxComboBox;
    dxlytm_cxcmbox: TdxLayoutItem;
    procedure Timer_KeyRecTimer(Sender: TObject);
    procedure Timer_SaveToTxTTimer(Sender: TObject);
    procedure Timer_ThreadTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_StartClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure DelSelectItemClick(Sender: TObject);
    procedure ClearAllClick(Sender: TObject);
    procedure Btn_WriteToDBClick(Sender: TObject);
    procedure actRecordNumKeysExecute(Sender: TObject);
    procedure actRecordKeysExecute(Sender: TObject);
    procedure Timer_DelTextTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acWriteToDBExecute(Sender: TObject);
    procedure acWriteSelToDBExecute(Sender: TObject);
    procedure acWriteSelToDBUpdate(Sender: TObject);
    procedure cxTLst_InfoChange(Sender: TObject);
    procedure dxbrbtn_ExitClick(Sender: TObject);
    procedure dxbrbtn_McSkinClick(Sender: TObject);
    procedure dxbrbtn_PumpkinClick(Sender: TObject);
    procedure acRecordKeysWithHookDLLExecute(Sender: TObject);
    procedure cxcmbxPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    procedure ChangeSkin(SkinName: string);

    procedure WriteToSQLiteDB;
    procedure WriteToMySQLDB;
  public
    { Public declarations }
  end;

var
  frmKeyHook: TfrmKeyHook;

implementation

uses
  Variants, U_Login, KeyHookFunc, SQLite3, SQLite3Wrap, SQLite3Utils;

  function EnableKeyHook: Bool; external 'HookFunc.DLL';
  function DisableKeyHook: Bool; external 'HookFunc.DLL';
  function GetKeyCount: Integer; external 'HookFunc.DLL';
  function GetKey(Index: Integer): ShortString; external 'HookFunc.DLL';
  procedure ClearKeyString; external 'HookFunc.DLL';

var
  F: TextFile;
  KeyCount: Integer;

{$R *.DFM}

//Detect Key Pressed Action From Any Window

procedure TfrmKeyHook.Timer_KeyRecTimer(Sender: TObject);
begin
  case CPFlag of
    //采用全局钩子函数获取键盘按键信息
    cfDefault:
      acRecordKeysWithHookDLLExecute(nil);

    //只记录数字按键
    cfNumber:
      actRecordNumKeysExecute(nil);

    //记录所有按键
    cfAll:
      actRecordKeysExecute(nil);
  end;
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
  if DetecThread('TEST.EXE') = 'EXIST' then
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
begin
  {
  Registry_Key := TRegistry.Create();
  Registry_Key.RootKey := HKEY_LOCAL_MACHINE;
  Registry_Key.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
  Registry_Key.WriteString('KeyboardHook', ExtractFilename(Application.ExeName));
  Registry_Key.Free;
  }

  LoginForm := TLoginForm.Create(nil);
  LoginForm.ShowModal;
end;

procedure TfrmKeyHook.Btn_StartClick(Sender: TObject);
begin
  Timer_KeyRec.Enabled := True;

  dxStatusBar.Panels[1].Text := '键盘按键记录正在进行...';

  Btn_Start.Enabled := False;
  Btn_Stop.Enabled := True;

  if CPFlag = cfDefault then
  begin
    EnableKeyHook;
    cxSpinEdit.Enabled := False;
  end;
end;

procedure TfrmKeyHook.Btn_StopClick(Sender: TObject);
begin
  Timer_KeyRec.Enabled := False;

  dxStatusBar.Panels[1].Text := '键盘按键记录已经停止';

  Btn_Stop.Enabled := False;
  Btn_Start.Enabled := True;

  if CPFlag = cfDefault then
  begin
    DisableKeyHook;
    cxSpinEdit.Enabled := False;
  end;
end;

procedure TfrmKeyHook.DelSelectItemClick(Sender: TObject);
var
  I: Integer;
  Next: Integer;
  Node: TcxTreeListNode;
begin
  Node := cxTLst_Info.FocusedNode;
  if not Assigned(Node) then Exit;

  Next := Node.Index;
  Node.Delete;

  for I := Next to cxTLst_Info.Count - 1 do
    cxTLst_Info.Items[I].Values[cxtrlstclmn_ID.ItemIndex] :=
      cxTLst_Info.Items[I].Index + 1;
end;

procedure TfrmKeyHook.ClearAllClick(Sender: TObject);
begin
  cxTLst_Info.Clear;
end;

procedure TfrmKeyHook.Btn_WriteToDBClick(Sender: TObject);
begin
  acWriteToDBExecute(nil);
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
          cxTLst_Info.GotoEOF;
        end;
      end
      else
      begin
        TmpStr := '';
        Node := cxTLst_Info.Add;
        cxTLst_Info.GotoEOF;
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

//记录所有键盘按键
procedure TfrmKeyHook.actRecordKeysExecute(Sender: TObject);
var
  I: Byte;
  TmpStr: string;
  Node: TcxTreeListNode;
begin
  for I := 8 to 222 do
  begin
    if GetAsyncKeyState(I) = -32767 then
    begin
      if cxTLst_Info.Count > 0 then
      begin
        Node := cxTLst_Info.Items[cxTLst_Info.Count - 1];
        TmpStr := VarToStr(Node.Values[cxtrlstclmn_Info.ItemIndex]);
        if Length(TmpStr) >= cxSpinEdit.Value then
        begin
          TmpStr := '';
          Node := cxTLst_Info.Add;
          cxTLst_Info.GotoEOF;
        end;
      end
      else
      begin
        TmpStr := '';
        Node := cxTLst_Info.Add;
        cxTLst_Info.GotoEOF;
      end;

      Node.Values[cxtrlstclmn_ID.ItemIndex] := cxTLst_Info.Count;

      case I of
        8:   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[BackSpace]';
        9:   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Tab]';
        13:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Enter]';
        17:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Ctrl]';
        27:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Esc]';
        32:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[BlankSpace]';

        //Del, Ins, Home, PageUp, PageDown, End
        33:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Page Up]';
        34:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Page Down]';
        35:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[End]';
        36:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Home]';

        //Arrow Up, Down, Left, Right
        37:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Left]';
        38:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Up]';
        39:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Right]';
        40:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Down]';

        //PrintScreen, Insert, Delete, ScrollLock
        44:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Print Screen]';
        45:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Insert]';
        46:  Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Del]';
        145: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Scroll Lock]';

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
        //a..z, A..Z
        65..90:
             begin
               if ((GetKeyState(VK_CAPITAL)) = 1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                   //a..z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + LowerCase(Chr(I))
                 else
                   //A..Z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + UpperCase(Chr(I))
               else
                 if GetKeyState(VK_SHIFT) < 0 then
                   //A..Z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + UpperCase(Chr(I))
                 else
                   //a..z
                   Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + LowerCase(Chr(I));
             end;

        //Win
        91: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[LWin]';
        92: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[RWin]';

        //NumberPad
        96..105:
             //Number: 0..9
             Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + IntToStr(I - 96);
        106: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '*';
        107: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '+';
        109: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '-';
        110: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '.';
        111: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '/';
        144: Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[Num Lock]';

        //F1-F12
        112..123:
             Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[F' + IntToStr(I - 111) + ']';

        186: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + ':'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + ';';
        187: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '+'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '=';
        188: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '<'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + ',';
        189: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '_'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '-';
        190: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '>'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '.';
        191: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '?'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '/';
        192: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '~'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '`';
        219: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '{'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '[';
        220: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '|'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '\';
        221: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '}'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + ']';
        222: if GetKeyState(VK_SHIFT) < 0 then
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '"'
             else
               Node.Values[cxtrlstclmn_Info.ItemIndex] := TmpStr + '''';
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
  ChangeSkin('Mcskin');
end;

procedure TfrmKeyHook.ChangeSkin(SkinName: string);
begin
  dxskncntrlr.UseSkins := False;
  dxskncntrlr.SkinName := SkinName;
  dxskncntrlr.NativeStyle := False;
  dxskncntrlr.UseSkins := True;
end;

procedure TfrmKeyHook.WriteToSQLiteDB;
var
  I: Integer;
  rCount: Integer;
  DBPath: string;
  SQLiteDB: TSQLite3DataBase;
  SQLiteStmt: TSQLite3Statement;
begin
  if cxTLst_Info.Count <= 0 then Exit;

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

    SQLiteStmt := SQLiteDB.Prepare('INSERT INTO SCANINFO (BARCODE) VALUES (?)');
    try
      for I := 0 to cxTLst_Info.Count - 1 do
      begin
        SQLiteStmt.BindText(1, cxTLst_Info.Items[I].Texts[1]);
        rCount := SQLiteStmt.StepAndReset;

        if rCount > 0 then
          dxStatusBar.Panels[1].Text := '写入数据库成功！'
        else
          dxStatusBar.Panels[1].Text := '写入数据库失败！';
      end;
    finally
      SQLiteStmt.Free;
    end;

  finally
    SQLiteDB.Free;
  end;
end;

procedure TfrmKeyHook.acWriteToDBExecute(Sender: TObject);
begin
  case DBFlag of
    //采用SQLite数据库存储数据
    dbSQLite:
      WriteToSQLiteDB;

    //采用MySQL数据库存储数据
    dbMYSQL:
      WriteToMySQLDB;
  end;
end;

procedure TfrmKeyHook.WriteToMySQLDB;
var
  I: Integer;
  Node: TcxTreeListNode;
  TmpStr: string;
  rCount: Integer;
begin
  try
    conMySQL.Open;
  except
    ShowMessage('无法连接MySQL数据库！');
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

procedure TfrmKeyHook.acWriteSelToDBExecute(Sender: TObject);
var
  Node: TcxTreeListNode;
  TmpStr: string;
  rCount: Integer;
  DBPath: string;
  SQLiteDB: TSQLite3DataBase;
  SQLiteStmt: TSQLite3Statement;
begin
  Node := cxTLst_Info.FocusedNode;
  if not Assigned(Node) then Exit;

  rCount := 0;

  TmpStr := Node.Values[cxtrlstclmn_Info.ItemIndex];

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

        SQLiteStmt := SQLiteDB.Prepare('INSERT INTO SCANINFO (BARCODE) VALUES (?)');
        try
          SQLiteStmt.BindText(1, TmpStr);
          rCount := SQLiteStmt.StepAndReset;
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
        conMySQL.Open;
      except
        ShowMessage('无法连接MySQL数据库！');
        Exit;
      end;

      qryMySQL.SQL.Clear;
      qryMySQL.SQL.Add('insert into scaninfo (barcode) values ("' + TmpStr + '")');
      rCount := qryMySQL.ExecSQL;
    end;
  end;

  if rCount > 0 then
    dxStatusBar.Panels[1].Text := '写入数据库成功！'
  else
    dxStatusBar.Panels[1].Text := '写入数据库失败！';
end;

procedure TfrmKeyHook.acWriteSelToDBUpdate(Sender: TObject);
begin
  mniWriteSelToDB.Enabled := cxTLst_Info.FocusedNode <> nil;
  DelSelectItem.Enabled := cxTLst_Info.FocusedNode <> nil;
end;

procedure TfrmKeyHook.cxTLst_InfoChange(Sender: TObject);
begin
  Self.ClearAll.Enabled := cxTLst_Info.Count <> 0;
  Btn_WriteToDB.Enabled := cxTLst_Info.Count <> 0;
end;

procedure TfrmKeyHook.dxbrbtn_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmKeyHook.dxbrbtn_McSkinClick(Sender: TObject);
begin
  ChangeSkin('McSkin');
end;

procedure TfrmKeyHook.dxbrbtn_PumpkinClick(Sender: TObject);
begin
  ChangeSkin('Pumpkin');
end;

procedure TfrmKeyHook.acRecordKeysWithHookDLLExecute(Sender: TObject);
var
  I: Integer;
  OldStr: ShortString;
  NewStr: ShortString;
  Node: TcxTreeListNode;
begin
  for I := KeyCount to GetKeyCount - 1 do
  begin
    NewStr := GetKey(I);

    if cxTLst_Info.Count <= 0 then
    begin
      cxTLst_Info.Add;
      cxTLst_Info.GotoEOF;
    end
    else
      if NewStr = '[Enter]' then
      begin
        cxTLst_Info.Add;
        cxTLst_Info.GotoEOF;
      end;

    if NewStr = '[Enter]' then
      NewStr := '';

    Node := cxTLst_Info.Items[cxTLst_Info.Count - 1];

    Node.Values[cxtrlstclmn_ID.ItemIndex] := Node.Index + 1;

    OldStr := VarToStr(Node.Values[cxtrlstclmn_Info.ItemIndex]);

    Node.Values[cxtrlstclmn_Info.ItemIndex] :=  OldStr + NewStr;
  end;

  KeyCount := GetKeyCount;
end;

procedure TfrmKeyHook.cxcmbxPropertiesChange(Sender: TObject);
begin
  case cxcmbx.ItemIndex of
    0:
      CPFlag := cfDefault;
    1:
      CPFlag := cfNumber;
    2:
      CPFlag := cfAll;
  end;

  if CPFlag = cfDefault then
  begin
    EnableKeyHook;
    cxSpinEdit.Enabled := False;
  end
  else
  begin
    DisableKeyHook;
    cxSpinEdit.Enabled := True;
  end;
end;

end.
