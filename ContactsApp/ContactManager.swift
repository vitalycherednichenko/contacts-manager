import Foundation

class ContactManager {
    private var contacts: [Contact]
    private var idCounter: Int
    private let fileManager: ContactsFileManager
    
    init(fileManager: ContactsFileManager = ContactsFileManager()) {
        self.fileManager = fileManager
        if let savedContacts = fileManager.loadContacts() {
            contacts = savedContacts
            idCounter = contacts.map { $0.id }.max() ?? 0
        } else {
            contacts = []
            idCounter = 0
        }
    }
    
    func createContact(personalInfo: [String: String], additionalInfo: [String: String] = [:]) -> Contact {
        idCounter += 1
        
        // Создаем PersonalInfo из словаря
        let info = PersonalInfo(
            name: personalInfo["name"] ?? "",
            surname: personalInfo["surname"] ?? "",
            middlename: personalInfo["middlename"] ?? ""
        )
        
        // Создаем ContactInfo с телефоном
        let connects = ConnectsInfo(phone: additionalInfo["phone"] ?? "")
        
        // Создаем контакт с заметкой из additionalInfo
        let note = additionalInfo["note"]
        
        let contact = Contact(
            id: idCounter,
            personalInfo: info,
            connects: connects,
            note: note
        )
        
        contacts.append(contact)
        try? fileManager.saveContacts(contacts)
        return contact
    }
    
    func addContact(_ contact: Contact) -> Bool {
        contacts.append(contact)
        return true
    }
    
    func getAllContacts() -> [Contact] {
        return contacts
    }
} 
