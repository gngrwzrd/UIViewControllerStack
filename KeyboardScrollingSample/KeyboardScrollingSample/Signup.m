
#import "Signup.h"

@interface Signup ()
@property BOOL firstlayout;
@property CGFloat nibHeight;
@end

@implementation Signup

- (void) viewDidLoad {
	[super viewDidLoad];
	self.nibHeight = self.contentView.frame.size.height;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShown:) name:UIKeyboardDidShowNotification object:nil];
	for(UITextField * field in self.fields) {
		field.delegate = self;
	}
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:TRUE];
	return TRUE;
}

- (void) onKeyboardShown:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	CGFloat keyboardHeight = keyboardFrameEnd.size.height;
	self.scrollViewBottom.constant = keyboardHeight;
}

- (IBAction) onSignup:(id) sender {
	[self.view endEditing:TRUE];
	UIViewControllerStack * stack = [self parentViewControllerStack];
	[stack popViewControllerAnimated:TRUE];
}

@end
