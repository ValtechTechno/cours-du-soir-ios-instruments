#import "CDSProjectsRetriever.h"
#import "CDSHTTPRequest.h"
#import "CDSProjectsParserOperation.h"

@interface CDSProjectsRetriever()<CDSHTTPRequestDelegate, CDSProjectsParserOperationDelegate>

@end

@implementation CDSProjectsRetriever

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
    [self.delegate projectsRetriever:self didFailedWithError:[NSError errorWithDomain:kUDSDomain code:0 userInfo:nil]];
}

#pragma mark - CDSProjectsParserOperationDelegate

- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didParsed:(NSArray *)projects
{
    [self.delegate projectsRetriever:self didRetrievedProjects:projects];
}

- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didFailedWithError:(NSError *)error
{
    [self.delegate projectsRetriever:self didFailedWithError:error];
}

@end
