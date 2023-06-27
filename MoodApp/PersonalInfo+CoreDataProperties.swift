//
//  PersonalInfo+CoreDataProperties.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/27.
//
//

import Foundation
import CoreData


extension PersonalInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalInfo> {
        return NSFetchRequest<PersonalInfo>(entityName: "PersonalInfo")
    }

    @NSManaged public var passcode: String?

}

extension PersonalInfo : Identifiable {

}
