# Defining and Decoding Model Objects

## Codable

Any type that conforms to `Encodable` can be encoded to an `HTTPBody` in an `HTTPRequest` or `HTTPResponse`.

```swift
struct MyType: Codable {
    let id: Int
    var name: String
}

let myObject = MyType(id: 1, name: "Bob")

try someRequest.body.encode(myObject)
```

Likewise, any class that is `Decodable` can be decoded from an `HTTPBody`.

```swift
let value = try someRequest.body.decode(as: MyType.self)
```

In addtion to these `Codable` protocols, Forge also has some extensions that can be used:

## DecoderUpdatable

To create a type that can be updated from a `Decoder`, make it conform to `DecoderUpdatable`:

```swift
protocol DecoderUpdatable {
    mutating func update(from decoder: Decoder) throws
}
```

```swift
struct MyUpdatableType: DecoderUpdatable {
    let id: Int
    var name: String

    enum Key: String, CodingKey {
        case id
        case name
    }

    mutating func update(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        name = try container.decode(String.self, forKey: .name)
    }
}
```

`DecoderUpdatable` types can be updated from an `HTTPBody`:

```swift
let myObject = MyUpdatableType(id: 1, name: "old name")

let updated = try someResponse.body.update(myObject)
```

`DecoderUpdatable` types can also be updated from containers:

```swift
class Parent: DecoderUpdatable {
    let id: Int
    var name: String?
    var child: MyUpdatableType

    init(id: Int, name: String?, child: MyUpdatableType) {
        self.id = id
        self.name = name
        self.child = child
    }

    enum Key: String, CodingKey {
        case id
        case name
        case child
    }

    func update(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        name = try container.decode(String.self, forKey: .name)
        child = try container.update(child, forKey: .child)
    }
}

let parent = Parent(id: 2, name: "Parent Old Name", child: myObject)

// parent is a reference type and does not need reassignment after the update
try someResponse.body.update(parent)
```
## DecodingFactory

There are some classes that just can't be made to conform to `Decodable` for these, you can use a `DecodingFactory` to create an object from a `Decoder`:

```swift
protocol DecodingFactory {
    associatedtype Model
    func create(from decoder: Decoder) throws -> Model
}
```

```swift
struct CLLocationFactory: DecodingFactory {
    enum Key: String, CodingKey {
        case latitude
        case longitude
    }

    func create(from decoder: Decoder) throws -> CLLocation {
        let container = try decoder.container(keyedBy: Key.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
```

`DecodingFactory` can be used with `HTTPBody`s instead of a `Decodable` type:

```swift
let location = someResponse.body.decode(using: CLLocationFactory())
```

## ManagedDecodable

CoreData objects are among those that can't be made `Decodable`. For these there is another protocol: `ManagedDecodable`

```swift
protocol ManagedDecodable: DecoderUpdatable {
    static var entityName: String { get }
    static var matchKeys: [MatchKey]? { get }
    static func createOrUpdate(in context: NSManagedObjectContext, from decoder: Decoder) throws -> Self
}
```

The `createOrUpdate` function has a default implementation for all `NSManagedObject`s which creates a new instance of the object in the `NSManagedObjectContext`.

If you provide a `matchKeys` property, the default `createOrUpdate` implementation will update a matching object if it exists, and create a new one if it cannot find a match.

```swift
class User: NSManagedObject, ManagedDecodable {
    static var entityName: String = "User"
    static var matchKeys: [MatchKey]? = [
        .key(Key.id)
    ]

    @NSManaged var id: Int
    @NSManaged var name: String

    enum Key: String, CodingKey {
        case id
        case name
    }

    func update(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
```

`ManagedDecodable` classes can be decoded using a `ManagedDecodingFactory`:

```swift
let factory = ManagedDecodingFactory<User>(context: myContext)
let user = try someResponse.body.decode(using: factory)
```

## CodingFormats

Forge has protocols for high-level decoders and encoders, like `JSONDecoder`, `PropertyListDecoder`, `JSONEncoder` and `PropertyListEncoder`.

These are `DecodingFormat`:

```swift
public protocol DecodingFormat {
    func decoder(for data: Data) -> Decoder
}
```

and `EncodingFormat`:

```swift
public protocol EncodingFormat {
    func encode<T: Encodable>(_ value: T) throws -> Data
}
```

`HTTPBody`s have `decodingFormat` and `encodingFormat` properties that correspond to these protocols.

The default values for these are `JSONDecoder()` and `JSONEncoder()`, but requests executed through a `Gateway` may have these changed by the gateway.

These properties can be changed

```swift
someRequest.body.encodingFormat = PropertyListEncoder()
let value = try someRequest.body.decode(as: MyType.self)
```

or you can pass a format explicitly to `HTTPBody`'s `decode` and `encode` functions:

```swift
try someRequest.body.encode(myObject, with: PropertyListEncoder())

let value = try someRequest.body.decode(as: MyType.self, with: PropertyListDecoder())
```

## Decoding Promises

Forge has conveniences for Decoding `HTTPResponse` or `HTTPRequest` `Promise`s that match the methods on `HTTPBody`:

```swift
gateway
  .request("things", id)
  .execute()
  .decode(as: MyType.self) // Returns Promise<MyType>

gateway
  .request("things", id)
  .execute()
  .decode(as: MyType.self, with: PropertyListDecoder()) // Returns Promise<MyType>


gateway
  .request("users", userID)
  .execute()
  .decode(using: ManagedDecodingFactory<User>(context: myContext)) // Returns Promise<User>
```

Requests executed through a `ManagedGateway` also have conveniences for `ManagedDecodable` objects, instead of needing a `ManagedDecodingFactory`:

```swift
managedGateway
  .request("users", userID)
  .execute()
  .decode(managed: User.self) // Returns Promise<User>
```
