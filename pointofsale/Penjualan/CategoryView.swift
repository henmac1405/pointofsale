import SwiftUI
 import SwiftData


struct CategoryView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
 
    @Query(sort: \Category.category_name) var category: [Category]
    
    let item_type : String
    var completion: (String, String, Int, Int) -> Void
    
    @State private var selectedCategoryId: UUID?
    
    var filteredCategory: [Category] {
        if item_type.isEmpty {
            return category
        } else {
            return category.filter { item in
                item.item_type.localizedCaseInsensitiveContains(item_type)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                 
                Spacer()
                Text("Daftar Kategori")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer() 
                Color.clear.frame(width: 30, height: 30)
            }
            .padding()
            .background(Color.blue)
            
            // MARK: - Item Additional
            VStack{
                    ForEach(filteredCategory, id: \.id) { item in
                        Button(action:{
                            completion(item.category_id, item.category_name, 0, 0)
                            dismiss()
                            print(item_type)
                        }){
                            HStack(spacing: 20) {
                                Image(systemName: "record.circle")
                                    .font(.title2)
                                    .foregroundColor(.black.opacity(0.7))
                                 
                                Text("\(item.category_name)")
                                    .font(.system(size: 16, weight: .bold))
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding(.vertical, 10)
                        }
                        Divider()
                        
                    }
                
            }
            Spacer()
            
            
            // MARK: - Footer Button
            VStack {
                Divider()
                Button(action: {
                    dismiss()
                }) {
                    Text("TUTUP")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.purple.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(20)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
//    CategoryView()
//}
