//
//  MockCurrencyProvider.swift
//  CurrencyConverterTests
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Foundation
@testable import CurrencyConverter

class MockCurrencyProvider: CurrencyProvider {
    
    var mockCurrencyData: CurrencyData?
    var shouldFail: Bool = false
    
    func fetchData() async throws -> CurrencyData {
        if shouldFail {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        
        guard let currencyData = mockCurrencyData else {
            throw NSError(domain: "MockError", code: 2, userInfo: nil)
        }
        return currencyData
    }
}
