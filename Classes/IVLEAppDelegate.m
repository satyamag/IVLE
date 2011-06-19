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



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
    [window addSubview:[viewController view]];
	
    [window makeKeyAndVisible];
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

