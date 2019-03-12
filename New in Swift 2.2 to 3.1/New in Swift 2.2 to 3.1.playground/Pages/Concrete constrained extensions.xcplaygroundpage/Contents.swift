/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Concrete constrained extensions

Swift lets us extend types using constraints, which is a powerful and expressive way to add functionality. To demonstrate this, let's look at a worked example in Swift 3.0 that modifies collections to do something trivial:
*/
extension Collection where Iterator.Element: Comparable {
    func lessThanFirst() -> [Iterator.Element] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
/*:
That adds a new method called `lessThanFirst()`, which returns all items in a collection that are less than the first item. So, using it with the array `[5, 6, 10, 4, 110, 3]` will return `[4, 3]`.

That code extends a protocol (`Collection`) only where it matches a constraint: elements in the collection must conform to another protocol, `Comparable`. This alone is powerful stuff, but let's take it back a step: what if we wanted something a bit more specific? Swift 3.0 lets us extend a concrete type rather than the protocol `Collection`, so instead we could write this:
*/
extension Array where Element: Comparable {
    func lessThanFirst() -> [Element] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
/*:
That extends a concrete type (only `Array`) but still using a protocol for its constraint. What if we wanted to go even more specific – extend a concrete type with a concrete constraint, for example only arrays that contains integers? Well, it turns out that isn't possible in Swift 3.0, which usually strikes people as odd: if Swift 3.0 can handle extending protocols with another protocol as a constraint, then surely extending a specific type with a specific constraint should be a cinch?

Fortunately, this discrepancy has been removed in Swift 3.1, which means we can now write code like this:
*/
extension Array where Element == Int {
    func lessThanFirst() -> [Int] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
/*:
That extends a concrete type (only `Array`) and uses a concrete constraint (only where the elements are `Int`).

Now, obviously we're using a trivial example here – in your own code this is going to be significantly more useful when you want to extend arrays containing your own custom structs.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/