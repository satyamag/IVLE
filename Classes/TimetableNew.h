//
//  TimetableNew.h
//  IVLE
//
//  Created by mac on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "IVLE.h"
#import "ModuleEvent.h"
#import "TapkuLibrary.h"
#import "TimeTableCell.h"
#import "ModuleEvent2.h"

@interface TimetableNew : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, UITableViewDelegate, UITableViewDataSource>{
	
	NSMutableArray *moduleEventsList;
	NSArray *currentDisplayEvents;
	TKCalendarMonthView *calendar;
	
	IBOutlet UITableView *currentEventsTable;
}

@end
