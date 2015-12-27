
#import "BaseVC.h"
#import "VC1.h"
#import "VC2.h"
#import "ViewController.h"

@interface BaseVC ()
@end

@implementation BaseVC

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) push1:(id)sender {
	VC1 * vc = [[VC1 alloc] init];
	[[ViewController instance].viewStack pushViewController:vc animated:TRUE];
}

- (IBAction) push2:(id) sender {
	VC2 * vc = [[VC2 alloc] init];
	[[ViewController instance].viewStack pushViewController:vc animated:TRUE];
}

@end
