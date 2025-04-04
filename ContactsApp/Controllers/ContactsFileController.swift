import Foundation

class ContactsFileController {
    private(set) var fileURL: URL
    
    init() {
        fileURL = URL(fileURLWithPath: "contacts.json", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        print("Файл контактов: \(fileURL.path)")
    }
    
    func setTestFileURL(_ url: URL) {
        fileURL = url
    }
    
    func saveContacts(_ contacts: [Contact]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(contacts)
        try data.write(to: fileURL, options: Data.WritingOptions.atomic)
    }
    
    func loadContacts() -> [Contact]? {
        do {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                print("Файл не существует: \(fileURL.path)")
                return nil
            }
            
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let contacts = try decoder.decode([Contact].self, from: data)
            print("Контакты успешно загружены из файла: \(fileURL.path)")
            return contacts
        } catch {
            print("Ошибка загрузки данных: \(error.localizedDescription)")
            print("Путь к файлу: \(fileURL.path)")
            return nil
        }
    }
} 
