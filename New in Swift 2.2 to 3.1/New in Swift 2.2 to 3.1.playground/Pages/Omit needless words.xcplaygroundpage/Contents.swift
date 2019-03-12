/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Omit needless words

When Swift went open source in December 2015, its shiny new API guideliness contained three fateful words: "omit needless words." This introduces another huge raft of breaking changes in Swift 3, because it means that method names that contain self-evident words now have those words removed.

Let's look at some simple examples first. First, Swift 2.2:
*/
let blue = UIColor.blueColor()
let min = numbers.minElement()
attributedString.appendAttributedString(anotherString)
names.insert("Jane", atIndex: 0)
UIDevice.currentDevice()
/*:
Can you identify the needless words? When you're working with `UIColor`, of course blue is going to be a color, so saying `blueColor()` is needless. When you append one attributed string to another, do you really need to specify that it's an attributed string you're appending as opposed to an elephant? And why should it be a method – surely a color should be a property!

Here is that same code in Swift 3:
*/
let blue = UIColor.blue
let min = numbers.min()
attributedString.append(anotherString)
names.insert("Jane", at: 0)
UIDevice.current
/*:
As you can see, this makes method names significantly shorter!

This change has particularly affected strings, which had repetition all over the place. The best way to demonstrate this is to show before and after code side-by-side, so in the code below the first line of each pair is Swift 2.2 and the second is Swift 3.0:
*/
"  Hello  ".stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
"  Hello  ".trimmingCharacters(in: .whitespacesAndNewlines)

"Taylor".containsString("ayl")
"Taylor".contains("ayl")

"1,2,3,4,5".componentsSeparatedByString(",")
"1,2,3,4,5".components(separatedBy: ",")

myPath.stringByAppendingPathComponent("file.txt")
myPath.appendingPathComponent("file.txt")

"Hello, world".stringByReplacingOccurrencesOfString("Hello", withString: "Goodbye")
"Hello, world".replacingOccurrences(of: "Hello", with: "Goodbye")

"Hello, world".substringFromIndex(7)
"Hello, world".substring(from: 7)

"Hello, world".capitalizedString
"Hello, world".capitalized
/*:
**Warning:** `capitalized` is still a property, but `lowercaseString` and `uppercaseString` have been transmogrified into the methods `lowercased()` and `uppercased()`.

I've chosen the examples so far because the jump to Swift 3 isn't vast, but there are quite a few changes that were significant enough to make my brain hit a speedbump – usually when the resulting method is so short that it wasn't immediately obvious what it was.

For example, look at this code:
*/
dismiss(animated: true, completion: nil)
/*:
When I first saw that, I blanked: "dismiss what?" That's partly a result of the [Stockholm syndrome](https://en.wikipedia.org/wiki/Stockholm_syndrome) that's inevitable having programmed for iOS for so long, but once you learn to reverse the parameter label change and re-add the needless words, you can see it's equivalent to this code in Swift 2.2:
*/
dismissViewControllerAnimated(true, completion: nil)
/*:
In fact, the `completion: nil` part is optional now, so you could even write this:
*/
dismiss(animated: true)
/*:
A similar change happened to `prepareForSegue()`, which now looks like this:
*/
override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?)
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/