//
//  MGManaged.swift
//  
//
//  Created by John Scott on 30/12/2022.
//

import CoreData
import SwiftUI

@propertyWrapper
public class MGManaged<Value: MGManagable>: NSObject {
    public static subscript<EnclosingType: NSManagedObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, MGManaged>
    ) -> Value {
        get {
            let `self` = instance[keyPath:storageKeyPath]
            instance.willAccessValue(forKey: self.name)
            defer { instance.didAccessValue(forKey: self.name) }
            return Value.decode(value: instance.primitiveValue(forKey: self.name))
        }
        set {
            let `self` = instance[keyPath:storageKeyPath]
            instance.willChangeValue(forKey: self.name)
            instance.setPrimitiveValue(newValue.encode(), forKey: self.name)
            instance.didChangeValue(forKey: self.name)
        }
    }

//    @available(*, unavailable,
//        message: "@MGManaged can only be applied to NSManagedObject classes"
//    )
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public init(_ name: String) {
        self.name = name
    }
    
    var name: String
}
