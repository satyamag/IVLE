//
//  Events.m
//  IVLE
//
//  Created by Shyam on 4/8/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "Events.h"

@interface Events (PrivateMethods)
-(void) initializeEventsArray;
@end

@implementation Events

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:[self retain] action:@selector(addEventButtonClicked)];
		
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//setup scroll view
    [self initializeEventsArray];
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		[scrollView setContentSize:CGSizeMake(600, 240 * ceil([eventsArray count] / 3) + 240)];
	}
	else {
		[scrollView setContentSize:CGSizeMake(600, 240 * ceil([eventsArray count] / 4) + 240)];
	}
	
	[scrollView setDirectionalLockEnabled:YES];
	[scrollView setClipsToBounds:YES];
	[scrollView setAlwaysBounceHorizontal:NO];
	
	[scrollView setBackgroundColor:[UIColor clearColor]];
	
	
	
	for (int i = 0; i < [eventsViewControllerArray count]; i++) {
		
		EventsView *currentEvent = [eventsViewControllerArray objectAtIndex:i];
		
		[scrollView addSubview:currentEvent.view];
	}
	
    [super viewDidLoad];
}

-(void) initializeEventsArray {
	
	int viewX = 0, viewY = 0;
	//UIBarButtonItem *addUserEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventButtonClicked)];
	
	ivleInterface = [[IVLE instance] retain];
	
	//add ivle events
	eventsArray = [[[ivleInterface studentEvents:NO] objectForKey:@"Results"] retain];
	eventsViewControllerArray = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [eventsArray count]; i++) {
		
		NSDictionary *currentEvent = [eventsArray objectAtIndex:i];
		
		EventsView *eventsVC = [[EventsView alloc] initWithEvent:currentEvent];
		[eventsVC setDelegate:self];
		[eventsVC.view setFrame:CGRectMake(viewX, viewY, 256, 240)];
		[eventsViewControllerArray addObject:eventsVC];
		[eventsVC release];
		
		if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
			viewX += 256;
			if (viewX == 256 * 4) {
				viewX = 0;
				viewY += 240;
			}
		}		
		else {
			viewX += 256;
			if (viewX == 256 * 3) {
				viewX = 0;
				viewY += 240;
			}
		}
	}
}
- (IBAction)homeButtonClicked {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshScreen object:[NSArray array]];
}

- (IBAction)addEventButtonClicked {
	
	//Popover view controller
	Map *mapVC = [[Map alloc] initWithAddEventMode:YES];
	
	if (mapPopover == nil) {
		mapPopover = [[UIPopoverController alloc] initWithContentViewController:mapVC];
		[mapPopover setPopoverContentSize:CGSizeMake(950, 600) animated:YES];
	}
	
	[mapPopover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark -
#pragma mark Events view delegate

- (void)setZoomForEventView:(UIView *)aView {

	[aView setFrame:CGRectMake(10, 10 + scrollView.contentOffset.y, scrollView.bounds.size.width - 20, scrollView.bounds.size.height - 20)];
	
}

- (void)setEventsForZoomedView {
	
	[scrollView setScrollEnabled:NO];
}

- (void)setEventsForNormalView {
	
	[scrollView setScrollEnabled:YES];
}

#pragma mark -
#pragma mark Memory handling functions

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	int viewX = 0, viewY = 0;
	
	for (int i = 0; i < [eventsViewControllerArray count]; i++) {
		
		EventsView *currentEvent = [eventsViewControllerArray objectAtIndex:i];
		
		[currentEvent.view setFrame:CGRectMake(viewX, viewY, 256, 240)];
		
		if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
			viewX += 256;
			if (viewX == 256 * 4) {
				viewX = 0;
				viewY += 240;
			}
		}		
		else {
			viewX += 256;
			if (viewX == 256 * 3) {
				viewX = 0;
				viewY += 240;
			}
		}
	}
	
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
	
	[eventsViewControllerArray release];
	[eventsArray release];
	[ivleInterface release];
	[buttonsArray release];
	[mapPopover release];
	
    [super dealloc];
}


@end
