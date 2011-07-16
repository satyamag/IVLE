    //
//  Forum.m
//  IVLE
//
//  Created by QIN HUAJUN on 7/13/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "Forum.h"


@implementation Forum

@synthesize mainThreadTable, subThreadTable, contentDisplay, mainNC;

#pragma mark -
#pragma mark ForumMainThreadTableDelegate

- (void)displayThreadContent:(NSString *)content{
	
	//control the contentDisplay view and subThreadTable view here
    
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

- (void)updateSubThreadTableView:(NSArray *)children {

	//update the subthreadtable view with this new table
	if (children != nil) {
		
		//prepare to push in new main thread table view
		ForumSubThreadTable *newForumTable = [[ForumSubThreadTable alloc] init];
		
		//set the new tableview delegate as the forum class
		[newForumTable setDelegate:self];
		
		//update the data source
		newForumTable.tableDataSource = children;
        
		newForumTable.view.frame = CGRectMake(1, 1, self.subThreadTable.frame.size.width, self.subThreadTable.frame.size.height);
		[self.subThreadTable addSubview:newForumTable.view];
        
	}

}

- (void)updateMainThreadTableView:(NSArray *)tableDataSource andIndexPath:(NSIndexPath *)indexPath{

	if (tableDataSource != nil) {
		
		ForumMainThreadTable *newTable = [[ForumMainThreadTable alloc] init];
		
		[newTable setDelegate:self];
		
		newTable.currentLevel = 3;
		
		newTable.tableDataSource = tableDataSource;
		
		[self.mainNC pushViewController:newTable animated:YES];
		
		[newTable.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
		
		[newTable release];
	}
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
	
	NSLog(@"Start loading forum!!!!");
	UIImage *bgImage_announcements = [UIImage imageNamed:@"module_info_announcement_bg.png"];
    UIImage *bgImage_subthread_table = [UIImage imageNamed:@"subthreads_table.png"];

	ForumMainThreadTable *mainTable = [[ForumMainThreadTable alloc] init];
	[mainTable setDelegate:self];
	
	//set up navigation controller for the main thread tableview
	mainNC = [[UINavigationController alloc] init];
	
	[mainNC pushViewController:mainTable animated:NO];
	mainNC.navigationBar.barStyle = UIBarStyleBlack;
	

	
	//set the navigation controller's view frame into the IBOutlet view frame

	mainNC.view.frame = CGRectMake(0, 0, self.mainThreadTable.frame.size.width, self.mainThreadTable.frame.size.height);
	[self.mainThreadTable addSubview:mainNC.view];
	
	contentDisplay.backgroundColor = [UIColor clearColor];
	mainThreadTable.backgroundColor = [UIColor clearColor];
    contentDisplay.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
    self.subThreadTable.backgroundColor = [UIColor colorWithPatternImage:bgImage_subthread_table];
	self.title = @"Forum";

	NSLog(@"done loading forum!!!");
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
	[mainNC release];
    [super dealloc];
}


@end
