unit uCriarProcedimento;

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
  TfCriarProcedimento = class(TfxForm)
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
  fCriarProcedimento: TfCriarProcedimento;

implementation

{$R *.fmx}

procedure TfCriarProcedimento.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Criar Procedimentos';
  TabControl.ActiveTab := tabEdicao;
end;

procedure TfCriarProcedimento.FormShow(Sender: TObject);
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

procedure TfCriarProcedimento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fCriarProcedimento.Release;
  fCriarProcedimento := nil;
end;

procedure TfCriarProcedimento.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfCriarProcedimento.btnCriarClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  edMetadado.Enabled := True;
  MemoMetadado.Enabled := True;
  MemoMetadado.Lines.Clear;
  edMetadado.SetFocus;
end;

procedure TfCriarProcedimento.btnEliminarClick(Sender: TObject);
var
  ssql: string;
  metadado: string;
begin
  if cbMetadados.Count = 0 then Exit;
  metadado := cbMetadados.Selected.Text;

  if Self.Confirma(
      'Eliminar o procedimento ' + metadado + '?', 'N') = False then
    Exit;

  ssql := 'drop procedure ' + metadado + ';';
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.Lines.Add(ssql);
  ExecutaScript;
end;

procedure TfCriarProcedimento.RecuperaMetadados;
begin
  fdm.GetProcedures(nil, cbMetadados);
end;

procedure TfCriarProcedimento.btnEditarClick(Sender: TObject);
begin
  if MemoMetadado.Lines.Count > 0 then Exit;
  edMetadado.Text := Trim(AnsiUpperCase(edMetadado.Text));

  if edMetadado.Text = '' then
  begin
    ShowMessage('Informe o nome do procedimento!');
    edMetadado.SetFocus;
    Exit;
  end;

  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Add('SET TERM ^ ; ');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('CREATE PROCEDURE ' + edMetadado.Text);
  MemoMetadado.Lines.Add('(');
  MemoMetadado.Lines.Add('/* Parâmetros de Entrada */');
  MemoMetadado.Lines.Add('<NomeParm1> <Tipo> <Character Set>,');
  MemoMetadado.Lines.Add('<NomeParm2> <Tipo> <Character Set>');
  MemoMetadado.Lines.Add(')');
  MemoMetadado.Lines.Add('RETURNS');
  MemoMetadado.Lines.Add('(');
  MemoMetadado.Lines.Add('/* Parâmetros de Saída */');
  MemoMetadado.Lines.Add('<NomeParm1> <Tipo> <Character Set>,');
  MemoMetadado.Lines.Add('<NomeParm2> <Tipo> <Character Set>');
  MemoMetadado.Lines.Add(')');
  MemoMetadado.Lines.Add('AS');
  MemoMetadado.Lines.Add('/* Declaração de Varíaveis */');
  MemoMetadado.Lines.Add('DECLARE VARIABLE <NomeVar1> <Character Set>;');
  MemoMetadado.Lines.Add('DECLARE VARIABLE <NomeVar2> <Character Set>;');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('BEGIN');
  MemoMetadado.Lines.Add('/* Código do Procedimento */');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('END');
  MemoMetadado.Lines.Add('^');
  MemoMetadado.Lines.Add('');
  MemoMetadado.Lines.Add('SET TERM ; ^ ');
  MemoMetadado.SetFocus;
end;

procedure TfCriarProcedimento.btnLimparClick(Sender: TObject);
begin
  TabControl.ActiveTab := tabEdicao;
  MemoMetadado.Lines.Clear;
  MemoMetadado.SetFocus;
end;

procedure TfCriarProcedimento.btnSalvarClick(Sender: TObject);
begin
  ExecutaScript;
end;

procedure TfCriarProcedimento.ExecutaScript;
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

procedure TfCriarProcedimento.cbMetadadosClosePopup(Sender: TObject);
begin
  ShowDDL(cbMetadados.Selected.Text);
end;

procedure TfCriarProcedimento.ShowDDL(AMetadado: string);
begin
  if AMetadado <> '' then
  begin
    MemoDDL.Lines.Clear;
    MemoDDL.Lines.AddStrings(fdm.GetProcedureDDL(AMetadado));
  end;
end;

end.
