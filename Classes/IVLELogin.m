    //
//  IVLELogin.m
//  IVLE
//
//  Created by Lee Sing Jie on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLELogin.h"


@implementation IVLELogin

@synthesize nusnetID;
@synthesize password;
@synthesize domain;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImage *blackboardImage = [UIImage imageNamed:@"Blackboard.png"];
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:blackboardImage]];
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
    [super dealloc];
}

- (IBAction)loginClicked{
	
	[[IVLE instance] login:self.nusnetID.text withPassword:self.password.text withDomain:self.domain.text];
	[self dismissModalViewControllerAnimated:YES];
	
}

- (IBAction)cancelClicked{
	[[[[UIAlertView alloc] initWithTitle:@"Offline" message:@"Working in offline mode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	[self dismissModalViewControllerAnimated:YES];
}

@end
