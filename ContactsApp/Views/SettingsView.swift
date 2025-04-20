import Foundation
import Contacts

protocol SettingsViewProtocol {
    func showSettingsMenu()
}

class SettingsView: BaseMenuView, SettingsViewProtocol {
    
    override func run() {
        showSettingsMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showSettingsMenu() {
        let menuItems = [
            "1. 🔄 Синхронизация с iCloud контактами",
            "2. 📁 Путь к файлу контактов",
            "3. 🎨 Настройки отображения",
            "4. ◀️  Назад в главное меню"
        ]
        
        showMenu(
            header: "⚙️  Настройки",
            title: "Выберите действие:",
            menuItems: menuItems
        )
    }
    
    override public func handleInput(_ input: String) {
        switch input {
        case "1": syncContacts()
        case "2": showFilePath()
        case "3": showDisplaySettings()
        case "4": router.showMainMenu()
        default:
            consoleView.displayError("Неверный выбор. Попробуйте снова.")
            run()
        }
    }
    
    private func syncContacts() {
        consoleView.clearScreen()
        consoleView.menuHeader("🔄 Синхронизация контактов")
        consoleView.menuInfoItem("Начинаем синхронизацию с iCloud контактами...")
        
        // Создаем экземпляр интерактора
        let contactsSyncInteractor = ContactsSyncInteractor()
        
        consoleView.menuInfoItem("Запрашиваем доступ к контактам...")
        let hasAccess = contactsSyncInteractor.requestAccess()
        
        if !hasAccess {
            consoleView.displayError("Доступ к контактам не был предоставлен.")
            
            // Проверяем текущий статус доступа более подробно
            let status = CNContactStore.authorizationStatus(for: .contacts)
            
            switch status {
            case .denied:
                // Пользователь ранее отклонил доступ, нужно перейти в настройки
                consoleView.menuInfoItem("""
                      ⚠️ Доступ к контактам ранее был отклонен.
                      
                      Для включения доступа к контактам необходимо изменить настройки системы.
                      """)
                
                let choice = consoleView.inputString(prompt: "Хотите открыть системные настройки конфиденциальности? (д/н): ")
                if choice.lowercased() == "д" {
                    openContactsPrivacySettings()
                    consoleView.menuInfoItem("После изменения настроек вернитесь в приложение.")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
                
            case .restricted:
                // Доступ ограничен родительским контролем или политикой организации
                consoleView.menuInfoItem("""
                      ⚠️ Доступ к контактам ограничен настройками устройства или родительским контролем.
                      
                      Пожалуйста, обратитесь к администратору устройства для разрешения доступа к контактам.
                      """)
                
                let choice = consoleView.inputString(prompt: "Хотите открыть системные настройки конфиденциальности? (д/н): ")
                if choice.lowercased() == "д" {
                    openContactsPrivacySettings()
                    consoleView.menuInfoItem("После изменения настроек вернитесь в приложение.")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
                
            default:
                // Общее сообщение для других случаев
                consoleView.menuInfoItem("Проверьте настройки конфиденциальности и предоставьте доступ к контактам.")
                
                let choice = consoleView.inputString(prompt: "Хотите открыть системные настройки конфиденциальности? (д/н): ")
                if choice.lowercased() == "д" {
                    openContactsPrivacySettings()
                    consoleView.menuInfoItem("После изменения настроек вернитесь в приложение.")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
            }
            
            let retryChoice = consoleView.inputString(prompt: "Хотите попробовать снова после изменения настроек? (д/н): ")
            if retryChoice.lowercased() == "д" {
                syncContacts() // Рекурсивно вызываем тот же метод для повторной попытки
                return
            }
            
            waitForEnter()
            return
        }
        
        // Синхронизируем контакты с основной базой данных приложения
        consoleView.displaySuccess("Доступ получен. Синхронизируем контакты...", description: nil)
        let result = contactsSyncInteractor.syncWithAppContacts()
        
        if result.total == 0 {
            consoleView.displayInfo("Не удалось найти контакты в iCloud.")
        } else {
            consoleView.menuInfoItem("📱 Найдено \(result.total) контактов в iCloud.")
            
            if result.imported > 0 {
                consoleView.displaySuccess("Успешно импортировано \(result.imported) новых контактов.", description: nil)
            } else {
                consoleView.displayInfo("Новых контактов для импорта не найдено.")
            }
        }
        
        waitForEnter()
    }
    
    private func showFilePath() {
        consoleView.clearScreen()
        consoleView.menuHeader("📁 Путь к файлу контактов")
        
        consoleView.menuItem("Текущий путь к файлу контактов: \(FileManager.default.currentDirectoryPath)/contacts.json")
        consoleView.menuItem("Путь к файлу iCloud контактов: \(FileManager.default.currentDirectoryPath)/data/icloud_contacts.json")
        
        consoleView.menuInfoItem("Функция изменения пути будет доступна в следующих версиях.")
        
        waitForEnter()
    }
    
    private func showDisplaySettings() {
        consoleView.clearScreen()
        consoleView.menuHeader("🎨 Настройки отображения")
        
        consoleView.menuInfoItem("Настройки отображения будут доступны в следующих версиях.")
        
        waitForEnter()
    }
    
    // Метод для открытия системных настроек конфиденциальности
    private func openContactsPrivacySettings() {
        #if os(macOS)
        // На macOS запускаем команду для открытия системных настроек конфиденциальности контактов
        let process = Process()
        process.launchPath = "/usr/bin/open"
        
        // Открываем настройки конфиденциальности
        process.arguments = ["x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"]
        
        do {
            try process.run()
            consoleView.displaySuccess("Открываю системные настройки...", description: nil)
        } catch {
            consoleView.displayError("Не удалось открыть системные настройки: \(error.localizedDescription)")
            
            // Альтернативный способ открытия настроек
            let alternativeProcess = Process()
            alternativeProcess.launchPath = "/usr/bin/open"
            alternativeProcess.arguments = ["/System/Library/PreferencePanes/Security.prefPane"]
            
            do {
                try alternativeProcess.run()
                consoleView.displaySuccess("Открываю системные настройки безопасности...", description: nil)
            } catch {
                consoleView.displayError("Не удалось открыть системные настройки: \(error.localizedDescription)")
                consoleView.displayInfo("Пожалуйста, откройте настройки контактов вручную.")
            }
        }
        #elseif os(iOS)
        // На iOS открываем настройки приложения
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
            consoleView.displaySuccess("Открываю настройки приложения...", description: nil)
        }
        #else
        consoleView.displayInfo("Автоматическое открытие настроек не поддерживается на этой платформе.")
        consoleView.displayInfo("Пожалуйста, откройте настройки контактов вручную.")
        #endif
    }
    
    internal override func waitForEnter() {
        super.waitForEnter() // вызываем метод родителя
        run() // запускаем меню снова
    }
} 
