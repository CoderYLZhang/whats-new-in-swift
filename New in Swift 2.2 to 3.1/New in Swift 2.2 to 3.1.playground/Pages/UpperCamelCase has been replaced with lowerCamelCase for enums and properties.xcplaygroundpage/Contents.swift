/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# UpperCamelCase has been replaced with lowerCamelCase for enums and properties

Although syntactically irrelevant, the capital letters we use to name classes and structs, properties, enums, and more have always followed a convention fairly closely: classes, structs, and enums use UpperCamelCase (MyStruct, WeatherType.Cloudy), properties and parameter names use lowerCamelCase (emailAddress, requestString).

I say "fairly closely" because there are some exceptions that are going to _stop_ being exceptions in Swift 3: properties and parameters that started with initials in Swift 2.2 will now used lowerCamelCase in Swift 3.

Sometimes this isn't too strange: Swift 2.2 created `NSURLRequest` objects using `NSURLRequest(URL: someURL)` – note the capital "URL". Swift 3 rewrites that to `URLRequest(url: someURL)`, and also means you'll use things like `webView.request?.url?.absoluteString` for reading the URL of a web view.

Where it's a bit more jarring is when only part of the property name is in caps, e.g. `CGColor` or `CIColor`. Yes, you've guessed it: they become `cgColor` and `ciColor` in Swift 3, so you'll be writing code like this:
*/
let red = UIColor.red.cgColor
/*:
This change does help drive consistency: all properties and parameters should start with a lowercase letter, no exceptions.

At the same time enum cases are also changing, moving from UpperCamelCase to lowerCamelCase. This makes sense: an enum is a data type (like a struct), but enum values are closer to properties. However, it does mean that wherever you've used an Apple enum, it will now be lowercase. So:
*/
UIInterfaceOrientationMask.Portrait // old
UIInterfaceOrientationMask.portrait // new

NSTextAlignment.Left // old
NSTextAlignment.left // new

SKBlendMode.Replace // old
SKBlendMode.replace // new
/*:
You get the idea. However, this tiny change brings something much bigger because Swift's optionals are actually just an enum under the hood, like this:
*/
enum Optional {
    case None
    case Some(Wrapped)
}
/*:
This means if you use `.Some` to work with optionals, you'll need to switch to `.some` instead. Of course, you could always take this opportunity to ditch `.some` entirely – these two pieces of code are identical:
*/
for case let .some(datum) in data {
    print(datum)
}

for case let datum? in data {
    print(datum)
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/