# Changes in Swift 3.0

#### 1.All function parameters have labels unless you request otherwise

The way we call functions and methods already changed in Swift 2.0, but it's changing again and this time it's going to break *everything*. In Swift 2.x and earlier, method names did not require a label for their first parameter, so the name of the first parameter was usually built into the method name. For example:

```swift
names.indexOf("Taylor")
"Taylor".writeToFile("filename", atomically: true, encoding: NSUTF8StringEncoding)
SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
override func numberOfSectionsInTableView(tableView: UITableView) -> Int
func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
```

Swift 3 makes all labels required unless you specify otherwise, which means the method names no longer detail their parameters. In practice, this often means the last part of the method name gets moved to be the name of the first parameter.

To show you how that looks, here is that Swift 2.2 code followed by its equivalent in Swift 3:

```swift
names.indexOf("Taylor")
names.index(of: "Taylor")

"Taylor".writeToFile("filename", atomically: true, encoding: NSUTF8StringEncoding)
"Taylor".write(toFile: "somefile", atomically: true, encoding: String.Encoding.utf8)

SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 10)

UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)

override func numberOfSectionsInTableView(tableView: UITableView) -> Int
override func numberOfSections(in tableView: UITableView) -> Int

func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
func viewForZooming(in scrollView: UIScrollView) -> UIView?

NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
```

In that last call, notice how `NSTimer` is now just called `Timer`. Several other basic types have also dropped the "NS" prefix, so you'll now see `UserDefaults`, `FileManager`, `Data`, `Date`, `URL` `URLRequest`, `UUID`, `NotificationCenter`, and more.

Those are methods you *call*, but this has a knock-on effect for many methods that *get called* too: when you're connecting to frameworks such as UIKit, they expect to follow the old-style "no first parameter name" rule even in Swift 3.

Here are some example signatures from Swift 2.2:

```swift
override func viewWillAppear(animated: Bool)
override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
override func didMoveToView(view: SKView)
override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?)
func textFieldShouldReturn(textField: UITextField) -> Bool
```

In Swift 3, they all need an underscore before the first parameter, to signal that the caller (Objective-C code) won't be using a parameter label:

```swift
override func viewWillAppear(_ animated: Bool)
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
override func didMoveToView(_ view: SKView)
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
func textFieldShouldReturn(_ textField: UITextField) -> Bool
```

####2.Omit needless words

When Swift went open source in December 2015, its shiny new API guideliness contained three fateful words: "omit needless words." This introduces another huge raft of breaking changes in Swift 3, because it means that method names that contain self-evident words now have those words removed.

Let's look at some simple examples first. First, Swift 2.2:

```swift
let blue = UIColor.blueColor()
let min = numbers.minElement()
attributedString.appendAttributedString(anotherString)
names.insert("Jane", atIndex: 0)
UIDevice.currentDevice()
```

Can you identify the needless words? When you're working with `UIColor`, of course blue is going to be a color, so saying `blueColor()` is needless. When you append one attributed string to another, do you really need to specify that it's an attributed string you're appending as opposed to an elephant? And why should it be a method – surely a color should be a property!

Here is that same code in Swift 3:

```swift
let blue = UIColor.blue
let min = numbers.min()
attributedString.append(anotherString)
names.insert("Jane", at: 0)
UIDevice.current
```

As you can see, this makes method names significantly shorter!

This change has particularly affected strings, which had repetition all over the place. The best way to demonstrate this is to show before and after code side-by-side, so in the code below the first line of each pair is Swift 2.2 and the second is Swift 3.0:

```swift
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
```

**Warning:** `capitalized` is still a property, but `lowercaseString` and `uppercaseString` have been transmogrified into the methods `lowercased()` and `uppercased()`.

I've chosen the examples so far because the jump to Swift 3 isn't vast, but there are quite a few changes that were significant enough to make my brain hit a speedbump – usually when the resulting method is so short that it wasn't immediately obvious what it was.

For example, look at this code:

```swift
dismiss(animated: true, completion: nil)
```

When I first saw that, I blanked: "dismiss what?" That's partly a result of the [Stockholm syndrome](https://en.wikipedia.org/wiki/Stockholm_syndrome) that's inevitable having programmed for iOS for so long, but once you learn to reverse the parameter label change and re-add the needless words, you can see it's equivalent to this code in Swift 2.2:

```swift
dismissViewControllerAnimated(true, completion: nil)
```

In fact, the `completion: nil` part is optional now, so you could even write this:

```swift
dismiss(animated: true)
```

A similar change happened to `prepareForSegue()`, which now looks like this:

```swift
override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?)
```

####3.UpperCamelCase has been replaced with lowerCamelCase for enums and properties

Although syntactically irrelevant, the capital letters we use to name classes and structs, properties, enums, and more have always followed a convention fairly closely: classes, structs, and enums use UpperCamelCase (MyStruct, WeatherType.Cloudy), properties and parameter names use lowerCamelCase (emailAddress, requestString).

I say "fairly closely" because there are some exceptions that are going to *stop* being exceptions in Swift 3: properties and parameters that started with initials in Swift 2.2 will now used lowerCamelCase in Swift 3.

Sometimes this isn't too strange: Swift 2.2 created `NSURLRequest` objects using `NSURLRequest(URL: someURL)` – note the capital "URL". Swift 3 rewrites that to `URLRequest(url: someURL)`, and also means you'll use things like `webView.request?.url?.absoluteString` for reading the URL of a web view.

Where it's a bit more jarring is when only part of the property name is in caps, e.g. `CGColor` or `CIColor`. Yes, you've guessed it: they become `cgColor` and `ciColor` in Swift 3, so you'll be writing code like this:

```swift
let red = UIColor.red.cgColor
```

This change does help drive consistency: all properties and parameters should start with a lowercase letter, no exceptions.

At the same time enum cases are also changing, moving from UpperCamelCase to lowerCamelCase. This makes sense: an enum is a data type (like a struct), but enum values are closer to properties. However, it does mean that wherever you've used an Apple enum, it will now be lowercase. So:

```swift
UIInterfaceOrientationMask.Portrait // old
UIInterfaceOrientationMask.portrait // new

NSTextAlignment.Left // old
NSTextAlignment.left // new

SKBlendMode.Replace // old
SKBlendMode.replace // new
```

You get the idea. However, this tiny change brings something much bigger because Swift's optionals are actually just an enum under the hood, like this:

```swift
enum Optional {
    case None
    case Some(Wrapped)
}
```

This means if you use `.Some` to work with optionals, you'll need to switch to `.some` instead. Of course, you could always take this opportunity to ditch `.some` entirely – these two pieces of code are identical:

```swift
for case let .some(datum) in data {
    print(datum)
}

for case let datum? in data {
    print(datum)
}
```

####4.Swifty importing of C functions

Swift 3 introduces attributes for C functions that allow library authors to specify new and beautiful ways their code should be imported into Swift. For example, all those functions that start with "CGContext" now get mapped to properties methods on a CGContext object, which makes for much more idiomatic Swift. Yes, this means the hideous wart that is `CGContextSetFillColorWithColor()` has finally been excised.

To demonstrate this, here's an example in Swift 2.2:

```swift
let ctx = UIGraphicsGetCurrentContext()

let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
CGContextSetLineWidth(ctx, 10)
CGContextAddRect(ctx, rectangle)
CGContextDrawPath(ctx, .FillStroke)

UIGraphicsEndImageContext()
```

In Swift 3 the `CGContext` can be treated as an object that you can call methods on rather than repeating `CGContext` again and again. So, we can rewrite that code like this:

```swift
if let ctx = UIGraphicsGetCurrentContext() {
    let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.setStrokeColor(UIColor.black.cgColor)
    ctx.setLineWidth(10)
    ctx.addRect(rectangle)
    ctx.drawPath(using: .fillStroke)

    UIGraphicsEndImageContext()
}
```

Note: in both Swift 2.2 and Swift 3.0 `UIGraphicsGetCurrentContext()` returns an optional `CGContext`, but because Swift 3 uses method calls we need to safely unwrap before it's used.

This mapping of C functions exists elsewhere, for example you can now read the `numberOfPages` property of a `CGPDFDocument`, and `CGAffineTransform` has been souped up quite dramatically. Here are some examples showing old and new:

```swift
CGAffineTransformIdentity
CGAffineTransform.identity

CGAffineTransformMakeScale(2, 2)
CGAffineTransform(scaleX: 2, y: 2)

CGAffineTransformMakeTranslation(128, 128)
CGAffineTransform(translationX: 128, y: 128)

CGAffineTransformMakeRotation(CGFloat(M_PI))
CGAffineTransform(rotationAngle: CGFloat(M_PI))
```

####5.Verbs and nouns

This is the part where some people will start to drift off in confusion, which is a shame because it's important.

Here's are some quotes from the Swift API guidelines:

- "When the operation is naturally described by a verb, use the verb’s imperative for the mutating method and apply the “ed” or “ing” suffix to name its nonmutating counterpart"
- "Prefer to name the nonmutating variant using the verb’s past participle"
- "When adding “ed” is not grammatical because the verb has a direct object, name the nonmutating variant using the verb’s present participle"
- "When the operation is naturally described by a noun, use the noun for the nonmutating method and apply the “form” prefix to name its mutating counterpart"

Got that? It's no surprise that Swift's rules are expressed using lingustic terminology – it is after all a language! – but this at least gives me a chance to feel smug that I did a second degree in English. What it means is that many methods are changing names in subtle and sometimes confusing ways.

Let's start with a couple of simple examples:

```swift
myArray.enumerate()
myArray.enumerated()

myArray.reverse()
myArray.reversed()
```

Each time Swift 3 modifies the method by adding a "d" to the end: this is a value that's being returned.

These rules are mostly innocent enough, but it causes confusion when it comes to array sorting. Swift 2.2 used `sort()` to return a sorted array, and `sortInPlace()` to sort an array in place. In Swift 3.0, `sort()` is renamed to `sorted()` (following the examples above), and `sortInPlace()` is renamed to `sort()`.

**TL;DR: This means you need to be careful because in Swift 2.2 sort() returned a sorted array, but in Swift 3.0 sort() sorts the array in place.**

# Changes in Swift 3.1

####1.Concrete constrained extensions

Swift lets us extend types using constraints, which is a powerful and expressive way to add functionality. To demonstrate this, let's look at a worked example in Swift 3.0 that modifies collections to do something trivial:

```swift
extension Collection where Iterator.Element: Comparable {
    func lessThanFirst() -> [Iterator.Element] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
```

That adds a new method called `lessThanFirst()`, which returns all items in a collection that are less than the first item. So, using it with the array `[5, 6, 10, 4, 110, 3]` will return `[4, 3]`.

That code extends a protocol (`Collection`) only where it matches a constraint: elements in the collection must conform to another protocol, `Comparable`. This alone is powerful stuff, but let's take it back a step: what if we wanted something a bit more specific? Swift 3.0 lets us extend a concrete type rather than the protocol `Collection`, so instead we could write this:

```swift
extension Array where Element: Comparable {
    func lessThanFirst() -> [Element] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
```

That extends a concrete type (only `Array`) but still using a protocol for its constraint. What if we wanted to go even more specific – extend a concrete type with a concrete constraint, for example only arrays that contains integers? Well, it turns out that isn't possible in Swift 3.0, which usually strikes people as odd: if Swift 3.0 can handle extending protocols with another protocol as a constraint, then surely extending a specific type with a specific constraint should be a cinch?

Fortunately, this discrepancy has been removed in Swift 3.1, which means we can now write code like this:

```swift
extension Array where Element == Int {
    func lessThanFirst() -> [Int] {
        guard let first = self.first else { return [] }
        return self.filter { $0 < first }
    }
}

let items = [5, 6, 10, 4, 110, 3].lessThanFirst()
print(items)
```

That extends a concrete type (only `Array`) and uses a concrete constraint (only where the elements are `Int`).

Now, obviously we're using a trivial example here – in your own code this is going to be significantly more useful when you want to extend arrays containing your own custom structs.

####2.Generics with nested types

Swift 3.0's support for nested types is useful to help you organize your data and increase encapsulation, but Swift 3.1 takes them to the next level by adding support for generics. Let's look at a simple example again, just to start with:

```swift
struct Message {
    struct Attachment {
        var contents: String
    }

    var title: String
    var attachment: Attachment
}
```

That creates a `Message` struct that has an `Attachment` struct inside it – a nested type. I've added two `String` properties, because messages will have some text and attachments will hold some text.

Now, what if we wanted either `Message` or `Attachment` to have different kinds of data – perhaps `Int` or `Data`? Well, that requires generics, so you might have found yourself writing something like this:

```swift
struct Message<T> {
    struct Attachment {
        var contents: String
    }

    var title: T
    var attachment: Attachment
}
```

That tells Swift we want `Message` to work across several data types, and whatever data type gets used to create the struct should also be used for the `title` property. Or at least that's what it *would* tell Swift, if such code were actually legal – Swift 3.0 does not allow you to mix nested type with generics. Fortunately, this is exactly what Swift 3.1 allows, because nested types can now appear inside generic types.

Not content to stop there, Swift 3.1 takes this a step further: nested types can *also* be generic, either using their own generic type or by inheriting the generic type of their parent. For example:

```swift
struct Message<T> {
    struct Attachment<T> {
        var contents: T
    }

    var title: T
    var attachment: Attachment<T>
}
```

With that code, the `Message` struct will have a specific type assigned to it, and the `Attachment` struct will always have the same type – you can't use `String` for one and `Int` for the other. So, this code will work fine:

```swift
let msg = Message(title: "Hello", attachment: Message.Attachment(contents: "World"))
```

Helpfully, if your goal is to make the nested type and its container use the same generic type, you don't even need to declare the nested type as generic – Swift makes the outer type available to the nested type, so in fact you can just write this:

```swift
struct Message<T> {
    struct Attachment {
        var contents: T
    }

    var title: T
    var attachment: Attachment
}
```

Generics are great and so are nested types, so I'm really pleased to see Swift 3.1 bring them together at last.

####3.Sequences get` prefix(while:)` and `drop(while:) `methods

Two useful new methods have been added to the `Sequence` protocol: `prefix(while:)` and `drop(while:)`. The former returns the longest subsequence that satisfies a predicate, which is a fancy way of saying that you give it a closure to run on every item, and it will go through all the elements in the sequence and return those that match the closure – but will stop as soon as it finds a non-matching element.

Let's take a look at a code example:

```swift
let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let prefixed = names.prefix { $0.hasPrefix("Michael") }
print(prefixed)
```

That uses the `hasPrefix()` method to return the subsequence `["Michael Jackson", "Michael Jordan", "Michael Caine"` – the first three elements in the sequence. It won't include "Michael Douglas", because that comes after the first non-Michael. If you wanted *all* the Michaels regardless of their position, you should use `filter()` instead.

The second new method, `drop(while:)` is effectively the opposite: it finds the longest subsequence that satisfies your predicate, then returns everything *after* it. For example:

```swift
let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
let dropped = names.drop { $0.hasPrefix("Michael") }
print(dropped)
```

That will return the subsequence `["Taylor Swift", "Adele Adkins", "Michael Douglas"]` – everything after the initial Michaels.