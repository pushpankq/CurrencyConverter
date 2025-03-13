//
//  CurrencyConversionResponse.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 25/01/25.
//

import Foundation

struct CurrencyConversionResponse: Codable {
    let base: String
    let rates: [String: Double]
}

struct Rate: Identifiable, Hashable {
    let id = UUID()
    let currencyCode: String
    var price: Double
}

extension Double {
    func formattedPrice() -> String {
        String(format: "%.2f", self)
    }
}
