//
//  AuthData+CoreDataClass.swift
//  MyESSTUios
//
//  Created by Sergey Ivanov on 20.11.17.
//  Copyright © 2017 agvares. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AuthData)
public class AuthData: NSManagedObject {
    convenience init() {
        // Описание сущности
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "AuthData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
