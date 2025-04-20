import Foundation

protocol ContactMenuViewProtocol {
    func showContactsMenu()
    func showCreateContactMenu()
    func showAllContacts()
    func showEditContact(_ contacts: [Contact])
    func showDeleteContact(_ contacts: [Contact])
}

class ContactMenuView: BaseMenuView, ContactMenuViewProtocol {
    private let presenter: ContactPresenterProtocol
    
    override init(router: RouterProtocol) {
        self.presenter = ContactPresenter()
        super.init(router: router)
    }
    
    override public func run() {
        showContactsMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showContactsMenu() {
        let menuItems = [
            "1. 📝 Добавить новый контакт",
            "2. 👥 Просмотреть все контакты",
            "3. 🔍 Поиск контактов",
            "4. ✏️  Редактировать контакт",
            "5. 🗑️  Удалить контакт",
            "6. ◀️  Назад в главное меню \(ANSIColors.reset)"
        ]
        
        showMenu(
            header: "📱 Главное меню / Контакты",
            title: "Выберите действие:",
            menuItems: menuItems
        )
    }
    
    override public func handleInput(_ input: String) {
        switch input {
        case "1":
            showCreateContactMenu()
            createContact()
        case "2": showAllContacts()
        case "3": showSearchContacts()
        case "4": showEditContact(presenter.getAllContacts())
        case "5": showDeleteContact(presenter.getAllContacts())
        case "6": router.showMainMenu()
        default:
            consoleView.displayError("Неверный выбор. Попробуйте снова.")
        }
        run()
    }
    
    public func showCreateContactMenu() {
        consoleView.menuSubTitle("📝 Создание нового контакта")
        sleep(1)
        consoleView.menuInfoItem("◀️  Если хотите вернутся в меню введите 'q'")
        consoleView.menuInfoItem("✳️  Обязательное поле отмечено *")
        consoleView.menuInfoItem("ℹ️  Нажмите Enter, чтобы пропустить заполнение поля")
        consoleView.menuHr()
    }
    
    private func createContact() {
        if let contact = presenter.createContact() {
            consoleView.displaySuccess("Контакт успешно создан:", description: contact.toStr())
        } else {
            // Пользователь ввел 'q' или произошла ошибка
            return
        }
        waitForEnter()
    }
    
    public func showAllContacts() {
        consoleView.menuSubTitle("👥 Список контактов")
        consoleView.menuHr()
        
        let contacts = presenter.getAllContacts()
        if contacts.isEmpty {
            consoleView.menuInfoItem("📭 Список контактов пуст.")
        } else {
            for contact in contacts {
                print(contact.toStr())
            }
        }
        waitForEnter()
    }
    
    public func showSearchContacts() {
        let contacts = presenter.getAllContacts()
        if contacts.isEmpty {
            consoleView.displayInfo("Список контактов пуст. Нажмите Enter для продолжения...")
            return
        }
        consoleView.menuSubTitle("🔍 Поиск контактов")
        consoleView.menuInfoItem("◀️  Если хотите вернутся в меню введите 'q'")
        consoleView.menuHr()
        
        let query = consoleView.inputString(prompt: "\nВведите поисковый запрос: ", required: true)
        
        if handleQInput(query) { return }
        
        let searchResults = presenter.searchContacts(query, contacts: contacts)
        
        if searchResults.isEmpty {
            consoleView.displayInfo("По запросу '\(query)' ничего не найдено.")
        } else {
            consoleView.menuSubTitle("🔍 Результаты поиска по запросу '\(query)':")
            consoleView.menuHr()
            
            for contact in searchResults {
                print(contact.toStr())
            }
        }
        
        waitForEnter()
    }
    
    public func showEditContact(_ contacts: [Contact]) {
        consoleView.menuSubTitle("✏️ Редактирование контакта")
        
        guard let id = searchAndSelectContact(presenter: presenter, action: "редактирования") else {
            return
        }
        
        if presenter.editContact(id: id) {
            consoleView.displaySuccess("Контакт с ID \(id) успешно отредактирован")
        } else {
            consoleView.displayError("Не удалось отредактировать контакт с ID \(id)")
        }
        
        waitForEnter()
    }
    
    public func showDeleteContact(_ contacts: [Contact]) {
        consoleView.menuSubTitle("🗑️ Удаление контакта")
        
        guard let id = searchAndSelectContact(presenter: presenter, action: "удаления") else {
            return
        }
        
        if presenter.deleteContact(id: id) {
            consoleView.displaySuccess("Контакт с ID \(id) успешно удален")
        } else {
            consoleView.displayError("Контакт с ID \(id) не найден")
        }
        
        waitForEnter()
    }
}
