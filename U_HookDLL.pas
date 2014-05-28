unit U_HookDLL;

interface

uses
  Windows;

const BUFFER_SIZE = 16 * 1024;              //�ļ�ӳ�䵽�ڴ�Ĵ�С
const HOOK_MEM_FILENAME = 'MEM_FILE';       //ӳ���ļ�����
const HOOK_MUTEX_NAME = 'MUTEX_NAME';       //��������

type
  //�������ݽṹ
  TShared = record
    Keys: array[0..BUFFER_SIZE - 1] of Char;
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
const
  KeyPressMask = $80000000;
begin
  if iCode < 0 then
    Result := CallNextHookEx(hOldKeyHook, iCode, wParam, lParam)
  else
  begin
    if ((lParam and KeyPressMask) = 0) then
    begin
      //���������Ϣ
      Shared^.Keys[Shared^.KeyCount] := Char(wParam and $00FF);
      Inc(Shared^.KeyCount);
      //�ﵽ��������������ʱ����
      if Shared^.KeyCount >= BUFFER_SIZE - 1 then
        Shared^.KeyCount := 0;
    end;
    Result := 0;
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

{ж�ؼ��̹���}
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
function GetKey(Index: Integer): Char; export;
begin
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