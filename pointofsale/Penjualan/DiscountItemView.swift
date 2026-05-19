import SwiftUI

struct DiscountItemView: View {
    @Environment(\.dismiss) private var dismiss
     
    var onApplyDiscount: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 1. CUSTOM TOP NAVIGATION BAR
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Discount")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 15)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
            
            // MARK: - 2. AREA DAFTAR DISKON (KONTEN UTAMA)
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                }
                .padding()
            }
            
            Divider()
            
            // MARK: - 3. BARIS TOMBOL AKSI BAWAH (Sesuai Gambar)
            HStack(spacing: 16) {
                 
                Button(action: {
                    onApplyDiscount(0)
                    dismiss()
                }) {
                    Text("HAPUS DISKON")
                        .modifier(DiscountButtonModifier())
                }
                
                
                Button(action: {
                    dismiss()
                }) {
                    Text("TUTUP")
                        .modifier(DiscountButtonModifier())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - STYLING MODIFIER UNTUK TOMBOL DISKON (Warna Ungu Pastel Sesuai Gambar)
struct DiscountButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color(red: 0.45, green: 0.35, blue: 0.65))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color(red: 0.96, green: 0.95, blue: 0.98))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(.systemGray5), lineWidth: 1)  
            )
    }
}

// MARK: - Preview Simulator
#Preview {
    DiscountItemView(onApplyDiscount: { _ in })
}
