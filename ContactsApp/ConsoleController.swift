import Darwin
import Foundation

class ConsoleController {
    private let contactManager: ContactController
    private let menuView: MenuView
    private let messageView: MessageView
    private let consoleView: ConsoleView
    private let contactView: ContactView
    
    init() {
        self.menuView = MenuView()
        self.contactManager = ContactController()
        self.messageView = MessageView()
        self.consoleView = ConsoleView()
        self.contactView = ContactView()
    }
    
    func run() {
        program: while true {
            switch menuView.showMainMenu() {
            case "1": addContact()
            case "2": showContacts()
            case "6":
                messageView.displaySuccess("До свидания! Спасибо за использование нашего приложения! 👋")
                break program
            default:
                messageView.displayError("Неверный выбор. Попробуйте снова.")
            }
        }
    }
    
    private func showContacts() {
        let contacts = contactManager.getAllContacts()
        contactView.showAllContacts(contacts)
    }
    
    private func addContact() {
        contactView.showCreateContact()
        
        guard let firstName = consoleView.inputString(prompt: "👤 *Имя: ", required: true) else { return }
        
        guard let middlename = consoleView.inputString(prompt: "👤 Отчество: ") else { return }
        
        guard let surname = consoleView.inputString(prompt: "👤 *Фамилия: ", required: true) else { return }
        
        guard let phone = consoleView.inputString(prompt: "📱 Телефон: ") else { return }
        
        guard let note = consoleView.inputString(prompt: "📝 Заметка: ") else { return }
        
        let personalInfo = PersonalInfo(
            name: firstName,
            surname: surname,
            middlename: middlename
        )
        
        let additionalInfo = [
            "phone": phone,
            "note": note
        ]
        
        let contact = contactManager.createContact(
            personalInfo: personalInfo,
            additionalInfo: additionalInfo
        )
        
        messageView.displaySuccess("Контакт успешно создан:", description: contact.toStr())
        
        messageView.displayInfo("Нажмите Enter для продолжения...")
    }
}
