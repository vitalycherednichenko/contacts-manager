//
//  ContactView.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

protocol ContactMenuViewProtocol {
    func showContactsMenu()
    func showAllContacts(_ contacts: [Contact])
    func showCreateContact()
    func showEditContact (_ contacts: [Contact])
    func editContact(_ id: Int) -> Contact?
    func searchContacts(_ query: String, contacts: [Contact]) -> [Contact]
}

class ContactMenuView: MenuViewProtocol, ContactMenuViewProtocol {
    private let presenter: ContactPresenterProtocol
    private let consoleView: ConsoleView
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.consoleView = ConsoleView()
        self.presenter = ContactPresenter()
        self.router = router
    }
    
    public func run () {
        showContactsMenu()
        if let input = readLine() {
            handleInput(input)
        }
    }
    
    public func showContactsMenu() {
        consoleView.clearScreen()
        print("""
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                ║                📱 Главное меню / Контакты                  ║
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
                
                \(ANSIColors.green)1. 📝 Добавить новый контакт
                
                2. 👥 Просмотреть все контакты
                
                3. 🔍 Поиск контактов
                
                4. ✏️  Редактировать контакт
                
                5. 🗑️  Удалить контакт
                
                6. ◀️  Назад в главное меню \(ANSIColors.reset)
                
                \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
                """, terminator: "")
    }
    
    public func handleInput(_ input: String) {
        switch input {
        case "1":
            showCreateContact()
            if let contact = presenter.createContact() {
                consoleView.displaySuccess("Контакт успешно создан:", description: contact.toStr())
                consoleView.displayInfo("Нажмите Enter для продолжения...")
            }
        case "2": showAllContacts(presenter.getAllContacts())
        case "3": showSearchContacts()
        case "4":
            let contacts = presenter.getAllContacts()
            if contacts.isEmpty {
                consoleView.displayInfo("Список контактов пуст. Нажмите Enter для продолжения...")
                break
            }
            showEditContactWithSearch(contacts)
        case "5":
            let contacts = presenter.getAllContacts()
            if contacts.isEmpty {
                consoleView.displayInfo("Список контактов пуст. Нажмите Enter для продолжения...")
                break
            }
            showDeleteContactWithSearch(contacts)
        case "6": router.showMainMenu()
        default:
            consoleView.displayError("Неверный выбор. Попробуйте снова.")
        }
        run()
    }
    
    public func showAllContacts(_ contacts: [Contact]) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)👥 Список контактов\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        consoleView.displayInfo("Нажмите Enter для продолжения...")
    }
    
    public func showCreateContact() {
        print("\(ANSIColors.green)\(ANSIColors.bold)📝 Создание нового контакта\(ANSIColors.reset)")
        sleep(1)
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)✳️  Обязательное поле отмечено * \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)ℹ️  Нажмите Enter, чтобы пропустить заполнение поля \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────────────\(ANSIColors.reset)")
    }
    
    func showDeleteContact (_ contacts: [Contact]) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)👥 Список контактов\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        sleep(1)
    }
    
    public func showEditContact (_ contacts: [Contact]) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)✏️ Редактирование контакта\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        sleep(1)
    }
    
    public func editContact(_ id: Int) -> Contact? {
        guard let contactIndex = presenter.getAllContacts().firstIndex(where: { $0.id == id }) else {
            consoleView.displayError("Контакт с ID \(id) не найден")
            return nil
        }
        
        let contact = presenter.getAllContacts()[contactIndex]
        
        print("\n\(ANSIColors.green)\(ANSIColors.bold)✏️ Редактирование контакта\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите оставить поле без изменений, нажмите Enter \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────────────\(ANSIColors.reset)")
        
        // Редактирование имени
        let namePrompt = "👤 Имя [\(contact.personalInfo.name)]: "
        guard let firstName = consoleView.inputString(prompt: namePrompt) else { return nil }
        if firstName.lowercased() == "q" { return nil }
        
        // Редактирование отчества
        let middlenamePrompt = "👤 Отчество [\(contact.personalInfo.middlename)]: "
        guard let middlename = consoleView.inputString(prompt: middlenamePrompt) else { return nil }
        if middlename.lowercased() == "q" { return nil }
        
        // Редактирование фамилии
        let surnamePrompt = "👤 Фамилия [\(contact.personalInfo.surname)]: "
        guard let surname = consoleView.inputString(prompt: surnamePrompt) else { return nil }
        if surname.lowercased() == "q" { return nil }
        
        // Редактирование телефона
        let phonePrompt = "📱 Телефон [\(contact.connects.phone ?? "")]: "
        guard let phone = consoleView.inputString(prompt: phonePrompt) else { return nil }
        if phone.lowercased() == "q" { return nil }
        
        // Редактирование заметки
        let notePrompt = "📝 Заметка [\(contact.note ?? "")]: "
        guard let note = consoleView.inputString(prompt: notePrompt) else { return nil }
        if note.lowercased() == "q" { return nil }
        
        // Создаем обновленный объект PersonalInfo
        let personalInfo = PersonalInfo(
            name: firstName.isEmpty ? contact.personalInfo.name : firstName,
            surname: surname.isEmpty ? contact.personalInfo.surname : surname,
            middlename: middlename.isEmpty ? contact.personalInfo.middlename : middlename
        )
        
        // Создаем обновленный объект ConnectsInfo
        let connects = ConnectsInfo(
            phone: phone.isEmpty ? (contact.connects.phone ?? "") : phone
        )
        
        // Создаем обновленный контакт
        let updatedContact = Contact(
            id: contact.id,
            personalInfo: personalInfo,
            connects: connects,
            note: note.isEmpty ? contact.note : note
        )
        
        return updatedContact
    }
    
    public func searchContacts(_ query: String, contacts: [Contact]) -> [Contact] {
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
    
    public func showSearchContacts() {
        let contacts = presenter.getAllContacts()
        if contacts.isEmpty {
            consoleView.displayInfo("Список контактов пуст. Нажмите Enter для продолжения...")
            return
        }
        
        print("\n\(ANSIColors.green)\(ANSIColors.bold)🔍 Поиск контактов\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        guard let query = consoleView.inputString(prompt: "\nВведите поисковый запрос: ", required: true) else { return }
        
        if query.lowercased() == "q" { return }
        
        let searchResults = searchContacts(query, contacts: contacts)
        
        if searchResults.isEmpty {
            consoleView.displayInfo("По запросу '\(query)' ничего не найдено.")
        } else {
            print("\n\(ANSIColors.green)\(ANSIColors.bold)🔍 Результаты поиска по запросу '\(query)':\(ANSIColors.reset)")
            print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
            
            for contact in searchResults {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        
        consoleView.displayInfo("Нажмите Enter для продолжения...")
    }
    
    public func showEditContactWithSearch(_ contacts: [Contact]) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)✏️ Редактирование контакта\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        guard let query = consoleView.inputString(prompt: "\nВведите поисковый запрос (оставьте пустым для отображения всех контактов): ") else { return }
        
        if query.lowercased() == "q" { return }
        
        let filteredContacts = searchContacts(query, contacts: contacts)
        
        if filteredContacts.isEmpty {
            consoleView.displayInfo("По запросу '\(query)' ничего не найдено. Нажмите Enter для продолжения...")
            return
        }
        
        for contact in filteredContacts {
            print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
            print(contact.toStr())
        }
        
        guard let idString = consoleView.inputString(prompt: "\nВведите ID контакта для редактирования: ", required: true) else { return }
        
        if idString.lowercased() == "q" { return }
        
        guard let id = Int(idString) else {
            consoleView.displayError("Неверный ID. Должно быть число.")
            consoleView.displayInfo("Нажмите Enter для продолжения...")
            return
        }
        
        if let editedContact = editContact(id) {
            if presenter.editContact(id: id, updatedContact: editedContact) {
                consoleView.displaySuccess("Контакт с ID \(id) успешно отредактирован")
            } else {
                consoleView.displayError("Не удалось отредактировать контакт с ID \(id)")
            }
        }
        
        consoleView.displayInfo("Нажмите Enter для продолжения...")
    }
    
    public func showDeleteContactWithSearch(_ contacts: [Contact]) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)🗑️ Удаление контакта\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        guard let query = consoleView.inputString(prompt: "\nВведите поисковый запрос (оставьте пустым для отображения всех контактов): ") else { return }
        
        if query.lowercased() == "q" { return }
        
        let filteredContacts = searchContacts(query, contacts: contacts)
        
        if filteredContacts.isEmpty {
            consoleView.displayInfo("По запросу '\(query)' ничего не найдено. Нажмите Enter для продолжения...")
            return
        }
        
        for contact in filteredContacts {
            print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
            print(contact.toStr())
        }
        
        guard let idString = consoleView.inputString(prompt: "\nВведите ID контакта для удаления: ", required: true) else { return }
        
        if idString.lowercased() == "q" { return }
        
        guard let id = Int(idString) else {
            consoleView.displayError("Неверный ID. Должно быть число.")
            consoleView.displayInfo("Нажмите Enter для продолжения...")
            return
        }
        
        if presenter.deleteContact(id: id) {
            consoleView.displaySuccess("Контакт с ID \(id) успешно удален")
        } else {
            consoleView.displayError("Контакт с ID \(id) не найден")
        }
        
        consoleView.displayInfo("Нажмите Enter для продолжения...")
    }
}
