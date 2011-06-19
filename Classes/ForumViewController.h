//
//  ForumViewController.h
//  IVLE
//
//  Created by QIN HUAJUN on 3/28/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumTableViewController.h"

@interface ForumViewController : UIViewController <ForumTableViewControllerDelegate> {
	
	IBOutlet UIView *tv;
	IBOutlet UIWebView *display;
	
	UINavigationController *forumTableNavController;

} 

@property (nonatomic, retain) IBOutlet UIView *tv;
@property (nonatomic, retain) IBOutlet UIWebView *display;
@property (nonatomic, retain) UINavigationController *forumTableNavController;

@end
