#import "CDSStoriesParserOperation.h"
#import "CDSStory.h"

@implementation CDSStoriesParserOperation

@synthesize delegate, data;

- (void)main
{
    NSError *error = nil;
    NSDictionary *storiesAsDictionary = [NSJSONSerialization JSONObjectWithData:self.data 
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&error];
    if (error) {
        [self.delegate storiesParserOperation:self didFailedWithError:error];
        return;
    }
    
    NSMutableArray *stories = [NSMutableArray array];
    for (NSDictionary *storyAsDictionary in [storiesAsDictionary objectForKey:@"stories"]) {
        CDSStory *story = [[CDSStory alloc] init];
        story.identifier = [[storyAsDictionary objectForKey:@"id"] intValue];
        story.title = [storyAsDictionary objectForKey:@"title"];
        story.content = [storyAsDictionary objectForKey:@"description"];
        story.points = [[storyAsDictionary objectForKey:@"points"] intValue];
        story.priority = [[storyAsDictionary objectForKey:@"priority"] intValue];
    }
    [self.delegate storiesParserOperation:self didParsed:stories];
}

@end
