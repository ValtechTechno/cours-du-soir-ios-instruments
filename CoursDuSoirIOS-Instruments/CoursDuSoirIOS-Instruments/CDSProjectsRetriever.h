@class CDSProjectsRetriever;

@protocol CDSProjectsRetrieverDelegate <NSObject>

- (void)projectsRetriever:(CDSProjectsRetriever *)projectsRetriever didRetrievedProjects:(NSArray *)projects;
- (void)projectsRetriever:(CDSProjectsRetriever *)projectsRetriever didFailedWithError:(NSError *)error;

@end

@interface CDSProjectsRetriever : NSObject

@property (nonatomic, weak) id <CDSProjectsRetrieverDelegate>delegate;

- (void)execute;

@end
