//
//  IVLEMain.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLEMain.h"

#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kNotificationSetPageTitle @"setPageTitle"


@interface IVLEMain (PrivateMethods)

- (void) setUpTimeTableView;
- (void) setUpEventsView;
- (void) setUpAnnouncementsView;

@end


@implementation IVLEMain

NSMutableArray *announcements;
@synthesize announcementCells;

static IVLETopBar *topBar;
static IVLEBottomBar *bottomBarNavigator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImage *blackboardImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:blackboardImage]];
		
		//added by SJ, memory managemment
		currentActiveLeftViewController = nil;
		currentActiveMainViewController = nil;
		
		splitVC = [[UISplitViewController alloc] init];
    }

    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Override point for customization after application launch.
	
	if (!topBar) {
		topBar = [[IVLETopBar alloc] init];
	}
	
	if (!bottomBarNavigator) {
		bottomBarNavigator = [[IVLEBottomBar alloc] init];
	}
	
	
	
	UIImage *bgImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
	
	timetable.tag = kHomePageTimetableViewTag;
	recentAnnouncements.tag = kHomePageAnnouncementsViewTag;
	
	
	
	[self.view addSubview:topBar.view];
	[self.view addSubview:bottomBarNavigator.view];
	//bottomBarNavigator.view.frame = 
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Home Screen"]];
	
	self.view.frame = CGRectMake(0,0,1024, 768);
	[timetable setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name:kNotificationRefreshScreen object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRightScreen:) name:kNotificationRefreshRightScreen object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLogin:) name:kNotificationLoginScreen object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relogin:) name:kNotificationReLoginSuccessful object:nil];
	
	if ([IVLE instance].authenticationToken == nil) {
		//	[self displayLogin];
		[self performSelector:@selector(displayLogin) withObject:nil afterDelay:2.95];
	}
}

-(void) relogin:(NSNotification *)notification {
	
	[self setUpEventsView];
	
	[self.view addSubview:topBar.view];
	[self.view addSubview:recentAnnouncements];
	
	[self.view addSubview:timetable];
	[pageControlView addSubview:eventsPageControl];
	[rightHandSideView addSubview:pageControlView];
	[rightHandSideView addSubview:eventsScrollView];
	[self.view addSubview:rightHandSideView];
	[self.view addSubview:bottomBarNavigator.view];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Home Screen"]];

	
}
	

- (void) memoryManagementOfViewControllers: (id) mainScreen  {
	//return;
	NSLog(@"inmemoryManagementOfViewControllers");
	//memory management by SJ
	if (currentActiveMainViewController != nil) {
		if (kDebugMemoryManagement) {
			NSLog(@"released %@", currentActiveMainViewController);
		}
		[currentActiveMainViewController release];
		currentActiveMainViewController = nil;
	} 
	if (kDebugMemoryManagement){
		NSLog(@"assigning %@", mainScreen);
	}
	currentActiveMainViewController = mainScreen;
	
}
- (void) setUpEventsView {
	
	//setting up events
	eventsScrollView.delegate = self;
	
	IVLE *ivleInterface = [IVLE instance];
	NSArray *eventsArray = [[ivleInterface studentEvents:YES] objectForKey:@"Results"];
	
	[eventsScrollView setBackgroundColor:[UIColor blackColor]];
	[eventsScrollView setCanCancelContentTouches:NO];
	
	eventsScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	eventsScrollView.clipsToBounds = YES;
	eventsScrollView.scrollEnabled = YES;
	eventsScrollView.pagingEnabled = YES;
	
	//setup labels inside scrollview
	for (int i = 0; i < 5; i++) {
		
		NSDictionary *currentEvent = [eventsArray objectAtIndex:i];
		UILabel *eventTitle = [[UILabel alloc] init];
		
		eventTitle.text = [currentEvent objectForKey:@"Title"];
		eventTitle.backgroundColor = [UIColor clearColor];
		eventTitle.textColor = [UIColor whiteColor];
		NSArray *futuraFonts = [UIFont fontNamesForFamilyName:@"Futura"];
		[eventTitle setFont:[UIFont fontWithName:[futuraFonts objectAtIndex:1] size:20]];	
		[eventTitle setLineBreakMode:UILineBreakModeWordWrap];
		[eventTitle setNumberOfLines:3];
		eventTitle.frame = CGRectMake(eventsScrollView.bounds.size.width * i + 10, 5, eventsScrollView.bounds.size.width - 20, eventsScrollView.bounds.size.height - 10);
		
		[eventsScrollView addSubview:eventTitle];
		[eventTitle release];
	}
	
	[eventsPageControl setNumberOfPages:5];
	[eventsScrollView setContentSize:CGSizeMake(eventsScrollView.bounds.size.width * eventsPageControl.numberOfPages, eventsScrollView.bounds.size.height)];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventsSummaryClicked:)];
	[tap setNumberOfTapsRequired:1];
	[eventsScrollView addGestureRecognizer:tap];
	[tap release];
	
}

- (void)eventsSummaryClicked:(UITapGestureRecognizer *)gesture {
	
	Events *eventsVC = [[Events alloc] init];
	[self refreshMainScreenWith:eventsVC];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Events"]];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    eventsPageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	/*
	 *	Change the scroll view
	 */
    CGRect frame = eventsScrollView.frame;
    frame.origin.x = frame.size.width * eventsPageControl.currentPage;
    frame.origin.y = 0;
	
    [eventsScrollView scrollRectToVisible:frame animated:YES];
	
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
}

-(void)backToLogin:(NSNotification*)notification {
	
	while ([[self.view subviews] count]) {
		[[[self.view subviews] lastObject] removeFromSuperview];
	}
	
	
	IVLELoginNew *login = [[IVLELoginNew alloc] init];
	
	[self memoryManagementOfViewControllers:login];
	login.view.frame= CGRectMake(0, 50, 1024, 718);
	login.wantsFullScreenLayout = YES;
	login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	login.modalPresentationStyle = UIModalPresentationCurrentContext;
	[self presentModalViewController:login animated:NO];
}

-(void) viewDidAppear:(BOOL)animated {
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(1024/2-spinner.frame.size.width/2, 768/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview] addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	
	[self setUpAnnouncementsView];
	[self setUpEventsView];
	[self setUpTimeTableView];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
	
}

-(void) setUpAnnouncementsView {
	
	IVLE *ivle = [IVLE instance];
	
	NSMutableArray* moduleIDs = [[[NSMutableArray alloc] init] retain];
	announcements = [[[NSMutableArray alloc] init] retain];
	
	NSDictionary *moduleDict = [ivle modules:0 withAllInfo:NO];
	
	int i;
	for (i=0; i<[[moduleDict valueForKey:@"Results"] count]; i++) {
		NSArray *module = [[moduleDict valueForKey:@"Results"] objectAtIndex:i];
		if (![[module valueForKey:@"ID"] isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
			[moduleIDs addObject:[module valueForKey:@"ID"]] ;
			[announcements addObjectsFromArray:[[[IVLE instance] announcements:[module valueForKey:@"ID"] withDuration:0 withTitle:NO] valueForKey:@"Results"]];
		}
	}
	
	if ([announcements count] > 20) {
		
		NSSortDescriptor *sortDescriptor;
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"CreatedDate" ascending:NO] autorelease];
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[announcements sortUsingDescriptors:sortDescriptors];
		NSRange range = NSMakeRange(20, [announcements count]-20);
		[announcements removeObjectsInRange:range];
	}

	announcementCells = [[[NSMutableArray alloc] init] retain];
	
	for (int i=0; i<[announcements count]; i++) {
		
		HomePageModuleAnnouncementCell *cell;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageModuleAnnouncementCell" 
													 owner:self
												   options:nil];
		cell = [[nib objectAtIndex:0] retain];
		
		NSRange range = NSMakeRange (6, 10);
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[[announcements objectAtIndex:i] valueForKey:@"CreatedDate"] substringWithRange:range] intValue]];
		
		
		cell.postTitle.text = [[announcements objectAtIndex:i] valueForKeyPath:@"Title"];
		cell.postDate.text = [date description];
		cell.moduleCode.text = [[announcements objectAtIndex:i] valueForKeyPath:@"Creator.Name"];
		
		NSString *formatedContent = [NSString stringWithFormat:@"<div id='foo'>%@</div>",[[announcements objectAtIndex:i] valueForKey:@"Description"]];
		[cell.descriptionText loadHTMLString:formatedContent baseURL:nil];
		
		do {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (!cell.finishedLoading);
		NSAssert(cell.finishedLoading, @"cell not finish loading");
		//		NSLog(@"%d, %f, %f", cell.finishedLoading, cell.frame.size.width, cell.frame.size.height);
		cell.descriptionText.backgroundColor = [UIColor clearColor];
		[announcementCells addObject:cell];
		//		NSLog(@"added");
		
	}
	[recentAnnouncements reloadData];
	
}

-(void) setUpTimeTableView {
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	tableView.allowsSelection = NO;
	tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IVLE_white_bg.png"]];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	
	if (tableView.tag == kHomePageTimetableViewTag) {
		return 1;
	}
	else {
		return [announcements count];
	}
	
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tableView.tag == kHomePageTimetableViewTag) {
		return [announcementCells objectAtIndex:[indexPath row]];
	}
	else {
		return [announcementCells objectAtIndex:[indexPath row]];
	}
    
}

- (void)loadContent:(NSString*)string{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.tag == kHomePageTimetableViewTag) {
		HomePageModuleAnnouncementCell *cell = [announcementCells objectAtIndex:[indexPath row]];
		return cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.postTitle.frame.origin.y);
	}
	else {
		
		HomePageModuleAnnouncementCell *cell = [announcementCells objectAtIndex:[indexPath row]];
		return cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.postTitle.frame.origin.y);
	}
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}


- (void)displayLogin{
	
	IVLELoginWebViewController *login = [[IVLELoginWebViewController alloc]init];
	
	
	[self memoryManagementOfViewControllers:login];
//	login.view.frame= CGRectMake(0, 50, 1024, 718);
	login.wantsFullScreenLayout = YES;
	login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	login.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:login animated:NO];
}




- (IBAction)modulesClicked{
	//REFACTOR NEEDED.
	IVLESideBar* leftBar = [[IVLESideBar alloc] init];
	
	
	ModulesWorkbin* rightBar = [[ModulesWorkbin alloc] init];
	
	[self refreshMainScreenWith:leftBar withRight:rightBar];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Modules"]];
	
}
- (IBAction)timetableClicked{
	
	Timetable * mainScreen = [[Timetable alloc] init];
	[self refreshMainScreenWith:mainScreen];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Timetable"]];
}

- (IBAction)mapClicked{
	Map * mainScreen = [[Map alloc] init];
	[self refreshMainScreenWith:mainScreen];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Campus Map"]];
}

- (IBAction)capClicked{
	CAPCalculator * mainScreen = [[CAPCalculator alloc] init];
	[self refreshMainScreenWith:mainScreen];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"CAP Calculator"]];
}

- (IBAction)eventsClicked {
	
	Events *eventsVC = [[Events alloc] init];
	[self refreshMainScreenWith:eventsVC];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Events"]];
}
- (void)refreshMainScreenWith:(UIViewController*)mainScreen{
	//memory management by SJ
	[self memoryManagementOfViewControllers: mainScreen];

	
	
	mainScreen.view.frame = CGRectMake(0,topBar.view.frame.size.height,1024, 748-topBar.view.frame.size.height-bottomBarNavigator.view.frame.size.height);
	//	bottomBarNavigator.view.frame = CGRectMake(0, 748-bottomBarNavigator.view.frame.size.height,  bottomBarNavigator.view.frame.size.width, bottomBarNavigator.view.frame.size.height);
	
	UIImage *backgroundImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
	[mainScreen.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
	
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}
	
	[self.view addSubview:topBar.view];
	[self.view addSubview:mainScreen.view];
	[self.view addSubview:bottomBarNavigator.view];
	//[self.view addSubview:topBar.view];
}

- (void)refreshMainScreenWith:(id)leftBar withRight:(id)rightBar{
	splitVC.viewControllers = [NSArray arrayWithObjects:leftBar, rightBar, nil];
	
	//memory management by SJ, leftBar is singleton.
	[self memoryManagementOfViewControllers: rightBar];

	//load background image for split view
	UIImage *backgroundImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
	splitVC.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	
	[splitVC setValue:[NSNumber numberWithFloat:200.0] forKey:@"_masterColumnWidth"];
	splitVC.view.frame = CGRectMake(0,topBar.view.frame.size.height,1024, 748-topBar.view.frame.size.height-bottomBarNavigator.view.frame.size.height);
	//	bottomBarNavigator.view.frame = CGRectMake(0, 648, 1024, 110);
	
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}
	
	[self.view addSubview:splitVC.view];
	[self.view addSubview:topBar.view];
	[self.view addSubview:bottomBarNavigator.view];
}

-(void) resetToHomeScreen:(NSArray*)viewArray {
	
	//NSLog(@"resetToHomeScreen");
	self.view.frame = CGRectMake(0,0,1024, 748);
	
	UIImage *bgImage = [UIImage imageNamed:@"IVLE_white_bg.png"];
	[timetable setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
	
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}
	
	[self setUpEventsView];
	
	[self.view addSubview:topBar.view];
	[self.view addSubview:recentAnnouncements];
	
	[self.view addSubview:timetable];
	[pageControlView addSubview:eventsPageControl];
	[rightHandSideView addSubview:pageControlView];
	[rightHandSideView addSubview:eventsScrollView];
	[self.view addSubview:rightHandSideView];
	[self.view addSubview:bottomBarNavigator.view];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Home Screen"]];
	
	
	
	
	//	self.view.frame = CGRectMake(0,0,1024, 768);
	/*
	 [self.view addSubview:[viewArray objectAtIndex:0]];
	 //	mainScreen.view.frame = CGRectMake(0,0,1024, 768);
	 //	[self.view addSubview:mainScreen.view];
	 */	
}

- (void)refreshScreen:(NSNotification*)notification{
	//REFACTOR. REMOVE RELIANCE ON ARRAY.
	if ([[notification object] count] == 0) {
		[self resetToHomeScreen:[[NSBundle mainBundle] loadNibNamed:@"IVLEMain" owner:self options:nil]];
	} else if([[notification object] count] == 1){
		[self refreshMainScreenWith:[[notification object] lastObject]];
	} else {
		NSAssert(0,@"Notification object count is wrong la!");
	}
}

- (void)refreshRightScreen:(NSNotification*)notification{
	if ([[notification object] count] == 1) {
		IVLESideBar* leftBar= [[IVLESideBar alloc] init];
		[self refreshMainScreenWith:leftBar withRight:[[notification object] objectAtIndex:0]];
	}
	
}

- (void)refreshScreenToSplashScreen{
	while ([[self.view subviews] count] > kIVLEMainNumberOfIcons) {
		[[[self.view subviews] lastObject] removeFromSuperview]; 
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRefreshRightScreen object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRefreshScreen object:nil];
	[bottomBarNavigator.view removeFromSuperview];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"main dealloc");
	[timetable release];
	[recentAnnouncements release];
	[topBar release];
	[bottomBarNavigator release];
    [super dealloc];
}

@end
