import Foundation

enum SystemMessages {
    enum Error {
        static let invalidChoice = "Неверный выбор. Попробуйте снова."
        static let contactNotFound = "Контакт с ID %d не найден"
        static let editContactFailed = "Не удалось отредактировать контакт с ID %d"
        static let emptyField = "Поле не может быть пустым. Попробуйте снова"
        static let invalidNumber = "Введите корректное числовое значение"
        static let contactsAccessDenied = "Доступ к контактам не был предоставлен."
        static let settingsOpenFailed = "Не удалось открыть системные настройки: %@"
    }
    
    enum Success {
        static let contactCreated = "Контакт успешно создан:"
        static let contactEdited = "Контакт с ID %d успешно отредактирован"
        static let contactDeleted = "Контакт с ID %d успешно удален"
        static let mainContactSet = "Основной контакт успешно установлен:"
        static let appExit = "До свидания! Спасибо за использование нашего приложения! 👋"
        static let contactsImported = "Успешно импортировано %d новых контактов."
        static let accessGranted = "Доступ получен. Синхронизируем контакты..."
        static let openingSystemSettings = "Открываю системные настройки..."
        static let openingSecuritySettings = "Открываю системные настройки безопасности..."
        static let openingAppSettings = "Открываю настройки приложения..."
    }
    
    enum Info {
        static let pressEnterToContinue = "Нажмите Enter для продолжения..."
        static let emptyContactList = "Список контактов пуст. Нажмите Enter для продолжения..."
        static let noSearchResults = "По запросу '%@' ничего не найдено."
        static let noSearchResultsWithEnter = "По запросу '%@' ничего не найдено. Нажмите Enter для продолжения..."
        static let noContactsForImport = "Новых контактов для импорта не найдено."
        static let noICloudContacts = "Не удалось найти контакты в iCloud."
        static let openSettingsManually = "Пожалуйста, откройте настройки контактов вручную."
        static let settingsNotSupported = "Автоматическое открытие настроек не поддерживается на этой платформе."
    }
    
    enum UI {
        static let backToMenuWithQ = "◀️  Если хотите вернутся в меню введите 'q'"
        static let requiredField = "✳️  Обязательное поле отмечено *"
        static let skipFieldWithEnter = "ℹ️  Нажмите Enter, чтобы пропустить заполнение поля"
        static let leaveUnchangedWithEnter = "ℹ️  Если хотите оставить поле без изменений, нажмите Enter"
    }
} 