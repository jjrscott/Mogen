//
//  File.swift
//  
//
//  Created by John Scott on 30/12/2022.
//

import Foundation
import CoreData
import ArgumentParser

@main
struct Generator: ParsableCommand {
    @Option var input: String
    @Option var output: String

    mutating func run() throws {
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: URL(fileURLWithPath: input)) else {
            fatalError()
        }
        
        var swiftCode = ""
        
        swiftCode += """
            import CoreData
            import Mogen
            """
        
        for entity in managedObjectModel.entities {
            guard let name = entity.managedObjectClassName else { continue }
            
            swiftCode += """

@objc(\(name))
@objcMembers
public class \(name): \(entity.superentity?.managedObjectClassName ?? "NSManagedObject") {

"""
            for property in entity.properties {
                if entity.superentity?.properties.contains(property) == true {
                    continue
                }
                swiftCode += "\t@MGManaged(\"\(property.name)\") \(property.swiftType)\n"
            }
            swiftCode += """
}
"""
            if entity.superentity == nil {
                swiftCode += """

extension \(name): Identifiable { }
"""
            }
        }
        
        try swiftCode.write(toFile: output, atomically: true, encoding: .utf8)
    }
}

extension NSPropertyDescription {
    @objc var swiftType: String { fatalError() }
}

extension NSAttributeDescription {
    override var swiftType: String {
        "var \(name): \(attributeType.swiftType)\(isOptional ?? "?")"
    }
}

extension NSAttributeType {
    var swiftType: String {
        switch self {
        case .undefinedAttributeType: fatalError()
        case .integer16AttributeType: return "Int16"
        case .integer32AttributeType: return "Int32"
        case .integer64AttributeType: return "Int64"
        case .decimalAttributeType: return "Decimal"
        case .doubleAttributeType: return "Double"
        case .floatAttributeType: return "Float"
        case .stringAttributeType: return "String"
        case .booleanAttributeType: return "Bool"
        case .dateAttributeType: return "Date"
        case .binaryDataAttributeType: return "Data"
        case .UUIDAttributeType: return "UUID"
        case .URIAttributeType: return "URL"
        case .transformableAttributeType: fatalError()
        case .objectIDAttributeType: fatalError()
        @unknown default: fatalError()
        }
    }
}

extension NSRelationshipDescription {
    override var swiftType: String {
        let destinationType = destinationEntity?.managedObjectClassName ?? "NSManagedObject"
        if isToMany {
            return "private(set) var \(name): MGMutableSet<\(destinationType)>"
        } else {
            return "var \(name): \(destinationType)\(isOptional ?? "?")"
        }
    }
}

extension NSFetchedPropertyDescription {
    override var swiftType: String {
        guard let fetchRequest else { fatalError() }
        guard let destinationType = fetchRequest.entity?.managedObjectClassName else { fatalError() }
        return "private(set) var \(name): MGArray<\(destinationType)>"
    }
}

func ??(lhs: Bool, rhs: String) -> String {
    lhs ? rhs : ""
}
