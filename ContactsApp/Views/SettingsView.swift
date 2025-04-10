import Foundation
import Contacts

protocol SettingsViewProtocol {
    func showSettingsMenu()
}

class SettingsView: MenuViewProtocol, SettingsViewProtocol {
    private let consoleView: ConsoleView
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
        self.consoleView = ConsoleView()
    }
    
    func run() {
        showSettingsMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showSettingsMenu() {
        consoleView.clearScreen()
        print("""
              \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
              ║                ⚙️  Настройки                               ║
              ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
              
              \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
              
              \(ANSIColors.green)1. 🔄 Синхронизация с iCloud контактами
              
              2. 📁 Путь к файлу контактов
              
              3. 🎨 Настройки отображения
              
              4. ◀️  Назад в главное меню\(ANSIColors.reset)
              
              \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
              """, terminator: "")
    }
    
    public func handleInput(_ input: String) {
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
        print("""
              \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
              ║                🔄 Синхронизация контактов                  ║
              ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
              
              \(ANSIColors.yellow)Начинаем синхронизацию с iCloud контактами...\(ANSIColors.reset)
              """)
        
        // Создаем экземпляр интерактора
        let contactsSyncInteractor = ContactsSyncInteractor()
        
        // Запрашиваем доступ
        print("\(ANSIColors.yellow)Запрашиваем доступ к контактам...\(ANSIColors.reset)")
        let hasAccess = contactsSyncInteractor.requestAccess()
        
        if !hasAccess {
            print("\(ANSIColors.red)❌ Доступ к контактам не был предоставлен.\(ANSIColors.reset)")
            
            // Проверяем текущий статус доступа более подробно
            let status = CNContactStore.authorizationStatus(for: .contacts)
            
            switch status {
            case .denied:
                // Пользователь ранее отклонил доступ, нужно перейти в настройки
                print("""
                      \(ANSIColors.yellow)
                      ⚠️ Доступ к контактам ранее был отклонен.
                      
                      Для включения доступа к контактам необходимо изменить настройки системы.
                      \(ANSIColors.reset)
                      """)
                
                print("\n\(ANSIColors.blue)Хотите открыть системные настройки конфиденциальности? (д/н): \(ANSIColors.reset)", terminator: "")
                if let choice = readLine()?.lowercased(), choice == "д" {
                    openContactsPrivacySettings()
                    print("\n\(ANSIColors.yellow)После изменения настроек вернитесь в приложение.\(ANSIColors.reset)")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
                
            case .restricted:
                // Доступ ограничен родительским контролем или политикой организации
                print("""
                      \(ANSIColors.yellow)
                      ⚠️ Доступ к контактам ограничен настройками устройства или родительским контролем.
                      
                      Пожалуйста, обратитесь к администратору устройства для разрешения доступа к контактам.
                      \(ANSIColors.reset)
                      """)
                
                print("\n\(ANSIColors.blue)Хотите открыть системные настройки конфиденциальности? (д/н): \(ANSIColors.reset)", terminator: "")
                if let choice = readLine()?.lowercased(), choice == "д" {
                    openContactsPrivacySettings()
                    print("\n\(ANSIColors.yellow)После изменения настроек вернитесь в приложение.\(ANSIColors.reset)")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
                
            default:
                // Общее сообщение для других случаев
                print("""
                      \(ANSIColors.yellow)
                      Проверьте настройки конфиденциальности и предоставьте доступ к контактам.
                      \(ANSIColors.reset)
                      """)
                
                print("\n\(ANSIColors.blue)Хотите открыть системные настройки конфиденциальности? (д/н): \(ANSIColors.reset)", terminator: "")
                if let choice = readLine()?.lowercased(), choice == "д" {
                    openContactsPrivacySettings()
                    print("\n\(ANSIColors.yellow)После изменения настроек вернитесь в приложение.\(ANSIColors.reset)")
                    sleep(2) // Даем время пользователю прочитать сообщение
                }
            }
            
            print("\n\(ANSIColors.blue)Хотите попробовать снова после изменения настроек? (д/н): \(ANSIColors.reset)", terminator: "")
            if let choice = readLine()?.lowercased(), choice == "д" {
                syncContacts() // Рекурсивно вызываем тот же метод для повторной попытки
                return
            }
            
            waitForInput()
            return
        }
        
        // Синхронизируем контакты с основной базой данных приложения
        print("\(ANSIColors.green)✅ Доступ получен. Синхронизируем контакты...\(ANSIColors.reset)")
        let result = contactsSyncInteractor.syncWithAppContacts()
        
        if result.total == 0 {
            print("\(ANSIColors.yellow)⚠️ Не удалось найти контакты в iCloud.\(ANSIColors.reset)")
        } else {
            print("\(ANSIColors.green)📱 Найдено \(result.total) контактов в iCloud.\(ANSIColors.reset)")
            
            if result.imported > 0 {
                print("\(ANSIColors.green)✅ Успешно импортировано \(result.imported) новых контактов.\(ANSIColors.reset)")
            } else {
                print("\(ANSIColors.yellow)ℹ️ Новых контактов для импорта не найдено.\(ANSIColors.reset)")
            }
        }
        
        waitForInput()
    }
    
    private func showFilePath() {
        consoleView.clearScreen()
        print("""
              \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
              ║                📁 Путь к файлу контактов                      ║
              ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
              
              \(ANSIColors.green)Текущий путь к файлу контактов: \(ANSIColors.reset)\(FileManager.default.currentDirectoryPath)/contacts.json
              \(ANSIColors.green)Путь к файлу iCloud контактов: \(ANSIColors.reset)\(FileManager.default.currentDirectoryPath)/data/icloud_contacts.json
              
              \(ANSIColors.yellow)Функция изменения пути будет доступна в следующих версиях.\(ANSIColors.reset)
              """)
        
        waitForInput()
    }
    
    private func showDisplaySettings() {
        consoleView.clearScreen()
        print("""
              \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
              ║                🎨 Настройки отображения                        ║
              ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
              
              \(ANSIColors.yellow)Настройки отображения будут доступны в следующих версиях.\(ANSIColors.reset)
              """)
        
        waitForInput()
    }
    
    private func waitForInput() {
        print("\n\(ANSIColors.yellow)Нажмите Enter для возврата в меню...\(ANSIColors.reset)")
        _ = readLine()
        run()
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
            print("\(ANSIColors.green)✅ Открываю системные настройки...\(ANSIColors.reset)")
        } catch {
            print("\(ANSIColors.red)❌ Не удалось открыть системные настройки: \(error.localizedDescription)\(ANSIColors.reset)")
            
            // Альтернативный способ открытия настроек
            let alternativeProcess = Process()
            alternativeProcess.launchPath = "/usr/bin/open"
            alternativeProcess.arguments = ["/System/Library/PreferencePanes/Security.prefPane"]
            
            do {
                try alternativeProcess.run()
                print("\(ANSIColors.green)✅ Открываю системные настройки безопасности...\(ANSIColors.reset)")
            } catch {
                print("\(ANSIColors.red)❌ Не удалось открыть системные настройки: \(error.localizedDescription)\(ANSIColors.reset)")
                print("\(ANSIColors.yellow)Пожалуйста, откройте настройки контактов вручную.\(ANSIColors.reset)")
            }
        }
        #elseif os(iOS)
        // На iOS открываем настройки приложения
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
            print("\(ANSIColors.green)✅ Открываю настройки приложения...\(ANSIColors.reset)")
        }
        #else
        print("\(ANSIColors.yellow)⚠️ Автоматическое открытие настроек не поддерживается на этой платформе.\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)Пожалуйста, откройте настройки контактов вручную.\(ANSIColors.reset)")
        #endif
    }
} 
