#import <UIKit/UIKit.h>
#import "CDSModel.h"

@class CDSDetailViewController;

@interface CDSMasterViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CDSDetailViewController *detailViewController;
@property (nonatomic, strong) CDSModel *model;

- (IBAction)refresh:(id)sender;

@end
