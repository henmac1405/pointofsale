import SwiftUI

import SwiftData

struct SalesmanView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SyncViewModel()
    @Query var salesman: [SalesMan]
 
    
    @State private var selectedCategoryId: UUID?
    
    var completion: (String, String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                 
                Spacer()
                Text("Sales Name")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer() 
                Color.clear.frame(width: 30, height: 30)
            }
            .padding()
            .background(Color.blue)
            
            // MARK: - Item Salesman
            VStack{
                ForEach(salesman, id: \.salesman_id) { item in
                    Button(action:{
                        completion(item.salesman_id, item.salesman_name)
                        dismiss()
                    }){
                        HStack(spacing: 20) {
                            Image(systemName: "record.circle")
                                .font(.title2)
                                .foregroundColor(.black.opacity(0.7))
                            
                            Text("\(item.salesman_name)")
                                .font(.system(size: 20, weight: .bold))
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

