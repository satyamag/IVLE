    //
//  SplashScreen.m
//  IVLE
//
//  Created by satyam agarwala on 4/10/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

@synthesize timer,splashImageView;



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)loadView {
	// Init the view
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	
	splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IVLE_splash_screen_white.png"]];
	//splashImageView.frame = CGRectMake(0, 0, 1024, 748);
	[self.view addSubview:splashImageView];
	

	
	timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

-(void) onTimer{
	//NSLog(@"LOAD");
}

- (void)fadeScreen
{
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.5];        // sets animation duration
	[UIView setAnimationDelegate:self];        // sets delegate for this block
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];   // calls the finishedFading method when the animation is done (or done fading out)	
	self.view.alpha = 0.0;       // Fades the alpha channel of this view to "0.0" over the animationDuration of "0.75" seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
}


- (void) finishedFading
{
	
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.15];        // sets animation duration
	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
	[splashImageView removeFromSuperview];
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
