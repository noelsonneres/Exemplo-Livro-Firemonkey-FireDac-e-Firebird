unit uGatilho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, System.Rtti, Data.Bind.Controls, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.Grid, FMX.ListBox, FMX.Memo, FMX.TabControl, FMX.EditBox, FMX.SpinBox,
  FMX.Controls.Presentation, FMX.Edit, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, uDAC,
  FireDAC.Comp.Client, Data.DB, Datasnap.DBClient, FMX.ComboEdit;

type
  TfGatilho = class(TfxForm)
    pnlSuperior: TPanel;
    pnlInferior: TPanel;
    BindNavigator: TBindNavigator;
    BindingsList: TBindingsList;
    cdsGatilhos: TClientDataSet;
    StringField5: TStringField;
    StringField4: TStringField;
    cdsGatilhostrigger_inactive: TStringField;
    BindSourceDBDados: TBindSourceDB;
    pnlCentral: TPanel;
    Splitter: TSplitter;
    TabControl: TTabControl;
    tabLista: TTabItem;
    grdDados: TGrid;
    tabDDL: TTabItem;
    LinkGridToDataSourceBindSourceDBDados2: TLinkGridToDataSource;
    MemoDDL: TMemo;
    ToolBar: TToolBar;
    cdsGatilhosrelation_name: TStringField;
    cdsGatilhostrigger_sequence: TSmallintField;
    lbMetadado: TLabel;
    btnSair: TButton;
    btnCriar: TButton;
    LinkPropertyToFieldText: TLinkPropertyToField;
    cdsGatilhostrigger_source: TMemoField;
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
  fGatilho: TfGatilho;

implementation

{$R *.fmx}

uses uCriarGatilho;

procedure TfGatilho.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Consultar Gatilhos';
  fdm := TfDAC.Create(Self);
  cdsGatilhos.CreateDataSet;
  cdsGatilhos.AfterScroll := ShowDDL;
  Self.GetStatusGrid(grdDados, Self);
end;

procedure TfGatilho.FormShow(Sender: TObject);
begin
  inherited;
  VerificaTabControl;
  TabControl.ActiveTab := tabLista;

  if fdm.GetConnection(Alias) = True then
  begin
    RecuperaMetadados;
    cdsGatilhos.Locate('trigger_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfGatilho.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if not cdsGatilhos.IsEmpty then cdsGatilhos.EmptyDataSet;
  Self.SetStatusGrid(grdDados, Self);
  fGatilho.Release;
  fGatilho := nil;
end;

procedure TfGatilho.VerificaTabControl;
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

procedure TfGatilho.btnSairClick(Sender: TObject);
begin
  inherited;
  while ParentTabControl.Tabs[TabForm.Index].ChildrenCount > 0 do
    ParentTabControl.Tabs[TabForm.Index].Children.Items[0].Parent := Self;
  Transparency := False;
  Close;
  ParentTabControl.Delete(TabForm.Index);
end;

procedure TfGatilho.btnCriarClick(Sender: TObject);
begin
  try
    fCriarGatilho := TfCriarGatilho.Create(Application);
    fCriarGatilho.fdm := Self.fdm;
    fCriarGatilho.ShowModal;
  finally
    fCriarGatilho.Free;
    RecuperaMetadados;
    cdsGatilhos.Locate('trigger_name', VarArrayOf([Metadado]), []);
    grdDados.SetFocus;
  end;
end;

procedure TfGatilho.RecuperaMetadados;
begin
  fdm.GetTriggers(cdsGatilhos, nil);
  cdsGatilhos.First;
  BindSourceDBDados.DataSet := cdsGatilhos;
  ShowDDL(cdsGatilhos);
end;

procedure TfGatilho.ShowDDL(DataSet: TDataSet);
begin
  MemoDDL.Lines.Clear;
  MemoDDL.Lines.Add(
    fdm.GetTriggerDDL(cdsGatilhos.FieldByName('trigger_name').AsString));
end;

end.
