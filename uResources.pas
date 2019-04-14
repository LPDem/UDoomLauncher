unit uResources;

interface

uses LanguagePacks;

// String by name
function SBN(const Name: string): string;

implementation

// String by name
function SBN(const Name: string): string;
begin
  Result := LanguagePacksManager.StringByName(Name);
end;

initialization
  LanguagePacksManager.AddResourceString('Confirmation', '�������������');
  LanguagePacksManager.AddResourceString('Question', '������');
  LanguagePacksManager.AddResourceString('Warning', '��������������');
  LanguagePacksManager.AddResourceString('Error', '������');
  LanguagePacksManager.AddResourceString('Message', '���������');
  LanguagePacksManager.AddResourceString('About_1', '����� ���� Player701');
  LanguagePacksManager.AddResourceString('About_2', 'This software shall be used for Good, not Evil');
  LanguagePacksManager.AddResourceString('ProfileDeleteConfirmation', '�������� ������ ������� ���� �������?');
  LanguagePacksManager.AddResourceString('PortDeleteConfirmation', '�������� ������ ������� ���� ����?');
  LanguagePacksManager.AddResourceString('ProfileAllreadyExists', '����� ������� ��� ����������! ������������ ���?');
  LanguagePacksManager.AddResourceString('CommandLine', '������ �������');
  LanguagePacksManager.AddResourceString('HexDDWarning', '���������� ������ � HexDD.wad ��� HEXEN.WAD. �������� HEXEN.WAD � ����� � Doom, � ����� ����� ������ ����.');
  LanguagePacksManager.AddResourceString('CantExecute', '�� ������� ��������� �������');
  LanguagePacksManager.AddResourceString('FileIsNotIWAD', '���� %s �� �������� IWAD''��!');
  LanguagePacksManager.AddResourceString('StrifeVoicesWarning', '���� IWAD ������ ���������� ��������. ��������� ��� � ����� �� STRIFE1.wad, � �� ��������� �������������!');
  LanguagePacksManager.AddResourceString('IWADAllreadyExists', '����� IWAD ��� ���� � ������!');
  LanguagePacksManager.AddResourceString('NoPorts', '�� ��������� �� ������ ����� Doom! �������� ����� ����?');
  LanguagePacksManager.AddResourceString('PortAllreadyExists', '����� ���� ��� ���� � ������!');
  LanguagePacksManager.AddResourceString('WrongPort', '����������� ����, ���������� ������ �� �������������!');
  LanguagePacksManager.AddResourceString('ModifiedVersion', '���. ������');
  LanguagePacksManager.AddResourceString('SetDefaultValue', '���������� �������� �� ���������');
  LanguagePacksManager.AddResourceString('FilePropFilter', '��� ����� (*.*)|*.*');
  LanguagePacksManager.AddResourceString('SelectFolder', '�������� �����');
  LanguagePacksManager.AddResourceString('Default', '�� ���������');
  LanguagePacksManager.AddResourceString('DefaultHint', '������� ��� ��������� �� �������� � ��������� �� ���������');
  LanguagePacksManager.AddResourceString('NoEditorForType', '�� ���������� ����������� ��������� ��� ����');
  LanguagePacksManager.AddResourceString('DefaultConfirmation', '�� �������� ������ �������� � ����� ������ ����������� ��������?');
  LanguagePacksManager.AddResourceString('NoParamValue', '�� ������� �������� ��������� %s ��� ��������� %s!');
  LanguagePacksManager.AddResourceString('WrongType', '������������ ��� %s ��� ��������� %s!');
  LanguagePacksManager.AddResourceString('WrongParamValue', '������������ �������� ��������� %s ��� ��������� %s!');
  LanguagePacksManager.AddResourceString('NoParam', '�� ������ �������� %s ��� ��������� %s!');
  LanguagePacksManager.AddResourceString('NoEndOfSection', '�� ������� ����� ����� ������ %s!');
  LanguagePacksManager.AddResourceString('ProcessFileError', '��������� ������ �� ����� ��������� �����');
  LanguagePacksManager.AddResourceString('DependParamNotExists', '��������� %s, ��������� � �������� DependsOn � ��������� %s, �� ����������!');



end.
