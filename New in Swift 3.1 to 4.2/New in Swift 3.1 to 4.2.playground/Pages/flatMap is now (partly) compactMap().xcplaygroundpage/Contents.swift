/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# `flatMap` is now (partly) `compactMap()`

The `flatMap()` method was useful for a variety of things in Swift 4.0, but one was particularly useful: the ability to transform each object in a collection, then remove any items that were nil.

[Swift Evolution proposal SE-0187](https://github.com/apple/swift-evolution/blob/master/proposals/0187-introduce-filtermap.md) suggested changing this, and as of Swift 4.1 this `flatMap()` variant has been renamed to `compactMap()` to make its meaning clearer.

For example:
*/
let array = ["1", "2", "Fish"]
let numbers = array.compactMap { Int($0) }
/*:
That will create an `Int` array containing the numbers 1 and 2, because "Fish" will fail conversion to `Int`, return nil, and be ignored.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/