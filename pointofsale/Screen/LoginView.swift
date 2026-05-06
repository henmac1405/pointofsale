import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isMenuExpanded = false
    @State private var navigateToCekKoneksi = false
    @State private var navigateToRegistrasi = false
    @State private var navigateToDownload = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white.ignoresSafeArea()
                
                // Konten Utama (Logo, Input, Tombol)
                VStack(spacing: 20) {
                    Image("TE") // Pastikan aset tersedia
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.top, 40)
                        .opacity(isMenuExpanded ? 0.3 : 1.0) // Efek redup saat menu buka
                    
                    // Input Fields
                    VStack(spacing: 15) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
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
                        mainButton(title: "Login")
                        mainButton(title: "Cancel")
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .disabled(isMenuExpanded)
                    
                    VStack(spacing: 15){
                        Text("Version 5.0.2")
                        Text("Last update 11 Febuari 2026")
                    }
                    
                    Spacer()
                }
                .blur(radius: isMenuExpanded ? 3 : 0) // Efek blur saat menu aktif
                
                // --- EXPANDABLE FAB SECTION ---
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 15) {
                            if isMenuExpanded {
                                
                                Button(action: {
                                    isMenuExpanded = false
                                    navigateToDownload = true // Trigger navigasi ke Registrasi
                                }) {
                                    menuItem(label: "Download", icon: "square.and.arrow.down.fill")
                                }
                                
                                Button(action: {
                                    isMenuExpanded = false
                                    navigateToRegistrasi = true // Trigger navigasi ke Registrasi
                                }) {
                                    menuItem(label: "Registration", icon: "pencil")
                                }
                                 
                                Button(action: {
                                    isMenuExpanded = false // Tutup menu FAB
                                    navigateToCekKoneksi = true // Trigger navigasi
                                }) {
                                    menuItem(label: "APIs Connection", icon: "gearshape.fill")
                                }
                            }
                            
                            // Tombol Utama (Toggle)
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
                RegistrasiView() // Halaman yang baru saja kita buat
            }
            .navigationDestination(isPresented: $navigateToDownload) {
                DownloadView() // Halaman yang baru saja kita buat
            }
        }
        
    }
    
    // Helper View untuk item menu melayang
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
    
    // Helper untuk TextField
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
    
    // Helper untuk Tombol Utama
    func mainButton(title: String) -> some View {
        Button(action: {}) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0, green: 0.6, blue: 0.8))
                .cornerRadius(35)
        }
    }
}

#Preview {
    LoginView()
}
