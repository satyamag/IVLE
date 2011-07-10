    //
//  TimetableNew.m
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimetableNew.h"


@implementation TimetableNew

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // get all module IDs and it's timetables
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//this block of code basically initializes all the module events in IVLE into the array "moduleEventsList"
	IVLE *ivleInstance = [IVLE instance];
	NSArray *modulesList = [NSArray arrayWithArray:[[ivleInstance modules:0 withAllInfo:NO] objectForKey:@"Results"]];
	
	if (!moduleEventsList) {
		
		moduleEventsList = [[NSMutableArray alloc] init];
	}
	else {
		
		[moduleEventsList removeAllObjects];
	}

	NSMutableArray *moduleIDsList = [NSMutableArray arrayWithObjects:nil];
	
	for (int i = 0; i < [modulesList count]; i++) {
		
		[moduleIDsList addObject:[[modulesList objectAtIndex:i] objectForKey:@"ID"]];
		NSArray *moduleEvents = [[ivleInstance timetableStudentModule:[moduleIDsList objectAtIndex:i]] objectForKey:@"Results"];
		
		for (int j = 0; j < moduleEvents.count; j++) {
			
			ModuleEvent *newModuleEvent = [[ModuleEvent alloc] init];
			[newModuleEvent createModuleEvent:[moduleEvents objectAtIndex:j]];
			[moduleEventsList addObject:newModuleEvent];
			[newModuleEvent release];
		}
	}
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
	
	[moduleEventsList release];
	
    [super dealloc];
}


@end
