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
        
        let firstName = consoleView.inputString(prompt: "👤 Имя: ")
        let middlename = consoleView.inputString(prompt: "👤 Отчество (или Enter, чтобы пропустить): ", allowEmpty: true)
        let surname = consoleView.inputString(prompt: "👤 Фамилия: ")
        let phone = consoleView.inputString(prompt: "📱 Телефон (или Enter, чтобы пропустить): ", allowEmpty: true)
        let note = consoleView.inputString(prompt: "📝 Заметка (или Enter, чтобы пропустить): ", allowEmpty: true)
        
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
