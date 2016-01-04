
#import <UIKit/UIKit.h>

@class UIViewControllerStack;

//UIViewControllerParentViewStack category.
//use to get a view controllers parent view stack controller.
@interface UIViewController (UIViewControllerParentViewStack)
- (UIViewControllerStack *) parentViewControllerStack;
@end

//notifications
extern NSString * const UIViewControllerStackNotificationWillPush;
extern NSString * const UIViewControllerStackNotificationDidPush;
extern NSString * const UIViewControllerStackNotificationWillPop;
extern NSString * const UIViewControllerStackNotificationDidPop;
extern NSString * const UIViewControllerStackNotificationUserInfoToControllerKey;
extern NSString * const UIViewControllerStackNotificationUserInfoFromControllerKey;

//operation enum for UIViewControllerStackUpdating protocol
typedef NS_ENUM(NSInteger,UIViewControllerStackOperation) {
	UIViewControllerStackOperationPush,
	UIViewControllerStackOperationPop
};

//protocol to notify your view controllers of updates
//you implement these on your view controllers that you push/pop.
@protocol UIViewControllerStackUpdating <NSObject>
@optional

//called on your view controller before the view stack pushes a view controller
- (void) viewStack:(UIViewControllerStack *) viewStack willShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;

//called on your view controller before the view stack pops a view controller
- (void) viewStack:(UIViewControllerStack *) viewStack willHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;

//called on your view controller after the view stack pushes a view controller
- (void) viewStack:(UIViewControllerStack *) viewStack didShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;

//called on your view controller after the view stack pops a view controller
- (void) viewStack:(UIViewControllerStack *) viewStack didHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;

//called on your view controller after it was resized
- (void) viewStackDidResizeViewController:(UIViewControllerStack *) viewStack;

//tell the view stack if it should resize your views frame to match the view stack frame
- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *) viewStack;

@end

//protocol to control and be updated of animation and swipe gesture.
@protocol UIViewControllerStackDelegate <NSObject>
@optional

//called before / after a pop
- (void) viewStackWillPop:(UIViewControllerStack *) viewStack toController:(UIViewController *) toController fromController:(UIViewController *) fromController wasAnimated:(BOOL) wasAnimated;
- (void) viewStackDidPop:(UIViewControllerStack *) viewStack toController:(UIViewController *) toController fromController:(UIViewController *) fromController wasAnimated:(BOOL) wasAnimated;

//override the start X postition for to controller.
//for UIViewControllerStackOperationPush, the default value is viewController.frame.size.width
//for UIViewControllerStackOperatoinPop, the default value is -(viewController.view.frame.size.width/viewStack.moveAmount)
- (CGFloat) startXForToController:(UIViewController *) viewController forViewStack:(UIViewControllerStack *) viewStack forOperation:(UIViewControllerStackOperation) operation;

//override the end X position for to controller.
//default value is 0 for both UIViewControllerStackOperationPush, and UIViewControllerStackOperationPop
- (CGFloat) endXForToController:(UIViewController *) viewController forViewStack:(UIViewControllerStack *) viewStack forOperation:(UIViewControllerStackOperation) operation;

//override the end X position for from controller.
//for UIViewControllerStackOperatoinPush, the default value is -(viewController.view.frame.size.width/viewStack.moveAmount)
//for UIViewControllerStackOperationPop, the default value is viewController.frame.size.width
- (CGFloat) endXForFromController:(UIViewController *) viewController forViewStack:(UIViewControllerStack *) viewStack forOperation:(UIViewControllerStackOperation) operation;

//called when the view stack is starting a swipe gesture
- (void) viewStackSwipeGestureWillStart:(UIViewControllerStack *) viewStack;

//called on your view controller during drag/swipe operations for popping.
- (void) viewStackSwipeGestureDidUpdate:(UIViewControllerStack *) viewStack delta:(CGFloat) delta;

//called when the view stack is done dragging.
- (void) viewStackSwipeGestureDidEnd:(UIViewControllerStack *) viewStack didPop:(BOOL) didPop;

@end

IB_DESIGNABLE
@interface UIViewControllerStack : UIView

//delegate
@property (weak) NSObject <UIViewControllerStackDelegate> * delegate;

//animation duration for push/popping view controllers that slide in / out.
//default is .25
@property IBInspectable CGFloat animationDuration;

//the distance to move view controllers when pushing / popping.
//the distance your view controller moves is calculated by taking viewController.width/distance.
@property IBInspectable CGFloat distance;

//whether to add a gesture recognizer for drag left to right which pops a view controller.
//default is false.
@property (nonatomic) IBInspectable BOOL swipeToPop;

//whether to set view.layer.shadow properties when views are being pushed/popped.
@property IBInspectable BOOL useLayerShadowProperties;

//whether to animate alpha as views are being pushed / popped.
//this has no effect when using drag gesture to pop a view controller.
@property IBInspectable BOOL animatesAlpha;

//whether to always resize your views frame to match this view stack's frame.
//implement methods from @protocol UIViewControllerStackUpdating to override this setting per view controller.
@property IBInspectable BOOL alwaysResizePushedViews;

//methods for pushing/popping and altering what's displayed.
- (void) pushViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) pushViewControllers:(NSArray *) viewControllers animated:(BOOL) animated;
- (void) popViewControllerAnimated:(BOOL) animated;
- (void) popToRootViewControllerAnimated:(BOOL) animated;
- (void) popToViewControllerAtIndex:(NSUInteger) index animated:(BOOL) animated;
- (void) replaceCurrentViewControllerWithViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) eraseStackAndPushViewController:(UIViewController *) viewController animated:(BOOL) animated;

//util methods for updating what's in the stack without effecting what's displayed.
- (void) pushViewControllers:(NSArray *) viewControllers;
- (void) insertViewController:(UIViewController *) viewController atIndex:(NSInteger) index;
- (void) replaceViewController:(UIViewController *) viewController withViewController:(UIViewController *) newViewController;

//completely erase stack and remove all subviews.
- (void) eraseStack;

//other utils
- (BOOL) canPopViewController;
- (BOOL) hasViewController:(UIViewController *) viewController;
- (BOOL) hasViewControllerClass:(Class) cls;
- (NSInteger) stackSize;
- (UIViewController *) currentViewController;
- (UIViewController *) rootViewController;
- (NSArray *) allViewControllers;

//these are overridable by subclasses, or you can implement UIViewControllerStackDelegate instead.
- (CGPoint) startPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation;
- (CGPoint) endPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation;
- (CGPoint) endPointForFromController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation;

// these are some utils to manually animate a pop operation. see NavBarSample for example.
- (void) beginSwipeGestureAnimationUpdates;
- (void) updateSwipeGestureWithDelta:(CGFloat) delta adjustDistanceMoved:(BOOL) adjustDistanceMoved;
- (void) endSwipeGestureAnimationUpdatesShouldPop:(BOOL) shouldPop;

@end
