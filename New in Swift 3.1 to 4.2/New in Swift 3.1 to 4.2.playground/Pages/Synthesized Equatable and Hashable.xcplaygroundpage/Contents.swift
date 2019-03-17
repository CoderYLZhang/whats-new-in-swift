/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Synthesized Equatable and Hashable

The `Equatable` protocol allows Swift to compare one instance of a type against another. When we say `5 == 5`, Swift understands what that means because `Int` conforms to `Equatable`, which means it implements a function describing what `==` means for two instances of `Int`.

Implementing `Equatable` in our own value types allows them to work like Swift’s strings, arrays, numbers, and more, and it’s usually a good idea to make your structs conform to `Equatable` just so they fit the concept of value types better.

However, implementing `Equatable` can be annoying. Consider this code:
*/
struct Person {
    var firstName: String
    var lastName: String
    var age: Int
    var city: String
}
/*:
If you have two instances of `Person` and want to make sure they are identical, you need to compare all four properties, like this:
*/
struct Person: Equatable {
    var firstName: String
    var lastName: String
    var age: Int
    var city: String

    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age && lhs.city == rhs.city
    }
}
/*:
Even _reading_ that is tiring, never mind _writing_ it.

Fortunately, Swift 4.1 can synthesize conformance for `Equatable` – it can generate an `==` method automatically, which will compare all properties in one value with all properties in another, just like above. So, all you have to do now is add `Equatable` as a protocol for your type, and Swift will do the rest.

Of course, if you _want_ you can implement `==` yourself. For example, if your type has an `id` field that identifies it uniquely, you would write `==` to compare that single value rather than letting Swift do all the extra work.

Swift 4.1 also introduces synthesized support for the `Hashable` protocol, which means it will generate a `hashValue` property for conforming types automatically. `Hashable` was always annoying to implement because you need to return a unique (or at least mostly unique) hash for every object. It’s important, though, because it lets you use your objects as dictionary keys and store them in sets.

Previously we’d need to write code like this:
*/
var hashValue: Int {
    return firstName.hashValue ^ lastName.hashValue &* 16777619
}
/*:
For the most part that’s no longer needed in Swift 4.1, although as with `Equatable` you might still want to write your own method if there’s something specific you need.

- important:  You still need to opt in to these protocols by adding a conformance to your type, and using the synthesized code does require that all properties in your type conform to `Equatable` or `Hashable` respectively.

For more information, see [Swift Evolution proposal SE-0185](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/