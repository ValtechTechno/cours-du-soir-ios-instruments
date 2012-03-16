@class CDSStoriesDao;

@protocol CDSStoriesDaoDelegate <NSObject>

- (void)storiesDao:(CDSStoriesDao *)storiesDao didRetrievedStories:(NSArray *)stories;
- (void)storiesDao:(CDSStoriesDao *)storiesDao didFailedWithError:(NSError *)error;

@end

@interface CDSStoriesDao : NSObject

@property (nonatomic, weak) id <CDSStoriesDaoDelegate> delegate;
@property (nonatomic, assign) NSUInteger projectIdentifier;

- (void)execute;

@end
