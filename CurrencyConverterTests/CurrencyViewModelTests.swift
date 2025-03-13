//
//  CurrencyViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Combine
import XCTest

@testable import CurrencyConverter

@MainActor
class CurrencyViewModelTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    var mockCurrencyProvider: MockCurrencyProvider!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        mockCurrencyProvider = MockCurrencyProvider()
        viewModel = CurrencyViewModel(provider: mockCurrencyProvider)
    }
    
    override func tearDown() {
        cancellables = []
        viewModel = nil
        mockCurrencyProvider = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() async {
        // Given
        let mockCurrencyData = CurrencyData(currencies: [Currency(currencyCode: "USD", currencyCountry: "United States")],
                                            rates: [Rate(currencyCode: "USD", price: 1.0)])
        mockCurrencyProvider.mockCurrencyData = mockCurrencyData
        
        // When
        await viewModel.fetchData()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.currencyCodes.count, 1)
        XCTAssertEqual(viewModel.rates.count, 1)
        XCTAssertEqual(viewModel.selectedCurrency.currencyCode, "USD")
    }
    
    func testFetchDataFailure() async {
        // Given
        mockCurrencyProvider.shouldFail = true
        
        // When
        await viewModel.fetchData()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.currencyCodes.count, 0)
        XCTAssertEqual(viewModel.rates.count, 0)
    }
    
    func testUpdatePrice() {
        // Given
        let rate = Rate(currencyCode: "USD", price: 1.2)
        viewModel.originalRates = [rate]
        print(viewModel.originalRates)
        
        viewModel.selectedCurrency = Currency(currencyCode: "USD", currencyCountry: "United States")
        
        // When
        viewModel.inputAmount = "10"
        
        viewModel.updatePrice()
        
        // Then
        XCTAssertEqual(viewModel.rates.first?.price, 10.0)
    }
    
    func testUpdatePriceWithInvalidInput() {
        // Given
        let rate = Rate(currencyCode: "USD", price: 1.2)
        viewModel.originalRates = [rate]
        viewModel.selectedCurrency = Currency(currencyCode: "USD", currencyCountry: "United States")
        
        // When: Set an invalid input amount that can't be converted to Double
        viewModel.inputAmount = ""
        
        viewModel.updatePrice()
        
        // Then
        XCTAssertTrue(viewModel.rates.isEmpty, "Rates should be cleared when the input is invalid.")
    }

}
