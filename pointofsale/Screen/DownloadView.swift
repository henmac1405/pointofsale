import SwiftUI

struct DownloadView: View {
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
                Text("Download & Update")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                // Spacer tambahan untuk menyeimbangkan tombol back
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.green)
            
            Spacer()
            
            
                VStack(alignment: .leading, spacing: 30) {
                    
                     
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("BUKAN VERSI TERBARU SILAHKAN UPDATE APPS ANDA")
                            .font(.caption)
                            .foregroundColor(.black)
                        
                         
                    }
                     
                    
                }
                .padding(25)
            
            
            Spacer()
            
            // Footer Buttons
            HStack(spacing: 15) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("TUTUP")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
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
    DownloadView()
}
