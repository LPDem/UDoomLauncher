unit uMasterServerFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Menus, Registry, CommCtrl, Contnrs,
  MasterServerThread;

const
  DataColumnsNum = 3;

type
  TVirtualItem = class
  public
    Server: TDoomServer;
    Data: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

type
  TMasterServerFrame = class(TFrame)
    Pnl_Top: TPanel;
    LV_Servers: TListView;
    ColsPopupMenu: TPopupMenu;
    Button1: TButton;
    Lbl_Count: TLabel;
    procedure LV_ServersColumnRightClick(Sender: TObject; Column: TListColumn; Point: TPoint);
    procedure LV_ServersData(Sender: TObject; Item: TListItem);
    procedure Button1Click(Sender: TObject);
    procedure LV_ServersColumnClick(Sender: TObject; Column: TListColumn);
  private
    MasterServerThread: TMasterServerThread;
    VirtualItems: TObjectList;
    procedure UpdateProc;
  protected
    function AddColumn(const Tag: Integer): TListColumn;
    procedure DeleteColumn(const Tag: Integer);
    procedure AddDefaultColumns;
    procedure FillPopupMenu;
    procedure UpdatePopupMenu;
    function IsColumnVisible(const Tag: Integer): Boolean;
    function ColumnIndexByTag(const Tag: Integer): Integer;
    procedure OnPopupMenuItemClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadSettings(const Reg: TRegistry);
    procedure SaveSettings(const Reg: TRegistry);
  end;

implementation

uses
  TypedStream;

const
  DataColumnsName: array [0..DataColumnsNum - 1] of string =
    (
    'Name',
    'IP',
    'Ping'
    );

  DataColumnsWidth: array [0..DataColumnsNum - 1] of Integer =
    (
    150,
    100,
    50
    );

var
  FOrderColumn: Integer;
  FOrderColumnTag: Integer;    
  FOrderASC: Boolean;

{$R *.dfm}

function LV_ServersCompare(Item1, Item2: Pointer): Integer;
var
  p1, p2: Integer;
  Item1Str, Item2Str: string;
begin
  Result := 0;
  Item1Str := TVirtualItem(Item1).Data[FOrderColumnTag];
  Item2Str := TVirtualItem(Item2).Data[FOrderColumnTag];
  case FOrderColumnTag of
    0, 1:
    begin
      Result := AnsiCompareText(Item1Str, Item2Str);
      if not FOrderASC then
        Result := -1 * Result;
    end;
    2:
    begin
      p1 := StrToInt(Item1Str);
      p2 := StrToInt(Item2Str);
      if FOrderASC then
        Result := p1 - p2
      else
        Result := p2 - p1;
    end;
  end;
end;

constructor TMasterServerFrame.Create(AOwner: TComponent);
begin
  inherited;
  FOrderColumn := -1;
  FOrderASC := True;
  VirtualItems := TObjectList.Create(True);
  AddDefaultColumns;
  FillPopupMenu;
end;

destructor TMasterServerFrame.Destroy;
begin
  if Assigned(MasterServerThread) then
  begin
    MasterServerThread.Terminate;
    MasterServerThread.WaitFor;
    MasterServerThread.Free;
  end;
  VirtualItems.Free;
  inherited Destroy;
end;

procedure TMasterServerFrame.DeleteColumn(const Tag: Integer);
var
  k: Integer;
begin
  k := ColumnIndexByTag(Tag);
  LV_Servers.Columns.Delete(k);
end;

function TMasterServerFrame.AddColumn(const Tag: Integer): TListColumn;
begin
  Result := LV_Servers.Columns.Add;
  Result.Caption := DataColumnsName[Tag];
  Result.Width := DataColumnsWidth[Tag];
  Result.Tag := Tag;
end;

procedure TMasterServerFrame.AddDefaultColumns;
begin
  AddColumn(0);
  AddColumn(1);
  AddColumn(2);
end;

procedure TMasterServerFrame.Button1Click(Sender: TObject);
begin
  MasterServerThread := TMasterServerThread.Create(True);
  MasterServerThread.UpdateProc := UpdateProc;
  MasterServerThread.Resume;
end;

procedure TMasterServerFrame.FillPopupMenu;
var
  i: Integer;
  MI: TMenuItem;
begin
  for i := Low(DataColumnsName) to High(DataColumnsName) do
  begin
    MI := TMenuItem.Create(ColsPopupMenu);
    MI.Caption := DataColumnsName[i];
    MI.Tag := i;
    MI.OnClick := OnPopupMenuItemClick;
    ColsPopupMenu.Items.Add(MI);
  end;
end;

function TMasterServerFrame.IsColumnVisible(const Tag: Integer): Boolean;
begin
  Result := ColumnIndexByTag(Tag) <> -1;
end;

function TMasterServerFrame.ColumnIndexByTag(const Tag: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to LV_Servers.Columns.Count - 1 do
    if LV_Servers.Columns[i].Tag = Tag then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TMasterServerFrame.LV_ServersColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = FOrderColumn then
    FOrderASC := not (FOrderASC)
  else
  begin
    FOrderColumn := Column.Index;
    FOrderASC := True;
  end;
  FOrderColumnTag := LV_Servers.Columns[FOrderColumn].Tag;
  LV_Servers.Items.BeginUpdate;
  VirtualItems.Sort(LV_ServersCompare);
  LV_Servers.Items.EndUpdate;
end;

procedure TMasterServerFrame.LV_ServersColumnRightClick(Sender: TObject; Column: TListColumn; Point: TPoint);
begin
  UpdatePopupMenu;
  Point := LV_Servers.ClientToScreen(Point);
  ColsPopupMenu.Popup(Point.X, Point.Y);
end;

procedure TMasterServerFrame.LV_ServersData(Sender: TObject; Item: TListItem);
var
  k: Integer;
  i: Integer;
begin
  k := Item.Index;
  while Item.SubItems.Count < LV_Servers.Columns.Count do
    Item.SubItems.Add('');
  Item.Data := TVirtualItem(VirtualItems[k]).Server;
  Item.Caption := TVirtualItem(VirtualItems[k]).Data[LV_Servers.Columns[0].Tag];
  for i := 0 to LV_Servers.Columns.Count - 2 do
    Item.SubItems[i] := TVirtualItem(VirtualItems[k]).Data[LV_Servers.Columns[i + 1].Tag];
end;

procedure TMasterServerFrame.OnPopupMenuItemClick(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then
    DeleteColumn(TMenuItem(Sender).Tag)
  else
    AddColumn(TMenuItem(Sender).Tag);
end;

procedure TMasterServerFrame.LoadSettings(const Reg: TRegistry);
var
  Stream: TTypedStream;
  i: Integer;
  k: Integer;
  Tag: Integer;
  Col: TListColumn;
begin
  if Reg.ValueExists('MasterServerColumns') then
  begin
    Stream := TTypedStream.Create;
    try
      Stream.Size := Reg.GetDataSize('MasterServerColumns');
      Reg.ReadBinaryData('MasterServerColumns', PByte(Stream.Memory)^, Stream.Size);
      k := Stream.ReadInteger;
      LV_Servers.Columns.Clear;
      for i := 0 to k - 1 do
      begin
        Tag := Stream.ReadInteger;
        Col := AddColumn(Tag);
        Col.Width := Stream.ReadInteger;
      end;
      FOrderColumnTag := Stream.ReadInteger;
      FOrderColumn := ColumnIndexByTag(FOrderColumnTag);
      FOrderASC := Stream.ReadBoolean;
    finally
      Stream.Free;
    end;
  end;
end;

procedure TMasterServerFrame.SaveSettings(const Reg: TRegistry);
var
  Stream: TTypedStream;
  i: Integer;
begin
  Stream := TTypedStream.Create;
  try
    Stream.WriteInteger(LV_Servers.Columns.Count);
    for i := 0 to LV_Servers.Columns.Count - 1 do
    begin
      Stream.WriteInteger(LV_Servers.Columns[i].Tag);
      Stream.WriteInteger(LV_Servers.Columns[i].Width);
    end;
    Stream.WriteInteger(FOrderColumnTag);
    Stream.WriteBoolean(FOrderASC);
    Stream.Position := 0;
    Reg.WriteBinaryData('MasterServerColumns', PByte(Stream.Memory)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure TMasterServerFrame.UpdatePopupMenu;
var
  i: Integer;
begin
  for i := 0 to ColsPopupMenu.Items.Count - 1 do
    ColsPopupMenu.Items[i].Checked := IsColumnVisible(ColsPopupMenu.Items[i].Tag);
end;

procedure TMasterServerFrame.UpdateProc;
var
  i, j: Integer;
  F: Boolean;
  Server: TDoomServer;
  k: Integer;
  VItem: TVirtualItem;
begin
  LV_Servers.Items.BeginUpdate;

  for i := VirtualItems.Count - 1 downto 0 do
  begin
    F := False;
    for j := 0 to MasterServerThread.Servers.Count - 1 do
    begin
      Server := TDoomServer(MasterServerThread.Servers[j]);
      if TVirtualItem(VirtualItems[i]).Server = Server then
      begin
        F := True;
        Break;
      end;
    end;
    if not F then
    begin
      LV_Servers.Items.Delete(i);
      VirtualItems.Delete(i);
    end;
  end;

  for i := 0 to MasterServerThread.Servers.Count - 1 do
  begin
    Server := TDoomServer(MasterServerThread.Servers[i]);
    k := -1;
    for j := 0 to VirtualItems.Count - 1 do
      if TVirtualItem(VirtualItems[j]).Server = Server then
      begin
        k := j;
        Break;
      end;
    if k = -1 then
    begin
      VItem := TVirtualItem.Create;
      VirtualItems.Add(VItem);
      VItem.Data.Add('');
      VItem.Data.Add('');
      VItem.Data.Add('');
      VItem.Server := Server;
    end else
    begin
      VItem := TVirtualItem(VirtualItems[k]);
    end;
    VItem.Data[0] := Server.Name + ' (' + Server.Version + ')';
    VItem.Data[1] := Server.IP + ':' + IntToStr(Server.Port);
    VItem.Data[2] := IntToStr(Server.Ping);
  end;
  LV_Servers.Items.Count := VirtualItems.Count;
  if FOrderColumn <> -1 then
    VirtualItems.Sort(LV_ServersCompare);
  LV_Servers.Items.EndUpdate;
  Lbl_Count.Caption := 'Всего: ' + IntToStr(VirtualItems.Count);
end;


{ TVirtualItem }

constructor TVirtualItem.Create;
begin
  inherited Create;
  Data := TStringList.Create;
end;

destructor TVirtualItem.Destroy;
begin
  Data.Free;
  inherited;
end;

end.
