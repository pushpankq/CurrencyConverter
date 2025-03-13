//
//  APICurrencyDataSource.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import Foundation

class APICurrencyDataSource {
    
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchCurrencyCodes() async throws -> [Currency] {
        do {
            let currencies: [String: String] = try await networkManager.request(.currencies)
            let currencyCodes = currencies.map {
                Currency(currencyCode: $0, currencyCountry: $1)
            }
            return currencyCodes
        } catch {
            throw mapError(error)
        }
    }
    
    func fetchConversionRates() async throws -> [Rate] {
        do {
            let response: CurrencyConversionResponse = try await networkManager.request(.rates)
            let rates = response.rates.map {
                Rate(currencyCode: $0, price: $1)
            }
            return rates
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return .networkError(error)
        }
    }
}

extension APICurrencyDataSource: CurrencyProvider {
    func fetchData() async throws -> CurrencyData {
        async let currencies = fetchCurrencyCodes()
        async let rates = fetchConversionRates()
        return try await CurrencyData(currencies: currencies, rates: rates)
    }
}
