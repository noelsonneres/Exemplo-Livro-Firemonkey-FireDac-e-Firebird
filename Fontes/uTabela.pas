unit uTabela;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, uxForm, System.Rtti, FMX.Layouts, FMX.Grid,
  FMX.TabControl, uDAC, Data.Bind.Controls, Fmx.Bind.Navigator,
  FMX.Controls.Presentation, FMX.Edit, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Grid, FMX.ListBox,
  FMX.Memo, Datasnap.DBClient;

type
  TfTabela = class(TfxForm)
    pnlTabelas: TPanel;
    TabControlDados: TTabControl;
    tabDados: TTabItem;
    tabPropriedades: TTabItem;
    grdDados: TGrid;
    pnlNavegacao: TPanel;
    ToolBar: TToolBar;
    ToolBar2: TToolBar;
    pnlPesquisa: TPanel;
    Label1: TLabel;
    edField: TEdit;
    BindNavigator: TBindNavigator;
    Label2: TLabel;
    cbTabelas: TComboBox;
    lbField: TLabel;
    BindSourceDBColunas: TBindSourceDB;
    BindSourceDBIndices: TBindSourceDB;
    BindSourceDBColunasIndice: TBindSourceDB;
    BindSourceDBRestricoesUnique: TBindSourceDB;
    BindSourceDBColunasRestricaoUnique: TBindSourceDB;
    BindSourceDBRestricoesCheck: TBindSourceDB;
    BindSourceDBIntegridadeReferencial: TBindSourceDB;
    tabControlPropriedades: TTabControl;
    tabColunas: TTabItem;
    grdColunas: TGrid;
    tabIndices: TTabItem;
    SplitterIndices: TSplitter;
    pnlGrdIndices: TPanel;
    grdIndices: TGrid;
    pnlGrdColunasIndice: TPanel;
    pnlNomeIndice: TPanel;
    Label3: TLabel;
    grdColunasIndice: TGrid;
    tabRestricoesUnique: TTabItem;
    Panel7: TPanel;
    Panel8: TPanel;
    Label4: TLabel;
    grdColunasRestricaoUnique: TGrid;
    Splitter3: TSplitter;
    Panel9: TPanel;
    grdRestricoesUnique: TGrid;
    tabRestricoesCheck: TTabItem;
    Panel10: TPanel;
    grdRestricoesCheck: TGrid;
    Splitter2: TSplitter;
    Panel11: TPanel;
    Panel12: TPanel;
    Label5: TLabel;
    MemoDDLRestricaoCheck: TMemo;
    tabIntegridadeReferencial: TTabItem;
    grdIntegridadeReferencial: TGrid;
    tabGatilhos: TTabItem;
    Splitter4: TSplitter;
    tabPrivilegios: TTabItem;
    tabDDL: TTabItem;
    grdGatilhos: TGrid;
    pnlDDLGatilho: TPanel;
    pnlNomeGatilho: TPanel;
    Label6: TLabel;
    MemoDDLGatilho: TMemo;
    BindSourceDBGatilhos: TBindSourceDB;
    grdPrivilegios: TGrid;
    MemoDDLTabela: TMemo;
    BindSourceDBPrivilegios: TBindSourceDB;
    cdsColunas: TClientDataSet;
    cdsColunasnumero: TSmallintField;
    cdsColunasnome: TStringField;
    cdsColunastipo: TStringField;
    cdsColunascaractere: TStringField;
    cdsColunasordenacao: TStringField;
    cdsColunasnulo: TStringField;
    cdsColunasdefault: TStringField;
    cdsColunasdominio: TStringField;
    cdsIndices: TClientDataSet;
    cdsIndicesindex_name: TStringField;
    cdsIndicesunique_flag: TStringField;
    cdsIndicesindex_type: TStringField;
    cdsRestricoesUnique: TClientDataSet;
    StringField1: TStringField;
    cdsRestricoesCheck: TClientDataSet;
    cdsRestricoesCheckconstraint_name: TStringField;
    cdsRestricoesChecktrigger_type: TStringField;
    cdsRestricoesChecktrigger_name: TStringField;
    cdsRestricoesChecktrigger_source: TMemoField;
    cdsIntegridadeReferencial: TClientDataSet;
    StringField2: TStringField;
    cdsIntegridadeReferencialrelation_name: TStringField;
    cdsIntegridadeReferencialupdate_rule: TStringField;
    cdsIntegridadeReferencialdelete_rule: TStringField;
    cdsGatilhos: TClientDataSet;
    StringField5: TStringField;
    StringField4: TStringField;
    MemoField1: TMemoField;
    cdsGatilhostrigger_inactive: TStringField;
    cdsPrivilegios: TClientDataSet;
    cdsPrivilegiosusuario: TStringField;
    cdsPrivilegiosselect: TStringField;
    cdsPrivilegiosupdate: TStringField;
    cdsPrivilegiosdelete: TStringField;
    cdsPrivilegiosinsert: TStringField;
    cdsPrivilegiosreference: TStringField;
    cdsColunasIndice: TClientDataSet;
    cdsColunasIndicefield_position: TSmallintField;
    cdsColunasIndicefield_name: TStringField;
    cdsColunasIndiceindex_type: TStringField;
    cdsColunasRestricaoUnique: TClientDataSet;
    SmallintField1: TSmallintField;
    StringField3: TStringField;
    chkAbrirTabela: TCheckBox;
    cdsColunascomputedBy: TMemoField;
    btnSair: TButton;
    btnCriar: TButton;
    btnAbrir: TButton;
    btnFechar: TButton;
    btnOrdenar: TButton;
    btnCommit: TButton;
    btnRollback: TButton;
    btnCriar2: TButton;
    Label7: TLabel;
    BindingsList: TBindingsList;
    LinkGridToDataSourceBindSourceDBDados: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBIndices: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBColunas: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBRestricoesUnique: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBColunasIndice: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBColunasRestricaoUnique: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBRestricoesCheck: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBGatilhos: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBIntegridadeReferencial: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDBPrivilegios: TLinkGridToDataSource;
    BindSourceDBDados: TBindSourceDB;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAbrirClick(Sender: TObject);
    procedure TabControlDadosChange(Sender: TObject);
    procedure tabControlPropriedadesChange(Sender: TObject);
    procedure cdsIndicesAfterScroll(DataSet: TDataSet);
    procedure cdsRestricoesUniqueAfterScroll(DataSet: TDataSet);
    procedure btnFecharClick(Sender: TObject);
    procedure btnCommitClick(Sender: TObject);
    procedure edFieldKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure grdDadosHeaderClick(Column: TColumn);
    procedure btnRollbackClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure cbTabelasChange(Sender: TObject);
    procedure chkAbrirTabelaChange(Sender: TObject);
    procedure btnOrdenarClick(Sender: TObject);
    procedure btnCriar2Click(Sender: TObject);
  private
    { Private declarations }
    FParentTabControl: TTabControl;
    fdm: TfDAC;
    Indice: Integer;
    xSelectSQL: string;

    xSelect: string;
    xWhere: string;
    xOrderBy: string;
    LastOrder: string;

    procedure CriaClientsDataSet;
    procedure LimpaClientsDataSet;

    procedure ShowTriggerDDL(DataSet: TDataSet);
    procedure ShowCheckConstraintDDL(DataSet: TDataSet);
    procedure RecuperaTabelas;
    procedure AbreTabela;

    procedure RecuperaColunas;
    procedure RecuperaIndices;
    procedure RecuperaRestricoesUnique;
    procedure RecuperaRestricoesCheck;
    procedure RecuperaIntegridadeReferencial;
    procedure RecuperaGatilhos;
    procedure RecuperaPrivilegios;
    procedure RecuperaDDLTabela;

    procedure MontaComandoSelect;
    procedure MontaComandoSelect2;
    procedure MontaComandoSelect3;
    procedure MontaClausulaWhere;

    function TrataArgumento(AArg: string): string;
    function TrataTermo(AArg: string): string;
  protected
    { Protected declarations }
    TabForm: TTabItem;
    procedure VerificaTabControl;
  public
    { Public declarations }
    Alias: string;
    NovaTela: Boolean;
    NomeTabela: string;
    Tag: Integer;
    property ParentTabControl: TTabControl
        read FParentTabControl write FParentTabControl;
  end;

var
  fTabela: TfTabela;

implementation

{$R *.fmx}

uses
  uCriarTabela, uCriarTabela2;

{ TfTabela }

procedure TfTabela.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Tabelas';
  fdm := TfDAC.Create(Self);
  fdm.FDQuery.CachedUpdates := True;
  fdm.FDQuery.Transaction := fdm.FDDefaultTransaction;
  fdm.FDQuery.UpdateTransaction := fdm.FDUpdateTransaction;

  NomeTabela := '';
  Indice := 0;
  xSelect := '';
  xWhere := '';
  xOrderBy := '';
  LastOrder := 'desc';

  BindSourceDBDados.DataSet := fdm.FDQuery;
  BindNavigator.DataSource := BindSourceDBDados;

  CriaClientsDataSet;
  cdsGatilhos.AfterScroll := ShowTriggerDDL;
  cdsRestricoesCheck.AfterScroll := ShowCheckConstraintDDL;

  Self.GetStatusGrid(grdColunas, Self);
  Self.GetStatusGrid(grdIndices, Self);
  Self.GetStatusGrid(grdColunasIndice, Self);
  Self.GetStatusGrid(grdRestricoesUnique, Self);
  Self.GetStatusGrid(grdColunasRestricaoUnique, Self);
  Self.GetStatusGrid(grdRestricoesCheck, Self);
  Self.GetStatusGrid(grdIntegridadeReferencial, Self);
  Self.GetStatusGrid(grdGatilhos, Self);
end;

procedure TfTabela.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControlDados.ActiveTab := tabDados;
  TabControlPropriedades.ActiveTab := tabColunas;

  if fdm.GetConnection(Alias) = True then
  begin
    lbField.Text := '';
    RecuperaTabelas;
    if (Tag = 1) or (Tag = 10) then
    begin
      if cbTabelas.Count > 0 then
        cbTabelas.ItemIndex := cbTabelas.Items.IndexOf(NomeTabela);
    end
    else
    begin
      if cbTabelas.Count > 0 then
      begin
        cbTabelas.ItemIndex := 0;
        NomeTabela := cbTabelas.Selected.Text;
      end;
    end;
  end;

  if (Tag = 10) or (Tag = -10) then
    btnCriar.Visible := False;
end;

procedure TfTabela.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  LimpaClientsDataSet;
  Self.SetStatusGrid(grdColunas, Self);
  Self.SetStatusGrid(grdIndices, Self);
  Self.SetStatusGrid(grdColunasIndice, Self);
  Self.SetStatusGrid(grdRestricoesUnique, Self);
  Self.SetStatusGrid(grdColunasRestricaoUnique, Self);
  Self.SetStatusGrid(grdRestricoesCheck, Self);
  Self.SetStatusGrid(grdIntegridadeReferencial, Self);
  Self.SetStatusGrid(grdGatilhos, Self);
  fTabela.Release;
  fTabela := nil;
end;

procedure TfTabela.CriaClientsDataSet;
begin
  cdsColunas.CreateDataSet;
  cdsIndices.CreateDataSet;
  cdsColunasIndice.CreateDataSet;
  cdsRestricoesUnique.CreateDataSet;
  cdsColunasRestricaoUnique.CreateDataSet;
  cdsRestricoesCheck.CreateDataSet;
  cdsIntegridadeReferencial.CreateDataSet;
  cdsGatilhos.CreateDataSet;
  cdsPrivilegios.CreateDataSet;
end;

procedure TfTabela.LimpaClientsDataSet;
begin
  if not cdsColunas.IsEmpty then
    cdsColunas.EmptyDataSet;
  if not cdsIndices.IsEmpty = True then
    cdsIndices.EmptyDataSet;
  if not cdsColunasIndice.IsEmpty then
    cdsColunasIndice.EmptyDataSet;
  if not cdsRestricoesUnique.IsEmpty then
    cdsRestricoesUnique.EmptyDataSet;
  if not cdsColunasRestricaoUnique.IsEmpty then
    cdsColunasRestricaoUnique.EmptyDataSet;
  if not cdsRestricoesCheck.IsEmpty then
    cdsRestricoesCheck.EmptyDataSet;
  if not cdsIntegridadeReferencial.IsEmpty then
    cdsIntegridadeReferencial.EmptyDataSet;
  if not cdsGatilhos.IsEmpty then
    cdsGatilhos.EmptyDataSet;
  if not cdsPrivilegios.IsEmpty then
    cdsPrivilegios.EmptyDataSet;
end;

procedure TfTabela.VerificaTabControl;
var
  I: Integer;
begin
  if NovaTela = False then Exit;
  if not Assigned(ParentTabControl) then Exit;

  if ParentTabControl.TabCount > 0 then
  begin
    for I := 0 to ParentTabControl.TabCount - 1 do begin
      if ParentTabControl.Tabs[I].Name = 'tab' + Self.Name then
      begin
        ParentTabControl.Delete(I);
        Break;
      end;
    end;
  end;

  TabForm := TTabItem.Create(ParentTabControl);
  TabForm := ParentTabControl.Add(nil);
  TabForm.Name := 'tab' + Self.Name;
  TabForm.Text := Self.Caption;
  ParentTabControl.ActiveTab := TabForm;

  while Self.ChildrenCount > 0 do
    Children[0].Parent := TabForm;
end;

procedure TfTabela.btnSairClick(Sender: TObject);
begin
  inherited;
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfTabela.btnCriarClick(Sender: TObject);
begin
  try
    fCriarTabela := TfCriarTabela.Create(Application);
    fCriarTabela.fdm := Self.fdm;
    fCriarTabela.ShowModal;
  finally
    fCriarTabela.Free;
    RecuperaTabelas;
    if (Tag = 1) or (Tag = 10) then
    begin
      if cbTabelas.Count > 0 then
        cbTabelas.ItemIndex := cbTabelas.Items.IndexOf(NomeTabela);
    end
    else
    begin
      if cbTabelas.Count > 0 then
      begin
        cbTabelas.ItemIndex := 0;
        NomeTabela := cbTabelas.Selected.Text;
      end;
    end;
  end;
end;

procedure TfTabela.btnCriar2Click(Sender: TObject);
begin
  try
    fCriarTabela2 := TfCriarTabela2.Create(Application);
    fCriarTabela2.fdm := Self.fdm;
    fCriarTabela2.ShowModal;
  finally
    fCriarTabela2.Free;
    RecuperaTabelas;
    if (Tag = 1) or (Tag = 10) then
    begin
      if cbTabelas.Count > 0 then
        cbTabelas.ItemIndex := cbTabelas.Items.IndexOf(NomeTabela);
    end
    else
    begin
      if cbTabelas.Count > 0 then
      begin
        cbTabelas.ItemIndex := 0;
        NomeTabela := cbTabelas.Selected.Text;
      end;
    end;
  end;
end;

procedure TfTabela.btnAbrirClick(Sender: TObject);
begin
  AbreTabela;
  grdDados.SetFocus;
end;

procedure TfTabela.btnFecharClick(Sender: TObject);
begin
  fdm.FDQuery.Close;
  LimpaClientsDataSet;
end;

procedure TfTabela.btnCommitClick(Sender: TObject);
var
  iErrors: Integer;
begin
  if Self.Confirma('Salvar atualizações Pendentes?', 'N') = False then
    Exit;

  with fdm.FDQuery do begin
    if (CachedUpdates) and (UpdatesPending) then
    begin
      fdm.StartUpdateTransaction();
      iErrors := fdm.FDQuery.ApplyUpdates();
      if iErrors = 0 then
      begin
        fdm.FDQuery.CommitUpdates;
        fdm.CommitUpdateTransaction();
      end
      else
      begin
        fdm.RollbackUpdateTransaction();
      end;
    end;
  end;
end;

procedure TfTabela.btnRollbackClick(Sender: TObject);
begin
  if Self.Confirma('Salvar atualizações Pendentes?', 'S') = True then
  begin
    fdm.FDQuery.CancelUpdates;
    fdm.FDQuery.Refresh;
  end;
end;

procedure TfTabela.btnOrdenarClick(Sender: TObject);
var
  localSelect: string;
  localWhere: string;
begin
  if fdm.FDQuery.IsEmpty then Exit;

  if lbField.Text = '' then
  begin
    lbField.Text := BindSourceDBDados.DataSet.Fields.Fields[0].FieldName;
  end;

  localSelect := xSelectSQL;
  localWhere := xWhere;

  if LastOrder = 'desc' then
  begin
    LastOrder := '';
    localSelect := localSelect + localWhere + ' order by ' +
      lbField.Text;
  end
  else
  begin
    LastOrder := 'desc';
    localSelect := localSelect + localWhere + ' order by ' +
      lbField.Text + ' ' + LastOrder;
  end;

  with fdm.FDQuery do begin
    Close;
    SQL.Clear;
    SQL.Add(localSelect);
    Open;
  end;

  BindSourceDBDados.DataSet := fdm.FDQuery;
  BindNavigator.DataSource := BindSourceDBDados;
end;

procedure TfTabela.RecuperaTabelas;
begin
  if (Tag = 1) or (Tag = -1) then
  begin
    fdm.GetTables(cbTabelas, 0);
  end;
  if (Tag = 10) or (Tag = -10) then
  begin
    fdm.GetTables(cbTabelas, 1);
  end;
end;

procedure TfTabela.TabControlDadosChange(Sender: TObject);
begin
  if TabControlDados.ActiveTab = tabPropriedades then
    TabControlPropriedadesChange(Self);
end;

procedure TfTabela.tabControlPropriedadesChange(Sender: TObject);
begin
  if TabControlPropriedades.ActiveTab = tabColunas then
    RecuperaColunas;
  if TabControlPropriedades.ActiveTab = tabIndices then
    RecuperaIndices;
  if TabControlPropriedades.ActiveTab = tabRestricoesUnique then
    RecuperaRestricoesUnique;
  if TabControlPropriedades.ActiveTab = tabRestricoesCheck then
    RecuperaRestricoesCheck;
  if TabControlPropriedades.ActiveTab = tabIntegridadeReferencial then
    RecuperaIntegridadeReferencial;
  if TabControlPropriedades.ActiveTab = tabGatilhos then
    RecuperaGatilhos;
  if TabControlPropriedades.ActiveTab = tabPrivilegios then
    RecuperaPrivilegios;
  if TabControlPropriedades.ActiveTab = tabDDL then
    RecuperaDDLTabela;
end;

procedure TfTabela.RecuperaColunas;
var
  ssql: string;
  qryX: TFDQuery;
  qryY: TFDQuery;
  numero: Smallint;
  nome, tipo, default, nulo, caractere, ordenacao, dominio: string;
  computedBy: string;
  sVetor: string;
  iLower: Integer;
  iUpper: Integer;
  subTipo, segmento: string;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  qryY := TFDQuery.Create(Self);
  qryY.Connection := fdm.FDConnection;
  cdsColunas.EmptyDataSet;

  ssql := ' select r.rdb$field_name '
        + '      , r.rdb$null_flag '
        + '      , r.rdb$collation_id '
        + '      , r.rdb$field_position '
        + '      , r.rdb$default_source '
        + '      , r.rdb$field_source '
        + '      , f.rdb$field_sub_type '
        + '      , f.rdb$character_set_id '
        + '      , f.rdb$field_length '
        + '      , f.rdb$field_scale '
        + '      , f.rdb$field_precision '
        + '      , f.rdb$computed_source '
        + '      , f.rdb$segment_length '
        + '      , t.rdb$type_name '
        + '   from rdb$relation_fields r '
        + '   join rdb$fields f on '
        + '        f.rdb$field_name = r.rdb$field_source '
        + '   join rdb$types  t on '
        + '        t.rdb$type = f.rdb$field_type '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '    and t.rdb$field_name  = ''RDB$FIELD_TYPE'' '
        + '  order by r.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      numero := FieldByName('rdb$field_position').AsInteger;
      nome := FieldByName('rdb$field_name').AsString;
      default := FieldByName('rdb$default_source').AsString;
      dominio := FieldByName('rdb$field_source').AsString;
      computedBy := FieldByName('rdb$computed_source').AsString;
      subTipo := FieldByName('rdb$field_sub_type').AsString;
      segmento := FieldByName('rdb$segment_length').AsString;
      caractere := '';
      ordenacao := '';

      ssql := ' select rdb$lower_bound, '
            + '        rdb$upper_bound '
            + '   from rdb$field_dimensions '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(AnsiUpperCase(dominio))
            + '  order by rdb$dimension ';

      with qryY do begin
        sVetor := '';
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        while not Eof do begin
          iLower := FieldByName('rdb$lower_bound').AsInteger;
          iUpper := FieldByName('rdb$upper_bound').AsInteger;
          if iLower = 0 then
          begin
            sVetor := IntToStr(iLower) + ':' + IntToStr(iUpper);
          end
          else
          begin
            if sVetor <> '' then
              sVetor := sVetor + ',';
            sVetor := sVetor + IntToStr(iUpper);
          end;
          Next;
        end;
        if sVetor <> '' then
          sVetor := '[' + sVetor + ']';
      end;

      if FieldByName('rdb$character_set_id').AsString <> '' then
      begin
        ssql := ' select rdb$character_set_name '
              + '   from rdb$character_sets '
              + '  where rdb$character_set_id = '
              +          FieldByName('rdb$character_set_id').AsString;

        caractere := fdm.ExecutaQuery(ssql);
      end;

      if (FieldByName('rdb$character_set_id').AsString <> '') and
         (FieldByName('rdb$collation_id').AsString <> '') then
      begin
        ssql := ' select rdb$collation_name '
              + '   from rdb$collations '
              + '  where rdb$character_set_id = ' +
                         FieldByName('rdb$character_set_id').AsString
              + '    and rdb$collation_id = ' +
                         FieldByName('rdb$collation_id').AsString;

        ordenacao := fdm.ExecutaQuery(ssql);
      end;

      if FieldByName('rdb$null_flag').AsInteger = 1 then
        nulo := 'Não'
      else
        nulo := 'Sim';

//      if Copy(dominio, 1, 4) <> 'RDB$' then
//        tipo := dominio
//      else
        tipo := FieldByName('rdb$type_name').AsString;

      if tipo = 'DOUBLE' then
      begin
        tipo := 'DOUBLE PRECISION';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'FLOAT' then
      begin
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'BLOB' then
      begin
        if subTipo <> '' then
          tipo := tipo + ' SUB_TYPE ' + subTipo;
        if segmento <> '' then
          tipo := tipo + ' SEGMENT SIZE ' + segmento;
      end
      else
      if tipo = 'TEXT' then
      begin
        tipo := 'CHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'VARYING' then
      begin
        tipo := 'VARCHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'SHORT' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'SMALLINT'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'LONG' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'INTEGER'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'INT64' then
      begin
        if (FieldByName('rdb$field_sub_type').AsInteger = 0) then
        begin
          tipo := 'INT64';
        end
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end;

      cdsColunas.Append;
      cdsColunas.FieldByName('numero').AsString     := IntToStr(numero + 1);
      cdsColunas.FieldByName('nome').AsString       := nome;
      cdsColunas.FieldByName('tipo').AsString       := tipo;
      cdsColunas.FieldByName('caractere').AsString  := caractere;
      cdsColunas.FieldByName('ordenacao').AsString  := ordenacao;
      cdsColunas.FieldByName('nulo').AsString       := nulo;
      cdsColunas.FieldByName('default').AsString    := default;
      cdsColunas.FieldByName('dominio').AsString    := dominio;
      cdsColunas.FieldByName('computedBy').AsString := computedBy;
      cdsColunas.Post;

      Next;
    end;
  end;

  cdsColunas.First;
  BindSourceDBColunas.DataSet := cdsColunas;
  qryX.Free;
end;

procedure TfTabela.RecuperaIndices;
var
  ssql: string;
  qryX: TFDQuery;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsIndices.EmptyDataSet;

  ssql := ' select rdb$index_name '
        + '      , case rdb$unique_flag '
        + '             when 1 then ''Sim'' '
        + '             else ''Não'' '
        + '        end as rdb$unique_flag '
        + '      , case rdb$index_type '
        + '             when 1 then ''Descendente'' '
        + '             else ''Ascendente'' '
        + '        end as rdb$index_type '
        + '   from rdb$indices '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '  order by rdb$index_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsIndices.Append;
      cdsIndices.FieldByName('index_name').AsString :=
        FieldByName('rdb$index_name').AsString;
      cdsIndices.FieldByName('unique_flag').AsString :=
        FieldByName('rdb$unique_flag').AsString;
      cdsIndices.FieldByName('index_type').AsString :=
        FieldByName('rdb$index_type').AsString;
      cdsIndices.Post;
      Next;
    end;
  end;

  cdsIndices.First;
  BindSourceDBIndices.DataSet := cdsIndices;
  qryX.Free;
end;

procedure TfTabela.RecuperaRestricoesUnique;
var
  ssql: string;
  qryX: TFDQuery;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsRestricoesUnique.EmptyDataSet;

  ssql := ' select rdb$index_name '
        + '   from rdb$indices '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '    and rdb$unique_flag = 1 '
        + '  order by rdb$index_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsRestricoesUnique.Append;
      cdsRestricoesUnique.FieldByName('index_name').AsString :=
        FieldByName('rdb$index_name').AsString;
      cdsRestricoesUnique.Post;
      Next;
    end;
  end;

  cdsRestricoesUnique.First;
  BindSourceDBRestricoesUnique.DataSet := cdsRestricoesUnique;
  qryX.Free;
end;

procedure TfTabela.RecuperaRestricoesCheck;
var
  ssql: string;
  qryX: TFDQuery;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsRestricoesCheck.EmptyDataSet;

  ssql := ' select r.rdb$constraint_name '
        + '      , case t.rdb$trigger_type '
        + '          when 1   then ''BEFORE INSERT'' '
        + '          when 2   then ''AFTER INSERT'' '
        + '          when 3   then ''BEFORE UPDATE'' '
        + '          when 4   then ''AFTER UPDATE'' '
        + '          when 5   then ''BEFORE DELETE'' '
        + '          when 6   then ''AFTER DELETE'' '
        + '          when 17  then ''BEFORE INSERT OR UPDATE'' '
        + '          when 18  then ''AFTER INSERT OR UPDATE'' '
        + '          when 25  then ''BEFORE INSERT OR Delete'' '
        + '          when 26  then ''AFTER INSERT OR DELETE'' '
        + '          when 27  then ''BEFORE UPDATE OR DELETE'' '
        + '          when 28  then ''AFTER UPDATE OR DELETE'' '
        + '          when 113 then ''BEFORE INSERT OR UPDATE OR DELETE'' '
        + '          when 114 then ''AFTER INSERT OR UPDATE OR DELETE'' '
        + '          else t.rdb$trigger_type '
        + '        end as rdb$trigger_type '
        + '      , t.rdb$trigger_name '
        + '      , t.rdb$trigger_source '
        + '  from rdb$relation_constraints r '
        + '  join rdb$check_constraints c '
        + '    on c.rdb$constraint_name = r.rdb$constraint_name '
        + '  join rdb$triggers t '
        + '    on t.rdb$trigger_name = c.rdb$trigger_name '
        + ' where upper(r.rdb$relation_name) = '
        +         QuotedStr(AnsiUpperCase(NomeTabela))
        + '   and r.rdb$constraint_type = ' + QuotedStr('CHECK')
        + ' order by r.rdb$constraint_type, r.rdb$constraint_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsRestricoesCheck.Append;
      cdsRestricoesCheck.FieldByName('constraint_name').AsString :=
        FieldByName('rdb$constraint_name').AsString;
      cdsRestricoesCheck.FieldByName('trigger_type').AsString :=
        FieldByName('rdb$trigger_type').AsString;
      cdsRestricoesCheck.FieldByName('trigger_source').AsString :=
        FieldByName('rdb$trigger_source').AsString;
      cdsRestricoesCheck.Post;
      Next;
    end;
  end;

  cdsRestricoesCheck.First;
  BindSourceDBRestricoesCheck.DataSet := cdsRestricoesCheck;
  ShowCheckConstraintDDL(cdsRestricoesCheck);
  qryX.Free;
end;

procedure TfTabela.RecuperaIntegridadeReferencial;
var
  ssql: string;
  qryX: TFDQuery;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsIntegridadeReferencial.EmptyDataSet;

  ssql := ' select a.rdb$constraint_name '
        + '      , c.rdb$relation_name '
        + '      , b.rdb$update_rule '
        + '      , b.rdb$delete_rule '
        + '   from rdb$relation_constraints a '
        + '   join rdb$ref_constraints b '
        + '     on b.rdb$constraint_name = a.rdb$constraint_name '
        + '   join rdb$relation_constraints c '
        + '     on c.rdb$constraint_name = b.rdb$const_name_uq '
        + '  where upper(a.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '    and a.rdb$constraint_type = ' + QuotedStr('FOREIGN KEY')
        + '  order by a.rdb$constraint_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsIntegridadeReferencial.Append;
      cdsIntegridadeReferencial.FieldByName('constraint_name').AsString :=
        FieldByName('rdb$constraint_name').AsString;
      cdsIntegridadeReferencial.FieldByName('relation_name').AsString :=
        FieldByName('rdb$relation_name').AsString;
      cdsIntegridadeReferencial.FieldByName('update_rule').AsString :=
        FieldByName('rdb$update_rule').AsString;
      cdsIntegridadeReferencial.FieldByName('delete_rule').AsString :=
        FieldByName('rdb$delete_rule').AsString;
      cdsIntegridadeReferencial.Post;
      Next;
    end;
  end;

  cdsIntegridadeReferencial.First;
  BindSourceDBIntegridadeReferencial.DataSet := cdsIntegridadeReferencial;
  qryX.Free;
end;

procedure TfTabela.RecuperaGatilhos;
var
  ssql: string;
  qryX: TFDQuery;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsGatilhos.EmptyDataSet;

  ssql := ' select rdb$trigger_name '
        + '      , case rdb$trigger_type '
        + '          when 1   then ''Before Insert'' '
        + '          when 2   then ''After Insert'' '
        + '          when 3   then ''Before Update'' '
        + '          when 4   then ''After Update'' '
        + '          when 5   then ''Before Delete'' '
        + '          when 6   then ''After Delete'' '
        + '          when 17  then ''Before Insert or Update'' '
        + '          when 18  then ''After Insert or Update'' '
        + '          when 25  then ''Before Insert or Delete'' '
        + '          when 26  then ''After Insert or Delete'' '
        + '          when 27  then ''Before Update or Delete'' '
        + '          when 28  then ''After Update or Delete'' '
        + '          when 113 then ''Before Insert or Update or Delete'' '
        + '          when 114 then ''After Insert or Update or Delete'' '
        + '          else rdb$trigger_type '
        + '        end as rdb$trigger_type '
        + '      , rdb$trigger_source '
        + '      , case rdb$trigger_inactive '
        + '             when 0 then ''Ativo'' '
        + '             when 1 then ''Inativo'' '
        + '        end as rdb$trigger_inactive '
        + '   from rdb$triggers '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '  order by rdb$trigger_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsGatilhos.Append;
      cdsGatilhos.FieldByName('trigger_name').AsString :=
        FieldByName('rdb$trigger_name').AsString;
      cdsGatilhos.FieldByName('trigger_type').AsString :=
        FieldByName('rdb$trigger_type').AsString;
      cdsGatilhos.FieldByName('trigger_source').AsString :=
        FieldByName('rdb$trigger_source').AsString;
      cdsGatilhos.FieldByName('trigger_inactive').AsString :=
        FieldByName('rdb$trigger_inactive').AsString;
      cdsGatilhos.Post;
      Next;
    end;
  end;

  cdsGatilhos.First;
  BindSourceDBGatilhos.DataSet := cdsGatilhos;
  ShowTriggerDDL(cdsGatilhos);
  qryX.Free;
end;

procedure TfTabela.RecuperaPrivilegios;
var
  ssql: string;
  qryX: TFDQuery;
  xUsuario, xSelect, xUpdate, xDelete, xInsert, xReference: string;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsPrivilegios.EmptyDataSet;

  ssql := ' select rdb$user '
        + '      , rdb$privilege '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '  order by rdb$user ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    xUsuario := '?';
    xSelect := 'Não';
    xUpdate := 'Não';
    xDelete := 'Não';
    xInsert := 'Não';
    xReference := 'Não';

    while not Eof do begin
      if xUsuario = '?' then
        xUsuario := FieldByName('rdb$user').AsString;
      if FieldByName('rdb$user').AsString = xUsuario then
      begin
        if FieldByName('rdb$privilege').AsString = 'S' then
          xSelect := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'U' then
          xUpdate := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'D' then
          xDelete := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'I' then
          xInsert := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'R' then
          xReference := 'Sim'
      end
      else
      begin
        cdsPrivilegios.Append;
        cdsPrivilegios.FieldByName('usuario').AsString   := xUsuario;
        cdsPrivilegios.FieldByName('select').AsString    := xSelect;
        cdsPrivilegios.FieldByName('update').AsString    := xUpdate;
        cdsPrivilegios.FieldByName('delete').AsString    := xDelete;
        cdsPrivilegios.FieldByName('insert').AsString    := xInsert;
        cdsPrivilegios.FieldByName('reference').AsString := xReference;
        cdsPrivilegios.Post;

        xUsuario := FieldByName('rdb$user').AsString;
        xSelect := 'Não';
        xUpdate := 'Não';
        xDelete := 'Não';
        xInsert := 'Não';
        xReference := 'Não';

        if FieldByName('rdb$privilege').AsString = 'S' then
          xSelect := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'U' then
          xUpdate := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'D' then
          xDelete := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'I' then
          xInsert := 'Sim'
        else
        if FieldByName('rdb$privilege').AsString = 'R' then
          xReference := 'Sim'
      end;

      Next;
    end;
  end;

  if xUsuario <> '?' then
  begin
    cdsPrivilegios.Append;
    cdsPrivilegios.FieldByName('usuario').AsString   := xUsuario;
    cdsPrivilegios.FieldByName('select').AsString    := xSelect;
    cdsPrivilegios.FieldByName('update').AsString    := xUpdate;
    cdsPrivilegios.FieldByName('delete').AsString    := xDelete;
    cdsPrivilegios.FieldByName('insert').AsString    := xInsert;
    cdsPrivilegios.FieldByName('reference').AsString := xReference;
    cdsPrivilegios.Post;
  end;

  cdsPrivilegios.First;
  BindSourceDBPrivilegios.DataSet := cdsPrivilegios;
  qryX.Free;
end;

procedure TfTabela.RecuperaDDLTabela;
begin
  MemoDDLTabela.Lines.Clear;
  MemoDDLTabela.Lines.AddStrings(fdm.GetTableDDL(NomeTabela));
end;

procedure TfTabela.cdsIndicesAfterScroll(DataSet: TDataSet);
var
  ssql: string;
  qryX: TFDQuery;
begin
  if cdsIndices.IsEmpty then Exit;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsColunasIndice.EmptyDataSet;

  ssql := ' select i.rdb$field_position '
        + '      , i.rdb$field_name '
        + '      , case x.rdb$index_type '
        + '             when 1 then ''Descendente'' '
        + '             else ''Ascendente'' '
        + '        end as rdb$index_type '
        + '   from rdb$index_segments i '
        + '   join rdb$indices x '
        + '     on x.rdb$index_name = i.rdb$index_name '
        + '  where upper(x.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '    and i.rdb$index_name = '
        +          QuotedStr(cdsIndices.Fields[0].AsString)
        + '  order by i.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsColunasIndice.Append;
      cdsColunasIndice.FieldByName('field_position').AsString :=
        FieldByName('rdb$field_position').AsString;
      cdsColunasIndice.FieldByName('field_name').AsString :=
        FieldByName('rdb$field_name').AsString;
      cdsColunasIndice.FieldByName('index_type').AsString :=
        FieldByName('rdb$index_type').AsString;
      cdsColunasIndice.Post;
      Next;
    end;
  end;

  cdsColunasIndice.First;
  BindSourceDBColunasIndice.DataSet := cdsColunasIndice;
  qryX.Free;
end;

procedure TfTabela.cdsRestricoesUniqueAfterScroll(DataSet: TDataSet);
var
  ssql: string;
  qryX: TFDQuery;
begin
  if cdsRestricoesUnique.IsEmpty then Exit;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;
  cdsColunasRestricaoUnique.EmptyDataSet;

  ssql := ' select i.rdb$field_position '
        + '      , i.rdb$field_name '
        + '   from rdb$index_segments i '
        + '   join rdb$indices x '
        + '     on x.rdb$index_name = i.rdb$index_name '
        + '  where upper(x.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(NomeTabela))
        + '    and i.rdb$index_name    = '
        +          QuotedStr(cdsRestricoesUnique.Fields[0].AsString)
        + '  order by i.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      cdsColunasRestricaoUnique.Append;
      cdsColunasRestricaoUnique.FieldByName('field_position').AsString :=
        FieldByName('rdb$field_position').AsString;
      cdsColunasRestricaoUnique.FieldByName('field_name').AsString :=
        FieldByName('rdb$field_name').AsString;
      cdsColunasRestricaoUnique.Post;
      Next;
    end;
  end;

  cdsColunasRestricaoUnique.First;
  BindSourceDBColunasRestricaoUnique.DataSet := cdsColunasRestricaoUnique;
  qryX.Free;
end;

procedure TfTabela.chkAbrirTabelaChange(Sender: TObject);
begin
  if chkAbrirTabela.IsChecked then
    cbTabelasChange(Self);
end;

procedure TfTabela.cbTabelasChange(Sender: TObject);
begin
  NomeTabela := cbTabelas.Selected.Text;
  if TabControlDados.ActiveTab = tabDados then
  begin
    if chkAbrirTabela.IsChecked then
    begin
      lbField.Text := '';
      AbreTabela;
    end;
  end
  else
  begin
    tabControlPropriedadesChange(nil);
  end;
end;

procedure TfTabela.AbreTabela;
begin
  xSelect := '';
  xWhere := '';
  xOrderBy := '';
  LastOrder := '';
  edField.Text := '';
  lbField.Text := '';

  MontaComandoSelect;
  //MontaComandoSelect2;
  //MontaComandoSelect3;

  with fdm.FDQuery do begin
    Close;
    SQL.Clear;
    SQL.Add(xSelectSQL);
    Open;
  end;

  BindSourceDBDados.DataSet := fdm.FDQuery;
  BindNavigator.DataSource := BindSourceDBDados;
end;

procedure TfTabela.ShowCheckConstraintDDL(DataSet: TDataSet);
begin
  MemoDDLRestricaoCheck.Lines.Clear;
  MemoDDLRestricaoCheck.Lines.Add(
    fdm.GetCheckConstraintDDL(NomeTabela,
    cdsRestricoesCheck.FieldByName('constraint_name').AsString)
    );
end;

procedure TfTabela.ShowTriggerDDL(DataSet: TDataSet);
begin
  MemoDDLGatilho.Lines.Clear;
  MemoDDLGatilho.Lines.Add(
    fdm.GetTriggerDDL(cdsGatilhos.FieldByName('trigger_name').AsString)
    );
end;

procedure TfTabela.grdDadosHeaderClick(Column: TColumn);
var
  I: Integer;
begin
  if fdm.FDQuery.IsEmpty then Exit;

  for I := 0 to BindSourceDBDados.DataSet.FieldCount - 1 do begin
    if BindSourceDBDados.DataSet.Fields.Fields[I].FieldName =
       Column.Header then
    begin
      if BindSourceDBDados.DataSet.Fields.Fields[I].DataType in
         [ftBlob, ftGraphic] then
      begin
        Indice := BindSourceDBDados.DataSet.Fields.Fields[I].Index;
        lbField.Text := '';
      end
      else
      begin
        Indice := BindSourceDBDados.DataSet.Fields.Fields[I].Index;
        lbField.Text := Column.Header;
      end;
      Break;
    end;
  end;
end;

procedure TfTabela.edFieldKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    if (lbField.Text = '') or
       (Trim(edField.Text) = '') then
    begin
      Exit;
    end
    else
    begin
      MontaComandoSelect;
      //MontaComandoSelect2;
      //MontaComandoSelect3;
      MontaClausulaWhere;
      xSelect := xSelect + xWhere;
    end;

    with fdm.FDQuery do begin
      Close;
      SQL.Clear;
      SQL.Add(xSelect);
      Open;
    end;
  end;

  BindSourceDBDados.DataSet := fdm.FDQuery;
  BindNavigator.DataSource := BindSourceDBDados;
end;

procedure TfTabela.MontaComandoSelect;
var
  ssql: string;
  tsFieldsName: TStrings;
  qry: TFDQuery;
  I: Integer;
  Field: string;
  S: string;
begin
  xSelectSQL := 'select ';
  tsFieldsName := TStringList.Create;
  qry := TFDQuery.Create(Self);
  qry.Connection := fdm.FDConnection;

  if (Tag = 1) or (Tag = -1) then
  begin
    S := '';
    tsFieldsName.AddStrings(fdm.GetFieldsTable(NomeTabela, 0));
    for I := 0 to tsFieldsName.Count - 1 do begin
      Field := tsFieldsName.Strings[I];
      if  S <> '' then
        S := S + ', ';
      S := S + Field;
    end;
    xSelectSQL := xSelectSQL + S;
  end;

  if (Tag = 10) or (Tag = -10) then
  begin
    S := '';
    tsFieldsName.AddStrings(fdm.GetFieldsTable(NomeTabela, 1));
    for I := 0 to tsFieldsName.Count - 1 do begin
      Field := tsFieldsName.Strings[I];
      if  S <> '' then
        S := S + ', ';
      S := S + Field;
    end;
    xSelectSQL := xSelectSQL + S;
  end;

  xSelectSQL := xSelectSQL + ' from ' + NomeTabela;
  xSelect := xSelectSQL;
  tsFieldsName.Free;
  qry.Close;
  qry.Free
end;

procedure TfTabela.MontaComandoSelect2;
var
  ssql: string;
  tsFieldsName: TStrings;
  qry: TFDQuery;
  I: Integer;
  Field: string;
begin
  xSelectSQL := 'select ';
  tsFieldsName := TStringList.Create;
  fdm.FDConnection.GetFieldNames('', '', NomeTabela, '', tsFieldsName);
  qry := TFDQuery.Create(Self);
  qry.Connection := fdm.FDConnection;

  if (Tag = 1) or (Tag = -1) then
  begin
    for I := 0 to tsFieldsName.Count - 1 do begin
      ssql := ' select rdb$system_flag '
            + '   from rdb$relation_fields '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(tsFieldsName.Strings[I])
            + '    and upper(rdb$relation_name) = '
            +          QuotedStr(AnsiUpperCase(NomeTabela));

      Field := tsFieldsName.Strings[I];

      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        if FieldByName('rdb$system_flag').AsInteger = 0 then
        begin
          if (fdm.CheckBlobField(NomeTabela, Field) = False) and
             (fdm.CheckArrayField(NomeTabela, Field) = False) then
          begin
            xSelectSQL := xSelectSQL + Field + ',';
          end;
        end;
      end;
    end;
  end;

  if (Tag = 10) or (Tag = -10) then
  begin
    for I := 0 to tsFieldsName.Count - 1 do begin
      ssql := ' select rdb$system_flag '
            + '   from rdb$relation_fields '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(tsFieldsName.Strings[I])
            + '    and upper(rdb$relation_name) = '
            +          QuotedStr(AnsiUpperCase(NomeTabela));

      Field := tsFieldsName.Strings[I];

      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        if FieldByName('rdb$system_flag').AsInteger = 1 then
        begin
          if (fdm.CheckBlobField(NomeTabela, Field) = False) and
             (fdm.CheckArrayField(NomeTabela, Field) = False) then
          begin
            xSelectSQL := xSelectSQL + Field + ',';
          end;
        end;
      end;
    end;
  end;

  Delete(xSelectSQL, Length(xSelectSQL), 1);
  xSelectSQL := xSelectSQL + ' from ' + NomeTabela;
  xSelect := xSelectSQL;
  tsFieldsName.Free;
  qry.Close;
  qry.Free
end;

procedure TfTabela.MontaComandoSelect3;
var
  ssql: string;
  tsFieldsName: TStrings;
  qry: TFDQuery;
  I: Integer;
  Field: string;
  SelectArray: string;
begin
  xSelectSQL := 'select ';
  tsFieldsName := TStringList.Create;
  fdm.FDConnection.GetFieldNames('', '', NomeTabela, '', tsFieldsName);
  qry := TFDQuery.Create(Self);
  qry.Connection := fdm.FDConnection;

  if (Tag = 1) or (Tag = -1) then
  begin
    for I := 0 to tsFieldsName.Count - 1 do begin
      ssql := ' select rdb$system_flag '
            + '   from rdb$relation_fields '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(tsFieldsName.Strings[I])
            + '    and upper(rdb$relation_name) = '
            +          QuotedStr(AnsiUpperCase(NomeTabela));

      Field := tsFieldsName.Strings[I];
      SelectArray := fdm.GetArraySelect(NomeTabela, Field);

      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        if FieldByName('rdb$system_flag').AsInteger = 0 then
        begin
          if SelectArray <> '' then
          begin
            xSelectSQL := xSelectSQL + SelectArray + ',';
          end
          else
          begin
            if (fdm.CheckBlobField(NomeTabela, Field) = False) then
            begin
              xSelectSQL := xSelectSQL + Field + ',';
            end;
          end;
        end;
      end;
    end;
  end;

  if (Tag = 10) or (Tag = -10) then
  begin
    for I := 0 to tsFieldsName.Count - 1 do begin
      ssql := ' select rdb$system_flag '
            + '   from rdb$relation_fields '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(tsFieldsName.Strings[I])
            + '    and upper(rdb$relation_name) = '
            +          QuotedStr(AnsiUpperCase(NomeTabela));

      Field := tsFieldsName.Strings[I];
      SelectArray := fdm.GetArraySelect(NomeTabela, Field);

      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        if FieldByName('rdb$system_flag').AsInteger = 1 then
        begin
          if SelectArray <> '' then
          begin
            xSelectSQL := xSelectSQL + SelectArray + ',';
          end
          else
          begin
            if (fdm.CheckBlobField(NomeTabela, Field) = False) then
            begin
              xSelectSQL := xSelectSQL + Field + ',';
            end;
          end;
        end;
      end;
    end;
  end;

  Delete(xSelectSQL, Length(xSelectSQL), 1);
  xSelectSQL := xSelectSQL + ' from ' + NomeTabela;
  xSelect := xSelectSQL;
  tsFieldsName.Free;
  qry.Close;
  qry.Free
end;

procedure TfTabela.MontaClausulaWhere;
var
  chkText, CharSet: string;
  operador, termo: string;
begin
  operador := TrataArgumento(edField.Text);
  termo := TrataTermo(edField.Text);

  if fdm.FDQuery.FieldByName(lbField.Text).DataType in [ftMemo, ftString,
     ftWideString] then
  begin
    CharSet := AnsiUpperCase(fdm.GetCharSetName);
    if Trim(CharSet) = 'NONE' then
    begin
      chkText := 'upper(cast(' + lbField.Text + ' as char(' +
        IntToStr(fdm.FDQuery.FieldByName(lbField.Text).Size) +
        ') character set win1252)) like ''%' +
        AnsiUpperCase(termo) + '%'''
    end
    else
    begin
      chkText := 'upper(' + lbField.Text + ') like ''%' +
        AnsiUpperCase(termo) + '%''';
    end;
  end
  else
  if fdm.FDQuery.FieldByName(lbField.Text).DataType in [ftWord, ftInteger,
     ftSmallInt, ftLargeint, ftAutoInc] then
    chkText := lbField.Text + operador + termo
  else
  if fdm.FDQuery.FieldByName(lbField.Text).DataType in [ftFloat,
     ftCurrency] then
    chkText := lbField.Text + operador +
      StringReplace(termo, ',', '.', [rfReplaceAll])
  else
  if fdm.FDQuery.FieldByName(lbField.Text).DataType in [ftDate,
     ftDateTime] then
    chkText := lbField.Text + operador +
      QuotedStr(FormatDateTime('mm/dd/yyyy',
      Trunc(StrToDate(termo))));

  if (chkText <> '') and (AnsiPos(chkText, xWhere) = 0) then
  begin
    if xWhere = '' then
    begin
      xWhere := ' where ' + chkText;
    end
    else
    begin
      xWhere := xWhere + ' and ' + chkText;
    end;
  end;
end;

function TfTabela.TrataArgumento(AArg: string): string;
var
  I: Integer;
begin
  Result := '';
  if AArg = '' then Exit;

  for I := 1 to Length(AArg) do begin
    if AArg[I] in ['>', '<', '='] then
      Result := Result + AArg[I];
  end;

  if Result = '' then Result := ' = ';
end;

function TfTabela.TrataTermo(AArg: string): string;
var
  I: Integer;
begin
  Result := '';
  if AArg = '' then Exit;

  for I := 1 to Length(AArg) do begin
    if not (AArg[I] in ['>', '<', '=']) then
      Result := Result + AArg[I];
  end;
end;

end.
