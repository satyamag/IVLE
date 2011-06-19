//
//  ForumTableViewController.m
//  IVLE
//
//  Created by QIN HUAJUN on 3/28/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumTableViewController.h"


@implementation ForumTableViewController

@synthesize tableDataSource, CurrentTitle, CurrentLevel, displayContent, delegate;

#pragma mark -
#pragma mark help methods

- (NSArray *)getSubThreadsForMainThreads:(NSString *)threadID {
	
	NSArray *thisThread = [[ivleInterface forumThreads:threadID withDuration:0 withThreads:YES] objectForKey:@"Results"];
	//NSLog(@"%@",thisThread);
	NSArray *subThreads = [[thisThread objectAtIndex:0] objectForKey:@"Threads"];
	
	return subThreads;
}

- (NSArray *)getMainThreadsForHeading:(NSString *)headingID {
	
	NSArray *headingMainThreads = [[ivleInterface forumHeadingMainThreads:headingID withDuration:0] objectForKey:@"Results"];
	//NSLog(@"ffffffffff %@", headingMainThreads);
	return headingMainThreads;
}

- (NSArray *)getHeadingsForForum:(NSString *)forumID {
	NSAssert(0, @"Broken by SJ");
	NSDictionary *forum = [ivleInterface forum:nil withDuration:0 withThreads:NO];
	NSArray *forumResults = [forum objectForKey:@"Results"];
	NSDictionary *currentForum = [forumResults objectAtIndex:0];
	NSArray *headings = [currentForum objectForKey:@"Headings"];
	
	return headings;
}

- (NSArray *)getForumsForModule:(NSString *)courseID {
	
	NSDictionary *forums = [ivleInterface forums:courseID withDuration:0 withThreads:NO withTitle:NO];
	NSArray *forumsResults = [forums objectForKey:@"Results"];
	
	return forumsResults;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	ivleInterface = [[IVLE instance] retain];
	
	self.view.backgroundColor = [UIColor clearColor];
	//self.tableView.backgroundView = nil;
	self.tableView.backgroundColor = [UIColor clearColor]; 
	
	if(CurrentLevel == 0) {
		
		//Initialize table data source
		tableDataSource = [[NSArray alloc] init];
		CurrentTitle = [[NSString alloc] init];
		
		self.tableDataSource = [self getForumsForModule:[IVLE instance].selectedCourseID];
		
		self.title = @"Forums";
	}
	else if (CurrentLevel == 2)
		self.title = CurrentTitle;	
	
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
    return NO;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"ForumTableView";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (CurrentLevel >= 2) {
			//construct different cell structure for display
			//cell = [self constructCellForPost:CellIdentifier];
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		else
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	
	NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	
	if (CurrentLevel == 0 || CurrentLevel == 1) {
		//level 0: forum
		//level 1: headings
		cell.textLabel.text = [dictionary objectForKey:@"Title"];
	}
	else {
		cell.textLabel.text = [dictionary objectForKey:@"PostTitle"];
		NSString *detailText = [[dictionary objectForKey:@"Poster"] objectForKey:@"Name"];
		cell.detailTextLabel.text = detailText;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
	}
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	
	if (CurrentLevel > 2) {
		if ([[dictionary objectForKey:@"Threads"] count] != 0) 
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else if (CurrentLevel == 2){
		if ([[self getSubThreadsForMainThreads:[dictionary objectForKey:@"ID"]] count] != 0)
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}

	
	cell.backgroundColor = [UIColor clearColor];

    return cell;	
}

- (UIActivityIndicatorView *) createSpinner {
	
	CGSize superviewFrameSize = [[self.view superview] frame].size;
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(superviewFrameSize.width/2, superviewFrameSize.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview]  addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	return spinner;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//activity spinner
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	
	//deselect row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Get the dictionary of the selected data source.
	NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	
	NSArray *Children;
	//NSMutableArray *subthreads;
	
	//Get the children of the present item.
	if (CurrentLevel == 0) {
		Children = [dictionary objectForKey:@"Headings"];
	}
	else if (CurrentLevel == 1) {
		Children = [self getMainThreadsForHeading:[dictionary objectForKey:@"ID"]];
	}
	else if (CurrentLevel == 2) {
		//NSLog(@"The ID for current thread: %@",[dictionary objectForKey:@"ID"]);
		Children = [self getSubThreadsForMainThreads:[dictionary objectForKey:@"ID"]];
	}
	else {
		Children = [dictionary objectForKey:@"Threads"];
	}
	

	if([Children count] == 0) {
		/*
		 DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
		 [self.navigationController pushViewController:dvController animated:YES];
		 [dvController release];
		 */
	}
	else {

		//Prepare to tableview.
		ForumTableViewController *newForumTable = [[ForumTableViewController alloc] init];
		
		//set the new tableview delegate as the forum controller view
		[newForumTable setDelegate:self.delegate];
		
		//Increment the Current View
		newForumTable.CurrentLevel = self.CurrentLevel + 1;
		
		//Set the title;
		newForumTable.CurrentTitle = [dictionary objectForKey:@"Title"];
		
		//Push the new table view on the stack
		[self.navigationController pushViewController:newForumTable animated:YES];
		
		newForumTable.tableDataSource = Children;
		
		[newForumTable release];
	}	
	
	[spinner removeFromSuperview];
	[spinner release];
	self.view.userInteractionEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//deselect row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Get the dictionary of the selected data source.
	NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	
	//update the display content by delegate
	if(CurrentLevel > 1){		
		displayContent = [dictionary objectForKey:@"PostBody"];
		[[self delegate] updateThreadContent:displayContent];
	}
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

