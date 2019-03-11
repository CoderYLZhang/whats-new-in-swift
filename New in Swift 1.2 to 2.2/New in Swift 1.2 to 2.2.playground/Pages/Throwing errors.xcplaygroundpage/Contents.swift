/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Throwing errors

`try/catch` is a way of programming that means "try this thing, but if it fails do this other thing instead." Swift uses enums for error types so that it can ensure your error catching is exhaustive, just like with `switch` statements. So for example, you might define your error list something like this:
*/
enum MyError: ErrorType {
    case UserError
    case NetworkError
    case DiscoverydError
}
/*:
Notice how my error type builds on the built-in `ErrorType` protocol; this is required.

Once you've defined the various errors you want to work with, it's time to introduce three new keywords: `throws`, `try`, `do` and `catch`.

First up, `throws` is a simple keyword that you add to your method to tell Swift it might fail. You put it right before where you put your method's return type, like this:
*/
func doStuff() throws -> String {
/*:
Once that's done, you cannot call that method unless your code is written to handle any errors it throws – Xcode simply won't compile. When you want to throw an error from inside your methods, you just write `throw` followed by the type of error you want to throw, like this:
*/
func doStuff() throws -> String {
    print("Do stuff 1")
    print("Do stuff 2")
    throw MyError.NetworkError

    return "Some return value"
}
/*:
The dummy `print()` calls are there so you can follow the program flow, as you'll see in a moment.

But first, on to the next keyword: `try`. This is placed before any call to a method that throws an error, like this:
*/
try doStuff()
/*:
This literally writes into your code "I acknowledge that this code might fail," so it's effectively syntactic sugar to ensure safety. But even with that your code still won't compile, because you don't catch the errors: you need to use `do` and `catch`.

Catching errors has two forms: catching specific errors and catching all errors. You can mix and match, meaning your code can say "if the error is X, I want to handle it like this; all other errors should be handled this other way."

Here's a very basic example showing how to catch all errors:
*/
do {
    try doStuff()
    print("Success")
} catch {
    print("An error occurred.")
}
/*:
If you remember, we made the `doStuff()` method print "Do stuff 1" then "Do stuff 2" before throwing a network error. So, what will happen is:

*   "Do stuff 1" will be printed
*   "Do stuff 2" will be printed
*   The NetworkError error will be thrown, immediately exiting the `doStuff()` method – its return statement will never be reached
*   Control will jump to the `catch` block
*   "An error occurred" will be printed

To be clear: in the code above, "Success" will never be printed – as soon as any `try` methods throw an error, execution stops and jumps to the `catch` block.

As I said, you can mix and match generic and specific `catch` blocks, but you do need to be sure that all possible errors are caught. For example, this will execute one chunk of code for NetworkError errors, and another chunk for all other errors:
*/
do {
    try doStuff()
    print("Success")
} catch MyError.NetworkError {
    print("A network error occurred")
} catch {
    print("An error occurred")
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/