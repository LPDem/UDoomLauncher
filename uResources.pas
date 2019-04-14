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
  LanguagePacksManager.AddResourceString('Confirmation', 'Подтверждение');
  LanguagePacksManager.AddResourceString('Question', 'Вопрос');
  LanguagePacksManager.AddResourceString('Warning', 'Предупреждение');
  LanguagePacksManager.AddResourceString('Error', 'Ошибка');
  LanguagePacksManager.AddResourceString('Message', 'Сообщение');
  LanguagePacksManager.AddResourceString('About_1', 'Автор идеи Player701');
  LanguagePacksManager.AddResourceString('About_2', 'This software shall be used for Good, not Evil');
  LanguagePacksManager.AddResourceString('ProfileDeleteConfirmation', 'Серьёзно хотите удалить этот профиль?');
  LanguagePacksManager.AddResourceString('PortDeleteConfirmation', 'Серьёзно хотите удалить этот порт?');
  LanguagePacksManager.AddResourceString('ProfileAllreadyExists', 'Такой профиль уже существует! Перезаписать его?');
  LanguagePacksManager.AddResourceString('CommandLine', 'Строка запуска');
  LanguagePacksManager.AddResourceString('HexDDWarning', 'Невозможно играть в HexDD.wad без HEXEN.WAD. Добавьте HEXEN.WAD в папку с Doom, и можно будет начать игру.');
  LanguagePacksManager.AddResourceString('CantExecute', 'Не удалось выполнить команду');
  LanguagePacksManager.AddResourceString('FileIsNotIWAD', 'Файл %s не является IWAD''ом!');
  LanguagePacksManager.AddResourceString('StrifeVoicesWarning', 'Этот IWAD нельзя подключить отдельно. Поместите его в папку со STRIFE1.wad, и он добавится автоматически!');
  LanguagePacksManager.AddResourceString('IWADAllreadyExists', 'Такой IWAD уже есть в списке!');
  LanguagePacksManager.AddResourceString('NoPorts', 'Не настроено ни одного порта Doom! Добавить новый порт?');
  LanguagePacksManager.AddResourceString('PortAllreadyExists', 'Такой порт уже есть в списке!');
  LanguagePacksManager.AddResourceString('WrongPort', 'Неизвестный порт, корректная работа не гарантируется!');
  LanguagePacksManager.AddResourceString('ModifiedVersion', 'мод. версия');
  LanguagePacksManager.AddResourceString('SetDefaultValue', 'Установить значение по умолчанию');
  LanguagePacksManager.AddResourceString('FilePropFilter', 'Все файлы (*.*)|*.*');
  LanguagePacksManager.AddResourceString('SelectFolder', 'Выберите папку');
  LanguagePacksManager.AddResourceString('Default', 'По умолчанию');
  LanguagePacksManager.AddResourceString('DefaultHint', 'Вернуть все настройки на странице к значениям по умолчанию');
  LanguagePacksManager.AddResourceString('NoEditorForType', 'Не существует визуального редактора для типа');
  LanguagePacksManager.AddResourceString('DefaultConfirmation', 'Вы серьёзно хотите сбросить с таким трудом настроенные значения?');
  LanguagePacksManager.AddResourceString('NoParamValue', 'Не указано значение параметра %s для настройки %s!');
  LanguagePacksManager.AddResourceString('WrongType', 'Недопустимый тип %s для настройки %s!');
  LanguagePacksManager.AddResourceString('WrongParamValue', 'Недопустимое значение параметра %s для настройки %s!');
  LanguagePacksManager.AddResourceString('NoParam', 'Не указан параметр %s для настройки %s!');
  LanguagePacksManager.AddResourceString('NoEndOfSection', 'Не удалось найти конец секции %s!');
  LanguagePacksManager.AddResourceString('ProcessFileError', 'Произошла ошибка во время обработки файла');
  LanguagePacksManager.AddResourceString('DependParamNotExists', 'Настройка %s, указанная в свойстве DependsOn у настройки %s, не существует!');



end.
