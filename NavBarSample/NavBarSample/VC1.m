
#import "VC1.h"
#import "ViewController.h"
#import "VC1Nav.h"

@interface VC1 ()
@end

@implementation VC1

- (void) viewDidLoad {
	[super viewDidLoad];
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	UIColor * color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
	self.view.backgroundColor = color;
}

- (IBAction) push:(id)sender {
	VC1 * vc = [[VC1 alloc] init];
	[[ViewController instance].viewStack pushViewController:vc animated:TRUE];
}

- (void) viewStack:(UIViewControllerStack *)viewStack willShowView:(UIViewControllerStackOperation)operation wasAnimated:(BOOL)wasAnimated {
	if(operation == UIViewControllerStackOperationPush) {
		VC1Nav * nav = [[VC1Nav alloc] init];
		[[ViewController instance].navBarStack pushViewController:nav animated:wasAnimated];
	}
}

@end
