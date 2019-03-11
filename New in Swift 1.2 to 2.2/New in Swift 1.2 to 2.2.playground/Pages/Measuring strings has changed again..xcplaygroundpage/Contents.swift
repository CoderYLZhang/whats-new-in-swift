/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Measuring strings has changed again.

In Swift 2.2 the way strings are measured changed yet again. What was `countElements()` became `count()` in Swift 1.1, and in Swift 2.0 was removed entirely. 

Instead, you should access the `characters` property of your String, then call `count` on that, like this:
*/
let string = "Hello, Swift!"
let count = string.characters.count
print(count)
/*:
- important:  This has changed in later versions of Swift – you should access the `count` property of strings directly.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/