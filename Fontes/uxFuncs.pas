unit uxFuncs;

interface

uses
  FMX.Dialogs, Winapi.ShellAPI, System.IniFiles, System.SysUtils,
  System.IOUtils;

function mc_GetPiece(AValue: string; APiece: Integer;
  ADelimiter: string): string;
function mc_Lixeira(AArquivo: string): Boolean;

function mc_GetArquivoCfg: string;
function mc_GravaArquivoCfg(AFile, ASection, AKey,
  AValue: string): Boolean;
function mc_LeArquivoCfg(AFile, ASection, AKey: string;
  AValue: string=''): string;

function mc_GetTempDir(): string;

implementation

function mc_GetPiece(AValue: string; APiece: Integer;
  ADelimiter: string): string;
var
  I, len, piece: Integer;
  ch: Char;
begin
  Result := '';

  if APiece < 1 then Exit;

  len := Length(AValue);
  piece := 0;

  for I := 1 to len do begin
    ch := AValue[I];
    if ch = ADelimiter then
    begin
      Inc(piece);
      if (piece = APiece) then Exit;
      Result := '';
    end
    else
    begin
      Result := Result + ch;
    end;
  end;

  Inc(piece);

  if (piece <> APiece) or (Length(Result) < 1) then
    Result := '';
end;

function mc_Lixeira(AArquivo: string): Boolean;
var
  sh: TShFileOpStruct;
begin
  Result := True;
  FillChar(sh, SizeOf(TShFileOpStruct), 0);
  with sh do begin
    wFunc := FO_DELETE;
    SetLength(AArquivo, Length(AArquivo));
    AArquivo := AArquivo + #0;
    pFrom := PChar(AArquivo);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  ShFileOperation(sh);
end;

function mc_GetArquivoCfg: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'FBAdmin.ini';
end;

function mc_GravaArquivoCfg(AFile, ASection, AKey,
  AValue: string): Boolean;
var
  ArqIni: TIniFile;
begin
  Result := True;

  if (Trim(ASection) = '') or (Trim(AKey) = '') then Exit;

  ArqIni := TIniFile.Create(AFile);

  with ArqIni do begin
    try
      try
        WriteString(ASection, AKey, AValue);
      except
        Result := False;
        Free;
      end;
    finally
      Free;
    end;
  end;
end;

function mc_LeArquivoCfg(AFile, ASection, AKey: string;
  AValue: string): string;
var
  ArqIni: TIniFile;
begin
  if (Trim(ASection) = '') or (Trim(AKey) = '') then Exit;

  Result := '';

  ArqIni := TIniFile.Create(AFile);

  with ArqIni do begin
    try
      try
        Result := ReadString(ASection, AKey, AValue);
      except
        Free;
      end;
    finally
      Free;
    end;
  end;
end;

function mc_GetTempDir(): string;
var
  TempDir: string;
begin
  TempDir := System.IOUtils.TPath.GetTempPath;
  Result := TempDir;
end;

end.
