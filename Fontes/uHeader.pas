unit uHeader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uxForm, uDAC, FMX.Layouts, FMX.Memo, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti;

type
  TfHeader = class(TfxForm)
    MemoHeader: TMemo;
    ToolBar: TToolBar;
    btnSair: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetHeader;
  public
    { Public declarations }
    fdm: TfDAC;
    Banco: string;
  end;

var
  fHeader: TfHeader;

implementation

{$R *.fmx}

procedure TfHeader.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Header';
end;

procedure TfHeader.FormShow(Sender: TObject);
begin
  inherited;
  GetHeader;
end;

procedure TfHeader.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  fHeader.Release;
  fHeader := nil;
end;

procedure TfHeader.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfHeader.GetHeader;
begin
  MemoHeader.Lines.Clear;
  MemoHeader.Lines.AddStrings(fdm.GetMonitorHeader(Banco));
end;

end.
