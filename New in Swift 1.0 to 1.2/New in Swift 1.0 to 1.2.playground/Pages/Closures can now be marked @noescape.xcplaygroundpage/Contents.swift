/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Closures can now be marked `@noescape`

Closures are reference types, which means Swift must quietly add memory management calls when they are passed into functions. To avoid adding unwanted work, you can now mark closure parameters with the `@noescape` keyword, which tells Swift the closure will be used before the function returns – it doesn't need to retain or release the closure.

As an example, this function checks whether a password that we have stored matches a password the user just entered, but it does this using a closure so that you can give it any encryption code you like. This closure is used immediately inside the function, so `@noescape` may be used as a performance optimization:
*/
func checkPassword(encryption: @noescape (String) -> ()) -> Bool {
    if closure(enteredPassword) == storedPassword {
        return true
    } else {
        return false
    }
}
/*:
- important:  This has changed in later versions of Swift – all closures are considered to be non-escaping by default.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/