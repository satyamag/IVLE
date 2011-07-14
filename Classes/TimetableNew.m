//
//  TimetableNew.m
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimetableNew.h"
#define kCourseID @"aefeaca4-f40a-4c82-9c8e-95f92c7ed0da"

@interface TimetableNew (PrivateMethods)

- (NSDate *)convertJSONDateToNSDateForDate:(NSString *)aDateInJSON;

@end


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
	UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
    
	if (!moduleEventsList) {
		
		moduleEventsList = [[NSMutableArray alloc] init];
	}
	else {
		
		[moduleEventsList removeAllObjects];
	}
	
	NSArray *tempEventsList = [[ivleInstance MyOrganizerIVLE:@"1/1/2011" withEndDate:@"20/12/2011"] objectForKey:@"Results"];
	
	//first add events from MyOrganizer
	for (int i = 0; i < tempEventsList.count; i++) {
		
		ModuleEvent *newModuleEvent = [[ModuleEvent alloc] init];
		[newModuleEvent createModuleEvent:[tempEventsList objectAtIndex:i]];
		[moduleEventsList addObject:newModuleEvent];
		[newModuleEvent release];
	}
	
	//NSLog(@"%@", [ivleInstance timetableStudent:@"2010/2011" forSemester:@"3"]);
	NSArray *timetableStudent = [[ivleInstance timetableStudent:@"2010/2011" forSemester:@"3"] objectForKey:@"Results"];

	for (int i = 0; i < timetableStudent.count; i++) {
		
		NSDictionary *currentEvent = [timetableStudent objectAtIndex:i];
		//NSLog(@"%@", currentEvent);
		ModuleEvent2 *newModuleEvent = [[ModuleEvent2 alloc] init];
		NSDictionary *semInfo = [[[ivleInstance MyOrganizerAcadSemesterInfo:[currentEvent objectForKey:@"AcadYear"] ForSem:[currentEvent objectForKey:@"Semester"]] objectForKey:@"Results"] objectAtIndex:0];
		//NSLog(@"%@", semInfo);
		NSDate *startDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterStartDate"]];
		NSDate *endDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterEndDate"]];
		[newModuleEvent createModuleEvent:currentEvent StartDate:startDate EndDate:endDate];
		[moduleEventsList addObject:newModuleEvent];
		[newModuleEvent release];
	}
	/*
	//then add stuff from course timetable
	NSArray *modulesList = [NSArray arrayWithArray:[[ivleInstance modules:0 withAllInfo:NO] objectForKey:@"Results"]];
	
	NSMutableArray *moduleIDsList = [NSMutableArray arrayWithObjects:nil];
	
	for (int i = 0; i < [modulesList count]; i++) {
		
		[moduleIDsList addObject:[[modulesList objectAtIndex:i] objectForKey:@"ID"]];
		NSArray *moduleEvents = [[ivleInstance timetableStudentModule:[moduleIDsList objectAtIndex:i]] objectForKey:@"Results"];
		NSLog(@"%@", moduleEvents);
		for (int j = 0; j < moduleEvents.count; j++) {
			
			NSDictionary *currentEvent = [moduleEvents objectAtIndex:j];
			NSLog(@"%@", currentEvent);
			ModuleEvent2 *newModuleEvent = [[ModuleEvent2 alloc] init];
			NSDictionary *semInfo = [[[ivleInstance MyOrganizerAcadSemesterInfo:[currentEvent objectForKey:@"AcadYear"] ForSem:[currentEvent objectForKey:@"Semester"]] objectForKey:@"Results"] objectAtIndex:0];
			NSLog(@"%@", semInfo);
			NSDate *startDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterStartDate"]];
			NSDate *endDate = [self convertJSONDateToNSDateForDate:[semInfo objectForKey:@"SemesterEndDate"]];
			[newModuleEvent createModuleEvent:currentEvent StartDate:startDate EndDate:endDate];
			[moduleEventsList addObject:newModuleEvent];
			[newModuleEvent release];
		}
	}
	*/
	//NSLog(@"%@", moduleEventsList);
	
	//create a calendar (Tapku)
	calendar = [[TKCalendarMonthView alloc] init];
	calendar.delegate = self;
	calendar.dataSource = self;
	[self.view addSubview:calendar];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"modules_workbin_3rd_column.png"]];
	currentEventsTable.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
	[calendar reload];
}

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
#pragma mark Tapku datasource and delegates

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSMutableArray *tempData = [NSMutableArray array];
	for (int i = 0; i < moduleEventsList.count; i++) {
		//NSLog(@"%@", [[moduleEventsList objectAtIndex:i] class]);
		if ([[[moduleEventsList objectAtIndex:i] class] isEqual:[ModuleEvent class]]) {
			
			NSString *tempDate = [dateFormat stringFromDate:[[moduleEventsList objectAtIndex:i] date]];
			[tempData addObject:tempDate];
		}
		else if ([[[moduleEventsList objectAtIndex:i] class] isEqual:[ModuleEvent2 class]]){
			
			ModuleEvent2 *currentEvent = [moduleEventsList objectAtIndex:i];
			NSArray *currentEventDates = currentEvent.classDates;
			
			for (NSDate *date in currentEventDates) {
				
				[tempData addObject:[dateFormat stringFromDate:date]];
			}
		}
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
		
		if ([[[moduleEventsList objectAtIndex:i] class] isEqual:[ModuleEvent class]]) {
			NSString *currentDate = [dateFormat stringFromDate:[[moduleEventsList objectAtIndex:i] date]];
			
			if ([currentDate isEqualToString:date]) {
				
				[eventsOnThisDate addObject:[moduleEventsList objectAtIndex:i]];
			}
		}
		else if ([[[moduleEventsList objectAtIndex:i] class] isEqual:[ModuleEvent2 class]]) {
			
			NSArray *datesList = [[moduleEventsList objectAtIndex:i] classDates];
			for (int j = 0; j < datesList.count; j++) {
				
				if ([date isEqualToString:[dateFormat stringFromDate:[datesList objectAtIndex:j]]]) {
					[eventsOnThisDate addObject:[moduleEventsList objectAtIndex:i]];
				}
			}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TimeTableCell *cell;
	
	
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeTableCell" 
												 owner:self
											   options:nil];
	cell = [nib objectAtIndex:0];
	
	if ([[[currentDisplayEvents objectAtIndex:indexPath.row] class] isEqual:[ModuleEvent class]]) {
		cell.eventTitle.text = [[currentDisplayEvents objectAtIndex:indexPath.row] title];
		
		NSString *eventType = [[currentDisplayEvents objectAtIndex:indexPath.row] eventType];
		if ( [eventType compare:@"IVLE"] == NSOrderedSame) {
			cell.eventType.image = [UIImage imageNamed:@"ivle_events.png"];
		}
		else if([eventType compare:@"Personal"] == NSOrderedSame) {
			cell.eventType.image = [UIImage imageNamed:@"personal_events.png"];
		}
		else {
			cell.eventType.image = [UIImage imageNamed:@"timetable_events.png"];
		}
		
		
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateStyle:kCFDateFormatterMediumStyle];
		cell.eventDate.text = [formatter stringFromDate:[[currentDisplayEvents objectAtIndex:indexPath.row] date]];
		
		cell.eventTitle.textColor = kWorkbinFontColor;
		cell.eventDate.textColor = kWorkbinFontColor;
		//    cell.eventType.textColor = kWorkbinFontColor;
	}
	else if ([[[currentDisplayEvents objectAtIndex:indexPath.row] class] isEqual:[ModuleEvent2 class]]) {
		
		cell.eventTitle.text = [[currentDisplayEvents objectAtIndex:indexPath.row] courseID];
		cell.eventType.image = [UIImage imageNamed:@"timetable_events.png"];
	}
	
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
