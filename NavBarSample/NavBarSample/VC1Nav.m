
#import "VC1Nav.h"
#import "ViewController.h"

@interface VC1Nav ()
@end

@implementation VC1Nav

- (void) viewDidLoad {
	[super viewDidLoad];
	if([ViewController instance].viewStack.allViewControllers.count == 1) {
		self.popButton.hidden = TRUE;
	}
	self.view.backgroundColor = [ViewController instance].navColor;
}

- (IBAction) onPop:(id) sender {
	[[ViewController instance].viewStack popViewControllerAnimated:TRUE];
}

@end
