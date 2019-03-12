/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Swifty importing of C functions

Swift 3 introduces attributes for C functions that allow library authors to specify new and beautiful ways their code should be imported into Swift. For example, all those functions that start with "CGContext" now get mapped to properties methods on a CGContext object, which makes for much more idiomatic Swift. Yes, this means the hideous wart that is `CGContextSetFillColorWithColor()` has finally been excised.

To demonstrate this, here's an example in Swift 2.2:
*/
let ctx = UIGraphicsGetCurrentContext()

let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
CGContextSetLineWidth(ctx, 10)
CGContextAddRect(ctx, rectangle)
CGContextDrawPath(ctx, .FillStroke)

UIGraphicsEndImageContext()
/*:
In Swift 3 the `CGContext` can be treated as an object that you can call methods on rather than repeating `CGContext` again and again. So, we can rewrite that code like this:
*/
if let ctx = UIGraphicsGetCurrentContext() {
    let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.setStrokeColor(UIColor.black.cgColor)
    ctx.setLineWidth(10)
    ctx.addRect(rectangle)
    ctx.drawPath(using: .fillStroke)

    UIGraphicsEndImageContext()
}
/*:
Note: in both Swift 2.2 and Swift 3.0 `UIGraphicsGetCurrentContext()` returns an optional `CGContext`, but because Swift 3 uses method calls we need to safely unwrap before it's used.

This mapping of C functions exists elsewhere, for example you can now read the `numberOfPages` property of a `CGPDFDocument`, and `CGAffineTransform` has been souped up quite dramatically. Here are some examples showing old and new:
*/
CGAffineTransformIdentity
CGAffineTransform.identity

CGAffineTransformMakeScale(2, 2)
CGAffineTransform(scaleX: 2, y: 2)

CGAffineTransformMakeTranslation(128, 128)
CGAffineTransform(translationX: 128, y: 128)

CGAffineTransformMakeRotation(CGFloat(M_PI))
CGAffineTransform(rotationAngle: CGFloat(M_PI))
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/