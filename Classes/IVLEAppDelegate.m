//
//  IVLEAppDelegate.m
//  IVLE
//
//  Created by LEE SING JIE on 3/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IVLEAppDelegate.h"
#import "IVLETabBarController.h"

@implementation IVLEAppDelegate

@synthesize window;

@synthesize tabBarController=_tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashOver) name:kNotificationSplashOver object:nil];
    splashViewController = [[SplashViewController alloc] init];
    [self.window addSubview:splashViewController.view];    
    
    [self.window makeKeyAndVisible];
    
	return YES;
}

-(void) splashOver {
    [splashViewController.view removeFromSuperview];
    tabBarController = [[IVLETabBarController alloc] initWithNibName:nil bundle:nil];
    [self.window addSubview:tabBarController.view];
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
    
	[splashViewController release];
	
    [window release];
    [super dealloc];
}


@end

