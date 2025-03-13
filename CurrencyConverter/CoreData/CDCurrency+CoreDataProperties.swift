//
//  CDCurrency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 26/01/25.
//
//

import Foundation
import CoreData

extension CDCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrency> {
        return NSFetchRequest<CDCurrency>(entityName: "CDCurrency")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var currencyCountry: String?

}

extension CDCurrency : Identifiable {

}
