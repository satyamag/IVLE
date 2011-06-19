    //
//  IVLETopBar.m
//  IVLE
//
//  Created by satyam agarwala on 4/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "IVLETopBar.h"

#define kNotificationSetWelcomeMessage @"setWelcomeMessage"
#define kNotificationSetPageTitle @"setPageTitle"
#define kNotificationSetTopBarButtons @"setTopBarButtons"

@implementation IVLETopBar
static IVLETopBar *sharedSingleton;
//@synthesize welcomeMessage;
@synthesize pageTitle;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


+ (IVLETopBar *)instance
{
	@synchronized(self)
    {
		if (sharedSingleton == NULL)
			sharedSingleton = [[self alloc] init];
    }
	
	return sharedSingleton;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//sets up notfications 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTopBarButtons:) name:kNotificationSetTopBarButtons object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearTopBarButtons:) name:kNotificationClearTopBarButtons object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTopBarPageTitle:) name:kNotificationSetPageTitle object:nil];

    [super viewDidLoad];
	buttons = [[NSArray alloc] init];
}

-(void) clearTopBarButtons:(NSNotification*)notification {

	//remove any buttons from top bar
	
	int i;
	if ([buttons count] != 0) {
		for (i=0; i<[buttons count]; i++) {
			UIButton *btn = (UIButton*)[buttons objectAtIndex:i];
			[btn removeFromSuperview];
		}
	}
	
}

-(void) setTopBarPageTitle:(NSNotification*)notification {

	//set page title 
	
	pageTitle.text = [notification object];
	
}


-(void) setTopBarButtons:(NSNotification*)notification {

	//introduce buttons to top bar as created in the buttons array
	
	int i;
	if ([buttons count] != 0) {
		for (i=0; i<[buttons count]; i++) {
			UIButton *btn = (UIButton*)[buttons objectAtIndex:i];
			[btn removeFromSuperview];
		}
	}
	buttons = [[notification object] retain];
	if ([buttons count] != 0) {
		for (i=0; i<[buttons count]; i++) {
			UIButton *btn = (UIButton*)[buttons objectAtIndex:i];
			[self.view addSubview:btn];
		}
	}
	
}

-(void) logoutPressed {
	
	//logout the current user

	[IVLE instance].authenticationToken = nil;
	[IVLESideBar clear];
	

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userLogin.plist"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:nil];
	// write plist to disk
//	[dict writeToFile:path atomically:YES];
	//[[[IVLESideBar alloc] initWithNibName:nil bundle:nil] removeInstance];
	[[ModulesFetcher sharedInstance] changeCoreData];
/*	if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(restartApplication)]) {
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate restartApplication];
		[[[UIApplication sharedApplication] delegate] restartApplication];
	}
*/	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginScreen object:[NSArray array]];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClearTopBarButtons object:nil];
	
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
//	[welcomeMessage release];
	[pageTitle release];
    [super dealloc];
}


@end
