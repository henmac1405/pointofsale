import Foundation
import SwiftUICore
import UIKit
import SwiftyJSON
import CryptoKit
import Combine

class Controller : ObservableObject{
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var isCorrect = true
    @Published var url_api = "https://api.transstudiomini.com/index.php/apiv5/"
    
    @Published var showAlert = false
    @Published var messageAlert = ""
    @Published var SecretKeyNoLog = ""
    @Published var companyID = ""
    @Published var responseMessage = ""
    @Published var signature = ""
    @Published var apiKey = ""
    @Published var token = ""
    @Published var username = ""
    @Published var user_password = ""
    @Published var user_id = ""
    @Published var user_pin = ""
    @Published var user_name = ""
    @Published var branch_id = ""
    @Published var imageUrl = "https://api.transstudiomini.com/assets/img/LOGO-MAINIA-MERAH-BIRU.jpg"
    
    
     
    //Model
    @Published var dataUser : [DataUser] = []
    @Published var dataBranch : [DataBranch] = []
    
    
    // Function ==================================================================================
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm:ss zzz"
        
        return formatter.string(from: Date())
    }
    
    func generateToken() -> String {
        
        let headerDict = ["typ": "API", "alg": "SHA256"]
        guard let headerData = try? JSONEncoder().encode(headerDict) else { return "" }
        let headerBase64 = headerData.base64EncodedString()
        
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime] // Menghasilkan format Z tanpa milidetik
        let timestampStr = formatter.string(from: Date())
        
        let timestampBase64 = Data(timestampStr.utf8).base64EncodedString()
        print("timestamp : \(timestampBase64)")
        
        //let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        
        
        let randomHex = generateRandomHexString(length: 20)
        let payloadBase64 = Data(randomHex.utf8).base64EncodedString()
        
        
        let combined = "\(headerBase64).\(timestampBase64).\(payloadBase64)"
        let finalToken = Data(combined.utf8).base64EncodedString()
        
        return finalToken
    }
    
    func generateRandomHexString(length: Int) -> String {
        let letters = "0123456789abcdef"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    func generateSignature(secretKey: String) -> String {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        
        let headerDict = ["typ": "API", "alg": "SHA256"]
        guard let headerData = try? JSONEncoder().encode(headerDict) else { return "" }
        let headerBase64 = headerData.base64EncodedString()
         
        let payloadBase64 = Data(secretKey.utf8).base64EncodedString()
         
        let tsBase64 = Data(timestampWithZ.utf8).base64EncodedString()
         
        let combinedSecretKey = "\(headerBase64).\(payloadBase64).\(tsBase64)"
         
        return Data(combinedSecretKey.utf8).base64EncodedString()
    }
    
    //API ============================================================================================
    
    
    
    func getCompany() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        
        self.SecretKeyNoLog = self.generateToken()
        
        print("SecretKeyNoLog : \(self.SecretKeyNoLog)")
        
        guard let url = URL(string: self.url_api + "company/show") else { return}
        print(url)
        
        
        
        print(timestampWithZ)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["":""]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        request.setValue(self.SecretKeyNoLog, forHTTPHeaderField: "SECRETKEY")
        
        print(request)
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            print(json)
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.isLoading = true
                    self.showAlert = false
                    self.isCorrect = true
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.companyID = subJson["value"].stringValue
                        self.getAPIKey()
                    }
                } else {
                    self.isLoading = false
                    self.showAlert = true
                    self.isCorrect = false
                }
                
                
                
            }
        }.resume()
        
    }
    
    func getAPIKey() {
        
        let apiname = "apikey/show"
        
        self.signature = generateSignature(secretKey: companyID)
        print("signature : \(self.signature)")
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["":""]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue(self.signature, forHTTPHeaderField: "SECRETKEY")
         
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            //            var fetchedPosts: [DataCompany] = []
            
            let json = JSON(data)
            let message = json["message"].stringValue
            print(message)
            print(json["state"])
            
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.apiKey = json["data"].stringValue
                    print(self.apiKey)
                    self.isCorrect = true
                    self.showAlert = false
                    self.getToken()
                } else {
                    self.isCorrect = false
                    self.responseMessage = message
                    self.showAlert = true
                }
            }
        }.resume()
    }
    func getToken() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "token/show"
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["":""]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
             
            let json = JSON(data)
            let message = json["message"].stringValue
            print(message)
            print(json["state"])
            
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.token = json["data"].stringValue
                    self.isCorrect = true
                    self.showAlert = false
                    self.isLoading = true
                    self.getLogin()
                } else {
                    self.isCorrect = false
                    self.isLoading = false
                    self.isLoggedIn = false
                    self.showAlert = true
                }
            }
        }.resume()
    }
    func getLogin() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "login/login"
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("user_id : \(self.username)")
        print("user_pin : \(self.user_password)")
        print("password : \(self.user_password.md5.uppercased())")
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "user_id", value: self.username),
            URLQueryItem(name: "user_pin", value: self.user_password.md5.uppercased()),
            URLQueryItem(name: "device_id", value: "IOS")
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
             
            let json = JSON(data)
            let message = json["message"].stringValue
            print(json)
            print(message)
            print(json["state"])
            
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.isCorrect = true
                    self.showAlert = false
                    self.isLoading = false
                    self.isLoggedIn = true
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.user_id = subJson["user_id"].stringValue
                        self.user_pin = subJson["user_pin"].stringValue
                        self.user_name = subJson["user_name"].stringValue
                        self.branch_id = subJson["branch_id"].stringValue
                    }
                } else {
                    self.responseMessage = message
                    print("error : \(self.responseMessage)")
                    self.isCorrect = false
                    self.isLoading = false
                    self.isLoggedIn = false
                    self.showAlert = true
                }
            }
        }.resume()
    }
    
    func getBranch() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "branch/branch"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("user_id : \(self.username)")
        print("user_pin : \(self.user_password)")
        print("password : \(self.user_password.md5.uppercased())")
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "branch_id", value: "")
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
             
            let json = JSON(data)
            let message = json["message"].stringValue
            print(json)
            print(message)
            print(json["state"])
            self.dataBranch.removeAll()
            
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.isCorrect = true
                    self.showAlert = false
                    self.isLoading = false
                    for (_, subJson):(String, JSON) in json["data"] {
                        let id = subJson["branch_id"].stringValue
                        let name = subJson["branch_name"].stringValue
                        let address = subJson["branch_address"].stringValue
                        let telp = subJson["branch_telp"].stringValue
                        let city = subJson["branch_city"].stringValue
                        self.dataBranch.append(DataBranch(branch_id: id, branch_name : name, branch_address: address, branch_telp: telp, branch_city: city))
                    }
                } else {
                    self.responseMessage = message
                    print("error : \(self.responseMessage)")
                    self.isCorrect = false
                    self.isLoading = false
                    self.showAlert = true
                }
            }
        }.resume()
    }
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
