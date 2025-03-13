//
//  String.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 27/01/25.
//

import Foundation

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
