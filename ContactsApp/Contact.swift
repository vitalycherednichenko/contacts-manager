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
        
        ФИО: \(personalInfo.surname) \(personalInfo.name)
        """
        
        if !personalInfo.middlename.isEmpty {
            result += " \(personalInfo.middlename)"
        }
        
        if let phone = connects.phone {
            result += "\nТелефон: \(phone)"
        }
        
        if let note = note {
            result += "\nЗаметка: \(note)"
        }
        
        result += "\n"
        return result
    }
} 
