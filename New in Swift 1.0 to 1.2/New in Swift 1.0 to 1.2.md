## **Changes in Swift 1.1**

#### 1.`countElements()` is now `count()`

In Swift 1.0 you would count an array like this:

```swift
let items = [1, 2, 3]
println(countElements(items))
```

The `countElements()` function has been renamed to `count()` in Swift 1.1, so the new code is this:

```swift
let items = [1, 2, 3]
println(count(items))
```

**Note:** This has changed in later versions of Swift – `count` is now a property of strings and collections.



#### 2.macOS apps can now use `@NSApplicationMain`

iOS apps have a `@UIApplicationMain` attribute that automatically generates a `UIApplicationMain()` func to bootstrap the app. This is now also available to macOS developers using `@NSApplicationMain`, and this attribute will automatically be added to Cocoa app delegates in all new projects.

## Changes in Swift 1.2

### 1.The `zip()` function joins two sequences

If you have two sequences that you'd like to join together, the `zip()` function will do just that and return an array of tuples. For example:

```swift
let names = ["Sophie", "Charlotte", "John"]
let scores = [90, 92, 95]
let zipped = zip(names, scores)
```

That will output an array of the tuples ("Sophie", 90), ("Charlotte", 92), and ("John", 95).

### 2.The `flatMap()` method transforms optionals and arrays

The `flatMap()` method is designed to allow you to transform optionals and elements inside a collection while also decreasing the amount of containment that happens. For example, if you transform an optional in a way that will also return an optional, using `map()` would give you an optional optional (a double optional), whereas `flatMap()` is able to combine those two optionals into a single optioanl.

```swift
let lengthOfFirst = names.first.flatMap { count($0) }
```

Decreasing the amount of containment also makes `flatMap()` a simple way of converting multi-dimensional arrays into single-dimensional arrays:

```swift
[[1, 2], [3, 4], [5, 6]].flatMap { $0 }
```

There is no "map" operation there, so we're just left with the flattening behavior – that will result in a single array containing the value `[1, 2, 3, 4, 5, 6]`.

### 3.Closures can now be marked `@noescape`

Closures are reference types, which means Swift must quietly add memory management calls when they are passed into functions. To avoid adding unwanted work, you can now mark closure parameters with the `@noescape`keyword, which tells Swift the closure will be used before the function returns – it doesn't need to retain or release the closure.

As an example, this function checks whether a password that we have stored matches a password the user just entered, but it does this using a closure so that you can give it any encryption code you like. This closure is used immediately inside the function, so `@noescape` may be used as a performance optimization:

```swift
func checkPassword(encryption: @noescape (String) -> ()) -> Bool {
    if closure(enteredPassword) == storedPassword {
        return true
    } else {
        return false
    }
}
```

**Note:** This has changed in later versions of Swift – all closures are considered to be non-escaping by default.

### 4.Classes can now have static methods and properties

Swift 1.2 gives us an alias for class final properties: `static`. While class variables may be overridden in subclasses, static variables may not. For example:

```swift
class Student: Person {
    // THIS ISN'T ALLOWED
    override static var count: Int {
        return 150
    }

    // THIS IS ALLOWED
    override class var averageAge: Double {
        return 19.5
    }
}
```

In this usage, `static var` is merely an alias for `final class var`.

### 5.Constants no longer require immediate initialization

Constants may be set only once, but Swift 1.2 allows us to create constants without initializing them immediately. For example:

```swift
let username: String

if authenticated {
    username = fetchUsername()
} else {
    username = "Anonymous"
}
```

### 6.A new `Set` data structure

Swift 1.2 introduced a new `Set` type that works similarly to `NSSet` except with value semantics. Sets work similarly to arrays except they are not ordered and do not store any element more than once. For example:

```swift
var starships = Set<String>()
starships.insert("Serenity")
starships.insert("Enterprise")
starships.insert("Executor")
starships.insert("Serenity")
starships.insert("Serenity")
```

Even though that code tries to insert Serenity three times, it will only be stored in the set once.

### 7.Implicit bridging has been reduced

Prior to Swift 1.2 bridging from Objective-C types to Swift types happened implicitly, meaning that you could use the two interchangeable. From Swift 1.2 onwards you must now use `as` to typecast these yourself. For example:

```swift
authenticateUser(yourNSString as String)
```

**Note:** This has changed in later versions of Swift – implicit bridging never happens now.

### 8.Multiple `if let` bindings

You may now place multiple `if let` bindings on a single line separated by a comma, rather than embed them in increasingly indented pyramids.

For example, previously you would write code like this:

```swift
if let user = loadUsername() {
    if let password = decryptPassword() {
        authenticate(user, password)
    }
}
```

As of Swift 1.2 you can write this:

```swift
if let user = loadUsername(), let password = decryptPassword() {
    authenticate(user, password)
}
```

### 9.Typecasting now includes `as!`

From Swift 1.2 onwards we have three ways of performing typecasts: `as` is used for typecasts that will always succeed (e.g. `someString as NSString`), `as?` is used for typecasts that might fail (e.g. `someView as? UIImageView`), and `as!` is used to force typecasts. If you use `as!` and you're wrong, your code will crash.

For example:

```swift
let submitButton = vw.viewWithTag(10) as! UIButton
```





