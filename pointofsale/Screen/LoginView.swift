import SwiftUI
import SwiftData

struct LoginView: View {
    @EnvironmentObject var controller : Controller
    
    @State private var username = "suhendra"
    @State private var password = "rahasia"
    @State private var isPasswordVisible = false
    @State private var isMenuExpanded = false
    @State private var navigateToCekKoneksi = false
    @State private var navigateToRegistrasi = false
    @State private var navigateToDownload = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var configs: [AppConfig]
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white.ignoresSafeArea()
                 
                VStack(spacing: 20) {
                    Image("TE")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.top, 40)
                        .opacity(isMenuExpanded ? 0.3 : 1.0)
                    
                     
                    VStack(spacing: 15) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                            }
                            
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            if(self.username == "" || self.password == ""){
                                self.controller.showAlert = true
                                self.controller.responseMessage = "User name dan Password tidak boleh kosong"
                            } else {
                                self.controller.isAutoShowSyncronize = true
                                self.controller.formType = "Login"
                                self.controller.username = self.username
                                self.controller.user_password = self.password
                                self.controller.getCompany()
                            }
                        }) {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0, green: 0.6, blue: 0.8))
                                .cornerRadius(35)
                        }
                        Button(action: {}) {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0, green: 0.6, blue: 0.8))
                                .cornerRadius(35)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .disabled(isMenuExpanded)
                    
                    VStack(spacing: 15){
                        Text("Version \(self.controller.POSVersion)")
                        Text("\(self.controller.POSupdate)")
                    }
                    
                    Spacer()
                }
                .blur(radius: isMenuExpanded ? 3 : 0)
                 
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 15) {
                            if isMenuExpanded {
                                
                                Button(action: {
                                    isMenuExpanded = false
                                    navigateToDownload = true /
                                }) {
                                    menuItem(label: "Download", icon: "square.and.arrow.down.fill")
                                }
                                
                                Button(action: {
                                    isMenuExpanded = false
                                    navigateToRegistrasi = true
                                }) {
                                    menuItem(label: "Registration", icon: "pencil")
                                }
                                 
                                Button(action: {
                                    isMenuExpanded = false
                                    navigateToCekKoneksi = true
                                }) {
                                    menuItem(label: "APIs Connection", icon: "gearshape.fill")
                                }
                            }
                             
                            Button(action: {
                                withAnimation(.spring()) {
                                    isMenuExpanded.toggle()
                                }
                            }) {
                                Image(systemName: isMenuExpanded ? "xmark" : "line.3.horizontal")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 65, height: 65)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToCekKoneksi) {
                CekKoneksiView()
            }
            .navigationDestination(isPresented: $navigateToRegistrasi) {
                RegistrasiView()
            }
            .navigationDestination(isPresented: $navigateToDownload) {
                DownloadView()
            }
            .onAppear {
                        loadData()
                getDeviceId()
                    }
        }
        
    }
     
    @ViewBuilder
    func menuItem(label: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(Color.red)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
     
    func customTextField(placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
    
     
     
    func loadData() {
        if let savedConfig = configs.first {
            self.controller.url_api = savedConfig.urlApiTe
            self.controller.url_api_allo = savedConfig.urlApiAllo
            print("Data dimuat: \(self.controller.url_api)")
        } else { 
            self.controller.showAlert = true
            self.controller.messageAlert = "API's Config is Blank"
            print("API's Config is Blank")
        }
    }
    // DAPATKAN DEVICE ID
    func getDeviceId() {
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            self.controller.deviceID = idfv
            self.controller.deviceName = UIDevice.current.name
            self.controller.deviceModel = UIDevice.current.model
            self.controller.deviceOS = UIDevice.current.systemName
            self.controller.deviceOSVersion = UIDevice.current.systemVersion
            self.controller.deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
            self.controller.iosID = idfv.replacingOccurrences(of: "-", with: "")
            self.controller.deviceDescr = UIDevice.current.name + " " + UIDevice.current.systemName + " " + UIDevice.current.systemVersion
            self.controller.registrasiSerialNumber = String(self.controller.iosID.suffix(10))
            print(self.controller.deviceID)
            print(self.controller.deviceName)
            print(self.controller.deviceModel)
            print(self.controller.deviceOS)
            print(self.controller.deviceOSVersion)
            print(self.controller.iosID)
            print(self.controller.deviceDescr)
        } else {
            self.controller.deviceID = ""
            self.controller.deviceName = ""
            self.controller.deviceModel = ""
            self.controller.deviceOS = ""
            self.controller.deviceOSVersion = ""
            self.controller.deviceUUID = ""
            self.controller.iosID = ""
        }
    }
}

#Preview {
    LoginView()
}
