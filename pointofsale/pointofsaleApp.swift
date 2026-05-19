//
//  pointofsaleApp.swift
//  pointofsale
//
//  Created by user on 05/05/26.
//

import SwiftUI
import SwiftData

@main
struct contohApp: App {
    @StateObject var controller = Controller()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(controller)
        }
        .modelContainer(for: [AppConfig.self, Category.self, Product.self, Discount.self, Tender.self, Salestype.self, HeaderFooter.self, VoidReason.self, ItemAdd.self,  ItemSize.self,  Size.self,  SalesMan.self,  Calender.self,  Setting.self])
    }
}
