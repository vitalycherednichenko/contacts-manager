import Foundation

protocol ProfileMenuViewProtocol {
    func showProfileMenu()
    func showSearchMainContact()
}

class ProfileMenuView: BaseMenuView, ProfileMenuViewProtocol {
    private let presenter: ContactPresenterProtocol
    
    override init(router: RouterProtocol) {
        self.presenter = ContactPresenter()
        super.init(router: router)
    }
    
    override public func run() {
        showProfileMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showProfileMenu() {
        consoleView.clearScreen()
        consoleView.menuHeader("👤 Главное меню / Профиль")
        consoleView.menuTitle("Ваш профиль")
        
        if let mainContact = presenter.getMainContact() {
            print(mainContact.toStr())
        } else {
            consoleView.menuItem("👤 Основной контакт не выбран")
        }
        
        let menuItems = [
            "1. 👤 Выбрать основной контакт",
            "2. ◀️  Назад в главное меню"
        ]
        
        consoleView.menuTitle("Выберите действие:")
        for item in menuItems {
            consoleView.menuItem(item)
        }
        consoleView.callToAction("Ваш выбор:")
    }
    
    override public func handleInput(_ input: String) {
        switch input {
        case "1": showSearchMainContact()
        case "2": router.showMainMenu()
        default:
            consoleView.displayError("Неверный выбор. Попробуйте снова.")
        }
        run()
    }
    
    public func showSearchMainContact() {
        consoleView.clearScreen()
        consoleView.menuHeader("👤 Выбор основного контакта")
        consoleView.menuTitle("Выберите контакт, который станет основным")
        
        guard let id = searchAndSelectContact(presenter: presenter, action: "выбора основным") else {
            return
        }
        
        if presenter.setMainContact(id: id) {
            if let contact = presenter.getMainContact() {
                consoleView.displaySuccess("Основной контакт успешно установлен:", description: contact.toStr())
            }
        } else {
            consoleView.displayError("Контакт с ID \(id) не найден")
        }
        
        waitForEnter()
    }
} 

