unit uRestore;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, Data.Bind.Controls, System.Rtti, FMX.Layouts, FMX.Grid, FMX.ListBox,
  Fmx.Bind.Navigator, uDAC, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.Grid, FireDAC.Comp.Client, FMX.Memo, FMX.Edit,
  FMX.Controls.Presentation, FireDAC.Phys.IBWrapper, FireDAC.Stan.Def,
  FireDAC.Phys.IBBase, FireDAC.Stan.Intf, FireDAC.Phys;

type
  TfRestore = class(TfxForm)
    ToolBar: TToolBar;
    pnlNavegador: TPanel;
    pnlEdicao: TPanel;
    pnlLog: TPanel;
    MemoLog: TMemo;
    lbBanco: TLabel;
    edBanco: TEdit;
    btnBanco: TEditButton;
    Label1: TLabel;
    edBackup: TEdit;
    btnBackup: TEditButton;
    edServidor: TEdit;
    edPorta: TEdit;
    cbProtocolo: TComboBox;
    chkNoShadow: TCheckBox;
    chkOneRelationAtATime: TCheckBox;
    chkDeactivateIndexes: TCheckBox;
    chkUseAllSpace: TCheckBox;
    chkCreateNewDB: TCheckBox;
    chkNoValidityCheck: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    FDIBRestore: TFDIBRestore;
    Label5: TLabel;
    cbPagina: TComboBox;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    btnSair: TButton;
    btnExecutar: TButton;
    btnLimpar: TButton;
    btnSalvar: TButton;
    lbMensagem: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnBancoClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure FDIBRestoreProgress(ASender: TFDPhysDriverService;
      const AMessage: string);
    procedure edBancoEnter(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutaRestore;
  public
    { Public declarations }
  end;

var
  fRestore: TfRestore;

implementation

{$R *.fmx}

procedure TfRestore.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Restore';
end;

procedure TfRestore.FormShow(Sender: TObject);
begin
  inherited;
  edBackup.SetFocus;
end;

procedure TfRestore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fRestore.Release;
  fRestore := nil;
end;

// Botões de comando

procedure TfRestore.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfRestore.btnExecutarClick(Sender: TObject);
begin
  ActiveControl := nil;

  if Trim(edBackup.Text) = '' then
  begin
    ShowMessage('Informe o arquivo de backup!');
    edBanco.SetFocus;
    Exit;
  end;

  if Trim(edBanco.Text) = '' then
  begin
    ShowMessage('Informe o arquivo de dados!');
    edBanco.SetFocus;
    Exit;
  end;

  if Trim(edServidor.Text) = '' then
  begin
    edServidor.Text := 'localhost';
  end;

  ExecutaRestore;
end;

procedure TfRestore.ExecutaRestore;
var
  Opcoes: TIBRestoreOptions;
  Protocolo: TIBProtocol;
begin
  Opcoes := [];

  if chkNoShadow.IsChecked = True then
    Opcoes := Opcoes + [roNoShadow];

  if chkOneRelationAtATime.IsChecked = True then
    Opcoes := Opcoes + [roOneAtATime];

  if chkDeactivateIndexes.IsChecked = True then
    Opcoes := Opcoes + [roDeactivateIdx];

  if chkUseAllSpace.IsChecked = True then
    Opcoes := Opcoes + [roUseAllSpace];

  if chkCreateNewDB.IsChecked = True then
    Opcoes := Opcoes + [roCreate];

  if chkNoValidityCheck.IsChecked = True then
    Opcoes := Opcoes + [roNoValidity];

  if cbProtocolo.Selected.Text = 'TCPIP' then
    Protocolo := ipTCPIP
  else
  if cbProtocolo.Selected.Text = 'Local' then
    Protocolo := ipLocal
  else
    Protocolo := ipLocal;

  lbMensagem.Text := 'Restauração iniciada em ' + DateToStr(Date) + '!';
  MemoLog.Lines.Clear;
  MemoLog.Lines.Add(lbMensagem.Text);
  MemoLog.Lines.Add(edBanco.Text);
  MemoLog.Lines.Add('');
  Application.ProcessMessages;

  FDIBRestore.UserName := uDAC.FB_USER_NAME;
  FDIBRestore.Password := uDAC.FB_PASSWORD;
  FDIBRestore.BackupFiles.Clear;
  FDIBRestore.BackupFiles.Add(edBackup.Text);
  FDIBRestore.Database := edBanco.Text;
  FDIBRestore.Verbose := True;
  FDIBRestore.Host := edServidor.Text + '/' + edPorta.Text;
  FDIBRestore.Protocol := Protocolo;
  FDIBRestore.Options := Opcoes;
  FDIBRestore.PageSize := StrToInt(cbPagina.Selected.Text);

  try
    FDIBRestore.Restore;
  finally
    lbMensagem.Text := 'Restauração concluída em ' + DateToStr(Date) + '!';
    MemoLog.Lines.Add(lbMensagem.Text);
  end;
end;

procedure TfRestore.FDIBRestoreProgress(ASender: TFDPhysDriverService;
  const AMessage: string);
begin
  MemoLog.Lines.Add(AMessage);
  Application.ProcessMessages;
end;

procedure TfRestore.btnLimparClick(Sender: TObject);
begin
  MemoLog.Lines.Clear;
end;

procedure TfRestore.btnSalvarClick(Sender: TObject);
var
  sd: TOpenDialog;
begin
  sd := TOpenDialog.Create(Self);
  sd.InitialDir := ExtractFilePath(ParamStr(0));
  sd.Filter :=
    'Todos (*.*)|*.*|Restores (txt)|*.txt';
  sd.DefaultExt := 'txt';
  sd.FileName := 'Restore.txt';

  if sd.Execute then
  begin
    MemoLog.Lines.SaveToFile(sd.FileName);
  end;

  sd.Free;
end;

// Eventos

procedure TfRestore.btnBackupClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(Self);
  od.InitialDir := ExtractFilePath(ParamStr(0));
  od.Filter :=
    'Todos (*.*)|*.*|Backups Firebird (fbk)|*.fbk';

  if od.Execute then
  begin
     edBackup.Text := od.FileName;
  end;

  od.Free;
end;

procedure TfRestore.btnBancoClick(Sender: TObject);
var
  pasta: string;
begin
  SelectDirectory('Selecione a pasta',
    ExtractFilePath(ParamStr(0)),
    pasta);
end;

procedure TfRestore.edBancoEnter(Sender: TObject);
begin
  if edBanco.Text = '' then
    edBanco.Text := ExtractFilePath(edBackup.Text) + 'Restore.fdb';
end;

end.
