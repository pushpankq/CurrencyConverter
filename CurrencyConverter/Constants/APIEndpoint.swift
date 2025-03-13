//
//  APIEndpoint.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 25/01/25.
//

import Foundation

enum APIEndpoint {
    
    static var baseURL: String {
        return "https://openexchangerates.org/api"
    }
    
    case currencies
    case rates
    
    var endpoint: URL? {
        switch self {
        case .currencies:
            return URL(string: "\(Self.baseURL)/currencies.json?\(CurrencyConverter.ApiKeys.appID)")
        case .rates:
            return URL(string: "\(Self.baseURL)/latest.json?app_id=\(CurrencyConverter.ApiKeys.appID)")
        }
    }
}
