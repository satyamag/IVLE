//
//  TimetableNew.m
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimetableNew.h"


@implementation TimetableNew

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // get all module IDs and it's timetables		
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//this block of code basically initializes all the module events in IVLE into the array "moduleEventsList"
	IVLE *ivleInstance = [IVLE instance];
	
	if (!moduleEventsList) {
		
		moduleEventsList = [[NSMutableArray alloc] init];
	}
	else {
		
		[moduleEventsList removeAllObjects];
	}
	
	NSArray *tempEventsList = [[ivleInstance MyOrganizerIVLE:@"1/1/2011" withEndDate:@"20/12/2011"] objectForKey:@"Results"];
	
	for (int i = 0; i < tempEventsList.count; i++) {
		
		ModuleEvent *newModuleEvent = [[ModuleEvent alloc] init];
		[newModuleEvent createModuleEvent:[tempEventsList objectAtIndex:i]];
		[moduleEventsList addObject:newModuleEvent];
		[newModuleEvent release];
	}
	
	//NSLog(@"%@", moduleEventsList);
	
	/*NSArray *modulesList = [NSArray arrayWithArray:[[ivleInstance modules:0 withAllInfo:NO] objectForKey:@"Results"]];
	 
	 if (!moduleEventsList) {
	 
	 moduleEventsList = [[NSMutableArray alloc] init];
	 }
	 else {
	 
	 [moduleEventsList removeAllObjects];
	 }
	 
	 NSMutableArray *moduleIDsList = [NSMutableArray arrayWithObjects:nil];
	 
	 for (int i = 0; i < [modulesList count]; i++) {
	 
	 [moduleIDsList addObject:[[modulesList objectAtIndex:i] objectForKey:@"ID"]];
	 NSArray *moduleEvents = [[ivleInstance timetableStudentModule:[moduleIDsList objectAtIndex:i]] objectForKey:@"Results"];
	 
	 for (int j = 0; j < moduleEvents.count; j++) {
	 
	 ModuleEvent *newModuleEvent = [[ModuleEvent alloc] init];
	 [newModuleEvent createModuleEvent:[moduleEvents objectAtIndex:j]];
	 [moduleEventsList addObject:newModuleEvent];
	 [newModuleEvent release];
	 }
	 }
	 
	 NSLog(@"%@", moduleEventsList);
	 */
	//create a calendar (Tapku)
	calendar = [[TKCalendarMonthView alloc] init];
	calendar.delegate = self;
	calendar.dataSource = self;
	[self.view addSubview:calendar];
	[calendar reload];
}

#pragma mark -
#pragma mark Tapku datasource and delegates

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSMutableArray *tempData = [NSMutableArray array];
	for (int i = 0; i < moduleEventsList.count; i++) {
		
		NSString *tempDate = [dateFormat stringFromDate:[[moduleEventsList objectAtIndex:i] date]];
		//NSLog(@"%@", tempDate);
		
		[tempData addObject:tempDate];
	}
	
	NSArray *data = [NSArray arrayWithArray:tempData];
	/*
	 //test data
	 NSArray *data = [NSArray arrayWithObjects:
	 @"2011-08-01 00:00:00 +0000", @"2011-08-09 00:00:00 +0000", @"2011-08-22 00:00:00 +0000",
	 @"2011-08-10 00:00:00 +0000", @"2011-08-11 00:00:00 +0000", @"2011-08-12 00:00:00 +0000",
	 @"2011-08-15 00:00:00 +0000", @"2011-08-28 00:00:00 +0000", @"2011-08-04 00:00:00 +0000", nil];
	 */
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first 
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
											  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
									fromDate:startDate];
	NSDate *date = [cal dateFromComponents:comp];
	NSString *d = [dateFormat stringFromDate:date];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];	
	
	
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([date compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		BOOL flag = FALSE;
		
		// If the date is in the data array, add it to the marks array, else don't
		for (int i = 0; i < data.count; i++) {
			
			if ([[data objectAtIndex:i] isEqualToString:d]) {
				
				flag = TRUE;
				break;
			}
			else {
				flag = FALSE;
			}
			
		}
		
		if (flag) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		date = [cal dateByAddingComponents:offsetComponents toDate:date options:0];
		d = [dateFormat stringFromDate:date];
	}
	
	[offsetComponents release];
	
	//NSLog(@"%@", marks);
	
	return [NSArray arrayWithArray:marks];
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSString *date = [dateFormat stringFromDate:d];
	
	//get events on the current date
	NSMutableArray *eventsOnThisDate = [NSMutableArray array];
	
	for (int i = 0; i < moduleEventsList.count; i++) {
		
		NSString *currentDate = [dateFormat stringFromDate:[[moduleEventsList objectAtIndex:i] date]];
		
		if ([currentDate isEqualToString:date]) {
			
			[eventsOnThisDate addObject:[moduleEventsList objectAtIndex:i]];
		}
	}
	
	currentDisplayEvents = [eventsOnThisDate retain];
	[currentEventsTable reloadData];
	
	//present these events on some view...
	/*for (ModuleEvent *event in eventsOnThisDate) {
	 
	 NSLog(@"%@", event);
	 }*/
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)d {
	
	NSLog(@"%@", d);
}

#pragma mark -
#pragma mark Table view delegates

#pragma mark -
#pragma mark Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [currentDisplayEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[cell.textLabel setText:[[currentDisplayEvents objectAtIndex:indexPath.row] title]];
	
	return cell;
}

#pragma mark -
#pragma mark Misc memory management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[moduleEventsList release];
	
    [super dealloc];
}


@end
