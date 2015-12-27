
#import <UIKit/UIKit.h>
#import "UIViewControllerStack.h"
#import "UIViewControllerStackNavBar.h"

@interface ViewController : UIViewController

@property IBOutlet UIViewControllerStack * viewStack;
@property IBOutlet UIViewControllerStackNavBar * navBarStack;

+ (ViewController *) instance;

@end
