unit uTeste;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, uDAC, FMX.Layouts, FMX.Memo, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Grid;

type
  TfTeste = class(TfxForm)
    Button1: TButton;
    Memo: TMemo;
    Button2: TButton;
    Grid: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fdm: TfDAC;
  public
    { Public declarations }
    Alias: string;
  end;

var
  fTeste: TfTeste;

implementation

{$R *.fmx}

procedure TfTeste.FormCreate(Sender: TObject);
begin
  inherited;
  inherited;
  Caption := 'Testes';
  fdm := TfDAC.Create(Self);
end;

procedure TfTeste.FormShow(Sender: TObject);
begin
  fdm.GetConnection(Alias);
end;

procedure TfTeste.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fTeste.Release;
  fTeste := nil;
end;

procedure TfTeste.Button1Click(Sender: TObject);
begin
  Memo.Lines.Clear;

// OK
//  fdm.FDConnection.GetCatalogNames(
//    '',
//    Memo.Lines
//   );

// OK
//  fdm.FDConnection.GetSchemaNames(
//    '',
//    '',
//    Memo.Lines
//   );

// OK
  fdm.FDConnection.GetTableNames(
    'C:\Pub\Lixo\NovoBanco.fdb',
    '',
    '',
    Memo.Lines,
    [osMy],
    [tkSynonym,tkTable,tkView],
    True
   );

// OK
//  fdm.FDConnection.GetFieldNames(
//    '',
//    '',
//    'ULTIMA',
//    '',
//    Memo.Lines
//    );

// OK
//  fdm.FDConnection.GetKeyFieldNames(
//    '',
//    '',
//    'ULTIMA',
//    '',
//    Memo.Lines);

// OK
//  fdm.FDConnection.GetGeneratorNames(
//    '',
//    '',
//    '',
//    Memo.Lines
//    [osMy],
//    True
//    );

// OK
//  fdm.FDConnection.GetPackageNames(
//    '',
//    '',
//    '',
//    Memo.Lines,
//    [osMy],
//    True
//    );

// OK
//  fdm.FDConnection.GetStoredProcNames(
//    '',
//    '',
//    '',
//    '',
//    Memo.Lines,
//    [osMy],
//    True
//    );
end;

procedure TfTeste.Button2Click(Sender: TObject);
var
  Table: TFDDatSTable;
  nome: string;
begin
  Memo.Lines.Clear;
  Table := TFDDatSTable.Create;

// OK
//  fdm.FDMetaInfoQuery.Connection := fdm.FDConnection;
//  fdm.FDMetaInfoQuery.MetaInfoKind := mkTables;
//  fdm.FDMetaInfoQuery.TableKinds := [tkTable];
//  fdm.FDMetaInfoQuery.AttachTable(Table, nil);
//  fdm.FDMetaInfoQuery.Open('select * from RDB$DATABASE');

// OK
//  fdm.FDMetaInfoQuery.Connection := fdm.FDConnection;
//  fdm.FDMetaInfoQuery.BaseObjectName := 'ULTIMA';
//  fdm.FDMetaInfoQuery.MetaInfoKind := mkPrimaryKeyFields;
//  fdm.FDMetaInfoQuery.ObjectScopes := [osMy,osSystem,osOther];
//  fdm.FDMetaInfoQuery.AttachTable(Table, nil);
//  fdm.FDMetaInfoQuery.Open('select * from RDB$DATABASE');

// OK
//  fdm.FDMetaInfoQuery.Connection := fdm.FDConnection;
//  fdm.FDMetaInfoQuery.MetaInfoKind := mkProcs;
//  fdm.FDMetaInfoQuery.ObjectScopes := [osMy,osSystem,osOther];
//  fdm.FDMetaInfoQuery.AttachTable(Table, nil);
//  fdm.FDMetaInfoQuery.Open('select * from RDB$DATABASE');

  fdm.FDMetaInfoQuery.Connection := fdm.FDConnection;
  fdm.FDMetaInfoQuery.BaseObjectName := 'MUNICIPIO';
  fdm.FDMetaInfoQuery.ObjectName := 'BUSCA_MUNICIPIO';
  fdm.FDMetaInfoQuery.MetaInfoKind := mkProcArgs;
  fdm.FDMetaInfoQuery.ObjectScopes := [osMy,osSystem,osOther];
  fdm.FDMetaInfoQuery.AttachTable(Table, nil);
  fdm.FDMetaInfoQuery.Open('select * from RDB$DATABASE');

  BindSourceDB1.DataSet := fdm.FDMetaInfoQuery;

  ShowMessage(IntToStr(
    fdm.FDMetaInfoQuery.RecordCount
    ));

  with fdm.FDMetaInfoQuery do begin
    First;
    while not Eof do begin
      nome := Fields[3].AsString;
      Memo.Lines.Add(nome);
      Next;
    end;
  end;
end;

procedure TfTeste.Button3Click(Sender: TObject);
begin
  inherited;
//  Memo.Lines.AddStrings(fdm.GetDatabaseHeader(Alias));
  Memo.Lines.Add(fdm.GetDatabaseODS(Alias));
end;

end.
