    //
//  ForumPostNew.m
//  IVLE
//
//  Created by Satyam Agarwala on 7/14/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "ForumPostNew.h"

#define FORUMHEADING 7

@implementation ForumPostNew

@synthesize  postTitle, postBody, headingName, headingList, delegate, heading, isReply;

-(BOOL)checkInputValidation {
	
	if ([postTitle text].length == 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title Lacking"
														message:@"Title cannot be empty!"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return FALSE;
	}
	else if ([postBody text].length == 0){
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Body Lacking"
														message:@"Post body cannot be empty!"
													   delegate:self cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return FALSE;
	}
	else {
		return TRUE;
	}

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    
    return self;
}

- (void)done {

	if ([self checkInputValidation] == TRUE) {
        
        if (isReply) {
            [[self delegate] postNewReplyWithTitle:[postTitle text] body:[postBody text]];
        }
        else {
           [[self delegate] postNewThreadWithHeading:headingName title:[postTitle text] body:[postBody text]]; 
        }
		

		//dismiss the modal view
		[self dismissModalViewControllerAnimated:YES];
	}
	
}

-(void) cancel {
    //dismiss the modal view
    [self dismissModalViewControllerAnimated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Post New Thread";
    
    if (isReply) {
        self.postTitle.text = @"Re:";
    }
    headingName = [[self delegate] getHeadingName];
    self.heading.text = headingName;

    
    self.navigationController.navigationBar.tintColor = kNavBarColor;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIImage *bgImage_announcements = [UIImage imageNamed:@"modules_workbin_3rd_column.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage_announcements];
	NSLog(@"%@", self.headingList);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
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
	[headingName release];
	[headingList release];
    [super dealloc];
}


@end
