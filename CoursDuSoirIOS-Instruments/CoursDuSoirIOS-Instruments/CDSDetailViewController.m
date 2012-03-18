#import "CDSDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CDSStory.h"

@interface CDSDetailViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) NSMutableArray* carouselViews;
@property (nonatomic, strong) id trackingTouchedView;

- (void)configureView;

@end

@implementation CDSDetailViewController

@synthesize model = _model;
@synthesize project = _project;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize carouselViews, trackingTouchedView;

#pragma mark - Managing the detail item

- (void)setProject:(CDSProject *)newProject
{
    if (_project != newProject) {
        _project = newProject;
        [_model retrieveStoriesFromProject:self.project];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    CGRect frameForViews = CGRectMake(-60, -95, 120, 190);    
    self.carouselViews = [NSMutableArray array];
    int index = [self.model.stories count];
    UIImage *image = [UIImage imageNamed:@"page"];
    while (index--)
    {
        CDSStory *story = [self.model.stories objectAtIndex:index];
        
		UIView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = frameForViews;
		UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:12];
        label.text = story.title;
		[view addSubview:label];
        
        [self.carouselViews addObject:view];
        [self.view addSubview:view];
    }
    
    currentAngle = lastAngle = 0.0f;
    [self setCarouselAngle:currentAngle];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self.model addObserver:self forKeyPath:@"stories" options:0 context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.model removeObserver:self forKeyPath:@"stories"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setCarouselAngle:(float)angle
{
    // we want to step around the outside of a circle in
    // linear steps; work out the distance from one step
    // to the next
    float angleToAdd = 360.0f / [self.carouselViews count];
    
    // apply positions to all carousel views
    for (UIView *view in self.carouselViews)
    {
        float angleInRadians = angle * M_PI / 180.0f;
        
        // get a location based on the angle
        float xPosition = (self.view.bounds.size.width * 0.5f) + 100.0f * sinf(angleInRadians);
        float yPosition = (self.view.bounds.size.height * 0.5f) + 45.0f * cosf(angleInRadians);
        
        // get a scale too; effectively we have:
        //
        //  0.75f   the minimum scale
        //  0.25f   the amount by which the scale varies over half a circle
        //
        // so this will give scales between 0.75 and 1.25. Adjust to suit!
        float scale = 0.75f + 0.25f * (cosf(angleInRadians) + 1.0);
        
        // apply location and scale
        view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(xPosition, yPosition), scale, scale);
        
        // tweak alpha using the same system as applied for scale, this time
        // with 0.3 the minimum and a semicircle range of 0.5
        view.alpha = 0.3f + 0.5f * (cosf(angleInRadians) + 1.0);
        
        // setting the z position on the layer has the effect of setting the
        // draw order, without having to reorder our list of subviews
        view.layer.zPosition = scale;
        
        // work out what the next angle is going to be
        angle += angleToAdd;
    }
}

#pragma mark - Gesture events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if we're not already tracking a touch then...
    if (!self.trackingTouchedView)
    {
        // ... track any of the new touches, we don't care which ...
        self.trackingTouchedView = [touches anyObject];
        
        // ... and cancel any animation that may be ongoing
        [animationTimer invalidate];
        animationTimer = nil;
        lastAngle = currentAngle;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if our touch moved then...
    if ([touches containsObject:self.trackingTouchedView])
    {
        // use the movement of the touch to decide
        // how much to rotate the carousel
        CGPoint locationNow = [self.trackingTouchedView locationInView:self.view];
        CGPoint locationThen = [self.trackingTouchedView previousLocationInView:self.view];
        
        lastAngle = currentAngle;
        currentAngle += (locationNow.x - locationThen.x) * 180.0f / self.view.bounds.size.width;
        // the 180.0f / self.view.bounds.size.width just says "let a full width of my view
        // be a 180 degree rotation"
        
        // and update the view positions
        [self setCarouselAngle:currentAngle];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if our touch ended then...
    if([touches containsObject:self.trackingTouchedView])
    {
        // make sure we're no longer tracking it
        self.trackingTouchedView = nil;
        
        // and kick off the inertial animation
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateAngle) userInfo:nil repeats:YES];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // treat cancelled touches exactly like ones that end naturally
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self configureView];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Selectors

- (void)animateAngle
{
    // work out the difference between the current angle and
    // the last one, and add that again but made a bit smaller.
    // This gives us inertial scrolling.
    float angleNow = currentAngle;
    currentAngle += (currentAngle - lastAngle) * 0.97f;
    lastAngle = angleNow;
    
    // push the new angle into the carousel
    [self setCarouselAngle:currentAngle];
    
    // if the last angle and the current one are now
    // really similar then cancel the animation timer
    if(fabsf(lastAngle - currentAngle) < 0.001)
    {
        [animationTimer invalidate];
        animationTimer = nil;
    }
}

@end
