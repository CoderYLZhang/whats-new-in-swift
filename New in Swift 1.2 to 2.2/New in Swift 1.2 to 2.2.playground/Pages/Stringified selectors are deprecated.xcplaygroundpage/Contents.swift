/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Stringified selectors are deprecated

One unwelcome quirk of Swift before 2.2 was that selectors could be written as strings, like this:
*/
navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tap!", style: .Plain, target: self, action: "buttonTaped")
/*:
If you look closely, I wrote `"buttonTaped"` rather than `"buttonTapped"`, but Xcode wasn't able to notify me of my mistake if either of those methods didn't exist.

This has been resolved as of Swift 2.2: using strings for selectors has been deprecated, and you should now write `#selector(buttonTapped)` in that code above. If the `buttonTapped()` method doesn't exist, you'll get a compile error – another whole class of bugs eliminated at compile time!

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/