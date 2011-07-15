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

#pragma mark -
#pragma mark Initializers

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSString *imageName;
        if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
            imageName= @"home_page_announcements_bg_portrait.png";
        }
        else imageName= @"home_page_announcements_bg.png";
        
		UIImage *blackboardImage = [UIImage imageNamed:imageName];
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
	
	recentTimetable.tag = kHomePageTimetableViewTag;
	recentAnnouncements.tag = kHomePageAnnouncementsViewTag;
	
	self.view.frame = CGRectMake(0,0,1024, 768);
	[recentTimetable setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name:kNotificationRefreshScreen object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpHomePageComponents:) name:kNotificationSetupHomePageComponents object:nil];
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLogin:) name:kNotificationLoginScreen object:nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"authToken.txt"];
	NSError *error;
	NSString *stringFromFileAtPath = [[NSString alloc]
									  initWithContentsOfFile:path
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
	if (stringFromFileAtPath == nil) {
		[self performSelector:@selector(displayLogin) withObject:nil afterDelay:0.0];
	}
	else {
		[[IVLE instance] setAuthToken:stringFromFileAtPath];
		[[ModulesFetcher sharedInstance] setUserID:[[IVLE instance] getAndSetUserName]];
		NSDictionary *tokenValidity = [[IVLE instance] validate];
		if ([tokenValidity objectForKey:@"Token"] != nil) {
			
			[[IVLE instance] setAuthToken:[tokenValidity objectForKey:@"Token"]];
			[[ModulesFetcher sharedInstance] setUserID:[[IVLE instance] getAndSetUserName]];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetupHomePageComponents object:nil];
	}
	[self.view setAutoresizesSubviews:YES];
	/*if ([IVLE instance].authenticationToken == nil) {
	 [self performSelector:@selector(displayLogin) withObject:nil afterDelay:0.0];
	 }*/
}

-(void) setUpHomePageComponents:(NSNotification*)notification {
	
    [self setUpAnnouncementsView];
	[self setUpEventsView];
    
    [self.view addSubview:recentAnnouncements];
	
	[pageControlView addSubview:eventsPageControl];
	[rightHandSideView addSubview:pageControlView];
	[rightHandSideView addSubview:eventsScrollView];
	[self.view addSubview:rightHandSideView];
	[self setUpTimeTableView];
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

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_announcements_bg.png"]]];
    }
    else
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_announcements_bg_portrait.png"]]];
}

#pragma mark -
#pragma mark PrivateMethods

- (NSDate *)convertJSONDateToNSDateForDate:(NSString *)aDateInJSON {
	
	/*
	 * This will convert DateTime (.NET) object serialized as JSON by WCF to a NSDate object.
	 */
	
	// Input string is something like: "/Date(1292851800000+0100)/" where
	// 1292851800000 is milliseconds since 1970 and +0100 is the timezone
	NSString *inputString = aDateInJSON;
	
	// This will tell number of seconds to add according to your default timezone
	// Note: if you don't care about timezone changes, just delete/comment it out
	NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	
	// A range of NSMakeRange(6, 10) will generate "1292851800" from "/Date(1292851800000+0100)/"
	// as in example above. We crop additional three zeros, because "dateWithTimeIntervalSince1970:"
	// wants seconds, not milliseconds; since 1 second is equal to 1000 milliseconds, this will work.
	// Note: if you don't care about timezone changes, just chop out "dateByAddingTimeInterval:offset" part
	NSDate *convertedDate = [[NSDate dateWithTimeIntervalSince1970:
							  [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]]
							 dateByAddingTimeInterval:offset];
	/*
	 // You can just stop here if all you care is a NSDate object from inputString,
	 // or see below on how to get a nice string representation from that date:
	 
	 // static is nice if you will use same formatter again and again (for example in table cells)
	 static NSDateFormatter *dateFormatter = nil;
	 if (dateFormatter == nil) {
	 dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateStyle:NSDateFormatterShortStyle];
	 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	 
	 // If you're okay with the default NSDateFormatterShortStyle then comment out two lines below
	 // or if you want four digit year, then this will do it:
	 NSString *fourDigitYearFormat = [[dateFormatter dateFormat]
	 stringByReplacingOccurrencesOfString:@"yy"
	 withString:@"yyyy"];
	 [dateFormatter setDateFormat:fourDigitYearFormat];
	 }
	 
	 // There you have it:
	 NSString *outputString = [dateFormatter stringFromDate:date];
	 */
	return convertedDate;
}

#pragma mark -
#pragma mark Announcements

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
        
        NSString *orientationIdentifier;
        if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
            orientationIdentifier= @"HomePageModuleAnnouncementCellPortrait";
        }
        else orientationIdentifier= @"HomePageModuleAnnouncementCell";
        
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:orientationIdentifier 
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
	
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(updateAnnouncementsTable) userInfo:nil repeats:NO];
}

-(void) updateAnnouncementsTable {
	[recentAnnouncements reloadData]; 
}

#pragma mark -
#pragma mark Events

- (void) setUpEventsView {
	
	//setting up events
	IVLE *ivleInterface = [IVLE instance];
	
	NSArray *eventsArray = [[ivleInterface studentEvents:YES] objectForKey:@"Results"];
	
	[eventsScrollView setBackgroundColor:[UIColor blackColor]];
	
	eventsScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	eventsScrollView.clipsToBounds = YES;
	
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
		eventTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
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

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }

    CGFloat pageWidth = 512;//_scrollView.frame.size.width;
	NSLog(@"%f", _scrollView.contentOffset.x);
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    eventsPageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

- (IBAction)changePage:(id)sender 
{
	
    CGRect frame = eventsScrollView.frame;
    frame.origin.x = 512 * eventsPageControl.currentPage;
    frame.origin.y = 0;
	
    [eventsScrollView scrollRectToVisible:frame animated:YES];
	
    pageControlIsChangingPage = YES;
}


#pragma mark -
#pragma mark Time table

-(void) setUpTimeTableView {
	
	timetableCells = [[NSMutableArray alloc] init];
	
	NSArray *timetableStudent = [[[IVLE instance] timetableStudent:@"2010/2011" forSemester:@"3"] objectForKey:@"Results"];
	
	for (int i = 0; i < timetableStudent.count; i++) {
		
		NSDictionary *currentEvent = [timetableStudent objectAtIndex:i];
		ModuleEvent2 *newModuleEvent = [[ModuleEvent2 alloc] init];
		NSDictionary *semInfo = [[[[IVLE instance] MyOrganizerAcadSemesterInfo:[currentEvent objectForKey:@"AcadYear"] ForSem:[currentEvent objectForKey:@"Semester"]] objectForKey:@"Results"] objectAtIndex:0];
		NSDate *startDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterStartDate"]];
		NSDate *endDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterEndDate"]];
		[newModuleEvent createModuleEvent:currentEvent StartDate:startDate EndDate:endDate];
		[timetableCells addObject:newModuleEvent];
		[newModuleEvent release];
	}	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSString *date = [dateFormat stringFromDate:[NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]]];
	
	//get events on the current date
	NSMutableArray *eventsOnThisDate = [NSMutableArray array];
	
	for (int i = 0; i < timetableCells.count; i++) {
		
		NSArray *datesList = [[timetableCells objectAtIndex:i] classDates];
		for (int j = 0; j < datesList.count; j++) {
			
			if ([date isEqualToString:[dateFormat stringFromDate:[datesList objectAtIndex:j]]]) {
				[eventsOnThisDate addObject:[timetableCells objectAtIndex:i]];
			}
		}
	}
	
	[timetableCells release];
	timetableCells = [eventsOnThisDate retain];
	
	[recentTimetable reloadData];
}

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
		
		ModuleEvent2 *currentEvent = [timetableCells objectAtIndex:indexPath.row];
		cell.eventTitle.text = [currentEvent courseID];
		cell.eventType.image = [UIImage imageNamed:@"timetable_events.png"];
		cell.eventDate.text = [NSString stringWithFormat:@"%@ - %@ \t Venue: %@", [currentEvent startTime], [currentEvent endTime], [currentEvent venue]];
        
        cell.eventTitle.textColor = kWorkbinFontColor;
        cell.eventDate.textColor = kWorkbinFontColor;
		
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

#pragma mark -
#pragma mark Memory handling functions

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	return YES;
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
	[recentTimetable release];
	[recentAnnouncements release];
	[timetableCells release];
	
    [super dealloc];
}

@end
