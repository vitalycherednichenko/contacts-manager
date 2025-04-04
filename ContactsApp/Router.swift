//
//  Router.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

protocol RouterProtocol {
    func showMainMenu()
    func showContactsMenu()
    func showProfileMenu()
    func showSettingsMenu()
}

class Router: RouterProtocol {
    
    func showMainMenu() {
        let view = MainMenuView(router: self)
        view.run()
    }
    
    func showContactsMenu() {
        let view = ContactsMenuView(router: self)
        view.run()
    }
    
    func showProfileMenu() {
        print("showProfileMenu")
    }
 
    func showSettingsMenu() {
        print("showSettingsMenu")
    }
}


