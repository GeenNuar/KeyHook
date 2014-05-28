program KeysHook;

uses
  ExceptionLog,
  Forms,
  U_Login in 'U_Login.pas' {LoginForm},
  KeyHookFunc in 'KeyHookFunc.pas',
  KeyHookForm in 'KeyHookForm.pas' {frmKeyHook},
  SQLite3Wrap in 'SQLite3Wrap.pas',
  SQLite3 in 'SQLite3.pas',
  SQLite3Utils in 'SQLite3Utils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmKeyHook, frmKeyHook);
  Application.Run;
end.
