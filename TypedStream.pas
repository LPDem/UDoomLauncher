unit TypedStream;

interface

uses
  SysUtils, Classes;

type
  TTypedStream = class(TMemoryStream)
  public
    function ReadBoolean: Boolean;
    function ReadCardinal: Cardinal;
    function ReadDateTime: TDateTime;
    function ReadGUID: TGUID;
    function ReadInteger: Integer;
    function ReadString: string;
    function ReadExtended: Extended;
    // ѕереводит содержимое потока в шестнадцатеричную строку
    function ToString: string; override;
    procedure WriteBoolean(const B: Boolean);
    procedure WriteCardinal(const i: Cardinal);
    procedure WriteDateTime(const D: TDateTime);
    procedure WriteGUID(const G: TGUID);
    procedure WriteInteger(const i: Integer);
    procedure WriteString(const S: string);
    procedure WriteExtended(const x: Extended);
  end;

  ETypedStream = class(Exception)
  end;

implementation

const
  ERROR_BOOLEAN = 'Ќеправильное логическое значение';

function TTypedStream.ReadBoolean: Boolean;
begin
  Read(Result, SizeOf(Result));
  if not (Result in [Low(Boolean)..High(Boolean)]) then
    raise ETypedStream.Create(ERROR_BOOLEAN);
end;

function TTypedStream.ReadCardinal: Cardinal;
begin
  Read(Result, SizeOf(Result));
end;

function TTypedStream.ReadDateTime: TDateTime;
begin
  Read(Result, SizeOf(Result));
end;

function TTypedStream.ReadExtended: Extended;
begin
  Read(Result, SizeOf(Result));
end;

function TTypedStream.ReadGUID: TGUID;
begin
  Read(Result, SizeOf(Result));
end;

function TTypedStream.ReadInteger: Integer;
begin
  Read(Result, SizeOf(Result));
end;

function TTypedStream.ReadString: string;
var
  L: Integer;
  s: AnsiString;
begin
  L := ReadInteger;
  SetLength(s, L);
  if L > 0 then
    Read(s[1], L);
  Result := UnicodeString(s);
end;

// ѕереводит содержимое потока в шестнадцатеричную строку
function TTypedStream.ToString: string;
var
  L: Integer;
  P: Int64;
  B: Byte;
begin
  L := Size;
  if L = 0 then
    Result := 'Ќет данных'
  else
  begin
    SetLength(Result, L * 3);
    Result := '';
    P := Position;
    Position := 0;
    while Position < L do
    begin
      Read(B, SizeOf(B));
      Result := Result + IntToHex(B, 2) + ' ';
    end;
    Position := P;
  end;
end;

procedure TTypedStream.WriteBoolean(const B: Boolean);
begin
  Write(B, SizeOf(B));
end;

procedure TTypedStream.WriteCardinal(const i: Cardinal);
begin
  Write(i, SizeOf(i));
end;

procedure TTypedStream.WriteDateTime(const D: TDateTime);
begin
  Write(D, SizeOf(D));
end;

procedure TTypedStream.WriteExtended(const x: Extended);
begin
  Write(x, SizeOf(x));
end;

procedure TTypedStream.WriteGUID(const G: TGUID);
begin
  Write(G, SizeOf(G));
end;

procedure TTypedStream.WriteInteger(const i: Integer);
begin
  Write(i, SizeOf(i));
end;

procedure TTypedStream.WriteString(const S: string);
var
  L: Integer;
  x: AnsiString;
begin
  x := AnsiString(S);
  L := Length(x);
  WriteInteger(L);
  if L > 0 then
    Write(x[1], L);
end;

end.
