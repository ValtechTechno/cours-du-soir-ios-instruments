@class CDSStoriesParserOperation;

@protocol CDSStoriesParserOperationDelegate <NSObject>

- (void)storiesParserOperation:(CDSStoriesParserOperation *)projectsParser didParsed:(NSArray *)stories;
- (void)storiesParserOperation:(CDSStoriesParserOperation *)projectsParser didFailedWithError:(NSError *)error;

@end

@interface CDSStoriesParserOperation : NSOperation

@property (nonatomic, weak) id <CDSStoriesParserOperationDelegate> delegate;
@property (nonatomic, strong) NSData *data;

@end
