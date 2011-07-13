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
#import "ForumViewController.h"
#import "Timetable.h"
#import "IVLELoginNew.h"
#import "Constants.h"
#import "HomePageModuleAnnouncementCell.h"
#import "IVLEAppDelegate.h"
#import "ModulesAnnouncementsCell.h"
#import "WebcastController.h"


@interface IVLEMain : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
	
	
	
	IBOutlet UITableView *recentAnnouncements;
	IBOutlet UIView *timetable;
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
}
@property (nonatomic, retain) NSMutableArray *announcements;
@property (nonatomic, retain) NSMutableArray *announcementCells;
//
//- (IBAction)modulesClicked;
//- (IBAction)timetableClicked;
//- (IBAction)mapClicked;
//- (IBAction)capClicked;
//- (IBAction)eventsClicked;
- (IBAction)changePage:(id)sender;

/* reloads the view with a split view controller
 leftBar: master of split view controller
 rightBar: detail of split view controller */

//- (void)refreshMainScreenWith:(id)leftBar withRight:(id)rightBar;
//
///* reloads the view with one single view
// mainScreen: view to load */
//
//- (void)refreshMainScreenWith:(id)mainScreen;
//
///* displays the Splash Screen */
//
//- (void)refreshScreenToSplashScreen;

/* displays the login screen */

-(void) displayLogin;
@end
