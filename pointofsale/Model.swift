
import Foundation
import SwiftUI

struct DataUser : Codable {
    var user_id: String
    var user_name: String
    var user_pin: String
    var branch_id: String
}

struct DataBranch : Codable {
    var branch_id: String
    var branch_name: String
    var branch_address: String
    var branch_telp: String
    var branch_city: String
}
