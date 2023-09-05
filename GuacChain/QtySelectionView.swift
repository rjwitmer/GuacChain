//
//  QtySelectionView.swift
//  GuacChain
//
//  Created by Bob Witmer on 2023-09-05.
//

import SwiftUI

struct QtySelectionView: View {
    @Binding var qty: Int
    var menuText: String
    
    var body: some View {
        HStack {
            Text("\(qty)")
                .font(.system(size: 48))
                .fontWeight(.heavy)
                .frame(width: 70)
            VStack (alignment: .leading, spacing: 0) {
                Text(menuText)
                    .font(.title2)
                Stepper("", value: $qty, in: 0...99)
                    .labelsHidden()
                
            }
        }
    }
}

struct QtySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QtySelectionView(qty: .constant(0), menuText: "The Satoshi 'Taco' moto")
    }
}
