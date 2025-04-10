import Foundation

protocol ContactPresenterProtocol {
    func getAllContacts() -> [Contact]
    func createContact() -> Contact?
    func deleteContact(id: Int) -> Bool
    func editContact(id: Int, updatedContact: Contact) -> Bool
    func setMainContact(id: Int) -> Bool
    func getMainContact() -> Contact?
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
        guard let firstName = consoleView.inputString(prompt: "👤 *Имя: ", required: true) else { return nil }
        guard let middlename = consoleView.inputString(prompt: "👤 Отчество: ") else { return nil }
        guard let surname = consoleView.inputString(prompt: "👤 *Фамилия: ", required: true) else { return nil }
        guard let phone = consoleView.inputString(prompt: "📱 Телефон: ") else { return nil }
        guard let note = consoleView.inputString(prompt: "📝 Заметка: ") else { return nil }
        
        let personalInfo = PersonalInfo(
            name: firstName,
            surname: surname,
            middlename: middlename
        )
        
        idCounter += 1
        
        let connects = ConnectsInfo(phone: phone)
        
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
    
    public func editContact(id: Int, updatedContact: Contact) -> Bool {
        guard let index = contacts.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
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
}
