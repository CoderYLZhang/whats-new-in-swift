/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Implicit bridging has been reduced

Prior to Swift 1.2 bridging from Objective-C types to Swift types happened implicitly, meaning that you could use the two interchangeable. From Swift 1.2 onwards you must now use `as` to typecast these yourself. For example:
*/
authenticateUser(yourNSString as String)
/*:
- important:  This has changed in later versions of Swift – implicit bridging never happens now.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/