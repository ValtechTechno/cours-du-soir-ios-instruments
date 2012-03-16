#import "CDSProjectsParserOperation.h"
#import "CDSProject.h"

@implementation CDSProjectsParserOperation

@synthesize delegate, data;

- (void)main
{
    NSError *error = nil;
    NSDictionary *projectsAsDictionary = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        [self.delegate projectsParserOperation:self didFailedWithError:error];
        return;
    }

    NSMutableArray *projects = [NSMutableArray array];
    for (NSDictionary *projectAsDictionary in [projectsAsDictionary objectForKey:@"projects"]) {
        CDSProject *project = [[CDSProject alloc] init];
        project.identifier = [[projectAsDictionary objectForKey:@"id"] intValue];
        project.name = [projectAsDictionary objectForKey:@"name"];
        [projects addObject:project];
    }
    [self.delegate projectsParserOperation:self didParsed:projects];
}

@end
