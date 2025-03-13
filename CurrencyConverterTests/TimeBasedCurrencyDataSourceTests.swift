//
//  TimeBasedCurrencyDataSourceTests.swift
//  CurrencyConverterTests
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Foundation
import XCTest

@testable import CurrencyConverter

class TimeBasedCurrencyDataSourceTests: XCTestCase {
    
    var dataSource: TimeBasedCurrencyDataSource!
    var mockCoreDataCurrencyDataSource: MockCoreDataCurrencyDataSource!
    var mockAPICurrencyDataSource: MockCurrencyProvider!
    var mockDataRefreshManager: MockDataRefreshManager!
    
    override func setUp() {
        super.setUp()
        
        mockCoreDataCurrencyDataSource = MockCoreDataCurrencyDataSource()
        mockAPICurrencyDataSource = MockCurrencyProvider()
        mockDataRefreshManager = MockDataRefreshManager()
        
        dataSource = TimeBasedCurrencyDataSource(
            coreDataCurrencyDataSource: mockCoreDataCurrencyDataSource,
            apiCurrencyDataSource: mockAPICurrencyDataSource,
            dataRefreshManager: mockDataRefreshManager
        )
    }
    
    override func tearDown() {
        dataSource = nil
        mockCoreDataCurrencyDataSource = nil
        mockAPICurrencyDataSource = nil
        mockDataRefreshManager = nil
        super.tearDown()
    }
    
    func testFetchDataFromAPI() async throws {
        // Given
        let mockCurrencyData = CurrencyData(currencies: [Currency(currencyCode: "USD", currencyCountry: "USA")],
                                            rates: [Rate(currencyCode: "USD", price: 1.0)])
        mockAPICurrencyDataSource.mockCurrencyData = mockCurrencyData
        mockDataRefreshManager.shouldRefresh = true
        
        // When
        let result = try await dataSource.fetchData()
        
        // Then
        XCTAssertEqual(result.currencies.count, 1)
        XCTAssertEqual(result.rates.count, 1)
        XCTAssertEqual(result.currencies.first?.currencyCode, "USD")
    }
    
    func testFetchDataFromCoreData() async throws {
        // Given
        let mockCurrencyData = CurrencyData(currencies: [Currency(currencyCode: "USD", currencyCountry: "USA")],
                                            rates: [Rate(currencyCode: "USD", price: 1.0)])
        mockCoreDataCurrencyDataSource.mockCurrencyData = mockCurrencyData
        mockDataRefreshManager.shouldRefresh = false
        
        // When
        let result = try await dataSource.fetchData()
        
        // Then
        XCTAssertEqual(result.currencies.count, 1)
        XCTAssertEqual(result.rates.count, 1)
        XCTAssertEqual(result.currencies.first?.currencyCode, "USD")
    }
}
