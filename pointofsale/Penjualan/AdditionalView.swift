import SwiftUI
import SwiftData

struct AdditionalView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var size: [Size]
    
    let itemAdd_name : String
    let itemAdd_qty : Int
    let size_type : String
    
    @State private var selectedQty = 0
    @State private var selectedName = ""
     
    
    @State private var selectedSize: String? = nil
     
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var filteredSize: [Size] {
            if size_type.isEmpty {
                return size
            } else {
                return size.filter { item in
                    item.size_type.localizedCaseInsensitiveContains(size_type)
                }
            }
        }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Spacer()
                Text(itemAdd_name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            
            // MARK: - Grid Ukuran
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(filteredSize, id: \.id) { size in
                        Button(action: {
                            if (selectedQty < self.itemAdd_qty){
                                selectedSize = size.size_id
                                selectedQty = selectedQty + 1
                                selectedName = selectedName + "\(size.size_name), "
                            }
                        }) {
                            Text(size.size_name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(selectedSize == size.size_id ? Color.blue.opacity(0.2) : Color(white: 0.96))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedSize == size.size_id ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(20)
                
                
            }
            
            HStack(spacing: 10) {
                Text("PILIH \(itemAdd_qty) \(itemAdd_name) : \(selectedName)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }
            // MARK: - Footer Buttons
            HStack(spacing: 10) {
                Button(action: {
                    dismiss()
                }) {
                    Text("TUTUP")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                Button(action: {
                    self.selectedQty = 0
                    self.selectedName = ""
                }) {
                    Text("HAPUS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                Button(action: {
                    self.controller.insertItemSize(context: modelContext, itemAdd_name: itemAdd_name, itemAdd_qty: itemAdd_qty)
                    self.controller.updateItemAdd_Status(name: itemAdd_name, status: 1)
                    dismiss()
                }) {
                    Text("SIMPAN")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                 
            }
            .padding()
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
    
    
    
}



#Preview {
    AdditionalView(itemAdd_name : "SEPATU", itemAdd_qty: 0, size_type : "")
}
