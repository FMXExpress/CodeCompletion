unit uMain;

interface

uses
  System.JSON, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections, System.DateUtils, System.Rtti, System.Threading,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.IOUtils, System.Actions, FMX.ActnList,
  FMX.Menus, FMX.StdCtrls, FMX.Layouts, FMX.Memo,
  OXmlPDOM, uLogTest, uCodeCompleteInfo, FMX.Objects, FMX.TreeView,
  FMX.Controls.Presentation, FMX.Edit,
  SimpleParser.Lexer.Types, FMX.TMSBaseControl, FMX.TMSMemo, FMX.TabControl,
  FMX.TMSMemoStyles, FMX.ListBox,
  {$IFDEF VER290}
    FMX.ScrollBox,
  {$ENDIF}
   FMX.TextLayout;

type
  TForm3 = class(TForm)
    dlgOpen1: TOpenDialog;
    actlst1: TActionList;
    act1: TAction;
    act2: TAction;
    btn1: TButton;
    act3: TAction;
    mmo1: TMemo;
    tvClasses: TTreeView;
    lyt1: TLayout;
    txt2: TText;
    mmo2: TMemo;
    lyt2: TLayout;
    btnFind: TButton;
    txt3: TEdit;
    btn2: TButton;
    btn3: TButton;
    GridLayout1: TGridLayout;
    Text1: TText;
    tbc1: TTabControl;
    tbtm1: TTabItem;
    tbtm2: TTabItem;
    tbtm3: TTabItem;
    tbtm4: TTabItem;
    mmo4: TMemo;
    mmoEditor: TTMSFMXMemo;
    Button1: TButton;
    stBookTile1: TStyleBook;
    tFlyParse: TTimer;
    Layout1: TLayout;
    Text2: TText;
    tbtm5: TTabItem;
    Switch1: TSwitch;
    mmo3: TMemo;
    txt1: TText;
    txt4: TText;
    tmsfmxmpsclstylr: TTMSFMXMemoPascalStyler;
    tmsfmxmGetToken: TTMSFMXMemo;
    procedure act1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure mmoEditorCursorChange(Sender: TObject);
    procedure mmoEditorGetAutoCompletionList(Sender: TObject; AToken: string;
      AList: TStringList);
    procedure mmoEditorInsertAutoCompletionEntry(Sender: TObject;
      var AEntry: string);
    procedure mmoEditorUndoChange(Sender: TObject; CanUndo, CanRedo: Boolean);
    procedure ChangeCode(const ACode : string);
    procedure Button1Click(Sender: TObject);
    procedure mmoEditorAutoCompletionCustomizeList(Sender: TObject;
      AAutoCompletionList: TMemoComboListBox);
    procedure mmoEditorAutoCompletionCustomizeItem(Sender: TObject;
      AAutoCompletionItem: TListBoxItem);
    procedure menuAutoCompleteListApplyStyleLookup(Sender: TObject);
    procedure tFlyParseTimer(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
    procedure mmoEditorKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure mmoEditorBeforeAutoCompletion(Sender: TObject; AToken: string;
      var Show: Boolean);
  private
    { Private declarations }
    FCurrentPltform : string;
    FCodeList : TStringList;
    FToken : string;
    FLock : Boolean;
    FOpenParam : Boolean;
    FBktPos : TPoint;
    function Parse(const FileName: string): string;
    function ParseContent(const Content: string): string;
    function GetWIdthText(AObj : TText) : Single;
    procedure BuildTv(Info : TCodeCompleteInfo);
    function FindFullToken(const CurX,CurY : Integer) : string;
    procedure SetOpenParam(const Value: Boolean);
  public
    { Public declarations }
    property OpenParam : Boolean read FOpenParam write SetOpenParam;
  end;
  TIncludeHandler = class(TInterfacedObject, IIncludeHandler)
  private
    FPath: string;
  public
    constructor Create(const Path: string);
    function GetIncludeFileContent(const FileName: string): string;
  end;
var
  Form3: TForm3;
  Info : TCodeCompleteInfo;


implementation
uses
  DelphiAST, DelphiAST.Writer, DelphiAST.Classes, DelphiAST.Consts,
  uHelper.SyntaxNode, uCOnst, uSerializer, uUnit;
var
    Testst : string;
    SyntaxTree_: TSyntaxNode;
{$R *.fmx}

procedure TForm3.act1Execute(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    try
      mmoEditor.Lines.LoadFromFile(dlgOpen1.FileName);
      //o1.Lines.Text := ParseContent(mmoEditor.Lines.Text);//Parse(dlgOpen1.FileName);
      self.tbc1.ActiveTab := self.tbtm4;
      if Info.ParseFromFile(dlgOpen1.FileName, FCurrentPltform, True) then
      begin
        BuildTv(Info);
      end;
    except
      on E: EParserException do
        mmo1.Lines.Add(Format('[%d, %d] %s', [E.Line, E.Col, E.Message]));
    end;
  end;
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
    Info.LoadUnits;
    mmo3.Text := Info.Log.Text;
    BuildTv(Info);
end;

procedure TForm3.btn3Click(Sender: TObject);
begin
    Info.SaveUnits;
    mmo3.Text := Info.Log.Text;
end;

procedure TForm3.btnFindClick(Sender: TObject);
var
    AValue: TList<string>;
begin
    mmo2.Lines.Clear;
    if Info.TryGetValue(txt3.Text, AValue) then begin
        mmo2.Lines.AddStrings(AValue.ToArray);
    end;
end;

procedure TForm3.BuildTv(Info: TCodeCompleteInfo);
var
    tvItem : TTreeViewItem;
    LUnit : TUnit;
    I: Integer;
begin
    mmo2.Lines.Clear;
    for lunit in Info.UnitList do
        mmo2.Lines.Add(lunit.Name);
    exit;
    tvClasses.Clear;
    tvClasses.BeginUpdate;
    for LUnit in Info.UnitList do
    begin
        tvItem := LUnit.TvItem;
        tvItem.Parent := tvClasses;
    end;
    tvClasses.EndUpdate;
    tvClasses.ExpandAll;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
    Info.PathList.Text := mmo4.Text;
end;

procedure TForm3.ChangeCode(const ACode: string);
var
    temp : string;
    LmSecCount : Integer;
    LNow : TDateTime;
    LTask : ITask;
begin
    if FCodeList.Text.Contains(ACode) then
        exit;
    FCodeList.Text := ACode;
    if Assigned(LTask) then
        exit;
    LTask := TTask.Create(
        procedure
        var
            LText : string;
        begin
            try
                LNow := Now;
                temp := ParseContent(ACode);
                if Info.Parse(temp, True) then
                    LText := 'Success';
            except
                on E: EParserException do
                    LText := (Format('[%d, %d] %s', [E.Line, E.Col, E.Message]));
            end;
            LmSecCount := MilliSecondsBetween(Now, LNow);
            TThread.Queue(nil,
                procedure
                begin
                    Caption := LText + ' Time : ' + string.Parse(LmSecCount);
                end);
        end
    );
    LTask.Start;
end;

function TForm3.FindFullToken(const CurX, CurY: Integer): string;
    procedure FillList(var AList : TList<Integer>; APos : Integer;
        AText, AFindText : string);
    var
        i :Integer;
    begin
        i := APos;
        while i > 0 do
        begin
            AList.Add(i);
            i := Pos(AFindText, AText, i + 1);
        end;
    end;
    function GetToken(const AText : string) : string;
    begin
        self.tmsfmxmGetToken.Clear;
        tmsfmxmGetToken.Lines.Text := AText;
        Result := tmsfmxmGetToken.WordAtXY(AText.Length - 1, 0);
        //need for view params after "("
        FToken := tmsfmxmGetToken.TokenAtXY(AText.Length, 0);
    end;
var
    LCurX, LCurY, i, j, LFirstOpen, LFirstClose, iCLose, iOpen : Integer;
    listOpen, listClose : TList<Integer>;
    LLineText : string;
begin
    LCurX := CurX;
    listOpen := TList<Integer>.Create;
    listClose := TList<Integer>.Create;
    LLineText := self.mmoEditor.Lines[CurY];
    if LLineText.Length - 1 > CurX then
        Delete(LLineText, CUrX + 1, LLineText.Length - 1);
    LFirstOpen := Pos(TConst.OPEN, LLineText);
    LFirstClose := Pos(TConst.Close, LLineText, LFirstOpen);
    FillList(listOpen, LFirstOpen, LLineText, TConst.Open);
    FillList(listClose, LFirstClose, LLineText, TConst.Close);
    for iCLose in listClose do
    begin
        for i := listOpen.Count - 1 downto 0 do
        begin
            iOpen := listOpen[i];
            if iOpen < iCLose then
            begin
                for j := iOpen to iClose do
                    LLineText[j] := TConst.Temp;
                listOpen.Delete(i);
                Break;
            end;
        end;
    end;
    LLineText := StringReplace(LLineText, TConst.Temp, '', [rfReplaceAll]);
    Result := GetToken(LLineText.TrimLeft);
    if Result.LastIndexOf(TConst.Open) = Result.Length - 1 then
        SetLength(Result, Result.Length- 1);
    FreeAndNil(listOpen);
    FreeAndNil(listCLose);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
    FCurrentPltform := 'MSWINDOWS';
{$ENDIF}
{$IFDEF POSIX}
    FCurrentPltform := 'POSIX';
{$ENDIF}
{$IFDEF MACOS}
{$IFDEF IOS}
    FCurrentPltform := 'IOS';
{$ELSE !IOS}
    FCurrentPltform := 'MACOS';
{$ENDIF IOS}
{$ENDIF MACOS}
{$IFDEF ANDROID}
    FCurrentPltform := 'ANDROID';
{$ENDIF}

    //ReportMemoryLeaksOnShutdown := True;
    FLock := False;
    OpenParam := False;
    FBktPos.X := -1;
    FBktPos.Y := -1;
    FToken := EmptyStr;
    FCodeList := TStringList.Create;
    Info := TCodeCompleteInfo.Create;
    tmsfmxmpsclstylr.AutoCompletion.AddStrings(TConst.PASCAL_CONST);
    //temp
    Info.PathList.Text := mmo4.Text;
    info.ThreadLoad.OnExecuteStep :=
        procedure (AValue : string; ASuccess : Boolean)
        begin
            TThread.Synchronize(nil,
            procedure
            begin
               mmo3.Lines.Add(Format('Unit: %s, Success: %s', [AValue, string.Parse(ASuccess)]));
            end
            );
        end;
end;

procedure TForm3.FormDestroy(Sender: TObject);
var
  temp : string;
begin
    try
    Info.SaveUnits;
    FreeAndNil(FCodeList);
    FreeAndNil(Info);
    except
          on e : Exception do
            temp := e.Message;
    end;
end;

function TForm3.GetWIdthText(AObj : TText): Single;
var
  TextLayout: TTextLayout;
begin
  if not Assigned(AObj) then
    exit;
  TextLayout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    TextLayout.BeginUpdate;
    try
      TextLayout.Text := AObj.Text;
      TextLayout.MaxSize := TPointF.Create(1000, AObj.Height);
      TextLayout.WordWrap := false;
      TextLayout.Font := AObj.Font;
      TextLayout.HorizontalAlign := AObj.TextSettings.HorzAlign;
      TextLayout.VerticalAlign := AObj.TextSettings.VertAlign;
    finally
      TextLayout.EndUpdate;
    end;
    AObj.Width := TextLayout.TextRect.Width + AObj.Margins.Right;
    AObj.UpdateRect;
  finally
    TextLayout.Free;
  end;
end;

procedure TForm3.menuAutoCompleteListApplyStyleLookup(Sender: TObject);
var
    LListItem : TListBoxItem;
    LText : TText;
begin
    LListItem := TListBoxItem(Sender);
    if not Assigned(LListItem) then
        Exit;
    LListItem.StylesData['descript'] := TValue.From<string>(LListItem.TagString);
    LListItem.StylesData['laydetail.visible'] := TValue.From<boolean>(not LListItem.ItemData.Detail.IsEmpty);
    //LListItem.StylesData['types'] := TValue.From<string>(LListItem.ItemData.Detail);
    LText := LListItem.FindStyleResource('text') as TText;
    GetWIdthText(LText);
    LListItem.StylesData['descript.margins.left'] := LListItem.StylesData['text.width'];

end;

procedure TForm3.mmoEditorAutoCompletionCustomizeItem(Sender: TObject;
  AAutoCompletionItem: TListBoxItem);
var
    LFindList : TArray<string>;
    LText, LDetail, LDesc : string;
    i, count : Integer;
    LDelimiter : Char;
begin
    AAutoCompletionItem.OnApplyStyleLookup := menuAutoCompleteListApplyStyleLookup;
    AAutoCompletionItem.BeginUpdate;
    LText := AAutoCompletionItem.Text;
    LDelimiter := uCOnst.TConst.DELIMITER;
    LFindList := LText.Split(LDelimiter);
    count := Length(LFindList);
    for i := 0 to count - 1 do
    begin
        LFindList[i] := stringreplace(LFindList[i], TConst.SPACE_REPLACE, ' ', [rfReplaceAll]);
        case i of
            0:
            begin
                LText := LFindList[i];
                if OpenParam then
                    LText := StringReplace(LText, FToken, '', []);
            end;
            1: LDesc := LFindList[i];
            2: LDetail := LFindList[i];
        end;
    end;
    AAutoCompletionItem.Text := LText.Trim;
    AAutoCompletionItem.ItemData.Detail := LDetail;
    AAutoCompletionItem.TagString := LDesc;
    AAutoCompletionItem.EndUpdate;
    //AAutoCompletionItem.StyleName := 'menuAutoCompleteListStyle';
    AAutoCompletionItem.NeedStyleLookup;
    AAutoCompletionItem.ApplyStyleLookup;
end;

procedure TForm3.mmoEditorAutoCompletionCustomizeList(Sender: TObject;
  AAutoCompletionList: TMemoComboListBox);
begin
    AAutoCompletionList.DefaultItemStyles.ItemStyle := 'menuAutoCompleteListStyle';
  //AAutoCompletionList.DefaultItemStyles.ItemStyle := 'menuAutoCompleteListStyle';
    //AAutoCompletionList.ItemHeight := 35;
end;

procedure TForm3.mmoEditorBeforeAutoCompletion(Sender: TObject; AToken: string;
  var Show: Boolean);
var
    temp, temp2 : string;
begin      exit;        //temp;
    Caption := AToken;
    temp2 := mmoEditor.WordAtXY(mmoEditor.CurX , mmoEditor.CurY);
    temp := mmoEditor.WordAtXY(mmoEditor.CurX - 1, mmoEditor.CurY);
end;

procedure TForm3.mmoEditorCursorChange(Sender: TObject);
begin
    FLock := FLock and (mmoEditor.CurY = FBktPos.Y) and (mmoEditor.CurX + 1 > FBktPos.X);
    OpenParam := OpenParam and FLock;
    Info.FindMethod(TPoint.Create(mmoEditor.CurX,
        mmoEditor.CurY + 1));
end;

procedure TForm3.mmoEditorGetAutoCompletionList(Sender: TObject; AToken: string;
  AList: TStringList);
var
    LList : TList<string>;
    LPosPoint, i : Integer;
    LWord, TextItem : string;
begin
    AToken := FindFullToken(mmoEditor.CurX, mmoEditor.CurY);
    if Info.TryGetValue(AToken, LList, True, OpenParam) then
    begin
        AList.Clear;
        AList.AddStrings(LList.ToArray);
        // space create error fro TMSMEMO(
        AList.Text := stringreplace(AList.Text,' ', TConst.SPACE_REPLACE, [rfReplaceAll]);
        if OpenParam then
            for i := 0 to AList.Count - 1 do
                AList[i] := FToken + AList[i];
        FreeAndNil(LList);
    end ;
end;

procedure TForm3.mmoEditorInsertAutoCompletionEntry(Sender: TObject;
  var AEntry: string);
var
    LFindList : TArray<string>;
    temp : string;
    i, count : integer;
begin
    if OpenParam then
        AEntry := EmptyStr;
end;

procedure TForm3.mmoEditorKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    if KeyChar = '(' then
    begin
        FLock := True;
        OpenParam := True;
        FBktPos.X := mmoeditor.CurX;
        FBktPos.Y := mmoeditor.CurY;
    end;
    if KeyChar = ')' then
    begin
        OpenParam := False;
        mmoEditor.Popup.HidePopup;
        //FLock := False;
    end;
end;

procedure TForm3.mmoEditorUndoChange(Sender: TObject; CanUndo,
  CanRedo: Boolean);
begin
    //ChangeCode(mmoEditor.Lines.Text);
end;

function TForm3.Parse(const FileName: string): string;
var
  SyntaxTree, InterfaceTree, MethodTree: TSyntaxNode;
  temp : string;
begin
  Result := '';
  SyntaxTree := TPasSyntaxTreeBuilder.Run(FileName, False,
    TIncludeHandler.Create(ExtractFilePath(FileName)));
  try
    Result := TSyntaxTreeWriter.ToXML(SyntaxTree, True);
  finally
    SyntaxTree.Free;
  end;
end;

function TForm3.ParseContent(const Content: string): string;
var
  ASTBuilder: TPasSyntaxTreeBuilder;
  StringStream: TStringStream;
  SyntaxTree: TSyntaxNode;
begin
  Result := '';

  StringStream := TStringStream.Create(Content, TEncoding.Unicode);
  try
    StringStream.Position := 0;

    ASTBuilder := TPasSyntaxTreeBuilder.Create;
    try    //ASTBuilder.Lexer.OnElseDirect
      ASTBuilder.InitDefinesDefinedByCompiler;
      //ASTBuilder.UseDefines := True;
      //ASTBuilder.AddDefine('ANDROID');
      //ASTBuilder.AddDefine('CPUX86');
      SyntaxTree := ASTBuilder.Run(StringStream);
      SyntaxTree_ := SyntaxTree.Clone;
      try       //TTMSFMXMemo().TokenAtXY()
        Result := TSyntaxTreeWriter.ToXML(SyntaxTree, True);
      finally
        SyntaxTree.Free;
      end;
    finally
      ASTBuilder.Free;
    end;
  finally
    StringStream.Free;
  end;
end;

procedure TForm3.SetOpenParam(const Value: Boolean);
begin
    FOpenParam := Value;
    if not Value and Assigned(Info) then
        Info.PrevList.IsParam := Value;
end;

procedure TForm3.Switch1Switch(Sender: TObject);
begin
    if Switch1.IsChecked then
        Info.SerializerType := TSerializerType.stJSON
    else
        Info.SerializerType := TSerializerType.stJDO;
end;

procedure TForm3.tFlyParseTimer(Sender: TObject);
begin
    ChangeCode(mmoEditor.Lines.Text);
end;

{ TIncludeHandler }

constructor TIncludeHandler.Create(const Path: string);
begin
  inherited Create;
  FPath := Path;
end;

function TIncludeHandler.GetIncludeFileContent(const FileName: string): string;
var
  FileContent: TStringList;
begin
  FileContent := TStringList.Create;
  try
    FileContent.LoadFromFile(System.IOUtils.TPath.Combine(FPath, FileName));
    Result := FileContent.Text;
  finally
    FileContent.Free;
  end;
end;

end.
