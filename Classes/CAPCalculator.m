//
//  CAPCalculator.m
//  IVLE
//
//  Created by Shyam on 3/27/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "CAPCalculator.h"

@interface CAPCalculator (PrivateMethods)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)addModule:(NSString *)newModuleCode WithMC:(NSNumber *)newModuleMC WithGrade:(NSString *)newModuleGrade WithSemester:(NSNumber *)newSemester;
- (void)removeModule:(CAPModule *)module ForSemester:(Semester *)semester;
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event;
- (void)updateModuleList;

- (float)gradeInFloat:(NSString *)aGrade;
- (float)calculateCAP;
- (float)calculateSAPForSem:(int)semester;
- (void)updateHeader;

@end

@implementation CAPCalculator

@synthesize modulesCompleted, MCsCompleted;
@synthesize managedObjectContext;
//@synthesize modulesTableView;

#pragma mark -
#pragma mark Accessors

- (int)modulesCompleted {
	
	return [moduleObjects count];
}

- (int)MCsCompleted {
	
	int totalMCs = 0;
	
	for (int i = 0; [moduleObjects count]; i++) {
		CAPModule *currentObject = [moduleObjects objectAtIndex:i];
		totalMCs += [[currentObject CAPModuleMC] integerValue];
	}
	
	return totalMCs;
}

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		
	}
    return self;
}

#pragma mark -
#pragma mark Module handling functions

- (void)addModule:(NSString *)newModuleCode WithMC:(NSNumber *)newModuleMC WithGrade:(NSString *)newModuleGrade WithSemester:(NSNumber *)newSemester {
	// MODIFIES:  core data and moduleObjects
	// REQUIRES: none
	// EFFECTS:  adds module to system
	
 	//add object to core data
	CAPModule *module = [NSEntityDescription insertNewObjectForEntityForName:@"CAPModule" inManagedObjectContext:managedObjectContext];
	[module setCAPModuleCode:newModuleCode];
	[module setCAPModuleGrade:newModuleGrade];
	[module setCAPModuleMC:newModuleMC];
	
	//check if semester already exists
	BOOL semesterExists = NO;
	for (int i = 0; i < [semesterObjects count]; i++) {
		
		Semester *currentSemester = [semesterObjects objectAtIndex:i];
		
		if ([[currentSemester semesterNumber] integerValue] == [newSemester integerValue]) {
			
			//add module to this semester
			[currentSemester addHasModuleObject:module];
			[module setBelongsToSemester:currentSemester];
			
			semesterExists = YES;
		}
	}
	
	if (!semesterExists) {
		
		//create new semester
		Semester *newSemesterModule = [NSEntityDescription insertNewObjectForEntityForName:@"Semester" inManagedObjectContext:managedObjectContext];
		[newSemesterModule setSemesterNumber:newSemester];
		[newSemesterModule addHasModuleObject:module];
		[module setBelongsToSemester:newSemesterModule];
	}
	
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }	
	
	//add object to moduleObjects
	[moduleObjects release];
	moduleObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CAPModule" withPredicate:nil]];
	
	//add object to semesterObjects
	[semesterObjects release];
	semesterObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"Semester" withPredicate:nil]];
	
	//update table
	[modulesTableView reloadData];
	[graphView reloadData];
	[self updateHeader];
}

- (void)removeModule:(CAPModule *)module ForSemester:(Semester *)semester {
	// MODIFIES:  core data and moduleObjects
	// REQUIRES: module should be in moduleObjects
	// EFFECTS:  removes module from system
	
	//check if semester is empty and delete if empty
	if ([[semester hasModule] count] == 1) {
		
		[managedObjectContext deleteObject:[module belongsToSemester]];
	}
	
	//remove object from coredata
	[managedObjectContext deleteObject:module];
	
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }		
	
	//remove object from moduleObjects
	[moduleObjects release];
	moduleObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CAPModule" withPredicate:nil]];
	
	//update semesterObjects
	[semesterObjects release];
	semesterObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"Semester" withPredicate:nil]];
	
	//update table
	[modulesTableView reloadData];
	[graphView reloadData];
	[self updateHeader];
}

- (IBAction)addNewModuleButtonPressed:(id)sender {
	
	
	//show popover
	if (![addModulePopover isPopoverVisible]) {
		
		CAPAddModuleViewController *addModuleVC = [[CAPAddModuleViewController alloc] init];
		[addModuleVC setDelegate:self];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addModuleVC];
		
		addModulePopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
		
		[addModulePopover setPopoverContentSize:CGSizeMake(kPopoverWidth, kPopoverHeight)];
		
		[addModulePopover presentPopoverFromRect:addModuleButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		//[addModulePopover presentPopoverFromBarButtonItem:addModuleButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		
		[addModuleVC release];
		[navigationController release];
	}
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}

- (void)updateModuleList {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	/*	//get module data from web
	 NSURL *gemModulesURL = [NSURL URLWithString:@"https://aces01.nus.edu.sg/cors/jsp/report/GEMInfoListing.jsp"];
	 NSURL *facultyModulesURL = [NSURL URLWithString:@"https://aces01.nus.edu.sg/cors/jsp/report/ModuleInfoListing.jsp"];
	 NSURL *singaporeStudiesModulesURL = [NSURL URLWithString:@"https://aces01.nus.edu.sg/cors/jsp/report/SSMInfoListing.jsp"];
	 NSURL *breadthModulesURL = [NSURL URLWithString:@"https://aces01.nus.edu.sg/cors/jsp/report/UEMInfoListing.jsp"];
	 NSURL *crossFacultyModulesURL = [NSURL URLWithString:@"https://aces01.nus.edu.sg/cors/jsp/report/CFMInfoListing.jsp"];
	 
	 NSArray *URLArray = [NSArray arrayWithObjects:gemModulesURL, facultyModulesURL, singaporeStudiesModulesURL, breadthModulesURL, crossFacultyModulesURL, nil];
	 
	 NSStringEncoding encoding;
	 
	 NSMutableArray *moduleListArray = [NSMutableArray array];
	 
	 for (int i = 0; i < [URLArray count]; i++) {
	 
	 NSString *source = [NSString stringWithContentsOfURL:[URLArray objectAtIndex:i] usedEncoding:&encoding error:NULL];
	 NSString *pattern = @"tr a";
	 
	 DocumentRoot* document = [Element parseHTML: source];
	 NSArray* elements = [document selectElements: pattern];
	 
	 for (Element* element in elements){
	 
	 NSString *moduleCode = [element contentsSource];
	 NSString *moduleName = [[[element nextElement] nextElement] contentsSource];
	 NSString *moduleMC = [[[[[element nextElement] nextElement] nextElement] nextElement] contentsSource];
	 
	 if (![moduleCode isEqual:@"Tutorial Time Table"]) {
	 //NSLog(@"Code: %@ Name: %@ MC: %@", moduleCode, moduleName, moduleMC);
	 
	 //first delete all previous stored modules
	 //[managedObjectContext deleteObject:ModuleList];
	 
	 //add modules and mcs to core data
	 ModuleList *newModule = [NSEntityDescription insertNewObjectForEntityForName:@"ModuleList" inManagedObjectContext:managedObjectContext];
	 [newModule setCode:moduleCode];
	 [newModule setName:moduleName];
	 [newModule setCredit:[NSNumber numberWithInt:[moduleMC intValue]]];
	 
	 NSError *error = nil;
	 if (managedObjectContext != nil) {
	 
	 if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
	 
	 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	 abort();
	 } 
	 }
	 
	 
	 //create an array out of the modules
	 NSDictionary *moduleInfos = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:moduleCode, moduleName, moduleMC, nil] forKeys:[NSArray arrayWithObjects:@"Code", @"Name", @"MC", nil]];
	 [moduleListArray addObject:moduleInfos];
	 }
	 }
	 }
	 
	 //write this array to file
	 NSString *error;
	 NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	 NSString *plistPath = [rootPath stringByAppendingPathComponent:@"ModuleList.plist"];
	 NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:moduleListArray
	 format:NSPropertyListXMLFormat_v1_0
	 errorDescription:&error];
	 if(moduleListArray) {
	 [plistData writeToFile:plistPath atomically:YES];
	 }
	 else {
	 NSLog(@"%@", error);
	 [error release];
	 }
	 */
	[pool release];
}

- (IBAction)refreshModuleList {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
													message:@"Refreshing module list will take sometime. You can continue using any other modules until the modules are refreshed" 
												   delegate:nil 
										  cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//start a new thread
	[NSThread detachNewThreadSelector:@selector(updateModuleList) toTarget:self withObject:nil];
}

- (void)updateHeader {
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 50, 50)];
	[headerLabel setTextAlignment:UITextAlignmentCenter];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerLabel.adjustsFontSizeToFitWidth = YES;
	
	if ([moduleObjects count] != 0) {
		
		headerLabel.text = [NSString stringWithFormat:@"CAP: %.2f", [self calculateCAP]];
		capLabel.text = [NSString stringWithFormat:@"%0.2f", [self calculateCAP]];
	}
	else {
		
		headerLabel.text = [NSString stringWithFormat:@"Add modules by clicking on the + button"];
		capLabel.text = @"Nothing lah!";
	}
	
	[modulesTableView setTableHeaderView:headerLabel];
	[headerLabel release];
}

- (IBAction)homeButtonPressed {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:[NSArray array]];
}

#pragma mark -
#pragma mark Popover delegates

- (void)userDidFinishAddingModule:(NSString *)aModule WithMC:(NSNumber *)anMC WithGrade:(NSString *)aGrade WithSemester:(NSNumber *)aSemester {
	
	[addModulePopover dismissPopoverAnimated:YES];
	addModulePopover = nil;
	[addModulePopover release];
	[self addModule:aModule WithMC:anMC WithGrade:aGrade WithSemester:aSemester];
}

#pragma mark -
#pragma mark CAP calculation functions

- (float)gradeInFloat:(NSString *)aGrade {
	
	if ([aGrade isEqual:@"A+"]) {
		return 5;
	}
	else if ([aGrade isEqual:@"A"]) {
		return 5;
	}
	else if ([aGrade isEqual:@"A-"]) {
		return 4.5;
	}
	else if ([aGrade isEqual:@"B+"]) {
		return 4;
	}
	else if ([aGrade isEqual:@"B"]) {
		return 3.5;
	}
	else if ([aGrade isEqual:@"B-"]) {
		return 3;
	}
	else if ([aGrade isEqual:@"C+"]) {
		return 2.5;
	}
	else if ([aGrade isEqual:@"C"]) {
		return 2;
	}
	else if ([aGrade isEqual:@"D+"]) {
		return 1.5;
	}
	else if ([aGrade isEqual:@"D"]) {
		return 1;
	}
	else if ([aGrade isEqual:@"F"]) {
		return 0;
	}
	
	return 0;
}

- (float)calculateCAP {
	// MODIFIES:  none
	// REQUIRES: moduleObjects != nil
	// EFFECTS:  returns CAP of all modules in moduleObjects
	
	float numerator = 0;
	float denominator = 0;
	
	//set values for CAP offset
	NSLog(@"%@ %@", [capOffset text], [numberOfMCsCompleted text]);
	if ([capOffset text] != @"" && [numberOfMCsCompleted text] != @"") {
		
		numerator = [[capOffset text] floatValue] * [[numberOfMCsCompleted text] floatValue];
		denominator = [[numberOfMCsCompleted text] floatValue];
	}
	
	for (int i = 0; i < [moduleObjects count]; i++) {
		
		CAPModule *currentModule = [moduleObjects objectAtIndex:i];
		NSString *gradeString = [currentModule CAPModuleGrade];
		float grade = [self gradeInFloat:gradeString];
		numerator += ([[currentModule CAPModuleMC] intValue]) * grade;
		if (![[currentModule CAPModuleGrade] isEqual:@"CS"] &&
			![[currentModule CAPModuleGrade] isEqual:@"CU"] &&
			![[currentModule CAPModuleGrade] isEqual:@"S"] &&
			![[currentModule CAPModuleGrade] isEqual:@"U"] &&
			![[currentModule CAPModuleGrade] isEqual:@"W"] &&
			![[currentModule CAPModuleGrade] isEqual:@"IP"] &&
			![[currentModule CAPModuleGrade] isEqual:@"IC"] &&
			![[currentModule CAPModuleGrade] isEqual:@"EXE"]) {
			
			denominator += ([[currentModule CAPModuleMC] intValue]);
		}
	}
	
	return numerator/denominator;
}

- (float)calculateSAPForSem:(int)semester {
	// MODIFIES:  none
	// REQUIRES: moduleObjects != nil
	// EFFECTS:  returns SAP of corresponding semester
	
	float numerator = 0;
	float denominator = 0;
	
	for (int i = 0; i < [moduleObjects count]; i++) {
		
		CAPModule *currentModule = [moduleObjects objectAtIndex:i];
		Semester *semesterOfCurrentModule = [currentModule belongsToSemester];
		
		if ([[semesterOfCurrentModule semesterNumber] integerValue] == semester) {
			
			numerator += [[currentModule CAPModuleMC] doubleValue] * [self gradeInFloat:[currentModule CAPModuleGrade]];
			if (![[currentModule CAPModuleGrade] isEqual:@"CS"] &&
				![[currentModule CAPModuleGrade] isEqual:@"CU"] &&
				![[currentModule CAPModuleGrade] isEqual:@"S"] &&
				![[currentModule CAPModuleGrade] isEqual:@"U"] &&
				![[currentModule CAPModuleGrade] isEqual:@"W"] &&
				![[currentModule CAPModuleGrade] isEqual:@"IP"] &&
				![[currentModule CAPModuleGrade] isEqual:@"IC"] &&
				![[currentModule CAPModuleGrade] isEqual:@"EXE"]) {
				
				denominator += ([[currentModule CAPModuleMC] intValue]);
			}
		}
	}
	
	return numerator/denominator;
}

#pragma mark -
#pragma mark Graphview data source

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	
	if ([semesterObjects count] != 0) {
		
		return 2;
	}
	return 2;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	
	//X values are semesters
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [semesterObjects count]; i++) {
		
		Semester *currentSemester = [semesterObjects objectAtIndex:i];
		[temp addObject:[currentSemester semesterNumber]];
	}
	
	NSArray *semesters = [NSArray arrayWithArray:temp];
	[temp release];
	
	return semesters;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	
	//Y values are SAP values
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	
	switch (plotIndex) {
		case 0:
		{
			for (int i = 0; i < [semesterObjects count]; i++) {
				
				int currentSemester = [[[semesterObjects objectAtIndex:i] semesterNumber] intValue];
				[temp addObject:[NSNumber numberWithFloat:[self calculateSAPForSem:currentSemester]]];
			}
			
			break;
		}
		case 1:
		{
			for (int i = 0; i < [semesterObjects count]; i++) {
				
				[temp addObject:[NSNumber numberWithFloat:[self calculateCAP]]];
			}
			
			break;
		}
		default:
			break;
	}
	
	NSArray *semesterSAP = [NSArray arrayWithArray:temp];
	
	[temp release];
	
	return semesterSAP;
}

#pragma mark -
#pragma mark modulesTableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [semesterObjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[semesterObjects objectAtIndex:section] hasModule] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ModuleTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell
	
	NSSet *setOfModules = [[semesterObjects objectAtIndex:indexPath.section] hasModule];
	
	CAPModule *currentModule = [[setOfModules allObjects] objectAtIndex:indexPath.row];
	
	[[cell textLabel] setText:[currentModule CAPModuleCode]];
	[[cell detailTextLabel] setText:[NSString stringWithFormat:@"Grade: %@ MC: %d", [currentModule CAPModuleGrade], [[currentModule CAPModuleMC] integerValue]]];
	
	//[cell setBackgroundColor:[UIColor clearColor]];
	//[[cell textLabel] setTextColor:[UIColor whiteColor]];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		Semester *currentSemester = [semesterObjects objectAtIndex:indexPath.section];
		CAPModule *moduleForCurrentSemester = [[[currentSemester hasModule] allObjects] objectAtIndex:indexPath.row];
		[self removeModule:moduleForCurrentSemester ForSemester:currentSemester];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	Semester *currentSemester = [semesterObjects objectAtIndex:section];
	
	return [NSString stringWithFormat:@"Semester %d SAP: %0.2f", [[currentSemester semesterNumber] intValue], [self calculateSAPForSem:[[currentSemester semesterNumber] intValue]]];
}

#pragma mark -
#pragma mark modulesTableView delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//deselect cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
 {
 UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
 if (section == 0)
 [headerView setBackgroundColor:[UIColor redColor]];
 else 
 [headerView setBackgroundColor:[UIColor clearColor]];
 return headerView;
 }
 */

#pragma mark -
#pragma mark Misc

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self updateHeader];
    // intialize moduleObjects
    ivleInterface = [IVLE instance];
    managedObjectContext = [[[ModulesFetcher sharedInstance] managedObjectContext] retain];
    moduleObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"CAPModule" withPredicate:nil]];
    semesterObjects = [[NSMutableArray alloc] initWithArray:[[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"Semester" withPredicate:nil]];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //add graph
    graphRect = CGRectMake(kGraphViewX, kGraphViewY, kGraphViewWidth, kGraphViewHeight);
    graphView = [[S7GraphView alloc] initWithFrame:graphRect];
    [graphView setDataSource:self];
    
    graphView.backgroundColor = [UIColor clearColor];
    
    graphView.drawAxisX = YES;
    graphView.drawAxisY = YES;
    graphView.drawGridX = YES;
    graphView.drawGridY = YES;
    
    graphView.xValuesColor = [UIColor blackColor];
    graphView.yValuesColor = [UIColor blackColor];
    
    graphView.gridXColor = [UIColor blackColor];
    graphView.gridYColor = [UIColor blackColor];
    
    graphView.drawInfo = YES;
    graphView.info = @"SAP Graph";
    graphView.infoColor = [UIColor blackColor];
    
    //clear color added by SJ
    SAPGraphView.backgroundColor = [UIColor clearColor];
    [SAPGraphView addSubview:graphView];
    
    //modulesTableView.backgroundView = nil;
    [modulesTableView setBackgroundView:nil];
    
    modulesTableView.backgroundColor = [UIColor clearColor];
    
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:[self retain] action:@selector(addNewModuleButtonPressed:)];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
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
	[moduleObjects release];
	[semesterObjects release];
	//[addModulePopover release];
	[managedObjectContext release];
	[buttonsArray release];
	
    [super dealloc];
}

@end
