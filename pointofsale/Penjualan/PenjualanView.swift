import SwiftUI
import SwiftData

struct PenjualanView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    let programposID : String
    let programposName : String
    @State private var salestypeid = ""
    @State private var itemtype = ""
    @State private var sizetype = ""
    @State private var rekanantype = ""
    @State private var searchText = ""
    @State private var isSearchText = false
    @State private var itemAdd_name = ""
    @State private var salesman_id = ""
    @State private var salesman_name = ""
    @State private var cust_id = ""
    @State private var cust_name = ""
    @State private var salesid = ""
    
    @State private var navigateToCategory = false
    @State private var navigateToCustomer = false
    @State private var navigateToAdditional = false
    @State private var navigateToSalesman = false
    @State private var navigateToScanBarcode = false
    @State private var navigateToScanTicket = false
    @State private var navigateToPenjualanEdit = false
    
    @State private var counter = 0
    @State private var sumprice : Double = 00
    
    @State private var selectedId : String = ""
    @State private var selectedName : String = ""
    @State private var selectedPrice : Int = 0
    @State private var selectedQty : Int = 0
    @State private var selectedCategory_id : String = ""
    @State private var selectedCategory_name : String = ""
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var product: [Product]
    @Query var itemAdd: [ItemAdd]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let columnsAdd = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let randomColors: [Color] = [.orange, .green, .cyan, .pink, .yellow, .indigo, .mint, .gray, .purple, .red, .brown, .blue]
    
    var filteredProduct: [Product] {
        if itemtype.isEmpty {
            return product
        } else {
            if searchText.isEmpty {
                if selectedCategory_id.isEmpty {
                    return product.filter { item in
                        item.item_type.localizedCaseInsensitiveContains(itemtype)
                    }
                } else {
                    return product.filter { item in
                        item.item_type.localizedCaseInsensitiveContains(itemtype) && item.category_id.localizedCaseInsensitiveContains(selectedCategory_id)
                    }
                }
            } else {
                if selectedCategory_id.isEmpty {
                    return product.filter { item in
                        item.item_type.localizedCaseInsensitiveContains(itemtype) && item.iteminventory_name.localizedCaseInsensitiveContains(searchText)
                    }
                } else {
                    return product.filter { item in
                        item.item_type.localizedCaseInsensitiveContains(itemtype) && item.category_id.localizedCaseInsensitiveContains(selectedCategory_id) && item.iteminventory_name.localizedCaseInsensitiveContains(searchText)
                    }
                }
            }
            
            
        }
    }
    
    var filteredItemAdd: [ItemAdd] {
        if salestypeid.isEmpty {
            return itemAdd
        } else {
            return itemAdd.filter { item in
                item.itemadd_salestype.localizedCaseInsensitiveContains(salestypeid)
            }
        }
    }
    
    var body: some View {
        
        VStack(spacing: 15) {
            // MARK: - Header Section
            VStack(spacing: 10) { 
                HStack {
                    Text("Jenis Transaksi : \(programposName)")
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        isSearchText = true
                    }){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                // Category Bar
                HStack {
                    Text("Kategori : \(selectedCategory_name)")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                    Button(action:{
                        navigateToCategory = true
                        //                            navPath.append("CATEGORY")
                    }){
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                    
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                // Search Product
                if ( isSearchText == true){
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                        
                        Button(action: {
                            isSearchText = false
                            searchText = ""
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(10)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // MARK: - Product
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(filteredProduct) { item in
                        Button(action: {
                            counter = counter + 1
                            sumprice = sumprice + item.price
                            if self.controller.status.count == 0 {
                                print("status : ")
                                self.controller.insertStatus(salesid: salesid, cust_id: cust_id, cust_name: cust_name, salestypeid: salestypeid, salesman_id: salesman_id, salesman_name: salesman_name, shift_id: "1")
                                print(self.controller.status)
                            }
                            
                            self.controller.insertLog(salesid: salesid, iteminventory_id: item.iteminventory_id, iteminventory_name: item.iteminventory_name, iteminventory_qty: 1, price: item.price, tax: item.tax, disc_id: item.disc_id, disc_name: item.disc_name, disc_percent: item.disc_amount, salestypeid: salestypeid)
                            
                            print("logs : ")
                            print(controller.log)
                        }){
                            VStack {
                                Text(item.iteminventory_name)
                                    .font(.system(size: 16, weight: .bold))
                                    .multilineTextAlignment(.center)
                                Spacer()
                                if (salestypeid == "point"){
                                    Text("Point : \(item.point.formatted(.number.grouping(.automatic)))")
                                        .font(.system(size: 16, weight: .bold))
                                } else {
                                    Text("Rp. \(item.price.formatted(.number.grouping(.automatic)))")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(randomColors.randomElement() ?? .orange)
                            .foregroundColor(.black)
                            .cornerRadius(12)}
                    }
                    
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // MARK: - Item Additional
            VStack{
                LazyVGrid(columns: columnsAdd, spacing: 15) {
                    ForEach(filteredItemAdd, id: \.id) { item in
                        VStack {
                            
                            Button (action: {
                                print(item.itemadd_name)
                                print("itemsize_type : \(item.itemadd_type)")
                                self.itemAdd_name = item.itemadd_name
                                self.sizetype = item.itemadd_type
                                if (item.itemadd_type == "CUSTOMER"){
                                    self.navigateToCustomer = true
                                } else if (item.itemadd_type == "WRISTBAND"){
                                    self.controller.showAlert = true
                                    self.controller.responseMessage = "Wristband Sudah Ditambahkan"
                                    self.controller.insertItemSize(context: modelContext, itemAdd_name: item.itemadd_name, itemAdd_qty: 1)
                                    self.controller.updateItemAdd_Status(name: item.itemadd_name, status: 1)
                                } else if (item.itemadd_type == "SALESMAN"){
                                    self.navigateToSalesman = true
                                } else if (item.itemadd_type == "SCAN BARCODE"){
                                   print("SCAN BARCODE")
                                    self.navigateToScanBarcode = true
                                } else if (item.itemadd_type == "SCAN TICKET"){
                                   print("SCAN TICKET")
                                    self.navigateToScanTicket = true
                                } else {
                                    if self.counter > 0 {
                                        self.navigateToAdditional = true
                                    } else {
                                        self.controller.showAlert = true
                                        self.controller.responseMessage = "Item Belum Dipilih"
                                    }
                                    
                                }
                            }) {
                                Text("\(item.itemadd_name)")
                                    .font(.system(size: 16, weight: .bold))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.6))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            // MARK: - Bottom Cart Bar
            HStack(spacing: 10) {
                // Home Button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .frame(width: 80, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                // Cart Summary
                Button(action: {
                    if self.counter > 0 {
                        self.controller.updateStatusTotalSales(salesid: salesid, totalsales: sumprice)
                        self.navigateToPenjualanEdit = true
                    } else {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "Item Belum Dipilih"
                    }
                    
                }) {
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("\(counter) barang = Rp. \(sumprice.formatted(.number.grouping(.automatic)))")
                            .fontWeight(.medium)
                    }
                    .font(.title3)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .padding(.top)
        .navigationBarHidden(true)
        .onAppear {
            salesid = self.controller.getFormattedDateSalesID()
            self.controller.sales_id = self.controller.getFormattedDateSalesID()
            self.controller.daily_id = self.controller.getFormattedDateDailyID()
            if programposID == "ticket" {
                salestypeid = "ticket"
                itemtype = "TIKET"
                rekanantype = "13"
            } else if programposID == "gokart" {
                salestypeid = "ticket"
                itemtype = "TIKET"
                rekanantype = "16"
            } else if programposID == "tiketing" {
                salestypeid = "ticket"
                itemtype = "TIKET"
                rekanantype = "16"
            } else if programposID == "openbooth" {
                salestypeid = "openbooth"
                itemtype = "VOUCHER"
                rekanantype = "12"
            } else if programposID == "transaksi" {
                salestypeid = "sales"
                itemtype = "Merchandise"
                rekanantype = "12"
            } else if programposID == "playground" {
                salestypeid = "playground"
                itemtype = "PLAYGROUND"
                rekanantype = "14"
            } else if programposID == "games" {
                salestypeid = "games"
                itemtype = "GAMES"
                rekanantype = "15"
            } else if programposID == "rdmmerchan" {
                salestypeid = "point"
                itemtype = "Merchandise"
                rekanantype = "12"
            } else if programposID == "fnb" {
                salestypeid = "FNB"
                itemtype = "FNB"
                rekanantype = "12"
            }
        }
        //Category
        .navigationDestination(isPresented: $navigateToCategory) {
            CategoryView(item_type : itemtype){ id, name, price, qty in
                self.selectedCategory_id = id
                self.selectedCategory_name = name
                self.selectedPrice = price
                self.selectedQty = qty
                print(name)
            }
        }
        //            //Customer
        .navigationDestination(isPresented: $navigateToCustomer) {
            CustomerView(){id, name  in
                self.cust_id = id
                self.cust_name = name
                self.controller.updateStatusCustomer(salesid: salesid, id: cust_id, name: cust_name)
            }
        }
        //            //Additional
        .navigationDestination(isPresented: $navigateToAdditional) {
            AdditionalView(itemAdd_name : itemAdd_name, itemAdd_qty: counter, size_type : sizetype)
        }
        //            //Salesman
        .navigationDestination(isPresented: $navigateToSalesman) {
            SalesmanView(){id, name  in
                self.salesman_id = id
                self.salesman_name = name
                self.controller.updateStatusSalesman(salesid: salesid, id: salesman_id, name: salesman_name)
            }
        }
        //            //Scan Barcode
        .navigationDestination(isPresented: $navigateToScanBarcode) {
            ScanBarcodeTicketView(type : "Barcode")
        }
        //            //Scan Ticket
        .navigationDestination(isPresented: $navigateToScanTicket) {
            ScanBarcodeTicketView(type : "Ticket")
        }
        //            //Penjualan Edit
        .navigationDestination(isPresented: $navigateToPenjualanEdit) {
            PenjualanEditView()
        }
        
    }
    
    
    
    
    
    
}

#Preview {
    PenjualanView(programposID : "ticket", programposName : "TIKET")
}
