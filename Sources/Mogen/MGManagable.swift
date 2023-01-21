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

    init(from object: NSManagedObject, forKey key: String)
    func encode(to object: NSManagedObject, forKey key: String)
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
    
    public init(from object: NSManagedObject, forKey key: String) {
        object.willAccessValue(forKey: key)
        defer { object.didAccessValue(forKey: key) }
        self = Self.decode(value: object.primitiveValue(forKey: key))
    }
    
    public func encode(to object: NSManagedObject, forKey key: String) {
        object.willChangeValue(forKey: key)
        object.setPrimitiveValue(encode(), forKey: key)
        object.didChangeValue(forKey: key)
    }
}

extension String: MGManagable {}
extension Date: MGManagable {}
extension Data: MGManagable {}
extension NSManagedObject: MGManagable {}
extension NSFetchRequest: MGManagable {}
extension UUID: MGManagable {}
extension URL: MGManagable {}

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

extension Int64: MGManagable {
    public static func decode(value: Any?) -> Int64 {
        if let value = value as? NSNumber {
            return value.int64Value
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Double: MGManagable {
    public static func decode(value: Any?) -> Double {
        if let value = value as? NSNumber {
            return value.doubleValue
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Float: MGManagable {
    public static func decode(value: Any?) -> Float {
        if let value = value as? NSNumber {
            return value.floatValue
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSNumber(value: self)
    }
}

extension Decimal: MGManagable {
    public static func decode(value: Any?) -> Decimal {
        if let value = value as? NSDecimalNumber {
            return value.decimalValue
        } else {
            fatalError()
        }
    }
    
    public func encode() -> Any? {
        NSDecimalNumber(decimal: self)
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
