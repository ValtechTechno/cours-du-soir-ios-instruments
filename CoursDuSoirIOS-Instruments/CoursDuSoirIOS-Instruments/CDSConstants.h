#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define kUDSBaseURL @"http://digitagile.appspot.com"
#define kUDSDomain  @"www.valtech.com"
