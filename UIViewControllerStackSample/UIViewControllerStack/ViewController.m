
#import "ViewController.h"
#import "VC.h"

@interface ViewController ()
@end

@implementation ViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.viewStack.resizeViews = TRUE;
	VC * vc = [[VC alloc] init];
	[self.viewStack pushViewController:vc animated:FALSE];
}

@end
