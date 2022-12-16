//
//  PDSModel+CoreDataProperties.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//
//

import Foundation
import CoreData

extension PDSModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PDSModel> {
        return NSFetchRequest<PDSModel>(entityName: "PDSModel")
    }
    @NSManaged public var date: Date?
    @NSManaged public var plan: String?
    @NSManaged public var doing: String?
    @NSManaged public var feedback: String?
    @NSManaged public var grade: String?
}

extension PDSModel : Identifiable {}
