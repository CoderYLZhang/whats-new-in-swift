#Changes in Swift 4.0

####1.Swifty encoding and decoding

We know value types are great, but we also know they interact terribly with Objective-C APIs such as `NSCoding` – you either need to write a shim layer or give in and use classes, both of which are unpleasant. Worse, even if you give in and switch to classes, you still need to write your encoding and decoding methods by hand, which is painful and error-prone.

Swift 4 introduces a new `Codable` protocol that lets you serialize and deserialize custom data types without writing any special code – and without having to worry about losing your value types. Even better, you can choose how you want the data to be serialized: you can use classic property list format or even JSON.

Let's take a look at how beautiful this is. First, here's a custom data type and some instances of it:

```swift
struct Language: Codable {
    var name: String
    var version: Int
}

let swift = Language(name: "Swift", version: 4)
let php = Language(name: "PHP", version: 7)
let perl = Language(name: "Perl", version: 6)
```

You can see I've marked the `Language` struct as conforming to the `Codable` protocol. With that one tiny addition, we can convert it to a `Data` representation of JSON like this:

```swift
let encoder = JSONEncoder()
if let encoded = try? encoder.encode(swift) {
    // save `encoded` somewhere
}
```

Swift will automatically encode all properties inside your data type – you don't need to do anything.

Now, if you're like me and have a long history of using `NSCoding`, you're probably somewhat doubtful: is that really all it takes, and how can we be sure it's working? Well, let's add some more code to try converting the `Data` object into a string so we can print it out, then decode it back into a new `Language` instance that we can read from:

```swift
if let encoded = try? encoder.encode(swift) {
    if let json = String(data: encoded, encoding: .utf8) {
        print(json)
    }

    let decoder = JSONDecoder()
    if let decoded = try? decoder.decode(Language.self, from: encoded) {
        print(decoded.name)
    }
}
```

Notice how decoding doesn't require a typecast – you provide the data type name as its first parameter, so Swift infers the return type from there.

Both `JSONEncoder` and its property list counterpart `PropertyListEncoder` have lots of options for customizing how they work: do you want compact JSON or pretty-printed JSON? Do you want to use ISO8601 dates or Unix epoch dates? Do you want to use binary property lists or XML? For more information on these and other options, see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0167-swift-encoders.md).

####2.Multi-line string literals

Writing multi-line strings in Swift has always meant adding `\n` inside your strings to add line breaks wherever you want them. This doesn't look good in code, but at least it displays correctly for users. Fortunately, Swift 4 introduces new multi-line string literal syntax that lets you add line breaks freely and use quote marks without escaping, while still benefiting from functionality like string interpolation.

To start a string literal, you need to write three double quotation marks: `"""` then press return. You can then go ahead and write a string as long as you want, including variables and line breaks, before ending your string by pressing return then writing three more double quotation marks.

String literals have two important rules: when you open a string using `"""` the content of your string must begin on a new line, and when you end a multi-line string using `"""` that must also begin on a new line.

Here it is in action:

```swift
let longString = """
When you write a string that spans multiple
lines make sure you start its content on a
line all of its own, and end it with three
quotes also on a line of their own.
Multi-line strings also let you write "quote marks"
freely inside your strings, which is great!
"""
```

That creates a new string with several line breaks right there in the definition – much easier to read *and* write.

For more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0168-multi-line-string-literals.md).

####3.Improved keypaths for key-value coding

One of the most loved features of Objective-C is its ability to reference a property dynamically rather than directly – that is, to be able to say "given object X, here is the property I'd like to read" without actually reading it. These references, called *keypaths*, are distinct from direct property accesses because they don't actually read or write the value, they just stash it away for use later on.

If you've never used keypaths before, let me show you an analogy of how they work using regular Swift methods. We're going to define a struct called `Starship` and a struct called `Crew`, then create one instance of each:

```swift
// an example struct
struct Crew {
    var name: String
    var rank: String
}

// another example struct, this time with a method
struct Starship {
    var name: String
    var maxWarp: Double
    var captain: Crew

    func goToMaximumWarp() {
        print("\(name) is now travelling at warp \(maxWarp)")
    }
}

// create instances of those two structs
let janeway = Crew(name: "Kathryn Janeway", rank: "Captain")
let voyager = Starship(name: "Voyager", maxWarp: 9.975, captain: janeway)

// grab a reference to the `goToMaximumWarp()` method
let enterWarp = voyager.goToMaximumWarp

// call that reference
enterWarp()
```

Because functions are first-class types in Swift, the last two lines are able to create a reference to the `goToMaximumWarp()` method called `enterWarp`, then call that later on whenever we want to. The problem is, you can't do the same thing for properties – you can't say "create a reference to the captain's name property that I can check when the inevitable mutiny happens," because Swift will just read the property directly and you'll just get its original value.

This is fixed with keypaths: they are *uninvoked references to properties* just like our `enterWarp()` code. If you invoke the reference now you get the current value, but if you invoke the reference later you get the latest value. You can dig through any number of properties, and Swift uses its type inference to ensure you get the correct type back.

The Swift Evolution community spent quite a while discussing the correct syntax for keypaths because it needed to be something visually different from other Swift code, and the syntax they ended up with uses backslashes: `\Starship.name`, `\Starship.maxWarp`, and `\Starship.captain.name`. You can assign those two to a variable then use them whenever you want, on any `Starship` instance. For example:

```swift
let nameKeyPath = \Starship.name
let maxWarpKeyPath = \Starship.maxWarp
let captainName = \Starship.captain.name

let starshipName = voyager[keyPath: nameKeyPath]
let starshipMaxWarp = voyager[keyPath: maxWarpKeyPath]
let starshipCaptain = voyager[keyPath: captainName]
```

That will make `starshipName` a string and `starshipMaxWarp` a double, because Swift is able to infer the types correctly. The third example there even goes into the property of a property, and Swift still figures it out correctly.

Future plans for this include being able to access array indexes and to create keypaths from strings at runtime – for more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md).

####4.Improved dictionary functionality

One of the most intriguing proposals for Swift 4 was to add some new functionality to dictionaries to make them more powerful, and also to make them behave more like you would expect in certain situations.

Let's start with a simple example: filtering dictionaries in Swift 3 does *not* return a new dictionary. Instead, it returns an array of tuples with key/value labels. For example:

```swift
let cities = ["Shanghai": 24_256_800, "Karachi": 23_500_000, "Beijing": 21_516_000, "Seoul": 9_995_000];
let massiveCities = cities.filter { $0.value > 10_000_000 }
```

After that code runs you can't read `massiveCities["Shanghai"]` because it is no longer a dictionary. Instead, you need to use `massiveCities[0].value`, which isn't great.

As of Swift 4 this behaves more like you would expect: you get back a new dictionary. Obviously this will break any existing code that relies on the tuple-array return type.

Similarly, the `map()` method on dictionaries never quite worked the way many people hoped: you got a key-value tuple passed in, and could return a single value to be added to an array. For example:

```swift
let populations = cities.map { $0.value * 2 }
```

That hasn't changed in Swift 4, but there is a new method called `mapValues()` that is going to be much more useful because it lets you transform the values and place them back into a dictionary using the original keys.

For example, this code will round and stringify all city populations, then put them back into a new dictionary with the same keys of Shanghai, Karachi, and Seoul:

```swift
let roundedCities = cities.mapValues { "\($0 / 1_000_000) million people" }
```

(In case you were wondering, it's not safe to map dictionary keys because you might create duplicates by accident.)

Easily my favorite new dictionary addition is a `grouping` initializer, which converts a sequence into a dictionary of sequences that are grouped by whatever you want. Continuing our `cities` example, we could use `cities.keys` to get back an array of city names, then group them by their first letter, like this:

```swift
let groupedCities = Dictionary(grouping: cities.keys) { $0.characters.first! }
print(groupedCities)
```

That will output the following:

```
["B": ["Beijing"], "S": ["Shanghai", "Seoul"], "K": ["Karachi"]]
```

Alternatively, we could group the cities based on the length of their names like this:

```swift
let groupedCities = Dictionary(grouping: cities.keys) { $0.count }
print(groupedCities)
```

That will output the following:

```
[5: ["Seoul"], 7: ["Karachi", "Beijing"], 8: ["Shanghai"]]
```

Finally, it's now possible to access a dictionary key and provide a default value to use if the key is missing:

```swift
let person = ["name": "Taylor", "city": "Nashville"]
let name = person["name", default: "Anonymous"]
```

Now, any experienced developer will probably argue that's better written using nil coalescing, and I agree. You could write this line instead using the current version of Swift:

```swift
let name = person["name"] ?? "Anonymous"
```

However, that doesn't work when you're *modifying* the dictionary value rather than just reading it. You can't modify a dictionary value in place because accessing its key returns an optional – the key might not exist, after all. With Swift 4's default dictionary values you can write much more succinct code, such as this:

```swift
var favoriteTVShows = ["Red Dwarf", "Blackadder", "Fawlty Towers", "Red Dwarf"]
var favoriteCounts = [String: Int]()

for show in favoriteTVShows {
    favoriteCounts[show, default: 0] += 1
}
```

That loops over every string in `favoriteTVShows`, and uses a dictionary called `favoriteCounts` to keep track of how often each item appears. We can modify the dictionary in one line of code because we know it will always have a value: either the default value of 0, or some higher number based on previous counting.

For more information see [the Swift Evolution proposal for these new features](https://github.com/apple/swift-evolution/blob/master/proposals/0165-dict.md).

####5.Strings are collections again

This is a small change, but one guaranteed to make a lot of people happy: strings are collections again. This means you can reverse them, loop over them character-by-character, `map()` and `flatMap()` them, and more. For example:

```swift
let quote = "It is a truth universally acknowledged that new Swift versions bring new features."
let reversed = quote.reversed()

for letter in quote {
    print(letter)
}
```

This change was introduced as part of a broad set of amendments called the [String Manifesto](https://github.com/apple/swift/blob/master/docs/StringManifesto.md).

####6.One-sided ranges

Last but not least, Swift 4 introduces Python-like one-sided collection slicing, where the missing side is automatically inferred to be the start or end of the collection. This has no effect on existing code because it's a new use for the existing operator, so you don't need to worry about potential breakage.

Here's an example:

```swift
let characters = ["Dr Horrible", "Captain Hammer", "Penny", "Bad Horse", "Moist"]
let bigParts = characters[..<3]
let smallParts = characters[3...]
print(bigParts)
print(smallParts)
```

That code will print out `["Dr Horrible", "Captain Hammer", "Penny"]` then `["Bad Horse", "Moist"]`.

For more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0172-one-sided-ranges.md).

#Changes in Swift 4.1

####1.Synthesized Equatable and Hashable

The `Equatable` protocol allows Swift to compare one instance of a type against another. When we say `5 == 5`, Swift understands what that means because `Int` conforms to `Equatable`, which means it implements a function describing what `==` means for two instances of `Int`.

Implementing `Equatable` in our own value types allows them to work like Swift’s strings, arrays, numbers, and more, and it’s usually a good idea to make your structs conform to `Equatable` just so they fit the concept of value types better.

However, implementing `Equatable` can be annoying. Consider this code:

```swift
struct Person {
    var firstName: String
    var lastName: String
    var age: Int
    var city: String
}
```

If you have two instances of `Person` and want to make sure they are identical, you need to compare all four properties, like this:

```swift
struct Person: Equatable {
    var firstName: String
    var lastName: String
    var age: Int
    var city: String

    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age && lhs.city == rhs.city
    }
}
```

Even *reading* that is tiring, never mind *writing* it.

Fortunately, Swift 4.1 can synthesize conformance for `Equatable` – it can generate an `==` method automatically, which will compare all properties in one value with all properties in another, just like above. So, all you have to do now is add `Equatable` as a protocol for your type, and Swift will do the rest.

Of course, if you *want* you can implement `==` yourself. For example, if your type has an `id` field that identifies it uniquely, you would write `==` to compare that single value rather than letting Swift do all the extra work.

Swift 4.1 also introduces synthesized support for the `Hashable` protocol, which means it will generate a `hashValue` property for conforming types automatically. `Hashable` was always annoying to implement because you need to return a unique (or at least mostly unique) hash for every object. It’s important, though, because it lets you use your objects as dictionary keys and store them in sets.

Previously we’d need to write code like this:

```swift
var hashValue: Int {
    return firstName.hashValue ^ lastName.hashValue &* 16777619
}
```

For the most part that’s no longer needed in Swift 4.1, although as with `Equatable` you might still want to write your own method if there’s something specific you need.

**Note:** You still need to opt in to these protocols by adding a conformance to your type, and using the synthesized code does require that all properties in your type conform to `Equatable` or `Hashable` respectively.

For more information, see [Swift Evolution proposal SE-0185](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md).

####2.Key decoding strategy for `Codable`

In Swift 4.0 a common problem was trying to use `Codable` with JSON that utilized snake_case for its key names rather than the camelCase we normally use in Swift. Codable was unable to understand how the two different name types were mapped, so you had to create a custom `CodingKeys` enum helping it out.

This is where Swift 4.1's new `keyDecodingStrategy` property comes in: it’s set to `.useDefaultKeys` by default, which does a direct mapping of JSON names to Swift properties. However, if you change it to `.convertFromSnakeCase` then `Codable` handles the name conversion for us.

For example:

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

do {
    let macs = try decoder.decode([Mac].self, from: jsonData)
    print(macs)
} catch {
    print(error.localizedDescription)
}
```

When you want to go back the other way – to convert a `Codable` struct with camelCase properties back to JSON with snake_case keys, set the `keyEncodingStrategy` to `.convertToSnakeCase` like this:

```swift
let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
let encoded = try encoder.encode(someObject)
```

**Note:** At the time of writing `keyDecodingStrategy` and `keyEncodingStrategy` are not available on Linux.

####3.Conditional conformances

Swift 4.1 implements [SE-0143](https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md), which introduced proposed conditional conformances into the language. This allows types to conform to a protocol only when certain conditions are met.

To demonstrate conditional conformances, let's create a `Purchaseable` protocol that we can use to buy things:

```swift
protocol Purchaseable {
   func buy()
}
```

We can now define a `Book` struct that conforms to the protocol, and prints a message when a book is bought:

```swift
struct Book: Purchaseable {
   func buy() {
      print("You bought a book")
   }
}
```

So far this is easy enough, but let's take it one step further: what if the user has a basket full of books, and wants to buy them all? We could loop over all books in the array by hand, calling `buy()` on each one. But a better approach is to write an extension on `Array` to make it conform to `Purchaseable`, then give it a `buy()` method that in turn calls `buy()` on each of its elements.

This is where conditional conformances come in: if we tried to extend all arrays, we'd be adding functionality where it wouldn't make sense – we'd be adding `buy()` to arrays of strings, for example, even though those strings don't have a `buy()` method we can call.

Swift 4.1 lets us make arrays conform to `Purchaseable` only if their elements also conform to `Purchaseable`, like this:

```swift
extension Array: Purchaseable where Element: Purchaseable {
   func buy() {
      for item in self {
         item.buy()
      }
   }
}
```

As you can see, conditional conformances let us constrain the way our extensions are applied more precisely than was possible before.

Conditional conformances also make large parts of Swift code easier and safer, even if you don't do any extra work yourself. For example, this code creates two arrays of optional strings and checks whether they are equal:

```swift
var left: [String?] = ["Andrew", "Lizzie", "Sophie"]
var right: [String?] = ["Charlotte", "Paul", "John"]
left == right
```

That might seem trivial, but that code wouldn't even compile in Swift 4.0 – both `String` and `[String]` were equatable, but `[String?]` was not.

The introduction of conditional conformance in Swift 4.1 means that it’s now possible to add protocol conformance to a type as long as it satisfies a condition. In this case, if the elements of the array are equatable, that means the whole thing is equatable. So, the above code now compiles in Swift 4.1

Conditional conformance has been extended to the `Codable` protocol in a way that will definitely make things safer. For example:

```swift
struct Person {
   var name = "Taylor"
}

var people = [Person()]
var encoder = JSONEncoder()
// try encoder.encode(people)
```

If you uncomment the `encoder.encode(people)` line, Swift will refuse to build your code because you're trying to encode a struct that doesn't conform to `Codable`. However, that code compiled cleanly with Swift 4.0, then threw a fatal error at runtime because `Person`doesn’t conform to `Codable`.

Obviously no one wants a fatal error at runtime, because it means your app crashes. Fortunately, Swift 4.1 cleans this up using conditional conformances: `Optional`, `Array`, `Dictionary`, and `Set` now only conform to `Codable` if their contents also conform to `Codable`, so the above code will refuse to compile.

####4.Recursive constraints on associated types

Swift 4.1 implements [SE-0157](https://github.com/apple/swift-evolution/blob/master/proposals/0157-recursive-protocol-constraints.md), which lifts restrictions on the way we use associated types inside protocols. As a result, we can now create recursive constraints for our associated types: associated types that are constrained by the protocol they are defined in.

To demonstrate this, let's consider a simple team hierarchy in a tech company. In this company, every employee has a manager – someone more senior to them that they report to. Each manager must also be an employee of the company, because it would be weird if they weren't.

We can express this relationship in a simple `Employee` protocol:

```swift
protocol Employee {
   associatedtype Manager: Employee
   var manager: Manager? { get set }
}
```

**Note:** I've used an optional `Manager?` because ultimately one person (presumably the CEO) has no manager.

Even though that's a fairly self-evident relationship, it wasn't possible to compile that code in Swift 4.0 because we're using the `Employee`protocol inside itself. However, this is fixed in Swift 4.1 because of the new ability to use recursive constraints on associated types.

Thanks to this new feature, we can model a simple tech company that has three kinds of team members: junior developers, senior developers, and board members. The reporting structure is also simple: junior developers are managed by senior developers, senior developers are managed by board members, and board members may be managed by another board member – e.g. the CTO reporting to the CEO.

That looks exactly as you would imagine thanks to Swift 4.1:

```swift
class BoardMember: Employee {
   var manager: BoardMember?
}

class SeniorDeveloper: Employee {
   var manager: BoardMember?
}

class JuniorDeveloper: Employee {
   var manager: SeniorDeveloper?
}
```

**Note:** I've used classes here rather than structs because `BoardMember` itself contains a `BoardMember` property and that would result in an infinitely sized struct. If one of these has to be a class I personally would prefer to make all three classes just for consistency, but if you preferred you could leave `BoardMember` as a class and make both `SeniorDeveloper` and `JuniorDeveloper` into structs.

####5.Build configuration import testing

Swift 4.1 implements [SE-0075](https://github.com/apple/swift-evolution/blob/master/proposals/0075-import-test.md), which introduces a new `canImport` condition that lets us check whether a specific module can be imported when our code is compiled.

This is particularly important for cross-platform code: if you had a Swift file that implemented one behavior on macOS and another on iOS, or if you needed specific functionality for Linux. For example:

```swift
#if canImport(SpriteKit)
   // this will be true for iOS, macOS, tvOS, and watchOS
#else
   // this will be true for other platforms, such as Linux
#endif
```

Previously you would have had to use inclusive or exclusive tests by operating system, like this:

```swift
#if !os(Linux)
   // Matches macOS, iOS, watchOS, tvOS, and any other future platforms
#endif

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
   // Matches only Apple platforms, but needs to be kept up to date as new platforms are added
#endif
```

The new `canImport` condition lets us focus on the functionality we care about rather than what platform we're compiling for, thus avoiding a variety of problems.

####6.Target environment testing

Swift 4.1 implements [SE-0190](https://github.com/apple/swift-evolution/blob/master/proposals/0190-target-environment-platform-condition.md), which introduces a new `targetEnvironment` condition that lets us differentiate between builds that are for physical devices and those that are for a simulated environment.

At this time `targetEnvironment` has only one value, `simulator`, which will be true if your build is targeting a simulated device such as the iOS Simulator. For example:

```swift
#if targetEnvironment(simulator)
   // code for the simulator here
#else
   // code for real devices here
#endif
```

This is useful when writing code to deal with functionality the simulator doesn't support, such as capturing photos from a camera or reading the accelerometer.

As an example, let's look at processing a photo from the camera. If we're running on a real device we'll create and configure a `UIImagePickerController()` to take photos using the camera, but if we're in the simulator we'll just load a sample image from our app bundle:

```swift
import UIKit

class TestViewController: UIViewController, UIImagePickerControllerDelegate {
   // a method that does some sort of image processing
   func processPhoto(_ img: UIImage) {
       // process photo here
   }

   // a method that loads a photo either using the camera or using a sample
   func takePhoto() {
      #if targetEnvironment(simulator)
         // we're building for the simulator; use the sample photo
         if let img = UIImage(named: "sample") {
            processPhoto(img)
         } else {
            fatalError("Sample image failed to load")
         }
      #else
         // we're building for a real device; take an actual photo
         let picker = UIImagePickerController()
         picker.sourceType = .camera
         vc.allowsEditing = true
         picker.delegate = self
         present(picker, animated: true)
      #endif
   }

   // this is called if the photo was taken successfully
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      // hide the camera
      picker.dismiss(animated: true)

      // attempt to retrieve the photo they took
      guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
         // that failed; bail out
         return
      }

      // we have an image, so we can process it
      processPhoto(image)
   }
}
```

####7.`flatMap` is now (partly) `compactMap()`

The `flatMap()` method was useful for a variety of things in Swift 4.0, but one was particularly useful: the ability to transform each object in a collection, then remove any items that were nil.

[Swift Evolution proposal SE-0187](https://github.com/apple/swift-evolution/blob/master/proposals/0187-introduce-filtermap.md) suggested changing this, and as of Swift 4.1 this `flatMap()` variant has been renamed to `compactMap()`to make its meaning clearer.

For example:

```swift
let array = ["1", "2", "Fish"]
let numbers = array.compactMap { Int($0) }
```

That will create an `Int` array containing the numbers 1 and 2, because "Fish" will fail conversion to `Int`, return nil, and be ignored.

#Changes in Swift 4.2

####1.Derived collections of enum cases

[SE-0194](https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md) introduces a new `CaseIterable` protocol that automatically generates an array property of all cases in an enum.

Prior to Swift 4.2 this either took hacks, hand-coding, or Sourcery code generation to accomplish, but now all you need to do is make your enum conform to the `CaseIterable` protocol. At compile time, Swift will automatically generate an `allCases` property that is an array of all your enum’s cases, in the order you defined them.

For example, this creates an enum of pasta shapes and asks Swift to automatically generate an `allCases` array for it:

```swift
enum Pasta: CaseIterable {
    case cannelloni, fusilli, linguine, tagliatelle
}
```

You can then go ahead and use that property as a regular array – it will be a `[Pasta]` given the code above, so we could print it like this:

```swift
for shape in Pasta.allCases {
    print("I like eating \(shape).")
}
```

This automatic synthesis of `allCases` will only take place for enums that do not use associated values. Adding those automatically wouldn’t make sense, however if you want you can add it yourself:

```swift
enum Car: CaseIterable {
    static var allCases: [Car] {
        return [.ford, .toyota, .jaguar, .bmw, .porsche(convertible: false), .porsche(convertible: true)]
    }

    case ford, toyota, jaguar, bmw
    case porsche(convertible: Bool)
}
```

At this time, Swift is unable to synthesize the `allCases` property if any of your enum cases are marked unavailable. So, if you need `allCases` then you’ll need to add it yourself, like this:

```swift
enum Direction: CaseIterable {
    static var allCases: [Direction] {
        return [.north, .south, .east, .west]
    }

    case north, south, east, west

    @available(*, unavailable)
    case all
}
```

**Important:** You need to add `CaseIterable` to the original declaration of your enum rather than an extension in order for the `allCases` array to be synthesized. This means you can’t use extensions to retroactively make existing enums conform to the protocol.

####2.Warning and error diagnostic directives

[SE-0196](https://github.com/apple/swift-evolution/blob/master/proposals/0196-diagnostic-directives.md) introduces new compiler directives that help us mark issues in our code. These will be familiar to any developers who had used Objective-C previously, but as of Swift 4.2 we can enjoy them in Swift too.

The two new directives are `#warning` and `#error`: the former will force Xcode to issue a warning when building your code, and the latter will issue a compile error so your code won’t build at all. Both of these are useful for different reasons:

- `#warning` is mainly useful as a reminder to yourself or others that some work is incomplete. Xcode templates often use `#warning` to mark method stubs that you should replace with your own code.
- `#error` is mainly useful if you ship a library that requires other developers to provide some data. For example, an authentication key for a web API – you want users to include their own key, so using `#error` will force them to change that code before continuing.

Both of these work in the same way: `#warning("Some message")` and `#error("Some message")`. For example:

```swift
func encrypt(_ string: String, with password: String) -> String {
    #warning("This is terrible method of encryption")
    return password + String(string.reversed()) + password
}

struct Configuration {
    var apiKey: String {
        #error("Please enter your API key below then delete this line.")
        return "Enter your key here"
    }
}    
```

Both `#warning` and `#error` work alongside the existing `#if` compiler directive, and will only be triggered if the condition being evaluated is true. For example:

```swift
#if os(macOS)
#error("MyLibrary is not supported on macOS.")
#endif
```

####3.Dynamic member look up

[SE-0195](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md) introduces a way to bring Swift closer to scripting languages such as Python, but in a type-safe way – you don’t lose any of Swift’s safety, but you do gain the ability to write the kind of code you’re more likely to see in PHP and Python.

At the core of this feature is a new attribute called `@dynamicMemberLookup`, which instructs Swift to call a subscript method when accessing properties. This subscript method, `subscript(dynamicMember:)`, is *required*: you’ll get passed the string name of the property that was requested, and can return any value you like.

Let’s look at a trivial example so you can understand the basics. We could create a `Person` struct that reads its values from a dictionary like this:

```swift
@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member, default: ""]
    }
}
```

The `@dynamicMemberLookup` attribute requires the type to implement a `subscript(dynamicMember:)` method to handle the actual work of dynamic member lookup. As you can see, I’ve written one that accepts the member name as string and returns a string, and internally it just looks up the member name in a dictionary and returns its value.

That struct allows us to write code like this:

```swift
let person = Person()
print(person.name)
print(person.city)
print(person.favoriteIceCream)
```

That will compile cleanly and run, even though `name`, `city`, and `favoriteIceCream` do not exist as properties on the `Person` type. Instead, they are all looked up at runtime: that code will print “Taylor Swift” and “Nashville” for the first two calls to `print()`, then an empty string for the final one because our dictionary doesn’t store anything for `favoriteIceCream`.

My `subscript(dynamicMember:)` method *must* return a string, which is where Swift’s type safety comes in: even though you’re dealing with dynamic data, Swift will still ensure you get back what you expected. And if you want multiple different types, just implement different `subscript(dynamicMember:)` methods, like this:

```swift
@dynamicMemberLookup
struct Employee {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member, default: ""]
    }

    subscript(dynamicMember member: String) -> Int {
        let properties = ["age": 26, "height": 178]
        return properties[member, default: 0]
    }
}
```

Now that any property can be accessed in more than one way, Swift requires you to be clear which one should be run. That might be implicit, for example if you send the return value into a function that accepts only strings, or it might be explicit, like this:

```swift
let employee = Employee()
let age: Int = employee.age
```

Either way, Swift must know for sure which subscript will be called.

You can even overload `subscript` to return closures:

```swift
@dynamicMemberLookup
struct User {
    subscript(dynamicMember member: String) -> (_ input: String) -> Void {
        return {
            print("Hello! I live at the address \($0).")
        }
    }
}

let user = User()
user.printAddress("555 Taylor Swift Avenue")
```

When that’s run, `user.printAddress` returns a closure that prints out a string, and the `("555 Taylor Swift Avenue")` part immediately calls it with that input.

If you use dynamic member subscripting in a type that has also some regular properties and methods, those properties and methods will always be used in place of the dynamic member. For example, we could define a `Singer` struct with a built-in `name` property alongside a dynamic member subscript:

```swift
struct Singer {
    public var name = "Justin Bieber"

    subscript(dynamicMember member: String) -> String {
        return "Taylor Swift"
    }
}

let singer = Singer()
print(singer.name)
```

That code will print “Justin Bieber”, because the `name` property will be used rather than the dynamic member subscript.

`@dynamicMemberLookup` plays a full part in Swift’s type system, which means you can assign them to protocols, structs, enums, and classes – even classes that are marked `@objc`.

In practice, this means two things. First, you can create a class using `@dynamicMemberLookup`, and any classes that inherit from it are also automatically `@dynamicMemberLookup`. So, this will print “I’m a sandwich” because `HotDog` inherits from `Sandwich`:

```swift
@dynamicMemberLookup
class Sandwich {
    subscript(dynamicMember member: String) -> String {
        return "I'm a sandwich!"
    }
}

class HotDog: Sandwich { }

let chiliDog = HotDog()
print(chiliDog.description)
```

Second, you can retroactively make other types use `@dynamicMemberLookup` by defining it on a protocol, adding a default implementation of `subscript(dynamicMember:)` using a protocol extension, then making other types conform to your protocol however you want.

For example, this creates a new `Subscripting` protocol, provides a default `subscript(dynamicMember:)` implementation that returns a message, then extends Swift’s `String` to use that protocol:

```swift
@dynamicMemberLookup
protocol Subscripting { }

extension Subscripting {
    subscript(dynamicMember member: String) -> String {
        return "This is coming from the subscript"
    }
}

extension String: Subscripting { }
let str = "Hello, Swift"
print(str.username)
```

####4.Enhanced conditional conformances

Conditional conformances [were introduced in Swift 4.1](https://www.whatsnewinswift.com/articles/50/whats-new-in-swift-4-1), allowing types to conform to a protocol only when certain conditions are met.

For example, if we had a `Purchaseable` protocol:

```swift
protocol Purchaseable {
    func buy()
}
```

And a simple type that conforms to that protocol:

```swift
struct Book: Purchaseable {
    func buy() {
        print("You bought a book")
    }
}
```

Then we could make `Array` conform to `Purchaseable` if all the elements inside the array were also `Purchasable`:

```swift
extension Array: Purchaseable where Element: Purchaseable {
    func buy() {
        for item in self {
            item.buy()
        }
    }
}
```

This worked great at compile time, but there was a problem: if you needed to query a conditional conformance at runtime, your code would crash because it wasn’t supported in Swift 4.1

In Swift 4.2 that’s now fixed, so if you receive data of one type and want to check if it can be converted to a conditionally conformed protocol, it works great.

For example:

```swift
let items: Any = [Book(), Book(), Book()]

if let books = items as? Purchaseable {
    books.buy()
}
```

In addition, support for automatic synthesis of `Hashable` conformance has improved greatly in Swift 4.2. Several built-in types from the Swift standard library – including optionals, arrays, dictionaries, and ranges – now automatically conform to the `Hashable` protocol when their elements conform to `Hashable`.

For example:

```swift
struct User: Hashable {
    var name: String
    var pets: [String]
}
```

Swift 4.2 can automatically synthesize `Hashable` conformance for that struct, but Swift 4.1 could not.

####5.Random number generation and shuffling

[SE-0202](https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md) introduces a new random API that’s native to Swift. This means you can for the most part stop using `arc4random_uniform()` and GameplayKit to get randomness, and instead rely on a cryptographically secure randomizer that’s baked right into the core of the language.

You can generate random numbers by calling the `random()` method on whatever numeric type you want, providing the range you want to work with. For example, this generates a random number in the range 1 through 4, inclusive on both sides:

```swift
let randomInt = Int.random(in: 1..<5)
```

Similar methods exist for `Float`, `Double`, and `CGFloat`:

```swift
let randomFloat = Float.random(in: 1..<10)
let randomDouble = Double.random(in: 1...100)
let randomCGFloat = CGFloat.random(in: 1...1000)
```

There’s also one for booleans, generating either true or false randomly:

```swift
let randomBool = Bool.random()
```

Checking a random boolean is effectively the same as checking `Int.random(in: 0...1) == 1`, but it expresses your intent more clearly.

SE-0202 also includes support for shuffling arrays using new `shuffle()` and `shuffled()` methods depending on whether you want in-place shuffling or not. For example:

```swift
var albums = ["Red", "1989", "Reputation"]

// shuffle in place
albums.shuffle()

// get a shuffled array back
let shuffled = albums.shuffled()
```

It also adds a new `randomElement()` method to arrays, which returns one random element from the array if it isn’t empty, or nil otherwise:

```swift
if let random = albums.randomElement() {
    print("The random album is \(random).")
}
```

####6.Simpler, more secure hashing
Swift 4.2 implements [SE-0206](https://github.com/apple/swift-evolution/blob/master/proposals/0206-hashable-enhancements.md), which simplifies the way we make custom types conform to the `Hashable` protocol.

From Swift 4.1 onwards conformance to `Hashable` can be synthesized by the compiler. However, if you want your own hashing implementation – for example, if your type has many properties but you know that one of them was enough to identify it uniquely – you still need to write your own code using whatever algorithm you thought was best.

Swift 4.2 introduces a new `Hasher` struct that provides a randomly seeded, universal hash function to make this process easier:

```swift
struct iPad: Hashable {
    var serialNumber: String
    var capacity: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(serialNumber)
    }
}
```

You can add more properties to your hash by calling `combine()` repeatedly, and the order in which you add properties affects the finished hash value.

You can also use `Hasher` as a standalone hash generator: just provide it with whatever values you want to hash, then call `finalize()` to generate the final value. For example:

```swift
let first = iPad(serialNumber: "12345", capacity: 256)
let second = iPad(serialNumber: "54321", capacity: 512)

var hasher = Hasher()
hasher.combine(first)
hasher.combine(second)
let hash = hasher.finalize()
```

`Hasher` uses a random seed every time it hashes an object, which means the hash value for any object is effectively guaranteed to be different between runs of your app.

This in turn means that elements you add to a set or a dictionary are highly likely to have a different order each time you run your app.

####7.Checking sequence elements match a condition

[SE-0207](https://github.com/apple/swift-evolution/blob/master/proposals/0207-containsOnly.md) provides a new `allSatisfy()` method that checks whether all items in a sequence pass a condition.

For example, if we had an array of exam results like this:

```swift
let scores = [85, 88, 95, 92]
```

We could decide whether a student passed their course by checking whether all their exam results were 85 or higher:

```swift
let passed = scores.allSatisfy { $0 >= 85 }
```

####8.In-place collection element removal

[Watch the video](https://www.youtube.com/watch?v=GwsoV8DqDkc)

[SE-0197](https://github.com/apple/swift-evolution/blob/master/proposals/0197-remove-where.md) introduces a new `removeAll(where:)` method that performs a high-performance, in-place filter for collections. You give it a closure condition to run, and it will strip out all objects that match the condition.

For example, if you have a collection of names and want to remove people called “Terry”, you’d use this:

```swift
var pythons = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
pythons.removeAll { $0.hasPrefix("Terry") }
print(pythons)
```

Now, you might very well think that you could accomplish that by using `filter()` like this:

```swift
pythons = pythons.filter { !$0.hasPrefix("Terry") }
```

However, that doesn’t use memory very efficiently, it specifies what you *don’t* want rather than what you *want*, and more advanced in-place solutions come with a range of complexities that are off-putting to novices. Ben Cohen, the author of SE-0197, gave a talk at [dotSwift 2018](https://www.dotconferences.com/2018/01/ben-cohen-extending-the-standard-library)where he discussed the implementation of this proposal in more detail – if you’re keen to learn why it’s so efficient, you should start there!

####9.Boolean toggling

[Watch the video](https://www.youtube.com/watch?v=qmI6lnxfYrk)

[SE-0199](https://github.com/apple/swift-evolution/blob/master/proposals/0199-bool-toggle.md) introduces a new `toggle()` method to booleans that flip them between true and false..

The entire code to implement proposal is only a handful of lines of Swift:

```swift
extension Bool {
   mutating func toggle() {
      self = !self
   }
}
```

However, the end result makes for much more natural Swift code:

```swift
var loggedIn = false
loggedIn.toggle()
```

As noted in the proposal, this is particularly useful in more complex data structures: `myVar.prop1.prop2.enabled.toggle()` avoids the potential typing errors that could be caused using manual negation.

The proposal makes Swift easier and safer to write, and is purely additive, so I think most folks will switch to using it quickly enough.