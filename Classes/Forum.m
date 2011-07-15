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

- (void)displayThreadContent:(UIWebView *)content{
	
	//control the contentDisplay view and subThreadTable view here
	self.contentDisplay = content;

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
		
		[self.subThreadTable addSubview:newForumTable.view];
	}

}

- (void)updateMainThreadTableView:(NSArray *)tableDataSource andCells:(NSMutableArray *)cells andIndexPath:(NSIndexPath *)indexPath{

	if (tableDataSource != nil) {
		
		ForumMainThreadTable *newTable = [[ForumMainThreadTable alloc] init];
		
		[newTable setDelegate:self];
		
		newTable.currentLevel = 3;
		
		newTable.tableDataSource = tableDataSource;
		
		[self.mainNC pushViewController:newTable animated:YES];
		
		[newTable.tableView selectRowAtIndexPath:(NSIndexPath *)[indexPath row] animated:YES scrollPosition:UITableViewScrollPositionNone];
		
		[newTable release];
	}
}



#pragma mark - 
#pragma mark view lifecycle

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		
		NSLog(@"!!!!!!!!Start loading forum!!!");
		
		ForumMainThreadTable *mainTable = [[ForumMainThreadTable alloc] init];
		[mainTable setDelegate:self];
		
		NSLog(@"im here 1");
		
		//set up navigation controller for the main thread tableview
		mainNC = [[UINavigationController alloc] init];
		[mainNC pushViewController:mainTable animated:NO];
		mainNC.navigationBar.barStyle = UIBarStyleBlack;
		
		NSLog(@"im here 2");
		
		//set the navigation controller's view frame into the IBOutlet view frame
		mainNC.view.frame = CGRectMake(0, 0, self.mainThreadTable.frame.size.width, self.mainThreadTable.frame.size.height);
		[self.mainThreadTable addSubview:mainNC.view];
		
		NSLog(@"im here 3");
		
		contentDisplay.backgroundColor = [UIColor clearColor];
		mainThreadTable.backgroundColor = [UIColor clearColor];
		//self.view.backgroundColor = [UIColor clearColor];
		//self.title = @"Forum";
    }
	NSLog(@"done loading forum");
	
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Custom initialization.
	
	NSLog(@"Start loading forum!!!!");
	
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
	self.view.backgroundColor = [UIColor clearColor];
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
