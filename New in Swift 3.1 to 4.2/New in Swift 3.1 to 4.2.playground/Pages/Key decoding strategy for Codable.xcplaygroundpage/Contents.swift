/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Key decoding strategy for `Codable`

In Swift 4.0 a common problem was trying to use `Codable` with JSON that utilized snake_case for its key names rather than the camelCase we normally use in Swift. Codable was unable to understand how the two different name types were mapped, so you had to create a custom `CodingKeys` enum helping it out.

This is where Swift 4.1's new `keyDecodingStrategy` property comes in: it’s set to `.useDefaultKeys` by default, which does a direct mapping of JSON names to Swift properties. However, if you change it to `.convertFromSnakeCase` then `Codable` handles the name conversion for us.

For example:
*/
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

do {
    let macs = try decoder.decode([Mac].self, from: jsonData)
    print(macs)
} catch {
    print(error.localizedDescription)
}
/*:
When you want to go back the other way – to convert a `Codable` struct with camelCase properties back to JSON with snake_case keys, set the `keyEncodingStrategy` to `.convertToSnakeCase` like this:
*/
let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
let encoded = try encoder.encode(someObject)
/*:
- important:  At the time of writing `keyDecodingStrategy` and `keyEncodingStrategy` are not available on Linux.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/