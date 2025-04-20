import Foundation

protocol ConsoleViewProtocol {
    func inputString(prompt: String, required: Bool) -> String
    func inputInteger(prompt: String, required: Bool) -> Int?
    func displayError(_ message: String)
    func displaySuccess(_ message: String, description: String?)
    func displayInfo(_ message: String)
}

class ConsoleView: ConsoleViewProtocol {

    private func getInput(prompt: String, required: Bool) -> String? {
        callToAction(prompt)
        
        guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
            return nil
        }
        
        if input.lowercased() == "q" {
            return "q"
        }
        
        if input.isEmpty, required {
            displayError("Поле не может быть пустым. Попробуйте снова")
            return nil
        }
        
        return input
    }

    public func inputString(prompt: String, required: Bool = false) -> String {
        while true {
            if let input = getInput(prompt: prompt, required: required) {
                return input
            }
        }
    }
    
    public func inputInteger(prompt: String, required: Bool = false) -> Int? {
        while true {
            if let input = getInput(prompt: prompt, required: required) {
                if input == "q" {
                    return nil
                }
                
                if let number = Int(input) {
                    return number
                } else {
                    displayError("Введите корректное числовое значение")
                }
            }
        }
    }
    
    public func menuHeader(_ text: String) {
        print(
            """
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                                   \(text)                        
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)            
            """)
    }
    
    public func menuTitle(_ text: String) {
        print("\n\(ANSIColors.yellow)\(ANSIColors.bold)\(text)\(ANSIColors.reset)")
    }
    
    public func menuSubTitle(_ text: String) {
        print("\n\(ANSIColors.green)\(ANSIColors.bold)\(text)\(ANSIColors.reset)\n")
    }
    
    public func menuItem(_ text: String) {
        print("\n\(ANSIColors.green)\(text)\(ANSIColors.reset)")
    }
    
    public func menuInfoItem(_ text: String) {
        print("\n\(ANSIColors.yellow)\(text)\(ANSIColors.reset)")
    }
    
    public func callToAction(_ text: String) {
        print("\n\(ANSIColors.cyan)\(text) \(ANSIColors.reset)", terminator: "")
    }
    
    public func menuHr() {
        print("\n\(ANSIColors.yellow)──────────────────────────────────────────────────────\(ANSIColors.reset)")
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
