/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Constants no longer require immediate initialization

Constants may be set only once, but Swift 1.2 allows us to create constants without initializing them immediately. For example:
*/
let username: String

if authenticated {
    username = fetchUsername()
} else {
    username = "Anonymous"
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/