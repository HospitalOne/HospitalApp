//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Daniil Belikov on 05.02.2020.
//  Copyright © 2020 Tolyatti City Hospital No.1. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?

}
