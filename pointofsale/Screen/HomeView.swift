import SwiftUI

struct HomeView: View {
    @EnvironmentObject var controller : Controller
    @State private var SyncFinished : Bool = false
    @State private var navigateToPenjualan = false
    @State private var navigateToLaporan = false
    @State private var navigateToRedeem = false
    
    @State private var navigateToPrinter = false
    @State private var navigateToRePrint = false
    @State private var navigateToVoid = false
    @State private var navigateToPassword = false
    @State private var navigateToShiftClose = false
    
    @State private var navigateToRePrintTic = false
    @State private var navigateToCekTiket = false
    @State private var navigateToCekQRIS = false
    
    @State private var navigateToScanIn = false
    @State private var navigateToScanOut = false
    @State private var navigateToScanWBIn = false
    @State private var navigateToScanWBOut = false
    @State private var navigateToRePrintTik = false
    @State private var navigateToWBList = false
    @State private var navigateToWBListIn = false
    @State private var navigateToWBListOut = false
    @State private var navigateToWBListStok = false
    
    @State private var navigateToKartuMain = false
    @State private var navigateToTopUp = false
    @State private var navigateTo = false
    @State private var navigateToTopUpApp = false
    @State private var navigateToTopUpPen = false
    @State private var navigateToKartuCek = false
    @State private var navigateToKartuPen = false
    @State private var navigateToRdmCust = false
    
    @State private var navigateToPGListIn = false
    @State private var navigateToPGListOut = false
    
    @State private var navigateToScanZooMove = false
    
    @State private var programposID = ""
    @State private var programposName = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(red: 0.2, green: 0.6, blue: 0.85).ignoresSafeArea()
                
                VStack(spacing: 20) {
                     
                    HStack(spacing : 20) {
                        Button(action: {
                            self.controller.syncProgrampos()
                        }) { Image(systemName: "arrow.clockwise") }
                        Button(action: {}) { Image(systemName: "gearshape.fill") }
                        Spacer()
                        Text(self.controller.user_fullname).bold().font(.title3)
                        Spacer()
                        Button(action: {}) { Image(systemName: "cart.fill") }
                        Button(action: {
                            self.controller.isLoggedIn = false
                        }) { Image(systemName: "rectangle.portrait.and.arrow.right") }
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                     
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(self.controller.branch_name).bold()
                            Spacer()
                            Text(self.controller.getFormattedDateDDMMMMYYYY())
                        }
                        Text("\(self.controller.machine_name) (\(self.controller.terminal_name)")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(controller.filteredData, id: \.id) { item in
                                Button(action: {
                                    print("programpos_id : \(item.programpos_id)  -  \(item.programpos_name)")
                                    programposID = item.programpos_id
                                    programposName = item.programpos_name
                                    self.controller.programposID = item.programpos_id
                                    self.controller.programposName = item.programpos_name
                                    if (item.isparent == 1 && item.parent_id == "0"){
                                        self.controller.filterIsParent = 0
                                        self.controller.parent_id = item.programpos_id
                                    } else {
                                        if (item.programpos_id == "syncronize"){
                                            self.controller.messageSyncronize = ""
                                            self.controller.isLoading = false
                                            self.controller.showSyncronize = true
                                            self.SyncFinished = false
                                        } else if (item.programpos_id == "laporan"){
                                            self.navigateToLaporan = true
                                        
                                        } else if (item.programpos_id == "printer"){
                                            self.navigateToPrinter = true
                                        } else if (item.programpos_id == "reprint"){
                                            self.navigateToRePrint = true
                                        } else if (item.programpos_id == "void"){
                                            self.navigateToVoid = true
                                        } else if (item.programpos_id == "password"){
                                            self.navigateToPassword = true
                                        } else if (item.programpos_id == "shiftclose"){
                                            self.navigateToShiftClose = true
                                        } else if (item.programpos_id == "reprinttic"){
                                            self.navigateToRePrintTic = true
                                        } else if (item.programpos_id == "cektiket"){
                                            self.navigateToCekTiket = true
                                        } else if (item.programpos_id == "cekqris"){
                                            self.navigateToCekQRIS = true
                                        //Frozenland
                                        } else if (item.programpos_id == "scan"){
                                            self.navigateToScanIn = true
                                        } else if (item.programpos_id == "scanout"){
                                            self.navigateToScanOut = true
                                        } else if (item.programpos_id == "scanwbin"){
                                            self.navigateToScanWBIn = true
                                        } else if (item.programpos_id == "scanwbout"){
                                            self.navigateToScanWBOut = true
                                        } else if (item.programpos_id == "reprinttik"){
                                            self.navigateToRePrintTik = true
                                        } else if (item.programpos_id == "wblist0"){
                                            self.navigateToWBList = true
                                        } else if (item.programpos_id == "wblist1"){
                                            self.navigateToWBListIn = true
                                        } else if (item.programpos_id == "wblist2"){
                                            self.navigateToWBListOut = true
                                        } else if (item.programpos_id == "wblist3"){
                                            self.navigateToWBListStok = true
                                        //Redeem - Kidcity
                                        } else if (item.programpos_id == "rdmticket"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToRedeem = true
                                            } else {
                                                self.navigateToRedeem = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "kartumain"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToKartuMain = true
                                            } else {
                                                self.navigateToKartuMain = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "topup"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToTopUp = true
                                            } else {
                                                self.navigateToTopUp = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "topupapp"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToTopUpApp = true
                                            } else {
                                                self.navigateToTopUpApp = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "topuppen"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToTopUpPen = true
                                            } else {
                                                self.navigateToTopUpPen = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "kartucek"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToKartuCek = true
                                            } else {
                                                self.navigateToKartuCek = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "kartupen"){
                                            
                                            if self.controller.cashier == 1 {
                                                self.navigateToKartuPen = true
                                            } else {
                                                self.navigateToKartuPen = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                        } else if (item.programpos_id == "rdmcust"){
                                            self.navigateToRdmCust = true
                                        //Playground
                                        } else if (item.programpos_id == "pglist1"){
                                            self.navigateToPGListIn = true
                                        } else if (item.programpos_id == "pglist2"){
                                            self.navigateToPGListOut = true
                                        // Zoomove
                                        } else if (item.programpos_id == "scangames"){
                                            self.navigateToScanZooMove = true
                                        
                                        // Transaksi Penjualan
                                        } else if (item.programpos_id == "fnb" || item.programpos_id == "transaksi" || item.programpos_id == "ticket" || item.programpos_id == "playground" || item.programpos_id == "openbooth" || item.programpos_id == "games" || item.programpos_id == "rdmmerchan"){
                                            if self.controller.cashier == 1 {
                                                self.navigateToPenjualan = true
                                            } else {
                                                self.navigateToPenjualan = false
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Anda tidak punya akses untuk menu ini"
                                            }
                                            
                                            
                                        } else {
                                            
                                        }
                                    }
                                    
                                }) {
                                    VStack {
                                        AsyncImage(url: URL(string: item.programpos_url)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .frame(width: 200, height: 200)
                                                    .aspectRatio(contentMode: .fit)
                                            } else if phase.error != nil {
                                                Image(systemName: "photo")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Text(item.programpos_name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 250)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                     
                    
                    
                }
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.controller.filterIsParent = 1
                            self.controller.parent_id = ""
                        }) {
                            
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
                            
                            
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                    }
                }
                // Custom Alert
                if controller.showSyncronize {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("Syncronize Data Master ?").font(.headline)
                        if (self.controller.isLoading == true){
                            ProgressView()
                        }
                        Text(controller.messageSyncronize)
                        
                        HStack {
                            Spacer()
                            Button("Skip") {
                                controller.showSyncronize = false  
                            }
                            
                            Spacer()
                             
                            Button("Ok")  {
                                
                                if (SyncFinished == true){
                                    controller.showSyncronize = false
                                } else {
                                    self.controller.messageSyncronize = ""
                                    viewModel.startSync(context: modelContext, controller: controller)
                                    self.SyncFinished = true
                                }
                                
                                
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(width: 280)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
            }
            .onAppear(){
                if (self.controller.isAutoShowSyncronize == true){
                    self.controller.showSyncronize = true
                    self.controller.isAutoShowSyncronize = false
                }
                self.controller.status.removeAll()
                self.controller.payment.removeAll()
                self.controller.log.removeAll()
            }
            //Transaksi - Penjualan
            .navigationDestination(isPresented: $navigateToPenjualan) {
                PenjualanView(programposID : programposID, programposName : programposName)
            }
            //Screeen
            .navigationDestination(isPresented: $navigateToLaporan) {
                LaporanView()
            }
            .navigationDestination(isPresented: $navigateToRedeem) {
                RedeemView()
            }
            .navigationDestination(isPresented: $navigateToPrinter) {
                PrinterView()
            }
            .navigationDestination(isPresented: $navigateToRePrint) {
                RePrintVoidView(type: "RePrint")
            }
            .navigationDestination(isPresented: $navigateToVoid) {
                RePrintVoidView(type: "Void")
            }
            .navigationDestination(isPresented: $navigateToPassword) {
                PasswordView()
            }
            .navigationDestination(isPresented: $navigateToShiftClose) {
                ShiftCloseView()
            }
            .navigationDestination(isPresented: $navigateToRePrintTic) {
                RePrintTicView()
            }
            .navigationDestination(isPresented: $navigateToCekTiket) {
                CekTicketView()
            }
            .navigationDestination(isPresented: $navigateToCekQRIS) {
                CekQRISView()
            }
            //Frozenland
            .navigationDestination(isPresented: $navigateToScanIn) {
                ScanTicketView(type: "In")
            }
            .navigationDestination(isPresented: $navigateToScanOut) {
                ScanTicketView(type: "Out")
            }
            .navigationDestination(isPresented: $navigateToScanWBIn) {
                ScanWristbandView(type: "In")
            }
            .navigationDestination(isPresented: $navigateToScanWBOut) {
                ScanWristbandView(type: "Out")
            }
            .navigationDestination(isPresented: $navigateToRePrintTik) {
                RePrintTikMasukView()
            }
            .navigationDestination(isPresented: $navigateToWBList) {
                WristbandListView(type: "List")
            }
            .navigationDestination(isPresented: $navigateToWBListIn) {
                WristbandListView(type: "In")
            }
            .navigationDestination(isPresented: $navigateToWBListOut) {
                WristbandListView(type: "Out")
            }
            .navigationDestination(isPresented: $navigateToWBListStok) {
                WristbandListView(type: "Stok")
            }
            //Redeem / Kidcity
            .navigationDestination(isPresented: $navigateToKartuMain) {
                KartuBermainView()
            }
            .navigationDestination(isPresented: $navigateToKartuCek) {
                KartuBermainCekView()
            }
            .navigationDestination(isPresented: $navigateToKartuPen) {
                KartuBermainPenView()
            }
            .navigationDestination(isPresented: $navigateToTopUp) {
                TopupView()
            }
            .navigationDestination(isPresented: $navigateToTopUpApp) {
                TopupAppView()
            }
            .navigationDestination(isPresented: $navigateToTopUpPen) {
                TopupPenView()
            }
            .navigationDestination(isPresented: $navigateToRdmCust) {
                RedeemCustView()
            }
            //Playground
            .navigationDestination(isPresented: $navigateToPGListIn) {
                PlaygroundListView(type: "In")
            }
            .navigationDestination(isPresented: $navigateToPGListOut) {
                PlaygroundListView(type: "Out")
            }
            //Zoomove
            .navigationDestination(isPresented: $navigateToScanZooMove) {
                ScanZoomoveView()
            }
            
        }
        
    }
}

// MARK: - Subviews
struct HeaderBarView: View {
    @EnvironmentObject var controller : Controller
    var body: some View {
        HStack(spacing : 20) {
            Button(action: {
                self.controller.syncProgrampos()
            }) { Image(systemName: "arrow.clockwise") }
            Button(action: {}) { Image(systemName: "gearshape.fill") }
            Spacer()
            Text(self.controller.user_fullname).bold().font(.title3)
            Spacer()
            Button(action: {}) { Image(systemName: "cart.fill") }
            Button(action: {
                self.controller.isLoggedIn = false
            }) { Image(systemName: "rectangle.portrait.and.arrow.right") }
        }
        .foregroundColor(.white)
        .padding()
    }
}

struct InfoCardView: View {
    @EnvironmentObject var controller : Controller
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(self.controller.branch_name).bold()
                Spacer()
                Text(self.controller.getFormattedDateDDMMMMYYYY())
            }
            Text("\(self.controller.machine_name) (\(self.controller.terminal_name)")
                .font(.subheadline)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


// Preview untuk Xcode 16
#Preview {
    HomeView()
}
