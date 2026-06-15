import SwiftUI
import SwiftData
struct PaymentMethod: Identifiable {
    let id = UUID()
    let name: String
}

struct PembayaranView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var tender: [Tender]
    
    let totalBill: Double
    @State var paymentBill: Double = 0
    @State var changeBill: Double = 0
    
    @State private var cashReceived: String = "50000"
    @State private var selectedTenderId: String? = nil
    @State private var showDialog: Bool = false
    @State private var inputCode: String = ""
    @State private var tender_id = ""
    @State private var tender_name = ""
    @State private var tender_type = ""
    @State private var change_amount: Double = 0
    
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isInputFocused: Bool
    
    
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    @State private var navigateToFinish = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            
            // MARK: - 1. CUSTOM TOP NAVIGATION BAR
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                Text("Pembayaran")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                
                Image(systemName: "arrow.left").foregroundColor(.clear)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
            
            
            
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - 2. TOTAL TAGIHAN
                    Text("Total Tagihan : Rp. \(Int(totalBill).formattedWithSeparator())")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.top, 30)
                    
                    // MARK: - 3. INPUT TUNAI
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Uang Tunai yang diterima")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        TextField("", text: $cashReceived)
                            .focused($isInputFocused)
                            .keyboardType(.numberPad)
                            .font(.system(size: 18))
                            .padding()
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray3), lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - 4. TOMBOL BAYAR TUNAI
                    Button(action: {
                        print("Bayar tunai diproses: \(cashReceived)")
                        if cashReceived.isEmpty {
                            self.controller.toastShow(message: "Nominal uang tunai tidak boleh kosong", style: .error)
                        } else if totalBill > Double(cashReceived)! {
                            self.controller.toastShow(message: "Pembayaran kurang dari total pembelian", style: .error)
                        } else {
                            change_amount = Double(cashReceived)! - totalBill
                            paymentBill = Double(cashReceived)!
                            changeBill =  paymentBill - totalBill
                            tender_id = "CASH"
                            tender_name = "CASH"
                            tender_type = "CASH"
                            self.controller.insertPayment(salesid: self.controller.sales_id, tender_id: tender_id, tender_name: tender_name, tender_type: tender_type, tender_code: inputCode, sales_amount: totalBill, payment_amount: Double(cashReceived)!, change_amount: changeBill, dailyid: self.controller.daily_id){
                                navigateToFinish = true
                            }
                        }
                    }) {
                        Text("BAYAR TUNAI")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - 5. SEPARATOR NON TUNAI
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Non Tunai")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                        
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(tender, id: \.id) { method in
                                Button(action: {
                                    print("\(method.tender_id) - \(method.tender_name) dipilih")
                                    tender_id = method.tender_id
                                    tender_name = method.tender_name
                                    tender_type = method.tender_type
                                    selectedTenderId = method.tender_id
                                    if method.tender_id == "qrismega" {
                                        
                                    } else {
                                        showDialog = true
                                        isTextFieldFocused = true
                                        inputCode = ""
                                    }
                                }) {
                                    Text(method.tender_name)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 8)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                        .background(selectedTenderId == method.tender_id ? Color.blue.opacity(0.2) : Color(white: 0.96))
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(.systemGray6), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    // MARK: - Footer Button
                    VStack {
                        Divider()
                        Button(action: {
                            dismiss()
                        }) {
                            Text("TUTUP")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(20)
                    }
                    .background(Color.white)
                }
            }
            
            
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
        .alert("Masukkan Kode atau Nomor", isPresented: $showDialog) {
            TextField("", text: $inputCode)
                .focused($isTextFieldFocused)
                .font(.system(size: 16))
                .padding()
                .frame(height: 55)
                .background(Color(red: 0.95, green: 0.93, blue: 0.97))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.45, green: 0.35, blue: 0.65), lineWidth: 2)
                )
                .keyboardType(.default)
            
            Button("BATAL", role: .cancel) {
                selectedTenderId = nil
                showDialog = false
                isTextFieldFocused = false
            }
            Button("PROSES") {
                if inputCode.count > 5 {
                    paymentBill = totalBill
                    changeBill =  paymentBill - totalBill
                    showDialog = false
                    self.controller.insertPayment(salesid: self.controller.sales_id, tender_id: tender_id, tender_name: tender_name, tender_type: tender_type, tender_code: inputCode, sales_amount: totalBill, payment_amount: totalBill, change_amount: 0, dailyid: self.controller.daily_id){
                        navigateToFinish = true
                    }
                } else {
                    self.controller.toastShow(message: "Minimal 6 karakter", style: .error)
                }
            }
        } message: {
            Text("")
        }
        .navigationDestination(isPresented: $navigateToFinish) {
            
            FinishView(
                totalBill: self.totalBill,
                payment: self.paymentBill,
                change : self.changeBill,
                cashier : self.controller.user_fullname,
                paymentType : self.tender_type,
            )
        }
        .navigationTitle("Pembayaran")


        
        
        
    }
}

// MARK: - Preview
#Preview {
    PembayaranView(totalBill: 8000)
}
