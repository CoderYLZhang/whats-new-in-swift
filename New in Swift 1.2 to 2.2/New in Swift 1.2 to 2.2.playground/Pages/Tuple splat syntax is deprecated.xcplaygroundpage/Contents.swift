/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Tuple splat syntax is deprecated

Another feature that has been deprecated is one that has been part of Swift since 2010 (yes, years before it launched). It's been named "the tuple splat", and not many people were using it. It's partly for that reason – although mainly because it introduces all sorts of ambiguities when reading code – that this syntax is being deprecated.

In case you were curious – and let's face it, you probably are – here's an example of tuple splat syntax in action:
*/
func describePerson(name: String, age: Int) {
    print("\(name) is \(age) years old")
}

let person = ("Taylor Swift", age: 26)
describePerson(person)
/*:
But remember: don't grow too fond of your new knowledge, because tuple splats are deprecated in Swift 2.2 and will be removed entirely in a later version.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/