unit uVisao;

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
  FireDAC.Phys.Intf, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

type
  TfVisao = class(TfxForm)
    pnlSuperior: TPanel;
    pnlInferior: TPanel;
    BindNavigator: TBindNavigator;
    BindingsList: TBindingsList;
    BindSourceDBDados: TBindSourceDB;
    pnlCentral: TPanel;
    Splitter: TSplitter;
    TabControl: TTabControl;
    tabLista: TTabItem;
    tabDDL: TTabItem;
    MemoDDL: TMemo;
    ToolBar: TToolBar;
    lbMetadado: TLabel;
    mtVisoes: TFDMemTable;
    mtVisoesview_name: TStringField;
    mtVisoesrelation_name: TStringField;
    mtVisoesowner_name: TStringField;
    grdDados: TGrid;
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
  fVisao: TfVisao;

implementation

{$R *.fmx}

uses
  uCriarVisao;

procedure TfVisao.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Visões';
  fdm := TfDAC.Create(Self);
  mtVisoes.CreateDataSet;
  mtVisoes.AfterScroll := ShowDDL;
  Self.GetStatusGrid(grdDados, Self);
end;

procedure TfVisao.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControl.ActiveTab := tabLista;

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaMetadados;
    mtVisoes.Locate('view_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfVisao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not mtVisoes.IsEmpty then mtVisoes.EmptyDataSet;
  Self.SetStatusGrid(grdDados, Self);
  fVisao.Release;
  fVisao := nil;
end;

procedure TfVisao.VerificaTabControl;
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

procedure TfVisao.btnSairClick(Sender: TObject);
begin
  inherited;
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfVisao.btnCriarClick(Sender: TObject);
begin
  try
    fCriarVisao := TfCriarVisao.Create(Application);
    fCriarVisao.fdm := Self.fdm;
    fCriarVisao.ShowModal;
  finally
    fCriarVisao.Free;
    RecuperaMetadados;
    mtVisoes.Locate('view_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfVisao.RecuperaMetadados;
begin
  fdm.GetViews(mtVisoes, nil);
  mtVisoes.First;
  BindSourceDBDados.DataSet := mtVisoes;
  ShowDDL(mtVisoes);
end;

procedure TfVisao.ShowDDL(DataSet: TDataSet);
begin
  MemoDDL.Lines.Clear;
  MemoDDL.Lines.Add(
    fdm.GetViewDDL(mtVisoes.FieldByName('view_name').AsString));
end;

end.
