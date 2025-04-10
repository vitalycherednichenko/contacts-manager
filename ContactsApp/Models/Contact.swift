import Foundation

struct Contact: Codable {
    let id: Int
    var personalInfo: PersonalInfo
    var connects: ConnectsInfo
    var note: String?
    var isMain: Bool = false

    var fullName: String {
        "\(personalInfo.surname) \(personalInfo.name) \(personalInfo.middlename)"
    }
    
    init(
        id: Int,
        personalInfo: PersonalInfo = PersonalInfo(),
        connects: ConnectsInfo = ConnectsInfo(),
        note: String? = nil,
        isMain: Bool = false
    ) {
        self.id = id
        self.personalInfo = personalInfo
        self.connects = connects
        self.note = note
        self.isMain = isMain
    }

    public func toStr() -> String {
        var result = """
        \(ANSIColors.blue)───────────────────────────────\(ANSIColors.reset)
        \(ANSIColors.cyan)\(ANSIColors.bold)👤 Контактная информация:\(ANSIColors.reset)
        \(ANSIColors.cyan)📛 ФИО: \(ANSIColors.reset)\(fullName)
        """
        
        if let phone = connects.phone {
            result += "\n\(ANSIColors.cyan)📱 Телефон: \(ANSIColors.reset)\(phone)"
        }
        
        if let note = note {
            result += "\n\(ANSIColors.cyan)📝 Заметка: \(ANSIColors.reset)\(note)"
        }
        
        if isMain {
            result += "\n\(ANSIColors.green)🌟 Основной контакт\(ANSIColors.reset)"
        }
        
        result += "\n\(ANSIColors.blue)───────────────────────────────\(ANSIColors.reset)"
        return result
    }
} 
