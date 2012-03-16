#import "CDSModel.h"
#import "CDSProjectsRetriever.h"

@interface CDSModel() <CDSProjectsRetrieverDelegate>

@end

@implementation CDSModel

@synthesize projects, points;

- (void)retrieveProjects
{
    CDSProjectsRetriever *projectRetriever = [[CDSProjectsRetriever alloc] init];
    projectRetriever.delegate = self;
    [projectRetriever execute];
}

- (void)retrievePoints
{
    
}

#pragma mark - CDSProjectsRetrieverDelegate

- (void)projectsRetriever:(CDSProjectsRetriever *)projectsRetriever didRetrievedProjects:(NSArray *)newProjects
{
    self.projects = newProjects;
}

- (void)projectsRetriever:(CDSProjectsRetriever *)projectsRetriever didFailedWithError:(NSError *)error
{
    self.projects = nil;
}

@end
