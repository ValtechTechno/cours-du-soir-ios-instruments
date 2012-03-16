#import <UIKit/UIKit.h>
#import "CDSModel.h"

@class CDSDetailViewController;

@interface CDSMasterViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CDSDetailViewController *detailViewController;
@property (strong, nonatomic) CDSModel *model;

- (IBAction)refresh:(id)sender;

@end
