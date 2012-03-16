#import "CDSProjectsDao.h"
#import "CDSHTTPRequest.h"
#import "CDSProjectsParserOperation.h"

@interface CDSProjectsDao()<CDSHTTPRequestDelegate, CDSProjectsParserOperationDelegate>

@end

@implementation CDSProjectsDao

@synthesize delegate;

- (void)execute
{
    CDSHTTPRequest *request = [[CDSHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects", kUDSBaseURL]];
    [request connectToUrl:url andDelegate:self];
}

#pragma mark - CDSHTTPRequestDelegate

- (void)httprequest:(CDSHTTPRequest *)request didReceiveData:(NSData *)data
{
    CDSProjectsParserOperation *operation = [[CDSProjectsParserOperation alloc] init];
    operation.delegate = self;
    operation.data = data;
    [operation start];
}

- (void)httprequest:(CDSHTTPRequest *)request didFailWithError:(NSError *)error
{
    [self.delegate projectsDao:self didFailedWithError:[NSError errorWithDomain:kUDSDomain code:0 userInfo:nil]];
}

#pragma mark - CDSProjectsParserOperationDelegate

- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didParsed:(NSArray *)projects
{
    [self.delegate projectsDao:self didRetrievedProjects:projects];
}

- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didFailedWithError:(NSError *)error
{
    [self.delegate projectsDao:self didFailedWithError:error];
}

@end
