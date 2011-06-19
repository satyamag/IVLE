//
//  TimetableAddClassViewController.m
//  IVLE
//
//  Created by QIN HUAJUN on 4/1/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "TimetableAddClassViewController.h"

#define TITLE 1
#define LOCATION 2

@implementation TimetableAddClassViewController

@synthesize _moduleName, _location, _classType, _day, _startTime, _endTime;
@synthesize delegate;

#pragma mark life cycle

- (BOOL)checkTimeCorrectness 
{
	if ([_startTime compare:_endTime] == NSOrderedAscending) {
		return YES;
	}
	else {
		return NO;
	}
}

//if the day of start time and end time not the same, return NO; else assign day to _day
- (BOOL)checkDay 
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"EEE";
	NSString *day1 = [formatter stringFromDate:_startTime];
	NSString *day2 = [formatter stringFromDate:_endTime];
	
	if ([day1 isEqualToString:day2]) {
		_day = day1;
		return YES;
	}
	else {
		return NO;
	}
	
}

//when done button pressed
- (void)done
{

	UITextField *moduleName = (UITextField *)[self.view viewWithTag:TITLE];
	_moduleName = [moduleName text];
	
	UITextField *location = (UITextField *)[self.view viewWithTag:LOCATION];
	_location = [location text];
	
	_classType = [classTypeSegment titleForSegmentAtIndex:[classTypeSegment selectedSegmentIndex]];
	
	//NSLog(@"%@  %@  %@  %@  %@  %@",_moduleName,_location,_day,_startTime,_endTime, _classType);
	

	//checkRep, handle empty error events
	if (!_moduleName || !_location || !_startTime || !_endTime || !_classType) {
		//propt for entering all info
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information Lacking"
														message:@"Please fill up all the information"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if (_moduleName.length < 6 || _moduleName.length > 7) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Module Code Invalid"
														message:@"Please fill in proper information"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if (_location.length > 12) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Name Too Long"
														message:@"Please fill in proper information"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if (![self checkDay]) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Day wrong!"
														message:@"The day of start time has to be the same as the end time"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if (![self checkTimeCorrectness]) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time wrong!"
														message:@"Start time has to be earlier than end time"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else {
		//create new class timetable info object
		NSDictionary *info = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_startTime, _endTime, _moduleName, _classType, _location, _day, nil]
															forKeys:[NSArray arrayWithObjects:@"startTime", @"endTime", @"moduleName", @"classType", @"location", @"day", nil]];
		[self.delegate addClassWithInfo:info];
	}
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//set up a scroll view for the content
	CGRect svRect = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height);
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:svRect];
	sv.contentOffset = CGPointMake(0, 80);
	sv.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200);
	[self.view addSubview:sv];
	[sv release];
	sv.backgroundColor = [UIColor clearColor];
	
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
	[sv addSubview:infoTable];
	
	infoTable.backgroundView = nil;
	infoTable.backgroundColor = [UIColor clearColor];
	
	self.title = @"Add Class";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

#pragma mark -
#pragma mark Delegates

//delegate method for timetablePicker
- (void)time:(NSDate *)time setFor:(NSString *)tag
{
	if ([tag isEqualToString:@"startTime"]) {
		_startTime = time;
	}
	else if ([tag isEqualToString:@"endTime"]) {
		_endTime = time;
	}
	[infoTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGSize)contentSizeForViewInPopover
{
	return self.view.frame.size;
}

#pragma mark -
#pragma mark Text field delegates

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	//convert text to uppercase
	[textField setText:[[textField text] uppercaseString]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	//auto hide the keyboard when press done/return key
	[textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

//return a string format of the date for displaying in the tableview
- (NSString *)getStringFormatForDate:(NSDate *)date
{
	//format the time into string
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"EEE hh:mm a";
	NSString *time = [formatter stringFromDate:date];
	
	NSString *newTime;
	if ([time hasSuffix:@"PM"]) {
		NSString *day = [time substringToIndex:3];
		NSString *min = [time substringWithRange:NSMakeRange(6, 3)];
		NSInteger hour = [[time substringWithRange:NSMakeRange(4, 2)] integerValue];
		NSInteger newHour = hour + 12;
		if (newHour == 24) {
			newHour = 12;
		}
		newTime = [[day stringByAppendingString:[NSString stringWithFormat:@" %d", newHour]] stringByAppendingString:min];
	}
	
	else if ([time hasSuffix:@"AM"] && [[time substringWithRange:NSMakeRange(4, 2)] integerValue] == 12) {
		NSString *day = [time substringToIndex:3];
		NSString *min = [time substringWithRange:NSMakeRange(6, 3)];
		
		newTime = [[day stringByAppendingString:[NSString stringWithString:@" 00"]] stringByAppendingString:min];
	}
	
	else {
		newTime = [time substringToIndex:9];
	}
	
	return newTime;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimetableAddClassViewTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
	    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [UIColor whiteColor];
	}
	
	//the "title" and "location" section
	if (indexPath.section == 0) {
		CGRect rect = CGRectMake(10, 9, cell.frame.size.width-20, cell.frame.size.height-18);
		UITextField *textField = [[UITextField alloc] initWithFrame:rect];
		if (indexPath.row == 0){
			textField.tag = TITLE;			
			textField.text = _moduleName;			
			textField.placeholder = @"Module Title:";
		}
		else {
			textField.tag = LOCATION;
			textField.text = _location;			
			textField.placeholder = @"Location:";
		}
		[textField setDelegate:self];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.returnKeyType = UIReturnKeyDone;
		[cell.contentView addSubview:textField];
		[textField release];
		
	}
	
	//the "day", "start time" and "end time" section
	else if (indexPath.section == 1){
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Start Time:";
				cell.detailTextLabel.text = [self getStringFormatForDate:_startTime];
				break;
			case 1:
				cell.textLabel.text = @"End Time:";
				cell.detailTextLabel.text = [self getStringFormatForDate:_endTime];
				break;
			default:
				break;
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//deselect row
	[infoTable deselectRowAtIndexPath:indexPath animated:YES];
	
	//add popover view to select day, startTime and endTime respectively
	if (indexPath.section == 1){
		if (indexPath.row == 0){
			//choose start time
			
			TimetablePickerViewController *pvc = [[TimetablePickerViewController alloc] init];
			[pvc setDelegate:self];
			[pvc setTag:@"startTime"];
			[self.navigationController pushViewController:pvc animated:YES];
			[pvc release];
		}
		else if (indexPath.row == 1){
			//choose end time
			
			TimetablePickerViewController *pvc = [[TimetablePickerViewController alloc] init];
			[pvc setDelegate:self];
			[pvc setTag:@"endTime"];
			[self.navigationController pushViewController:pvc animated:YES];
			[pvc release];
		}
	}
}

#pragma mark -
#pragma mark Memory management

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
	[classTypeSegment release];
	[infoTable release];
	[_moduleName release];
	[_location release];
	[_day release];
	[_classType release];
	[_startTime release];
	[_endTime release];
    [super dealloc];
}


@end
