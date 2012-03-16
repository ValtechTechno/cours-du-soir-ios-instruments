#import <Foundation/Foundation.h>

@class CDSProjectsParserOperation;

@protocol CDSProjectsParserOperationDelegate <NSObject>

- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didParsed:(NSArray *)projects;
- (void)projectsParserOperation:(CDSProjectsParserOperation *)projectsParser didFailedWithError:(NSError *)error;

@end

@interface CDSProjectsParserOperation : NSOperation

@property (nonatomic, weak) id <CDSProjectsParserOperationDelegate> delegate;
@property (nonatomic, strong) NSData *data;

@end
