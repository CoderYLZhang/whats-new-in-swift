/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Multiple `if let` bindings

You may now place multiple `if let` bindings on a single line separated by a comma, rather than embed them in increasingly indented pyramids.

For example, previously you would write code like this:
*/
if let user = loadUsername() {
    if let password = decryptPassword() {
        authenticate(user, password)
    }
}
/*:
As of Swift 1.2 you can write this:
*/
if let user = loadUsername(), let password = decryptPassword() {
    authenticate(user, password)
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/