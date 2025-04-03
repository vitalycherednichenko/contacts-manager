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
                    print("\(ANSIColors.green)\(ANSIColors.bold)До свидания! Спасибо за использование нашего приложения! 👋\(ANSIColors.reset)\n")
                    return
                default:
                    print("\(ANSIColors.red)⚠️ Неверный выбор. Попробуйте снова.\(ANSIColors.reset)")
                    sleep(1)
                }
            } else {
                print("\(ANSIColors.red)⚠️ Неверный выбор. Попробуйте снова.\(ANSIColors.reset)")
                sleep(1)
            }
        }
    }
    
    private func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
    
    private func displayMenu() {
        clearScreen()
        print("""
        \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
        ║                📱 Контакты людей v1.0                ║
        ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
        
        \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
        
        \(ANSIColors.green)1. 📝 Добавить новый контакт
        2. 👥 Просмотреть все контакты
        6. 🚪 Выход\(ANSIColors.reset)
        
        \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
        """, terminator: "")
    }
    
    private func inputString(prompt: String, allowEmpty: Bool = false) -> String {
        while true {
            print("\(ANSIColors.cyan)\(prompt)\(ANSIColors.reset)", terminator: "")
            if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
                if allowEmpty || !input.isEmpty {
                    return input
                }
            }
            if !allowEmpty {
                print("\(ANSIColors.red)⚠️ Ввод не может быть пустым. Попробуйте снова\(ANSIColors.reset)")
                sleep(1)
            } else {
                return ""
            }
        }
    }
    
    private func waitForEnter() {
        sleep(1)
        print("\n\(ANSIColors.yellow)Нажмите Enter для продолжения...\(ANSIColors.reset)", terminator: "")
        _ = readLine()
    }
    
    private func addContact() {
        print("\(ANSIColors.green)\(ANSIColors.bold)📝 Создание нового контакта\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
        
        let firstName = inputString(prompt: "👤 Имя: ")
        let middlename = inputString(prompt: "👤 Отчество (или Enter, чтобы пропустить): ", allowEmpty: true)
        let surname = inputString(prompt: "👤 Фамилия: ")
        let phone = inputString(prompt: "📱 Телефон (или Enter, чтобы пропустить): ", allowEmpty: true)
        let note = inputString(prompt: "📝 Заметка (или Enter, чтобы пропустить): ", allowEmpty: true)
        
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
        print("\n\(ANSIColors.green)✅ Контакт успешно создан:\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
        print(contact.toStr())
        waitForEnter()
    }
    
    private func showAllContacts() {
        let contacts = contactManager.getAllContacts()
        print("\(ANSIColors.green)\(ANSIColors.bold)👥 Список контактов\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
                print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
            }
        }
        waitForEnter()
    }
} 
