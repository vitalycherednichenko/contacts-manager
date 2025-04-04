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
        sleep(1)
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)✳️  Обязательное поле отмечено * \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)ℹ️  Нажмите Enter, чтобы пропустить заполнение поля \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────────────\(ANSIColors.reset)")
    }
    
    func showDeleteContact (_ contacts: [Contact]) {
        print("\(ANSIColors.green)\(ANSIColors.bold)👥 Список контактов\(ANSIColors.reset)")
        print("\n\(ANSIColors.yellow)◀️  Если хотите вернутся в меню введите 'q' \(ANSIColors.reset)", terminator: "")
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────\(ANSIColors.reset)")
        
        if contacts.isEmpty {
            print("\(ANSIColors.yellow)📭 Список контактов пуст.\(ANSIColors.reset)")
        } else {
            for contact in contacts {
                print("\n\(ANSIColors.cyan)ID \(contact.id):\(ANSIColors.reset)")
                print(contact.toStr())
            }
        }
        sleep(1)
    }
}
