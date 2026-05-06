import SwiftUI

struct CekKoneksiView: View {
    @State private var urlApiTe = "https://transsnowworld.com"
    @State private var urlApiAllo = "https://transsnowworld.com"
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
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
                // Spacer tambahan untuk menyeimbangkan tombol back
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
                        Divider()
                        
                        Button(action: { /* Aksi Cek */ }) {
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
                        Divider()
                        
                        Button(action: { /* Aksi Cek */ }) {
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
                
                Button(action: { /* Aksi Simpan */ }) {
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
    }
}

#Preview {
    CekKoneksiView()
}
