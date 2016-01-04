
#import <UIKit/UIKit.h>
#import "UIViewControllerStack.h"

@interface ViewController : UIViewController <UIViewControllerStackDelegate>

@property IBOutlet UIViewControllerStack * viewStack;
@property IBOutlet UIViewControllerStack * navBarStack;
@property UIColor * navColor;

+ (ViewController *) instance;

@end
