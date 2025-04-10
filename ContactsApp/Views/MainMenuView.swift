import Foundation

protocol MainMenuViewProtocol {
    func showMainMenu()
    func getAppVersion() -> String
}

class MainMenuView: MenuViewProtocol, MainMenuViewProtocol  {
    private let presenter: MainMenuPresenterProtocol
    private let consoleView: ConsoleView
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
        self.consoleView = ConsoleView()
        self.presenter = MainMenuPresenter()
    }
    
    func run () {
        showMainMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showMainMenu() {
        consoleView.clearScreen()
        let version = getAppVersion()
        print("""
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                ║                📱 Контакты людей \(version)                    ║
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
                
                \(ANSIColors.green)1. 📞 Контакты
                
                2. 👤 Ваш профиль
                
                3. ⚙️  Настройки
                
                4. 🚪 Выход\(ANSIColors.reset)
                
                \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
                """, terminator: "")
    }
    
    public func handleInput(_ input: String) {
        switch input {
        case "1": router.showContactsMenu()
        case "2": router.showProfileMenu()
        case "3": router.showSettingsMenu()
        case "4":
            consoleView.displaySuccess("До свидания! Спасибо за использование нашего приложения! 👋")
            exit(0)
        default:
            consoleView.displayError("Неверный выбор. Попробуйте снова.")
        }
        
        run()
    }

    public func getAppVersion() -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["describe", "--tags", "--abbrev=0"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            if let data = try? pipe.fileHandleForReading.readToEnd(),
               let version = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                return version
            }
        } catch {
            print("Ошибка при получении версии: \(error)")
        }
        
        return "1.0"
    }
}
