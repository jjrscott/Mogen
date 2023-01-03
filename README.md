# Mogen

Mogen is an Xcode plugin that, when installed, generates Swift type-safe classes for CoreData entities. It was inspired by [mogenerator](https://github.com/rentzsch/mogenerator).

Xcode's built in codegen will produce something like this:

```swift
@objc(MOEvent)
public class MOEvent: NSManagedObject { }

extension MOEvent {
    @NSManaged public var comment: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var timestampNudge: NSNumber?
    @NSManaged public var animals: NSSet?
}
```

Mogen will produce this:

```swift
@objc(MOEvent) @objcMembers
public class MOEvent: NSManagedObject {
	@MGManaged("comment") var comment: String?
	@MGManaged("timestamp") var timestamp: Date?
	@MGManaged("timestampNudge") var timestampNudge: Int16?
	@MGManaged("animals") private(set) var animals: MGMutableSet<MOAnimal>
}
```

Note that `timestampNudge` and `animals` are now correctly typed.

## Usage

```swift
.package(url: "https://github.com/jjrscott/Mogen", from: "x.y.z")
```

```swift
.target(
    name: "...",
    dependencies: [
        .product(name: "Mogen", package: "Mogen"),
    ],
    plugins: [
        .plugin(name: "BuildTool", package: "Mogen")
    ]
```
