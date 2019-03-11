/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Comparing tuples

A tuple is simply a comma-separated list of values, where each value may or may not be named. For example:
*/
let singer = ("Taylor", "Swift")
let alien = ("Justin", "Bieber")
/*:
In older versions of Swift, you couldn't compare two tuples without writing some unwieldy code like this:
*/
func ==  (t1: (T, T), t2: (T, T)) -> Bool {
    return t1.0 == t2.0 && t1.1 == t2.1
}
/*:
It's not very user-friendly to require that kind of boilerplate code, and of course it would only work for tuples that have exactly two elements. In Swift 2.2, you no longer need to write that code because tuples can be compared directly:
*/
let singer = ("Taylor", "Swift")
let alien = ("Justin", "Bieber")

if singer == alien {
    print("Matching tuples!")
} else {
    print("Non-matching tuples!")
}
/*:
Swift 2.2's automatic tuple comparison works with tuples with two elements just like the function we wrote, but it also works with tuples of other sizes – up to arity 6, which means a tuple that contains six elements.

(In case you were wondering: "arity" is pronounced like "arrity", but "tuple" is pronounced any number of ways: "toople", "tyoople" and "tupple" are all common.)

You can see how tuple comparison works by changing our two tuples like this:
*/
let singer = ("Taylor", 26)
let alien = ("Justin", "Bieber")
/*:
Be prepared for a very long error message from Xcode, but the interesting part comes near the end:
*/
note: overloads for '==' exist with these partially matching parameter lists: ......
((A, B), (A, B)), ((A, B, C), (A, B, C)), ((A, B, C, D), (A, B, C, D)), ((A, B, C, D, E), (A, B, C, D, E)), ((A, B, C, D, E, F), (A, B, C, D, E, F))
/*:
As you can see, Swift literally has functions to compare tuples all the way up to `(A, B, C, D, E, F)`, which ought to be more than enough.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/
