//
//  MGManagable.swift
//  
//
//  Created by John Scott on 31/12/2022.
//

import CoreData

public protocol MGManagable {
    static func decode(value: Any?) -> Self
    func encode() -> Any?
}

extension MGManagable {
    public static func decode(value: Any?) -> Self {
        if let value = value as? Self {
            return value
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        self
    }
}

extension String: MGManagable {}
extension Date: MGManagable {}
extension Data: MGManagable {}
extension NSManagedObject: MGManagable {}
extension NSFetchRequest: MGManagable {}

extension Int32: MGManagable {
    public static func decode(value: Any?) -> Int32 {
        if let value = value as? NSNumber {
            return value.int32Value
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Bool: MGManagable {
    public static func decode(value: Any?) -> Bool {
        if let value = value as? NSNumber {
            return value.boolValue
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Int16: MGManagable {
    public static func decode(value: Any?) -> Int16 {
        if let value = value as? NSNumber {
            return value.int16Value
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Optional: MGManagable where Wrapped: MGManagable {
    public static func decode(value: Any?) -> Optional<Wrapped> {
        if let value {
            return Wrapped.decode(value: value)
        } else {
            return nil
        }
    }
    
    public func encode() -> Any? {
        self?.encode()
    }
}


extension MGMutableSet: MGManagable where Element: NSManagedObject {
    public static func decode(value: Any?) -> Self {
        guard let value = value as? NSMutableSet else {
            fatalError()
        }
        return Self(original: value)
    }

    public func encode() -> Any? {
        fatalError()
    }
}

