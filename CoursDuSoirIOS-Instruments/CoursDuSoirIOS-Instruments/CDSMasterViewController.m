#import "CDSMasterViewController.h"
#import "CDSDetailViewController.h"
#import "CDSProject.h"

@interface CDSMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation CDSMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize model = _model;
@synthesize activityIndicator = _activityIndicator;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.model addObserver:self forKeyPath:@"projects" options:0 context:nil];
    self.detailViewController = (CDSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.detailViewController.model = self.model;
}

- (void)viewDidUnload
{
    [self.model removeObserver:self forKeyPath:@"projects"];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicator startAnimating];
    [self.model retrieveProjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.activityIndicator stopAnimating];
    _objects = [NSMutableArray arrayWithArray:self.model.projects];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CDSProject *project = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"id: %d", project.identifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CDSProject *project = [_objects objectAtIndex:indexPath.row];
        self.detailViewController.project = project;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CDSProject *project = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setModel:self.model];
        [[segue destinationViewController] setProject:project];
    }
}

#pragma mark - Selector

- (void)refresh:(id)sender
{
    [self.activityIndicator startAnimating];
    [self.model retrieveProjects];
}

@end
