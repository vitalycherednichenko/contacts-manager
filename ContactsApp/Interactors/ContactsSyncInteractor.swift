import Foundation
import Contacts

class ContactsSyncInteractor {
    private let contactStore = CNContactStore()
    
    // Запрос разрешения на доступ к контактам (синхронно)
    func requestAccess() -> Bool {
        // Проверяем текущий статус доступа
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            // Запрашиваем разрешение синхронно через семафор
            let semaphore = DispatchSemaphore(value: 0)
            var accessGranted = false
            
            contactStore.requestAccess(for: .contacts) { granted, error in
                accessGranted = granted
                semaphore.signal()
            }
            
            // Ждем ответа
            semaphore.wait()
            return accessGranted
        @unknown default:
            return false
        }
    }
    
    // Получение всех контактов из системной адресной книги (синхронно)
    func fetchContacts() -> [CNContact] {
        // Проверяем доступ
        if !requestAccess() {
            print("Доступ к контактам не предоставлен")
            return []
        }
        
        // Ключи для запроса
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactNoteKey as CNKeyDescriptor
        ]
        
        var contacts = [CNContact]()
        
        do {
            // Запрос контактов
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            try contactStore.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
            
            return contacts
        } catch {
            print("Ошибка при получении контактов: \(error.localizedDescription)")
            return []
        }
    }
    
    // Сохранение контактов в JSON файл
    func saveContactsToJson(_ contacts: [CNContact], filename: String = "icloud_contacts.json") -> Bool {
        
        // Преобразуем контакты в словари для сохранения в JSON
        var contactsData: [[String: Any]] = []
        
        for contact in contacts {
            var contactDict: [String: Any] = [:]
            
            // Базовая информация
            contactDict["firstName"] = contact.givenName
            contactDict["lastName"] = contact.familyName
            contactDict["middleName"] = contact.middleName
            
            // Телефоны
            var phones: [String] = []
            for phoneNumber in contact.phoneNumbers {
                phones.append(phoneNumber.value.stringValue)
            }
            contactDict["phones"] = phones
            
            // Безопасно проверяем примечание
            // Проверяем, доступно ли свойство note и не пустое ли оно
            if contact.isKeyAvailable(CNContactNoteKey) && !contact.note.isEmpty {
                contactDict["note"] = contact.note
            }
            
            contactsData.append(contactDict)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: contactsData, options: .prettyPrinted)
            
            // Путь к файлу
            let fileManager = FileManager.default
            let currentDir = fileManager.currentDirectoryPath
            
            // Проверяем существование папки data, если нет - создаем
            let dataFolderPath = currentDir + "/data"
            if !fileManager.fileExists(atPath: dataFolderPath) {
                try fileManager.createDirectory(atPath: dataFolderPath, withIntermediateDirectories: true)
            }
            
            // Полный путь к файлу в папке data
            let fileURL = URL(fileURLWithPath: "\(dataFolderPath)/\(filename)")
            
            try jsonData.write(to: fileURL)
            return true
        } catch {
            print("Ошибка при сохранении контактов в JSON: \(error.localizedDescription)")
            return false
        }
    }
    
    // Конвертация CNContact в нашу модель Contact
    func convertToAppContacts(cnContacts: [CNContact], startIdFrom: Int) -> [Contact] {
        var idCounter = startIdFrom
        var convertedContacts = [Contact]()
        
        for cnContact in cnContacts {
            idCounter += 1
            
            // Получаем имя, фамилию и отчество
            let personalInfo = PersonalInfo(
                name: cnContact.givenName,
                surname: cnContact.familyName,
                middlename: cnContact.middleName
            )
            
            // Получаем номер телефона (берем первый, если он есть)
            var phoneNumber: String? = nil
            if !cnContact.phoneNumbers.isEmpty {
                phoneNumber = cnContact.phoneNumbers.first?.value.stringValue
            }
            
            let connectsInfo = ConnectsInfo(phone: phoneNumber ?? "")
            
            // Безопасно получаем примечание
            var note: String? = nil
            if cnContact.isKeyAvailable(CNContactNoteKey) && !cnContact.note.isEmpty {
                note = cnContact.note
            }
            
            // Создаем контакт
            let contact = Contact(
                id: idCounter,
                personalInfo: personalInfo,
                connects: connectsInfo,
                note: note
            )
            
            convertedContacts.append(contact)
        }
        
        return convertedContacts
    }
    
    // Синхронизация с основной базой данных приложения
    func syncWithAppContacts() -> (imported: Int, total: Int) {
        // Получаем контакты из iCloud
        let icloudContacts = fetchContacts()
        
        if icloudContacts.isEmpty {
            return (0, 0)
        }
        
        // Сохраняем их в JSON для истории/дебага
        _ = saveContactsToJson(icloudContacts)
        
        // Загружаем текущие контакты из файла
        let fileInteractor = FileInteractor()
        var existingContacts = fileInteractor.loadContacts() ?? []
        
        // Находим максимальный ID для новых контактов
        let maxId = existingContacts.map { $0.id }.max() ?? 0
        
        // Преобразуем CNContact в нашу модель Contact
        let newContacts = convertToAppContacts(cnContacts: icloudContacts, startIdFrom: maxId)
        
        // Фильтруем, чтобы исключить дубликаты (простое сравнение по имени и телефону)
        var importedContacts: [Contact] = []
        for newContact in newContacts {
            let isDuplicate = existingContacts.contains { existingContact in
                let sameNames = existingContact.personalInfo.name == newContact.personalInfo.name &&
                                existingContact.personalInfo.surname == newContact.personalInfo.surname
                let samePhone = existingContact.connects.phone == newContact.connects.phone
                return sameNames && samePhone
            }
            
            if !isDuplicate {
                importedContacts.append(newContact)
            }
        }
        
        // Добавляем импортированные контакты к существующим
        existingContacts.append(contentsOf: importedContacts)
        
        // Сохраняем обновленный список
        try? fileInteractor.saveContacts(existingContacts)
        
        return (importedContacts.count, icloudContacts.count)
    }
} 
