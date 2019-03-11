/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Renamed debug identifiers: `#line`, `#function`, `#file`

Swift 2.1 and earlier used the "screaming snake case" symbols `__FILE__`, `__LINE__`, `__COLUMN__`, and `__FUNCTION__`, which automatically get replaced the compiler by the filename, line number, column number and function name where they appear.

In Swift 2.2, those old symbols have been replaced with `#file`, `#line`, `#column` and `#function`, which will be familiar to you if you've already used [Swift 2.0's #available](https://www.hackingwithswift.com/new-syntax-swift-2-availability-checking) to check for iOS features. As the official Swift review says, it also introduces "a convention where # means invoke compiler substitution logic here."

Here’s how the debug identifiers in action from Swift 2.2 and later:
*/
func printGreeting(name: String, repeat repeatCount: Int) {
    print("This is on line \(#line) of \(#function)")

    let upperName = name.uppercaseString

    for _ in 0 ..< repeatCount {
        print(upperName)
    }
}

printGreeting("Taylor", repeat: 5)
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/