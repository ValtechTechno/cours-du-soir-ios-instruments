#import "CDSModel.h"
#import "CDSProjectsDao.h"

@interface CDSModel() <CDSProjectsDaoDelegate>

@end

@implementation CDSModel

@synthesize projects, points;

- (void)retrieveProjects
{
    CDSProjectsDao *projectRetriever = [[CDSProjectsDao alloc] init];
    projectRetriever.delegate = self;
    [projectRetriever execute];
}

- (void)retrieveStories
{
    
}

#pragma mark - CDSProjectsRetrieverDelegate

- (void)projectsRetriever:(CDSProjectsDao *)projectsRetriever didRetrievedProjects:(NSArray *)newProjects
{
    self.projects = newProjects;
}

- (void)projectsRetriever:(CDSProjectsDao *)projectsRetriever didFailedWithError:(NSError *)error
{
    self.projects = nil;
}

@end
