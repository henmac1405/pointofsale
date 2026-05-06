//
//  pointofsaleApp.swift
//  pointofsale
//
//  Created by user on 05/05/26.
//

import SwiftUI

@main
struct contohApp: App {
    @StateObject var controller = Controller()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(controller)
        }
    }
}
