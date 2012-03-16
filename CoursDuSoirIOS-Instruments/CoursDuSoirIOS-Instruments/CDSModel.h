#import "CDSProject.h"

@interface CDSModel : NSObject

@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) NSArray *stories;

- (void)retrieveProjects;
- (void)retrieveStoriesFromProject:(CDSProject *)project;

@end
