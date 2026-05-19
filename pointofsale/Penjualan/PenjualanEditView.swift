import SwiftUI
import Foundation

struct PenjualanEditView: View {
    @EnvironmentObject var controller: Controller
    @Environment(\.dismiss) private var dismiss
    
    @State private var cartItems: [Log] = []
    
    @State private var showTotalPopup: Bool = false
    @State private var selectedItemForEdit: Log? = nil
    @State private var navigateToPembayaran: Bool = false
    
    @State private var itemYangAkanDiedit: Log? = nil
     
    var totalQty: Int { cartItems.map { $0.Qty }.reduce(0, +) }
    var totalSubtotal: Double { cartItems.map { $0.Subtotal }.reduce(0, +) }
    var totalDiscount: Double { cartItems.map { $0.Discamount }.reduce(0, +) }
    var tax: Double { cartItems.map { $0.Taxamount }.reduce(0, +) }
    var finalTotal: Double { cartItems.map { $0.Total }.reduce(0, +) }
    
    var body: some View {
        ZStack {
            if let itemAktif = itemYangAkanDiedit {
                            PenjualanEditItemView(item: itemAktif) {
                                itemYangAkanDiedit = nil
                            } onSimpan: { kuanstitasBaru, diskonBaru, note in
                                updateItemInCart(id: itemAktif.Id, newQty: kuanstitasBaru, newDisc: diskonBaru, newNote: note)
                                itemYangAkanDiedit = nil
                            }
            } else {
                VStack(spacing: 0) {
                    // NAVBAR
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Keranjang")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "arrow.left").foregroundColor(.clear)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                    
                    // LIST ITEM BELANJA
                    List {
                        ForEach(cartItems, id: \.Id) { item in
                            let itemSubtotalText = String(format: "%.0f", item.Subtotal)
                            let itemDiscText = String(format: "%.0f", item.Discamount)
                            
                            HStack(spacing: 16) {
                                Text("\(item.Qty)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Color.black)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.Name)
                                        .font(.system(size: 16, weight: .semibold))
                                    HStack(spacing: 4) {
                                        Text("Disc: \(itemDiscText)")
                                        Text("Subtotal: \(itemSubtotalText)")
                                    }
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                }
                                Spacer()
                                HStack(spacing: 20) {
                                    Button(action: { selectedItemForEdit = item }) {
                                        Image(systemName: "pencil").foregroundColor(.gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: { hapusItem(item) }) {
                                        Image(systemName: "trash.fill").foregroundColor(.gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                                            itemYangAkanDiedit = item
                                                        }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    // TOMBOL NAVIGASI BAWAH
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: 12) {
                            Button(action: { dismiss() }) {
                                Text("HOME")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                                    .cornerRadius(24)
                            }
                            
                            Button(action: { cartItems.removeAll() }) {
                                Text("CLEAR")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                                    .cornerRadius(24)
                            }
                            
                            Button(action: { showTotalPopup = true }) {
                                Text("TOTAL")
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
            }
        }
        .onAppear() {
            cartItems = self.controller.log
        }
          
        .sheet(isPresented: $showTotalPopup) {
            PopupTotalView(
                qty: totalQty,
                subtotal: totalSubtotal,
                discount: totalDiscount,
                tax: tax,
                total: finalTotal,
                onTutup: { showTotalPopup = false },
                onBayar: {
                    showTotalPopup = false
                    navigateToPembayaran = true
                }
            )
            .presentationDetents([.medium, .fraction(0.55)])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $navigateToPembayaran) {
            PembayaranView(totalBill : finalTotal)
        }
        
    }
    
    private func updateItem(id: String, newQty: Int, newDisc: Double) {
        if let index = cartItems.firstIndex(where: { $0.Id == id }) {
            cartItems[index].Qty = newQty
            cartItems[index].Subtotal = cartItems[index].Price * Double(newQty)
            cartItems[index].Discamount = newDisc
            cartItems[index].Total = cartItems[index].Subtotal - newDisc + cartItems[index].Taxamount
        }
    }
    
    private func hapusItem(_ item: Log) {
        cartItems.removeAll(where: { $0.Id == item.Id })
    }
    
    private func updateItemInCart(id: String, newQty: Int, newDisc: Double, newNote : String) {
            if let index = cartItems.firstIndex(where: { $0.Id == id }) {
                cartItems[index].Qty = newQty
                cartItems[index].Subtotal = cartItems[index].Price * Double(newQty)
                cartItems[index].Discamount = newDisc
                cartItems[index].Note = newNote
                
                let tempSubtotalAfterDisc = max(0, cartItems[index].Subtotal - newDisc)
                cartItems[index].Taxamount = tempSubtotalAfterDisc * (cartItems[index].Taxpercent / 100.0)
                cartItems[index].Total = tempSubtotalAfterDisc + cartItems[index].Taxamount
            }
        }
}

struct PopupTotalView: View {
    let qty: Int
    let subtotal: Double
    let discount: Double
    let tax: Double
    let total: Double
    
    var onTutup: () -> Void
    var onBayar: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            VStack(spacing: 20) {
                PopupRow(icon: "arrow.right", title: "Jumlah Barang", value: "\(qty)", isBoldValue: true)
                 
                PopupRow(icon: "arrow.right", title: "Subtotal", value: "Rp. \(Int(subtotal).formattedWithSeparator())")
                 
                PopupRow(icon: "arrow.right", title: "Discount", value: "Rp. \(Int(discount).formattedWithSeparator())")
                 
                PopupRow(icon: "arrow.right", title: "Tax", value: "Rp. \(Int(tax).formattedWithSeparator())")
                 
                PopupRow(icon: "arrow.right", title: "Total", value: "Rp. \(Int(total).formattedWithSeparator())", isBoldValue: true)
            }
            .padding(.horizontal, 24)
            
            Divider()
             
            HStack(spacing: 16) {
                Button(action: onTutup) {
                    Text("TUTUP")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                        .cornerRadius(24)
                }
                
                Button(action: onBayar) {
                    Text("BAYAR")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.12, green: 0.53, blue: 0.93))
                        .cornerRadius(24)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .background(Color.white)
    }
    
     
    
}

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension Double {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
 
struct PopupRow: View {
    let icon: String
    let title: String
    let value: String
    var isBoldValue: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black.opacity(0.7))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: isBoldValue ? .bold : .medium))
                .foregroundColor(.black)
        }
    }
}
