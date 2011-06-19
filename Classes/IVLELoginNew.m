//
//  IVLELogin.m
//  IVLE
//
//  Created by satyam agarwala.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLELoginNew.h"


@implementation IVLELoginNew

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
	
	NSString *domainTrimmed = [domain.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *nusnetIDTrimmed = [nusnetID.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *passwordTrimmed = [password.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[[IVLE instance] login:nusnetIDTrimmed withPassword:passwordTrimmed withDomain:domainTrimmed];
	[self dismissModalViewControllerAnimated:YES];
	
}

- (IBAction)cancelClicked{
	[[[[UIAlertView alloc] initWithTitle:@"Offline" message:@"Working in offline mode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	[self dismissModalViewControllerAnimated:YES];
}

@end
