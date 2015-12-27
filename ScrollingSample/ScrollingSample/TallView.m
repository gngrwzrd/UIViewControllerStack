
#import "TallView.h"
#import "ShortView.h"
#import "ViewController.h"

@interface TallView ()
@property CGFloat nibHeight;
@end

@implementation TallView

- (void) viewDidLoad {
	[super viewDidLoad];
	self.nibHeight = self.view.frame.size.height;
}

- (CGFloat) minViewHeightForViewStackController:(UIViewControllerStack *)viewStack {
	return self.nibHeight;
}

- (BOOL) viewStackShouldBecomeScrollable:(UIViewControllerStack *) viewStack {
	return TRUE;
}

- (IBAction) pushMain:(id) sender {
	ShortView * main = [[ShortView alloc] init];
	[[ViewController instance].viewStack pushViewController:main animated:TRUE];
}

- (IBAction) onBack:(id)sender {
	[[ViewController instance].viewStack popViewControllerAnimated:TRUE];
}

@end
