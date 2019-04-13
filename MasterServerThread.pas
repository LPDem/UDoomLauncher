unit MasterServerThread;

interface

uses
  Windows, Classes, HuffmanCode, MasterServerHuffman, IdUDPClient, IdGlobal,
  Contnrs;

type
  TServersListItem = record
    IP: string;
    Port: Word;
  end;

  TDoomServer = class
  public
    IP: string;
    Port: Word;
    Ping: Cardinal;
    Version: string;
    Name: string;
  end;

  TMasterServerThread = class(TThread)
  private
    FIdUDPClient: TIdUDPClient;
    FHuffmanCode: THuffmanCode;
  protected
    FServersList: array of TServersListItem;
    FServers: TObjectList;
    FServerListUpdated: Boolean;
    procedure Execute; override;
    procedure QueryMasterServer;
    procedure QueryServer(const IP: string; const Port: Word);
    function ProcessAnswer: Boolean;
    function ReadString(const Buffer: TIdBytes; var Index: Integer): string;
    function GetServer(const IP: string; const Port: Word): TDoomServer;
    procedure DeleteOldServers;
  public
    UpdateProc: TThreadMethod;
    property Servers: TObjectList read FServers;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

const
  SQF_NAME = $00000001;
  SQF_URL = $00000002;
  SQF_EMAIL = $00000004;
  SQF_MAPNAME = $00000008;
  SQF_MAXCLIENTS = $00000010;
  SQF_MAXPLAYERS = $00000020;
  SQF_PWADS = $00000040;
  SQF_GAMETYPE = $00000080;
  SQF_GAMENAME = $00000100;
  SQF_IWAD = $00000200;
  SQF_FORCEPASSWORD = $00000400;
  SQF_FORCEJOINPASSWORD = $00000800;
  SQF_GAMESKILL = $00001000;
  SQF_BOTSKILL = $00002000;
  SQF_DMFLAGS = $00004000;
  SQF_LIMITS = $00010000;
  SQF_TEAMDAMAGE = $00020000;
  SQF_TEAMSCORES = $00040000; // Deprecated
  SQF_NUMPLAYERS = $00080000;
  SQF_PLAYERDATA = $00100000;
  SQF_TEAMINFO_NUMBER = $00200000;
  SQF_TEAMINFO_NAME = $00400000;
  SQF_TEAMINFO_COLOR = $00800000;
  SQF_TEAMINFO_SCORE = $01000000;
  SQF_TESTING_SERVER = $02000000;
  SQF_DATA_MD5SUM = $04000000;

{ TMasterServerThread }

constructor TMasterServerThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FIdUDPClient := TIdUDPClient.Create(nil);
  FHuffmanCode := THuffmanCode.Create(MasterServerHuffmanTree);
  FServers := TObjectList.Create(True);
end;

procedure TMasterServerThread.DeleteOldServers;
var
  i, j: Integer;
  F: Boolean;
begin
  for i := FServers.Count - 1 downto 0 do
  begin
    F := False;
    for j := 0 to Length(FServersList) - 1 do
      if (FServersList[j].IP = TDoomServer(FServers[i]).IP) and (FServersList[j].Port = TDoomServer(FServers[i]).Port) then
      begin
        F := True;
        Break;
      end;
    if not F then
      FServers.Delete(i);
  end;
end;

destructor TMasterServerThread.Destroy;
begin
  FIdUDPClient.Free;
  FHuffmanCode.Free;
  FServers.Free;
  inherited Destroy;
end;

procedure TMasterServerThread.Execute;
var
  i: Integer;
  Time1, Time2, Time3: Cardinal;
  NeedUpdate: Boolean;
begin
  FIdUDPClient.Host := 'skulltag.servegame.com';
  FIdUDPClient.Port := 15300;
  FIdUDPClient.ReceiveTimeout := 1;
  Time1 := 0;
  Time2 := 0;
  Time3 := 0;
  NeedUpdate := False;
  FServerListUpdated := False;
  while not Terminated do
  begin
    if GetTickCount - Time1 >= 60 * 1000 then
    begin
      QueryMasterServer;
      Time1 := GetTickCount;
    end;
    NeedUpdate := ProcessAnswer or NeedUpdate;
    if FServerListUpdated or (GetTickCount - Time2 >= 10 * 1000) then
    begin
      for i := 0 to Length(FServersList) - 1 do
      begin
        QueryServer(FServersList[i].IP, FServersList[i].Port);
        NeedUpdate := ProcessAnswer or NeedUpdate;
        if Terminated then
          Exit;
      end;
      Time2 := GetTickCount;
      FServerListUpdated := False;
    end;
    if NeedUpdate and (GetTickCount - Time3 >= 1 * 1000) then
    begin
      if Assigned(UpdateProc) then
        Synchronize(UpdateProc);
      Time3 := GetTickCount;
      NeedUpdate := False;
    end;
  end;
end;

function TMasterServerThread.GetServer(const IP: string; const Port: Word): TDoomServer;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FServers.Count - 1 do
    if (TDoomServer(FServers[i]).IP = IP) and (TDoomServer(FServers[i]).Port = Port) then
    begin
      Result := TDoomServer(FServers[i]);
      Break;
    end;
  if not Assigned(Result) then
  begin
    Result := TDoomServer.Create;
    FServers.Add(Result);
    Result.IP := IP;
    Result.Port := Port;
  end;
end;

function TMasterServerThread.ProcessAnswer: Boolean;
var
  BufferIn, BufferOut: TIdBytes;
  Len: Integer;
  IP: string;
  Port: Word;
  Count: Integer;
  k: Integer;
  ServersCount: Integer;
  Flags: Cardinal;
  Server: TDoomServer;
begin
  SetLength(BufferIn, FIdUDPClient.BufferSize);
  try
    Count := FIdUDPClient.ReceiveBuffer(BufferIn, IP, Port);
  except
    Count := 0;
  end;
  Result := Count > 0;
  if not Result then
    Exit;

  SetLength(BufferIn, Count);
  Len := FHuffmanCode.Decode(@BufferIn[0], nil, Length(BufferIn), 0);
  SetLength(BufferOut, Len);
  FHuffmanCode.Decode(@BufferIn[0], @BufferOut[0], Length(BufferIn), Len);

  if Length(BufferOut) > 4 then
  begin
    if (PInteger(@BufferOut[0]))^ = 0 then
    begin
      SetLength(FServersList, 0);
      ServersCount := 0;
      k := 4;
      while BufferOut[k] <> 2 do
      begin
        SetLength(FServersList, ServersCount + 1);
        FServersList[ServersCount].IP := IntToStr(BufferOut[k + 1]) + '.' +
          IntToStr(BufferOut[k + 2]) + '.' + IntToStr(BufferOut[k + 3]) + '.' + IntToStr(BufferOut[k + 4]);
        FServersList[ServersCount].Port := (PWord(@BufferOut[k + 5]))^;
        Inc(ServersCount);
        k := k + 7;
      end;
      DeleteOldServers;
      FServerListUpdated := True;
    end
    else
    if (PInteger(@BufferOut[0]))^ = 5660023 then
    begin
      Server := GetServer(IP, Port);
      k := 4;
      // Ping
      Server.Ping := GetTickCount - PDWord(@BufferOut[k])^;
      Inc(k, 4);
      // Version
      Server.Version := ReadString(BufferOut, k);
      // Flags
      Flags := PDWord(@BufferOut[k])^;
      Inc(k, 4);
      // Name
      if (Flags and SQF_NAME) <> 0 then
        Server.Name := ReadString(BufferOut, k);

    end;
  end;
end;

procedure TMasterServerThread.QueryMasterServer;
var
  BufferIn, BufferOut: TIdBytes;
  Len: Integer;
begin
  SetLength(BufferIn, 4);
  BufferIn[0] := 199;
  BufferIn[1] := 0;
  BufferIn[2] := 0;
  BufferIn[3] := 0;
  Len := FHuffmanCode.Encode(@BufferIn[0], nil, Length(BufferIn), 0);
  SetLength(BufferOut, Len);
  FHuffmanCode.Encode(@BufferIn[0], @BufferOut[0], Length(BufferIn), Len);
  FIdUDPClient.SendBuffer(BufferOut);
end;

procedure TMasterServerThread.QueryServer(const IP: string; const Port: Word);
var
  BufferIn, BufferOut: TIdBytes;
  Len: Integer;
  Flags: Cardinal;
begin
  Flags := SQF_NAME;
  SetLength(BufferIn, 12);
  BufferIn[0] := 199;
  BufferIn[1] := 0;
  BufferIn[2] := 0;
  BufferIn[3] := 0;
  PDWord(@BufferIn[4])^ := Flags;
  PDWord(@BufferIn[8])^ := GetTickCount;
  Len := FHuffmanCode.Encode(@BufferIn[0], nil, Length(BufferIn), 0);
  SetLength(BufferOut, Len);
  FHuffmanCode.Encode(@BufferIn[0], @BufferOut[0], Length(BufferIn), Len);
  FIdUDPClient.SendBuffer(IP, Port, BufferOut);
end;

function TMasterServerThread.ReadString(const Buffer: TIdBytes; var Index: Integer): string;
var
  k: Integer;
begin
  k := Index;
  while Buffer[Index] <> 0 do
    Inc(Index);
  SetLength(Result, Index - k);
  if Length(Result) > 0 then
    CopyMemory(@Result[1], @Buffer[k], Length(Result));
  Inc(Index);
end;

end.
