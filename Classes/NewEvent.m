    //
//  NewEvent.m
//  IVLE
//
//  Created by Shyam on 4/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "NewEvent.h"


@implementation NewEvent

@synthesize delegate;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (IBAction)doneButtonPressed {
	
	[delegate userAddedEventWith:eventTitle.text Description:description.text Contact:contact.text DateTime:dateTime.text Organizer:organizer.text Price:price.text Venue:venue.text Agenda:agenda.text];
}

- (IBAction)cancelButtonPressed {
	
	[delegate userCancelledAddingEvents];
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
