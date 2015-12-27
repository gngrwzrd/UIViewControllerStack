
#import <UIKit/UIKit.h>

@class UIViewControllerStack;

//UIViewControllerParentViewStack category - use to get a view controllers parent view stack controller.
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

//protocol to notify view controllers of updates
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

IB_DESIGNABLE
@interface UIViewControllerStack : UIView

//animation duration for push/popping view controllers that slide in / out.
@property IBInspectable CGFloat animationDuration;

//whether to animate alpha as views are being pushed / popped.
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

@end
