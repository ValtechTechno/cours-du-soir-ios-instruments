@class CDSHTTPRequest;

@protocol CDSHTTPRequestDelegate <NSObject>

- (void)httprequest:(CDSHTTPRequest *)request didReceiveData:(NSData *)data;
- (void)httprequest:(CDSHTTPRequest *)request didFailWithError:(NSError *)error;

@end

@interface CDSHTTPRequest : NSObject

@property (nonatomic, strong) id <CDSHTTPRequestDelegate> delegate;

- (void)connectToUrl:(NSURL *)aUrl andDelegate:(id<CDSHTTPRequestDelegate>)aDelegate;
- (void)cancel;

@end
