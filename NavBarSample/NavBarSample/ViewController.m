
#import "ViewController.h"
#import "VC1.h"

static ViewController * _instance;

@interface ViewController ()
@end

@implementation ViewController

+ (ViewController *) instance; {
	return _instance;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	_instance = self;
	
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	UIColor * color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
	self.navColor = color;
	
	self.viewStack.resizeViews = TRUE;
	self.viewStack.delegate = self;
	
	self.navBarStack.backgroundColor = self.navColor;
	self.navBarStack.swipeToPop = FALSE;
	self.navBarStack.useShadows = FALSE;
	self.navBarStack.resizeViews = TRUE;
	self.navBarStack.animatesAlpha = TRUE;
	self.navBarStack.delegate = self;
	
	VC1 * vc1 = [[VC1 alloc] init];
	[self.viewStack pushViewController:vc1 animated:FALSE];
}

- (void) viewStackWillPop:(UIViewControllerStack *)viewStack toController:(UIViewController *)toController fromController:(UIViewController *)fromController wasAnimated:(BOOL) wasAnimated {
	if(viewStack == self.viewStack) {
		[self.navBarStack popViewControllerAnimated:wasAnimated];
	}
}

- (void) viewStackSwipeGestureWillStart:(UIViewControllerStack *)viewStack {
	if(viewStack == self.viewStack) {
		[self.navBarStack beginSwipeGestureAnimationUpdates];
	}
}

- (void) viewStackSwipeGestureDidUpdate:(UIViewControllerStack *)viewStack delta:(CGFloat)delta {
	if(viewStack == self.viewStack) {
		[self.navBarStack updateSwipeGestureWithDelta:delta adjustDistanceMoved:TRUE];
	}
}

- (void) viewStackSwipeGestureDidEnd:(UIViewControllerStack *)viewStack didPop:(BOOL)didPop {
	if(viewStack == self.viewStack) {
		[self.navBarStack endSwipeGestureAnimationUpdatesShouldPop:didPop];
	}
}

- (CGFloat) startXForToController:(UIViewController *)viewController forViewStack:(UIViewControllerStack *)viewStack forOperation:(UIViewControllerStackOperation)operation {
	if(viewStack == self.navBarStack) {
		if(operation == UIViewControllerStackOperationPush) {
			return viewController.view.frame.size.width * viewStack.distance;
		}
		
		if(operation == UIViewControllerStackOperationPop) {
			return -(viewController.view.frame.size.width * viewStack.distance);
		}
	}
	return CGFLOAT_MAX;
}

- (CGFloat) endXForFromController:(UIViewController *)viewController forViewStack:(UIViewControllerStack *)viewStack forOperation:(UIViewControllerStackOperation)operation {
	if(viewStack == self.navBarStack) {
		if(operation == UIViewControllerStackOperationPush) {
			return -(viewController.view.frame.size.width * viewStack.distance);
		}
		
		if(operation == UIViewControllerStackOperationPop) {
			return viewController.view.frame.size.width * viewStack.distance;
		}
	}
	return CGFLOAT_MAX;
}

@end
