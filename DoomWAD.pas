unit DoomWAD;

interface

uses
  Windows, Classes, SysUtils;

type
  TDoomWADHeader = packed record
    WADType: array [0..3] of Char;
    EntriesCount: Integer;
    Directory: Integer;
  end;

  TDoomWADDirectory = packed record
    LumpData: Integer;
    LumpSize: Integer;
    LumpName: array [0..7] of Char;
  end;

  TDoomWAD = class
  private
    WADHeader: TDoomWADHeader;
    WADDirectory: array of TDoomWADDirectory;
  public
    constructor Create(const FileName: string); reintroduce;
    function IsLumpExists(const LumpName: string): Boolean;
    function IsIWAD: Boolean;
  end;

implementation

{ TDoomWAD }

constructor TDoomWAD.Create(const FileName: string);
var
  Stream: TFileStream;
  i: Integer;
begin
  inherited Create;
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    Stream.Read(WADHeader, SizeOf(TDoomWADHeader));
    Stream.Seek(WADHeader.Directory, soFromBeginning);
    SetLength(WADDirectory, WADHeader.EntriesCount);
    for i := 0 to WADHeader.EntriesCount - 1 do
      Stream.Read(WADDirectory[i], SizeOf(TDoomWADDirectory));
  finally
    Stream.Free;
  end;
end;

function TDoomWAD.IsIWAD: Boolean;
begin
  Result := AnsiSameText(WADHeader.WADType, 'IWAD');
end;

function TDoomWAD.IsLumpExists(const LumpName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Length(WADDirectory) - 1 do
    if AnsiSameText(WADDirectory[i].LumpName, LumpName) then
    begin
      Result := True;
      Exit;
    end;
end;

end.
