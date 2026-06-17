import SwiftUI
import SwiftyJSON

struct StrukView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) private var dismiss
    
    var noBill: String
    
    @State private var isLoadData: Bool = false
    @State private var subtotal: Double = 0
    @State private var discountItem: Double = 0
    @State private var discountTotal: Double = 0
    @State private var tax: Double = 0
    @State private var paymentType: String = ""
    @State private var cashier: String = ""
    @State private var total: Double = 0
    @State private var payment: Double = 0
    @State private var change: Double = 0
    
    @State private var itemstruk: [JSON] = []
    @State private var itemtiket: [JSON] = []
    @State private var liststruk_logadditional: [JSON] = []
    @State private var liststruk_wristband: [JSON] = []
    @State private var liststruk_gamesqr: [JSON] = []
    @State private var liststruk_voucheropenbooth: [JSON] = []
    
    private let lebarKertasThermal: CGFloat = 576
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - NAVIGATION BAR TOP
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Text("Print Struk")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.leading, 24)
                
                Spacer()
                
                Button(action: { /* Logika Tombol Share */ }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            
            // MARK: - KERTAS STRUK PUTIH
            ScrollView {
                if isLoadData {
                    ProgressView("Wait...")
                        .scaleEffect(1.5)
                        .padding(.top, 60)
                } else {
                    VStack(spacing: 0) {
                        
                        Image("TE")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.top, 40)
                            .opacity(1.0)
                        
                        Text("PT TRANS REKREASINDO")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                            .padding(.bottom, 65)
                        
                        VStack(spacing: 12) {
                            StrukHeaderRow(label: "Bill", value: noBill)
                            StrukHeaderRow(label: "Cashier", value: cashier)
                        }
                        .padding(.horizontal, 24)
                        
                        DashedLineView()
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("Qty").frame(width: 35, alignment: .leading)
                                Text("Item").frame(maxWidth: .infinity, alignment: .leading)
                                Text("Price").frame(width: 75, alignment: .trailing)
                                Text("Total").frame(width: 75, alignment: .trailing)
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            
                            ForEach(0..<itemstruk.count, id: \.self) { index in
                                let item = itemstruk[index]
                                
                                HStack(alignment: .top) {
                                    Text("\(item["quantitiy"].intValue)")
                                        .frame(width: 35, alignment: .leading)
                                    
                                    Text(item["iteminventory_name"].stringValue.uppercased())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(Int(item["price"].doubleValue).formattedWithSeparator())
                                        .frame(width: 75, alignment: .trailing)
                                    
                                    Text(Int(item["netPrice"].doubleValue).formattedWithSeparator())
                                        .frame(width: 75, alignment: .trailing)
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        DashedLineView()
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        
                        VStack(spacing: 12) {
                            StrukSummaryRow(label: "Subtotal", value: Int(subtotal).formattedWithSeparator())
                            StrukSummaryRow(label: "Discount Item", value: Int(discountItem).formattedWithSeparator())
                            StrukSummaryRow(label: "Discount Total", value: Int(discountTotal).formattedWithSeparator())
                            StrukSummaryRow(label: "Tax", value: Int(tax).formattedWithSeparator())
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        DashedLineView()
                            .padding(.horizontal, 16)
                            .padding(.top, 18)
                        
                        HStack {
                            Text("TOTAL")
                                .font(.system(size: 32, weight: .regular))
                            Spacer()
                            Text("Rp. \(Int(total).formattedWithSeparator())")
                                .font(.system(size: 32, weight: .regular))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        
                        DashedLineView()
                            .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Spacer()
                                Text(paymentType.uppercased())
                                    .frame(width: 100, alignment: .leading)
                                Text("Rp.")
                                    .frame(width: 40, alignment: .leading)
                                Text(Int(payment).formattedWithSeparator())
                                    .frame(width: 100, alignment: .trailing)
                            }
                            
                            HStack {
                                Spacer()
                                Text("Change :")
                                    .frame(width: 100, alignment: .leading)
                                Text("Rp.")
                                    .frame(width: 40, alignment: .leading)
                                Text(Int(change).formattedWithSeparator())
                                    .frame(width: 100, alignment: .trailing)
                            }
                        }
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        DashedLineView().padding(.horizontal, 16).padding(.top, 24)
                        DashedLineView().padding(.horizontal, 16).padding(.top, 4)
                        
                        Text(self.controller.getFormattedDateTimeFull())
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.top, 70)
                            .padding(.bottom, 50)
                    }
                }
            }
            .background(Color.white)
            
            // MARK: - TOMBOL NAVIGASI BOTTOM BAR
            HStack(spacing: 12) {
                // Tombol Print
                Button(action: {  }) {
                    HStack(spacing: 8) {
                        Image(systemName: "printer.fill")
                        Text("PRINT")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color(red: 0.14, green: 0.54, blue: 0.94))
                    .cornerRadius(24)
                }
                
                //  Settings
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 54, height: 48)
                        .background(Color(red: 0.14, green: 0.54, blue: 0.94))
                        .cornerRadius(24)
                }
                
                //  Batal  
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark").font(.system(size: 16, weight: .bold)).foregroundColor(.white).frame(width: 54, height: 48).background(Color(red: 0.14, green: 0.54, blue: 0.94)).cornerRadius(24)}}.padding(.horizontal, 16).padding(.vertical, 14).background(Color(.systemGray6))}
        .frame(width: lebarKertasThermal)
        .padding(.horizontal, 16)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            self.isLoadData = true
                self.controller.list_struk_new(sales_id: noBill) { jsonResult in
                    guard let json = jsonResult else {
                        self.isLoadData = false
                        return
                    }
                    
                    let jsonArray = json["data"].arrayValue
                    var tempSubtotal: Double = 0
                    var tempDiscItem: Double = 0
                    var tempTax: Double = 0
                    
                    for row in jsonArray {
                        tempSubtotal += row["netPrice"].doubleValue
                        tempDiscItem += row["discountitemamount"].doubleValue
                        tempTax += row["taxamount"].doubleValue
                        self.paymentType = row["tendertype"].stringValue
                        self.cashier = row["create_by"].stringValue
                        self.total = row["salesamount"].doubleValue
                        self.payment = row["paymentamount"].doubleValue
                        self.change = row["changeamount"].doubleValue
                    }
                    
                    let tempDiscTotal = json["data"]["discounttotalamount"].doubleValue
                    
                    DispatchQueue.main.async {
                        
                        self.itemstruk = jsonArray
                        self.subtotal = tempSubtotal
                        self.discountItem = tempDiscItem
                        self.discountTotal = tempDiscTotal
                        self.tax = tempTax
//                        self.isLoadData = false
                        
                        //tiketing
                        self.controller.getTiketMasuk_lokal(sales_id: noBill) { tiketResult in
                            guard let jsonTiket = tiketResult else {
                                self.isLoadData = false
                                return
                            }
                            
                            let tiketArray = jsonTiket["data"].arrayValue
                            
                            DispatchQueue.main.async {
                                self.itemtiket = tiketArray
                                
                                
                                //Log Additional
                                self.controller.list_struk_logadditional(sales_id: noBill) { logAddResult in
                                    guard let jsonLogAdd = logAddResult else {
                                        self.isLoadData = false
                                        return
                                    }
                                    
                                    let logAddArray = jsonLogAdd["data"].arrayValue
                                    
                                    DispatchQueue.main.async {
                                        self.liststruk_logadditional = logAddArray
                                        
                                        //wristband
                                        self.controller.list_struk_wristband(sales_id: noBill) { wristbandResult in
                                            guard let jsonWrisband = wristbandResult else {
                                                self.isLoadData = false
                                                return
                                            }
                                            
                                            let wristbandArray = jsonWrisband["data"].arrayValue
                                            
                                            DispatchQueue.main.async {
                                                self.liststruk_wristband = wristbandArray
                                                
                                                
                                                //games QR
                                                self.controller.list_struk_gamesqr(sales_id: noBill) { gamesqrResult in
                                                    guard let jsonGamesqr = gamesqrResult else {
                                                        self.isLoadData = false
                                                        return
                                                    }
                                                    
                                                    let gamesQRArray = jsonGamesqr["data"].arrayValue
                                                    DispatchQueue.main.async {
                                                        self.liststruk_gamesqr = gamesQRArray
                                                        
                                                        //voucher openbooth
                                                        self.controller.list_struk_voucheropenbooth(sales_id: noBill) { openboothResult in
                                                            guard let jsonOpenBooth = openboothResult else {
                                                                self.isLoadData = false
                                                                return
                                                            }
                                                            
                                                            let openboothArray = jsonOpenBooth["data"].arrayValue
                                                            DispatchQueue.main.async {
                                                                self.liststruk_voucheropenbooth = openboothArray
                                                                self.isLoadData = false
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    
                                    }
                                }
                            }
                            
                        }
                    }
            }
        }
    }
}

struct DashedLineView: View {
    var body: some View {
        LineShape()
            .stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .butt, dash: [4, 4]))
            .frame(height: 1)
    }
}

struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// MARK: - COMPONENT BARIS HEADER STRUK
struct StrukHeaderRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(width: 100, alignment: .leading)
            
            Text(":")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(width: 20, alignment: .center)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - COMPONENT BARIS SUMMARY STRUK
struct StrukSummaryRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
        }
    }
}

