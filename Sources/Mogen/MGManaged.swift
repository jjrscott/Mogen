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
            return Value(from: instance, forKey: wrapper.name)
        }
        set {
            let wrapper = instance[keyPath:storageKeyPath]
            newValue.encode(to: instance, forKey: wrapper.name)
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
