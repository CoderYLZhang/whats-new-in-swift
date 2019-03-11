/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# The `flatMap()` method transforms optionals and arrays

The `flatMap()` method is designed to allow you to transform optionals and elements inside a collection while also decreasing the amount of containment that happens. For example, if you transform an optional in a way that will also return an optional, using `map()` would give you an optional optional (a double optional), whereas `flatMap()` is able to combine those two optionals into a single optioanl.
*/
let lengthOfFirst = names.first.flatMap { count($0) }
/*:
Decreasing the amount of containment also makes `flatMap()` a simple way of converting multi-dimensional arrays into single-dimensional arrays:
*/
[[1, 2], [3, 4], [5, 6]].flatMap { $0 }
/*:
There is no "map" operation there, so we're just left with the flattening behavior – that will result in a single array containing the value `[1, 2, 3, 4, 5, 6]`.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/