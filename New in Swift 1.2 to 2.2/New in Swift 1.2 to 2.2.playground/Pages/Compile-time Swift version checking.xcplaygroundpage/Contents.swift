/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)
# Compile-time Swift version checking

Swift 2.2 adds a new build configuration option that makes it easy to combine code code written in versions of Swift into a single file. This might seem unnecessary, but spare a thought to people who write libraries in Swift: do they target Swift 2.2 and hope everyone is using it, or target Swift 2.0 and hope users can upgrade using Xcode?

Using the new build option lets you write two different flavours of Swift, and the correct one will be compiled depending on the version of the Swift compiler.

For example:
*/
#if swift(>=2.2)
print("Running Swift 2.2 or later")
#else
print("Running Swift 2.1 or earlier")
#endif
/*:
Just like the existing `#if os()` build option, this adjusts what code is produced by the compiler: if you're using a Swift 2.2 compiler, the second `print()` line won't even be seen. This means you can use utter gibberish if you want:
*/
#if swift(>=2.2)
print("Running Swift 2.2 or later")
#else
THIS WILL COMPILE JUST FINE IF YOU'RE
USING A SWIFT 2.2 COMPILER BECAUSE
THIS BIT IS COMPLETELY IGNORED!
#endif
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)
*/