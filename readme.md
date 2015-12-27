# UIViewControllerStack

UIViewControllerStack is a stack like data structure for pushing and popping view controllers in and out of view.

It gives you an interface much like UINavigationController, but without the overhead and view management that UINavigationController requires.

It gives you hooks you'd need to setup things like top navigation bars, or bottom tool bars - allowing you to set it up how you like, instead of being constrained to one control.

## UIViewControllerStack Object

### Animation Duration

You can change animation duration in interface builder, or with:

````
viewStack.animationDuration = .25;
````

### Alpha

You can optionally turn on alpha animations with:

````
viewStack.animatesAlpha = TRUE;
````

### Pushing view controllers

To setup the first view controller in the stack, you can push a view controller without animating it:

````
[viewStack pushViewController:myViewController animated:FALSE];
````

After that you can push animated view controllers:

````
[viewStack pushViewController:myViewController animated:TRUE];
````

You can push multiple view controllers into the stack with:

````
[viewStack pushViewControllers:@[vc1,vc2,] animated:TRUE];
````

This results in vc2 being the view controller that gets pushed into the view frame. A pop would navigate back to vc1.

### Poppping view controllers

You can pop a single view controller with:

````
[viewStack popViewControllerAnimated:TRUE];
````

You can pop to the root view controller with:

````
[viewStack popToRootViewControllerAnimated:TRUE];
````

Popping to root view controller will discard all other view controllers and bring the user back to the root view controller.

You can pop back to a certain view controller with:

````
[viewStack popToViewControllerAtIndex:2 animated:TRUE];
````

### Erasing the view stack

You can completely erase the stack and start a new root view controller with:

````
[viewStack eraseStackAndPushViewController:myViewController animated:TRUE];
````

Or you can completely erase and remove all view controllers, leaving the view stack empty with no views being visible:

````
[viewStack eraseStack];
````

### Replacing the current view controller

You can replace the current view controller in the stack with a new one:

````
[viewStack replaceCurrentViewControllerWithViewController:myViewController animated:TRUE];
````

### Updating the view stack without changing what's displayed

You can easily replace a view controller somewhere in the stack with:

````
[viewStack replaceViewController:viewControllerAlreadyInStack withViewController:myNewViewController];
````

You can insert a new view controller anywhere into the stack without changing what's displayed:

````
[viewStack insertViewController:myViewController atIndex:1];
````

### View resizing

When your view controllers are becoming the visible view, whether from a push or a pop, the view stack can resize your view controllers to fit within the view stack frame.

You can control this behavior globally with:

````
viewStack.alwaysResizePushedViews = TRUE;
````

Or you can pick and choose which views to auto resize by implementing the @protocol UIViewControllerStackUpdated and the method:

````
- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *) viewStack;
````

### Stack update notifications

You can be notified of stack operations that are happening to your view controllers by implementing @protocol UIViewControllerStackUpdating:

````
- (void) viewStack:(UIViewControllerStack *) viewStack willShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack willHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack didShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack didHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack didResizeViewController:(UIViewController *) viewController;
````

The UIViewControllerStackOperation is defined as:

````
typedef NS_ENUM(NSInteger,UIViewControllerStackOperation) {
	UIViewControllerStackOperationPush,
	UIViewControllerStackOperationPop
};
````

There's also traditional NSNotifications available with:

````
extern NSString * const UIViewControllerStackNotificationWillPush;
extern NSString * const UIViewControllerStackNotificationDidPush;
extern NSString * const UIViewControllerStackNotificationWillPop;
extern NSString * const UIViewControllerStackNotificationDidPop;
extern NSString * const UIViewControllerStackNotificationUserInfoToControllerKey;
extern NSString * const UIViewControllerStackNotificationUserInfoFromControllerKey;
````

### Other Utilities

There are a few other utility methods that can be useful at times:

````
- (BOOL) canPopViewController;
- (BOOL) hasViewController:(UIViewController *) viewController;
- (BOOL) hasViewControllerClass:(Class) cls;
- (NSInteger) stackSize;
- (UIViewController *) currentViewController;
- (UIViewController *) rootViewController;
- (NSArray *) allViewControllers;
````

## License

The MIT License (MIT)
Copyright (c) 2016 Aaron Smith

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.