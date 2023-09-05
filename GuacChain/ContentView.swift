//
//  ContentView.swift
//  GuacChain
//
//  Created by Bob Witmer on 2023-09-05.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var currencyVM: CurrencyViewModel
    
    enum Currency: String, CaseIterable {
        case usd = "$ USD"
        case gbp = "£ GPB"
        case eur = "€ EUR"
    }
    
    enum Price: Double, CaseIterable {
        case taco = 5.00
        case burrito = 8.00
        case chips = 3.00
        case horchata = 2.00
    }
    
    @State private var tacoQty = 0
    @State private var burritoQty = 0
    @State private var chipsQty = 0
    @State private var horchataQty = 0
    @State private var currencySelection: Currency = .usd
    @State private var symbol = "$"
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Text("Guac")
                    .foregroundColor(.green)
                Text("Chain")
                    .foregroundColor(.red)
            }
            .font(.custom("Marker Felt", size: 48))
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Text("The World's Tastiest Tacos - But We Only Accept Bitcoin")
                .font(.custom("Papyrus", size: 20))
                .multilineTextAlignment(.center)
            
            Text("🌮")
                .font(.system(size: 80))
                .multilineTextAlignment(.center)
            
            VStack (alignment: .leading) {
                QtySelectionView(qty: $tacoQty, menuText: "The Satoshi 'Taco' moto")
                QtySelectionView(qty: $burritoQty, menuText: "Bitcoin Burrito")
                QtySelectionView(qty: $chipsQty, menuText: "CryptoChips")
                QtySelectionView(qty: $horchataQty, menuText: "'No Bubble' Horchata")
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Spacer()
            
            Picker("Currency:", selection: $currencySelection) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currencySelection) { _ in
                symbol = String(currencySelection.rawValue.prefix(1))
            }
            
            HStack (alignment: .top) {
                Text("Total:")
                    .font(.title)
                
                VStack (alignment: .leading) {
                    Text("฿ \(calcBillInBitcoin())")
                    Text("\(symbol) \(String(format: "%.2f", calcBillInCurrency()))")
                }
            }

        }
        .padding()
        .task {
            await currencyVM.getData()
        }
    }
    
    func calcBillInBitcoin() -> Double {
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        return usdTotal / currencyVM.usdPerBTC
    }
    
    func calcBillInCurrency() -> Double {
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        
        switch currencySelection {
        case .usd:
            return usdTotal
        case .gbp:
            return usdTotal * (currencyVM.gbpPerBTC / currencyVM.usdPerBTC)
        case .eur:
            return usdTotal * (currencyVM.eurPerBTC / currencyVM.usdPerBTC)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
