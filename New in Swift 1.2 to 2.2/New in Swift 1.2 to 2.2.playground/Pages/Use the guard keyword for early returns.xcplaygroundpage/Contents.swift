/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Use the `guard` keyword for early returns

It's very common to place some conditional checks at the start of a method to ensure that various data is configured ready to go. For example, if a Submit button is tapped, you might want to check that the user has entered a username in your user interface. To do this, you'd use this code:
*/
func submitTapped() {
    guard username.text.characters.count > 0 else {
        return
    }

    print("All good")
}
/*:
Using `guard` might not seem much different to using `if`, but with `guard` your intention is clearer: execution should not continue if your conditions are not met. Plus it has the advantage of being shorter and more readable, so `guard` is a real improvement, and I'm sure it will be adopted quickly.

There is one bonus to using `guard` that might make it even more useful to you: if you use it to unwrap any optionals, those unwrapped values stay around for you to use in the rest of your code block. For example:
*/
guard let unwrappedName = userName else {
    return
}

print("Your username is \(unwrappedName)")
/*:
This is in comparison to a straight `if` statement, where the unwrapped value would be available only inside the `if` block, like this:
*/
if let unwrappedName = userName {
    print("Your username is \(unwrappedName)")
} else {
    return
}

// this won't work – unwrappedName doesn't exist here!
print("Your username is \(unwrappedName)")
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/