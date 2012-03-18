#import <UIKit/UIKit.h>
#import "CDSModel.h"
#import "CDSProject.h"

@interface CDSDetailViewController : UIViewController <UISplitViewControllerDelegate> {
    float currentAngle;
    float lastAngle;
    NSTimer *animationTimer;
}

@property (strong, nonatomic) CDSProject *project;
@property (strong, nonatomic) CDSModel *model;

@end
