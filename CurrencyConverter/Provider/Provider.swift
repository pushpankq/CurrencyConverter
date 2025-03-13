//
//  Provider.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 29/01/25.
//

import Foundation

enum Provider {
    static var currencyProvider: CurrencyProvider {
        TimeBasedCurrencyDataSource(
            coreDataCurrencyDataSource: CoreDataCurrencyDataSource(),
            apiCurrencyDataSource: APICurrencyDataSource(),
            dataRefreshManager: DataRefreshManager.instance
        )
    }
}
