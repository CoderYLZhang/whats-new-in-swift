/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Use the `defer` keyword to delay work until your scope exits

Some languages have a concept of `try/finally` which lets you tell your app "no matter what happens, I want this code to be executed." Swift 2 introduces its own take on this requirement using the `defer` keyword: it means "I want this work to take place, but not just yet." In practice, this usually means the work will happen just before your method ends, but here's the cool thing: this will still happen if you throw an error.

First, a simple example:
*/
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
/*:
If you run that, you'll see "Checkpoint 1", "Checkpoint 2", "Checkpoint 3", "Do clean up here", then "Checkpoint 4". So, even though the `defer` line appears before checkpoint 3, it gets executed after – it gets deferred until the method is about to end.

I put "Do clean up code here" in there because that's exactly what `defer` is good at: when you know you need to flush a cache, write out a file or whatever, and you want to make sure that code gets executed regardless of what path is taken through your method.

As I said, work you schedule with `defer` will execute no matter what route your code takes through your method, and that includes if you throw any errors. For example:
*/
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
/*:
As soon as `doStuff()` throws its error, the method is exited and at that point the deferred code is called.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/