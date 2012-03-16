#import "CDSModel.h"
#import "CDSProjectsDao.h"
#import "CDSStoriesDao.h"

@interface CDSModel() <CDSProjectsDaoDelegate, CDSStoriesDaoDelegate>

@end

@implementation CDSModel

@synthesize projects, stories;

- (void)retrieveProjects
{
    CDSProjectsDao *projectDao = [[CDSProjectsDao alloc] init];
    projectDao.delegate = self;
    [projectDao execute];
}

- (void)retrieveStoriesFromProject:(CDSProject *)project
{
    CDSStoriesDao *storiesDao = [[CDSStoriesDao alloc] init];
    storiesDao.delegate = self;
    storiesDao.projectIdentifier = project.identifier;
    [storiesDao execute];
}

#pragma mark - CDSProjectsRetrieverDelegate

- (void)projectsDao:(CDSProjectsDao *)projectsDao didRetrievedProjects:(NSArray *)newProjects
{
    self.projects = newProjects;
}

- (void)projectsDao:(CDSProjectsDao *)projectsDao didFailedWithError:(NSError *)error
{
    self.projects = nil;
}

#pragma mark - CDSStoriesDaoDelegate

- (void)storiesDao:(CDSStoriesDao *)storiesDao didRetrievedStories:(NSArray *)newStories
{
    self.stories = newStories;
}

- (void)storiesDao:(CDSStoriesDao *)storiesDao didFailedWithError:(NSError *)error
{
    self.stories = nil;
}

@end
