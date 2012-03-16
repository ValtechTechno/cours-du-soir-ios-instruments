@class VTHTTPRequest;

@protocol VTHTTPRequestDelegate <NSObject>

- (void)httprequest:(VTHTTPRequest *)request didReceiveData:(NSData *)data;
- (void)httprequest:(VTHTTPRequest *)request didFailWithError:(NSError *)error;

@end

@interface VTHTTPRequest : NSObject

@property (nonatomic, weak) id <VTHTTPRequestDelegate> delegate;

- (void)connectToUrl:(NSURL *)aUrl andDelegate:(id<VTHTTPRequestDelegate>)aDelegate;
- (void)cancel;

@end
