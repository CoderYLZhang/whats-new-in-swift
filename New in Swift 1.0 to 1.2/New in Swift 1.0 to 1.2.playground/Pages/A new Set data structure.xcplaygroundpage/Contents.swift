/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# A new `Set` data structure

Swift 1.2 introduced a new `Set` type that works similarly to `NSSet` except with value semantics. Sets work similarly to arrays except they are not ordered and do not store any element more than once. For example:
*/
var starships = Set<String>()
starships.insert("Serenity")
starships.insert("Enterprise")
starships.insert("Executor")
starships.insert("Serenity")
starships.insert("Serenity")
/*:
Even though that code tries to insert Serenity three times, it will only be stored in the set once.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/