unit uRegistrarBanco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts,
  System.IniFiles, uDAC;

type
  TfRegistrarBanco = class(TfxForm)
    pnlAcoes: TPanel;
    btnNovo: TButton;
    btnExcluir: TButton;
    btnTestar: TButton;
    btnSalvar: TButton;
    pnlLateral: TPanel;
    Splitter: TSplitter;
    pnlCentral: TPanel;
    ListBox: TListBox;
    grpBanco: TGroupBox;
    grpUsuario: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edAlias: TEdit;
    edServidor: TEdit;
    cbProtocolo: TComboBox;
    edPorta: TEdit;
    edBanco: TEdit;
    cbCharSet: TComboBox;
    cbDialeto: TComboBox;
    btnNome: TEditButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edUsuario: TEdit;
    edSenha: TEdit;
    edPapel: TEdit;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    Label11: TLabel;
    edBiblioteca: TEdit;
    btnBiblioteca: TEditButton;
    procedure btnNomeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnTestarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBibliotecaClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    tsRegistros: TStrings;
    tsAlteracoes: TStrings;

    procedure LimpaCampos;
    procedure LeArquivoRegistros;
    procedure GravaArquivoRegistro;
    function ExcluiItemListBox(AAlias: string): Boolean;
  public
    { Public declarations }
  end;

var
  fRegistrarBanco: TfRegistrarBanco;

implementation

{$R *.fmx}

uses
  uxFuncs;

procedure TfRegistrarBanco.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Registrar Bancos';
  fdm := TfDAC.Create(Self);
end;

procedure TfRegistrarBanco.FormShow(Sender: TObject);
begin
  inherited;
  tsRegistros := TStringList.Create;
  tsAlteracoes := TStringList.Create;
  LimpaCampos;
  LeArquivoRegistros;
end;

procedure TfRegistrarBanco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  tsRegistros.Free;
  tsAlteracoes.Free;
  fRegistrarBanco.Release;
  fRegistrarBanco := nil;
end;

procedure TfRegistrarBanco.LeArquivoRegistros;
var
  List: TListBox;
  FileName: TIniFile;
  S, alias: string;
  I: Integer;
begin
  List := TListBox.Create(Self);
  tsRegistros.Clear;
  ListBox.Items.Clear;

  FileName := TIniFile.Create(mc_GetArquivoCfg);
  FileName.ReadSectionValues('Databases', List.Items);

  for I := 0 to List.Count - 1 do begin
    S := Trim(mc_GetPiece(List.Items[I], 1, '='));
    S := Trim(mc_GetPiece(List.Items[I], 2, '='));
    alias := uxFuncs.mc_GetPiece(s, 1, '#');
    ListBox.Items.Add(alias);
    tsRegistros.Add(S);
  end;

  FileName.Free;
  List.Free;
end;

procedure TfRegistrarBanco.btnNovoClick(Sender: TObject);
begin
  LimpaCampos;
  edAlias.SetFocus;
end;

procedure TfRegistrarBanco.LimpaCampos;
begin
  edAlias.Text := '';
  edServidor.Text := 'localhost';
  cbProtocolo.ItemIndex := cbProtocolo.Items.IndexOf('Local');
  edBanco.Text := '';
  cbCharSet.ItemIndex := cbCharSet.Items.IndexOf('WIN1252');
  edUsuario.Text := '';
  edSenha.Text := '';
  edPapel.Text := '';
  edPorta.Text := '3050';
  cbDialeto.ItemIndex := cbDialeto.Items.IndexOf('3');
  edBiblioteca.Text := fdm.GetDefaultLibrary;
end;

procedure TfRegistrarBanco.btnExcluirClick(Sender: TObject);
begin
  ExcluiItemListBox(edAlias.Text);
  LimpaCampos;
  GravaArquivoRegistro;
end;

function TfRegistrarBanco.ExcluiItemListBox(AAlias: string): Boolean;
var
  I: Integer;
  alias: string;
begin
  Result := True;
  AAlias := Trim(AAlias);
  if AAlias = '' then Exit;

  tsAlteracoes.Clear;

  for I := 0 to tsRegistros.Count - 1 do begin
    alias := mc_GetPiece(tsRegistros.Strings[I], 1, '#');
    if (AnsiUpperCase(alias) <> AnsiUpperCase(AAlias)) then
      tsAlteracoes.Add(tsRegistros.Strings[I]);
  end;

  tsRegistros.Clear;
  ListBox.Clear;

  for I := 0 to tsAlteracoes.Count - 1 do begin
    ListBox.Items.Add(mc_GetPiece(tsAlteracoes.Strings[I], 1, '#'));
    tsRegistros.Add(tsAlteracoes.Strings[I]);
  end;
end;

procedure TfRegistrarBanco.btnTestarClick(Sender: TObject);
begin
  fdm.FDConnection.Connected := False;
  fdm.FDConnection.Params.Clear;
  fdm.FDConnection.DriverName := 'FB';
  fdm.FDConnection.Params.Add('User_Name=' + edUsuario.Text);
  fdm.FDConnection.Params.Add('Password=' + edSenha.Text);
  fdm.FDConnection.Params.Add('Protocol=' +
   cbProtocolo.Items.Strings[cbProtocolo.ItemIndex]);
  fdm.FDConnection.Params.Add('Database=' + edBanco.Text);
  fdm.FDConnection.Params.Add('Server=' + edServidor.Text);
  fdm.FDConnection.Params.Add('SqlDialect=' +
    cbDialeto.Items.Strings[cbDialeto.ItemIndex]);
  fdm.FDConnection.Params.Add('CharacterSet=' +
    cbCharSet.Items.Strings[cbCharSet.ItemIndex]);
  fdm.FDConnection.Params.Add('VendorLibWin32=' + edBiblioteca.Text);

  try
    try
      fdm.FDConnection.Connected := True;
      ShowMessage('Conexão estabelecida!');
    except
      ShowMessage('Erro na conexão!');
    end;
  finally
    fdm.FDConnection.Connected := False;
  end;
end;

procedure TfRegistrarBanco.btnSalvarClick(Sender: TObject);
var
  S: string;
  I: Integer;
  alias: string;
begin
  for I := 0 to ListBox.Items.Count - 1 do begin
    if AnsiUpperCase(ListBox.Items[I]) = AnsiUpperCase(edAlias.Text) then
    begin
      ExcluiItemListBox(edAlias.Text);
      Break;
    end;
  end;

  if Trim(edAlias.Text) = '' then Exit;
  if Trim(edBanco.Text) = '' then Exit;
  if Trim(edUsuario.Text) = '' then Exit;
  if Trim(edSenha.Text) = '' then Exit;

  if Trim(edServidor.Text) = '' then
    edServidor.Text := 'localhost';

  if Trim(edBiblioteca.Text) = '' then
    edBiblioteca.Text := fdm.GetDefaultLibrary;

  alias := AnsiUpperCase(Trim(edAlias.Text));

  S := alias + '#'
     + Trim(edServidor.Text) + '#'
     + Trim(cbProtocolo.Items.Strings[cbProtocolo.ItemIndex]) + '#'
     + Trim(edBanco.Text) + '#'
     + Trim(cbCharSet.Items.Strings[cbCharSet.ItemIndex]) + '#'
     + Trim(edUsuario.Text) + '#'
     + Trim(edSenha.Text) + '#'
     + Trim(edPapel.Text) + '#'
     + Trim(edPorta.Text) + '#'
     + Trim(cbDialeto.Items.Strings[cbDialeto.ItemIndex]) + '#'
     + Trim(edBiblioteca.Text);

  tsRegistros.Add(S);
  ListBox.Clear;

  for I := 0 to tsRegistros.Count - 1 do begin
    ListBox.Items.Add(mc_GetPiece(tsRegistros.Strings[I], 1, '#'));
    tsAlteracoes.Add(tsRegistros.Strings[I]);
  end;

  GravaArquivoRegistro;
end;

procedure TfRegistrarBanco.GravaArquivoRegistro;
var
  S, alias: string;
  I: Integer;
  FileName: TIniFile;
begin
  FileName := TIniFile.Create(mc_GetArquivoCfg);
  FileName.EraseSection('Databases');

  for I := 0 to tsRegistros.Count - 1 do begin
    S := tsRegistros.Strings[I];
    alias := mc_GetPiece(S, 1, '#');
    FileName.WriteString('Databases', alias, S);
  end;

  FileName.Free;
end;

procedure TfRegistrarBanco.ListBoxClick(Sender: TObject);
var
  I: Integer;
  S: string;
  Item: TListBoxItem;
  FileName: TIniFile;
begin
  Item := TListBoxItem.Create(nil);

  for I := 0 to ListBox.Items.Count - 1 do begin
    Item := ListBox.Selected;
    Break;
  end;

  if Item.Text <> '' then
  begin
    FileName := TIniFile.Create(mc_GetArquivoCfg);
    S := FileName.ReadString('Databases', Item.Text, '');
    edAlias.Text := mc_GetPiece(S, 1, '#');
    edServidor.Text := mc_GetPiece(S, 2, '#');
    cbProtocolo.ItemIndex :=
      cbProtocolo.Items.IndexOf(mc_GetPiece(S, 3, '#'));
    edBanco.Text := mc_GetPiece(S, 4, '#');
    cbCharSet.ItemIndex :=
      cbCharSet.Items.IndexOf(mc_GetPiece(S, 5, '#'));
    edUsuario.Text := mc_GetPiece(S, 6, '#');
    edSenha.Text := mc_GetPiece(S, 7, '#');
    edPapel.Text := mc_GetPiece(S, 8, '#');
    edPorta.Text := mc_GetPiece(S, 9, '#');
    cbDialeto.ItemIndex :=
      cbDialeto.Items.IndexOf(mc_GetPiece(S, 10, '#'));
    edBiblioteca.Text := mc_GetPiece(S, 11, '#');
    FileName.Free;
  end;
end;

procedure TfRegistrarBanco.btnNomeClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(Self);
  with od do begin
    InitialDir := ExtractFilePath(ParamStr(0));
    if Execute then
    begin
      edBanco.Text := FileName;
    end;
    Free;
  end;
end;

procedure TfRegistrarBanco.btnBibliotecaClick(Sender: TObject);
var
  pasta: string;
begin
  SelectDirectory('Selecione a pasta',
    ExtractFilePath(ParamStr(0)),
    pasta);
  edBiblioteca.Text := pasta + '\fbclient.dll';
end;

end.
