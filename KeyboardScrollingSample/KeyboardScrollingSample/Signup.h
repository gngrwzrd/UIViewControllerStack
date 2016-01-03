
#import <UIKit/UIKit.h>
#import "UIViewControllerStack.h"
#import "UIScrollableViewController.h"

@interface Signup : UIScrollableViewController <UIViewControllerStackUpdating,UITextFieldDelegate>

@property IBOutletCollection(UITextField) NSArray * fields;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@end
