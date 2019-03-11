/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Traditional C-style for loops are deprecated

This changed outlawed the following syntax in Swift:
*/
for var i = 1; i <= 10; i += 1 {
    print("\(i) green bottles")
}
/*:
These are called C-style for loops because they have long been a feature of C-like languages, and conceptually even pre-date C by quite a long way.

Although Swift is (just about!) a C-like language, it has a number of newer, smarter alternatives to the traditional for loop. The result: this construct was deprecated in Swift 2.2 and will be removed "in a future version of Swift."

To replace these old for loops, use one of the many alternatives. For example, the "green bottles" code above could be rewritten to loop over a range, like this:
*/
for i in 1...10 {
    print("\(i) green bottles")
}
/*:
Remember, though, that it's a bad idea to create a range where the start is higher than the end: your code will compile, but it will crash at runtime. So, rather than writing this:
*/
for i in 10...1 {
    print("\(i) green bottles")
}
/*:
…you should write this instead:
*/
for i in (1...10).reverse() {
    print("\(i) green bottles")
}
/*:
Another alternative is just to use regular fast enumeration over an array of items, like this:
*/
var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

for number in array {
    print("\(number) green bottles")
}
/*:
Although if you want to be technically correct (also known as "the best kind of correct") you would write such a beast like this:
*/
var array = Array(1...10)

for number in array {
    print("\(number) green bottles")
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/