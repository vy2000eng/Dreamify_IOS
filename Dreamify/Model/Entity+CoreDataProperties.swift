//
//  Entity+CoreDataProperties.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var recording: NSObject?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Entity : Identifiable {

}
