
import Foundation
import SwiftUI
import SwiftData

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

struct DataProgramPos : Identifiable {
    var id = UUID()
    var programpos_id : String
    var programpos_name : String
    var programpos_descr : String
    var programpos_image : String
    var programpos_url : String
    var programpos_isdisabled : Int
    var parent_id : String
    var isparent : Int
}
 
@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var category_id: String
    var category_name: String
    var item_type: String
    
    init(category_id: String, category_name: String, item_type: String) {
        self.id = UUID()
        self.category_id = category_id
        self.category_name = category_name
        self.item_type = item_type
    }
}
 
@Model
final class Product {
    @Attribute(.unique) var id: UUID
    var category_id : String
    var iteminventory_id : String
    var iteminventory_name : String
    var price : Double
    var tax : Double
    var point : Int
    var barcode : String
    var disc_id : String
    var disc_name : String
    var disc_amount : Double
    var daytype_id : String
    var item_type : String
    var promo_id : String
    var promoph_id : String
    var image_name : String
    var iteminventory_qty  : Int
    
    init(  category_id : String, iteminventory_id : String, iteminventory_name : String,
           price : Double, tax : Double, point : Int, barcode : String, disc_id : String,  disc_name : String,  disc_amount : Double,
           daytype_id : String, item_type : String,  promo_id : String, promoph_id : String, image_name : String, iteminventory_qty  : Int) {
        self.id = UUID()
        self.category_id = category_id
        self.iteminventory_id = iteminventory_id
        self.iteminventory_name = iteminventory_name
        self.price = price
        self.tax = tax
        self.point = point
        self.barcode = barcode
        self.disc_id = disc_id
        self.disc_name = disc_name
        self.disc_amount = disc_amount
        self.daytype_id = daytype_id
        self.item_type = item_type
        self.promo_id = promo_id
        self.promoph_id = promoph_id
        self.image_name = image_name
        self.iteminventory_qty = iteminventory_qty
        
    }
}
 

@Model
final class Discount {
    @Attribute(.unique) var id: UUID
    var disc_id : String
    var disc_name : String
    var disc_amount : Double
    var disc_minamount : Double
    var disc_maxamount : Double
    var disc_validfrom : String
    var disc_validto : String
    
    init(  disc_id : String, disc_name : String, disc_amount : Double, disc_minamount : Double, disc_maxamount : Double,
           disc_validfrom : String, disc_validto : String) {
        self.id = UUID()
        self.disc_id = disc_id
        self.disc_name = disc_name
        self.disc_amount = disc_amount
        self.disc_minamount = disc_minamount
        self.disc_maxamount = disc_maxamount
        self.disc_validfrom = disc_validfrom
        self.disc_validto = disc_validto
    }
}
 

@Model
final class Tender {
    @Attribute(.unique) var id: UUID
    var tender_id : String
    var tender_name : String
    var tender_type : String
    var tender_amount : Double
    
    init(  tender_id : String, tender_name : String, tender_type : String, tender_amount : Double) {
        self.id = UUID()
        self.tender_id = tender_id
        self.tender_name = tender_name
        self.tender_type = tender_type
        self.tender_amount = tender_amount
    }
}
 
@Model
final class Salestype {
    @Attribute(.unique) var id: UUID
    var salestype_id : String
    var salestype_name : String
    
    init(  salestype_id : String, salestype_name : String) {
        self.id = UUID()
        self.salestype_id = salestype_id
        self.salestype_name = salestype_name
    }
}
 
@Model
final class HeaderFooter {
    @Attribute(.unique) var id: UUID
    var channel_name : String
    var branch_name : String
    var address : String
    var city : String
    var phone : String
    var fax : String
    var footer1 : String
    var footer2 : String
    var footer3 : String
    
    init( channel_name : String, branch_name : String, address : String, city : String, phone : String,
          fax : String, footer1 : String, footer2 : String, footer3 : String) {
        self.id = UUID()
        self.channel_name = channel_name
        self.branch_name = branch_name
        self.address = address
        self.city = city
        self.phone = phone
        self.fax = fax
        self.footer1 = footer1
        self.footer2 = footer2
        self.footer3 = footer3
    }
}
 
@Model
final class VoidReason {
    @Attribute(.unique) var id: UUID
    var voidreason_id : String
    var voidreason_name : String
    
    init(  voidreason_id : String, voidreason_name : String) {
        self.id = UUID()
        self.voidreason_id = voidreason_id
        self.voidreason_name = voidreason_name
    }
}
 
@Model
final class ItemAdd {
    @Attribute(.unique) var id: UUID
    var itemadd_id : String
    var  itemadd_name : String
    var itemadd_qty : Int
    var  itemadd_descr : String
    var  itemadd_price : Double
    var  itemadd_type : String
    var  itemadd_salestype : String
    var  itemadd_ismust : Int
    var  itemadd_status : Int
    
    init(itemadd_id : String,
         itemadd_name : String,
         itemadd_qty : Int,
         itemadd_descr : String,
         itemadd_price : Double,
         itemadd_type : String,
         itemadd_salestype : String,
         itemadd_ismust : Int,
         itemadd_status : Int) {
        self.id = UUID()
        self.itemadd_id = itemadd_id
        self.itemadd_name = itemadd_name
        self.itemadd_qty = itemadd_qty
        self.itemadd_descr = itemadd_descr
        self.itemadd_price = itemadd_price
        self.itemadd_type = itemadd_type
        self.itemadd_salestype = itemadd_salestype
        self.itemadd_ismust = itemadd_ismust
        self.itemadd_status = itemadd_status
    }
}
 
@Model
final class ItemSize {
    @Attribute(.unique) var id: UUID
    var itemsize_id : String
    var itemsize_name : String
    var itemsize_descr : String
    var itemsize_qty : Int
    
    init(itemsize_id : String,
         itemsize_name : String,
         itemsize_descr : String,
         itemsize_qty : Int) {
        self.id = UUID()
        self.itemsize_id = itemsize_id
        self.itemsize_name = itemsize_name
        self.itemsize_descr = itemsize_descr
        self.itemsize_qty = itemsize_qty
    }
}
 
@Model
final class Size {
    @Attribute(.unique) var id: UUID
    var size_id : String
    var size_name : String
    var size_descr : String
    var size_type : String
    
    init(size_id : String,
         size_name : String,
         size_descr : String,
         size_type : String) {
        self.id = UUID()
        self.size_id = size_id
        self.size_name = size_name
        self.size_descr = size_descr
        self.size_type = size_type
    }
}
 
@Model
final class SalesMan {
    @Attribute(.unique) var id: UUID
    var salesman_id : String
    var salesman_name : String
    
    init(salesman_id : String,
         salesman_name : String) {
        self.id = UUID()
        self.salesman_id = salesman_id
        self.salesman_name = salesman_name
    }
}
 
@Model
final class Calender {
    @Attribute(.unique) var id: UUID
    var calender_date : String
    var calender_descr : String
    
    init(calender_date : String,
         calender_descr : String) {
        self.id = UUID()
        self.calender_date = calender_date
        self.calender_descr = calender_descr
    }
}

struct Customer : Identifiable {
    var id = UUID()
    var cust_id : String
    var cust_name : String
    var cust_address : String
    var cust_hp : String
    var cust_telp : String
    var cust_email : String
    var cust_age : String
    var cust_gender : String
    var member_id : String
}

 
@Model
final class Setting {
    @Attribute(.unique) var id: UUID
    var setting_id: String
    var setting_value: String
    
    init(setting_id: String, setting_value: String) {
        self.id = UUID()
        self.setting_id = setting_id
        self.setting_value = setting_value
    }
}

struct Status : Codable {
    var salesid : String
    var Strsalesdate : String
    var Salesdate : Int
    var Qty : Int
    var Is_open : Int
    var Is_discount : Int
    var Totalsales : Double
    var Totalpayment : Double
    var Totalchange : Double
    var Cust_id : String
    var Cust_name : String
    var Table_id : String
    var Table_no : String
    var Styler_id : String
    var Styler_name : String
    var Create_by : String
    var Create_date : Int
    var Modify_by : String
    var Modify_date : Int
    var Salestype_id : String
    var Salestype_name : String
    var Keterangan : String
    var Is_temp : Int
    var Dailyid : String
    var Branchid : String
    var Regionid : String
    var Channelid : String
    var Machineid : String
    var Shift_id : String
    var Card_number : String
    var Device_id : String
    var Posversion : String
    var Ticketdate : Int
    var Salesman_id : String
    var Salesman_name : String
}

struct Payment : Codable {
    var Salesid : String
    var Line : Int
    var Tenderid : String
    var Tendername : String
    var Tendertype : String
    var Tendercode : String
    var Salesamount : Double
    var Paymentamount : Double
    var Changeamount : Double
    var Disable : Int
    var Dailyid : String
    var Branchid : String
    var Regionid : String
    var Channelid : String
    var Machineid : String
}

struct Log : Codable {
    var Line : Int
    var Salesid : String
    var Id : String
    var Name : String
    var Qty : Int
    var Price : Double
    var Subtotal : Double
    var Discid : String
    var Discname : String
    var Discpercent : Double
    var Discamount : Double
    var Taxid : String
    var Taxname : String
    var Taxpercent : Double
    var Taxamount : Double
    var Total : Double
    var Hold : Int
    var Finish : Int
    var Salesdate : Int
    var Strsalesdate : String
    var Create_date : Int
    var Create_by : String
    var Modify_date : Int
    var Modify_by : String
    var Note : String
    var Dailyid : String
    var Branchid : String
    var Regionid : String
    var Channelid : String
    var Machineid : String
    var Promoph_id : String
    var Promo_id : String
    var Promo_name : String
    var Salestypeid : String
}

