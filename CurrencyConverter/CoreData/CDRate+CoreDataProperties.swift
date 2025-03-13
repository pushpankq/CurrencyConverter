//
//  CDRate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 26/01/25.
//
//

import Foundation
import CoreData

extension CDRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRate> {
        return NSFetchRequest<CDRate>(entityName: "CDRate")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var price: Double

}

extension CDRate : Identifiable {

}
