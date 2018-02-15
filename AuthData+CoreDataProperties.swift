//
//  AuthData+CoreDataProperties.swift
//  MyESSTUios
//
//  Created by Sergey Ivanov on 20.11.17.
//  Copyright © 2017 agvares. All rights reserved.
//
//

import Foundation
import CoreData


extension AuthData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthData> {
        return NSFetchRequest<AuthData>(entityName: "AuthData")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var patronymic: String?
    @NSManaged public var token: String?
    @NSManaged public var userCode: String?

}
