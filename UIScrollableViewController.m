
#import "UIScrollableViewController.h"

@interface UIScrollableViewController ()
@property BOOL _firstlayout;
@property CGFloat _nibHeight;
@end

@implementation UIScrollableViewController

- (void) viewDidLoad {
	self._nibHeight = self.contentView.frame.size.height;
}

- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if(!self._firstlayout) {
		self._firstlayout = TRUE;
		self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self._nibHeight);
		self.contentView.frame = CGRectMake(0,0,self.view.frame.size.width,self._nibHeight);
		[self.scrollView addSubview:self.contentView];
	}
}

@end
