    //
//  IVLESideBarNavigator.m
//  IVLE
//
//  Created by satyam agarwala on 4/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "IVLEBottomBar.h"


#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kNotificationSetPageTitle @"setPageTitle"
@implementation IVLEBottomBar

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.view.backgroundColor = [UIColor clearColor]; 
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.frame = CGRectMake(0, 748-self.view.frame.size.height,  self.view.frame.size.width, self.view.frame.size.height);

}



- (IBAction)homeClicked{
	
	//loads home screen and clears top bar of any buttons
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:[NSArray array]];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClearTopBarButtons object:nil];
}

- (UIActivityIndicatorView *) createSpinner {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(1024/2-spinner.frame.size.width/2, 748/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
	[spinner startAnimating];
	[[self.view superview] addSubview:spinner];
	self.view.userInteractionEnabled = NO;
	return spinner;
}
- (IBAction)modulesClicked{
	
	//loads modules
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];

	NSArray *leftBar = [NSArray arrayWithObject:[[ModulesWorkbin alloc] init]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshRightScreen object:leftBar];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClearTopBarButtons object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Modules"]];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
}


- (IBAction)timetableClicked{
	
	// loads timetable and adds button to top bar
	
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	NSArray *leftBar = [NSArray arrayWithObject:[[Timetable alloc] init]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:leftBar];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Timetable"]];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
}

- (IBAction)eventsClicked{
	
	//loads events and add buttons to top bar 
	
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	NSArray *leftBar = [NSArray arrayWithObject:[[Events alloc] init]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:leftBar];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Events"]];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
}

- (IBAction)mapClicked{
	
	//loads map and adds buttons to top bar
	
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	NSArray *leftBar = [NSArray arrayWithObject:[[Map alloc] init]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:leftBar];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClearTopBarButtons object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"Map"]];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
}

- (IBAction)capClicked{
	
	//loads CAP calculator and adds buttons to top bar 
	
	UIActivityIndicatorView *spinner;
	spinner = [self createSpinner];
	NSArray *leftBar = [NSArray arrayWithObject:[[CAPCalculator alloc] init]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:leftBar];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetPageTitle object:[NSString stringWithString:@"CAP Calculator"]];
	
	self.view.userInteractionEnabled = YES;
	[spinner removeFromSuperview];
	[spinner release];
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

    [super dealloc];
}


@end
