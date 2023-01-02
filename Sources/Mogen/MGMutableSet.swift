//
//  MGMutableSet.swift
//  
//
//  Created by John Scott on 31/12/2022.
//

import Foundation

public class MGMutableSet<Element> {
    private let original: NSMutableSet
    
    required init(original: NSMutableSet) {
        self.original = original
    }
}

extension MGMutableSet: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        MGFastEnumerationIterator<Element>(original: original.makeIterator())
    }
    
    public var underestimatedCount: Int {
        original.underestimatedCount
    }
}

struct MGFastEnumerationIterator<Element> {
    private var original: NSFastEnumerationIterator
    
    init(original: NSFastEnumerationIterator) {
        self.original = original
    }
}

extension MGFastEnumerationIterator: IteratorProtocol {
    mutating func next() -> Element? {
        original.next() as? Element
    }
}
