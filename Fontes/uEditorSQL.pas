unit uEditorSQL;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, Data.Bind.Controls, System.Rtti, FMX.Layouts, FMX.Grid, FMX.ListBox,
  Fmx.Bind.Navigator, uDAC, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.Grid, FireDAC.Comp.Client, FMX.Memo;

type
  TfEditorSQL = class(TfxForm)
    ToolBar: TToolBar;
    pnlNavegador: TPanel;
    BindNavigator: TBindNavigator;
    pnlMetadados: TPanel;
    Label2: TLabel;
    cbTabelas: TComboBox;
    Label1: TLabel;
    cbVisoes: TComboBox;
    pnlEditor: TPanel;
    Splitter: TSplitter;
    pnlDados: TPanel;
    grdDados: TStringGrid;
    BindingsList: TBindingsList;
    BindSourceDBDados: TBindSourceDB;
    MemoSQL: TMemo;
    LinkGridToDataSourceBindSourceDBDados: TLinkGridToDataSource;
    chkSQLPadrao: TCheckBox;
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
    procedure cbTabelasClosePopup(Sender: TObject);
    procedure cbVisoesClosePopup(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    procedure RecuperaTabelas;
    procedure RecuperaVisoes;
  public
    { Public declarations }
    Alias: string;
  end;

var
  fEditorSQL: TfEditorSQL;

implementation

{$R *.fmx}

procedure TfEditorSQL.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Editor SQL';
  fdm := TfDAC.Create(Self);
end;

procedure TfEditorSQL.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaTabelas;
    if cbTabelas.Count > 0 then
      cbTabelas.ItemIndex := 0;
    RecuperaVisoes;
    if cbVisoes.Count > 0 then
      cbVisoes.ItemIndex := 0;
  end;
  MemoSQL.SetFocus;
end;

procedure TfEditorSQL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fEditorSQL.Release;
  fEditorSQL := nil;
end;

procedure TfEditorSQL.RecuperaTabelas;
begin
  fdm.GetTables(cbTabelas, 0);
end;

procedure TfEditorSQL.RecuperaVisoes;
begin
  fdm.GetViews(nil, cbVisoes);
end;

// Botões de comando

procedure TfEditorSQL.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfEditorSQL.btnCarregarClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(Self);
  od.InitialDir := ExtractFilePath(ParamStr(0));
  od.Filter :=
    'Todos (*.*)|*.*|Instruções (sql)|*.sql|Instruções (txt)|*.txt';

  if od.Execute then
  begin
    MemoSQL.Lines.LoadFromFile(od.FileName);
    MemoSQL.SetFocus;
  end;

  od.Free;
end;

procedure TfEditorSQL.btnSalvarClick(Sender: TObject);
var
  sd: TOpenDialog;
begin
  sd := TOpenDialog.Create(Self);
  sd.InitialDir := ExtractFilePath(ParamStr(0));
  sd.Filter :=
    'Todos (*.*)|*.*|Instruções (sql)|*.sql|Instruções (txt)|*.txt';
  sd.DefaultExt := 'sql';
  sd.FileName := 'Instrucao.sql';

  if sd.Execute then
  begin
    MemoSQL.Lines.SaveToFile(sd.FileName);
  end;

  sd.Free;
end;

procedure TfEditorSQL.btnExecutarClick(Sender: TObject);
begin
  if MemoSQL.Lines.Count = 0 then
  begin
    ShowMessage('Forneça a instrução SQL');
    MemoSQL.SetFocus;
    Exit;
  end;

  with fdm.FDQuery do begin
    Close;
    SQL.Clear;
    SQL.AddStrings(MemoSQL.Lines);
    Open;
  end;

  BindSourceDBDados.DataSet := fdm.FDQuery;
  BindNavigator.DataSource := BindSourceDBDados;
end;

procedure TfEditorSQL.btnLimparClick(Sender: TObject);
begin
  MemoSQL.Lines.Clear;
  MemoSQL.SetFocus;
end;

// Eventos

procedure TfEditorSQL.cbTabelasClosePopup(Sender: TObject);
begin
  if chkSQLPadrao.IsChecked then
  begin
    MemoSQL.Lines.Clear;
    MemoSQL.Lines.Add('select * from ' + cbTabelas.Selected.Text);
    btnExecutarClick(Self);
  end;
end;

procedure TfEditorSQL.cbVisoesClosePopup(Sender: TObject);
begin
  if chkSQLPadrao.IsChecked then
  begin
    MemoSQL.Lines.Clear;
    MemoSQL.Lines.Add('select * from ' + cbVisoes.Selected.Text);
    btnExecutarClick(Self);
  end;
end;

end.
