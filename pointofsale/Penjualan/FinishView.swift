import SwiftUI

struct FinishView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) private var dismiss
     
    @State var noBill: String = ""
    
    @State private var showingNewTransactionAlert = false
    
    // State kontrol alur transaksi
    @State var isSuccess = false
    @State var status = "Status Error : "
    @State var isProcessing: Bool = false
    
    let totalBill: Double
    var payment : Double
    var change : Double
    var cashier : String
    var paymentType : String
     
    @State private var navigateToPenjualan = false
    @State private var navigateToStruk = false
    @State private var hasExecutedApi = false
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if isProcessing {
                    LoadingView()
                } else if isSuccess {
                    SuccessReceiptView(
                        noBill: noBill,
                        date: self.controller.getFormattedDateTimeFull(),
                        totalBill: Int(totalBill).formattedWithSeparator(),
                        payment: Int(payment).formattedWithSeparator(),
                        change: Int(change).formattedWithSeparator(),
                        cashier: cashier,
                        paymentType: paymentType
                    )
                } else {
                    FailedView(status: status)
                }
            }
            .frame(maxHeight: .infinity)
             
            HStack(spacing: 16) {
                if isSuccess {
                    Button(action: {
                        self.hasExecutedApi = true
                        navigateToStruk = true
                    }) {
                        Text("PRINT RECEIPT")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isProcessing ? Color.gray : Color.blue)
                            .cornerRadius(25)
                    }
                    .disabled(isProcessing)
                } else {
                    Button(action: {
                        executeApiTransaction()
                    }) {
                        Text("TRY AGAIN")  
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isProcessing ? Color.gray : Color.blue)
                            .cornerRadius(25)
                    }
                    .disabled(isProcessing)
                }
                
                Button(action: {
                    showingNewTransactionAlert = true
                }) {
                    Text("NEW TRANSACTION")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isProcessing ? Color.gray : Color.blue)
                        .cornerRadius(25)
                }
                .disabled(isProcessing)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .border(Color(.systemGray6), width: 1)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !hasExecutedApi {
                            executeApiTransaction()
                        }
        }
        .alert("New Transaction ?", isPresented: $showingNewTransactionAlert) {
            Button("Cancel", role: .cancel) {
            }
            Button("Yes") {
                NewTransaction()
            }
        } message: {
        }
        //Transaksi - Penjualan
        .navigationDestination(isPresented: $navigateToPenjualan) {
            PenjualanView(programposID : self.controller.programposID, programposName : self.controller.programposName)
        }
        //Struk
        .navigationDestination(isPresented: $navigateToStruk) {

                    StrukView(
                        noBill:  noBill,  
                    )
                }
    }
    
    private func NewTransaction() {
        self.controller.status.removeAll()
        self.controller.payment.removeAll()
        self.controller.log.removeAll()
        self.controller.customer.removeAll()
        
        navigateToPenjualan = true
    }
    private func executeApiTransaction() {
        withAnimation {
            self.isProcessing = true
        }
        
         
        controller.list_tesnew(
        ) { result in
            withAnimation {
                self.isProcessing = false
                
                if result.prefix(7) == "success" {
                    self.isSuccess = true
                    let components = result.components(separatedBy: "-")
                    if components.count > 1 {
                        self.noBill = components[1]
                    }
                } else {
                    self.isSuccess = false
                    self.status = "\(result)"
                }
            }
        }
    }
    
    private func formatAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    
    
}

// MARK: - Subviews Komponen UI Terpisah (Lebih Rapi & Ringan)

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(2.0)
                .tint(.blue)
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SuccessReceiptView: View {
    var noBill: String
    var date: String
    var totalBill: String
    var payment: String
    var change: String
    var cashier: String
    var paymentType: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Transaction Successful")
                    .font(.system(size: 24, weight: .regular))
                    .padding(.top, 40)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)
                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 20)
                
                VStack(spacing: 18) {
                    ReceiptRow(label: "No Bill", value: noBill)
                    ReceiptRow(label: "Date", value: date)
                    ReceiptRow(label: "Total Bill", value: totalBill)
                    ReceiptRow(label: "Payment", value: payment)
                    ReceiptRow(label: "Change", value: change)
                    ReceiptRow(label: "Cashier", value: cashier)
                    ReceiptRow(label: "Payment Type", value: paymentType)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct FailedView: View {
    var status: String
    
    var body: some View {
        VStack(spacing: 24) {
            ScrollView{
                Spacer()
                Text("Failed Transaction")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.red)
                    .padding()
                
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    .padding()
                Text(status)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

struct ReceiptRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(width: 120, alignment: .leading)
            
            Text(":")
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
