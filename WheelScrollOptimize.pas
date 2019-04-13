unit WheelScrollOptimize;

interface

implementation

uses
  Windows, SysUtils, Controls, Messages, Forms;

type

  TInjectRec = packed record
    Jump: Byte;
    Offset: Integer;
  end;
  
  PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
  TAbsoluteIndirectJmp = packed record
    OpCode: Word;   //$FF25
    Addr: ^Pointer;
  end;

  PWin9xDebugThunk = ^TWin9xDebugThunk;
  TWin9xDebugThunk = packed record
    PUSH: Byte;    // $68
    Addr: Pointer;
    JMP: Byte;     // $E9
    Offset: Integer;
  end;

procedure TControlMouseWheelHandler(Control: TControl; var Message: TMessage);
var
  Form: TCustomForm;
  Capture: TControl;
begin
  // Так скроллинг колесом мыши работает намного лучше
  Form := GetParentForm(Control);
  Capture := GetCaptureControl;
  if Assigned(Capture) and (Capture <> Form) and (Capture <> Control) and (Capture.Parent = nil) then
    Capture.WindowProc(Message);
end;

function IsWin9xDebugThunk(Addr: Pointer): Boolean;
begin
  Result := (Addr <> nil) and (PWin9xDebugThunk(Addr).PUSH = $68) and
                              (PWin9xDebugThunk(Addr).JMP = $E9);
end;  

function GetActualAddr(Proc: Pointer): Pointer;
begin
  if Proc <> nil then
  begin
    if (SysUtils.Win32Platform <> VER_PLATFORM_WIN32_NT) and IsWin9xDebugThunk(Proc) then
      Proc := PWin9xDebugThunk(Proc).Addr;
    if (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end
  else
    Result := nil;
end;

procedure CodeRedirect(Proc: Pointer; NewProc: Pointer);
var
  OldProtect: Cardinal;
begin
  if Proc = nil then
    Exit;
  Proc := GetActualAddr(Proc);
  if VirtualProtectEx(GetCurrentProcess, Proc, SizeOf(TInjectRec), PAGE_EXECUTE_READWRITE, OldProtect) then
  begin
    TInjectRec(Proc^).Jump := $E9;
    TInjectRec(Proc^).Offset := Integer(NewProc) - (Integer(Proc) + SizeOf(TInjectRec));
    VirtualProtectEx(GetCurrentProcess, Proc, SizeOf(TInjectRec), OldProtect, @OldProtect);
  end;
end;

function GetDynamicMethod(AClass: TClass; Index: Integer): Pointer;
asm
  CALL System.@FindDynaClass
end;

initialization
  CodeRedirect(@TControl.MouseWheelHandler, @TControlMouseWheelHandler);

end.
