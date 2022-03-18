program ProgTest;

uses
  Vcl.Forms,
  mPTMain in 'mPTMain.pas' {Form1},
  PrognoseUtils in 'PrognoseUtils.pas',
  BaseUtils2 in 'BaseUtils2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
