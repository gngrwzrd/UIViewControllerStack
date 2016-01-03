
#import "VC2.h"
#import "VC2Nav.h"
#import "ViewController.h"

@implementation VC2

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) viewStack:(UIViewControllerStack *)viewStack willShowView:(UIViewControllerStackOperation)operation wasAnimated:(BOOL)wasAnimated {
	if(operation == UIViewControllerStackOperationPush) {
		VC2Nav * nav = [[VC2Nav alloc] init];
		[[ViewController instance].navBarStack pushViewController:nav animated:wasAnimated];
	}
}

@end
