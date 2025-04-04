import Foundation

protocol MenuViewProtocol {
    func showMainMenu() -> String?
}

class MenuView: MenuViewProtocol {
    
    func showMainMenu() -> String? {
        clearScreen()
        let version = getAppVersion()
        print("""
                \(ANSIColors.cyan)\(ANSIColors.bold)╔════════════════════════════════════════════════════════════╗
                ║                📱 Контакты людей \(version)              ║
                ╚════════════════════════════════════════════════════════════╝\(ANSIColors.reset)
                
                \(ANSIColors.yellow)\(ANSIColors.bold)Выберите действие:\(ANSIColors.reset)
                
                \(ANSIColors.green)1. 📝 Добавить новый контакт
                2. 👥 Просмотреть все контакты
                6. 🚪 Выход\(ANSIColors.reset)
                
                \(ANSIColors.blue)Ваш выбор: \(ANSIColors.reset)
                """, terminator: "")
        
        return readLine()
    }

    private func getAppVersion() -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["describe", "--tags", "--abbrev=0"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            if let data = try? pipe.fileHandleForReading.readToEnd(),
               let version = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                return version
            }
        } catch {
            print("Ошибка при получении версии: \(error)")
        }
        
        return "1.0"
    }
    
    private func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
}
