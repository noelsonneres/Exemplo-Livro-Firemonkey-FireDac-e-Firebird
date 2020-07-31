unit uCriarGatilho;

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
  TfCriarGatilho = class(TfxForm)
    pnlPrincipal: TPanel;
    pnlEdicao: TPanel;
    ToolBar: TToolBar;
    Label2: TLabel;
    cbTabelas: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    btnEditar: TButton;
    btnLimpar: TButton;
    btnSalvar: TButton;
    SpinBoxPosicao: TSpinBox;
    cbAcao: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    Label4: TLabel;
    edMetadado: TEdit;
    lbNome: TLabel;
    cbMetadados: TComboBox;
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
    procedure RecuperaTabelas;
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
  fCriarGatilho: TfCriarGatilho;

implementation

{$R *.fmx}

procedure TfCriarGatilho.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Gatilhos';
  TabControl.ActiveTab := tabEdicao;
end;

procedure TfCriarGatilho.FormShow(Sender: TObject);
begin
  inherited;
  if fdm.FDConnection.Connected = True then
  begin
    RecuperaTabelas;
    if cbTabelas.Count > 0 then
      cbTabelas.ItemIndex := 0;
    RecuperaMetadados;
    if cbMetadados.Count > 0 then
    begin
      cbMetadados.ItemIndex := 0;
      ShowDDL(cbMetadados.Selected.Text);
    end;
  end;
end;

procedure TfCriarGatilho.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fCriarGatilho.Release;
  fCriarGatilho := nil;
end;

procedure TfCriarGatilho.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarGatilho.btnCriarClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  edMetadado.Enabled := True;
  MemoMetadado.Enabled := True;
  MemoMetadado.Lines.Clear;
  edMetadado.SetFocus;
end;

procedure TfCriarGatilho.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbMetadados.Count = 0 then Exit;
  metadado := cbMetadados.Selected.Text;

  if Self.Confirma(
      'Eliminar o gatilho ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop trigger ' + metadado + ';';
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.Lines.Add(ssql);
  ExecutaScript;
end;

procedure TfCriarGatilho.RecuperaTabelas;
begin
  fdm.GetTables(cbTabelas, 0);
end;

procedure TfCriarGatilho.RecuperaMetadados;
begin
  fdm.GetTriggers(nil, cbMetadados);
end;

procedure TfCriarGatilho.btnEditarClick(Sender: TObject);
begin
  if MemoMetadado.Lines.Count > 0 then Exit;
  edMetadado.Text := Trim(AnsiUpperCase(edMetadado.Text));

  if edMetadado.Text = '' then
  begin
    ShowMessage('Informe o nome do gatilho!');
    edMetadado.SetFocus;
    Exit;
  end;

  if cbTabelas.Selected.Text = '' then
  begin
    ShowMessage('Não existem tabelas no banco!');
    edMetadado.SetFocus;
    Exit;
  end;

  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Add('SET TERM ^ ; ');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('CREATE TRIGGER ' + edMetadado.Text +
    ' FOR ' + cbTabelas.Items.Strings[cbTabelas.ItemIndex]);
  MemoMetadado.Lines.Add('ACTIVE ' +
    cbAcao.Items.Strings[cbAcao.ItemIndex] +
    ' POSITION ' + SpinBoxPosicao.Text + ' AS');
  MemoMetadado.Lines.Add('BEGIN');
  MemoMetadado.Lines.Add('/* Código do Gatilho */');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('END');
  MemoMetadado.Lines.Add('^');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('SET TERM ; ^ ');
  MemoMetadado.SetFocus;
end;

procedure TfCriarGatilho.btnLimparClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.SetFocus;
end;

procedure TfCriarGatilho.btnSalvarClick(Sender: TObject);
begin
  ExecutaScript;
end;

procedure TfCriarGatilho.ExecutaScript;
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

procedure TfCriarGatilho.cbMetadadosClosePopup(Sender: TObject);
begin
  ShowDDL(cbMetadados.Selected.Text);
end;

procedure TfCriarGatilho.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.Add(fdm.GetTriggerDDL(AMetadado));
  end;
end;

end.
