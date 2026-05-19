import Foundation
import SwiftData
import SwiftUICore
import UIKit
import SwiftyJSON
import CryptoKit
import Combine

class Controller : ObservableObject{
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var isCorrect = true
    @Published var url_api = ""
    @Published var url_api_allo = ""
    @Published var formType = ""
    @Published var result_cekkoneksiTE = ""
    @Published var result_cekkoneksiAllo = ""
    @Published var showAlert = false
    @Published var messageAlert = ""
    @Published var SecretKeyNoLog = ""
    @Published var companyID = ""
    @Published var responseMessage = ""
    @Published var signature = ""
    @Published var apiKey = ""
    @Published var token = ""
    @Published var POSVersion = "5.0.3"
    @Published var POSupdate = "Last Update 11 Febuari 2026"
    
    @Published var isAutoShowSyncronize = false
    @Published var showSyncronize = false
    @Published var messageSyncronize = ""
    
    //mandatory
    @Published var channel_id = ""
    @Published var region_id = ""
    @Published var branch_id = ""
    @Published var branch_name = ""
    @Published var machine_id = ""
    @Published var machine_name = ""
    @Published var terminal_id = ""
    @Published var terminal_name = ""
    @Published var cashier = 0
    @Published var supervisor = 0
    @Published var manager = 0
    @Published var isdiscount = 0
    @Published var strukturunit_id = ""
    @Published var sales_id = ""
    @Published var daily_id = ""
    
    //User
    @Published var username = ""
    @Published var user_password = ""
    @Published var user_id = ""
    @Published var user_pin = ""
    @Published var user_fullname = ""
    
    @Published var imageUrl = "https://api.transstudiomini.com/assets/img/LOGO-MAINIA-MERAH-BIRU.jpg"
    
    //Device
    @Published var deviceID : String = ""
    @Published var deviceName : String = ""
    @Published var deviceDescr : String = ""
    @Published var deviceModel : String = ""
    @Published var deviceOS : String = ""
    @Published var deviceOSVersion : String = ""
    @Published var deviceUUID : String = ""
    @Published var iosID : String = ""
    
    //Branch
    
    
    //Register
    @Published var registrasiDescr = ""
    @Published var registrasiStatus = 0
    @Published var registrasiBranch = ""
    @Published var registrasiMachine = ""
    @Published var registrasiSerialNumber = ""
    @Published var registrasiKeterangan = ""
    
    //Model
    @Published var dataUser : [DataUser] = []
    @Published var dataBranch : [DataBranch] = []
    @Published var dataProgramPos : [DataProgramPos] = []
    @Published var customer : [Customer] = []
    @Published var status : [Status] = []
    @Published var payment : [Payment] = []
    @Published var log : [Log] = []
    
    
    @Published var filterIsParent = 1
    @Published var parent_id = "" 
    
    var filteredData: [DataProgramPos] {
        if filterIsParent == 1 {
            return dataProgramPos.filter { item in
                item.isparent == 1
            }
        } else {
            return dataProgramPos.filter { item in
                item.parent_id == parent_id
            }
        }
            
    }
     
    
     
    

    // Function ===========================================================================================================================================
    
    func getFormattedDateTimeFull() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm:ss zzz"
        
        return formatter.string(from: Date())
    }
    
    func getFormattedDateDDMMMMYYYY() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "dd MMMM yyyy"
        
        return formatter.string(from: Date())
    }
    
    func getFormattedDateYYYYMMdd() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: Date())
    }
    
    func getFormattedDateDailyID() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "yyMMdd"
        
        return formatter.string(from: Date())
    }
    
    func getFormattedDateSalesID() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.string(from: Date())
    }
    
    func getFormattedTime() -> String {
        let formatter = DateFormatter()
        
        
        formatter.locale = Locale(identifier: "id_ID")
        
        
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: Date())
    }
    
    func formatNumber(_ value: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    
    func generateToken() -> String {
        
        let headerDict = ["typ": "API", "alg": "SHA256"]
        guard let headerData = try? JSONEncoder().encode(headerDict) else { return "" }
        let headerBase64 = headerData.base64EncodedString()
        
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
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
    
    
    // Transaksi Penjualan ========================================================================================
    
    func insertStatus(salesid : String, cust_id : String, cust_name : String, salestypeid : String, salesman_id : String, salesman_name : String, shift_id : String){
        let DateNow = Date()
        let iSalesdate = Int(DateNow.timeIntervalSince1970)
        
        status.append(Status(
            salesid : sales_id,
            Strsalesdate : getFormattedDateYYYYMMdd(),
            Salesdate : iSalesdate,
            Qty : 1,
            Is_open : 0,
            Is_discount : 0,
            Totalsales : 0,
            Totalpayment : 0,
            Totalchange : 0,
            Cust_id : cust_id,
            Cust_name : cust_name,
            Table_id : "",
            Table_no : "",
            Styler_id : "",
            Styler_name : "",
            Create_by : user_id,
            Create_date : iSalesdate,
            Modify_by : "",
            Modify_date : 0,
            Salestype_id : salestypeid,
            Salestype_name : salestypeid,
            Keterangan : "",
            Is_temp : 0,
            Dailyid : getFormattedDateDailyID(),
            Branchid : branch_id,
            Regionid : region_id,
            Channelid : channel_id,
            Machineid : machine_id,
            Shift_id : shift_id,
            Card_number : "",
            Device_id : deviceModel,
            Posversion : POSVersion,
            Ticketdate : iSalesdate,
            Salesman_id : salesman_id,
            Salesman_name : salesman_name
        ))
        
    }
    
    func insertLog(salesid : String, iteminventory_id : String, iteminventory_name : String, iteminventory_qty : Int, price : Double, tax : Double, disc_id : String, disc_name : String, disc_percent : Double, salestypeid : String){
        let DateNow = Date()
        let iSalesdate = Int(DateNow.timeIntervalSince1970)
        
        var _qty = 0
        var _price  = price
        
        //cari data item yang sama sebalum nya
        let dataLog = log.filter { item in
            item.Id == iteminventory_id
        }
        print("datalog : ")
        print(dataLog)
        if dataLog.count > 0 {
            print("sudah ada 1")
            for logs in dataLog {
                print("Ditemukan: \(logs.Name)")
                _qty = iteminventory_qty + logs.Qty
            }
        } else {
            _qty = iteminventory_qty
        }
        print("qty : \(_qty)")
        var subtotal : Double = 0
        var disc_amount : Double = 0
        var tax_amount : Double = 0
        var total : Double = 0
        subtotal = Double(_qty) * _price
        
        if disc_percent > 0 {
            disc_amount = subtotal * disc_percent / 100
        }
        if tax > 0 {
            tax_amount = (subtotal - disc_amount) * tax / 100
        }
        
        total = subtotal - disc_amount + tax_amount
        
        let line = log.count * 10
        
        
        
        if dataLog.count > 0 {
            print("sudah ada 2")
            updateLogbyID(salesid: salesid, id: iteminventory_id, name: iteminventory_name, qty: _qty, price: _price, subtotal: subtotal, total: total, disc_amount: disc_amount, tax_amount: tax_amount)
        } else {
            log.append(Log(
                Line : line,
                Salesid : sales_id,
                Id : iteminventory_id,
                Name : iteminventory_name,
                Qty : iteminventory_qty,
                Price : price,
                Subtotal : subtotal,
                Discid : disc_id,
                Discname : disc_name,
                Discpercent : disc_percent,
                Discamount : disc_amount,
                Taxid : "",
                Taxname : "",
                Taxpercent : tax,
                Taxamount : tax_amount,
                Total : total,
                Hold : 0,
                Finish : 0,
                Salesdate : iSalesdate,
                Strsalesdate : getFormattedDateYYYYMMdd(),
                Create_date : iSalesdate,
                Create_by : user_id,
                Modify_date : 0,
                Modify_by : "",
                Note : "",
                Dailyid : getFormattedDateDailyID(),
                Branchid : branch_id,
                Regionid : region_id,
                Channelid : channel_id,
                Machineid : machine_id,
                Promoph_id : "",
                Promo_id : "",
                Promo_name : "",
                Salestypeid : salestypeid
            ))
        }
    }
    func insertPayment(salesid : String, tender_id : String, tender_name : String, tender_type : String, tender_code : String, sales_amount : Double, payment_amount : Double, change_amount : Double, dailyid : String){
        payment.removeAll()
        payment.append(Payment(
            Salesid : salesid,
              Line : 10,
              Tenderid : tender_id,
              Tendername : tender_name,
              Tendertype : tender_type,
              Tendercode : tender_code,
              Salesamount : sales_amount,
              Paymentamount : payment_amount,
              Changeamount : change_amount,
              Disable : 0,
              Dailyid : dailyid,
            Branchid : branch_id,
            Regionid : region_id,
            Channelid : channel_id,
            Machineid : machine_id))
    }
    func updateLogbyID(salesid: String, id: String, name: String, qty : Int, price : Double, subtotal : Double, total : Double, disc_amount : Double, tax_amount : Double) {
        if let index = self.log.firstIndex(where: { $0.Salesid == salesid && $0.Id == id}) {
            self.log[index].Qty = qty
            self.log[index].Subtotal = subtotal
            self.log[index].Total = total
            self.log[index].Discamount = disc_amount
            self.log[index].Taxamount = tax_amount
            
            print("Logs dengan name \(name) berhasil diperbarui.")
        } else {
            print("Logs tidak terpenuhi dengan name \(name) tidak ditemukan.")
        }
    }
    func updateStatusCustomer(salesid: String, id: String, name: String) {
        if let index = self.status.firstIndex(where: { $0.salesid == salesid }) {
            self.status[index].Cust_id = id
            self.status[index].Cust_name = name
            
            print("Customer dengan ID \(salesid) berhasil diperbarui.")
        } else {
            print("Kondisi tidak terpenuhi: Customer dengan ID \(salesid) tidak ditemukan.")
        }
    }
    
    func updateStatusSalesman(salesid: String, id: String, name: String) {
        if let index = self.status.firstIndex(where: { $0.salesid == salesid }) {
            self.status[index].Salesman_id = id
            self.status[index].Salesman_name = name
            
            print("Salesman dengan ID \(salesid) berhasil diperbarui.")
        } else {
            print("Kondisi tidak terpenuhi: Salesman dengan ID \(salesid) tidak ditemukan.")
        }
    }
    
    func updateStatusTotalSales(salesid: String, totalsales: Double) {
        if let index = self.status.firstIndex(where: { $0.salesid == salesid }) {
            self.status[index].Totalsales = totalsales
            
            print("TotalSales dengan ID \(salesid) berhasil diperbarui.")
        } else {
            print("Kondisi tidak terpenuhi: TotalSales dengan ID \(salesid) tidak ditemukan.")
        }
    }
    
    func insertItemSize(context: ModelContext, itemAdd_name : String, itemAdd_qty : Int) {
        do {
            try context.delete(
                        model: ItemSize.self,
                        where: #Predicate<ItemSize> { item in
                            item.itemsize_name == itemAdd_name
                        }
                    )
            try context.save()
            
            let newData = ItemSize(itemsize_id: itemAdd_name, itemsize_name: itemAdd_name, itemsize_descr: itemAdd_name, itemsize_qty: itemAdd_qty)
            
            context.insert(newData)
            try context.save()
            
            print("ItenSize dengan name \(itemAdd_name) berhasil diperbarui.")
            
        } catch {
            print("Gagal memperbarui database ItemSize \(itemAdd_name) : \(error.localizedDescription)")
        }
    }
    
    //update ItemAdd Status
    func updateItemAdd_Status(name: String, status: Int) {
        do {
            
            let descriptor = FetchDescriptor<ItemAdd>(
                predicate: #Predicate<ItemAdd> { item in
                    item.itemadd_name == name
                }
            )
             
            let itemsToUpdate = try modelContext.fetch(descriptor)
            
             
            for item in itemsToUpdate {
                item.itemadd_status = status
            }
            
            
            try modelContext.save()
            print("Berhasil memperbarui \(itemsToUpdate.count) data.")
            
        } catch {
            print("Gagal mengupdate data: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    //API =====================================================================================================================
    
    
    
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
                self.showAlert = true
                self.responseMessage = "Error : \(error.localizedDescription)"
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
                self.showAlert = true
                self.responseMessage = "Error : \(error.localizedDescription)"
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
                self.showAlert = true
                self.responseMessage = "Error : \(error.localizedDescription)"
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
                    if (self.formType == "CekKoneksiTE" || self.formType == "CekKoneksiAllo"){
                        self.CekKoneksi()
                    } else if (self.formType == "Login"){
                        print("Login")
                        self.getVersionByType()
                    } else if (self.formType == "Registrasi"){
                        self.getDeviceRegister()
                        print("Registrasi")
                    } else {
                        print("NULL FORM TYPE")
                    }
//
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
                self.showAlert = true
                self.responseMessage = "Error : \(error.localizedDescription)"
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
                    
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.user_id = subJson["user_id"].stringValue
                        self.user_pin = subJson["user_pin"].stringValue
                        self.user_fullname = subJson["user_name"].stringValue
                        self.cashier = subJson["cashier"].intValue
                        self.supervisor = subJson["supervisor"].intValue
                        self.manager = subJson["manager"].intValue
                        self.isdiscount = subJson["discount"].intValue
                        self.strukturunit_id = subJson["strukturunit_id"].stringValue
                        print("user_id : \(self.user_id)")
                        print("user_pin : \(self.user_pin)")
                        print("user_fullname : \(self.user_fullname)")
                        print("cashier : \(self.cashier)")
                        print("supervisor : \(self.supervisor)")
                        print("manager : \(self.manager)")
                        print("strukturunit_id : \(self.strukturunit_id)")
                        let branchuser_id = subJson["branch_id"].stringValue
                        if (branchuser_id != self.branch_id) {
                            self.isLoggedIn = false
                            self.showAlert = true
                            self.responseMessage = "Akun Pemakai bukan untuk Cabang ini"
                        } else {
                            self.isLoggedIn = true
                            self.syncProgrampos()
                        }
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
    
    func getVersionByType() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "version/version"
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: ""),
            URLQueryItem(name: "region_id", value: ""),
            URLQueryItem(name: "region_id", value: ""),
            URLQueryItem(name: "type", value: "POS")
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error:", error.localizedDescription)
                self.showAlert = true
                self.responseMessage = "Error : \(error.localizedDescription)"
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
                    for (_, subJson):(String, JSON) in json["data"] {
                        let version_id = subJson["version_id"].stringValue
                        print("version_id : \(version_id)")
                        if (version_id == self.POSVersion){
                            self.getDeviceRegister()
                        } else {
                            self.showAlert = true
                            self.responseMessage = "Bukan Versi terbaru, segera update aplikasi anda"
                        }
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
    
    func CekKoneksi() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "cek_koneksi/show"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "id", value: "")
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
                    if(self.formType == "CekKoneksiTE"){
                        self.result_cekkoneksiTE = "Success"
                    } else if(self.formType == "CekKoneksiAllo"){
                        self.result_cekkoneksiAllo = "Success"
                    }
                } else {
                    self.responseMessage = message
                    print("error : \(self.responseMessage)")
                    self.isCorrect = false
                    self.isLoading = false
                    self.showAlert = true
                    if(self.formType == "CekKoneksiTE"){
                        self.result_cekkoneksiTE = message
                    } else if(self.formType == "CekKoneksiAllo"){
                        self.result_cekkoneksiAllo = message
                    }
                }
            }
        }.resume()
    }
    
    func getDeviceRegister() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "register/device_get"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "id", value: self.deviceID),
            URLQueryItem(name: "manufacturer", value: "Apple"),
            URLQueryItem(name: "model", value: self.deviceModel),
            URLQueryItem(name: "product", value: self.deviceName),
            URLQueryItem(name: "brand", value: "Apple"),
            URLQueryItem(name: "display", value: "-"),
            URLQueryItem(name: "board", value: "-"),
            URLQueryItem(name: "device", value: self.deviceDescr),
            URLQueryItem(name: "androidId", value: self.iosID)
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
                        self.registrasiStatus = subJson["isapproved"].int!
                        self.registrasiBranch = subJson["branch_name"].stringValue + " - " + subJson["machine_name"].stringValue
                        self.registrasiKeterangan = subJson["keterangan"].stringValue
                        self.registrasiSerialNumber = subJson["terminal_id"].stringValue
                        if (self.registrasiStatus == 1){
                            self.registrasiDescr = "PERANGKAT SUDAH TERDAFTAR"
                        } else if (self.registrasiStatus == 2){
                            self.registrasiDescr = "PERANGKAT BELUM DI APPROVE"
                        } else {
                            self.registrasiDescr = "PERANGKAT BELUM TERDAFTAR"
                        }
                        if (self.formType == "Login"){
                            if (self.registrasiStatus != 1){
                                self.showAlert = true
                                self.responseMessage = "PERANGKAT BELUM TERDAFTAR"
                            } else {
                                self.channel_id = subJson["channel_id"].stringValue
                                self.region_id = subJson["region_id"].stringValue
                                self.branch_id = subJson["branch_id"].stringValue
                                self.branch_name = subJson["branch_name"].stringValue
                                self.machine_id = subJson["machine_id"].stringValue
                                self.machine_name = subJson["machine_name"].stringValue
                                self.terminal_id = subJson["terminal_id"].stringValue
                                print("channel_id : \(self.channel_id)")
                                print("region_id : \(self.region_id)")
                                print("branch_id : \(self.branch_id)")
                                print("branch_name : \(self.branch_name)")
                                print("machine_id : \(self.machine_id)")
                                print("machine_name : \(self.machine_name)")
                                print("terminal_id : \(self.terminal_id)")
                                self.getTerminal()
                            }
                        }
                    }
                } else {
                    self.responseMessage = message
                    print("error : \(self.responseMessage)")
                    self.isCorrect = false
                    self.isLoading = false
                    self.showAlert = true
                    self.registrasiDescr = "PERANGKAT BELUM TERDAFTAR"
                    self.registrasiStatus = 0
                }
            }
        }.resume()
    }
    
    func getTerminal() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "terminal/terminal_find"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "terminal_id", value: self.terminal_id),
            URLQueryItem(name: "salestype_id", value: ""),
            URLQueryItem(name: "branch_id", value: self.branch_id),
            URLQueryItem(name: "machine_id", value: self.machine_id),
            URLQueryItem(name: "mac_address", value: "")
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
                    self.isLoading = true
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.terminal_name = subJson["terminal_name"].stringValue
                        print("terminal_name : \(self.terminal_name)")
                    }
                    self.getLogin()
                } else {
                    self.responseMessage = "Terminal Not Found"
                    print("error : \(self.responseMessage)")
                    self.isCorrect = false
                    self.isLoading = false
                    self.showAlert = true
                }
            }
        }.resume()
    }
    
    func insertDeviceRegister(completion: @escaping (JSON?) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "register/device_insert"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "id", value: self.deviceID),
            URLQueryItem(name: "manufacturer", value: "Apple"),
            URLQueryItem(name: "model", value: self.deviceModel),
            URLQueryItem(name: "product", value: self.deviceName),
            URLQueryItem(name: "brand", value: "Apple"),
            URLQueryItem(name: "display", value: "-"),
            URLQueryItem(name: "board", value: "-"),
            URLQueryItem(name: "device", value: self.deviceDescr),
            URLQueryItem(name: "androidId", value: self.iosID),
            URLQueryItem(name: "branch_id", value: ""),
            URLQueryItem(name: "region_id", value: ""),
            URLQueryItem(name: "channel_id", value: ""),
            URLQueryItem(name: "keterangan", value: self.registrasiKeterangan),
            URLQueryItem(name: "machine_id", value: ""),
            URLQueryItem(name: "terminal_id", value: self.registrasiSerialNumber)
            
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
                completion(json)
            }
        }.resume()
    }
    
    func updateDeviceRegister(completion: @escaping (JSON?) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "qris/query_update"
        
        self.isLoading = true
        
        var sql = "update posdeviceregister set terminal_id = '9FA523DAF5', branch_id = '1711036', machine_id = 'ticket', channel_id = 'KDC', region_id = '00100', isapproved = '1' where manufacturer = 'Apple'"
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "sql", value: sql),
            
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
                completion(json)
            }
        }.resume()
    }
    
    func custonerfindbynohp(noHP : String, completion: @escaping (JSON?) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "customer/customer_findbynohp"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "nohp", value: noHP)
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
            
            self.customer.removeAll()
            
            DispatchQueue.main.async {
                self.responseMessage = message
                self.messageSyncronize = message
                if (json["state"] == true){
                    self.isLoading = false
                } else {
                    print("error : \(self.responseMessage)")
                    self.isLoading = false
                }
                completion(json)
            }
        }.resume()
    }
    
    // SYNCRONIZE =========================================================================================================================================================
    
    func syncProgrampos() {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/userprogram_sync"
        
        self.isLoading = true
        
        guard let url = URL(string: self.url_api + apiname) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        request.setValue(self.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(self.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: self.channel_id),
            URLQueryItem(name: "region_id", value: self.region_id),
            URLQueryItem(name: "branch_id", value: self.branch_id),
            URLQueryItem(name: "machine_id", value: self.machine_id),
            URLQueryItem(name: "username", value: self.username)
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
            self.dataProgramPos.removeAll()
            
            DispatchQueue.main.async {
                self.responseMessage = message
                if (json["state"] == true){
                    self.isCorrect = true
                    self.showAlert = false
                    self.isLoading = false
                    for (_, subJson):(String, JSON) in json["data"] {
                        let programpos_id = subJson["programpos_id"].stringValue
                        let programpos_name = subJson["programpos_name"].stringValue
                        let programpos_descr = subJson["programpos_descr"].stringValue
                        let programpos_image = subJson["programpos_image"].stringValue
                        let programpos_url = subJson["programpos_url"].stringValue
                        let programpos_isdisabled = subJson["programpos_isdisabled"].intValue
                        let parent_id = subJson["parent_id"].stringValue
                        let isparent = subJson["isparent"].intValue
                        self.dataProgramPos.append(DataProgramPos(programpos_id: programpos_id, programpos_name : programpos_name, programpos_descr: programpos_descr, programpos_image: programpos_image, programpos_url: programpos_url, programpos_isdisabled: programpos_isdisabled, parent_id: parent_id, isparent: isparent))
                    }
                    //self.getLogin()
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
