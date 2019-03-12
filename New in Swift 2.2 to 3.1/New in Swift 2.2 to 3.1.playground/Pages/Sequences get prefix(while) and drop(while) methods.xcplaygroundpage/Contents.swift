/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)
# Sequences get `prefix(while:)` and `drop(while:)` methods

Two useful new methods have been added to the `Sequence` protocol: `prefix(while:)` and `drop(while:)`. The former returns the longest subsequence that satisfies a predicate, which is a fancy way of saying that you give it a closure to run on every item, and it will go through all the elements in the sequence and return those that match the closure – but will stop as soon as it finds a non-matching element.

Let's take a look at a code example:
*/
let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let prefixed = names.prefix { $0.hasPrefix("Michael") }
print(prefixed)
/*:
That uses the `hasPrefix()` method to return the subsequence `["Michael Jackson", "Michael Jordan", "Michael Caine"` – the first three elements in the sequence. It won't include "Michael Douglas", because that comes after the first non-Michael. If you wanted _all_ the Michaels regardless of their position, you should use `filter()` instead.

The second new method, `drop(while:)` is effectively the opposite: it finds the longest subsequence that satisfies your predicate, then returns everything _after_ it. For example:
*/
let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let dropped = names.drop { $0.hasPrefix("Michael") }
print(dropped)
/*:
That will return the subsequence `["Taylor Swift", "Adele Adkins", "Michael Douglas"]` – everything after the initial Michaels.

&nbsp;

[< Previous](@previous)           [Home](Introduction)
*/