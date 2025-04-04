//
//  ContactView.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

class ContactView {
    private let message: MessageView
    
    init () {
        self.message = MessageView()
    }
    
    public func showAllContacts(_ contacts: [Contact]) {
        print("\(ANSIColors.green)\(ANSIColors.bold)👥 Список контактов\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        message.displayInfo("Нажмите Enter для продолжения...")
    }
    
    func showCreateContact () {
        print("\(ANSIColors.green)\(ANSIColors.bold)📝 Создание нового контакта\(ANSIColors.reset)")
        print("\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)")
    }
}
