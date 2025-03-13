//
//  CurrencySelectionView.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import SwiftUI

struct CurrencySelectionView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Picker(String(localized: "Select currency"), selection: $viewModel.selectedCurrency) {
                ForEach(viewModel.currencyCodes) { currency in
                    Text(currency.currencyCode)
                        .tag(currency)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 6.0)
                    .stroke(Color.gray, lineWidth: 1.0)
            )
            .padding(.horizontal)
        }
    }
}
