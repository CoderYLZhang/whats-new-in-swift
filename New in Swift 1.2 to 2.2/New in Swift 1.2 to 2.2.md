## Changes in Swift 2.0

#### 1.Throwing errors

`try/catch` is a way of programming that means "try this thing, but if it fails do this other thing instead." Swift uses enums for error types so that it can ensure your error catching is exhaustive, just like with `switch` statements. So for example, you might define your error list something like this:

```swift
enum MyError: ErrorType {
    case UserError
    case NetworkError
    case DiscoverydError
}
```

Notice how my error type builds on the built-in `ErrorType` protocol; this is required.

Once you've defined the various errors you want to work with, it's time to introduce three new keywords: `throws`, `try`, `do` and `catch`.

First up, `throws` is a simple keyword that you add to your method to tell Swift it might fail. You put it right before where you put your method's return type, like this:

```swift
func doStuff() throws -> String {
```

Once that's done, you cannot call that method unless your code is written to handle any errors it throws – Xcode simply won't compile. When you want to throw an error from inside your methods, you just write `throw` followed by the type of error you want to throw, like this:

```swift
func doStuff() throws -> String {
    print("Do stuff 1")
    print("Do stuff 2")
    throw MyError.NetworkError

    return "Some return value"
}
```

The dummy `print()` calls are there so you can follow the program flow, as you'll see in a moment.

But first, on to the next keyword: `try`. This is placed before any call to a method that throws an error, like this:

```swift
try doStuff()
```

This literally writes into your code "I acknowledge that this code might fail," so it's effectively syntactic sugar to ensure safety. But even with that your code still won't compile, because you don't catch the errors: you need to use `do` and `catch`.

Catching errors has two forms: catching specific errors and catching all errors. You can mix and match, meaning your code can say "if the error is X, I want to handle it like this; all other errors should be handled this other way."

Here's a very basic example showing how to catch all errors:

```swift
do {
    try doStuff()
    print("Success")
} catch {
    print("An error occurred.")
}
```

If you remember, we made the `doStuff()` method print "Do stuff 1" then "Do stuff 2" before throwing a network error. So, what will happen is:

- "Do stuff 1" will be printed
- "Do stuff 2" will be printed
- The NetworkError error will be thrown, immediately exiting the `doStuff()` method – its return statement will never be reached
- Control will jump to the `catch` block
- "An error occurred" will be printed

To be clear: in the code above, "Success" will never be printed – as soon as any `try` methods throw an error, execution stops and jumps to the `catch` block.

As I said, you can mix and match generic and specific `catch` blocks, but you do need to be sure that all possible errors are caught. For example, this will execute one chunk of code for NetworkError errors, and another chunk for all other errors:

```swift
do {
    try doStuff()
    print("Success")
} catch MyError.NetworkError {
    print("A network error occurred")
} catch {
    print("An error occurred")
}
```

#### 2.Use the guard keyword for early returns

It's very common to place some conditional checks at the start of a method to ensure that various data is configured ready to go. For example, if a Submit button is tapped, you might want to check that the user has entered a username in your user interface. To do this, you'd use this code:

```swift
func submitTapped() {
    guard username.text.characters.count > 0 else {
        return
    }

    print("All good")
}
```

Using `guard` might not seem much different to using `if`, but with `guard` your intention is clearer: execution should not continue if your conditions are not met. Plus it has the advantage of being shorter and more readable, so `guard` is a real improvement, and I'm sure it will be adopted quickly.

There is one bonus to using `guard` that might make it even more useful to you: if you use it to unwrap any optionals, those unwrapped values stay around for you to use in the rest of your code block. For example:

```swift
guard let unwrappedName = userName else {
    return
}

print("Your username is \(unwrappedName)")
```

This is in comparison to a straight `if` statement, where the unwrapped value would be available only inside the `if` block, like this:

```swift
if let unwrappedName = userName {
    print("Your username is \(unwrappedName)")
} else {
    return
}

// this won't work – unwrappedName doesn't exist here!
print("Your username is \(unwrappedName)")
```

#### 3.Measuring strings has changed again.

In Swift 2.2 the way strings are measured changed yet again. What was `countElements()` became `count()` in Swift 1.1, and in Swift 2.0 was removed entirely. 

Instead, you should access the `characters` property of your String, then call `count` on that, like this:

```swift
let string = "Hello, Swift!"
let count = string.characters.count
print(count)
```

**Note:** This has changed in later versions of Swift – you should access the `count` property of strings directly.

#### 4.Use the defer keyword to delay work until your scope exits

Some languages have a concept of `try/finally` which lets you tell your app "no matter what happens, I want this code to be executed." Swift 2 introduces its own take on this requirement using the `defer` keyword: it means "I want this work to take place, but not just yet." In practice, this usually means the work will happen just before your method ends, but here's the cool thing: this will still happen if you throw an error.

First, a simple example:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    print("Checkpoint 1")
    doStuff()
    print("Checkpoint 4")
}

func doStuff() {
    print("Checkpoint 2")
    defer { print("Do clean up here") }
    print("Checkpoint 3")
}
```

If you run that, you'll see "Checkpoint 1", "Checkpoint 2", "Checkpoint 3", "Do clean up here", then "Checkpoint 4". So, even though the `defer` line appears before checkpoint 3, it gets executed after – it gets deferred until the method is about to end.

I put "Do clean up code here" in there because that's exactly what `defer` is good at: when you know you need to flush a cache, write out a file or whatever, and you want to make sure that code gets executed regardless of what path is taken through your method.

As I said, work you schedule with `defer` will execute no matter what route your code takes through your method, and that includes if you throw any errors. For example:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    print("Checkpoint 1")

    do {
        try doStuff()
    } catch {
        print("Error!")
    }

    print("Checkpoint 4")
}

func doStuff() throws {
    print("Checkpoint 2")
    defer { print("Do clean up here") }
    throw MyError.UserError
    print("Checkpoint 3")
}
```

As soon as `doStuff()` throws its error, the method is exited and at that point the deferred code is called.

#### 5.Mutability warnings

This is a simple change that is going to go a long way to help code readability. As you know, Swift developers prefer declaring things as constants (using `let`) rather than variables (using `var`). But what if you made something a variable by accident? Or if you thought you might need to change it, then never do?

As of Xcode 7 and Swift 2, you'll get warnings in your code whenever you declare variables that never change – Xcode literally examines the way you use the variable and knows if you never change it.

#### 6.Checking API availability

One regular problem that iOS developers hit is that we need to be careful when using new APIs – if you try and use `UIStackView` on iOS 8, for example, your app will crash. In the olden days, Objective C developers would write code like this:

```swift
NSClassFromString(@"UIAlertController") != nil
```

That means, "if the UIAlertController class exists," which was a way of checking if we were running on iOS 8 or later. But because Xcode didn't know that was our goal, it couldn't ensure we got things right. Well, this is fixed with Swift 2, because you can now write code like this:

```swift
if #available(iOS 9, *) {
    let stackView = UIStackView()
    // do stuff
}
```

The magic happens with `#available`: it will automatically check whether we are running on iOS 9 or later, and, if so, will run the code with the `UIStackView`. The `*` after "iOS 9" is there as a catch all for any future platforms that Apple introduces, and it's required.

So, `#available` is cool, but even better is the fact that you can give it an `else` block and, because Xcode now knows this block will only execute if the device is iOS 8 or earlier, it can warn you if you new APIs. For example, if you wrote something like this:

```swift
if #available(iOS 9, *) {
    // do cool iOS 9 stuff
} else {
    let stackView = UIStackView()
}
```

## Changes in Swift 2.1

#### 1.String interpolation can now include string literals

Using quote marks inside strings caused problems before Swift 2.1, which meant that using string literals inside string interpolation was also difficult. This has been fixed in Swift 2.1, so this kind of code works fine now:

```swift
print("Hello, \(username ?? "Anonymous")")
```

This means it's also possible to read dictionary keys using string interpolation, like this:

```swift
print("Hello, \(user["name"]!)")
```

## Changes in Swift 2.2

#### 1.++ and -- are deprecated

Swift 2.2 formally deprecates the `++` and `--` operators, which means they still work but you'll get a warning when you use them. Deprecation is usually a first step towards removing something entirely, and in this case both of these operators will be removed in Swift 3.0.

In their place, you need to use `+= 1` and `-= 1` instead. These operators have been there all along, and are not going away.

You might wonder why two long-standing operators are being removed, particularly when they exist in C, C#, Java, and – critically to its "joke" – C++. There are several answers, not least:

1. Writing `++` rather than `+= 1` is hardly a dramatic time saving
2. Although it's easy once you know it, `++` doesn't have an obvious meaning to people learning Swift, whereas `+=` at least reads as "add and assign."
3. C-style loops – one of the most common situations where `++` and `--` were used – have also been deprecated, which brings me on to my next point…

#### 2.Traditional C-style for loops are deprecated

This changed outlawed the following syntax in Swift:

```swift
for var i = 1; i <= 10; i += 1 {
    print("\(i) green bottles")
}
```

These are called C-style for loops because they have long been a feature of C-like languages, and conceptually even pre-date C by quite a long way.

Although Swift is (just about!) a C-like language, it has a number of newer, smarter alternatives to the traditional for loop. The result: this construct was deprecated in Swift 2.2 and will be removed "in a future version of Swift."

To replace these old for loops, use one of the many alternatives. For example, the "green bottles" code above could be rewritten to loop over a range, like this:

```swift
for i in 1...10 {
    print("\(i) green bottles")
}
```

Remember, though, that it's a bad idea to create a range where the start is higher than the end: your code will compile, but it will crash at runtime. So, rather than writing this:

```swift
for i in 10...1 {
    print("\(i) green bottles")
}
```

…you should write this instead:

```swift
for i in (1...10).reverse() {
    print("\(i) green bottles")
}
```

Another alternative is just to use regular fast enumeration over an array of items, like this:

```swift
var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

for number in array {
    print("\(number) green bottles")
}
```

Although if you want to be technically correct (also known as "the best kind of correct") you would write such a beast like this:

```swift
var array = Array(1...10)

for number in array {
    print("\(number) green bottles")
}
```

#### 3.Comparing tuples

A tuple is simply a comma-separated list of values, where each value may or may not be named. For example:

```swift
let singer = ("Taylor", "Swift")
let alien = ("Justin", "Bieber")
```

In older versions of Swift, you couldn't compare two tuples without writing some unwieldy code like this:

```swift
func ==  (t1: (T, T), t2: (T, T)) -> Bool {
    return t1.0 == t2.0 && t1.1 == t2.1
}
```

It's not very user-friendly to require that kind of boilerplate code, and of course it would only work for tuples that have exactly two elements. In Swift 2.2, you no longer need to write that code because tuples can be compared directly:

```swift
let singer = ("Taylor", "Swift")
let alien = ("Justin", "Bieber")

if singer == alien {
    print("Matching tuples!")
} else {
    print("Non-matching tuples!")
}
```

Swift 2.2's automatic tuple comparison works with tuples with two elements just like the function we wrote, but it also works with tuples of other sizes – up to arity 6, which means a tuple that contains six elements.

(In case you were wondering: "arity" is pronounced like "arrity", but "tuple" is pronounced any number of ways: "toople", "tyoople" and "tupple" are all common.)

You can see how tuple comparison works by changing our two tuples like this:

```swift
let singer = ("Taylor", 26)
let alien = ("Justin", "Bieber")
```

Be prepared for a very long error message from Xcode, but the interesting part comes near the end:

```swift
note: overloads for '==' exist with these partially matching parameter lists: ......
((A, B), (A, B)), ((A, B, C), (A, B, C)), ((A, B, C, D), (A, B, C, D)), ((A, B, C, D, E), (A, B, C, D, E)), ((A, B, C, D, E, F), (A, B, C, D, E, F))
```

As you can see, Swift literally has functions to compare tuples all the way up to `(A, B, C, D, E, F)`, which ought to be more than enough.

#### 4.Tuple splat syntax is deprecated

Another feature that has been deprecated is one that has been part of Swift since 2010 (yes, years before it launched). It's been named "the tuple splat", and not many people were using it. It's partly for that reason – although mainly because it introduces all sorts of ambiguities when reading code – that this syntax is being deprecated.

In case you were curious – and let's face it, you probably are – here's an example of tuple splat syntax in action:

```swift
func describePerson(name: String, age: Int) {
    print("\(name) is \(age) years old")
}

let person = ("Taylor Swift", age: 26)
describePerson(person)
```

But remember: don't grow too fond of your new knowledge, because tuple splats are deprecated in Swift 2.2 and will be removed entirely in a later version.

#### 5.More keywords can be used as argument labels

Argument labels are a core feature of Swift, and let us write code like this:

```swift
for i in 1.stride(through: 9, by: 2) {
    print(i)
}
```

Without the `through` or `by` labels, this code would lose its self-documenting nature: what do the 9 and 2 do in `1.stride(9, 2)`? In this example, Swift also uses the argument labels to distinguish `1.stride(through: 9, by: 2)` from `1.stride(to: 9, by: 2)`, which produces different results.

As of Swift 2.2, you can now use a variety of language keywords as these argument labels. You might wonder why this would be a good thing, but consider this code:

```swift
func printGreeting(name: String, repeat repeatCount: Int) {
    for _ in 0 ..< repeatCount {
        print(name)
    }
}

printGreeting("Taylor", repeat: 5)
```

That uses `repeat` as an argument label, which makes sense because the function will print a string a number of times. Because `repeat` is a keyword, this code would not work before Swift 2.2 – you would need to write `repeat` instead, which is unpleasant.

Note that there are still some keywords that may not be used, specifically `var`, `let` and `inout`.

#### 6.Variable parameters have been deprecated

Another deprecation, but again with good reason: `var` parameters are deprecated because they offer only marginal usefulness, and are frequently confused with `inout`.

To give you an example, here is the `printGreeting()` function modified to use `var`:

```swift
func printGreeting(var name: String, repeat repeatCount: Int) {
    name = name.uppercaseString

    for _ in 0 ..< repeatCount {
        print(name)
    }
}

printGreeting("Taylor", repeat: 5)
```

The differences there are in the first two lines: `name` is now `var name`, and `name` gets converted to uppercase so that "TAYLOR" is printed out five times.

Without the `var` keyword, `name` would have been a constant and so the `uppercaseString` line would have failed.

The difference between `var` and `inout` is subtle: using `var` lets you modify a parameter inside the function, whereas `inout` causes your changes to persist even after the function ends.

As of Swift 2.2, `var` is deprecated, and it's slated for removal in Swift 3.0. If this is something you were using, just create a variable copy of the parameter inside the method, like this:

```swift
func printGreeting(name: String, repeat repeatCount: Int) {
    let upperName = name.uppercaseString

    for _ in 0 ..< repeatCount {
        print(upperName)
    }
}

printGreeting("Taylor", repeat: 5)
```

#### 7.Renamed debug identifiers: line, function, file

Swift 2.1 and earlier used the "screaming snake case" symbols `__FILE__`, `__LINE__`, `__COLUMN__`, and `__FUNCTION__`, which automatically get replaced the compiler by the filename, line number, column number and function name where they appear.

In Swift 2.2, those old symbols have been replaced with `#file`, `#line`, `#column` and `#function`, which will be familiar to you if you've already used [Swift 2.0's #available](https://www.hackingwithswift.com/new-syntax-swift-2-availability-checking) to check for iOS features. As the official Swift review says, it also introduces "a convention where # means invoke compiler substitution logic here."

Here’s how the debug identifiers in action from Swift 2.2 and later:

```swift
func printGreeting(name: String, repeat repeatCount: Int) {
    print("This is on line \(#line) of \(#function)")

    let upperName = name.uppercaseString

    for _ in 0 ..< repeatCount {
        print(upperName)
    }
}

printGreeting("Taylor", repeat: 5)
```

#### 8.Stringified selectors are deprecated

One unwelcome quirk of Swift before 2.2 was that selectors could be written as strings, like this:

```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tap!", style: .Plain, target: self, action: "buttonTaped")
```

If you look closely, I wrote `"buttonTaped"` rather than `"buttonTapped"`, but Xcode wasn't able to notify me of my mistake if either of those methods didn't exist.

This has been resolved as of Swift 2.2: using strings for selectors has been deprecated, and you should now write `#selector(buttonTapped)` in that code above. If the `buttonTapped()` method doesn't exist, you'll get a compile error – another whole class of bugs eliminated at compile time!

#### 9.Compile-time Swift version checking

Swift 2.2 adds a new build configuration option that makes it easy to combine code code written in versions of Swift into a single file. This might seem unnecessary, but spare a thought to people who write libraries in Swift: do they target Swift 2.2 and hope everyone is using it, or target Swift 2.0 and hope users can upgrade using Xcode?

Using the new build option lets you write two different flavours of Swift, and the correct one will be compiled depending on the version of the Swift compiler.

For example:

```swift
#if swift(>=2.2)
print("Running Swift 2.2 or later")
#else
print("Running Swift 2.1 or earlier")
#endif
```

Just like the existing `#if os()` build option, this adjusts what code is produced by the compiler: if you're using a Swift 2.2 compiler, the second `print()` line won't even be seen. This means you can use utter gibberish if you want:

```swift
#if swift(>=2.2)
print("Running Swift 2.2 or later")
#else
THIS WILL COMPILE JUST FINE IF YOU'RE
USING A SWIFT 2.2 COMPILER BECAUSE
THIS BIT IS COMPLETELY IGNORED!
#endif
```

