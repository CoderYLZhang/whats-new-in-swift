/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# The `zip()` function joins two sequences

If you have two sequences that you'd like to join together, the `zip()` function will do just that and return an array of tuples. For example:
*/
let names = ["Sophie", "Charlotte", "John"]
let scores = [90, 92, 95]
let zipped = zip(names, scores)
/*:
That will output an array of the tuples ("Sophie", 90), ("Charlotte", 92), and ("John", 95).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/