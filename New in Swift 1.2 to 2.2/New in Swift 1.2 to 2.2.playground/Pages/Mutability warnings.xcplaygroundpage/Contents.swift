/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Mutability warnings

This is a simple change that is going to go a long way to help code readability. As you know, Swift developers prefer declaring things as constants (using `let`) rather than variables (using `var`). But what if you made something a variable by accident? Or if you thought you might need to change it, then never do?

As of Xcode 7 and Swift 2, you'll get warnings in your code whenever you declare variables that never change – Xcode literally examines the way you use the variable and knows if you never change it.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/