//
//  Dress+CoreDataProperties.swift
//  projekt
//
//  Created by student on 02/06/2022.
//  Copyright © 2022 pl. All rights reserved.
//
//

import Foundation
import CoreData


extension Dress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dress> {
        return NSFetchRequest<Dress>(entityName: "Dress")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var order: NSSet?

}

// MARK: Generated accessors for order
extension Dress {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}

extension Dress : Identifiable {

}
