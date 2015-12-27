
#import "ViewController.h"
#import "ShortView.h"
#import "AppDelegate.h"

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
	self.viewStack.alwaysResizePushedViews = TRUE;
	
	ShortView * shortview = [[ShortView alloc] init];
	[self.viewStack pushViewController:shortview animated:FALSE];
}

@end
