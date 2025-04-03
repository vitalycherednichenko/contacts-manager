import Foundation

struct Contact: Codable {
    let id: Int
    var personalInfo: PersonalInfo
    var connects: ConnectsInfo
    var note: String?
    
    init(id: Int, personalInfo: PersonalInfo = PersonalInfo(), connects: ConnectsInfo = ConnectsInfo(), note: String? = nil) {
        self.id = id
        self.personalInfo = personalInfo
        self.connects = connects
        self.note = note
    }

    func toStr() -> String {
        var result = """
        
        \(ANSIColors.cyan)\(ANSIColors.bold)👤 Контактная информация:\(ANSIColors.reset)
        \(ANSIColors.blue)📛 ФИО: \(ANSIColors.reset)\(personalInfo.surname) \(personalInfo.name)
        """
        
        if !personalInfo.middlename.isEmpty {
            result += " \(personalInfo.middlename)"
        }
        
        if let phone = connects.phone {
            result += "\n\(ANSIColors.blue)📱 Телефон: \(ANSIColors.reset)\(phone)"
        }
        
        if let note = note {
            result += "\n\(ANSIColors.blue)📝 Заметка: \(ANSIColors.reset)\(note)"
        }
        
        result += "\n\(ANSIColors.yellow)───────────────────────────────\(ANSIColors.reset)"
        return result
    }
} 
