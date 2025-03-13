//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 25/01/25.
//

import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let currencyCode: String
    let currencyCountry: String
}

extension Currency {
    init() {
        self.currencyCode = "USD"
        self.currencyCountry = "USA"
    }
}
