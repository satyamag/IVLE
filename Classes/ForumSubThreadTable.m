//
//  ForumSubThreadTable.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumSubThreadTable.h"


@implementation ForumSubThreadTable

@synthesize tableDataSource, cells, delegate, selectedCell;

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

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.backgroundColor = [UIColor clearColor];
    cells = [[NSMutableArray alloc] init];	

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
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
    
    NSDictionary *info = [tableDataSource objectAtIndex:[indexPath row]];
    
    ForumTableCell *cell;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumTableCell" 
                                                 owner:self
                                               options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.titleText.text = [info objectForKey:@"PostTitle"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cells addObject:cell];
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 50.0;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedCell) {
        selectedCell.titleText.textColor = kWorkbinFontColor;
        selectedCell.metaText.textColor = kWorkbinFontColor;
    }
    selectedCell = (ForumTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedCell.titleText.textColor = kWorkbinFontCompColor;
    selectedCell.metaText.textColor = kWorkbinFontCompColor;
    
    UIWebView *content = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"PostBody"];
    [[self delegate] displayThreadContent:content];
    
    NSArray *children = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Threads"];
    if ([children count] != 0) {
        
        if ([children count] == 1) {
            //call delegate to update sub thread table
            [self.view removeFromSuperview];
            [[self delegate] updateSubThreadTableView:children];
        }
        else {
            [self.view removeFromSuperview];
            [[self delegate] updateSubThreadTableView:[NSArray arrayWithObjects:[children objectAtIndex:0], nil]];
            [[self delegate] updateMainThreadTableView:children andIndexPath:indexPath];
        }
        
        
    }
	
    
    
	//[self.delegate updateMainThreadTableView:self.tableDataSource andCells:self.cells andIndexPath:indexPath];
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

