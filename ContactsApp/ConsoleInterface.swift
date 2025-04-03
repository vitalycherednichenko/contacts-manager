import Darwin
import Foundation

class ConsoleInterface {
    private let contactManager: ContactManager
    
    init() {
        self.contactManager = ContactManager()
    }
    
    func run() {
        while true {
            displayMenu()
            if let choice = readLine(), let option = Int(choice) {
                print("\n")
                switch option {
                case 1: addContact()
                case 2: showAllContacts()
                case 6:
                    print("До свидания!\n")
                    return
                default:
                    print("Неверный выбор. Попробуйте снова.")
                }
            } else {
                print("\nНеверный выбор. Попробуйте снова.")
            }
        }
    }
    
    private func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
    
    private func displayMenu() {
        clearScreen()
        print("""
        \n==== Добро пожаловать в приложение "Контакты людей" ====!
        
        Выберите действие:
        
        1. Добавить контакт
        2. Просмотреть все контакты
        6. Выход
        
        Ваш выбор: 
        """, terminator: "")
    }
    
    private func inputString(prompt: String, allowEmpty: Bool = false) -> String {
        while true {
            print(prompt, terminator: "")
            if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
                if allowEmpty || !input.isEmpty {
                    return input
                }
            }
            if !allowEmpty {
                print("Ввод не может быть пустым. Попробуйте снова")
                sleep(1)
            } else {
                return ""
            }
        }
    }
    
    private func waitForEnter() {
        sleep(2)
        print("\nНажмите Enter для продолжения...", terminator: "")
        _ = readLine()
    }
    
    private func addContact() {
        let firstName = inputString(prompt: "Введите имя: ")
        let middlename = inputString(prompt: "Введите отчество (или Enter, чтобы пропустить): ", allowEmpty: true)
        let surname = inputString(prompt: "Введите фамилию: ")
        let phone = inputString(prompt: "Введите телефон (или Enter, чтобы пропустить): ", allowEmpty: true)
        let note = inputString(prompt: "Введите заметку (или Enter, чтобы пропустить): ", allowEmpty: true)
        
        let personalInfo = [
            "name": firstName,
            "surname": surname,
            "middlename": middlename
        ]
        
        var additionalInfo: [String: String] = [:]
        if !phone.isEmpty {
            additionalInfo["phone"] = phone
        }
        if !note.isEmpty {
            additionalInfo["note"] = note
        }
        
        let contact = contactManager.createContact(personalInfo: personalInfo, additionalInfo: additionalInfo)
        print("Контакт успешно создан:", contact.toStr())
        waitForEnter()
    }
    
    private func showAllContacts() {
        let contacts = contactManager.getAllContacts()
        if contacts.isEmpty {
            print("Список контактов пуст.")
        } else {
            print("Список контактов:")
            for contact in contacts {
                print("id \(contact.id): ", contact.toStr())
            }
        }
        waitForEnter()
    }
} 