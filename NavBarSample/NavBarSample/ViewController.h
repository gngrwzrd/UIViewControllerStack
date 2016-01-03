
#import <UIKit/UIKit.h>
#import "UIViewControllerStack.h"

@interface ViewController : UIViewController <UIViewControllerStackDelegate>

@property IBOutlet UIViewControllerStack * viewStack;
@property IBOutlet UIViewControllerStack * navBarStack;

+ (ViewController *) instance;

@end
