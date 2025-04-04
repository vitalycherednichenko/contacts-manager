//
//  ConsoleView.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

class ConsoleView {
    private let message: MessageView
    
    init () {
        self.message = MessageView()
    }
    
    public func inputString(prompt: String, allowEmpty: Bool = false) -> String {
        while true {
            print("\(ANSIColors.cyan)\(prompt)\(ANSIColors.reset)", terminator: "")
            if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
                if allowEmpty || !input.isEmpty {
                    return input
                }
            }
            if !allowEmpty {
                message.displayError("Ввод не может быть пустым. Попробуйте снова")
            } else {
                return ""
            }
        }
    }
}
