//
//  IVLEMain.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLEMain.h"

#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kCourseID @"aefeaca4-f40a-4c82-9c8e-95f92c7ed0da"

@interface IVLEMain (PrivateMethods)

- (void) setUpTimeTableView;
- (void) setUpEventsView;
- (void) setUpAnnouncementsView;
- (void) setUpHomePageComponents;
- (void) updateAnnouncementsTable;

@end


@implementation IVLEMain


@synthesize announcementCells;
@synthesize announcements;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImage *blackboardImage = [UIImage imageNamed:@"home_page_announcements_bg.png"];
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
	
	UIImage *bgImage = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
	
	timetable.tag = kHomePageTimetableViewTag;
	recentAnnouncements.tag = kHomePageAnnouncementsViewTag;
	
	self.view.frame = CGRectMake(0,0,1024, 768);
	[timetable setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name:kNotificationRefreshScreen object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpHomePageComponents:) name:kNotificationSetupHomePageComponents object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLogin:) name:kNotificationLoginScreen object:nil];
	
	if ([IVLE instance].authenticationToken == nil) {
		[self performSelector:@selector(displayLogin) withObject:nil afterDelay:0.0];
	}

}
	
//- (void) memoryManagementOfViewControllers: (id) mainScreen  {
//	//return;
//	NSLog(@"inmemoryManagementOfViewControllers");
//	//memory management by SJ
//	if (currentActiveMainViewController != nil) {
//		if (kDebugMemoryManagement) {
//			NSLog(@"released %@", currentActiveMainViewController);
//		}
//		[currentActiveMainViewController release];
//		currentActiveMainViewController = nil;
//	} 
//	if (kDebugMemoryManagement){
//		NSLog(@"assigning %@", mainScreen);
//	}
//	currentActiveMainViewController = mainScreen;
//	
//}

-(void) setUpHomePageComponents:(NSNotification*)notification {

    [self setUpAnnouncementsView];
	[self setUpEventsView];
    
    [self.view addSubview:recentAnnouncements];
	
	[self.view addSubview:timetable];
	[pageControlView addSubview:eventsPageControl];
	[rightHandSideView addSubview:pageControlView];
	[rightHandSideView addSubview:eventsScrollView];
	[self.view addSubview:rightHandSideView];
	[self setUpTimeTableView];
}
- (void) setUpEventsView {
	
	//setting up events
	eventsScrollView.delegate = self;
	
	IVLE *ivleInterface = [IVLE instance];
	
	//NSLog(@"%@", [ivleInterface validate]);
	
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

	IVLEAppDelegate *appDelegate = (IVLEAppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate switchToTab:3];
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

//-(void)backToLogin:(NSNotification*)notification {
//	
//	while ([[self.view subviews] count]) {
//		[[[self.view subviews] lastObject] removeFromSuperview];
//	}
//	
//	
//	IVLELoginNew *login = [[IVLELoginNew alloc] init];
//	
//	[self memoryManagementOfViewControllers:login];
//	login.view.frame= CGRectMake(0, 50, 1024, 718);
//	login.wantsFullScreenLayout = YES;
//	login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//	login.modalPresentationStyle = UIModalPresentationCurrentContext;
//	[self presentModalViewController:login animated:NO];
//}

-(void) viewDidAppear:(BOOL)animated {
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(1024/2-spinner.frame.size.width/2, 768/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview] addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
	
}

-(void) setUpAnnouncementsView {

	IVLE *ivle = [IVLE instance];
	
	NSMutableArray* moduleIDs = [[[NSMutableArray alloc] init] autorelease];
	announcements = [[NSMutableArray alloc] init];
	
	NSDictionary *moduleDict = [ivle modules:0 withAllInfo:NO];
	
	int i;
	for (i=0; i<[[moduleDict valueForKey:@"Results"] count]; i++) {
		NSArray *module = [[moduleDict valueForKey:@"Results"] objectAtIndex:i];
		if (![[module valueForKey:@"ID"] isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
			[moduleIDs addObject:[module valueForKey:@"ID"]] ;
			[announcements addObjectsFromArray:[[[IVLE instance] announcements:[module valueForKey:@"ID"] withDuration:0 withTitle:NO] valueForKey:@"Results"]];
		}
	}
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"CreatedDate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [announcements sortUsingDescriptors:sortDescriptors];
	
	if ([announcements count] > 20) {
        
		NSRange range = NSMakeRange(20, [announcements count]-20);
		[announcements removeObjectsInRange:range];
	}
    
    
	announcementCells = [[[NSMutableArray alloc] init] retain];
	
	for (int i=0; i<[announcements count]; i++) {
		
		HomePageModuleAnnouncementCell *cell;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageModuleAnnouncementCell" 
													 owner:self
												   options:nil];
		cell = [nib objectAtIndex:0];
		
		NSRange range = NSMakeRange (6, 10);
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[[announcements objectAtIndex:i] valueForKey:@"CreatedDate"] substringWithRange:range] intValue]];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateStyle:kCFDateFormatterMediumStyle];
		
		cell.titleText.text = [[announcements objectAtIndex:i] valueForKeyPath:@"Title"];
		cell.meta.text = [NSString stringWithFormat:@"%@, %@", [[announcements objectAtIndex:i] valueForKeyPath:@"Creator.Name"], [formatter stringFromDate:date]];
        
        cell.titleText.textColor = kWorkbinFontColor;
        cell.meta.textColor = kWorkbinFontColor;


		NSString *formatedContent = [NSString stringWithFormat:@"<html> \n"
                                     "<head> \n"
                                     "<style type=\"text/css\"> \n"
                                     "body {font-family: \"%@\"; font-size: %@; text-align: %@}\n"
                                     "</style> \n"
                                     "</head> \n"
                                     "<body><div id='foo'>%@</div></body> \n"
                                     "</html>", @"HelveticaNeue", [NSNumber numberWithInt:kWebViewFontSize],@"justify",[[announcements objectAtIndex:i] valueForKey:@"Description"]];
        
        if ([[announcements objectAtIndex:i] valueForKey:@"isRead"]) {
            cell.readIndicator.image = [UIImage imageNamed:@"read.png"];
        }
        else
            cell.readIndicator.image = [UIImage imageNamed:@"new.png"];
		
        [cell.descriptionText loadHTMLString:formatedContent baseURL:nil];
		cell.descriptionText.backgroundColor = [UIColor clearColor];
		[announcementCells addObject:cell];		
	}
	
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(updateAnnouncementsTable) userInfo:nil repeats:NO];
}

-(void) updateAnnouncementsTable {
   [recentAnnouncements reloadData]; 
}

-(void) setUpTimeTableView {
	
	NSMutableArray *moduleEventsList = [NSMutableArray array];
	NSArray *tempEventsList = [[[IVLE instance] MyOrganizerIVLE:@"1/1/2011" withEndDate:@"20/12/2011"] objectForKey:@"Results"];
	
	for (int i = 0; i < tempEventsList.count; i++) {
		
		ModuleEvent *newModuleEvent = [[ModuleEvent alloc] init];
		[newModuleEvent createModuleEvent:[tempEventsList objectAtIndex:i]];
		[moduleEventsList addObject:newModuleEvent];
		[newModuleEvent release];
	}
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSString *date = [dateFormat stringFromDate:[NSDate date]];
	
	//get events on the current date
	NSMutableArray *eventsOnThisDate = [NSMutableArray array];
	
	for (int i = 0; i < moduleEventsList.count; i++) {
		
		NSString *currentDate = [dateFormat stringFromDate:[[moduleEventsList objectAtIndex:i] date]];
		
		if ([currentDate isEqualToString:date]) {
			
			[eventsOnThisDate addObject:[moduleEventsList objectAtIndex:i]];
		}
	}
	
	timetableCells = [eventsOnThisDate retain];
	[recentTimetable reloadData];
}

#pragma mark -
#pragma mark Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if (tableView == recentAnnouncements) {
		// Return the number of sections.
		tableView.allowsSelection = NO;
		tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"modules_workbin_3rd_column.png"]];
		return 1;
	}
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (tableView == recentAnnouncements) {
		if (tableView.tag == kHomePageTimetableViewTag) {
			return 1;
		}
		else {
			return [announcements count];
		}
	}
	else {
		return [timetableCells count];
	}

	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if (tableView == recentAnnouncements) {
		if (tableView.tag == kHomePageTimetableViewTag) {
			return [announcementCells objectAtIndex:[indexPath row]];
		}
		else {
			return [announcementCells objectAtIndex:[indexPath row]];
		}
	}
	else {
		TimeTableCell *cell;
		
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeTableCell" 
													 owner:self
												   options:nil];
		cell = [nib objectAtIndex:0];
		
		cell.eventTitle.text = [[timetableCells objectAtIndex:indexPath.row] title];
		
		NSString *eventType = [[timetableCells objectAtIndex:indexPath.row] eventType];
		if ( [eventType compare:@"IVLE"] == NSOrderedSame) {
			cell.eventType.image = [UIImage imageNamed:@"ivle_events.png"];
		}
		else if([eventType compare:@"Personal"] == NSOrderedSame) {
			cell.eventType.image = [UIImage imageNamed:@"personal_events"];
		}
		else {
			cell.eventType.image = [UIImage imageNamed:@"timetable_events.png"];
		}
		
		
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateStyle:kCFDateFormatterMediumStyle];
		cell.eventDate.text = [formatter stringFromDate:[[timetableCells objectAtIndex:indexPath.row] date]];
		
		cell.eventTitle.textColor = kWorkbinFontColor;
		cell.eventDate.textColor = kWorkbinFontColor;
		//    cell.eventType.textColor = kWorkbinFontColor;
		cell.backgroundColor = [UIColor clearColor];
		return cell;
	}

	return nil;
}

- (void)loadContent:(NSString*)string{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == recentAnnouncements) {
		if (tableView.tag == kHomePageTimetableViewTag) {
			HomePageModuleAnnouncementCell *cell = [announcementCells objectAtIndex:[indexPath row]];
			return cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.titleText.frame.origin.y);
		}
		else {
			
			HomePageModuleAnnouncementCell *cell = [announcementCells objectAtIndex:[indexPath row]];
			return cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.titleText.frame.origin.y);
		}
	}
	return 50;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}


- (void)displayLogin{
	
	IVLELoginWebViewController *login = [[IVLELoginWebViewController alloc]init];
	
	
//	[self memoryManagementOfViewControllers:login];
//	login.view.frame= CGRectMake(0, 50, 1024, 718);
	login.wantsFullScreenLayout = YES;
	login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	login.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:login animated:NO];
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

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//NSLog(@"main dealloc");
	[timetable release];
	[recentAnnouncements release];
	[timetableCells release];

    [super dealloc];
}

@end
