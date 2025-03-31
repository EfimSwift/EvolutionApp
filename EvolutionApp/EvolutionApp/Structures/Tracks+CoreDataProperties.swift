//
//  Tracks+CoreDataProperties.swift
//  EvolutionApp
//
//  Created by user on 27.03.2025.
//
//

import Foundation
import CoreData


extension Tracks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tracks> {
        return NSFetchRequest<Tracks>(entityName: "Tracks")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var album: Album?

}

extension Tracks : Identifiable {

}
