import SwiftUI
import SwiftData

struct RePrintVoidView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var voidReason : [VoidReason]
    
    let type : String
    @State private var userName = ""
    @State private var password = ""
    @State private var noBill = ""
    @State private var alasanVoid = "Salah Pesan"
    @Environment(\.dismiss) var dismiss
    let daftarAlasan = ["Salah Pesan", "Stok Habis", "Pelanggan Batal"]
    
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
                CustomTextField(placeholder: "User Name", text: $userName)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                CustomTextField(placeholder: "No Bill", text: $noBill)
                
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
                
                Button(action: {}) {
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
    }
}
 
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            Divider()
        }
    }
}

#Preview {
    RePrintVoidView(type: "Void")
}
