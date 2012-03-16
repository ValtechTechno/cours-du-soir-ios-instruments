#import <UIKit/UIKit.h>
#import "CDSProject.h"

@interface CDSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) CDSProject *detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
