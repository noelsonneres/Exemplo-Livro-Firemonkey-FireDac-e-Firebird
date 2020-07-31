unit uxForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Grid, System.IniFiles;

type
  TfxForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    { Protected declarations }
    function SetStatusGrid(AGrid: TGrid; F: TForm): Boolean;
    function GetStatusGrid(AGrid: TGrid; F: TForm): Boolean;
    function Confirma(Msg: string; SN: string='N'): Boolean;
  public
    { Public declarations }
  end;

var
  fxForm: TfxForm;

implementation

{$R *.fmx}

uses
  uxFuncs;

procedure TfxForm.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

procedure TfxForm.FormShow(Sender: TObject);
begin
  inherited;
//
end;

procedure TfxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
//
end;

function TfxForm.Confirma(Msg, SN: string): Boolean;
begin
  if AnsiUpperCase(SN) = 'N' then
  begin
    if MessageDlg(Msg,TMsgDlgType.mtInformation,
       [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
       0, TMsgDlgBtn.mbNo) = idNo then
      Result := False;
  end
  else
  begin
    if MessageDlg(Msg,TMsgDlgType.mtInformation,
       [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
       0, TMsgDlgBtn.mbNo) = idYes then
      Result := True;
  end;
end;

function TfxForm.SetStatusGrid(AGrid: TGrid; F: TForm): Boolean;
var
  Perfis: string;
  FileName: string;
  Section: string;
  Ident: string;
  Value: string;
  I: Integer;
begin
  Perfis := ExtractFilePath(ParamStr(0)) + 'Perfis';
  if not DirectoryExists(Perfis) then
    ForceDirectories(Perfis);
  FileName := Perfis + '\' + F.Name + '.ini';
  Section := F.Name + AGrid.Name;

  with TIniFile.Create(FileName) do begin
    try
      EraseSection(Section);
      for I := 0 to AGrid.ColumnCount - 1 do begin
        Ident := AGrid.Columns[I].Header;
        Value := '';

        if AGrid.Columns[I].Visible = True then
          Value := Value + '1' + ';'
        else
          Value := Value + '0' + ';';
        Value := Value + FloatToStr(AGrid.Columns[I].Width);
        WriteString(Section, Ident, Value);
      end;
    finally
      Free;
    end;
  end;
end;

function TfxForm.GetStatusGrid(AGrid: TGrid; F: TForm): Boolean;
var
  Perfis: string;
  FileName: string;
  Section: string;
  Ident: string;
  Value: string;
  Visible: Boolean;
  Width: Integer;
  I: Integer;
begin
  Perfis := ExtractFilePath(ParamStr(0)) + 'Perfis';
  if not DirectoryExists(Perfis) then
    ForceDirectories(Perfis);
  FileName := Perfis + '\' + F.Name + '.ini';
  Section := F.Name + AGrid.Name;

  with TIniFile.Create(FileName) do begin
    try
      for I := 0 to AGrid.ColumnCount - 1 do begin
        Ident := AGrid.Columns[I].Header;
        Value := ReadString(Section, Ident, '');
        if Value = '' then
        begin
          AGrid.Columns[I].Width := 80;
        end
        else
        begin
          Visible := (mc_GetPiece(Value, 1, ';') = '1');
          Width := StrToInt(mc_GetPiece(Value, 2, ';'));
          AGrid.Columns[I].Visible := Visible;
          AGrid.Columns[I].Width := Width;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

end.
