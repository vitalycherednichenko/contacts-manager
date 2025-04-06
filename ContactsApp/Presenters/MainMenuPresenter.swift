import Darwin
import Foundation

protocol MainMenuPresenterProtocol {
    
}

class MainMenuPresenter: MainMenuPresenterProtocol {
    private let contactPresenter: ContactPresenter
    private let consoleView: ConsoleView
    
    init() {
        self.contactPresenter = ContactPresenter()
        self.consoleView = ConsoleView()
    }
}
