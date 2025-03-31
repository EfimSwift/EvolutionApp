//
//  Photos+CoreDataProperties.swift
//  EvolutionApp
//
//  Created by user on 27.03.2025.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var createdAt: Date?

}

extension Photos : Identifiable {

}
