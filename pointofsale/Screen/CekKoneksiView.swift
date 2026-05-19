import SwiftUI
import SwiftData

struct CekKoneksiView: View {
    @EnvironmentObject var controller : Controller
    //https://apidev.transstudiomini.com/index.php/apiv5/
    @State private var urlApiTe = ""
    @State private var urlApiAllo = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @Query private var configs: [AppConfig]
    
    @StateObject private var viewModel = SyncViewModel()
    @Query private var settings: [Setting]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                Spacer()
                Text("CEK KONEKSI")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.blue)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Seksi URL API TE
                    VStack(alignment: .leading, spacing: 8) {
                        Text("URL API TE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "target") // Mengganti ikon radio button
                                .foregroundColor(.black)
                                .padding(.top, 4)
                            
                            TextField("", text: $urlApiTe, axis: .vertical)
                                .font(.body)
                        }
                        Text(self.controller.result_cekkoneksiTE)
                            .font(.caption)
                        Divider()
                        
                        Button(action: {
                            self.controller.result_cekkoneksiTE = ""
                            self.controller.formType = "CekKoneksiTE"
                            self.controller.url_api = self.urlApiTe
                            self.controller.getCompany()
                        }) {
                            Text("CEK KONEKSI URL API TE")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.purple.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .padding(.top, 10)
                    }
                    
                    // Seksi URL API ALLO
                    VStack(alignment: .leading, spacing: 8) {
                        Text("URL API ALLO")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "target")
                                .foregroundColor(.black)
                                .padding(.top, 4)
                            
                            TextField("", text: $urlApiAllo, axis: .vertical)
                                .font(.body)
                        }
                        Text(self.controller.result_cekkoneksiAllo)
                            .font(.caption)
                        Divider()
                        
                        Button(action: {
                            self.controller.result_cekkoneksiAllo = ""
                            self.controller.formType = "CekKoneksiAllo"
                            self.controller.url_api = self.urlApiTe
                            self.controller.getCompany()
                        }) {
                            Text("CEK KONEKSI URL API ALLO")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.purple.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(25)
            }
            
            Spacer()
            
            // Footer Buttons
            HStack(spacing: 15) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("TUTUP")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    viewModel.startSync(context: modelContext, controller: controller)
                }) {
                    Text("SETTING")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    saveData()
                }) {
                    Text("SIMPAN")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
        .navigationBarHidden(true)
        .onAppear {
                    loadData()
                }
    }
    
    // FUNGSI UNTUK MEMUAT DATA
    func loadData() {
        if let savedConfig = configs.first {
            urlApiTe = savedConfig.urlApiTe
            urlApiAllo = savedConfig.urlApiAllo
            print("Data dimuat: \(urlApiTe)")
        } else {
            urlApiTe = ""
            urlApiAllo = ""
            print("Database kosong, menggunakan nilai default.")
        }
    }
    
    // FUNGSI UNTUK MENYIMPAN DATA
    func saveData() {
        for config in configs {
            modelContext.delete(config)
        }
         
        let newConfig = AppConfig(urlApiTe: urlApiTe, urlApiAllo: urlApiAllo)
        modelContext.insert(newConfig)
        
        print("Data berhasil diperbarui!")
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CekKoneksiView()
}
