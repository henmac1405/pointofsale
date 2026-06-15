import SwiftUI

struct CustomerView: View {
    @EnvironmentObject var controller : Controller
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
     
    
    @State private var noHP: String = ""
    @State private var name: String = ""
    @State private var umur: String = ""
    @State private var gender: String = "Male"
    @State private var email: String = ""
    @State private var address: String = ""
    
    let genderOptions = ["Male", "Female"]
    
    var completion: (String, String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Spacer()
                Text("Customer Profile")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            ZStack(alignment: .leading) {
                                 
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                                    .frame(height: 55)
                                
                                 
                                Text(" No HP ")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .offset(x: 12, y: -27)
                                    .font(.system(size: 16, weight: .bold))
                                
                                TextField("", text: $noHP)
                                    .padding(.horizontal, 15)
                                    .font(.system(size: 16, weight: .bold))
                                    .keyboardType(.numberPad)
                                    .onChange(of: noHP) { oldValue, newValue in
                                        if newValue.count >= 20 {
                                            noHP = String(newValue.prefix(20))
                                        }
                                    }
                            }
                            Button(action:{
                                self.controller.customerfindbynohp(noHP: noHP) { json in
                                    DispatchQueue.main.async {
                                        if let data = json {
                                            name = ""
                                            address = ""
                                            gender = ""
                                            email = ""
                                            umur = ""
                                            print("state : \(data["state"])")
                                            if data["state"] == true {
                                                if (data["data"].count > 0 ){
                                                    for i in 0..<data["data"].count {
                                                        print(i)
                                                        print(data["data"][i]["name"])
                                                        self.name = "\(data["data"][i]["rekanan_name"])"
                                                        self.umur = "\(data["data"][i]["rekanan_age"])"
                                                        self.gender = "\(data["data"][i]["rekanan_picgender"])"
                                                        self.address = "\(data["data"][i]["rekanan_address"])"
                                                        self.email = "\(data["data"][i]["rekanan_email"])"
                                                    }
                                                }
                                            } else{
                                                
                                                self.controller.showAlert = true
                                                self.controller.responseMessage = "Data Customer tidak ditemukan"
                                            }
                                        } else {
                                            self.controller.showAlert = true
                                            self.controller.responseMessage = "Gagal Load Data Customer"
                                            
                                        }
                                    }
                                }
                            }){
                                Image(systemName: "magnifyingglass")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                            }
                        }
                        Text("\(noHP.count)/20")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Name
                    VStack(alignment: .trailing, spacing: 4) {
                        ZStack(alignment: .leading) {
                             
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 55)
                            
                             
                            Text(" Name ")
                                .font(.caption)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .offset(x: 12, y: -27)
                                .font(.system(size: 16, weight: .bold))
                            
                            TextField("", text: $name)
                                .padding(.horizontal, 15)
                                .font(.system(size: 16, weight: .bold))
                                .onChange(of: name) { oldValue, newValue in
                                    if newValue.count >= 50 {
                                        name = String(newValue.prefix(50))
                                    }
                                }
                        }
                        Text("\(name.count)/50")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Umur
                    VStack(alignment: .trailing, spacing: 4) {
                        ZStack(alignment: .leading) {
                             
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 55)
                            
                             
                            Text(" Umur ")
                                .font(.caption)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .offset(x: 12, y: -27)
                                .font(.system(size: 16, weight: .bold))
                            
                            TextField("", text: $umur)
                                .padding(.horizontal, 15)
                                .font(.system(size: 16, weight: .bold))
                                .keyboardType(.numberPad)
                                .onChange(of: umur) { oldValue, newValue in
                                    if newValue.count >= 2 {
                                        umur = String(newValue.prefix(2))
                                    }
                                }
                        }
                        Text("\(umur.count)/2")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Gender Picker
                    VStack(alignment: .leading, spacing: -10) {
                        Text(" Gender ")
                            .font(.caption)
                            .background(Color.white)
                            .padding(.leading, 12)
                            .zIndex(1)
                        
                        HStack {
                            Picker("Gender", selection: $gender) {
                                ForEach(genderOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.black)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    // Email
                    VStack(alignment: .trailing, spacing: 4) {
                        ZStack(alignment: .leading) {
                             
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 55)
                            
                             
                            Text(" Email ")
                                .font(.caption)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .offset(x: 12, y: -27)
                                .font(.system(size: 16, weight: .bold))
                            
                            TextField("", text: $email)
                                .padding(.horizontal, 15)
                                .font(.system(size: 16, weight: .bold))
                                .onChange(of: email) { oldValue, newValue in
                                    if newValue.count >= 50 {
                                        email = String(newValue.prefix(50))
                                    }
                                }
                        }
                        Text("\(email.count)/50")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Address
                    VStack(alignment: .trailing, spacing: 4) {
                        ZStack(alignment: .leading) {
                             
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 100)
                            
                             
                            Text(" Address ")
                                .font(.caption)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .offset(x: 12, y: -27)
                                .font(.system(size: 16, weight: .bold))
                            
                            TextField("", text: $address)
                                .padding(.horizontal, 15)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
                .padding(20)
            }
            
            Divider()
            
            // MARK: - Action Buttons
            HStack(spacing: 12) {
                Button(action: { 
                     dismiss()
                }) {
                    Text("TUTUP")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                Button(action: {
                    self.controller.customer.removeAll()
                    noHP = ""
                    name = ""
                    address = ""
                    gender = ""
                    email = ""
                    umur = ""
                }) {
                    Text("HAPUS")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                Button(action: {
                    if noHP.count <= 5 {
                        self.controller.showAlert = true
                        self.controller.responseMessage = "No HP minimal 6 angka"
                    } else if (name == "" || email == "" || noHP == ""){
                        self.controller.showAlert = true
                        self.controller.responseMessage = "No HP, Nama dan Email tidak boleh kosong"
                    } else {
                        self.controller.customer.removeAll()
                        self.controller.customer.append(Customer(cust_id: noHP, cust_name: name, cust_address: address, cust_hp: noHP, cust_telp: noHP, cust_email: email, cust_age: umur, cust_gender: gender, member_id: ""))
                        self.controller.updateItemAdd_Status(name: "CUSTOMER", status: 1)
                        completion(noHP, name)
                        dismiss()
                    }
                }) {
                    Text("SIMPAN")
                        .font(.subheadline)
                        .fontWeight(.bold)
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
 
 

//#Preview {
//    CustomerView(path : "")
//}
