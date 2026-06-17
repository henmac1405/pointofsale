import SwiftUI

struct ScanBarcodeTicketView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    
    let type : String
    
    @State private var showInputPopup: Bool = false
    @State private var inputCode: String = ""
    @State private var barcodeResult: String = ""
    @State private var tittle = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                HStack {
                    Text(tittle)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                     
                    Button(action: {
                        showInputPopup = true
                        isTextFieldFocused = true
                        inputCode = ""
                        
                    }) {
                        Image(systemName: "keyboard")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white)
                
                Spacer()
                Text("CAMERA")
                Spacer()
                 
                VStack(spacing: 5) {
                    Text("\(type) :")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                     
                    Text(barcodeResult.isEmpty ? "-" : barcodeResult)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                Divider()
                 
                HStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("TUTUP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                     
                    Button(action: {
                        barcodeResult = "8999906664215"
                    }) {
                        Text("SCAN")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                     
                    Button(action: {
                        print("Proses data: \(barcodeResult)")
                    }) {
                        Text("PROSES")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                }
                .padding()
                
                
            }
            
            // Custom Alert
            if showInputPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Masukkan Kode atau Nomor")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 5)
                     
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
                    
                    HStack {
                        Spacer()
                        Button("Batal") {
                            showInputPopup = false
                            isTextFieldFocused = false
                        }
                        
                        Spacer()
                        
                        Button("Cari")  {
                            showInputPopup = false
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
        .navigationBarHidden(true)
        .onAppear{
            if type == "Barcode" {
                self.tittle = "Barcode Scanner"
            } else {
                self.tittle = "Ticket Scanner"
            }
        }
    }
}

 

// MARK: - Preview Simulator
#Preview {
    ScanBarcodeTicketView(type : "")
}
