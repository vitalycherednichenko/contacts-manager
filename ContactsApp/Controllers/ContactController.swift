import Foundation

class ContactController {
    private var contacts: [Contact]
    private var idCounter: Int
    private let fileManager: ContactsFileController
    
    init(fileManager: ContactsFileController = ContactsFileController()) {
        self.fileManager = fileManager
        if let savedContacts = fileManager.loadContacts() {
            contacts = savedContacts
            idCounter = contacts.map { $0.id }.max() ?? 0
        } else {
            contacts = []
            idCounter = 0
        }
    }
    
    func createContact(personalInfo: PersonalInfo, additionalInfo: [String: String] = [:]) -> Contact {
        idCounter += 1
        
        let connects = ConnectsInfo(phone: additionalInfo["phone"] ?? "")
        
        let note = additionalInfo["note"]
        
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
    
    func addContact(_ contact: Contact) -> Bool {
        contacts.append(contact)
        return true
    }
    
    func getAllContacts() -> [Contact] {
        return contacts
    }
}
