unit uCriarFuncao;

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
  TfCriarFuncao = class(TfxForm)
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
    TabControl: TTabControl;
    tabEdicao: TTabItem;
    tabDDL: TTabItem;
    MemoMetadado: TMemo;
    pnlMensagem: TPanel;
    lbMensagem: TLabel;
    MemoDDL: TMemo;
    btnSair: TButton;
    btnRegistrar: TButton;
    btnEliminar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
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
  fCriarFuncao: TfCriarFuncao;

implementation

{$R *.fmx}

procedure TfCriarFuncao.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Registrar Funções';
  TabControl.ActiveTab := tabEdicao;
end;

procedure TfCriarFuncao.FormShow(Sender: TObject);
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

procedure TfCriarFuncao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fCriarFuncao.Release;
  fCriarFuncao := nil;
end;

procedure TfCriarFuncao.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarFuncao.btnRegistrarClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  edMetadado.Enabled := True;
  MemoMetadado.Enabled := True;
  MemoMetadado.Lines.Clear;
  edMetadado.SetFocus;
end;

procedure TfCriarFuncao.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbMetadados.Count = 0 then Exit;
  metadado := cbMetadados.Selected.Text;

  if (AnsiUpperCase(metadado) = 'RDB$SET_CONTEXT') or
     (AnsiUpperCase(metadado) = 'RDB$GET_CONTEXT') then
  begin
    ShowMessage('Metadado ' + metadado + ' não pode ser eliminado!');
    Exit;
  end;

  if Self.Confirma(
      'Eliminar a função ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop external function ' + metadado + ';';
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.Lines.Add(ssql);
  ExecutaScript;
end;

procedure TfCriarFuncao.RecuperaMetadados;
begin
  fdm.GetFunctions(nil, cbMetadados);
end;

procedure TfCriarFuncao.btnEditarClick(Sender: TObject);
begin
  if MemoMetadado.Lines.Count > 0 then Exit;

  if edMetadado.Text = '' then
  begin
    ShowMessage('Informe o nome da função!');
    edMetadado.SetFocus;
    Exit;
  end;

  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Add('DECLARE external FUNCTION ' + edMetadado.Text);
  MemoMetadado.Lines.Add('<Parametro 1>,');
  MemoMetadado.Lines.Add('<Parametro 2>,');
  MemoMetadado.Lines.Add('<Parametro 3>');
  MemoMetadado.Lines.Add('RETURNS <Retorno> BY VALUE | FREE_IT');
  MemoMetadado.Lines.Add('ENTRY_POINT <EntryName>');
  MemoMetadado.Lines.Add('MODULE_NAME <ModuleName>');
  MemoMetadado.Lines.Add(';');
  MemoMetadado.SetFocus;
end;

procedure TfCriarFuncao.btnLimparClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.SetFocus;
end;

procedure TfCriarFuncao.btnSalvarClick(Sender: TObject);
begin
  ExecutaScript;
end;

procedure TfCriarFuncao.ExecutaScript;
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

procedure TfCriarFuncao.cbMetadadosClosePopup(Sender: TObject);
begin
  ShowDDL(cbMetadados.Selected.Text);
end;

procedure TfCriarFuncao.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.AddStrings(fdm.GetFunctionDDL(AMetadado));
  end;
end;

end.
