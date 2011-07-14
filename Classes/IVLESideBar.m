//
//  IVLESideBar.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLESideBar.h"

@interface IVLESideBar (PrivateMethods)

-(NSArray*)determineActiveLinksForModule:(NSString*)courseID;

@end

@implementation IVLESideBar
#define HEADER_HEIGHT 50.0
#define ROW_HEIGHT 80.0
#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kNotificationSetPageTitle @"setPageTitle"
#define kCourseID @"aefeaca4-f40a-4c82-9c8e-95f92c7ed0da"
#define kMediaID @"b3bdb994-ee7c-4784-bf09-3aa4d6bb656f"
#define kWebcastLink @"http://coursecast3.nus.edu.sg/Panopto/Content/Sessions/513ee01f-1fe0-4169-a120-2640eb2879b3/6788f2a7-9ea1-41a3-9f58-ae9f5850b37a-9f189653-b17e-4786-8cc3-e02a059c9899.mp4"

static IVLESideBar *sharedSingleton;
//@synthesize moduleList;

NSMutableArray* moduleStrings;
NSMutableArray* moduleActiveLinks;
NSMutableArray* moduleHeaderInfoArray;
NSDictionary *moduleActiveLinksAssociation;
NSDictionary *moduleActiveLinksImageAssociation;
NSInteger openSectionIndex;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


+ (void)clear
{
	
	[moduleStrings release];
//	[moduleHeaderInfoArray release];
	[moduleActiveLinksAssociation release];
	sharedSingleton = NULL;
	moduleHeaderInfoArray = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	
	@synchronized(self)
    {
		if (sharedSingleton == NULL) {
			sharedSingleton = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		}
    }
	
	return sharedSingleton;
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	IVLE *ivle = [IVLE instance];
	
	openSectionIndex = -1;
	
	moduleStrings = [[[NSMutableArray alloc] init] retain];
	
	NSDictionary *moduleDict = [ivle modules:0 withAllInfo:NO];
	
		//NSLog(@"%@", moduleDict);
	int i;
	for (i=0; i<[[moduleDict valueForKey:@"Results"] count]; i++) {
		NSArray *module = [[moduleDict valueForKey:@"Results"] objectAtIndex:i];
		if (![[module valueForKey:@"ID"] isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
			[moduleStrings addObject:[[moduleDict valueForKey:@"Results"] objectAtIndex:i]] ;
		}
	}
	
	if (moduleHeaderInfoArray == nil) {
		
		moduleHeaderInfoArray = [[[NSMutableArray alloc] init] retain];
		moduleActiveLinks = [[[NSMutableArray alloc] init] retain];

		for(NSArray *module in moduleStrings) {
			
			ModuleHeaderInfo *moduleHeaderInfo = [[ModuleHeaderInfo alloc] init];
			moduleHeaderInfo.open = NO;
			moduleHeaderInfo.moduleName = [module valueForKey:@"CourseCode"];
			moduleHeaderInfo.moduleID = [module valueForKey:@"ID"];
			[moduleHeaderInfoArray addObject:moduleHeaderInfo];
			[moduleHeaderInfo release];
			
            NSArray *links = [[self determineActiveLinksForModule:[module valueForKey:@"ID"]] retain];
			[moduleActiveLinks addObject:links];
            [links release];

		}
	}
	
	
	moduleActiveLinksAssociation = [[[NSDictionary alloc] initWithObjectsAndKeys: @"ModulesInfo",@"Information",
                                                                                  @"ModulesAnnouncements",@"Announcements",
                                                                                  @"ForumViewController",@"Forum",
                                                                                  @"ModulesWorkbin",@"Workbin",
                                                                                  @"WebcastController",@"Webcasts",
                                                                                  @"GradebookController", @"Gradebook",nil] retain];
    
	moduleActiveLinksImageAssociation =[[[NSDictionary alloc] initWithObjectsAndKeys: @"information.png",@"Information",
                                                                                      @"announcements.png",@"Announcements",
                                                                                      @"forum.png",@"Forum",
                                                                                      @"workbin.png",@"Workbin",
                                                                                      @"webcasts.png",@"Webcasts",
                                                                                      @"gradebook.png",@"Gradebook",nil] retain];

	UIImage *backgroundImage = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
	moduleList.backgroundColor = [UIColor clearColor];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [moduleStrings count];
}

-(NSArray*)determineActiveLinksForModule:(NSString*)courseID {
    
    IVLE *ivle = [IVLE instance];
    NSMutableArray *activeLinks = [[[NSMutableArray alloc] init] autorelease];
    
    //check for information
    
    NSArray* courseInfo = [[ivle moduleInfo:courseID withDuration:0] valueForKey:@"Results"];
    if ([courseInfo count] > 0) {
        [activeLinks addObject:@"Information"];
    }
    
    //check for announcements
    
    NSArray* announcements = [[ivle announcements:courseID withDuration:0 withTitle:NO] valueForKey:@"Results"];
    if ([announcements count] > 0) {
        [activeLinks addObject:@"Announcements"];
    }
    
    //check for forum
    
    NSDictionary* forums = [ivle forums:courseID withDuration:0 withThreads:NO withTitle:NO];
    if ([forums count] > 0) {
        [activeLinks addObject:@"Forum"];
    }
    
    //check for workbin
    
    NSDictionary* workbin = [ivle workbin:courseID withDuration:0 withWorkbinID:nil withTitle:NO];
    if ([workbin count] > 0) {
        [activeLinks addObject:@"Workbin"];
    }
    
    //check for webcasts
    
    NSDictionary* webcasts = [[ivle webcasts:courseID withDuration:0 withTitleOnly:YES] objectForKey:@"Results"];
    if ([webcasts count] > 0) {
        [activeLinks addObject:@"Webcasts"];
    }
    
    //check for gradebook
    
    NSDictionary* gradebook = [[ivle gradebookViewItems:courseID] objectForKey:@"Results"];
    if ([gradebook count] > 0) {
        [activeLinks addObject:@"Gradebook"];
    }
    
    return activeLinks;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return ROW_HEIGHT;
	
}
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
	ModuleHeaderInfo *moduleHeaderInfo = [moduleHeaderInfoArray objectAtIndex:section];
	if (!moduleHeaderInfo.headerView) {
		
		moduleHeaderInfo.headerView = [[[ModuleHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, moduleList.bounds.size.width, HEADER_HEIGHT) title:moduleHeaderInfo.moduleName module:section delegate:self] autorelease];
		
	}
	return moduleHeaderInfo.headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	//NSLog(@"%d", section);
	NSInteger numOfActiveLinksInModule = ceil([[moduleActiveLinks objectAtIndex:section] count]/2.0);
	ModuleHeaderInfo *moduleHeaderInfo =  [moduleHeaderInfoArray objectAtIndex:section];
	return moduleHeaderInfo.open ? numOfActiveLinksInModule : 0;
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	
	return HEADER_HEIGHT;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	MyIdentifier = @"tableCellView";
	
	LeftSideBarCellView *cell = (LeftSideBarCellView *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
		cell = tableCell;
	}
	
	
	int rowNumber = indexPath.row;
	int linkCount = [[moduleActiveLinks objectAtIndex:indexPath.section] count];
	
	if ((rowNumber == (ceil(linkCount/2.0)-1)) && (linkCount%2 == 1)) {
		
		[cell setLabelTextLeft:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2)]];
		UIButton *leftButton = [cell getCellButtonLeft];
		leftButton.tag = indexPath.section*10+(rowNumber*2);
		[leftButton addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		UIImage *leftButtonImage =[UIImage imageNamed:[moduleActiveLinksImageAssociation objectForKey:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2)]]];
		[leftButton setImage:leftButtonImage forState:UIControlStateNormal];
		
		[cell removeLabelRight];
		[cell removeButtonRight];
	}
	else {
		[cell setLabelTextLeft:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2)]];
		[cell setLabelTextRight:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2+1)]];
		
		
		UIButton *leftButton = [cell getCellButtonLeft];
		UIButton *rightButton = [cell getCellButtonRight];
		
		leftButton.tag = indexPath.section*10+(rowNumber*2);
		rightButton.tag	 = indexPath.section*10+(rowNumber*2+1);
		
		[leftButton addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[rightButton addTarget:[self retain] action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		UIImage *leftButtonImage =[UIImage imageNamed:[moduleActiveLinksImageAssociation objectForKey:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2)]]];
		UIImage *rightButtonImage = [UIImage imageNamed:[moduleActiveLinksImageAssociation objectForKey:[[moduleActiveLinks objectAtIndex:indexPath.section] objectAtIndex:(rowNumber*2+1)]]];
		
		[leftButton setImage:leftButtonImage forState:UIControlStateNormal];
		[rightButton setImage:rightButtonImage forState:UIControlStateNormal];
		
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
	
}


- (void)btnClicked:(id)sender{
	UIButton *button = (UIButton*)sender;
	
	NSInteger tag = button.tag;
	
	NSInteger sectionNumber = tag/10;
	NSInteger linkNumber = tag%10;

	NSString *nibName = [moduleActiveLinksAssociation objectForKey:[[moduleActiveLinks objectAtIndex:sectionNumber] objectAtIndex:linkNumber]];
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(1024/2-spinner.frame.size.width/2, 768/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview] addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	
	NSArray *leftBar;
	if ([nibName compare:@"ModulesInfo"] == NSOrderedSame) {
        ModulesInfo *info = [[ModulesInfo alloc] initWithNibName:nibName bundle:nil];
		leftBar = [NSArray arrayWithObject:info];
        [info release];
        
	}
	
	else if ([nibName compare:@"ModulesAnnouncements"] == NSOrderedSame) {
		
        ModulesAnnouncements *announcements = [[ModulesAnnouncements alloc] initWithNibName:nibName bundle:nil]; 
		leftBar = [NSArray arrayWithObject:announcements];
        [announcements release];
	}
	
	else if ([nibName compare:@"ForumViewController"] == NSOrderedSame) {
        
		ForumViewController *fvc = [[ForumViewController alloc] initWithNibName:nibName bundle:nil];
		leftBar = [NSArray arrayWithObject:fvc];
        [fvc release];
	}
	
	else if ([nibName compare:@"ModulesWorkbin"] == NSOrderedSame) {
		
        ModulesWorkbin *workbin = [[ModulesWorkbin alloc] initWithNibName:nibName bundle:nil];
		leftBar = [NSArray arrayWithObject:workbin];	
        [workbin release];           
	}
	
	else if ([nibName compare:@"GradebookController"] == NSOrderedSame) {
		
		GradeBookController *gradeBook = [[GradeBookController alloc] initWithNibName:nibName bundle:nil];
		leftBar = [NSArray arrayWithObject:gradeBook];
		[gradeBook release];
	}
    
    else if ([nibName compare:@"WebcastController"] == NSOrderedSame) {
		
		WebcastController *webcast = [[WebcastController alloc] initWithNibName:nibName bundle:nil];
		leftBar = [NSArray arrayWithObject:webcast];
		[webcast release];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshRightScreen object:leftBar];
	[spinner removeFromSuperview];
	self.view.userInteractionEnabled = YES;

	[spinner release];
	
}

-(void)moduleHeader:(ModuleHeader*)sectionHeaderView moduleOpened:(NSInteger)sectionOpened {
	
	
	ModuleHeaderInfo *moduleHeaderInfo = [moduleHeaderInfoArray objectAtIndex:sectionOpened];
	moduleHeaderInfo.open = YES;
	[IVLE instance].selectedCourseID = moduleHeaderInfo.moduleID;
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = ceil([[moduleActiveLinks objectAtIndex:sectionOpened] count]/2.0);
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
		
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
	
	
	
    NSInteger previousOpenHeaderIndex = openSectionIndex;
    if (previousOpenHeaderIndex != -1) {
		
		ModuleHeaderInfo *previousOpenHeader = [moduleHeaderInfoArray objectAtIndex:previousOpenHeaderIndex];
        previousOpenHeader.open = NO;
		[previousOpenHeader.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = ceil([[moduleActiveLinks objectAtIndex:previousOpenHeaderIndex] count]/2.0);
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenHeaderIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenHeaderIndex == -1 || sectionOpened < previousOpenHeaderIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [moduleList beginUpdates];
    [moduleList deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [moduleList insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [moduleList endUpdates];
    openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
}

-(void)moduleHeader:(ModuleHeader*)sectionHeaderView moduleClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	ModuleHeaderInfo *moduleHeaderInfo = [moduleHeaderInfoArray objectAtIndex:sectionClosed];
	moduleHeaderInfo.open = NO;
	
	
	NSInteger countOfRowsToDelete = ceil([[moduleActiveLinks objectAtIndex:sectionClosed] count]/2.0);
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [moduleList deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    openSectionIndex = -1;
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;//interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
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
	NSLog(@"dealloc sidebar %@", self);
	[moduleStrings release];
	[moduleHeaderInfoArray release];
	[moduleActiveLinksAssociation release];
    [super dealloc];

	
}


@end
