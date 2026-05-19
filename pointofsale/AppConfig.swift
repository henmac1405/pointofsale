import Foundation
import SwiftData

@Model
class AppConfig {
    var urlApiTe: String
    var urlApiAllo: String
    var lastUpdated: Date
    
    init(urlApiTe: String, urlApiAllo: String) {
        self.urlApiTe = urlApiTe
        self.urlApiAllo = urlApiAllo
        self.lastUpdated = Date()
    }
}
 
