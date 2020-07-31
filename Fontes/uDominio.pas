unit uDominio;

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
  TfDominio = class(TfxForm)
    pnlSuperior: TPanel;
    pnlInferior: TPanel;
    BindNavigator: TBindNavigator;
    BindingsList: TBindingsList;
    cdsDominios: TClientDataSet;
    BindSourceDBDados: TBindSourceDB;
    pnlCentral: TPanel;
    Splitter: TSplitter;
    TabControl: TTabControl;
    tabLista: TTabItem;
    grdDados: TGrid;
    tabDDL: TTabItem;
    MemoDDL: TMemo;
    ToolBar: TToolBar;
    LinkGridToDataSourceBindSourceDBDados: TLinkGridToDataSource;
    cdsDominiosfield_name: TStringField;
    lbMetadado: TLabel;
    cdsDominiosdefault_source: TMemoField;
    cdsDominiosvalidation_source: TMemoField;
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
  fDominio: TfDominio;

implementation

{$R *.fmx}

uses uCriarDominio;

procedure TfDominio.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Domínios';
  fdm := TfDAC.Create(Self);
  cdsDominios.CreateDataSet;
  cdsDominios.AfterScroll := ShowDDL;
  Self.GetStatusGrid(grdDados, Self);
end;

procedure TfDominio.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControl.ActiveTab := tabLista;

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaMetadados;
    cdsDominios.Locate('field_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfDominio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not cdsDominios.IsEmpty then cdsDominios.EmptyDataSet;
  Self.SetStatusGrid(grdDados, Self);
  fDominio.Release;
  fDominio := nil;
end;

procedure TfDominio.VerificaTabControl;
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

procedure TfDominio.btnSairClick(Sender: TObject);
begin
  inherited;
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfDominio.btnCriarClick(Sender: TObject);
begin
  try
    fCriarDominio := TfCriarDominio.Create(Application);
    fCriarDominio.fdm := Self.fdm;
    fCriarDominio.ShowModal;
  finally
    fCriarDominio.Free;
    RecuperaMetadados;
    cdsDominios.Locate('field_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfDominio.RecuperaMetadados;
begin
  fdm.GetDomains(cdsDominios, nil);
  cdsDominios.First;
  BindSourceDBDados.DataSet := cdsDominios;
  ShowDDL(cdsDominios);
end;

procedure TfDominio.ShowDDL(DataSet: TDataSet);
begin
  MemoDDL.Lines.Clear;
  MemoDDL.Lines.AddStrings(
    fdm.GetDomainDDL(
      cdsDominios.FieldByName('field_name').AsString));
end;

end.
