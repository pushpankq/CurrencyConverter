//
//  CoreDataCurrencyDataSource.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import Foundation
import CoreData

enum CoreDataFetchError: Error {
    case fetchFailed(String)
    case emptyResults
}

final class CoreDataCurrencyDataSource {
    
    private let persistentContainer: NSPersistentContainer
    
    init(
        persistentContainer: NSPersistentContainer = CoreDataManager.shared.persistentContainer
    ) {
        self.persistentContainer = persistentContainer
    }
    
    func fetchCurrencyCodes() async throws -> [Currency] {
        let context = persistentContainer.viewContext
        return try await context.perform {
            let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
            do {
                let currencies = try context.fetch(fetchRequest)
                if currencies.isEmpty {
                    throw CoreDataFetchError.emptyResults
                }
                return currencies.map {
                    Currency(currencyCode: $0.currencyCode ?? "", currencyCountry: $0.currencyCountry ?? "")
                }
            } catch {
                throw CoreDataFetchError.fetchFailed("Failed to fetch currencies from Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchConversionRates() async throws -> [Rate] {
        let context = persistentContainer.viewContext
        return try await context.perform {
            let fetchRequest: NSFetchRequest<CDRate> = CDRate.fetchRequest()
            
            do {
                let rates = try context.fetch(fetchRequest)
                if rates.isEmpty {
                    throw CoreDataFetchError.emptyResults
                }
                return rates.map {
                    Rate(currencyCode: $0.currencyCode ?? "", price: $0.price)
                }
            } catch {
                throw CoreDataFetchError.fetchFailed("Failed to fetch rates from Core Data: \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataCurrencyDataSource {
    
    func saveCurrenciesToCoreData(_ currencies: [Currency]) async throws {
        let context = persistentContainer.viewContext

        try await context.perform { [weak self] in
            guard let self = self else { return }
            
            self.clearOldCurrencies()
            
            for currency in currencies {
                let entity = CDCurrency(context: context)
                entity.currencyCode = currency.currencyCode
                entity.currencyCountry = currency.currencyCountry
            }
            do {
                try context.save()
            } catch {
                throw CoreDataFetchError.fetchFailed("Failed to save currencies to Core Data: \(error.localizedDescription)")
            }
        }
    }

    func saveRatesToCoreData(_ rates: [Rate]) async throws {
        let context = persistentContainer.viewContext

        try await context.perform { [weak self] in
            guard let self = self else { return }
            
            self.clearOldRates()
            
            for rate in rates {
                let entity = CDRate(context: context)
                entity.currencyCode = rate.currencyCode
                entity.price = rate.price
            }
            do {
                try context.save()
            } catch {
                throw CoreDataFetchError.fetchFailed("Failed to save rates to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func clearOldCurrencies() {
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCurrency.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete old currencies: \(error.localizedDescription)")
        }
    }

    func clearOldRates() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDRate.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete old rates: \(error.localizedDescription)")
        }
    }
}

extension CoreDataCurrencyDataSource: CurrencyProvider  {
    func fetchData() async throws -> CurrencyData {
        async let currencies = fetchCurrencyCodes()
        async let rates = fetchConversionRates()
        return try await CurrencyData(currencies: currencies, rates: rates)
    }
}

extension CoreDataCurrencyDataSource : CurryencyRecorder {
    func recordData(_ data: CurrencyData) {
        Task {
            try await saveCurrenciesToCoreData(data.currencies)
            try await saveRatesToCoreData(data.rates)
        }
    }
}
