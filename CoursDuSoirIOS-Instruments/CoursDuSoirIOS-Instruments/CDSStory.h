@interface CDSStory : NSObject

@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, assign) NSUInteger points;
@property (nonatomic, strong) NSString *content;

@end
