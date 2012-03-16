#import "CDSStoriesDao.h"
#import "CDSHTTPRequest.h"
#import "CDSStoriesParserOperation.h"

@interface CDSStoriesDao()<CDSHTTPRequestDelegate, CDSStoriesParserOperationDelegate>

@end

@implementation CDSStoriesDao

@synthesize delegate, projectIdentifier;

- (void)execute
{
    CDSHTTPRequest *request = [[CDSHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%d/stories", kUDSBaseURL, projectIdentifier]];
    [request connectToUrl:url andDelegate:self];
}

#pragma mark - CDSHTTPRequestDelegate

- (void)httprequest:(CDSHTTPRequest *)request didReceiveData:(NSData *)data
{
    CDSStoriesParserOperation *operation = [[CDSStoriesParserOperation alloc] init];
    operation.delegate = self;
    operation.data = data;
    [operation start];
}

- (void)httprequest:(CDSHTTPRequest *)request didFailWithError:(NSError *)error
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
