#import "CDSProject.h"

#define kCDSMemoryDummySize 1048576

@interface CDSProject() {
    unsigned char *dummyBuffer;
}

@end

@implementation CDSProject

@synthesize identifier, name;

- (id)init
{
    self = [super init];
    if (self) {
        dummyBuffer = malloc(kCDSMemoryDummySize);
    }
    return self;
}

- (void)dealloc
{
    free(dummyBuffer);
}

@end
