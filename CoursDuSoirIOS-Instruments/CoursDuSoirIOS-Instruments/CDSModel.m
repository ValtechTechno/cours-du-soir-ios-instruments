#import "CDSModel.h"
#import "CDSProjectsDao.h"
#import "CDSStoriesDao.h"

@interface CDSModel() <CDSProjectsDaoDelegate, CDSStoriesDaoDelegate>

@property (nonatomic, strong) CDSProjectsDao *projectsDao;
@property (nonatomic, strong) CDSStoriesDao *storiesDao;
@end

@implementation CDSModel

@synthesize projects, stories;
@synthesize projectsDao, storiesDao;

- (id)init
{
    self = [super init];
    if (self) {
        self.projectsDao = [[CDSProjectsDao alloc] init];
        self.storiesDao = [[CDSStoriesDao alloc] init];
    }
    return self;
}

- (void)retrieveProjects
{
    self.projectsDao.delegate = self;
    [self.projectsDao execute];
}

- (void)retrieveStoriesFromProject:(CDSProject *)project
{
    self.storiesDao.delegate = self;
    self.storiesDao.projectIdentifier = project.identifier;
    [self.storiesDao execute];
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
