import Foundation

struct ConnectsInfo: Codable {
    var phone: String?
    
    init(phone: String = "") {
        self.phone = phone
    }
} 
