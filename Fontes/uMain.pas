unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Menus, FMX.StdCtrls, FMX.Layouts, FMX.TreeView,
  FMX.TabControl, FMX.Printer, System.IniFiles, uDAC, FMX.ListBox,
  FMX.Ani, FMX.Objects, System.Actions, FMX.ActnList, FMX.Edit,
  FMX.Controls.Presentation;

type
  TfMain = class(TForm)
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    mnuBancoDados: TMenuItem;
    mnuCriarBancoDados: TMenuItem;
    pnlLateral: TPanel;
    TabControl: TTabControl;
    tabBancos: TTabItem;
    tabMetadados: TTabItem;
    tvBancos: TTreeView;
    tvMetadados: TTreeView;
    Splitter: TSplitter;
    pnlCentral: TPanel;
    TabControlTDI: TTabControl;
    mnuRegistrarBancoDados: TMenuItem;
    mnuMetadados: TMenuItem;
    mnuCriarTabela: TMenuItem;
    mnuCriarVisao: TMenuItem;
    mnuCriarProcedimento: TMenuItem;
    mnuCriarGerador: TMenuItem;
    mnuCriarExcecao: TMenuItem;
    mnuCriarFuncao: TMenuItem;
    mnuCriarDominio: TMenuItem;
    mnuCriarPapel: TMenuItem;
    ActionList: TActionList;
    acRegistrarBanco: TAction;
    acCriarBanco: TAction;
    mnuCriarGatilho: TMenuItem;
    acCriarTabela: TAction;
    acCriarVisao: TAction;
    acCriarProcedimento: TAction;
    acCriarGerador: TAction;
    acCriarGatilho: TAction;
    acCriarExcecao: TAction;
    acCriarFuncao: TAction;
    acCriarDominio: TAction;
    acCriarPapel: TAction;
    mnuFerramentas: TMenuItem;
    mnuBackup: TMenuItem;
    mnuRestore: TMenuItem;
    mnuEditorSQL: TMenuItem;
    mnuEditorScript: TMenuItem;
    acEditorSQL: TAction;
    acEditorScript: TAction;
    acBackup: TAction;
    acRestore: TAction;
    mnuFecharBanco: TMenuItem;
    acFecharBanco: TAction;
    acEstilo0: TAction;
    acEstilo1: TAction;
    acEstilo2: TAction;
    acEstilo3: TAction;
    acEstilo4: TAction;
    mnuSistema: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    mnuSair: TMenuItem;
    mnuEstilo: TMenuItem;
    StyleBook0: TStyleBook;
    StyleBook1: TStyleBook;
    StyleBook2: TStyleBook;
    StyleBook3: TStyleBook;
    StyleBook4: TStyleBook;
    acGerenciarUsuario: TAction;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    lbBancoConectado: TLabel;
    ToolBar: TToolBar;
    btnFechar: TButton;
    acHeader: TAction;
    MenuItem8: TMenuItem;
    acEstatistica: TAction;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    acCriarTabela2: TAction;
    MenuItem12: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure tvBancosDblClick(Sender: TObject);
    procedure tvMetadadosDblClick(Sender: TObject);
    procedure acCriarBancoExecute(Sender: TObject);
    procedure acRegistrarBancoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acCriarTabelaExecute(Sender: TObject);
    procedure acCriarVisaoExecute(Sender: TObject);
    procedure acCriarProcedimentoExecute(Sender: TObject);
    procedure acCriarGeradorExecute(Sender: TObject);
    procedure acCriarGatilhoExecute(Sender: TObject);
    procedure acCriarExcecaoExecute(Sender: TObject);
    procedure acCriarFuncaoExecute(Sender: TObject);
    procedure acCriarDominioExecute(Sender: TObject);
    procedure acCriarPapelExecute(Sender: TObject);
    procedure acEditorSQLExecute(Sender: TObject);
    procedure acEditorScriptExecute(Sender: TObject);
    procedure acBackupExecute(Sender: TObject);
    procedure acRestoreExecute(Sender: TObject);
    procedure acFecharBancoExecute(Sender: TObject);
    procedure acEstilo0Execute(Sender: TObject);
    procedure acEstilo1Execute(Sender: TObject);
    procedure acEstilo2Execute(Sender: TObject);
    procedure acEstilo3Execute(Sender: TObject);
    procedure acEstilo4Execute(Sender: TObject);
    procedure mnuSairClick(Sender: TObject);
    procedure acGerenciarUsuarioExecute(Sender: TObject);
    procedure acHeaderExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acEstatisticaExecute(Sender: TObject);
    procedure acCriarTabela2Execute(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    Alias: string;
    Banco: string;

    procedure RecuperaBancos;
    procedure RecuperaMetadados;
    procedure RecuperaMetadado(AGrupo: string; AItem1, AItem2: Integer);
    procedure HabilitaMenu;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

uses
  uxFuncs,
  uCriarBanco, uRegistrarBanco, uTabela, uGatilho, uCriarTabela,
  uVisao, uGerador, uExcecao, uPapel, uProcedimento, uFuncao, uDominio,
  uCriarVisao, uCriarProcedimento, uCriarGerador, uCriarGatilho,
  uCriarExcecao, uCriarFuncao, uCriarDominio, uCriarPapel, uEditorSQL,
  uEditorScript, uBackup, uRestore, uGerenciarUsuario, uCriarTabela2,
  uHeader, uEstatistica;

procedure TfMain.FormCreate(Sender: TObject);
begin
  Caption := 'Administrador Firebird';
  fdm := TfDAC.Create(Self);
  TabControl.ActiveTab := tabBancos;
  RecuperaBancos;
  lbBancoConectado.Text := '';
end;

procedure TfMain.FormShow(Sender: TObject);
var
  sEstilo: string;
  iEstilo: Integer;
begin
  sEstilo := mc_LeArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '0');
  iEstilo := StrToIntDef(sEstilo, 0);
  case iEstilo of
    0 : Self.StyleBook := StyleBook0;
    1 : Self.StyleBook := StyleBook1;
    2 : Self.StyleBook := StyleBook2;
    3 : Self.StyleBook := StyleBook3;
    4 : Self.StyleBook := StyleBook4;
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fdm.FDConnection.Connected = True then
    fdm.FDConnection.Connected := False;
  fdm.Free;
end;

procedure TfMain.mnuSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfMain.RecuperaBancos;
var
  List: TListBox;
  FileName: TIniFile;
  S, objName: string;
  I: Integer;
  Item1: TTreeViewItem;
  Item2: TTreeViewItem;
begin
  List := TListBox.Create(Self);
  tvBancos.Clear;
  FileName := TIniFile.Create(mc_GetArquivoCfg);
  FileName.ReadSectionValues('Databases', List.Items);

  for I := 0 to List.Count - 1 do begin
    S := Trim(mc_GetPiece(List.Items[I], 1, '='));
    objName := uxFuncs.mc_GetPiece(S, 1, '#');
    Item1 := TTreeViewItem.Create(Self);
    Item1.Text := objName;
    Item1.Parent := tvBancos;
  end;

  FileName.Free;
  List.Free;
  TabControl.ActiveTab := tabBancos;
end;

procedure TfMain.tvBancosDblClick(Sender: TObject);
begin
  Alias := '';
  Banco := '';
  lbBancoConectado.Text := '';
  if (tvBancos.Count = 0) then Exit;
  if fdm.GetConnection(tvBancos.Selected.Text) = True then
  begin
    Alias := tvBancos.Selected.Text;
    Banco := fdm.GetDatabase(Alias);
    RecuperaMetadados;
    TabControl.ActiveTab := tabMetadados;
    HabilitaMenu;
    lbBancoConectado.Text := 'Banco Conectado: ' +
      ExtractFileName(Banco);
  end;
end;

procedure TfMain.RecuperaMetadados;
begin
  tvMetadados.Clear;
  RecuperaMetadado('Tabelas', -1, 1);
  RecuperaMetadado('Visões', -2, 2);
  RecuperaMetadado('Procedimentos', -3, 3);
  RecuperaMetadado('Geradores', -4, 4);
  RecuperaMetadado('Gatilhos', -5, 5);
  RecuperaMetadado('Exceções', -6, 6);
  RecuperaMetadado('Funções', -7, 7);
  RecuperaMetadado('Domínios', -8, 8);
  RecuperaMetadado('Papéis', -9, 9);
  RecuperaMetadado('Tabelas Sistema', -10, 10);
end;

procedure TfMain.RecuperaMetadado(AGrupo: string; AItem1, AItem2: Integer);
var
  Item1: TTreeViewItem;
  Item2: TTreeViewItem;
  objName, ssql: string;
begin
  Item1 := TTreeViewItem.Create(Self);
  Item1.Parent := tvMetadados;
  Item1.Text := AGrupo;
  Item1.Tag := AItem1;

  if AGrupo = 'Tabelas' then
  begin
    ssql := ' select rdb$relation_name as objName '
          + '   from rdb$relations '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '    and (rdb$view_source is null) '
          + '  order by rdb$relation_name ';
  end;
  if AGrupo = 'Visões' then
  begin
    ssql := ' select rdb$relation_name as objName '
          + '   from rdb$relations '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '    and (rdb$view_source is not null) '
          + '  order by rdb$relation_name ';
  end;
  if AGrupo = 'Procedimentos' then
  begin
    ssql := ' select rdb$procedure_name as objName '
          + '   from rdb$procedures '
          + '  order by rdb$procedure_name ';
  end;
  if AGrupo = 'Geradores' then
  begin
    ssql := ' select rdb$generator_name as objName '
          + '   from rdb$generators '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '  order by rdb$generator_name ';
  end;
  if AGrupo = 'Gatilhos' then
  begin
    ssql := ' select rdb$trigger_name as objName '
          + '   from rdb$triggers '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '  order by rdb$trigger_name ';
  end;
  if AGrupo = 'Exceções' then
  begin
    ssql := ' select rdb$exception_name as objName '
          + '   from rdb$exceptions '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '  order by rdb$exception_name ';
  end;
  if AGrupo = 'Funções' then
  begin
    ssql := ' select rdb$function_name as objName '
          + '   from rdb$functions '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '  order by rdb$function_name ';
  end;
  if AGrupo = 'Domínios' then
  begin
    ssql := ' select rdb$field_name as objName '
          + '   from rdb$fields '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '    and rdb$field_name not starting ''RDB$'' '
          + '  order by rdb$field_name ';
  end;
  if AGrupo = 'Papéis' then
  begin
    ssql := ' select rdb$role_name as objName '
          + '   from rdb$roles '
          + '  order by rdb$role_name ';
  end;
  if AGrupo = 'Tabelas Sistema' then
  begin
    ssql := ' select rdb$relation_name as objName '
          + '   from rdb$relations '
          + '  where (rdb$system_flag = 1) '
          + '    and (rdb$view_source is null) '
          + '  order by rdb$relation_name ';
  end;

  with fdm.FDQuery do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      objName := FieldByName('objName').AsString;
      Item2 := TTreeViewItem.Create(Self);
      Item2.Parent := Item1;
      Item2.Text := objName;
      Item2.Tag := AItem2;
      Next;
    end;
    Close;
  end;
end;

procedure TfMain.HabilitaMenu;
begin
  acGerenciarUsuario.Enabled := (Alias <> '');
  acFecharBanco.Enabled := (Alias <> '');
  acHeader.Enabled := (Alias <> '');
  acEditorSQL.Enabled := (Alias <> '');
  acEditorScript.Enabled := (Alias <> '');
  acEstatistica.Enabled := (Alias <> '');
  acCriarDominio.Enabled := (Alias <> '');
  acCriarTabela.Enabled := (Alias <> '');
  acCriarTabela2.Enabled := (Alias <> '');
  acCriarVisao.Enabled := (Alias <> '');
  acCriarProcedimento.Enabled := (Alias <> '');
  acCriarGerador.Enabled := (Alias <> '');
  acCriarGatilho.Enabled := (Alias <> '');
  acCriarExcecao.Enabled := (Alias <> '');
  acCriarFuncao.Enabled := (Alias <> '');
  acCriarPapel.Enabled := (Alias <> '');
end;

procedure TfMain.tvMetadadosDblClick(Sender: TObject);
begin
  if (tvMetadados.Selected) = nil then Exit;

  if (tvMetadados.Selected.Tag = -1) or
     (tvMetadados.Selected.Tag = 1) or
     (tvMetadados.Selected.Tag = -10) or
     (tvMetadados.Selected.Tag = 10) then
  begin
    if not Assigned(fTabela) then
    begin
      fTabela := TfTabela.Create(Application);
      fTabela.Transparency := True;
      fTabela.ParentTabControl := TabControlTDI;
      fTabela.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 1) or
         (tvMetadados.Selected.Tag = 10) then
      begin
        fTabela.NomeTabela := tvMetadados.Selected.Text;
      end;

      fTabela.Tag := tvMetadados.Selected.Tag;
      fTabela.NovaTela := True;
      fTabela.Show;
    end
    else
    begin
      fTabela.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 1) or
         (tvMetadados.Selected.Tag = 10) then
      begin
        fTabela.NomeTabela := tvMetadados.Selected.Text;
      end;

      fTabela.NovaTela := False;
      fTabela.Tag := tvMetadados.Selected.Tag;
      fTabela.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -2) or
     (tvMetadados.Selected.Tag = 2) then
  begin
    if not Assigned(fVisao) then
    begin
      fVisao := TfVisao.Create(Application);
      fVisao.Transparency := True;
      fVisao.ParentTabControl := TabControlTDI;
      fVisao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 2) then
        fVisao.Metadado := tvMetadados.Selected.Text
      else
        fVisao.Metadado := '';

      fVisao.NovaTela := True;
      fVisao.Tag := tvMetadados.Selected.Tag;
      fVisao.Show;
    end
    else
    begin
      fVisao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 2) then
        fVisao.Metadado := tvMetadados.Selected.Text
      else
        fVisao.Metadado := '';

      fVisao.NovaTela := False;
      fVisao.Tag := tvMetadados.Selected.Tag;
      fVisao.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -3) or
     (tvMetadados.Selected.Tag = 3) then
  begin
    if not Assigned(fProcedimento) then
    begin
      fProcedimento := TfProcedimento.Create(Application);
      fProcedimento.Transparency := True;
      fProcedimento.ParentTabControl := TabControlTDI;
      fProcedimento.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 3) then
        fProcedimento.Metadado := tvMetadados.Selected.Text
      else
        fProcedimento.Metadado := '';

      fProcedimento.NovaTela := True;
      fProcedimento.Tag := tvMetadados.Selected.Tag;
      fProcedimento.Show;
    end
    else
    begin
      fProcedimento.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 3) then
        fProcedimento.Metadado := tvMetadados.Selected.Text
      else
        fProcedimento.Metadado := '';

      fProcedimento.NovaTela := False;
      fProcedimento.Tag := tvMetadados.Selected.Tag;
      fProcedimento.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -4) or
     (tvMetadados.Selected.Tag = 4) then
  begin
    if not Assigned(fGerador) then
    begin
      fGerador := TfGerador.Create(Application);
      fGerador.Transparency := True;
      fGerador.ParentTabControl := TabControlTDI;
      fGerador.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 4) then
        fGerador.Metadado := tvMetadados.Selected.Text
      else
        fGerador.Metadado := '';

      fGerador.NovaTela := True;
      fGerador.Tag := tvMetadados.Selected.Tag;
      fGerador.Show;
    end
    else
    begin
      fGerador.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 4) then
        fGerador.Metadado := tvMetadados.Selected.Text
      else
        fGerador.Metadado := '';

      fGerador.NovaTela := False;
      fGerador.Tag := tvMetadados.Selected.Tag;
      fGerador.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -5) or
     (tvMetadados.Selected.Tag = 5) then
  begin
    if not Assigned(fGatilho) then
    begin
      fGatilho := TfGatilho.Create(Application);
      fGatilho.Transparency := True;
      fGatilho.ParentTabControl := TabControlTDI;
      fGatilho.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 5) then
        fGatilho.Metadado := tvMetadados.Selected.Text
      else
        fGatilho.Metadado := '';

      fGatilho.NovaTela := True;
      fGatilho.Tag := tvMetadados.Selected.Tag;
      fGatilho.Show;
    end
    else
    begin
      fGatilho.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 5) then
        fGatilho.Metadado := tvMetadados.Selected.Text
      else
        fGatilho.Metadado := '';

      fGatilho.NovaTela := False;
      fGatilho.Tag := tvMetadados.Selected.Tag;
      fGatilho.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -6) or
     (tvMetadados.Selected.Tag = 6) then
  begin
    if not Assigned(fExcecao) then
    begin
      fExcecao := TfExcecao.Create(Application);
      fExcecao.Transparency := True;
      fExcecao.ParentTabControl := TabControlTDI;
      fExcecao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 6) then
        fExcecao.Metadado := tvMetadados.Selected.Text
      else
        fExcecao.Metadado := '';

      fExcecao.NovaTela := True;
      fExcecao.Tag := tvMetadados.Selected.Tag;
      fExcecao.Show;
    end
    else
    begin
      fExcecao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 6) then
        fExcecao.Metadado := tvMetadados.Selected.Text
      else
        fExcecao.Metadado := '';

      fExcecao.NovaTela := False;
      fExcecao.Tag := tvMetadados.Selected.Tag;
      fExcecao.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -7) or
     (tvMetadados.Selected.Tag = 7) then
  begin
    if not Assigned(fFuncao) then
    begin
      fFuncao := TfFuncao.Create(Application);
      fFuncao.Transparency := True;
      fFuncao.ParentTabControl := TabControlTDI;
      fFuncao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 7) then
        fFuncao.Metadado := tvMetadados.Selected.Text
      else
        fFuncao.Metadado := '';

      fFuncao.NovaTela := True;
      fFuncao.Tag := tvMetadados.Selected.Tag;
      fFuncao.Show;
    end
    else
    begin
      fFuncao.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 7) then
        fFuncao.Metadado := tvMetadados.Selected.Text
      else
        fFuncao.Metadado := '';

      fFuncao.NovaTela := False;
      fFuncao.Tag := tvMetadados.Selected.Tag;
      fFuncao.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -8) or
     (tvMetadados.Selected.Tag = 8) then
  begin
    if not Assigned(fDominio) then
    begin
      fDominio := TfDominio.Create(Application);
      fDominio.Transparency := True;
      fDominio.ParentTabControl := TabControlTDI;
      fDominio.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 8) then
        fDominio.Metadado := tvMetadados.Selected.Text
      else
        fDominio.Metadado := '';

      fDominio.NovaTela := True;
      fDominio.Tag := tvMetadados.Selected.Tag;
      fDominio.Show;
    end
    else
    begin
      fDominio.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 8) then
        fDominio.Metadado := tvMetadados.Selected.Text
      else
        fDominio.Metadado := '';

      fDominio.NovaTela := False;
      fDominio.Tag := tvMetadados.Selected.Tag;
      fDominio.FormShow(Self);
    end;
  end;

  if (tvMetadados.Selected.Tag = -9) or
     (tvMetadados.Selected.Tag = 9) then
  begin
    if not Assigned(fPapel) then
    begin
      fPapel := TfPapel.Create(Application);
      fPapel.Transparency := True;
      fPapel.ParentTabControl := TabControlTDI;
      fPapel.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 9) then
        fPapel.Metadado := tvMetadados.Selected.Text
      else
        fPapel.Metadado := '';

      fPapel.NovaTela := True;
      fPapel.Tag := tvMetadados.Selected.Tag;
      fPapel.Show;
    end
    else
    begin
      fPapel.Alias := Self.Alias;

      if (tvMetadados.Selected.Tag = 9) then
        fPapel.Metadado := tvMetadados.Selected.Text
      else
        fPapel.Metadado := '';

      fPapel.NovaTela := False;
      fPapel.Tag := tvMetadados.Selected.Tag;
      fPapel.FormShow(Self);
    end;
  end;
end;

{********************************************************************}
{ Action List                                                        }
{ Banco de Dados                                                     }
{********************************************************************}

procedure TfMain.acCriarBancoExecute(Sender: TObject);
begin
  try
    fCriarBanco := TfCriarBanco.Create(Application);
    fCriarBanco.ShowModal;
  finally
    fCriarBanco.Free;
    RecuperaBancos;
  end;
end;

procedure TfMain.acRegistrarBancoExecute(Sender: TObject);
begin
  try
    fRegistrarBanco := TfRegistrarBanco.Create(Application);
    fRegistrarBanco.ShowModal;
  finally
    fRegistrarBanco.Free;
    RecuperaBancos;
  end;
end;

procedure TfMain.acGerenciarUsuarioExecute(Sender: TObject);
begin
  try
    fGerenciarUsuario := TfGerenciarUsuario.Create(Application);
    fGerenciarUsuario.Alias := Self.Alias;
    fGerenciarUsuario.ShowModal;
  finally
    fGerenciarUsuario.Free;
  end;
end;

procedure TfMain.acHeaderExecute(Sender: TObject);
begin
  try
    fHeader := TfHeader.Create(Application);
    fHeader.fdm := Self.fdm;
    fHeader.Banco := Self.Banco;
    fHeader.ShowModal;
  finally
    fHeader.Free;
  end;
end;

procedure TfMain.acFecharBancoExecute(Sender: TObject);
begin
  tvMetadados.Clear;
  Alias := '';
  fdm.FDConnection.Connected := False;
  TabControl.ActiveTab := tabBancos;
  HabilitaMenu;
end;

{********************************************************************}
{ Action List                                                        }
{ Metadados                                                          }
{********************************************************************}

procedure TfMain.acCriarDominioExecute(Sender: TObject);
begin
  try
    fCriarDominio := TfCriarDominio.Create(Application);
    fCriarDominio.fdm := Self.fdm;
    fCriarDominio.StyleBook := Self.StyleBook;
    fCriarDominio.ShowModal;
  finally
    fCriarDominio.Free;
  end;
end;

procedure TfMain.acCriarTabelaExecute(Sender: TObject);
begin
  try
    fCriarTabela := TfCriarTabela.Create(Application);
    fCriarTabela.fdm := Self.fdm;
    fCriarTabela.StyleBook := Self.StyleBook;
    fCriarTabela.ShowModal;
  finally
    fCriarTabela.Free;
  end;
end;

procedure TfMain.acCriarTabela2Execute(Sender: TObject);
begin
  try
    fCriarTabela2 := TfCriarTabela2.Create(Application);
    fCriarTabela2.fdm := Self.fdm;
    fCriarTabela2.StyleBook := Self.StyleBook;
    fCriarTabela2.ShowModal;
  finally
    fCriarTabela2.Free;
  end;
end;

procedure TfMain.acCriarVisaoExecute(Sender: TObject);
begin
  try
    fCriarVisao := TfCriarVisao.Create(Application);
    fCriarVisao.fdm := Self.fdm;
    fCriarVisao.StyleBook := Self.StyleBook;
    fCriarVisao.ShowModal;
  finally
    fCriarVisao.Free;
  end;
end;

procedure TfMain.acCriarProcedimentoExecute(Sender: TObject);
begin
  try
    fCriarProcedimento := TfCriarProcedimento.Create(Application);
    fCriarProcedimento.fdm := Self.fdm;
    fCriarProcedimento.StyleBook := Self.StyleBook;
    fCriarProcedimento.ShowModal;
  finally
    fCriarProcedimento.Free;
  end;
end;

procedure TfMain.acCriarGeradorExecute(Sender: TObject);
begin
  try
    fCriarGerador := TfCriarGerador.Create(Application);
    fCriarGerador.fdm := Self.fdm;
    fCriarGerador.StyleBook := Self.StyleBook;
    fCriarGerador.ShowModal;
  finally
    fCriarGerador.Free;
  end;
end;

procedure TfMain.acCriarGatilhoExecute(Sender: TObject);
begin
  try
    fCriarGatilho := TfCriarGatilho.Create(Application);
    fCriarGatilho.fdm := Self.fdm;
    fCriarGatilho.StyleBook := Self.StyleBook;
    fCriarGatilho.ShowModal;
  finally
    fCriarGatilho.Free;
  end;
end;

procedure TfMain.acCriarExcecaoExecute(Sender: TObject);
begin
  try
    fCriarExcecao := TfCriarExcecao.Create(Application);
    fCriarExcecao.fdm := Self.fdm;
    fCriarExcecao.StyleBook := Self.StyleBook;
    fCriarExcecao.ShowModal;
  finally
    fCriarExcecao.Free;
  end;
end;

procedure TfMain.acCriarFuncaoExecute(Sender: TObject);
begin
  try
    fCriarFuncao := TfCriarFuncao.Create(Application);
    fCriarFuncao.fdm := Self.fdm;
    fCriarFuncao.StyleBook := Self.StyleBook;
    fCriarFuncao.ShowModal;
  finally
    fCriarFuncao.Free;
  end;
end;

procedure TfMain.acCriarPapelExecute(Sender: TObject);
begin
  try
    fCriarPapel := TfCriarPapel.Create(Application);
    fCriarPapel.fdm := Self.fdm;
    fCriarPapel.StyleBook := Self.StyleBook;
    fCriarPapel.ShowModal;
  finally
    fCriarPapel.Free;
  end;
end;

{********************************************************************}
{ Action List                                                        }
{ Ferramentas                                                        }
{********************************************************************}

procedure TfMain.acEditorSQLExecute(Sender: TObject);
begin
  try
    fEditorSQL := TfEditorSQL.Create(Application);
    fEditorSQL.Alias := Self.Alias;
    fEditorSQL.StyleBook := Self.StyleBook;
    fEditorSQL.ShowModal;
  finally
    fEditorSQL.Free;
  end;
end;

procedure TfMain.acEditorScriptExecute(Sender: TObject);
begin
  try
    fEditorScript := TfEditorScript.Create(Application);
    fEditorScript.Alias := Self.Alias;
    fEditorScript.StyleBook := Self.StyleBook;
    fEditorScript.ShowModal;
  finally
    fEditorScript.Free;
  end;
end;

procedure TfMain.acBackupExecute(Sender: TObject);
begin
  try
    fBackup := TfBackup.Create(Application);
    fBackup.StyleBook := Self.StyleBook;
    fBackup.ShowModal;
  finally
    fBackup.Free;
  end;
end;

procedure TfMain.acRestoreExecute(Sender: TObject);
begin
  try
    fRestore := TfRestore.Create(Application);
    fRestore.StyleBook := Self.StyleBook;
    fRestore.ShowModal;
  finally
    fRestore.Free;
  end;
end;

procedure TfMain.acEstatisticaExecute(Sender: TObject);
begin
  try
    fEstatistica := TfEstatistica.Create(Application);
    fEstatistica.fdm := Self.fdm;
    fEstatistica.Banco := Self.Banco;
    fEstatistica.StyleBook := Self.StyleBook;
    fEstatistica.ShowModal;
  finally
    fEstatistica.Free;
  end;
end;

{********************************************************************}
{ Action List                                                        }
{ Sistema                                                            }
{********************************************************************}

procedure TfMain.acEstilo0Execute(Sender: TObject);
begin
  Self.StyleBook := StyleBook0;
  mc_GravaArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '0');
end;

procedure TfMain.acEstilo1Execute(Sender: TObject);
begin
  Self.StyleBook := StyleBook1;
  mc_GravaArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '1');
end;

procedure TfMain.acEstilo2Execute(Sender: TObject);
begin
  Self.StyleBook := StyleBook2;
  mc_GravaArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '2');
end;

procedure TfMain.acEstilo3Execute(Sender: TObject);
begin
  Self.StyleBook := StyleBook3;
  mc_GravaArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '3');
end;

procedure TfMain.acEstilo4Execute(Sender: TObject);
begin
  Self.StyleBook := StyleBook4;
  mc_GravaArquivoCfg(mc_GetArquivoCfg, 'Interface', 'Estilo', '4');
end;

end.

