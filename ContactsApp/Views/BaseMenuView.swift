import Foundation

protocol MenuViewProtocol {
    func run()
    func handleInput(_ input: String)
    
}

class BaseMenuView: MenuViewProtocol {
    let consoleView: ConsoleView
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.consoleView = ConsoleView()
        self.router = router
    }
    
    func run() {
        fatalError("Метод должен быть переопределен в подклассе")
    }
    
    func handleInput(_ input: String) {
        fatalError("Метод должен быть переопределен в подклассе")
    }
    
    func showMenu(header: String, title: String, menuItems: [String], callToAction: String = "Ваш выбор:") {
        consoleView.clearScreen()
        consoleView.menuHeader(header)
        consoleView.menuTitle(title)
        
        for item in menuItems {
            consoleView.menuItem(item)
        }
        
        consoleView.callToAction(callToAction)
    }
    
    func handleQInput(_ input: String) -> Bool {
        return input.lowercased() == "q"
    }
    
    func waitForEnter() {
        consoleView.displayInfo(SystemMessages.Info.pressEnterToContinue)
    }
    
    func searchAndSelectContact(presenter: ContactPresenterProtocol, action: String) -> Int? {
        let contacts = presenter.getAllContacts()
        if contacts.isEmpty {
            consoleView.displayInfo(SystemMessages.Info.emptyContactList)
            return nil
        }
        
        consoleView.menuInfoItem(SystemMessages.UI.backToMenuWithQ)
        consoleView.menuHr()
        
        let query = consoleView.inputString(prompt: "\nВведите поисковый запрос (оставьте пустым для отображения всех контактов): ")
        
        if handleQInput(query) { return nil }
        
        let filteredContacts = presenter.searchContacts(query, contacts: contacts)
        
        if filteredContacts.isEmpty {
            consoleView.displayInfo(String(format: SystemMessages.Info.noSearchResultsWithEnter, query))
            return nil
        }
        
        for contact in filteredContacts {
            print(contact.toStr())
        }
        
        let id = consoleView.inputInteger(prompt: "\nВведите ID контакта для \(action): ", required: true)
        
        return id
    }
}
