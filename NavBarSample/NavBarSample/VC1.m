
#import "VC1.h"
#import "ViewController.h"
#import "VC1Nav.h"

@interface VC1 ()
@end

@implementation VC1

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) viewStack:(UIViewControllerStack *)viewStack willShowView:(UIViewControllerStackOperation)operation wasAnimated:(BOOL)wasAnimated {
	if(operation == UIViewControllerStackOperationPush) {
		VC1Nav * nav = [[VC1Nav alloc] init];
		[[ViewController instance].navBarStack pushViewController:nav animated:wasAnimated];
	}
}

@end
