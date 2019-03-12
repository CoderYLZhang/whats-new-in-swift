/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# All function parameters have labels unless you request otherwise

The way we call functions and methods already changed in Swift 2.0, but it's changing again and this time it's going to break _everything_. In Swift 2.x and earlier, method names did not require a label for their first parameter, so the name of the first parameter was usually built into the method name. For example:
*/
names.indexOf("Taylor")
"Taylor".writeToFile("filename", atomically: true, encoding: NSUTF8StringEncoding)
SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
override func numberOfSectionsInTableView(tableView: UITableView) -> Int
func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
/*:
Swift 3 makes all labels required unless you specify otherwise, which means the method names no longer detail their parameters. In practice, this often means the last part of the method name gets moved to be the name of the first parameter.

To show you how that looks, here is that Swift 2.2 code followed by its equivalent in Swift 3:
*/
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
/*:
In that last call, notice how `NSTimer` is now just called `Timer`. Several other basic types have also dropped the "NS" prefix, so you'll now see `UserDefaults`, `FileManager`, `Data`, `Date`, `URL` `URLRequest`, `UUID`, `NotificationCenter`, and more.

Those are methods you _call_, but this has a knock-on effect for many methods that _get called_ too: when you're connecting to frameworks such as UIKit, they expect to follow the old-style "no first parameter name" rule even in Swift 3.

Here are some example signatures from Swift 2.2:
*/
override func viewWillAppear(animated: Bool)
override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
override func didMoveToView(view: SKView)
override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?)
func textFieldShouldReturn(textField: UITextField) -> Bool
/*:
In Swift 3, they all need an underscore before the first parameter, to signal that the caller (Objective-C code) won't be using a parameter label:
*/
override func viewWillAppear(_ animated: Bool)
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
override func didMoveToView(_ view: SKView)
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
func textFieldShouldReturn(_ textField: UITextField) -> Bool
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/