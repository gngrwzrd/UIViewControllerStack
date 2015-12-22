
#import "RootViewController.h"

@implementation RootViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.viewStack.animatesAlpha = TRUE;
}

- (IBAction) onStart:(id) sender {
	HomeViewController * home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	[self.viewStack pushViewController:home animated:FALSE];
}

@end
