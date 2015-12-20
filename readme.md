# UIViewControllerStack

UIViewControllerStack is a stack like data structure for pushing and popping view controllers in and out of view.

## Use Case

I built this to be able to quickly setup applications that look like a UINavigationController based application. But without so much (in my opinion) boiler plate code and setup times.

I've successfully use this class in many iOS apps, it's super useful and very quick to setup. You can easily get a navigation based application setup with little work.

## UIViewControllerStack Object

You can use UIVIewControllerStack in interface builder or setup manually with initWithFrame:.

### Animation Duration

You can change animation duration in interface builder, or with:

````
viewStack.animationDuration = .25;
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

Or you can complete erase and remove all view controllers, leaving the view stack empty with no views being visible:

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

You can also provide a custom frame for your view with:

````
- (CGRect) viewFrameForViewStackController:(UIViewControllerStack *) viewStack;
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

There is also tradiitonal NSNotifications available with:

````
extern NSString * const UIViewControllerStackNotificationWillPush;
extern NSString * const UIViewControllerStackNotificationDidPush;
extern NSString * const UIViewControllerStackNotificationWillPop;
extern NSString * const UIViewControllerStackNotificationDidPop;
extern NSString * const UIViewControllerStackNotificationUserInfoToControllerKey;
extern NSString * const UIViewControllerStackNotificationUserInfoFromControllerKey;
````

### UIViewControllerStack is a UIScrollView

UIViewControllerStack subclasses UIScrollView so that views being pushed / popped can easily be made scrollable.

If your view has a minimum height, you can provide that to the view stack which will make the view stack vertically scrollable.

````
- (CGFloat) minViewHeightForViewStackController:(UIViewControllerStack *) viewStack;
````

If your views minimum height is greater than the height of the view stack, the view stack will be made vertically scrollable. To get a better idea of how that works, consider this code, which is essentially how it works with a few contrived lines of code to better illustrate:

````
CGRect f = viewController.view.frame;
CGFloat minHeight = [viewController minViewHeightForViewStackController:self];
if(self.frame.size.height < minHeight) {
	f.size.height = minHeight; //leave your view at it's minimum height
} else {
	f.size.height = self.frame.size.height;
}
viewController.frame = f;
self.contentSize = f.size; //make scrollable
````

### Other Utilities

There are a few other utility methods that can be useful at times:

````
- (BOOL) canPopViewController;
- (BOOL) hasViewController:(UIViewController *) viewController;
- (BOOL) hasViewControllerClass:(Class) cls;
- (NSInteger) stackSize;
- (UIViewController *) currentViewController;
- (NSArray *) allViewControllers;
````
