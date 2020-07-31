unit uBackup;

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
  TfBackup = class(TfxForm)
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
    chkIgnoreChecksums: TCheckBox;
    chkIgnoreLimbo: TCheckBox;
    chkMetadataOnly: TCheckBox;
    chkNoGarbageCollection: TCheckBox;
    chkNonTransportable: TCheckBox;
    chkConvertExtTables: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    FDIBBackup: TFDIBBackup;
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
    procedure FDIBBackupProgress(ASender: TFDPhysDriverService;
      const AMessage: string);
    procedure edBackupEnter(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutaBackup;
  public
    { Public declarations }
  end;

var
  fBackup: TfBackup;

implementation

{$R *.fmx}

uses
  uxFuncs;

procedure TfBackup.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Backup';
end;

procedure TfBackup.FormShow(Sender: TObject);
begin
  inherited;
  edBanco.SetFocus;
end;

procedure TfBackup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fBackup.Release;
  fBackup := nil;
end;

// Botões de comando

procedure TfBackup.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfBackup.btnExecutarClick(Sender: TObject);
begin
  ActiveControl := nil;

  if Trim(edBanco.Text) = '' then
  begin
    ShowMessage('Informe o arquivo de dados!');
    edBanco.SetFocus;
    Exit;
  end;

  if Trim(edBackup.Text) = '' then
  begin
    ShowMessage('Informe o arquivo de backup!');
    edBanco.SetFocus;
    Exit;
  end;

  if Trim(edServidor.Text) = '' then
  begin
    edServidor.Text := 'localhost';
  end;

  ExecutaBackup;
end;

procedure TfBackup.ExecutaBackup;
var
  Opcoes: TIBBackupOptions;
  Protocolo: TIBProtocol;
begin
  Opcoes := [];

  if chkIgnoreChecksums.IsChecked = True then
    Opcoes := Opcoes + [boIgnoreChecksum];

  if chkIgnoreLimbo.IsChecked = True then
    Opcoes := Opcoes + [boIgnoreLimbo];

  if chkMetadataOnly.IsChecked = True then
    Opcoes := Opcoes + [boMetadataOnly];

  if chkNoGarbageCollection.IsChecked = True then
    Opcoes := Opcoes + [boNoGarbageCollect];

  if chkNonTransportable.IsChecked = True then
    Opcoes := Opcoes + [boNonTransportable];

  if chkConvertExtTables.IsChecked = True then
    Opcoes := Opcoes + [boConvert];

  if cbProtocolo.Selected.Text = 'TCPIP' then
    Protocolo := ipTCPIP
  else
  if cbProtocolo.Selected.Text = 'Local' then
    Protocolo := ipLocal
  else
    Protocolo := ipLocal;

  lbMensagem.Text := 'Backup iniciado em ' + DateToStr(Date) + '!';
  MemoLog.Lines.Clear;
  MemoLog.Lines.Add(lbMensagem.Text);
  MemoLog.Lines.Add(edBackup.Text);
  MemoLog.Lines.Add('');
  Application.ProcessMessages;

  FDIBBackup.UserName := uDAC.FB_USER_NAME;
  FDIBBackup.Password := uDAC.FB_PASSWORD;
  FDIBBackup.Database := edBanco.Text;
  FDIBBackup.BackupFiles.Clear;
  FDIBBackup.BackupFiles.Add(edBackup.Text);
  FDIBBackup.Verbose := True;
  FDIBBackup.Host := edServidor.Text + '/' + edPorta.Text;
  FDIBBackup.Protocol := Protocolo;
  FDIBBackup.Options := Opcoes;

  try
    FDIBBackup.Backup;
  finally
    lbMensagem.Text := 'Backup concluído em ' + DateToStr(Date) + '!';
    MemoLog.Lines.Add(lbMensagem.Text);
  end;
end;

procedure TfBackup.FDIBBackupProgress(ASender: TFDPhysDriverService;
  const AMessage: string);
begin
  MemoLog.Lines.Add(AMessage);
  Application.ProcessMessages;
end;

procedure TfBackup.btnLimparClick(Sender: TObject);
begin
  MemoLog.Lines.Clear;
end;

procedure TfBackup.btnSalvarClick(Sender: TObject);
var
  sd: TOpenDialog;
begin
  sd := TOpenDialog.Create(Self);
  sd.InitialDir := ExtractFilePath(ParamStr(0));
  sd.Filter :=
    'Todos (*.*)|*.*|Backups (txt)|*.txt';
  sd.DefaultExt := 'txt';
  sd.FileName := 'Backup.txt';

  if sd.Execute then
  begin
    MemoLog.Lines.SaveToFile(sd.FileName);
  end;

  sd.Free;
end;

// Eventos

procedure TfBackup.btnBancoClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(Self);
  od.InitialDir := ExtractFilePath(ParamStr(0));
  od.Filter :=
    'Todos (*.*)|*.*|Bancos Firebird (fdb)|*.fdb';

  if od.Execute then
  begin
    edBanco.Text := od.FileName;
  end;

  od.Free;
end;

procedure TfBackup.btnBackupClick(Sender: TObject);
var
  pasta: string;
begin
  SelectDirectory('Selecione a pasta',
    ExtractFilePath(ParamStr(0)),
    pasta);
end;

procedure TfBackup.edBackupEnter(Sender: TObject);
begin
  if edBackup.Text = '' then
    edBackup.Text := ChangeFileExt(edBanco.Text, '.fbk');
end;

end.
