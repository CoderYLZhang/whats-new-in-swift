/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Classes can now have static methods and properties

Swift 1.2 gives us an alias for class final properties: `static`. While class variables may be overridden in subclasses, static variables may not. For example:
*/
class Student: Person {
    // THIS ISN'T ALLOWED
    override static var count: Int {
        return 150
    }

    // THIS IS ALLOWED
    override class var averageAge: Double {
        return 19.5
    }
}
/*:
In this usage, `static var` is merely an alias for `final class var`.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/