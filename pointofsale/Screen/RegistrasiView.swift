import SwiftUI

struct DeviceInfoItem: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct RegistrasiView: View {
    @Environment(\.dismiss) var dismiss
    
    // Data dummy sesuai gambar
    let deviceDetails = [
        DeviceInfoItem(label: "ID", value: "TP1A.220624.014"),
        DeviceInfoItem(label: "manufacturer", value: "INFINIX"),
        DeviceInfoItem(label: "model", value: "Infinix X6528B"),
        DeviceInfoItem(label: "product", value: "X6528B-OP"),
        DeviceInfoItem(label: "brand", value: "Infinix"),
        DeviceInfoItem(label: "display", value: "X6528B-F069ZAaAbAcAdAeBgBhBi-T-OP-2"),
        DeviceInfoItem(label: "board", value: "Infinix-X6528B"),
        DeviceInfoItem(label: "device", value: "Infinix-X6528B")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header / Title
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
                        Text("PERANGKAT SUDAH TERDAFTAR")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("TRANS SNOW SURABAYA")
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
                
                Button(action: { /* Aksi Daftar */ }) {
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
    }
}

#Preview {
    RegistrasiView()
}
