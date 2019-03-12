/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Generics with nested types

Swift 3.0's support for nested types is useful to help you organize your data and increase encapsulation, but Swift 3.1 takes them to the next level by adding support for generics. Let's look at a simple example again, just to start with:
*/
struct Message {
    struct Attachment {
        var contents: String
    }

    var title: String
    var attachment: Attachment
}
/*:
That creates a `Message` struct that has an `Attachment` struct inside it – a nested type. I've added two `String` properties, because messages will have some text and attachments will hold some text.

Now, what if we wanted either `Message` or `Attachment` to have different kinds of data – perhaps `Int` or `Data`? Well, that requires generics, so you might have found yourself writing something like this:
*/
struct Message<T> {
    struct Attachment {
        var contents: String
    }

    var title: T
    var attachment: Attachment
}
/*:
That tells Swift we want `Message` to work across several data types, and whatever data type gets used to create the struct should also be used for the `title` property. Or at least that's what it _would_ tell Swift, if such code were actually legal – Swift 3.0 does not allow you to mix nested type with generics. Fortunately, this is exactly what Swift 3.1 allows, because nested types can now appear inside generic types.

Not content to stop there, Swift 3.1 takes this a step further: nested types can _also_ be generic, either using their own generic type or by inheriting the generic type of their parent. For example:
*/
struct Message<T> {
    struct Attachment<T> {
        var contents: T
    }

    var title: T
    var attachment: Attachment<T>
}
/*:
With that code, the `Message` struct will have a specific type assigned to it, and the `Attachment` struct will always have the same type – you can't use `String` for one and `Int` for the other. So, this code will work fine:
*/
let msg = Message(title: "Hello", attachment: Message.Attachment(contents: "World"))
/*:
Helpfully, if your goal is to make the nested type and its container use the same generic type, you don't even need to declare the nested type as generic – Swift makes the outer type available to the nested type, so in fact you can just write this:
*/
struct Message<T> {
    struct Attachment {
        var contents: T
    }

    var title: T
    var attachment: Attachment
}
/*:
Generics are great and so are nested types, so I'm really pleased to see Swift 3.1 bring them together at last.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/