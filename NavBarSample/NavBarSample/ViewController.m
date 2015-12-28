
#import "ViewController.h"
#import "VC1.h"

static ViewController * _instance;

@interface ViewController ()
@property BOOL firstlayout;
@end

@implementation ViewController

+ (ViewController *) instance; {
	return _instance;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	_instance = self;
	
	self.viewStack.alwaysResizePushedViews = TRUE;
	self.navBarStack.alwaysResizePushedViews = TRUE;
	
	VC1 * vc1 = [[VC1 alloc] init];
	[self.viewStack pushViewController:vc1 animated:FALSE];
	self.firstlayout = TRUE;
}


@end
