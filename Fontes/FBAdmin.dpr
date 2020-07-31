program FBAdmin;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uDAC in 'uDAC.pas' {fDAC: TDataModule},
  uxFuncs in 'uxFuncs.pas',
  uxForm in 'uxForm.pas' {fxForm},
  uTabela in 'uTabela.pas' {fTabela},
  uRegistrarBanco in 'uRegistrarBanco.pas' {fRegistrarBanco},
  uCriarBanco in 'uCriarBanco.pas' {fCriarBanco},
  uGatilho in 'uGatilho.pas' {fGatilho},
  uVisao in 'uVisao.pas' {fVisao},
  uGerador in 'uGerador.pas' {fGerador},
  uExcecao in 'uExcecao.pas' {fExcecao},
  uPapel in 'uPapel.pas' {fPapel},
  uProcedimento in 'uProcedimento.pas' {fProcedimento},
  uFuncao in 'uFuncao.pas' {fFuncao},
  uCriarTabela in 'uCriarTabela.pas' {fCriarTabela},
  uCriarFuncao in 'uCriarFuncao.pas' {fCriarFuncao},
  uCriarGerador in 'uCriarGerador.pas' {fCriarGerador},
  uCriarExcecao in 'uCriarExcecao.pas' {fCriarExcecao},
  uDominio in 'uDominio.pas' {fDominio},
  uCriarDominio in 'uCriarDominio.pas' {fCriarDominio},
  uCriarPapel in 'uCriarPapel.pas' {fCriarPapel},
  uCriarProcedimento in 'uCriarProcedimento.pas' {fCriarProcedimento},
  uCriarVisao in 'uCriarVisao.pas' {fCriarVisao},
  uCriarGatilho in 'uCriarGatilho.pas' {fCriarGatilho},
  uEditorSQL in 'uEditorSQL.pas' {fEditorSQL},
  uEditorScript in 'uEditorScript.pas' {fEditorScript},
  uBackup in 'uBackup.pas' {fBackup},
  uRestore in 'uRestore.pas' {fRestore},
  uGerenciarUsuario in 'uGerenciarUsuario.pas' {fGerenciarUsuario},
  uPrivilegio in 'uPrivilegio.pas' {fPrivilegio},
  uCriarTabela2 in 'uCriarTabela2.pas' {fCriarTabela2},
  uTeste in 'uTeste.pas' {fTeste},
  uHeader in 'uHeader.pas' {fHeader},
  uMensagem in 'uMensagem.pas' {fMensagem},
  uEstatistica in 'uEstatistica.pas' {fEstatistica};

{$R *.res}
{$R uac.res}

begin
  Application.Initialize;
  Application.CreateForm(TfDAC, fDAC);
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
