/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Swifty encoding and decoding

We know value types are great, but we also know they interact terribly with Objective-C APIs such as `NSCoding` – you either need to write a shim layer or give in and use classes, both of which are unpleasant. Worse, even if you give in and switch to classes, you still need to write your encoding and decoding methods by hand, which is painful and error-prone.

Swift 4 introduces a new `Codable` protocol that lets you serialize and deserialize custom data types without writing any special code – and without having to worry about losing your value types. Even better, you can choose how you want the data to be serialized: you can use classic property list format or even JSON.

Let's take a look at how beautiful this is. First, here's a custom data type and some instances of it:
*/
struct Language: Codable {
    var name: String
    var version: Int
}

let swift = Language(name: "Swift", version: 4)
let php = Language(name: "PHP", version: 7)
let perl = Language(name: "Perl", version: 6)
/*:
You can see I've marked the `Language` struct as conforming to the `Codable` protocol. With that one tiny addition, we can convert it to a `Data` representation of JSON like this:
*/
let encoder = JSONEncoder()
if let encoded = try? encoder.encode(swift) {
    // save `encoded` somewhere
}
/*:
Swift will automatically encode all properties inside your data type – you don't need to do anything.

Now, if you're like me and have a long history of using `NSCoding`, you're probably somewhat doubtful: is that really all it takes, and how can we be sure it's working? Well, let's add some more code to try converting the `Data` object into a string so we can print it out, then decode it back into a new `Language` instance that we can read from:
*/
if let encoded = try? encoder.encode(swift) {
    if let json = String(data: encoded, encoding: .utf8) {
        print(json)
    }

    let decoder = JSONDecoder()
    if let decoded = try? decoder.decode(Language.self, from: encoded) {
        print(decoded.name)
    }
}
/*:
Notice how decoding doesn't require a typecast – you provide the data type name as its first parameter, so Swift infers the return type from there.

Both `JSONEncoder` and its property list counterpart `PropertyListEncoder` have lots of options for customizing how they work: do you want compact JSON or pretty-printed JSON? Do you want to use ISO8601 dates or Unix epoch dates? Do you want to use binary property lists or XML? For more information on these and other options, see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0167-swift-encoders.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/