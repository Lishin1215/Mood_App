//
//  PersonalInfo+CoreDataProperties.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/4.
//
//

import Foundation
import CoreData


extension PersonalInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalInfo> {
        return NSFetchRequest<PersonalInfo>(entityName: "PersonalInfo")
    }

    @NSManaged public var passcode: String?
    @NSManaged public var reminderTime: Date?
    @NSManaged public var languageSelect: Int16

}

extension PersonalInfo : Identifiable {

}
