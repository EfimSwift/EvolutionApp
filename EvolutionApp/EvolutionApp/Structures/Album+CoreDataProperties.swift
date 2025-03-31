//
//  Album+CoreDataProperties.swift
//  EvolutionApp
//
//  Created by user on 27.03.2025.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var tracks: NSSet?

}

// MARK: Generated accessors for tracks
extension Album {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: Tracks)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: Tracks)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)

}

extension Album : Identifiable {

}
