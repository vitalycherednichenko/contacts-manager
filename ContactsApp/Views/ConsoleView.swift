//
//  ConsoleView.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

protocol ConsoleViewProtocol {
    func inputString(prompt: String, required: Bool) -> String?
    func displayError(_ message: String)
    func displaySuccess(_ message: String, description: String?)
    func displayInfo(_ message: String)
}

class ConsoleView: ConsoleViewProtocol {
    
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
                displayError("Поле не может быть пустым. Попробуйте снова")
                continue
            }
            
            return input
        }
    }
    
    public func displayError(_ message: String) {
        print("\n\(ANSIColors.red)⚠️  \(message)\(ANSIColors.reset)")
        sleep(1)
    }
    
    public func displaySuccess(_ message: String, description: String? = nil) {
        print("\n\(ANSIColors.green)✅ \(message)\(ANSIColors.reset)")
        if let description = description {
            print("\n\(description)")
        }
        sleep(1)
    }
    
    public func displayInfo(_ message: String) {
        sleep(1)
        print("\n\(ANSIColors.yellow)ℹ️  \(message) \(ANSIColors.reset)", terminator: "")
        _ = readLine()
    }
    
    public func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
}
