import Foundation

protocol ProfileMenuViewProtocol {
    func showProfileMenu()
    func showSearchMainContact()
}

class ProfileMenuView: MenuViewProtocol, ProfileMenuViewProtocol {
    private let presenter: ContactPresenterProtocol
    private let consoleView: ConsoleView
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.consoleView = ConsoleView()
        self.presenter = ContactPresenter()
        self.router = router
    }
    
    public func run() {
        showProfileMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showProfileMenu() {
        consoleView.clearScreen()
        print("""
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                ║                👤 Главное меню / Профиль                  ║
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Ваш профиль\(ANSIColors.reset)
                """)
        
        // Отображаем основной контакт если он выбран
        if let mainContact = presenter.getMainContact() {
            print("\n\(ANSIColors.green)\(ANSIColors.bold)👤 Основной контакт:\(ANSIColors.reset)")
            print(mainContact.toStr())
        } else {
            print("\n\(ANSIColors.yellow)👤 Основной контакт не выбран\(ANSIColors.reset)")
        }
        
        print("""
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
                
                \(ANSIColors.green)1. 👤 Выбрать основной контакт
                
                2. ◀️  Назад в главное меню\(ANSIColors.reset)
                
                \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
                """, terminator: "")
    }
    
    public func handleInput(_ input: String) {
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
        print("""
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                ║              👤 Выбор основного контакта                  ║
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Выберите контакт, который станет основным\(ANSIColors.reset)
                """)
        
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        let contacts = presenter.getAllContacts()
        
        if contacts.isEmpty {
            consoleView.displayInfo("Список контактов пуст. Создайте контакт в разделе 'Контакты'.")
            return
        }
        
        guard let query = consoleView.inputString(prompt: "\nВведите поисковый запрос (оставьте пустым для отображения всех контактов): ") else { return }
        
        if query.lowercased() == "q" { return }
        
        let filteredContacts = searchContacts(query, contacts: contacts)
        
        if filteredContacts.isEmpty {
            consoleView.displayInfo("По запросу '\(query)' ничего не найдено.")
            return
        }
        
        for contact in filteredContacts {
            print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
            print(contact.toStr())
        }
        
        guard let idString = consoleView.inputString(prompt: "\nВведите ID контакта для выбора основным: ", required: true) else { return }
        
        if idString.lowercased() == "q" { return }
        
        guard let id = Int(idString) else {
            consoleView.displayError("Неверный ID. Должно быть число.")
            consoleView.displayInfo("Нажмите Enter для продолжения...")
            return
        }
        
        if presenter.setMainContact(id: id) {
            if let contact = presenter.getMainContact() {
                consoleView.displaySuccess("Основной контакт успешно установлен:", description: contact.toStr())
            }
        } else {
            consoleView.displayError("Контакт с ID \(id) не найден")
        }
        
        consoleView.displayInfo("Нажмите Enter для продолжения...")
    }
    
    private func searchContacts(_ query: String, contacts: [Contact]) -> [Contact] {
        if query.isEmpty {
            return contacts
        }
        
        let lowercasedQuery = query.lowercased()
        return contacts.filter { contact in
            // Поиск по имени
            if contact.personalInfo.name.lowercased().contains(lowercasedQuery) {
                return true
            }
            // Поиск по фамилии
            if contact.personalInfo.surname.lowercased().contains(lowercasedQuery) {
                return true
            }
            // Поиск по отчеству
            if contact.personalInfo.middlename.lowercased().contains(lowercasedQuery) {
                return true
            }
            // Поиск по телефону
            if let phone = contact.connects.phone, phone.lowercased().contains(lowercasedQuery) {
                return true
            }
            // Поиск по заметке
            if let note = contact.note, note.lowercased().contains(lowercasedQuery) {
                return true
            }
            return false
        }
    }
} 