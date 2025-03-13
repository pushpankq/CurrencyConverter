//
//  MockDataRefreshManager.swift
//  CurrencyConverterTests
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Foundation
@testable import CurrencyConverter


class MockDataRefreshManager: DataRefreshManaging {
    
    var shouldRefresh: Bool = false
    
    func getLastRefreshTime() -> Date? {
        return Date()
    }
    
    func saveRefreshTime(_ time: Date) {
        // Do nothing
    }
    
    func checkRefreshStatus() -> Bool {
        return shouldRefresh
    }
}
