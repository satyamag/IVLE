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

#define CoreDataSJNo
#define CoreDataWriteNo
@interface IVLEAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	
	SplashViewController *viewController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
	
- (void)restartApplication;

@end

