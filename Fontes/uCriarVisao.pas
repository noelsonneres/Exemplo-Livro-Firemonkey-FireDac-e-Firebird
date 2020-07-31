unit uCriarVisao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, System.Rtti, Data.Bind.Controls, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.Grid, FMX.ListBox, FMX.Memo, FMX.TabControl, FMX.EditBox, FMX.SpinBox,
  FMX.Controls.Presentation, FMX.Edit, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, uDAC,
  FireDAC.Comp.Client, Data.DB, Datasnap.DBClient, FMX.ComboEdit,
  FireDAC.Phys.Intf;

type
  TfCriarVisao = class(TfxForm)
    pnlPrincipal: TPanel;
    pnlEdicao: TPanel;
    btnEditar: TButton;
    btnLimpar: TButton;
    btnSalvar: TButton;
    Label4: TLabel;
    edMetadado: TEdit;
    Label2: TLabel;
    cbMetadados: TComboBox;
    ToolBar: TToolBar;
    Label1: TLabel;
    cbTabelas: TComboBox;
    TabControl: TTabControl;
    tabEdicao: TTabItem;
    tabDDL: TTabItem;
    MemoMetadado: TMemo;
    pnlMensagem: TPanel;
    lbMensagem: TLabel;
    MemoDDL: TMemo;
    btnSair: TButton;
    btnCriar: TButton;
    btnEliminar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure cbMetadadosClosePopup(Sender: TObject);
  private
    { Private declarations }
    procedure RecuperaTabelas;
    procedure RecuperaMetadados;
    procedure ShowDDL(AMetadado: string);
    procedure ExecutaScript;
  protected
    { Protected declarations }
  public
    { Public declarations }
    fdm: TfDAC;
  end;

var
  fCriarVisao: TfCriarVisao;

implementation

{$R *.fmx}

procedure TfCriarVisao.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Visões';
  TabControl.ActiveTab := tabEdicao;
end;

procedure TfCriarVisao.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.FDConnection.Connected = True then
  begin
    RecuperaTabelas;
    if cbTabelas.Count > 0 then
      cbTabelas.ItemIndex := 0;
    RecuperaMetadados;
    if cbMetadados.Count > 0 then
    begin
      cbMetadados.ItemIndex := 0;
      ShowDDL(cbMetadados.Selected.Text);
    end;
  end;
end;

procedure TfCriarVisao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fCriarVisao.Release;
  fCriarVisao := nil;
end;

procedure TfCriarVisao.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarVisao.btnCriarClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  edMetadado.Enabled := True;
  MemoMetadado.Enabled := True;
  MemoMetadado.Lines.Clear;
  edMetadado.SetFocus;
end;

procedure TfCriarVisao.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbMetadados.Count = 0 then Exit;
  metadado := cbMetadados.Selected.Text;

  if Self.Confirma(
      'Eliminar a visão ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop view ' + metadado + ';';
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.Lines.Add(ssql);
  ExecutaScript;
end;

procedure TfCriarVisao.RecuperaTabelas;
begin
  fdm.GetTables(cbTabelas, 0);
end;

procedure TfCriarVisao.RecuperaMetadados;
begin
  fdm.GetViews(nil, cbMetadados);
end;

procedure TfCriarVisao.btnEditarClick(Sender: TObject);
var
  ssql: string;
  colunas: string;
  listFields: TStrings;
  I: Integer;
begin
  if MemoMetadado.Lines.Count > 0 then Exit;
  edMetadado.Text := Trim(AnsiUpperCase(edMetadado.Text));

  if edMetadado.Text = '' then
  begin
    ShowMessage('Informe o nome da visão!');
    edMetadado.SetFocus;
    Exit;
  end;

  if cbTabelas.Selected.Text = '' then
  begin
    ShowMessage('Não existem tabelas no banco!');
    edMetadado.SetFocus;
    Exit;
  end;

  listFields := TStringList.Create;

  fdm.FDConnection.GetFieldNames(
    '',
    '',
    cbTabelas.Selected.Text,
    '',
    listFields
    );

  colunas := '';

  for I := 0 to listFields.Count - 1 do begin
    if I = 0 then
      colunas := colunas + listFields.Strings[I] + ', ' + #13#10
    else
    if I = listFields.Count - 1 then
      colunas := colunas + listFields.Strings[I] + #13#10
    else
      colunas := colunas + listFields.Strings[I] + ',' + #13#10;
  end;

  TabControl.ActiveTab := tabEdicao;
  ssql := 'CREATE VIEW ' + edMetadado.Text + ' AS ' + #13#10;
  ssql := ssql + 'SELECT ' + #13#10;
  ssql := ssql + colunas;
  ssql := ssql + 'FROM ' + cbTabelas.Selected.Text + ';';
  MemoMetadado.Lines.Add(ssql);
  MemoMetadado.SetFocus;
  listFields.Free;
end;

procedure TfCriarVisao.btnLimparClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.SetFocus;
end;

procedure TfCriarVisao.btnSalvarClick(Sender: TObject);
begin
  ExecutaScript;
end;

procedure TfCriarVisao.ExecutaScript;
begin
  if MemoMetadado.Lines.Count = 0 then
  begin
    lbMensagem.Text := 'Sem instrução para executar!';
    Exit;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      AddStrings(MemoMetadado.Lines);
    end;
    ValidateAll;
    ExecuteAll;
    if TotalErrors > 0 then
    begin
      fdm.RollbackUpdateTransaction;
      lbMensagem.Text := 'Erros na execução: ' +
        IntToStr(TotalErrors);
    end
    else
    begin
      fdm.CommitUpdateTransaction;
      RecuperaMetadados;

      if edMetadado.Text <> '' then
      begin
        cbMetadados.ItemIndex :=
          cbMetadados.Items.IndexOf(edMetadado.Text);
      end
      else
      begin
        if cbMetadados.Count > 0 then
          cbMetadados.ItemIndex := 0;
      end;

      ShowDDL(edMetadado.Text);
      edMetadado.Text := '';
      edMetadado.Enabled := False;
      MemoMetadado.Enabled := False;
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfCriarVisao.cbMetadadosClosePopup(Sender: TObject);
begin
  ShowDDL(cbMetadados.Selected.Text);
end;

procedure TfCriarVisao.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.Add(fdm.GetViewDDL(AMetadado));
  end;
end;

end.
