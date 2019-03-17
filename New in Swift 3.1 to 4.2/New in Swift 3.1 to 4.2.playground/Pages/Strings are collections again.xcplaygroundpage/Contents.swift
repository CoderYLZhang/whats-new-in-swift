/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Strings are collections again

This is a small change, but one guaranteed to make a lot of people happy: strings are collections again. This means you can reverse them, loop over them character-by-character, `map()` and `flatMap()` them, and more. For example:
*/
let quote = "It is a truth universally acknowledged that new Swift versions bring new features."
let reversed = quote.reversed()

for letter in quote {
    print(letter)
}
/*:
This change was introduced as part of a broad set of amendments called the [String Manifesto](https://github.com/apple/swift/blob/master/docs/StringManifesto.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/