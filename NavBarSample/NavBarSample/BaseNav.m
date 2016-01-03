
#import "BaseNav.h"
#import "ViewController.h"

@interface BaseNav ()
@end

@implementation BaseNav

- (void) viewDidLoad {
	[super viewDidLoad];
	if([ViewController instance].viewStack.allViewControllers.count == 1) {
		self.popButton.hidden = TRUE;
	}
}

- (IBAction) onPop:(id) sender {
	[[ViewController instance].viewStack popViewControllerAnimated:TRUE];
}

@end
