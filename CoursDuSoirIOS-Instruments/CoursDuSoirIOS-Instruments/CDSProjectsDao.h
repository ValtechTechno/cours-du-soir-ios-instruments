@class CDSProjectsDao;

@protocol CDSProjectsDaoDelegate <NSObject>

- (void)projectsDao:(CDSProjectsDao *)projectsDao didRetrievedProjects:(NSArray *)projects;
- (void)projectsDao:(CDSProjectsDao *)projectsDao didFailedWithError:(NSError *)error;

@end

@interface CDSProjectsDao : NSObject

@property (nonatomic, strong) id <CDSProjectsDaoDelegate>delegate;

- (void)execute;

@end
