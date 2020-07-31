unit uEditorScript;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, Data.Bind.Controls, System.Rtti, FMX.Layouts, FMX.Grid, FMX.ListBox,
  Fmx.Bind.Navigator, uDAC, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.Grid, FireDAC.Comp.Client, FMX.Memo;

type
  TfEditorScript = class(TfxForm)
    ToolBar: TToolBar;
    pnlMensagem: TPanel;
    pnlEditor: TPanel;
    MemoScript: TMemo;
    lbMensagem: TLabel;
    btnSair: TButton;
    btnCarregar: TButton;
    btnSalvar: TButton;
    btnExecutar: TButton;
    btnLimpar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
  public
    { Public declarations }
    Alias: string;
  end;

var
  fEditorScript: TfEditorScript;

implementation

{$R *.fmx}

procedure TfEditorScript.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Editor Script';
  fdm := TfDAC.Create(Self);
end;

procedure TfEditorScript.FormShow(Sender: TObject);
begin
  inherited;
  fdm.GetConnection(Alias);
  MemoScript.SetFocus;
end;

procedure TfEditorScript.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fEditorScript.Release;
  fEditorScript := nil;
end;

// Botões de comando

procedure TfEditorScript.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfEditorScript.btnCarregarClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(Self);
  od.InitialDir := ExtractFilePath(ParamStr(0));
  od.Filter :=
    'Todos (*.*)|*.*|Roteiros (sql)|*.sql|Roteiros (txt)|*.txt';

  if od.Execute then
  begin
    MemoScript.Lines.LoadFromFile(od.FileName);
    MemoScript.SetFocus;
  end;

  od.Free;
end;

procedure TfEditorScript.btnSalvarClick(Sender: TObject);
var
  sd: TOpenDialog;
begin
  sd := TOpenDialog.Create(Self);
  sd.InitialDir := ExtractFilePath(ParamStr(0));
  sd.Filter :=
    'Todos (*.*)|*.*|Roteiros (sql)|*.sql|Toteiros (txt)|*.txt';
  sd.DefaultExt := 'sql';
  sd.FileName := 'Roteiro.sql';

  if sd.Execute then
  begin
    MemoScript.Lines.SaveToFile(sd.FileName);
  end;

  sd.Free;
end;

procedure TfEditorScript.btnExecutarClick(Sender: TObject);
begin
  if MemoScript.Lines.Count = 0 then
  begin
    ShowMessage('Forneça o roteiro!');
    MemoScript.SetFocus;
    Exit;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      AddStrings(MemoScript.Lines);
    end;
    ValidateAll;
    ExecuteAll;
    if TotalErrors > 0 then
    begin
      fdm.RollbackUpdateTransaction();
      lbMensagem.Text := 'Erros na execução do roteiro: ' +
        IntToStr(TotalErrors);
    end
    else
    begin
      lbMensagem.Text := 'Roteiro executado!';
      fdm.CommitUpdateTransaction;
      MemoScript.Lines.Clear;
    end;
  end;
end;

procedure TfEditorScript.btnLimparClick(Sender: TObject);
begin
  MemoScript.Lines.Clear;
  MemoScript.SetFocus;
end;

end.

