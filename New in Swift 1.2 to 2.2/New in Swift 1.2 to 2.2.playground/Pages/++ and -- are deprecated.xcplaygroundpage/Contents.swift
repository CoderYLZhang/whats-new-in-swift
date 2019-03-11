/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# `++` and `--` are deprecated

Swift 2.2 formally deprecates the `++` and `--` operators, which means they still work but you'll get a warning when you use them. Deprecation is usually a first step towards removing something entirely, and in this case both of these operators will be removed in Swift 3.0.

In their place, you need to use `+= 1` and `-= 1` instead. These operators have been there all along, and are not going away.

You might wonder why two long-standing operators are being removed, particularly when they exist in C, C#, Java, and – critically to its "joke" – C++. There are several answers, not least:

1.  Writing `++` rather than `+= 1` is hardly a dramatic time saving
2.  Although it's easy once you know it, `++` doesn't have an obvious meaning to people learning Swift, whereas `+=` at least reads as "add and assign."
3.  C-style loops – one of the most common situations where `++` and `--` were used – have also been deprecated, which brings me on to my next point…

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/