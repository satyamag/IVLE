//
//  IVLETabBarController.m
//  IVLE
//
//  Created by satyam agarwala on 7/17/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "IVLETabBarController.h"


@implementation IVLETabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        IVLEMain *home = [[IVLEMain alloc] init];
        UINavigationController *IVLEHomeNavigator = [[UINavigationController alloc] initWithRootViewController:home];
        IVLEHomeNavigator.navigationBar.tintColor = kNavBarColor;
        home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
        home.title = @"Home";
        
        Workbin *workbinController = [[Workbin alloc] init];
        UINavigationController *workbinNavigator = [[UINavigationController alloc] initWithRootViewController:workbinController];
        workbinNavigator.navigationBar.tintColor = kNavBarColor;
        workbinController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Modules" image:[UIImage imageNamed:@"modules.png"] tag:2];
        workbinController.title = @"Modules";
        
        Events *eventController = [[Events alloc] init];
        UINavigationController *eventsNavigator = [[UINavigationController alloc] initWithRootViewController:eventController];
        eventsNavigator.navigationBar.tintColor = kNavBarColor;
        eventController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"events.png"] tag:3];
        eventController.title = @"Events";
        
        TimetableNew *timeTableControllerNew = [[TimetableNew alloc] init];
        UINavigationController *timeTableNavigatorNew = [[UINavigationController alloc] initWithRootViewController:timeTableControllerNew];
        timeTableNavigatorNew.navigationBar.tintColor = kNavBarColor;
        timeTableControllerNew.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:[UIImage imageNamed:@"timetable.png"] tag:4];
        timeTableControllerNew.title = @"Calendar";
        
        Map *mapController = [[Map alloc] init];
        UINavigationController *mapNavigator = [[UINavigationController alloc] initWithRootViewController:mapController];
        mapNavigator.navigationBar.tintColor = kNavBarColor;
        mapController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"map.png"] tag:5];
        mapController.title = @"Map";
        
        //    CAPCalculator *capController = [[[CAPCalculator alloc] init] autorelease];
        //    UINavigationController *capNavigator = [[[UINavigationController alloc] initWithRootViewController:capController] autorelease];
        //    capNavigator.navigationBar.tintColor = kNavBarColor;
        //    capController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cap Calculator" image:[UIImage imageNamed:@"calculator.png"] tag:6];
        //    capController.title = @"CAP System";
        
        [self setViewControllers:[NSArray arrayWithObjects:IVLEHomeNavigator, workbinNavigator, eventsNavigator, timeTableNavigatorNew, mapNavigator, nil]];
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (self.selectedViewController.tabBarItem.tag == 2) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    } 
    else {
        return YES;
    }
}



@end
