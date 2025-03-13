//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 25/01/25.
//

import Foundation
import Combine
import CoreData

@MainActor
final class CurrencyViewModel: ObservableObject {

    @Published private(set) var currencyCodes: [Currency] = []
    @Published var rates: [Rate] = []
    @Published var isLoading: Bool = false
    @Published var inputAmount: String = "1"
    @Published var conversionButtonOpacity: Double = 0.0
    @Published var selectedCurrency: Currency = Currency() {
        didSet {
            updatePrice()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    var originalRates: [Rate] = []
    
    private let provider: CurrencyProvider
    
    init(provider: CurrencyProvider = Provider.currencyProvider) {
        
        self.provider = provider
        
        $inputAmount
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updatePrice()
            }
            .store(in: &cancellables)
    }
    
    func fetchData() async {
        isLoading = true
                
        do {
            let data = try await provider.fetchData()
            
            let sortedCurrencyCodes = data.currencies.sorted { $0.currencyCode < $1.currencyCode }
            let sortedRates = data.rates.sorted { $0.currencyCode < $1.currencyCode }
            
            self.selectedCurrency = sortedCurrencyCodes.first ?? Currency()
            self.rates = sortedRates
            self.currencyCodes = sortedCurrencyCodes
            self.originalRates = sortedRates
            
            isLoading = false
            
            // we are getting all currencies from USD
            // we are converting currency by default selected currency
            updatePrice()
        } catch  {
            debugPrint("Failed to fetch data: \(error)")
            self.currencyCodes = []
            self.rates = []
            isLoading = false
        }
    }
}

extension CurrencyViewModel {
    func updatePrice() {
        guard let enteredAmount = Double(inputAmount) else {
            rates = []
            return
        }
        guard let price = originalRates.first(where: { $0.currencyCode == selectedCurrency.currencyCode })?.price else {
            return
        }
        rates = originalRates.map { rate in
            var updatedRate = rate
            updatedRate.price = (updatedRate.price / price) * enteredAmount
            return updatedRate
        }
    }
}
