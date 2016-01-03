
#import "UIViewControllerStack.h"

//notifications
NSString * const UIViewControllerStackNotificationWillPush = @"UIViewControllerStackNotificationWillPush";
NSString * const UIViewControllerStackNotificationDidPush = @"UIViewControllerStackNotificationDidPush";
NSString * const UIViewControllerStackNotificationWillPop = @"UIViewControllerStackNotificationWillPop";
NSString * const UIViewControllerStackNotificationDidPop = @"UIViewControllerStackNotificationDidPop";
NSString * const UIViewControllerStackNotificationUserInfoToControllerKey = @"UIViewControllerStackNotificationUserInfoToControllerKey";
NSString * const UIViewControllerStackNotificationUserInfoFromControllerKey = @"UIViewControllerStackNotificationUserInfoFromControllerKey";

//UIViewControllerParentViewStack addition
@implementation UIViewController (UIViewControllerParentViewStack)
- (UIViewControllerStack *) parentViewControllerStack; {
	UIView * superview = self.view.superview;
	NSInteger count = 20;
	while(superview && count > -1) {
		if([superview isKindOfClass:[UIViewControllerStack class]]) {
			return (UIViewControllerStack *)superview;
		}
		superview = superview.superview;
		count--;
	}
	return nil;
}
@end

//UIViewControllerStack
@interface UIViewControllerStack ()
@property NSMutableArray * viewControllers;
@property CGPoint swipeLocation;
@property UIPanGestureRecognizer * panGesture;
@end

@implementation UIViewControllerStack

- (void) defaultInit {
	self.viewControllers = [NSMutableArray array];
	self.animationDuration = .25;
	self.moveAmount = 8;
	self.finishDragAnimationDuration = .1;
	self.animatesAlpha = FALSE;
	self.swipeToPop = TRUE;
	self.useLayerShadowProperties = TRUE;
}

- (id) init {
	self = [super init];
	[self defaultInit];
	return self;
}

- (id) initWithCoder:(NSCoder *) aDecoder {
	self = [super initWithCoder:aDecoder];
	[self defaultInit];
	return self;
}

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	[self defaultInit];
	return self;
}

- (void) dealloc {
	if(self.panGesture) {
		[self removeGestureRecognizer:self.panGesture];
	}
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self resizeViewController:self.currentViewController];
}

- (BOOL) swipeToPop {
	return self.panGesture != nil;
}

- (void) setSwipeToPop:(BOOL)swipeToPop {
	if(swipeToPop) {
		[self addPanGestureRecognizer];
	} else if(self.panGesture) {
		[self removeGestureRecognizer:self.panGesture];
		self.panGesture = nil;
	}
}

- (void) addPanGestureRecognizer {
	if(!self.panGesture) {
		self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
	}
	[self removeGestureRecognizer:self.panGesture];
	[self addGestureRecognizer:self.panGesture];
}

- (void) removeShadowsForViewController:(UIViewController *) viewController {
	viewController.view.layer.shadowOpacity = 0;
	viewController.view.layer.shadowColor = nil;
	viewController.view.layer.shadowOffset = CGSizeZero;
	viewController.view.layer.shadowRadius = 0;
}

- (void) addShadowForViewController:(UIViewController *) viewController {
	if(!self.useLayerShadowProperties) {
		return;
	}
	viewController.view.layer.shadowOffset = CGSizeMake(0, 0);
	viewController.view.layer.shadowRadius = 4;
	viewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	viewController.view.layer.shadowOpacity = .3;
}

- (void) beginSwipeGestureAnimationUpdates {
	[self panGestureStart:nil];
}

- (void) updateSwipeGestureWithDelta:(CGFloat) delta useMoveAmount:(BOOL) useMoveAmount {
	UIViewController * popController = [self.viewControllers objectAtIndex:(self.viewControllers.count-2)];
	UIViewController * current = self.currentViewController;
	
	CGRect currentFrame = current.view.frame;
	CGFloat fraction = 1;
	CGFloat update = 1;
	CGFloat distance = 1;
	
	if(useMoveAmount) {
		update = self.frame.size.width / (currentFrame.size.width / self.moveAmount);
	}
	currentFrame.origin.x += delta/update;
	
	if(currentFrame.origin.x < 0) {
		currentFrame.origin.x = 0;
		current.view.frame = currentFrame;
		return;
	}
	
	current.view.frame = currentFrame;
	
	if(self.animatesAlpha) {
		distance = self.frame.size.width / self.moveAmount;
		fraction = (1 / distance);
		update = (distance - currentFrame.origin.x) * fraction;
		current.view.alpha = update;
	}
	
	CGRect popFrame = popController.view.frame;
	fraction = self.frame.size.width / (popFrame.size.width / self.moveAmount);
	update = delta/fraction;
	popFrame.origin.x += update;
	popController.view.frame = popFrame;
	
	if(self.animatesAlpha) {
		popController.view.alpha = (1 / self.frame.size.width) * currentFrame.origin.x;
	}
}

- (void) endSwipeGestureAnimationUpdatesShouldPop:(BOOL) shouldPop {
	
	UIViewController * popController = [self.viewControllers objectAtIndex:(self.viewControllers.count-2)];
	UIViewController * current = self.currentViewController;
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	__block CGRect currentFrame = current.view.frame;
	__block CGRect popFrame = popController.view.frame;
	
	if(!shouldPop) {
		
		if([self.delegate respondsToSelector:@selector(viewStackSwipeGestureDidEnd:didPop:)]) {
			[self.delegate viewStackSwipeGestureDidEnd:self didPop:FALSE];
		}
		
		[UIView animateWithDuration:self.finishDragAnimationDuration delay:0 options:options animations:^{
			
			currentFrame.origin.x = 0;
			current.view.frame = currentFrame;
			current.view.alpha = 1;
			popFrame.origin = [self endPointForFromController:popController forOperation:UIViewControllerStackOperationPush];
			popController.view.frame = popFrame;
			popController.view.alpha = 1;
			
		} completion:^(BOOL finished) {
			
			[self removeShadowsForViewController:current];
			
		}];
		
	} else {
		
		if([self.delegate respondsToSelector:@selector(viewStackSwipeGestureDidEnd:didPop:)]) {
			[self.delegate viewStackSwipeGestureDidEnd:self didPop:TRUE];
		}
		
		[UIView animateWithDuration:self.finishDragAnimationDuration delay:0 options:options animations:^{
			
			if(self.animatesAlpha) {
				current.view.alpha = 0;
				popController.view.alpha = 1;
			}
			
			currentFrame.origin = [self endPointForFromController:current forOperation:UIViewControllerStackOperationPop];
			current.view.frame = currentFrame;
			popFrame.origin = [self endPointForToController:popController forOperation:UIViewControllerStackOperationPop];
			popController.view.frame = popFrame;
			
		} completion:^(BOOL finished) {
			
			UIViewController * current = [self currentViewControllerByRemovingLastObject];
			[self removeShadowsForViewController:current];
			[current.view removeFromSuperview];
			
		}];
	}
}

- (void) panGestureStart:(UIPanGestureRecognizer *) pan {
	UIViewController * popController = [self.viewControllers objectAtIndex:(self.viewControllers.count-2)];
	UIViewController * current = self.currentViewController;
	if([self.delegate respondsToSelector:@selector(viewStackSwipeGestureWillStart:)]) {
		[self.delegate viewStackSwipeGestureWillStart:self];
	}
	[self addShadowForViewController:current];
	if(pan) {
		self.swipeLocation = [pan locationInView:self];
	}
	CGRect popFrame = popController.view.frame;
	popFrame.origin = [self startPointForToController:popController forOperation:UIViewControllerStackOperationPop];
	popController.view.frame = popFrame;
	[self insertSubview:popController.view atIndex:0];
}

- (void) panGestureUpdate:(UIPanGestureRecognizer *) pan {
	CGPoint location = [pan locationInView:self];
	CGFloat diff = location.x - self.swipeLocation.x;
	if([self.delegate respondsToSelector:@selector(viewStackSwipeGestureDidUpdate:delta:)]) {
		[self.delegate viewStackSwipeGestureDidUpdate:self delta:diff];
	}
	[self updateSwipeGestureWithDelta:diff useMoveAmount:FALSE];
	self.swipeLocation = location;
}

- (void) panGestureEnd:(UIPanGestureRecognizer *) pan {
	UIViewController * current = self.currentViewController;
	__block CGRect currentFrame = current.view.frame;
	self.swipeLocation = CGPointZero;
	if(currentFrame.origin.x < self.frame.size.width/2) {
		[self endSwipeGestureAnimationUpdatesShouldPop:FALSE];
	} else {
		[self endSwipeGestureAnimationUpdatesShouldPop:TRUE];
	}
}

- (void) onPan:(UIPanGestureRecognizer *) pan {
	if(self.viewControllers.count < 2) {
		return;
	}
	
	if(pan.state == UIGestureRecognizerStateBegan) {
		[self panGestureStart:pan];
	}
	
	else if(pan.state == UIGestureRecognizerStateChanged) {
		[self panGestureUpdate:pan];
	}
	
	else if(pan.state == UIGestureRecognizerStateEnded) {
		[self panGestureEnd:pan];
	}
}

- (void) resizeViewController:(UIViewController *) viewController {
	if(!viewController) {
		return;
	}
	
	BOOL updatedFrame = FALSE;
	CGRect f = viewController.view.frame;
	UIViewController <UIViewControllerStackUpdating> * updating = (UIViewController <UIViewControllerStackUpdating> *) viewController;
	
	if(self.alwaysResizePushedViews) {
		f.size.width = self.frame.size.width;
		f.size.height = self.frame.size.height;
		updatedFrame = TRUE;
	}
	
	if([updating respondsToSelector:@selector(shouldResizeFrameForStackPush:)]) {
		BOOL resize = [updating shouldResizeFrameForStackPush:self];
		if(resize) {
			f.size.width = self.frame.size.width;
			f.size.height = self.frame.size.height;
			updatedFrame = TRUE;
		}
	}
	
	if(!CGRectEqualToRect(f,viewController.view.frame)) {
		viewController.view.frame = f;
	}
	
	if([updating respondsToSelector:@selector(viewStackDidResizeViewController:)]) {
		[updating viewStackDidResizeViewController:self];
	}
}

- (CGPoint) startPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	if([self.delegate respondsToSelector:@selector(startXForToController:forViewStack:forOperation:)]) {
		CGFloat x = [self.delegate startXForToController:viewController forViewStack:self forOperation:operation];
		if(x != CGFLOAT_MAX) {
			return CGPointMake(x,0);
		}
	}
	
	if(operation == UIViewControllerStackOperationPush) {
		return CGPointMake(self.frame.size.width,0);
	}
	
	if(operation == UIViewControllerStackOperationPop) {
		return CGPointMake(-(viewController.view.frame.size.width/self.moveAmount),0);
	}
	
	return CGPointZero;
}

- (CGPoint) endPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	if([self.delegate respondsToSelector:@selector(endXForToController:forViewStack:forOperation:)]) {
		CGFloat x = [self.delegate endXForToController:viewController forViewStack:self forOperation:operation];
		if(x != CGFLOAT_MAX) {
			return CGPointMake(x,0);
		}
	}
	return CGPointMake(0,0);
}

- (CGPoint) endPointForFromController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	if([self.delegate respondsToSelector:@selector(endXForFromController:forViewStack:forOperation:)]) {
		CGFloat x = [self.delegate endXForFromController:viewController forViewStack:self forOperation:operation];
		if(x != CGFLOAT_MAX) {
			return CGPointMake(x,0);
		}
	}
	
	if(operation == UIViewControllerStackOperationPush) {
		return CGPointMake(-(viewController.view.frame.size.width/self.moveAmount),0);
	}
	
	if(operation == UIViewControllerStackOperationPop) {
		return CGPointMake(viewController.view.frame.size.width,0);
	}
	
	return CGPointZero;
}

- (void) pushFromController:(UIViewController *) fromController toController:(UIViewController *) toController withDuration:(CGFloat) duration {
	UIViewController <UIViewControllerStackUpdating> * toControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)toController;
	UIViewController <UIViewControllerStackUpdating> * fromControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)fromController;
	
	//resize view controllers
	[self resizeViewController:fromController];
	[self resizeViewController:toController];
	
	//add shadow to next controller
	[self addShadowForViewController:toController];
	
	//move view controller off to right side and add as subview
	CGRect f = toController.view.frame;
	f.origin = [self startPointForToController:toController forOperation:UIViewControllerStackOperationPush];
	toController.view.frame = f;
	
	//add subview
	[self addSubview:toController.view];
	
	//setup animation options
	UIViewAnimationOptions options = 0;
	options |= UIViewAnimationOptionCurveEaseInOut;
	
	//setup/post notification info
	NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
	
	//notify the view controllers of what's about to happen
	if(fromController) {
		if([fromController respondsToSelector:@selector(viewStack:willHideView:wasAnimated:)]) {
			[fromControllerUpdating viewStack:self willHideView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
		}
		[userInfo setObject:fromController forKey:UIViewControllerStackNotificationUserInfoFromControllerKey];
	}
	
	if(toController) {
		if([toController respondsToSelector:@selector(viewStack:willShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self willShowView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
		}
		[userInfo setObject:toController forKey:UIViewControllerStackNotificationUserInfoToControllerKey];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationWillPush object:self userInfo:userInfo];
	
	//if duration is 0, set everything immediately without UIView animations.
	//using UIView animation with a duration of 0 has a slight noticeable movement.
	if(duration == 0) {
		
		CGRect f;
		
		if(fromController) {
			f = fromController.view.frame;
			f.origin = [self endPointForFromController:fromController forOperation:UIViewControllerStackOperationPush];
			fromController.view.frame = f;
			[fromController.view removeFromSuperview];
			fromController.view.alpha = 1;
			if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
				[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
			}
		}
		
		if(toController) {
			f = toController.view.frame;
			f.origin = [self endPointForToController:toController forOperation:UIViewControllerStackOperationPush];
			toController.view.frame = f;
			toController.view.alpha = 1;
			if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
				[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
			}
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationDidPush object:userInfo];
		
		return;
	}
	
	//set alpha
	if(self.animatesAlpha) {
		toController.view.alpha = 0;
	}
	
	//trigger animation, moving current off to the left, new view controller in from the right.
	[UIView animateWithDuration:duration delay:0 options:options animations:^{
		CGRect f;
		
		if(fromController) {
			f = fromController.view.frame;
			f.origin = [self endPointForFromController:fromController forOperation:UIViewControllerStackOperationPush];
			fromController.view.frame = f;
			if(self.animatesAlpha) {
				fromController.view.alpha = 0;
			}
		}
		
		if(toController) {
			f = toController.view.frame;
			f.origin = [self endPointForToController:toController forOperation:UIViewControllerStackOperationPush];
			toController.view.frame = f;
			if(self.animatesAlpha) {
				toController.view.alpha = 1;
			}
		}
		
	} completion:^(BOOL finished) {
		
		if(fromController) {
			[fromController.view removeFromSuperview];
			fromController.view.alpha = 1;
			
			if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
				[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
			}
		}
		
		if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
		}
		
		[self removeShadowsForViewController:toController];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationDidPush object:userInfo];
	}];
}

- (void) popFromController:(UIViewController *) fromController toController:(UIViewController *) toController withDuration:(CGFloat) duration {
	UIViewController <UIViewControllerStackUpdating> * toControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)toController;
	UIViewController <UIViewControllerStackUpdating> * fromControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)fromController;
	
	//resize view controllers
	[self resizeViewController:fromController];
	[self resizeViewController:toController];
	
	//move the next view controller off to left of host view and add as subview
	if(toController) {
		
		//get start point for toController
		CGRect f = toController.view.frame;
		f.origin = [self startPointForToController:toController forOperation:UIViewControllerStackOperationPop];
		toController.view.frame = f;
		
		//animate alpha
		if(self.animatesAlpha) {
			toController.view.alpha = 0;
		}
		
		//add subview
		[self insertSubview:toController.view atIndex:0];
	}
	
	//setup animation options
	UIViewAnimationOptions options = 0;
	options |= UIViewAnimationOptionCurveEaseInOut;
	
	//setup/post notification user info
	NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
	
	//notify view controllers of what's about to happen
	if(fromController) {
		if([fromController respondsToSelector:@selector(viewStack:willHideView:wasAnimated:)]) {
			[fromControllerUpdating viewStack:self willHideView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
		}
		[userInfo setObject:fromController forKey:UIViewControllerStackNotificationUserInfoFromControllerKey];
	}
	
	if(toController) {
		if([toController respondsToSelector:@selector(viewStack:willShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self willShowView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
		}
		[userInfo setObject:toController forKey:UIViewControllerStackNotificationUserInfoToControllerKey];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationWillPop object:self userInfo:userInfo];
	
	//if duration is 0, set everything immediately without UIView animations.
	//using UIView animation with a duration of 0 has a slight noticeable movement.
	if(duration == 0) {
		
		if([self.delegate respondsToSelector:@selector(viewStackWillPop:toController:fromController:wasAnimated:)]) {
			[self.delegate viewStackWillPop:self toController:toController fromController:fromController wasAnimated:FALSE];
		}
		
		CGRect f;
		
		if(fromController) {
			f = fromController.view.frame;
			f.origin = [self endPointForFromController:fromController forOperation:UIViewControllerStackOperationPop];
			fromController.view.frame = f;
			[fromController.view removeFromSuperview];
			fromController.view.alpha = 1;
			if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
				[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
			}
		}
		
		if(toController) {
			f = toController.view.frame;
			f.origin = [self endPointForToController:toController forOperation:UIViewControllerStackOperationPop];
			toController.view.frame = f;
			toController.view.alpha = 1;
			if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
				[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
			}
		}
		
		if([self.delegate respondsToSelector:@selector(viewStackDidPop:toController:fromController:wasAnimated:)]) {
			[self.delegate viewStackDidPop:self toController:toController fromController:fromController wasAnimated:FALSE];
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationDidPop object:self userInfo:userInfo];
		
		return;
	}
	
	[self addShadowForViewController:fromController];
	
	if([self.delegate respondsToSelector:@selector(viewStackWillPop:toController:fromController:wasAnimated:)]) {
		[self.delegate viewStackWillPop:self toController:toController fromController:fromController wasAnimated:TRUE];
	}
	
	//trigger animation, moving popped off to right, next view controller in from the left
	[UIView animateWithDuration:duration delay:0 options:options animations:^{
		
		CGRect f;
		
		if(fromController) {
			f = fromController.view.frame;
			f.origin = [self endPointForFromController:fromController forOperation:UIViewControllerStackOperationPop];
			fromController.view.frame = f;
			if(self.animatesAlpha) {
				fromController.view.alpha = 0;
			}
		}
		
		if(toController) {
			f = toController.view.frame;
			f.origin = [self endPointForToController:toController forOperation:UIViewControllerStackOperationPop];
			toController.view.frame = f;
			if(self.animatesAlpha) {
				toController.view.alpha = 1;
			}
		}
		
	} completion:^(BOOL finished) {
		
		if(fromController) {
			[fromController.view removeFromSuperview];
			fromController.view.alpha = 1;
			
			if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
				[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
			}
		}
		
		if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
		}
		
		[self removeShadowsForViewController:fromController];
		
		if([self.delegate respondsToSelector:@selector(viewStackDidPop:toController:fromController:wasAnimated:)]) {
			[self.delegate viewStackDidPop:self toController:toController fromController:fromController wasAnimated:TRUE];
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerStackNotificationDidPop object:self userInfo:userInfo];
	}];
}

- (void) pushViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	
	UIViewController * current = [self currentViewController];
	[self.viewControllers addObject:viewController];
	[self pushFromController:current toController:viewController withDuration:duration];
}

- (void) pushViewControllers:(NSArray *) viewControllers animated:(BOOL) animated; {
	UIViewController * current = self.currentViewController;
	[self.viewControllers addObjectsFromArray:viewControllers];
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	[self pushFromController:current toController:self.viewControllers.lastObject withDuration:duration];
}

- (void) pushViewControllers:(NSArray *) viewControllers; {
	[self.viewControllers addObjectsFromArray:viewControllers];
}

- (void) insertViewController:(UIViewController *) viewController atIndex:(NSInteger) index; {
	[self.viewControllers insertObject:viewController atIndex:index];
}

- (void) popViewControllerAnimated:(BOOL) animated; {
	if(self.viewControllers.count == 1) {
		return;
	}
	UIViewController * current = [self currentViewControllerByRemovingLastObject];
	UIViewController * nxt = [self currentViewController];
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	[self popFromController:current toController:nxt withDuration:duration];
}

- (void) popToRootViewControllerAnimated:(BOOL) animated; {
	UIViewController * current = [self currentViewController];
	UIViewController * nxt = self.viewControllers[0];
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	[self popFromController:current toController:nxt withDuration:duration];
	[self.viewControllers removeAllObjects];
	[self.viewControllers addObject:nxt];
}

- (void) eraseStackAndPushViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	[self pushFromController:self.currentViewController toController:viewController withDuration:duration];
	[self.viewControllers removeAllObjects];
	[self.viewControllers addObject:viewController];
}

- (void) replaceCurrentViewControllerWithViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	UIViewController * currentViewController = [self currentViewControllerByRemovingLastObject];
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	[self pushFromController:currentViewController toController:viewController withDuration:duration];
	[_viewControllers addObject:viewController];
}

- (void) replaceViewController:(UIViewController *) viewController withViewController:(UIViewController *) newViewController; {
	NSInteger index = [self.viewControllers indexOfObject:viewController];
	if(index != NSNotFound) {
		[self.viewControllers replaceObjectAtIndex:index withObject:newViewController];
	}
}

- (UIViewController *) currentViewController {
	if(self.viewControllers.count > 0) {
		return [self.viewControllers lastObject];
	}
	return nil;
}

- (UIViewController *) rootViewController; {
	return self.viewControllers.firstObject;
}

- (UIViewController *) currentViewControllerByRemovingLastObject {
	UIViewController * current = [self currentViewController];
	if(current) {
		[self.viewControllers removeLastObject];
	}
	return current;
}

- (BOOL) canPopViewController {
	return self.viewControllers.count > 1;
}

- (NSInteger) stackSize {
	return self.viewControllers.count;
}

- (NSArray *) allViewControllers; {
	return [NSArray arrayWithArray:self.viewControllers];
}

- (void) popToViewControllerAtIndex:(NSUInteger) index animated:(BOOL) animated {
	if(index == 0) {
		[self popToRootViewControllerAnimated:TRUE];
		return;
	}
	if(index == self.viewControllers.count - 1) {
		return;
	}
	UIViewController * toController = [self.viewControllers objectAtIndex:index];
	UIViewController * fromController = self.currentViewController;
	float duration = 0;
	if(animated) {
		duration = self.animationDuration;
	}
	NSUInteger location = index + 1;
	NSUInteger length = self.viewControllers.count - location;
	[self.viewControllers removeObjectsInRange:NSMakeRange(location,length)];
	[self popFromController:fromController toController:toController withDuration:duration];
}

- (BOOL) hasViewController:(UIViewController *) viewController {
	for(UIViewController * vc in self.viewControllers) {
		if(vc == viewController) {
			return TRUE;
		}
	}
	return FALSE;
}

- (BOOL) hasViewControllerClass:(Class)cls {
	for(UIViewController * vc in self.viewControllers) {
		if([vc class] == cls) {
			return TRUE;
		}
	}
	return FALSE;
}

- (void) eraseStack {
	for(UIViewController * vc in self.viewControllers) {
		[vc.view removeFromSuperview];
	}
	[self.viewControllers removeAllObjects];
}

@end
