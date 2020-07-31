unit uGerador;

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
  TfGerador = class(TfxForm)
    pnlSuperior: TPanel;
    pnlInferior: TPanel;
    BindNavigator: TBindNavigator;
    BindingsList: TBindingsList;
    cdsGeradores: TClientDataSet;
    BindSourceDBDados: TBindSourceDB;
    pnlCentral: TPanel;
    Splitter: TSplitter;
    TabControl: TTabControl;
    tabLista: TTabItem;
    grdDados: TGrid;
    tabDDL: TTabItem;
    MemoDDL: TMemo;
    ToolBar: TToolBar;
    cdsGeradoresgenerator_name: TStringField;
    LinkGridToDataSourceBindSourceDBDados: TLinkGridToDataSource;
    lbMetadado: TLabel;
    btnCriar: TButton;
    btnSair: TButton;
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
  fGerador: TfGerador;

implementation

{$R *.fmx}

uses uCriarGerador;

procedure TfGerador.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Geradores';
  fdm := TfDAC.Create(Self);
  cdsGeradores.CreateDataSet;
  cdsGeradores.AfterScroll := ShowDDL;
  Self.GetStatusGrid(grdDados, Self);
end;

procedure TfGerador.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControl.ActiveTab := tabLista;

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaMetadados;
    cdsGeradores.Locate('generator_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfGerador.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not cdsGeradores.IsEmpty then cdsGeradores.EmptyDataSet;
  Self.SetStatusGrid(grdDados, Self);
  fGerador.Release;
  fGerador := nil;
end;

procedure TfGerador.VerificaTabControl;
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
end;

procedure TfGerador.btnSairClick(Sender: TObject);
begin
  inherited;
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfGerador.btnCriarClick(Sender: TObject);
begin
  try
    fCriarGerador := TfCriarGerador.Create(Application);
    fCriarGerador.fdm := Self.fdm;
    fCriarGerador.ShowModal;
  finally
    fCriarGerador.Free;
    RecuperaMetadados;
    cdsGeradores.Locate('generator_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfGerador.RecuperaMetadados;
begin
  fdm.GetGenerators(cdsGeradores, nil);
  cdsGeradores.First;
  BindSourceDBDados.DataSet := cdsGeradores;
  ShowDDL(cdsGeradores);
end;

procedure TfGerador.ShowDDL(DataSet: TDataSet);
begin
  MemoDDL.Lines.Clear;
  MemoDDL.Lines.Add(
    fdm.GetGeneratorDDL(
      cdsGeradores.FieldByName('generator_name').AsString));
end;

end.
