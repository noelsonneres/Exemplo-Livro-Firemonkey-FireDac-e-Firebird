unit uDAC;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, Datasnap.DBClient,
  System.Win.Registry, WinApi.Windows, System.IniFiles, FMX.Dialogs,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Phys.IBWrapper, FMX.Types, FMX.Controls, FMX.Forms, ShellAPI,
  System.Threading, FMX.ListBox, FMX.ComboEdit;

const
  FB_USER_NAME = 'SYSDBA';
  FB_PASSWORD  = 'masterkey';

type
  TfDAC = class(TDataModule)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDMetaInfoQuery: TFDMetaInfoQuery;
    FDUpdateTransaction: TFDTransaction;
    FDDefaultTransaction: TFDTransaction;
    FDScript: TFDScript;
    FDIBSecurity: TFDIBSecurity;
    FDMemTable: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ODSMajor: Integer;
    ODSMinor: Integer;

    function GetConnection(AAlias: string): Boolean;
    function GetDatabase(AAlias: string): string;
    function GetCurrentUser: string;
    function GetDefaultInstance: string;
    function GetDefaultLibrary: string;
    function GetRoleUser(AUser: string; ACombo: TComboEdit): string;

    function GetMonitorHeader(ABanco: string): TStrings;
    function GetDatabaseHeader(ABanco: string): TStrings;
    function GetDatabaseHeader2(ABanco: string): TStrings;

    function GetMonitorODS(ABanco: string): string;
    function GetDatabaseODS(ABanco: string): string;
    function GetStatistics(ABanco, AOpcoes, ATabela: string): TStrings;
    function GetStatistics2(ABanco, AOpcoes, ATabela: string): TStrings;

    function CheckTable(ATable: string): Boolean;
    function CheckBlobField(ATable, AField: string): Boolean;
    function CheckArrayField(ATable, AField: string): Boolean;
    function GetArraySelect(ATable, AField: string): string;
    function GetCharSetName: string;

    function StartDefaultTransaction: Boolean;
    function StartUpdateTransaction: Boolean;
    function CommitDefaultTransaction(ARetaining: Boolean=False): Boolean;
    function CommitUpdateTransaction(ARetaining: Boolean=False): Boolean;
    function RollbackUpdateTransaction(ARetaining: Boolean=False): Boolean;

    function ExecutaQuery(ASQL: string): string;

    function GetTableDDL(ATable: string): TStrings;
    function GetTablePKDDL(ATable: string): string;
    function GetCheckConstraintDDL(ATable, AConstraint: string): string;
    function GetIndicesTableDDL(ATable: string): TStrings;
    function GetForeignKeysTableDDL(ATable: string): TStrings;
    function GetViewDDL(AView: string): string;
    function GetProcedureDDL(AProcedure: string): TStrings;
    function GetGeneratorDDL(AGenerator: string): string;
    function GetTriggerDDL(ATrigger: string): string;
    function GetExceptionDDL(AException: string): string;
    function GetFunctionDDL(AFunction: string): TStrings;
    function GetRoleDDL(ARole: string): string;
    function GetDomainDDL(ADomain: string): TStrings;

    function GetFieldsTable(ATable: string; AFlag: Integer): TStrings;
    function GetDomainsTable(ATable: string): TStrings;
    function GetTriggersTable(ATable: string): TStrings;
    function GetParentTable(AIndex: string): string;
    function GetFieldsIndex(AIndex: string): string;
    function GetDomainsList: string;

    function GetTables(ACombo: TComboBox; AFlag: Integer=0;
      AItemZero: string=''): Boolean; overload;
    function GetTables(ACombo: TComboEdit; AFlag: Integer=0;
      AItemZero: string=''): Boolean; overload;
    function GetDomains(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetViews(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetProcedures(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetRoles(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetExceptions(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetFunctions(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetGenerators(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
    function GetTriggers(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
  end;

var
  fDAC: TfDAC;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  uxFuncs, uMensagem;

{ TfDAC }

procedure TfDAC.DataModuleCreate(Sender: TObject);
begin
//
end;

// ----------------------------------------
// Gerais
// ----------------------------------------

function TfDAC.GetConnection(AAlias: string): Boolean;
var
  S: string;
  FileName: TIniFile;
  alias: string;
  servidor: string;
  protocolo: string;
  banco: string;
  charSet: string;
  usuario: string;
  senha: string;
  papel: string;
  porta: string;
  dialeto: string;
  biblioteca: string;
begin
  Result := False;
  if AAlias = '' then Exit;

  FileName := TIniFile.Create(mc_GetArquivoCfg);
  S := FileName.ReadString('Databases', AAlias, '');

  alias := mc_GetPiece(S, 1, '#');
  servidor := mc_GetPiece(S, 2, '#');
  protocolo := mc_GetPiece(S, 3, '#');
  banco := mc_GetPiece(S, 4, '#');
  CharSet := mc_GetPiece(S, 5, '#');
  usuario := mc_GetPiece(S, 6, '#');
  senha := mc_GetPiece(S, 7, '#');
  papel := mc_GetPiece(S, 8, '#');
  porta := mc_GetPiece(S, 9, '#');
  dialeto := mc_GetPiece(S, 10, '#');
  biblioteca := mc_GetPiece(S, 11, '#');

  FDConnection.Connected := False;
  FDConnection.Params.Clear;
  FDConnection.DriverName := 'FB';
  FDConnection.Params.Add('User_Name=' + usuario);
  FDConnection.Params.Add('Password=' + senha);
  FDConnection.Params.Add('Protocol=' + protocolo);
  FDConnection.Params.Add('Database=' + banco);
  FDConnection.Params.Add('SqlDialect=' + dialeto);
  FDConnection.Params.Add('CharacterSet=' + charSet);
  FDConnection.Params.Add('VendorLibWin32=' + biblioteca);
  FDConnection.Params.Add('ExtendedMetadata=True');

  if porta = '' then
    FDConnection.Params.Add('Server=' + servidor)
  else
    FDConnection.Params.Add('Server=' + servidor + '/' + porta);

  try
    FDConnection.Connected := True;
    Result := True;
  except
    raise;
  end;

  FileName.Free;
end;

function TfDAC.GetDatabase(AAlias: string): string;
var
  S: string;
  FileName: TIniFile;
begin
  if AAlias = '' then Exit;
  FileName := TIniFile.Create(mc_GetArquivoCfg);
  S := FileName.ReadString('Databases', AAlias, '');
  FileName.Free;
  Result := mc_GetPiece(S, 4, '#');
end;

function TfDAC.GetMonitorHeader(ABanco: string): TStrings;
var
  qryX: TFDQuery;
  ssql: string;
begin
  Result := TStringList.Create;

  if CheckTable('MON$DATABASE') = False then
  begin
    Result := GetDatabaseHeader(ABanco);
    //Result := GetDatabaseHeader2(ABanco);
    Exit;
  end;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select * from mon$database '
        + '  where upper(MON$DATABASE_NAME) = '
        +          QuotedStr(AnsiUpperCase(ABanco));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if (RecordCount > 0) then
    begin
      Result.Add('Database ' +
        FieldByName('MON$DATABASE_NAME').AsString);

      Result.Add('Database header page information:');

      Result.Add(#9 + 'Page size          ' + #9#9 +
        FieldByName('MON$PAGE_SIZE').AsString);
      Result.Add(#9 + 'ODS Version        ' + #9#9 +
        FieldByName('MON$ODS_MAJOR').AsString + '.' +
        FieldByName('MON$ODS_MINOR').AsString);
      Result.Add(#9 + 'Oldest transaction ' + #9 +
        FieldByName('MON$OLDEST_TRANSACTION').AsString);
      Result.Add(#9 + 'Oldest active      ' + #9#9 +
        FieldByName('MON$OLDEST_ACTIVE').AsString);
      Result.Add(#9 + 'Oldest snapshot    ' + #9 +
        FieldByName('MON$OLDEST_SNAPSHOT').AsString);
      Result.Add(#9 + 'Next transaction   ' + #9 +
        FieldByName('MON$NEXT_TRANSACTION').AsString);
      Result.Add(#9 + 'Page buffers       ' + #9#9 +
        FieldByName('MON$PAGE_BUFFERS').AsString);
      Result.Add(#9 + 'Database dialect   ' + #9 +
        FieldByName('MON$SQL_DIALECT').AsString);
      Result.Add(#9 + 'Sweep interval     ' + #9#9 +
        FieldByName('MON$SWEEP_INTERVAL').AsString);
      Result.Add(#9 + 'Creation date      ' + #9#9 +
        FieldByName('MON$CREATION_DATE').AsString);
      Result.Add(#9 + 'Pages              ' + #9#9 +
        FieldByName('MON$PAGES').AsString);
      Result.Add(#9 + 'Stat ID            ' + #9#9 +
        FieldByName('MON$STAT_ID').AsString);

      Result.Add('Attributes:');

      if FieldByName('MON$SHUTDOWN_MODE').AsInteger = 0 then
        Result.Add(#9 + 'Shutdown mode      ' + #9 + 'online')
      else
      if FieldByName('MON$SHUTDOWN_MODE').AsInteger = 1 then
        Result.Add(#9 + 'Shutdown mode      ' + #9 + 'multi-user shutdown')
      else
      if FieldByName('MON$SHUTDOWN_MODE').AsInteger = 2 then
        Result.Add(#9 + 'Shutdown mode      ' + #9 + 'single-user shutdown')
      else
      if FieldByName('MON$SHUTDOWN_MODE').AsInteger = 3 then
        Result.Add(#9 + 'Shutdown mode      ' + #9 + 'full shutdown');

      if FieldByName('MON$BACKUP_STATE').AsInteger = 0 then
        Result.Add(#9 + 'Backup state       ' + #9#9 + 'normal')
      else
      if FieldByName('MON$BACKUP_STATE').AsInteger = 1 then
        Result.Add(#9 + 'Backup state      ' + #9#9 + 'stalled')
      else
      if FieldByName('MON$BACKUP_STATE').AsInteger = 2 then
        Result.Add(#9 + 'Backup state      ' + #9#9 + 'merge');

      if FieldByName('MON$READ_ONLY').AsInteger = 1 then
        Result.Add(#9 + 'Read only        ' + #9#9 + 'True')
      else
        Result.Add(#9 + 'Read only        ' + #9#9 + 'False');

      if FieldByName('MON$FORCED_WRITES').AsInteger = 1 then
        Result.Add(#9 + 'Force write      ' + #9#9 + 'True')
      else
        Result.Add(#9 + 'Force write      ' + #9#9 + 'False');

      if FieldByName('MON$RESERVE_SPACE').AsInteger = 1 then
        Result.Add(#9 + 'Reserve space    ' + #9#9 + 'True')
      else
        Result.Add(#9 + 'Reserve space    ' + #9#9 + 'False');
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetDatabaseHeader(ABanco: string): TStrings;
var
  fileName: string;
  fbBin: string;
  appDir: string;
  fileBat: string;
  fileLog: string;
  fileText: TextFile;
  cmd: string;
  si: STARTUPINFO;
  pi: PROCESS_INFORMATION;
  dirTemp: string;
begin
  Result := TStringList.Create;
  fbBin := GetDefaultInstance;
  appDir := ExtractFilePath(ParamStr(0));
  fileBat := mc_GetTempDir + 'gstat.bat';
  fileLog := mc_GetTempDir + 'gstat.log';

  AssignFile(fileText, fileBat);
  Rewrite(fileText);

  cmd := 'cd ' + '"' + fbBin + 'bin' + '"';
  Writeln(fileText, cmd);
  cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' +
    FB_PASSWORD + ' -h ' + '"' + ABanco + '"' + ' > ' +
    '"' + fileLog + '"';
  Writeln(fileText, cmd);
  cmd :=  'cd ' + '"' + appDir + '"';
  Writeln(fileText, cmd);

  CloseFile(fileText);

  ZeroMemory(@si, sizeof(si));
  ZeroMemory(@pi, sizeof(pi));

  si.cb := sizeof(si);
  si.lpReserved := nil;
  si.lpDesktop := nil;
  si.lpTitle := nil;
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_HIDE;
  si.cbReserved2 := 0;
  si.lpReserved2 := nil;

  CreateProcess(
    nil,              // LPCTSTR lpApplicationName
    PChar(fileBat),   // LPTSTR lpCommandLine
    nil,              // LPSECURITY_ATTRIBUTES lpProcessAttributes
    nil,              // LPSECURITY_ATTRIBUTES lpThreadAttributes
    False,            // BOOL bInheritHandles
    CREATE_NO_WINDOW, // DWORD dwCreationFlags
    nil,              // LPVOID lpEnvironment
    nil,              // LPCTSTR lpCurrentDirectory
    si,               // LPSTARTUPINFO lpStartupInfo
    pi                // LPPROCESS_INFORMATION lpProcessInformation
    );

  fMensagem := TfMensagem.Create(Application);
  try
    fMensagem.msg := 'Recuperando header. Aguarde...';
    fMensagem.processo := pi;
    fMensagem.ShowModal;
  finally
    fMensagem.Free;
  end;

  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

  if FileExists(fileLog) then
    Result.LoadFromFile(fileLog);

  uxFuncs.mc_Lixeira(fileBat);
  uxFuncs.mc_Lixeira(fileLog);
end;

function TfDAC.GetDatabaseHeader2(ABanco: string): TStrings;
var
  fileName: string;
  fbBin: string;
  appDir: string;
  fileLog: string;
  fileBat: string;
  fileText: TextFile;
  cmd: string;
begin
  Result := TStringList.Create;
  fbBin := GetDefaultInstance;
  appDir := ExtractFilePath(ParamStr(0));
  fileLog := appDir + 'gstat.log';
  fileBat := appDir + 'gstat.bat';

  AssignFile(fileText, fileBat);
  Rewrite(fileText);

  cmd := 'cd ' + '"' + fbBin + 'bin' + '"';
  Writeln(fileText, cmd);
  cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' +
    FB_PASSWORD + ' -h ' + '"' + ABanco + '"' + ' > ' +
    '"' + fileLog + '"';
  Writeln(fileText, cmd);
  cmd :=  'cd ' + '"' + appDir + '"';
  Writeln(fileText, cmd);

  CloseFile(fileText);

  TParallel.For(0, 0,
    procedure(Value: Integer)
    begin
       ShellExecute(0, nil, PChar(fileBat), nil, nil, SW_MINIMIZE);
       Sleep(1000);
    end);

  if FileExists(fileLog) then
    Result.LoadFromFile(fileLog);

  uxFuncs.mc_Lixeira(fileBat);
  uxFuncs.mc_Lixeira(fileLog);
end;

function TfDAC.GetMonitorODS(ABanco: string): string;
var
  qryX: TFDQuery;
  ssql: string;
begin
  Result := '';

  if CheckTable('MON$DATABASE') = False then
  begin
    Result := GetDatabaseODS(ABanco);
    Exit;
  end;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select MON$ODS_MAJOR, '
        + '        MON$ODS_MINOR '
        + '   from mon$database '
        + '  where upper(MON$DATABASE_NAME) = '
        +          QuotedStr(AnsiUpperCase(ABanco));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if (RecordCount > 0) then
    begin
      Result :=
        FieldByName('MON$ODS_MAJOR').AsString + '.' +
        FieldByName('MON$ODS_MINOR').AsString;
      ODSMajor := FieldByName('MON$ODS_MAJOR').AsInteger;
      ODSMinor := FieldByName('MON$ODS_MINOR').AsInteger;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetDatabaseODS(ABanco: string): string;
var
  tsODS: TStrings;
  I, P: Integer;
  lin: string;
begin
  Result := '';
  tsODS := TStringList.Create;
  tsODS.AddStrings(GetDatabaseHeader(ABanco));

  for I := 0 to tsODS.Count - 1 do begin
    lin := tsODS.Strings[I];
    P := AnsiPos('ODS version', lin);
    if P > 0 then
    begin
      Break;
    end;
  end;

  for I := 1 to Length(lin) do begin
    if (CharInSet(lin[I], ['0'..'9', '.'])) then
       Result := Result + lin[I];
  end;

  if Result <> '' then
  begin
    ODSMajor := StrToInt(mc_GetPiece(Result, 1, '.'));
    ODSMinor := StrToInt(mc_GetPiece(Result, 2, '.'));
  end;

  tsODS.Free;
end;

function TfDAC.GetStatistics(ABanco, AOpcoes, ATabela: string): TStrings;
var
  fbBin: string;
  appDir: string;
  fileBat: string;
  fileLog: string;
  fileText: TextFile;
  cmd: string;
  si: STARTUPINFO;
  pi: PROCESS_INFORMATION;
begin
  Result := TStringList.Create;
  fbBin := GetDefaultInstance;
  appDir := ExtractFilePath(ParamStr(0));
  fileBat := mc_GetTempDir + 'gstat.bat';
  fileLog := mc_GetTempDir + 'gstat.log';

  AssignFile(fileText, fileBat);
  Rewrite(fileText);

  cmd := 'cd "' + fbBin + 'bin"';
  Writeln(fileText, cmd);

  if ATabela = '<Todas>' then
  begin
    cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' + FB_PASSWORD + ' ' +
      AOpcoes + '"' + ABanco + '"' + ' > ' + '"' + fileLog + '"';
  end
  else
  begin
    cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' + FB_PASSWORD + ' ' +
      AOpcoes + '"' + ABanco + '"' + ' -t ' + ATabela +
      ' > ' + '"' + fileLog + '"';
  end;

  Writeln(fileText, cmd);
  cmd :=  'cd "' + appDir + '"';
  Writeln(fileText, cmd);
  CloseFile(fileText);

  ZeroMemory(@si, sizeof(si));
  ZeroMemory(@pi, sizeof(pi));

  si.cb := sizeof(si);
  si.lpReserved := nil;
  si.lpDesktop := nil;
  si.lpTitle := nil;
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_HIDE;
  si.cbReserved2 := 0;
  si.lpReserved2 := nil;

  CreateProcess(
    nil,              // LPCTSTR lpApplicationName
    PChar(fileBat),   // LPTSTR lpCommandLine
    nil,              // LPSECURITY_ATTRIBUTES lpProcessAttributes
    nil,              // LPSECURITY_ATTRIBUTES lpThreadAttributes
    False,            // BOOL bInheritHandles
    CREATE_NO_WINDOW, // DWORD dwCreationFlags
    nil,              // LPVOID lpEnvironment
    nil,              // LPCTSTR lpCurrentDirectory
    si,               // LPSTARTUPINFO lpStartupInfo
    pi                // LPPROCESS_INFORMATION lpProcessInformation
    );

  fMensagem := TfMensagem.Create(Application);
  try
    fMensagem.msg := 'Recuperando estatísticas. Aguarde...';
    fMensagem.processo := pi;
    fMensagem.ShowModal;
  finally
    fMensagem.Free;
  end;

  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

  if FileExists(fileLog) then
    Result.LoadFromFile(fileLog);

  uxFuncs.mc_Lixeira(fileBat);
  uxFuncs.mc_Lixeira(fileLog);
end;

function TfDAC.GetStatistics2(ABanco, AOpcoes, ATabela: string): TStrings;
var
  fbBin: string;
  appDir: string;
  fileLog: string;
  fileBat: string;
  fileText: TextFile;
  cmd: string;
begin
  Result := TStringList.Create;
  fbBin := GetDefaultInstance;
  appDir := ExtractFilePath(ParamStr(0));
  fileLog := appDir + 'gstat.log';
  fileBat := appDir + 'gstat.bat';

  AssignFile(fileText, fileBat);
  Rewrite(fileText);

  cmd := 'cd "' + fbBin + 'bin"';
  Writeln(fileText, cmd);

  if ATabela = '<Todas>' then
  begin
    cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' + FB_PASSWORD + ' ' +
      AOpcoes + '"' + ABanco + '"' + ' > ' + '"' + fileLog + '"';
  end
  else
  begin
    cmd := 'gstat -user ' + FB_USER_NAME + ' -pas ' + FB_PASSWORD + ' ' +
      AOpcoes + '"' + ABanco + '"' + ' -t ' + ATabela +
      ' > ' + '"' + fileLog + '"';
  end;

  Writeln(fileText, cmd);
  cmd :=  'cd "' + appDir + '"';
  Writeln(fileText, cmd);
  CloseFile(fileText);

  TParallel.For(0, 0,
    procedure(Value: Integer)
    begin
       ShellExecute(0, nil, PChar(fileBat), nil, nil, SW_MINIMIZE);
       Sleep(1000);
    end);

  if FileExists(fileLog) then
    Result.LoadFromFile(fileLog);

  uxFuncs.mc_Lixeira(fileBat);
  uxFuncs.mc_Lixeira(fileLog);
end;

function TfDAC.GetCurrentUser: string;
var
  qryX: TFDQuery;
  ssql: string;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$get_context(''SYSTEM'', ''CURRENT_USER'') '
        + '   from rdb$database ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if (RecordCount > 0) then
      Result := Fields[0].AsString;
  end;

  qryX.Free;
end;

function TfDAC.GetDefaultInstance: string;
begin
  Result := '';
  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    try
      OpenKey('\Software\Firebird Project\Firebird Server\Instances', False);
      Result := ReadString('DefaultInstance');
      CloseKey;
    finally
      Free;
    end;
  end;
end;

function TfDAC.GetDefaultLibrary: string;
begin
  Result := GetDefaultInstance;
  if Result <> '' then
    Result := Result + 'fbclient.dll';
end;

function TfDAC.GetRoleUser(AUser: string; ACombo: TComboEdit): string;
var
  qryX: TFDQuery;
  ssql: string;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$relation_name '
        + '   from rdb$user_privileges '
        + '  where upper(rdb$user) = '
        +          QuotedStr(AnsiUpperCase(AUser))
        + '    and rdb$object_type = 13 ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      ACombo.Items.Add(FieldByName('rdb$relation_name').AsString);
      Next;
    end;
  end;

  qryX.Free;
end;

// ----------------------------------------
// Transações
// ----------------------------------------

function TfDAC.StartDefaultTransaction: Boolean;
begin
  Result := True;
  if not FDConnection.Connected then Exit;
  if FDDefaultTransaction.Active = False then
    FDDefaultTransaction.StartTransaction;
end;

function TfDAC.StartUpdateTransaction: Boolean;
begin
  Result := True;
  if not FDConnection.Connected then Exit;
  if FDUpdateTransaction.Active = False then
    FDUpdateTransaction.StartTransaction;
end;

function TfDAC.CommitDefaultTransaction(ARetaining: Boolean): Boolean;
begin
  Result := True;
  if not FDConnection.Connected then Exit;
  if FDDefaultTransaction.Active = True then
  begin
    if ARetaining then
      FDDefaultTransaction.CommitRetaining
    else
      FDDefaultTransaction.Commit;
  end;
end;

function TfDAC.CommitUpdateTransaction(ARetaining: Boolean): Boolean;
begin
  Result := True;
  if not FDConnection.Connected then Exit;
  if FDUpdateTransaction.Active = True then
  begin
    if ARetaining then
      FDUpdateTransaction.CommitRetaining
    else
      FDUpdateTransaction.Commit;
  end;
end;

function TfDAC.RollbackUpdateTransaction(ARetaining: Boolean): Boolean;
begin
  Result := True;
  if not FDConnection.Connected then Exit;
  if FDUpdateTransaction.Active = True then
  begin
    if ARetaining then
      FDUpdateTransaction.RollbackRetaining
    else
      FDUpdateTransaction.Rollback;
  end;
end;

// ----------------------------------------
// Comandos
// ----------------------------------------

function TfDAC.ExecutaQuery(ASQL: string): string;
var
  qryX: TFDQuery;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  try
    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ASQL);
      Open;
      if (RecordCount > 0) then
        Result := Fields[0].AsString;
    end;
  except
    qryX.Free;
    raise;
  end;

  qryX.Free;
end;

// ----------------------------------------
// Montagem de DDLs
// ----------------------------------------

function TfDAC.GetTableDDL(ATable: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  qryY: TFDQuery;
  nome, tipo, default, nulo, caractere, ordenacao, dominio: string;
  subTipo, segmento, computedBy: string;
  sVetor: string;
  iLower: Integer;
  iUpper: Integer;
  tsDominios: TStrings;
  tsColunas: TStrings;
  tsIndices: TStrings;
  tsIntegridade: TStrings;
  tsGatilhos: TStrings;
  S, PK: string;
  I: Integer;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;

  tsDominios := TStringList.Create;
  tsColunas := TStringList.Create;
  tsIndices := TStringList.Create;
  tsIntegridade := TStringList.Create;
  tsGatilhos := TStringList.Create;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;
  qryY := TFDQuery.Create(Self);
  qryY.Connection := FDConnection;

  ssql := ' select r.rdb$field_name '
        + '      , r.rdb$null_flag '
        + '      , r.rdb$collation_id '
        + '      , r.rdb$field_position '
        + '      , r.rdb$default_source '
        + '      , r.rdb$field_source '
        + '      , f.rdb$field_sub_type '
        + '      , f.rdb$character_set_id '
        + '      , f.rdb$field_length '
        + '      , f.rdb$field_scale '
        + '      , f.rdb$field_precision '
        + '      , f.rdb$segment_length '
        + '      , f.rdb$computed_source '
        + '      , t.rdb$type_name '
        + '   from rdb$relation_fields r '
        + '   join rdb$fields f on '
        + '        f.rdb$field_name = r.rdb$field_source '
        + '   join rdb$types t '
        + '     on t.rdb$type = f.rdb$field_type '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and t.rdb$field_name = ''RDB$FIELD_TYPE'' '
        + '  order by r.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      nome := FieldByName('rdb$field_name').AsString;
      default := FieldByName('rdb$default_source').AsString;
      dominio := FieldByName('rdb$field_source').AsString;
      subTipo := FieldByName('rdb$field_sub_type').AsString;
      segmento := FieldByName('rdb$segment_length').AsString;
      computedBy := FieldByName('rdb$computed_source').AsString;
      caractere := '';
      ordenacao := '';

      ssql := ' select rdb$lower_bound, '
            + '        rdb$upper_bound '
            + '   from rdb$field_dimensions '
            + '  where upper(rdb$field_name) = '
            +          QuotedStr(AnsiUpperCase(dominio))
            + '  order by rdb$dimension ';

      with qryY do begin
        sVetor := '';
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        while not Eof do begin
          iLower := FieldByName('rdb$lower_bound').AsInteger;
          iUpper := FieldByName('rdb$upper_bound').AsInteger;
          if iLower = 0 then
          begin
            sVetor := IntToStr(iLower) + ':' + IntToStr(iUpper);
          end
          else
          begin
            if sVetor <> '' then
              sVetor := sVetor + ',';
            sVetor := sVetor + IntToStr(iUpper);
          end;
          Next;
        end;
        if sVetor <> '' then
          sVetor := '[' + sVetor + ']';
      end;

      if FieldByName('rdb$character_set_id').AsString <> '' then
      begin
        ssql := ' select rdb$character_set_name '
              + '   from rdb$character_sets '
              + '  where rdb$character_set_id = '
              +          FieldByName('rdb$character_set_id').AsString;

        caractere := ExecutaQuery(ssql);
        if caractere <> '' then
          caractere := 'CHARACTER SET ' + caractere;
      end;

      if (FieldByName('rdb$character_set_id').AsString <> '') and
         (FieldByName('rdb$collation_id').AsString <> '') then
      begin
        ssql := ' select rdb$collation_name '
              + '   from rdb$collations '
              + '  where rdb$character_set_id = '
              +          FieldByName('rdb$character_set_id').AsString
              + '    and rdb$collation_id = ' +
                         FieldByName('rdb$collation_id').AsString;

        ordenacao := ExecutaQuery(ssql);
        if ordenacao <> '' then
          ordenacao := 'COLLATE ' + ordenacao;
      end;

      if FieldByName('rdb$null_flag').AsInteger = 1 then
        nulo := 'NOT NULL'
      else
        nulo := '';

//      if Copy(dominio, 1, 4) <> 'RDB$' then
//        tipo := dominio
//      else
        tipo := FieldByName('rdb$type_name').AsString;

      if tipo = 'DOUBLE' then
      begin
        tipo := 'DOUBLE PRECISION';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'FLOAT' then
      begin
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'BLOB' then
      begin
        if subTipo <> '' then
          tipo := tipo + ' SUB_TYPE ' + subTipo;
        if segmento <> '' then
          tipo := tipo + ' SEGMENT SIZE ' + segmento;
      end
      else
      if tipo = 'TEXT' then
      begin
        tipo := 'CHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'VARYING' then
      begin
        tipo := 'VARCHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'SHORT' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'SMALLINT'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
          FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'LONG' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'INTEGER'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end
      else
      if tipo = 'INT64' then
      begin
        if (FieldByName('rdb$field_sub_type').AsInteger = 0) then
        begin
          tipo := 'INT64';
        end
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
        if sVetor <> '' then
          tipo := tipo + sVetor;
      end;

      default := FieldByName('rdb$default_source').AsString;

      if computedBy <> '' then
      begin
        S := nome + ' COMPUTED BY ' + computedBy;
        caractere := '';
        ordenacao := '';
        default := '';
      end
      else
      begin
        S := nome + ' ' + tipo;
      end;

      if nulo <> '' then
        S := S + ' ' + nulo;

      if default <> '' then
      begin
        S := S + ' ' + default;
        caractere := '';
        ordenacao := '';
      end;

      if caractere <> '' then
        S := S + ' ' + caractere;

      if ordenacao <> '' then
        S := S + ' ' + ordenacao;

      S := S +  ',';

      tsColunas.Add(S);

      Next;
    end;

    S := '';
  end;

  if tsColunas.Count > 0 then
  begin
    PK := GetTablePKDDL(ATable);

    if PK <> '' then
    begin
      tsColunas.Add(PK);
    end
    else
    begin
      I := tsColunas.Count - 1;
      S := tsColunas.Strings[I];
      Delete(S, Length(S), 1);
      tsColunas.Delete(I);
      tsColunas.Add(S);
    end;
  end;

  if tsColunas.Count > 0 then
  begin
    // Recupera domínios
    tsDominios.AddStrings(GetDomainsTable(ATable));
    if tsDominios.Count > 0 then
    begin
      Result.AddStrings(tsDominios);
      Result.Add('');
    end;

    Result.Add('CREATE TABLE ' + ATable);
    Result.Add('(');
    Result.AddStrings(tsColunas);
    Result.Add(');');

    // Recupera índices
    tsIndices.AddStrings(GetIndicesTableDDL(ATable));
    if tsIndices.Count > 0 then
    begin
      Result.Add('');
      Result.AddStrings(tsIndices);
    end;

    // Recupera integridade referencial
    tsIntegridade.AddStrings(GetForeignKeysTableDDL(ATable));
    if tsIntegridade.Count > 0 then
    begin
      Result.Add('');
      Result.AddStrings(tsIntegridade);
    end;

    // Recupera gatilhos
    tsGatilhos.AddStrings(GetTriggersTable(ATable));
    if tsGatilhos.Count > 0 then
    begin
      Result.Add('');
      Result.AddStrings(tsGatilhos);
    end;
  end;

  Result := Result;
  tsDominios.Free;
  tsColunas.Free;
  tsIndices.Free;
  tsIntegridade.Free;
  tsGatilhos.Free;
  qryX.Free;
  qryY.Free;
end;

function TfDAC.GetTablePKDDL(ATable: string): string;
var
  ssql: string;
  qryX: TFDQuery;
  S: string;
  constraint: string;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select r.rdb$constraint_name, '
        + '        i.rdb$field_name, '
        + '        i.rdb$field_position '
        + '   from rdb$relation_constraints r '
        + '   join rdb$index_segments i '
        + '     on i.rdb$index_name = r.rdb$index_name '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and r.rdb$constraint_type = ''PRIMARY KEY'' '
        + '  order by i.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      if FieldByName('rdb$field_position').AsInteger = 0 then
      begin
        constraint := FieldByName('rdb$constraint_name').AsString;
        if AnsiPos('INTEG_', constraint) > 0 then
          S := 'PRIMARY KEY ('
        else
          S := 'CONSTRAINT ' + constraint + ' ' + 'PRIMARY KEY (';
      end;
      S := S + FieldByName('rdb$field_name').AsString + ', ';
      Next;
    end;
  end;

  if S <> '' then
  begin
    Delete(S, Length(S) - 1, 2);
    Result := S + ')';
  end;

  qryX.Free;
end;

function TfDAC.GetCheckConstraintDDL(ATable, AConstraint: string): string;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select t.rdb$trigger_source '
        + '   from rdb$relation_constraints r '
        + '   join rdb$check_constraints c '
        + '     on c.rdb$constraint_name = r.rdb$constraint_name '
        + '   join rdb$triggers t '
        + '     on t.rdb$trigger_name = c.rdb$trigger_name '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and r.rdb$constraint_type = ' + QuotedStr('CHECK')
        + '    and r.rdb$constraint_name = ' + QuotedStr(AConstraint);

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    Result := FieldByName('rdb$trigger_source').AsString;
  end;

  qryX.Free;
end;

function TfDAC.GetIndicesTableDDL(ATable: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  sIndexName: string;
  sUnique: string;
  sOrder: string;
  sType: string;
  sIndexFields: string;
  S: string;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select i.rdb$index_name, '
        + '        case i.rdb$unique_flag '
        + '          when 1 then ''UNIQUE'' '
        + '          else '''' '
        + '        end as rdb$unique_flag, '
        + '        case i.rdb$index_type '
        + '          when 1 then ''DESCENDING'' '
        + '          else '''' '
        + '        end as rdb$index_type '
        + '   from rdb$indices i '
        + '   join rdb$index_segments s '
        + '     on s.rdb$index_name = i.rdb$index_name '
        + '   left outer join rdb$relation_constraints r '
        + '     on r.rdb$constraint_name = i.rdb$index_name '
        + '  where upper(i.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and i.rdb$system_flag = 0 '
        + '    and i.rdb$foreign_key is null '
        + '    and r.rdb$constraint_type is null '
        + '  order by i.rdb$index_id ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      sIndexName := FieldByName('rdb$index_name').AsString;
      sUnique := FieldByName('rdb$unique_flag').AsString;
      sOrder := FieldByName('rdb$index_type').AsString;

      // Recupera colunas do índice
      sIndexFields := GetFieldsIndex(sIndexName);

      if sIndexFields <> '' then
      begin
        S := 'CREATE INDEX';

        if sUnique <> '' then
          S := S + ' ' + sUnique;

        if sOrder <> '' then
          S := S + ' ' + sOrder;

        if Copy(sIndexName, 1, 4) <> 'RDB$' then
          S := S + ' ' + sIndexName + ' ON TABLE ' +
            ATable + '(' + sIndexFields + ')'
        else
          S := S + ' ON TABLE ' +
            ATable + '(' + sIndexFields + ')';

        S := S + ';';

        if Result.Count = 0 then
          Result.Add('');
        Result.Add(S);
      end;
      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetForeignKeysTableDDL(ATable: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  sForeignKey: string;
  sReference: string;
  sIndexName: string;
  sUpdateRule: string;
  sDeleteRule: string;
  sParentTable: string;
  sForeignKeyFields: string;
  sReferencesFields: string;
  S: string;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select i.rdb$index_name, '
        + '        i.rdb$foreign_key, '
        + '        c.rdb$update_rule, '
        + '        c.rdb$delete_rule '
        + '    from rdb$indices i '
        + '    join rdb$relation_constraints r '
        + '      on r.rdb$index_name = i.rdb$index_name '
        + '    join rdb$ref_constraints c '
        + '      on c.rdb$constraint_name = r.rdb$constraint_name '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and r.rdb$constraint_type = ''FOREIGN KEY'' '
        + '  order by i.rdb$index_id ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      sForeignKey := FieldByName('rdb$index_name').AsString;
      sReference := FieldByName('rdb$foreign_key').AsString;
      sIndexName := FieldByName('rdb$index_name').AsString;
      sUpdateRule := FieldByName('rdb$update_rule').AsString;
      sDeleteRule := FieldByName('rdb$delete_rule').AsString;

      // Recupera a tabela pai
      sParentTable := GetParentTable(sForeignKey);

      // Recupera colunas da foreign key
      sForeignKeyFields := GetFieldsIndex(sForeignKey);
      sReferencesFields := GetFieldsIndex(sReference);

      if sForeignKeyFields <> '' then
      begin
        if Copy(indexName, 1, 4) = 'RDB$' then
        begin
          S := 'ALTER TABLE ' + ATable + ' ADD FOREIGN KEY (' +
            sForeignKeyFields + ') REFERENCES ' +
            sParentTable + ' (' + sReferencesFields + ')';
          if sUpdateRule <> 'RESTRICT' then
            S := S + ' ON UPDATE ' + sUpdateRule;
          if sDeleteRule <> 'RESTRICT' then
            S := S + ' ON DELETE ' + sDeleteRule;
          S := S + ';';
        end
        else
        begin
          S := 'ALTER TABLE ' + ATable + ' ADD CONSTRAINT ' +
            sForeignKey + ' FOREIGN KEY (' +
            sForeignKeyFields + ') REFERENCES ' +
            sParentTable + ' (' + sReferencesFields + ')';
          if sUpdateRule <> 'RESTRICT' then
            S := S + ' ON UPDATE ' + sUpdateRule;
          if sDeleteRule <> 'RESTRICT' then
            S := S + ' ON DELETE ' + sDeleteRule;
          S := S + ';';
        end;

        if Result.Count = 0 then
          Result.Add('');
        Result.Add(S);
      end;

      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetViewDDL(AView: string): string;
var
  ssql: string;
  qryX: TFDQuery;
  S: string;
  tabela: string;
begin
  Result := '';
  S := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select v.rdb$relation_name, '
        + '        f.rdb$field_name '
        + '   from rdb$view_relations  v '
        + '   join rdb$relation_fields f '
        + '     on f.rdb$relation_name = v.rdb$view_name '
        + '  where upper(v.rdb$view_name) = '
        +          QuotedStr(AnsiUpperCase(AView))
        + '  order by f.rdb$field_position ';


  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      tabela := FieldByName('rdb$relation_name').AsString;
      if S <> '' then
        S := S + ',' + #13#10;
      S := S + FieldByName('rdb$field_name').AsString;
      Next;
    end;
  end;

  if S <> '' then
  begin
    Result := 'CREATE VIEW ' + AView + ' ( ' + #13#10;
    Result := Result + S + ') AS ' + #13#10 + #13#10;
    Result := Result + 'SELECT ' + #13#10;
    Result := Result + S + #13#10;
    Result := Result + 'FROM ' + tabela + #13#10 + ';';
  end;

  qryX.Free;
end;

function TfDAC.GetProcedureDDL(AProcedure: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  nome, fonte, tipo, caractere, dominio: string;
  subTipo, segmento: string;
  tsEnt: TStrings;
  tsSai: TStrings;
  S, Ent, Sai: string;
  I: Integer;
begin
  AProcedure := AnsiUpperCase(AProcedure);
  Result := TStringList.Create;
  tsEnt := TStringList.Create;
  tsSai := TStringList.Create;

  Ent := '';
  Sai := '';

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select p.rdb$procedure_name '
        + '      , p.rdb$procedure_source '
        + '      , r.rdb$parameter_name '
        + '      , r.rdb$field_source '
        + '      , r.rdb$parameter_type '
        + '      , r.rdb$parameter_number '
        + '      , f.rdb$field_name '
        + '      , f.rdb$field_sub_type '
        + '      , f.rdb$field_length '
        + '      , f.rdb$field_scale '
        + '      , f.rdb$field_precision '
        + '      , f.rdb$segment_length '
        + '      , f.rdb$computed_source '
        + '      , f.rdb$character_length '
        + '      , f.rdb$character_set_id '
        + '      , f.rdb$collation_id '
        + '      , t.rdb$type_name '
        + '   from rdb$procedures p '
        + '   join rdb$procedure_parameters r '
        + '     on r.rdb$procedure_name = p.rdb$procedure_name '
        + '   join rdb$fields f '
        + '     on f.rdb$field_name = r.rdb$field_source '
        + '   join rdb$types t '
        + '     on t.rdb$type = f.rdb$field_type '
        + '  where upper(p.rdb$procedure_name) = '
        +          QuotedStr(AnsiUpperCase(AProcedure))
        + '    and t.rdb$field_name = ''RDB$FIELD_TYPE'' '
        + '  order by r.rdb$parameter_type, r.rdb$parameter_number ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      fonte := FieldByName('rdb$procedure_source').AsString;
      nome := FieldByName('rdb$parameter_name').AsString;
      dominio := FieldByName('rdb$field_source').AsString;
      subTipo := FieldByName('rdb$field_sub_type').AsString;
      segmento := FieldByName('rdb$segment_length').AsString;
      caractere := '';

      if FieldByName('rdb$character_set_id').AsString <> '' then
      begin
        ssql := ' select rdb$character_set_name '
              + '   from rdb$character_sets '
              + '  where rdb$character_set_id = '
              +          FieldByName('rdb$character_set_id').AsString;

        caractere := ExecutaQuery(ssql);
        if caractere <> '' then
          caractere := 'CHARACTER SET ' + caractere;
      end;

      tipo := FieldByName('rdb$type_name').AsString;

      if tipo = 'DOUBLE' then
      begin
        tipo := 'DOUBLE PRECISION';
      end
      else
      if tipo = 'BLOB' then
      begin
        if subTipo <> '' then
          tipo := tipo + ' SUB_TYPE ' + subTipo;
        if segmento <> '' then
          tipo := tipo + ' SEGMENT SIZE ' + segmento;
      end
      else
      if tipo = 'TEXT' then
      begin
        tipo := 'CHAR(' + FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipo = 'VARYING' then
      begin
        tipo := 'VARCHAR(' + FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipo = 'SHORT' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'SMALLINT'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' + FieldByName('rdb$field_precision').AsString +
            ', ' + IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) + ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipo = 'LONG' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'INTEGER'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipo = 'INT64' then
      begin
        if (FieldByName('rdb$field_sub_type').AsInteger = 0) then
        begin
          tipo := 'INT64';
        end
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := tipo + 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end;

      if FieldByName('rdb$parameter_type').AsInteger = 0 then
      begin
        Ent := Ent + nome + ' ' + tipo;
        if caractere <> '' then
          Ent := Ent + ' ' + caractere;
        Ent := Ent + ',' + #13#10;
        tsEnt.Add(Ent);
      end;

      if FieldByName('rdb$parameter_type').AsInteger = 1 then
      begin
        Sai := Sai + nome + ' ' + tipo;
        if caractere <> '' then
          Sai := Sai + ' ' + caractere;
        Sai := Sai + ',' + #13#10;
        tsSai.Add(Sai);
      end;

      Next;
    end;
  end;

  qryX.Free;

  if Ent <> '' then
  begin
    I := tsEnt.Count - 1;
    Ent := tsEnt.Strings[I];
    Delete(Ent, Length(Ent) - 2, 2);
  end;

  if Sai <> '' then
  begin
    I := tsSai.Count - 1;
    Sai := tsSai.Strings[I];
    Delete(Sai, Length(Sai) - 2, 2);
  end;

  if (Ent <> '') or (Sai <> '') then
  begin
    Result.Add('SET TERM ^ ; ');
    Result.Add('');
    Result.Add('CREATE PROCEDURE ' + AProcedure);
    Result.Add('(');

    if (Ent <> '') then
    begin
      Result.Add(Trim(Ent));
      Result.Add(')');
    end;

    if (Sai <> '') then
    begin
      Result.Add('RETURNS');
      Result.Add('(');
      Result.Add(Trim(Sai));
      Result.Add(')');
    end;

    Result.Add('AS');
    Result.Add('BEGIN EXIT; END ^');

    Result.Add('');
    Result.Add('ALTER PROCEDURE ' + AProcedure);
    Result.Add('(');
    if (Ent <> '') then
    begin
      Result.Add(Trim(Ent));
      Result.Add(')');
    end;

    if (Sai <> '') then
    begin
      Result.Add('RETURNS');
      Result.Add('(');
      Result.Add(Trim(Sai));
      Result.Add(')');
    end;

    Result.Add('AS');
    Result.Add(fonte);
    Result.Add('^');
    Result.Add('');
    Result.Add('SET TERM ; ^ ');
  end;
end;

function TfDAC.GetGeneratorDDL(AGenerator: string): string;
begin
  Result := '';
  if AGenerator <> '' then
    Result := 'CREATE GENERATOR ' + AGenerator + ';';
end;

function TfDAC.GetTriggerDDL(ATrigger: string): string;
var
  ssql: string;
  qryX: TFDQuery;
  S: string;
begin
  S := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$trigger_name '
        + '      ,  rdb$relation_name '
        + '      , rdb$trigger_source '
        + '      ,  rdb$trigger_sequence '
        + '      , case rdb$trigger_type '
        + '          when 1   then ''BEFORE INSERT'' '
        + '          when 2   then ''AFTER INSERT'' '
        + '          when 3   then ''BEFORE UPDATE'' '
        + '          when 4   then ''AFTER UPDATE'' '
        + '          when 5   then ''BEFORE DELETE'' '
        + '          when 6   then ''AFTER DELETE'' '
        + '          when 17  then ''BEFORE INSERT OR UPDATE'' '
        + '          when 18  then ''AFTER INSERT OR UPDATE'' '
        + '          when 25  then ''BEFORE INSERT OR Delete'' '
        + '          when 26  then ''AFTER INSERT OR DELETE'' '
        + '          when 27  then ''BEFORE UPDATE OR DELETE'' '
        + '          when 28  then ''AFTER UPDATE OR DELETE'' '
        + '          when 113 then ''BEFORE INSERT OR UPDATE OR DELETE'' '
        + '          when 114 then ''AFTER INSERT OR UPDATE OR DELETE'' '
        + '          else rdb$trigger_type '
        + '        end as rdb$trigger_type '
        + '      , case rdb$trigger_inactive '
        + '          when 0 then ''Active'' '
        + '          when 1 then ''Inative'' '
        + '        end as rdb$trigger_inactive '
        + '   from rdb$triggers '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '    and upper(rdb$trigger_name) = '
        +          QuotedStr(AnsiUpperCase(ATrigger));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if RecordCount = 0 then Exit;
    S := 'SET TERM ^' + ' ; ' + #13#10 + #13#10;
    S := S + 'CREATE TRIGGER ' + ATrigger + ' FOR ' +
             FieldByName('rdb$relation_name').AsString + #13#10;
    S := S + FieldByName('rdb$trigger_inactive').AsString + ' ' +
             FieldByName('rdb$trigger_type').AsString + ' POSITION ' +
             FieldByName('rdb$trigger_sequence').AsString + #13#10;
    S := S + FieldByName('rdb$trigger_source').AsString + #13#10;
    S := S + '^' + #13#10 + #13#10;
    S := S + 'SET TERM ' + ' ; ' + '^';
  end;

  Result := S;
  qryX.Free;
end;

function TfDAC.GetExceptionDDL(AException: string): string;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$exception_name, '
        + '        rdb$message '
        + '   from rdb$exceptions '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '    and upper(rdb$exception_name) = '
        +          QuotedStr(AnsiUpperCase(AException));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if RecordCount > 0 then
      Result := 'CREATE EXCEPTION ' +
        FieldByName('rdb$exception_name').AsString + ' ' +
        QuotedStr(FieldByName('rdb$message').AsString) + ';';
  end;

  qryX.Free;
end;

function TfDAC.GetFunctionDDL(AFunction: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  parametro, nome, entryPoint, moduleName, tipoDado, retorno: string;
  tsEnt: TStrings;
  tsSai: TStrings;
  S, Ent, Sai: string;
  I: Integer;
begin
  AFunction := AnsiUpperCase(AFunction);
  Result := TStringList.Create;
  tsEnt := TStringList.Create;
  tsSai := TStringList.Create;
  Ent := '';
  Sai := '';

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select f.rdb$function_name, '
        + '        f.rdb$module_name, '
        + '        f.rdb$entrypoint, '
        + '        f.rdb$return_argument, '
        + '        a.rdb$field_type, '
        + '        a.rdb$field_scale, '
        + '        a.rdb$field_length, '
        + '        a.rdb$field_precision,'
        + '        a.rdb$field_sub_type, '
        + '        a.rdb$argument_position, '
        + '        t.rdb$type_name '
        + '   from rdb$functions f, '
        + '        rdb$function_arguments a, '
        + '        rdb$types t '
        + '  where f.rdb$function_name = a.rdb$function_name '
        + '    and a.rdb$field_type = t.rdb$type '
        + '    and t.rdb$field_name = ' + QuotedStr('RDB$FIELD_TYPE')
        + '    and upper(f.rdb$function_name) = '
        +          QuotedStr(AnsiUpperCase(AFunction))
        + '  order by f.rdb$function_name, a.rdb$argument_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      parametro := '';
      nome := FieldByName('rdb$function_name').AsString;
      entryPoint := FieldByName('rdb$entrypoint').AsString;
      moduleName := FieldByName('rdb$module_name').AsString;
      tipoDado := Trim(FieldByName('rdb$type_name').AsString);
      retorno := Trim(FieldByName('rdb$return_argument').AsString);

      if (AnsiUpperCase(nome) = 'RDB$SET_CONTEXT') or
         (AnsiUpperCase(nome) = 'RDB$GET_CONTEXT') then
        Break;

      if tipoDado = 'DOUBLE' then
      begin
        parametro := parametro + ' DOUBLE PRECISION';
      end
      else
      if tipoDado = 'TEXT' then
      begin
        parametro := parametro + ' CHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipoDado = 'VARYING' then
      begin
        parametro := parametro + ' VARCHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipoDado = 'CSTRING' then
      begin
        parametro := parametro + ' CSTRING(' +
          FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipoDado = 'SHORT' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          parametro := parametro + ' SMALLINT'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          parametro := parametro + ' NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          parametro := parametro + ' DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipoDado = 'LONG' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          parametro := parametro + ' INTEGER'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          parametro := parametro + ' NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          parametro := parametro + ' DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipoDado = 'INT64' then
      begin
        if (FieldByName('rdb$field_sub_type').AsInteger = 0) then
        begin
          parametro := parametro + ' INT64';
        end
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          parametro := parametro + ' NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          parametro := parametro + ' DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      begin
        parametro := parametro + ' ' + tipoDado;
      end;

      if (FieldByName('rdb$argument_position').AsInteger =
          FieldByName('rdb$return_argument').AsInteger) then
      begin
        parametro := parametro + ' RETURNS PARAMETER ' + retorno;
        Sai := Sai + ' ' + parametro;
        Sai := Sai + ',' + #13#10;
        tsSai.Add(Sai);
      end
      else
      begin
        Ent := Ent + ' ' + parametro;
        Ent := Ent + ',' + #13#10;
        tsEnt.Add(Ent);
      end;

      Next;
    end;
  end;

  qryX.Free;

  if (Sai <> '') then
  begin
    I := tsSai.Count - 1;
    Sai := tsSai.Strings[I];
    Delete(Sai, Length(Sai) - 2, 2);
  end;

  if (Ent <> '') or (Sai <> '') then
  begin
    Result.Add('DECLARE EXTERNAL FUNCTION ' + AFunction);
    Result.Add(#9 + Trim(Ent));
    Result.Add(#9 + Trim(Sai));
    Result.Add('ENTRY_POINT ' + QuotedStr(entryPoint) +
      ' MODULE_NAME ' + QuotedStr(moduleName) + ';');
  end;
end;

function TfDAC.GetRoleDDL(ARole: string): string;
begin
  Result := '';
  if ARole <> '' then
    Result := 'CREATE ROLE ' + ARole + ';';
end;

function TfDAC.GetDomainDDL(ADomain: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  tipo, default, nulo, caractere, ordenacao, dominio: string;
  subTipo, segmento, computedBy, validacao: string;
  S: string;
  I: Integer;
begin
  ADomain := AnsiUpperCase(ADomain);
  Result := TStringList.Create;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select f.rdb$field_name '
        + '      , f.rdb$validation_source '
        + '      , f.rdb$computed_source '
        + '      , f.rdb$default_source '
        + '      , f.rdb$field_length '
        + '      , f.rdb$field_scale '
        + '      , f.rdb$field_type '
        + '      , f.rdb$field_sub_type '
        + '      , f.rdb$segment_length '
        + '      , f.rdb$null_flag '
        + '      , f.rdb$character_length '
        + '      , f.rdb$collation_id '
        + '      , f.rdb$character_set_id '
        + '      , f.rdb$field_precision '
        + '      , t.rdb$type_name '
        + '   from rdb$fields f '
        + '   join rdb$types t '
        +'      on t.rdb$type = f.rdb$field_type '
        + '  where (f.rdb$system_flag = 0 or f.rdb$system_flag is null) '
        + '    and f.rdb$field_name not starting ''RDB$'' '
        + '    and t.rdb$field_name = ''RDB$FIELD_TYPE'' '
        + '    and f.rdb$field_name = '
        +          QuotedStr(AnsiUpperCase(ADomain));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      dominio := FieldByName('rdb$field_name').AsString;
      default := FieldByName('rdb$default_source').AsString;
      subTipo := FieldByName('rdb$field_sub_type').AsString;
      segmento := FieldByName('rdb$segment_length').AsString;
      computedBy := FieldByName('rdb$computed_source').AsString;
      validacao := FieldByName('rdb$validation_source').AsString;
      caractere := '';
      ordenacao := '';

      if FieldByName('rdb$character_set_id').AsString <> '' then
      begin
        ssql := ' select rdb$character_set_name '
              + '   from rdb$character_sets '
              + '  where rdb$character_set_id = '
              +          FieldByName('rdb$character_set_id').AsString;

        caractere := ExecutaQuery(ssql);
        if caractere <> '' then
          caractere := 'CHARACTER SET ' + caractere;
      end;

      if (FieldByName('rdb$character_set_id').AsString <> '') and
         (FieldByName('rdb$collation_id').AsString <> '') then
      begin
        ssql := ' select rdb$collation_name '
              + '   from rdb$collations '
              + '  where rdb$character_set_id = ' +
                         FieldByName('rdb$character_set_id').AsString
              + '    and rdb$collation_id = ' +
                         FieldByName('rdb$collation_id').AsString;

        ordenacao := ExecutaQuery(ssql);
        if ordenacao <> '' then
          ordenacao := 'COLLATE ' + ordenacao;
      end;

      if FieldByName('rdb$null_flag').AsInteger = 1 then
        nulo := 'NOT NULL'
      else
        nulo := '';

      tipo := FieldByName('rdb$type_name').AsString;

      if tipo = 'DOUBLE' then
      begin
        tipo := 'DOUBLE PRECISION';
      end
      else
      if tipo = 'BLOB' then
      begin
        if subTipo <> '' then
          tipo := tipo + ' SUB_TYPE ' + subTipo;
        if segmento <> '' then
          tipo := tipo + ' SEGMENT SIZE ' + segmento;
      end
      else
      if tipo = 'TEXT' then
      begin
        tipo := 'CHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipo = 'VARYING' then
      begin
        tipo := 'VARCHAR(' +
          FieldByName('rdb$field_length').AsString + ')';
      end
      else
      if tipo = 'SHORT' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'SMALLINT'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipo = 'LONG' then
      begin
        if (FieldByName('rdb$field_precision').AsInteger = 0) then
          tipo := 'INTEGER'
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end
      else
      if tipo = 'INT64' then
      begin
        if (FieldByName('rdb$field_sub_type').AsInteger = 0) then
        begin
          tipo := 'INT64';
        end
        else
        if (FieldByName('rdb$field_sub_type').AsInteger = 1) then
        begin
          tipo := 'NUMERIC(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end
        else
        if FieldByName('rdb$field_sub_type').AsInteger = 2 then
        begin
          tipo := tipo + 'DECIMAL(' +
            FieldByName('rdb$field_precision').AsString +
            ', ' +
            IntToStr(FieldByName('rdb$field_scale').AsInteger * -1) +
            ')';
        end;
      end;

      if computedBy <> '' then
      begin
        S := ' COMPUTED BY ' + computedBy;
        caractere := '';
        ordenacao := '';
        default := '';
      end
      else
      begin
        S := tipo;
      end;

      if nulo <> '' then
        S := S + ' ' + nulo;

      if default <> '' then
      begin
        S := S + ' ' + default + #13#10;
        caractere := '';
        ordenacao := '';
      end;

      if validacao <> '' then
      begin
        S := S + ' ' + validacao + #13#10;
      end;

      if caractere <> '' then
        S := S + ' ' + caractere;

      if ordenacao <> '' then
        S := S + ' ' + ordenacao;

      Next;
    end;
  end;

  qryX.Free;

  if S <> '' then
  begin
    Result.Add('CREATE DOMAIN ' + ADomain + ' AS');
    S := Trim(S);
    Result.Add(Trim(S) + ';');
  end;
end;

// ----------------------------------------
// Recuperação de metadados
// ----------------------------------------

function TfDAC.GetFieldsTable(ATable: string; AFlag: Integer): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  iType: Integer;
  iSubtype: Integer;
  iDimensions: Integer;
  S: string;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select distinct '
        + '        r.rdb$field_name, '
        + '        r.rdb$field_position, '
        + '        f.rdb$field_type, '
        + '        f.rdb$field_sub_type, '
        + '        f.rdb$dimensions '
        + '   from rdb$relation_fields r '
        + '   join rdb$fields f '
        + '     on f.rdb$field_name = r.rdb$field_source '
        + '   join rdb$types t '
        + '     on t.rdb$type = f.rdb$field_type '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and r.rdb$system_flag = ' + IntToStr(AFlag)
        + '    and t.rdb$field_name in '
        + '        (''RDB$FIELD_TYPE'', ''RDB$FIELD_SUB_TYPE'') '
        + ' order by r.rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      iType := FieldByName('rdb$field_type').AsInteger;
      iSubtype := FieldByName('rdb$field_sub_type').AsInteger;
      iDimensions := FieldByName('rdb$dimensions').AsInteger;
      if ((iType = 261) and (iSubtype <> 1)) or
         (iDimensions > 0) then
      begin
        // by pass
      end
      else
      begin
        Result.Add(FieldByName('rdb$field_name').AsString);
      end;
      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetDomainsTable(ATable: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  dominio: string;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$field_source '
        + '   from rdb$relation_fields  '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and rdb$field_source not starting ''RDB$'' '
        + '  order by rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      dominio := FieldByName('rdb$field_source').AsString;
      Result.AddStrings(GetDomainDDL(dominio));
      Result.Add('');
      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetTriggersTable(ATable: string): TStrings;
var
  ssql: string;
  qryX: TFDQuery;
  gatilho: string;
begin
  ATable := AnsiUpperCase(ATable);
  Result := TStringList.Create;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$trigger_name '
        + '   from rdb$triggers '
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '  order by rdb$trigger_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      gatilho := FieldByName('rdb$trigger_name').AsString;
      Result.Add(GetTriggerDDL(gatilho));
      Result.Add('');
      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetDomainsList: string;
var
  ssql: string;
  qryX: TFDQuery;
  contador: Integer;
  S: string;
begin
  Result := '';
  contador := 0;
  S := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$field_name '
        + '   from rdb$fields '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '    and rdb$field_name not starting ''RDB$'' '
        + '  order by rdb$field_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    while not Eof do begin
      Inc(contador);
      if S <> '' then
        S := S + ';';
      S := S + FieldByName('rdb$field_name').AsString;
      Next;
    end;
  end;

  qryX.Free;

  if S <> '' then
  begin
    Inc(Contador);
    Result := IntToStr(contador) + ';' + S;
  end;
end;

function TfDAC.GetParentTable(AIndex: string): string;
var
  ssql: string;
begin
  Result := '';
  AIndex := AnsiUpperCase(AIndex);

  ssql := ' select rdb$relation_name '
        + '   from rdb$relation_constraints '
        + '  where upper(rdb$constraint_name) = '
        +          QuotedStr(AnsiUpperCase(AIndex));

  Result := ExecutaQuery(ssql);
end;

function TfDAC.GetFieldsIndex(AIndex: string): string;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := '';
  AIndex := AnsiUpperCase(AIndex);

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$field_name '
        + '   from rdb$index_segments '
        + '  where upper(rdb$index_name) = '
        +          QuotedStr(AnsiUpperCase(AIndex))
        + '  order by rdb$field_position ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + FieldByName('rdb$field_name').AsString;
      Next;
    end;
  end;

  qryX.Free;
end;

function TfDAC.GetTables(ACombo: TComboBox; AFlag: Integer;
  AItemZero: string): Boolean;
var
  ssql: string;
  qry: TFDQuery;
  objName: string;
  ListItem: TListBoxItem;
begin
  Result := True;

  ACombo.Items.Clear;
  if AItemZero <> '' then
    ACombo.Items.Add(AItemZero);

  qry := TFDQuery.Create(Self);
  qry.Connection := FDConnection;

  if (AFlag = 0) then
  begin
    ssql := ' select rdb$relation_name as objName '
          + '   from rdb$relations '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '    and (rdb$view_source is null) '
          + '  order by rdb$relation_name ';
  end;

  if (AFlag = 1) then
  begin
  ssql := ' select rdb$relation_name as objName '
        + '   from rdb$relations '
        + '  where (rdb$system_flag = 1) '
        + '    and (rdb$view_source is null) '
        + '  order by rdb$relation_name ';
  end;

  try
    try
      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        while not Eof do begin
          objName := FieldByName('objName').AsString;
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := objName;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    except
      raise;
    end;
  finally
    qry.Close;
    qry.Free;
  end;
end;

function TfDAC.GetTables(ACombo: TComboEdit; AFlag: Integer;
  AItemZero: string): Boolean;
var
  ssql: string;
  qry: TFDQuery;
  objName: string;
begin
  Result := True;

  ACombo.Items.Clear;
  if AItemZero <> '' then
    ACombo.Items.Add(AItemZero);

  qry := TFDQuery.Create(Self);
  qry.Connection := FDConnection;

  if (AFlag = 0) then
  begin
    ssql := ' select rdb$relation_name as objName '
          + '   from rdb$relations '
          + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
          + '    and (rdb$view_source is null) '
          + '  order by rdb$relation_name ';
  end;

  if (AFlag = 1) then
  begin
  ssql := ' select rdb$relation_name as objName '
        + '   from rdb$relations '
        + '  where (rdb$system_flag = 1) '
        + '    and (rdb$view_source is null) '
        + '  order by rdb$relation_name ';
  end;

  try
    try
      with qry do begin
        Close;
        SQL.Clear;
        SQL.Add(ssql);
        Open;
        while not Eof do begin
          objName := FieldByName('objName').AsString;
          ACombo.Items.Add(objName);
          Next;
        end;
      end;
    except
      raise;
    end;
  finally
    qry.Close;
    qry.Free;
  end;
end;

function TfDAC.GetDomains(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$field_name, '
        + '        rdb$default_source, '
        + '        rdb$validation_source '
        + '   from rdb$fields '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '    and rdb$field_name not starting ''RDB$'' '
        + '  order by rdb$field_name ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;

    if ADataSet <> nil then
    begin
      TClientDataSet(ADataSet).EmptyDataSet;
      while not Eof do begin
        ADataSet.Append;
        ADataSet.FieldByName('field_name').AsString :=
          FieldByName('rdb$field_name').AsString;
        ADataSet.FieldByName('default_source').AsString :=
          FieldByName('rdb$default_source').AsString;
        ADataSet.FieldByName('validation_source').AsString :=
          FieldByName('rdb$validation_source').AsString;
        ADataSet.Post;
        Next;
      end;
    end;

    if ACombo <> nil then
    begin
      ACombo.Items.Clear;
      while not Eof do begin
        ListItem := TListBoxItem.Create(nil);
        ListItem.Text := FieldByName('rdb$field_name').AsString;
        ACombo.AddObject(ListItem);
        Next;
      end;
    end;
  end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetViews(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select v.rdb$view_name '
        + '      , v.rdb$relation_name '
        + '      , r.rdb$owner_name '
        + '   from rdb$view_relations v '
        + '   join rdb$relations r '
        + '     on r.rdb$relation_name = v.rdb$view_name '
        + '  where (r.rdb$system_flag = 0 or r.rdb$system_flag is null) '
        + '    and (r.rdb$view_source is not null) '
        + '  order by v.rdb$view_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('view_name').AsString :=
            FieldByName('rdb$view_name').AsString;
          ADataSet.FieldByName('relation_name').AsString :=
            FieldByName('rdb$relation_name').AsString;
          ADataSet.FieldByName('owner_name').AsString :=
            FieldByName('rdb$owner_name').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$view_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetProcedures(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$procedure_name, '
        + '        rdb$owner_name '
        + '   from rdb$procedures '
        + '  order by rdb$procedure_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('procedure_name').AsString :=
            FieldByName('rdb$procedure_name').AsString;
          ADataSet.FieldByName('owner_name').AsString :=
            FieldByName('rdb$owner_name').AsString;
          ADataSet.Post;
          Next;
    end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$procedure_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetRoles(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$role_name, '
        + '        rdb$owner_name '
        + '   from rdb$roles '
        + '  order by rdb$role_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('role_name').AsString :=
            FieldByName('rdb$role_name').AsString;
          ADataSet.FieldByName('owner_name').AsString :=
            FieldByName('rdb$owner_name').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$role_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetExceptions(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$exception_name, '
        + '        rdb$message '
        + '   from rdb$exceptions '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '  order by rdb$exception_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('exception_name').AsString :=
            FieldByName('rdb$exception_name').AsString;
          ADataSet.FieldByName('message').AsString :=
            FieldByName('rdb$message').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$exception_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetFunctions(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$function_name, '
        + '        rdb$entrypoint, '
        + '        rdb$module_name '
        + '   from rdb$functions '
        + '  order by rdb$function_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('function_name').AsString :=
            FieldByName('rdb$function_name').AsString;
          ADataSet.FieldByName('entrypoint').AsString :=
            FieldByName('rdb$entrypoint').AsString;
          ADataSet.FieldByName('module_name').AsString :=
            FieldByName('rdb$module_name').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$function_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetGenerators(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$generator_name '
        + '   from rdb$generators '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '  order by rdb$generator_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('generator_name').AsString :=
            FieldByName('rdb$generator_name').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$generator_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

function TfDAC.GetTriggers(ADataSet: TDataSet; ACombo: TComboBox): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
  ListItem: TListBoxItem;
begin
  Result := True;
  if (ADataSet = nil) and (ACombo = nil) then Exit;

  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$trigger_name '
        + '      , rdb$relation_name '
        + '      , rdb$trigger_source '
        + '      , rdb$trigger_sequence '
        + '      , case rdb$trigger_type '
        + '          when 1   then ''BEFORE INSERT'' '
        + '          when 2   then ''AFTER INSERT'' '
        + '          when 3   then ''BEFORE UPDATE'' '
        + '          when 4   then ''AFTER UPDATE'' '
        + '          when 5   then ''BEFORE DELETE'' '
        + '          when 6   then ''AFTER DELETE'' '
        + '          when 17  then ''BEFORE INSERT OR UPDATE'' '
        + '          when 18  then ''AFTER INSERT OR UPDATE'' '
        + '          when 25  then ''BEFORE INSERT OR Delete'' '
        + '          when 26  then ''AFTER INSERT OR DELETE'' '
        + '          when 27  then ''BEFORE UPDATE OR DELETE'' '
        + '          when 28  then ''AFTER UPDATE OR DELETE'' '
        + '          when 113 then ''BEFORE INSERT OR UPDATE OR DELETE'' '
        + '          when 114 then ''AFTER INSERT OR UPDATE OR DELETE'' '
        + '          else rdb$trigger_type '
        + '        end as rdb$trigger_type '
        + '      , case rdb$trigger_inactive '
        + '          when 0 then ''Ativo'' '
        + '          when 1 then ''Inativo'' '
        + '        end as rdb$trigger_inactive '
        + '   from rdb$triggers '
        + '  where (rdb$system_flag = 0 or rdb$system_flag is null) '
        + '  order by rdb$relation_name, rdb$trigger_name ';

    with qryX do begin
      Close;
      SQL.Clear;
      SQL.Add(ssql);
      Open;

      if ADataSet <> nil then
      begin
        TClientDataSet(ADataSet).EmptyDataSet;
        while not Eof do begin
          ADataSet.Append;
          ADataSet.FieldByName('trigger_name').AsString :=
            FieldByName('rdb$trigger_name').AsString;
          ADataSet.FieldByName('relation_name').AsString :=
            FieldByName('rdb$relation_name').AsString;
          ADataSet.FieldByName('trigger_source').AsString :=
            FieldByName('rdb$trigger_source').AsString;
          ADataSet.FieldByName('trigger_sequence').AsString :=
            FieldByName('rdb$trigger_sequence').AsString;
          ADataSet.FieldByName('trigger_type').AsString :=
            FieldByName('rdb$trigger_type').AsString;
          ADataSet.FieldByName('trigger_inactive').AsString :=
            FieldByName('rdb$trigger_inactive').AsString;
          ADataSet.Post;
          Next;
        end;
      end;

      if ACombo <> nil then
      begin
        ACombo.Items.Clear;
        while not Eof do begin
          ListItem := TListBoxItem.Create(nil);
          ListItem.Text := FieldByName('rdb$trigger_name').AsString;
          ACombo.AddObject(ListItem);
          Next;
        end;
      end;
    end;

  qryX.Close;
  qryX.Free;
end;

// ----------------------------------------
// Miscelânia
// ----------------------------------------

function TfDAC.CheckTable(ATable: string): Boolean;
var
  qryX: TFDQuery;
  ssql: string;
begin
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;
  ssql := ' select * from ' + ATable + ' where 0 = 1 ';

  try
    qryX.Open(ssql);
    Result := True;
    qryX.Free;
  except
    on E: EFDDBEngineException do begin
      qryX.Free;
      if E.Kind = ekObjNotExists then
      begin
        Result := False;
      end
      else
      begin
        raise;
      end;
    end;
  end;
end;

function TfDAC.CheckBlobField(ATable, AField: string): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := False;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select f.rdb$field_sub_type '
        + '      , t.rdb$type_name '
        + '   from rdb$relation_fields r '
        + '   join rdb$fields f '
        + '     on f.rdb$field_name = r.rdb$field_source '
        + '   join rdb$types t '
        + '     on t.rdb$type = f.rdb$field_type '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and upper(r.rdb$field_name) = '
        +          QuotedStr(AnsiUpperCase(AField))
        + '    and t.rdb$field_name = ''RDB$FIELD_TYPE'' ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if RecordCount > 0 then
    begin
      if (FieldByName('rdb$type_name').AsString = 'BLOB') and
         (FieldByName('rdb$field_sub_type').AsInteger <> 1) then
       Result := True;
    end;
  end;
end;

function TfDAC.CheckArrayField(ATable, AField: string): Boolean;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := False;
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select count(d.rdb$field_name) as contador '
        + '   from rdb$relation_fields r '
        + '   join rdb$field_dimensions d '
        + '     on d.rdb$field_name = r.rdb$field_source '
        + '  where upper(r.rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and upper(r.rdb$field_name) = '
        +          QuotedStr(AnsiUpperCase(AField));

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    if (FieldByName('contador').AsInteger <> 0) then
      Result := True;
  end;

  qryX.Free;
end;

function TfDAC.GetArraySelect(ATable, AField: string): string;
var
  ssql: string;
  qryX: TFDQuery;
  dominio: string;
  sVetor: string;
  iLower: Integer;
  iUpper: Integer;
  S: string;
  I, K: Integer;
begin
  Result := '';
  sVetor := '';
  S := '';
  ATable := AnsiUpperCase(ATable);
  AField := AnsiUpperCase(AField);
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$field_source '
        + '   from rdb$relation_fields'
        + '  where upper(rdb$relation_name) = '
        +          QuotedStr(AnsiUpperCase(ATable))
        + '    and upper(rdb$field_name) = '
        +          QuotedStr(AnsiUpperCase(AField));

  dominio := ExecutaQuery(ssql);

  ssql := ' select rdb$lower_bound, '
        + '        rdb$upper_bound '
        + '   from rdb$field_dimensions '
        + '  where upper(rdb$field_name) = '
        +          QuotedStr(AnsiUpperCase(dominio))
        + '  order by rdb$dimension ';

  with qryX do begin
    sVetor := '';
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    while not Eof do begin
      iLower := FieldByName('rdb$lower_bound').AsInteger;
      iUpper := FieldByName('rdb$upper_bound').AsInteger;
      if iLower = 0 then
      begin
        sVetor := IntToStr(iLower) + ':' + IntToStr(iUpper);
      end
      else
      begin
        if sVetor <> '' then
          sVetor := sVetor + ',';
        sVetor := sVetor + IntToStr(iUpper);
      end;
      Next;
    end;
  end;

  if sVetor <> '' then
  begin
    if AnsiPos(':', sVetor) > 0 then
    begin
      iLower := StrToInt(mc_GetPiece(sVetor, 1, ':'));
      iUpper := StrToInt(mc_GetPiece(sVetor, 2, ':'));
      for I := iLower to iUpper do begin
        if S <> '' then
          S := S + ',';
        S := S + AField + '[' + IntToStr(I) + '] as ' +
          AField + '_' + IntToStr(I);
      end;
    end
    else
    if AnsiPos(',', sVetor) > 0 then
    begin
      iLower := StrToInt(mc_GetPiece(sVetor, 1, ','));
      iUpper := StrToInt(mc_GetPiece(sVetor, 2, ','));
      for I := 1 to iLower do begin
        for K := 1 to iUpper do begin
          if S <> '' then
            S := S + ',';
          S := S + AField + '[' + IntToStr(I) + ',' +
            IntToStr(K) + '] as ' +
          AField + '_' + IntToStr(I) + '_' + IntToStr(K);
        end;
      end;
    end
    else
    begin
      iUpper := StrToInt(sVetor);
      for I := 1 to iUpper do begin
        if S <> '' then
          S := S + ',';
        S := S + AField + '[' + IntToStr(I) + '] as ' +
          AField + '_' + IntToStr(I);
      end;
    end;
  end;

  Result := S;
  qryX.Free;
end;

function TfDAC.GetCharSetName: string;
var
  ssql: string;
  qryX: TFDQuery;
begin
  Result := '';
  qryX := TFDQuery.Create(Self);
  qryX.Connection := FDConnection;

  ssql := ' select rdb$character_set_name '
        + '   from rdb$database ';

  with qryX do begin
    Close;
    SQL.Clear;
    SQL.Add(ssql);
    Open;
    Result := FieldByName('rdb$character_set_name').AsString;
  end;

  qryX.Free;
end;

end.
