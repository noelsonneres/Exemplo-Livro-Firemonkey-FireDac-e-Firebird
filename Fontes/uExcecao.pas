unit uExcecao;

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
  TfExcecao = class(TfxForm)
    pnlSuperior: TPanel;
    pnlInferior: TPanel;
    BindNavigator: TBindNavigator;
    BindingsList: TBindingsList;
    cdsExcecoes: TClientDataSet;
    pnlCentral: TPanel;
    Splitter: TSplitter;
    TabControl: TTabControl;
    tabLista: TTabItem;
    grdDados: TGrid;
    tabDDL: TTabItem;
    MemoDDL: TMemo;
    ToolBar: TToolBar;
    cdsExcecoesexception_name: TStringField;
    cdsExcecoesmessage: TStringField;
    lbMetadado: TLabel;
    BindSourceDBDados: TBindSourceDB;
    LinkGridToDataSourceBindSourceDBDados: TLinkGridToDataSource;
    btnSair: TButton;
    btnCriar: TButton;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
    FParentTabControl: TTabControl;
    procedure RecuperaMetadados;
    procedure ShowDDL(DataSet: TDataSet);
  protected
    { Protected declarations }
    TabForm: TTabItem;
    procedure VerificaTabControl;
  public
    { Public declarations }
    Alias: string;
    Metadado: string;
    NovaTela: Boolean;
    Tag: Integer;
    property ParentTabControl: TTabControl
        read FParentTabControl write FParentTabControl;
  end;

var
  fExcecao: TfExcecao;

implementation

{$R *.fmx}

uses uCriarExcecao;

procedure TfExcecao.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Exceções';
  fdm := TfDAC.Create(Self);
  cdsExcecoes.CreateDataSet;
  cdsExcecoes.AfterScroll := ShowDDL;
  Self.GetStatusGrid(grdDados, Self);
end;

procedure TfExcecao.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControl.ActiveTab := tabLista;

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaMetadados;
    cdsExcecoes.Locate('exception_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfExcecao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not cdsExcecoes.IsEmpty then cdsExcecoes.EmptyDataSet;
  Self.SetStatusGrid(grdDados, Self);
  fExcecao.Release;
  fExcecao := nil;
end;

procedure TfExcecao.VerificaTabControl;
var
  I: Integer;
begin
  if NovaTela = False then Exit;
  if not Assigned(ParentTabControl) then Exit;

  if ParentTabControl.TabCount > 0 then
  begin
    for I := 0 to ParentTabControl.TabCount - 1 do begin
      if ParentTabControl.Tabs[I].Name = 'tab' + Self.Name then
      begin
        ParentTabControl.Delete(I);
        Break;
      end;
    end;
  end;

  TabForm := TTabItem.Create(ParentTabControl);
  TabForm := ParentTabControl.Add(nil);
  TabForm.Name := 'tab' + Self.Name;
  TabForm.Text := Self.Caption;
  ParentTabControl.ActiveTab := TabForm;

  while Self.ChildrenCount > 0 do
    Children[0].Parent := TabForm;

  TabForm.TabStop := False;
end;

procedure TfExcecao.btnSairClick(Sender: TObject);
begin
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfExcecao.btnCriarClick(Sender: TObject);
begin
  try
    fCriarExcecao := TfCriarExcecao.Create(Application);
    fCriarExcecao.fdm := Self.fdm;
    fCriarExcecao.ShowModal;
  finally
    fCriarExcecao.Free;
    RecuperaMetadados;
    cdsExcecoes.Locate('exception_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfExcecao.RecuperaMetadados;
begin
  fdm.GetExceptions(cdsExcecoes, nil);
  cdsExcecoes.First;
  BindSourceDBDados.DataSet := cdsExcecoes;
  ShowDDL(cdsExcecoes);
end;

procedure TfExcecao.ShowDDL(DataSet: TDataSet);
begin
  MemoDDL.Lines.Clear;
  MemoDDL.Lines.Add(
    fdm.GetExceptionDDL(
      cdsExcecoes.FieldByName('exception_name').AsString));
end;

end.
