#import "CDSProjectsDao.h"
#import "VTHTTPRequest.h"
#import "CDSProjectsParserOperation.h"

@interface CDSProjectsDao()<VTHTTPRequestDelegate, CDSProjectsParserOperationDelegate>

@property (nonatomic, strong) VTHTTPRequest *request;
@property (nonatomic, strong) CDSProjectsParserOperation *operation;

@end

@implementation CDSProjectsDao

@synthesize delegate;
@synthesize request, operation;

- (void)execute
{
    self.request = [[VTHTTPRequest alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects", kUDSBaseURL]];
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
    self.operation = [[CDSProjectsParserOperation alloc] init];
    self.operation.delegate = self;
    self.operation.data = data;
    [self.operation start];
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
