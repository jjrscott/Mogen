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
            let wrapper = instance[keyPath:storageKeyPath]
            instance.willAccessValue(forKey: wrapper.name)
            defer { instance.didAccessValue(forKey: wrapper.name) }
            return Value.decode(value: instance.primitiveValue(forKey: wrapper.name))
        }
        set {
            let wrapper = instance[keyPath:storageKeyPath]
            instance.willChangeValue(forKey: wrapper.name)
            instance.setPrimitiveValue(newValue.encode(), forKey: wrapper.name)
            instance.didChangeValue(forKey: wrapper.name)
        }
    }

    @available(*, unavailable,
        message: "@MGManaged can only be applied to NSManagedObject classes"
    )
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public init(_ name: String) {
        self.name = name
    }
    
    public var projectedValue: MGManaged<Value> {
        return self
    }
    
    var name: String
}
