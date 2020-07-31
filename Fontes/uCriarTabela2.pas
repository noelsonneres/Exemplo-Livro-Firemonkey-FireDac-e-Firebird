unit uCriarTabela2;

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
  FireDAC.Phys.Intf, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

type
  TfCriarTabela2 = class(TfxForm)
    pnlPrincipal: TPanel;
    pnlEdicao: TPanel;
    btnIncluirLista: TButton;
    btnAlterarLista: TButton;
    btnSalvar: TButton;
    Label4: TLabel;
    edTabela: TEdit;
    Label2: TLabel;
    cbTabelas: TComboBox;
    ToolBar: TToolBar;
    TabControl: TTabControl;
    tabEdicao: TTabItem;
    tabDDL: TTabItem;
    pnlMensagem: TPanel;
    lbMensagem: TLabel;
    MemoDDL: TMemo;
    Label1: TLabel;
    edColuna: TEdit;
    Label3: TLabel;
    edTamanho: TEdit;
    Label5: TLabel;
    edEscala: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edSegmento: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    edDefault: TEdit;
    Label15: TLabel;
    edComputedBy: TEdit;
    Panel1: TPanel;
    btnParaCima: TButton;
    btnParaBaixo: TButton;
    btnExcluir: TButton;
    mtGrid: TFDMemTable;
    mtGridColuna: TStringField;
    mtGridTipoDado: TStringField;
    mtGridCharSet: TStringField;
    mtGridCollate: TStringField;
    mtGridChavePrimaria: TStringField;
    mtGridDefault: TStringField;
    mtGridComputedBy: TStringField;
    BindSourceDBGrid: TBindSourceDB;
    BindingsList: TBindingsList;
    Grid: TGrid;
    mtGridID: TIntegerField;
    btnSair: TButton;
    btnCriar: TButton;
    btnEliminar: TButton;
    Label16: TLabel;
    edCheck: TEdit;
    mtGridCheck: TStringField;
    chkChavePrimaria: TCheckBox;
    chkNotNull: TCheckBox;
    cbTipoDado: TComboEdit;
    cbSubtipo: TComboEdit;
    cbCharSet: TComboEdit;
    cbCollate: TComboEdit;
    mtGridNotNull: TStringField;
    Label11: TLabel;
    edArray: TEdit;
    mtGridTamanho: TIntegerField;
    mtGridEscala: TIntegerField;
    mtGridSubtipo: TSmallintField;
    mtGridSegmento: TSmallintField;
    mtGridArray: TSmallintField;
    LinkGridToDataSourceBindSourceDBGrid: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirListaClick(Sender: TObject);
    procedure btnAlterarListaClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure cbTabelasClosePopup(Sender: TObject);
    procedure btnParaCimaClick(Sender: TObject);
    procedure btnParaBaixoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edTabelaClick(Sender: TObject);
    procedure edColunaEnter(Sender: TObject);
    procedure pnlEdicaoClick(Sender: TObject);
    procedure chkChavePrimariaClick(Sender: TObject);
    procedure cbTipoDadoClosePopup(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
  private
    { Private declarations }
    TipoDado: string;
    Operacao: string;
    Index: Integer;
    procedure RecuperaMetadados;
    procedure ShowDDL(AMetadado: string);
    procedure RecuperaDominios;
    procedure LimpaCampos;
    procedure HabilitaEdicao;
    procedure DesabilitaEdicao;
    procedure AssinalaValoresPadroes;
    procedure GridMove(ALinAnt, ALinAtu: Integer);
    function FormataTipo(ATipo, ATamanho, AEscala, ASubtipo, ASegmento,
      AVetor: string): string;
    procedure ExecutaScript(ASql: string);
  protected
    { Protected declarations }
  public
    { Public declarations }
    fdm: TfDAC;
  end;

var
  fCriarTabela2: TfCriarTabela2;

implementation

{$R *.fmx}

uses
  uxFuncs;

procedure TfCriarTabela2.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Tabelas (2)';
  TabControl.ActiveTab := tabEdicao;
  mtGrid.CreateDataSet;
end;

procedure TfCriarTabela2.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.FDConnection.Connected = True then
  begin
    RecuperaMetadados;
    if cbTabelas.Count > 0 then
    begin
      cbTabelas.ItemIndex := 0;
      ShowDDL(cbTabelas.Selected.Text);
    end;
    RecuperaDominios;
  end;
end;

procedure TfCriarTabela2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not mtGrid.IsEmpty then mtGrid.EmptyDataSet;
  fCriarTabela2.Release;
  fCriarTabela2 := nil;
end;

procedure TfCriarTabela2.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarTabela2.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbTabelas.Count = 0 then Exit;
  metadado := cbTabelas.Selected.Text;

  if Self.Confirma(
      'Eliminar a tabela ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop table ' + metadado + ';';
  ExecutaScript(ssql);
end;

procedure TfCriarTabela2.RecuperaMetadados;
begin
  fdm.GetTables(cbTabelas, 0);
end;

procedure TfCriarTabela2.RecuperaDominios;
var
  dominios: string;
  dominio: string;
  contador: Integer;
  I: Integer;
begin
  dominios := fdm.GetDomainsList;
  if dominios = '' then Exit;
  contador := StrToInt(mc_GetPiece(dominios, 1, ';'));
  for I := 2 to contador do begin
    dominio := mc_GetPiece(dominios, I, ';');
    cbTipoDado.Items.Add(dominio);
  end;
end;

procedure TfCriarTabela2.btnAlterarListaClick(Sender: TObject);
begin
  Operacao := 'Alterar Lista';
  Grid.Enabled := True;
  btnParaCima.Enabled := True;
  btnParaBaixo.Enabled := True;
  btnExcluir.Enabled := True;
  Grid.SetFocus;
end;

procedure TfCriarTabela2.btnSalvarClick(Sender: TObject);
var
  ssql: string;
  coluna, tipoDado, tamanho, escala, subtipo, segmento, vetor: string;
  charSet, collate: string;
  chave, notNull, default, computedBy, check: string;
  sqlChave: string;
  I, L: Integer;
begin
  edTabela.Text := Trim(AnsiUpperCase(edTabela.Text));
  ssql := 'create table ' + edTabela.Text + ' (';

  if Length(edTabela.Text) <= 28 then
    sqlChave := 'constraint PK_' + edTabela.Text + ' primary key ('
  else
    sqlChave := 'primary key (';

  mtGrid.First;

  while not mtGrid.Eof do begin
    coluna := mtGrid.FieldByName('Coluna').AsString;
    tipoDado := mtGrid.FieldByName('TipoDado').AsString;
    tamanho := mtGrid.FieldByName('Tamanho').AsString;
    escala := mtGrid.FieldByName('Escala').AsString;
    subtipo := mtGrid.FieldByName('Subtipo').AsString;
    segmento := mtGrid.FieldByName('Segmento').AsString;
    vetor := mtGrid.FieldByName('Array').AsString;
    charSet := mtGrid.FieldByName('CharSet').AsString;
    collate := mtGrid.FieldByName('Collate').AsString;
    chave := mtGrid.FieldByName('ChavePrimaria').AsString;
    notNull := mtGrid.FieldByName('NotNull').AsString;
    default := mtGrid.FieldByName('Default').AsString;
    computedBy := mtGrid.FieldByName('ComputedBy').AsString;
    check := mtGrid.FieldByName('Check').AsString;

    // Formata o tipo de dado
    tipoDado :=
      FormataTipo(tipoDado, tamanho, escala, subtipo, segmento, vetor);

    if charSet = 'NONE' then charSet := '';
    if collate = 'NONE' then collate := '';

    if (default <> '') or (check <> '') then
    begin
      charSet := '';
      collate := '';
    end;

    if (tipoDado = 'COMPUTED BY') then
      ssql := ssql + coluna + ' computed by (' + computedBy + ') '
    else
      ssql := ssql + coluna + ' ' + tipoDado + ' ';

    if (Copy(tipoDado, 1, 4) = 'CHAR') or
       (Copy(tipoDado, 1, 7) = 'VARCHAR') or
       (tipoDado = 'BLOB') or
       (tipoDado = 'DATE') or
       (tipoDado = 'TIME') or
       (tipoDado = 'TIMESTAMP') then
    begin
      if charSet <> '' then
        ssql := ssql + 'character set ' + charSet + ' ';
      if collate <> '' then
        ssql := ssql + 'collate ' + collate +  ' ';
      if notNull = 'SIM' then
        ssql := ssql + 'not null ';
      if default <> '' then
        ssql := ssql + 'default ' + QuotedStr(default) + ' ';
      if check <> '' then
        ssql := ssql + 'check (' + check + ') ';
    end
    else
    begin
      if tipoDado <> 'COMPUTED BY' then
      begin
        if default <> '' then
          ssql := ssql + 'default ' + default + ' ';
        if NotNull = 'SIM' then
          ssql := ssql + 'not null ';
      end;
      if check <> '' then
        ssql := ssql + ' check (' + check + ') ';
    end;

    ssql := Trim(ssql) + ', ';

    if chave = 'SIM' then
      sqlChave := sqlChave + coluna + ', ';

    // Próximo registro
    mtGrid.Next;
  end;

  sqlChave[Length(sqlChave) - 1] := ' ';
  sqlChave := Trim(sqlChave);
  ssql := ssql + sqlChave + '));';
  ExecutaScript(ssql);
end;

procedure TfCriarTabela2.ExecutaScript(ASql: string);
begin
  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ASql);
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
      cbTabelas.ItemIndex :=
        cbTabelas.Items.IndexOf(edTabela.Text);
      ShowDDL(edTabela.Text);
      lbMensagem.Text := 'Instrução executada!';
      Operacao := '';
      DesabilitaEdicao;
    end;
  end;
end;

procedure TfCriarTabela2.cbTabelasClosePopup(Sender: TObject);
begin
  if cbTabelas.Items.Count > 0 then
    ShowDDL(cbTabelas.Selected.Text);
end;

procedure TfCriarTabela2.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.AddStrings(fdm.GetTableDDL(AMetadado));
  end;
end;

// Eventos de edição

procedure TfCriarTabela2.btnCriarClick(Sender: TObject);
begin
  Operacao := 'Criar';
  Index := 0;
  TabControl.ActiveTab := tabEdicao;
  Grid.Enabled := False;
  btnParaCima.Enabled := False;
  btnParaBaixo.Enabled := False;
  btnExcluir.Enabled := False;
  HabilitaEdicao;
end;

procedure TfCriarTabela2.edColunaEnter(Sender: TObject);
begin
  if Operacao = 'Alterar Lista' then
  begin
    Operacao := 'Criar';
    Grid.Enabled := False;
    btnParaCima.Enabled := False;
    btnParaBaixo.Enabled := False;
    btnExcluir.Enabled := False;
  end;
end;

procedure TfCriarTabela2.edTabelaClick(Sender: TObject);
begin
  if Operacao = 'Alterar Lista' then
  begin
    Grid.Enabled := False;
    btnParaCima.Enabled := False;
    btnParaBaixo.Enabled := False;
    btnExcluir.Enabled := False;
  end;
end;

procedure TfCriarTabela2.cbTipoDadoClosePopup(Sender: TObject);
begin
  if (cbTipoDado.Text = 'COMPUTED BY') then
  begin
    edTamanho.Enabled := False;
    edEscala.Enabled := False;
    cbSubtipo.Enabled := False;
    edSegmento.Enabled := False;
    edArray.Enabled := False;
    cbCharSet.Enabled := False;
    cbCollate.Enabled := False;
    chkChavePrimaria.Enabled := False;
    chkNotNull.Enabled := False;
    edDefault.Enabled := False;
    edComputedBy.Enabled := True;
    edCheck.Enabled := False;
    edComputedBy.SetFocus;
  end
  else
  if (cbTipoDado.Text = 'NUMERIC') or
     (cbTipoDado.Text = 'DECIMAL') then
  begin
    edTamanho.Enabled := True;
    edEscala.Enabled := True;
    cbSubtipo.Enabled := False;
    edSegmento.Enabled := False;
    edArray.Enabled := True;
    cbCharSet.Enabled := False;
    cbCollate.Enabled := False;
    chkChavePrimaria.Enabled := True;
    chkNotNull.Enabled := True;
    edDefault.Enabled := True;
    edComputedBy.Enabled := False;
    edCheck.Enabled := True;
    edTamanho.SetFocus;
  end
  else
  if (cbTipoDado.Text = 'BLOB') then
  begin
    edTamanho.Enabled := False;
    edEscala.Enabled := False;
    cbSubtipo.Enabled := True;
    edSegmento.Enabled := True;
    edArray.Enabled := False;
    cbCharSet.Enabled := False;
    cbCollate.Enabled := False;
    chkChavePrimaria.Enabled := False;
    chkNotNull.Enabled := True;
    edDefault.Enabled := False;
    edComputedBy.Enabled := False;
    edCheck.Enabled := False;
    cbSubtipo.SetFocus;
  end
  else
  if (cbTipoDado.Text = 'CHAR') or
     (cbTipoDado.Text = 'VARCHAR') then
  begin
    edTamanho.Enabled := True;
    edEscala.Enabled := False;
    cbSubtipo.Enabled := False;
    edSegmento.Enabled := False;
    edArray.Enabled := True;
    cbCharSet.Enabled := True;
    cbCollate.Enabled := True;
    chkChavePrimaria.Enabled := True;
    chkNotNull.Enabled := True;
    edDefault.Enabled := True;
    edComputedBy.Enabled := False;
    edCheck.Enabled := True;
    edTamanho.SetFocus;
  end
  else
  begin
    edTamanho.Enabled := False;
    edEscala.Enabled := False;
    cbSubtipo.Enabled := False;
    edSegmento.Enabled := False;
    edArray.Enabled := True;
    cbCharSet.Enabled := False;
    cbCollate.Enabled := False;
    chkChavePrimaria.Enabled := True;
    chkNotNull.Enabled := True;
    edDefault.Enabled := True;
    edComputedBy.Enabled := False;
    edCheck.Enabled := True;
    chkChavePrimaria.SetFocus;
  end;
end;

procedure TfCriarTabela2.chkChavePrimariaClick(Sender: TObject);
begin
  if chkChavePrimaria.IsChecked then
  begin
    chkNotNull.IsChecked := False;
    edDefault.SetFocus;
  end
  else
  begin
    chkNotNull.IsChecked := True;
    edArray.Text := '';
    edDefault.SetFocus;
  end;
end;

procedure TfCriarTabela2.LimpaCampos;
begin
  edTabela.Text := '';
  edColuna.Text := '';
  mtGrid.EmptyDataSet;
  MemoDDL.Lines.Clear;
  AssinalaValoresPadroes;
  lbMensagem.Text := '';
end;

procedure TfCriarTabela2.pnlEdicaoClick(Sender: TObject);
begin
  if Operacao = 'Alterar Lista' then
  begin
    Operacao := 'Criar';
    Grid.Enabled := False;
    btnParaCima.Enabled := False;
    btnParaBaixo.Enabled := False;
    btnExcluir.Enabled := False;
  end;
end;

procedure TfCriarTabela2.AssinalaValoresPadroes;
begin
  edTamanho.Text := '';
  cbTipoDado.ItemIndex := 0;
  edEscala.Text := '';
  cbSubtipo.ItemIndex := 0;
  edSegmento.Text := '';
  edArray.Text := '';
  cbCharSet.ItemIndex := 0;
  cbCollate.ItemIndex := 0;
  chkChavePrimaria.IsChecked := False;
  chkNotNull.IsChecked := False;
  edDefault.Text := '';
  edComputedBy.Text := '';
  edCheck.Text := '';
end;

procedure TfCriarTabela2.btnIncluirListaClick(Sender: TObject);
begin
  if (chkChavePrimaria.IsChecked) then
    chkNotNull.IsChecked := True;

  Grid.Enabled := True;
  Inc(Index);

  mtGrid.Append;
  mtGrid.FieldByName('ID').AsInteger := Index;
  mtGrid.FieldByName('Coluna').AsString := edColuna.Text;
  mtGrid.FieldByName('TipoDado').AsString := cbTipoDado.Text;;
  mtGrid.FieldByName('Tamanho').AsString := edTamanho.Text;
  mtGrid.FieldByName('Escala').AsString := edEscala.Text;
  mtGrid.FieldByName('Subtipo').AsString := cbSubtipo.Text;
  mtGrid.FieldByName('Segmento').AsString := edSegmento.Text;
  mtGrid.FieldByName('Array').AsString := edArray.Text;
  mtGrid.FieldByName('CharSet').AsString := cbCharSet.Text;
  mtGrid.FieldByName('Collate').AsString := cbCollate.Text;

  if chkChavePrimaria.IsChecked then
    mtGrid.FieldByName('ChavePrimaria').AsString := 'SIM'
  else
    mtGrid.FieldByName('ChavePrimaria').AsString := 'NÃO';

  if chkNotNull.IsChecked then
    mtGrid.FieldByName('NotNull').AsString := 'SIM'
  else
    mtGrid.FieldByName('NotNull').AsString := 'NÃO';

  mtGrid.FieldByName('Default').AsString := edDefault.Text;
  mtGrid.FieldByName('ComputedBy').AsString := edComputedBy.Text;
  mtGrid.FieldByName('Check').AsString := edCheck.Text;
  mtGrid.Post;
  Grid.Enabled := False;
  edColuna.Text := '';
  AssinalaValoresPadroes;
  edColuna.SetFocus;
end;

procedure TfCriarTabela2.HabilitaEdicao;
begin
  LimpaCampos;
  edTabela.Enabled := True;
  edColuna.Enabled := True;
  cbTipoDado.Enabled := True;
  edTamanho.Enabled := True;
  edEscala.Enabled := True;
  cbSubtipo.Enabled := True;
  edSegmento.Enabled := True;
  edArray.Enabled := True;
  cbCharSet.Enabled := True;
  cbCollate.Enabled := True;
  chkChavePrimaria.Enabled := True;
  chkNotNull.Enabled := False;
  edDefault.Enabled := True;
  edComputedBy.Enabled := True;
  btnIncluirLista.Enabled := True;
  btnAlterarLista.Enabled := True;
  btnSalvar.Enabled := True;
  edTabela.SetFocus;
end;

procedure TfCriarTabela2.DesabilitaEdicao;
begin
  LimpaCampos;
  edTabela.Text := '';
  edTabela.Enabled := False;
  edColuna.Enabled := False;
  cbTipoDado.Enabled := False;
  edTamanho.Enabled := False;
  edEscala.Enabled := False;
  cbSubtipo.Enabled := False;
  edSegmento.Enabled := False;
  edArray.Enabled := True;
  cbCharSet.Enabled := False;
  cbCollate.Enabled := False;
  chkChavePrimaria.Enabled := False;
  chkNotNull.Enabled := False;
  edDefault.Enabled := False;
  edComputedBy.Enabled := False;
  btnIncluirLista.Enabled := False;
  btnAlterarLista.Enabled := False;
  btnSalvar.Enabled := False;
  cbTabelas.SetFocus;
end;

procedure TfCriarTabela2.btnParaCimaClick(Sender: TObject);
var
  idAnt: Integer;
  idAtu: Integer;
begin
  idAnt := mtGrid.FieldByName('ID').AsInteger;
  mtGrid.Prior;
  idAtu := mtGrid.FieldByName('ID').AsInteger;
  if idAnt > 1 then
    GridMove(idAnt, idAtu);
end;

procedure TfCriarTabela2.btnParaBaixoClick(Sender: TObject);
var
  idAnt: Integer;
  idAtu: Integer;
  idMax: Integer;
begin
  idAnt := mtGrid.FieldByName('ID').AsInteger;
  mtGrid.Next;
  idAtu := mtGrid.FieldByName('ID').AsInteger;
  mtGrid.Last;
  idMax := mtGrid.FieldByName('ID').AsInteger;
  if idAnt < idMax then
    GridMove(idAnt, idAtu);
end;

procedure TfCriarTabela2.btnExcluirClick(Sender: TObject);
begin
// Preenche a área de edição com os dados excluídos
  edColuna.Text := mtGrid.FieldByName('Coluna').AsString;
  cbTipoDado.Text := mtGrid.FieldByName('TipoDado').AsString;
  edTamanho.Text := mtGrid.FieldByName('Tamanho').AsString;
  edEscala.Text := mtGrid.FieldByName('Escala').AsString;
  cbSubTipo.Text := mtGrid.FieldByName('Subtipo').AsString;
  edSegmento.Text := mtGrid.FieldByName('Segmento').AsString;
  edArray.Text := mtGrid.FieldByName('Array').AsString;
  cbCharSet.Text := mtGrid.FieldByName('CharSet').AsString;
  cbCollate.Text := mtGrid.FieldByName('Collate').AsString;
  chkChavePrimaria.IsChecked :=
    (mtGrid.FieldByName('ChavePrimaria').AsString = 'SIM');
  chkNotNull.IsChecked :=
    (mtGrid.FieldByName('NotNull').AsString = 'SIM');
  edDefault.Text := mtGrid.FieldByName('Default').AsString;
  edComputedBy.Text := mtGrid.FieldByName('ComputedBy').AsString;
  edCheck.Text := mtGrid.FieldByName('Check').AsString;

// Elimina o item da lista
  mtGrid.Edit;
  mtGrid.Delete;
end;

procedure TfCriarTabela2.GridDblClick(Sender: TObject);
begin
  btnExcluirClick(Self);
end;

procedure TfCriarTabela2.GridMove(ALinAnt, ALinAtu: Integer);
var
  SAnt, SAtu: string;
  I: Integer;
begin
  mtGrid.Locate('ID', VarArrayOf([ALinAnt]), []);
  for I := 1 to 14 do
    SAnt := SAnt + mtGrid.Fields[I].AsString + ';';

  mtGrid.Locate('ID', VarArrayOf([ALinAtu]), []);
  for I := 1 to 14 do
    SAtu := SAtu + mtGrid.Fields[I].AsString + ';';

  mtGrid.Locate('ID', VarArrayOf([ALinAnt]), []);
  mtGrid.Edit;
  mtGrid.FieldByName('ID').AsInteger := ALinAnt;
  for I := 1 to 14 do
    mtGrid.Fields[I].AsString := mc_GetPiece(SAtu, I, ';');
  mtGrid.Post;

  mtGrid.Locate('ID', VarArrayOf([ALinAtu]), []);
  mtGrid.Edit;
  mtGrid.FieldByName('ID').AsInteger := ALinAtu;
  for I := 1 to 14 do
    mtGrid.Fields[I].AsString := mc_GetPiece(SAnt, I, ';');
  mtGrid.Post;
end;

function TfCriarTabela2.FormataTipo(ATipo, ATamanho, AEscala, ASubtipo,
  ASegmento, AVetor: string): string;
begin
  if (ATipo = 'CHAR') or
     (ATipo = 'VARCHAR') then
  begin
    Result := ATipo + '(' + ATamanho + ')';
    if (AVetor <> '') and (AVetor <> '0') then
      Result := Result + '[' + AVetor + ']';
  end
  else
  if (ATipo = 'NUMERIC') or
     (ATipo = 'DECIMAL') then
  begin
    Result := ATipo + '(' + ATamanho +
      ', ' + AEscala + ')';
    if (AVetor <> '') and (AVetor <> '0') then
      Result := Result + '[' + AVetor + ']';
  end
  else
  if (ATipo = 'BLOB') then
  begin
    Result := ATipo;
    if ASubtipo = '0' then
      Result := Result + ' SUB_TYPE 0 SEGMENT SIZE ' +
        ASegmento
    else
    if ASubtipo = '1' then
      Result := Result + ' SUB_TYPE 1 SEGMENT SIZE ' +
        ASegmento;
  end
  else
  begin
    Result := ATipo;
    if (AVetor <> '') and (AVetor <> '0') then
      Result := Result + '[' + AVetor + ']';
  end;
end;

end.
