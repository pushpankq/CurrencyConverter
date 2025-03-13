//
//  CurrencyServiceManager.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 28/01/25.
//

import Foundation
import CoreData

protocol CurrencyProvider {
    func fetchData() async throws -> CurrencyData
}

protocol CurryencyRecorder {
    func recordData(_ data: CurrencyData)
}

typealias CurryencyManager = CurryencyRecorder & CurrencyProvider

final class TimeBasedCurrencyDataSource: CurrencyProvider {
    
    private let coreDataCurrencyDataSource: CurryencyManager
    private let apiCurrencyDataSource: CurrencyProvider
    private let dataRefreshManager: DataRefreshManaging

    init(
        coreDataCurrencyDataSource: CurryencyManager = CoreDataCurrencyDataSource(),
        apiCurrencyDataSource: CurrencyProvider = APICurrencyDataSource(),
        dataRefreshManager: DataRefreshManaging = DataRefreshManager.instance
    ) {
        self.coreDataCurrencyDataSource = coreDataCurrencyDataSource
        self.apiCurrencyDataSource = apiCurrencyDataSource
        self.dataRefreshManager = dataRefreshManager
    }
    
    func fetchData() async throws -> CurrencyData {
        if dataRefreshManager.checkRefreshStatus() {
            
            let currencyData = try await apiCurrencyDataSource.fetchData()
            coreDataCurrencyDataSource.recordData(currencyData)
            dataRefreshManager.saveRefreshTime(Date())
            return currencyData
        } else {
            let currencyData = try await coreDataCurrencyDataSource.fetchData()
            return currencyData
        }
    }
}
