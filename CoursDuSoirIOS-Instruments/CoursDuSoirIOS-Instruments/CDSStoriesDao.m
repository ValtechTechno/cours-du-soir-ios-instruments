#import "CDSStoriesDao.h"
#import "VTHTTPRequest.h"
#import "CDSStoriesParserOperation.h"

@interface CDSStoriesDao()<VTHTTPRequestDelegate, CDSStoriesParserOperationDelegate>

@property (nonatomic, strong) VTHTTPRequest *request;
@property (nonatomic, strong) CDSStoriesParserOperation *operation;

@end

@implementation CDSStoriesDao

@synthesize delegate, projectIdentifier;
@synthesize request, operation;

- (void)execute
{
    self.request = [[VTHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%d/stories", kUDSBaseURL, projectIdentifier]];
    [self.request connectToUrl:url andDelegate:self];
}

- (void)dealloc
{
    [self.request cancel];
    [self.operation cancel];
}

#pragma mark - CDSHTTPRequestDelegate

- (void)httprequest:(VTHTTPRequest *)request didReceiveData:(NSData *)data
{
    self.operation = [[CDSStoriesParserOperation alloc] init];
    self.operation.delegate = self;
    self.operation.data = data;
    [self.operation start];
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
