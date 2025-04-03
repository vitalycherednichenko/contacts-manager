import Foundation

struct PersonalInfo: Codable {
    var name: String = ""
    var surname: String = ""
    var middlename: String = ""
    
    init(name: String = "", surname: String = "", middlename: String = "") {
        self.name = name
        self.surname = surname
        self.middlename = middlename
    }
} 