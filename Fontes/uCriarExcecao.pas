unit uCriarExcecao;

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
  FireDAC.Phys.Intf;

type
  TfCriarExcecao = class(TfxForm)
    pnlPrincipal: TPanel;
    pnlEdicao: TPanel;
    btnEditar: TButton;
    btnLimpar: TButton;
    btnSalvar: TButton;
    Label4: TLabel;
    edMetadado: TEdit;
    Label2: TLabel;
    cbMetadados: TComboBox;
    ToolBar: TToolBar;
    Label1: TLabel;
    edMensagem: TEdit;
    TabControl: TTabControl;
    tabEdicao: TTabItem;
    tabDDL: TTabItem;
    MemoMetadado: TMemo;
    pnlMensagem: TPanel;
    lbMensagem: TLabel;
    MemoDDL: TMemo;
    btnSair: TButton;
    btnCriar: TButton;
    btnEliminar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure cbMetadadosClosePopup(Sender: TObject);
  private
    { Private declarations }
    procedure RecuperaMetadados;
    procedure ShowDDL(AMetadado: string);
    procedure ExecutaScript;
  protected
    { Protected declarations }
  public
    { Public declarations }
    fdm: TfDAC;
  end;

var
  fCriarExcecao: TfCriarExcecao;

implementation

{$R *.fmx}

procedure TfCriarExcecao.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Exceções';
  TabControl.ActiveTab := tabEdicao;
end;

procedure TfCriarExcecao.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.FDConnection.Connected = True then
  begin
    RecuperaMetadados;
    if cbMetadados.Count > 0 then
    begin
      cbMetadados.ItemIndex := 0;
      ShowDDL(cbMetadados.Selected.Text);
    end;
  end;
end;

procedure TfCriarExcecao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fCriarExcecao.Release;
  fCriarExcecao := nil;
end;

procedure TfCriarExcecao.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarExcecao.btnCriarClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  edMetadado.Enabled := True;
  edMensagem.Enabled := True;
  MemoMetadado.Enabled := True;
  MemoMetadado.Lines.Clear;
  edMetadado.SetFocus;
end;

procedure TfCriarExcecao.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbMetadados.Count = 0 then Exit;
  metadado := cbMetadados.Selected.Text;

  if Self.Confirma(
      'Eliminar a exceção ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop exception ' + metadado + ';';
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.Lines.Add(ssql);
  ExecutaScript;
end;

procedure TfCriarExcecao.RecuperaMetadados;
begin
  fdm.GetExceptions(nil, cbMetadados);
end;

procedure TfCriarExcecao.btnEditarClick(Sender: TObject);
begin
  if MemoMetadado.Lines.Count > 0 then Exit;
  edMetadado.Text := Trim(AnsiUpperCase(edMetadado.Text));

  if edMetadado.Text = '' then
  begin
    ShowMessage('Informe o nome da exceção!');
    edMetadado.SetFocus;
    Exit;
  end;

  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Add('CREATE EXCEPTION ' + edMetadado.Text + ' ' +
    QuotedStr(edMensagem.Text) + ';');
  MemoMetadado.SetFocus;
end;

procedure TfCriarExcecao.btnLimparClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.SetFocus;
end;

procedure TfCriarExcecao.btnSalvarClick(Sender: TObject);
begin
  ExecutaScript;
  edMensagem.Text := '';
end;

procedure TfCriarExcecao.ExecutaScript;
begin
  if MemoMetadado.Lines.Count = 0 then
  begin
    lbMensagem.Text := 'Sem instrução para executar!';
    Exit;
  end;

  fdm.StartUpdateTransaction;
  with fdm.FDScript do begin
    SQLScripts.Clear;
    SQLScripts.Add;
    with SQLScripts[0].SQL do begin
      AddStrings(MemoMetadado.Lines);
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

      if edMetadado.Text <> '' then
      begin
        cbMetadados.ItemIndex :=
          cbMetadados.Items.IndexOf(edMetadado.Text);
      end
      else
      begin
        if cbMetadados.Count > 0 then
          cbMetadados.ItemIndex := 0;
      end;

      ShowDDL(edMetadado.Text);
      edMetadado.Text := '';
      edMetadado.Enabled := False;
      MemoMetadado.Enabled := False;
      lbMensagem.Text := 'Instrução executada!';
    end;
  end;
end;

procedure TfCriarExcecao.cbMetadadosClosePopup(Sender: TObject);
begin
  ShowDDL(cbMetadados.Selected.Text);
end;

procedure TfCriarExcecao.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.Add(fdm.GetExceptionDDL(AMetadado));
  end;
end;

end.
