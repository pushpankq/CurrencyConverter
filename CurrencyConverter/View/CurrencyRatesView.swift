//
//  CurrencyRatesView.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import SwiftUI

struct CurrencyRatesView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    let columns: [GridItem]
    
    var body: some View {
        if !viewModel.rates.isEmpty {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.rates) { currency in
                    VStack {
                        Text(currency.price.formattedPrice())
                            .font(.caption2)
                        Text(currency.currencyCode)
                            .font(.footnote)
                    }
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 6.0)
                            .stroke(Color.gray, lineWidth: 1.0)
                    )
                }
            }
            .padding()
        } else {
            Text(String(localized: "No data available"))
        }
    }
}
