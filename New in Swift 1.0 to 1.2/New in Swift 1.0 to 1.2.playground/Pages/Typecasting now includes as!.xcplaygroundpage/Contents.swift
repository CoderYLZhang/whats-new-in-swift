/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)
# Typecasting now includes `as!`

From Swift 1.2 onwards we have three ways of performing typecasts: `as` is used for typecasts that will always succeed (e.g. `someString as NSString`), `as?` is used for typecasts that might fail (e.g. `someView as? UIImageView`), and `as!` is used to force typecasts. If you use `as!` and you're wrong, your code will crash.

For example:
*/
let submitButton = vw.viewWithTag(10) as! UIButton
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)
*/