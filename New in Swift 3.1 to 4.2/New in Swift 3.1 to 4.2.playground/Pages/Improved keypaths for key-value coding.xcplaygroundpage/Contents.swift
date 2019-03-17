/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Improved keypaths for key-value coding

One of the most loved features of Objective-C is its ability to reference a property dynamically rather than directly – that is, to be able to say "given object X, here is the property I'd like to read" without actually reading it. These references, called _keypaths_, are distinct from direct property accesses because they don't actually read or write the value, they just stash it away for use later on.

If you've never used keypaths before, let me show you an analogy of how they work using regular Swift methods. We're going to define a struct called `Starship` and a struct called `Crew`, then create one instance of each:
*/
// an example struct
struct Crew {
    var name: String
    var rank: String
}

// another example struct, this time with a method
struct Starship {
    var name: String
    var maxWarp: Double
    var captain: Crew

    func goToMaximumWarp() {
        print("\(name) is now travelling at warp \(maxWarp)")
    }
}

// create instances of those two structs
let janeway = Crew(name: "Kathryn Janeway", rank: "Captain")
let voyager = Starship(name: "Voyager", maxWarp: 9.975, captain: janeway)

// grab a reference to the `goToMaximumWarp()` method
let enterWarp = voyager.goToMaximumWarp

// call that reference
enterWarp()
/*:
Because functions are first-class types in Swift, the last two lines are able to create a reference to the `goToMaximumWarp()` method called `enterWarp`, then call that later on whenever we want to. The problem is, you can't do the same thing for properties – you can't say "create a reference to the captain's name property that I can check when the inevitable mutiny happens," because Swift will just read the property directly and you'll just get its original value.

This is fixed with keypaths: they are _uninvoked references to properties_ just like our `enterWarp()` code. If you invoke the reference now you get the current value, but if you invoke the reference later you get the latest value. You can dig through any number of properties, and Swift uses its type inference to ensure you get the correct type back.

The Swift Evolution community spent quite a while discussing the correct syntax for keypaths because it needed to be something visually different from other Swift code, and the syntax they ended up with uses backslashes: `\Starship.name`, `\Starship.maxWarp`, and `\Starship.captain.name`. You can assign those two to a variable then use them whenever you want, on any `Starship` instance. For example:
*/
let nameKeyPath = \Starship.name
let maxWarpKeyPath = \Starship.maxWarp
let captainName = \Starship.captain.name

let starshipName = voyager[keyPath: nameKeyPath]
let starshipMaxWarp = voyager[keyPath: maxWarpKeyPath]
let starshipCaptain = voyager[keyPath: captainName]
/*:
That will make `starshipName` a string and `starshipMaxWarp` a double, because Swift is able to infer the types correctly. The third example there even goes into the property of a property, and Swift still figures it out correctly.

Future plans for this include being able to access array indexes and to create keypaths from strings at runtime – for more information see [the Swift Evolution proposal for this new feature](https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md).

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/