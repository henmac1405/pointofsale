import Foundation
import SwiftData
import SwiftyJSON

@MainActor
class SyncService {
    
    func syncCategory(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/category_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
            URLQueryItem(name: "terminal_id", value: controller.terminal_id)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            
            print(url)
            print(json)
             
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Category.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let category_id = subJson["category_id"].stringValue
                            let category_name = subJson["category_name"].stringValue
                            let item_type = subJson["item_type"].stringValue
                            
                            let newData = Category(category_id: category_id, category_name: category_name, item_type : item_type)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncProduct(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/itemsales_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
            URLQueryItem(name: "terminal_id", value: controller.terminal_id)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Product.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let category_id = subJson["category_id"].stringValue
                            let iteminventory_id = subJson["iteminventory_id"].stringValue
                            let iteminventory_name = subJson["iteminventory_name"].stringValue
                            let price = subJson["price1"].doubleValue
                            let tax = subJson["tax_amount"].doubleValue
                            let point = subJson["point"].intValue
                            let barcode = subJson["barcode"].stringValue
                            let disc_id = subJson["discount_id"].stringValue
                            let disc_name = subJson["discount_name"].stringValue
                            let disc_amount = subJson["discount_amount"].doubleValue
                            let daytype_id = subJson["daytype_id"].stringValue
                            let item_type = subJson["item_type"].stringValue
                            let promo_id = subJson["promo_id"].stringValue
                            let promoph_id = ""
                            let image_name = subJson["image_name"].stringValue
                            let iteminventory_qty = subJson["iteminventory_qty"].intValue
                            
                            let newData = Product(category_id: category_id, iteminventory_id : iteminventory_id, iteminventory_name : iteminventory_name, price : price, tax : tax, point : point, barcode : barcode, disc_id : disc_id, disc_name : disc_name, disc_amount : disc_amount, daytype_id : daytype_id, item_type : item_type, promo_id : promo_id, promoph_id : promoph_id, image_name : image_name, iteminventory_qty : iteminventory_qty)
                            
                            modelContext.insert(newData)
                            
//                            let newData = Category(category_id: category_id, category_name: category_name, item_type : item_type)
//                            modelContext.insert(newData)
                            
                            
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncDiscount(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/discount_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
            URLQueryItem(name: "terminal_id", value: controller.terminal_id)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Discount.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let disc_id = subJson["disc_id"].stringValue
                            let disc_name = subJson["disc_name"].stringValue
                            let disc_amount = subJson["disc_amount"].doubleValue
                            let disc_minamount = subJson["disc_minamount"].doubleValue
                            let disc_maxamount = subJson["disc_maxamount"].doubleValue
                            let disc_validfrom = subJson["disc_validfrom"].stringValue
                            let disc_validto = subJson["disc_validto"].stringValue
                            let newData = Discount(disc_id: disc_id, disc_name : disc_name, disc_amount : disc_amount, disc_minamount : disc_minamount, disc_maxamount : disc_maxamount, disc_validfrom : disc_validfrom, disc_validto : disc_validto)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncTender(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/tender_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
            URLQueryItem(name: "terminal_id", value: controller.terminal_id)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Tender.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let tender_id = subJson["tender_id"].stringValue
                            let tender_name = subJson["tendername"].stringValue
                            let tender_type = subJson["tendertype"].stringValue
                            let tender_amount = subJson["remark"].doubleValue
                            let newData = Tender(tender_id: tender_id, tender_name : tender_name, tender_type : tender_type, tender_amount : tender_amount)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncSalestype(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/salestype_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Salestype.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            
                            let salestype_id = subJson["salestype_id"].stringValue
                            let salestype_name = subJson["salestype_name"].stringValue
                            let newData = Salestype(salestype_id: salestype_id, salestype_name : salestype_name)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncHeaderFooter(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/posheaderfooter_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: HeaderFooter.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            
                            let channel_name = subJson["channel_name"].stringValue
                            let branch_name = subJson["branch_name"].stringValue
                            let address = subJson["address"].stringValue
                            let city = subJson["city"].stringValue
                            let phone = subJson["phone"].stringValue
                            let fax = subJson["fax"].stringValue
                            let footer1 = subJson["footer1"].stringValue
                            let footer2 = subJson["footer2"].stringValue
                            let footer3 = subJson["footer3"].stringValue
                            let newData = HeaderFooter(channel_name: channel_name, branch_name : branch_name, address : address, city : city, phone : phone, fax : fax, footer1 : footer1,footer2 : footer2,footer3 : footer3)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncVoidreason(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/voidreason_get"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: VoidReason.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let voidreason_id = subJson["voidreason_id"].stringValue
                            let voidreason_name = subJson["voidreason_name"].stringValue
                            let newData = VoidReason(voidreason_id: voidreason_id, voidreason_name : voidreason_name)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncItemadd(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/itemadd_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: ItemAdd.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let itemadd_id = subJson["iteminventory_id"].stringValue
                            let itemadd_name = subJson["iteminventory_name"].stringValue
                            let itemadd_qty = subJson["iteminventory_qty"].intValue
                            let itemadd_descr = subJson["iteminventory_descr"].stringValue
                            let itemadd_price = subJson["iteminventory_price"].doubleValue
                            let itemadd_type = subJson["iteminventory_type"].stringValue
                            let itemadd_salestype = subJson["iteminventory_salestype"].stringValue
                            let itemadd_ismust = subJson["iteminventory_ismust"].intValue
                            let itemadd_status = 0
                            let newData = ItemAdd(itemadd_id: itemadd_id,  itemadd_name : itemadd_name, itemadd_qty : itemadd_qty, itemadd_descr : itemadd_descr, itemadd_price : itemadd_price, itemadd_type : itemadd_type, itemadd_salestype : itemadd_salestype,  itemadd_ismust : itemadd_ismust, itemadd_status : itemadd_status)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncItemSize(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/itemsize_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Size.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let size_id = subJson["itemsize_id"].stringValue
                            let size_name = subJson["itemsize_name"].stringValue
                            let size_descr = subJson["itemsize_descr"].stringValue
                            let size_type = subJson["itemsize_type"].stringValue.trimmingCharacters(in: .whitespaces)
                            let newData = Size(size_id: size_id, size_name : size_name, size_descr : size_descr, size_type : size_type)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncSetting(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/setting_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Setting.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let setting_id = subJson["setting_id"].stringValue
                            let setting_value = subJson["setting_value"].stringValue
                            
                            let newData = Setting(setting_id: setting_id, setting_value: setting_value)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncSalesman(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/salesman_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json)
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: SalesMan.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let salesman_id = subJson["username"].stringValue
                            let salesman_name = subJson["user_fullname"].stringValue
                            let newData = SalesMan(salesman_id: salesman_id, salesman_name : salesman_name)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
    
    func syncCalender(controller: Controller, modelContext: ModelContext, completion: @escaping (Bool, String) -> Void) {
        let timestampWithZ = ISO8601DateFormatter().string(from: Date())
        let apiname = "syncronize/calender_sync"
        
        guard let url = URL(string: controller.url_api + apiname) else {
            completion(false, "URL Tidak Valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(controller.apiKey, forHTTPHeaderField: "APIKEY")
        request.setValue(controller.token, forHTTPHeaderField: "TOKEN")
        request.setValue(timestampWithZ, forHTTPHeaderField: "TIMESTAMP")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "channel_id", value: controller.channel_id),
            URLQueryItem(name: "region_id", value: controller.region_id),
            URLQueryItem(name: "branch_id", value: controller.branch_id),
            URLQueryItem(name: "machine_id", value: controller.machine_id),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false, "Data kosong") }
                return
            }
            
            let json = JSON(data)
            let message = json["message"].stringValue
            let isSuccess = json["state"].boolValue
            print(url)
            print(json) 
            DispatchQueue.main.async {
                if isSuccess {
                    do {
                        // 1. Hapus data lama
                        try modelContext.delete(model: Calender.self)
                        try modelContext.save()
                        
                        // 2. Insert data baru
                        for (_, subJson):(String, JSON) in json["data"] {
                            let calender_date = subJson["calender_date"].stringValue
                            let calender_descr = subJson["calender_descr"].stringValue
                            let newData = Calender(calender_date: calender_date, calender_descr : calender_descr)
                            modelContext.insert(newData)
                        }
                        
                        // 3. Simpan perubahan akhir
                        try modelContext.save()
                        completion(true, message)
                        
                    } catch {
                        completion(false, "Gagal menyimpan database: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, message)
                }
            }
        }.resume()
    }
}
