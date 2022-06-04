//
//  Order+CoreDataProperties.swift
//  projekt
//
//  Created by student on 02/06/2022.
//  Copyright © 2022 pl. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int16
    @NSManaged public var size: String?
    @NSManaged public var dress: Dress?
    @NSManaged public var fabric: Fabric?
    
    
    public var dress_name: String {
        dress?.name! ?? ""
    }
    public var dress_price: Double {
        dress?.price ?? 0.0
    }
    public var fabric_name: String {
        fabric?.name! ?? ""
    }
    public var fabric_price: Double {
        fabric?.price ?? 0.0
    }
}

extension Order : Identifiable {

}
