//
//  Dream+CoreDataProperties.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/3/25.
//
//

import Foundation
import CoreData


extension Dream {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dream> {
        return NSFetchRequest<Dream>(entityName: "Dream")
    }

    @NSManaged public var analyzedText: String?
    @NSManaged public var created_date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var tag: String?
    @NSManaged public var title: String?
    @NSManaged public var transcribedText: String?
    @NSManaged public var url: String?
    @NSManaged public var userRelationShip: UserEntity?

}

extension Dream : Identifiable {

}
