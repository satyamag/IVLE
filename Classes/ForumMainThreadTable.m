//
//  ForumMainThreadTable.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumMainThreadTable.h"


@implementation ForumMainThreadTable

@synthesize tableDataSource, cells, currentLevel, currentTitle, headingNames, headingIDs, delegate, currentHeading, selectedCell;

#pragma mark -
#pragma mark help methods

- (NSArray *)getSubThreadsForMainThreads:(NSString *)threadID {
	
	NSArray *thisThread = [[[IVLE instance] forumThreads:threadID withDuration:0 withThreads:YES] objectForKey:@"Results"];
	NSLog(@"-----getting sub threads for main thread 1, this should display the main thread target %@",thisThread);
	NSArray *subThreads = [[thisThread objectAtIndex:0] objectForKey:@"Threads"];
	NSLog(@"-----getting sub threads for main thread 2, this should display the sub threads %@",subThreads);
	
	return subThreads;
}

- (NSArray *)getMainThreadsForHeading:(NSString *)headingID {
	
	NSArray *headingMainThreads = [[[IVLE instance] forumHeadingMainThreads:headingID withDuration:0 withMainTopics:YES] objectForKey:@"Results"];
	NSLog(@"-----getting main threads for heading %@", headingMainThreads);
	return headingMainThreads;
}

- (NSArray *)getHeadingsForForum:(NSString *)forumID {

	/*
	NSLog(@"getting headings %@",[[IVLE instance] forum:nil withDuration:0 withThreads:NO]);
	
	NSDictionary *forum = [[IVLE instance] forum:nil withDuration:0 withThreads:NO];
	NSArray *forumResults = [forum objectForKey:@"Results"];
	NSDictionary *currentForum = [forumResults objectAtIndex:0];
	NSArray *headings = [currentForum objectForKey:@"Headings"];
	
	return headings;
	 */
	NSLog(@"-----getting forumHeadings %@",[[IVLE instance] forumHeadings:forumID withDuration:0 withThreads:NO]);
	
	NSDictionary *forumHeadings = [[IVLE instance] forumHeadings:forumID withDuration:0 withThreads:NO];
	NSArray *result = [forumHeadings objectForKey:@"Results"];
	return result;
	
}

- (NSArray *)getForumsForModule:(NSString *)courseID {

	NSLog(@"-----getting forums %@",[[IVLE instance] forums:courseID withDuration:0 withThreads:NO withTitle:NO]);
	
	NSDictionary *forums = [[IVLE instance] forums:courseID withDuration:0 withThreads:NO withTitle:NO];
	NSArray *forumsResults = [forums objectForKey:@"Results"];	
	return forumsResults;
}

//-(void) prepareCellsForMainSubThreads{
//    
//    NSArray *posts = self.tableDataSource;
//    NSEnumerator *e = [posts objectEnumerator];
//    NSDictionary *cellInformation;
//    while ((cellInformation = (NSDictionary*)[e nextObject])) {
//        
//       
//        
//    }
//    
//}

-(NSString*) getHeadingName{
    return currentHeading;
}

- (void)postNewThread{
	
	NSLog(@"post new threads here");
	ForumPostNew *postWindow = [[ForumPostNew alloc] initWithNibName:@"ForumPostNew" bundle:nil];
	[postWindow setDelegate:self];
	NSLog(@"test headingnames: %@",self.headingNames);
    
    postWindow.heading.text = [NSString stringWithString:self.currentHeading];
	postWindow.headingList = self.headingNames;
	
	UINavigationController *navi = [[UINavigationController alloc] init];
	[navi pushViewController:postWindow animated:NO];
	[postWindow release];
	
	navi.wantsFullScreenLayout = YES;
	navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	navi.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:navi animated:NO];
	
}

-(void)postNewThreadWithHeading:(NSString *)headingName title:(NSString *)titleName body:(NSString *)postBody{

	NSLog(@"start posting threads to the server");
	NSString *headingID;
	for(int k=0; k<[self.headingNames count]; k++){
		if ([[self.headingNames objectAtIndex:k] isEqualToString:headingName]) {
			headingID = [headingIDs objectAtIndex:k];
		}
	}
	
	NSLog(@"got heading id already");
	NSLog(@"%@", self.headingIDs);
	NSLog(@"heading ID is: %@",headingID);
	
	if (headingID != nil) {
		[[IVLE instance] forumPostNewThread:headingID withTitle:titleName withReply:postBody];
	}
	else {
		NSLog(@"Heading ID not found for heading: %@", headingName);
	}

	
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bgImage_forumMainTable = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_forumMainTable];
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:bgImage_forumMainTable];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	if (currentLevel == 0) {
		
		tableDataSource = [[NSArray alloc] init];
		cells = [[NSMutableArray alloc] init];
		currentTitle = [[NSString alloc] init];
		
		self.title = @"Forums";
        
		//initialize table data source
		tableDataSource = [[self getForumsForModule:[IVLE instance].selectedCourseID] retain];
        
	}
	else if (currentLevel == 2) {
		self.title = currentTitle;
        currentHeading = [NSString stringWithString:currentTitle];
        
        [self.delegate clearSubThreadView];
	}
    
//    else if(currentLevel > 2) {
//        [self.delegate clearSubThreadView];
//    }
	
	if (currentLevel > 1) {
		
		//add a "post" button in the navigation view controller
//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:[self retain] action:@selector(postNewThread)];
//        
//        // change the back button and add an event handler
//        self.navigationItem.leftBarButtonItem =
//        [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                         style:UIBarButtonItemStyleBordered
//                                        target:self
//                                        action:@selector(handleBack:)];
    }
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.tableView addGestureRecognizer:rightSwipeGesture];
    [self.tableView addGestureRecognizer:leftSwipeGesture];
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

-(void)didSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    
    
    if (currentLevel == 3) {
        [self.delegate clearSubThreadView];
        [self.delegate clearContentView];
    }
    
    [self.view removeFromSuperview];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)didSwipeLeft:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    
    
    
    
    
	//activity spinner
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	
	NSLog(@"print data source");
	//NSLog(@"%@",self.tableDataSource);
	//NSLog(@"%@", indexPath.row);
	NSLog(@"data at row indexpath %@",[self.tableDataSource objectAtIndex:indexPath.row]);
	//NSLog(@"now test sub threads");
	//NSLog(@"%@",[self getSubThreadsForMainThreads:@"2f74c3d3-e112-4dd0-8160-901cfab60558"]);
	
	NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	NSArray *children; //for the next level tableDataSource
	
	if (currentLevel == 0 || currentLevel == 1) {
		//no need to display content, but update the main thread table view
		
		//get the children of the present item
		if (currentLevel == 0) {
			children = [dictionary objectForKey:@"Headings"];
			
			headingNames = [[NSMutableArray alloc] init];
			headingIDs = [[NSMutableArray alloc] init];
            
			//record heading names
			for(int j=0; j<[children count];j++){
                
				[headingNames addObject:[[children objectAtIndex:j] objectForKey:@"Title"]];
				[headingIDs addObject:[[children objectAtIndex:j] objectForKey:@"ID"]];
			}
			NSLog(@"Names: %@ and IDs: %@", self.headingNames, self.headingIDs);
		}
		else if (currentLevel == 1) {
			children = [self getMainThreadsForHeading:[dictionary objectForKey:@"ID"]];
		}
		
		//push a new table view to main thread table view window
		if ([children count] != 0) {
			

			//prepare to push in new main thread table view
			ForumMainThreadTable *newForumTable = [[ForumMainThreadTable alloc] init];
			
			//set the new tableview delegate as the forum class
			[newForumTable setDelegate:self.delegate];
			
			//increment the current level
			newForumTable.currentLevel = self.currentLevel + 1;
			
			//set the title
			newForumTable.currentTitle = [dictionary objectForKey:@"Title"];
			
			//set the headingNames
			newForumTable.headingNames = self.headingNames;
			newForumTable.headingIDs = self.headingIDs;
			newForumTable.tableDataSource = children;
            
			//push the new table view on the stack of the navigation controller
            [[self delegate] updateMainThreadTableView:newForumTable];
			//[self.navigationController pushViewController:newForumTable animated:YES];
			
			//update the data source
			
			
			//[newForumTable release];
		}
		else {
			
			NSLog(@"No headings or main threads!");
		}
        
        
	}
	else {
        
        if (selectedCell) {
            selectedCell.titleText.textColor = kWorkbinFontColor;
            selectedCell.metaText.textColor = kWorkbinFontColor;
        }
        selectedCell = (ForumTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        selectedCell.titleText.textColor = kWorkbinFontCompColor;
        selectedCell.metaText.textColor = kWorkbinFontCompColor;
        
		//update the content display view
		UIWebView *content = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"PostBody"];
		[[self delegate] displayThreadContent:content];
		
		//update the subthread table view
		if (currentLevel == 2) {
			children = [self getSubThreadsForMainThreads:[dictionary objectForKey:@"ID"]];
		}
		else {
			children = [dictionary objectForKey:@"Threads"];
		}
		
		if ([children count] != 0) {
			
			//call delegate to update sub thread table
            [[self delegate] clearSubThreadView];
			[[self delegate] updateSubThreadTableView:children andPreviousTable:nil];
            
		}
		else {
			NSLog(@"No more sub threads!");
            [[self delegate] clearSubThreadView];
			[[self delegate] updateSubThreadTableView:nil andPreviousTable:nil];
		} 
        
	}
	
	[spinner removeFromSuperview];
	[spinner release];
	self.view.userInteractionEnabled = YES;}



- (void) handleBack:(id)sender
{
    // do your custom handler code here
    
    // make sure you do this!
    // pop the controller

    if (currentLevel == 3) {
        [self.delegate clearSubThreadView];
        [self.delegate clearContentView];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableDataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (currentLevel == 0 || currentLevel == 1) {
		//level 0: forums
		//level 1: headings
		
        ForumTableCell *cell;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumTableCell" 
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
		
		// Configure the cell...
		NSDictionary *info = [self.tableDataSource objectAtIndex:indexPath.row];		
		
		cell.titleText.text = [info objectForKey:@"Title"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
		
	}
	else {
        
        ForumTableCell *cell;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumTableCell" 
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
		
		// Configure the cell...
		NSDictionary *info = [self.tableDataSource objectAtIndex:indexPath.row];
		
		cell.titleText.text = [info objectForKey:@"PostTitle"];
        
        NSRange range = NSMakeRange (6, 10);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[info objectForKey:@"PostDate"] substringWithRange:range] intValue]];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateStyle:kCFDateFormatterMediumStyle];
        
        cell.metaText.text = [NSString stringWithFormat:@"%@, %@", [[[info objectForKey:@"Poster"] objectForKey:@"Name"] capitalizedString], [formatter stringFromDate:date]];
        
        if ([[info objectForKey:@"isPosterStaff"] intValue] == 1) {
            cell.staffIndicator.image = [UIImage imageNamed:@"teacher.png"];
        }
        
        if ([[info objectForKey:@"isRead"] intValue] == 0) {
            cell.readIndicator.image = [UIImage imageNamed:@"new.png"];
        }
        
		cell.backgroundColor = [UIColor clearColor];
        [self.cells addObject:cell];
//        [cells addObject:[self.tableDataSource objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
		//return [self.cells objectAtIndex:[indexPath row]];
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        return 50.0;
        //    return 56.0;
    }
	return 50.0;

}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    
	//activity spinner
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	
	NSLog(@"print data source");
	//NSLog(@"%@",self.tableDataSource);
	//NSLog(@"%@", indexPath.row);
	NSLog(@"data at row indexpath %@",[self.tableDataSource objectAtIndex:indexPath.row]);
	//NSLog(@"now test sub threads");
	//NSLog(@"%@",[self getSubThreadsForMainThreads:@"2f74c3d3-e112-4dd0-8160-901cfab60558"]);
	
	NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	NSArray *children; //for the next level tableDataSource
	
	if (currentLevel == 0 || currentLevel == 1) {
		//no need to display content, but update the main thread table view
		
		//get the children of the present item
		if (currentLevel == 0) {
			children = [dictionary objectForKey:@"Headings"];
			
			headingNames = [[NSMutableArray alloc] init];
			headingIDs = [[NSMutableArray alloc] init];

			//record heading names
			for(int j=0; j<[children count];j++){

				[headingNames addObject:[[children objectAtIndex:j] objectForKey:@"Title"]];
				[headingIDs addObject:[[children objectAtIndex:j] objectForKey:@"ID"]];
			}
			NSLog(@"Names: %@ and IDs: %@", self.headingNames, self.headingIDs);
		}
		else if (currentLevel == 1) {
			children = [self getMainThreadsForHeading:[dictionary objectForKey:@"ID"]];
		}
		
		//push a new table view to main thread table view window
		if ([children count] != 0) {
			
			//prepare to push in new main thread table view
			ForumMainThreadTable *newForumTable = [[ForumMainThreadTable alloc] init];
			
			//set the new tableview delegate as the forum class
			[newForumTable setDelegate:self.delegate];
			
			//increment the current level
			newForumTable.currentLevel = self.currentLevel + 1;
			
			//set the title
//			newForumTable.currentTitle = [dictionary objectForKey:@"Title"];
			
			//set the headingNames
			newForumTable.headingNames = self.headingNames;
			newForumTable.headingIDs = self.headingIDs;
			
			//push the new table view on the stack of the navigation controller
            [[self delegate] updateMainThreadTableView:newForumTable];
//			[self.navigationController pushViewController:newForumTable animated:YES];
			
			//update the data source
			newForumTable.tableDataSource = children;
			
//			[newForumTable release];
		}
		else {
			
			NSLog(@"No headings or main threads!");
		}


	}
	else {
        
        if (selectedCell) {
            selectedCell.titleText.textColor = kWorkbinFontColor;
            selectedCell.metaText.textColor = kWorkbinFontColor;
        }
        selectedCell = (ForumTableCell*)[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.titleText.textColor = kWorkbinFontCompColor;
        selectedCell.metaText.textColor = kWorkbinFontCompColor;
        
		//update the content display view
		UIWebView *content = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"PostBody"];
		[[self delegate] displayThreadContent:content];
		
		//update the subthread table view
		if (currentLevel == 2) {
			children = [self getSubThreadsForMainThreads:[dictionary objectForKey:@"ID"]];
		}
		else {
			children = [dictionary objectForKey:@"Threads"];
		}
		
		if ([children count] != 0) {
			
			//call delegate to update sub thread table
            [[self delegate] clearSubThreadView];
			[[self delegate] updateSubThreadTableView:children andPreviousTable:nil];

		}
		else {
			NSLog(@"No more sub threads!");
            [[self delegate] clearSubThreadView];
			[[self delegate] updateSubThreadTableView:nil andPreviousTable:nil];
		} 

	}
	
	[spinner removeFromSuperview];
	[spinner release];
	self.view.userInteractionEnabled = YES;

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
	[tableDataSource release];
	[cells release];
	[currentTitle release];
    [super dealloc];
}


@end

