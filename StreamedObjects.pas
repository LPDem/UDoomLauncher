unit StreamedObjects;

interface

uses
  Classes,
  Contnrs,
  TypedStream;

type
  TStreamedObject = class(TPersistent)
  protected
    FSavedVersion: Integer;
    FVersion: Integer;
    procedure LoadFromTypedStream (const Stream: TTypedStream);
      virtual; abstract;
    procedure SaveToTypedStream (const Stream: TTypedStream);
      virtual; abstract;
  public
    constructor Create; virtual;
    procedure LoadFromStream (const Stream: TTypedStream);
    procedure SaveToStream (const Stream: TTypedStream);
  end;

  TStreamedObjectClass = class of TStreamedObject;

  TStreamedObjectList = class(TStreamedObject) 
  protected
    FList: TObjectList;
    procedure LoadFromTypedStream (const Stream: TTypedStream);
      override;
    procedure ObjectCreated (const Obj: TObject); virtual;
    procedure SaveToTypedStream (const Stream: TTypedStream);
      override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property List: TObjectList read FList;
  end;

implementation

uses
  SysUtils, RTTI;

constructor TStreamedObject.Create;
begin
  inherited;
  FVersion := 1;
  FSavedVersion := 0;
end;

procedure TStreamedObject.LoadFromStream
  (const Stream: TTypedStream);
var
  Position: Int64;
begin
  Position := Stream.Position;
  FSavedVersion := Stream.ReadInteger();
  Position := Position + Stream.ReadInteger();
  LoadFromTypedStream(Stream);
  Stream.Position := Position;
end;

procedure TStreamedObject.SaveToStream
  (const Stream: TTypedStream);
var
  Size: Int64;
  SizePosition: Int64;
  EndPosition: Int64;
begin
  Size := Stream.Position;
  Stream.WriteInteger(FVersion);
  SizePosition := Stream.Position;
  Stream.WriteInteger(0);
  SaveToTypedStream(Stream);
  EndPosition := Stream.Position;
  Size := EndPosition - Size;
  Stream.Position := SizePosition;
  Stream.WriteInteger(Size);
  Stream.Position := EndPosition;
end;

constructor TStreamedObjectList.Create;
begin
  inherited;
  Flist := TObjectList.Create();
end;

destructor TStreamedObjectList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TStreamedObjectList.LoadFromTypedStream
  (const Stream: TTypedStream);
var
  i: System.Integer;
  x: TStreamedObject;
  s: System.AnsiString;
  _Class: System.TClass;
  c: TRttiContext;
  t: TRttiType;
begin
  Flist.Count := Stream.ReadInteger();
  for i := 0 to Flist.Count - 1 do
  begin
    s := Stream.ReadString();
    _Class := FindClass(s);
    c:= TRttiContext.Create;
    t := c.GetType(_Class);
    x := TStreamedObject(t.GetMethod('Create').Invoke(t.AsInstance.MetaclassType,[]).AsObject);
    c.Free;
    ObjectCreated(x);
    x.LoadFromStream(Stream);
    Flist[i] := x;
  end;
end;

procedure TStreamedObjectList.ObjectCreated (const Obj: TObject);
begin
end;

procedure TStreamedObjectList.SaveToTypedStream
  (const Stream: TTypedStream);
var
  i: Integer;
  x: TStreamedObject;
begin
  Stream.WriteInteger(FList.Count);
  for i := 0 to FList.Count - 1 do
  begin
    x := FList[i] as TStreamedObject;
    Stream.WriteString(x.ClassName);
    x.SaveToStream(Stream);
  end;
end;

initialization
begin
  RegisterClass(TStreamedObjectList);
end;

end.


