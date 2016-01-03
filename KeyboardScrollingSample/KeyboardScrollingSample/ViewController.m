
#import "ViewController.h"
#import "MainScreen.h"

@interface ViewController ()
@property BOOL firstload;
@end

@implementation ViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.viewStack.alwaysResizePushedViews = TRUE;
	MainScreen * main = [[MainScreen alloc] init];
	[self.viewStack pushViewController:main animated:FALSE];
}

@end
