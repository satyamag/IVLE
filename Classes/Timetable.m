    //
//  Timetable.m
//  IVLE
//
//  Created by QIN HUAJUN on 3/27/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "Timetable.h"


@implementation Timetable

@synthesize sections, schedule;
@synthesize managedObjectContext, timetableDays, timetableClasses;


#pragma mark sync with calendar methods

- (void)addToCalendar:(CoreDataTimetableClassInfo *)newClass
{
	EKEventStore* store = [[[EKEventStore alloc] init] autorelease];
	EKEvent* event = [EKEvent eventWithEventStore:store];
	
	event.title = newClass.moduleCode;
	event.location = newClass.classLocation;
	event.notes = newClass.classType;
	event.startDate = newClass.startTime;
	event.endDate = newClass.endTime;
	event.calendar = [store defaultCalendarForNewEvents];
	
	//NSLog(@"%@ end: %@",event.startDate, event.endDate);
	//set recurrence
	EKRecurrenceRule * recurrenceRule = [[EKRecurrenceRule alloc] 
										 initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
										 interval:1
										 end:nil];
	event.recurrenceRule = recurrenceRule;
	[recurrenceRule release];
	
	NSError *err;
	[store saveEvent:event span:EKSpanThisEvent error:&err];
	if (err != nil) {
		NSLog(@"error adding event: %@", err);
	}
	
	//record the event identifier
	newClass.eventIdentifier = event.eventIdentifier;
	//NSLog(@"event identifier: %@", newClass.eventIdentifier);
					
}

- (void)removeFromCalendar:(NSString *)eventIdentifier {
	EKEventStore* store = [[[EKEventStore alloc] init] autorelease];
	EKEvent* event = [store eventWithIdentifier:eventIdentifier];
	
	NSError* err = nil;
	if (event != nil) {  
		//NSLog(@"event found in calendar!");
		[store removeEvent:event span:EKSpanThisEvent error:&err];
	}
	if (err != nil) {
		NSLog(@"error removing event: %@", err);
	}
}

#pragma mark class life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *backgroundImage = [UIImage imageNamed:@"timetable_background.png"];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
	
	timetable.backgroundView = nil;
	timetable.backgroundColor = [UIColor clearColor];
	
	managedObjectContext = [[[ModulesFetcher sharedInstance] managedObjectContext] retain];
	timetableDays = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableDay" withPredicate:nil]];
	timetableClasses = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableClassInfo" withPredicate:nil]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:[self retain] action:@selector(addNewClass:)];
}

#pragma mark Core data 

//delegate method from TimetableAddClassViewController
- (void)addClassWithInfo:(NSDictionary *)info
{
	//@"startTime", @"endTime", @"moduleName", @"classType", @"location", @"day"
	
	//create object for core data
	CoreDataTimetableClassInfo *newClass = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataTimetableClassInfo" inManagedObjectContext:managedObjectContext];
	[newClass setStartTime:[info objectForKey:@"startTime"]];
	[newClass setEndTime:[info objectForKey:@"endTime"]];
	[newClass setModuleCode:[info objectForKey:@"moduleName"]];
	[newClass setClassType:[info objectForKey:@"classType"]];
	[newClass setClassLocation:[info objectForKey:@"location"]];
	
	//add to calendar and get the event identifier
	[self addToCalendar:newClass];
	
	BOOL dayExists = NO;
	for (int i=0; i<[timetableDays count]; i++) {
		
		CoreDataTimetableDay *currentDay = [timetableDays objectAtIndex:i];
		
		if ([[currentDay day] isEqualToString: [info objectForKey:@"day"]]) {
			
			//add the new class to the day's set
			[currentDay addTimetableClassInfoObject:newClass];
			[newClass setBelongsToTimetableDay:currentDay];
			
			dayExists = YES;
		}
	}
	
	if (!dayExists) {

		//create new day
		CoreDataTimetableDay *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataTimetableDay" inManagedObjectContext:managedObjectContext];
		[newDay setDay:[info objectForKey:@"day"]];
		[newDay addTimetableClassInfoObject:newClass];
		[newClass setBelongsToTimetableDay:newDay];
		
		//check if timetable exists
		NSMutableArray *timetables = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetable" withPredicate:nil]];
		if ([timetables count] == 0) {

			CoreDataTimetable *newTimetable = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataTimetable" inManagedObjectContext:managedObjectContext];
			[newTimetable addTimetableDayObject:newDay];
			[newDay setBelongsToTimetable:newTimetable];
		}
		else {
			CoreDataTimetable *currentTimetable = [timetables objectAtIndex:0];
			[currentTimetable addTimetableDayObject:newDay];
			[newDay setBelongsToTimetable:currentTimetable];
		}
		
		//added by SJ.
		[timetables release];

	}
	
	NSError *error = nil;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	//NSLog(@"successfully added core data for timetable");
	
	//update the table data source
	[timetableDays release];
	timetableDays = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableDay" withPredicate:nil]]; 
	
	[timetableClasses release];
	timetableClasses = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableClassInfo" withPredicate:nil]];
	
	//dismiss popover window
	[popover dismissPopoverAnimated:YES];
	
	//reload table view
	[timetable reloadData];
	
}

//remove a class from timetable and core data
- (void)removeClass:(CoreDataTimetableClassInfo *)class FromDay:(CoreDataTimetableDay *)day
{
	//remove from calendar
	[self removeFromCalendar:class.eventIdentifier];
	
	//check if the day is empty and remove if yes
	if ([timetableDays count] == 1) {
		
		[managedObjectContext deleteObject:day];
	}
	
	[managedObjectContext deleteObject:class];
	
	NSError *error = nil;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		} 
	}
	
	//update the table data source
	[timetableDays release];
	timetableDays = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableDay" withPredicate:nil]]; 
	
	
	[timetableClasses release];
	timetableClasses = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CoreDataTimetableClassInfo" withPredicate:nil]];
	
	[timetable reloadData];
}

#pragma mark IBAction

- (IBAction)addNewClass:(id)sender 
{
	//NSLog(@"start adding new class");
	if (popover) {
		[popover dismissPopoverAnimated:YES];
	}
	
	TimetableAddClassViewController* tacvc = [[TimetableAddClassViewController alloc] init];
	[tacvc setDelegate:self];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tacvc];
	popover = [[UIPopoverController alloc] initWithContentViewController:nc];
	[popover presentPopoverFromRect:addModuleButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}


#pragma mark -
#pragma mark Table view data source

- (NSArray *)sections {
	if (!sections) {
		sections = [[NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday",nil] retain]; 
	}
	return sections;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self sections] count];
}

- (NSSet *)getClassForDay:(NSString*)_day
{
	for (int i=0; i<[timetableDays count]; i++) {
		if ([[(CoreDataTimetableDay*)[timetableDays objectAtIndex:i] day] isEqualToString:[_day substringToIndex:3]]) {
			return [[timetableDays objectAtIndex:i] TimetableClassInfo];
		}
	}
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSSet *classesInDay = [self getClassForDay:[self.sections objectAtIndex:section]];
	if (classesInDay != nil) {
		return [[classesInDay allObjects] count];
	}
	else {
		return 0;
	}
}


//configure the subviews of a cell for showing data
- (UITableViewCell *)getCellContentView:(NSString *)cellIdentifier
{
	CGRect timeFrame = CGRectMake(10, 5, 150, 30);
	CGRect moduleNameFrame = CGRectMake(220, 5, 100, 30);
	CGRect classTypeFrame = CGRectMake(400, 5, 100, 30);
	CGRect locationFrame = CGRectMake(570, 5, 100, 30);
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    
	UILabel *temp;
	temp = [[UILabel alloc] initWithFrame:timeFrame];
	temp.backgroundColor = [UIColor clearColor];
	temp.tag = 1;
	[cell.contentView addSubview:temp];
	[temp release];
	
	//add module name
	temp = [[UILabel alloc] initWithFrame:moduleNameFrame];
	temp.backgroundColor = [UIColor clearColor];
	temp.tag = 2;
	[cell.contentView addSubview:temp];
	[temp release];
	
	//add class type
	temp = [[UILabel alloc] initWithFrame:classTypeFrame];
	temp.backgroundColor = [UIColor clearColor];
	temp.tag = 3;
	[cell.contentView addSubview:temp];
	[temp release];
	
	//add location
	temp = [[UILabel alloc] initWithFrame:locationFrame];
	temp.backgroundColor = [UIColor clearColor];
	temp.tag = 4;
	[cell.contentView addSubview:temp];
	[temp release];
	
	return cell;
}

- (NSArray *)classInfoAtIndexPath:(NSIndexPath *)indexPath 
{
	
	//NSSet *classesInDay = [[timetableDays objectAtIndex:indexPath.section] TimetableClassInfo];
	NSSet *classesInDay = [self getClassForDay:[self.sections objectAtIndex:indexPath.section]];
	if (classesInDay == nil) {
		NSLog(@"error getting classInfoForIndexPath");
	}
	
	CoreDataTimetableClassInfo *classInfo = [[classesInDay allObjects] objectAtIndex:indexPath.row];
	return [NSArray arrayWithObjects:classInfo.startTime, classInfo.endTime, classInfo.moduleCode, classInfo.classType, classInfo.classLocation, nil];
	
}

//return a string format of the date for displaying in the tableview
- (NSString *)getStringFormatForDate:(NSDate *)date
{
	//format the time into string
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"hh:mm a";
	NSString *time = [formatter stringFromDate:date];
	
	NSString *newTime;
	if ([time hasSuffix:@"PM"]) {
		NSString *min = [time substringWithRange:NSMakeRange(2, 3)];
		NSInteger hour = [[time substringToIndex:2] integerValue];
		NSInteger newHour = hour + 12;
		if (newHour == 24) {
			newHour = 12;
		}
		newTime = [[NSString stringWithFormat:@"%d", newHour] stringByAppendingString:min];
	}
	
	else if ([time hasSuffix:@"AM"] && [[time substringToIndex:2] integerValue] == 12) {
		NSString *min = [time substringWithRange:NSMakeRange(6, 3)];
		
		newTime = [[NSString stringWithString:@"00"] stringByAppendingString:min];
	}
	
	else {
		newTime = [time substringToIndex:5];
	}
	
	return newTime;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimetableTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self getCellContentView:CellIdentifier];
		//cell.backgroundColor = [UIColor clearColor];
    }
	
	NSArray *classInfo = [self classInfoAtIndexPath:indexPath];
	//class info format: startTime, endTime, moduleName, classType, location

	UILabel *temp;
	for (int i=0; i<4; i++) {
		temp = (UILabel *)[cell viewWithTag:i+1];
		if (i==0) {
			NSString *st = [self getStringFormatForDate:[classInfo objectAtIndex:i]];
			NSString *et = [self getStringFormatForDate:[classInfo objectAtIndex:i+1]];
			temp.text = [[st stringByAppendingString:@" - "] stringByAppendingString:et];
		}
		else {
			temp.text = [classInfo objectAtIndex:i+1];
		}
		//temp.textColor = [UIColor whiteColor];

	}

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		CoreDataTimetableDay *currentDay;
		for (int i=0; i<[timetableDays count]; i++) {
			;
			if ([[(CoreDataTimetableDay*)[timetableDays objectAtIndex:i] day]  isEqualToString:[[self.sections objectAtIndex:indexPath.section] substringToIndex:3]]) {
				currentDay = [timetableDays objectAtIndex:i];
			}
		}
		CoreDataTimetableClassInfo *currentClass = [[[currentDay TimetableClassInfo] allObjects] objectAtIndex:indexPath.row];
		[self removeClass:currentClass FromDay:currentDay];
	}     
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//deselect row
	[timetable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *title = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
	title.backgroundColor = [UIColor clearColor];
	title.text = [sections objectAtIndex:section];
	title.font = [UIFont boldSystemFontOfSize:20];
	//title.textColor = [UIColor whiteColor];
	//title.textAlignment = UITextAlignmentCenter;
	return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40.0;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
    return NO;
}


#pragma mark -
#pragma mark Memory management

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
	[schedule release];
	[sections release];
	[managedObjectContext release];
	[timetableDays release];
	[timetableClasses release];
	[popover release];
	[buttonsArray release];
    [super dealloc];
}


@end
