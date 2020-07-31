unit uCriarBanco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, uDAC,
  FireDAC.Comp.Client, System.IniFiles;

type
  TfCriarBanco = class(TfxForm)
    pnlMensagem: TPanel;
    btnCriar: TButton;
    pnlEdicao: TPanel;
    lbBanco: TLabel;
    edBanco: TEdit;
    btnNome: TEditButton;
    lbCharSet: TLabel;
    cbCharSet: TComboBox;
    ListBoxItem7: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    lbDialeto: TLabel;
    cbDialeto: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    lbPagina: TLabel;
    cbPagina: TComboBox;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    Label11: TLabel;
    edBiblioteca: TEdit;
    btnBiblioteca: TEditButton;
    lbMensagem: TLabel;
    procedure btnNomeClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBibliotecaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    procedure GravaArquivoRegistro;
  public
    { Public declarations }
  end;

var
  fCriarBanco: TfCriarBanco;

implementation

{$R *.fmx}

uses
  uxFuncs;

procedure TfCriarBanco.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Bancos';
  fdm := TfDAC.Create(Self);
  edBiblioteca.Text := fdm.GetDefaultLibrary;
end;

procedure TfCriarBanco.FormShow(Sender: TObject);
begin
  inherited;
//
end;

procedure TfCriarBanco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fdm.Free;
  fCriarBanco.Release;
  fCriarBanco := nil;
end;

procedure TfCriarBanco.btnNomeClick(Sender: TObject);
var
  pasta: string;
begin
  SelectDirectory('Selecione a pasta',
    ExtractFilePath(ParamStr(0)),
    pasta);

  if pasta <> '' then
    edBanco.Text := pasta + '\NovoBanco.fdb';
end;

procedure TfCriarBanco.btnBibliotecaClick(Sender: TObject);
var
  pasta: string;
begin
  SelectDirectory('Selecione a pasta',
    ExtractFilePath(ParamStr(0)),
    pasta);

  if pasta <> '' then
    edBiblioteca.Text := pasta + '\fbclient.dll';
end;

procedure TfCriarBanco.btnCriarClick(Sender: TObject);
var
  pathBanco: string;
begin
  if Trim(edBanco.Text) = '' then
  begin
    ShowMessage('Forneça o nome do banco!');
    edBanco.SetFocus;
    Exit;
  end;

  if FileExists(edBanco.Text) then
  begin
    ShowMessage('Banco informado já existe!');
    edBanco.SetFocus;
    Exit;
  end;

  pathBanco := ExtractFilePath(edBanco.Text);

  if not DirectoryExists(pathBanco) then
    ForceDirectories(pathBanco);

  if Trim(edBiblioteca.Text) = '' then
  begin
    edBiblioteca.Text := fdm.GetDefaultLibrary;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      Add('SET SQL DIALECT ' +
           cbDialeto.Items.Strings[cbDialeto.ItemIndex] + ';');
      Add('SET CLIENTLIB ' + QuotedStr(edBiblioteca.Text) + ';');
      Add('CREATE DATABASE ' + QuotedStr(edBanco.Text));
      Add('USER ' + uDAC.FB_USER_NAME);
      Add('PASSWORD ' + uDAC.FB_PASSWORD);
      Add('PAGE_SIZE ' + cbPagina.Items.Strings[cbPagina.ItemIndex]);
      Add('DEFAULT CHARACTER SET ' +
        cbCharSet.Items.Strings[cbCharSet.ItemIndex] + ';');
    end;
    ValidateAll;
    ExecuteAll;
    if TotalErrors > 0 then
    begin
      fdm.RollbackUpdateTransaction;
      lbMensagem.Text := 'Erro na criação do banco!';
    end
    else
    begin
      fdm.CommitUpdateTransaction;
      GravaArquivoRegistro;
      lbMensagem.Text := 'Banco criado!';
    end;
  end;
end;

procedure TfCriarBanco.GravaArquivoRegistro;
var
  S, alias: string;
  FileName: TIniFile;
begin
// Define apelido do banco
  alias := ExtractFileName(edBanco.Text);

  if Pos('.', alias) > 0 then
    alias := mc_GetPiece(alias, 1, '.');

  alias := AnsiUpperCase(alias);

// Monta linha para o arquivo de configuração
  S := alias + '#'
     + 'localhost#'
     + 'Local#'
     + Trim(edBanco.Text) + '#'
     + Trim(cbCharSet.Items.Strings[cbDialeto.ItemIndex]) + '#'
     + FB_USER_NAME + '#'
     + FB_PASSWORD + '#'
     + '#'
     + '3050#'
     + Trim(cbDialeto.Items.Strings[cbDialeto.ItemIndex]) + '#'
     + Trim(edBiblioteca.Text) + '#';

// Grava arquivo de configuração
  FileName := TIniFile.Create(mc_GetArquivoCfg);
  FileName.WriteString('Databases', alias, S);
  FileName.Free;
end;

end.
