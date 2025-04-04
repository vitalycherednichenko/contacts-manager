import Darwin
import Foundation

class ConsoleController {
    private let contactController: ContactController
    private let menuView: MenuView
    private let messageView: MessageView
    private let consoleView: ConsoleView
    private let contactView: ContactView
    
    init() {
        self.menuView = MenuView()
        self.contactController = ContactController()
        self.messageView = MessageView()
        self.consoleView = ConsoleView()
        self.contactView = ContactView()
    }
    
    func run() {
        program: while true {
            switch menuView.showMainMenu() {
            case "1": addContact()
            case "2": showContacts()
            case "3": deleteContact()
            case "6":
                messageView.displaySuccess("До свидания! Спасибо за использование нашего приложения! 👋")
                break program
            default:
                messageView.displayError("Неверный выбор. Попробуйте снова.")
            }
        }
    }
    
    private func showContacts() {
        let contacts = contactController.getAllContacts()
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
        
        let contact = contactController.createContact(
            personalInfo: personalInfo,
            additionalInfo: additionalInfo
        )
        
        messageView.displaySuccess("Контакт успешно создан:", description: contact.toStr())
        
        messageView.displayInfo("Нажмите Enter для продолжения...")
    }
    
    private func deleteContact() {
        let contacts = contactController.getAllContacts()
        
        if contacts.isEmpty {
            messageView.displayInfo("Список контактов пуст. Нажмите Enter для продолжения...")
            return
        }
        
        contactView.showDeleteContact(contacts)
        
        guard let idString = consoleView.inputString(prompt: "\nВведите ID контакта для удаления: ", required: true) else {
            return
        }
        
        if idString.lowercased() == "q" {
            return
        }
        
        guard let id = Int(idString) else {
            messageView.displayError("Неверный ID. Должно быть число.")
            messageView.displayInfo("Нажмите Enter для продолжения...")
            return
        }
        
        if contactController.deleteContact(id: id) {
            messageView.displaySuccess("Контакт с ID \(id) успешно удален")
        } else {
            messageView.displayError("Контакт с ID \(id) не найден")
        }
        
        messageView.displayInfo("Нажмите Enter для продолжения...")
    }
}
