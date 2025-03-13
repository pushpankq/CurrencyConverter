//
//  MockCoreDataCurrencyDataSource.swift
//  CurrencyConverterTests
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Foundation
@testable import CurrencyConverter

class MockCoreDataCurrencyDataSource: CurrencyProvider {
    
    var mockCurrencyData: CurrencyData?
    
    func fetchData() async throws -> CurrencyData {
        guard let data = mockCurrencyData else {
            throw NSError(domain: "MockCoreDataError", code: 0, userInfo: nil)
        }
        return data
    }
}

extension MockCoreDataCurrencyDataSource: CurryencyRecorder {
    func recordData(_ data: CurrencyData) {
        mockCurrencyData = data
    }
}
