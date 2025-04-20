import Foundation

protocol MainMenuViewProtocol {
    func showMainMenu()
    func getAppVersion() -> String
}

class MainMenuView: BaseMenuView, MainMenuViewProtocol {
    private let presenter: MainMenuPresenterProtocol
    
    override init(router: RouterProtocol) {
        self.presenter = MainMenuPresenter()
        super.init(router: router)
    }
    
    override func run() {
        showMainMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showMainMenu() {
        let menuItems = [
            "1. 📞 Контакты",
            "2. 👤 Ваш профиль",
            "3. ⚙️  Настройки",
            "4. 🚪 Выход"
        ]
        
        showMenu(
            header: "📱 Контакты людей \(getAppVersion())",
            title: "Выберите действие:",
            menuItems: menuItems
        )
    }
    
    override public func handleInput(_ input: String) {
        switch input {
        case "1": router.showContactsMenu()
        case "2": router.showProfileMenu()
        case "3": router.showSettingsMenu()
        case "4":
            consoleView.displaySuccess(SystemMessages.Success.appExit)
            exit(0)
        default:
            consoleView.displayError(SystemMessages.Error.invalidChoice)
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
