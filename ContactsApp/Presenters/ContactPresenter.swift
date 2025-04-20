import Foundation

protocol ContactPresenterProtocol {
    func getAllContacts() -> [Contact]
    func createContact() -> Contact?
    func deleteContact(id: Int) -> Bool
    func editContact(id: Int) -> Bool
    func setMainContact(id: Int) -> Bool
    func getMainContact() -> Contact?
    func searchContacts(_ query: String, contacts: [Contact]) -> [Contact]
}


class ContactPresenter: ContactPresenterProtocol {
    private var contacts: [Contact]
    private let consoleView: ConsoleView
    private var idCounter: Int
    private let fileManager: FileInteractor
    
    init(fileManager: FileInteractor = FileInteractor()) {
        self.consoleView = ConsoleView()
        self.fileManager = fileManager
        if let savedContacts = fileManager.loadContacts() {
            contacts = savedContacts
            idCounter = contacts.map { $0.id }.max() ?? 0
        } else {
            contacts = []
            idCounter = 0
        }
    }
    
    func getAllContacts() -> [Contact] {
        contacts
    }
    
    public func createContact() -> Contact? {
        let firstName = consoleView.inputString(prompt: "👤 *Имя: ", required: true)
        if firstName.lowercased() == "q" { return nil }
        
        let middlename = consoleView.inputString(prompt: "👤 Отчество: ")
        if middlename.lowercased() == "q" { return nil }
        
        let surname = consoleView.inputString(prompt: "👤 Фамилия: ")
        if surname.lowercased() == "q" { return nil }
        
        let phone = consoleView.inputString(prompt: "📱 Телефон: ")
        if phone.lowercased() == "q" { return nil }
        
        let note = consoleView.inputString(prompt: "📝 Заметка: ")
        if note.lowercased() == "q" { return nil }
        
        let personalInfo = PersonalInfo(
            name: firstName,
            surname: surname,
            middlename: middlename
        )
        
        let connects = ConnectsInfo(phone: phone)
        
        idCounter += 1
        
        let contact = Contact(
            id: idCounter,
            personalInfo: personalInfo,
            connects: connects,
            note: note
        )
        
        contacts.append(contact)
        
        try? fileManager.saveContacts(contacts)
        
        return contact
    }
    
    public func editContact(id: Int) -> Bool {
        guard let index = getAllContacts().firstIndex(where: { $0.id == id }) else {
            consoleView.displayError("Контакт с ID \(id) не найден")
            return false
        }
        
        let contact = getAllContacts()[index]
        
        consoleView.menuSubTitle("✏️ Редактирование контакта")
        consoleView.menuInfoItem("ℹ️  Если хотите оставить поле без изменений, нажмите Enter")
        consoleView.menuInfoItem("◀️  Если хотите вернутся в меню введите 'q'")
        consoleView.menuHr()
        
        let namePrompt = "👤 Имя [\(contact.personalInfo.name)]: "
        let firstName = consoleView.inputString(prompt: namePrompt)
        if firstName.lowercased() == "q" { return false }
        
        let middlenamePrompt = "👤 Отчество [\(contact.personalInfo.middlename ?? "")]: "
        let middlename = consoleView.inputString(prompt: middlenamePrompt)
        if middlename.lowercased() == "q" { return false }
        
        let surnamePrompt = "👤 Фамилия [\(contact.personalInfo.surname ?? "")]: "
        let surname = consoleView.inputString(prompt: surnamePrompt)
        if surname.lowercased() == "q" { return false }
        
        let phonePrompt = "📱 Телефон [\(contact.connects.phone ?? "")]: "
        let phone = consoleView.inputString(prompt: phonePrompt)
        if phone.lowercased() == "q" { return false }
        
        // Редактирование заметки
        let notePrompt = "📝 Заметка [\(contact.note ?? "")]: "
        let note = consoleView.inputString(prompt: notePrompt)
        if note.lowercased() == "q" { return false }
        
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
        
        contacts[index] = updatedContact
        try? fileManager.saveContacts(contacts)
        return true
    }
    
    public func deleteContact(id: Int) -> Bool {
        guard let index = contacts.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        contacts.remove(at: index)
        try? fileManager.saveContacts(contacts)
        return true
    }
    
    public func setMainContact(id: Int) -> Bool {
        guard let index = contacts.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        // Сначала сбрасываем флаг isMain у всех контактов
        for i in 0..<contacts.count {
            contacts[i].isMain = false
        }
        
        // Устанавливаем флаг isMain для выбранного контакта
        contacts[index].isMain = true
        
        try? fileManager.saveContacts(contacts)
        return true
    }
    
    public func getMainContact() -> Contact? {
        return contacts.first { $0.isMain }
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
            if let surname = contact.personalInfo.surname, surname.lowercased().contains(lowercasedQuery) {
                return true
            }
            // Поиск по отчеству
            if let middlename = contact.personalInfo.middlename, middlename.lowercased().contains(lowercasedQuery) {
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
