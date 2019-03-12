/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Verbs and nouns

This is the part where some people will start to drift off in confusion, which is a shame because it's important.

Here's are some quotes from the Swift API guidelines:

*   "When the operation is naturally described by a verb, use the verb’s imperative for the mutating method and apply the “ed” or “ing” suffix to name its nonmutating counterpart"
*   "Prefer to name the nonmutating variant using the verb’s past participle"
*   "When adding “ed” is not grammatical because the verb has a direct object, name the nonmutating variant using the verb’s present participle"
*   "When the operation is naturally described by a noun, use the noun for the nonmutating method and apply the “form” prefix to name its mutating counterpart"

Got that? It's no surprise that Swift's rules are expressed using lingustic terminology – it is after all a language! – but this at least gives me a chance to feel smug that I did a second degree in English. What it means is that many methods are changing names in subtle and sometimes confusing ways.

Let's start with a couple of simple examples:
*/
myArray.enumerate()
myArray.enumerated()

myArray.reverse()
myArray.reversed()
/*:
Each time Swift 3 modifies the method by adding a "d" to the end: this is a value that's being returned.

These rules are mostly innocent enough, but it causes confusion when it comes to array sorting. Swift 2.2 used `sort()` to return a sorted array, and `sortInPlace()` to sort an array in place. In Swift 3.0, `sort()` is renamed to `sorted()` (following the examples above), and `sortInPlace()` is renamed to `sort()`.

**TL;DR: This means you need to be careful because in Swift 2.2 `sort()` returned a sorted array, but in Swift 3.0 `sort()` sorts the array in place.**

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/