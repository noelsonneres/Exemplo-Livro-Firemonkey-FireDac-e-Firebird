unit uPrivilegio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, uDAC,
  FireDAC.Comp.Client;

type
  TfPrivilegio = class(TfxForm)
    pnlObjeto: TPanel;
    Label1: TLabel;
    edObjeto: TEdit;
    lbTipoObjeto: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbTabelas: TComboBox;
    cbVisoes: TComboBox;
    cbProcedimentos: TComboBox;
    pnlIndividual: TPanel;
    chkSelect: TCheckBox;
    chkInsert: TCheckBox;
    chkUpdate: TCheckBox;
    chkDelete: TCheckBox;
    chkReferences: TCheckBox;
    chkSelectGrantOption: TCheckBox;
    chkReferencesGrantOption: TCheckBox;
    chkDeleteGrantOption: TCheckBox;
    chkInsertGrantOption: TCheckBox;
    chkUpdateGrantOption: TCheckBox;
    chkSelect2: TCheckBox;
    chkUpdate2: TCheckBox;
    chkInsert2: TCheckBox;
    chkDelete2: TCheckBox;
    chkReferences2: TCheckBox;
    chkReferencesGrantOption2: TCheckBox;
    chkDeleteGrantOption2: TCheckBox;
    chkUpdateGrantOption2: TCheckBox;
    chkInsertGrantOption2: TCheckBox;
    chkSelectGrantOption2: TCheckBox;
    chkExecute: TCheckBox;
    chkExecuteGrantOption: TCheckBox;
    rbMarcarTabelas: TRadioButton;
    rbDesmarcarTabelas: TRadioButton;
    btnConfirmarTabela: TButton;
    btnConfirmarVisao: TButton;
    btnConfirmarProcedimento: TButton;
    pnlMensagem: TPanel;
    pnlGlobal: TPanel;
    chkGrantAllTabelas: TCheckBox;
    chkRevokeAllTabelas: TCheckBox;
    chkGrantAllVisoes: TCheckBox;
    chkRevokeAllVisoes: TCheckBox;
    chkGrantAllProcedimentos: TCheckBox;
    chkRevokeAllProcedimentos: TCheckBox;
    edTabelaSelecionada: TEdit;
    edVisaoSelecionada: TEdit;
    edProcedimentoSelecionado: TEdit;
    btnConfirmarTabelas: TButton;
    btnConfirmarVisoes: TButton;
    btnConfirmarProcedimentos: TButton;
    Label6: TLabel;
    Label7: TLabel;
    lbMensagem: TLabel;
    Label2: TLabel;
    rbDesmarcarVisoes: TRadioButton;
    rbMarcarVisoes: TRadioButton;
    Label8: TLabel;
    cbGatilhos: TComboBox;
    chkExecute2: TCheckBox;
    chkExecuteGrantOption2: TCheckBox;
    chkGrantAllGatilhos: TCheckBox;
    chkRevokeAllGatilhos: TCheckBox;
    btnConfirmarGatilhos: TButton;
    edGatilhoSelecionado: TEdit;
    btnConfirmarGatilho: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTabelasClosePopup(Sender: TObject);
    procedure cbVisoesClosePopup(Sender: TObject);
    procedure cbProcedimentosClosePopup(Sender: TObject);
    procedure rbMarcarTabelasClick(Sender: TObject);
    procedure rbDesmarcarTabelasClick(Sender: TObject);
    procedure rbMarcarVisoesClick(Sender: TObject);
    procedure rbDesmarcarVisoesClick(Sender: TObject);
    procedure btnConfirmarTabelaClick(Sender: TObject);
    procedure btnConfirmarVisaoClick(Sender: TObject);
    procedure btnConfirmarProcedimentoClick(Sender: TObject);
    procedure btnConfirmarTabelasClick(Sender: TObject);
    procedure btnConfirmarVisoesClick(Sender: TObject);
    procedure btnConfirmarProcedimentosClick(Sender: TObject);
    procedure chkGrantAllTabelasClick(Sender: TObject);
    procedure chkGrantAllVisoesClick(Sender: TObject);
    procedure chkGrantAllProcedimentosClick(Sender: TObject);
    procedure cbGatilhosClosePopup(Sender: TObject);
    procedure btnConfirmarGatilhosClick(Sender: TObject);
    procedure btnConfirmarGatilhoClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
  public
    { Public declarations }
    Alias: string;

    procedure RecuperaTabelas;
    procedure RecuperaVisoes;
    procedure RecuperaProcedimentos;
    procedure RecuperaGatilhos;

    procedure SelecionaPrivilegiosTabelas(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosTabelas;
    procedure ConcedeRetiraPrivilegiosTabelas;

    procedure SelecionaPrivilegiosVisoes(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosVisoes;
    procedure ConcedeRetiraPrivilegiosVisoes;

    procedure SelecionaPrivilegiosProcedimentos(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosProcedimentos;
    procedure ConcedeRetiraPrivilegiosProcedimentos;

    procedure SelecionaPrivilegiosGatilhos(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosGatilhos;
    procedure ConcedeRetiraPrivilegiosGatilhos;
  end;

var
  fPrivilegio: TfPrivilegio;

implementation

{$R *.fmx}

procedure TfPrivilegio.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Gerenciar Privilégios';
  fdm := TfDAC.Create(Self);
end;

procedure TfPrivilegio.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaTabelas;
    if lbTipoObjeto.Text = 'Tabela' then
      cbTabelas.ItemIndex := cbTabelas.Items.IndexOf(edObjeto.Text)
    else
      cbTabelas.ItemIndex := 0;
    cbTabelasClosePopup(Self);

    RecuperaVisoes;
    if lbTipoObjeto.Text = 'Visão' then
      cbVisoes.ItemIndex := cbVisoes.Items.IndexOf(edObjeto.Text)
    else
      cbVisoes.ItemIndex := 0;
    cbVisoesClosePopup(Self);

    RecuperaProcedimentos;
    if lbTipoObjeto.Text = 'Procedimento' then
      cbProcedimentos.ItemIndex :=
        cbProcedimentos.Items.IndexOf(edObjeto.Text)
    else
      cbProcedimentos.ItemIndex := 0;
    cbProcedimentosClosePopup(Self);

    RecuperaGatilhos;
    if lbTipoObjeto.Text = 'Gatilho' then
      cbGatilhos.ItemIndex :=
        cbGatilhos.Items.IndexOf(edObjeto.Text)
    else
      cbGatilhos.ItemIndex := 0;
    cbGatilhosClosePopup(Self);
  end;
end;

procedure TfPrivilegio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fPrivilegio.Release;
  fPrivilegio := nil;
end;

procedure TfPrivilegio.RecuperaTabelas;
begin
  fdm.GetTables(cbTabelas, 0);
end;

procedure TfPrivilegio.RecuperaVisoes;
begin
  fdm.GetViews(nil, cbVisoes);
end;

procedure TfPrivilegio.RecuperaProcedimentos;
begin
  fdm.GetProcedures(nil, cbProcedimentos);
end;

procedure TfPrivilegio.RecuperaGatilhos;
begin
  fdm.GetTriggers(nil, cbGatilhos);
end;

procedure TfPrivilegio.cbTabelasClosePopup(Sender: TObject);
begin
  if cbTabelas.Items.Count = 0 then Exit;
  edTabelaSelecionada.Text := cbTabelas.Selected.Text;
  RecuperaPrivilegiosTabelas;
end;

procedure TfPrivilegio.cbVisoesClosePopup(Sender: TObject);
begin
  if cbVisoes.Items.Count = 0 then Exit;
  edVisaoSelecionada.Text := cbVisoes.Selected.Text;
  RecuperaPrivilegiosVisoes;
end;

procedure TfPrivilegio.cbProcedimentosClosePopup(Sender: TObject);
begin
  if cbProcedimentos.Items.Count = 0 then Exit;
  edProcedimentoSelecionado.Text := cbProcedimentos.Selected.Text;
  RecuperaPrivilegiosProcedimentos;
end;

procedure TfPrivilegio.cbGatilhosClosePopup(Sender: TObject);
begin
  if cbGatilhos.Items.Count = 0 then Exit;
  edGatilhoSelecionado.Text := cbGatilhos.Selected.Text;
  RecuperaPrivilegiosGatilhos;
end;

procedure TfPrivilegio.SelecionaPrivilegiosTabelas(AChecked: Boolean);
begin
  chkSelect.IsChecked := AChecked;
  chkSelectGrantOption.IsChecked := AChecked;
  chkInsert.IsChecked := AChecked;
  chkInsertGrantOption.IsChecked := AChecked;
  chkUpdate.IsChecked := AChecked;
  chkUpdateGrantOption.IsChecked := AChecked;
  chkDelete.IsChecked := AChecked;
  chkDeleteGrantOption.IsChecked := AChecked;
  chkReferences.IsChecked := AChecked;
  chkReferencesGrantOption.IsChecked := AChecked;
end;

procedure TfPrivilegio.RecuperaPrivilegiosTabelas;
var
  qryX: TFDQuery;
  ssql, user, priv, grant: string;
begin
  if Trim(edTabelaSelecionada.Text) = '' then Exit;

  user := Trim(edObjeto.Text);

  SelecionaPrivilegiosTabelas(False);

  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;

  ssql := ' select rdb$privilege, rdb$grant_option '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(user))
        + '    and upper(rdb$relation_name) = '
        +          QuotedStr(Trim(AnsiUpperCase(
                     edTabelaSelecionada.Text)));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      priv := Trim(FieldByName('rdb$privilege').AsString);
      grant := Trim(FieldByName('rdb$grant_option').AsString);

      if priv = 'S' then
      begin
        chkSelect.IsChecked := (priv = 'S');
        chkSelectGrantOption.IsChecked := (grant = '1');
      end
      else
      if priv = 'I' then
      begin
        chkInsert.IsChecked := (priv = 'I');
        chkInsertGrantOption.IsChecked := (grant = '1');
      end
      else
      if priv = 'U' then
      begin
        chkUpdate.IsChecked := (priv = 'U');
        chkUpdateGrantOption.IsChecked := (grant = '1');
      end
      else
      if priv = 'D' then
      begin
        chkDelete.IsChecked := (priv = 'D');
        chkDeleteGrantOption.IsChecked := (grant = '1');
      end
      else
      if priv = 'R' then
      begin
        chkReferences.IsChecked := (priv = 'R');
        chkReferencesGrantOption.IsChecked := (grant = '1');
      end;

      Next;
    end;
  end;

  qryX.Close;
  qryX.Free;
end;

procedure TfPrivilegio.ConcedeRetiraPrivilegiosTabelas;
var
  ssql, grant: string;
  I: Integer;
begin
  if chkGrantAllTabelas.IsChecked = True then
  begin
    ssql := '';
    grant := 'grant all ';
    for I := 0 to cbTabelas.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on ' + cbTabelas.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end
  else
  if chkRevokeAllTabelas.IsChecked = True then
  begin
    ssql := '';
    grant := 'revoke all ';
    for I := 0 to cbTabelas.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on ' + cbTabelas.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.SelecionaPrivilegiosVisoes(AChecked: Boolean);
begin
  chkSelect2.IsChecked := AChecked;
  chkSelectGrantOption2.IsChecked := AChecked;
  chkInsert2.IsChecked := AChecked;
  chkInsertGrantOption2.IsChecked := AChecked;
  chkUpdate2.IsChecked := AChecked;
  chkUpdateGrantOption2.IsChecked := AChecked;
  chkDelete2.IsChecked := AChecked;
  chkDeleteGrantOption2.IsChecked := AChecked;
  chkReferences2.IsChecked := AChecked;
  chkReferencesGrantOption2.IsChecked := AChecked;
end;

procedure TfPrivilegio.RecuperaPrivilegiosVisoes;
var
  qryX: TFDQuery;
  ssql, user, priv, grant: string;
begin
  if Trim(edVisaoSelecionada.Text) = '' then Exit;

  user := Trim(edObjeto.Text);

  SelecionaPrivilegiosVisoes(False);

  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;

  ssql := ' select rdb$privilege, rdb$grant_option '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(user))
        + '    and upper(rdb$relation_name) = '
        +          QuotedStr(Trim(AnsiUpperCase(
                     edVisaoSelecionada.Text)));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      priv := Trim(FieldByName('rdb$privilege').AsString);
      grant := Trim(FieldByName('rdb$grant_option').AsString);

      if priv = 'S' then
      begin
        chkSelect2.IsChecked := (priv = 'S');
        chkSelectGrantOption2.IsChecked := (grant = '1');
      end
      else
      if priv = 'I' then
      begin
        chkInsert2.IsChecked := (priv = 'I');
        chkInsertGrantOption2.IsChecked := (grant = '1');
      end
      else
      if priv = 'U' then
      begin
        chkUpdate2.IsChecked := (priv = 'U');
        chkUpdateGrantOption2.IsChecked := (grant = '1');
      end
      else
      if priv = 'D' then
      begin
        chkDelete2.IsChecked := (priv = 'D');
        chkDeleteGrantOption2.IsChecked := (grant = '1');
      end
      else
      if priv = 'R' then
      begin
        chkReferences2.IsChecked := (priv = 'R');
        chkReferencesGrantOption2.IsChecked := (grant = '1');
      end;

      Next;
    end;
  end;

  qryX.Close;
  qryX.Free;
end;

procedure TfPrivilegio.ConcedeRetiraPrivilegiosVisoes;
var
  ssql, grant: string;
  I: Integer;
begin
  if chkGrantAllVisoes.IsChecked = True then
  begin
    ssql := '';
    grant := 'grant all ';
    for I := 0 to cbVisoes.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on ' + cbVisoes.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end
  else
  if chkRevokeAllVisoes.IsChecked = True then
  begin
    ssql := '';
    grant := 'revoke all ';
    for I := 0 to cbVisoes.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on ' + cbVisoes.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.SelecionaPrivilegiosProcedimentos(AChecked: Boolean);
begin
  chkExecute.IsChecked := AChecked;
  chkExecuteGrantOption.IsChecked := AChecked;
end;

procedure TfPrivilegio.RecuperaPrivilegiosProcedimentos;
var
  qryX: TFDQuery;
  ssql, user, priv, grant: string;
begin
  if Trim(edProcedimentoSelecionado.Text) = '' then Exit;
  user := Trim(edObjeto.Text);
  SelecionaPrivilegiosProcedimentos(False);

  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;

  ssql := ' select rdb$privilege, rdb$grant_option '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(user))
        + '    and upper(rdb$relation_name) = '
        +          QuotedStr(Trim(AnsiUpperCase(
                     edProcedimentoSelecionado.Text)));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      priv := Trim(FieldByName('rdb$privilege').AsString);
      grant := Trim(FieldByName('rdb$grant_option').AsString);

      if priv = 'X' then
      begin
        chkExecute.IsChecked := (priv = 'X');
        chkExecuteGrantOption.IsChecked := (grant = '1');
      end;

      Next;
    end;
  end;

  qryX.Close;
  qryX.Free;
end;

procedure TfPrivilegio.ConcedeRetiraPrivilegiosProcedimentos;
var
  ssql, grant: string;
  I: Integer;
begin
  if chkGrantAllProcedimentos.IsChecked = True then
  begin
    ssql := '';
    grant := 'grant execute ';
    for I := 0 to cbProcedimentos.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on procedure '
            + cbProcedimentos.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end
  else
  if chkRevokeAllProcedimentos.IsChecked = True then
  begin
    ssql := '';
    grant := 'revoke execute ';
    for I := 0 to cbProcedimentos.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on procedure '
            + cbProcedimentos.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.SelecionaPrivilegiosGatilhos(AChecked: Boolean);
begin
  chkExecute2.IsChecked := AChecked;
  chkExecuteGrantOption2.IsChecked := AChecked;
end;

procedure TfPrivilegio.RecuperaPrivilegiosGatilhos;
var
  qryX: TFDQuery;
  ssql, user, priv, grant: string;
begin
  if Trim(edGatilhoSelecionado.Text) = '' then Exit;
  user := Trim(edObjeto.Text);
  SelecionaPrivilegiosGatilhos(False);

  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;

  ssql := ' select rdb$privilege, rdb$grant_option '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(user))
        + '    and upper(rdb$relation_name) = '
        +          QuotedStr(Trim(AnsiUpperCase(
                     edGatilhoSelecionado.Text)));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      priv := Trim(FieldByName('rdb$privilege').AsString);
      grant := Trim(FieldByName('rdb$grant_option').AsString);

      if priv = 'X' then
      begin
        chkExecute.IsChecked := (priv = 'X');
        chkExecuteGrantOption.IsChecked := (grant = '1');
      end;

      Next;
    end;
  end;

  qryX.Close;
  qryX.Free;
end;

procedure TfPrivilegio.ConcedeRetiraPrivilegiosGatilhos;
var
  ssql, grant: string;
  I: Integer;
begin
  if chkGrantAllGatilhos.IsChecked = True then
  begin
    ssql := '';
    grant := 'grant execute ';
    for I := 0 to cbGatilhos.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on trigger '
            + cbGatilhos.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end
  else
  if chkRevokeAllGatilhos.IsChecked = True then
  begin
    ssql := '';
    grant := 'revoke execute ';
    for I := 0 to cbGatilhos.Items.Count - 1 - 1 do begin
      ssql := ssql + grant + ' on trigger '
            + cbGatilhos.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.rbMarcarTabelasClick(Sender: TObject);
begin
  if Trim(edTabelaSelecionada.Text) = '' then Exit;
  if rbMarcarTabelas.IsChecked = False then
    SelecionaPrivilegiosTabelas(True)
  else
    SelecionaPrivilegiosTabelas(True);
end;

procedure TfPrivilegio.rbDesmarcarTabelasClick(Sender: TObject);
begin
  if Trim(edTabelaSelecionada.Text) = '' then Exit;
  if rbMarcarTabelas.IsChecked = True then
    SelecionaPrivilegiosTabelas(False)
  else
    SelecionaPrivilegiosTabelas(False);
end;

procedure TfPrivilegio.rbMarcarVisoesClick(Sender: TObject);
begin
  if Trim(edVisaoSelecionada.Text) = '' then Exit;
  if rbMarcarVisoes.IsChecked = False then
    SelecionaPrivilegiosVisoes(True)
  else
    SelecionaPrivilegiosVisoes(True);
end;

procedure TfPrivilegio.rbDesmarcarVisoesClick(Sender: TObject);
begin
  if Trim(edVisaoSelecionada.Text) = '' then Exit;
  if rbMarcarVisoes.IsChecked = True then
    SelecionaPrivilegiosVisoes(False)
  else
    SelecionaPrivilegiosVisoes(False);
end;

procedure TfPrivilegio.btnConfirmarTabelaClick(Sender: TObject);
const
  Terminador = ';';
var
  ssql: string;
begin
  if Trim(edTabelaSelecionada.Text) = '' then Exit;

// Remove privilégios, caso existam
  ssql := ' revoke all on ' + edTabelaSelecionada.Text
        + ' from ' + edObjeto.Text + Terminador + #13#10;

// Assegura privilégios
  if chkSelect.IsChecked then
  begin
    ssql := ssql + 'grant select on ' + edTabelaSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkSelectGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkInsert.IsChecked then
  begin
    ssql := ssql + 'grant insert on ' + edTabelaSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkInsertGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkUpdate.IsChecked then
  begin
    ssql := ssql + 'grant update on ' + edTabelaSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkUpdateGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkDelete.IsChecked then
  begin
    ssql := ssql + 'grant delete on ' + edTabelaSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkDeleteGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkReferences.IsChecked then
  begin
    ssql := ssql + 'grant references on ' + edTabelaSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkReferencesGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.btnConfirmarVisaoClick(Sender: TObject);
const
  Terminador = ';';
var
  ssql: string;
begin
  if Trim(edVisaoSelecionada.Text) = '' then Exit;

// Remove privilégios, caso existam
  ssql := ' revoke all on ' + edVisaoSelecionada.Text
        + ' from ' + edObjeto.Text + Terminador + #13#10;

// Assegura privilégios
  if chkSelect2.IsChecked then
  begin
    ssql := ssql + 'grant select on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkSelectGrantOption2.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkInsert2.IsChecked then
  begin
    ssql := ssql + 'grant insert on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkInsertGrantOption2.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql+ Terminador + #13#10;
  end;

  if chkUpdate2.IsChecked then
  begin
    ssql := ssql + 'grant update on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkUpdateGrantOption2.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkDelete2.IsChecked then
  begin
    ssql := ssql + 'grant delete on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkDeleteGrantOption2.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkReferences2.IsChecked then
  begin
    ssql := ssql + 'grant references on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkReferencesGrantOption2.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.btnConfirmarProcedimentoClick(Sender: TObject);
const
  Terminador = ';';
var
  ssql: string;
begin
  if Trim(edProcedimentoSelecionado.Text) = '' then Exit;

// Remove privilégio, caso exista
  ssql := ' revoke execute on procedure ' + edProcedimentoSelecionado.Text
        + ' from ' + edObjeto.Text + Terminador + #13#10;

// Assegura privilégios
  if chkExecute.IsChecked then
  begin
    ssql := ssql + 'grant execute on procedure '
          + edProcedimentoSelecionado.Text + ' to ' + edObjeto.Text;
    if chkExecuteGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.btnConfirmarGatilhoClick(Sender: TObject);
const
  Terminador = ';';
var
  ssql: string;
begin
  if Trim(edGatilhoSelecionado.Text) = '' then Exit;

// Remove privilégio, caso exista
  ssql := ' revoke execute on trigger ' + edGatilhoSelecionado.Text
        + ' from ' + edObjeto.Text + Terminador + #13#10;

// Assegura privilégios
  if chkExecute.IsChecked then
  begin
    ssql := ssql + 'grant execute on trigger '
          + edGatilhoSelecionado.Text + ' to ' + edObjeto.Text;
    if chkExecuteGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add(ssql);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfPrivilegio.btnConfirmarTabelasClick(Sender: TObject);
begin
  if (chkGrantAllTabelas.IsChecked = True) or
     (chkRevokeAllTabelas.IsChecked = True) then
  begin
    ConcedeRetiraPrivilegiosTabelas;
    RecuperaPrivilegiosTabelas;
  end;
end;

procedure TfPrivilegio.btnConfirmarVisoesClick(Sender: TObject);
begin
  if (chkGrantAllVisoes.IsChecked = True) or
     (chkRevokeAllVisoes.IsChecked = True) then
  begin
    ConcedeRetiraPrivilegiosVisoes;
    RecuperaPrivilegiosVisoes;
  end;
end;

procedure TfPrivilegio.btnConfirmarProcedimentosClick(Sender: TObject);
begin
  if (chkGrantAllProcedimentos.IsChecked = True) or
     (chkRevokeAllProcedimentos.IsChecked = True) then
  begin
    ConcedeRetiraPrivilegiosProcedimentos;
    RecuperaPrivilegiosProcedimentos;
  end;
end;

procedure TfPrivilegio.btnConfirmarGatilhosClick(Sender: TObject);
begin
  if (chkGrantAllGatilhos.IsChecked = True) or
     (chkRevokeAllGatilhos.IsChecked = True) then
  begin
    ConcedeRetiraPrivilegiosGatilhos;
    RecuperaPrivilegiosGatilhos;
  end;
end;

procedure TfPrivilegio.chkGrantAllTabelasClick(Sender: TObject);
begin
  if chkGrantAllTabelas.IsChecked = False then
  begin
    chkRevokeAllTabelas.IsChecked := False
  end;
  if chkRevokeAllTabelas.IsChecked = False then
  begin
    chkGrantAllTabelas.IsChecked := False
  end;
end;

procedure TfPrivilegio.chkGrantAllVisoesClick(Sender: TObject);
begin
  if chkGrantAllVisoes.IsChecked = False then
  begin
    chkRevokeAllVisoes.IsChecked := False
  end;
  if chkRevokeAllVisoes.IsChecked = False then
  begin
    chkGrantAllVisoes.IsChecked := False
  end;
end;

procedure TfPrivilegio.chkGrantAllProcedimentosClick(Sender: TObject);
begin
  if chkGrantAllProcedimentos.IsChecked = False then
  begin
    chkRevokeAllProcedimentos.IsChecked := False
  end;
  if chkRevokeAllProcedimentos.IsChecked = False then
  begin
    chkGrantAllProcedimentos.IsChecked := False;
  end;
end;

end.
