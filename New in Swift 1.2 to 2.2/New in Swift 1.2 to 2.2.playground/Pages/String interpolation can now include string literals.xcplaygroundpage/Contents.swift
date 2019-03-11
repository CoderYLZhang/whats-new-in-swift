/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# String interpolation can now include string literals

Using quote marks inside strings caused problems before Swift 2.1, which meant that using string literals inside string interpolation was also difficult. This has been fixed in Swift 2.1, so this kind of code works fine now:
*/
print("Hello, \(username ?? "Anonymous")")
/*:
This means it's also possible to read dictionary keys using string interpolation, like this:
*/
print("Hello, \(user["name"]!)")
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/