//
//  Timetable.h
//  IVLE
//
//  Created by QIN HUAJUN on 3/27/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableAddClassViewController.h"
#import "CoreDataTimetable.h"
#import "CoreDataTimetableDay.h"
#import "CoreDataTimetableClassInfo.h"
#import "ModulesFetcher.h"
#import <EventKit/EventKit.h>
#import "IVLE.h"

@interface Timetable : UIViewController <UITableViewDataSource, UITableViewDelegate, TimetableAddClassViewControllerDelegate> {

	IBOutlet UITableView *timetable;
	 UIButton *addModuleButton;
	
	NSArray *sections;
	NSMutableDictionary *schedule;
	
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *timetableDays;
	NSMutableArray *timetableClasses;
	
	UIPopoverController* popover;
	NSArray *buttonsArray;
}

@property (retain) NSArray *sections;
@property (retain) NSMutableDictionary *schedule;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *timetableDays;
@property (nonatomic, retain) NSMutableArray *timetableClasses;


- (IBAction)addNewClass:(id)sender;

@end
