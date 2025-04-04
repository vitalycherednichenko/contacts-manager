import Darwin
import Foundation

protocol MainMenuPresenterProtocol {
    func handleInput(_ input: String, view: MainMenuViewProtocol)
}

class MainMenuController: MainMenuPresenterProtocol {
    private let contactController: ContactController
    private let consoleView: ConsoleView
    
    init() {
        self.contactController = ContactController()
        self.consoleView = ConsoleView()
    }
    
    func handleInput(_ input: String, view: MainMenuViewProtocol) {
//        switch input {
//        case "1": addContact()
//        case "2": showContacts()
//        case "3": deleteContact()
//        case "6":
//            consoleView.displaySuccess("До свидания! Спасибо за использование нашего приложения! 👋")
//            exit(0)
//        default:
//            consoleView.displayError("Неверный выбор. Попробуйте снова.")
//        }
//        
//        view.run()
    }
}
