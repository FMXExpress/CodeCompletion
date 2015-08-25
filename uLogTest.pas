unit uLogTest;

interface
uses
    System.JSON, Soap.XSBuiltIns, System.Classes, System.SysUtils,
    System.Generics.Collections, FMX.Controls, System.IniFiles;

    /// <summary>
    /// Сихнронизирвоать прцоедуру
    /// </summary>
    procedure  SynchExecute(proc : TProc);
    /// <summary>
    /// Изменение состояния контрола с синхронизацией потоков
    /// </summary>
    procedure  SetSynchronizeVisible(obj : TControl; visible : Boolean; isBringToFont : Boolean = False);
    /// <summary>
    /// Проверка JSON на Null & empty
    /// </summary>
    function ValidateJSONObject(AJsonValue : TJsonValue; var tempJson : TJSONObject) : Boolean; Overload;
    function ValidateJSONObject(AJsonValue : TJsonValue; var tempJson : string) : Boolean; Overload;
    /// <summary>
    /// Перевод UTC формат времени в обычный
    /// </summary>
    function UtcToNative(var dateTime : TDateTime; Utc : string) : Boolean;
    /// <summary>
    /// Перевод обычный формат времени в UTC
    /// </summary>
    function NativeToUtc(dateTime : TDateTime; var Utc : string) : Boolean;
const
  // TypeLibrary Major and minor versions
  MSXML2MajorVersion = 6;
  MSXML2MinorVersion = 0;
  LIBID_MSXML2: TGUID = '{F5078F18-C551-11D3-89B9-0000F81FE221}';
const
  IID_IXMLDOMNode: TGUID = '{2933BF80-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMNodeList: TGUID = '{2933BF82-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMNamedNodeMap: TGUID = '{2933BF83-7B36-11D2-B20E-00C04F983E60}';
const
  IID_IXMLDOMDocument: TGUID = '{2933BF81-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMDocumentType: TGUID = '{2933BF8B-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMImplementation: TGUID = '{2933BF8F-7B36-11D2-B20E-00C04F983E60}';
var
    FTestVar : Integer;
type
    TLogStatus = (lsBeforeSend, lsSuccess, lsFailed);
    TLogItem = record
    public
        FDate : TDateTime;
        FStatus : TLogStatus;  {
    private
        FDate2 : TDateTime;
        FStatus2 : TLogStatus;
    public
        FDate3 : TDateTime;
        FStatus3 : TLogStatus;   }
    end;
    TLog = class(TDictionary<string, TLogItem>)
    function fgdfgf : Boolean; virtual; abstract;
  private
    function GetSelf: TList<string>;
    private
        FCount2 : integer;
    published
        procedure TestTest;
    type
        TCLassing = (fdf, fgfgf, regtre);
    public
        procedure AddF(const Key : string; ls : TLogStatus; time : TDateTime);
    [SvSerialize]
        property List: TList<string> read GetSelf;
    private
        FCount : integer;
    public
        property ALIST: TList<string> read GetSelf;
        property count : Integer read FCount2 write FCount2 default 0;
    end;
    PLogItem = ^TLogItem;
    PLog = ^TLog;
var
    FLLFL : integer;
implementation
{ TLog }
{------------------------------------------------------------------------------}
procedure TLog.{dfsdfds}AddF(const Key : string; ls : TLogStatus; time : TDateTime);
var
    item : TLogItem;
    tempKey : string;
begin             TMemIniFile.Create('fdfd');
    tempKey := Key;
    self.Remove(tempKey);
    item.FDate := time;
    item.FStatus := ls;
    self.Add(tempKey, item);
end;
{------------------------------------------------------------------------------}
/// Сихнронизирвоать прцоедуру
procedure  SynchExecute(proc : TProc);
begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
        proc;
    end);
end;
{------------------------------------------------------------------------------}
/// Изменение состояния контрола с синхронизацией потоков
procedure  SetSynchronizeVisible(obj : TControl; visible : Boolean; isBringToFont : Boolean);
begin
    SynchExecute(
    procedure
    begin
        obj.Visible := visible;
        if isBringToFont then
            obj.BringToFront;
    end);
end;
{------------------------------------------------------------------------------}
/// Проверка JSON на Null & empty
function ValidateJSONObject(AJsonValue : TJsonValue; var tempJson : TJSONObject) : Boolean;
var
    res : Boolean;
    temp : string;
begin
  Result := True;
  try
    if not Assigned(AJsonValue) then
        Exit(True);
    res := AJsonValue.Null;
    temp := AJsonValue.Value;
    if res then
        Exit;
    tempJson := AJsonValue as TJSONObject;
    if not Assigned(tempJson) then
    begin
        res := true;
    end;
  except
    res := True;
  end;
  Result := res;
end;
{------------------------------------------------------------------------------}
function ValidateJSONObject(AJsonValue : TJsonValue; var tempJson : string) : Boolean;
var
    res : Boolean;
    temp : string;
begin
  Result := True;
  try
    if not Assigned(AJsonValue) then
        Exit(True);
    res := AJsonValue.Null;
    temp := AJsonValue.Value;
    if res then
        Exit;
    tempJson := temp;
  except
    res := True;
  end;
  Result := res;
end;
{------------------------------------------------------------------------------}
/// Перевод UTC формат времени в обычный
function UtcToNative(var dateTime : TDateTime; Utc : string) : Boolean;
var
    utcTime : TXsDateTime;
begin
    if Utc.IsEmpty then
        Exit;
    utcTime := TXsDateTime.Create;
    try
        utcTime.XSToNative(Utc);
        dateTime := utcTime.AsDateTime;
    finally
        FreeAndNil(utcTime);
    end;
end;
{------------------------------------------------------------------------------}
/// Перевод обычный формат времени в UTC
function NativeToUtc(dateTime : TDateTime; var Utc : string) : Boolean;
var
    utcTime : TXsDateTime;
    LocalDateTime : TDateTime;
begin
    Utc := FormatDateTime('yyyy.mm.dd', dateTime) + 'T' +
        FormatDateTime('hh:mm:ss', dateTime);//DateTimeToStr(LocalDateTime);
end;
{------------------------------------------------------------------------------}
function TLog.GetSelf: TList<string>;
var
    list : TList<string>;
begin
    list := TList<string>.Create;
    list.AddRange(['1','2','3','4','5','6','7','8','9','1']);
    Result := list;
end;

procedure TLog.TestTest;
begin

end;

end.
