/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# One-sided ranges

Last but not least, Swift 4 introduces Python-like one-sided collection slicing, where the missing side is automatically inferred to be the start or end of the collection. This has no effect on existing code because it's a new use for the existing operator, so you don't need to worry about potential breakage.

Here's an example:
*/
let characters = ["Dr Horrible", "Captain Hammer", "Penny", "Bad Horse", "Moist"]
let bigParts = characters[..<3]
let smallParts = characters[3...]
print(bigParts)
print(smallParts)
/*:
That code will print out `["Dr Horrible", "Captain Hammer", "Penny"]` then `["Bad Horse", "Moist"]`.

For more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0172-one-sided-ranges.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/