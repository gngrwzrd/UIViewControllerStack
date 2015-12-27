
#import "UIViewControllerStackNavBar.h"

@interface UIViewControllerStack ()
- (void) defaultInit;
@end

@implementation UIViewControllerStackNavBar

- (void) defaultInit {
	[super defaultInit];
	self.animatesAlpha = TRUE;
}

- (id) init {
	self = [super init];
	[self defaultInit];
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self defaultInit];
	return self;
}

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self defaultInit];
	return self;
}

//below override methods set the start / end points only a quarter of the screen.

- (CGPoint) startPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	if(operation == UIViewControllerStackOperationPush) {
		return CGPointMake(self.frame.size.width/6,0);
	}
	
	if(operation == UIViewControllerStackOperationPop) {
		return CGPointMake(-(viewController.view.frame.size.width/6),0);
	}
	
	return CGPointZero;
}

- (CGPoint) endPointForToController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	return CGPointMake(0,0);
}

- (CGPoint) endPointForFromController:(UIViewController *) viewController forOperation:(UIViewControllerStackOperation) operation {
	if(operation == UIViewControllerStackOperationPush) {
		return CGPointMake(-(viewController.view.frame.size.width/6),0);
	}
	
	if(operation == UIViewControllerStackOperationPop) {
		return CGPointMake(viewController.view.frame.size.width/6,0);
	}
	
	return CGPointZero;
}

@end
