/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# More keywords can be used as argument labels

Argument labels are a core feature of Swift, and let us write code like this:
*/
for i in 1.stride(through: 9, by: 2) {
    print(i)
}
/*:
Without the `through` or `by` labels, this code would lose its self-documenting nature: what do the 9 and 2 do in `1.stride(9, 2)`? In this example, Swift also uses the argument labels to distinguish `1.stride(through: 9, by: 2)` from `1.stride(to: 9, by: 2)`, which produces different results.

As of Swift 2.2, you can now use a variety of language keywords as these argument labels. You might wonder why this would be a good thing, but consider this code:
*/
func printGreeting(name: String, repeat repeatCount: Int) {
    
    for _ in 0 ..< repeatCount {
        print(name)
    }
}

printGreeting("Taylor", repeat: 5)
/*:
That uses `repeat` as an argument label, which makes sense because the function will print a string a number of times. Because `repeat` is a keyword, this code would not work before Swift 2.2 – you would need to write `repeat` instead, which is unpleasant.

Note that there are still some keywords that may not be used, specifically `var`, `let` and `inout`.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/
