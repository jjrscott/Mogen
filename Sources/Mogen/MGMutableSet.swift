//
//  MGMutableSet.swift
//  
//
//  Created by John Scott on 31/12/2022.
//

import Foundation
import CoreData

public class MGMutableSet<Element>: MGManagable {
    private let object: NSManagedObject
    private let key: String
    
    required public init(from object: NSManagedObject, forKey key: String) {
        self.object = object
        self.key = key
    }
    
    private var original: NSMutableSet {
        object.willAccessValue(forKey: key)
        defer { object.didAccessValue(forKey: key) }
        return object.mutableSetValue(forKey: key)
    }
}

extension MGMutableSet: Sequence {
    public func makeIterator() -> MGFastEnumerationIterator<Element> {
        MGFastEnumerationIterator<Element>(original: original.makeIterator())
    }
    
    public var underestimatedCount: Int {
        original.underestimatedCount
    }
}

public struct MGFastEnumerationIterator<Element> {
    private var original: NSFastEnumerationIterator
    
    init(original: NSFastEnumerationIterator) {
        self.original = original
    }
}

extension MGFastEnumerationIterator: IteratorProtocol {
    public mutating func next() -> Element? {
        original.next() as? Element
    }
}

extension MGMutableSet {
    public var count: Int {
        original.count
    }
    
    public var allObjects: [Element]  {
        original.allObjects as! [Element]
    }

    public func contains(_ anObject: Element) -> Bool  {
        original.contains(anObject)
    }
    
    
    public func add(_ object: Element) {
        if #available(iOS 13.0, *) {
            objectWillChange.send()
        }
        original.add(object)
    }

    public func remove(_ object: Element) {
        if #available(iOS 13.0, *) {
            objectWillChange.send()
        }
        original.remove(object)
    }
}

@available(iOS 13.0, *)
extension MGMutableSet: ObservableObject {
    
}
