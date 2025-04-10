import Foundation

class FileInteractor {
    private(set) var fileURL: URL
    private let dataFolderPath: String
    
    init() {
        let fileManager = FileManager.default
        let currentDir = fileManager.currentDirectoryPath
        self.dataFolderPath = currentDir + "/data"
        
        // Проверяем существование папки data, если нет - создаем
        if !fileManager.fileExists(atPath: dataFolderPath) {
            do {
                try fileManager.createDirectory(atPath: dataFolderPath, withIntermediateDirectories: true)
            } catch {
                print("Ошибка при создании папки data: \(error.localizedDescription)")
            }
        }
        
        // Создаем URL для файла в папке data
        fileURL = URL(fileURLWithPath: "contacts.json", relativeTo: URL(fileURLWithPath: dataFolderPath))
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
            return contacts
        } catch {
            print("Ошибка загрузки данных: \(error.localizedDescription)")
            print("Путь к файлу: \(fileURL.path)")
            return nil
        }
    }
} 
