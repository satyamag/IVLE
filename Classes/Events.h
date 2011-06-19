//
//  Events.h
//  IVLE
//
//  Created by Shyam on 4/8/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "EventsView.h"
#import "EventsData.h"
#import "ModulesFetcher.h"
#import "NewEvent.h"
#import "Map.h"

@interface Events : UIViewController <EventsViewDelegate>{

	IVLE *ivleInterface;
	
	IBOutlet UIScrollView *scrollView;
	
	NSArray *eventsArray, *buttonsArray;
	NSMutableArray *eventsViewControllerArray;
	NSManagedObjectContext *managedObjectContext;
}

- (IBAction)homeButtonClicked;
// MODIFIES:  none
// REQUIRES: self != nil
// EFFECTS:  loads the home screen

- (IBAction)addEventButtonClicked;
// MODIFIES:  none
// REQUIRES: self != nil
// EFFECTS:  presents popover to add event


@end
