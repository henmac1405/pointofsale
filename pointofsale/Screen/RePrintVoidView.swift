import SwiftUI
import SwiftData

struct RePrintVoidView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var voidReason : [VoidReason]
    
    let type : String
    @State private var userName = "suhendra"
    @State private var password = "rahasia"
    @State private var noBill = "0001"
    @State private var alasanVoid = "Salah Pesan"
    @Environment(\.dismiss) var dismiss
    let daftarAlasan = ["Salah Pesan", "Stok Habis", "Pelanggan Batal"]
    @State private var salesid = ""
    @State private var dailyid = ""
    @State private var manager = 0
    @State private var navigateToStruk = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text(type)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            
            // Logo
            Image("TE")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding(.top, 20)
            
            // Input Fields
            VStack(spacing: 15) {
                // Field User Name
                CustomTextField(placeholder: "User Name", text: $userName)
                    .submitLabel(.next)
                
                // Field Password
                CustomSecureField(placeholder: "Password", text: $password)
                    .submitLabel(.next)
                
                // Field No Bill
                CustomTextField(placeholder: "No Bill", text: $noBill)
                    .submitLabel(.done)
                
                if (type == "Void"){
                    // Dropdown / Picker
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Alasan Void :")
                            Picker("", selection: $alasanVoid) {
                                ForEach(voidReason, id: \.voidreason_name) { alasan in
                                    Text(alasan.voidreason_name)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button(action: {dismiss()}) {
                    Text("TUTUP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    if userName.isEmpty {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "User Name tidak boleh kosong"
                    } else if password.isEmpty {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "Password tidak boleh kosong"
                    } else if noBill.isEmpty {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "No Bill tidak boleh kosong"
                    } else if noBill.count > 4 {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "No Bill Maksmimal 4 digit"
                    } else {
                        self.salesid = self.dailyid + noBill
                        print("salesid : \(salesid)")
                         
                            self.controller.getuserid(username: userName, user_password: password) { jsonResult in
                                guard let json = jsonResult else {
                                    return
                                }
                                
                                self.manager = json["data"][0]["manager"].intValue
                                print("Manager : \(manager)")
                                
                                if manager == 1 {
                                    
                                    self.controller.getposstatussales_byid(sales_id: salesid){ statusResult in
                                        guard let statusJson = statusResult else {
                                            return
                                        }
                                        
                                        if statusJson["data"][0]["isused"] == 1 {
                                            self.controller.showAlert = true
                                            self.controller.responseMessage = "Sudah digunakan"
                                        } else {
                                            navigateToStruk = true
                                            print("Navigate to Struk")
                                        }
                                    }
                                } else {
                                    self.controller.showAlert = true
                                    self.controller.responseMessage = "Bukan Level Manager!"
                                }
                                
                                
                            
                        }
                    }
                }) {
                    Text("PROSES")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            dailyid = self.controller.getFormattedDateDailyID()
        }
        //Struk
        .navigationDestination(isPresented: $navigateToStruk) {

                    StrukView(
                        noBill:  salesid,
                    )
                }
    }
}
// --- KOMPONEN KUSTOM TEXTFIELD ---
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 16))
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white)
            .autocapitalization(.none)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
    }
}

// --- KOMPONEN KUSTOM SECUREFIELD (PASSWORD) ---
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .font(.system(size: 16))
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white)
            .autocapitalization(.none)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
    }
}

#Preview {
    RePrintVoidView(type: "Void")
}
