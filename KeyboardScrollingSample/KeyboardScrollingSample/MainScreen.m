
#import "MainScreen.h"
#import "Signup.h"
#import "UIViewControllerStack.h"

@interface MainScreen ()
@end

@implementation MainScreen

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) onSignup:(id)sender {
	UIViewControllerStack * stack = [self parentViewControllerStack];
	Signup * signup = [[Signup alloc] init];
	[stack pushViewController:signup animated:TRUE];
}

@end
