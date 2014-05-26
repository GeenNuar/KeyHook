unit KeyHookFunc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ImgList, Menus, ShellApi, ExtCtrls, StdCtrls, Dialogs, TLHelp32, strutils, Buttons;

type
  //进程信息类
  TProcessInfo = record
    ExeFile: string;
    ProcessID: DWORD;
  end;
  pProcessInfo = ^TProcessInfo;

  //系统用户类
  TSysUser = class(TObject)
  private
    {Private Declarations}
    FUserName: string;
    FUserPass: string;
  public
    {Public Declarations}
    property UserName: string read FUserName write FUserName;
    property UserPass: string read FUserPass write FUserPass;
  end;

  //数据库连接类
  TDBConn = class(TObject)
    private
      {Private Declarations}
      FDBName: string;
      FDBSvr: string;
      FDBPort: string;
      FDBUserName: string;
      FDBUserPass: string;
    public
      {Public Declarations}
      property DBName: string read FDBName write FDBName;
      property DBSvr: string read FDBSvr write FDBSvr;
      property DBPort: string read FDBPort write FDBPort;
      property DBUserName: string read FDBUserName write FDBUserName;
      property DBUserPass: string read FDBUserPass write FDBUserPass;
  end;

  //检测某个进程是否存在
  function DetecThread(TmpStr: string): string;

var
  SysUser: TSysUser;
  DBConn: TDBConn;

implementation

function DetecThread(TmpStr: string): string;
var
  P: pProcessInfo;
  ContinueLoop: Bool;
  I: Integer;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  I := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    New(P);
    P.ExeFile := FProcessEntry32.szExeFile;
    P.ProcessID := FProcessEntry32.th32ProcessID;
    if LowerCase(P.ExeFile) = LowerCase(TmpStr) then
      I := I + 1;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;

  if I < 1 then
  begin
    Result := ('notexist');
  end
  else
  begin
    Result := ('exist');
  end;
end;

initialization
  SysUser := TSysUser.Create;
  DBConn := TDBConn.Create;

finalization
  SysUser.Free;
  DBConn.Free;
end.

