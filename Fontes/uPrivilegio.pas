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
    grpVisoes: TGroupBox;
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
    rbMarcarTodas: TRadioButton;
    rbDesmarcarTodas: TRadioButton;
    grpProcedimentos: TGroupBox;
    chkExecute: TCheckBox;
    chkExecuteGrantOption: TCheckBox;
    btnLimpar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTabelasClosePopup(Sender: TObject);
    procedure cbVisoesClosePopup(Sender: TObject);
    procedure cbProcedimentosClosePopup(Sender: TObject);
    procedure rbMarcarTodasClick(Sender: TObject);
    procedure rbDesmarcarTodasClick(Sender: TObject);
    procedure btnConfirmarTabelaClick(Sender: TObject);
    procedure btnConfirmarVisaoClick(Sender: TObject);
    procedure btnConfirmarProcedimentoClick(Sender: TObject);
    procedure btnConfirmarTabelasClick(Sender: TObject);
    procedure btnConfirmarVisoesClick(Sender: TObject);
    procedure btnConfirmarProcedimentosClick(Sender: TObject);
    procedure chkGrantAllTabelasClick(Sender: TObject);
    procedure chkGrantAllVisoesClick(Sender: TObject);
    procedure chkGrantAllProcedimentosClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
  public
    { Public declarations }
    Alias: string;
    Role: string;

    procedure RecuperaTabelas;
    procedure RecuperaVisoes;
    procedure RecuperaProcedimentos;

    procedure SelecionaPrivilegiosTabelasVisoes(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosTabelasVisoes(AObjeto: string);

    procedure SelecionaPrivilegiosProcedimentos(AChecked: Boolean=True);
    procedure RecuperaPrivilegiosProcedimentos;

    procedure ExecutaScript(ASql: string);
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
    RecuperaVisoes;
    RecuperaProcedimentos;

    if cbTabelas.Items.Count > 0 then
      cbTabelas.ItemIndex := 0;
    if cbVisoes.Items.Count > 0 then
      cbVisoes.ItemIndex := 0;
    if cbProcedimentos.Items.Count > 0 then
      cbProcedimentos.ItemIndex := 0;

    if cbTabelas.Items.Count > 0 then
      cbTabelasClosePopup(Self);

    if cbProcedimentos.Items.Count > 0 then
      cbProcedimentosClosePopup(Self)
    else
    if cbVisoes.Items.Count > 0 then
      cbVisoesClosePopup(Self);
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

procedure TfPrivilegio.cbTabelasClosePopup(Sender: TObject);
begin
  if cbTabelas.Items.Count = 0 then Exit;
  edTabelaSelecionada.Text := cbTabelas.Selected.Text;
  edVisaoSelecionada.Text := '';
  RecuperaPrivilegiosTabelasVisoes(edTabelaSelecionada.Text);
end;

procedure TfPrivilegio.cbVisoesClosePopup(Sender: TObject);
begin
  if cbVisoes.Items.Count = 0 then Exit;
  edVisaoSelecionada.Text := cbVisoes.Selected.Text;
  edTabelaSelecionada.Text := '';
  RecuperaPrivilegiosTabelasVisoes(edVisaoSelecionada.Text);
end;

procedure TfPrivilegio.cbProcedimentosClosePopup(Sender: TObject);
begin
  if cbProcedimentos.Items.Count = 0 then Exit;
  edProcedimentoSelecionado.Text := cbProcedimentos.Selected.Text;
  RecuperaPrivilegiosProcedimentos;
end;

procedure TfPrivilegio.SelecionaPrivilegiosTabelasVisoes(AChecked: Boolean);
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

procedure TfPrivilegio.RecuperaPrivilegiosTabelasVisoes(AObjeto: string);
var
  qryX: TFDQuery;
  ssql, user, priv, grant: string;
begin
  if Trim(AObjeto) = '' then Exit;
  user := Trim(edObjeto.Text);
  SelecionaPrivilegiosTabelasVisoes(False);
  qryX := TFDQuery.Create(Self);
  qryX.Connection := fdm.FDConnection;

  ssql := ' select rdb$privilege, rdb$grant_option '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(user))
        + '    and upper(rdb$relation_name) = '
        +          QuotedStr(Trim(AnsiUpperCase(AObjeto)));

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

procedure TfPrivilegio.rbMarcarTodasClick(Sender: TObject);
begin
  if (Trim(edTabelaSelecionada.Text) = '') and
     (Trim(edVisaoSelecionada.Text) = '') then Exit;

  if rbMarcarTodas.IsChecked = False then
    SelecionaPrivilegiosTabelasVisoes(True)
  else
    SelecionaPrivilegiosTabelasVisoes(True);
end;

procedure TfPrivilegio.rbDesmarcarTodasClick(Sender: TObject);
begin
  if (Trim(edTabelaSelecionada.Text) = '') and
     (Trim(edVisaoSelecionada.Text) = '') then Exit;

  if rbMarcarTodas.IsChecked = True then
    SelecionaPrivilegiosTabelasVisoes(False)
  else
    SelecionaPrivilegiosTabelasVisoes(False);
end;

procedure TfPrivilegio.btnLimparClick(Sender: TObject);
begin
  edTabelaSelecionada.Text := '';
  edVisaoSelecionada.Text := '';
  edProcedimentoSelecionado.Text := '';
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

// Ajusta opções
  if chkSelectGrantOption.IsChecked then
     chkSelect.IsChecked := True;
  if chkInsertGrantOption.IsChecked then
     chkInsert.IsChecked := True;
  if chkUpdateGrantOption.IsChecked then
     chkUpdate.IsChecked := True;
  if chkDeleteGrantOption.IsChecked then
     chkDelete.IsChecked := True;
  if chkReferencesGrantOption.IsChecked then
     chkReferences.IsChecked := True;

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

  ExecutaScript(ssql);
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

// Ajusta opções
  if chkSelectGrantOption.IsChecked then
     chkSelect.IsChecked := True;
  if chkInsertGrantOption.IsChecked then
     chkInsert.IsChecked := True;
  if chkUpdateGrantOption.IsChecked then
     chkUpdate.IsChecked := True;
  if chkDeleteGrantOption.IsChecked then
     chkDelete.IsChecked := True;
  if chkReferencesGrantOption.IsChecked then
     chkReferences.IsChecked := True;

// Assegura privilégios
  if chkSelect.IsChecked then
  begin
    ssql := ssql + 'grant select on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkSelectGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkInsert.IsChecked then
  begin
    ssql := ssql + 'grant insert on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkInsertGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql+ Terminador + #13#10;
  end;

  if chkUpdate.IsChecked then
  begin
    ssql := ssql + 'grant update on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkUpdateGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkDelete.IsChecked then
  begin
    ssql := ssql + 'grant delete on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkDeleteGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  if chkReferences.IsChecked then
  begin
    ssql := ssql + 'grant references on ' + edVisaoSelecionada.Text
          + ' to ' + edObjeto.Text;
    if chkReferencesGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  ExecutaScript(ssql);
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

// Ajusta opções
  if chkExecuteGrantOption.IsChecked then
     chkExecute.IsChecked := True;

// Assegura privilégios
  if chkExecute.IsChecked then
  begin
    ssql := ssql + 'grant execute on procedure '
          + edProcedimentoSelecionado.Text + ' to ' + edObjeto.Text;
    if chkExecuteGrantOption.IsChecked then
      ssql := ssql + ' with grant option ';
    ssql := ssql + Terminador + #13#10;
  end;

  ExecutaScript(ssql);
end;

procedure TfPrivilegio.btnConfirmarTabelasClick(Sender: TObject);
var
  ssql: string;
  I: Integer;
begin
  if (chkGrantAllTabelas.IsChecked = False) and
     (chkRevokeAllTabelas.IsChecked = False) then Exit;

  if chkGrantAllTabelas.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbTabelas.Items.Count - 1 do begin
      ssql := ssql + ' grant all on '
            + cbTabelas.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option;' + #13#10;
    end;
  end;

  if chkRevokeAllTabelas.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbTabelas.Items.Count - 1 do begin
      ssql := ssql + ' revoke all on '
            + cbTabelas.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  ExecutaScript(ssql);
end;

procedure TfPrivilegio.btnConfirmarVisoesClick(Sender: TObject);
var
  ssql: string;
  I: Integer;
begin
  if (chkGrantAllVisoes.IsChecked = False) and
     (chkRevokeAllVisoes.IsChecked = False) then Exit;

  if chkGrantAllVisoes.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbVisoes.Items.Count - 1 do begin
      ssql := ssql + ' grant all on '
            + cbVisoes.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end;

  if chkRevokeAllVisoes.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbVisoes.Items.Count - 1 do begin
      ssql := ssql + ' revoke all on '
            + cbVisoes.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  ExecutaScript(ssql);
end;

procedure TfPrivilegio.btnConfirmarProcedimentosClick(Sender: TObject);
var
  ssql: string;
  I: Integer;
begin
  if (chkGrantAllProcedimentos.IsChecked = False) or
     (chkRevokeAllProcedimentos.IsChecked = False) then Exit;

  if chkGrantAllProcedimentos.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbProcedimentos.Items.Count - 1 do begin
      ssql := ssql + ' grant execute on procedure '
            + cbProcedimentos.ListItems[I].Text
            + ' to ' + edObjeto.Text
            + ' with grant option; ' + #13#10;
    end;
  end;

  if chkRevokeAllProcedimentos.IsChecked = True then
  begin
    ssql := '';
    for I := 0 to cbProcedimentos.Items.Count - 1 do begin
      ssql := ssql + ' revoke execute on procedure '
            + cbProcedimentos.ListItems[I].Text
            + ' from ' + edObjeto.Text + ';' + #13#10;
    end;
  end;

  ExecutaScript(ssql);
end;

procedure TfPrivilegio.ExecutaScript(ASql: string);
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
      lbMensagem.Text := 'Instrução executada!';
    end;
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
