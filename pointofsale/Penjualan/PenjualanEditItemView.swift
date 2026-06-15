import SwiftUI

struct PenjualanEditItemView: View {
    let item: Log
    var onBatal: () -> Void
    var onSimpan: (Int, Double, String) -> Void
     
    @State private var qty: Int = 1
    @State private var discountAmount: Double = 0
    @State private var catatan: String = ""
     
    init(item: Log, onBatal: @escaping () -> Void, onSimpan: @escaping (Int, Double, String) -> Void) {
        self.item = item
        self.onBatal = onBatal
        self.onSimpan = onSimpan
        _qty = State(initialValue: item.qty)
        _discountAmount = State(initialValue: item.discamount)
        _catatan = State(initialValue: item.note)
    }
     
    private var subtotal: Double { item.price * Double(qty) }
    private var subtotalAfterDisc: Double { max(0, subtotal - discountAmount) }
    private var taxValue: Double { subtotalAfterDisc * (item.taxpercent / 100.0) }
    private var total: Double { subtotalAfterDisc + taxValue }
   
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBatal) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(item.name)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
             
            ScrollView {
                VStack(spacing: 24) {
                    CustomOutlineField(title: "Harga", value: item.price.formattedWithSeparator())
                     
                    HStack(spacing: 12) {
                        Button(action: { if qty > 1 { qty -= 1 } }) {
                            Text("-")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 46)
                                .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                                .cornerRadius(24)
                        }
                        
                        Text("\(qty)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(Color(red: 0.12, green: 0.53, blue: 0.93).opacity(0.2))
                            .cornerRadius(24)
                        
                        Button(action: { qty += 1 }) {
                            Text("+")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 46)
                                .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                                .cornerRadius(24)
                        }
                    }
                    
                     
                    CustomOutlineField(title: "Subtotal", value: subtotal.formattedWithSeparator())
                    
                     
                    CustomOutlineField(
                        title: discountAmount > 0 ? "Discount" : "No Discount",
                        value: discountAmount.formattedWithSeparator()
                    )
                    
                    
                    CustomOutlineField(title: "Subtotal after Disc", value: subtotalAfterDisc.formattedWithSeparator())
                    
                     
                    CustomOutlineField(title: "Tax \(Int(item.taxpercent))%", value: taxValue.formattedWithSeparator())
                    
                     
                    CustomOutlineField(title: "Total", value: total.formattedWithSeparator())
                    
                     
                    CustomOutlineField(title: "Catatan", value: "", textBinding: $catatan)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
             
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    Button(action: onBatal) {
                        Text("BATAL")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                            .cornerRadius(24)
                    }
                    
                    Button(action: { 
                    }) {
                        Text("DISKON")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                            .cornerRadius(24)
                    }
                    
                    Button(action: { onSimpan(qty, discountAmount, catatan) }) {
                        Text("SIMPAN")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                            .cornerRadius(24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
    }
}
 
  
struct CustomOutlineField: View {
    let title: String
    let value: String
     
    var textBinding: Binding<String>? = nil
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                .frame(height: 64)
             
            if title == "Catatan", let binding = textBinding {
                TextField("Tulis catatan di sini...", text: binding)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            } else {
                Text(value)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .padding(.top, 22)
            }
             
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal, 6)
                .background(Color(uiColor: .systemBackground))  
                .offset(x: 12, y: -8)
        }
    }
}

