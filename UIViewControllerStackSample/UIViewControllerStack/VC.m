
#import "VC.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface VC ()
@end

@implementation VC

- (void) viewDidLoad {
	[super viewDidLoad];
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	UIColor * color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
	self.view.backgroundColor = color;
	
	AppDelegate * delegate = [UIApplication sharedApplication].delegate;
	ViewController * mainvc = (ViewController *)delegate.window.rootViewController;
	if(mainvc.viewStack.allViewControllers.count == 1) {
		self.popButton.hidden = TRUE;
	}
}

- (IBAction) push:(id)sender {
	VC * vc = [[VC alloc] init];
	AppDelegate * delegate = [UIApplication sharedApplication].delegate;
	ViewController * mainvc = (ViewController *)delegate.window.rootViewController;
	[mainvc.viewStack pushViewController:vc animated:TRUE];
}

- (IBAction) pop:(id)sender {
	AppDelegate * delegate = [UIApplication sharedApplication].delegate;
	ViewController * mainvc = (ViewController *)delegate.window.rootViewController;
	[mainvc.viewStack popViewControllerAnimated:TRUE];
}

@end
