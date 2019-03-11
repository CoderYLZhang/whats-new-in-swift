/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Checking API availability

One regular problem that iOS developers hit is that we need to be careful when using new APIs – if you try and use `UIStackView` on iOS 8, for example, your app will crash. In the olden days, Objective C developers would write code like this:
*/
NSClassFromString(@"UIAlertController") != nil
/*:
That means, "if the UIAlertController class exists," which was a way of checking if we were running on iOS 8 or later. But because Xcode didn't know that was our goal, it couldn't ensure we got things right. Well, this is fixed with Swift 2, because you can now write code like this:
*/
if #available(iOS 9, *) {
    let stackView = UIStackView()
    // do stuff
}
/*:
The magic happens with `#available`: it will automatically check whether we are running on iOS 9 or later, and, if so, will run the code with the `UIStackView`. The `*` after "iOS 9" is there as a catch all for any future platforms that Apple introduces, and it's required.

So, `#available` is cool, but even better is the fact that you can give it an `else` block and, because Xcode now knows this block will only execute if the device is iOS 8 or earlier, it can warn you if you new APIs. For example, if you wrote something like this:
*/
if #available(iOS 9, *) {
    // do cool iOS 9 stuff
} else {
    let stackView = UIStackView()
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/