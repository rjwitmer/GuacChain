//
//  CurrencyViewModel.swift
//  GuacChain
//
//  Created by Bob Witmer on 2023-09-05.
//

import Foundation

@MainActor
class CurrencyViewModel: ObservableObject {
 
    private struct Returned: Codable {
        var bpi: BPI
    }
    struct BPI: Codable {
        var USD: USD
        var GBP: GBP
        var EUR: EUR
    }
    
    struct USD: Codable {
        var code: String
        var symbol: String
        var rate: String
        var description: String
        var rate_float: Double
    }
    struct GBP: Codable {
        var code: String
        var symbol: String
        var rate: String
        var description: String
        var rate_float: Double
    }
    struct EUR: Codable {
        var code: String
        var symbol: String
        var rate: String
        var description: String
        var rate_float: Double
    }
    

    
    let urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    @Published var usdPerBTC: Double = 0.0
    @Published var gbpPerBTC: Double = 0.0
    @Published var eurPerBTC: Double = 0.0
    @Published var isLoading = false
    
    
    func getData() async {
        print("🕸️ We are accessing the URL \(urlString)")
        isLoading = true
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from:  url)
            
            // Try to decode JSON data into our out data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            usdPerBTC = returned.bpi.USD.rate_float
            gbpPerBTC = returned.bpi.GBP.rate_float
            eurPerBTC = returned.bpi.EUR.rate_float
            print("One bitcoin is currently worth: $\(usdPerBTC), £\(gbpPerBTC), €\(eurPerBTC)")
            isLoading = false
        } catch {
            print("😡 ERROR: Could not use URL at \(urlString) to get data and response --> \(error.localizedDescription)")
            isLoading = false
        }
    }
    
}
