//
//  IVLESideBarNavigator.h
//  IVLE
//
//  Created by satyam agarwala on 4/12/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVLE.h"
#import "ModuleHeader.h"
#import "ModuleHeaderInfo.h"
#import "LeftSideBarCellView.h"
#import "ForumViewController.h"
#import "IVLE.h"
#import "Timetable.h"
#import "ModulesWorkbin.h"
#import "ModulesInfo.h"
#import "ModulesAnnouncements.h"
#import "CAPCalculator.h"
#import "Events.h"
#import "Constants.h"

#import "Map.h"

@interface IVLEBottomBar : UIViewController {

	
	IBOutlet UIButton *home;
	IBOutlet UIButton *modules;
	IBOutlet UIButton *timetable;
	IBOutlet UIButton *events;
	IBOutlet UIButton *map;
	IBOutlet UIButton *logout;
	IBOutlet UIButton *cms;
	
}

/*Display Home Screen */

- (IBAction)homeClicked;

/* Displays Modules */

- (IBAction)modulesClicked;

/* Displays Timetable */

- (IBAction)timetableClicked;

/* Displays Events */

- (IBAction)eventsClicked;

/* Displays Map */

- (IBAction)mapClicked;

/* Displays CAP Calculator */

- (IBAction)capClicked;

@end
