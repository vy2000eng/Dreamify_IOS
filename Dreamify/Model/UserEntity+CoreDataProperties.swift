//
//  UserEntity+CoreDataProperties.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/25/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var userEmail: String
    @NSManaged public var dreamRelationShip: Set<Dream>?

}

// MARK: Generated accessors for dreamRelationShip
extension UserEntity {

    @objc(addDreamRelationShipObject:)
    @NSManaged public func addToDreamRelationShip(_ value: Dream)

    @objc(removeDreamRelationShipObject:)
    @NSManaged public func removeFromDreamRelationShip(_ value: Dream)

    @objc(addDreamRelationShip:)
    @NSManaged public func addToDreamRelationShip(_ values: NSSet)

    @objc(removeDreamRelationShip:)
    @NSManaged public func removeFromDreamRelationShip(_ values: NSSet)

}

extension UserEntity : Identifiable {

}
