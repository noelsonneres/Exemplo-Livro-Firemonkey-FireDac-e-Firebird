unit uMensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Winapi.Windows, FMX.Layouts, FMX.Memo;

type
  TfMensagem = class(TForm)
    Timer: TTimer;
    Memo: TMemo;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    msg: string;
    processo: PROCESS_INFORMATION;
  end;

var
  fMensagem: TfMensagem;

implementation

{$R *.fmx}

procedure TfMensagem.FormCreate(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TfMensagem.FormShow(Sender: TObject);
begin
  if msg = '' then msg := 'Aguarde...';
  Memo.Lines.Clear;
  Memo.Lines.Add(msg);
  Application.ProcessMessages;
end;

procedure TfMensagem.TimerTimer(Sender: TObject);
var
  lExitCode: DWORD;
begin
  GetExitCodeProcess(processo.hProcess, lExitCode);
  if (lExitCode <> STILL_ACTIVE) then
  begin
    Timer.Enabled := False;
    Close;
  end;
end;

end.
