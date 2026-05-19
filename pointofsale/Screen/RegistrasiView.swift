import SwiftUI

struct DeviceInfoItem: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct RegistrasiView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
     
    let deviceDetails = [
        DeviceInfoItem(label: "ID", value: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"),
        DeviceInfoItem(label: "manufacturer", value: "Apple"),
        DeviceInfoItem(label: "model", value: UIDevice.current.model),
        DeviceInfoItem(label: "product", value: UIDevice.current.name),
        DeviceInfoItem(label: "brand", value: "Apple"),
        DeviceInfoItem(label: "device", value: UIDevice.current.name + " " + UIDevice.current.systemName + " " + UIDevice.current.systemVersion),
        DeviceInfoItem(label: "IOS ID", value: UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: "") ?? "Unknown")
    ]
    
     
    @State var keterangan = ""
    @State var serialnumber = String(UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: "").suffix(10) ?? "")
    
     
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("IOS Device Info")
                    .font(.system(size: 24, weight: .regular))
                    .padding(.leading, 20)
                Spacer()
            }
            .frame(height: 60)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Status Terdaftar
                    VStack(spacing: 15) {
                        Text(self.controller.registrasiDescr)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(self.controller.registrasiBranch)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 30)
                    
                    // List Informasi Device
                    VStack(spacing: 0) {
                        ForEach(deviceDetails) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .top) {
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .resizable()
                                        .frame(width: 8, height: 10)
                                        .padding(.top, 5)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.label)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(item.value)
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal, 10)
                                
                                Divider()
                                    .padding(.top, 8)
                            }
                            .padding(.bottom, 15)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    //keterangan
                    VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .top) {
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .resizable()
                                        .frame(width: 8, height: 10)
                                        .padding(.top, 5)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Keterangan")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        TextField("Keterangan", text: $controller.registrasiKeterangan)
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                            .autocapitalization(.allCharacters)
                                    }
                                }
                                .padding(.horizontal, 10)
                                
                                Divider()
                                    .padding(.top, 8)
                            }
                            .padding(.bottom, 15)
                        
                    }
                    .padding(.horizontal, 10)
                    
                    //serial number
                    VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .top) {
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .resizable()
                                        .frame(width: 8, height: 10)
                                        .padding(.top, 5)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Serial Number")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        TextField("Serial Number", text: $controller.registrasiSerialNumber)
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                            .autocapitalization(.allCharacters)
                                    }
                                }
                                .padding(.horizontal, 10)
                                
                                Divider()
                                    .padding(.top, 8)
                            }
                            .padding(.bottom, 15)
                        
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            // Footer Buttons
            HStack(spacing: 15) {
                Button(action: { dismiss() }) {
                    Text("TUTUP")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    self.controller.updateDeviceRegister { json in
                        if let data = json {
                            self.controller.showAlert = true
                            self.controller.responseMessage = "\(data["message"])"
                        } else {
                            self.controller.showAlert = true
                            self.controller.responseMessage = "Gagal Update Data Perangkat"
                        }
                    }
                }) {
                    Text("UPDATE")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    if (self.controller.registrasiKeterangan == ""){
                        self.controller.showAlert = true
                        self.controller.responseMessage = "KETERANGAN TIDAK BOLEH KOSONG"
                    } else if (self.controller.registrasiSerialNumber == ""){
                        self.controller.showAlert = true
                        self.controller.responseMessage = "SERIAL NUMBER TIDAK BOLEH KOSONG"
                    } else if (self.controller.registrasiStatus != 0) {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "PERANGKAT SUDAH TERDAFTAR"
                    } else {
                        self.controller.insertDeviceRegister { json in
                            if let data = json {
                                print("Data berhasil disimpan : \(data["message"])")
                                self.controller.showAlert = true
                                self.controller.responseMessage = "\(data["message"])"
                                if (data["state"] == true) {
                                    dismiss()
                                } 
                            } else {
                                print("Gagal Menyimpan Data Perangkat")
                                self.controller.showAlert = true
                                self.controller.responseMessage = "Gagal Menyimpan Data Perangkat"
                            }
                        }
                    }
                }) {
                    Text("DAFTAR")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding(20)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .onAppear {
            self.controller.formType = "Registrasi"
            self.controller.getCompany()
             
                }
    }
}

#Preview {
    RegistrasiView()
}
