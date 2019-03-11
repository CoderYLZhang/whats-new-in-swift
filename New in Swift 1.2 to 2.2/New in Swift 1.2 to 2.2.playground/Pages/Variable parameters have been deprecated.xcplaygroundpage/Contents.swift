/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Variable parameters have been deprecated

Another deprecation, but again with good reason: `var` parameters are deprecated because they offer only marginal usefulness, and are frequently confused with `inout`.

To give you an example, here is the `printGreeting()` function modified to use `var`:
*/
func printGreeting(var name: String, repeat repeatCount: Int) {
    name = name.uppercaseString

    for _ in 0 ..< repeatCount {
        print(name)
    }
}

printGreeting("Taylor", repeat: 5)
/*:
The differences there are in the first two lines: `name` is now `var name`, and `name` gets converted to uppercase so that "TAYLOR" is printed out five times.

Without the `var` keyword, `name` would have been a constant and so the `uppercaseString` line would have failed.

The difference between `var` and `inout` is subtle: using `var` lets you modify a parameter inside the function, whereas `inout` causes your changes to persist even after the function ends.

As of Swift 2.2, `var` is deprecated, and it's slated for removal in Swift 3.0\. If this is something you were using, just create a variable copy of the parameter inside the method, like this:
*/
func printGreeting(name: String, repeat repeatCount: Int) {
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