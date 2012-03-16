#import <UIKit/UIKit.h>

@interface CDSModel : NSObject

@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) NSArray *points;

- (void)retrieveProjects;
- (void)retrievePoints;

@end
