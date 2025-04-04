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
    
    public func inputString(prompt: String, required: Bool = false) -> String? {
        while true {
            print("\(ANSIColors.cyan)\(prompt)\(ANSIColors.reset)", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            if input.lowercased() == "q" {
                return nil
            }
            
            if input.isEmpty, required {
                message.displayError("Поле не может быть пустым. Попробуйте снова")
                continue
            }
            
            return input
        }
    }
}
