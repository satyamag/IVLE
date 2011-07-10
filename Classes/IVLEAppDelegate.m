//
//  IVLEAppDelegate.m
//  IVLE
//
//  Created by LEE SING JIE on 3/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IVLEAppDelegate.h"


@implementation IVLEAppDelegate

@synthesize window;

@synthesize tabBarController=_tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
//	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
 //   [window addSubview:[viewController view]];
	
    
    IVLEMain *home = [[[IVLEMain alloc] init] autorelease];
    UINavigationController *IVLEHomeNavigator = [[[UINavigationController alloc] initWithRootViewController:home] autorelease];
    IVLEHomeNavigator.navigationBar.tintColor = kNavBarColor;
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    home.title = @"Home";
    
    Workbin *workbinController = [[[Workbin alloc] init] autorelease];
    UINavigationController *workbinNavigator = [[[UINavigationController alloc] initWithRootViewController:workbinController] autorelease];
    workbinNavigator.navigationBar.tintColor = kNavBarColor;
    workbinController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Workbin" image:[UIImage imageNamed:@"modules.png"] tag:2];
    workbinController.title = @"Workbin";
    
    Events *eventController = [[[Events alloc] init] autorelease];
    UINavigationController *eventsNavigator = [[[UINavigationController alloc] initWithRootViewController:eventController] autorelease];
    eventsNavigator.navigationBar.tintColor = kNavBarColor;
    eventController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"events.png"] tag:3];
    eventController.title = @"Events";
    
    Timetable *timeTableController = [[[Timetable alloc] init] autorelease];
    UINavigationController *timeTableNavigator = [[[UINavigationController alloc] initWithRootViewController:timeTableController] autorelease];
    timeTableNavigator.navigationBar.tintColor = kNavBarColor;
    timeTableController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:[UIImage imageNamed:@"timetable.png"] tag:4];
    timeTableController.title = @"Calendar";
	 
	TimetableNew *timeTableControllerNew = [[[TimetableNew alloc] init] autorelease];
	UINavigationController *timeTableNavigatorNew = [[[UINavigationController alloc] initWithRootViewController:timeTableControllerNew] autorelease];
	timeTableNavigatorNew.navigationBar.tintColor = kNavBarColor;
	timeTableControllerNew.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:[UIImage imageNamed:@"timetable.png"] tag:4];
	timeTableControllerNew.title = @"Calendar";
    
    Map *mapController = [[[Map alloc] init] autorelease];
    UINavigationController *mapNavigator = [[[UINavigationController alloc] initWithRootViewController:mapController] autorelease];
    mapNavigator.navigationBar.tintColor = kNavBarColor;
    mapController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"map.png"] tag:5];
    mapController.title = @"Map";
    
    CAPCalculator *capController = [[[CAPCalculator alloc] init] autorelease];
    UINavigationController *capNavigator = [[[UINavigationController alloc] initWithRootViewController:capController] autorelease];
    capNavigator.navigationBar.tintColor = kNavBarColor;
    capController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cap Calculator" image:[UIImage imageNamed:@"calculator.png"] tag:6];
    capController.title = @"CAP System";
    
    NSArray *arrayOfViewControllers = [NSArray arrayWithObjects:IVLEHomeNavigator, workbinNavigator, eventsNavigator, timeTableNavigatorNew, mapNavigator, capNavigator, nil];
    
    [self.tabBarController setViewControllers:arrayOfViewControllers];
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    
//    [window makeKeyAndVisible];
	return YES;
}

- (void)restartApplication{
	[viewController.view removeFromSuperview];
	[viewController release];
	
	viewController = [[SplashViewController alloc] init];
	
    // Override point for customization after app launch    
    [window addSubview:[viewController view]];
	
    [window makeKeyAndVisible];
}

-(void) switchToTab:(int)index {
    [self.tabBarController setSelectedIndex:(index-1) ];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
    
	[viewController release];
	
    [window release];
    [super dealloc];
}


@end

