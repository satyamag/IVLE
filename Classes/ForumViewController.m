//
//  ForumViewController.m
//  IVLE
//
//  Created by QIN HUAJUN on 3/28/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumViewController.h"


@implementation ForumViewController

@synthesize tv, forumTableNavController, display;


#pragma mark -
#pragma mark ForumTableViewController delegate

- (void)updateThreadContent:(NSString *)newContent
{
	NSString *formatedContent = [NSString stringWithFormat:@"<html><head><style type='text/css'>body </style></head><body>%@</body></html>",newContent];
	[self.display loadHTMLString:formatedContent baseURL:nil];
}

#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ForumTableViewController *forumTable = [[ForumTableViewController alloc] init];
	[forumTable setDelegate:self];
	
	//set up navigation controller for the tableview
	forumTableNavController = [[UINavigationController alloc] init];
	[forumTableNavController pushViewController:forumTable animated:NO];
	forumTableNavController.navigationBar.barStyle = UIBarStyleBlack;
	
	//set the navigation controller's view frame into the IBOutlet view frame set up in IB
	forumTableNavController.view.frame = CGRectMake(0, 0, self.tv.frame.size.width, self.tv.frame.size.height);
	[self.tv addSubview:forumTableNavController.view];
	
	display.backgroundColor = [UIColor clearColor];
	tv.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor clearColor];
	self.title = @"Forum";
	
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
