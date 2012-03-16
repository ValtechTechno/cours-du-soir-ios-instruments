#import "CDSProjectsDao.h"
#import "VTHTTPRequest.h"
#import "CDSProjectsParserOperation.h"

@interface CDSProjectsDao()<VTHTTPRequestDelegate, CDSProjectsParserOperationDelegate>

@end

@implementation CDSProjectsDao

@synthesize delegate;

- (void)execute
{
    VTHTTPRequest *request = [[VTHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects", kUDSBaseURL]];
    [request connectToUrl:url andDelegate:self];
}

#pragma mark - CDSHTTPRequestDelegate

- (void)httprequest:(VTHTTPRequest *)request didReceiveData:(NSData *)data
{
    CDSProjectsParserOperation *operation = [[CDSProjectsParserOperation alloc] init];
    operation.delegate = self;
    operation.data = data;
    [operation start];
}

- (void)httprequest:(VTHTTPRequest *)request didFailWithError:(NSError *)error
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
