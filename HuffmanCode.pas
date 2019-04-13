unit HuffmanCode;

interface

uses
  Windows, Classes, Contnrs;

type

  THuffmanTree = array [0..255] of Real;

  THuffmanNode = class
  public
    One, Zero: THuffmanNode;
    Weight: Single;
    Value: Byte;
    Len: Byte;
    Bits: DWord;
    Parent: THuffmanNode;
    destructor Destroy; override;
  end;

  THuffmanCode = class
  private
    FLookupNodes: array [0..255] of THuffmanNode;
    FRootNode: THuffmanNode;
  protected
    procedure BuildTree(const Tree: THuffmanTree);
    function SetBit(const Bits: Byte; const Index: Byte): Byte; overload;
    function SetBit(const Bits: DWord; const Index: Byte): DWord; overload;
  public
    constructor Create(const Tree: THuffmanTree); reintroduce;
    destructor Destroy; override;
    function Encode(Source, Dest: Pointer; const SLen, DLen: Integer): Integer;
    function Decode(Source, Dest: Pointer; const SLen, DLen: Integer): Integer;
  end;

implementation

uses
  SysUtils;

function HuffmanCodeSoft(Item1, Item2: Pointer): Integer;
begin
  if THuffmanNode(Item1).Weight > THuffmanNode(Item2).Weight then
    Result := -1
  else
  if THuffmanNode(Item1).Weight < THuffmanNode(Item2).Weight then
    Result := 1
  else
    Result := 0;
end;

{ THuffmanCode }

procedure THuffmanCode.BuildTree(const Tree: THuffmanTree);
var
  FNodes: TObjectList;
  Node: THuffmanNode;
  i: Byte;
begin
  // Tree
  FNodes := TObjectList.Create(False);
  try
    for i := Low(Tree) to High(Tree) do
    begin
      Node := THuffmanNode.Create;
      FNodes.Add(Node);
      Node.One := nil;
      Node.Zero := nil;
      Node.Parent := nil;
      Node.Weight := Tree[i];
      Node.Value := i;
      FLookupNodes[i] := Node;
    end;
    while FNodes.Count > 1 do
    begin
      FNodes.Sort(HuffmanCodeSoft);
      Node := THuffmanNode.Create;
      Node.One := THuffmanNode(FNodes[FNodes.Count - 1]);
      THuffmanNode(FNodes[FNodes.Count - 1]).Parent := Node;
      Node.Zero := THuffmanNode(FNodes[FNodes.Count - 2]);
      THuffmanNode(FNodes[FNodes.Count - 2]).Parent := Node;
      Node.Weight := THuffmanNode(FNodes[FNodes.Count - 1]).Weight + THuffmanNode(FNodes[FNodes.Count - 2]).Weight;
      FNodes.Delete(FNodes.Count - 1);
      FNodes.Delete(FNodes.Count - 1);
      FNodes.Add(Node);
    end;
    FRootNode := THuffmanNode(FNodes[0]);
  finally
    FNodes.Free;
  end;
  // Lookup table
  for i := Low(Tree) to High(Tree) do
  begin
    Node := FLookupNodes[i];
    Node.Len := 0;
    Node.Bits := 0;
    while Assigned(Node.Parent) do
    begin
      if Node.Parent.One = Node then
        FLookupNodes[i].Bits := SetBit(FLookupNodes[i].Bits, FLookupNodes[i].Len);
      FLookupNodes[i].Len := FLookupNodes[i].Len + 1;
      Node := Node.Parent;
    end;
  end;
end;

constructor THuffmanCode.Create(const Tree: THuffmanTree);
begin
  inherited Create;
  BuildTree(Tree);
end;

function THuffmanCode.Decode(Source, Dest: Pointer; const SLen, DLen: Integer): Integer;
var
  NumBits: Integer;
  BitIndex: Integer;
  S: PByte;
  k: Integer;
  Node: THuffmanNode;
begin
  if PByte(Source)^ = $FF then
  begin
    Result := SLen - 1;
    if Assigned(Dest) then
    begin
      Inc(PByte(Source));
      CopyMemory(Dest, Source, SLen - 1);
    end;
  end
  else
  begin
    Result := 0;
    Node := FRootNode;
    S := Source;
    NumBits := (SLen - 1) * 8 - S^;
    Inc(S);
    BitIndex := 0;
    k := 0;
    while BitIndex < NumBits do
    begin
      while Assigned(Node.One) do
      begin
        if ((S^ shr k) AND 1) = 1 then
          Node := Node.One
        else
          Node := Node.Zero;
        Inc(BitIndex);
        Inc(k);
        if k >=8 then
        begin
          k := 0;
          Inc(S);
        end;
      end;
      Inc(Result);
      if Assigned(Dest) then
      begin
        PByte(Dest)^ := Node.Value;
        Inc(PByte(Dest));
      end;
      Node := FRootNode;
    end;
  end;
end;

destructor THuffmanCode.Destroy;
begin
  if Assigned(FRootNode) then
    FRootNode.Free;
  inherited;
end;

function THuffmanCode.Encode(Source, Dest: Pointer; const SLen, DLen: Integer): Integer;
var
  i, j: Integer;
  BitIndex: Integer;
  Bits: DWord;
  ByteIndex: Integer;
  D: PByte;
  FirstByte: PByte;
begin
  if not Assigned(Dest) then
  begin
    Result := 0;
    for i := 1 to SLen do
    begin
      Result := Result + FLookupNodes[PByte(Source)^].Len;
      Inc(PByte(Source));
    end;
    Result := 1 + (Result + 7) div 8;
  end
  else
  if DLen >= SLen + 1 then
  begin
    FirstByte := Dest;
    FirstByte^ := $FF;
    Inc(FirstByte);
    CopyMemory(FirstByte, Source, SLen);
    Result := SLen + 1;
  end
  else
  begin
    Result := 0;
    BitIndex := 0;
    ZeroMemory(Dest, DLen);
    FirstByte := Dest;
    Inc(PByte(Dest));
    for i := 1 to SLen do
    begin
      Result := Result + FLookupNodes[PByte(Source)^].Len;
      Bits := FLookupNodes[PByte(Source)^].Bits;
      for j := FLookupNodes[PByte(Source)^].Len - 1 downto 0 do
      begin
        if ((Bits shr j) AND 1) = 1 then
        begin
          ByteIndex := BitIndex div 8;
          D := Dest;
          Inc(D, ByteIndex);
          D^ := SetBit(D^, BitIndex mod 8);
        end;
        Inc(BitIndex);
      end;
      Inc(PByte(Source));
    end;
    FirstByte^ := (8 - (BitIndex mod 8)) mod 8;
    Result := 1 + (Result + 7) div 8;
  end;
end;

function THuffmanCode.SetBit(const Bits, Index: Byte): Byte;
begin
  Result := Bits OR (1 shl Index);
end;

function THuffmanCode.SetBit(const Bits: DWord; const Index: Byte): DWord;
begin
  Result := Bits OR (1 shl Index);
end;

{ THuffmanNode }

destructor THuffmanNode.Destroy;
begin
  if Assigned(One) then
    One.Free;
  if Assigned(Zero) then
    Zero.Free;
  inherited;
end;

end.
