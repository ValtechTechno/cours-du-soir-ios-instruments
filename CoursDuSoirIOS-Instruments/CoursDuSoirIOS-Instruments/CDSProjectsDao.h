@class CDSProjectsDao;

@protocol CDSProjectsDaoDelegate <NSObject>

- (void)projectsRetriever:(CDSProjectsDao *)projectsRetriever didRetrievedProjects:(NSArray *)projects;
- (void)projectsRetriever:(CDSProjectsDao *)projectsRetriever didFailedWithError:(NSError *)error;

@end

@interface CDSProjectsDao : NSObject

@property (nonatomic, weak) id <CDSProjectsDaoDelegate>delegate;

- (void)execute;

@end
