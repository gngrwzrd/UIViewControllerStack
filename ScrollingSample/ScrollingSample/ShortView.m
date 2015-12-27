
#import "ShortView.h"
#import "TallView.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface ShortView ()
@end

@implementation ShortView

- (void) viewDidLoad {
	[super viewDidLoad];
	if([ViewController instance].viewStack.rootViewController == self) {
		self.backButton.hidden = TRUE;
	}
}

- (IBAction) pushTallVC:(id) sender {
	TallView * tallvc = [[TallView alloc] init];
	[[ViewController instance].viewStack pushViewController:tallvc animated:TRUE];
}

- (IBAction) onBack:(id)sender {
	[[ViewController instance].viewStack popViewControllerAnimated:TRUE];
}

@end
