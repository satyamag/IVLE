//
//  CAPAddModuleViewController.m
//  IVLE
//
//  Created by Shyam on 4/3/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "CAPAddModuleViewController.h"

@interface CAPAddModuleViewController (PrivateMethods)

- (void)done;

@end


@implementation CAPAddModuleViewController

@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setContentSizeForViewInPopover:CGSizeMake(320, 320)];
	
	//get all module list from plist file
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"ModuleList.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		
		plistPath = [[NSBundle mainBundle] pathForResource:@"ModuleList" ofType:@"plist"];
	}
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSArray *temp = (NSArray *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:&errorDesc];
	if (!temp) {
		
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	moduleList = [[NSArray alloc] initWithArray:temp];
	//moduleList = [[NSArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"ModuleList" withPredicate:nil]];
		
	moduleCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 615, 37)];
	[moduleCode setDelegate:self];
	moduleMC = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 615, 37)];
	[moduleCode setPlaceholder:@"Code"];
	[moduleMC setPlaceholder:@"MC"];
	
	moduleGrade = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 25, 31)];
	moduleSem = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 25, 31)];
	[moduleGrade setText:@"B"];
	[moduleSem setText:@"1"];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
	self.navigationItem.rightBarButtonItem = doneButton;
}

- (void) done {
	
	//check if inputs are correct
	if (moduleCode.text != nil && moduleMC.text != nil && moduleGrade.text != nil && moduleSem.text != nil) {
		
		NSNumber *MC = [NSNumber numberWithInt:[[moduleMC text] intValue]];
		NSNumber *sem = [NSNumber numberWithInt:[[moduleSem text] intValue]];
		
		[delegate userDidFinishAddingModule:[moduleCode text] WithMC:MC WithGrade:moduleGrade.text WithSemester:sem];
	}
	
	else {
		//print error
		//*************************
		//*************************
		//*************************
	}

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark Text field delegates

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField = moduleCode) {
		
		//convert text to uppercase
		[textField setText:[[textField text] uppercaseString]];
		
		//compare with module list
		for (int i = 0; i < [moduleList count]; i++) {
			
			NSDictionary *currentModule = [moduleList objectAtIndex:i];
			NSString *storedCode = [currentModule objectForKey:@"Code"];
			
			if (([storedCode rangeOfString:[moduleCode text]]).location != NSNotFound) {
				
				[moduleMC setText:[NSString stringWithFormat:@"%d", [[currentModule objectForKey:@"MC"] intValue]]];
			}
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	if (textField == moduleCode) {
		
		[moduleMC becomeFirstResponder];
	}
	
	return YES;
}

#pragma mark -
#pragma mark Popover delegates

- (void)userDidFinishChoosingGrade:(NSString *)aGrade {

	[moduleGrade setText:aGrade];
}

- (void)userDidFinishChoosingSem:(int)semester {
	
	[moduleSem setText:[NSString stringWithFormat:@"%d", semester]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
		case 0:
		{
			//[[cell textLabel] setText:@"Code"];
			[cell addSubview:moduleCode];
			break;
		}
		case 1:
		{
			//[[cell textLabel] setText:@"MC"];
			[cell addSubview:moduleMC];
			break;
		}
		case 2:
		{
			[[cell textLabel] setText:@"Grade"];
			[cell addSubview:moduleGrade];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
		}
		case 3:
		{
			[[cell textLabel] setText:@"Semester"];
			[cell addSubview:moduleSem];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
		}

		default:
			break;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	//deselect cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.row) {
		case 2:
		{
			CAPGradeChooserViewController *gradeChooser = [[CAPGradeChooserViewController alloc] init];
			[gradeChooser setDelegate:self];
			[self.navigationController pushViewController:gradeChooser animated:YES];
			
			[gradeChooser release];
			break;
		}
		case 3:
		{
			CAPSemChooserViewController *semChooser = [[CAPSemChooserViewController alloc] init];
			[semChooser setDelegate:self];
			[self.navigationController pushViewController:semChooser animated:YES];
			[self setContentSizeForViewInPopover:CGSizeMake(320, 320)];
			[semChooser release];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[moduleCode release];
	[moduleMC release];
	[moduleSem release];
	[moduleGrade release];
	[moduleList release];
	
    [super dealloc];
}

@end

