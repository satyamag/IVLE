//
//  IVLEMain.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModulesWorkbin.h"
#import "IVLE.h"
#import "IVLESideBar.h"
#import "IVLELoginWebViewController.h"
#import "CAP.h"
#import "CAPCalculator.h"
#import "Forum.h"
#import "IVLELoginNew.h"
#import "Constants.h"
#import "HomePageModuleAnnouncementCell.h"
#import "IVLEAppDelegate.h"
#import "ModulesAnnouncementsCell.h"
#import "WebcastController.h"
#import "TimeTableCell.h"

@class Reachability;

@interface IVLEMain : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
	
	IBOutlet UITableView *recentAnnouncements, *recentTimetable;
	NSMutableArray *announcementCells;
	NSMutableArray *timetableCells;
    NSMutableArray *announcements;
	
	IBOutlet UIScrollView *eventsScrollView;
	IBOutlet UIPageControl *eventsPageControl;
	
	BOOL pageControlIsChangingPage;
	
	id currentActiveLeftViewController;
	id currentActiveMainViewController;
	UISplitViewController* splitVC;
	
	IBOutlet UIView *rightHandSideView, *pageControlView;
	
	Reachability *internetReachable;
	Reachability *hostReachable;
	
	BOOL internetActive, hostActive;
}
@property (nonatomic, retain) NSMutableArray *announcements;
@property (nonatomic, retain) NSMutableArray *announcementCells;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;

/* To check the network status */
- (void) checkNetworkStatus:(NSNotification *)notice;

// to change the small dot in UIPageControl
- (IBAction)changePage:(id)sender;

/* displays the login screen */
-(void) displayLogin;
@end
