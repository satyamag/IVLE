//
//  ForumSubThreadTable.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumSubThreadTable.h"


@implementation ForumSubThreadTable

@synthesize tableDataSource, cells, delegate;

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
	
	NSArray *headingMainThreads = [[[IVLE instance] forumHeadingMainThreads:headingID withDuration:0] objectForKey:@"Results"];
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

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.backgroundColor = [UIColor clearColor];

	//init the cells
	for (int i=0; i<[tableDataSource count]; i++) {
		
		NSDictionary *info = [tableDataSource objectAtIndex:i];
		
		ForumTableCell *cell;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumTableCell" 
													 owner:self
												   options:nil];
		cell = [nib objectAtIndex:0];
		
		cell.titleText.text = [info objectForKey:@"PostTitle"];
		cell.meta.text = [[info objectForKey:@"Poster"] objectForKey:@"Name"];
		
		NSString *formatedContent = [NSString stringWithFormat:@"<html> \n"
									 "<head> \n"
									 "<style type=\"text/css\"> \n"
									 "body {font-family: \"%@\"; font-size: %@; text-align: %@}\n"
									 "</style> \n"
									 "</head> \n"
									 "<body><div id='foo'>%@</div></body> \n"
									 "</html>", @"HelveticaNeue", [NSNumber numberWithInt:kWebViewFontSize],@"justify",[info valueForKey:@"PostBody"]];
		
		[cell.descriptionText loadHTMLString:formatedContent baseURL:nil];
		
		do {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (!cell.finishedLoading);
		NSAssert(cell.finishedLoading, @"cell not finish loading");
		cell.descriptionText.backgroundColor = [UIColor clearColor];
		
		[self.cells addObject:cell];
		
	}
	
	UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
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
    
	return [self.cells objectAtIndex:[indexPath row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ForumTableCell *cell = [cells objectAtIndex:[indexPath row]];
	CGFloat height = cell.descriptionText.frame.size.height + (cell.descriptionText.frame.origin.y-cell.titleText.frame.origin.y);
    CGFloat x = cell.backgroundImage.frame.origin.x;
    CGFloat y = cell.backgroundImage.frame.origin.y;
    CGFloat width = cell.backgroundImage.frame.size.width;
    
    
    cell.backgroundImage.frame = CGRectMake(x, y, width, cell.descriptionText.frame.size.height);
	return height;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self.view removeFromSuperview];
	[self.delegate updateMainThreadTableView:self.tableDataSource andCells:self.cells andIndexPath:indexPath];
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
    [super dealloc];
}


@end

