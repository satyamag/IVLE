//
//  IVLEAppDelegate.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "IVLEMain.h"
#import "SplashViewController.h"
#import "Constants.h"
#import "Events.h"
#import "Workbin.h"
#import "Map.h"
#import "TimetableNew.h"

@class IVLETabBarController;

#import "Constants.h"

#define CoreDataSJNo
#define CoreDataWriteNo
@interface IVLEAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	IVLETabBarController *tabBarController;
	SplashViewController *splashViewController;

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
	
-(void) splashOver;
-(void) switchToTab:(int)index;


@end

