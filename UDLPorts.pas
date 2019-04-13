unit UDLPorts;

interface

uses
  Windows, StreamedObjects, CheckLst, TypedStream;

type
  TPWADsList = class;

  TDoomPortType = (ptUnknown, ptZDoom, ptGZDoom, ptSkullTag);
  TDoomPortTypeSet = set of TDoomPortType;

  TPWADsList = class(TStreamedObjectList)
  public
    procedure InsertPWAD(const Index: Integer; const FileName: string);
    procedure ToListBox(const LB: TCheckListBox);
  end;

  TDoomPort = class(TStreamedObject)
  private
    FDescr: string;
    FFileName: string;
    FPortType: TDoomPortType;
    FVer: string;
    procedure SetFileName(const Value: string);
  protected
    procedure LoadFromTypedStream(const Stream: TTypedStream); override;
    procedure SaveToTypedStream(const Stream: TTypedStream); override;
  public
    constructor Create; override;
    function CmdParams(const GameType: Integer): string;
    function PortName: string;
    property Descr: string read FDescr;
    property FileName: string read FFileName write SetFileName;
    property PortType: TDoomPortType read FPortType;
    property Ver: string read FVer;
  end;

  TIWAD = class(TStreamedObject)
  private
    FPWADsList: TPWADsList;
  protected
    procedure LoadFromTypedStream(const Stream: TTypedStream); override;
    procedure SaveToTypedStream(const Stream: TTypedStream); override;
  public
    Descr: string;
    FileName: string;
    constructor Create; override;
    destructor Destroy; override;
    property PWADsList: TPWADsList read FPWADsList;
  end;

  TPWAD = class(TStreamedObject)
  protected
    procedure LoadFromTypedStream(const Stream: TTypedStream); override;
    procedure SaveToTypedStream(const Stream: TTypedStream); override;
  public
    Checked: Boolean;
    FileName: string;
  end;

  TWADVersion = record
    Hash: string;
    Version: string;
  end;

implementation

uses
  SysUtils, JvVersionInfo;

procedure TPWAD.LoadFromTypedStream(const Stream: TTypedStream);
begin
  inherited;
  FileName := Stream.ReadString;
  Checked := Stream.ReadBoolean;
end;

procedure TPWAD.SaveToTypedStream(const Stream: TTypedStream);
begin
  inherited;
  Stream.WriteString(FileName);
  Stream.WriteBoolean(Checked);
end;

constructor TIWAD.Create;
begin
  inherited;
  FPWADsList := TPWADsList.Create;
  FVersion := 2;
end;

destructor TIWAD.Destroy;
begin
  FreeAndNil(FPWADsList);
  inherited;
end;

procedure TIWAD.LoadFromTypedStream(const Stream: TTypedStream);
begin
  inherited;
  FileName := Stream.ReadString;
  Descr := Stream.ReadString;
  if FSavedVersion >= 2 then
    PWADsList.LoadFromStream(Stream);
end;

procedure TIWAD.SaveToTypedStream(const Stream: TTypedStream);
begin
  inherited;
  Stream.WriteString(FileName);
  Stream.WriteString(Descr);
  PWADsList.SaveToStream(Stream);
end;

constructor TDoomPort.Create;
begin
  inherited Create;
  FVersion := 2;
end;

function TDoomPort.CmdParams(const GameType: Integer): string;
begin
  if (GameType = 2) and (FPortType = ptSkullTag) then
    Result := '-host'
  else
    Result := '';
end;

procedure TDoomPort.LoadFromTypedStream(const Stream: TTypedStream);
begin
  inherited;
  FileName := Stream.ReadString;
  if FSavedVersion < 2 then
  begin
    FDescr := Stream.ReadString;
    FVer := Stream.ReadString;
    FPortType := TDoomPortType(Stream.ReadInteger);
  end;
end;

function TDoomPort.PortName: string;
begin
  Result := FDescr + ' ' + FVer + ' (' + FFileName + ')';
end;

procedure TDoomPort.SaveToTypedStream(const Stream: TTypedStream);
begin
  inherited;
  Stream.WriteString(FFileName);
  if FVersion < 2 then
  begin
    Stream.WriteString(FDescr);
    Stream.WriteString(FVer);
    Stream.WriteInteger(Ord(FPortType));
  end;
end;

procedure TDoomPort.SetFileName(const Value: string);
var
  VersionInfo: TJvVersionInfo;
begin
  FFileName := Value;
  VersionInfo := TJvVersionInfo.Create(FFileName);
  try
    FDescr := VersionInfo.FileDescription;
    FVer := VersionInfo.FileVersion;
    if AnsiPos('ZDoom', FDescr) >= 0 then
      FPortType := ptZDoom
    else
    if AnsiPos('GZDoom', FDescr) >= 0 then
      FPortType := ptGZDoom
    else
    if AnsiPos('SkullTag', FDescr) >= 0 then
      FPortType := ptSkullTag
    else
      FPortType := ptUnknown;
  finally
    VersionInfo.Free;
  end;
end;

procedure TPWADsList.InsertPWAD(const Index: Integer; const FileName: string);
var
  PWAD: TPWAD;
begin
  PWAD := TPWAD.Create;
  PWAD.FileName := FileName;
  PWAD.Checked := True;
  List.Insert(Index, PWAD);
end;

procedure TPWADsList.ToListBox(const LB: TCheckListBox);
var
  i, k: Integer;
  PWAD: TPWAD;
begin
  LB.Items.Clear;
  for i := 0 to List.Count - 1 do
  begin
    PWAD := TPWAD(List[i]);
    k := LB.Items.Add(PWAD.FileName);
    LB.Checked[k] := PWAD.Checked;
  end;
end;


end.
