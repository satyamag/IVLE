    //
//  Forum.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "Forum.h"


@implementation Forum

@synthesize mainThreadTable, subThreadTable, contentDisplay, currentPostID,currentHeadingID, currentHeadingName;

#pragma mark -
#pragma mark ForumMainThreadTableDelegate


- (void)displayThreadContent:(NSString *)content andPostID:(NSString*)postID {
	
	//control the contentDisplay view and subThreadTable view here
    currentPostID = [NSString stringWithString:postID];
    NSString *formatedContent = [NSString stringWithFormat:@"<html> \n"
     "<head> \n"
     "<style type=\"text/css\"> \n"
     "body {font-family: \"%@\"; font-size: %@; text-align: %@}\n"
     "</style> \n"
     "</head> \n"
     "<body><div id='foo'>%@</div></body> \n"
     "</html>", @"HelveticaNeue", [NSNumber numberWithInt:kWebViewFontSize],@"justify",content];
    
	[self.contentDisplay loadHTMLString:formatedContent baseURL:nil];

}

- (void)updateSubThreadTableView:(NSArray *)children andPreviousTable:(id)previousTable{

	//update the subthreadtable view with this new table
	if (children != nil) {
		
		//prepare to push in new main thread table view
		ForumSubThreadTable *newForumTable = [[ForumSubThreadTable alloc] init];
		[newForumTable setPreviousTable:(ForumSubThreadTable*)previousTable];
		//set the new tableview delegate as the forum class
		[newForumTable setDelegate:self];
		
		//update the data source
		newForumTable.tableDataSource = children;
        
		newForumTable.view.frame = CGRectMake(1, 1, self.subThreadTable.frame.size.width, self.subThreadTable.frame.size.height);
		[self.subThreadTable addSubview:newForumTable.view];
        
	}

}

- (void)updateMainThreadTableView:(id)newForumTable andHeadingID:(NSString*)headingID andHeadingName:(NSString*)headingName{
    
    
    ForumMainThreadTable *table = (ForumMainThreadTable*) newForumTable;
    NSLog(@"HEADING ID --------------------------- %@",headingID);
    NSLog(@"HEADING NAME ------------------------- %@",headingName);
    if (table.currentLevel == 2) {
        currentHeadingID = [NSString stringWithString:headingID];
        currentHeadingName =  [NSString stringWithString:headingName];
    }
    table.view.frame = CGRectMake(0, 0, self.mainThreadTable.frame.size.width, self.mainThreadTable.frame.size.height);
    [self.mainThreadTable addSubview:table.view];
}


- (void)updateMainThreadTableView:(NSArray *)tableDataSource andIndexPath:(NSIndexPath *)indexPath{

	if (tableDataSource != nil) {
		
		ForumMainThreadTable *newTable = [[ForumMainThreadTable alloc] init];
		
		[newTable setDelegate:self];
		
		newTable.currentLevel = 3;
		
		newTable.tableDataSource = tableDataSource;
		
//		[self.mainNC pushViewController:newTable animated:YES];
		newTable.view.frame = CGRectMake(0, 0, self.mainThreadTable.frame.size.width, self.mainThreadTable.frame.size.height);
        
        [self.mainThreadTable addSubview:newTable.view];
        
		[newTable.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
		
	}
}

-(void) enablePostingNewThread {
    postThreadLabel.hidden = NO;
    postThreadButton.enabled = YES;
}

-(void) disablePostingNewThread {
    postThreadLabel.hidden = YES;
    postThreadButton.enabled = NO;
}

-(void) enableReply {
    postReplyLabel.hidden = NO;
    postReplyButton.enabled = YES;
    postReplyImage.hidden = NO;
}

-(void) disableReply {
    postReplyLabel.hidden = YES;
    postReplyButton.enabled = NO;
    postReplyImage.hidden = YES;
}
-(void) clearSubThreadView {
    
    for (UIView *view in self.subThreadTable.subviews) {
        [view removeFromSuperview];
    }
}

-(void) clearContentView {
    [self.contentDisplay loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}



#pragma mark - 
#pragma mark view lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Custom initialization.
	
    [self disablePostingNewThread];
    [self disableReply];
	NSLog(@"Start loading forum!!!!");
	UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
    UIImage *bgImage_subthread_table = [UIImage imageNamed:@"subthreads_table.png"];

	ForumMainThreadTable *mainTable = [[ForumMainThreadTable alloc] init];
	[mainTable setDelegate:self];
    
    mainTable.view.frame = CGRectMake(0, 0, self.mainThreadTable.frame.size.width, self.mainThreadTable.frame.size.height);
	[self.mainThreadTable addSubview:mainTable.view];
	
	contentDisplay.backgroundColor = [UIColor clearColor];
	mainThreadTable.backgroundColor = [UIColor clearColor];
    contentDisplay.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    self.subThreadTable.backgroundColor = [UIColor colorWithPatternImage:bgImage_subthread_table];

	NSLog(@"done loading forum!!!");
}

- (IBAction)postNewThread:(id)sender{
	
    UIButton *button = (UIButton*)sender;
    NSLog(@"%d",button.tag);
    
	NSLog(@"post new threads here");
	ForumPostNew *postWindow = [[ForumPostNew alloc] initWithNibName:@"ForumPostNew" bundle:nil];
	[postWindow setDelegate:self];
    
    if (button.tag == 2) {
        [postWindow setIsReply:YES];
    }
    else {
        [postWindow setIsReply:NO];
    }
    postWindow.heading.text = [NSString stringWithString:currentHeadingName];
	
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
	if (currentHeadingID) {
		[[IVLE instance] forumPostNewThread:currentHeadingID withTitle:titleName withReply:postBody];
	}
	else {
		NSLog(@"Heading ID not found for heading: %@", headingName);
	}
}

-(void)postNewReplyWithTitle:(NSString *)titleName body:(NSString *)postBody{
    
	NSLog(@"start posting threads to the server");
	if (currentPostID) {
		[[IVLE instance] forumReplyThread:currentPostID withTitle:titleName withReply:postBody];
	}
	else {
		NSLog(@"Post ID not found for heading: %@", titleName);
	}
}

-(NSString*) getHeadingName{
    return currentHeadingName;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
    return NO;
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
    [super dealloc];
}


@end
