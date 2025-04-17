//
//  Log+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import CoreData
import Foundation

public extension Log {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Log> {
        NSFetchRequest<Log>(entityName: "Log")
    }
}

extension Log: Identifiable { }
