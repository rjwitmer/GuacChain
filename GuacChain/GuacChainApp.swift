//
//  GuacChainApp.swift
//  GuacChain
//
//  Created by Bob Witmer on 2023-09-05.
//

import SwiftUI

@main
struct GuacChainApp: App {
    @StateObject var currencyVM = CurrencyViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(currencyVM)
        }
    }
}
