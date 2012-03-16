#import <UIKit/UIKit.h>
#import "CDSModel.h"
#import "CDSProject.h"

@interface CDSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) CDSProject *project;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) CDSModel *model;

@end
