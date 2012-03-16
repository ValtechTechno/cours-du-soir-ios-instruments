#import "CDSStoriesDao.h"
#import "VTHTTPRequest.h"
#import "CDSStoriesParserOperation.h"

@interface CDSStoriesDao()<VTHTTPRequestDelegate, CDSStoriesParserOperationDelegate>

@end

@implementation CDSStoriesDao

@synthesize delegate, projectIdentifier;

- (void)execute
{
    VTHTTPRequest *request = [[VTHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%d/stories", kUDSBaseURL, projectIdentifier]];
    [request connectToUrl:url andDelegate:self];
}

#pragma mark - CDSHTTPRequestDelegate

- (void)httprequest:(VTHTTPRequest *)request didReceiveData:(NSData *)data
{
    CDSStoriesParserOperation *operation = [[CDSStoriesParserOperation alloc] init];
    operation.delegate = self;
    operation.data = data;
    [operation start];
}

- (void)httprequest:(VTHTTPRequest *)request didFailWithError:(NSError *)error
{
    [self.delegate storiesDao:self didFailedWithError:[NSError errorWithDomain:kUDSDomain code:0 userInfo:nil]];
}

#pragma mark - CDSStoriesParserOperationDelegate

- (void)storiesParserOperation:(CDSStoriesParserOperation *)projectsParser didParsed:(NSArray *)stories
{
    [self.delegate storiesDao:self didRetrievedStories:stories];
}

- (void)storiesParserOperation:(CDSStoriesParserOperation *)projectsParser didFailedWithError:(NSError *)error
{
    [self.delegate storiesDao:self didFailedWithError:error];
}

@end
