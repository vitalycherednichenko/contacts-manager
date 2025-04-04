//
//  ConsoleView.swift
//  ContactsApp
//
//  Created by Vitaly on 04.04.2025.
//

import Foundation

protocol MessageViewProtocol {
    func displayError(_ message: String)
    func displaySuccess(_ message: String)
    func displayInfo(_ message: String)
}

class MessageView {
    
    func displayError(_ message: String) {
        print("\n\(ANSIColors.red)⚠️  \(message)\(ANSIColors.reset)")
        sleep(1)
    }
    
    func displaySuccess(_ message: String, description: String? = nil) {
        print("\n\(ANSIColors.green)✅ \(message)\(ANSIColors.reset)")
        if let description = description {
            print("\n\(description)")
        }
        sleep(1)
    }
    
    func displayInfo(_ message: String) {
        sleep(1)
        print("\n\(ANSIColors.yellow)ℹ️  \(message) \(ANSIColors.reset)", terminator: "")
        _ = readLine()
    }
}
