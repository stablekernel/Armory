# Quickstart

In Forge, an HTTP server is represented by a `Gateway`.

```swift
let gateway = Gateway(baseURL: myURL)
```

`Gateway`s are used to make and execute `HTTPRequest`s, that return a `Promise` for your model objects.

```swift
let request = gateway.request("users", userID)
request
  .execute()
  .decode(as: User.self)
```

`Gateway`s [can be customized](gateway.md) to modify all requests made through them.

`HTTPRequest`s include conveniences for working with `HTTPMethod`s, `HTTPHeaders` and `HTTPBody`s, and return `HTTPResponse`s, that can be modified or decoded.
More on `HTTPRequest`s [here](request.md).

```swift
let request = gateway.request("users")
request.headers.add(.contentType, "application/json")
request.method = .post
try request.body.encode(myNewUser)
request
  .execute()
  .then(MyResponseMiddleware())
  .decode(as: User.self)
```

Any model objects conforming to the `Codable` protocols can be used with `HTTPRequest` and `HTTPResponse`, although there are also [other Codable conveniences built in](model.md).
