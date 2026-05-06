

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var controller : Controller
    @State private var startAnimating = false
    
    var body: some View {
        ZStack{
            VStack{
                if (controller.isLoading == true) {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .tint(.blue)
                        .padding()
                        .opacity(startAnimating ? 1.0 : 0.3) // Efek berkedip
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                                startAnimating = true
                            }
                        }

                }
                if (self.controller.isLoggedIn == false){
                    LoginView()
                } else {
                    HomeView()
                }
            }
            
            
        }
        .alert("Warning", isPresented:$controller.showAlert) {
            Button("Oke", role: .cancel) {}
            
        } message: {
            Text(self.controller.responseMessage).font(.title).bold()
        }
    }
}

#Preview {
    ContentView().environmentObject(Controller())
}
