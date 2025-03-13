//
//  DataRefreshManager.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import Foundation

protocol DataRefreshManaging {
    func getLastRefreshTime() -> Date?
    func saveRefreshTime(_ time: Date)
    func checkRefreshStatus() -> Bool
}

final class DataRefreshManager: DataRefreshManaging {
    
    private let refreshTime = 30
    private let queue = DispatchQueue(label: "com.currencyconverter.dataRefreshQueue", attributes: .concurrent)
    
    static let instance = DataRefreshManager()

    private init() {}

    func getLastRefreshTime() -> Date? {
        return queue.sync {
            return UserDefaults.standard.object(forKey: CurrencyConverter.UserDefaultsKeys.lastRefereshTime) as? Date
        }
    }

    func saveRefreshTime(_ time: Date) {
        queue.async {
            UserDefaults.standard.set(time, forKey: CurrencyConverter.UserDefaultsKeys.lastRefereshTime)
        }
    }

    func checkRefreshStatus() -> Bool {
        return queue.sync {
            let nowDate = Date()
            
            if let lastDate = getLastRefreshTime() {
                let currentCalendar = Calendar.current
                let start = currentCalendar.ordinality(of: .minute, in: .era, for: lastDate) ?? 0
                let end = currentCalendar.ordinality(of: .minute, in: .era, for: nowDate) ?? 0
                return (end - start) > refreshTime
            }
            return true
        }
    }
}
