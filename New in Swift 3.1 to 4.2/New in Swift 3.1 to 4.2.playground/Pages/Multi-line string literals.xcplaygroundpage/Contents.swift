/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Multi-line string literals

Writing multi-line strings in Swift has always meant adding `\n` inside your strings to add line breaks wherever you want them. This doesn't look good in code, but at least it displays correctly for users. Fortunately, Swift 4 introduces new multi-line string literal syntax that lets you add line breaks freely and use quote marks without escaping, while still benefiting from functionality like string interpolation.

To start a string literal, you need to write three double quotation marks: `"""` then press return. You can then go ahead and write a string as long as you want, including variables and line breaks, before ending your string by pressing return then writing three more double quotation marks.

String literals have two important rules: when you open a string using `"""` the content of your string must begin on a new line, and when you end a multi-line string using `"""` that must also begin on a new line.

Here it is in action:
*/
let longString = """
When you write a string that spans multiple
lines make sure you start its content on a
line all of its own, and end it with three
quotes also on a line of their own.
Multi-line strings also let you write "quote marks"
freely inside your strings, which is great!
"""
/*:
That creates a new string with several line breaks right there in the definition – much easier to read _and_ write.

For more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0168-multi-line-string-literals.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/