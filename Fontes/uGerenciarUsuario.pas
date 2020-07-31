unit uGerenciarUsuario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts,
  System.IniFiles, uDAC, FireDAC.Comp.Client, FireDAC.Phys.IBWrapper,
  FMX.ComboEdit;

type
  TfGerenciarUsuario = class(TfxForm)
    pnlAcoes: TPanel;
    btnNovo: TButton;
    btnExcluir: TButton;
    btnGrantsUser: TButton;
    btnSalvar: TButton;
    pnlLateral: TPanel;
    Splitter: TSplitter;
    pnlCentral: TPanel;
    ListBox: TListBox;
    grpUsuario: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    edUsuario: TEdit;
    edSenha: TEdit;
    cbPapeis: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edPrimeiroNome: TEdit;
    edNomeMeio: TEdit;
    edUltimoNome: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    btnGrantsRole: TButton;
    cbPapeisUsuario: TComboEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGrantsUserClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edUsuarioChange(Sender: TObject);
    procedure cbPapeisClosePopup(Sender: TObject);
    procedure btnGrantsRoleClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    tsRegistros: TStrings;
    tsAlteracoes: TStrings;
    UsuarioCorrente: string;
    Operacao: string;
    procedure RecuperaPapeis;
    procedure LimpaCampos;
    procedure LeUsuariosRegistrados;
    procedure RecuperaDadosUsuario;
    procedure VerificaSYSDBA_PUBLIC;
    function GravaUsuario(): Boolean;
    function ExcluiUsuario(): Boolean;
    function ConcedePrivilegio(Papel: string): Boolean;
  public
    { Public declarations }
    Alias: string;
  end;

var
  fGerenciarUsuario: TfGerenciarUsuario;

implementation

{$R *.fmx}

uses
  uxFuncs, uPrivilegio;

procedure TfGerenciarUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Gerenciar Usuários';
  fdm := TfDAC.Create(Self);
end;

procedure TfGerenciarUsuario.FormShow(Sender: TObject);
begin
  inherited;
  tsRegistros := TStringList.Create;
  tsAlteracoes := TStringList.Create;
  LimpaCampos;
  LeUsuariosRegistrados;

  btnExcluir.Enabled := False;
  btnGrantsUser.Enabled := False;
  btnGrantsRole.Enabled := False;
  Operacao := '';

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaPapeis;
    if cbPapeis.Count > 0 then
      cbPapeis.ItemIndex := 0;
    btnGrantsUser.Enabled := True;
    btnGrantsRole.Enabled := True;
  end;
end;

procedure TfGerenciarUsuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  tsRegistros.Free;
  tsAlteracoes.Free;
  fGerenciarUsuario.Release;
  fGerenciarUsuario := nil;
end;

procedure TfGerenciarUsuario.LeUsuariosRegistrados;
begin
  tsRegistros.Clear;
  ListBox.Items.Clear;
  ListBox.Items.Add('PUBLIC');
  tsRegistros.Add('PUBLIC');

  fdm.FDIBSecurity.DriverLink := fdm.FDPhysFBDriverLink;
  fdm.FDIBSecurity.UserName := uDAC.FB_USER_NAME;
  fdm.FDIBSecurity.Password := uDAC.FB_PASSWORD;
  fdm.FDIBSecurity.Host := 'localhost';
  fdm.FDIBSecurity.Protocol := ipLocal;
  fdm.FDIBSecurity.DisplayUsers;
  fdm.FDMemTable.AttachTable(fdm.FDIBSecurity.Users, nil);
  fdm.FDMemTable.Open;

  with fdm.FDMemTable do begin
    First;
    while not Eof do begin
      ListBox.Items.Add(Fields[0].AsString);
      tsRegistros.Add(Fields[0].AsString);
      Next;
    end;
  end;
end;

procedure TfGerenciarUsuario.RecuperaPapeis;
begin
  fdm.GetRoles(nil, cbPapeis);
end;

procedure TfGerenciarUsuario.ListBoxClick(Sender: TObject);
var
  Item: TListBoxItem;
  I: Integer;
begin
  Operacao := 'Existente';
  LimpaCampos;
  Item := TListBoxItem.Create(nil);

  for I := 0 to ListBox.Items.Count - 1 do begin
    Item := ListBox.Selected;
    Break;
  end;

  UsuarioCorrente := Item.Text;
  edUsuario.Text := Item.Text;
  RecuperaDadosUsuario;
end;

procedure TfGerenciarUsuario.RecuperaDadosUsuario;
begin
  if (UsuarioCorrente = 'PUBLIC') then
  begin
    edSenha.Text := '';
    edPrimeiroNome.Text := '';
    edNomeMeio.Text := '';
    edUltimoNome.Text := '';
  end
  else
  begin
    fdm.FDIBSecurity.DriverLink := fdm.FDPhysFBDriverLink;
    fdm.FDIBSecurity.AUserName := UsuarioCorrente;
    fdm.FDIBSecurity.UserName := uDAC.FB_USER_NAME;
    fdm.FDIBSecurity.Password := uDAC.FB_PASSWORD;
    fdm.FDIBSecurity.Host := 'localhost';
    fdm.FDIBSecurity.Protocol := ipLocal;
    fdm.FDIBSecurity.DisplayUser;
    edUsuario.Text := UsuarioCorrente;
    edSenha.Text := '';
    edPrimeiroNome.Text := fdm.FDIBSecurity.AFirstName;
    edNomeMeio.Text := fdm.FDIBSecurity.AMiddleName;
    edUltimoNome.Text := fdm.FDIBSecurity.ALastName;
  end;

  if (UsuarioCorrente <> 'SYSDBA') and
     (UsuarioCorrente <> 'PUBLIC') then
  begin
    fdm.GetRoleUser(UsuarioCorrente, cbPapeisUsuario);
    if cbPapeisUsuario.Items.Count > 0 then
      cbPapeisUsuario.ItemIndex := 0
    else
      cbPapeisUsuario.Text := '';
  end
  else
  begin
    cbPapeisUsuario.Text := '';
  end;
end;

procedure TfGerenciarUsuario.LimpaCampos;
begin
  edUsuario.Text := '';
  edSenha.Text := '';
  edPrimeiroNome.Text := '';
  edNomeMeio.Text := '';
  edUltimoNome.Text := '';
  cbPapeisUsuario.Items.Clear;
  cbPapeisUsuario.Text := '';
end;

procedure TfGerenciarUsuario.btnNovoClick(Sender: TObject);
begin
  Operacao := 'Novo';
  UsuarioCorrente := '';
  LimpaCampos;
  btnExcluir.Enabled := False;
  btnSalvar.Enabled := True;
  edUsuario.SetFocus;
end;

procedure TfGerenciarUsuario.btnExcluirClick(Sender: TObject);
var
  I: Integer;
  usuario: string;
begin
  if Trim(edUsuario.Text) = '' then
  begin
    ShowMessage('Informe o nome do usuário!');
    edUsuario.SetFocus;
    Exit;
  end;

  if Self.Confirma(
      'Excluir o usuário ' + edUsuario.Text + '?', 'N') = False then
    Exit;

  if ExcluiUsuario = True then
  begin
    tsAlteracoes.Clear;

    for I := 0 to tsRegistros.Count - 1 do begin
      usuario := tsRegistros.Strings[I];
      if (usuario <> edUsuario.Text) then
        tsAlteracoes.Add(tsRegistros.Strings[I])
    end;

    tsRegistros.Clear;
    ListBox.Clear;

    for I := 0 to tsAlteracoes.Count - 1 do begin
      ListBox.Items.Add(tsAlteracoes.Strings[I]);
      tsRegistros.Add(tsAlteracoes.Strings[I]);
    end;

    LimpaCampos;
  end;
end;

procedure TfGerenciarUsuario.btnSalvarClick(Sender: TObject);
var
  I: Integer;
  papel: string;
begin
  if Trim(edUsuario.Text) = '' then
  begin
    ShowMessage('Informe o nome do usuário!');
    edUsuario.SetFocus;
    Exit;
  end;

  if GravaUsuario = True then
  begin
    papel := Trim(cbPapeisUsuario.Text);
    if papel <> '' then
      ConcedePrivilegio(papel);
    if Trim(edUsuario.Text) <> UsuarioCorrente then
    begin
      tsRegistros.Add(edUsuario.Text);
      ListBox.Clear;
      for I := 0 to tsRegistros.Count - 1 do begin
        ListBox.Items.Add(tsRegistros.Strings[I]);
        tsAlteracoes.Add(tsRegistros.Strings[I]);
      end;
    end;
  end;
end;

function TfGerenciarUsuario.GravaUsuario: Boolean;
begin
  Result := False;
  try
    fdm.FDIBSecurity.DriverLink := fdm.FDPhysFBDriverLink;
    fdm.FDIBSecurity.UserName := uDAC.FB_USER_NAME;
    fdm.FDIBSecurity.Password := uDAC.FB_PASSWORD;
    fdm.FDIBSecurity.AUserName := edUsuario.Text;

    if edSenha.Text <> '' then
      fdm.FDIBSecurity.APassword := edSenha.Text;

    fdm.FDIBSecurity.AFirstName := edPrimeiroNome.Text;
    fdm.FDIBSecurity.AMiddleName := edNomeMeio.Text;
    fdm.FDIBSecurity.ALastName := edUltimoNome.Text;
    fdm.FDIBSecurity.Host := 'localhost';
    fdm.FDIBSecurity.Protocol := ipLocal;

    if Operacao = 'Novo' then
      begin
      fdm.FDIBSecurity.AddUser;
      Operacao := '';
      UsuarioCorrente := '';
      end
    else
    if Trim(edUsuario.Text) <> UsuarioCorrente then
      fdm.FDIBSecurity.ModifyUser;

    Result := True;
  except
    raise;
  end;
end;

function TfGerenciarUsuario.ConcedePrivilegio(Papel: string): Boolean;
var
  ssql: string;
begin
  ssql := 'grant ' + Trim(Papel) + ' to ' + Trim(edUsuario.Text) + ';';

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
    end
    else
    begin
      fdm.CommitUpdateTransaction;
    end;
  end;
end;

function TfGerenciarUsuario.ExcluiUsuario: Boolean;
begin
  Result := False;
  try
    fdm.FDIBSecurity.DriverLink := fdm.FDPhysFBDriverLink;
    fdm.FDIBSecurity.UserName := uDAC.FB_USER_NAME;
    fdm.FDIBSecurity.Password := uDAC.FB_PASSWORD;
    fdm.FDIBSecurity.AUserName := edUsuario.Text;
    fdm.FDIBSecurity.Host := 'localhost';
    fdm.FDIBSecurity.Protocol := ipLocal;
    fdm.FDIBSecurity.DeleteUser;
    UsuarioCorrente := '';
    Result := True;
  except
    raise;
  end;
end;

procedure TfGerenciarUsuario.VerificaSYSDBA_PUBLIC;
begin
  if Trim(AnsiUpperCase(edUsuario.Text)) = 'SYSDBA' then
  begin
    btnExcluir.Enabled := False;
    btnSalvar.Enabled := True;
  end
  else
  if Trim(AnsiUpperCase(edUsuario.Text)) = 'PUBLIC' then
  begin
    btnExcluir.Enabled := False;
    btnSalvar.Enabled := False;
  end
  else
  begin
    if Operacao = 'Existente' then
    begin
      btnExcluir.Enabled := True;
      btnSalvar.Enabled := True;
    end;
  end;
end;

procedure TfGerenciarUsuario.btnGrantsUserClick(Sender: TObject);
begin
  if Trim(AnsiUpperCase(edUsuario.Text)) = 'SYSDBA' then
  begin
    ShowMessage('Operação não permitida para o SYSDBA!');
    edUsuario.SetFocus;
    Exit;
  end;

  if Trim(edUsuario.Text) = '' then
  begin
    ShowMessage('Não há usuário selecionado!');
    edUsuario.SetFocus;
    Exit;
  end;

  try
    fPrivilegio := TfPrivilegio.Create(Application);
    fPrivilegio.Alias := Self.Alias;
    fPrivilegio.Role := cbPapeisUsuario.Text;
    fPrivilegio.edObjeto.Text := edUsuario.Text;
    fPrivilegio.lbTipoObjeto.Text := 'Usuário';
    fPrivilegio.ShowModal;
  finally
    fPrivilegio.Free;
  end;
end;

procedure TfGerenciarUsuario.btnGrantsRoleClick(Sender: TObject);
begin
  if Trim(cbPapeisUsuario.Text) = 'RDB$ADMIN' then
  begin
    ShowMessage('Operação não permitida para o RDB$ADMIN!');
    Exit;
  end;

  if Trim(cbPapeisUsuario.Text) = '' then
  begin
    ShowMessage('Não há papel selecionado!');
    Exit;
  end;

  try
    fPrivilegio := TfPrivilegio.Create(Application);
    fPrivilegio.Alias := Self.Alias;
    fPrivilegio.Role := '';
    fPrivilegio.edObjeto.Text := cbPapeisUsuario.Text;
    fPrivilegio.lbTipoObjeto.Text := 'Papel';
    fPrivilegio.ShowModal;
  finally
    fPrivilegio.Free;
  end;
end;

procedure TfGerenciarUsuario.cbPapeisClosePopup(Sender: TObject);
var
  I: Integer;
  Achou: Boolean;
begin
  Achou := False;
  for I := 0 to cbPapeisUsuario.Count - 1 do begin
    if cbPapeisUsuario.Items[I] = cbPapeis.Selected.Text then
    begin
      Achou := True;
      Break;
    end
  end;
  if Achou = False then
    cbPapeisUsuario.Items.Add(cbPapeis.Selected.Text);
end;

procedure TfGerenciarUsuario.edUsuarioChange(Sender: TObject);
begin
  edUsuario.OnChange := nil;
  edUsuario.Text := Trim(AnsiUpperCase(edUsuario.Text));
  if edUsuario.Text <> UsuarioCorrente then
  begin
    UsuarioCorrente := edUsuario.Text;
    RecuperaDadosUsuario;
  end;
  VerificaSYSDBA_PUBLIC;
  edUsuario.OnChange := edUsuarioChange;
end;

end.
