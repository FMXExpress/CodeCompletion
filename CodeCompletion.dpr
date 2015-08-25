program CodeCompletion;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form3},
  uCodeCompleteInfo in 'uCodeCompleteInfo.pas',
  uLogTest in 'uLogTest.pas',
  uParser in 'uParser.pas',
  SvCollections.Tries in 'Core\SvCollections.Tries.pas',
  uSerializerJSON in 'uSerializerJSON.pas',
  uUnit in 'uUnit.pas',
  uHelper.SyntaxNode in 'uHelper.SyntaxNode.pas',
  uHelper.SvStringTrie in 'uHelper.SvStringTrie.pas',
  DelphiAST.Classes in 'Source\AST\DelphiAST.Classes.pas',
  DelphiAST.Consts in 'Source\AST\DelphiAST.Consts.pas',
  DelphiAST in 'Source\AST\DelphiAST.pas',
  DelphiAST.Writer in 'Source\AST\DelphiAST.Writer.pas',
  SimpleParser.Lexer in 'Source\AST\SimpleParser\SimpleParser.Lexer.pas',
  SimpleParser.Lexer.Types in 'Source\AST\SimpleParser\SimpleParser.Lexer.Types.pas',
  SimpleParser in 'Source\AST\SimpleParser\SimpleParser.pas',
  SimpleParser.Types in 'Source\AST\SimpleParser\SimpleParser.Types.pas',
  OXmlPDOM in 'Source\OXML\units\OXmlPDOM.pas',
  OXmlSAX in 'Source\OXML\units\OXmlSAX.pas',
  OEncoding in 'Source\OXML\units\OEncoding.pas',
  OHashedStrings in 'Source\OXML\units\OHashedStrings.pas',
  OJSON in 'Source\OXML\units\OJSON.pas',
  OTextReadWrite in 'Source\OXML\units\OTextReadWrite.pas',
  OWideSupp in 'Source\OXML\units\OWideSupp.pas',
  OXmlCDOM in 'Source\OXML\units\OXmlCDOM.pas',
  OXmlCSeq in 'Source\OXML\units\OXmlCSeq.pas',
  OXmlDOMVendor in 'Source\OXML\units\OXmlDOMVendor.pas',
  OXmlLng in 'Source\OXML\units\OXmlLng.pas',
  OXmlPSeq in 'Source\OXML\units\OXmlPSeq.pas',
  OXmlReadWrite in 'Source\OXML\units\OXmlReadWrite.pas',
  OXmlRTTISerialize in 'Source\OXML\units\OXmlRTTISerialize.pas',
  OXmlSerialize in 'Source\OXML\units\OXmlSerialize.pas',
  OXmlUtils in 'Source\OXML\units\OXmlUtils.pas',
  OXmlXPath in 'Source\OXML\units\OXmlXPath.pas',
  OBufferedStreams in 'Source\OXML\units\OBufferedStreams.pas',
  ODictionary in 'Source\OXML\units\ODictionary.pas',
  JsonDataObjects in 'Source\JsonDataObjects.pas',
  uSerializerJDO in 'uSerializerJDO.pas',
  uConst in 'uConst.pas',
  uUnit.Helper in 'uUnit.Helper.pas',
  uSerializer in 'uSerializer.pas',
  uTest in 'TestUnit\uTest.pas',
  uThread in 'uThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
