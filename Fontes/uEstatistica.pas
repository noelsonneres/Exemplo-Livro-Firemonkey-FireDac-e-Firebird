unit uEstatistica;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, FMX.ComboEdit, FMX.Layouts, FMX.Memo, FMX.ListBox, FMX.Edit,
  FMX.Controls.Presentation, Winapi.Windows, FireDAC.Comp.Client,
  uDAC;

type
  TfEstatistica = class(TfxForm)
    ToolBar: TToolBar;
    btnSair: TButton;
    btnExecutar: TButton;
    btnLimpar: TButton;
    pnlEdicao: TPanel;
    chkTabelasSistema: TCheckBox;
    chkVersoesRegistros: TCheckBox;
    pnlMensagem: TPanel;
    MemoLog: TMemo;
    cbTabelas: TComboEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    { Private declarations }
    procedure RecuperaTabelas;
  public
    { Public declarations }
    fdm: TfDAC;
    Banco: string;
  end;

var
  fEstatistica: TfEstatistica;

implementation

{$R *.fmx}

uses
  uxFuncs,
  uMensagem;

procedure TfEstatistica.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Estatísticas';
end;

procedure TfEstatistica.FormShow(Sender: TObject);
begin
  inherited;
  RecuperaTabelas;
end;

procedure TfEstatistica.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fEstatistica.Release;
  fEstatistica := nil;
end;

procedure TfEstatistica.RecuperaTabelas;
begin
  fdm.GetTables(cbTabelas, 0, '<Todas>');
  if cbTabelas.Count > 0 then
    cbTabelas.ItemIndex := 0;
end;

procedure TfEstatistica.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfEstatistica.btnExecutarClick(Sender: TObject);
var
  opcoes: string;
begin
  opcoes := '-a ';

  if chkTabelasSistema.IsChecked = True then
    opcoes := opcoes + '-s ';

  if chkVersoesRegistros.IsChecked = True then
    opcoes := opcoes + '-r ';

  MemoLog.Lines.Clear;
  MemoLog.Lines.AddStrings(
    fdm.GetStatistics(Banco, opcoes, cbTabelas.Text));
end;

procedure TfEstatistica.btnLimparClick(Sender: TObject);
begin
  MemoLog.Lines.Clear;
end;

end.

