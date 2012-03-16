#import "CDSHTTPRequest.h"

@interface CDSHTTPRequest()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *buffer;

@end

@implementation CDSHTTPRequest

@synthesize delegate;
@synthesize url, urlConnection, buffer;

#pragma mark - Public

- (void)connectToUrl:(NSURL *)aUrl andDelegate:(id<CDSHTTPRequestDelegate>)aDelegate {
    self.delegate = aDelegate;
    self.url = aUrl;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.urlConnection) {
        self.buffer = [NSMutableData data];
    } else {
        NSError *error = [NSError errorWithDomain:@"www.valtech.com" code:1 userInfo:nil];
        [self.delegate httprequest:self didFailWithError:error];
    }
}

- (void)cancel {
    [self.urlConnection cancel];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.buffer setLength:0];   
    
    if ([response respondsToSelector:@selector(statusCode)]) {
        NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];        
        if (statusCode >= 400) {
            DLog(@"HTTP error: %d, with URL: %@", statusCode, self.url);            
            [connection cancel];
            NSError *error = [NSError errorWithDomain:@"www.valtech.com" code:1 userInfo:nil];
            [self.delegate httprequest:self didFailWithError:error];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 
    [self.delegate httprequest:self didReceiveData:self.buffer];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate httprequest:self didFailWithError:error];
}
@end
